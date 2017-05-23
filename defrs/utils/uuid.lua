--- Generates UUIDs in version 4 format (randomly) only right now
-- random seed is set once on module init
require('socket')

M = {}

function M.randomseed(seed)
  local bitsize = 32
  local lua_version = tonumber(_VERSION:match("%d%.*%d*"))
  seed = math.floor(math.abs(seed))
  if seed >= (2^bitsize) then
    -- avoid overflow causing 1 or 0 as seed = repeated seeds
    seed = seed - math.floor(seed / 2^bitsize) * (2^bitsize)
  end
  if lua_version < 5.2 then
    -- 5.1 (incorrect) signed int
    math.randomseed(seed - 2^(bitsize-1))
  else
    -- 5.2 (correct) unsigned int
    math.randomseed(seed)
  end
  return seed
end

function M.set_random_seed()
  M.randomseed(socket.gettime()*10000)
end

function M.generate_UUID_version_4()
  local UUID_template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(UUID_template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      local UUID, _ = string.format('%x', v)
      return UUID
  end)
end

M.set_random_seed()
M.dummy_UUID = M.generate_UUID_version_4() -- dump first random value


--print(M.generate_UUID_version_4())
--UUID, _ = M.generate_UUID_version_4()
--print(UUID)

return M
