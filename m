From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/23] block: add a flags argument to (__)blkdev_issue_zeroout
Date: Thu, 23 Mar 2017 10:33:26 -0400
Message-ID: <20170323143341.31549-9-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Turn the existin discard flag into a new BLKDEV_ZERO_UNMAP flag with
similar semantics, but without referring to diѕcard.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c              | 31 ++++++++++++++-----------------
 block/ioctl.c                |  3 +--
 drivers/nvme/target/io-cmd.c |  2 +-
 fs/block_dev.c               |  2 +-
 fs/dax.c                     |  2 +-
 fs/xfs/xfs_bmap_util.c       |  2 +-
 include/linux/blkdev.h       | 14 +++++++++-----
 7 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a93115ccf461..1e849f904d4c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -282,14 +282,18 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
  * @nr_sects:	number of sectors to write
  * @gfp_mask:	memory allocation flags (for bio_alloc)
  * @biop:	pointer to anchor bio
- * @discard:	discard flag
+ * @flags:	controls detailed behavior
  *
  * Description:
- *  Generate and issue number of bios with zerofiled pages.
+ *  Zero-fill a block range, either using hardware offload or by explicitly
+ *  writing zeroes to the device.
+ *
+ *  If a device is using logical block provisioning, the underlying space will
+ *  only be release if %flags contains BLKDEV_ZERO_UNMAP.
  */
 int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
-		bool discard)
+		unsigned flags)
 {
 	int ret;
 	int bi_size = 0;
@@ -337,28 +341,21 @@ EXPORT_SYMBOL(__blkdev_issue_zeroout);
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
  * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @discard:	whether to discard the block range
+ * @flags:	controls detailed behavior
  *
  * Description:
- *  Zero-fill a block range.  If the discard flag is set and the block
- *  device guarantees that subsequent READ operations to the block range
- *  in question will return zeroes, the blocks will be discarded. Should
- *  the discard request fail, if the discard flag is not set, or if
- *  discard_zeroes_data is not supported, this function will resort to
- *  zeroing the blocks manually, thus provisioning (allocating,
- *  anchoring) them. If the block device supports WRITE ZEROES or WRITE SAME
- *  command(s), blkdev_issue_zeroout() will use it to optimize the process of
- *  clearing the block range. Otherwise the zeroing will be performed
- *  using regular WRITE calls.
+ *  Zero-fill a block range, either using hardware offload or by explicitly
+ *  writing zeroes to the device.  See __blkdev_issue_zeroout() for the
+ *  valid values for %flags.
  */
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			 sector_t nr_sects, gfp_t gfp_mask, bool discard)
+		sector_t nr_sects, gfp_t gfp_mask, unsigned flags)
 {
 	int ret;
 	struct bio *bio = NULL;
 	struct blk_plug plug;
 
-	if (discard) {
+	if (flags & BLKDEV_ZERO_UNMAP) {
 		if (!blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask,
 				BLKDEV_DISCARD_ZERO))
 			return 0;
@@ -366,7 +363,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
 	blk_start_plug(&plug);
 	ret = __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
-			&bio, discard);
+			&bio, flags);
 	if (ret == 0 && bio) {
 		ret = submit_bio_wait(bio);
 		bio_put(bio);
diff --git a/block/ioctl.c b/block/ioctl.c
index 7b88820b93d9..304685022d9f 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -254,8 +254,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 	mapping = bdev->bd_inode->i_mapping;
 	truncate_inode_pages_range(mapping, start, end);
 
-	return blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
-				    false);
+	return blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 4195115c7e54..1366babaee50 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -184,7 +184,7 @@ static void nvmet_execute_write_zeroes(struct nvmet_req *req)
 		(req->ns->blksize_shift - 9)) + 1;
 
 	if (__blkdev_issue_zeroout(req->ns->bdev, sector, nr_sector,
-				GFP_KERNEL, &bio, true))
+				GFP_KERNEL, &bio, BLKDEV_ZERO_UNMAP))
 		status = NVME_SC_INTERNAL | NVME_SC_DNR;
 
 	if (bio) {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00ec4370..6128283b7830 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2110,7 +2110,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	case FALLOC_FL_ZERO_RANGE:
 	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
-					    GFP_KERNEL, false);
+					    GFP_KERNEL, 0);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
 		/* Only punch if the device can do zeroing discard. */
diff --git a/fs/dax.c b/fs/dax.c
index de622d4282a6..7a107355d33f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -982,7 +982,7 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		sector_t start_sector = dax.sector + (offset >> 9);
 
 		return blkdev_issue_zeroout(bdev, start_sector,
-				length >> 9, GFP_NOFS, true);
+				length >> 9, GFP_NOFS, BLKDEV_ZERO_UNMAP);
 	} else {
 		if (dax_map_atomic(bdev, &dax) < 0)
 			return PTR_ERR(dax.addr);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8b75dcea5966..6b87c4296787 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -81,7 +81,7 @@ xfs_zero_extent(
 	return blkdev_issue_zeroout(xfs_find_bdev_for_inode(VFS_I(ip)),
 		block << (mp->m_super->s_blocksize_bits - 9),
 		count_fsb << (mp->m_super->s_blocksize_bits - 9),
-		GFP_NOFS, true);
+		GFP_NOFS, BLKDEV_ZERO_UNMAP);
 }
 
 int
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3b3bd646f580..19209416225d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1333,23 +1333,27 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 	return bqt->tag_index[tag];
 }
 
+extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
+extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
 #define BLKDEV_DISCARD_ZERO	(1 << 1)	/* must reliably zero data */
 
-extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, int flags,
 		struct bio **biop);
-extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
+
+#define BLKDEV_ZERO_UNMAP	(1 << 0)  /* free unused blocks */
+
 extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
-		bool discard);
+		unsigned flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, bool discard);
+		sector_t nr_sects, gfp_t gfp_mask, unsigned flags);
+
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
-- 
2.11.0

