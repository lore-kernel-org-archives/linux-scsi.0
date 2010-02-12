From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4/5] SCSI: fix bad method call in scsi_target_destroy
Date: Fri, 12 Feb 2010 12:14:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121211190.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35479 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757310Ab0BLROM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:14:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1336) fixes a bug in scsi_target_destroy().  It calls
the host template's target_destroy method even if the target_alloc
method failed.  (Also, the target_destroy method is called inside the
scope of the host lock, which is unnecessary and probably a mistake.)

A new flag is added to struct scsi_target to remember whether or not
the target_alloc has succeeded.  There also are a couple of minor
whitespace formatting improvements.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -242,6 +242,7 @@ struct scsi_target {
 	unsigned int		single_lun:1;	/* Indicates we should only
 						 * allow I/O to one of the luns
 						 * for the device at a time. */
+	unsigned int		did_target_alloc:1;
 	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
 						/* means no lun present */
 	/* commands actually active on LLD. protected by host lock. */
Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -332,10 +332,10 @@ static void scsi_target_destroy(struct s
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
+	if (starget->did_target_alloc && shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (shost->hostt->target_destroy)
-		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
@@ -442,14 +442,16 @@ static struct scsi_target *scsi_alloc_ta
 	if (shost->hostt->target_alloc) {
 		error = shost->hostt->target_alloc(starget);
 
-		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+		if (error) {
+			dev_printk(KERN_ERR, dev,
+				"target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
 			return NULL;
 		}
 	}
+	starget->did_target_alloc = 1;
 	get_device(dev);
 
 	return starget;

