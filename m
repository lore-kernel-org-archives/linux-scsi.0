From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as397] SCSI core: Fix refcounting error
Date: Sun, 24 Oct 2004 12:35:15 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410241223440.25592-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:46350 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261565AbUJXQfV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 12:35:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James and Mike:

This bug was present as of 2.6.9-bk7, apparently introduced along with the
addition of SCSI targets into sysfs.  The code takes a reference to the
host for each initialized sdev but only drops a reference when each
target is released.  As you might expect, this causes a refcount leak
whenever a target has more than 0 LUNs.

The patch changes things so that the reference is acquired when the target 
is initialized, not when the sdev is initialized.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

--- 2.6.9-bk7/drivers/scsi/scsi_scan.c.orig	Thu Oct 21 10:17:21 2004
+++ 2.6.9-bk7/drivers/scsi/scsi_scan.c	Sun Oct 24 11:09:48 2004
@@ -271,8 +271,7 @@
 			goto out_cleanup_slave;
 	}
 
-	if (get_device(&sdev->host->shost_gendev) == NULL ||
-	    scsi_sysfs_device_initialize(sdev) != 0)
+	if (scsi_sysfs_device_initialize(sdev) != 0)
 		goto out_cleanup_slave;
 
 
--- 2.6.9-bk7/drivers/scsi/scsi_sysfs.c.orig	Thu Oct 21 10:17:21 2004
+++ 2.6.9-bk7/drivers/scsi/scsi_sysfs.c	Sun Oct 24 11:09:42 2004
@@ -775,7 +775,7 @@
 		memset(starget, 0, size);
 		dev = &starget->dev;
 		device_initialize(dev);
-		dev->parent = &shost->shost_gendev;
+		dev->parent = get_device(&shost->shost_gendev);
 		dev->release = scsi_target_dev_release;
 		sprintf(dev->bus_id, "target%d:%d:%d",
 			shost->host_no, sdev->channel, sdev->id);

