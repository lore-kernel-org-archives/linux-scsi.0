From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Sat, 28 Aug 2004 22:23:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828202335.GA18962@lst.de>
References: <412EF74A.1070106@torque.net> <4130129F.40503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49570 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268072AbUH1UXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 16:23:46 -0400
Content-Disposition: inline
In-Reply-To: <4130129F.40503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sat, Aug 28, 2004 at 03:05:35PM +1000, Douglas Gilbert wrote:
> Here is a second cut of the patch.
> 
> If James accepts it naturally he is free to enforce the
> appropriate coding style.
> 
> I believe that cleaning up scsi error processing is going
> to be a "work in progress" for a while.

Here's a version with a few small adjustments:

 - moved the code to the scsi_error.c/scsi_eh.c
 - small style cleanups
 - added the two helpers I suggested
 - don't do the memset if we return failure, callers shouldn't look at
   it then

--- linux-2.6.9-rc1-mm1/drivers/scsi/scsi_error.c	2004-08-28 12:17:33.000000000 +0200
+++ linux-2.6.9-rc1-mm1-hch/drivers/scsi/scsi_error.c	2004-08-28 13:20:30.000000000 +0200
@@ -1850,3 +1850,79 @@
 	scsi_next_command(scmd);
 	return rtn;
 }
+
+/**
+ * scsi_normalize_sense - normalize main elements from either fixed or
+ *			descriptor sense data format into a common format.
+ *
+ * @sense_buffer:	byte array containing sense data returned by device
+ * @sb_len:		number of valid bytes in sense_buffer
+ * @sshdr:		pointer to instance of structure that common
+ *			elements are written to. Ignored if NULL.
+ *
+ * Notes:
+ *	The "main elements" from sense data are: response_code, sense_key,
+ *	asc, ascq and additional_length (only for descriptor format).
+ *
+ *	Typically this function can be called after a device has
+ *	responded to a SCSI command with the CHECK_CONDITION status.
+ *
+ * Return value:
+ *	1 if valid sense data information found, else 0;
+ **/
+int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+                         struct scsi_sense_hdr *sshdr)
+{
+	if (!sense_buffer || !sb_len || (sense_buffer[0] & 0x70) != 0x70)
+		return 0;
+
+	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
+
+	sshdr->response_code = (sense_buffer[0] & 0x7f);
+	if (sshdr->response_code >= 0x72) {
+		/*
+		 * descriptor format
+		 */
+		if (sb_len > 1)
+			sshdr->sense_key = (sense_buffer[1] & 0xf);
+		if (sb_len > 2)
+			sshdr->asc = sense_buffer[2];
+		if (sb_len > 3)
+			sshdr->ascq = sense_buffer[3];
+		if (sb_len > 7)
+			sshdr->additional_length = sense_buffer[7];
+	} else {
+		/* 
+		 * fixed format
+		 */
+		if (sb_len > 2)
+			sshdr->sense_key = (sense_buffer[2] & 0xf);
+		if (sb_len > 7) {
+			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
+					 sb_len : (sense_buffer[7] + 8);
+			if (sb_len > 12)
+				sshdr->asc = sense_buffer[12];
+			if (sb_len > 13)
+				sshdr->ascq = sense_buffer[13];
+		}
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(scsi_normalize_sense);
+
+int scsi_request_normalize_sense(struct scsi_request *sreq,
+				 struct scsi_sense_hdr *sshdr)
+{
+	return scsi_normalize_sense(sreq->sr_sense_buffer,
+			sizeof(sreq->sr_sense_buffer), sshdr);
+}
+EXPORT_SYMBOL(scsi_request_normalize_sense);
+
+int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
+				 struct scsi_sense_hdr *sshdr)
+{
+	return scsi_normalize_sense(cmd->sense_buffer,
+			sizeof(cmd->sense_buffer), sshdr);
+}
+EXPORT_SYMBOL(scsi_command_normalize_sense);
--- linux-2.6.9-rc1-mm1/drivers/scsi/scsi_lib.c	2004-08-27 16:41:19.000000000 +0200
+++ linux-2.6.9-rc1-mm1-hch/drivers/scsi/scsi_lib.c	2004-08-28 12:51:09.000000000 +0200
@@ -692,6 +692,7 @@
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
+	struct scsi_sense_hdr sshdr;
 
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
@@ -715,7 +716,10 @@
 			      (CHECK_CONDITION << 1) : (result & 0xff);
 		if (result) {
 			clear_errors = 0;
-			if (cmd->sense_buffer[0] & 0x70) {
+			if (scsi_command_normalize_sense(cmd, &sshdr)) {
+				/*
+				 * SG_IO wants to know about deferred errors
+				 */
 				int len = 8 + cmd->sense_buffer[7];
 
 				if (len > SCSI_SENSE_BUFFERSIZE)
@@ -774,17 +778,17 @@
 	 * can choose a block to remap, etc.
 	 */
 	if (driver_byte(result) != 0) {
-		if ((cmd->sense_buffer[0] & 0x7f) == 0x70) {
+		if (scsi_command_normalize_sense(cmd, &sshdr) &&
+				!scsi_sense_is_deferred(&sshdr)) {
 			/*
 			 * If the device is in the process of becoming ready,
 			 * retry.
 			 */
-			if (cmd->sense_buffer[12] == 0x04 &&
-			    cmd->sense_buffer[13] == 0x01) {
+			if (sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
 				scsi_requeue_command(q, cmd);
 				return;
 			}
-			if ((cmd->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
+			if (sshdr.sense_key == UNIT_ATTENTION) {
 				if (cmd->device->removable) {
 					/* detected disc change.  set a bit 
 					 * and quietly refuse further access.
@@ -813,7 +817,11 @@
 		 * failed, we may have read past the end of the disk.
 		 */
 
-		switch (cmd->sense_buffer[2]) {
+		/*
+		 * XXX: Following is probably broken since deferred errors
+		 *	fall through [dpg 20040827]
+		 */
+		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd->device->use_10_for_rw &&
 			    (cmd->cmnd[0] == READ_10 ||
@@ -835,8 +843,6 @@
 			       req->rq_disk ? req->rq_disk->disk_name : "");
 			cmd = scsi_end_request(cmd, 0, this_count, 1);
 			return;
-			break;
-		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
 			       cmd->device->host->host_no, (int) cmd->device->channel,
@@ -1496,8 +1502,7 @@
 	}
 
 	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
+	memset(sreq->sr_sense_buffer, 0, sizeof(sreq->sr_sense_buffer));
 	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
 	memset(buffer, 0, len);
@@ -1508,14 +1513,21 @@
 	 * ILLEGAL REQUEST sense return identifies the actual command
 	 * byte as the problem.  MODE_SENSE commands can return
 	 * ILLEGAL REQUEST if the code page isn't supported */
-	if (use_10_for_ms && ! scsi_status_is_good(sreq->sr_result) &&
-	    (driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-	    sreq->sr_sense_buffer[2] == ILLEGAL_REQUEST &&
-	    (sreq->sr_sense_buffer[4] & 0x40) == 0x40 &&
-	    sreq->sr_sense_buffer[5] == 0 &&
-	    sreq->sr_sense_buffer[6] == 0 ) {
-		sreq->sr_device->use_10_for_ms = 0;
-		goto retry;
+
+	if (use_10_for_ms && !scsi_status_is_good(sreq->sr_result) &&
+	    (driver_byte(sreq->sr_result) & DRIVER_SENSE)) {
+		struct scsi_sense_hdr sshdr;
+
+		if (scsi_request_normalize_sense(sreq, &sshdr)) {
+			if ((sshdr.sense_key == ILLEGAL_REQUEST) &&
+			    (sshdr.asc == 0x20) && (sshdr.ascq == 0)) {
+				/* 
+				 * Invalid command operation code
+				 */
+				sreq->sr_device->use_10_for_ms = 0;
+				goto retry;
+			}
+		}
 	}
 
 	if(scsi_status_is_good(sreq->sr_result)) {
@@ -1710,4 +1722,3 @@
 	scsi_run_queue(sdev->request_queue);
 }
 EXPORT_SYMBOL(scsi_device_resume);
-
--- linux-2.6.9-rc1-mm1/include/scsi/scsi_eh.h	2004-08-28 12:17:39.000000000 +0200
+++ linux-2.6.9-rc1-mm1-hch/include/scsi/scsi_eh.h	2004-08-28 14:36:26.000000000 +0200
@@ -3,15 +3,48 @@
 
 struct scsi_cmnd;
 struct scsi_device;
+struct scsi_request;
 struct Scsi_Host;
 
+/*
+ * This is a slightly modified SCSI sense "descriptor" format header.
+ * The addition is to allow the 0x70 and 0x71 response codes. The idea
+ * is to place the salient data from either "fixed" or "descriptor" sense
+ * format into one structure to ease application processing.
+ *
+ * The original sense buffer should be kept around for those cases
+ * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
+ */
+struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
+	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+	u8 sense_key;
+	u8 asc;
+	u8 ascq;
+	u8 byte4;
+	u8 byte5;
+	u8 byte6;
+	u8 additional_length;	/* always 0 for fixed sense format */
+};
+
+
 extern void scsi_add_timer(struct scsi_cmnd *, int,
-			   void (*)(struct scsi_cmnd *));
+		void (*)(struct scsi_cmnd *));
 extern int scsi_delete_timer(struct scsi_cmnd *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
+extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
+		struct scsi_sense_hdr *sshdr);
+extern int scsi_request_normalize_sense(struct scsi_request *sreq,
+		struct scsi_sense_hdr *sshdr);
+extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
+		struct scsi_sense_hdr *sshdr);
 
+static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
+{
+	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
+}
+ 
 /*
  * Reset request from external source
  */
