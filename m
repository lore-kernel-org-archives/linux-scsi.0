From: Alan Stern <stern@rowland.harvard.edu>
Subject: list_for_each_entry_safe() regarded as unsafe
Date: Thu, 9 Jun 2005 12:27:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506091201080.5136-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:6828 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261374AbVFIQ1D
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 12:27:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Dag Nygren <dag@newtech.fi>, SCSI development list <linux-scsi@vger.kernel.org>

Mike and whoever else may be interested:

The scsi_forget_host() and __scsi_remove_target() routines (in scsi_scan.c 
and scsi_sysfs.c) contain these lines respectively:

	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {

	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {

Neither loop is truly safe because they release shost->host_lock to do the
actual removals.  I've just seen a couple of different oopses caused when
__scsi_remove_target() was called during scanning.  Details available if 
you want them.

I don't know what the best way is fix this.  Even if scsi_forget_host() 
acquired the host's scan_mutex, that wouldn't be enough to guarantee the 
__targets and __devices lists won't change, would it?  And it might cause 
interference with other pathways.

Maybe it's best simply to avoid using list_for_each_entry_safe, as in
the example below:

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -653,17 +653,19 @@ void __scsi_remove_target(struct scsi_ta
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->reap_ref++;
-	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
+restart:
+	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
+		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);


