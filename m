From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as255) Handle Unit Attention during INQUIRY better
Date: Wed, 21 Apr 2004 17:12:09 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404211705270.1740-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:34318 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263708AbUDUVML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 17:12:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

Some buggy USB storage devices can return Unit Attention status for
INQUIRY commands.  The current code in scsi_scan.c checks for ASC = 0x28 =
Not ready to ready transition, but these devices can also return ASC =
0x29 = Power-on or reset occurred.  In addition, the code doesn't retry
the INQUIRY when these codes are received.

Please verify this patch is correct and apply it (or something like it).

Alan Stern


===== scsi_scan.c 1.57 vs edited =====
--- 1.57/drivers/scsi/scsi_scan.c	Wed Mar 17 14:05:26 2004
+++ edited/drivers/scsi/scsi_scan.c	Wed Apr 21 17:04:15 2004
@@ -331,6 +331,7 @@
 	struct scsi_device *sdev = sreq->sr_device;	/* a bit ugly */
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int possible_inq_resp_len;
+	int count = 0;
 
 	*bflags = 0;
  repeat_inquiry:
@@ -351,19 +352,24 @@
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
 			" code 0x%x\n", sreq->sr_result ?
 			"failed" : "successful", sreq->sr_result));
+	++count;
 
 	if (sreq->sr_result) {
 		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
 		    (sreq->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
-		    sreq->sr_sense_buffer[12] == 0x28 &&
+		    (sreq->sr_sense_buffer[12] == 0x28 ||
+		     sreq->sr_sense_buffer[12] == 0x29) &&
 		    sreq->sr_sense_buffer[13] == 0) {
-			/* not-ready to ready transition - good */
+			/* not-ready to ready transition or power-on - good */
 			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
-		} else
-			/*
-			 * assume no peripheral if any other sort of error
-			 */
-			return;
+			/* Supposedly, but many buggy devices do so anyway */
+			if (count < 3)
+				goto repeat_inquiry;
+		}
+		/*
+		 * assume no peripheral if any other sort of error
+		 */
+		return;
 	}
 
 	/*

