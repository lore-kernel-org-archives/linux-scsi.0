From: taco <tacoee@gmail.com>
Subject: [PATCH] block: Needn't read the size of device or partition again
Date: Sun, 11 Dec 2011 21:10:47 +0800
Message-ID: <1323609047-12242-1-git-send-email-tacoee@gmail.com>
References: <yes>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63641 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1LKNM4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2011 08:12:56 -0500
In-Reply-To: <yes>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: taco <tacoee@gmail.com>, linux-scsi@vger.kernel.org

It is not necessary to invoke i_size_read to get the size of device or
partition again, due to did it before.i_size_read maybe need to abtain
lock or disable preempt.

Signed-off-by: taco <tacoee@gmail.com>
---
 block/blk-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ea70e6c..3aa3fc3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1423,7 +1423,7 @@ static inline void blk_partition_remap(struct bio *bio)
 	}
 }
 
-static void handle_bad_sector(struct bio *bio)
+static void handle_bad_sector(struct bio *bio, sector_t maxsector)
 {
 	char b[BDEVNAME_SIZE];
 
@@ -1432,7 +1432,7 @@ static void handle_bad_sector(struct bio *bio)
 			bdevname(bio->bi_bdev, b),
 			bio->bi_rw,
 			(unsigned long long)bio->bi_sector + bio_sectors(bio),
-			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
+			(long long)maxsector);
 
 	set_bit(BIO_EOF, &bio->bi_flags);
 }
@@ -1493,7 +1493,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
 			 * without checking the size of the device, e.g., when
 			 * mounting a device.
 			 */
-			handle_bad_sector(bio);
+			handle_bad_sector(bio, maxsector);
 			return 1;
 		}
 	}
-- 
1.7.5.4

