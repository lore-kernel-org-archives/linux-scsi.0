From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Mon, 30 Jan 2012 19:31:28 -0500
Message-ID: <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:53200 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2AaAbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 19:31:50 -0500
In-Reply-To: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com, "Martin K. Petersen" <martin.petersen@oracle.com>

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
---
 Documentation/ABI/testing/sysfs-block |   13 +++++
 block/blk-core.c                      |   10 +++-
 block/blk-lib.c                       |   79 +++++++++++++++++++++++++++++++++
 block/blk-settings.c                  |   16 +++++++
 block/blk-sysfs.c                     |   13 +++++
 block/elevator.c                      |    9 +++-
 include/linux/blk_types.h             |    5 ++-
 include/linux/blkdev.h                |   21 ++++++++-
 8 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..e5f4194 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,16 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/queue/max_write_same_bytes
+Date:		January 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Some devices support a write same operation in which a
+		single data block can be written to a range of several
+		contiguous blocks on storage. This can be used to wipe
+		areas on disk or to initialize drives in a RAID
+		configuration. max_write_same_bytes indicates how many
+		bytes can be written in a single write same command. If
+		max_write_same_bytes is 0, write same is not supported
+		by the device.
diff --git a/block/blk-core.c b/block/blk-core.c
index e6c05a9..373ed52 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1592,6 +1592,11 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
+
 	if (blk_throtl_bio(q, bio))
 		return false;	/* throttled, will be resubmitted later */
 
@@ -1743,7 +1748,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_flags & REQ_DISCARD)
+	if ((rq->cmd_flags & REQ_DISCARD) || (rq->cmd_flags & REQ_WRITE_SAME))
 		return 0;
 
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
@@ -2217,7 +2222,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	req->buffer = bio_data(req->bio);
 
 	/* update sector only for requests with clear definition of sector */
-	if (req->cmd_type == REQ_TYPE_FS || (req->cmd_flags & REQ_DISCARD))
+	if (req->cmd_type == REQ_TYPE_FS || (req->cmd_flags & REQ_DISCARD) ||
+	    (req->cmd_flags & REQ_WRITE_SAME))
 		req->__sector += total_bytes >> 9;
 
 	/* mixed attributes always follow the first bio */
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..19f4754 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -115,6 +115,85 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 EXPORT_SYMBOL(blkdev_issue_discard);
 
 /**
+ * blkdev_issue_write_same - queue a write same operation
+ * @bdev:	target blockdev
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @buffer:	pointer to buffer containing data to write
+ * @length:	buffer length. Must be equal to bdev logical block size.
+ *
+ * Description:
+ *    Issue a write same request for the sectors in question.
+ */
+int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
+			    sector_t nr_sects, gfp_t gfp_mask, void *buffer,
+			    unsigned int length)
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
+	BUG_ON(length != bdev_logical_block_size(bdev));
+	BUG_ON(offset_in_page(buffer) + length > PAGE_CACHE_SIZE);
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
+		bio->bi_phys_segments = 1;
+		bio->bi_io_vec->bv_page = virt_to_page(buffer);
+		bio->bi_io_vec->bv_offset = offset_in_page(buffer);
+		bio->bi_io_vec->bv_len = length;
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
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..5680b91 100644
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
@@ -143,6 +144,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
+	lim->max_write_same_sectors = UINT_MAX;
 
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 }
@@ -287,6 +289,18 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
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
@@ -511,6 +525,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+	t->max_write_same_sectors = min(t->max_write_same_sectors,
+					b->max_write_same_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..e0b38d2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -161,6 +161,13 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(queue_discard_zeroes_data(q), page);
 }
 
+static ssize_t queue_max_write_same_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n",
+		(unsigned long long)q->limits.max_write_same_sectors << 9);
+}
+
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -357,6 +364,11 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
 	.show = queue_discard_zeroes_data_show,
 };
 
+static struct queue_sysfs_entry queue_max_write_same_entry = {
+	.attr = {.name = "max_write_same_bytes", .mode = S_IRUGO },
+	.show = queue_max_write_same_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -404,6 +416,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_granularity_entry.attr,
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_max_write_same_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/elevator.c b/block/elevator.c
index 91e18f8..d6f7703 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -82,6 +82,12 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 		return 0;
 
 	/*
+	 * Don't merge write same requests
+	 */
+	if ((bio->bi_rw & REQ_WRITE_SAME) || (rq->bio->bi_rw & REQ_WRITE_SAME))
+		return 0;
+
+	/*
 	 * Don't merge discard requests and secure discard requests
 	 */
 	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
@@ -639,7 +645,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
-		    (rq->cmd_flags & REQ_DISCARD)) {
+		    (rq->cmd_flags & REQ_DISCARD) ||
+		    (rq->cmd_flags & REQ_WRITE_SAME)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..b312ac8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -124,6 +124,7 @@ enum rq_flag_bits {
 	__REQ_PRIO,		/* boost priority in cfq */
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
+	__REQ_WRITE_SAME,	/* write same block many times */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_FUA,		/* forced unit access */
@@ -162,12 +163,14 @@ enum rq_flag_bits {
 #define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+#define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
-	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
+	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
+	 REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6c6a1f0..4e2f049 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -254,6 +254,7 @@ struct queue_limits {
 	unsigned int		io_min;
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
+	unsigned int		max_write_same_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -581,8 +582,9 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (((rq)->cmd_flags & REQ_DISCARD) || \
-	  (rq)->cmd_type == REQ_TYPE_FS))
+	 (((rq)->cmd_flags & REQ_DISCARD || \
+	   (rq)->cmd_flags & REQ_WRITE_SAME ||	\
+	   (rq)->cmd_type == REQ_TYPE_FS)))
 
 /*
  * q->prep_rq_fn return values
@@ -835,6 +837,8 @@ extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
+extern void blk_queue_max_write_same_sectors(struct request_queue *q,
+		unsigned int max_write_same_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
@@ -959,6 +963,9 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask, void *buffer,
+		unsigned int length);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
@@ -1126,6 +1133,16 @@ static inline unsigned int bdev_discard_zeroes_data(struct block_device *bdev)
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
1.7.8.3.21.gab8a7

