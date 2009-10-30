From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] block: Expose discard granularity
Date: Thu, 29 Oct 2009 23:30:08 -0400
Message-ID: <1256873409-12668-2-git-send-email-martin.petersen@oracle.com>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:41761 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbZJ3Da2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 23:30:28 -0400
In-Reply-To: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

While SSDs track block usage on a per-sector basis, RAID arrays often
have allocation blocks that are bigger.  Allow the discard granularity
to be set and expose it in sysfs.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c   |   16 +++++++++++++++-
 block/blk-sysfs.c      |   22 ++++++++++++++++++++++
 include/linux/blkdev.h |   13 +++++++++++++
 3 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 66d4aa8..60a0bec 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -96,7 +96,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 	lim->max_hw_sectors = INT_MAX;
-	lim->max_discard_sectors = SAFE_MAX_SECTORS;
+	lim->max_discard_sectors = 0;
+	lim->discard_granularity = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -252,6 +253,19 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
 /**
+ * blk_queue_discard_granularity - set minimum size for discard requests
+ * @q:	the request queue for the device
+ * @gran:  the smallest unit the device can discard (in bytes)
+ *
+ * Description:
+ */
+void blk_queue_discard_granularity(struct request_queue *q, unsigned int gran)
+{
+	q->limits.discard_granularity = gran;
+}
+EXPORT_SYMBOL(blk_queue_discard_granularity);
+
+/**
  * blk_queue_max_phys_segments - set max phys segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8a6d81a..3e9c947 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -126,6 +126,16 @@ static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
 	return queue_var_show(queue_io_opt(q), page);
 }
 
+static ssize_t queue_discard_granularity_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_discard_granularity(q), page);
+}
+
+static ssize_t queue_discard_max_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_max_discard_sectors(q) << 9, page);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -293,6 +303,16 @@ static struct queue_sysfs_entry queue_io_opt_entry = {
 	.show = queue_io_opt_show,
 };
 
+static struct queue_sysfs_entry queue_discard_granularity_entry = {
+	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
+	.show = queue_discard_granularity_show,
+};
+
+static struct queue_sysfs_entry queue_discard_max_entry = {
+	.attr = {.name = "discard_max_bytes", .mode = S_IRUGO },
+	.show = queue_discard_max_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nonrot_show,
@@ -328,6 +348,8 @@ static struct attribute *default_attrs[] = {
 	&queue_physical_block_size_entry.attr,
 	&queue_io_min_entry.attr,
 	&queue_io_opt_entry.attr,
+	&queue_discard_granularity_entry.attr,
+	&queue_discard_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 221cecd..d5bb834 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -312,6 +312,7 @@ struct queue_limits {
 	unsigned int		io_min;
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
+	unsigned int		discard_granularity;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
@@ -939,6 +940,8 @@ extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
+extern void blk_queue_discard_granularity(struct request_queue *q,
+					  unsigned int gran);
 extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
@@ -1134,6 +1137,16 @@ static inline int bdev_alignment_offset(struct block_device *bdev)
 	return q->limits.alignment_offset;
 }
 
+static inline unsigned int queue_discard_granularity(struct request_queue *q)
+{
+	return q->limits.discard_granularity;
+}
+
+static inline unsigned int queue_max_discard_sectors(struct request_queue *q)
+{
+	return q->limits.max_discard_sectors;
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
1.6.0.6

