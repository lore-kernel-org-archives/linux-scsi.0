From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] block: remove REQ_OP_WRITE_SAME support
Date: Wed, 12 Apr 2017 10:48:07 +0200
Message-ID: <20170412084809.8245-7-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44605 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753648AbdDLIsb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 04:48:31 -0400
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                 |  3 --
 block/blk-core.c            | 11 +-----
 block/blk-lib.c             | 90 ---------------------------------------------
 block/blk-merge.c           | 32 ----------------
 block/blk-settings.c        | 16 --------
 block/blk-sysfs.c           | 12 ------
 include/linux/bio.h         |  3 --
 include/linux/blk_types.h   |  4 +-
 include/linux/blkdev.h      | 26 -------------
 include/trace/events/f2fs.h |  1 -
 kernel/trace/blktrace.c     |  1 -
 11 files changed, 2 insertions(+), 197 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f4d207180266..b310e7ef3fbf 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -684,9 +684,6 @@ static struct bio *__bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
 		break;
-	case REQ_OP_WRITE_SAME:
-		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
-		break;
 	default:
 		__bio_for_each_segment(bv, bio_src, iter, iter_src)
 			bio->bi_io_vec[bio->bi_vcnt++] = bv;
diff --git a/block/blk-core.c b/block/blk-core.c
index 8654aa0cef6d..92336bc8495c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1929,10 +1929,6 @@ generic_make_request_checks(struct bio *bio)
 		if (!blk_queue_secure_erase(q))
 			goto not_supported;
 		break;
-	case REQ_OP_WRITE_SAME:
-		if (!bdev_write_same(bio->bi_bdev))
-			goto not_supported;
-		break;
 	case REQ_OP_ZONE_REPORT:
 	case REQ_OP_ZONE_RESET:
 		if (!bdev_is_zoned(bio->bi_bdev))
@@ -2100,12 +2096,7 @@ blk_qc_t submit_bio(struct bio *bio)
 	 * go through the normal accounting stuff before submission.
 	 */
 	if (bio_has_data(bio)) {
-		unsigned int count;
-
-		if (unlikely(bio_op(bio) == REQ_OP_WRITE_SAME))
-			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
-		else
-			count = bio_sectors(bio);
+		unsigned int count = bio_sectors(bio);
 
 		if (op_is_write(bio_op(bio))) {
 			count_vm_events(PGPGOUT, count);
diff --git a/block/blk-lib.c b/block/blk-lib.c
index e8caecd71688..57c99b9b3b78 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -131,96 +131,6 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
-/**
- * __blkdev_issue_write_same - generate number of bios with same page
- * @bdev:	target blockdev
- * @sector:	start sector
- * @nr_sects:	number of sectors to write
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @page:	page containing data to write
- * @biop:	pointer to anchor bio
- *
- * Description:
- *  Generate and issue number of bios(REQ_OP_WRITE_SAME) with same page.
- */
-static int __blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, struct page *page,
-		struct bio **biop)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int max_write_same_sectors;
-	struct bio *bio = *biop;
-	sector_t bs_mask;
-
-	if (!q)
-		return -ENXIO;
-
-	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
-	if ((sector | nr_sects) & bs_mask)
-		return -EINVAL;
-
-	if (!bdev_write_same(bdev))
-		return -EOPNOTSUPP;
-
-	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
-	max_write_same_sectors = UINT_MAX >> 9;
-
-	while (nr_sects) {
-		bio = next_bio(bio, 1, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_bdev = bdev;
-		bio->bi_vcnt = 1;
-		bio->bi_io_vec->bv_page = page;
-		bio->bi_io_vec->bv_offset = 0;
-		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
-		bio_set_op_attrs(bio, REQ_OP_WRITE_SAME, 0);
-
-		if (nr_sects > max_write_same_sectors) {
-			bio->bi_iter.bi_size = max_write_same_sectors << 9;
-			nr_sects -= max_write_same_sectors;
-			sector += max_write_same_sectors;
-		} else {
-			bio->bi_iter.bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
-		cond_resched();
-	}
-
-	*biop = bio;
-	return 0;
-}
-
-/**
- * blkdev_issue_write_same - queue a write same operation
- * @bdev:	target blockdev
- * @sector:	start sector
- * @nr_sects:	number of sectors to write
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @page:	page containing data
- *
- * Description:
- *    Issue a write same request for the sectors in question.
- */
-int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
-				sector_t nr_sects, gfp_t gfp_mask,
-				struct page *page)
-{
-	struct bio *bio = NULL;
-	struct blk_plug plug;
-	int ret;
-
-	blk_start_plug(&plug);
-	ret = __blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask, page,
-			&bio);
-	if (ret == 0 && bio) {
-		ret = submit_bio_wait(bio);
-		bio_put(bio);
-	}
-	blk_finish_plug(&plug);
-	return ret;
-}
-EXPORT_SYMBOL(blkdev_issue_write_same);
-
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned flags)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3990ae406341..d6c86bfc5722 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -68,22 +68,6 @@ static struct bio *blk_bio_write_zeroes_split(struct request_queue *q,
 	return bio_split(bio, q->limits.max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
-static struct bio *blk_bio_write_same_split(struct request_queue *q,
-					    struct bio *bio,
-					    struct bio_set *bs,
-					    unsigned *nsegs)
-{
-	*nsegs = 1;
-
-	if (!q->limits.max_write_same_sectors)
-		return NULL;
-
-	if (bio_sectors(bio) <= q->limits.max_write_same_sectors)
-		return NULL;
-
-	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
-}
-
 static inline unsigned get_max_io_size(struct request_queue *q,
 				       struct bio *bio)
 {
@@ -216,9 +200,6 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 	case REQ_OP_WRITE_ZEROES:
 		split = blk_bio_write_zeroes_split(q, *bio, bs, &nsegs);
 		break;
-	case REQ_OP_WRITE_SAME:
-		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
-		break;
 	default:
 		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
 		break;
@@ -259,8 +240,6 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
 		return 0;
-	case REQ_OP_WRITE_SAME:
-		return 1;
 	}
 
 	fbio = bio;
@@ -454,8 +433,6 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		nsegs = __blk_bvec_map_sg(q, rq->special_vec, sglist, &sg);
-	else if (rq->bio && bio_op(rq->bio) == REQ_OP_WRITE_SAME)
-		nsegs = __blk_bvec_map_sg(q, bio_iovec(rq->bio), sglist, &sg);
 	else if (rq->bio)
 		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
 
@@ -688,10 +665,6 @@ static struct request *attempt_merge(struct request_queue *q,
 	    || req_no_special_merge(next))
 		return NULL;
 
-	if (req_op(req) == REQ_OP_WRITE_SAME &&
-	    !blk_write_same_mergeable(req->bio, next->bio))
-		return NULL;
-
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -806,11 +779,6 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (blk_integrity_merge_bio(rq->q, rq, bio) == false)
 		return false;
 
-	/* must be using the same buffer */
-	if (req_op(rq) == REQ_OP_WRITE_SAME &&
-	    !blk_write_same_mergeable(rq->bio, bio))
-		return false;
-
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4fa81ed383ca..aea05adfd6b4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -96,7 +96,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->max_dev_sectors = 0;
 	lim->chunk_sectors = 0;
-	lim->max_write_same_sectors = 0;
 	lim->max_write_zeroes_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->max_hw_discard_sectors = 0;
@@ -132,7 +131,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_dev_sectors = UINT_MAX;
-	lim->max_write_same_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
@@ -291,18 +289,6 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
 /**
- * blk_queue_max_write_same_sectors - set max sectors for a single write same
- * @q:  the request queue for the device
- * @max_write_same_sectors: maximum number of sectors to write per command
- **/
-void blk_queue_max_write_same_sectors(struct request_queue *q,
-				      unsigned int max_write_same_sectors)
-{
-	q->limits.max_write_same_sectors = max_write_same_sectors;
-}
-EXPORT_SYMBOL(blk_queue_max_write_same_sectors);
-
-/**
  * blk_queue_max_write_zeroes_sectors - set max sectors for a single
  *                                      write zeroes
  * @q:  the request queue for the device
@@ -557,8 +543,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
-	t->max_write_same_sectors = min(t->max_write_same_sectors,
-					b->max_write_same_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
 					b->max_write_zeroes_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index fc20489f0d2b..2ea4aca4ec1c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -211,12 +211,6 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(0, page);
 }
 
-static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
-{
-	return sprintf(page, "%llu\n",
-		(unsigned long long)q->limits.max_write_same_sectors << 9);
-}
-
 static ssize_t queue_write_zeroes_max_show(struct request_queue *q, char *page)
 {
 	return sprintf(page, "%llu\n",
@@ -603,11 +597,6 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
 	.show = queue_discard_zeroes_data_show,
 };
 
-static struct queue_sysfs_entry queue_write_same_max_entry = {
-	.attr = {.name = "write_same_max_bytes", .mode = S_IRUGO },
-	.show = queue_write_same_max_show,
-};
-
 static struct queue_sysfs_entry queue_write_zeroes_max_entry = {
 	.attr = {.name = "write_zeroes_max_bytes", .mode = S_IRUGO },
 	.show = queue_write_zeroes_max_show,
@@ -705,7 +694,6 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
-	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4931756d86d9..96a20afb8575 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -87,7 +87,6 @@ static inline bool bio_no_advance_iter(struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_SAME ||
 	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
 }
 
@@ -199,8 +198,6 @@ static inline unsigned __bio_segments(struct bio *bio, struct bvec_iter *bvec)
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
 		return 0;
-	case REQ_OP_WRITE_SAME:
-		return 1;
 	default:
 		break;
 	}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 61339bc44400..fc4fc927dcc4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -171,10 +171,8 @@ enum req_opf {
 	REQ_OP_SECURE_ERASE	= 5,
 	/* seset a zone write pointer */
 	REQ_OP_ZONE_RESET	= 6,
-	/* write the same sector many times */
-	REQ_OP_WRITE_SAME	= 7,
 	/* write the zero filled sector many times */
-	REQ_OP_WRITE_ZEROES	= 9,
+	REQ_OP_WRITE_ZEROES	= 7,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ec993573e0a8..1f066f246dd7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -326,7 +326,6 @@ struct queue_limits {
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
 	unsigned int		max_hw_discard_sectors;
-	unsigned int		max_write_same_sectors;
 	unsigned int		max_write_zeroes_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
@@ -806,14 +805,6 @@ static inline bool rq_mergeable(struct request *rq)
 	return true;
 }
 
-static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
-{
-	if (bio_data(a) == bio_data(b))
-		return true;
-
-	return false;
-}
-
 static inline unsigned int blk_queue_depth(struct request_queue *q)
 {
 	if (q->queue_depth)
@@ -1035,9 +1026,6 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
 		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-	if (unlikely(op == REQ_OP_WRITE_SAME))
-		return q->limits.max_write_same_sectors;
-
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
@@ -1157,8 +1145,6 @@ extern void blk_queue_max_discard_segments(struct request_queue *,
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
-extern void blk_queue_max_write_same_sectors(struct request_queue *q,
-		unsigned int max_write_same_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
@@ -1336,8 +1322,6 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
-extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
 
@@ -1539,16 +1523,6 @@ static inline int bdev_discard_alignment(struct block_device *bdev)
 	return q->limits.discard_alignment;
 }
 
-static inline unsigned int bdev_write_same(struct block_device *bdev)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	if (q)
-		return q->limits.max_write_same_sectors;
-
-	return 0;
-}
-
 static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index c80fcad0a6c9..da1b542ef8d6 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -71,7 +71,6 @@ TRACE_DEFINE_ENUM(CP_DISCARD);
 		{ REQ_OP_ZONE_REPORT,		"ZONE_REPORT" },	\
 		{ REQ_OP_SECURE_ERASE,		"SECURE_ERASE" },	\
 		{ REQ_OP_ZONE_RESET,		"ZONE_RESET" },		\
-		{ REQ_OP_WRITE_SAME,		"WRITE_SAME" },		\
 		{ REQ_OP_WRITE_ZEROES,		"WRITE_ZEROES" })
 
 #define show_bio_op_flags(flags)					\
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b2058a7f94bd..99060c96a4bd 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1750,7 +1750,6 @@ void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes)
 
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_WRITE:
-	case REQ_OP_WRITE_SAME:
 		rwbs[i++] = 'W';
 		break;
 	case REQ_OP_DISCARD:
-- 
2.11.0
