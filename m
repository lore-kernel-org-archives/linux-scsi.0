From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Mon, 5 Jan 2009 23:01:06 -0800
Message-ID: <20090106070106.GA17332@plap4-2.local>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu> <1230914541.3304.9.camel@localhost.localdomain> <20090105232825.GA12820@plap4-2.local> <1231206966.3324.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:32559 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZAFHBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 02:01:08 -0500
Content-Disposition: inline
In-Reply-To: <1231206966.3324.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Mon, 05 Jan 2009, James Bottomley wrote:

> Hmm, brown paper bag for me on the review, I think.
> 
> The problem is that the buffers are released before the requeue; this is
> wrong.  The fix might be to release them later.  Does this work?

Hmm, no...

<snip>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cc613ba..0de4834 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -962,7 +962,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	}
>  
>  	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
> -	scsi_release_buffers(cmd);
>  
>  	/*
>  	 * Next deal with any sectors which we were able to correctly
> @@ -976,8 +975,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	 * are leftovers and there is some kind of error
>  	 * (result != 0), retry the rest.
>  	 */
> -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> +	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL) {
> +		scsi_release_buffers(cmd);
>  		return;
> +	}

This hunk is causing a panic during early SCSI init-time of the server
boot disk -- sg_free_table+0x51 (RIP), scsi_release_buffers+0xd4,
scsi_io_completion+0x324.  IAC, in looking through the code
scsi_end_request() returns NULL when the command has already been
requeued (via scsi_requeue_command()).  Modifying your original patch
to release-buffers prior to scsi_end_request()'s call to
scsi_requeue_command() and dropping the post-scsi_end_request() call
to scsi_release_buffers() fixes *both* the panic as well as the original
problem I reported regarding commands returned with a DID_RESET status
being requeued in an incomplete state.

Here's the updated patch.  Any other holes I missed?

--
av

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc613ba..9b626af 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -749,6 +749,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				scsi_release_buffers(cmd);
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}
@@ -962,7 +963,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
-	scsi_release_buffers(cmd);
 
 	/*
 	 * Next deal with any sectors which we were able to correctly
@@ -1080,6 +1080,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
+		scsi_release_buffers(cmd);
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
@@ -1095,6 +1096,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
+		scsi_release_buffers(cmd);
 		scsi_requeue_command(q, cmd);
 		break;
 	case ACTION_RETRY:
