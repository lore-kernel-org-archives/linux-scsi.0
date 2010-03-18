From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: don't kfree an initialized struct device
Date: Thu, 18 Mar 2010 15:41:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1003181531010.1325-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46539 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751089Ab0CRTlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 15:41:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1359) fixes a bug in scsi_alloc_target().  After a
device structure has been initialized (and especially after its name
has been set), it must not be freed directly.  One has to call
put_device() instead.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -458,8 +458,7 @@ static struct scsi_target *scsi_alloc_ta
 	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
-		put_device(parent);
-		kfree(starget);
+		put_device(dev);
 		return found_target;
 	}
 	/* Unfortunately, we found a dying target; need to

