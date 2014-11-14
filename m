From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard() function
Date: Fri, 14 Nov 2014 15:22:05 -0500
Message-ID: <yq1ioihv8gi.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
	<20141107082610.GC8394@infradead.org>
	<yq1k3379fvj.fsf@sermon.lab.mkp.net> <20141107162025.GA607@thunk.org>
	<yq17fz79ds4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq17fz79ds4.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 07 Nov 2014 11:27:39 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> What would you prefer as the default for the ext4 use case? To
Martin> allocate or to discard?

I didn't get a preference for whether sb_issue_zeroout() should discard
or allocate.

But here's an updated patch 3...

commit eb23c9e71e08b7f467cbc36990a1a01a94a7b959
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Thu Nov 6 14:36:05 2014 -0500

    block: Add discard flag to blkdev_issue_zeroout() function
    
    blkdev_issue_discard() will zero a given block range. This is done by
    way of explicit writing, thus provisioning or allocating the blocks on
    disk.
    
    There are use cases where the desired behavior is to zero the blocks but
    unprovision them if possible. The blocks must deterministically contain
    zeroes when they are subsequently read back.
    
    This patch adds a flag to blkdev_issue_zeroout() that provides this
    variant. If the discard flag is set and a block device guarantees
    discard_zeroes_data we will use REQ_DISCARD to clear the block range. If
    the device does not support discard_zeroes_data or if the discard
    request fails we will fall back to first REQ_WRITE_SAME and then a
    regular REQ_WRITE.
    
    Also update the callers of blkdev_issue_zero() to reflect the new flag
    and make sb_issue_zeroout() prefer the discard approach.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8411be3c19d3..715e948f58a4 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -283,23 +283,45 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
  * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @discard:	whether to discard the block range
  *
  * Description:
- *  Generate and issue number of bios with zerofiled pages.
+
+ *  Zero-fill a block range.  If the discard flag is set and the block
+ *  device guarantees that subsequent READ operations to the block range
+ *  in question will return zeroes, the blocks will be discarded. Should
+ *  the discard request fail, if the discard flag is not set, or if
+ *  discard_zeroes_data is not supported, this function will resort to
+ *  zeroing the blocks manually, thus provisioning (allocating,
+ *  anchoring) them. If the block device supports the WRITE SAME command
+ *  blkdev_issue_zeroout() will use it to optimize the process of
+ *  clearing the block range. Otherwise the zeroing will be performed
+ *  using regular WRITE calls.
  */
 
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			 sector_t nr_sects, gfp_t gfp_mask)
+			 sector_t nr_sects, gfp_t gfp_mask, bool discard)
 {
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned char bdn[BDEVNAME_SIZE];
+
+	if (discard && blk_queue_discard(q) && q->limits.discard_zeroes_data) {
+
+		if (!blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, 0))
+			return 0;
+
+		bdevname(bdev, bdn);
+		pr_warn("%s: DISCARD failed. Manually zeroing.\n", bdn);
+	}
+
 	if (bdev_write_same(bdev)) {
-		unsigned char bdn[BDEVNAME_SIZE];
 
 		if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
 					     ZERO_PAGE(0)))
 			return 0;
 
 		bdevname(bdev, bdn);
-		pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
+		pr_warn("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
 	}
 
 	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
diff --git a/block/ioctl.c b/block/ioctl.c
index 6c7bf903742f..7d8befde2aca 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -198,7 +198,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
 	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
 		return -EINVAL;
 
-	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL);
+	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6960fb064731..ee5b9611c51c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1388,7 +1388,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		list_add_tail(&peer_req->w.list, &device->active_ee);
 		spin_unlock_irq(&device->resource->req_lock);
 		if (blkdev_issue_zeroout(device->ldev->backing_bdev,
-			sector, data_size >> 9, GFP_NOIO))
+			sector, data_size >> 9, GFP_NOIO, false))
 			peer_req->flags |= EE_WAS_ERROR;
 		drbd_endio_write_sec_final(peer_req);
 		return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aac0f9ea952a..f3ad69d8de45 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1163,7 +1163,7 @@ extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			sector_t nr_sects, gfp_t gfp_mask);
+		sector_t nr_sects, gfp_t gfp_mask, bool discard);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
@@ -1177,7 +1177,7 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 	return blkdev_issue_zeroout(sb->s_bdev,
 				    block << (sb->s_blocksize_bits - 9),
 				    nr_blocks << (sb->s_blocksize_bits - 9),
-				    gfp_mask);
+				    gfp_mask, true);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
