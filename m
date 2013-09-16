From: oliver@neukum.org
Subject: [PATCH] sd: error handling during flushing caches
Date: Mon, 16 Sep 2013 13:28:15 +0200
Message-ID: <1379330895-20505-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:40272 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab3IPL2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2013 07:28:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hare@suse.de, luto@amacapital.net, stern@rowland.harvard.edu
Cc: Oliver Neukum <oneukum@suse.de>

From: Oliver Neukum <oneukum@suse.de>

It makes no sense to flush the cache of a device without medium.
Errors during suspend must be handled according to their causes.
Errors due to missing media or unplugged devices must be ignored.
Errors due to devices being offlined must also be ignored.
The error returns must be modified so that the generic layer
understands them.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_pm.c |  3 ++-
 drivers/scsi/sd.c      | 72 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 4c5aabe..af4c050 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -54,7 +54,8 @@ scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
 		/*
 		 * All the high-level SCSI drivers that implement runtime
 		 * PM treat runtime suspend, system suspend, and system
-		 * hibernate identically.
+		 * hibernate nearly identically. In all cases the requirements
+		 * for runtime suspension are stricter.
 		 */
 		if (pm_runtime_suspended(dev))
 			return 0;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 80f39b8..cf6eaa4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -105,7 +105,8 @@ static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
 static int  sd_remove(struct device *);
 static void sd_shutdown(struct device *);
-static int sd_suspend(struct device *);
+static int sd_suspend_system(struct device *);
+static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
 static int sd_done(struct scsi_cmnd *);
@@ -483,11 +484,11 @@ static struct class sd_disk_class = {
 };
 
 static const struct dev_pm_ops sd_pm_ops = {
-	.suspend		= sd_suspend,
+	.suspend		= sd_suspend_system,
 	.resume			= sd_resume,
-	.poweroff		= sd_suspend,
+	.poweroff		= sd_suspend_system,
 	.restore		= sd_resume,
-	.runtime_suspend	= sd_suspend,
+	.runtime_suspend	= sd_suspend_runtime,
 	.runtime_resume		= sd_resume,
 };
 
@@ -1430,7 +1431,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };
 
@@ -1448,12 +1448,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 	if (res) {
 		sd_print_result(sdkp, res);
-		if (driver_byte(res) & DRIVER_SENSE)
+
+		if (driver_byte(res) & DRIVER_SENSE) 
 			sd_print_sense_hdr(sdkp, &sshdr);
+		/* we need to evaluate the error return  */
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+				/* this is no error here */
+				return 0;
+
+		switch (host_byte(res)) {
+		/* ignore errors due to racing a disconnection */
+		case DID_BAD_TARGET:
+		case DID_NO_CONNECT:
+			return 0;
+		/* signal the upper layer it might try again */
+		case DID_BUS_BUSY:
+		case DID_IMM_RETRY:
+		case DID_REQUEUE:
+		case DID_SOFT_ERROR:
+			return -EBUSY;
+		default:
+			return -EIO;
+		}
 	}
-
-	if (res)
-		return -EIO;
 	return 0;
 }
 
@@ -3070,9 +3089,17 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			res = 0;
 	}
 
-	return res;
+	/* SCSI error codes must not go to the generic layer */
+	if (res)
+		return -EIO;
+
+	return 0;
 }
 
 /*
@@ -3090,7 +3117,7 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		goto exit;
 
-	if (sdkp->WCE) {
+	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
 	}
@@ -3104,7 +3131,7 @@ exit:
 	scsi_disk_put(sdkp);
 }
 
-static int sd_suspend(struct device *dev)
+static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
@@ -3112,16 +3139,23 @@ static int sd_suspend(struct device *dev)
 	if (!sdkp)
 		return 0;	/* this can happen */
 
-	if (sdkp->WCE) {
+	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
-		if (ret)
+		if (ret) {
+			/* ignore OFFLINE device */
+			if (ret == -ENODEV)
+				ret = 0;
 			goto done;
+		}
 	}
 
 	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
+		if (ignore_stop_errors)
+			ret = 0;
 	}
 
 done:
@@ -3129,6 +3163,16 @@ done:
 	return ret;
 }
 
+static int sd_suspend_system(struct device *dev)
+{
+	return sd_suspend_common(dev, true);
+}
+
+static int sd_suspend_runtime(struct device *dev)
+{
+	return sd_suspend_common(dev, false);
+}
+
 static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-- 
1.8.3.1

