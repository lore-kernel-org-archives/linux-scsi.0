From: Alan Stern <stern@rowland.harvard.edu>
Subject: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Mon, 28 Jul 2003 10:10:33 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
References: <20030724153505.GC1063@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269670AbTG1NzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 09:55:21 -0400
In-Reply-To: <20030724153505.GC1063@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Jens:

This patch changes the scsi_mode_sense() routine to retry up to a total of 
3 times if a command fails with a UNIT ATTENTION sense key value.

Without this change, sr.c does not properly read the capabilities mode 
page for a just-powered-up cdrom drive -- it gives up upon receiving a 
Device Reset Occurred code.

The patch looks lengthy, but most of it just changes the indentation 
level.

Alan Stern


--- 2.6.0-orig/drivers/scsi/scsi_lib.c	Thu Jul 17 15:49:29 2003
+++ 2.6.0/drivers/scsi/scsi_lib.c	Sat Jul 26 10:30:49 2003
@@ -1375,55 +1375,63 @@
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
+	int my_retries;
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
- retry:
-	use_10_for_ms = sreq->sr_device->use_10_for_ms;
+	for (my_retries = 0; my_retries < 3; ++my_retries) {
+		use_10_for_ms = sreq->sr_device->use_10_for_ms;
 
-	if (use_10_for_ms) {
-		if (len < 8)
-			len = 8;
-
-		cmd[0] = MODE_SENSE_10;
-		cmd[8] = len;
-		header_length = 8;
-	} else {
-		if (len < 4)
-			len = 4;
-
-		cmd[0] = MODE_SENSE;
-		cmd[4] = len;
-		header_length = 4;
+		if (use_10_for_ms) {
+			if (len < 8)
+				len = 8;
+
+			cmd[0] = MODE_SENSE_10;
+			cmd[8] = len;
+			header_length = 8;
+		} else {
+			if (len < 4)
+				len = 4;
+
+			cmd[0] = MODE_SENSE;
+			cmd[4] = len;
+			header_length = 4;
+		}
+
+		sreq->sr_cmd_len = 0;
+		sreq->sr_sense_buffer[0] = 0;
+		sreq->sr_sense_buffer[2] = 0;
+		sreq->sr_data_direction = DMA_FROM_DEVICE;
+
+		memset(buffer, 0, len);
+
+		scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
+
+		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
+		    sreq->sr_sense_buffer[2] == UNIT_ATTENTION)
+			continue;
+
+		/* This code looks awful: what it's doing is making sure an
+		 * ILLEGAL REQUEST sense return identifies the actual command
+		 * byte as the problem.  MODE_SENSE commands can return
+		 * ILLEGAL REQUEST if the code page isn't supported */
+		if (use_10_for_ms && ! scsi_status_is_good(sreq->sr_result) &&
+		    (driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
+		    sreq->sr_sense_buffer[2] == ILLEGAL_REQUEST &&
+		    (sreq->sr_sense_buffer[4] & 0x40) == 0x40 &&
+		    sreq->sr_sense_buffer[5] == 0 &&
+		    sreq->sr_sense_buffer[6] == 0 ) {
+			sreq->sr_device->use_10_for_ms = 0;
+			continue;
+		}
+		if (scsi_status_is_good(sreq->sr_result))
+			break;
 	}
 
-	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
-
-	memset(buffer, 0, len);
-
-	scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
-
-	/* This code looks awful: what it's doing is making sure an
-	 * ILLEGAL REQUEST sense return identifies the actual command
-	 * byte as the problem.  MODE_SENSE commands can return
-	 * ILLEGAL REQUEST if the code page isn't supported */
-	if (use_10_for_ms && ! scsi_status_is_good(sreq->sr_result) &&
-	    (driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-	    sreq->sr_sense_buffer[2] == ILLEGAL_REQUEST &&
-	    (sreq->sr_sense_buffer[4] & 0x40) == 0x40 &&
-	    sreq->sr_sense_buffer[5] == 0 &&
-	    sreq->sr_sense_buffer[6] == 0 ) {
-		sreq->sr_device->use_10_for_ms = 0;
-		goto retry;
-	}
-
-	if(scsi_status_is_good(sreq->sr_result)) {
+	if (scsi_status_is_good(sreq->sr_result)) {
 		data->header_length = header_length;
 		if(use_10_for_ms) {
 			data->length = buffer[0]*256 + buffer[1];

