From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/09] block: don't depend on consecutive minor space
Date: Mon, 25 Aug 2008 19:47:19 +0900
Message-ID: <1219661245-16055-4-git-send-email-tj@kernel.org>
References: <1219661245-16055-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121AbYHYKwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:52:49 -0400
In-Reply-To: <1219661245-16055-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

* Implement disk_devt() and part_devt() and use them to directly
  access devt instead of computing it from ->major and ->first_minor.

  Note that all references to ->major and ->first_minor outside of
  block layer is used to determine devt of the disk (the part0) and as
  ->major and ->first_minor will continue to represent devt for the
  disk, converting these users aren't strictly necessary.  However,
  convert them for consistency.

* Implement disk_max_parts() to avoid directly deferencing
  genhd->minors.

* Update bdget_disk() such that it doesn't assume consecutive minor
  space.

* Move devt computation from register_disk() to add_disk() and make it
  the only one (all other usages use the initially determined value).

These changes clean up the code and will help disk->part dereference
fix and extended block device numbers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c                       |  107 +++++++++++++++++++++++++----------
 block/ioctl.c                       |    6 +-
 drivers/block/pktcdvd.c             |    2 +-
 drivers/block/ps3disk.c             |    2 +-
 drivers/char/random.c               |    6 +-
 drivers/md/dm-ioctl.c               |    4 +-
 drivers/md/dm-stripe.c              |    4 +-
 drivers/md/dm.c                     |    7 +-
 drivers/memstick/core/mspro_block.c |    2 +-
 drivers/mmc/card/block.c            |    2 +-
 drivers/s390/block/dasd_proc.c      |    3 +-
 drivers/s390/block/dcssblk.c        |    4 +-
 drivers/scsi/sr.c                   |    2 +-
 fs/block_dev.c                      |    2 +-
 fs/partitions/check.c               |   19 ++++---
 include/linux/genhd.h               |   27 +++++++--
 16 files changed, 132 insertions(+), 67 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3a33847..d26b4b7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -186,14 +186,15 @@ void add_disk(struct gendisk *disk)
 	int retval;
 
 	disk->flags |= GENHD_FL_UP;
-	blk_register_region(MKDEV(disk->major, disk->first_minor),
-			    disk->minors, NULL, exact_match, exact_lock, disk);
+	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
+	blk_register_region(disk_devt(disk), disk->minors, NULL,
+			    exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
 	blk_register_filter(disk);
 
 	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
+	bdi_register_dev(bdi, disk_devt(disk));
 	retval = sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
 	WARN_ON(retval);
 }
@@ -207,8 +208,7 @@ void unlink_gendisk(struct gendisk *disk)
 	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
-	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
-			      disk->minors);
+	blk_unregister_region(disk_devt(disk), disk->minors);
 }
 
 /**
@@ -227,6 +227,38 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 	return  kobj ? dev_to_disk(dev) : NULL;
 }
 
+/**
+ * bdget_disk - do bdget() by gendisk and partition number
+ * @disk: gendisk of interest
+ * @partno: partition number
+ *
+ * Find partition @partno from @disk, do bdget() on it.
+ *
+ * CONTEXT:
+ * Don't care.
+ *
+ * RETURNS:
+ * Resulting block_device on success, NULL on failure.
+ */
+extern struct block_device *bdget_disk(struct gendisk *disk, int partno)
+{
+	dev_t devt = MKDEV(0, 0);
+
+	if (partno == 0)
+		devt = disk_devt(disk);
+	else {
+		struct hd_struct *part = disk->part[partno - 1];
+
+		if (part && part->nr_sects)
+			devt = part_devt(part);
+	}
+
+	if (likely(devt != MKDEV(0, 0)))
+		return bdget(devt);
+	return NULL;
+}
+EXPORT_SYMBOL(bdget_disk);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
@@ -257,7 +289,7 @@ void __init printk_all_partitions(void)
 		 * option takes.
 		 */
 		printk("%02x%02x %10llu %s",
-		       disk->major, disk->first_minor,
+		       MAJOR(disk_devt(disk)), MINOR(disk_devt(disk)),
 		       (unsigned long long)get_capacity(disk) >> 1,
 		       disk_name(disk, 0, buf));
 		if (disk->driverfs_dev != NULL &&
@@ -268,15 +300,15 @@ void __init printk_all_partitions(void)
 			printk(" (driver?)\n");
 
 		/* now show the partitions */
-		for (n = 0; n < disk->minors - 1; ++n) {
-			if (disk->part[n] == NULL)
-				continue;
-			if (disk->part[n]->nr_sects == 0)
+		for (n = 0; n < disk_max_parts(disk); ++n) {
+			struct hd_struct *part = disk->part[n];
+
+			if (!part || !part->nr_sects)
 				continue;
 			printk("  %02x%02x %10llu %s\n",
-			       disk->major, n + 1 + disk->first_minor,
-			       (unsigned long long)disk->part[n]->nr_sects >> 1,
-			       disk_name(disk, n + 1, buf));
+			       MAJOR(part_devt(part)), MINOR(part_devt(part)),
+			       (unsigned long long)part->nr_sects >> 1,
+			       disk_name(disk, part->partno, buf));
 		}
 	}
 	class_dev_iter_exit(&iter);
@@ -344,26 +376,27 @@ static int show_partition(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) ||
-			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
+	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
+				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
 	seq_printf(seqf, "%4d  %4d %10llu %s\n",
-		sgp->major, sgp->first_minor,
+		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
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
 		seq_printf(seqf, "%4d  %4d %10llu %s\n",
-			sgp->major, n + 1 + sgp->first_minor,
-			(unsigned long long)sgp->part[n]->nr_sects >> 1 ,
-			disk_name(sgp, n + 1, buf));
+			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
+			   (unsigned long long)part->nr_sects >> 1,
+			   disk_name(sgp, part->partno, buf));
 	}
 
 	return 0;
@@ -579,7 +612,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	disk_round_stats(gp);
 	preempt_enable();
 	seq_printf(seqf, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
-		gp->major, gp->first_minor, disk_name(gp, 0, buf),
+		MAJOR(disk_devt(gp)), MINOR(disk_devt(gp)),
+		disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
 		jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
@@ -591,7 +625,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		jiffies_to_msecs(disk_stat_read(gp, time_in_queue)));
 
 	/* now show all non-0 size partitions of it */
-	for (n = 0; n < gp->minors - 1; n++) {
+	for (n = 0; n < disk_max_parts(gp); n++) {
 		struct hd_struct *hd = gp->part[n];
 
 		if (!hd || !hd->nr_sects)
@@ -602,8 +636,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		preempt_enable();
 		seq_printf(seqf, "%4d %4d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
-			   gp->major, n + gp->first_minor + 1,
-			   disk_name(gp, n + 1, buf),
+			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
+			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[0]),
 			   part_stat_read(hd, merges[0]),
 			   (unsigned long long)part_stat_read(hd, sectors[0]),
@@ -662,11 +696,22 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct gendisk *disk = dev_to_disk(dev);
 
-		if (!strcmp(dev->bus_id, name) && partno < disk->minors) {
-			devt = MKDEV(MAJOR(dev->devt),
-				     MINOR(dev->devt) + partno);
-			break;
+		if (strcmp(dev->bus_id, name))
+			continue;
+		if (partno < 0 || partno > disk_max_parts(disk))
+			continue;
+
+		if (partno == 0)
+			devt = disk_devt(disk);
+		else {
+			struct hd_struct *part = disk->part[partno - 1];
+
+			if (!part || !part->nr_sects)
+				continue;
+
+			devt = part_devt(part);
 		}
+		break;
 	}
 	class_dev_iter_exit(&iter);
 	return devt;
@@ -756,7 +801,7 @@ void set_disk_ro(struct gendisk *disk, int flag)
 {
 	int i;
 	disk->policy = flag;
-	for (i = 0; i < disk->minors - 1; i++)
+	for (i = 0; i < disk_max_parts(disk); i++)
 		if (disk->part[i]) disk->part[i]->policy = flag;
 }
 
diff --git a/block/ioctl.c b/block/ioctl.c
index d77f5e2..403f7d7 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -29,7 +29,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	partno = p.pno;
-	if (partno <= 0 || partno >= disk->minors)
+	if (partno <= 0 || partno > disk_max_parts(disk))
 		return -EINVAL;
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
@@ -47,7 +47,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			mutex_lock(&bdev->bd_mutex);
 
 			/* overlap? */
-			for (i = 0; i < disk->minors - 1; i++) {
+			for (i = 0; i < disk_max_parts(disk); i++) {
 				struct hd_struct *s = disk->part[i];
 
 				if (!s)
@@ -96,7 +96,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (disk->minors == 1 || bdev != bdev->bd_contains)
+	if (!disk_max_parts(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 158eed4..19c739d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2919,7 +2919,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	if (!disk->queue)
 		goto out_mem2;
 
-	pd->pkt_dev = MKDEV(disk->major, disk->first_minor);
+	pd->pkt_dev = MKDEV(pktdev_major, idx);
 	ret = pkt_new_dev(pd, dev);
 	if (ret)
 		goto out_new_dev;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 4b0d6c7..936466f 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -541,7 +541,7 @@ static int ps3disk_remove(struct ps3_system_bus_device *_dev)
 	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 
 	mutex_lock(&ps3disk_mask_mutex);
-	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
+	__clear_bit(MINOR(disk_devt(priv->gendisk)) / PS3DISK_MINORS,
 		    &ps3disk_mask);
 	mutex_unlock(&ps3disk_mask_mutex);
 	del_gendisk(priv->gendisk);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index e0d0e37..6c6282c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -660,10 +660,10 @@ void add_disk_randomness(struct gendisk *disk)
 	if (!disk || !disk->random)
 		return;
 	/* first major is 1, so we get >= 0x200 here */
-	DEBUG_ENT("disk event %d:%d\n", disk->major, disk->first_minor);
+	DEBUG_ENT("disk event %d:%d\n",
+		  MAJOR(disk_devt(disk)), MINOR(disk_devt(disk)));
 
-	add_timer_randomness(disk->random,
-			     0x100 + MKDEV(disk->major, disk->first_minor));
+	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
 }
 #endif
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b262c00..c3de311 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -426,7 +426,7 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
 				old_nl->next = (uint32_t) ((void *) nl -
 							   (void *) old_nl);
 			disk = dm_disk(hc->md);
-			nl->dev = huge_encode_dev(MKDEV(disk->major, disk->first_minor));
+			nl->dev = huge_encode_dev(disk_devt(disk));
 			nl->next = 0;
 			strcpy(nl->name, hc->name);
 
@@ -539,7 +539,7 @@ static int __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	if (dm_suspended(md))
 		param->flags |= DM_SUSPEND_FLAG;
 
-	param->dev = huge_encode_dev(MKDEV(disk->major, disk->first_minor));
+	param->dev = huge_encode_dev(disk_devt(disk));
 
 	/*
 	 * Yes, this will be out of date by the time it gets back
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 4de90ab..b745d8a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -284,8 +284,8 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio,
 
 	memset(major_minor, 0, sizeof(major_minor));
 	sprintf(major_minor, "%d:%d",
-		bio->bi_bdev->bd_disk->major,
-		bio->bi_bdev->bd_disk->first_minor);
+		MAJOR(disk_devt(bio->bi_bdev->bd_disk)),
+		MINOR(disk_devt(bio->bi_bdev->bd_disk)));
 
 	/*
 	 * Test to see which stripe drive triggered the event
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bca448e..b4ddb96 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1142,7 +1142,7 @@ static void unlock_fs(struct mapped_device *md);
 
 static void free_dev(struct mapped_device *md)
 {
-	int minor = md->disk->first_minor;
+	int minor = MINOR(disk_devt(md->disk));
 
 	if (md->suspended_bdev) {
 		unlock_fs(md);
@@ -1263,7 +1263,7 @@ static struct mapped_device *dm_find_md(dev_t dev)
 
 	md = idr_find(&_minor_idr, minor);
 	if (md && (md == MINOR_ALLOCED ||
-		   (dm_disk(md)->first_minor != minor) ||
+		   (MINOR(disk_devt(dm_disk(md))) != minor) ||
 		   test_bit(DMF_FREEING, &md->flags))) {
 		md = NULL;
 		goto out;
@@ -1314,7 +1314,8 @@ void dm_put(struct mapped_device *md)
 
 	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
 		map = dm_get_table(md);
-		idr_replace(&_minor_idr, MINOR_ALLOCED, dm_disk(md)->first_minor);
+		idr_replace(&_minor_idr, MINOR_ALLOCED,
+			    MINOR(disk_devt(dm_disk(md))));
 		set_bit(DMF_FREEING, &md->flags);
 		spin_unlock(&_minor_lock);
 		if (!dm_suspended(md)) {
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 44b1817..95bbd3b 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -195,7 +195,7 @@ static int mspro_block_bd_open(struct inode *inode, struct file *filp)
 static int mspro_block_disk_release(struct gendisk *disk)
 {
 	struct mspro_block_data *msb = disk->private_data;
-	int disk_id = disk->first_minor >> MEMSTICK_PART_SHIFT;
+	int disk_id = MINOR(disk_devt(disk)) >> MEMSTICK_PART_SHIFT;
 
 	mutex_lock(&mspro_block_disk_lock);
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 86dbb36..1cb6114 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -83,7 +83,7 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 	mutex_lock(&open_lock);
 	md->usage--;
 	if (md->usage == 0) {
-		int devidx = md->disk->first_minor >> MMC_SHIFT;
+		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
 		__clear_bit(devidx, dev_use);
 
 		put_disk(md->disk);
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 03c0e40..e3b5c4d 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -76,7 +76,8 @@ dasd_devices_show(struct seq_file *m, void *v)
 	/* Print kdev. */
 	if (block->gdp)
 		seq_printf(m, " at (%3d:%6d)",
-			   block->gdp->major, block->gdp->first_minor);
+			   MAJOR(disk_devt(block->gdp)),
+			   MINOR(disk_devt(block->gdp)));
 	else
 		seq_printf(m, "  at (???:??????)");
 	/* Print device name. */
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 01fcdd9..805cd01 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -114,7 +114,7 @@ dcssblk_assign_free_minor(struct dcssblk_dev_info *dev_info)
 		found = 0;
 		// test if minor available
 		list_for_each_entry(entry, &dcssblk_devices, lh)
-			if (minor == entry->gd->first_minor)
+			if (minor == MINOR(disk_devt(entry->gd)))
 				found++;
 		if (!found) break; // got unused minor
 	}
@@ -392,7 +392,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		goto unload_seg;
 	}
 	sprintf(dev_info->gd->disk_name, "dcssblk%d",
-		dev_info->gd->first_minor);
+		MINOR(disk_devt(dev_info->gd)));
 	list_add_tail(&dev_info->lh, &dcssblk_devices);
 
 	if (!try_module_get(THIS_MODULE)) {
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 27f5bfd..8dbe379 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -878,7 +878,7 @@ static void sr_kref_release(struct kref *kref)
 	struct gendisk *disk = cd->disk;
 
 	spin_lock(&sr_index_lock);
-	clear_bit(disk->first_minor, sr_index_bits);
+	clear_bit(MINOR(disk_devt(disk)), sr_index_bits);
 	spin_unlock(&sr_index_lock);
 
 	unregister_cdrom(&cd->cdi);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index de0776c..72e0a28 100644
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
index db56f5f..0f33955 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -134,7 +134,11 @@ char *disk_name(struct gendisk *hd, int partno, char *buf)
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	int partno = MINOR(bdev->bd_dev) - bdev->bd_disk->first_minor;
+	int partno = 0;
+
+	if (bdev->bd_part)
+		partno = bdev->bd_part->partno;
+
 	return disk_name(bdev->bd_disk, partno, buf);
 }
 
@@ -169,7 +173,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
-	state->limit = hd->minors;
+	state->limit = disk_max_parts(hd) + 1;
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
@@ -416,7 +420,6 @@ void register_disk(struct gendisk *disk)
 	int err;
 
 	disk->dev.parent = disk->driverfs_dev;
-	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
 
 	strlcpy(disk->dev.bus_id, disk->disk_name, BUS_ID_SIZE);
 	/* ewww... some of these buggers have / in the name... */
@@ -440,7 +443,7 @@ void register_disk(struct gendisk *disk)
 	disk_sysfs_add_subdirs(disk);
 
 	/* No minors to use for partitions */
-	if (disk->minors == 1)
+	if (!disk_max_parts(disk))
 		goto exit;
 
 	/* No such device (e.g., media were just removed) */
@@ -463,8 +466,8 @@ exit:
 	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
-	for (i = 1; i < disk->minors; i++) {
-		p = disk->part[i-1];
+	for (i = 0; i < disk_max_parts(disk); i++) {
+		p = disk->part[i];
 		if (!p || !p->nr_sects)
 			continue;
 		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
@@ -482,7 +485,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	if (res)
 		return res;
 	bdev->bd_invalidated = 0;
-	for (p = 1; p < disk->minors; p++)
+	for (p = 1; p <= disk_max_parts(disk); p++)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
@@ -545,7 +548,7 @@ void del_gendisk(struct gendisk *disk)
 	int p;
 
 	/* invalidate stuff */
-	for (p = disk->minors - 1; p > 0; p--) {
+	for (p = disk_max_parts(disk); p > 0; p--) {
 		invalidate_partition(disk, p);
 		delete_partition(disk, p);
 	}
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6bfff7a..6cb34ba 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -120,10 +120,14 @@ struct blk_scsi_cmd_filter {
 };
 
 struct gendisk {
+	/* major, first_minor and minors are input parameters only,
+	 * don't use directly.  Use disk_devt() and disk_max_parts().
+	 */
 	int major;			/* major number of driver */
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
+
 	char disk_name[32];		/* name of major driver */
 	struct hd_struct **part;	/* [indexed by minor - 1] */
 	struct block_device_operations *fops;
@@ -162,6 +166,21 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
+static inline int disk_max_parts(struct gendisk *disk)
+{
+	return disk->minors - 1;
+}
+
+static inline dev_t disk_devt(struct gendisk *disk)
+{
+	return disk->dev.devt;
+}
+
+static inline dev_t part_devt(struct hd_struct *part)
+{
+	return part->dev.devt;
+}
+
 /* 
  * Macros to operate on percpu disk statistics:
  *
@@ -173,7 +192,7 @@ static inline struct hd_struct *disk_map_sector(struct gendisk *gendiskp,
 {
 	struct hd_struct *part;
 	int i;
-	for (i = 0; i < gendiskp->minors - 1; i++) {
+	for (i = 0; i < disk_max_parts(gendiskp); i++) {
 		part = gendiskp->part[i];
 		if (part && part->start_sect <= sector
 		    && sector < part->start_sect + part->nr_sects)
@@ -376,6 +395,7 @@ extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
+extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
@@ -563,11 +583,6 @@ extern void blk_register_region(dev_t devt, unsigned long range,
 			void *data);
 extern void blk_unregister_region(dev_t devt, unsigned long range);
 
-static inline struct block_device *bdget_disk(struct gendisk *disk, int partno)
-{
-	return bdget(MKDEV(disk->major, disk->first_minor) + partno);
-}
-
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
-- 
1.5.4.5

