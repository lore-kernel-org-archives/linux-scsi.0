From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] Add release function to sd for scsi_disk structure
Date: Sat, 18 Oct 2003 00:40:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031018074040.GA1210@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:23230 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261311AbTJRHgc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Oct 2003 03:36:32 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e33.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id h9I7aUBd325360
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2003 03:36:30 -0400
Received: from dyn9-47-17-195 (sig-9-65-27-5.mts.ibm.com [9.65.27.5])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h9I7aJOt104066
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2003 01:36:30 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is against 2.6.0-test8.

This patch removes the delay in calling device_del on the sdev struct
device during a surprise removal event. Reference counting functions for
sd's scsi_disk structure where also added to fix issues of unregistering
when a sd is open.

I have tested this patch using scsi_debug with differnt combinations of
adds / removes. I mounted both partitioned and un-partitioned sd disks,
remove the host, and then did a umount. The ref count debug output shows
the objects staying in place prior to the umount and cleaning up once
the umount is called.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch fixes an issue with a delayed call of device_del on the
sdev_gendev struct device.
	- Remove the delayed call to device_del.
	- Add kobject to sd scsi_disk structure.
	- Add release function for scsi_disk kobject.
	- Add get / put functions for scsi_disk and calls to these
	  functions.
EDESC


 drivers/scsi/scsi.c       |    4 --
 drivers/scsi/scsi_sysfs.c |    3 --
 drivers/scsi/sd.c         |   63 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 57 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~blkdev_release drivers/scsi/scsi_sysfs.c
--- qla-bleed-2.5/drivers/scsi/scsi_sysfs.c~blkdev_release	Fri Oct 17 23:14:06 2003
+++ qla-bleed-2.5-andmike/drivers/scsi/scsi_sysfs.c	Fri Oct 17 23:34:55 2003
@@ -412,8 +412,7 @@ void scsi_remove_device(struct scsi_devi
 		set_bit(SDEV_DEL, &sdev->sdev_state);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (!atomic_read(&sdev->access_count))
-			device_del(&sdev->sdev_gendev);
+		device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
 	}
 
diff -puN drivers/scsi/scsi.c~blkdev_release drivers/scsi/scsi.c
--- qla-bleed-2.5/drivers/scsi/scsi.c~blkdev_release	Fri Oct 17 23:14:06 2003
+++ qla-bleed-2.5-andmike/drivers/scsi/scsi.c	Fri Oct 17 23:14:06 2003
@@ -914,9 +914,7 @@ void scsi_device_put(struct scsi_device 
 		return;
 
 	module_put(sdev->host->hostt->module);
-	if (atomic_dec_and_test(&sdev->access_count))
-		if (test_bit(SDEV_DEL, &sdev->sdev_state))
-			device_del(&sdev->sdev_gendev);
+	atomic_dec(&sdev->access_count);
 	put_device(&sdev->sdev_gendev);
 	class_put(&sdev_class);
 }
diff -puN drivers/scsi/sd.c~blkdev_release drivers/scsi/sd.c
--- qla-bleed-2.5/drivers/scsi/sd.c~blkdev_release	Fri Oct 17 23:14:06 2003
+++ qla-bleed-2.5-andmike/drivers/scsi/sd.c	Fri Oct 17 23:14:06 2003
@@ -74,9 +74,16 @@
  */
 #define SD_MAX_RETRIES		5
 
+static void scsi_disk_release (struct kobject *kobj);
+
+static struct kobj_type scsi_disk_kobj_type = {
+	.release = scsi_disk_release,
+};
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
+	struct kobject	kobj;
 	struct gendisk	*disk;
 	unsigned int	openers;	/* protected by BKL for now, yuck */
 	sector_t	capacity;	/* size in 512-byte sectors */
@@ -87,6 +94,7 @@ struct scsi_disk {
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 };
 
+
 static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
 
@@ -128,11 +136,33 @@ static int sd_major(int major_idx)
 	}
 }
 
+#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj);
+
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
+static int scsi_disk_get(struct scsi_disk *sdkp)
+{
+	if (!kobject_get(&sdkp->kobj))
+		goto out;
+	if (scsi_device_get(sdkp->device))
+		goto out_put_kobj;
+	return 0;
+
+out_put_kobj:
+	kobject_put(&sdkp->kobj);
+out:
+	return -ENXIO;
+}
+
+static void scsi_disk_put(struct scsi_disk *sdkp)
+{
+	scsi_device_put(sdkp->device);
+	kobject_put(&sdkp->kobj);
+}
+
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -352,15 +382,17 @@ static int sd_open(struct inode *inode, 
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdev = sdkp->device;
+	struct scsi_device *sdev;
 	int retval;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
 
-	retval = scsi_device_get(sdev);
+	retval = scsi_disk_get(sdkp);
 	if (retval)
 		return retval;
 
+	sdev = sdkp->device;
+
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -406,7 +438,7 @@ static int sd_open(struct inode *inode, 
 	return 0;
 
 error_out:
-	scsi_device_put(sdev);
+	scsi_disk_put(sdkp);
 	return retval;	
 }
 
@@ -438,7 +470,7 @@ static int sd_release(struct inode *inod
 	 * XXX and what if there are packets in flight and this close()
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
-	scsi_device_put(sdev);
+	scsi_disk_put(sdkp);
 	return 0;
 }
 
@@ -1270,6 +1302,10 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
+	memset (sdkp, 0, sizeof(*sdkp));
+	kobject_init(&sdkp->kobj);
+	sdkp->kobj.ktype = &scsi_disk_kobj_type;
+
 	gd = alloc_disk(16);
 	if (!gd)
 		goto out_free;
@@ -1348,16 +1384,27 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	del_gendisk(sdkp->disk);
+	sd_shutdown(dev);
+	kobject_put(&sdkp->kobj);
+
+	return 0;
+}
+
+/**
+ *	scsi_disk_release - Called to free the scsi_disk structure
+ *	@kobj: pointer to embedded kobject
+ **/
+static void scsi_disk_release(struct kobject *kobj)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(kobj);
+	
+	put_disk(sdkp->disk);
 
 	spin_lock(&sd_index_lock);
 	clear_bit(sdkp->index, sd_index_bits);
 	spin_unlock(&sd_index_lock);
 
-	sd_shutdown(dev);
-	put_disk(sdkp->disk);
 	kfree(sdkp);
-
-	return 0;
 }
 
 /*

_
