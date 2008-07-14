From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] block: implement extended dev numbers
Date: Mon, 14 Jul 2008 16:12:11 +0900
Message-ID: <1216019534-29977-8-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbYGNHQX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:16:23 -0400
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

Implement extended device numbers.  A block driver can tell block
layer that it wants to use extended device numbers.  After the usual
minor space is used up, block layer automatically allocates devt's
from EXT_BLOCK_MAJOR.

Currently only one major number is allocated for this but as the
allocation is strictly on-demand, ~1mil minor space under it should
suffice unless the system actually has more than ~1mil partitions and
if that ever happens adding more majors to the extended devt area is
easy.

Due to internal implementation issues, the first partition can't be
allocated on the extended area.  In other words, genhd->minors should
at least be 1.  This limitation will be lifted by later changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |  119 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/partitions/check.c |   10 ++++-
 include/linux/genhd.h |   13 ++++-
 include/linux/major.h |    2 +
 4 files changed, 135 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 76961be..2511694 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -16,6 +16,7 @@
 #include <linux/kobj_map.h>
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
+#include <linux/idr.h>
 
 #include "blk.h"
 
@@ -24,6 +25,15 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 #endif
 
+/* for extended dynamic devt allocation, currently only one major is used */
+#define MAX_EXT_DEVT		(1 << MINORBITS)
+
+/* For extended devt allocation.  ext_devt_mutex prevents look up
+ * results from going away underneath its user.
+ */
+static DEFINE_MUTEX(ext_devt_mutex);
+static DEFINE_IDR(ext_devt_idr);
+
 static struct device_type disk_type;
 
 /**
@@ -288,6 +298,73 @@ EXPORT_SYMBOL(unregister_blkdev);
 
 static struct kobj_map *bdev_map;
 
+/**
+ * blk_alloc_devt - allocate a dev_t for a partition
+ * @part: partition to allocate dev_t for
+ * @gfp_mask: memory allocation flag
+ * @devt: out parameter for resulting dev_t
+ *
+ * Allocate a dev_t for block device.
+ *
+ * RETURNS:
+ * 0 on success, allocated dev_t is returned in *@devt.  -errno on
+ * failure.
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
+{
+	int idx, rc;
+
+	/* in consecutive minor range? */
+	if (part->partno < part_to_disk(part)->minors) {
+		*devt = MKDEV(part_to_disk(part)->major, part->partno);
+		return 0;
+	}
+
+	/* allocate ext devt */
+	do {
+		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
+			return -ENOMEM;
+		rc = idr_get_new(&ext_devt_idr, part, &idx);
+	} while (rc == -EAGAIN);
+
+	if (rc)
+		return rc;
+
+	if (idx > MAX_EXT_DEVT) {
+		idr_remove(&ext_devt_idr, idx);
+		return -EBUSY;
+	}
+
+	*devt = MKDEV(BLOCK_EXT_MAJOR, idx);
+	return 0;
+}
+
+/**
+ * blk_free_devt - free a dev_t
+ * @devt: dev_t to free
+ *
+ * Free @devt which was allocated using blk_alloc_devt().
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void blk_free_devt(dev_t devt)
+{
+	might_sleep();
+
+	if (devt == MKDEV(0, 0))
+		return;
+
+	if (MAJOR(devt) == BLOCK_EXT_MAJOR) {
+		mutex_lock(&ext_devt_mutex);
+		idr_remove(&ext_devt_idr, MINOR(devt));
+		mutex_unlock(&ext_devt_mutex);
+	}
+}
+
 /*
  * Register device numbers dev..(dev+range-1)
  * range must be nonzero
@@ -368,10 +445,27 @@ void unlink_gendisk(struct gendisk *disk)
  */
 struct gendisk *get_gendisk(dev_t devt, int *partno)
 {
-	struct kobject *kobj = kobj_lookup(bdev_map, devt, partno);
-	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *disk = NULL;
+
+	if (MAJOR(devt) != BLOCK_EXT_MAJOR) {
+		struct kobject *kobj;
+
+		kobj = kobj_lookup(bdev_map, devt, partno);
+		if (kobj)
+			disk = dev_to_disk(kobj_to_dev(kobj));
+	} else {
+		struct hd_struct *part;
+
+		mutex_lock(&ext_devt_mutex);
+		part = idr_find(&ext_devt_idr, MINOR(devt));
+		if (part && get_disk(part_to_disk(part))) {
+			*partno = part->partno;
+			disk = part_to_disk(part);
+		}
+		mutex_unlock(&ext_devt_mutex);
+	}
 
-	return  kobj ? dev_to_disk(dev) : NULL;
+	return disk;
 }
 
 /**
@@ -880,17 +974,29 @@ struct gendisk *alloc_disk(int minors)
 
 struct gendisk *alloc_disk_node(int minors, int node_id)
 {
+	return alloc_disk_ext_node(minors, 0, node_id);
+}
+
+struct gendisk *alloc_disk_ext(int minors, int ext_minors)
+{
+	return alloc_disk_ext_node(minors, ext_minors, -1);
+}
+
+struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
+{
 	struct gendisk *disk;
 
 	disk = kmalloc_node(sizeof(struct gendisk),
 				GFP_KERNEL | __GFP_ZERO, node_id);
 	if (disk) {
+		int tot_minors = minors + ext_minors;
+
 		if (!init_disk_stats(disk)) {
 			kfree(disk);
 			return NULL;
 		}
-		if (minors > 1) {
-			int size = (minors - 1) * sizeof(struct hd_struct *);
+		if (tot_minors > 1) {
+			int size = (tot_minors - 1) * sizeof(struct hd_struct *);
 			disk->__part = kmalloc_node(size,
 				GFP_KERNEL | __GFP_ZERO, node_id);
 			if (!disk->__part) {
@@ -900,6 +1006,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			}
 		}
 		disk->minors = minors;
+		disk->ext_minors = ext_minors;
 		rand_initialize_disk(disk);
 		disk->dev.class = &block_class;
 		disk->dev.type = &disk_type;
@@ -912,6 +1019,8 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 
 EXPORT_SYMBOL(alloc_disk);
 EXPORT_SYMBOL(alloc_disk_node);
+EXPORT_SYMBOL(alloc_disk_ext);
+EXPORT_SYMBOL(alloc_disk_ext_node);
 
 struct kobject *get_disk(struct gendisk *disk)
 {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 87c23e3..78be967 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -342,6 +342,7 @@ void delete_partition(struct gendisk *disk, int partno)
 	if (!part)
 		return;
 
+	blk_free_devt(part_devt(part));
 	rcu_assign_pointer(disk->__part[partno-1], NULL);
 	kobject_put(part->holder_dir);
 	device_del(&part->dev);
@@ -361,6 +362,7 @@ int add_partition(struct gendisk *disk, int partno,
 		  sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p = NULL;
+	dev_t devt = MKDEV(0, 0);
 	int err;
 
 	if (disk->__part[partno - 1]) {
@@ -388,10 +390,15 @@ int add_partition(struct gendisk *disk, int partno,
 			 "%s%d", disk->dev.bus_id, partno);
 
 	device_initialize(&p->dev);
-	p->dev.devt = MKDEV(disk->major, disk->first_minor + partno);
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
+
+	err = blk_alloc_devt(p, &devt);
+	if (err)
+		goto fail;
+	p->dev.devt = devt;
+
 	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(disk->__part[partno-1], p);
 
@@ -416,6 +423,7 @@ int add_partition(struct gendisk *disk, int partno,
 	return 0;
 
  fail:
+	blk_free_devt(devt);
 	if (p)
 		free_part_stats(p);
 	kfree(p);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7737468..cb6d9a7 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -114,13 +114,15 @@ struct hd_struct {
 
 
 struct gendisk {
-	/* major, first_minor and minors are input parameters only,
-	 * don't use directly.  Use disk_devt() and disk_max_parts().
+	/* major, first_minor, minors and ext_minors are input
+	 * parameters only, don't use directly.  Use disk_devt() and
+	 * disk_max_parts().
 	 */
 	int major;			/* major number of driver */
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
+	int ext_minors;			/* number of extended dynamic minors */
 
 	char disk_name[32];		/* name of major driver */
 
@@ -165,7 +167,7 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 
 static inline int disk_max_parts(struct gendisk *disk)
 {
-	return disk->minors - 1;
+	return disk->minors + disk->ext_minors - 1;
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
@@ -540,6 +542,8 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
+extern int blk_alloc_devt(struct hd_struct *part, dev_t *devt);
+extern void blk_free_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int partno);
 extern char *disk_name (struct gendisk *hd, int partno, char *buf);
 
@@ -550,6 +554,9 @@ extern void printk_all_partitions(void);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
+extern struct gendisk *alloc_disk_ext_node(int minors, int ext_minrs,
+					   int node_id);
+extern struct gendisk *alloc_disk_ext(int minors, int ext_minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
 extern void blk_register_region(dev_t devt, unsigned long range,
diff --git a/include/linux/major.h b/include/linux/major.h
index 0cb9805..d62fd67 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -170,4 +170,6 @@
 
 #define VIOTAPE_MAJOR		230
 
+#define BLOCK_EXT_MAJOR		259
+
 #endif
-- 
1.5.4.5

