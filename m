From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Current git --> kaboom [bisect] seems IDE related.
Date: Sun, 10 Feb 2008 09:43:52 -0500
Message-ID: <20080210144352.GA3537@infradead.org>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYBJOn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 09:43:58 -0500
Content-Disposition: inline
In-Reply-To: <200802101438.46698.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Sun, Feb 10, 2008 at 02:38:46PM +0100, Bartlomiej Zolnierkiewicz wrote:
> The OOPS is most likely (again) my fault - I was rushing out to push out
> the fix and memset() line didn't get converted.

The new patch works fine for me.

> I prepared the new patch, documented it and started looking into SCSI
> build breakage... and I no longer feel comfortable with the hack :(
> 
> It seems that fixing IDE properly will be easier than auditing the whole
> SCSI for all the weird assumptions on rq->cmd[] size (James?) so I'm back
> to the code, in the meantime here's the updated patch:

Yeah, this is quite nasty.  I'll attach the patch below which just
rejects a command in scsi_setup_blk_pc_cmnd if it's too large for
the scsi_cmnd cmnd array.  This is probably enough but I haven't
audited all of the scsi code yet.  But as James said this is
too much of a memory vastage to put it into the tree.

Long-term the Panasas folks have looked into killing the scsi_cmnd.cmnd
filed entirely and make the struct request.cmd field dynamically sized
which would solve your problem, but probably won't be ready for 2.6.25.


Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2008-02-10 07:49:50.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi_lib.c	2008-02-10 15:19:42.000000000 +0100
@@ -1129,7 +1129,12 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 		req->buffer = NULL;
 	}
 
-	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
+	if (req->cmd_len > sizeof(cmd->cmnd)) {
+		scsi_release_buffers(cmd);
+		scsi_put_command(cmd);
+		return BLKPREP_KILL;
+	}
+
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)
