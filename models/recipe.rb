class Recipe

  attr_reader :id, :name, :description, :instructions, :ingredients

  def initialize (recipe_id, name, description, instructions)
    @id = recipe_id
    @name = name
    @description = description
    @instructions = instructions
    @ingredients = []
  end
  def self.db_connection
    begin
      connection = PG.connect(dbname: "recipes")
      yield(connection)
    ensure
      connection.close
    end
  end

  def self.all
    recipe_list = []
    sql = "SELECT * FROM recipes"
    recipes = db_connection do |conn|
      conn.exec(sql)
    end
    recipes.each do |recipe|
      recipe_list << Recipe.new(recipe["id"], recipe["name"], recipe["description"], recipe["instructions"])
    end
    recipe_list
  end

  def ingredients
    []
  end

  def self.find(id)
    sql = "SELECT * FROM recipes WHERE recipes.id = $1"
    recipe = db_connection do |conn|
      conn.exec_params(sql, [id.to_i]).first
    end
    if recipe == nil
      Recipe.new(403, "name", "This recipe doesn't have a description.", "This recipe doesn't have any instructions.")
    else
      Recipe.new(recipe["id"], recipe["name"], recipe["description"], recipe["instructions"])
    end
  end


end
