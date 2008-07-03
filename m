From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] block: adjust formatting for large minors and add ext_range sysfs attr
Date: Thu,  3 Jul 2008 17:33:04 +0900
Message-ID: <1215073986-4709-5-git-send-email-tj@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759478AbYGCNGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 09:06:08 -0400
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>

With extended minors and the soon-to-follow debug feature, large minor
numbers for block devices will be common.  This patch does the
followings.

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
 block/genhd.c      |   48 ++++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |    1 +
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 97cc5e4..615e0de 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -286,6 +286,18 @@ struct gendisk *get_gendisk(dev_t devt, int *part)
 	return  kobj ? dev_to_disk(dev) : NULL;
 }
 
+static char *bdevt_str(int major, int minor, char *buf)
+{
+	if (major <= 0xff && minor <= 0xff) {
+		char tbuf[BDEVT_SIZE];
+		snprintf(tbuf, BDEVT_SIZE, "%02x%02x", major, minor);
+		snprintf(buf, BDEVT_SIZE, "%-9s", tbuf);
+	} else
+		snprintf(buf, BDEVT_SIZE, "%03x:%05x", major, minor);
+
+	return buf;
+}
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
@@ -295,7 +307,8 @@ void __init printk_all_partitions(void)
 {
 	struct device *dev;
 	struct gendisk *sgp;
-	char buf[BDEVNAME_SIZE];
+	char devt_buf[BDEVT_SIZE];
+	char name_buf[BDEVNAME_SIZE];
 	int n;
 
 	mutex_lock(&block_class_lock);
@@ -315,10 +328,10 @@ void __init printk_all_partitions(void)
 		 * Note, unlike /proc/partitions, I am showing the numbers in
 		 * hex - the same format as the root= option takes.
 		 */
-		printk("%02x%02x %10llu %s",
-			disk_major(sgp), disk_minor(sgp),
+		printk("%s %10llu %s",
+		        bdevt_str(disk_major(sgp), disk_minor(sgp), devt_buf),
 			(unsigned long long)get_capacity(sgp) >> 1,
-			disk_name(sgp, 0, buf));
+			disk_name(sgp, 0, name_buf));
 		if (sgp->driverfs_dev != NULL &&
 		    sgp->driverfs_dev->driver != NULL)
 			printk(" driver: %s\n",
@@ -333,10 +346,11 @@ void __init printk_all_partitions(void)
 			if (!part || !part->nr_sects)
 				continue;
 
-			printk("  %02x%02x %10llu %s\n",
-				part_major(part), part_minor(part),
+			printk("  %s %10llu %s\n",
+				bdevt_str(part_major(part), part_minor(part),
+					  devt_buf),
 				(unsigned long long)sgp->part[n]->nr_sects >> 1,
-				disk_name(sgp, n + 1, buf));
+				disk_name(sgp, n + 1, name_buf));
 		}
 	}
 
@@ -386,7 +400,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	char buf[BDEVNAME_SIZE];
 
 	if (&sgp->dev.node == block_class.devices.next)
-		seq_puts(seqf, "major minor  #blocks  name\n\n");
+		seq_puts(seqf, "major   minor   #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
@@ -396,7 +410,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(seqf, "%4d  %4d %10llu %s\n",
+	seq_printf(seqf, "%4d  %7d %10llu %s\n",
 		disk_major(sgp), disk_minor(sgp),
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
@@ -406,7 +420,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 			continue;
 		if (part->nr_sects == 0)
 			continue;
-		seq_printf(seqf, "%4d  %4d %10llu %s\n",
+		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			part_major(part), part_minor(part),
 			(unsigned long long)part->nr_sects >> 1,
 			disk_name(sgp, n + 1, buf));
@@ -488,6 +502,14 @@ static ssize_t disk_range_show(struct device *dev,
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
@@ -568,6 +590,7 @@ static ssize_t disk_fail_store(struct device *dev,
 #endif
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
@@ -579,6 +602,7 @@ static struct device_attribute dev_attr_fail =
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
+	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
 	&dev_attr_size.attr,
 	&dev_attr_capability.attr,
@@ -677,7 +701,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	preempt_disable();
 	disk_round_stats(gp);
 	preempt_enable();
-	seq_printf(s, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
+	seq_printf(s, "%4d %7d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
 		disk_major(gp), disk_minor(gp), disk_name(gp, n, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
@@ -699,7 +723,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 		preempt_disable();
 		part_round_stats(hd);
 		preempt_enable();
-		seq_printf(s, "%4d %4d %s %lu %lu %llu "
+		seq_printf(s, "%4d %7d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   part_major(hd), part_minor(hd),
 			   disk_name(gp, n + 1, buf),
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

