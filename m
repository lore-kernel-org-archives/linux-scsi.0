From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] block: implement extended minors
Date: Thu,  3 Jul 2008 17:33:03 +0900
Message-ID: <1215073986-4709-4-git-send-email-tj@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Implement extended minors.  A block driver can tell block layer that
it wants to use extended minors.  After the usual minor space is used
up, block layer automatically allocates devt from EXT_BLOCK_MAJOR.

Currently only one major number is allocated for this but as the
allocation is on-demand so ~1mil minor space under it should suffice
for most cases.

For internal implementation simplicity, the first partition can't be
allocated on the extended area.  In other words, genhd->minors should
at least be 1.  Lifting this restriction shouldn't be too difficult.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |  118 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/partitions/check.c |   11 +++++
 include/linux/genhd.h |    8 +++-
 include/linux/major.h |    2 +
 4 files changed, 134 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e7310ba..97cc5e4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -16,6 +16,7 @@
 #include <linux/kobj_map.h>
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
+#include <linux/idr.h>
 
 #include "blk.h"
 
@@ -24,6 +25,10 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 #endif
 
+/* for extended dynamic devt allocation, currently only one major is used */
+#define MAX_EXT_DEVT		(1 << MINORBITS)
+static DEFINE_IDR(ext_devt_idr);
+
 static struct device_type disk_type;
 
 /*
@@ -136,6 +141,65 @@ EXPORT_SYMBOL(unregister_blkdev);
 
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
+ * Determined by @gfp_mask.
+ */
+int blk_alloc_devt(struct hd_struct *part, gfp_t gfp_mask, dev_t *devt)
+{
+	int idx, rc;
+
+	if (part->partno < part->disk->minors) {
+		*devt = MKDEV(part->disk->major, part->partno);
+		return 0;
+	}
+
+	while (true) {
+		if (!idr_pre_get(&ext_devt_idr, gfp_mask))
+			return -ENOMEM;
+
+		rc = idr_get_new(&ext_devt_idr, part, &idx);
+		if (rc == 0)
+			break;
+		if (rc && rc != -EAGAIN)
+			return rc;
+	}
+
+	if (idx > MAX_EXT_DEVT) {
+		idr_remove(&ext_devt_idr, idx);
+		return -EBUSY;
+	}
+
+	*devt = MKDEV(EXT_BLOCK_MAJOR, idx);
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
+ * Don't care.
+ */
+void blk_free_devt(dev_t devt)
+{
+	if (MAJOR(devt) == EXT_BLOCK_MAJOR)
+		idr_remove(&ext_devt_idr, MINOR(devt));
+}
+
 /*
  * Register device numbers dev..(dev+range-1)
  * range must be nonzero
@@ -368,12 +432,43 @@ static struct kobject *base_probe(dev_t devt, int *part, void *data)
 	return NULL;
 }
 
+static struct kobject *ext_probe(dev_t devt, int *idx, void *data)
+{
+	struct hd_struct *part;
+
+	part = idr_find(&ext_devt_idr, MINOR(devt));
+	if (unlikely(!part))
+		return NULL;
+
+	*idx = part->partno;
+	return &part->disk->dev.kobj;
+}
+
+static int ext_lock(dev_t devt, void *data)
+{
+	struct hd_struct *part;
+
+	part = idr_find(&ext_devt_idr, MINOR(devt));
+	if (likely(part && get_disk(part->disk)))
+		return 0;
+	return -1;
+}
+
 static int __init genhd_device_init(void)
 {
-	int error = class_register(&block_class);
+	int error;
+
+	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
+
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
+	if (!bdev_map)
+		return -ENOMEM;
+
+	blk_register_region(MKDEV(EXT_BLOCK_MAJOR, 0), 1 << MINORBITS, NULL,
+			    ext_probe, ext_lock, NULL);
+
 	blk_dev_init();
 
 #ifndef CONFIG_SYSFS_DEPRECATED
@@ -691,22 +786,34 @@ EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *alloc_disk(int minors)
 {
-	return alloc_disk_node(minors, -1);
+	return alloc_disk_ext(minors, 0);
 }
 
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
 			disk->part = kmalloc_node(size,
 				GFP_KERNEL | __GFP_ZERO, node_id);
 			if (!disk->part) {
@@ -716,6 +823,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			}
 		}
 		disk->minors = minors;
+		disk->ext_minors = ext_minors;
 		rand_initialize_disk(disk);
 		disk->dev.class = &block_class;
 		disk->dev.type = &disk_type;
@@ -728,6 +836,8 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 
 EXPORT_SYMBOL(alloc_disk);
 EXPORT_SYMBOL(alloc_disk_node);
+EXPORT_SYMBOL(alloc_disk_ext);
+EXPORT_SYMBOL(alloc_disk_ext_node);
 
 struct kobject *get_disk(struct gendisk *disk)
 {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 994a621..15d231f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -331,6 +331,7 @@ void delete_partition(struct gendisk *disk, int part)
 		return;
 	if (!p->nr_sects)
 		return;
+	blk_free_devt(p->dev.devt);
 	disk->part[part-1] = NULL;
 	p->start_sect = 0;
 	p->nr_sects = 0;
@@ -386,6 +387,16 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
+
+	err = blk_alloc_devt(p, GFP_KERNEL, &p->dev.devt);
+	if (err) {
+		printk(KERN_WARNING "%s: failed to to allocate MAJOR:MINOR "
+		       "(part=%d, err=%d)\n", name, part, err);
+		free_part_stats(p);
+		kfree(p);
+		return;
+	}
+
 	disk->part[part-1] = p;
 
 	/* delay uevent until 'holders' subdir is created */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 1db5740..a1843e6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -117,6 +117,7 @@ struct gendisk {
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
+	int ext_minors;			/* number of extended dynamic minors */
 	char disk_name[32];		/* name of major driver */
 	struct hd_struct **part;	/* [indexed by minor - 1] */
 	struct block_device_operations *fops;
@@ -146,7 +147,7 @@ struct gendisk {
 
 static inline int disk_max_parts(struct gendisk *disk)
 {
-	return disk->minors - 1;
+	return disk->minors + disk->ext_minors - 1;
 }
 
 static inline int disk_major(struct gendisk *disk)
@@ -551,6 +552,8 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
+extern int blk_alloc_devt(struct hd_struct *part, gfp_t gfp_mask, dev_t *devt);
+extern void blk_free_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
@@ -561,6 +564,9 @@ extern void printk_all_partitions(void);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
+extern struct gendisk *alloc_disk_ext_node(int minors, int ext_minrs,
+					   int node_id);
+extern struct gendisk *alloc_disk_ext(int minors, int ext_minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
 extern void blk_register_region(dev_t devt, unsigned long range,
diff --git a/include/linux/major.h b/include/linux/major.h
index 0cb9805..e7fa573 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -170,4 +170,6 @@
 
 #define VIOTAPE_MAJOR		230
 
+#define EXT_BLOCK_MAJOR		259
+
 #endif
-- 
1.5.4.5

