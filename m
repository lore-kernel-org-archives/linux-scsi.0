From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] block: use blkdev_issue_discard in blk_ioctl_discard
Date: Sat, 29 Aug 2009 19:03:34 -0400
Message-ID: <20090829231121.385741993@bombadil.infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752809AbZH2XLc@vger.kernel.org>
Content-Disposition: inline; filename=discard-unify-code
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

blk_ioctl_discard duplicates large amounts of code from blkdev_issue_discard,
the only difference between the two is that blkdev_issue_discard needs to
send a barrier discard request and blk_ioctl_discard a non-barrier one,
and blk_ioctl_discard needs to wait on the request.  To facilitates this
add a flags argument to blkdev_issue_discard to control both aspects of the
behaviour.  This will be very useful later on for using the waiting
funcitonality for other callers.

Based on an earlier patch from Matthew Wilcox <matthew@wil.cx>.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-08-29 16:49:43.067370900 -0300
+++ linux-2.6/block/blk-barrier.c	2009-08-29 17:43:30.407344330 -0300
@@ -348,6 +348,9 @@ static void blkdev_discard_end_io(struct
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
 
+	if (bio->bi_private)
+		complete(bio->bi_private);
+
 	bio_put(bio);
 }
 
@@ -357,21 +360,20 @@ static void blkdev_discard_end_io(struct
  * @sector:	start sector
  * @nr_sects:	number of sectors to discard
  * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	DISCARD_FL_* flags to control behaviour
  *
  * Description:
- *    Issue a discard request for the sectors in question. Does not wait.
+ *    Issue a discard request for the sectors in question.
  */
-int blkdev_issue_discard(struct block_device *bdev,
-			 sector_t sector, sector_t nr_sects, gfp_t gfp_mask)
+int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, int flags)
 {
-	struct request_queue *q;
-	struct bio *bio;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	int type = flags & DISCARD_FL_BARRIER ?
+		DISCARD_BARRIER : DISCARD_NOBARRIER;
 	int ret = 0;
 
-	if (bdev->bd_disk == NULL)
-		return -ENXIO;
-
-	q = bdev_get_queue(bdev);
 	if (!q)
 		return -ENXIO;
 
@@ -379,12 +381,14 @@ int blkdev_issue_discard(struct block_de
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		bio = bio_alloc(gfp_mask, 0);
+		struct bio *bio = bio_alloc(gfp_mask, 0);
 		if (!bio)
 			return -ENOMEM;
 
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
+		if (flags & DISCARD_FL_WAIT)
+			bio->bi_private = &wait;
 
 		bio->bi_sector = sector;
 
@@ -396,10 +400,13 @@ int blkdev_issue_discard(struct block_de
 			bio->bi_size = nr_sects << 9;
 			nr_sects = 0;
 		}
+
 		bio_get(bio);
-		submit_bio(DISCARD_BARRIER, bio);
+		submit_bio(type, bio);
+
+		if (flags & DISCARD_FL_WAIT)
+			wait_for_completion(&wait);
 
-		/* Check if it failed immediately */
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
 			ret = -EOPNOTSUPP;
 		else if (!bio_flagged(bio, BIO_UPTODATE))
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c	2009-08-29 16:49:43.075370172 -0300
+++ linux-2.6/block/ioctl.c	2009-08-29 16:49:52.743341374 -0300
@@ -112,22 +112,9 @@ static int blkdev_reread_part(struct blo
 	return res;
 }
 
-static void blk_ioc_discard_endio(struct bio *bio, int err)
-{
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	}
-	complete(bio->bi_private);
-}
-
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			     uint64_t len)
 {
-	struct request_queue *q = bdev_get_queue(bdev);
-	int ret = 0;
-
 	if (start & 511)
 		return -EINVAL;
 	if (len & 511)
@@ -137,40 +124,8 @@ static int blk_ioctl_discard(struct bloc
 
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
-
-	if (!q->prepare_discard_fn)
-		return -EOPNOTSUPP;
-
-	while (len && !ret) {
-		DECLARE_COMPLETION_ONSTACK(wait);
-		struct bio *bio;
-
-		bio = bio_alloc(GFP_KERNEL, 0);
-
-		bio->bi_end_io = blk_ioc_discard_endio;
-		bio->bi_bdev = bdev;
-		bio->bi_private = &wait;
-		bio->bi_sector = start;
-
-		if (len > queue_max_hw_sectors(q)) {
-			bio->bi_size = queue_max_hw_sectors(q) << 9;
-			len -= queue_max_hw_sectors(q);
-			start += queue_max_hw_sectors(q);
-		} else {
-			bio->bi_size = len << 9;
-			len = 0;
-		}
-		submit_bio(DISCARD_NOBARRIER, bio);
-
-		wait_for_completion(&wait);
-
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
-	}
-	return ret;
+	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
+				    DISCARD_FL_WAIT);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
Index: linux-2.6/fs/btrfs/extent-tree.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent-tree.c	2009-08-29 16:49:43.079341766 -0300
+++ linux-2.6/fs/btrfs/extent-tree.c	2009-08-29 16:49:52.743341374 -0300
@@ -1511,7 +1511,8 @@ static int remove_extent_backref(struct 
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
+			     DISCARD_FL_BARRIER);
 }
 #endif
 
Index: linux-2.6/fs/gfs2/rgrp.c
===================================================================
--- linux-2.6.orig/fs/gfs2/rgrp.c	2009-08-29 16:49:43.139342340 -0300
+++ linux-2.6/fs/gfs2/rgrp.c	2009-08-29 16:49:52.747373241 -0300
@@ -857,7 +857,8 @@ static void gfs2_rgrp_send_discards(stru
 					goto start_new_extent;
 				if ((start + nr_sects) != blk) {
 					rv = blkdev_issue_discard(bdev, start,
-							    nr_sects, GFP_NOFS);
+							    nr_sects, GFP_NOFS,
+							    DISCARD_FL_BARRIER);
 					if (rv)
 						goto fail;
 					nr_sects = 0;
@@ -871,7 +872,8 @@ start_new_extent:
 		}
 	}
 	if (nr_sects) {
-		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS);
+		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS,
+					 DISCARD_FL_BARRIER);
 		if (rv)
 			goto fail;
 	}
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-08-29 16:49:43.147343148 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-08-29 17:43:19.767342397 -0300
@@ -977,15 +977,18 @@ static inline struct request *blk_map_qu
 }
 
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
-extern int blkdev_issue_discard(struct block_device *,
-				sector_t sector, sector_t nr_sects, gfp_t);
+#define DISCARD_FL_WAIT		0x01	/* wait for completion */
+#define DISCARD_FL_BARRIER	0x02	/* issue DISCARD_BARRIER request */
+extern int blkdev_issue_discard(struct block_device *, sector_t sector,
+		sector_t nr_sects, gfp_t, int flags);
 
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)
 {
 	block <<= (sb->s_blocksize_bits - 9);
 	nr_blocks <<= (sb->s_blocksize_bits - 9);
-	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL);
+	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
+				    DISCARD_FL_BARRIER);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2009-08-29 16:49:43.151342120 -0300
+++ linux-2.6/mm/swapfile.c	2009-08-29 16:49:52.755377749 -0300
@@ -161,7 +161,8 @@ static int discard_swap(struct swap_info
 		}
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-						nr_blocks, GFP_KERNEL);
+						nr_blocks, GFP_KERNEL,
+						DISCARD_FL_BARRIER);
 		if (err)
 			break;
 
@@ -200,7 +201,8 @@ static void discard_swap_cluster(struct 
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-							nr_blocks, GFP_NOIO))
+							nr_blocks, GFP_NOIO,
+							DISCARD_FL_BARRIER))
 				break;
 		}
 
