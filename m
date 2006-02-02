From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] scsi core: fix uninitialized variable error
Date: Thu, 2 Feb 2006 16:44:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602021637430.4715-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:24262 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932300AbWBBVoV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2006 16:44:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as649) fixes an uninitialized variable error (sdev) in 
__scsi_add_device.  I don't understand why the compiler didn't flag the 
error.

It also removes a pair of calls to get_device and put_device; they are no 
longer needed since scsi_target_reap now uses a work_queue.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -368,11 +368,7 @@ static struct scsi_target *scsi_alloc_ta
 
 		if(error) {
 			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
-			/* don't want scsi_target_reap to do the final
-			 * put because it will be under the host lock */
-			get_device(dev);
 			scsi_target_reap(starget);
-			put_device(dev);
 			return NULL;
 		}
 	}
@@ -1265,7 +1261,6 @@ struct scsi_device *__scsi_add_device(st
 {
 	struct scsi_device *sdev;
 	struct device *parent = &shost->shost_gendev;
-	int res;
 	struct scsi_target *starget;
 
 	starget = scsi_alloc_target(parent, channel, id);
@@ -1274,12 +1269,10 @@ struct scsi_device *__scsi_add_device(st
 
 	get_device(&starget->dev);
 	mutex_lock(&shost->scan_mutex);
-	if (scsi_host_scan_allowed(shost)) {
-		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
-					     hostdata);
-		if (res != SCSI_SCAN_LUN_PRESENT)
-			sdev = ERR_PTR(-ENODEV);
-	}
+	if (!scsi_host_scan_allowed(shost) ||
+			scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
+				hostdata) != SCSI_SCAN_LUN_PRESENT)
+		sdev = ERR_PTR(-ENODEV);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);

