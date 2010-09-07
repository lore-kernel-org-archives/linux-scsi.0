From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: fix medium-removal bug
Date: Tue, 7 Sep 2010 11:27:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1009071125440.1848-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57883 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757349Ab0IGP1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 11:27:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Commit 409f3499a2cfcd1e9c2857c53af7fcce069f027f (scsi/sd: remove big
kernel lock) introduced a bug in the sd_release routine.  Medium
removal should be allowed when the number of open file references
drops to 0, not when it becomes non-zero.

This patch (as1414) adjusts the test to fix the bug.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This patch needs to get into 2.6.36.  2.6.35 and earlier don't contain 
the buggy commit.



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -870,7 +870,7 @@ static int sd_release(struct gendisk *di
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
-	if (atomic_dec_return(&sdkp->openers) && sdev->removable) {
+	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}

