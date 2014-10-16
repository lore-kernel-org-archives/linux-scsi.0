From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] block: set the nr of sectors a dev can compare and write atomically
Date: Thu, 16 Oct 2014 00:37:11 -0500
Message-ID: <1413437835-13778-2-git-send-email-michaelc@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This adds blk settings helpers to allow drivers to tell the block layer
how many sectors it can process in a COMPARE_AND_WRITE/ATS request.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-settings.c   |   20 ++++++++++++++++++++
 block/blk-sysfs.c      |   11 +++++++++++
 include/linux/blkdev.h |    3 +++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f1a1795..b33cf1c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -114,6 +114,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
 	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	lim->chunk_sectors = 0;
+	lim->max_cmp_and_write_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->discard_granularity = 0;
@@ -147,6 +148,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
+	lim->max_cmp_and_write_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
@@ -298,6 +300,22 @@ void blk_queue_chunk_sectors(struct request_queue *q, unsigned int chunk_sectors
 EXPORT_SYMBOL(blk_queue_chunk_sectors);
 
 /**
+ * blk_queue_max_cmp_and_write_sectors - set max sectors for a single request
+ * @q:  the request queue for the device
+ * @max_cmp_and_write_sectors: maximum number of 512b sectors to cmp and write
+ *
+ * Description:
+ *    This sets the total number of sectors that the device can process
+ *    in a compare and write operation.
+ **/
+void blk_queue_max_cmp_and_write_sectors(struct request_queue *q,
+					 unsigned int max_cmp_and_write_sectors)
+{
+	q->limits.max_cmp_and_write_sectors = max_cmp_and_write_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_cmp_and_write_sectors);
+
+/**
  * blk_queue_max_discard_sectors - set max sectors for a single discard
  * @q:  the request queue for the device
  * @max_discard_sectors: maximum number of sectors to discard
@@ -548,6 +566,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_write_same_sectors = min(t->max_write_same_sectors,
 					b->max_write_same_sectors);
+	t->max_cmp_and_write_sectors = min(t->max_cmp_and_write_sectors,
+					   b->max_cmp_and_write_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 17f5c84..c546400 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -161,6 +161,11 @@ static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
 		(unsigned long long)q->limits.max_write_same_sectors << 9);
 }
 
+static ssize_t queue_cmp_and_write_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n",
+		(unsigned long long)q->limits.max_cmp_and_write_sectors << 9);
+}
 
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
@@ -374,6 +379,11 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
 	.show = queue_write_same_max_show,
 };
 
+static struct queue_sysfs_entry queue_cmp_and_write_max_entry = {
+	.attr = {.name = "cmp_and_write_max_bytes", .mode = S_IRUGO },
+	.show = queue_cmp_and_write_max_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_show_nonrot,
@@ -422,6 +432,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
+	&queue_cmp_and_write_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..6d03206 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -290,6 +290,7 @@ struct queue_limits {
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
 	unsigned int		max_write_same_sectors;
+	unsigned int		max_cmp_and_write_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -1009,6 +1010,8 @@ extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
+extern void blk_queue_max_cmp_and_write_sectors(struct request_queue *,
+		unsigned int max_cmp_and_write_sectors);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_same_sectors(struct request_queue *q,
-- 
1.7.1
