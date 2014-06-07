From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Sat, 07 Jun 2014 12:29:44 -0700
Message-ID: <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49186 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbaFGT3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2014 15:29:46 -0400
In-Reply-To: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Haber <steven@qumulo.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, 2014-06-05 at 16:52 -0700, Steven Haber wrote:
> Hello,
> 
> I am testing ATA device durability during hot unplug. I have a power
> fault test suite that has turned up issues with the fsync->SCSI->ATA
> codepath. If a device is unplugged while an fsync is in progress, ATA
> returns a flush error to the SCSI driver but scsi_io_completion()
> seems to disregard it. fsync() returns no error, which should mean
> that the write was durably flushed to disk. I expect fsync() to return
> EIO or something similar when the flush isn't acked by the device.
> 
> When the failure occurs, the SCSI sense key is set to ABORTED_COMMAND.
> However, scsi_end_command() is called without any of the sense context
> and scsi_io_completion() returns early without checking sense at all.
> 
> This commit may be related:
> d6b0c53723753fc0cfda63f56735b225c43e1e9a
> (http://git.opencores.org/?a=commitdiff&p=linux&h=d6b0c53723753fc0cfda63f56735b225c43e1e9a)
> 
> The following patch fixes the issue, but it's a hack. I only have a
> vague understanding of Linux drivers, so I'm looking for advice on how
> to make this fix better and get it upstream.

OK, so for some reason this is a zero size REQ_TYPE_FS command, which
the logic actually assumes we cannot have.

I suspect REQ_TYPE_FLUSH subtly broke this logic because it's coming
back to us as REQ_TYPE_FS even though it's been set up (in SCSI) as
REQ_TYPE_BLOCK_PC.

On this theory, we'd eat the return codes of all no data transfer
commands that fail.  I think the generic fix is to make sure that all
commands initiallised as REQ_TYPE_BLOCK_PC actually have the ->cmd_type
set to that.

There may be some knock on side effects because it doesn't look like the
block flush code expects us to change the request->cmd_type.  Cc'd Jens
for opinions on this.

Can you try this out and see if it fixes the problem?  If it doesn't,
we're going to have to get into debugging exactly what this zero length
request is.

Thanks,

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9db097a..78229ec7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1171,6 +1171,11 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	
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


