From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH 06/14] lpfc: Add support for RDP ELS command.
Date: Wed, 20 May 2015 11:02:00 -0400
Message-ID: <555CA1E8.8090005@avagotech.com>
References: <5535058d.LpgX8LwxtB5bdZhy%james.smart@emulex.com> <20150421143833.00004b43@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35528 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbbETPCC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2015 11:02:02 -0400
Received: by qkdn188 with SMTP id n188so28629752qkd.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2015 08:02:01 -0700 (PDT)
In-Reply-To: <20150421143833.00004b43@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

Sebastian,

Agree with the statement on not returning right reject 
reasons/explanations. Patches will be reposted shortly with itcorrected 
as well as the spacing changes for this patch and patch 3.

-- james s


On 4/21/2015 8:38 AM, Sebastian Herbszt wrote:
> James Smart wrote:
>> Add support for RDP ELS command.
>>
>> ...
>> +/*
>> + * lpfc_els_rcv_rdp - Process an unsolicited RDP ELS.
>> + * @vport: pointer to a host virtual N_Port data structure.
>> + * @cmdiocb: pointer to lpfc command iocb data structure.
>> + * @ndlp: pointer to a node-list data structure.
>> + *
>> + * This routine processes an unsolicited RDP(Read Diagnostic Parameters)
>> + * IOCB. First, the payload of the unsolicited RDP is checked.
>> + * Then it will (1) send MBX_DUMP_MEMORY, Embedded DMP_LMSD sub command TYPE-3
>> + * for Page A0, (2) send MBX_DUMP_MEMORY, DMP_LMSD for Page A2,
>> + * (3) send MBX_READ_LNK_STAT to get link stat, (4) Call lpfc_els_rdp_cmpl
>> + * gather all data and send RDP response.
>> + *
>> + * Return code
>> + *   0 - Sent the acc response
>> + *   1 - Sent the reject response.
>> + */
>> +static int
>> +lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
>> +		struct lpfc_nodelist *ndlp)
>> +{
>> +	struct lpfc_hba  *phba = vport->phba;
> here too
>
>> +	struct lpfc_dmabuf *pcmd;
>> +	uint8_t rjt_err;
>> +	struct fc_rdp_req_frame *rdp_req;
>> +	struct lpfc_rdp_context *rdp_context;
>> +	IOCB_t *cmd = NULL;
>> +	struct ls_rjt stat;
>> +
>> +	if (phba->sli_rev < LPFC_SLI_REV4 ||
>> +			(bf_get(lpfc_sli_intf_if_type,
>> +				&phba->sli4_hba.sli_intf) !=
>> +						LPFC_SLI_INTF_IF_TYPE_2)) {
>> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
>> +		goto rjt;
>> +	}
>> +
>> +	if (phba->sli_rev < LPFC_SLI_REV4 || (phba->hba_flag & HBA_FCOE_MODE)) {
>> +		rjt_err = LSRJT_CMD_UNSUPPORTED;
>> +		goto rjt;
>> +	}
>> +
> Code at rjt label also sets rjt_err to LSRJT_CMD_UNSUPPORTED.
>
> Should the command not get rejected with LSRJT_UNABLE_TPC and
> LSEXP_REQ_UNSUPPORTED?
>
>> +	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
>> +	rdp_req = (struct fc_rdp_req_frame *) pcmd->virt;
>> +
>> +
>> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
>> +			 "2422 ELS RDP Request "
>> +			 "dec len %d tag x%x port_id %d len %d\n",
>> +			 be32_to_cpu(rdp_req->rdp_des_length),
>> +			 be32_to_cpu(rdp_req->nport_id_desc.tag),
>> +			 be32_to_cpu(rdp_req->nport_id_desc.nport_id),
>> +			 be32_to_cpu(rdp_req->nport_id_desc.length));
>> +
>> +	if (sizeof(struct fc_rdp_nport_desc) !=
>> +			be32_to_cpu(rdp_req->rdp_des_length))
>> +		goto rjt;
>> +	if (RDP_N_PORT_DESC_TAG != be32_to_cpu(rdp_req->nport_id_desc.tag))
>> +		goto rjt;
>> +	if (RDP_NPORT_ID_SIZE !=
>> +			be32_to_cpu(rdp_req->nport_id_desc.length))
>> +		goto rjt;
>> +	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
>> +	if (!rdp_context) {
>> +		rjt_err = LSRJT_UNABLE_TPC;
>> +		goto error;
>> +	}
>> +
>> +	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
>> +	cmd = &cmdiocb->iocb;
>> +	rdp_context->ndlp = lpfc_nlp_get(ndlp);
>> +	rdp_context->ox_id = cmd->unsli3.rcvsli3.ox_id;
>> +	rdp_context->rx_id = cmd->ulpContext;
>> +	rdp_context->cmpl = lpfc_els_rdp_cmpl;
>> +	if (lpfc_get_rdp_info(phba, rdp_context)) {
>> +		lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_ELS,
>> +				 "2423 Unable to send mailbox");
>> +		kfree(rdp_context);
>> +		rjt_err = LSRJT_UNABLE_TPC;
>> +		lpfc_nlp_put(ndlp);
>> +		goto error;
>> +	}
>> +
>> +	return 0;
>> +rjt:
>> +	rjt_err = LSRJT_CMD_UNSUPPORTED;
>> +error:
>> +	memset(&stat, 0, sizeof(stat));
>> +	stat.un.b.lsRjtRsnCode = rjt_err;
>> +	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
>> +	return 1;
>> +}
> Sebastian
>
>

