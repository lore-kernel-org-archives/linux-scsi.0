From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 3/3] target/iblock: use bdev_logical_block_count()
Date: Thu, 23 Jun 2016 15:30:16 +0200
Message-ID: <20160623133016.3781907-3-arnd@arndb.de>
References: <20160623133016.3781907-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160623133016.3781907-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-block@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

Enabling CONFIG_UBSAN_SANITIZE_ALL on ARM caused a link error:

drivers/target/built-in.o: In function `iblock_emulate_read_cap_with_block_size.constprop.1':
target_core_iblock.c:(.text+0xc2774): undefined reference to `____ilog2_NaN'
target_core_iblock.c:(.text+0xc27f8): undefined reference to `__aeabi_uldivmod'
target_core_iblock.c:(.text+0xc299c): undefined reference to `__aeabi_uldivmod'

This is caused by gcc not behaving in the expected ways with __builtin_constant_p(),
but it also points to somewhat inefficient code based on an expensive 64-bit
division.

I have introduced a better bdev_logical_block_count() now, so we can use that here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/target/target_core_iblock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 22af12f8b8eb..2dc0129553e1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -201,9 +201,8 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	struct block_device *bd,
 	struct request_queue *q)
 {
-	unsigned long long blocks_long = (div_u64(i_size_read(bd->bd_inode),
-					bdev_logical_block_size(bd)) - 1);
 	u32 block_size = bdev_logical_block_size(bd);
+	unsigned long long blocks_long = bdev_logical_block_count(bd) - 1;
 
 	if (block_size == dev->dev_attrib.block_size)
 		return blocks_long;
-- 
2.9.0
