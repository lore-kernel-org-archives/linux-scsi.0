From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as373) Let LLD specify INQUIRY length
Date: Tue, 7 Sep 2004 16:47:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409071628510.809-100000@ida.rowland.org>
References: <20040826201128.A23103@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2820 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268634AbUIGUrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 16:47:06 -0400
In-Reply-To: <20040826201128.A23103@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 26 Aug 2004, Christoph Hellwig wrote:

> Maybe instead of adding gazillions of blacklists for different inquiry
> lengthes we should just add an max_inquiry_length field to scsi_device
> that can be set in slave_alloc?

That sounds like a good suggestion.  Even better, instead of adding a new 
field we can simply use the existing inquiry_length.

This patch changes scsi_probe_lun() to use the value in 
sdev->inquiry_length for the first INQUIRY attempt, if that value is 
nonzero.  Subsequent attempts are based, as before, on the blacklist flags 
and the Additional Length field in the INQUIRY data.

The patch also contains a fairly extensive reorganization of the 
subroutine.  All the code that was duplicated for sending the INQUIRY 
command twice has been consolidated.  The routine now makes up to three 
passes:

	In the first pass, the transfer length is the value initially
	found in sdev->inquiry_length if that has been set, otherwise
	it is the current conservative 36 bytes.

	If the first pass succeeds, the routine retrieves the blist flags
	for the device and checks the Additional Length field.  The blist
	flags take precedence over sdev->inquiry_length, which in turn
	takes precedence over the Additional Length.  If it turns out
	there is more data available than we transferred the first time,
	a second pass tries to get it.

	If the second pass succeeds the INQUIRY data may have changed,
	so the blist flags are looked up again and the Additional Length
	is checked again.  If not, a third pass tries to get the data 
	back, using the same transfer length as the first pass.

Finally, the value stored in sdev->inquiry_length is set to the amount
actually transferred or the size computed from the Additional Length, 
whichever is smaller.

Although the net change in the source file size is small, the new routine 
has more comments and less code.  Overall I think it's an improvement.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_scan.c 1.62 vs edited =====
--- 1.62/drivers/scsi/scsi_scan.c	Mon Jun 28 10:44:56 2004
+++ edited/drivers/scsi/scsi_scan.c	Tue Sep  7 15:38:10 2004
@@ -346,104 +346,113 @@
 {
 	struct scsi_device *sdev = sreq->sr_device;	/* a bit ugly */
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	int possible_inq_resp_len;
-	int count = 0;
+	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
+	int response_len = 0;
+	int pass, count;
 
 	*bflags = 0;
- repeat_inquiry:
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
-			" channel %d id %d lun %d\n", sdev->host->host_no,
-			sdev->channel, sdev->id, sdev->lun));
-
-	memset(scsi_cmd, 0, 6);
-	scsi_cmd[0] = INQUIRY;
-	scsi_cmd[4] = 36;	/* issue conservative alloc_length */
-	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
-
-	memset(inq_result, 0, 36);
-	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result, 36,
-		      HZ/2 + HZ*scsi_inq_timeout, 3);
-
-	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s with"
-			" code 0x%x\n", sreq->sr_result ?
-			"failed" : "successful", sreq->sr_result));
-	++count;
-
-	if (sreq->sr_result) {
-		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
-		    (sreq->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
-		    (sreq->sr_sense_buffer[12] == 0x28 ||
-		     sreq->sr_sense_buffer[12] == 0x29) &&
-		    sreq->sr_sense_buffer[13] == 0) {
-			/* not-ready to ready transition or power-on - good */
-			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
-			/* Supposedly, but many buggy devices do so anyway */
-			if (count < 3)
-				goto repeat_inquiry;
-		}
-		/*
-		 * assume no peripheral if any other sort of error
-		 */
-		return;
-	}
 
-	/*
-	 * Get any flags for this device.
-	 *
-	 * XXX add a bflags to Scsi_Device, and replace the corresponding
-	 * bit fields in Scsi_Device, so bflags need not be passed as an
-	 * argument.
-	 */
-	*bflags |= scsi_get_device_flags(sdev, &inq_result[8], &inq_result[16]);
-
-	possible_inq_resp_len = (unsigned char) inq_result[4] + 5;
-	if (BLIST_INQUIRY_36 & *bflags)
-		possible_inq_resp_len = 36;
-	else if (BLIST_INQUIRY_58 & *bflags)
-		possible_inq_resp_len = 58;
-	else if (possible_inq_resp_len > 255)
-		possible_inq_resp_len = 36;	/* sanity */
+	/* Perform up to 3 passes.  The first pass uses a conservative
+	 * transfer length of 36 unless sdev->inquiry_len specifies a
+	 * different value. */
+	first_inquiry_len = sdev->inquiry_len ? sdev->inquiry_len : 36;
+	try_inquiry_len = first_inquiry_len;
+	pass = 1;
+
+ next_pass:
+	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY pass %d "
+			"to host %d channel %d id %d lun %d, length %d\n",
+			pass, sdev->host->host_no, sdev->channel,
+			sdev->id, sdev->lun, try_inquiry_len));
 
-	if (possible_inq_resp_len > 36) {	/* do additional INQUIRY */
+	/* Each pass gets up to three chances to ignore Unit Attention */
+	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
-		scsi_cmd[4] = (unsigned char) possible_inq_resp_len;
+		scsi_cmd[4] = (unsigned char) try_inquiry_len;
 		sreq->sr_cmd_len = 0;
 		sreq->sr_data_direction = DMA_FROM_DEVICE;
-		/*
-		 * re-zero inq_result just to be safe.
-		 */
-		memset(inq_result, 0, possible_inq_resp_len);
-		scsi_wait_req(sreq, (void *) scsi_cmd,
-			      (void *) inq_result,
-			      possible_inq_resp_len, (1+scsi_inq_timeout)*(HZ/2), 3);
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
-				" %s with code 0x%x\n", sreq->sr_result ?
-				"failed" : "successful", sreq->sr_result));
+
+		memset(inq_result, 0, try_inquiry_len);
+		scsi_wait_req(sreq, (void *) scsi_cmd, (void *) inq_result,
+				try_inquiry_len,
+				HZ/2 + HZ*scsi_inq_timeout, 3);
+
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
+				"with code 0x%x\n",
+				sreq->sr_result ? "failed" : "successful",
+				sreq->sr_result));
+
 		if (sreq->sr_result) {
-			/* if the longer inquiry has failed, flag the device
-			 * as only accepting 36 byte inquiries and retry the
-			 * 36 byte inquiry */
-			printk(KERN_INFO "scsi scan: %d byte inquiry failed"
-			       " with code %d.  Consider BLIST_INQUIRY_36 for"
-			       " this device\n", possible_inq_resp_len,
-			       sreq->sr_result);
-			*bflags = BLIST_INQUIRY_36;
-			goto repeat_inquiry;
+
+			/* not-ready to ready transition or power-on - good */
+			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
+			/* Supposedly, but many buggy devices do so anyway. */
+			if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
+					(sreq->sr_sense_buffer[2] & 0xf) ==
+						UNIT_ATTENTION &&
+					(sreq->sr_sense_buffer[12] == 0x28 ||
+					 sreq->sr_sense_buffer[12] == 0x29) &&
+					sreq->sr_sense_buffer[13] == 0)
+				continue;
 		}
+		break;
+	}
+
+	if (sreq->sr_result == 0) {
+		response_len = (unsigned char) inq_result[4] + 5;
+		if (response_len > 255)
+			response_len = first_inquiry_len;	/* sanity */
 
 		/*
-		 * The INQUIRY can change, this means the length can change.
+		 * Get any flags for this device.
+		 *
+		 * XXX add a bflags to Scsi_Device, and replace the
+		 * corresponding bit fields in Scsi_Device, so bflags
+		 * need not be passed as an argument.
 		 */
-		possible_inq_resp_len = (unsigned char) inq_result[4] + 5;
-		if (BLIST_INQUIRY_58 & *bflags)
-			possible_inq_resp_len = 58;
-		else if (possible_inq_resp_len > 255)
-			possible_inq_resp_len = 36;	/* sanity */
+		*bflags = scsi_get_device_flags(sdev, &inq_result[8],
+				&inq_result[16]);
+
+		/* When the first pass succeeds we gain information about
+		 * what larger transfer lengths might work. */
+		if (pass == 1) {
+			if (BLIST_INQUIRY_36 & *bflags)
+				next_inquiry_len = 36;
+			else if (BLIST_INQUIRY_58 & *bflags)
+				next_inquiry_len = 58;
+			else if (sdev->inquiry_len)
+				next_inquiry_len = sdev->inquiry_len;
+			else
+				next_inquiry_len = response_len;
+
+			/* If more data is available perform the second pass */
+			if (next_inquiry_len > try_inquiry_len) {
+				try_inquiry_len = next_inquiry_len;
+				pass = 2;
+				goto next_pass;
+			}
+		}
+
+	} else if (pass == 2) {
+		printk(KERN_INFO "scsi scan: %d byte inquiry failed.  "
+				"Consider BLIST_INQUIRY_36 for this device\n",
+				try_inquiry_len);
+
+		/* If this pass failed, the third pass goes back and transfers
+		 * the same amount as we successfully got in the first pass. */
+		try_inquiry_len = first_inquiry_len;
+		pass = 3;
+		goto next_pass;
 	}
 
-	sdev->inquiry_len = possible_inq_resp_len;
+	/* If the last transfer attempt got an error, assume the
+	 * peripheral doesn't exist or is dead. */
+	if (sreq->sr_result)
+		return;
+
+	/* Don't report any more data than the device says is valid */
+	sdev->inquiry_len = min(try_inquiry_len, response_len);
 
 	/*
 	 * XXX Abort if the response length is less than 36? If less than

