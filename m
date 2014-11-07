From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard() function
Date: Fri,  7 Nov 2014 00:08:14 -0500
Message-ID: <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKGFIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 00:08:34 -0500
In-Reply-To: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

blkdev_issue_discard() will zero a given block range on disk. This is
done by way of either WRITE SAME or regular WRITE. I.e. the blocks on
disk will be written and thus provisioned.

There are use cases where the desired behavior is to zero the blocks but
unprovision them if possible. The blocks must deterministically contain
zeroes when they are subsequently read back.

This patch introduces a blkdev_issue_zeroout_discard() call that
provides this functionality. If a block device guarantees
discard_zeroes_data the new function will use discard to clear the block
range. If the device does not support discard_zeroes_data or if the
discard request fails we will fall back to blkdev_issue_zeroout() to
ensure predictable results.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c        | 44 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |  2 ++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8411be3c19d3..2ffec6a01c71 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -278,14 +278,18 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 }
 
 /**
- * blkdev_issue_zeroout - zero-fill a block range
+ * blkdev_issue_zeroout - zero-fill and provision a block range
  * @bdev:	blockdev to write
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
  * @gfp_mask:	memory allocation flags (for bio_alloc)
  *
  * Description:
- *  Generate and issue number of bios with zerofiled pages.
+ *  Zero-fill a block range. The blocks will be provisioned
+ *  (allocated/anchored) and are guaranteed to return zeroes when read
+ *  back. This function will attempt to use WRITE SAME to optimize the
+ *  process if the block device supports it. Otherwise it will fall back
+ *  to zeroing the blocks using regular WRITE calls.
  */
 
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
@@ -305,3 +309,39 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+/**
+ * blkdev_issue_zeroout_discard - zero-fill and attempt to discard block range
+ * @bdev:	blockdev to write
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Zero-fill a block range. In contrast to blkdev_issue_zeroout() this
+ *  function will attempt to deprovision (deallocate/discard) the blocks
+ *  in question. It will only do so if the underlying device guarantees
+ *  that subsequent READ operations to the block range in question will
+ *  return zeroes. If the device does not provide hard guarantees or if
+ *  the DISCARD attempt should fail the block range will be explicitly
+ *  zeroed using blkdev_issue_zeroout().
+ */
+
+int blkdev_issue_zeroout_discard(struct block_device *bdev, sector_t sector,
+				 sector_t nr_sects, gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (blk_queue_discard(q) && q->limits.discard_zeroes_data) {
+		unsigned char bdn[BDEVNAME_SIZE];
+
+		if (!blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, 0))
+			return 0;
+
+		bdevname(bdev, bdn);
+		pr_err("%s: DISCARD failed. Manually zeroing.\n", bdn);
+	}
+
+	return blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
+}
+EXPORT_SYMBOL(blkdev_issue_zeroout_discard);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aac0f9ea952a..078b6e5f488a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1164,6 +1164,8 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask);
+extern int blkdev_issue_zeroout_discard(struct block_device *bdev,
+			sector_t sector, sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
-- 
1.9.3

