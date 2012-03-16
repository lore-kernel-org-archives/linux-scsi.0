From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/7] block: Make blkdev_issue_zeroout use WRITE SAME
Date: Fri, 16 Mar 2012 14:43:15 -0400
Message-ID: <1331923399-30987-4-git-send-email-martin.petersen@oracle.com>
References: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46077 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2CPSne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 14:43:34 -0400
In-Reply-To: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

If the device supports WRITE SAME, use that to optimize zeroing of
blocks. If the device does not support WRITE SAME or if the operation
fails, fall back to writing zeroes the old-fashioned way.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c        |   31 ++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    3 +--
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e6cb5b4..5a8d026 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  *  Generate and issue number of bios with zerofiled pages.
  */
 
-int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
@@ -249,4 +249,33 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
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
+		printk(KERN_ERR "%s: WRITE SAME failed. Manually zeroing.\n",
+		       bdn);
+	}
+
+	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
+}
 EXPORT_SYMBOL(blkdev_issue_zeroout);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8c97ee9..92956b7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -959,8 +959,7 @@ extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, void *buffer,
-		unsigned int length);
+		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
-- 
1.7.7.6

