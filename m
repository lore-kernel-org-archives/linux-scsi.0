From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/13] block: allow disk to have extended device number
Date: Mon, 14 Jul 2008 16:48:13 +0900
Message-ID: <1216021693-483-14-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbYGNHuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:50:04 -0400
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

Now that disk and partition handlings are mostly unified, it's easy to
allow disk to have extended device number.  This patch makes
add_disk() use extended device number if disk->minors is zero.  Both
sd and ide-disk are updated to use this.

* sd_format_disk_name() is implemented which can generically determine
  the drive name.  This removes disk number restriction stemming from
  limited device names.

* If sd index goes over SD_MAX_DISKS (which can be increased now BTW),
  sd simply doesn't initialize minors letting block layer choose
  extended device number.

* If CONFIG_DEBUG_EXT_DEVT is set, both sd and ide-disk always set
  minors to 0 and use extended device numbers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c          |   29 ++++++++++++++++++-
 drivers/ide/ide-disk.c |    2 +-
 drivers/scsi/sd.c      |   74 +++++++++++++++++++++++++++++++++++-------------
 fs/partitions/check.c  |    1 +
 include/linux/genhd.h  |    3 +-
 5 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b38c235..a4f3117 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -477,13 +477,40 @@ static int exact_lock(dev_t devt, void *data)
  *
  * This function registers the partitioning information in @disk
  * with the kernel.
+ *
+ * FIXME: error handling
  */
 void add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
+	dev_t devt;
+	int rc;
+
+	/* minors == 0 indicates to use ext devt from part0 and should
+	 * be accompanied with EXT_DEVT flag.  Make sure all
+	 * parameters make sense.
+	 */
+	WARN_ON(disk->minors && !(disk->major || disk->first_minor));
+	WARN_ON(!disk->minors && !(disk->flags & GENHD_FL_EXT_DEVT));
 
 	disk->flags |= GENHD_FL_UP;
-	disk_to_dev(disk)->devt = MKDEV(disk->major, disk->first_minor);
+
+	if (disk->minors)
+		devt = MKDEV(disk->major, disk->first_minor);
+	else {
+		rc = blk_alloc_devt(&disk->part0, &devt);
+		if (rc)
+			return;
+
+		/* ->major and ->first_minor aren't supposed to be
+		 * referenced from here on, but set them just in case.
+		 */
+		disk->major = MAJOR(devt);
+		disk->first_minor = MINOR(devt);
+	}
+
+	disk_to_dev(disk)->devt = devt;
+
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 6d7cf15..6fe4d7b 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -44,7 +44,7 @@
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		(1 << PARTN_BITS)
 #else
-#define IDE_DISK_MINORS		1
+#define IDE_DISK_MINORS		0
 #endif
 
 struct ide_disk_obj {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1f41e3d..a10706b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -89,7 +89,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
-#define SD_MINORS	1
+#define SD_MINORS	0
 #endif
 
 static int  sd_revalidate_disk(struct gendisk *);
@@ -1610,6 +1610,52 @@ static int sd_revalidate_disk(struct gendisk *disk)
 }
 
 /**
+ *	sd_format_disk_name - format disk name
+ *	@prefix: name prefix - ie. "sd" for SCSI disks
+ *	@index: index of the disk to format name for
+ *	@buf: output buffer
+ *	@buflen: length of the output buffer
+ *
+ *	SCSI disk names starts at sda.  The 26th device is sdz and the
+ *	27th is sdaa.  The last one for two lettered suffix is sdzz
+ *	which is followed by sdaaa.
+ *
+ *	This is basically 26 base counting with one extra 'nil' entry
+ *	at the beggining from the second digit on and can be
+ *	determined using similar method as 26 base conversion with the
+ *	index shifted -1 after each digit is computed.
+ *
+ *	CONTEXT:
+ *	Don't care.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
+{
+	const int base = 'z' - 'a' + 1;
+	char *begin = buf + strlen(prefix);
+	char *end = buf + buflen;
+	char *p;
+	int unit;
+
+	p = end - 1;
+	*p = '\0';
+	unit = base;
+	do {
+		if (p == begin)
+			return -EINVAL;
+		*--p = 'a' + (index % unit);
+		index = (index / unit) - 1;
+	} while (index >= 0);
+
+	memmove(begin, p, end - p);
+	memcpy(buf, prefix, strlen(prefix));
+
+	return 0;
+}
+
+/**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
@@ -1661,8 +1707,8 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
-	error = -EBUSY;
-	if (index >= SD_MAX_DISKS)
+	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
+	if (error)
 		goto out_free_index;
 
 	sdkp->device = sdp;
@@ -1689,24 +1735,12 @@ static int sd_probe(struct device *dev)
 
 	get_device(&sdp->sdev_gendev);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-	gd->fops = &sd_fops;
-
-	if (index < 26) {
-		sprintf(gd->disk_name, "sd%c", 'a' + index % 26);
-	} else if (index < (26 + 1) * 26) {
-		sprintf(gd->disk_name, "sd%c%c",
-			'a' + index / 26 - 1,'a' + index % 26);
-	} else {
-		const unsigned int m1 = (index / 26 - 1) / 26 - 1;
-		const unsigned int m2 = (index / 26 - 1) % 26;
-		const unsigned int m3 =  index % 26;
-		sprintf(gd->disk_name, "sd%c%c%c",
-			'a' + m1, 'a' + m2, 'a' + m3);
+	if (index < SD_MAX_DISKS) {
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
-
+	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 825da63..15a3a1e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -592,6 +592,7 @@ void del_gendisk(struct gendisk *disk)
 		delete_partition(disk, part->partno);
 	}
 	invalidate_partition(disk, 0);
+	blk_free_devt(disk_to_dev(disk)->devt);
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 	unlink_gendisk(disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a48f350..5b97ef8 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -59,6 +59,7 @@ enum {
 };
 
 #define DISK_MAX_PARTS			256
+#define DISK_NAME_LEN			32
 
 #include <linux/major.h>
 #include <linux/device.h>
@@ -131,7 +132,7 @@ struct gendisk {
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
 
-	char disk_name[32];		/* name of major driver */
+	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 
 	/* Array of pointers to partitions indexed by partno.
 	 * Protected with matching bdev lock but stat and other
-- 
1.5.4.5

