From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/5] block: Make blkdev_issue_zeroout use WRITE SAME
Date: Mon, 30 Jan 2012 19:31:29 -0500
Message-ID: <1327969892-5090-3-git-send-email-martin.petersen@oracle.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48056 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2AaAbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 19:31:52 -0500
In-Reply-To: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

If the device supports WRITE SAME, use that to optimize zeroing of
blocks. If the device does not support WRITE SAME or if the operation
fails, fall back to writing zeroes the old-fashioned way.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 19f4754..458ffff 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -204,7 +204,7 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  *  Generate and issue number of bios with zerofiled pages.
  */
 
-int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
@@ -254,4 +254,34 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
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
+					     empty_zero_page,
+					     bdev_logical_block_size(bdev)))
+			return 0;
+
+		bdevname(bdev, bdn);
+		printk(KERN_ERR "%s: WRITE SAME failed. Manually zeroing.\n",
+		       bdn);
+	}
+
+	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
+}
 EXPORT_SYMBOL(blkdev_issue_zeroout);
-- 
1.7.8.3.21.gab8a7

