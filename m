From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: avoid deadlocks when running under multipath
Date: Fri, 10 May 2013 11:06:16 +0200
Message-ID: <1368176776-78284-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3EJJGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 05:06:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When multipathed systems run into an all-paths-down scenario
all devices might be dropped, too. This causes 'del_gendisk'
to be called, which will unregister the kobj_map->probe()
function for all disk device numbers.
When the device comes back the default ->probe() function
is run which will call __request_module(), which will
deadlock.
As 'del_gendisk' typically does _not_ trigger a module unload
the default ->probe() function is pointless anyway.
This patch implements a dummy ->probe() function, which will
just return NULL if the disk is not registered.
This will avoid the deadlock. Plus it'll speed up device
scanning.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..2ee0aa6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -489,6 +489,16 @@ static struct scsi_driver sd_template = {
 };
 
 /*
+ * Dummy kobj_map->probe function.
+ * The default ->probe function will call modprobe, which is
+ * pointless as this module is already loaded.
+ */
+static struct kobject *sd_default_probe(dev_t devt, int *partno, void *data)
+{
+	return NULL;
+}
+
+/*
  * Device no to disk mapping:
  * 
  *       major         disc2     disc  p1
@@ -2961,8 +2971,10 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
+	dev_t devt;
 
 	sdkp = dev_get_drvdata(dev);
+	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
@@ -2972,6 +2984,9 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	blk_register_region(devt, SD_MINORS, NULL,
+			    sd_default_probe, NULL, NULL);
+
 	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
 	put_device(&sdkp->dev);
@@ -3115,9 +3130,13 @@ static int __init init_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
 
-	for (i = 0; i < SD_MAJORS; i++)
-		if (register_blkdev(sd_major(i), "sd") == 0)
-			majors++;
+	for (i = 0; i < SD_MAJORS; i++) {
+		if (register_blkdev(sd_major(i), "sd") != 0)
+			continue;
+		majors++;
+		blk_register_region(sd_major(i), SD_MINORS, NULL,
+				    sd_default_probe, NULL, NULL);
+	}
 
 	if (!majors)
 		return -ENODEV;
@@ -3176,8 +3195,10 @@ static void __exit exit_sd(void)
 
 	class_unregister(&sd_disk_class);
 
-	for (i = 0; i < SD_MAJORS; i++)
+	for (i = 0; i < SD_MAJORS; i++) {
+		blk_unregister_region(sd_major(i), SD_MINORS);
 		unregister_blkdev(sd_major(i), "sd");
+	}
 }
 
 module_init(init_sd);
