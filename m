Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC46C352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FFB020644
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 09:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503792AbgDPJPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 05:15:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:48070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441145AbgDPIKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 04:10:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29698AD1E;
        Thu, 16 Apr 2020 08:10:21 +0000 (UTC)
Subject: Re: [PATCH v3 25/31] elx: efct: Hardware IO submission routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-26-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1af2f44d-ede4-bdd8-5812-9d4526a1f9b5@suse.de>
Date:   Thu, 16 Apr 2020 10:10:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-26-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines that write IO to Work queue, send SRRs and raw frames.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Reduced arguments for sli_fcp_tsend64_wqe(), sli_fcp_trsp64_wqe(),
>    sli_fcp_treceive64_wqe() calls
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 519 ++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h |  19 ++
>   2 files changed, 538 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index fd3c2dec3ef6..26dd9bd1eeef 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -2516,3 +2516,522 @@ efct_hw_flush(struct efct_hw *hw)
>   
>   	return EFC_SUCCESS;
>   }
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
> +					rnode->attached, rnode->fc_id,
> +					rnode->sport->fc_id)) {
> +			efc_log_err(hw->os, "REQ WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;

I did mention several times that I'm not a big fan of overly long 
argument lists.
Can't you pass in 'io' and 'rnode' directly and cut down on the number 
of arguments?

> +	case EFCT_HW_ELS_RSP:
> +		if (!send ||
> +		    sli_xmit_els_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, send, len,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT, iparam->els.ox_id,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->attached, rnode->fc_id,
> +					local_flags, U32_MAX)) {

Same here.

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
> +					iparam->els.ox_id,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->attached, rnode->fc_id,
> +					local_flags, iparam->els.s_id)) {

And here.

> +			efc_log_err(hw->os, "RSP (SID) WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_FC_CT:
> +		if (!send ||
> +		    sli_gen_request64_wqe(&hw->sli, io->wqe.wqebuf, io->sgl,
> +					len, receive->size, io->indicator,
> +					io->reqtag, SLI4_CQ_DEFAULT,
> +					rnode->fc_id, rnode->indicator,
> +					&iparam->fc_ct)) {

And here.

> +			efc_log_err(hw->os, "GEN WQE error\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_FC_CT_RSP:
> +		if (!send ||
> +		    sli_xmit_sequence64_wqe(&hw->sli, io->wqe.wqebuf,
> +					    io->sgl, len, io->indicator,
> +					    io->reqtag, rnode->fc_id,
> +					    rnode->indicator, &iparam->fc_ct)) {

And here.

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
> +					rnode->attached,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->fc_id, rnode->sport->fc_id,
> +					U32_MAX)) {

This simply cries out for doing so ...

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
> +		memcpy(&bls.u.acc, iparam->bls.payload,
> +		       sizeof(bls.u.acc));
> +
> +		bls.ox_id = cpu_to_le16(iparam->bls.ox_id);
> +		bls.rx_id = cpu_to_le16(iparam->bls.rx_id);
> +
> +		if (sli_xmit_bls_rsp64_wqe(&hw->sli, io->wqe.wqebuf,
> +					   hw->sli.wqe_size, &bls,
> +					io->indicator, io->reqtag,
> +					SLI4_CQ_DEFAULT,
> +					rnode->attached,
> +					rnode->indicator,
> +					rnode->sport->indicator,
> +					rnode->fc_id, rnode->sport->fc_id,
> +					iparam->bls.s_id)) {

...


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
