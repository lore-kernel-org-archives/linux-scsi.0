From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix uninitialized variable error in scsi_io_completion
Date: Mon, 15 Dec 2008 10:31:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812151026100.2525-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38483 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751395AbYLOPb3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 10:31:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1191) adds a missing "default" case in
scsi_io_completion(), thereby fixing an "uninitialized variable"
error.  It also adds a missing newline to a log entry.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

James, I'm shocked!  :-)   Didn't you ever try to compile your changes 
to this routine?

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -1024,6 +1024,10 @@ void scsi_io_completion(struct scsi_cmnd
 				case 0x09: /* self test in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
+				default:
+					description = "Device not ready";
+					action = ACTION_FAIL;
+					break;
 				}
 			} else {
 				description = "Device not ready";
@@ -1049,7 +1053,7 @@ void scsi_io_completion(struct scsi_cmnd
 		/* Give up and fail the remainder of the request */
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			if (description)
-				scmd_printk(KERN_INFO, cmd, "%s",
+				scmd_printk(KERN_INFO, cmd, "%s\n",
 					    description);
 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)

