From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Thu, 01 Aug 2013 16:12:48 +0200
Message-ID: <1375366368.1518.18.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1307311105250.1546-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BF9COvnKQwoXq9rDqVv3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab3HAOMu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 10:12:50 -0400
In-Reply-To: <Pine.LNX.4.44L0.1307311105250.1546-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de


--=-BF9COvnKQwoXq9rDqVv3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-07-31 at 11:13 -0400, Alan Stern wrote:

> More importantly, if we already know that the medium is not present or
> has been changed since it was last used, then there's no reason to call
> sd_sync_cache() at all.

Like this?

	Regards
		Oliver




--=-BF9COvnKQwoXq9rDqVv3
Content-Disposition: attachment; filename="0001-sd-error-handling-during-flushing-caches.patch"
Content-Type: text/x-patch; name="0001-sd-error-handling-during-flushing-caches.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 8c90d860652aa99e6e60d9b32bc3aa8d4db9efa5 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.de>
Date: Thu, 1 Aug 2013 10:08:20 +0200
Subject: [PATCH] sd: error handling during flushing caches

It makes no sense to flush the cache of a device without medium.
Errors during suspend must be handled according to their causes.
Errors due to missing media or unplugged devices must be ignored.
Errors due to devices being offlined must also be ignored.
The error returns must be modified so that the generic layer
understands them.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_pm.c |  3 ++-
 drivers/scsi/sd.c      | 69 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 60 insertions(+), 12 deletions(-)

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
index 86fcf2c..3c7f918 100644
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
 
@@ -1437,6 +1438,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
+	if (!sdkp->media_present)
+		return 0;
 
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };
@@ -1455,12 +1458,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
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
 
@@ -3062,9 +3084,17 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
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
@@ -3096,7 +3126,7 @@ exit:
 	scsi_disk_put(sdkp);
 }
 
-static int sd_suspend(struct device *dev)
+static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
@@ -3107,13 +3137,20 @@ static int sd_suspend(struct device *dev)
 	if (sdkp->WCE) {
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
@@ -3121,6 +3158,16 @@ done:
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


--=-BF9COvnKQwoXq9rDqVv3--

