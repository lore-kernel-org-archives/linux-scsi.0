From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and partitions
Date: Wed, 20 May 2009 17:19:12 -0400
Message-ID: <yq1ws8bealr.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-6-git-send-email-martin.petersen@oracle.com>
	<20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com>
	<yq1fxf1gi3y.fsf@sermon.lab.mkp.net> <20090519181530.GH4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090519181530.GH4140@kernel.dk> (Jens Axboe's message of "Tue,
	19 May 2009 20:15:30 +0200")
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> If you repost an updated 5/13 patch and I'll add it to the mix.

block: Export I/O topology for block devices and partitions

To support devices with physical block sizes bigger than 512 bytes we
need to ensure proper alignment.  This patch adds support for exposing
I/O topology characteristics as devices are stacked.

  logical_block_size is the smallest unit the device can address.

  physical_block_size indicates the smallest I/O the device can write
  without incurring a read-modify-write penalty.

  The alignment_offset parameter indicates the number of bytes the start
  of the device/partition is offset from the device's natural alignment.
  Partition tools and MD/DM utilities can use this to pad their offsets
  so filesystems start on proper boundaries.

  The io_min parameter is the smallest preferred I/O size reported by
  the device.  In many cases this is the same as the physical block
  size.  However, the io_min parameter can be scaled up when stacking
  (RAID5 chunk size > physical block size).

  The io_opt characteristic indicates the optimal I/O size reported by
  the device.  This is usually the stripe width for arrays.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 44f52a4..cbbd3e0 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -60,3 +60,62 @@ Description:
 		Indicates whether the block layer should automatically
 		generate checksums for write requests bound for
 		devices that support receiving integrity metadata.
+
+What:		/sys/block/<disk>/alignment_offset
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report a physical block size that is
+		bigger than the logical block size (for instance a drive
+		with 4KB physical sectors exposing 512-byte logical
+		blocks to the operating system).  This parameter
+		indicates how many bytes the beginning of the device is
+		offset from the disk's natural alignment.
+
+What:		/sys/block/<disk>/<partition>/alignment_offset
+Date:		April 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		Storage devices may report a physical block size that is
+		bigger than the logical block size (for instance a drive
+		with 4KB physical sectors exposing 512-byte logical
+		blocks to the operating system).  This parameter
+		indicates how many bytes the beginning of the partition
+		is offset from the disk's natural alignment.
+
+What:		/sys/block/<disk>/queue/logical_block_size
+Date:		May 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		This is the smallest unit the storage device can
+		address.  It is typically 512 bytes.
+
+What:		/sys/block/<disk>/queue/physical_block_size
+Date:		May 2009
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		This is the smallest unit the storage device can write
+		without resorting to read-modify-write operation.  It is
+		usually the same as the logical block size but may be
+		bigger.  One example is SATA drives with 4KB sectors
+		that expose a 512-byte logical block size to the
+		operating system.
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
index b0f547c..5649f34 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -309,9 +309,94 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);
 void blk_queue_logical_block_size(struct request_queue *q, unsigned short size)
 {
 	q->limits.logical_block_size = size;
+
+	if (q->limits.physical_block_size < size)
+		q->limits.physical_block_size = size;
+
+	if (q->limits.io_min < q->limits.physical_block_size)
+		q->limits.io_min = q->limits.physical_block_size;
 }
 EXPORT_SYMBOL(blk_queue_logical_block_size);
 
+/**
+ * blk_queue_physical_block_size - set physical block size for the queue
+ * @q:  the request queue for the device
+ * @size:  the physical block size, in bytes
+ *
+ * Description:
+ *   This should be set to the lowest possible sector size that the
+ *   hardware can operate on without reverting to read-modify-write
+ *   operations.
+ */
+void blk_queue_physical_block_size(struct request_queue *q, unsigned short size)
+{
+	q->limits.physical_block_size = size;
+
+	if (q->limits.physical_block_size < q->limits.logical_block_size)
+		q->limits.physical_block_size = q->limits.logical_block_size;
+
+	if (q->limits.io_min < q->limits.physical_block_size)
+		q->limits.io_min = q->limits.physical_block_size;
+}
+EXPORT_SYMBOL(blk_queue_physical_block_size);
+
+/**
+ * blk_queue_alignment_offset - set physical block alignment offset
+ * @q:	the request queue for the device
+ * @alignment:	alignment offset in bytes
+ *
+ * Description:
+ *   Some devices are naturally misaligned to compensate for things like
+ *   the legacy DOS partition table 63-sector offset.  Low-level drivers
+ *   should call this function for devices whose first sector is not
+ *   naturally aligned.
+ */
+void blk_queue_alignment_offset(struct request_queue *q, unsigned int offset)
+{
+	q->limits.alignment_offset =
+		offset & (q->limits.physical_block_size - 1);
+	q->limits.misaligned = 0;
+}
+EXPORT_SYMBOL(blk_queue_alignment_offset);
+
+/**
+ * blk_queue_io_min - set minimum request size for the queue
+ * @q:	the request queue for the device
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
+	q->limits.io_min = min;
+
+	if (q->limits.io_min < q->limits.logical_block_size)
+		q->limits.io_min = q->limits.logical_block_size;
+
+	if (q->limits.io_min < q->limits.physical_block_size)
+		q->limits.io_min = q->limits.physical_block_size;
+}
+EXPORT_SYMBOL(blk_queue_io_min);
+
+/**
+ * blk_queue_io_opt - set optimal request size for the queue
+ * @q:	the request queue for the device
+ * @io_opt:  optimal request size in bytes
+ *
+ * Description:
+ *   Drivers can call this function to set the preferred I/O request
+ *   size for devices that report such a value.
+ */
+void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
+{
+	q->limits.io_opt = opt;
+}
+EXPORT_SYMBOL(blk_queue_io_opt);
+
 /*
  * Returns the minimum that is _not_ zero, unless both are zero.
  */
@@ -358,6 +443,107 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_stack_limits - adjust queue_limits for stacked devices
+ * @t:	the stacking driver limits (top)
+ * @bdev:  the underlying queue limits (bottom)
+ * @offset:  offset to beginning of data within component device
+ *
+ * Description:
+ *    Merges two queue_limit structs.  Returns 0 if alignment didn't
+ *    change.  Returns -1 if adding the bottom device caused
+ *    misalignment.
+ */
+int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
+		     sector_t offset)
+{
+	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
+	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+
+	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
+					    b->seg_boundary_mask);
+
+	t->max_phys_segments = min_not_zero(t->max_phys_segments,
+					    b->max_phys_segments);
+
+	t->max_hw_segments = min_not_zero(t->max_hw_segments,
+					  b->max_hw_segments);
+
+	t->max_segment_size = min_not_zero(t->max_segment_size,
+					   b->max_segment_size);
+
+	t->logical_block_size = max(t->logical_block_size,
+				    b->logical_block_size);
+
+	t->physical_block_size = max(t->physical_block_size,
+				     b->physical_block_size);
+
+	t->io_min = max(t->io_min, b->io_min);
+	t->no_cluster |= b->no_cluster;
+
+	/* Bottom device offset aligned? */
+	if (offset &&
+	    (offset & (b->physical_block_size - 1)) != b->alignment_offset) {
+		t->misaligned = 1;
+		return -1;
+	}
+
+	/* If top has no alignment offset, inherit from bottom */
+	if (!t->alignment_offset)
+		t->alignment_offset =
+			b->alignment_offset & (b->physical_block_size - 1);
+
+	/* Top device aligned on logical block boundary? */
+	if (t->alignment_offset & (t->logical_block_size - 1)) {
+		t->misaligned = 1;
+		return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * disk_stack_limits - adjust queue limits for stacked drivers
+ * @t:	MD/DM gendisk (top)
+ * @bdev:  the underlying block device (bottom)
+ * @offset:  offset to beginning of data within component device
+ *
+ * Description:
+ *    Merges the limits for two queues.  Returns 0 if alignment
+ *    didn't change.  Returns -1 if adding the bottom device caused
+ *    misalignment.
+ */
+void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
+		       sector_t offset)
+{
+	struct request_queue *t = disk->queue;
+	struct request_queue *b = bdev_get_queue(bdev);
+
+	offset += get_start_sect(bdev) << 9;
+
+	if (blk_stack_limits(&t->limits, &b->limits, offset) < 0) {
+		char top[BDEVNAME_SIZE], bottom[BDEVNAME_SIZE];
+
+		disk_name(disk, 0, top);
+		bdevname(bdev, bottom);
+
+		printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
+		       top, bottom);
+	}
+
+	if (!t->queue_lock)
+		WARN_ON_ONCE(1);
+	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(t->queue_lock, flags);
+		if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+			queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
+		spin_unlock_irqrestore(t->queue_lock, flags);
+	}
+}
+EXPORT_SYMBOL(disk_stack_limits);
+
+/**
  * blk_queue_dma_pad - set pad mask
  * @q:     the request queue for the device
  * @mask:  pad mask
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3ccdadb..9337e17 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -105,6 +105,21 @@ static ssize_t queue_logical_block_size_show(struct request_queue *q, char *page
 	return queue_var_show(queue_logical_block_size(q), page);
 }
 
+static ssize_t queue_physical_block_size_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_physical_block_size(q), page);
+}
+
+static ssize_t queue_io_min_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_io_min(q), page);
+}
+
+static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_io_opt(q), page);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -257,6 +272,21 @@ static struct queue_sysfs_entry queue_logical_block_size_entry = {
 	.show = queue_logical_block_size_show,
 };
 
+static struct queue_sysfs_entry queue_physical_block_size_entry = {
+	.attr = {.name = "physical_block_size", .mode = S_IRUGO },
+	.show = queue_physical_block_size_show,
+};
+
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
@@ -289,6 +319,9 @@ static struct attribute *default_attrs[] = {
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
 	&queue_logical_block_size_entry.attr,
+	&queue_physical_block_size_entry.attr,
+	&queue_io_min_entry.attr,
+	&queue_io_opt_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/genhd.c b/block/genhd.c
index 1a4916e..fe7ccc0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -852,11 +852,21 @@ static ssize_t disk_capability_show(struct device *dev,
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
+static ssize_t disk_alignment_offset_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -875,6 +885,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
 	&dev_attr_size.attr,
+	&dev_attr_alignment_offset.attr,
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..0af3608 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -219,6 +219,13 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
+ssize_t part_alignment_offset_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
+}
+
 ssize_t part_stat_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
@@ -272,6 +279,7 @@ ssize_t part_fail_store(struct device *dev,
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -282,6 +290,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_partition.attr,
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
+	&dev_attr_alignment_offset.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -383,6 +392,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	pdev = part_to_dev(p);
 
 	p->start_sect = start;
+	p->alignment_offset = queue_sector_alignment_offset(disk->queue, start);
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2655673..943a661 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -314,11 +314,16 @@ struct queue_limits {
 	unsigned int		max_hw_sectors;
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
+	unsigned int		physical_block_size;
+	unsigned int		alignment_offset;
+	unsigned int		io_min;
+	unsigned int		io_opt;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
 	unsigned short		max_phys_segments;
 
+	unsigned char		misaligned;
 	unsigned char		no_cluster;
 };
 
@@ -909,6 +914,15 @@ extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_alignment_offset(struct request_queue *q,
+				       unsigned int alignment);
+extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
+extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
+extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
+			    sector_t offset);
+extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
+			      sector_t offset);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
@@ -1045,6 +1059,39 @@ static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
 	return queue_logical_block_size(bdev_get_queue(bdev));
 }
 
+static inline unsigned int queue_physical_block_size(struct request_queue *q)
+{
+	return q->limits.physical_block_size;
+}
+
+static inline unsigned int queue_io_min(struct request_queue *q)
+{
+	return q->limits.io_min;
+}
+
+static inline unsigned int queue_io_opt(struct request_queue *q)
+{
+	return q->limits.io_opt;
+}
+
+static inline int queue_alignment_offset(struct request_queue *q)
+{
+	if (q && q->limits.misaligned)
+		return -1;
+
+	if (q && q->limits.alignment_offset)
+		return q->limits.alignment_offset;
+
+	return 0;
+}
+
+static inline int queue_sector_alignment_offset(struct request_queue *q,
+						sector_t sector)
+{
+	return ((sector << 9) - q->limits.alignment_offset)
+		& (q->limits.io_min - 1);
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a1a28ca..149fda2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -90,6 +90,7 @@ struct disk_stats {
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
+	sector_t alignment_offset;
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;
