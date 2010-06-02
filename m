From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/7] SCSI: simplify __scsi_remove_target()
Date: Wed, 2 Jun 2010 16:35:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021152350.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58687 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:35:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1339) simplifies __scsi_remove_target() by replacing
target-reap operations with calls to get_device()/put_device().  Since
the target is being removed entirely, there's no need to prevent it
from being removed from visibility.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -986,8 +986,8 @@ static void __scsi_remove_target(struct 
 	unsigned long flags;
 	struct scsi_device *sdev;
 
+	get_device(&starget->dev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -1000,7 +1000,7 @@ static void __scsi_remove_target(struct 
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
+	put_device(&starget->dev);
 }
 
 static int __remove_child (struct device * dev, void * data)

