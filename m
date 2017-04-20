From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 20/22] Update ABORT processing for NVMET.
Date: Thu, 20 Apr 2017 10:10:39 +0200
Message-ID: <20170420081003.GT6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-21-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943438AbdDTIKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 04:10:48 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-21-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:39PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> The driver with nvme had this routine stubbed.
> 
> Right now XRI_ABORTED_CQE is not handled and the FC NVMET
> Transport has a new API for the driver.
> 
> Missing code path, new NVME abort API
> Update ABORT processing for NVMET
> 
> There are 3 new FC NVMET Transport API/ template routines for NVMET:
> 
> lpfc_nvmet_xmt_fcp_release
> This NVMET template callback routine called to release context
> associated with an IO This routine is ALWAYS called last, even
> if the IO was aborted or completed in error.
> 
> lpfc_nvmet_xmt_fcp_abort
> This NVMET template callback routine called to abort an exchange that
> has an IO in progress
> 
> nvmet_fc_rcv_fcp_req
> When the lpfc driver receives an ABTS, this NVME FC transport layer
> callback routine is called. For this case there are 2 paths thru the
> driver: the driver either has an outstanding exchange / context for the
> XRI to be aborted or not.  If not, a BA_RJT is issued otherwise a BA_ACC
> 
> NVMET Driver abort paths:
> 
> There are 2 paths for aborting an IO. The first one is we receive an IO and
> decide not to process it because of lack of resources. An unsolicated ABTS
> is immediately sent back to the initiator as a response.
> lpfc_nvmet_unsol_fcp_buffer
>             lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)
> 
> The second one is we sent the IO up to the NVMET transport layer to
> process, and for some reason the NVME Transport layer decided to abort the
> IO before it completes all its phases. For this case there are 2 paths
> thru the driver:
> the driver either has an outstanding TSEND/TRECEIVE/TRSP WQE or no
> outstanding WQEs are present for the exchange / context.
> lpfc_nvmet_xmt_fcp_abort
>     if (LPFC_NVMET_IO_INP)
>         lpfc_nvmet_sol_fcp_issue_abort  (ABORT_WQE)
>                 lpfc_nvmet_sol_fcp_abort_cmp
>     else
>         lpfc_nvmet_unsol_fcp_issue_abort
>                 lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)
>                         lpfc_nvmet_unsol_fcp_abort_cmp
> 
> Context flags:
> LPFC_NVMET_IOP - his flag signifies an IO is in progress on the exchange.
> LPFC_NVMET_XBUSY  - this flag indicates the IO completed but the firmware
> is still busy with the corresponding exchange. The exchange should not be
> reused until after a XRI_ABORTED_CQE is received for that exchange.
> LPFC_NVMET_ABORT_OP - this flag signifies an ABORT_WQE was issued on the
> exchange.
> LPFC_NVMET_CTX_RLS  - this flag signifies a context free was requested,
> but we are deferring it due to an XBUSY or ABORT in progress.
> 
> A ctxlock is added to the context structure that is used whenever these
> flags are set/read  within the context of an IO.
> The LPFC_NVMET_CTX_RLS flag is only set in the defer_relase routine when
> the transport has resolved all IO associated with the buffer. The flag is
> cleared when the CTX is associated with a new IO.
> 
> An exchange can has both an LPFC_NVMET_XBUSY and a LPFC_NVMET_ABORT_OP
> condition active simultaneously. Both conditions must complete before the
> exchange is freed.
> When the abort callback (lpfc_nvmet_xmt_fcp_abort) is envoked:
> If there is an outstanding IO, the driver will issue an ABORT_WQE. This
> should result in 3 completions for the exchange:
> 1) IO cmpl with XB bit set
> 2) Abort WQE cmpl
> 3) XRI_ABORTED_CQE cmpl
> For this scenerio, after completion #1, the NVMET Transport IO rsp
> callback is called.  After completion #2, no action is taken with respect
> to the exchange / context.  After completion #3, the exchange context is
> free for re-use on another IO.
> 
> If there is no outstanding activity on the exchange, the driver will send a
> ABTS to the Initiator. Upon completion of this WQE, the exchange / context
> is freed for re-use on another IO.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

[...]

> @@ -139,6 +159,11 @@ lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
>  		   struct lpfc_dmabuf *mp)
>  {
>  	if (ctxp) {
> +		if (ctxp->flag)
> +			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +			"6314 rq_post ctx xri x%x flag x%x\n",
> +			ctxp->oxid, ctxp->flag);
> +

Indendation looks a bit odd here. Not sure if GCC-6's -Wmisleading-indent will
flag this.

> @@ -801,7 +847,122 @@ void
>  lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
>  			    struct sli4_wcqe_xri_aborted *axri)
>  {
> -	/* TODO: work in progress */
> +	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
> +	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
> +	struct lpfc_nvmet_rcv_ctx *ctxp, *next_ctxp;
> +	struct lpfc_nodelist *ndlp;
> +	unsigned long iflag = 0;
> +	int rrq_empty = 0;
> +	bool released = false;
> +
> +	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +			"6317 XB aborted xri x%x rxid x%x\n", xri, rxid);
> +
> +	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
> +		return;
> +	spin_lock_irqsave(&phba->hbalock, iflag);
> +	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
> +	list_for_each_entry_safe(ctxp, next_ctxp,
> +				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
> +				 list) {
> +		if (ctxp->rqb_buffer->sglq->sli4_xritag == xri) {

		if (ctxp->rqb_buffer->sglq->sli4_xritag != xri)
			continue;
			????

This saves the indent so the block below doesn't look so squezed and you don't
have to have a linebreak in spin_unlock() for instance.

> +			/* Check if we already received a free context call
> +			 * and we have completed processing an abort situation.
> +			 */
> +			if ((ctxp->flag & LPFC_NVMET_CTX_RLS) &&
> +			    !(ctxp->flag & LPFC_NVMET_ABORT_OP)) {
> +				list_del(&ctxp->list);
> +				released = true;
> +			}
> +			ctxp->flag &= ~LPFC_NVMET_XBUSY;
> +			spin_unlock(
> +				&phba->sli4_hba.abts_nvme_buf_list_lock);
> +
> +			rrq_empty = list_empty(&phba->active_rrq_list);
> +			spin_unlock_irqrestore(&phba->hbalock, iflag);
> +			ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
> +			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
> +			    ((ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) ||
> +			    (ndlp->nlp_state == NLP_STE_MAPPED_NODE))) {
> +				lpfc_set_rrq_active(
> +					phba, ndlp,
> +					ctxp->rqb_buffer->sglq->sli4_lxritag,
> +					rxid, 1);
> +				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
> +			}
> +
> +			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +					"6318 XB aborted %x flg x%x (%x)\n",
> +					ctxp->oxid, ctxp->flag, released);
> +			if (released)
> +				lpfc_nvmet_rq_post(phba, ctxp,
> +						   &ctxp->rqb_buffer->hbuf);
> +			if (rrq_empty)
> +				lpfc_worker_wake_up(phba);
> +			return;
> +		}
> +	}
> +	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
> +	spin_unlock_irqrestore(&phba->hbalock, iflag);
> +}
> +
> +int
> +lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
> +			   struct fc_frame_header *fc_hdr)
> +
> +{
> +#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
> +	struct lpfc_hba *phba = vport->phba;
> +	struct lpfc_nvmet_rcv_ctx *ctxp, *next_ctxp;
> +	struct nvmefc_tgt_fcp_req *rsp;
> +	uint16_t xri;
> +	unsigned long iflag = 0;
> +
> +	xri = be16_to_cpu(fc_hdr->fh_ox_id);
> +
> +	spin_lock_irqsave(&phba->hbalock, iflag);
> +	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
> +	list_for_each_entry_safe(ctxp, next_ctxp,
> +				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
> +				 list) {

Same here.

> +		if (ctxp->rqb_buffer->sglq->sli4_xritag == xri) {
> +			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
> +			spin_unlock_irqrestore(&phba->hbalock, iflag);
> +
> +			spin_lock_irqsave(&ctxp->ctxlock, iflag);
> +			ctxp->flag |= LPFC_NVMET_ABTS_RCV;
> +			spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
> +
> +			lpfc_nvmeio_data(phba,
> +					 "NVMET ABTS RCV: "
> +					 "xri x%x CPU %02x rjt %d\n",
> +					 xri, smp_processor_id(), 0);
> +
> +			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +					"6319 NVMET Rcv ABTS:acc xri x%x\n",
> +					xri);
> +
> +			rsp = &ctxp->ctx.fcp_req;
> +			nvmet_fc_rcv_fcp_abort(phba->targetport, rsp);
> +
> +			/* Respond with BA_ACC accordingly */
> +			lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 1);
> +			return 0;
> +		}
> +	}
> +	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
> +	spin_unlock_irqrestore(&phba->hbalock, iflag);
> +
> +	lpfc_nvmeio_data(phba, "NVMET ABTS RCV: xri x%x CPU %02x rjt %d\n",
> +			 xri, smp_processor_id(), 1);
> +
> +	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +			"6320 NVMET Rcv ABTS:rjt xri x%x\n", xri);
> +
> +	/* Respond with BA_RJT accordingly */
> +	lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 0);
> +	return 0;
> +#endif
>  }

> @@ -1677,10 +1847,15 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
>  	cmdwqe->context2 = NULL;
>  	cmdwqe->context3 = NULL;
>  	lpfc_sli_release_iocbq(phba, cmdwqe);
> +
> +	/* Since iaab/iaar are NOT set, there is no work left.
> +	 * For LPFC_NVMET_XBUSY, lpfc_sli4_nvmet_xri_aborted
> +	 * should have been called already.
> +	 */
>  }
>  
>  /**
> - * lpfc_nvmet_xmt_fcp_abort_cmp - Completion handler for ABTS
> + * lpfc_nvmet_unsol_fcp_abort_cmp - Completion handler for ABTS
>   * @phba: Pointer to HBA context object.
>   * @cmdwqe: Pointer to driver command WQE object.
>   * @wcqe: Pointer to driver response CQE object.
> @@ -1690,8 +1865,8 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
>   * The function frees memory resources used for the NVME commands.
>   **/
>  static void
> -lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
> -			     struct lpfc_wcqe_complete *wcqe)
> +lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
> +			       struct lpfc_wcqe_complete *wcqe)
>  {
>  	struct lpfc_nvmet_rcv_ctx *ctxp;
>  	struct lpfc_nvmet_tgtport *tgtp;
> @@ -1706,35 +1881,54 @@ lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
>  	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
>  	atomic_inc(&tgtp->xmt_abort_cmpl);
>  
> +	if (!ctxp) {
> +		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
> +				"6070 ABTS cmpl: WCQE: %08x %08x %08x %08x\n",
> +				wcqe->word0, wcqe->total_data_placed,
> +				result, wcqe->word3);
> +		return;
> +	}
> +
> +	/* Sanity check */
> +	if (ctxp->state != LPFC_NVMET_STE_ABORT) {
> +		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
> +				"6112 ABTS Wrong state:%d oxid x%x\n",
> +				ctxp->state, ctxp->oxid);

OK, this is kinda odd as well. We do a sanity check on the state but don't
take any measures other than writing a log message? Maybe that's OK, but it
surely looks a bit odd to me when reviewing. If it's OK please amend the
comment above and explain this is intented behaviour.


Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
