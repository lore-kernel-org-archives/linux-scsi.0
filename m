From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Thu, 4 Dec 2008 15:49:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812041546260.2180-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754768AbYLDUtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 15:49:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1183) fixes a bug in scsi_check_sense().  The routine is
documented as returning one of SUCCESS, FAILED, or NEEDS_RETRY.  But
in the HARDWARE_ERROR case it can return ADD_TO_MLQUEUE.  And since it
does this without bothering to increment the retry count, it can lead
to an infinite retry loop.

The fix is to return NEEDS_RETRY instead.  Then the caller,
scsi_decide_disposition(), will do the right thing.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -330,7 +330,7 @@ static int scsi_check_sense(struct scsi_
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
-			return ADD_TO_MLQUEUE;
+			return NEEDS_RETRY;
 		else
 			return SUCCESS;
 

