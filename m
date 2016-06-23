From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/3] partition/efi: use bdev_logical_block_count()
Date: Thu, 23 Jun 2016 15:30:15 +0200
Message-ID: <20160623133016.3781907-2-arnd@arndb.de>
References: <20160623133016.3781907-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160623133016.3781907-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-block@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

Enabling CONFIG_UBSAN_SANITIZE_ALL on ARM caused a link error:

last_lba.part.0':
:(.text+0xc3440): undefined reference to `____ilog2_NaN'
:(.text+0xc3538): undefined reference to `__aeabi_uldivmod'
:(.text+0xc38e8): undefined reference to `__aeabi_uldivmod'

This is caused by gcc not behaving in the expected ways with __builtin_constant_p(),
but it also points to somewhat inefficient code based on a 64-bit
division.

I have introduced a better bdev_logical_block_count() now, so we
can use that here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/partitions/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index bcd86e5cd546..7b1a62073d34 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -149,8 +149,8 @@ static u64 last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return div_u64(bdev->bd_inode->i_size,
-		       bdev_logical_block_size(bdev)) - 1ULL;
+
+	return bdev_logical_block_count(bdev) - 1;
 }
 
 static inline int pmbr_part_valid(gpt_mbr_record *part)
-- 
2.9.0
