From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: fix race in scsi_target_reap
Date: Thu, 18 Mar 2010 15:39:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1003181526530.1325-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751204Ab0CRTjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 15:39:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1357) fixes a race in SCSI target allocation and
release.  Putting a target in the STARGET_DEL state isn't protected by
the host lock, so an old target structure could be reused by a new
device even though it's about to be deleted.  The cure is to change
the state while still holding the host lock.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -492,19 +492,20 @@ void scsi_target_reap(struct scsi_target
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 	enum scsi_target_state state;
-	int empty;
+	int empty = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	state = starget->state;
-	empty = --starget->reap_ref == 0 &&
-		list_empty(&starget->devices) ? 1 : 0;
+	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+		empty = 1;
+		starget->state = STARGET_DEL;
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if (!empty)
 		return;
 
 	BUG_ON(state == STARGET_DEL);
-	starget->state = STARGET_DEL;
 	if (state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else

