From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2 of 9] block: Export I/O topology for block devices and
	partitions
Date: Fri, 24 Apr 2009 01:32:23 -0400
Message-ID: <72f4e15760670febdb40.1240551143__30463.1753512242$1240551486$gmane$org@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:42207 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZDXFgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2009 01:36:10 -0400
In-Reply-To: <patchbomb.1240551141@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide

To support devices with physical block sizes bigger than 512 bytes we
need to ensure proper alignment.  This patch adds support for exposing
I/O topology characteristics as devices are stacked.

  hardsect_size remains unchanged.  It is the smallest atomic unit the
  device can address (i.e. logical block size).

  io_granularity indicates the smallest I/O the device can access
  without incurring a read-modify-write penalty.  The granularity is set
  by low-level drivers from then on it is purely internal to the
  stacking logic.

  The io_min parameter is the smallest preferred I/O size reported by
  the device.  In many cases this is the same as granularity.  However,
  the io_min parameter can be scaled up when stacking (RAID5 chunk size
  > physical sector size).  io_min is available in sysfs
  (minimum_io_size).

  The io_opt characteristic indicates the optimal I/O size reported by
  the device.  This is usually the stripe width for arrays.  The value
  is in sysfs (optimal_io_size).

  The io_alignment parameter indicates the number of bytes the start of
  the device/partition is offset from the device granularity.  Partition
  tools and MD/DM tools can use this to align filesystems to the proper
  boundaries.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
7 files changed, 245 insertions(+), 4 deletions(-)
Documentation/ABI/testing/sysfs-block |   41 ++++++++++
block/blk-settings.c                  |  135 ++++++++++++++++++++++++++++++++-
block/blk-sysfs.c                     |   22 +++++
block/genhd.c                         |   10 ++
fs/partitions/check.c                 |   10 ++
include/linux/blkdev.h                |   30 +++++++
include/linux/genhd.h                 |    1 



diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -60,3 +60,44 @@ Description:
 		Indicates whether the block layer should automatically
 		generate checksums for write requests bound for
 		devices that support receiving integrity metadata.
+
+What:		/sys/block/<disk>/alignment
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report a physical block size that is
+		bigger than the logical block size (for instance a drive
+		with 4KB physical sectors exposing 512-byte logical
+		blocks to the operating system).  This parameter
+		indicates how many bytes the beginning of the device are
+		offset from the disk's natural alignment.
+
+What:		/sys/block/<disk>/<partition>/alignment
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report a physical block size that is
+		bigger than the logical block size (for instance a drive
+		with 4KB physical sectors exposing 512-byte logical
+		blocks to the operating system).  This parameter
+		indicates how many bytes the beginning of the partition
+		are offset from the disk's natural alignment.
+
+What:		/sys/block/<disk>/queue/minimum_io_size
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report a preferred minimum I/O size,
+		which is the smallest request the device can perform
+		without incurring a read-modify-write penalty.  For disk
+		drives this is often the physical block size.  For RAID
+		arrays it is often the stripe chunk size.
+
+What:		/sys/block/<disk>/queue/optimal_io_size
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report an optimal I/O size, which is
+		the device's preferred unit of receiving I/O.  This is
+		rarely reported for disk drives.  For RAID devices it is
+		usually the stripe width or the internal block size.
diff --git a/block/blk-settings.c b/block/blk-settings.c
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -292,22 +292,87 @@ EXPORT_SYMBOL(blk_queue_max_segment_size
  *
  * Description:
  *   This should typically be set to the lowest possible sector size
- *   that the hardware can operate on (possible without reverting to
- *   even internal read-modify-write operations). Usually the default
- *   of 512 covers most hardware.
+ *   (logical block size) that the hardware can operate on.  Usually the
+ *   default of 512 covers most hardware.
  **/
 void blk_queue_hardsect_size(struct request_queue *q, unsigned short size)
 {
-	q->hardsect_size = size;
+	q->hardsect_size = q->io_granularity = size;
 }
 EXPORT_SYMBOL(blk_queue_hardsect_size);
 
+/**
+ * blk_queue_io_granularity - set I/O granularity for the queue
+ * @q:  the request queue for the device
+ * @size:  the I/O granularity, in bytes
+ *
+ * Description:
+ *   This should typically be set to the lowest possible sector size
+ *   that the hardware can operate on without reverting to
+ *   read-modify-write operations.
+ **/
+void blk_queue_io_granularity(struct request_queue *q, unsigned short size)
+{
+	q->io_granularity = size;
+}
+EXPORT_SYMBOL(blk_queue_io_granularity);
+
+/**
+ * blk_queue_io_alignment - set physical block alignment for the queue
+ * @q:  the request queue for the device
+ * @alignment:  alignment offset in bytes
+ *
+ * Description:
+ *   Some devices are naturally misaligned to compensate for things like
+ *   the legacy DOS partition table 63-sector offset.  Low-level drivers
+ *   should call this function for devices whose first sector is not
+ *   naturally aligned.
+ */
+void blk_queue_io_alignment(struct request_queue *q, unsigned int alignment)
+{
+	q->io_alignment = alignment & (q->io_granularity - 1);
+	clear_bit(QUEUE_FLAG_MISALIGNED, &q->queue_flags);
+}
+EXPORT_SYMBOL(blk_queue_io_alignment);
+
 /*
  * Returns the minimum that is _not_ zero, unless both are zero.
  */
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 
 /**
+ * blk_queue_io_min - set minimum request size for the queue
+ * @q:  the request queue for the device
+ * @io_min:  smallest I/O size in bytes
+ *
+ * Description:
+ *   Some devices have an internal block size bigger than the reported
+ *   hardware sector size.  This function can be used to signal the
+ *   smallest I/O the device can perform without incurring a performance
+ *   penalty.
+ */
+void blk_queue_io_min(struct request_queue *q, unsigned int min)
+{
+	q->io_min = min;
+}
+EXPORT_SYMBOL(blk_queue_io_min);
+
+/**
+ * blk_queue_io_opt - set optimal request size for the queue
+ * @q:  the request queue for the device
+ * @io_opt:  optimal request size in bytes
+ *
+ * Description:
+ *   Drivers can call this function to set the preferred I/O request
+ *   size for devices that report such a value.
+ */
+void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
+{
+	q->io_opt = opt;
+}
+EXPORT_SYMBOL(blk_queue_io_opt);
+
+/**
  * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
  * @t:	the stacking driver (top)
  * @b:  the underlying device (bottom)
@@ -335,6 +400,68 @@ void blk_queue_stack_limits(struct reque
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_queue_stack_topology - adjust queue limits for stacked drivers
+ * @t:	the stacking driver (top)
+ * @bdev:  the underlying block device (bottom)
+ * @offset:  offset to beginning of data within component device
+ **/
+void blk_queue_stack_topology(struct request_queue *t, struct block_device *bdev,
+			      sector_t offset)
+{
+	struct request_queue *b = bdev_get_queue(bdev);
+	int misaligned;
+
+	/* zero is "infinity" */
+	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
+	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
+
+	t->max_phys_segments = min_not_zero(t->max_phys_segments, b->max_phys_segments);
+	t->max_hw_segments = min_not_zero(t->max_hw_segments, b->max_hw_segments);
+	t->max_segment_size = min_not_zero(t->max_segment_size, b->max_segment_size);
+	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
+	t->io_min = max(t->io_min, b->io_min);
+	t->io_granularity = max(t->io_granularity, b->io_granularity);
+
+	misaligned = 0;
+	offset += get_start_sect(bdev) << 9;
+
+	/* Bottom device offset aligned? */
+	if (offset && (offset & (b->io_granularity - 1)) != b->io_alignment) {
+		misaligned = 1;
+		goto out;
+	}
+
+	/* If top has no alignment, inherit from bottom */
+	if (!t->io_alignment)
+		t->io_alignment = b->io_alignment & (b->io_granularity - 1);
+
+	/* Top alignment on logical block boundary? */
+	if (t->io_alignment & (t->hardsect_size - 1)) {
+		misaligned = 1;
+		goto out;
+	}
+
+out:
+	if (!t->queue_lock)
+		WARN_ON_ONCE(1);
+	else if (misaligned || !test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(t->queue_lock, flags);
+
+		if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+			queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
+
+		if (misaligned)
+			queue_flag_set(QUEUE_FLAG_MISALIGNED, t);
+
+		spin_unlock_irqrestore(t->queue_lock, flags);
+	}
+}
+EXPORT_SYMBOL(blk_queue_stack_topology);
+
+/**
  * blk_queue_dma_pad - set pad mask
  * @q:     the request queue for the device
  * @mask:  pad mask
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -105,6 +105,16 @@ static ssize_t queue_hw_sector_size_show
 	return queue_var_show(q->hardsect_size, page);
 }
 
+static ssize_t queue_io_min_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->io_min, page);
+}
+
+static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->io_opt, page);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -256,6 +266,16 @@ static struct queue_sysfs_entry queue_hw
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_io_min_entry = {
+	.attr = {.name = "minimum_io_size", .mode = S_IRUGO },
+	.show = queue_io_min_show,
+};
+
+static struct queue_sysfs_entry queue_io_opt_entry = {
+	.attr = {.name = "optimal_io_size", .mode = S_IRUGO },
+	.show = queue_io_opt_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nonrot_show,
@@ -287,6 +307,8 @@ static struct attribute *default_attrs[]
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_io_min_entry.attr,
+	&queue_io_opt_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/genhd.c b/block/genhd.c
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -848,11 +848,20 @@ static ssize_t disk_capability_show(stru
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
+static ssize_t disk_alignment_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%d\n", queue_io_alignment(disk->queue));
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alignment, S_IRUGO, disk_alignment_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -871,6 +880,7 @@ static struct attribute *disk_attrs[] = 
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
 	&dev_attr_size.attr,
+	&dev_attr_alignment.attr,
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -219,6 +219,13 @@ ssize_t part_size_show(struct device *de
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
+ssize_t part_alignment_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment);
+}
+
 ssize_t part_stat_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
@@ -272,6 +279,7 @@ ssize_t part_fail_store(struct device *d
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alignment, S_IRUGO, part_alignment_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -282,6 +290,7 @@ static struct attribute *part_attrs[] = 
 	&dev_attr_partition.attr,
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
+	&dev_attr_alignment.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -383,6 +392,7 @@ struct hd_struct *add_partition(struct g
 	pdev = part_to_dev(p);
 
 	p->start_sect = start;
+	p->alignment = queue_sector_alignment(disk->queue, start);
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -402,6 +402,10 @@ struct request_queue
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
+	unsigned int		io_alignment;
+	unsigned int		io_granularity;
+	unsigned int		io_min;
+	unsigned int		io_opt;
 
 	unsigned long		seg_boundary_mask;
 	void			*dma_drain_buffer;
@@ -461,6 +465,7 @@ struct request_queue
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
+#define QUEUE_FLAG_MISALIGNED  16	/* bdev not aligned to disk */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -877,7 +882,15 @@ extern void blk_queue_max_phys_segments(
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
+extern void blk_queue_io_granularity(struct request_queue *, unsigned short);
+extern void blk_queue_io_alignment(struct request_queue *q,
+				unsigned int alignment);
+extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
+extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
+extern void blk_queue_stack_topology(struct request_queue *t,
+				     struct block_device *bdev,
+				     sector_t offset);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
@@ -978,6 +991,23 @@ static inline int bdev_hardsect_size(str
 	return queue_hardsect_size(bdev_get_queue(bdev));
 }
 
+static inline int queue_io_alignment(struct request_queue *q)
+{
+	if (q && test_bit(QUEUE_FLAG_MISALIGNED, &q->queue_flags))
+		return -1;
+
+	if (q && q->io_alignment)
+		return q->io_alignment;
+
+	return 0;
+}
+
+static inline int queue_sector_alignment(struct request_queue *q,
+					 sector_t sector)
+{
+	return ((sector << 9) - q->io_alignment) & (q->io_min - 1);
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -90,6 +90,7 @@ struct disk_stats {
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
+	sector_t alignment;
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;


