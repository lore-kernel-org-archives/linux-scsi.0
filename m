From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sat, 8 Mar 2008 17:35:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803081643590.31118-100000@netrider.rowland.org>
References: <1204996842.2893.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1950 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750714AbYCHWfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2008 17:35:11 -0500
In-Reply-To: <1204996842.2893.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 8 Mar 2008, James Bottomley wrote:

> > > The bottom line is that this patch won't work with variable length
> > > commands like inquiry that always return a residue.
> > 
> > You're saying that the amount of data returned is smaller that the 
> > amount requested because the data is variable length, right?
> 
> Yes.
> 
> > Under these circumstances the block layer should not resubmit anything.
> > That is, it should be smart enough to know that the "missing" data does
> > not in fact exist, as opposed to not being returned because of a
> > retryable device error.
> > 
> > Aren't requests for things like VPD distinguished from regular 
> > data-block accesses by a flag in the request structure already?  The 
> > block layer should take this flag into account when deciding whether to 
> > continue trying to transfer the "missing" data.  Maybe that needs to be 
> > fixed first.
> 
> I'm sure Jens will look at patches.

Actually it looks as though the faulty logic is in scsi_end_request()  
and/or scsi_io_completion().  The interface between those two routines
is quite confusing in regard to how the "requeue" argument is used.

At the site of the first call to scsi_end_request(), the code says:

	/* A number of bytes were successfully read.  If there
	 * are leftovers and there is some kind of error
	 * (result != 0), retry the rest.
	 */
	if (scsi_end_request(cmd, 0, good_bytes, result == 0) == NULL)
		return;

	/* good_bytes = 0, or (inclusive) there were leftovers and
	 * result = 0, so scsi_end_request couldn't retry.
	 */

These comments do a wonderful job of misdirecting the reader and 
encouraging him to conflate "requeue" with "retry".

If there are leftovers but error is 0, it seems reasonable to requeue
the remainder only when blk_fs_request(req) is true.  Anything else 
could simply be a short, variable-length response.

Do you think adding something like this is the right way to go?  I'm 
not sure it will work correctly.  What does one pass to 
blk_end_request() to indicate that the remaining data can't be 
transferred because it doesn't exist?

Or do you think that when blk_fs_request(req) isn't true, then 
scsi_io_completion() should get to decide whether or not to retry it?

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -667,10 +667,15 @@ static struct scsi_cmnd *scsi_end_reques
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
-		/* kill remainder if no retrys */
-		if (error && blk_noretry_request(req))
+		/* Kill remainder if no retrys.  For request types
+		 * other than REQ_TYPE_FS, !error indicates a normal
+		 * variable-length response so the remainder should
+		 * not be requeued.
+		 */
+		if ((error && blk_noretry_request(req)) ||
+		    (!error && !blk_fs_request(req))) {
 			blk_end_request(req, error, leftover);
-		else {
+		} else {
 			if (requeue) {
 				/*
 				 * Bleah.  Leftovers again.  Stick the
@@ -888,15 +893,16 @@ void scsi_io_completion(struct scsi_cmnd
 	if (clear_errors)
 		req->errors = 0;
 
-	/* A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
+	/* A number of bytes were successfully read.  If there are
+	 * leftovers and no error (result == 0), simply requeue them.
+	 * But if this isn't possible, we must figure out whether to
+	 * retry the command.
 	 */
 	if (scsi_end_request(cmd, 0, good_bytes, result == 0) == NULL)
 		return;
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
+	 * result != 0, so scsi_end_request couldn't requeue.
 	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {

