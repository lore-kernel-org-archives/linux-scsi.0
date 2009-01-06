From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Tue, 06 Jan 2009 13:15:20 -0600
Message-ID: <1231269320.10475.25.camel@localhost.localdomain>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
	 <1230914541.3304.9.camel@localhost.localdomain>
	 <20090105232825.GA12820@plap4-2.local>
	 <1231206966.3324.65.camel@localhost.localdomain>
	 <20090106070106.GA17332@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60032 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbZAFTPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 14:15:24 -0500
In-Reply-To: <20090106070106.GA17332@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Mon, 2009-01-05 at 23:01 -0800, Andrew Vasquez wrote:
> On Mon, 05 Jan 2009, James Bottomley wrote:
> 
> > Hmm, brown paper bag for me on the review, I think.
> > 
> > The problem is that the buffers are released before the requeue; this is
> > wrong.  The fix might be to release them later.  Does this work?
> 
> Hmm, no...
> 
> <snip>
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index cc613ba..0de4834 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -962,7 +962,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> >  	}
> >  
> >  	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
> > -	scsi_release_buffers(cmd);
> >  
> >  	/*
> >  	 * Next deal with any sectors which we were able to correctly
> > @@ -976,8 +975,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> >  	 * are leftovers and there is some kind of error
> >  	 * (result != 0), retry the rest.
> >  	 */
> > -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> > +	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL) {
> > +		scsi_release_buffers(cmd);
> >  		return;
> > +	}
> 
> This hunk is causing a panic during early SCSI init-time of the server
> boot disk -- sg_free_table+0x51 (RIP), scsi_release_buffers+0xd4,
> scsi_io_completion+0x324.  IAC, in looking through the code
> scsi_end_request() returns NULL when the command has already been
> requeued (via scsi_requeue_command()).  Modifying your original patch
> to release-buffers prior to scsi_end_request()'s call to
> scsi_requeue_command() and dropping the post-scsi_end_request() call
> to scsi_release_buffers() fixes *both* the panic as well as the original
> problem I reported regarding commands returned with a DID_RESET status
> being requeued in an incomplete state.

Gosh this is a subtle nasty mess.

> Here's the updated patch.  Any other holes I missed?

Yes, I'm afraid ... if scsi_release_buffers() is moved into
scsi_end_request() then it has to be called for every NULL returning
path otherwise we leak buffers.  The missing release is the NULL return
at the bottom of the function.  However, you can't call
scsi_release_buffers() there because we've lost the request and the
scsi_bidi_cmd() check tries to touch it.

Hopefully this version has all the holes plugged, if you could give it a
spin...

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc613ba..940dc32 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -701,6 +701,8 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
+static void __scsi_release_buffers(struct scsi_cmnd *, int);
+
 /*
  * Function:    scsi_end_request()
  *
@@ -749,6 +751,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				scsi_release_buffers(cmd);
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}
@@ -760,6 +763,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
+	__scsi_release_buffers(cmd, 0);
 	scsi_next_command(cmd);
 	return NULL;
 }
@@ -815,6 +819,26 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
 }
 
+static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
+{
+
+	if (cmd->sdb.table.nents)
+		scsi_free_sgtable(&cmd->sdb);
+
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+
+	if (do_bidi_check && scsi_bidi_cmnd(cmd)) {
+		struct scsi_data_buffer *bidi_sdb =
+			cmd->request->next_rq->special;
+		scsi_free_sgtable(bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
+		cmd->request->next_rq->special = NULL;
+	}
+
+	if (scsi_prot_sg_count(cmd))
+		scsi_free_sgtable(cmd->prot_sdb);
+}
+
 /*
  * Function:    scsi_release_buffers()
  *
@@ -834,21 +858,7 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
  */
 void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb);
-
-	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-
-	if (scsi_bidi_cmnd(cmd)) {
-		struct scsi_data_buffer *bidi_sdb =
-			cmd->request->next_rq->special;
-		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
-		cmd->request->next_rq->special = NULL;
-	}
-
-	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb);
+	__scsi_release_buffers(cmd, 1);
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
@@ -962,7 +972,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
-	scsi_release_buffers(cmd);
 
 	/*
 	 * Next deal with any sectors which we were able to correctly
@@ -1080,6 +1089,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
+		scsi_release_buffers(cmd);
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			if (description)
 				scmd_printk(KERN_INFO, cmd, "%s\n",
@@ -1095,6 +1105,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
+		scsi_release_buffers(cmd);
 		scsi_requeue_command(q, cmd);
 		break;
 	case ACTION_RETRY:


