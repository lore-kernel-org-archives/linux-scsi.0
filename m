From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/21] advansys: Fix simultaneous calls to ->queuecommand
Date: Mon, 08 Oct 2007 12:07:47 +0200
Message-ID: <470A0173.7000603@panasas.com>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765423981-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29045 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbXJHKHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 06:07:55 -0400
In-Reply-To: <11913765423981-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Wed, Oct 03 2007 at 3:55 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> The narrow board used two global structures to set up a command;
> unfortunately they weren't locked, so with two boards in the machine,
> one call to queuecommand could corrupt the data being used by the other
> call to queuecommand.
> 
> Fix this by allocating asc_scsi_q on the stack (64 bytes) and using kmalloc
> for the asc_sg_head (2k)
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/advansys.c |   88 +++++++++++++++++++++--------------------------
>  1 files changed, 39 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 3dd7856..fd4d669 100644
> @@ -10257,12 +10240,12 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
>  		    dma_map_single(boardp->dev, scp->request_buffer,
>  				   scp->request_bufflen,
>  				   scp->sc_data_direction) : 0;
> -		asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
> -		asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
> +		asc_scsi_q->q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
> +		asc_scsi_q->q1.data_cnt = cpu_to_le32(scp->request_bufflen);
>  		ASC_STATS_ADD(scp->device->host, cont_xfer,
>  			      ASC_CEILING(scp->request_bufflen, 512));
> -		asc_scsi_q.q1.sg_queue_cnt = 0;
> -		asc_scsi_q.sg_head = NULL;
> +		asc_scsi_q->q1.sg_queue_cnt = 0;
> +		asc_scsi_q->sg_head = NULL;
>  	} else {
>  		/*
>  		 * CDB scatter-gather request list.
> @@ -10270,6 +10253,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
>  		int sgcnt;
>  		int use_sg;
>  		struct scatterlist *slp;
> +		struct asc_sg_head *asc_sg_head;
>  
>  		slp = (struct scatterlist *)scp->request_buffer;
>  		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
> @@ -10287,28 +10271,31 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
>  
>  		ASC_STATS(scp->device->host, sg_cnt);
>  
> -		/*
> -		 * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
> -		 * structure to point to it.
> -		 */
> -		memset(&asc_sg_head, 0, sizeof(ASC_SG_HEAD));
> +		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
> +			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
> +		if (!asc_sg_head) {
> +			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
> +				     scp->sc_data_direction);
> +			scp->result = HOST_BYTE(DID_SOFT_ERROR);
> +			return ASC_ERROR;
> +		}
>  
> -		asc_scsi_q.q1.cntl |= QC_SG_HEAD;
> -		asc_scsi_q.sg_head = &asc_sg_head;
> -		asc_scsi_q.q1.data_cnt = 0;
> -		asc_scsi_q.q1.data_addr = 0;
> +		asc_scsi_q->q1.cntl |= QC_SG_HEAD;
> +		asc_scsi_q->sg_head = asc_sg_head;
> +		asc_scsi_q->q1.data_cnt = 0;
> +		asc_scsi_q->q1.data_addr = 0;
>  		/* This is a byte value, otherwise it would need to be swapped. */
> -		asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
> +		asc_sg_head->entry_cnt = asc_scsi_q->q1.sg_queue_cnt = use_sg;
>  		ASC_STATS_ADD(scp->device->host, sg_elem,
> -			      asc_sg_head.entry_cnt);
> +			      asc_sg_head->entry_cnt);
>  
>  		/*
>  		 * Convert scatter-gather list into ASC_SG_HEAD list.
>  		 */
>  		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
> -			asc_sg_head.sg_list[sgcnt].addr =
> +			asc_sg_head->sg_list[sgcnt].addr =
>  			    cpu_to_le32(sg_dma_address(slp));
> -			asc_sg_head.sg_list[sgcnt].bytes =
> +			asc_sg_head->sg_list[sgcnt].bytes =
>  			    cpu_to_le32(sg_dma_len(slp));
>  			ASC_STATS_ADD(scp->device->host, sg_xfer,
>  				      ASC_CEILING(sg_dma_len(slp), 512));
> @@ -11338,14 +11325,17 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
>  
>  	if (ASC_NARROW_BOARD(boardp)) {
>  		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
> +		struct asc_scsi_q asc_scsi_q;
>  
>  		/* asc_build_req() can not return ASC_BUSY. */
> -		if (asc_build_req(boardp, scp) == ASC_ERROR) {
> +		ret = asc_build_req(boardp, scp, &asc_scsi_q);
> +		if (ret == ASC_ERROR) {
>  			ASC_STATS(scp->device->host, build_error);
>  			return ASC_ERROR;
>  		}
>  
>  		ret = AscExeScsiQueue(asc_dvc, &asc_scsi_q);
> +		kfree(asc_scsi_q.sg_head);
>  		err_code = asc_dvc->err_code;
>  	} else {
>  		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
Matthew 
I see that these patches are before the conversion to scsi data accessors 
and !use_sg cleanup that was posted by TOMO:
http://www.spinics.net/lists/linux-scsi/msg19055.html

Could you please also post that patch rebased to latest changes as part of
your patchset?

I was hoping we could get all the data accessors patches into 2.6.24,
Is this patchset for the 2.6.24 window?

Thanks
Boaz


