From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 1/2] streamline block SG_IO error processing
Date: Sat, 15 Jan 2005 13:35:32 +1000
Message-ID: <41E88F84.4000304@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000907040001050508020402"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:22213 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262198AbVAODf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 22:35:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------000907040001050508020402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I am working on the assumption that users of the
SG_IO ioctl in the block layer (or via st or osst)
want SCSI status and sense data returned
via the ioctl immediately without:
   - the error/warning silently disappearing and/or being
     hidden by a retry (e.g. UNIT ATTENTION, lu becoming
     ready)
   - noise in the log (or console)
   - any other side effects (save clearing expecting_cc_ua
     if a UNIT ATTENTION was expected)

To this end here are two patches, the first to scsi_lib.c
attached to this post and the second to sd.c in a following
post. Some work may also be needed in the st and osst
drivers.

These patches are against lk 2.6.11-rc1-bk1 which includes
James's "SCSI updates to 2.6.11-rc1" patch.

The descriptor sense patches are now functional in
the mid level (including error reporting functions
in constants.c). The next drivers to visit will be
sd and sg. Medium errors (or hardware errors which seem
synonomous) are an interesting case for sd with big
lus. SBC-2 says that if the sense data information field
is too large to fit in the fixed format sense data then
the valid bit shall be set to 0. This implies big lus
really should be using descriptor sense format.

Changelog:
   - cleanup scsi_end_request() documentation
   - shorten path for block SG_IO through scsi_io_completion()
   - for non-SG_IO sense processing in scsi_io_completion():
      - ignore deferred errors (report + retry should suffice)
      - consolidate into a cleaner switch statement

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------000907040001050508020402
Content-Type: text/x-patch;
 name="slib2611rc1bk1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slib2611rc1bk1.diff"

--- linux/drivers/scsi/scsi_lib.c	2005-01-14 12:08:37.000000000 +1000
+++ linux/drivers/scsi/scsi_lib.c2611rc1bk1med	2005-01-15 11:34:03.000000000 +1000
@@ -498,19 +498,17 @@
 /*
  * Function:    scsi_end_request()
  *
- * Purpose:     Post-processing of completed commands called from interrupt
- *              handler or a bottom-half handler.
+ * Purpose:     Post-processing of completed commands (usually invoked at end
+ *		of upper level post-processing and scsi_io_completion).
  *
  * Arguments:   cmd	 - command that is complete.
- *              uptodate - 1 if I/O indicates success, 0 for I/O error.
- *              sectors  - number of sectors we want to mark.
+ *              uptodate - 1 if I/O indicates success, <= 0 for I/O error.
+ *              bytes    - number of bytes of completed I/O
  *		requeue  - indicates whether we should requeue leftovers.
- *		frequeue - indicates that if we release the command block
- *			   that the queue request function should be called.
  *
  * Lock status: Assumed that lock is not held upon entry.
  *
- * Returns:     Nothing
+ * Returns:     cmd if requeue done or required, NULL otherwise
  *
  * Notes:       This is called for block device requests in order to
  *              mark some number of sectors as complete.
@@ -694,8 +692,9 @@
 	int this_count = cmd->bufflen;
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	int clear_errors = 1;
 	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
+	int sense_deferred = 0;
 
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
@@ -714,11 +713,15 @@
 		kfree(cmd->buffer);
 	}
 
+	if (result) {
+		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
+		if (sense_valid)
+			sense_deferred = scsi_sense_is_deferred(&sshdr);
+	}
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = result;
 		if (result) {
-			clear_errors = 0;
-			if (scsi_command_normalize_sense(cmd, &sshdr)) {
+			if (sense_valid) {
 				/*
 				 * SG_IO wants current and deferred errors
 				 */
@@ -742,6 +745,11 @@
 	cmd->request_buffer = NULL;
 	cmd->request_bufflen = 0;
 
+	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+		scsi_end_request(cmd, 1, good_bytes, 0);
+		return;
+	}
+
 	/*
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
@@ -751,8 +759,7 @@
 					      req->nr_sectors, good_bytes));
 		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
-		if (clear_errors)
-			req->errors = 0;
+		req->errors = 0;
 		/*
 		 * If multiple sectors are requested in one buffer, then
 		 * they will have been finished off by the first command.
@@ -779,52 +786,37 @@
 	 * sense buffer.  We can extract information from this, so we
 	 * can choose a block to remap, etc.
 	 */
-	if (driver_byte(result) != 0) {
-		if (scsi_command_normalize_sense(cmd, &sshdr) &&
-				!scsi_sense_is_deferred(&sshdr)) {
-			/*
-			 * If the device is in the process of becoming ready,
-			 * retry.
-			 */
-			if (sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
+	if (sense_valid && (! sense_deferred)) {
+		switch (sshdr.sense_key) {
+		case UNIT_ATTENTION:
+			if (cmd->device->removable) {
+				/* detected disc change.  set a bit 
+				 * and quietly refuse further access.
+				 */
+				cmd->device->changed = 1;
+				cmd = scsi_end_request(cmd, 0,
+						this_count, 1);
+				return;
+			} else {
+				/*
+				* Must have been a power glitch, or a
+				* bus reset.  Could not have been a
+				* media change, so we just retry the
+				* request and see what happens.  
+				*/
 				scsi_requeue_command(q, cmd);
 				return;
 			}
-			if (sshdr.sense_key == UNIT_ATTENTION) {
-				if (cmd->device->removable) {
-					/* detected disc change.  set a bit 
-					 * and quietly refuse further access.
-		 			 */
-					cmd->device->changed = 1;
-					cmd = scsi_end_request(cmd, 0,
-							this_count, 1);
-					return;
-				} else {
-					/*
-				 	* Must have been a power glitch, or a
-				 	* bus reset.  Could not have been a
-				 	* media change, so we just retry the
-				 	* request and see what happens.  
-				 	*/
-					scsi_requeue_command(q, cmd);
-					return;
-				}
-			}
-		}
-		/*
-		 * If we had an ILLEGAL REQUEST returned, then we may have
-		 * performed an unsupported command.  The only thing this
-		 * should be would be a ten byte read where only a six byte
-		 * read was supported.  Also, on a system where READ CAPACITY
-		 * failed, we may have read past the end of the disk.
-		 */
-
-		/*
-		 * XXX: Following is probably broken since deferred errors
-		 *	fall through [dpg 20040827]
-		 */
-		switch (sshdr.sense_key) {
+			break;
 		case ILLEGAL_REQUEST:
+			/*
+		 	* If we had an ILLEGAL REQUEST returned, then we may
+		 	* have performed an unsupported command.  The only
+		 	* thing this should be would be a ten byte read where
+			* only a six byte read was supported.  Also, on a
+			* system where READ CAPACITY failed, we may have read
+			* past the end of the disk.
+		 	*/
 			if (cmd->device->use_10_for_rw &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
@@ -841,6 +833,14 @@
 			}
 			break;
 		case NOT_READY:
+			/*
+			 * If the device is in the process of becoming ready,
+			 * retry.
+			 */
+			if (sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
+				scsi_requeue_command(q, cmd);
+				return;
+			}
 			printk(KERN_INFO "Device %s not ready.\n",
 			       req->rq_disk ? req->rq_disk->disk_name : "");
 			cmd = scsi_end_request(cmd, 0, this_count, 1);

--------------000907040001050508020402--
