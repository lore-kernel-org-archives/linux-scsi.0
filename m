From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 18:56:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412EF74A.1070106@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040900000006090301090807"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:34198 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269264AbUH0I5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 04:57:33 -0400
Received: from [192.168.48.80] (dsl-215.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.215])
	by borg.st.net.au (Postfix) with ESMTP id 0B50939451D
	for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2004 18:57:27 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040900000006090301090807
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This is a retransmission. My previous post on this
subject doesn't seem to have got through to the list.


After the comments on the RFC for this thread, here is
a patch against lk 2.6.9-rc1 to kick around.

The patch only touches two files: scsi.h and scsi_lib.c
It adds the proposed facility and then uses it in scsi_lib
in roughly 4 locations. IMO there were 3 sense processing errors:
    - block SG_IO did not get passed back deferred errors
      [SG_IO is a __pass-through__ interface!!]
    - MEDIUM_ERRORs _do_ get processed for deferred sense errors
      in scsi_io_completion() which seems unintended
      [I did not fix this one.]
    - invalid command operation code handling in
      __scsi_mode_sense() was just wrong

If people think this is a reasonable approach, then the rest of
the scsi mid-level and upper level driver could be converted.
As Kai pointed we may need some general routines to pick up the
sense data "extras".

The benefit of doing this conversion is that it may well
highlight a lot more sense data processing errors (if the
above is any guide).

Changes:
     - add structure to receive normalized sense data from either
       fixed or descriptor format sense data
     - add scsi_normalize_sense() function to populate that structure
     - add scsi_sense_is_deferred() function so deferred errors can
       be ignored in many contexts
     - apply new mechanism to sense data processing within the
       scsi_lib.c file

Doug Gilbert


--------------040900000006090301090807
Content-Type: text/x-patch;
 name="scsi_sdesc269rc1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_sdesc269rc1.diff"

--- linux/include/scsi/scsi.h	2004-08-25 10:06:42.000000000 +1000
+++ linux/include/scsi/scsi.h269rc1sdesc	2004-08-27 14:35:42.000000000 +1000
@@ -236,6 +236,33 @@
 	__u8 scsi_lun[8];
 };
 
+/* This is a slightly modified SCSI sense "descriptor" format header.
+ * The addition is to allow the 0x70 and 0x71 response codes. The idea
+ * is to place the salient data from either "fixed" or "descriptor" sense
+ * format into one structure to ease application processing.
+ * The original sense buffer should be kept around for those cases
+ * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
+ */
+struct scsi_sense_hd {     /* See SPC-3 section 4.5 */
+    uint8_t response_code; /* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+    uint8_t sense_key;
+    uint8_t asc;
+    uint8_t ascq;
+    uint8_t byte4;
+    uint8_t byte5;
+    uint8_t byte6;
+    uint8_t additional_length; /* always 0 for fixed sense format */
+};
+
+extern int scsi_normalize_sense(const uint8_t * sense_buffer, int sb_len,
+                                struct scsi_sense_hd * sshd);
+
+static inline int scsi_sense_is_deferred(struct scsi_sense_hd * sshd)
+{
+	return (sshd && (sshd->response_code >= 0x70) && 
+		(sshd->response_code & 1)) ? 1 : 0;
+}
+ 
 /*
  *  MESSAGE CODES
  */
--- linux/drivers/scsi/scsi_lib.c	2004-08-25 10:06:39.000000000 +1000
+++ linux/drivers/scsi/scsi_lib.c269rc1sdesc	2004-08-27 15:38:03.000000000 +1000
@@ -692,6 +692,7 @@
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
+	struct scsi_sense_hd sshd;
 
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
@@ -715,7 +716,9 @@
 			      (CHECK_CONDITION << 1) : (result & 0xff);
 		if (result) {
 			clear_errors = 0;
-			if (cmd->sense_buffer[0] & 0x70) {
+			if (scsi_normalize_sense(cmd->sense_buffer,
+					sizeof cmd->sense_buffer, &sshd)) {
+				/* SG_IO wants to know about deferred errors */
 				int len = 8 + cmd->sense_buffer[7];
 
 				if (len > SCSI_SENSE_BUFFERSIZE)
@@ -774,17 +777,18 @@
 	 * can choose a block to remap, etc.
 	 */
 	if (driver_byte(result) != 0) {
-		if ((cmd->sense_buffer[0] & 0x7f) == 0x70) {
+		if (scsi_normalize_sense(cmd->sense_buffer,
+					 SCSI_SENSE_BUFFERSIZE, &sshd) &&
+		    (! scsi_sense_is_deferred(&sshd))) {
 			/*
 			 * If the device is in the process of becoming ready,
 			 * retry.
 			 */
-			if (cmd->sense_buffer[12] == 0x04 &&
-			    cmd->sense_buffer[13] == 0x01) {
+			if (sshd.asc == 0x04 && sshd.ascq == 0x01) {
 				scsi_requeue_command(q, cmd);
 				return;
 			}
-			if ((cmd->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
+			if (sshd.sense_key == UNIT_ATTENTION) {
 				if (cmd->device->removable) {
 					/* detected disc change.  set a bit 
 					 * and quietly refuse further access.
@@ -813,7 +817,9 @@
 		 * failed, we may have read past the end of the disk.
 		 */
 
-		switch (cmd->sense_buffer[2]) {
+/* Following is broken since deferred errors fall through. [dpg 20040827] */
+
+		switch (sshd.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd->device->use_10_for_rw &&
 			    (cmd->cmnd[0] == READ_10 ||
@@ -1496,8 +1502,7 @@
 	}
 
 	sreq->sr_cmd_len = 0;
-	sreq->sr_sense_buffer[0] = 0;
-	sreq->sr_sense_buffer[2] = 0;
+	memset(sreq->sr_sense_buffer, 0, sizeof(sreq->sr_sense_buffer));
 	sreq->sr_data_direction = DMA_FROM_DEVICE;
 
 	memset(buffer, 0, len);
@@ -1508,14 +1513,20 @@
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
+	if (use_10_for_ms && (! scsi_status_is_good(sreq->sr_result)) &&
+	    (driver_byte(sreq->sr_result) & DRIVER_SENSE)) {
+		struct scsi_sense_hd sshd;
+
+		if (scsi_normalize_sense(sreq->sr_sense_buffer,
+			 sizeof sreq->sr_sense_buffer, &sshd)) {
+			if ((sshd.sense_key == ILLEGAL_REQUEST) &&
+			    (sshd.asc == 0x20)) {
+				/* Invalid command operation code */
+				sreq->sr_device->use_10_for_ms = 0;
+				goto retry;
+			}
+		}
 	}
 
 	if(scsi_status_is_good(sreq->sr_result)) {
@@ -1711,3 +1722,55 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+/**
+ *	scsi_normalize_sense - normalize main elements from either fixed
+ *		or descriptor sense data format into a common format.
+ *	@sense_buffer:	byte array containing sense data returned by
+ *			device
+ *	@sb_len:	number of valid bytes in sense_buffer
+ *	@sshd:		pointer to instance of structure that common
+ *			elements are written to. Ignored if NULL.
+ *
+ *	The "main elements" from sense data are: response_code, sense_key,
+ *	asc, ascq and additional_length (only for descriptor format).
+ *	Typically this function can be called after a device has
+ *	responded to a SCSI command with the CHECK_CONDITION status.
+ *
+ *	Returns 1 if valid sense data information found, else 0;
+ **/
+int scsi_normalize_sense(const uint8_t * sense_buffer, int sb_len,
+                         struct scsi_sense_hd * sshd)
+{
+	if (sshd)
+		memset(sshd, 0, sizeof(struct scsi_sense_hd));
+	if ((NULL == sense_buffer) || (0 == sb_len) ||
+	    (0x70 != (0x70 & sense_buffer[0])))
+		return 0;
+	if (NULL == sshd)
+		return 1;
+	sshd->response_code = (0x7f & sense_buffer[0]);
+	if (sshd->response_code >= 0x72) {	/* descriptor format */
+		if (sb_len > 1)
+			sshd->sense_key = (0xf & sense_buffer[1]);
+		if (sb_len > 2)
+			sshd->asc = sense_buffer[2];
+		if (sb_len > 3)
+			sshd->ascq = sense_buffer[3];
+		if (sb_len > 7)
+			sshd->additional_length = sense_buffer[7];
+	} else {				/* fixed format */
+		if (sb_len > 2)
+			sshd->sense_key = (0xf & sense_buffer[2]);
+		if (sb_len > 7) {
+			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
+					 sb_len : (sense_buffer[7] + 8);
+			if (sb_len > 12)
+				sshd->asc = sense_buffer[12];
+			if (sb_len > 13)
+				sshd->ascq = sense_buffer[13];
+		}
+	}
+	return 1;
+}
+EXPORT_SYMBOL(scsi_normalize_sense);
+

--------------040900000006090301090807--
