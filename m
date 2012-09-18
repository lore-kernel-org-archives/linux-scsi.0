From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/8] block: Make blkdev_issue_zeroout use WRITE SAME
Date: Tue, 18 Sep 2012 12:19:28 -0400
Message-ID: <1347985172-2495-5-git-send-email-martin.petersen@oracle.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24399 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IRQTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:19:53 -0400
In-Reply-To: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

If the device supports WRITE SAME, use that to optimize zeroing of
blocks. If the device does not support WRITE SAME or if the operation
fails, fall back to writing zeroes the old-fashioned way.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a062543..9373b58 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -214,7 +214,7 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  *  Generate and issue number of bios with zerofiled pages.
  */
 
-int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
@@ -264,4 +264,32 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
 	return ret;
 }
+
+/**
+ * blkdev_issue_zeroout - zero-fill a block range
+ * @bdev:	blockdev to write
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Generate and issue number of bios with zerofiled pages.
+ */
+
+int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+			 sector_t nr_sects, gfp_t gfp_mask)
+{
+	if (bdev_write_same(bdev)) {
+		unsigned char bdn[BDEVNAME_SIZE];
+
+		if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
+					     ZERO_PAGE(0)))
+			return 0;
+
+		bdevname(bdev, bdn);
+		pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
+	}
+
+	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
+}
 EXPORT_SYMBOL(blkdev_issue_zeroout);
-- 
1.7.7.6

