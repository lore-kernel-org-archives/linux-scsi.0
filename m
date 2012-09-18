From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/8] block: Implement support for WRITE SAME
Date: Tue, 18 Sep 2012 12:19:27 -0400
Message-ID: <1347985172-2495-4-git-send-email-martin.petersen@oracle.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IRQT7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:19:59 -0400
In-Reply-To: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

The WRITE SAME command supported on some SCSI devices allows the same
block to be efficiently replicated throughout a block range. Only a
single logical block is transferred from the host and the storage device
writes the same data to all blocks described by the I/O.

This patch implements support for WRITE SAME in the block layer. The
blkdev_issue_write_same() function can be used by filesystems and block
drivers to replicate a buffer across a block range. This can be used to
efficiently initialize software RAID devices, etc.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/ABI/testing/sysfs-block |   14 ++++++
 block/blk-core.c                      |   14 +++++-
 block/blk-lib.c                       |   74 +++++++++++++++++++++++++++++++++
 block/blk-merge.c                     |    9 ++++
 block/blk-settings.c                  |   16 +++++++
 block/blk-sysfs.c                     |   13 ++++++
 drivers/md/raid0.c                    |    1 +
 fs/bio.c                              |    9 +++-
 include/linux/bio.h                   |    3 +
 include/linux/blk_types.h             |    5 ++-
 include/linux/blkdev.h                |   29 +++++++++++++
 11 files changed, 181 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..279da08 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,17 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/queue/write_same_max_bytes
+Date:		January 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Some devices support a write same operation in which a
+		single data block can be written to a range of several
+		contiguous blocks on storage. This can be used to wipe
+		areas on disk or to initialize drives in a RAID
+		configuration. write_same_max_bytes indicates how many
+		bytes can be written in a single write same command. If
+		write_same_max_bytes is 0, write same is not supported
+		by the device.
+
diff --git a/block/blk-core.c b/block/blk-core.c
index 33eded0..3b08054 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1704,6 +1704,11 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
+
 	/*
 	 * Various block parts want %current->io_context and lazy ioc
 	 * allocation ends up trading a lot of pain for a small amount of
@@ -1809,8 +1814,6 @@ EXPORT_SYMBOL(generic_make_request);
  */
 void submit_bio(int rw, struct bio *bio)
 {
-	int count = bio_sectors(bio);
-
 	bio->bi_rw |= rw;
 
 	/*
@@ -1818,6 +1821,13 @@ void submit_bio(int rw, struct bio *bio)
 	 * go through the normal accounting stuff before submission.
 	 */
 	if (bio_has_data(bio)) {
+		unsigned int count;
+
+		if (unlikely(rw & REQ_WRITE_SAME))
+			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
+		else
+			count = bio_sectors(bio);
+
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 19cc761..a062543 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -130,6 +130,80 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 EXPORT_SYMBOL(blkdev_issue_discard);
 
 /**
+ * blkdev_issue_write_same - queue a write same operation
+ * @bdev:	target blockdev
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @page:	page containing data to write
+ *
+ * Description:
+ *    Issue a write same request for the sectors in question.
+ */
+int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
+			    sector_t nr_sects, gfp_t gfp_mask,
+			    struct page *page)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned int max_write_same_sectors;
+	struct bio_batch bb;
+	struct bio *bio;
+	int ret = 0;
+
+	if (!q)
+		return -ENXIO;
+
+	max_write_same_sectors = q->limits.max_write_same_sectors;
+
+	if (max_write_same_sectors == 0)
+		return -EOPNOTSUPP;
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	while (nr_sects) {
+		bio = bio_alloc(gfp_mask, 1);
+		if (!bio) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		bio->bi_sector = sector;
+		bio->bi_end_io = bio_batch_end_io;
+		bio->bi_bdev = bdev;
+		bio->bi_private = &bb;
+		bio->bi_vcnt = 1;
+		bio->bi_io_vec->bv_page = page;
+		bio->bi_io_vec->bv_offset = 0;
+		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
+
+		if (nr_sects > max_write_same_sectors) {
+			bio->bi_size = max_write_same_sectors << 9;
+			nr_sects -= max_write_same_sectors;
+			sector += max_write_same_sectors;
+		} else {
+			bio->bi_size = nr_sects << 9;
+			nr_sects = 0;
+		}
+
+		atomic_inc(&bb.done);
+		submit_bio(REQ_WRITE | REQ_WRITE_SAME, bio);
+	}
+
+	/* Wait for bios in-flight */
+	if (!atomic_dec_and_test(&bb.done))
+		wait_for_completion(&wait);
+
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		ret = -ENOTSUPP;
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_write_same);
+
+/**
  * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
  * @sector:	start sector
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 642b862..936a110 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -419,6 +419,10 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || next->special)
 		return 0;
 
+	if (req->cmd_flags & REQ_WRITE_SAME &&
+	    !blk_write_same_mergeable(req->bio, next->bio))
+		return 0;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -518,6 +522,11 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return false;
 
+	/* must be using the same buffer */
+	if (rq->cmd_flags & REQ_WRITE_SAME &&
+	    !blk_write_same_mergeable(rq->bio, bio))
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 565a678..779bb76 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -113,6 +113,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
+	lim->max_write_same_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
@@ -144,6 +145,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
+	lim->max_write_same_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -286,6 +288,18 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
 /**
+ * blk_queue_max_write_same_sectors - set max sectors for a single write same
+ * @q:  the request queue for the device
+ * @max_write_same_sectors: maximum number of sectors to write per command
+ **/
+void blk_queue_max_write_same_sectors(struct request_queue *q,
+				      unsigned int max_write_same_sectors)
+{
+	q->limits.max_write_same_sectors = max_write_same_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_write_same_sectors);
+
+/**
  * blk_queue_max_segments - set max hw segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
@@ -510,6 +524,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+	t->max_write_same_sectors = min(t->max_write_same_sectors,
+					b->max_write_same_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ea51d82..247dbfd 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -180,6 +180,13 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(queue_discard_zeroes_data(q), page);
 }
 
+static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n",
+		(unsigned long long)q->limits.max_write_same_sectors << 9);
+}
+
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -385,6 +392,11 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
 	.show = queue_discard_zeroes_data_show,
 };
 
+static struct queue_sysfs_entry queue_write_same_max_entry = {
+	.attr = {.name = "write_same_max_bytes", .mode = S_IRUGO },
+	.show = queue_write_same_max_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -432,6 +444,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_granularity_entry.attr,
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_write_same_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index de63a1f..a9e4fa9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -422,6 +422,7 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
diff --git a/fs/bio.c b/fs/bio.c
index 13e9567..f855e0e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1487,9 +1487,12 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 
 	bp->bv1 = bi->bi_io_vec[0];
 	bp->bv2 = bi->bi_io_vec[0];
-	bp->bv2.bv_offset += first_sectors << 9;
-	bp->bv2.bv_len -= first_sectors << 9;
-	bp->bv1.bv_len = first_sectors << 9;
+
+	if (bio_is_rw(bi)) {
+		bp->bv2.bv_offset += first_sectors << 9;
+		bp->bv2.bv_len -= first_sectors << 9;
+		bp->bv1.bv_len = first_sectors << 9;
+	}
 
 	bp->bio1.bi_io_vec = &bp->bv1;
 	bp->bio2.bi_io_vec = &bp->bv2;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index e54305c..820e7aa 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -399,6 +399,9 @@ static inline bool bio_is_rw(struct bio *bio)
 	if (!bio_has_data(bio))
 		return false;
 
+	if (bio->bi_rw & REQ_WRITE_SAME)
+		return false;
+
 	return true;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1b22966..cdf1119 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -147,6 +147,7 @@ enum rq_flag_bits {
 	__REQ_PRIO,		/* boost priority in cfq */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+	__REQ_WRITE_SAME,	/* write same block many times */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_FUA,		/* forced unit access */
@@ -185,13 +186,15 @@ enum rq_flag_bits {
 #define REQ_META		(1 << __REQ_META)
 #define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
+#define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
-	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
+	 REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 /* This mask is used for both bio and request merge checking */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90f7abe..1756001 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -270,6 +270,7 @@ struct queue_limits {
 	unsigned int		io_min;
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
+	unsigned int		max_write_same_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -614,9 +615,20 @@ static inline bool blk_check_merge_flags(unsigned int flags1,
 	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
 		return false;
 
+	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
+		return false;
+
 	return true;
 }
 
+static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
+{
+	if (bio_data(a) == bio_data(b))
+		return true;
+
+	return false;
+}
+
 /*
  * q->prep_rq_fn return values
  */
@@ -818,6 +830,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 	if (unlikely(cmd_flags & REQ_DISCARD))
 		return q->limits.max_discard_sectors;
 
+	if (unlikely(cmd_flags & REQ_WRITE_SAME))
+		return q->limits.max_write_same_sectors;
+
 	return q->limits.max_sectors;
 }
 
@@ -886,6 +901,8 @@ extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
+extern void blk_queue_max_write_same_sectors(struct request_queue *q,
+		unsigned int max_write_same_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
@@ -1016,6 +1033,8 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
@@ -1193,6 +1212,16 @@ static inline unsigned int bdev_discard_zeroes_data(struct block_device *bdev)
 	return queue_discard_zeroes_data(bdev_get_queue(bdev));
 }
 
+static inline unsigned int bdev_write_same(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return q->limits.max_write_same_sectors;
+
+	return 0;
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
1.7.7.6

