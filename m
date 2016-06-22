From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] target/iblock: use ilog2 to compute block size
Date: Wed, 22 Jun 2016 14:55:12 +0200
Message-ID: <20160622125534.1267407-1-arnd@arndb.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Enabling CONFIG_UBSAN_SANITIZE_ALL on ARM caused a link error:

drivers/target/built-in.o: In function `iblock_emulate_read_cap_with_block_size.constprop.1':
target_core_iblock.c:(.text+0xc2774): undefined reference to `____ilog2_NaN'
target_core_iblock.c:(.text+0xc27f8): undefined reference to `__aeabi_uldivmod'
target_core_iblock.c:(.text+0xc299c): undefined reference to `__aeabi_uldivmod'

This is caused by gcc not behaving in the expected ways with __builtin_constant_p(),
but it also points to somewhat inefficient code: As we know that the
block size is a power-of-two value, we can turn the expensive 64-bit
division into a simpler variable bit shift.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/target/target_core_iblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 22af12f8b8eb..3ab4e2d1202c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -201,9 +201,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct block_device *bd,
 	struct request_queue *q)
 {
-	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
-					bdev_logical_block_size(bd)) - 1);
 	u32 block_size = bdev_logical_block_size(bd);
+	unsigned int block_shift = ilog2(block_size);
+	unsigned long long blocks_long = (i_size_read(bd->bd_inode) >> block_shift) - 1;
 
 	if (block_size == dev->dev_attrib.block_size)
 		return blocks_long;
-- 
2.9.0
