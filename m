From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] block: add alt_size
Date: Sun,  1 Feb 2009 11:55:49 +0900
Message-ID: <1233456951-992-2-git-send-email-tj@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

ATA disks have two sizes - the user visible size and native size.  The
user visible size is usually used by the BIOS to hide certain area
(e.g. recovery partition) or trim size for various reasons.  IDE and
libata can unlock these HPA areas and IDE does so by default and
libata depending on kernel parameters (some distros default to unlock
to maintain compatibility with IDE).

This usually doesn't matter but certain tools need to know what BIOS
wants the disk to look like.  For example, certain BIOS RAID formats
put the metadata at the end of the disk where the 'end' is the trimmed
size, so without knowing the BIOS size, dmraid can't work reliably if
HPA is unlocked.

This patch adds alt_size to genhd and exports it via sysfs.  alt_size
is always smaller than the regular size.  Being a hint, alt_size can
also be set from userland by writing to the sysfs node mostly for
debugging and testing.  Because initialization order isn't enforced,
the alt_size < size limitation is applied while getting the attribute.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   26 ++++++++++++++++++++++++++
 include/linux/genhd.h |   13 ++++++++++++-
 2 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 397960c..db7b501 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -824,6 +824,29 @@ static ssize_t disk_ro_show(struct device *dev,
 	return sprintf(buf, "%d\n", get_disk_ro(disk) ? 1 : 0);
 }
 
+static ssize_t disk_alt_size_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%llu\n",
+		       (unsigned long long)get_alt_capacity(disk));
+}
+
+static ssize_t disk_alt_size_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	sector_t new_size = simple_strtoull(buf, NULL, 0);
+
+	set_alt_capacity(disk, new_size);
+
+	if (get_alt_capacity(disk) == new_size)
+		return count;
+	return -EINVAL;
+}
+
 static ssize_t disk_capability_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -837,6 +860,8 @@ static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alt_size, S_IRUGO | S_IWUSR, disk_alt_size_show,
+		   disk_alt_size_store);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -855,6 +880,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
 	&dev_attr_size.attr,
+	&dev_attr_alt_size.attr,
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 16948ea..763affe 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -159,7 +159,8 @@ struct gendisk {
 
 	struct timer_rand_state *random;
 
-	atomic_t sync_io;		/* RAID */
+	sector_t alt_nr_sects;	/* alt sects, should be <= part0.sects */
+	atomic_t sync_io;	/* RAID */
 	struct work_struct async_notify;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
@@ -364,10 +365,20 @@ static inline sector_t get_capacity(struct gendisk *disk)
 {
 	return disk->part0.nr_sects;
 }
+static inline sector_t get_alt_capacity(struct gendisk *disk)
+{
+	if (disk->alt_nr_sects && disk->alt_nr_sects < disk->part0.nr_sects)
+		return disk->alt_nr_sects;
+	return 0;
+}
 static inline void set_capacity(struct gendisk *disk, sector_t size)
 {
 	disk->part0.nr_sects = size;
 }
+static inline void set_alt_capacity(struct gendisk *disk, sector_t size)
+{
+	disk->alt_nr_sects = size;
+}
 
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 
-- 
1.6.0.2
