From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Wed, 21 Apr 2004 10:43:22 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404211041220.1106-100000@ida.rowland.org>
References: <40860003.1070406@nogin.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:13326 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263147AbUDUOnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 10:43:23 -0400
In-Reply-To: <40860003.1070406@nogin.org>
List-Id: linux-scsi@vger.kernel.org
To: Aleksey Nogin <aleksey@nogin.org>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Apr 2004, Aleksey Nogin wrote:

> Thanks a lot for your feedback. Unfortunately, your patch does not seem 
> to affect anything.

Yes, now you come to mention it, I see there isn't any code in there to 
retry the INQUIRY command after a Unit Attention!  All right, try this 
patch instead.

Alan Stern


===== drivers/scsi/scsi_scan.c 1.57 vs edited =====
--- 1.57/drivers/scsi/scsi_scan.c	Wed Mar 17 14:05:26 2004
+++ edited/drivers/scsi/scsi_scan.c	Wed Apr 21 10:40:06 2004
@@ -331,6 +331,7 @@
 	struct scsi_device *sdev = sreq->sr_device;	/* a bit ugly */
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int possible_inq_resp_len;
+	int count = 0;
 
 	*bflags = 0;
  repeat_inquiry:
@@ -351,14 +352,19 @@
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
+			/* Supposedly, but many buggy devices do so anyway */
+			if (count < 3)
+				goto repeat_inquiry;
 		} else
 			/*
 			 * assume no peripheral if any other sort of error

