From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: remove command-size switching code
Date: Thu, 25 Sep 2008 15:03:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809251500180.2184-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752466AbYIYTDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 15:03:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1138) removes from sd.c some old code for switching from
10-byte commands to 6-byte commands.  This code is redundant -- the
switching for READ and WRITE is already handled in
scsi_io_completion() and the switching for MODE SENSE is already
handled in scsi_mode_sense().  (There is no comparable switch for MODE
SELECT, but I doubt one is needed.)

Furthermore the other handlers do a better job; they check for
appropriate ASC and ASCQ values before blindly switching the size.
The code in sd.c is known to cause problems with some devices by
switching when it shouldn't.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

What is the point of that strange test against scsi_device_protection?  
It's not present in the comparable part of scsi_io_completion().



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1069,15 +1069,6 @@ static int sd_done(struct scsi_cmnd *SCp
 			scsi_print_sense("sd", SCpnt);
 			good_bytes = sd_completed_bytes(SCpnt);
 		}
-		if (!scsi_device_protection(SCpnt->device) &&
-		    SCpnt->device->use_10_for_rw &&
-		    (SCpnt->cmnd[0] == READ_10 ||
-		     SCpnt->cmnd[0] == WRITE_10))
-			SCpnt->device->use_10_for_rw = 0;
-		if (SCpnt->device->use_10_for_ms &&
-		    (SCpnt->cmnd[0] == MODE_SENSE_10 ||
-		     SCpnt->cmnd[0] == MODE_SELECT_10))
-			SCpnt->device->use_10_for_ms = 0;
 		break;
 	default:
 		break;

