From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/7] SCSI: simplify scsi_remove_target()
Date: Wed, 2 Jun 2010 16:36:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021153480.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58689 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:36:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1340) eliminates an unnecessary local variable from
scsi_remove_target().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -1020,16 +1020,14 @@ static int __remove_child (struct device
  */
 void scsi_remove_target(struct device *dev)
 {
-	struct device *rdev;
-
 	if (scsi_is_target_device(dev)) {
 		__scsi_remove_target(to_scsi_target(dev));
 		return;
 	}
 
-	rdev = get_device(dev);
+	get_device(dev);
 	device_for_each_child(dev, NULL, __remove_child);
-	put_device(rdev);
+	put_device(dev);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 

