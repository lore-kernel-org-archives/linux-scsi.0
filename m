From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd.c: fix refcounting regression in suspend/resume routines
Date: Mon, 21 May 2007 09:55:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0705210953040.3974-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50694 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755100AbXEUOBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 10:01:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as909) fixes a couple of refcounting errors in the sd
driver's suspend and resume methods.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1789,7 +1789,7 @@ static void sd_shutdown(struct device *d
 static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-	int ret;
+	int ret = 0;
 
 	if (!sdkp)
 		return 0;	/* this can happen */
@@ -1798,30 +1798,34 @@ static int sd_suspend(struct device *dev
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
-			return ret;
+			goto done;
 	}
 
 	if (mesg.event == PM_EVENT_SUSPEND &&
 	    sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+done:
+	scsi_disk_put(sdkp);
+	return ret;
 }
 
 static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
-		return 0;
+		goto done;
 
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	ret = sd_start_stop_device(sdkp, 1);
 
-	return sd_start_stop_device(sdkp, 1);
+done:
+	scsi_disk_put(sdkp);
+	return ret;
 }
 
 /**

