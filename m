From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Tue, 17 Feb 2009 15:10:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902171507370.18399-100000@iolanthe.rowland.org>
References: <20090215115823.GB19464@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43947 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751810AbZBQUKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 15:10:23 -0500
In-Reply-To: <20090215115823.GB19464@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009, Ingo Molnar wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Here's an SCSI regression i tracked down recently. I'll follow up with
> > more info.
> 
> I sent this to James Bottomley about a month ago, who suggested that the
> bug looks similar to problems caused by:
> 
>  | commit b60af5b0adf0da24c673598c8d3fb4d4189a15ce
>  | Author: Alan Stern <stern@rowland.harvard.edu>
>  | Date:   Mon Nov 3 15:56:47 2008 -0500
>  |
>  |     [SCSI] simplify scsi_io_completion()
> 
> I could not revert that patch because it had a lot of followup dependencies,
> but by experimentation i figured out the following string of gradual reverts
> to scsi_lib.c [the revert commits can be found in tip:out-of-tree]:
> 
>  813104e: Revert "[SCSI] simplify scsi_io_completion()"
>  84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
>  0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
>  3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting commands"
>  c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"
> 
> These reverts solved the problem and the box has not locked up in the SCSI irq 
> completion code since then. The code has not had any changes upstream since i
> did the reverts, so the bug is still relevant as of .29-rc5.
> 
> ( James suggested i send this bugreport to this list too, so that it does not
>   get single-threaded on him as he is busy with other things - so more suggestions
>   are welcome. I can try proposed fix patches. James suggested the patch below
>   and i dont think it will show us much more than what we already know: that we
>   are looping in scsi_run_queue(). )

I have no idea if this will make any difference for the problem you're
seeing, but it has been submitted and it's worth trying out.  If the
problem still occurs, I'll write a diagnostic patch to add log messages
giving the destiny of each request in scsi_io_completion().

Alan Stern




This patch (as1144c) removes scsi_end_request().  The routine had only
one caller, so it is moved inline and simplified.

In addition, if no forward progress has been made then the patch
decrements a request's retry counter before unpreparing and requeuing
it, to avoid infinite retry loops.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -703,71 +703,6 @@ void scsi_run_host_queues(struct Scsi_Ho
 
 static void __scsi_release_buffers(struct scsi_cmnd *, int);
 
-/*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands (usually invoked at end
- *		of upper level post-processing and scsi_io_completion).
- *
- * Arguments:   cmd	 - command that is complete.
- *              error    - 0 if I/O indicates success, < 0 for I/O error.
- *              bytes    - number of bytes of completed I/O
- *		requeue  - indicates whether we should requeue leftovers.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     cmd if requeue required, NULL otherwise.
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
- */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
-{
-	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
-
-	/*
-	 * If there are blocks left over at the end, set up the command
-	 * to queue the remainder of them.
-	 */
-	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
-
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request(req, error, leftover);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	__scsi_release_buffers(cmd, 0);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -929,7 +864,6 @@ static void scsi_end_bidi_request(struct
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -980,18 +914,30 @@ void scsi_io_completion(struct scsi_cmnd
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-
-	/* A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (blk_end_request(req, error, good_bytes) == 0) {
+		/* This request is completely finished; start the next one */
+		scsi_next_command(cmd);
 		return;
-	this_count = blk_rq_bytes(req);
+	}
 
 	error = -EIO;
 
-	if (host_byte(result) == DID_RESET) {
+	/* The request isn't finished yet.  Figure out what to do next. */
+	if (result == 0) {
+		/* No error, so carry out the remainder of the request.
+		 * Failure to make forward progress counts against the
+		 * the number of retries.
+		 */
+		if (good_bytes > 0 || --req->retries >= 0)
+			action = ACTION_REPREP;
+		else {
+			action = ACTION_FAIL;
+			description = "Retries exhausted";
+		}
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* Retrys are disallowed, so kill the remainder. */
+		action = ACTION_FAIL;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.

