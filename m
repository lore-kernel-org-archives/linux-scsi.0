From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] block: add a max_discard_segment_size queue limit
Date: Mon, 20 Mar 2017 16:43:17 -0400
Message-ID: <20170320204319.12628-6-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ATA only allows 16 bits, so we need a limit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |  6 ++++++
 block/blk-merge.c      |  9 +++++++++
 block/blk-settings.c   | 14 ++++++++++++++
 include/linux/blkdev.h |  8 ++++++++
 4 files changed, 37 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index d772c221cc17..3eb3bd89b47a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1486,9 +1486,15 @@ bool bio_attempt_discard_merge(struct request_queue *q, struct request *req,
 		struct bio *bio)
 {
 	unsigned short segments = blk_rq_nr_discard_segments(req);
+	unsigned max_segment_sectors = queue_max_discard_segment_size(q) >> 9;
 
 	if (segments >= queue_max_discard_segments(q))
 		goto no_merge;
+	if (blk_rq_sectors(req) > max_segment_sectors)
+		goto no_merge;
+	if (bio_sectors(bio) > max_segment_sectors)
+		goto no_merge;
+
 	if (blk_rq_sectors(req) + bio_sectors(bio) >
 	    blk_rq_get_max_sectors(req, blk_rq_pos(req)))
 		goto no_merge;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2afa262425d1..c62a6f0325e0 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -11,6 +11,15 @@
 
 #include "blk.h"
 
+/*
+ * Split a discard bio if it doesn't fit into the overall discard request size
+ * of the device.  Note that we don't split it here if it's over the maximum
+ * discard segment size to avoid creating way too many bios in that case.
+ * We will simply take care of never merging such a larger than segment size
+ * bio into a request that has other bios, and let the low-level driver take
+ * care of splitting the request into multiple ranges in the on the wire
+ * format.
+ */
 static struct bio *blk_bio_discard_split(struct request_queue *q,
 					 struct bio *bio,
 					 struct bio_set *bs,
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1e7174ffc9d4..9d515ae3a405 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -93,6 +93,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->virt_boundary_mask = 0;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
+	lim->max_discard_segment_size = UINT_MAX;
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->max_dev_sectors = 0;
 	lim->chunk_sectors = 0;
@@ -132,6 +133,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_discard_segments = 1;
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_segment_size = UINT_MAX;
+	lim->max_discard_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
@@ -376,6 +378,18 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 EXPORT_SYMBOL(blk_queue_max_segment_size);
 
 /**
+ * blk_queue_max_discard_segment_size - set max segment size for discards
+ * @q:  the request queue for the device
+ * @max_size:  max size of a discard segment in bytes
+ **/
+void blk_queue_max_discard_segment_size(struct request_queue *q,
+		unsigned int max_size)
+{
+	q->limits.max_discard_segment_size = max_size;
+}
+EXPORT_SYMBOL_GPL(blk_queue_max_discard_segment_size);
+
+/**
  * blk_queue_logical_block_size - set logical block size for the queue
  * @q:  the request queue for the device
  * @size:  the logical block size, in bytes
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a7da607ca04..3b3bd646f580 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -333,6 +333,7 @@ struct queue_limits {
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
+	unsigned int		max_discard_segment_size;
 
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
@@ -1150,6 +1151,8 @@ extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_discard_segments(struct request_queue *,
 		unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
+extern void blk_queue_max_discard_segment_size(struct request_queue *,
+		unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_same_sectors(struct request_queue *q,
@@ -1415,6 +1418,11 @@ static inline unsigned int queue_max_segment_size(struct request_queue *q)
 	return q->limits.max_segment_size;
 }
 
+static inline unsigned int queue_max_discard_segment_size(struct request_queue *q)
+{
+	return q->limits.max_discard_segment_size;
+}
+
 static inline unsigned short queue_logical_block_size(struct request_queue *q)
 {
 	int retval = 512;
-- 
2.11.0

