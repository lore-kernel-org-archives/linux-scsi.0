From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: don't turn off use_10_for_rw too eagerly
Date: Thu, 28 Sep 2006 15:35:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0609281532320.8448-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:9231 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1161022AbWI1Tfe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 15:35:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

I've run across a few reports of USB mass storage devices which, for
whatever bizarre reason, sometimes return a failure with sense key =
Invalid Request, ASC = Invalid op code.  This happens when the command
is READ(10) or WRITE(10), in spite of the fact that the device really
does accept the 10-byte command forms and not the 6-byte forms.

This patch (as795) keeps track of whether devices do accept READ(10)
and WRITE(10), and avoids turning off sdev->use_10_for_rw for these
devices when they return bogus sense data.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

James:

There are two potential weaknesses in the patch.  One is that when the bad
sense data occurs, it unconditionally calls scsi_requeue_command().  Could
this lead to an infinite loop?
                
The second is that it dynamically records the success of every READ(10) or
WRITE(10) command for every disk device.  Perhaps it would be better to
set the new flag just once for USB devices that are known to accept the
10-byte commands and then leave it.  What do you think?

Alan Stern


Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -929,6 +929,18 @@ static void sd_rw_intr(struct scsi_cmnd 
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
+
+	/*
+	 * Some buggy devices return ILLEGAL_REQUEST sense for READ_10
+	 * or WRITE_10 even though they do accept those commands.
+	 * To prevent confusion, we will avoid switching to READ_6/WRITE_6
+	 * if _any_ READ_10/WRITE_10 has ever been accepted.
+	 */
+	else {
+		if (SCpnt->cmnd[0] == READ_10 || SCpnt->cmnd[0] == WRITE_10)
+			SCpnt->device->keep_10_for_rw = 1;
+	}
+
 #ifdef CONFIG_SCSI_LOGGING
 	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
 				SCpnt->request->rq_disk->disk_name, result));
@@ -990,10 +1002,6 @@ static void sd_rw_intr(struct scsi_cmnd 
 		good_bytes = xfer_size;
 		break;
 	case ILLEGAL_REQUEST:
-		if (SCpnt->device->use_10_for_rw &&
-		    (SCpnt->cmnd[0] == READ_10 ||
-		     SCpnt->cmnd[0] == WRITE_10))
-			SCpnt->device->use_10_for_rw = 0;
 		if (SCpnt->device->use_10_for_ms &&
 		    (SCpnt->cmnd[0] == MODE_SENSE_10 ||
 		     SCpnt->cmnd[0] == MODE_SELECT_10))
Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -112,6 +112,7 @@ struct scsi_device {
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
+	unsigned keep_10_for_rw:1;	/* 10-byte read/writes known to work */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -895,10 +895,16 @@ void scsi_io_completion(struct scsi_cmnd
 			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
-				cmd->device->use_10_for_rw = 0;
-				/* This will cause a retry with a
-				 * 6-byte command.
+				/* If we know the device accepts READ_10
+				 * or WRITE_10, don't switch the size.
+				 * Just retry, since the sense is bogus.
 				 */
+				if (!cmd->device->keep_10_for_rw) {
+					/* This will cause a retry with a
+					 * 6-byte command.
+					 */
+					cmd->device->use_10_for_rw = 0;
+				}
 				scsi_requeue_command(q, cmd);
 				return;
 			} else {

