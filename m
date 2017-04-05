From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/27] block: add a REQ_NOUNMAP flag for REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 16:21:49 +0200
Message-ID: <20170405142205.6477-12-hch@lst.de>
References: <20170405142205.6477-1-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170405142205.6477-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If this flag is set logical provisioning capable device should
release space for the zeroed blocks if possible, if it is not set
devices should keep the blocks anchored.

Also remove an out of sync kerneldoc comment for a static function
that would have become even more out of data with this change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-lib.c           | 19 +++++--------------
 include/linux/blk_types.h |  6 ++++++
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index f9f24ec69c27..2f6d2cb2e1a2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -226,20 +226,9 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
 
-/**
- * __blkdev_issue_write_zeroes - generate number of bios with WRITE ZEROES
- * @bdev:	blockdev to issue
- * @sector:	start sector
- * @nr_sects:	number of sectors to write
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @biop:	pointer to anchor bio
- *
- * Description:
- *  Generate and issue number of bios(REQ_OP_WRITE_ZEROES) with zerofiled pages.
- */
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
-		struct bio **biop)
+		struct bio **biop, unsigned flags)
 {
 	struct bio *bio = *biop;
 	unsigned int max_write_zeroes_sectors;
@@ -258,7 +247,9 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		bio = next_bio(bio, 0, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev = bdev;
-		bio_set_op_attrs(bio, REQ_OP_WRITE_ZEROES, 0);
+		bio->bi_opf = REQ_OP_WRITE_ZEROES;
+		if (flags & BLKDEV_ZERO_NOUNMAP)
+			bio->bi_opf |= REQ_NOUNMAP;
 
 		if (nr_sects > max_write_zeroes_sectors) {
 			bio->bi_iter.bi_size = max_write_zeroes_sectors << 9;
@@ -306,7 +297,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		return -EINVAL;
 
 	ret = __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp_mask,
-			biop);
+			biop, flags);
 	if (ret == 0 || (ret && ret != -EOPNOTSUPP))
 		goto out;
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4eae30bfbfca..8eaa7dca7057 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -195,6 +195,10 @@ enum req_flag_bits {
 	__REQ_PREFLUSH,		/* request for cache flush */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
 	__REQ_BACKGROUND,	/* background IO */
+
+	/* command specific flags for REQ_OP_WRITE_ZEROES: */
+	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
+
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -212,6 +216,8 @@ enum req_flag_bits {
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 
+#define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
+
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 
-- 
2.11.0

