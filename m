From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Wed, 31 Jul 2013 13:39:50 +0200
Message-ID: <1375270790.17175.10.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1307291016220.1479-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/DUC0NOKCjRv66NIJQcj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013Ab3GaLjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jul 2013 07:39:52 -0400
In-Reply-To: <Pine.LNX.4.44L0.1307291016220.1479-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de


--=-/DUC0NOKCjRv66NIJQcj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2013-07-29 at 10:21 -0400, Alan Stern wrote:
> On Mon, 29 Jul 2013, Oliver Neukum wrote:
> 
> > On Fri, 2013-07-26 at 16:31 -0400, Alan Stern wrote:
> > 
> > > In addition to my earlier comment, the patch below should be applied.  
> > > It will fix your immediate problem, although not in the best way.
> > 
> > Alan,
> > 
> > I think your diagnosis is correct, but not the fix.
> > This is run even in the runtime case. We might lose
> > data if the flush is not done.
> 
> Actually no, the scsi_bus_suspend_common() routine does not run during 
> runtime PM.  It gets called only from scsi_bus_suspend(), 
> scsi_bus_freeze(), and scsi_bus_poweroff(), which are all part of 
> system sleep.


These errors should be handled cleanly. How about this patch?

	Regards
		Oliver




--=-/DUC0NOKCjRv66NIJQcj
Content-Disposition: attachment; filename="0001-sd-handle-errors-during-suspend.patch"
Content-Type: text/x-patch; name="0001-sd-handle-errors-during-suspend.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 76a377d9894dc8945e9afecc7f9864e6dc3156b1 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.de>
Date: Wed, 31 Jul 2013 13:32:51 +0200
Subject: [PATCH] sd: handle errors during suspend

Errors during suspend must be handled according to reasons
Errors due to missing media or unplugged devices must be ignored.
The error returns must be modified so that the generic layer
understands them.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_pm.c |  3 ++-
 drivers/scsi/sd.c      | 61 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 11 deletions(-)

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
index 86fcf2c..76273f4 100644
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
 
@@ -1455,12 +1456,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
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
 
@@ -3062,9 +3082,17 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
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
@@ -3096,7 +3124,7 @@ exit:
 	scsi_disk_put(sdkp);
 }
 
-static int sd_suspend(struct device *dev)
+static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
@@ -3113,7 +3141,10 @@ static int sd_suspend(struct device *dev)
 
 	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
+		if (ignore_stop_errors)
+			ret = 0;
 	}
 
 done:
@@ -3121,6 +3152,16 @@ done:
 	return ret;
 }
 
+static int sd_suspend_system(struct device *dev)
+{
+	return sd_suspend_common(dev, true);
+}
+
+static int sd_suspend_runtime(struct device *dev)
+{
+        return sd_suspend_common(dev, false);
+}
+
 static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-- 
1.8.3.1


--=-/DUC0NOKCjRv66NIJQcj--

