From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Mon, 05 Jan 2009 19:56:06 -0600
Message-ID: <1231206966.3324.65.camel@localhost.localdomain>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
	 <1230914541.3304.9.camel@localhost.localdomain>
	 <20090105232825.GA12820@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46357 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZAFB4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 20:56:11 -0500
In-Reply-To: <20090105232825.GA12820@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Mon, 2009-01-05 at 15:28 -0800, Andrew Vasquez wrote:
> On Fri, 02 Jan 2009, James Bottomley wrote:
> 
> > On Tue, 2008-12-16 at 23:55 -0600, michaelc@cs.wisc.edu wrote:
> > > From: Mike Christie <michaelc@cs.wisc.edu>
> > > 
> > > This patch fixes a regression in scsi-misc introduced with:
> > > 312efe5efcdb02d604ea37a41d965f32ca276d6a
> > > [SCSI] simplify scsi_io_completion().
> > > 
> > > The problem is that in previous kernels scsi_io_completion would call
> > > scsi_requeue_command, but now it can call scsi_queue_insert for
> > > something like a UNIT_ATTENTION (for netapp targets we get
> > > UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
> > > will call scsi_device_unbusy, but in the scsi_io_completion code path
> > > scsi_finish_command has already called this so we now end up
> > > with invalid host, target and device busy values.
> > > 
> > > Patch was made over scsi-misc.
> > 
> > This is a bad bug, but not quite the way I'd like to fix it.  Whether
> > the queue should be unbusied or not is really separate from the block
> > action, so it should have its own flag (plus it's not really a flag many
> > people should be using).  Since, really, the wrong use is confined to
> > the defining file, how about this:
> 
> Hmm, with this patch I'm still running into the problems I described
> here:
> 
> http://article.gmane.org/gmane.linux.scsi/47029
> 
> basically, I/Os returned with a DID_RESET status are being requeued in
> an incomplete state:
> 
> 	[ 2362.068342] scsi(5:0:13): OVERRUN status detected 0x7-0x400
> 	[ 2362.068345] CDB: 0x2a 0x0 0x0 0x0 0xe 0x70
> 	[ 2362.068347] PID=0x81eeb req=0x0 xtra=0x1c00 -- returning DID_ERROR status!
> 	[ 2362.068411] scsi(5:0:13): OVERRUN status detected 0x7-0x400
> 	[ 2362.068413] CDB: 0x2a 0x0 0x0 0x0 0xe 0x70
> 	[ 2362.068415] PID=0x81eec req=0x0 xtra=0x1c00 -- returning DID_ERROR status!
> 
> :(
> 
> Thoughts?

Hmm, brown paper bag for me on the review, I think.

The problem is that the buffers are released before the requeue; this is
wrong.  The fix might be to release them later.  Does this work?

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc613ba..0de4834 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -962,7 +962,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
-	scsi_release_buffers(cmd);
 
 	/*
 	 * Next deal with any sectors which we were able to correctly
@@ -976,8 +975,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
 	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL) {
+		scsi_release_buffers(cmd);
 		return;
+	}
 	this_count = blk_rq_bytes(req);
 
 	error = -EIO;
@@ -1080,6 +1081,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
+		scsi_release_buffers(cmd);
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
@@ -1095,6 +1097,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
+		scsi_release_buffers(cmd);
 		scsi_requeue_command(q, cmd);
 		break;
 	case ACTION_RETRY:


