From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/7] SCSI: move transport_destroy_device() call
Date: Wed, 2 Jun 2010 16:36:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021156570.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58693 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758027Ab0FBUgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:36:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1342) moves the call of transport_destroy_device() from
__scsi_remove_device() to scsi_device_dev_release_usercontext() where
it logically belongs.  In theory the slave_destroy() call belongs
there too, but at that point we don't know whether the corresponding
slave_alloc() call succeeded.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -302,6 +302,8 @@ static void scsi_device_dev_release_user
 	parent = sdev->sdev_gendev.parent;
 	starget = to_scsi_target(parent);
 
+	transport_destroy_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
@@ -962,7 +964,6 @@ void __scsi_remove_device(struct scsi_de
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(dev);
 	put_device(dev);
 }
 
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -326,7 +326,6 @@ static struct scsi_device *scsi_alloc_sd
 
 out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
-	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 out:

