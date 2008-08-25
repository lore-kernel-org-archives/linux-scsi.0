From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/09] block: adjust formatting for large minors and add ext_range sysfs attr
Date: Mon, 25 Aug 2008 19:47:23 +0900
Message-ID: <1219661245-16055-8-git-send-email-tj@kernel.org>
References: <1219661245-16055-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661245-16055-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

With extended minors and the soon-to-follow debug feature, large minor
numbers for block devices will be common.  This patch does the
followings to make printouts pretty.

* Adapt print formats such that large minors don't break the
  formatting.

* For extended MAJ:MIN, %02x%02x for MAJ:MIN used in
  printk_all_partitions() doesn't cut it anymore.  Update it such that
  %03x:%05x is used if either MAJ or MIN doesn't fit in %02x.

* Implement ext_range sysfs attribute which shows total minors the
  device can use including both conventional minor space and the
  extended one.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c      |   47 +++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |    1 +
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e730dc0..93ebc6c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -366,6 +366,18 @@ void blk_free_devt(dev_t devt)
 	}
 }
 
+static char *bdevt_str(dev_t devt, char *buf)
+{
+	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
+		char tbuf[BDEVT_SIZE];
+		snprintf(tbuf, BDEVT_SIZE, "%02x%02x", MAJOR(devt), MINOR(devt));
+		snprintf(buf, BDEVT_SIZE, "%-9s", tbuf);
+	} else
+		snprintf(buf, BDEVT_SIZE, "%03x:%05x", MAJOR(devt), MINOR(devt));
+
+	return buf;
+}
+
 /*
  * Register device numbers dev..(dev+range-1)
  * range must be nonzero
@@ -523,7 +535,8 @@ void __init printk_all_partitions(void)
 		struct gendisk *disk = dev_to_disk(dev);
 		struct disk_part_iter piter;
 		struct hd_struct *part;
-		char buf[BDEVNAME_SIZE];
+		char name_buf[BDEVNAME_SIZE];
+		char devt_buf[BDEVT_SIZE];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -538,10 +551,10 @@ void __init printk_all_partitions(void)
 		 * numbers in hex - the same format as the root=
 		 * option takes.
 		 */
-		printk("%02x%02x %10llu %s",
-		       MAJOR(disk_devt(disk)), MINOR(disk_devt(disk)),
+		printk("%s %10llu %s",
+		       bdevt_str(disk_devt(disk), devt_buf),
 		       (unsigned long long)get_capacity(disk) >> 1,
-		       disk_name(disk, 0, buf));
+		       disk_name(disk, 0, name_buf));
 		if (disk->driverfs_dev != NULL &&
 		    disk->driverfs_dev->driver != NULL)
 			printk(" driver: %s\n",
@@ -552,10 +565,10 @@ void __init printk_all_partitions(void)
 		/* now show the partitions */
 		disk_part_iter_init(&piter, disk, 0);
 		while ((part = disk_part_iter_next(&piter)))
-			printk("  %02x%02x %10llu %s\n",
-			       MAJOR(part_devt(part)), MINOR(part_devt(part)),
+			printk("  %s %10llu %s\n",
+			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, buf));
+			       disk_name(disk, part->partno, name_buf));
 		disk_part_iter_exit(&piter);
 	}
 	class_dev_iter_exit(&iter);
@@ -612,7 +625,7 @@ static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
 
 	p = disk_seqf_start(seqf, pos);
 	if (!IS_ERR(p) && p)
-		seq_puts(part, "major minor  #blocks  name\n\n");
+		seq_puts(seqf, "major   minor   #blocks  name\n\n");
 	return p;
 }
 
@@ -631,14 +644,14 @@ static int show_partition(struct seq_file *seqf, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(seqf, "%4d  %4d %10llu %s\n",
+	seq_printf(seqf, "%4d  %7d %10llu %s\n",
 		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
 
 	disk_part_iter_init(&piter, sgp, 0);
 	while ((part = disk_part_iter_next(&piter)))
-		seq_printf(seqf, "%4d  %4d %10llu %s\n",
+		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
 			   (unsigned long long)part->nr_sects >> 1,
 			   disk_name(sgp, part->partno, buf));
@@ -692,6 +705,14 @@ static ssize_t disk_range_show(struct device *dev,
 	return sprintf(buf, "%d\n", disk->minors);
 }
 
+static ssize_t disk_ext_range_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%d\n", disk_max_parts(disk) + 1);
+}
+
 static ssize_t disk_removable_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -781,6 +802,7 @@ static ssize_t disk_fail_store(struct device *dev,
 #endif
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
@@ -793,6 +815,7 @@ static struct device_attribute dev_attr_fail =
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
+	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
 	&dev_attr_size.attr,
@@ -859,7 +882,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	cpu = disk_stat_lock();
 	disk_round_stats(cpu, gp);
 	disk_stat_unlock();
-	seq_printf(seqf, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
+	seq_printf(seqf, "%4d %7d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
 		MAJOR(disk_devt(gp)), MINOR(disk_devt(gp)),
 		disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
@@ -878,7 +901,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		cpu = disk_stat_lock();
 		part_round_stats(cpu, hd);
 		disk_stat_unlock();
-		seq_printf(seqf, "%4d %4d %s %lu %lu %llu "
+		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 860689f..02a9fb5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1685,6 +1685,7 @@ extern void chrdev_show(struct seq_file *,off_t);
 
 /* fs/block_dev.c */
 #define BDEVNAME_SIZE	32	/* Largest string for a blockdev identifier */
+#define BDEVT_SIZE	10	/* Largest string for MAJ:MIN for blkdev */
 
 #ifdef CONFIG_BLOCK
 #define BLKDEV_MAJOR_HASH_SIZE	255
-- 
1.5.4.5

