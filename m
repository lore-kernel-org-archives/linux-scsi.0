From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Wed, 27 Aug 2008 14:50:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808271447260.17771-100000@iolanthe.rowland.org>
References: <1219847626.3292.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1219847626.3292.17.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch (as1133) fixes a bug in the interaction between
scsi_end_request() and scsi_io_completion().  The bug was triggered by
recent changes to accomodate USB drives can't access their last few
sectors using multi-sector transfers (the so-called last_sector_bug
flag).

The bug shows up when a multi-sector I/O request has been broken up
into single-sector commands.  If one of those commands gets an error,
the remainder of the request never gets completed.  This is because
the "bytes" value passed to scsi_end_request() is completely wrong; it
is the transfer size of the current command, not the total transfer
size of the request.

Changes made in the patch include:

	Use the blk_rq_bytes() routine to get the remaining size
	of a request instead of calculating it by hand.

	Don't bother to call blk_end_request() for a BLK_TYPE_FS
	request when the number of bytes transferred is 0.  (This
	test isn't really needed; it is a possibly premature
	optimization.)

	Remove a comment in scsi_io_completion() that has bothered
	me for a long time.  Although it's less than two lines long,
	it contains at least three major mistakes.

	Replace a bunch of repetitious calls to scsi_end_request() for
	-EIO errors by either "goto retry" or "goto fail", depending
	on whether or not the individual request should be retried.

	In the "retry" case, don't claim that any additional bytes
	have been transferred since the last call to
	scsi_end_request().  They haven't.

	In the "fail" case, pass the total number of bytes remaining
	in the request (i.e., blk_rq_bytes(req)) so that the entire
	request will complete.

Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>

---

This patch could be broken up into several simpler patches, of which 
all but the last would be uncontroversial.  But first I'd like to get 
some feedback concerning the overall correctness.

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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
