From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 19 Jun 2014 11:05:59 -0700
Message-ID: <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
	 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
	 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
	 <20140611133736.GA12240@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59722 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933474AbaFSSGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2014 14:06:02 -0400
In-Reply-To: <20140611133736.GA12240@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Wed, 2014-06-11 at 06:37 -0700, Christoph Hellwig wrote:
> On Mon, Jun 09, 2014 at 10:29:06AM -0700, James Bottomley wrote:
> > I'll do it as a bug fix, but I do need Jens to make sure nothing else
> > breaks first.  Best I can tell, the state model for compound commands
> > like flush doesn't expect us to change the request type ... nothing puts
> > it back to REQ_TYPE_FS.  In your case, the flush is the last command
> > sent, so there's no problem ... I just worry we will get an obscure
> > problem later on from something that does a BLOCK_PC prepared first
> > command.
> 
> Yes, I don't think resetting cmd_type is a good idea.  I'd much rather
> see a special case for rq->cmd_flags & REQ_FLUSH in the completion
> handler - we already treat it special during setup anyway.

That's not really a good idea either ... I did think of it.  We'll end
up with a cmd_type of REQ_TYPE_FS which because of REQ_FLUSH (or REQ_FUA
or REQ_DISCARD or any number of other things) we have to treat as though
it were REQ_TYPE_BLOCK_PC.  It's much better to tune handling
expectations according to req->cmd_type because that's what we already
do.  These commands are actually set up by our handlers, so it's up to
us to mark the request type correctly.

This, I think, does everything we need

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e3163..d1458ec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1103,6 +1103,11 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = req->retries;
+	/*
+	 * Thanks to flush and other PC prepared commands, we may
+	 * not be a REQ_TYPE_BLOCK_PC; make sure we are
+	 */
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
@@ -1129,6 +1134,11 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	BUG_ON(!req->nr_phys_segments);
 
 	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	/*
+	 * Thanks to flush and other PC prepared commands, we may
+	 * not be a REQ_TYPE_FS; make sure we are
+	 */
+	req->cmd_type = REQ_TYPE_FS;
 	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);


