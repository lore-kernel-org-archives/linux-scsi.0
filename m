From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/4 ver 3] SCSI: make starget->reap_ref count the number of
 underlying devices
Date: Wed, 28 Oct 2009 15:09:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910281505020.3061-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57071 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752508AbZJ1TJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 15:09:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1248c) changes the meaning of starget->reap_ref.  Now it
serves to count the number of underlying devices beneath the target,
plus one when we want to prevent an empty target from being removed 
from visibility.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -303,6 +303,7 @@ static struct scsi_device *scsi_alloc_sd
 	transport_setup_device(&sdev->sdev_gendev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
+	starget->reap_ref++;
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -501,8 +502,7 @@ void scsi_target_reap(struct scsi_target
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
-	empty = --starget->reap_ref == 0 &&
-		list_empty(&starget->devices) ? 1 : 0;
+	empty = --starget->reap_ref == 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (!empty)
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -302,7 +302,6 @@ static void scsi_device_dev_release_user
 	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);


