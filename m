From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/6] block: Implement support for copy offload operations
Date: Wed, 28 May 2014 23:52:41 -0400
Message-ID: <1401335565-29865-3-git-send-email-martin.petersen@oracle.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbaE2Dwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:52:46 -0400
In-Reply-To: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Many modern SCSI devices support copy offloading operations in which one
can copy a block range from one LUN to another without the need for data
to be copied sent to the host and back. This is particularly useful for
things like cloning LUNs or virtual machine images.

Implement support for REQ_COPY commands in the block layer:

 - Add max_copy_sectors queue limits and handle stacking

 - Expose this parameter in sysfs in bytes (copy_max_bytes)

 - Add special casing for REQ_COPY in merging and mapping functions

 - Introduce a bio_copy descriptor hanging off of bio->bi_special. This
   descriptor contains the source bdev and source sector for the copy
   operation. Target bdev/sector/size are described by the bio proper.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 Documentation/ABI/testing/sysfs-block |  9 +++++++++
 block/blk-core.c                      |  5 +++++
 block/blk-merge.c                     |  7 ++-----
 block/blk-settings.c                  | 15 +++++++++++++++
 block/blk-sysfs.c                     | 10 ++++++++++
 include/linux/bio.h                   | 15 +++++++++++++--
 include/linux/blk_types.h             | 15 ++++++++++++---
 include/linux/blkdev.h                | 13 +++++++++++++
 8 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 279da08f7541..d1304cc305f7 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -220,3 +220,12 @@ Description:
 		write_same_max_bytes is 0, write same is not supported
 		by the device.
 
+
+What:		/sys/block/<disk>/queue/copy_max_bytes
+Date:		January 2014
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Devices that support copy offloading will set this value
+		to indicate the maximum buffer size in bytes that can be
+		copied in one operation. If the copy_max_bytes is 0 the
+		device does not support copy offload.
diff --git a/block/blk-core.c b/block/blk-core.c
index 5b6f768a7c01..3a91044ee19b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1810,6 +1810,11 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio->bi_rw & REQ_COPY && !bdev_copy_offload(bio->bi_bdev)) {
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
+
 	/*
 	 * Various block parts want %current->io_context and lazy ioc
 	 * allocation ends up trading a lot of pain for a small amount of
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6c583f9c5b65..0e1027e2e32b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -25,10 +25,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	 * This should probably be returning 0, but blk_add_request_payload()
 	 * (Christoph!!!!)
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
-		return 1;
-
-	if (bio->bi_rw & REQ_WRITE_SAME)
+	if (bio->bi_rw & (REQ_DISCARD | REQ_WRITE_SAME | REQ_COPY))
 		return 1;
 
 	fbio = bio;
@@ -182,7 +179,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio->bi_rw & (REQ_DISCARD | REQ_COPY)) {
 		/*
 		 * This is a hack - drivers should be neither modifying the
 		 * biovec, nor relying on bi_vcnt - but because of
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5d21239bc859..98801bcc02b0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -114,6 +114,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->max_write_same_sectors = 0;
+	lim->max_copy_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
@@ -147,6 +148,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
+	lim->max_copy_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -301,6 +303,18 @@ void blk_queue_max_write_same_sectors(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_write_same_sectors);
 
 /**
+ * blk_queue_max_copy_sectors - set max sectors for a single copy operation
+ * @q:  the request queue for the device
+ * @max_copy_sectors: maximum number of sectors per copy operation
+ **/
+void blk_queue_max_copy_sectors(struct request_queue *q,
+				unsigned int max_copy_sectors)
+{
+	q->limits.max_copy_sectors = max_copy_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_copy_sectors);
+
+/**
  * blk_queue_max_segments - set max hw segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
@@ -527,6 +541,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_write_same_sectors = min(t->max_write_same_sectors,
 					b->max_write_same_sectors);
+	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4d6811ac13fd..8d9077dc5bae 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -161,6 +161,11 @@ static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
 		(unsigned long long)q->limits.max_write_same_sectors << 9);
 }
 
+static ssize_t queue_copy_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n",
+		(unsigned long long)q->limits.max_copy_sectors << 9);
+}
 
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
@@ -374,6 +379,10 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
 	.show = queue_write_same_max_show,
 };
 
+static struct queue_sysfs_entry queue_copy_max_entry = {
+	.attr = {.name = "copy_max_bytes", .mode = S_IRUGO },
+	.show = queue_copy_max_show,
+};
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -422,6 +431,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
+	&queue_copy_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9fb4b0d75b11..b85fa9ac5779 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -251,8 +251,8 @@ static inline unsigned bio_segments(struct bio *bio)
 	struct bvec_iter iter;
 
 	/*
-	 * We special case discard/write same, because they interpret bi_size
-	 * differently:
+	 * We special case discard/write same/copy, because they
+	 * interpret bi_size differently:
 	 */
 
 	if (bio->bi_rw & REQ_DISCARD)
@@ -261,12 +261,23 @@ static inline unsigned bio_segments(struct bio *bio)
 	if (bio->bi_rw & REQ_WRITE_SAME)
 		return 1;
 
+	if (bio->bi_rw & REQ_COPY)
+		return 1;
+
 	bio_for_each_segment(bv, bio, iter)
 		segs++;
 
 	return segs;
 }
 
+static inline struct bio_copy *bio_copy(struct bio *bio)
+{
+	if (bio->bi_rw & REQ_COPY)
+		return bio->bi_special.copy;
+
+	return NULL;
+}
+
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 9cce1fcd6793..7ba2798dd579 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,11 @@ struct bvec_iter {
 						   current bvec */
 };
 
+struct bio_copy {
+	struct block_device	*bic_bdev;
+	sector_t		bic_sector;
+};
+
 /*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
@@ -81,6 +86,7 @@ struct bio {
 	union {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	struct bio_integrity_payload *integrity;  /* data integrity */
+	struct bio_copy *copy;			  /* copy offload */
 #endif
 	} bi_special;
 
@@ -162,6 +168,7 @@ enum rq_flag_bits {
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_WRITE_SAME,	/* write same block many times */
+	__REQ_COPY,		/* copy block range */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
@@ -206,6 +213,7 @@ enum rq_flag_bits {
 #define REQ_PRIO		(1ULL << __REQ_PRIO)
 #define REQ_DISCARD		(1ULL << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
+#define REQ_COPY		(1ULL << __REQ_COPY)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 
@@ -214,14 +222,15 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE | REQ_INTEGRITY)
+	 REQ_SECURE | REQ_INTEGRITY | REQ_COPY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
-#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
+#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME|REQ_COPY)
 
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
+	 REQ_COPY)
 
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5d0067766ff2..0d80e09251e6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -289,6 +289,7 @@ struct queue_limits {
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
 	unsigned int		max_write_same_sectors;
+	unsigned int		max_copy_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -976,6 +977,8 @@ extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
+extern void blk_queue_max_copy_sectors(struct request_queue *q,
+		unsigned int max_copy_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
@@ -1332,6 +1335,16 @@ static inline unsigned int bdev_write_same(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_copy_offload(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return q->limits.max_copy_sectors;
+
+	return 0;
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
1.9.0

