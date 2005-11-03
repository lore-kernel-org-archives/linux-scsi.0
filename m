From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: fix race between rescan and remove
Date: Thu, 3 Nov 2005 10:54:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511031047350.5056-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46228 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1030357AbVKCPyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2005 10:54:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

When the well-known open/remove race was fixed in sd.c, a closely-related
race between rescan and remove was ignored.  Probably because rescan gets 
called from an unusual pathway (via sysfs).  It's easy for this race to
trigger an oops, especially if you unplug a USB storage device while a
user program continually writes to the "rescan" attribute file.

This patch (as597) fixes the race by making the rescan routine acquire the 
appropriate references.  It also cleans up the code scsi_disk_get 
somewhat.  This resolves Bugzilla entry #5237.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Do you think this is appropriate for 2.6.14.stable?

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -182,19 +182,29 @@ static struct scsi_disk *scsi_disk_get(s
 	struct scsi_disk *sdkp = NULL;
 
 	down(&sd_ref_sem);
-	if (disk->private_data == NULL)
-		goto out;
-	sdkp = scsi_disk(disk);
-	kref_get(&sdkp->kref);
-	if (scsi_device_get(sdkp->device))
-		goto out_put;
+	if (disk->private_data) {
+		sdkp = scsi_disk(disk);
+		if (scsi_device_get(sdkp->device) == 0)
+			kref_get(&sdkp->kref);
+		else
+			sdkp = NULL;
+	}
 	up(&sd_ref_sem);
 	return sdkp;
+}
 
- out_put:
-	kref_put(&sdkp->kref, scsi_disk_release);
-	sdkp = NULL;
- out:
+static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
+{
+	struct scsi_disk *sdkp;
+
+	down(&sd_ref_sem);
+	sdkp = dev_get_drvdata(dev);
+	if (sdkp) {
+		if (scsi_device_get(sdkp->device) == 0)
+			kref_get(&sdkp->kref);
+		else
+			sdkp = NULL;
+	}
 	up(&sd_ref_sem);
 	return sdkp;
 }
@@ -769,8 +779,13 @@ static int sd_prepare_flush(request_queu
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	sd_revalidate_disk(sdkp->disk);
+	struct scsi_disk *sdkp;
+
+	sdkp = scsi_disk_get_from_dev(dev);
+	if (sdkp) {
+		sd_revalidate_disk(sdkp->disk);
+		scsi_disk_put(sdkp);
+	}
 }
 
 

