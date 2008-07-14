From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] block: make variable and argument names more consistent
Date: Mon, 14 Jul 2008 16:12:06 +0900
Message-ID: <1216019534-29977-3-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

In hd_struct, @partno is used to denote partition number and a number
of other places use @part to denote hd_struct.  Functions use @part
and @index instead.  This causes confusion and makes it difficult to
use consistent variable names for hd_struct.  Always use @partno if a
variable represents partition number.

Also, print out functions use @f or @part for seq_file argument.  Use
@seqf instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   50 ++++++++++++++++++++++++------------------------
 block/ioctl.c         |   14 ++++++------
 fs/block_dev.c        |    8 +++---
 fs/partitions/check.c |   32 +++++++++++++++---------------
 include/linux/genhd.h |   12 +++++-----
 5 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 432c358..94c4203 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -43,14 +43,14 @@ static inline int major_to_index(int major)
 }
 
 #ifdef CONFIG_PROC_FS
-void blkdev_show(struct seq_file *f, off_t offset)
+void blkdev_show(struct seq_file *seqf, off_t offset)
 {
 	struct blk_major_name *dp;
 
 	if (offset < BLKDEV_MAJOR_HASH_SIZE) {
 		mutex_lock(&block_class_lock);
 		for (dp = major_names[offset]; dp; dp = dp->next)
-			seq_printf(f, "%3d %s\n", dp->major, dp->name);
+			seq_printf(seqf, "%3d %s\n", dp->major, dp->name);
 		mutex_unlock(&block_class_lock);
 	}
 }
@@ -157,7 +157,7 @@ void blk_unregister_region(dev_t devt, unsigned long range)
 
 EXPORT_SYMBOL(blk_unregister_region);
 
-static struct kobject *exact_match(dev_t devt, int *part, void *data)
+static struct kobject *exact_match(dev_t devt, int *partno, void *data)
 {
 	struct gendisk *p = data;
 
@@ -214,9 +214,9 @@ void unlink_gendisk(struct gendisk *disk)
  * This function gets the structure containing partitioning
  * information for the given device @dev.
  */
-struct gendisk *get_gendisk(dev_t devt, int *part)
+struct gendisk *get_gendisk(dev_t devt, int *partno)
 {
-	struct kobject *kobj = kobj_lookup(bdev_map, devt, part);
+	struct kobject *kobj = kobj_lookup(bdev_map, devt, partno);
 	struct device *dev = kobj_to_dev(kobj);
 
 	return  kobj ? dev_to_disk(dev) : NULL;
@@ -280,7 +280,7 @@ void __init printk_all_partitions(void)
 
 #ifdef CONFIG_PROC_FS
 /* iterator */
-static void *part_start(struct seq_file *part, loff_t *pos)
+static void *part_start(struct seq_file *seqf, loff_t *pos)
 {
 	loff_t k = *pos;
 	struct device *dev;
@@ -295,7 +295,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	return NULL;
 }
 
-static void *part_next(struct seq_file *part, void *v, loff_t *pos)
+static void *part_next(struct seq_file *seqf, void *v, loff_t *pos)
 {
 	struct gendisk *gp = v;
 	struct device *dev;
@@ -309,19 +309,19 @@ static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 	return NULL;
 }
 
-static void part_stop(struct seq_file *part, void *v)
+static void part_stop(struct seq_file *seqf, void *v)
 {
 	up(&block_class.sem);
 }
 
-static int show_partition(struct seq_file *part, void *v)
+static int show_partition(struct seq_file *seqf, void *v)
 {
 	struct gendisk *sgp = v;
 	int n;
 	char buf[BDEVNAME_SIZE];
 
 	if (&sgp->dev.node == block_class.devices.next)
-		seq_puts(part, "major minor  #blocks  name\n\n");
+		seq_puts(seqf, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) ||
@@ -331,7 +331,7 @@ static int show_partition(struct seq_file *part, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(part, "%4d  %4d %10llu %s\n",
+	seq_printf(seqf, "%4d  %4d %10llu %s\n",
 		sgp->major, sgp->first_minor,
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
@@ -340,7 +340,7 @@ static int show_partition(struct seq_file *part, void *v)
 			continue;
 		if (sgp->part[n]->nr_sects == 0)
 			continue;
-		seq_printf(part, "%4d  %4d %10llu %s\n",
+		seq_printf(seqf, "%4d  %4d %10llu %s\n",
 			sgp->major, n + 1 + sgp->first_minor,
 			(unsigned long long)sgp->part[n]->nr_sects >> 1 ,
 			disk_name(sgp, n + 1, buf));
@@ -358,7 +358,7 @@ const struct seq_operations partitions_op = {
 #endif
 
 
-static struct kobject *base_probe(dev_t devt, int *part, void *data)
+static struct kobject *base_probe(dev_t devt, int *partno, void *data)
 {
 	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
 		/* Make old-style 2.4 aliases work */
@@ -528,7 +528,7 @@ static struct device_type disk_type = {
  * extra fields.
  */
 
-static void *diskstats_start(struct seq_file *part, loff_t *pos)
+static void *diskstats_start(struct seq_file *seqf, loff_t *pos)
 {
 	loff_t k = *pos;
 	struct device *dev;
@@ -543,7 +543,7 @@ static void *diskstats_start(struct seq_file *part, loff_t *pos)
 	return NULL;
 }
 
-static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
+static void *diskstats_next(struct seq_file *seqf, void *v, loff_t *pos)
 {
 	struct gendisk *gp = v;
 	struct device *dev;
@@ -558,12 +558,12 @@ static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 	return NULL;
 }
 
-static void diskstats_stop(struct seq_file *part, void *v)
+static void diskstats_stop(struct seq_file *seqf, void *v)
 {
 	up(&block_class.sem);
 }
 
-static int diskstats_show(struct seq_file *s, void *v)
+static int diskstats_show(struct seq_file *seqf, void *v)
 {
 	struct gendisk *gp = v;
 	char buf[BDEVNAME_SIZE];
@@ -571,7 +571,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 
 	/*
 	if (&gp->dev.kobj.entry == block_class.devices.next)
-		seq_puts(s,	"major minor name"
+		seq_puts(seqf,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
 				"\n\n");
@@ -580,7 +580,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	preempt_disable();
 	disk_round_stats(gp);
 	preempt_enable();
-	seq_printf(s, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
+	seq_printf(seqf, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
 		gp->major, gp->first_minor, disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
@@ -602,7 +602,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 		preempt_disable();
 		part_round_stats(hd);
 		preempt_enable();
-		seq_printf(s, "%4d %4d %s %lu %lu %llu "
+		seq_printf(seqf, "%4d %4d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   gp->major, n + gp->first_minor + 1,
 			   disk_name(gp, n + 1, buf),
@@ -653,7 +653,7 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-dev_t blk_lookup_devt(const char *name, int part)
+dev_t blk_lookup_devt(const char *name, int partno)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
@@ -665,9 +665,9 @@ dev_t blk_lookup_devt(const char *name, int part)
 		if (strcmp(dev->bus_id, name) == 0) {
 			struct gendisk *disk = dev_to_disk(dev);
 
-			if (part < disk->minors)
+			if (partno < disk->minors)
 				devt = MKDEV(MAJOR(dev->devt),
-					     MINOR(dev->devt) + part);
+					     MINOR(dev->devt) + partno);
 			break;
 		}
 	}
@@ -778,10 +778,10 @@ int bdev_read_only(struct block_device *bdev)
 
 EXPORT_SYMBOL(bdev_read_only);
 
-int invalidate_partition(struct gendisk *disk, int index)
+int invalidate_partition(struct gendisk *disk, int partno)
 {
 	int res = 0;
-	struct block_device *bdev = bdget_disk(disk, index);
+	struct block_device *bdev = bdget_disk(disk, partno);
 	if (bdev) {
 		fsync_bdev(bdev);
 		res = __invalidate_device(bdev);
diff --git a/block/ioctl.c b/block/ioctl.c
index ecbdd74..54a468d 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -15,7 +15,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
 	long long start, length;
-	int part;
+	int partno;
 	int i, rc;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -27,8 +27,8 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	disk = bdev->bd_disk;
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
-	part = p.pno;
-	if (part <= 0 || part >= disk->minors)
+	partno = p.pno;
+	if (partno <= 0 || partno >= disk->minors)
 		return -EINVAL;
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
@@ -59,16 +59,16 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			}
 
 			/* all seems OK */
-			rc = add_partition(disk, part, start, length,
+			rc = add_partition(disk, partno, start, length,
 					   ADDPART_FLAG_NONE);
 
 			mutex_unlock(&bdev->bd_mutex);
 			return rc;
 
 		case BLKPG_DEL_PARTITION:
-			if (!disk->part[part-1])
+			if (!disk->part[partno - 1])
 				return -ENXIO;
-			bdevp = bdget_disk(disk, part);
+			bdevp = bdget_disk(disk, partno);
 			if (!bdevp)
 				return -ENOMEM;
 			mutex_lock(&bdevp->bd_mutex);
@@ -82,7 +82,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			invalidate_bdev(bdevp);
 
 			mutex_lock_nested(&bdev->bd_mutex, 1);
-			delete_partition(disk, part);
+			delete_partition(disk, partno);
 			mutex_unlock(&bdev->bd_mutex);
 			mutex_unlock(&bdevp->bd_mutex);
 			bdput(bdevp);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 10d8a0a..6451120 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -930,7 +930,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	struct module *owner = NULL;
 	struct gendisk *disk;
 	int ret;
-	int part;
+	int partno;
 	int perm = 0;
 
 	if (file->f_mode & FMODE_READ)
@@ -947,7 +947,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	ret = -ENXIO;
 	file->f_mapping = bdev->bd_inode->i_mapping;
 	lock_kernel();
-	disk = get_gendisk(bdev->bd_dev, &part);
+	disk = get_gendisk(bdev->bd_dev, &partno);
 	if (!disk) {
 		unlock_kernel();
 		bdput(bdev);
@@ -959,7 +959,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
 		bdev->bd_contains = bdev;
-		if (!part) {
+		if (!partno) {
 			struct backing_dev_info *bdi;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev->bd_inode, file);
@@ -987,7 +987,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			if (ret)
 				goto out_first;
 			bdev->bd_contains = whole;
-			p = disk->part[part - 1];
+			p = disk->part[partno - 1];
 			bdev->bd_inode->i_data.backing_dev_info =
 			   whole->bd_inode->i_data.backing_dev_info;
 			if (!(disk->flags & GENHD_FL_UP) || !p || !p->nr_sects) {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index b75ca08..fa27fdb 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -120,22 +120,22 @@ static int (*check_part[])(struct parsed_partitions *, struct block_device *) =
  * a pointer to that same buffer (for convenience).
  */
 
-char *disk_name(struct gendisk *hd, int part, char *buf)
+char *disk_name(struct gendisk *hd, int partno, char *buf)
 {
-	if (!part)
+	if (!partno)
 		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
 	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, part);
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
 	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, part);
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
 
 	return buf;
 }
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	int part = MINOR(bdev->bd_dev) - bdev->bd_disk->first_minor;
-	return disk_name(bdev->bd_disk, part, buf);
+	int partno = MINOR(bdev->bd_dev) - bdev->bd_disk->first_minor;
+	return disk_name(bdev->bd_disk, partno, buf);
 }
 
 EXPORT_SYMBOL(bdevname);
@@ -319,13 +319,13 @@ static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 	kobject_put(k);
 }
 
-void delete_partition(struct gendisk *disk, int part)
+void delete_partition(struct gendisk *disk, int partno)
 {
-	struct hd_struct *p = disk->part[part-1];
+	struct hd_struct *p = disk->part[partno-1];
 
 	if (!p)
 		return;
-	disk->part[part-1] = NULL;
+	disk->part[partno-1] = NULL;
 	p->start_sect = 0;
 	p->nr_sects = 0;
 	part_stat_set_all(p, 0);
@@ -342,13 +342,13 @@ static ssize_t whole_disk_show(struct device *dev,
 static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 		   whole_disk_show, NULL);
 
-int add_partition(struct gendisk *disk, int part,
+int add_partition(struct gendisk *disk, int partno,
 		  sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p = NULL;
 	int err;
 
-	if (disk->part[part - 1]) {
+	if (disk->part[partno - 1]) {
 		err = -EBUSY;
 		goto fail;
 	}
@@ -362,22 +362,22 @@ int add_partition(struct gendisk *disk, int part,
 
 	p->start_sect = start;
 	p->nr_sects = len;
-	p->partno = part;
+	p->partno = partno;
 	p->policy = disk->policy;
 
 	if (isdigit(disk->dev.bus_id[strlen(disk->dev.bus_id)-1]))
 		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-		"%sp%d", disk->dev.bus_id, part);
+		"%sp%d", disk->dev.bus_id, partno);
 	else
 		snprintf(p->dev.bus_id, BUS_ID_SIZE,
-			 "%s%d", disk->dev.bus_id, part);
+			 "%s%d", disk->dev.bus_id, partno);
 
 	device_initialize(&p->dev);
-	p->dev.devt = MKDEV(disk->major, disk->first_minor + part);
+	p->dev.devt = MKDEV(disk->major, disk->first_minor + partno);
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
-	disk->part[part-1] = p;
+	disk->part[partno-1] = p;
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 68d50a2..f8a54bb 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -363,7 +363,7 @@ extern int get_blkdev_list(char *, int);
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
-extern struct gendisk *get_gendisk(dev_t dev, int *part);
+extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
@@ -532,8 +532,8 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name, int part);
-extern char *disk_name (struct gendisk *hd, int part, char *buf);
+extern dev_t blk_lookup_devt(const char *name, int partno);
+extern char *disk_name (struct gendisk *hd, int partno, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern int add_partition(struct gendisk *, int, sector_t, sector_t, int);
@@ -551,16 +551,16 @@ extern void blk_register_region(dev_t devt, unsigned long range,
 			void *data);
 extern void blk_unregister_region(dev_t devt, unsigned long range);
 
-static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
+static inline struct block_device *bdget_disk(struct gendisk *disk, int partno)
 {
-	return bdget(MKDEV(disk->major, disk->first_minor) + index);
+	return bdget(MKDEV(disk->major, disk->first_minor) + partno);
 }
 
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
 
-static inline dev_t blk_lookup_devt(const char *name, int part)
+static inline dev_t blk_lookup_devt(const char *name, int partno)
 {
 	dev_t devt = MKDEV(0, 0);
 	return devt;
-- 
1.5.4.5

