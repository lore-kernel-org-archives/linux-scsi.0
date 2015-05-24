From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 06/15] lpfc: Add support for RDP ELS command.
Date: Sun, 24 May 2015 14:23:03 +0200
Message-ID: <20150524142303.00000bd6@localhost>
References: <555e1c09.H9g0xgyFF0UX5XNd%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62577 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbbEXMXL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 08:23:11 -0400
In-Reply-To: <555e1c09.H9g0xgyFF0UX5XNd%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Add support for RDP ELS command.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   1 +
>  drivers/scsi/lpfc/lpfc_crtn.h |   2 +
>  drivers/scsi/lpfc/lpfc_els.c  | 420 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_hw.h   | 169 +++++++++++++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  | 201 ++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_mbox.c | 152 +++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli4.h |  10 +
>  7 files changed, 955 insertions(+)

snip 

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 3975276..724b61c 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4615,6 +4615,422 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
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
> +		rdp_speed = RDP_PS_4GB;
> +		break;
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
> +		struct lpfc_hba *phba)
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

checkpatch suggests to not split this user-visible string

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
> +lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
> +{
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
> +	struct lpfc_hba *phba = vport->phba;
> +	struct lpfc_dmabuf *pcmd;
> +	uint8_t rjt_err, rjt_expl = LSEXP_NOTHING_MORE;
> +	struct fc_rdp_req_frame *rdp_req;
> +	struct lpfc_rdp_context *rdp_context;
> +	IOCB_t *cmd = NULL;
> +	struct ls_rjt stat;
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4 ||
> +			(bf_get(lpfc_sli_intf_if_type,
> +				&phba->sli4_hba.sli_intf) !=
> +						LPFC_SLI_INTF_IF_TYPE_2)) {
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		rjt_expl = LSEXP_REQ_UNSUPPORTED;
> +		goto error;
> +	}
> +
> +	if (phba->sli_rev < LPFC_SLI_REV4 || (phba->hba_flag & HBA_FCOE_MODE)) {
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		rjt_expl = LSEXP_REQ_UNSUPPORTED;
> +		goto error;
> +	}
> +
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

same here

> +
> +	if (sizeof(struct fc_rdp_nport_desc) !=
> +			be32_to_cpu(rdp_req->rdp_des_length))
> +		goto rjt_logerr;
> +	if (RDP_N_PORT_DESC_TAG != be32_to_cpu(rdp_req->nport_id_desc.tag))
> +		goto rjt_logerr;
> +	if (RDP_NPORT_ID_SIZE !=
> +			be32_to_cpu(rdp_req->nport_id_desc.length))
> +		goto rjt_logerr;
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
> +
> +rjt_logerr:
> +	rjt_err = LSRJT_LOGICAL_ERR;
> +
> +error:
> +	memset(&stat, 0, sizeof(stat));
> +	stat.un.b.lsRjtRsnCode = rjt_err;
> +	stat.un.b.lsRjtRsnCodeExp = rjt_expl;
> +	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
> +	return 1;
> +}
> +
> +
>  static void
>  lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
>  {
> @@ -7052,6 +7468,10 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
>  		phba->fc_stat.elsRcvLCB++;
>  		lpfc_els_rcv_lcb(vport, elsiocb, ndlp);
>  		break;
> +	case ELS_CMD_RDP:
> +		phba->fc_stat.elsRcvRDP++;
> +		lpfc_els_rcv_rdp(vport, elsiocb, ndlp);
> +		break;
>  	case ELS_CMD_RSCN:
>  		phba->fc_stat.elsRcvRSCN++;
>  		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index 6ad0a6f..892c525 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -543,6 +543,7 @@ struct fc_vft_header {
>  #define ELS_CMD_TEST      0x11000000
>  #define ELS_CMD_RRQ       0x12000000
>  #define ELS_CMD_REC       0x13000000
> +#define ELS_CMD_RDP       0x18000000
>  #define ELS_CMD_PRLI      0x20100014
>  #define ELS_CMD_PRLO      0x21100014
>  #define ELS_CMD_PRLO_ACC  0x02100014
> @@ -581,6 +582,7 @@ struct fc_vft_header {
>  #define ELS_CMD_TEST      0x11
>  #define ELS_CMD_RRQ       0x12
>  #define ELS_CMD_REC       0x13
> +#define ELS_CMD_RDP	  0x18

surrounding lines use just spaces

>  #define ELS_CMD_PRLI      0x14001020
>  #define ELS_CMD_PRLO      0x14001021
>  #define ELS_CMD_PRLO_ACC  0x14001002
> @@ -1042,6 +1044,168 @@ struct fc_lcb_res_frame {
>  	uint16_t      lcb_duration;     /* LCB Payload Word 2, bit 15:0  */
>  };
>  
> +/*
> + * Read Diagnostic Parameters (RDP) ELS frame.
> + */
> +#define SFF_PG0_IDENT_SFP              0x3
> +
> +#define SFP_FLAG_PT_OPTICAL            0x0
> +#define SFP_FLAG_PT_SWLASER            0x01
> +#define SFP_FLAG_PT_LWLASER_LC1310     0x02
> +#define SFP_FLAG_PT_LWLASER_LL1550     0x03
> +#define SFP_FLAG_PT_MASK               0x0F
> +#define SFP_FLAG_PT_SHIFT              0
> +
> +#define SFP_FLAG_IS_OPTICAL_PORT       0x01
> +#define SFP_FLAG_IS_OPTICAL_MASK       0x010
> +#define SFP_FLAG_IS_OPTICAL_SHIFT      4
> +
> +#define SFP_FLAG_IS_DESC_VALID         0x01
> +#define SFP_FLAG_IS_DESC_VALID_MASK    0x020
> +#define SFP_FLAG_IS_DESC_VALID_SHIFT   5
> +
> +#define SFP_FLAG_CT_UNKNOWN            0x0
> +#define SFP_FLAG_CT_SFP_PLUS           0x01
> +#define SFP_FLAG_CT_MASK               0x3C
> +#define SFP_FLAG_CT_SHIFT              6
> +
> +struct fc_rdp_port_name_info {
> +	uint8_t wwnn[8];
> +	uint8_t wwpn[8];
> +};

No padding here

> +
> +
> +/*
> + * Link Error Status Block Structure (FC-FS-3) for RDP
> + * This similar to RPS ELS
> + */
> +struct fc_link_status {
> +	uint32_t      link_failure_cnt;
> +	uint32_t      loss_of_synch_cnt;
> +	uint32_t      loss_of_signal_cnt;
> +	uint32_t      primitive_seq_proto_err;
> +	uint32_t      invalid_trans_word;
> +	uint32_t      invalid_crc_cnt;
> +
> +};

but here and below. There might be a gain from consistent style.

> +
> +#define RDP_PORT_NAMES_DESC_TAG  0x00010003
> +struct fc_rdp_port_name_desc {
> +	uint32_t	tag;     /* 0001 0003h */
> +	uint32_t	length;  /* set to size of payload struct */
> +	struct fc_rdp_port_name_info  port_names;

Additional space here

> +};
> +
> +
> +struct fc_rdp_link_error_status_payload_info {
> +	struct fc_link_status link_status; /* 24 bytes */
> +	uint32_t  port_type;             /* bits 31-30 only */
> +};

and here

> +
> +#define RDP_LINK_ERROR_STATUS_DESC_TAG  0x00010002
> +struct fc_rdp_link_error_status_desc {
> +	uint32_t         tag;     /* 0001 0002h */
> +	uint32_t         length;  /* set to size of payload struct */
> +	struct fc_rdp_link_error_status_payload_info info;
> +};
> +
> +#define VN_PT_PHY_UNKNOWN      0x00
> +#define VN_PT_PHY_PF_PORT      0x01
> +#define VN_PT_PHY_ETH_MAC      0x10
> +#define VN_PT_PHY_SHIFT                30

here

> +
> +#define RDP_PS_1GB             0x8000
> +#define RDP_PS_2GB             0x4000
> +#define RDP_PS_4GB             0x2000
> +#define RDP_PS_10GB            0x1000
> +#define RDP_PS_8GB             0x0800
> +#define RDP_PS_16GB            0x0400
> +#define RDP_PS_32GB            0x0200
> +
> +#define RDP_CAP_UNKNOWN        0x0001
> +#define RDP_PS_UNKNOWN         0x0002
> +#define RDP_PS_NOT_ESTABLISHED 0x0001
> +
> +struct fc_rdp_port_speed {
> +	uint16_t   capabilities;
> +	uint16_t   speed;
> +};
> +
> +struct fc_rdp_port_speed_info {
> +	struct fc_rdp_port_speed   port_speed;
> +};

here

> +
> +#define RDP_PORT_SPEED_DESC_TAG  0x00010001
> +struct fc_rdp_port_speed_desc {
> +	uint32_t         tag;            /* 00010001h */
> +	uint32_t         length;         /* set to size of payload struct */
> +	struct fc_rdp_port_speed_info info;
> +};
> +
> +#define RDP_NPORT_ID_SIZE      4
> +#define RDP_N_PORT_DESC_TAG    0x00000003
> +struct fc_rdp_nport_desc {
> +	uint32_t         tag;          /* 0000 0003h, big endian */
> +	uint32_t         length;       /* size of RDP_N_PORT_ID struct */
> +	uint32_t         nport_id : 12;
> +	uint32_t         reserved : 8;
> +};
> +
> +
> +struct fc_rdp_link_service_info {
> +	uint32_t         els_req;    /* Request payload word 0 value.*/
> +};
> +
> +#define RDP_LINK_SERVICE_DESC_TAG  0x00000001
> +struct fc_rdp_link_service_desc {
> +	uint32_t         tag;     /* Descriptor tag  1 */
> +	uint32_t         length;  /* set to size of payload struct. */
> +	struct fc_rdp_link_service_info  payload;
> +				  /* must be ELS req Word 0(0x18) */
> +};

here

> +
> +struct fc_rdp_sfp_info {
> +	uint16_t	temperature;
> +	uint16_t	vcc;
> +	uint16_t	tx_bias;
> +	uint16_t	tx_power;
> +	uint16_t	rx_power;
> +	uint16_t	flags;
> +};
> +
> +#define RDP_SFP_DESC_TAG  0x00010000
> +struct fc_rdp_sfp_desc {
> +	uint32_t         tag;
> +	uint32_t         length;  /* set to size of sfp_info struct */
> +	struct fc_rdp_sfp_info sfp_info;
> +};
> +
> +struct fc_rdp_req_frame {
> +	uint32_t         rdp_command;           /* ELS command opcode (0x18)*/
> +	uint32_t         rdp_des_length;        /* RDP Payload Word 1 */
> +	struct fc_rdp_nport_desc nport_id_desc; /* RDP Payload Word 2 - 4 */
> +};
> +
> +
> +struct fc_rdp_res_frame {
> +	uint32_t	reply_sequence;		/* FC word0 LS_ACC or LS_RJT */
> +	uint32_t	length;			/* FC Word 1      */
> +	struct fc_rdp_link_service_desc link_service_desc;    /* Word 2 -4  */
> +	struct fc_rdp_sfp_desc sfp_desc;                      /* Word 5 -9  */
> +	struct fc_rdp_port_speed_desc portspeed_desc;         /* Word 10-12 */
> +	struct fc_rdp_link_error_status_desc link_error_desc; /* Word 13-21 */
> +	struct fc_rdp_port_name_desc diag_port_names_desc;    /* Word 22-27 */
> +	struct fc_rdp_port_name_desc attached_port_names_desc;/* Word 28-33 */
> +};
> +
> +
> +#define RDP_DESC_PAYLOAD_SIZE (sizeof(struct fc_rdp_link_service_desc) \
> +			+ sizeof(struct fc_rdp_sfp_desc) \
> +			+ sizeof(struct fc_rdp_port_speed_desc) \
> +			+ sizeof(struct fc_rdp_link_error_status_desc) \
> +			+ (sizeof(struct fc_rdp_port_name_desc) * 2))
> +
> +
>  /******** FDMI ********/
>  
>  /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
> @@ -1619,6 +1783,11 @@ typedef struct {		/* FireFly BIU registers */
>  #define TEMPERATURE_OFFSET 0xB0	/* Slim offset for critical temperature event */
>  
>  /*
> + * return code Fail
> + */
> +#define FAILURE 1
> +
> +/*
>   *    Begin Structure Definitions for Mailbox Commands
>   */
>  
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 9f2bfcc..7cc7bec 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -2455,6 +2455,205 @@ struct lpfc_mbx_supp_pages {
>  #define LPFC_SLI4_PARAMETERS		2
>  };
>  
> +struct lpfc_mbx_memory_dump_type3 {
> +	uint32_t word1;
> +#define lpfc_mbx_memory_dump_type3_type_SHIFT    0
> +#define lpfc_mbx_memory_dump_type3_type_MASK     0x0000000f
> +#define lpfc_mbx_memory_dump_type3_type_WORD     word1
> +#define lpfc_mbx_memory_dump_type3_link_SHIFT    24
> +#define lpfc_mbx_memory_dump_type3_link_MASK     0x000000ff
> +#define lpfc_mbx_memory_dump_type3_link_WORD     word1
> +	uint32_t word2;
> +#define lpfc_mbx_memory_dump_type3_page_no_SHIFT  0
> +#define lpfc_mbx_memory_dump_type3_page_no_MASK   0x0000ffff
> +#define lpfc_mbx_memory_dump_type3_page_no_WORD   word2
> +#define lpfc_mbx_memory_dump_type3_offset_SHIFT   16
> +#define lpfc_mbx_memory_dump_type3_offset_MASK    0x0000ffff
> +#define lpfc_mbx_memory_dump_type3_offset_WORD    word2
> +	uint32_t word3;
> +#define lpfc_mbx_memory_dump_type3_length_SHIFT  0
> +#define lpfc_mbx_memory_dump_type3_length_MASK   0x00ffffff
> +#define lpfc_mbx_memory_dump_type3_length_WORD   word3
> +	uint32_t addr_lo;
> +	uint32_t addr_hi;
> +	uint32_t return_len;
> +};
> +
> +#define DMP_PAGE_A0             0xa0
> +#define DMP_PAGE_A2             0xa2
> +#define DMP_SFF_PAGE_A0_SIZE	256
> +#define DMP_SFF_PAGE_A2_SIZE	256
> +
> +#define SFP_WAVELENGTH_LC1310	1310
> +#define SFP_WAVELENGTH_LL1550	1550
> +
> +
> +/*
> + *  * SFF-8472 TABLE 3.4
> + *   */

broken comment

> +#define  SFF_PG0_CONNECTOR_UNKNOWN    0x00   /* Unknown  */
> +#define  SFF_PG0_CONNECTOR_SC         0x01   /* SC       */
> +#define  SFF_PG0_CONNECTOR_FC_COPPER1 0x02   /* FC style 1 copper connector */
> +#define  SFF_PG0_CONNECTOR_FC_COPPER2 0x03   /* FC style 2 copper connector */
> +#define  SFF_PG0_CONNECTOR_BNC        0x04   /* BNC / TNC */
> +#define  SFF_PG0_CONNECTOR__FC_COAX   0x05   /* FC coaxial headers */
> +#define  SFF_PG0_CONNECTOR_FIBERJACK  0x06   /* FiberJack */
> +#define  SFF_PG0_CONNECTOR_LC         0x07   /* LC        */
> +#define  SFF_PG0_CONNECTOR_MT         0x08   /* MT - RJ   */
> +#define  SFF_PG0_CONNECTOR_MU         0x09   /* MU        */
> +#define  SFF_PG0_CONNECTOR_SF         0x0A   /* SG        */
> +#define  SFF_PG0_CONNECTOR_OPTICAL_PIGTAIL 0x0B /* Optical pigtail */
> +#define  SFF_PG0_CONNECTOR_OPTICAL_PARALLEL 0x0C /* MPO Parallel Optic */
> +#define  SFF_PG0_CONNECTOR_HSSDC_II   0x20   /* HSSDC II */
> +#define  SFF_PG0_CONNECTOR_COPPER_PIGTAIL 0x21 /* Copper pigtail */
> +#define  SFF_PG0_CONNECTOR_RJ45       0x22  /* RJ45 */
> +
> +/* SFF-8472 Table 3.1 Diagnostics: Data Fields Address/Page A0 */
> +
> +#define SSF_IDENTIFIER			0
> +#define SSF_EXT_IDENTIFIER		1
> +#define SSF_CONNECTOR			2
> +#define SSF_TRANSCEIVER_CODE_B0		3
> +#define SSF_TRANSCEIVER_CODE_B1		4
> +#define SSF_TRANSCEIVER_CODE_B2		5
> +#define SSF_TRANSCEIVER_CODE_B3		6
> +#define SSF_TRANSCEIVER_CODE_B4		7
> +#define SSF_TRANSCEIVER_CODE_B5		8
> +#define SSF_TRANSCEIVER_CODE_B6		9
> +#define SSF_TRANSCEIVER_CODE_B7		10
> +#define SSF_ENCODING			11
> +#define SSF_BR_NOMINAL			12
> +#define SSF_RATE_IDENTIFIER		13
> +#define SSF_LENGTH_9UM_KM		14
> +#define SSF_LENGTH_9UM			15
> +#define SSF_LENGTH_50UM_OM2		16
> +#define SSF_LENGTH_62UM_OM1		17
> +#define SFF_LENGTH_COPPER		18
> +#define SSF_LENGTH_50UM_OM3		19
> +#define SSF_VENDOR_NAME			20
> +#define SSF_VENDOR_OUI			36
> +#define SSF_VENDOR_PN			40
> +#define SSF_VENDOR_REV			56
> +#define SSF_WAVELENGTH_B1		60
> +#define SSF_WAVELENGTH_B0		61
> +#define SSF_CC_BASE			63
> +#define SSF_OPTIONS_B1			64
> +#define SSF_OPTIONS_B0			65
> +#define SSF_BR_MAX			66
> +#define SSF_BR_MIN			67
> +#define SSF_VENDOR_SN			68
> +#define SSF_DATE_CODE			84
> +#define SSF_MONITORING_TYPEDIAGNOSTIC	92
> +#define SSF_ENHANCED_OPTIONS		93
> +#define SFF_8472_COMPLIANCE		94
> +#define SSF_CC_EXT			95
> +#define SSF_A0_VENDOR_SPECIFIC		96
> +
> +/* SFF-8472 Table 3.1a Diagnostics: Data Fields Address/Page A2 */
> +
> +#define SSF_AW_THRESHOLDS		0
> +#define SSF_EXT_CAL_CONSTANTS		56
> +#define SSF_CC_DMI			95
> +#define SFF_TEMPERATURE_B1		96
> +#define SFF_TEMPERATURE_B0		97
> +#define SFF_VCC_B1			98
> +#define SFF_VCC_B0			99
> +#define SFF_TX_BIAS_CURRENT_B1		100
> +#define SFF_TX_BIAS_CURRENT_B0		101
> +#define SFF_TXPOWER_B1			102
> +#define SFF_TXPOWER_B0			103
> +#define SFF_RXPOWER_B1			104
> +#define SFF_RXPOWER_B0			105
> +#define SSF_STATUS_CONTROL		110
> +#define SSF_ALARM_FLAGS_B1		112
> +#define SSF_ALARM_FLAGS_B0		113
> +#define SSF_WARNING_FLAGS_B1		116
> +#define SSF_WARNING_FLAGS_B0		117
> +#define SSF_EXT_TATUS_CONTROL_B1	118
> +#define SSF_EXT_TATUS_CONTROL_B0	119
> +#define SSF_A2_VENDOR_SPECIFIC		120
> +#define SSF_USER_EEPROM			128
> +#define SSF_VENDOR_CONTROL		148
> +
> +
> +/*
> + * Tranceiver codes Fibre Channel SFF-8472
> + * Table 3.5.
> + */
> +
> +struct sff_trasnceiver_codes_byte0 {
> +	uint8_t inifiband:4;
> +	uint8_t teng_ethernet:4;
> +};
> +
> +struct sff_trasnceiver_codes_byte1 {
> +	uint8_t  sonet:6;
> +	uint8_t  escon:2;
> +};
> +
> +struct sff_trasnceiver_codes_byte2 {
> +	uint8_t  soNet:8;
> +};
> +
> +struct sff_trasnceiver_codes_byte3 {
> +	uint8_t ethernet:8;
> +};
> +
> +struct sff_trasnceiver_codes_byte4 {
> +	uint8_t fc_el_lo:1;
> +	uint8_t fc_lw_laser:1;
> +	uint8_t fc_sw_laser:1;
> +	uint8_t fc_md_distance:1;
> +	uint8_t fc_lg_distance:1;
> +	uint8_t fc_int_distance:1;
> +	uint8_t fc_short_distance:1;
> +	uint8_t fc_vld_distance:1;
> +};
> +
> +struct sff_trasnceiver_codes_byte5 {
> +	uint8_t reserved1:1;
> +	uint8_t reserved2:1;
> +	uint8_t fc_sfp_active:1;  /* Active cable   */
> +	uint8_t fc_sfp_passive:1; /* Passive cable  */
> +	uint8_t fc_lw_laser:1;     /* Longwave laser */
> +	uint8_t fc_sw_laser_sl:1;
> +	uint8_t fc_sw_laser_sn:1;
> +	uint8_t fc_el_hi:1;        /* Electrical enclosure high bit */
> +};
> +
> +struct sff_trasnceiver_codes_byte6 {
> +	uint8_t fc_tm_sm:1;      /* Single Mode */
> +	uint8_t reserved:1;
> +	uint8_t fc_tm_m6:1;       /* Multimode, 62.5um (M6) */
> +	uint8_t fc_tm_tv:1;      /* Video Coax (TV) */
> +	uint8_t fc_tm_mi:1;      /* Miniature Coax (MI) */
> +	uint8_t fc_tm_tp:1;      /* Twisted Pair (TP) */
> +	uint8_t fc_tm_tw:1;      /* Twin Axial Pair  */
> +};
> +
> +struct sff_trasnceiver_codes_byte7 {
> +	uint8_t fc_sp_100MB:1;   /*  100 MB/sec */
> +	uint8_t reserve:1;
> +	uint8_t fc_sp_200mb:1;   /*  200 MB/sec */
> +	uint8_t fc_sp_3200MB:1;  /* 3200 MB/sec */
> +	uint8_t fc_sp_400MB:1;   /*  400 MB/sec */
> +	uint8_t fc_sp_1600MB:1;  /* 1600 MB/sec */
> +	uint8_t fc_sp_800MB:1;   /*  800 MB/sec */
> +	uint8_t fc_sp_1200MB:1;  /* 1200 MB/sec */
> +};
> +
> +/* User writable non-volatile memory, SFF-8472 Table 3.20 */
> +struct user_eeprom {
> +	uint8_t vendor_name[16];
> +	uint8_t vendor_oui[3];
> +	uint8_t vendor_pn[816];
> +	uint8_t vendor_rev[4];
> +	uint8_t vendor_sn[16];
> +	uint8_t datecode[6];
> +	uint8_t lot_code[2];
> +	uint8_t reserved191[57];
> +};
> +
>  struct lpfc_mbx_pc_sli4_params {
>  	uint32_t word1;
>  #define qs_SHIFT				0
> @@ -3054,6 +3253,7 @@ struct lpfc_mqe {
>  		struct lpfc_mbx_get_prof_cfg get_prof_cfg;
>  		struct lpfc_mbx_wr_object wr_object;
>  		struct lpfc_mbx_get_port_name get_port_name;
> +		struct lpfc_mbx_memory_dump_type3 mem_dump_type3;
>  		struct lpfc_mbx_nop nop;
>  	} un;
>  };
> @@ -3199,6 +3399,7 @@ struct lpfc_acqe_fc_la {
>  #define LPFC_FC_LA_SPEED_8G		0x8
>  #define LPFC_FC_LA_SPEED_10G		0xA
>  #define LPFC_FC_LA_SPEED_16G		0x10
> +#define LPFC_FC_LA_SPEED_32G            0x20

surrounding lines use tabs

>  #define lpfc_acqe_fc_la_topology_SHIFT		16
>  #define lpfc_acqe_fc_la_topology_MASK		0x000000FF
>  #define lpfc_acqe_fc_la_topology_WORD		word0

Sebastian
