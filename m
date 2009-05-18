From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH UPDATED2 block#for-2.6.31 2/3] block: set rq->resid_len
	to  blk_rq_bytes() on issue
Date: Mon, 18 May 2009 14:49:19 +0200
Message-ID: <20090518124919.GK4140@kernel.dk>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FFD7E.8050607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:33286 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZERMtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2009 08:49:19 -0400
Content-Disposition: inline
In-Reply-To: <4A0FFD7E.8050607@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>

On Sun, May 17 2009, Tejun Heo wrote:
> In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
> rq->resid_len, the default value of residue count was changed from
> full count to zero.  The conversion was done under the assumption that
> when a request fails residue count wasn't defined.  However, Boaz and
> James pointed out that this wasn't true and the residue count should
> be preserved for failed requests too.
> 
> This patchset restores the original behavior by setting rq->resid_len
> to blk_rq_bytes(rq) on request start and restoring explicit clearing
> in affected drivers.  While at it, take advantage of the fact that
> rq->resid_len is set to full count where applicable.
> 
> * ide-cd: rq->resid_len cleared on pc success
> 
> * mptsas: req->resid_len cleared on success
> 
> * sas_expander: rsp/req->resid_len cleared on success
> 
> * mpt2sas_transport: req->resid_len cleared on success
> 
> * ide-cd, ide-tape, mptsas, sas_host_smp, mpt2sas_transport, ub: take
>   advantage of initial full count to simplify code

Tejun, you have to stop replying with updated patches in an existing
thread. It's virtually impossible to sort the resulting mess into
patches worth applying.

If you update patches in a series, or post a new patch, do it in a new
thread. And use explicit naming (like "foo patchset version bar") so
it's easy to grasp the chronology of the patches. Otherwise I have to
spend lots of time extracting and comparing patches, which is just a
waste of time.

I haven't applied anything in this thread. Please repost the pending
patches so they can be reviewed and applied! Thanks.

> 
> Boaz Harrosh spotted bug in resid_len initialization.  Fixed as
> suggested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Borislav Petkov <petkovbb@googlemail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> ---
> Fixed as Boaz suggested.  Thanks Boaz.
> 
>  block/blk-core.c                         |    5 +++--
>  drivers/block/ub.c                       |    6 ++++--
>  drivers/ide/ide-cd.c                     |    4 ++--
>  drivers/ide/ide-tape.c                   |    2 +-
>  drivers/message/fusion/mptsas.c          |    3 ++-
>  drivers/scsi/libsas/sas_expander.c       |    4 ++++
>  drivers/scsi/libsas/sas_host_smp.c       |    3 ---
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
>  8 files changed, 18 insertions(+), 13 deletions(-)
> 
> Index: block/block/blk-core.c
> ===================================================================
> --- block.orig/block/blk-core.c
> +++ block/block/blk-core.c
> @@ -1783,9 +1783,10 @@ void blk_start_request(struct request *r
>  	blk_dequeue_request(req);
>  
>  	/*
> -	 * We are now handing the request to the hardware, add the
> -	 * timeout handler.
> +	 * We are now handing the request to the hardware, initialize
> +	 * resid_len to full count and add the timeout handler.
>  	 */
> +	req->resid_len = blk_rq_bytes(req);
>  	blk_add_timer(req);
>  }
>  EXPORT_SYMBOL(blk_start_request);
> Index: block/drivers/ide/ide-cd.c
> ===================================================================
> --- block.orig/drivers/ide/ide-cd.c
> +++ block/drivers/ide/ide-cd.c
> @@ -699,6 +699,7 @@ static ide_startstop_t cdrom_newpc_intr(
>  
>  out_end:
>  	if (blk_pc_request(rq) && rc == 0) {
> +		rq->resid_len = 0;
>  		blk_end_request_all(rq, 0);
>  		hwif->rq = NULL;
>  	} else {
> @@ -718,8 +719,7 @@ out_end:
>  
>  		/* make sure it's fully ended */
>  		if (blk_fs_request(rq) == 0) {
> -			rq->resid_len = blk_rq_bytes(rq) -
> -				(cmd->nbytes - cmd->nleft);
> +			rq->resid_len -= cmd->nbytes - cmd->nleft;
>  			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
>  				rq->resid_len += cmd->last_xfer_len;
>  		}
> Index: block/drivers/ide/ide-tape.c
> ===================================================================
> --- block.orig/drivers/ide/ide-tape.c
> +++ block/drivers/ide/ide-tape.c
> @@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t
>  		}
>  
>  		tape->first_frame += blocks;
> -		rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
> +		rq->resid_len -= blocks * tape->blk_size;
>  
>  		if (pc->error) {
>  			uptodate = 0;
> Index: block/drivers/message/fusion/mptsas.c
> ===================================================================
> --- block.orig/drivers/message/fusion/mptsas.c
> +++ block/drivers/message/fusion/mptsas.c
> @@ -1357,7 +1357,8 @@ static int mptsas_smp_handler(struct Scs
>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>  		memcpy(req->sense, smprep, sizeof(*smprep));
>  		req->sense_len = sizeof(*smprep);
> -		rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
> +		req->resid_len = 0;
> +		rsp->resid_len -= smprep->ResponseDataLength;
>  	} else {
>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
>  		    ioc->name, __func__);
> Index: block/drivers/scsi/libsas/sas_expander.c
> ===================================================================
> --- block.orig/drivers/scsi/libsas/sas_expander.c
> +++ block/drivers/scsi/libsas/sas_expander.c
> @@ -1937,7 +1937,11 @@ int sas_smp_handler(struct Scsi_Host *sh
>  	if (ret > 0) {
>  		/* positive number is the untransferred residual */
>  		rsp->resid_len = ret;
> +		req->resid_len = 0;
>  		ret = 0;
> +	} else if (ret == 0) {
> +		rsp->resid_len = 0;
> +		req->resid_len = 0;
>  	}
>  
>  	return ret;
> Index: block/drivers/scsi/libsas/sas_host_smp.c
> ===================================================================
> --- block.orig/drivers/scsi/libsas/sas_host_smp.c
> +++ block/drivers/scsi/libsas/sas_host_smp.c
> @@ -176,9 +176,6 @@ int sas_smp_host_handler(struct Scsi_Hos
>  	resp_data[1] = req_data[1];
>  	resp_data[2] = SMP_RESP_FUNC_UNK;
>  
> -	req->resid_len = blk_rq_bytes(req);
> -	rsp->resid_len = blk_rq_bytes(rsp);
> -
>  	switch (req_data[1]) {
>  	case SMP_REPORT_GENERAL:
>  		req->resid_len -= 8;
> Index: block/drivers/scsi/mpt2sas/mpt2sas_transport.c
> ===================================================================
> --- block.orig/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ block/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1170,8 +1170,8 @@ transport_smp_handler(struct Scsi_Host *
>  
>  		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>  		req->sense_len = sizeof(*mpi_reply);
> -		rsp->resid_len = blk_rq_bytes(rsp) -
> -				 mpi_reply->ResponseDataLength;
> +		req->resid_len = 0;
> +		rsp->resid_len -= mpi_reply->ResponseDataLength;
>  	} else {
>  		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
>  		    "%s - no reply\n", ioc->name, __func__));
> Index: block/drivers/block/ub.c
> ===================================================================
> --- block.orig/drivers/block/ub.c
> +++ block/drivers/block/ub.c
> @@ -781,8 +781,10 @@ static void ub_rw_cmd_done(struct ub_dev
>  
>  	if (cmd->error == 0) {
>  		if (blk_pc_request(rq)) {
> -			if (cmd->act_len < blk_rq_bytes(rq))
> -				rq->resid_len = blk_rq_bytes(rq) - cmd->act_len;
> +			if (cmd->act_len >= rq->resid_len)
> +				rq->resid_len = 0;
> +			else
> +				rq->resid_len -= cmd->act_len;
>  			scsi_status = 0;
>  		} else {
>  			if (cmd->act_len != cmd->len) {

-- 
Jens Axboe

