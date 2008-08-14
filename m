From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Thu, 14 Aug 2008 15:41:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808141535350.2148-100000@iolanthe.rowland.org>
References: <48A30DC7.8070501@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55670 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754800AbYHNTl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 15:41:29 -0400
In-Reply-To: <48A30DC7.8070501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Antonio Ospite <ospite@studenti.unina.it>

On Wed, 13 Aug 2008, Boaz Harrosh wrote:

> One thing I don't like is the now blk_end_request(req, -EIO, bytes=0)
> inside scsi_end_request(). What's the point of calling that with 0 bytes?
> Maybe fix that too.

While testing the patch, I learned what the point is.  :-)

Actually it's very simple; you just have to remember that not all 
requests are BLOCK_FS type.  Other types of request can indeed have a 
transfer length of 0, and we want to end those requests normally.

So this version of the patch works better than the earlier one.  In 
principle there doesn't seem to be any reason not to call 
blk_end_request with bytes = 0, but I left the test in there.

Alan, you might want to test this version and see how well it works for 
you.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -674,16 +674,13 @@ static struct scsi_cmnd *scsi_end_reques
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
+	if (unlikely(bytes == 0 && blk_fs_request(req)) ||
+			blk_end_request(req, error, bytes)) {
 
 		/* kill remainder if no retrys */
-		if (error && blk_noretry_request(req))
-			blk_end_request(req, error, leftover);
-		else {
+		if (error && blk_noretry_request(req)) {
+			blk_end_request(req, error, blk_rq_bytes(req));
+		} else {
 			if (requeue) {
 				/*
 				 * Bleah.  Leftovers again.  Stick the
@@ -852,7 +849,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = scsi_bufflen(cmd);
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -909,9 +905,6 @@ void scsi_io_completion(struct scsi_cmnd
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
-	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
@@ -920,8 +913,7 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				scsi_end_request(cmd, -EIO, this_count, 1);
-				return;
+				goto retry;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
@@ -951,15 +943,13 @@ void scsi_io_completion(struct scsi_cmnd
 				 */
 				scsi_requeue_command(q, cmd);
 			} else if (sshdr.asc == 0x10) /* DIX */
-				scsi_end_request(cmd, -EIO, this_count, 0);
+				goto fail;
 			else
-				scsi_end_request(cmd, -EIO, this_count, 1);
+				goto retry;
 			return;
 		case ABORTED_COMMAND:
-			if (sshdr.asc == 0x10) { /* DIF */
-				scsi_end_request(cmd, -EIO, this_count, 0);
-				return;
-			}
+			if (sshdr.asc == 0x10)  /* DIF */
+				goto fail;
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
@@ -985,8 +975,7 @@ void scsi_io_completion(struct scsi_cmnd
 							 "Device not ready",
 							 &sshdr);
 
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
@@ -995,8 +984,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry;
 		default:
 			break;
 		}
@@ -1015,8 +1003,13 @@ void scsi_io_completion(struct scsi_cmnd
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
+		goto fail;
 	}
-	scsi_end_request(cmd, -EIO, this_count, !result);
+ retry:
+	scsi_end_request(cmd, -EIO, 0, 1);
+	return;
+ fail:
+	scsi_end_request(cmd, -EIO, blk_rq_bytes(req), 0);
 }
 
 static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,

