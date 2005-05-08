From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_cmnd->resid handling for sd, 2.6.12-rc4
Date: Sun, 08 May 2005 21:06:27 +1000
Message-ID: <427DF2B3.3070700@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060607000702060206080304"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:5804 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261450AbVEHLJr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 May 2005 07:09:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: aherrman@de.ibm.com

This is a multi-part message in MIME format.
--------------060607000702060206080304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Further to the thread titled: "evaluation of scsi_cmnd->resid"
started by Andreas Herrmann on 2005/4/13, the attachment
adds resid handling to the sd driver. The patch is against
lk 2.6.12-rc4 .

It treats a "short" DMA read operation in a similar fashion
to a MEDIUM ERROR. This way the block layer gets as much
valid data as is available. Pathological double errors
are not handled (e.g. a MEDIUM ERROR on a latter sector
in a multi sector read plus a resid that indicates even
less data was read (than the MEDIUM ERROR indicates)).

The resid field in the scsi_cmnd structure is initialized
to zero so older LLDs that don't set it will not trip up
the proposed new code.
[resid = requested_xfer_len - actual_xfer_len]

While testing this patch I noticed MEDIUM ERRORs and
resid>0 on READs (since it mimics the former) do not
cause errors to appear in the log. Mid level logging
does show what is happening but it is not very
practical to have that on for very long. Reporting
and counting these occurrences may be a good idea.


ChangeLog:
   - in the sd driver check if the LLD reports an
     abridged DMA transfer on READ operations.
     If so process in a similar fashion to a
     MEDIUM ERROR condition.


Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------060607000702060206080304
Content-Type: text/x-patch;
 name="sd2612rc4resid.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd2612rc4resid.diff"

--- linux/drivers/scsi/sd.c	2005-05-07 16:18:00.000000000 +1000
+++ linux/drivers/scsi/sd.c2612rc4resid	2005-05-08 12:36:34.000000000 +1000
@@ -843,6 +843,9 @@
 {
 	int result = SCpnt->result;
 	int this_count = SCpnt->bufflen;
+	int resid = SCpnt->resid;
+	int opcode = SCpnt->cmnd[0];
+	struct request * req = SCpnt->request;
 	int good_bytes = (result == 0 ? this_count : 0);
 	sector_t block_sectors = 1;
 	u64 first_err_block;
@@ -859,12 +862,18 @@
 	}
 
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
-				SCpnt->request->rq_disk->disk_name, result));
+	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: opcode=0x%x "
+				"res=0x%x\n", req->rq_disk->disk_name,
+				opcode, result));
 	if (sense_valid) {
-		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[respc,sk,asc,"
-				"ascq]=%x,%x,%x,%x\n", sshdr.response_code,
-				sshdr.sense_key, sshdr.asc, sshdr.ascq));
+		SCSI_LOG_HLCOMPLETE(1, printk("  sd_rw_intr: sb[respc,sk,asc,"
+				"ascq]=%x,%x,%x,%x  %s\n",
+			sshdr.response_code, sshdr.sense_key, sshdr.asc,
+			sshdr.ascq, (sense_deferred ? "DEFERRED" : "")));
+	}
+	if (resid) {
+		SCSI_LOG_HLCOMPLETE(1, printk("  sd_rw_intr: resid=%d\n",
+					resid));
 	}
 #endif
 	/*
@@ -878,13 +887,13 @@
 	 * else if errors, check them, and if necessary prepare for
 	 * (partial) retries.
 	 */
-	if (blk_pc_request(SCpnt->request))
+	if (blk_pc_request(req))
 		good_bytes = this_count;
 	else if (driver_byte(result) != 0 &&
 		 sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case MEDIUM_ERROR:
-			if (!blk_fs_request(SCpnt->request))
+			if (!blk_fs_request(req))
 				break;
 			info_valid = scsi_get_sense_info_fld(
 				SCpnt->sense_buffer, SCSI_SENSE_BUFFERSIZE,
@@ -894,8 +903,8 @@
 			 * in actual truncation (if sector_t < 64 bits)
 			 */
 			error_sector = (sector_t)first_err_block;
-			if (SCpnt->request->bio != NULL)
-				block_sectors = bio_sectors(SCpnt->request->bio);
+			if (req->bio != NULL)
+				block_sectors = bio_sectors(req->bio);
 			switch (SCpnt->device->sector_size) {
 			case 1024:
 				error_sector <<= 1;
@@ -920,7 +929,7 @@
 			}
 
 			error_sector &= ~(block_sectors - 1);
-			good_bytes = (error_sector - SCpnt->request->sector) << 9;
+			good_bytes = (error_sector - req->sector) << 9;
 			if (good_bytes < 0 || good_bytes >= this_count)
 				good_bytes = 0;
 			break;
@@ -930,6 +939,10 @@
 			/*
 			 * Inform the user, but make sure that it's not treated
 			 * as a hard error.
+			 * N.B. This could be a "Failure prediction threshold
+			 * exceeded" type message (depending on MRIE setting
+			 * in IEC mode page). Ignore such a message at your
+			 * peril.
 			 */
 			scsi_print_sense("sd", SCpnt);
 			SCpnt->result = 0;
@@ -939,18 +952,45 @@
 
 		case ILLEGAL_REQUEST:
 			if (SCpnt->device->use_10_for_rw &&
-			    (SCpnt->cmnd[0] == READ_10 ||
-			     SCpnt->cmnd[0] == WRITE_10))
+			    (opcode == READ_10 || opcode == WRITE_10))
 				SCpnt->device->use_10_for_rw = 0;
 			if (SCpnt->device->use_10_for_ms &&
-			    (SCpnt->cmnd[0] == MODE_SENSE_10 ||
-			     SCpnt->cmnd[0] == MODE_SELECT_10))
+			    (opcode == MODE_SENSE_10 ||
+			     opcode == MODE_SELECT_10))
 				SCpnt->device->use_10_for_ms = 0;
 			break;
 
 		default:
 			break;
 		}
+	} else if ((resid > 0) &&
+		((opcode == READ_6) || (opcode == READ_10) ||
+		 (opcode == READ_16))) {
+		/*
+		 * During a read operation the LLD DMA element has indicated
+		 * that less bytes were read than requested.
+		 * Assume truncated DMA transfers on WRITE operations
+		 * are reported by device.
+		 */
+		if (req->bio != NULL)
+			block_sectors = bio_sectors(req->bio);
+		switch (SCpnt->device->sector_size) {
+		case 1024:
+			if (block_sectors < 2)
+				block_sectors = 2;
+			break;
+		case 2048:
+			if (block_sectors < 4)
+				block_sectors = 4;
+			break;
+		case 4096:
+			if (block_sectors < 8)
+				block_sectors = 8;
+			break;
+		default:
+			break;
+		}
+		good_bytes = (this_count > resid) ? (this_count - resid) : 0;
 	}
 	/*
 	 * This calls the generic completion function, now that we know

--------------060607000702060206080304--
