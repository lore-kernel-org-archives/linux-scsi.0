From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] block: don't depend on consecutive minor space
Date: Thu,  3 Jul 2008 17:33:02 +0900
Message-ID: <1215073986-4709-3-git-send-email-tj@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbYGCNGN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 09:06:13 -0400
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>

Implement disk_major(), disk_minor(), part_major() and part_minor()
and use them to directly access devt instead of computing it from
first_minor.

While at it, implement disk_max_parts() to avoid directly deferencing
genhd->minors.

These changes are to enable extended block minors.a

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   80 ++++++++++++++++++++++++++++---------------------
 block/ioctl.c         |    6 ++--
 fs/block_dev.c        |    2 +-
 fs/partitions/check.c |   22 +++++++------
 include/linux/genhd.h |   27 ++++++++++++++++-
 5 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b922d48..e7310ba 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -185,13 +185,14 @@ void add_disk(struct gendisk *disk)
 	struct backing_dev_info *bdi;
 
 	disk->flags |= GENHD_FL_UP;
-	blk_register_region(MKDEV(disk->major, disk->first_minor),
-			    disk->minors, NULL, exact_match, exact_lock, disk);
+	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
+	blk_register_region(disk->dev.devt, disk->minors, NULL,
+			    exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
 
 	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
+	bdi_register_dev(bdi, disk->dev.devt);
 	sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
 }
 
@@ -203,8 +204,7 @@ void unlink_gendisk(struct gendisk *disk)
 	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
-	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
-			      disk->minors);
+	blk_unregister_region(disk->dev.devt, disk->minors);
 }
 
 /**
@@ -252,7 +252,7 @@ void __init printk_all_partitions(void)
 		 * hex - the same format as the root= option takes.
 		 */
 		printk("%02x%02x %10llu %s",
-			sgp->major, sgp->first_minor,
+			disk_major(sgp), disk_minor(sgp),
 			(unsigned long long)get_capacity(sgp) >> 1,
 			disk_name(sgp, 0, buf));
 		if (sgp->driverfs_dev != NULL &&
@@ -263,13 +263,14 @@ void __init printk_all_partitions(void)
 			printk(" (driver?)\n");
 
 		/* now show the partitions */
-		for (n = 0; n < sgp->minors - 1; ++n) {
-			if (sgp->part[n] == NULL)
-				continue;
-			if (sgp->part[n]->nr_sects == 0)
+		for (n = 0; n < disk_max_parts(sgp); ++n) {
+			struct hd_struct *part = sgp->part[n];
+
+			if (!part || !part->nr_sects)
 				continue;
+
 			printk("  %02x%02x %10llu %s\n",
-				sgp->major, n + 1 + sgp->first_minor,
+				part_major(part), part_minor(part),
 				(unsigned long long)sgp->part[n]->nr_sects >> 1,
 				disk_name(sgp, n + 1, buf));
 		}
@@ -314,35 +315,36 @@ static void part_stop(struct seq_file *part, void *v)
 	mutex_unlock(&block_class_lock);
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
-	if (!get_capacity(sgp) ||
-			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
+	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
+				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(part, "%4d  %4d %10llu %s\n",
-		sgp->major, sgp->first_minor,
+	seq_printf(seqf, "%4d  %4d %10llu %s\n",
+		disk_major(sgp), disk_minor(sgp),
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
-	for (n = 0; n < sgp->minors - 1; n++) {
-		if (!sgp->part[n])
+	for (n = 0; n < disk_max_parts(sgp); n++) {
+		struct hd_struct *part = sgp->part[n];
+		if (!part)
 			continue;
-		if (sgp->part[n]->nr_sects == 0)
+		if (part->nr_sects == 0)
 			continue;
-		seq_printf(part, "%4d  %4d %10llu %s\n",
-			sgp->major, n + 1 + sgp->first_minor,
-			(unsigned long long)sgp->part[n]->nr_sects >> 1 ,
+		seq_printf(seqf, "%4d  %4d %10llu %s\n",
+			part_major(part), part_minor(part),
+			(unsigned long long)part->nr_sects >> 1,
 			disk_name(sgp, n + 1, buf));
 	}
 
@@ -581,7 +583,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	disk_round_stats(gp);
 	preempt_enable();
 	seq_printf(s, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
-		gp->major, n + gp->first_minor, disk_name(gp, n, buf),
+		disk_major(gp), disk_minor(gp), disk_name(gp, n, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
 		jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
@@ -593,7 +595,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 		jiffies_to_msecs(disk_stat_read(gp, time_in_queue)));
 
 	/* now show all non-0 size partitions of it */
-	for (n = 0; n < gp->minors - 1; n++) {
+	for (n = 0; n < disk_max_parts(gp); n++) {
 		struct hd_struct *hd = gp->part[n];
 
 		if (!hd || !hd->nr_sects)
@@ -604,7 +606,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 		preempt_enable();
 		seq_printf(s, "%4d %4d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
-			   gp->major, n + gp->first_minor + 1,
+			   part_major(hd), part_minor(hd),
 			   disk_name(gp, n + 1, buf),
 			   part_stat_read(hd, ios[0]),
 			   part_stat_read(hd, merges[0]),
@@ -653,23 +655,33 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-dev_t blk_lookup_devt(const char *name, int part)
+dev_t blk_lookup_devt(const char *name, int partno)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
 
 	mutex_lock(&block_class_lock);
 	list_for_each_entry(dev, &block_class.devices, node) {
+		struct gendisk *disk = dev_to_disk(dev);
+
 		if (dev->type != &disk_type)
 			continue;
-		if (strcmp(dev->bus_id, name) == 0) {
-			struct gendisk *disk = dev_to_disk(dev);
+		if (strcmp(dev->bus_id, name))
+			continue;
+		if (partno < 0 || partno > disk_max_parts(disk))
+			continue;
 
-			if (part < disk->minors)
-				devt = MKDEV(MAJOR(dev->devt),
-					     MINOR(dev->devt) + part);
-			break;
+		if (partno == 0)
+			devt = disk->dev.devt;
+		else {
+			struct hd_struct *part = disk->part[partno - 1];
+
+			if (!part || !part->nr_sects)
+				continue;
+
+			devt = part->dev.devt;
 		}
+		break;
 	}
 	mutex_unlock(&block_class_lock);
 
@@ -760,7 +772,7 @@ void set_disk_ro(struct gendisk *disk, int flag)
 {
 	int i;
 	disk->policy = flag;
-	for (i = 0; i < disk->minors - 1; i++)
+	for (i = 0; i < disk_max_parts(disk); i++)
 		if (disk->part[i]) disk->part[i]->policy = flag;
 }
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..9b008a2 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -28,7 +28,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	part = p.pno;
-	if (part <= 0 || part >= disk->minors)
+	if (part <= 0 || part > disk_max_parts(disk))
 		return -EINVAL;
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
@@ -49,7 +49,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				return -EBUSY;
 			}
 			/* overlap? */
-			for (i = 0; i < disk->minors - 1; i++) {
+			for (i = 0; i < disk_max_parts(disk); i++) {
 				struct hd_struct *s = disk->part[i];
 
 				if (!s)
@@ -99,7 +99,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (disk->minors == 1 || bdev != bdev->bd_contains)
+	if (!disk_max_parts(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 10d8a0a..215e4be 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -892,7 +892,7 @@ int check_disk_change(struct block_device *bdev)
 
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
-	if (bdev->bd_disk->minors > 1)
+	if (disk_max_parts(bdev->bd_disk))
 		bdev->bd_invalidated = 1;
 	return 1;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index b915ac2..994a621 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -134,8 +134,12 @@ char *disk_name(struct gendisk *hd, int part, char *buf)
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	int part = MINOR(bdev->bd_dev) - bdev->bd_disk->first_minor;
-	return disk_name(bdev->bd_disk, part, buf);
+	int partno = 0;
+
+	if (bdev->bd_part)
+		partno = bdev->bd_part->partno;
+
+	return disk_name(bdev->bd_disk, partno, buf);
 }
 
 EXPORT_SYMBOL(bdevname);
@@ -169,7 +173,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
-	state->limit = hd->minors;
+	state->limit = disk_max_parts(hd) + 1;
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
@@ -379,7 +383,6 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 			 "%s%d", disk->dev.bus_id, part);
 
 	device_initialize(&p->dev);
-	p->dev.devt = MKDEV(disk->major, disk->first_minor + part);
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
@@ -408,7 +411,6 @@ void register_disk(struct gendisk *disk)
 	int err;
 
 	disk->dev.parent = disk->driverfs_dev;
-	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
 
 	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
 	/* ewww... some of these buggers have / in the name... */
@@ -432,7 +434,7 @@ void register_disk(struct gendisk *disk)
 	disk_sysfs_add_subdirs(disk);
 
 	/* No minors to use for partitions */
-	if (disk->minors == 1)
+	if (!disk_max_parts(disk))
 		goto exit;
 
 	/* No such device (e.g., media were just removed) */
@@ -455,8 +457,8 @@ exit:
 	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
-	for (i = 1; i < disk->minors; i++) {
-		p = disk->part[i-1];
+	for (i = 0; i < disk_max_parts(disk); i++) {
+		p = disk->part[i];
 		if (!p || !p->nr_sects)
 			continue;
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
@@ -474,7 +476,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	if (res)
 		return res;
 	bdev->bd_invalidated = 0;
-	for (p = 1; p < disk->minors; p++)
+	for (p = 1; p <= disk_max_parts(disk); p++)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
@@ -531,7 +533,7 @@ void del_gendisk(struct gendisk *disk)
 	int p;
 
 	/* invalidate stuff */
-	for (p = disk->minors - 1; p > 0; p--) {
+	for (p = disk_max_parts(disk); p > 0; p--) {
 		invalidate_partition(disk, p);
 		delete_partition(disk, p);
 	}
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 1f06681..1db5740 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -144,6 +144,31 @@ struct gendisk {
 	struct work_struct async_notify;
 };
 
+static inline int disk_max_parts(struct gendisk *disk)
+{
+	return disk->minors - 1;
+}
+
+static inline int disk_major(struct gendisk *disk)
+{
+	return MAJOR(disk->dev.devt);
+}
+
+static inline int disk_minor(struct gendisk *disk)
+{
+	return MINOR(disk->dev.devt);
+}
+
+static inline int part_major(struct hd_struct *part)
+{
+	return MAJOR(part->dev.devt);
+}
+
+static inline int part_minor(struct hd_struct *part)
+{
+	return MINOR(part->dev.devt);
+}
+
 /* 
  * Macros to operate on percpu disk statistics:
  *
@@ -155,7 +180,7 @@ static inline struct hd_struct *get_part(struct gendisk *gendiskp,
 {
 	struct hd_struct *part;
 	int i;
-	for (i = 0; i < gendiskp->minors - 1; i++) {
+	for (i = 0; i < disk_max_parts(gendiskp); i++) {
 		part = gendiskp->part[i];
 		if (part && part->start_sect <= sector
 		    && sector < part->start_sect + part->nr_sects)
-- 
1.5.4.5

