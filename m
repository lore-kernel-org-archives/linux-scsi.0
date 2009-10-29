From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] block: add support for discard limits
Date: Thu, 29 Oct 2009 11:08:31 -0400
Message-ID: <20091029151127.257902381@bombadil.infradead.org>
References: <20091029150830.497006534@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZJ2PLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 11:11:23 -0400
Content-Disposition: inline; filename=discard-add-limits
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mkp@mkp.net, axboe@kernel.dk, matthew@wil.cx

To properly support discard on SCSI Arrays we need to take the discard
granularity and the first aligned discard LBA into account.  This patch
adds block limits for both of them, and trims down dicard requests to fit
into these limits in blkdev_issue_discard.  We also make sure the alignment
offset is properly adjust for partitions and add sysfs files to expose
the limits to userspaced.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c	2009-10-29 15:46:06.567004210 +0100
+++ linux-2.6/block/blk-sysfs.c	2009-10-29 15:47:33.660022475 +0100
@@ -126,6 +126,18 @@ static ssize_t queue_io_opt_show(struct 
 	return queue_var_show(queue_io_opt(q), page);
 }
 
+static ssize_t queue_discard_granularity_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.discard_granularity, page);
+}
+
+static ssize_t queue_discard_alignment_show(struct request_queue *q,
+		char *page)
+{
+	return queue_var_show(q->limits.discard_alignment, page);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -293,6 +305,16 @@ static struct queue_sysfs_entry queue_io
 	.show = queue_io_opt_show,
 };
 
+static struct queue_sysfs_entry queue_discard_granularity_entry = {
+	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
+	.show = queue_discard_granularity_show,
+};
+
+static struct queue_sysfs_entry queue_discard_alignment_entry = {
+	.attr = {.name = "discard_alignment", .mode = S_IRUGO },
+	.show = queue_discard_alignment_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nonrot_show,
@@ -328,6 +350,8 @@ static struct attribute *default_attrs[]
 	&queue_physical_block_size_entry.attr,
 	&queue_io_min_entry.attr,
 	&queue_io_opt_entry.attr,
+	&queue_discard_granularity_entry.attr,
+	&queue_discard_alignment_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-10-29 15:46:06.551004197 +0100
+++ linux-2.6/include/linux/blkdev.h	2009-10-29 15:47:33.661024838 +0100
@@ -312,6 +312,8 @@ struct queue_limits {
 	unsigned int		io_min;
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
+	unsigned int		discard_granularity;
+	unsigned int		discard_alignment;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-10-29 15:46:06.573022714 +0100
+++ linux-2.6/block/blk-barrier.c	2009-10-29 15:47:33.663024324 +0100
@@ -355,6 +355,20 @@ static void blkdev_discard_end_io(struct
 	bio_put(bio);
 }
 
+/*
+ * Many implementation of block dicard are very limited.  Most implementations
+ * enforce a granularity limit for the discard requests and we have to trim
+ * down the request to match it.  In addition to that for some implementation
+ * the start of this granularity is misaligned vs block 0, so we need to take
+ * that into account aswell.
+ */
+static sector_t discard_offset(sector_t sector, unsigned int granularity,
+		unsigned int alignment)
+{
+	return ((sector - alignment + granularity - 1) &
+		~(granularity - 1)) - (sector - alignment);
+}
+
 /**
  * blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
@@ -371,10 +385,12 @@ int blkdev_issue_discard(struct block_de
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
+	struct hd_struct *part = bdev->bd_part;
 	int type = flags & DISCARD_FL_BARRIER ?
 		DISCARD_BARRIER : DISCARD_NOBARRIER;
 	struct bio *bio;
 	struct page *page;
+	sector_t offset;
 	int ret = 0;
 
 	if (!q)
@@ -383,6 +399,18 @@ int blkdev_issue_discard(struct block_de
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	/*
+	 * We need to respect the discard granularity that is supported by the
+	 * device.  Round up the start block to the nearest multiple and round
+	 * down the length to the nearest multiple of that granularity.
+	 */
+	offset = discard_offset(sector, q->limits.discard_granularity,
+				part->discard_alignment);
+
+	sector += offset;
+	nr_sects = (nr_sects - offset - 1) &
+		    ~(q->limits.discard_granularity - 1);
+
 	while (nr_sects && !ret) {
 		unsigned int sector_size = q->limits.logical_block_size;
 		unsigned int max_discard_sectors =
Index: linux-2.6/fs/partitions/check.c
===================================================================
--- linux-2.6.orig/fs/partitions/check.c	2009-10-29 15:46:06.580003701 +0100
+++ linux-2.6/fs/partitions/check.c	2009-10-29 15:47:33.667023647 +0100
@@ -226,6 +226,13 @@ ssize_t part_alignment_offset_show(struc
 	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
 }
 
+ssize_t part_discard_alignment_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%u\n", p->discard_alignment);
+}
+
 ssize_t part_stat_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
@@ -288,6 +295,8 @@ static DEVICE_ATTR(partition, S_IRUGO, p
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
+static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
+		   NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -300,6 +309,7 @@ static struct attribute *part_attrs[] = 
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_alignment_offset.attr,
+	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -403,6 +413,8 @@ struct hd_struct *add_partition(struct g
 
 	p->start_sect = start;
 	p->alignment_offset = queue_sector_alignment_offset(disk->queue, start);
+	p->discard_alignment = (disk->queue->limits.discard_alignment + start) &
+				(disk->queue->limits.discard_granularity - 1);
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2009-10-29 15:46:06.557028148 +0100
+++ linux-2.6/include/linux/genhd.h	2009-10-29 15:47:33.672256087 +0100
@@ -91,6 +91,7 @@ struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
 	sector_t alignment_offset;
+	unsigned int discard_alignment;
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;

