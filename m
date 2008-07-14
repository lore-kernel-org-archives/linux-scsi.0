From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] block: adjust formatting for large minors and add ext_range sysfs attr
Date: Mon, 14 Jul 2008 16:12:12 +0900
Message-ID: <1216019534-29977-9-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
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
index 2511694..1b8ca16 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -365,6 +365,18 @@ void blk_free_devt(dev_t devt)
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
@@ -513,7 +525,8 @@ void __init printk_all_partitions(void)
 	struct gendisk *sgp;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	char buf[BDEVNAME_SIZE];
+	char name_buf[BDEVNAME_SIZE];
+	char devt_buf[BDEVT_SIZE];
 
 	down(&block_class.sem);
 	/* For each block device... */
@@ -532,10 +545,10 @@ void __init printk_all_partitions(void)
 		 * Note, unlike /proc/partitions, I am showing the numbers in
 		 * hex - the same format as the root= option takes.
 		 */
-		printk("%02x%02x %10llu %s",
-			MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
+		printk("%s %10llu %s",
+			bdevt_str(disk_devt(sgp), devt_buf),
 			(unsigned long long)get_capacity(sgp) >> 1,
-			disk_name(sgp, 0, buf));
+			disk_name(sgp, 0, name_buf));
 		if (sgp->driverfs_dev != NULL &&
 		    sgp->driverfs_dev->driver != NULL)
 			printk(" driver: %s\n",
@@ -546,10 +559,10 @@ void __init printk_all_partitions(void)
 		/* now show the partitions */
 		disk_part_iter_start(&piter, sgp, 0);
 		while ((part = disk_part_iter_next(&piter)))
-			printk("  %02x%02x %10llu %s\n",
-			       MAJOR(part_devt(part)), MINOR(part_devt(part)),
+			printk("  %s %10llu %s\n",
+			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(sgp, part->partno, buf));
+			       disk_name(sgp, part->partno, name_buf));
 		disk_part_iter_stop(&piter);
 	}
 
@@ -600,7 +613,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	if (&sgp->dev.node == block_class.devices.next)
-		seq_puts(seqf, "major minor  #blocks  name\n\n");
+		seq_puts(seqf, "major   minor   #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
@@ -610,14 +623,14 @@ static int show_partition(struct seq_file *seqf, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(seqf, "%4d  %4d %10llu %s\n",
+	seq_printf(seqf, "%4d  %7d %10llu %s\n",
 		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
 
 	disk_part_iter_start(&piter, sgp, 0);
 	while ((part = disk_part_iter_next(&piter)))
-		seq_printf(seqf, "%4d  %4d %10llu %s\n",
+		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
 			   (unsigned long long)part->nr_sects >> 1,
 			   disk_name(sgp, part->partno, buf));
@@ -668,6 +681,14 @@ static ssize_t disk_range_show(struct device *dev,
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
@@ -748,6 +769,7 @@ static ssize_t disk_fail_store(struct device *dev,
 #endif
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
@@ -759,6 +781,7 @@ static struct device_attribute dev_attr_fail =
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
+	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
 	&dev_attr_size.attr,
 	&dev_attr_capability.attr,
@@ -858,7 +881,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	preempt_disable();
 	disk_round_stats(gp);
 	preempt_enable();
-	seq_printf(seqf, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
+	seq_printf(seqf, "%4d %7d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
 		MAJOR(disk_devt(gp)), MINOR(disk_devt(gp)),
 		disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
@@ -877,7 +900,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		preempt_disable();
 		part_round_stats(hd);
 		preempt_enable();
-		seq_printf(seqf, "%4d %4d %s %lu %lu %llu "
+		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8e2762..8337243 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1667,6 +1667,7 @@ extern void chrdev_show(struct seq_file *,off_t);
 
 /* fs/block_dev.c */
 #define BDEVNAME_SIZE	32	/* Largest string for a blockdev identifier */
+#define BDEVT_SIZE	10	/* Largest string for MAJ:MIN for blkdev */
 
 #ifdef CONFIG_BLOCK
 #define BLKDEV_MAJOR_HASH_SIZE	255
-- 
1.5.4.5

