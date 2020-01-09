Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF2EC32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1792072A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgAIJwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 04:52:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:35522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgAIJwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 04:52:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5719DC20B;
        Thu,  9 Jan 2020 09:52:21 +0000 (UTC)
Subject: Re: [PATCH v2 25/32] elx: efct: Hardware IO submission routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-26-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <4a661cb9-ebb2-44e6-b7ee-6d5c56315f53@suse.de>
Date:   Thu, 9 Jan 2020 10:52:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-26-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:37 PM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines that write IO to Work queue, send SRRs and raw frames.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_hw.c | 625 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h |  19 ++
>  2 files changed, 644 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 43f1ff526694..440c4fa196bf 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -3192,6 +3192,68 @@ efct_hw_eq_process(struct efct_hw *hw, struct hw_eq *eq,
>  	return 0;
>  }
>  
> +static int
> +_efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe)
> +{
> +	int rc;
> +	int queue_rc;
> +
> +	/* Every so often, set the wqec bit to generate comsummed completions */
> +	if (wq->wqec_count)
> +		wq->wqec_count--;
> +
> +	if (wq->wqec_count == 0) {
> +		struct sli4_generic_wqe *genwqe = (void *)wqe->wqebuf;
> +
> +		genwqe->cmdtype_wqec_byte |= SLI4_GEN_WQE_WQEC;
> +		wq->wqec_count = wq->wqec_set_count;
> +	}
> +
> +	/* Decrement WQ free count */
> +	wq->free_count--;
> +
> +	queue_rc = sli_wq_write(&wq->hw->sli, wq->queue, wqe->wqebuf);
> +
> +	if (queue_rc < 0)
> +		rc = -1;
> +	else
> +		rc = 0;
> +
> +	return rc;
> +}
> +

return (queue_rq < 0) ? -1 : 0;

> +static void
> +hw_wq_submit_pending(struct hw_wq *wq, u32 update_free_count)
> +{
> +	struct efct_hw_wqe *wqe;
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&wq->queue->lock, flags);
> +
> +	/* Update free count with value passed in */
> +	wq->free_count += update_free_count;
> +
> +	while ((wq->free_count > 0) && (!list_empty(&wq->pending_list))) {
> +		wqe = list_first_entry(&wq->pending_list,
> +				       struct efct_hw_wqe, list_entry);
> +		list_del(&wqe->list_entry);
> +		_efct_hw_wq_write(wq, wqe);
> +
> +		if (wqe->abort_wqe_submit_needed) {
> +			wqe->abort_wqe_submit_needed = false;
> +			sli_abort_wqe(&wq->hw->sli, wqe->wqebuf,
> +				      wq->hw->sli.wqe_size,
> +				      SLI_ABORT_XRI, wqe->send_abts, wqe->id,
> +				      0, wqe->abort_reqtag, SLI4_CQ_DEFAULT);
> +					  INIT_LIST_HEAD(&wqe->list_entry);
> +			list_add_tail(&wqe->list_entry, &wq->pending_list);
> +			wq->wq_pending_count++;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&wq->queue->lock, flags);
> +}
> +
>  void
>  efct_hw_cq_process(struct efct_hw *hw, struct hw_cq *cq)
>  {
> @@ -3390,3 +3452,566 @@ efct_hw_flush(struct efct_hw *hw)
>  
>  	return 0;
>  }
> +
> +int
> +efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe)
> +{
> +	int rc = 0;
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&wq->queue->lock, flags);
> +	if (!list_empty(&wq->pending_list)) {
> +		INIT_LIST_HEAD(&wqe->list_entry);
> +		list_add_tail(&wqe->list_entry, &wq->pending_list);
> +		wq->wq_pending_count++;
> +		while ((wq->free_count > 0) &&
> +		       ((wqe = list_first_entry(&wq->pending_list,
> +					struct efct_hw_wqe, list_entry))
> +			 != NULL)) {
> +			list_del(&wqe->list_entry);
> +			rc = _efct_hw_wq_write(wq, wqe);
> +			if (rc < 0)
> +				break;
> +			if (wqe->abort_wqe_submit_needed) {
> +				wqe->abort_wqe_submit_needed = false;
> +				sli_abort_wqe(&wq->hw->sli,
> +					      wqe->wqebuf,
> +					      wq->hw->sli.wqe_size,
> +					      SLI_ABORT_XRI,
> +					      wqe->send_abts, wqe->id,
> +					      0, wqe->abort_reqtag,
> +					      SLI4_CQ_DEFAULT);
> +
> +				INIT_LIST_HEAD(&wqe->list_entry);
> +				list_add_tail(&wqe->list_entry,
> +					      &wq->pending_list);
> +				wq->wq_pending_count++;
> +			}
> +		}
> +	} else {
> +		if (wq->free_count > 0) {
> +			rc = _efct_hw_wq_write(wq, wqe);
> +		} else {
> +			INIT_LIST_HEAD(&wqe->list_entry);
> +			list_add_tail(&wqe->list_entry, &wq->pending_list);
> +			wq->wq_pending_count++;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&wq->queue->lock, flags);
> +
> +	return rc;
> +}
> +
> +/**
> + * This routine supports communication sequences consisting of a single
> + * request and single response between two endpoints. Examples include:
> + *  - Sending an ELS request.
> + *  - Sending an ELS response - To send an ELS response, the caller must provide
> + * the OX_ID from the received request.
> + *  - Sending a FC Common Transport (FC-CT) request - To send a FC-CT request,
> + * the caller must provide the R_CTL, TYPE, and DF_CTL
> + * values to place in the FC frame header.
> + */
> +enum efct_hw_rtn
> +efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
> +		  struct efct_hw_io *io,
> +		  struct efc_dma *send, u32 len,
> +		  struct efc_dma *receive, struct efc_remote_node *rnode,
> +		  union efct_hw_io_param_u *iparam,
> +		  efct_hw_srrs_cb_t cb, void *arg)
> +{
> +	struct sli4_sge	*sge = NULL;
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
> +	u16	local_flags = 0;
> +	u32 sge0_flags;
> +	u32 sge1_flags;
> +
> +	if (!io || !rnode || !iparam) {
> +		pr_err("bad parm hw=%p io=%p s=%p r=%p rn=%p iparm=%p\n",
> +			hw, io, send, receive, rnode, iparam);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (hw->state != EFCT_HW_STATE_ACTIVE) {
> +		efc_log_test(hw->os,
> +			      "cannot send SRRS, HW state=%d\n", hw->state);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	io->rnode = rnode;
> +	io->type  = type;
> +	io->done = cb;
> +	io->arg  = arg;
> +
> +	sge = io->sgl->virt;
> +
> +	/* clear both SGE */
> +	memset(io->sgl->virt, 0, 2 * sizeof(struct sli4_sge));
> +
> +	sge0_flags = le32_to_cpu(sge[0].dw2_flags);
> +	sge1_flags = le32_to_cpu(sge[1].dw2_flags);
> +	if (send) {
> +		sge[0].buffer_address_high =
> +			cpu_to_le32(upper_32_bits(send->phys));
> +		sge[0].buffer_address_low  =
> +			cpu_to_le32(lower_32_bits(send->phys));
> +
> +		sge0_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
> +
> +		sge[0].buffer_length = cpu_to_le32(len);
> +	}
> +
> +	if (type == EFCT_HW_ELS_REQ || type == EFCT_HW_FC_CT) {
> +		sge[1].buffer_address_high =
> +			cpu_to_le32(upper_32_bits(receive->phys));
> +		sge[1].buffer_address_low  =
> +			cpu_to_le32(lower_32_bits(receive->phys));
> +
> +		sge1_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
> +		sge1_flags |= SLI4_SGE_LAST;
> +
> +		sge[1].buffer_length = cpu_to_le32(receive->size);
> +	} else {
> +		sge0_flags |= SLI4_SGE_LAST;
> +	}
> +
> +	sge[0].dw2_flags = cpu_to_le32(sge0_flags);
> +	sge[1].dw2_flags = cpu_to_le32(sge1_flags);
> +
> +	switch (type) {
> +	case EFCT_HW_ELS_REQ:
> +		if (!send ||
> +		    sli_els_request64_wqe(&hw->sli, io->wqe.wqebuf,
> +					  hw->sli.wqe_size, io->sgl,
> +					*((u8 *)send->virt),
> +					len, receive->size,
> +					iparam->els.timeout,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT, rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->node_group, rnode->attached,
> +					rnode->fc_id, rnode->sport->fc_id)) {
> +			efc_log_err(hw->os, "REQ WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_ELS_RSP:
> +		if (!send ||
> +		    sli_xmit_els_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, send, len,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT, iparam->els.ox_id,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->node_group, rnode->attached,
> +					rnode->fc_id,
> +					local_flags, U32_MAX)) {
> +			efc_log_err(hw->os, "RSP WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_ELS_RSP_SID:
> +		if (!send ||
> +		    sli_xmit_els_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, send, len,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT,
> +					iparam->els_sid.ox_id,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->node_group, rnode->attached,
> +					rnode->fc_id,
> +					local_flags, iparam->els_sid.s_id)) {
> +			efc_log_err(hw->os, "RSP (SID) WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_FC_CT:
> +		if (!send ||
> +		    sli_gen_request64_wqe(&hw->sli, io->wqe.wqebuf,
> +					  hw->sli.wqe_size, io->sgl,
> +					len, receive->size,
> +					iparam->fc_ct.timeout, io->indicator,
> +					io->reqtag, SLI4_CQ_DEFAULT,
> +					rnode->node_group, rnode->fc_id,
> +					rnode->indicator,
> +					iparam->fc_ct.r_ctl,
> +					iparam->fc_ct.type,
> +					iparam->fc_ct.df_ctl)) {
> +			efc_log_err(hw->os, "GEN WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_FC_CT_RSP:
> +		if (!send ||
> +		    sli_xmit_sequence64_wqe(&hw->sli, io->wqe.wqebuf,
> +					    hw->sli.wqe_size, io->sgl,
> +					len, iparam->fc_ct_rsp.timeout,
> +					iparam->fc_ct_rsp.ox_id,
> +					io->indicator, io->reqtag,
> +					rnode->node_group, rnode->fc_id,
> +					rnode->indicator,
> +					iparam->fc_ct_rsp.r_ctl,
> +					iparam->fc_ct_rsp.type,
> +					iparam->fc_ct_rsp.df_ctl)) {
> +			efc_log_err(hw->os, "XMIT SEQ WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_BLS_ACC:
> +	case EFCT_HW_BLS_RJT:
> +	{
> +		struct sli_bls_payload	bls;
> +
> +		if (type == EFCT_HW_BLS_ACC) {
> +			bls.type = SLI4_SLI_BLS_ACC;
> +			memcpy(&bls.u.acc, iparam->bls.payload,
> +			       sizeof(bls.u.acc));
> +		} else {
> +			bls.type = SLI4_SLI_BLS_RJT;
> +			memcpy(&bls.u.rjt, iparam->bls.payload,
> +			       sizeof(bls.u.rjt));
> +		}
> +
> +		bls.ox_id = cpu_to_le16(iparam->bls.ox_id);
> +		bls.rx_id = cpu_to_le16(iparam->bls.rx_id);
> +
> +		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, &bls,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT,
> +					rnode->attached, rnode->node_group,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->fc_id, rnode->sport->fc_id,
> +					U32_MAX)) {
> +			efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	}
> +	case EFCT_HW_BLS_ACC_SID:
> +	{
> +		struct sli_bls_payload	bls;
> +
> +		bls.type = SLI4_SLI_BLS_ACC;
> +		memcpy(&bls.u.acc, iparam->bls_sid.payload,
> +		       sizeof(bls.u.acc));
> +
> +		bls.ox_id = cpu_to_le16(iparam->bls_sid.ox_id);
> +		bls.rx_id = cpu_to_le16(iparam->bls_sid.rx_id);
> +
> +		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, &bls,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT,
> +					rnode->attached, rnode->node_group,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->fc_id, rnode->sport->fc_id,
> +					iparam->bls_sid.s_id)) {
> +			efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE SID error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	}
> +	default:
> +		efc_log_err(hw->os, "bad SRRS type %#x\n", type);
> +		rc = EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (rc == EFCT_HW_RTN_SUCCESS) {
> +		if (!io->wq)
> +			io->wq = efct_hw_queue_next_wq(hw, io);
> +
> +		io->xbusy = true;
> +
> +		/*
> +		 * Add IO to active io wqe list before submitting, in case the
> +		 * wcqe processing preempts this thread.
> +		 */
> +		io->wq->use_count++;
> +		efct_hw_add_io_timed_wqe(hw, io);
> +		rc = efct_hw_wq_write(io->wq, &io->wqe);
> +		if (rc >= 0) {
> +			/* non-negative return is success */
> +			rc = 0;
> +		} else {
> +			/* failed to write wqe, remove from active wqe list */
> +			efc_log_err(hw->os,
> +				     "sli_queue_write failed: %d\n", rc);
> +			io->xbusy = false;
> +			efct_hw_remove_io_timed_wqe(hw, io);
> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * Send a read, write, or response IO.
> + *
> + * This routine supports sending a higher-level IO (for example, FCP) between
> + * two endpoints as a target or initiator. Examples include:
> + *  - Sending read data and good response (target).
> + *  - Sending a response (target with no data or after receiving write data).
> + *  .
> + * This routine assumes all IOs use the SGL associated with the HW IO. Prior to
> + * calling this routine, the data should be loaded using efct_hw_io_add_sge().
> + */
> +enum efct_hw_rtn
> +efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
> +		struct efct_hw_io *io,
> +		u32 len, union efct_hw_io_param_u *iparam,
> +		struct efc_remote_node *rnode, void *cb, void *arg)
> +{
> +	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
> +	u32	rpi;
> +	bool send_wqe = true;
> +
> +	if (!io || !rnode || !iparam) {
> +		pr_err("bad parm hw=%p io=%p iparam=%p rnode=%p\n",
> +			hw, io, iparam, rnode);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (hw->state != EFCT_HW_STATE_ACTIVE) {
> +		efc_log_err(hw->os, "cannot send IO, HW state=%d\n",
> +			     hw->state);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	rpi = rnode->indicator;
> +
> +	/*
> +	 * Save state needed during later stages
> +	 */
> +	io->rnode = rnode;
> +	io->type  = type;
> +	io->done  = cb;
> +	io->arg   = arg;
> +
> +	/*
> +	 * Format the work queue entry used to send the IO
> +	 */
> +	switch (type) {
> +	case EFCT_HW_IO_TARGET_WRITE: {
> +		u16 flags = iparam->fcp_tgt.flags;
> +		struct fcp_txrdy *xfer = io->xfer_rdy.virt;
> +
> +		/*
> +		 * Fill in the XFER_RDY for IF_TYPE 0 devices
> +		 */
> +		xfer->ft_data_ro = cpu_to_be32(iparam->fcp_tgt.offset);
> +		xfer->ft_burst_len = cpu_to_be32(len);
> +
> +		if (io->xbusy)
> +			flags |= SLI4_IO_CONTINUATION;
> +		else
> +			flags &= ~SLI4_IO_CONTINUATION;
> +
> +		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
> +
> +		if (sli_fcp_treceive64_wqe(&hw->sli,
> +					   io->wqe.wqebuf,
> +					   hw->sli.wqe_size,
> +					   &io->def_sgl,
> +					   io->first_data_sge,
> +					   iparam->fcp_tgt.offset, len,
> +					   io->indicator, io->reqtag,
> +					   SLI4_CQ_DEFAULT,
> +					   iparam->fcp_tgt.ox_id, rpi,
> +					   rnode->node_group,
> +					   rnode->fc_id, flags,
> +					   iparam->fcp_tgt.dif_oper,
> +					   iparam->fcp_tgt.blk_size,
> +					   iparam->fcp_tgt.cs_ctl,
> +					   iparam->fcp_tgt.app_id)) {
Whoa.
Now _that_ are a lot of arguments.
I would invite you to try to whittle down that list, eg by passing in
'iparam.fcp_tct' and 'rnode' instead of the individual elements.

> +			efc_log_err(hw->os, "TRECEIVE WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	}
> +	case EFCT_HW_IO_TARGET_READ: {
> +		u16 flags = iparam->fcp_tgt.flags;
> +
> +		if (io->xbusy)
> +			flags |= SLI4_IO_CONTINUATION;
> +		else
> +			flags &= ~SLI4_IO_CONTINUATION;
> +
> +		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
> +		if (sli_fcp_tsend64_wqe(&hw->sli, io->wqe.wqebuf,
> +					hw->sli.wqe_size, &io->def_sgl,
> +					io->first_data_sge,
> +					iparam->fcp_tgt.offset, len,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT, iparam->fcp_tgt.ox_id,
> +					rpi, rnode->node_group,
> +					rnode->fc_id, flags,
> +					iparam->fcp_tgt.dif_oper,
> +					iparam->fcp_tgt.blk_size,
> +					iparam->fcp_tgt.cs_ctl,
> +					iparam->fcp_tgt.app_id)) {

Same here.

> +			efc_log_err(hw->os, "TSEND WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	}
> +	case EFCT_HW_IO_TARGET_RSP: {
> +		u16 flags = iparam->fcp_tgt.flags;
> +
> +		if (io->xbusy)
> +			flags |= SLI4_IO_CONTINUATION;
> +		else
> +			flags &= ~SLI4_IO_CONTINUATION;
> +
> +		io->tgt_wqe_timeout = iparam->fcp_tgt.timeout;
> +		if (sli_fcp_trsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +				       hw->sli.wqe_size, &io->def_sgl,
> +				       len, io->indicator, io->reqtag,
> +				       SLI4_CQ_DEFAULT, iparam->fcp_tgt.ox_id,
> +					rpi, rnode->node_group, rnode->fc_id,
> +					flags, iparam->fcp_tgt.cs_ctl,
> +				       0, iparam->fcp_tgt.app_id)) {

And here.

> +			efc_log_err(hw->os, "TRSP WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +
> +		break;
> +	}
> +	default:
> +		efc_log_err(hw->os, "unsupported IO type %#x\n", type);
> +		rc = EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (send_wqe && rc == EFCT_HW_RTN_SUCCESS) {
> +		if (!io->wq)
> +			io->wq = efct_hw_queue_next_wq(hw, io);
> +
> +		io->xbusy = true;
> +
> +		/*
> +		 * Add IO to active io wqe list before submitting, in case the
> +		 * wcqe processing preempts this thread.
> +		 */
> +		hw->tcmd_wq_submit[io->wq->instance]++;
> +		io->wq->use_count++;
> +		efct_hw_add_io_timed_wqe(hw, io);
> +		rc = efct_hw_wq_write(io->wq, &io->wqe);
> +		if (rc >= 0) {
> +			/* non-negative return is success */
> +			rc = 0;
> +		} else {
> +			/* failed to write wqe, remove from active wqe list */
> +			efc_log_err(hw->os,
> +				     "sli_queue_write failed: %d\n", rc);
> +			io->xbusy = false;
> +			efct_hw_remove_io_timed_wqe(hw, io);
> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * Send a raw frame
> + *
> + * Using the SEND_FRAME_WQE, a frame consisting of header and payload is sent.
> + */
> +enum efct_hw_rtn
> +efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
> +		   u8 sof, u8 eof, struct efc_dma *payload,
> +		   struct efct_hw_send_frame_context *ctx,
> +		   void (*callback)(void *arg, u8 *cqe, int status),
> +		   void *arg)
> +{
> +	int rc;
> +	struct efct_hw_wqe *wqe;
> +	u32 xri;
> +	struct hw_wq *wq;
> +
> +	wqe = &ctx->wqe;
> +
> +	/* populate the callback object */
> +	ctx->hw = hw;
> +
> +	/* Fetch and populate request tag */
> +	ctx->wqcb = efct_hw_reqtag_alloc(hw, callback, arg);
> +	if (!ctx->wqcb) {
> +		efc_log_err(hw->os, "can't allocate request tag\n");
> +		return EFCT_HW_RTN_NO_RESOURCES;
> +	}
> +
> +	/* Choose a work queue, first look for a class[1] wq, otherwise just
> +	 * use wq[0]
> +	 */
> +	wq = efct_varray_iter_next(hw->wq_class_array[1]);
> +	if (!wq)
> +		wq = hw->hw_wq[0];
> +
> +	/* Set XRI and RX_ID in the header based on which WQ, and which
> +	 * send_frame_io we are using
> +	 */
> +	xri = wq->send_frame_io->indicator;
> +
> +	/* Build the send frame WQE */
> +	rc = sli_send_frame_wqe(&hw->sli, wqe->wqebuf,
> +				hw->sli.wqe_size, sof, eof,
> +				(u32 *)hdr, payload, payload->len,
> +				EFCT_HW_SEND_FRAME_TIMEOUT, xri,
> +				ctx->wqcb->instance_index);
> +	if (rc) {
> +		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n",
> +			     rc);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/* Write to WQ */
> +	rc = efct_hw_wq_write(wq, wqe);
> +	if (rc) {
> +		efc_log_err(hw->os, "efct_hw_wq_write failed: %d\n", rc);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	wq->use_count++;
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +u32
> +efct_hw_io_get_count(struct efct_hw *hw,
> +		     enum efct_hw_io_count_type io_count_type)
> +{
> +	struct efct_hw_io *io = NULL;
> +	u32 count = 0;
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&hw->io_lock, flags);
> +
> +	switch (io_count_type) {
> +	case EFCT_HW_IO_INUSE_COUNT:
> +		list_for_each_entry(io, &hw->io_inuse, list_entry) {
> +			count = count + 1;
> +		}
> +		break;
> +	case EFCT_HW_IO_FREE_COUNT:
> +		list_for_each_entry(io, &hw->io_free, list_entry) {
> +			count = count + 1;
> +		}
> +		break;
> +	case EFCT_HW_IO_WAIT_FREE_COUNT:
> +		list_for_each_entry(io, &hw->io_wait_free, list_entry) {
> +			count = count + 1;
> +		}
> +		break;
> +	case EFCT_HW_IO_N_TOTAL_IO_COUNT:
> +		count = hw->config.n_io;
> +		break;
> +	}
> +
> +	spin_unlock_irqrestore(&hw->io_lock, flags);
> +
> +	return count;
> +}
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index 55679e40cc49..1a019594c471 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -952,4 +952,23 @@ efct_hw_process(struct efct_hw *hw, u32 vector, u32 max_isr_time_msec);
>  extern int
>  efct_hw_queue_hash_find(struct efct_queue_hash *hash, u16 id);
>  
> +int efct_hw_wq_write(struct hw_wq *wq, struct efct_hw_wqe *wqe);
> +enum efct_hw_rtn
> +efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
> +		   u8 sof, u8 eof, struct efc_dma *payload,
> +		struct efct_hw_send_frame_context *ctx,
> +		void (*callback)(void *arg, u8 *cqe, int status),
> +		void *arg);
> +typedef int(*efct_hw_srrs_cb_t)(struct efct_hw_io *io,
> +				struct efc_remote_node *rnode, u32 length,
> +				int status, u32 ext_status, void *arg);
> +extern enum efct_hw_rtn
> +efct_hw_srrs_send(struct efct_hw *hw, enum efct_hw_io_type type,
> +		  struct efct_hw_io *io,
> +		  struct efc_dma *send, u32 len,
> +		  struct efc_dma *receive, struct efc_remote_node *rnode,
> +		  union efct_hw_io_param_u *iparam,
> +		  efct_hw_srrs_cb_t cb,
> +		  void *arg);
> +
>  #endif /* __EFCT_H__ */
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
