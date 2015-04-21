From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 06/14] lpfc: Add support for RDP ELS command.
Date: Tue, 21 Apr 2015 14:38:33 +0200
Message-ID: <20150421143833.00004b43@localhost>
References: <5535058d.LpgX8LwxtB5bdZhy%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52989 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbDUMie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 08:38:34 -0400
In-Reply-To: <5535058d.LpgX8LwxtB5bdZhy%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Add support for RDP ELS command.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> Signed-off-by: James Smart <james.smart@emulex.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   1 +
>  drivers/scsi/lpfc/lpfc_crtn.h |   2 +
>  drivers/scsi/lpfc/lpfc_els.c  | 415 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_hw.h   | 169 +++++++++++++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  | 201 ++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_mbox.c | 152 ++++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli4.h |  10 +
>  7 files changed, 950 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 3246d09..a5a56fa 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -231,6 +231,7 @@ struct lpfc_stats {
>  	uint32_t elsRcvRTV;
>  	uint32_t elsRcvECHO;
>  	uint32_t elsRcvLCB;
> +	uint32_t elsRcvRDP;
>  	uint32_t elsXmitFLOGI;
>  	uint32_t elsXmitFDISC;
>  	uint32_t elsXmitPLOGI;
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index 587e3e9..b0e6fe4 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -498,3 +498,5 @@ bool lpfc_disable_oas_lun(struct lpfc_hba *, struct lpfc_name *,
>  bool lpfc_find_next_oas_lun(struct lpfc_hba *, struct lpfc_name *,
>  			    struct lpfc_name *, uint64_t *, struct lpfc_name *,
>  			    struct lpfc_name *, uint64_t *, uint32_t *);
> +int lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox);
> +void lpfc_mbx_cmpl_rdp_page_a0(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb);
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 9099a06..455a5dd 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4617,6 +4617,417 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
>  	return sentplogi;
>  }
>  
> +void
> +lpfc_rdp_res_link_service(struct fc_rdp_link_service_desc *desc,
> +		uint32_t word0)
> +{
> +
> +	desc->tag = cpu_to_be32(RDP_LINK_SERVICE_DESC_TAG);
> +	desc->payload.els_req = word0;
> +	desc->length = cpu_to_be32(sizeof(desc->payload));
> +}
> +
> +void
> +lpfc_rdp_res_sfp_desc(struct fc_rdp_sfp_desc *desc,
> +		uint8_t *page_a0, uint8_t *page_a2)
> +{
> +	uint16_t wavelength;
> +	uint16_t temperature;
> +	uint16_t rx_power;
> +	uint16_t tx_bias;
> +	uint16_t tx_power;
> +	uint16_t vcc;
> +	uint16_t flag = 0;
> +	struct sff_trasnceiver_codes_byte4 *trasn_code_byte4;
> +	struct sff_trasnceiver_codes_byte5 *trasn_code_byte5;
> +
> +	desc->tag = cpu_to_be32(RDP_SFP_DESC_TAG);
> +
> +	trasn_code_byte4 = (struct sff_trasnceiver_codes_byte4 *)
> +			&page_a0[SSF_TRANSCEIVER_CODE_B4];
> +	trasn_code_byte5 = (struct sff_trasnceiver_codes_byte5 *)
> +			&page_a0[SSF_TRANSCEIVER_CODE_B5];
> +
> +	if ((trasn_code_byte4->fc_sw_laser) ||
> +	    (trasn_code_byte5->fc_sw_laser_sl) ||
> +	    (trasn_code_byte5->fc_sw_laser_sn)) {  /* check if its short WL */
> +		flag |= (SFP_FLAG_PT_SWLASER << SFP_FLAG_PT_SHIFT);
> +	} else if (trasn_code_byte4->fc_lw_laser) {
> +		wavelength = (page_a0[SSF_WAVELENGTH_B1] << 8) |
> +			page_a0[SSF_WAVELENGTH_B0];
> +		if (wavelength == SFP_WAVELENGTH_LC1310)
> +			flag |= SFP_FLAG_PT_LWLASER_LC1310 << SFP_FLAG_PT_SHIFT;
> +		if (wavelength == SFP_WAVELENGTH_LL1550)
> +			flag |= SFP_FLAG_PT_LWLASER_LL1550 << SFP_FLAG_PT_SHIFT;
> +	}
> +	/* check if its SFP+ */
> +	flag |= ((page_a0[SSF_IDENTIFIER] == SFF_PG0_IDENT_SFP) ?
> +			SFP_FLAG_CT_SFP_PLUS : SFP_FLAG_CT_UNKNOWN)
> +					<< SFP_FLAG_CT_SHIFT;
> +
> +	/* check if its OPTICAL */
> +	flag |= ((page_a0[SSF_CONNECTOR] == SFF_PG0_CONNECTOR_LC) ?
> +			SFP_FLAG_IS_OPTICAL_PORT : 0)
> +					<< SFP_FLAG_IS_OPTICAL_SHIFT;
> +
> +	temperature = (page_a2[SFF_TEMPERATURE_B1] << 8 |
> +		page_a2[SFF_TEMPERATURE_B0]);
> +	vcc = (page_a2[SFF_VCC_B1] << 8 |
> +		page_a2[SFF_VCC_B0]);
> +	tx_power = (page_a2[SFF_TXPOWER_B1] << 8 |
> +		page_a2[SFF_TXPOWER_B0]);
> +	tx_bias = (page_a2[SFF_TX_BIAS_CURRENT_B1] << 8 |
> +		page_a2[SFF_TX_BIAS_CURRENT_B0]);
> +	rx_power = (page_a2[SFF_RXPOWER_B1] << 8 |
> +		page_a2[SFF_RXPOWER_B0]);
> +	desc->sfp_info.temperature = cpu_to_be16(temperature);
> +	desc->sfp_info.rx_power = cpu_to_be16(rx_power);
> +	desc->sfp_info.tx_bias = cpu_to_be16(tx_bias);
> +	desc->sfp_info.tx_power = cpu_to_be16(tx_power);
> +	desc->sfp_info.vcc = cpu_to_be16(vcc);
> +
> +	desc->sfp_info.flags = cpu_to_be16(flag);
> +	desc->length = cpu_to_be32(sizeof(desc->sfp_info));
> +}
> +
> +void
> +lpfc_rdp_res_link_error(struct fc_rdp_link_error_status_desc *desc,
> +		READ_LNK_VAR *stat)
> +{
> +	uint32_t type;
> +
> +	desc->tag = cpu_to_be32(RDP_LINK_ERROR_STATUS_DESC_TAG);
> +
> +	type = VN_PT_PHY_PF_PORT << VN_PT_PHY_SHIFT;
> +
> +	desc->info.port_type = cpu_to_be32(type);
> +
> +	desc->info.link_status.link_failure_cnt =
> +		cpu_to_be32(stat->linkFailureCnt);
> +	desc->info.link_status.loss_of_synch_cnt =
> +		cpu_to_be32(stat->lossSyncCnt);
> +	desc->info.link_status.loss_of_signal_cnt =
> +		cpu_to_be32(stat->lossSignalCnt);
> +	desc->info.link_status.primitive_seq_proto_err =
> +		cpu_to_be32(stat->primSeqErrCnt);
> +	desc->info.link_status.invalid_trans_word =
> +		cpu_to_be32(stat->invalidXmitWord);
> +	desc->info.link_status.invalid_crc_cnt = cpu_to_be32(stat->crcCnt);
> +
> +	desc->length = cpu_to_be32(sizeof(desc->info));
> +}
> +
> +void
> +lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
> +{
> +	uint16_t rdp_cap = 0;
> +	uint16_t rdp_speed;
> +
> +	desc->tag = cpu_to_be32(RDP_PORT_SPEED_DESC_TAG);
> +
> +	switch (phba->sli4_hba.link_state.speed) {
> +	case LPFC_FC_LA_SPEED_1G:
> +		rdp_speed = RDP_PS_1GB;
> +		break;
> +	case LPFC_FC_LA_SPEED_2G:
> +		rdp_speed = RDP_PS_2GB;
> +		break;
> +	case LPFC_FC_LA_SPEED_4G:
> +		rdp_speed  = RDP_PS_4GB;
> +		break;

Additional space here

> +	case LPFC_FC_LA_SPEED_8G:
> +		rdp_speed = RDP_PS_8GB;
> +		break;
> +	case LPFC_FC_LA_SPEED_10G:
> +		rdp_speed = RDP_PS_10GB;
> +		break;
> +	case LPFC_FC_LA_SPEED_16G:
> +		rdp_speed = RDP_PS_16GB;
> +		break;
> +	case LPFC_FC_LA_SPEED_32G:
> +		rdp_speed = RDP_PS_32GB;
> +		break;
> +	default:
> +		rdp_speed = RDP_PS_UNKNOWN;
> +		break;
> +	}
> +
> +	desc->info.port_speed.speed = cpu_to_be16(rdp_speed);
> +
> +	if (phba->lmt & LMT_16Gb)
> +		rdp_cap |= RDP_PS_16GB;
> +	if (phba->lmt & LMT_10Gb)
> +		rdp_cap |= RDP_PS_10GB;
> +	if (phba->lmt & LMT_8Gb)
> +		rdp_cap |= RDP_PS_8GB;
> +	if (phba->lmt & LMT_4Gb)
> +		rdp_cap |= RDP_PS_4GB;
> +	if (phba->lmt & LMT_2Gb)
> +		rdp_cap |= RDP_PS_2GB;
> +	if (phba->lmt & LMT_1Gb)
> +		rdp_cap |= RDP_PS_1GB;
> +
> +	if (rdp_cap == 0)
> +		rdp_cap = RDP_CAP_UNKNOWN;
> +
> +	desc->info.port_speed.capabilities = cpu_to_be16(rdp_cap);
> +	desc->length = cpu_to_be32(sizeof(desc->info));
> +}
> +
> +void
> +lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
> +		struct lpfc_hba  *phba)

and here

> +{
> +
> +	desc->tag = cpu_to_be32(RDP_PORT_NAMES_DESC_TAG);
> +
> +	memcpy(desc->port_names.wwnn, phba->wwnn,
> +			sizeof(desc->port_names.wwnn));
> +
> +	memcpy(desc->port_names.wwpn, &phba->wwpn,
> +			sizeof(desc->port_names.wwpn));
> +
> +	desc->length = cpu_to_be32(sizeof(desc->port_names));
> +}
> +
> +void
> +lpfc_rdp_res_attach_port_names(struct fc_rdp_port_name_desc *desc,
> +		struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
> +{
> +
> +	desc->tag = cpu_to_be32(RDP_PORT_NAMES_DESC_TAG);
> +	if (vport->fc_flag & FC_FABRIC) {
> +		memcpy(desc->port_names.wwnn, &vport->fabric_nodename,
> +				sizeof(desc->port_names.wwnn));
> +
> +		memcpy(desc->port_names.wwpn, &vport->fabric_portname,
> +				sizeof(desc->port_names.wwpn));
> +	} else {  /* Point to Point */
> +		memcpy(desc->port_names.wwnn, &ndlp->nlp_nodename,
> +				sizeof(desc->port_names.wwnn));
> +
> +		memcpy(desc->port_names.wwnn, &ndlp->nlp_portname,
> +				sizeof(desc->port_names.wwpn));
> +	}
> +
> +	desc->length = cpu_to_be32(sizeof(desc->port_names));
> +}
> +
> +void
> +lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
> +		int status)
> +{
> +	struct lpfc_nodelist *ndlp = rdp_context->ndlp;
> +	struct lpfc_vport *vport = ndlp->vport;
> +	struct lpfc_iocbq *elsiocb;
> +	IOCB_t *icmd;
> +	uint8_t *pcmd;
> +	struct ls_rjt *stat;
> +	struct fc_rdp_res_frame *rdp_res;
> +	uint32_t cmdsize;
> +	int rc;
> +
> +	if (status != SUCCESS)
> +		goto error;
> +	cmdsize = sizeof(struct fc_rdp_res_frame);
> +
> +	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize,
> +			lpfc_max_els_tries, rdp_context->ndlp,
> +			rdp_context->ndlp->nlp_DID, ELS_CMD_ACC);
> +	lpfc_nlp_put(ndlp);
> +	if (!elsiocb)
> +		goto free_rdp_context;
> +
> +	icmd = &elsiocb->iocb;
> +	icmd->ulpContext = rdp_context->rx_id;
> +	icmd->unsli3.rcvsli3.ox_id = rdp_context->ox_id;
> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			"2171 Xmit RDP response tag x%x xri x%x, "
> +			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x",
> +			elsiocb->iotag, elsiocb->iocb.ulpContext,
> +			ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
> +			ndlp->nlp_rpi);
> +	rdp_res = (struct fc_rdp_res_frame *)
> +		(((struct lpfc_dmabuf *) elsiocb->context2)->virt);
> +	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
> +	memset(pcmd, 0, sizeof(struct fc_rdp_res_frame));
> +	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
> +
> +	/* For RDP payload */
> +	lpfc_rdp_res_link_service(&rdp_res->link_service_desc, ELS_CMD_RDP);
> +
> +	lpfc_rdp_res_sfp_desc(&rdp_res->sfp_desc,
> +			rdp_context->page_a0, rdp_context->page_a2);
> +	lpfc_rdp_res_speed(&rdp_res->portspeed_desc, phba);
> +	lpfc_rdp_res_link_error(&rdp_res->link_error_desc,
> +			&rdp_context->link_stat);
> +	lpfc_rdp_res_diag_port_names(&rdp_res->diag_port_names_desc, phba);
> +	lpfc_rdp_res_attach_port_names(&rdp_res->attached_port_names_desc,
> +			vport, ndlp);
> +	rdp_res->length = cpu_to_be32(RDP_DESC_PAYLOAD_SIZE);
> +
> +	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
> +
> +	phba->fc_stat.elsXmitACC++;
> +	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
> +	if (rc == IOCB_ERROR)
> +		lpfc_els_free_iocb(phba, elsiocb);
> +
> +	kfree(rdp_context);
> +
> +	return;
> +error:
> +	cmdsize = 2 * sizeof(uint32_t);
> +	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, lpfc_max_els_tries,
> +			ndlp, ndlp->nlp_DID, ELS_CMD_LS_RJT);
> +	lpfc_nlp_put(ndlp);
> +	if (!elsiocb)
> +		goto free_rdp_context;
> +
> +	icmd = &elsiocb->iocb;
> +	icmd->ulpContext = rdp_context->rx_id;
> +	icmd->unsli3.rcvsli3.ox_id = rdp_context->ox_id;
> +	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
> +
> +	*((uint32_t *) (pcmd)) = ELS_CMD_LS_RJT;
> +	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
> +	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
> +
> +	phba->fc_stat.elsXmitLSRJT++;
> +	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
> +	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
> +
> +	if (rc == IOCB_ERROR)
> +		lpfc_els_free_iocb(phba, elsiocb);
> +free_rdp_context:
> +	kfree(rdp_context);
> +}
> +
> +int
> +lpfc_get_rdp_info(struct lpfc_hba  *phba, struct lpfc_rdp_context *rdp_context)
> +{

and here

> +	LPFC_MBOXQ_t *mbox = NULL;
> +	int rc;
> +
> +	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +	if (!mbox) {
> +		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_ELS,
> +				"7105 failed to allocate mailbox memory");
> +		return 1;
> +	}
> +
> +	if (lpfc_sli4_dump_page_a0(phba, mbox))
> +		goto prep_mbox_fail;
> +	mbox->vport = rdp_context->ndlp->vport;
> +	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a0;
> +	mbox->context2 = (struct lpfc_rdp_context *) rdp_context;
> +	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
> +	if (rc == MBX_NOT_FINISHED)
> +		goto issue_mbox_fail;
> +
> +	return 0;
> +
> +prep_mbox_fail:
> +issue_mbox_fail:
> +	mempool_free(mbox, phba->mbox_mem_pool);
> +	return 1;
> +}
> +
> +/*
> + * lpfc_els_rcv_rdp - Process an unsolicited RDP ELS.
> + * @vport: pointer to a host virtual N_Port data structure.
> + * @cmdiocb: pointer to lpfc command iocb data structure.
> + * @ndlp: pointer to a node-list data structure.
> + *
> + * This routine processes an unsolicited RDP(Read Diagnostic Parameters)
> + * IOCB. First, the payload of the unsolicited RDP is checked.
> + * Then it will (1) send MBX_DUMP_MEMORY, Embedded DMP_LMSD sub command TYPE-3
> + * for Page A0, (2) send MBX_DUMP_MEMORY, DMP_LMSD for Page A2,
> + * (3) send MBX_READ_LNK_STAT to get link stat, (4) Call lpfc_els_rdp_cmpl
> + * gather all data and send RDP response.
> + *
> + * Return code
> + *   0 - Sent the acc response
> + *   1 - Sent the reject response.
> + */
> +static int
> +lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
> +		struct lpfc_nodelist *ndlp)
> +{
> +	struct lpfc_hba  *phba = vport->phba;

here too

> +	struct lpfc_dmabuf *pcmd;
> +	uint8_t rjt_err;
> +	struct fc_rdp_req_frame *rdp_req;
> +	struct lpfc_rdp_context *rdp_context;
> +	IOCB_t *cmd = NULL;
> +	struct ls_rjt stat;
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4 ||
> +			(bf_get(lpfc_sli_intf_if_type,
> +				&phba->sli4_hba.sli_intf) !=
> +						LPFC_SLI_INTF_IF_TYPE_2)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4 || (phba->hba_flag & HBA_FCOE_MODE)) {
> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
> +		goto rjt;
> +	}
> +

Code at rjt label also sets rjt_err to LSRJT_CMD_UNSUPPORTED.

Should the command not get rejected with LSRJT_UNABLE_TPC and
LSEXP_REQ_UNSUPPORTED?

> +	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
> +	rdp_req = (struct fc_rdp_req_frame *) pcmd->virt;
> +
> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			 "2422 ELS RDP Request "
> +			 "dec len %d tag x%x port_id %d len %d\n",
> +			 be32_to_cpu(rdp_req->rdp_des_length),
> +			 be32_to_cpu(rdp_req->nport_id_desc.tag),
> +			 be32_to_cpu(rdp_req->nport_id_desc.nport_id),
> +			 be32_to_cpu(rdp_req->nport_id_desc.length));
> +
> +	if (sizeof(struct fc_rdp_nport_desc) !=
> +			be32_to_cpu(rdp_req->rdp_des_length))
> +		goto rjt;
> +	if (RDP_N_PORT_DESC_TAG != be32_to_cpu(rdp_req->nport_id_desc.tag))
> +		goto rjt;
> +	if (RDP_NPORT_ID_SIZE !=
> +			be32_to_cpu(rdp_req->nport_id_desc.length))
> +		goto rjt;
> +	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
> +	if (!rdp_context) {
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		goto error;
> +	}
> +
> +	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
> +	cmd = &cmdiocb->iocb;
> +	rdp_context->ndlp = lpfc_nlp_get(ndlp);
> +	rdp_context->ox_id = cmd->unsli3.rcvsli3.ox_id;
> +	rdp_context->rx_id = cmd->ulpContext;
> +	rdp_context->cmpl = lpfc_els_rdp_cmpl;
> +	if (lpfc_get_rdp_info(phba, rdp_context)) {
> +		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_ELS,
> +				 "2423 Unable to send mailbox");
> +		kfree(rdp_context);
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		lpfc_nlp_put(ndlp);
> +		goto error;
> +	}
> +
> +	return 0;
> +rjt:
> +	rjt_err = LSRJT_CMD_UNSUPPORTED;
> +error:
> +	memset(&stat, 0, sizeof(stat));
> +	stat.un.b.lsRjtRsnCode = rjt_err;
> +	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
> +	return 1;
> +}

Sebastian
