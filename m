From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7/7] SCSI: change the meaning of starget->reap_ref
Date: Wed, 2 Jun 2010 16:37:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006021157540.1992-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58697 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753654Ab0FBUhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 16:37:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1248e) changes the meaning of starget->reap_ref.  Now it
serves to count the number of underlying devices beneath the target
(i.e., the length of the starget->devices list), plus one when we want
to prevent a possibly-empty target from being removed from visibility.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -305,6 +305,7 @@ static struct scsi_device *scsi_alloc_sd
 	transport_setup_device(&sdev->sdev_gendev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
+	starget->reap_ref++;
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -503,7 +504,7 @@ void scsi_target_reap(struct scsi_target
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+	if (--starget->reap_ref == 0) {
 		empty = 1;
 		starget->state = STARGET_DEL;
 	}
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -305,7 +305,6 @@ static void scsi_device_dev_release_user
 	transport_destroy_device(&sdev->sdev_gendev);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);

