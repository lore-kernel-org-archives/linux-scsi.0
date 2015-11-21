From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 2/3] block: Add badblock management for gendisks
Date: Fri, 20 Nov 2015 17:49:19 -0700
Message-ID: <1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

NVDIMM devices, which can behave more like DRAM rather than block
devices, may develop bad cache lines, or 'poison'. A block device
exposed by the pmem driver can then consume poison via a read (or
write), and cause a machine check. On platforms without machine
check recovery features, this would mean a crash.

The block device maintaining a runtime list of all known sectors that
have poison can directly avoid this, and also provide a path forward
to enable proper handling/recovery for DAX faults on such a device.

Use the new badblock management interfaces to add a badblocks list to
gendisks.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 block/genhd.c         | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |  6 +++++
 2 files changed, 70 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 0c706f3..4209c32 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -20,6 +20,7 @@
 #include <linux/idr.h>
 #include <linux/log2.h>
 #include <linux/pm_runtime.h>
+#include <linux/badblocks.h>
 
 #include "blk.h"
 
@@ -505,6 +506,20 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static void disk_alloc_badblocks(struct gendisk *disk)
+{
+	disk->bb = kzalloc(sizeof(disk->bb), GFP_KERNEL);
+	if (!disk->bb) {
+		pr_warn("%s: failed to allocate space for badblocks\n",
+			disk->disk_name);
+		return;
+	}
+
+	if (badblocks_init(disk->bb, 1))
+		pr_warn("%s: failed to initialize badblocks\n",
+			disk->disk_name);
+}
+
 static void register_disk(struct gendisk *disk)
 {
 	struct device *ddev = disk_to_dev(disk);
@@ -609,6 +624,7 @@ void add_disk(struct gendisk *disk)
 	disk->first_minor = MINOR(devt);
 
 	disk_alloc_events(disk);
+	disk_alloc_badblocks(disk);
 
 	/* Register BDI before referencing it from bdev */
 	bdi = &disk->queue->backing_dev_info;
@@ -657,6 +673,9 @@ void del_gendisk(struct gendisk *disk)
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
 
+	badblocks_free(disk->bb);
+	kfree(disk->bb);
+
 	part_stat_set_all(&disk->part0, 0);
 	disk->part0.stamp = 0;
 
@@ -670,6 +689,48 @@ void del_gendisk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(del_gendisk);
 
+/*
+ * The gendisk usage of badblocks does not track acknowledgements for
+ * badblocks. We always assume they are acknowledged.
+ */
+int disk_check_badblocks(struct gendisk *disk, sector_t s, int sectors,
+		   sector_t *first_bad, int *bad_sectors)
+{
+	return badblocks_check(disk->bb, s, sectors, first_bad, bad_sectors);
+}
+EXPORT_SYMBOL(disk_check_badblocks);
+
+int disk_set_badblocks(struct gendisk *disk, sector_t s, int sectors)
+{
+	return badblocks_set(disk->bb, s, sectors, 1);
+}
+EXPORT_SYMBOL(disk_set_badblocks);
+
+int disk_clear_badblocks(struct gendisk *disk, sector_t s, int sectors)
+{
+	return badblocks_clear(disk->bb, s, sectors);
+}
+EXPORT_SYMBOL(disk_clear_badblocks);
+
+/* sysfs access to bad-blocks list. */
+static ssize_t disk_badblocks_show(struct device *dev,
+					struct device_attribute *attr,
+					char *page)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return badblocks_show(disk->bb, page, 0);
+}
+
+static ssize_t disk_badblocks_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *page, size_t len)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return badblocks_store(disk->bb, page, len, 0);
+}
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @devt: device to get partitioning information for
@@ -988,6 +1049,8 @@ static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(badblocks, S_IRUGO | S_IWUSR, disk_badblocks_show,
+		disk_badblocks_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -1009,6 +1072,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_badblocks.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 2adbfa6..5563bde 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -162,6 +162,7 @@ struct disk_part_tbl {
 };
 
 struct disk_events;
+struct badblocks;
 
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
@@ -201,6 +202,7 @@ struct gendisk {
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+	struct badblocks *bb;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
@@ -421,6 +423,10 @@ extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
+extern int disk_check_badblocks(struct gendisk *disk, sector_t s, int sectors,
+		   sector_t *first_bad, int *bad_sectors);
+extern int disk_set_badblocks(struct gendisk *disk, sector_t s, int sectors);
+extern int disk_clear_badblocks(struct gendisk *disk, sector_t s, int sectors);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
-- 
2.5.0

