From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1 of 3] block: Export I/O hints for block devices and
	partitions
Date: Thu, 05 Jun 2008 01:22:50 -0400
Message-ID: <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:32909 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYFEFYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2008 01:24:25 -0400
In-Reply-To: <patchbomb.1212643369@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

3 files changed, 74 insertions(+)
block/genhd.c         |   39 +++++++++++++++++++++++++++++++++++++++
fs/partitions/check.c |   11 +++++++++++
include/linux/genhd.h |   24 ++++++++++++++++++++++++


Export physical start offset and preferred I/O sizes in sysfs.  This
allows filesystems to align data structures to RAID stripes.

`physical offset' indicates the physical offset in sectors to the
start of the block device.

`optimal_io_block' indicates the smallest request that can be
submitted without incurring a performance penalty (RAID
read-modify-write, 512-byte sector emulation).  It is recommended that
I/O requests are a multiple of this size.

`optimal-io-length' indicates the optimal I/O length for the device
(i.e. stripe size).

These values are largely modeled after the SCSI SBC-3 Block Limits
VPD.

Block device drivers may call disk_set_io_hints() to set these values
to their preference.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 3e197642edae -r 3e5d8520d247 block/genhd.c
--- a/block/genhd.c	Mon Jun 02 15:30:44 2008 -0700
+++ b/block/genhd.c	Thu Jun 05 01:07:51 2008 -0400
@@ -222,6 +222,15 @@
 	return  kobj ? dev_to_disk(dev) : NULL;
 }
 
+void disk_set_io_hints(struct gendisk *disk, sector_t offset, uint block, uint len)
+{
+	printk(KERN_ERR "%s I/O hints: off %llu, gran %u, len %u\n",
+	       disk->disk_name, (unsigned long long)offset, block, len);
+	disk->phys_offset = offset;
+	disk->optimal_io_block = block;
+	disk->optimal_io_length = len;
+}
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
@@ -416,6 +425,30 @@
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
+static ssize_t disk_phys_offset_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%llu\n", (unsigned long long)disk->phys_offset);
+}
+
+static ssize_t disk_optimal_io_block_show(struct device *dev,
+					  struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%u\n", disk->optimal_io_block);
+}
+
+static ssize_t disk_optimal_io_length_show(struct device *dev,
+					   struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%u\n", disk->optimal_io_length);
+}
+
 static ssize_t disk_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -474,6 +507,9 @@
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
+static DEVICE_ATTR(phys_offset, S_IRUGO, disk_phys_offset_show, NULL);
+static DEVICE_ATTR(optimal_io_block, S_IRUGO, disk_optimal_io_block_show, NULL);
+static DEVICE_ATTR(optimal_io_length, S_IRUGO, disk_optimal_io_length_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -485,6 +521,9 @@
 	&dev_attr_removable.attr,
 	&dev_attr_size.attr,
 	&dev_attr_capability.attr,
+	&dev_attr_phys_offset.attr,
+	&dev_attr_optimal_io_block.attr,
+	&dev_attr_optimal_io_length.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
diff -r 3e197642edae -r 3e5d8520d247 fs/partitions/check.c
--- a/fs/partitions/check.c	Mon Jun 02 15:30:44 2008 -0700
+++ b/fs/partitions/check.c	Thu Jun 05 01:07:51 2008 -0400
@@ -204,6 +204,14 @@
 	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
 }
 
+static ssize_t part_phys_offset_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%llu\n",(unsigned long long)p->phys_offset);
+}
+
 static ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -261,6 +269,7 @@
 #endif
 
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
+static DEVICE_ATTR(phys_offset, S_IRUGO, part_phys_offset_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -271,6 +280,7 @@
 static struct attribute *part_attrs[] = {
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
+	&dev_attr_phys_offset.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -358,6 +368,7 @@
 		return;
 	}
 	p->start_sect = start;
+	p->phys_offset = disk->phys_offset + start;
 	p->nr_sects = len;
 	p->partno = part;
 	p->policy = disk->policy;
diff -r 3e197642edae -r 3e5d8520d247 include/linux/genhd.h
--- a/include/linux/genhd.h	Mon Jun 02 15:30:44 2008 -0700
+++ b/include/linux/genhd.h	Thu Jun 05 01:07:51 2008 -0400
@@ -87,6 +87,7 @@
 struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
+	sector_t phys_offset;
 	struct device dev;
 	struct kobject *holder_dir;
 	int policy, partno;
@@ -122,6 +123,10 @@
 	struct request_queue *queue;
 	void *private_data;
 	sector_t capacity;
+
+	sector_t phys_offset;
+	unsigned int optimal_io_block;
+	unsigned int optimal_io_length;
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
@@ -357,6 +362,25 @@
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *part);
+extern void disk_set_io_hints(struct gendisk *, sector_t, unsigned int, unsigned int);
+
+static inline sector_t bdev_phys_offset(struct block_device *bdev)
+{
+	if (bdev != bdev->bd_contains)
+		return bdev->bd_part->phys_offset;
+
+	return bdev->bd_disk->phys_offset;
+}
+
+static inline unsigned int bdev_optimal_io_block(struct block_device *bdev)
+{
+	return bdev->bd_disk->optimal_io_block;
+}
+
+static inline unsigned int bdev_optimal_io_length(struct block_device *bdev)
+{
+	return bdev->bd_disk->optimal_io_length;
+}
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);


