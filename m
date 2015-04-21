From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 03/14] lpfc: Add support for ELS LCB.
Date: Tue, 21 Apr 2015 14:03:11 +0200
Message-ID: <20150421140311.00002282@localhost>
References: <5535058a.EPPUgDo7Qzh5RC0J%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63507 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbbDUMDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:03:11 -0400
In-Reply-To: <5535058a.EPPUgDo7Qzh5RC0J%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Add support for ELS LCB.
> 
> Also has a little whitespace fixing.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   1 +
>  drivers/scsi/lpfc/lpfc_els.c  | 239 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_hw.h   |  32 ++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  |  27 ++++-
>  drivers/scsi/lpfc/lpfc_init.c |   2 +
>  drivers/scsi/lpfc/lpfc_sli4.h |  11 ++
>  6 files changed, 306 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 9b81a34..3246d09 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -230,6 +230,7 @@ struct lpfc_stats {
>  	uint32_t elsRcvRRQ;
>  	uint32_t elsRcvRTV;
>  	uint32_t elsRcvECHO;
> +	uint32_t elsRcvLCB;
>  	uint32_t elsXmitFLOGI;
>  	uint32_t elsXmitFDISC;
>  	uint32_t elsXmitPLOGI;
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 851e8ef..9f28dcb 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4587,16 +4587,16 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
>  		if (!NLP_CHK_NODE_ACT(ndlp))
>  			continue;
>  		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
> -		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
> -		    (ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
> -		    (ndlp->nlp_flag & NLP_NPR_ADISC) == 0) {
> +				(ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
> +				(ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
> +				(ndlp->nlp_flag & NLP_NPR_ADISC) == 0) {
>  			ndlp->nlp_prev_state = ndlp->nlp_state;
>  			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
>  			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
>  			sentplogi++;
>  			vport->num_disc_nodes++;
>  			if (vport->num_disc_nodes >=
> -			    vport->cfg_discovery_threads) {
> +					vport->cfg_discovery_threads) {
>  				spin_lock_irq(shost->host_lock);
>  				vport->fc_flag |= FC_NLP_MORE;
>  				spin_unlock_irq(shost->host_lock);
> @@ -4615,6 +4615,233 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
>  	return sentplogi;
>  }
>  
> +static void
> +lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
> +{
> +	MAILBOX_t *mb;
> +	IOCB_t *icmd;
> +	uint8_t *pcmd;
> +	struct lpfc_iocbq *elsiocb;
> +	struct lpfc_nodelist *ndlp;
> +	struct ls_rjt *stat;
> +	struct lpfc_lcb_context *lcb_context;
> +	struct fc_lcb_res_frame  *lcb_res;

Additional space here

> +	uint32_t cmdsize;
> +	int rc;
> +
> +	mb = &pmb->u.mb;
> +
> +	lcb_context  = (struct lpfc_lcb_context *)pmb->context1;

here

> +	ndlp = lcb_context->ndlp;
> +	pmb->context1 = NULL;
> +	pmb->context2 = NULL;
> +
> +	if (mb->mbxStatus) {
> +		mempool_free(pmb, phba->mbox_mem_pool);
> +		goto error;
> +	}
> +
> +	mempool_free(pmb, phba->mbox_mem_pool);
> +
> +	cmdsize = sizeof(struct fc_lcb_res_frame);
> +	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
> +			lpfc_max_els_tries, ndlp,
> +			ndlp->nlp_DID, ELS_CMD_ACC);
> +
> +	/* Decrement the ndlp reference count from previous mbox command */
> +	lpfc_nlp_put(ndlp);
> +
> +	if (!elsiocb)
> +		goto free_lcb_context;
> +
> +	lcb_res = (struct fc_lcb_res_frame *)
> +		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
> +
> +	icmd = &elsiocb->iocb;
> +	icmd->ulpContext = lcb_context->rx_id;
> +	icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
> +
> +	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
> +	*((uint32_t *)(pcmd)) = ELS_CMD_ACC;
> +	lcb_res->lcb_sub_command = lcb_context->sub_command;
> +	lcb_res->lcb_type = lcb_context->type;
> +	lcb_res->lcb_frequency = lcb_context->frequency;
> +	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
> +	phba->fc_stat.elsXmitACC++;
> +	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
> +	if (rc == IOCB_ERROR)
> +		lpfc_els_free_iocb(phba, elsiocb);
> +
> +	kfree(lcb_context);
> +	return;
> +
> +error:
> +	cmdsize = sizeof(struct fc_lcb_res_frame);
> +	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
> +			lpfc_max_els_tries, ndlp,
> +			ndlp->nlp_DID, ELS_CMD_LS_RJT);
> +	lpfc_nlp_put(ndlp);
> +	if (!elsiocb)
> +		goto free_lcb_context;
> +
> +	icmd = &elsiocb->iocb;
> +	icmd->ulpContext = lcb_context->rx_id;
> +	icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
> +	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
> +
> +	*((uint32_t *)(pcmd)) = ELS_CMD_LS_RJT;
> +	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
> +	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
> +
> +	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
> +	phba->fc_stat.elsXmitLSRJT++;
> +	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
> +	if (rc == IOCB_ERROR)
> +		lpfc_els_free_iocb(phba, elsiocb);
> +free_lcb_context:
> +	kfree(lcb_context);
> +}
> +
> +static int
> +lpfc_sli4_set_beacon(struct lpfc_vport *vport,
> +		     struct lpfc_lcb_context *lcb_context,
> +		     uint32_t beacon_state)
> +{
> +	struct lpfc_hba  *phba = vport->phba;

here

> +	LPFC_MBOXQ_t *mbox = NULL;
> +	uint32_t len;
> +	int rc;
> +
> +	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +	if (!mbox)
> +		return 1;
> +
> +	len = sizeof(struct lpfc_mbx_set_beacon_config) -
> +		sizeof(struct lpfc_sli4_cfg_mhdr);
> +	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
> +			 LPFC_MBOX_OPCODE_SET_BEACON_CONFIG, len,
> +			 LPFC_SLI4_MBX_EMBED);
> +	mbox->context1 = (void *)lcb_context;
> +	mbox->vport = phba->pport;
> +	mbox->mbox_cmpl = lpfc_els_lcb_rsp;
> +	bf_set(lpfc_mbx_set_beacon_port_num, &mbox->u.mqe.un.beacon_config,
> +	       phba->sli4_hba.physical_port);
> +	bf_set(lpfc_mbx_set_beacon_state, &mbox->u.mqe.un.beacon_config,
> +	       beacon_state);
> +	bf_set(lpfc_mbx_set_beacon_port_type, &mbox->u.mqe.un.beacon_config, 1);
> +	bf_set(lpfc_mbx_set_beacon_duration, &mbox->u.mqe.un.beacon_config, 0);
> +	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
> +	if (rc == MBX_NOT_FINISHED) {
> +		mempool_free(mbox, phba->mbox_mem_pool);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/**
> + * lpfc_els_rcv_lcb - Process an unsolicited LCB
> + * @vport: pointer to a host virtual N_Port data structure.
> + * @cmdiocb: pointer to lpfc command iocb data structure.
> + * @ndlp: pointer to a node-list data structure.
> + *
> + * This routine processes an unsolicited LCB(LINK CABLE BEACON) IOCB.
> + * First, the payload of the unsolicited LCB is checked.
> + * Then based on Subcommand  either Becon will turn on or off.

here

> + *
> + * Return code
> + * 0 - Sent the acc response
> + * 1 - Sent the reject response.
> + **/
> +static int
> +lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
> +		 struct lpfc_nodelist *ndlp)
> +{
> +	struct lpfc_hba  *phba = vport->phba;

here

> +	struct lpfc_dmabuf *pcmd;
> +	IOCB_t *icmd;
> +	uint8_t *lp;
> +	struct fc_lcb_request_frame  *beacon;

here

> +	struct lpfc_lcb_context *lcb_context;
> +	uint8_t state, rjt_err;
> +	struct ls_rjt stat;
> +
> +	icmd = &cmdiocb->iocb;
> +	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
> +	lp = (uint8_t *)pcmd->virt;
> +	beacon = (struct fc_lcb_request_frame *)pcmd->virt;
> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			"0192 ELS LCB Data x%x x%x x%x x%x sub x%x "
> +			"type x%x frequency %x duration x%x\n",
> +			lp[0], lp[1], lp[2],
> +			beacon->lcb_command,
> +			beacon->lcb_sub_command,
> +			beacon->lcb_type,
> +			beacon->lcb_frequency,
> +			be16_to_cpu(beacon->lcb_duration));
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4 ||
> +	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
> +	    LPFC_SLI_INTF_IF_TYPE_2)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}
> +	lcb_context = kmalloc(sizeof(struct lpfc_lcb_context), GFP_KERNEL);
> +
> +	if (phba->hba_flag & HBA_FCOE_MODE) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}
> +	if (beacon->lcb_frequency  == 0) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}

here

> +	if ((beacon->lcb_type != LPFC_LCB_GREEN) &&
> +	    (beacon->lcb_type  != LPFC_LCB_AMBER)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}

here

> +	if ((beacon->lcb_sub_command != LPFC_LCB_ON) &&
> +	    (beacon->lcb_sub_command != LPFC_LCB_OFF)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}
> +	if ((beacon->lcb_sub_command == LPFC_LCB_ON) &&
> +	    (beacon->lcb_type != LPFC_LCB_GREEN) &&
> +	    (beacon->lcb_type  != LPFC_LCB_AMBER)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}

and here

Sebastian
