From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 13 Aug 2008 15:17:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0808131504420.2308-100000@iolanthe.rowland.org>
References: <48A30DC7.8070501@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751705AbYHMTRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Aug 2008 15:17:54 -0400
In-Reply-To: <48A30DC7.8070501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Antonio Ospite <ospite@studenti.unina.it>

On Wed, 13 Aug 2008, Boaz Harrosh wrote:

> OK Yes, you are absolutely right. Please send a proposal and we'll 
> stare at it for a while.
> 
> One thing I don't like is the now blk_end_request(req, -EIO, bytes=0)
> inside scsi_end_request(). What's the point of calling that with 0 bytes?
> Maybe fix that too.
> 
> > Alan Stern
> > 
> > PS: In my copy of the code, scsi_end_request() doesn't use
> > blk_rq_bytes().  Has this been updated in the SCSI development tree?
> > 
> 
> No it does not. I was just commenting on the new code. If you fix up
> scsi_end_request() you should fix this too.
> 
> Thanks for doing this. This is a long outstanding nagging bug. It was
> encountered before.

> One more thing I do not understand is: inside scsi_io_completion()
> in some places it will requeue with: "scsi_end_request(cmd, -EIO, this_count, 1)"
> and at other places it will directly requeue with: "scsi_requeue_command(q, cmd);"
> The difference being in the later case not calling scsi_next_command(cmd);
> 
> Do you understand why?

I'm not sure.  Maybe it's part of the original conceptual bug about
calling blk_end_request(req, error, this_count).  The only other
difference between the two approaches is that scsi_end_request() won't
requeue if blk_noretry_request is true -- it will just terminate the 
request.

Here's the new patch, addressing all your points.  I have not tested 
it.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -674,16 +674,12 @@ static struct scsi_cmnd *scsi_end_reques
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
+	if (bytes == 0 || blk_end_request(req, error, bytes)) {
 
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
@@ -852,7 +848,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = scsi_bufflen(cmd);
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -909,9 +904,6 @@ void scsi_io_completion(struct scsi_cmnd
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
-	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
@@ -920,8 +912,7 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				scsi_end_request(cmd, -EIO, this_count, 1);
-				return;
+				goto retry;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
@@ -951,15 +942,13 @@ void scsi_io_completion(struct scsi_cmnd
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
@@ -985,8 +974,7 @@ void scsi_io_completion(struct scsi_cmnd
 							 "Device not ready",
 							 &sshdr);
 
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry;
 		case VOLUME_OVERFLOW:
 			if (!(req->cmd_flags & REQ_QUIET)) {
 				scmd_printk(KERN_INFO, cmd,
@@ -995,8 +983,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_print_sense("", cmd);
 			}
 			/* See SSC3rXX or current. */
-			scsi_end_request(cmd, -EIO, this_count, 1);
-			return;
+			goto retry;
 		default:
 			break;
 		}
@@ -1015,8 +1002,13 @@ void scsi_io_completion(struct scsi_cmnd
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

