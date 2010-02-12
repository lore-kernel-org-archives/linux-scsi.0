From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/5] SCSI: fix target allocation outside of scan_mutex
Date: Fri, 12 Feb 2010 12:14:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121212020.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35481 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757308Ab0BLROT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:14:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1337) fixes a bug in __scsi_add_device().  It calls
scsi_alloc_target() outside the protection of the host's scan_mutex,
meaning that it might find an incompletely-initialized target or it
might create a duplicate target.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1506,25 +1506,29 @@ struct scsi_device *__scsi_add_device(st
 {
 	struct scsi_device *sdev = ERR_PTR(-ENODEV);
 	struct device *parent = &shost->shost_gendev;
-	struct scsi_target *starget;
+	struct scsi_target *starget = NULL;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
-		return ERR_PTR(-ENODEV);
-
-	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
-		return ERR_PTR(-ENOMEM);
+		return sdev;
 
 	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
-	if (scsi_host_scan_allowed(shost))
-		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
+	if (scsi_host_scan_allowed(shost)) {
+		starget = scsi_alloc_target(parent, channel, id);
+		if (starget)
+			scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
+					1, hostdata);
+		else
+			sdev = ERR_PTR(-ENOMEM);
+	}
 	mutex_unlock(&shost->scan_mutex);
-	scsi_target_reap(starget);
-	put_device(&starget->dev);
 
+	if (starget) {
+		scsi_target_reap(starget);
+		put_device(&starget->dev);
+	}
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);

