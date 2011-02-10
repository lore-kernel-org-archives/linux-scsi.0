From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Thu, 10 Feb 2011 13:15:29 -0600
Message-ID: <4D543951.2000207@linux.vnet.ibm.com>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35862 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab1BJTPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 14:15:30 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1AIpIn5015826
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 13:51:25 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id D04E74DE803E
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 14:14:37 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p1AJFSNC1806432
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 14:15:28 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p1AJFRag022373
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 14:15:28 -0500
In-Reply-To: <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, nab@linux-iscsi.org

On 02/10/2011 06:21 AM, FUJITA Tomonori wrote:

> +static int process_mad_iu(struct iu_entry *iue)
> +{
> +	union viosrp_iu *iu = vio_iu(iue);
> +	struct viosrp_adapter_info *info;
> +	struct viosrp_host_config *conf;
> +
> +	switch (iu->mad.empty_iu.common.type) {
> +	case VIOSRP_EMPTY_IU_TYPE:
> +		printk(KERN_ERR "%s\n", "Unsupported EMPTY MAD IU");
> +		break;
> +	case VIOSRP_ERROR_LOG_TYPE:
> +		printk(KERN_ERR "%s\n", "Unsupported ERROR LOG MAD IU");
> +		iu->mad.error_log.common.status = 1;
> +		send_iu(iue, sizeof(iu->mad.error_log),	VIOSRP_MAD_FORMAT);
> +		break;
> +	case VIOSRP_ADAPTER_INFO_TYPE:
> +		info = &iu->mad.adapter_info;
> +		info->common.status = send_adapter_info(iue, info->buffer,
> +							info->common.length);
> +		send_iu(iue, sizeof(*info), VIOSRP_MAD_FORMAT);
> +		break;
> +	case VIOSRP_HOST_CONFIG_TYPE:
> +		conf = &iu->mad.host_config;
> +		conf->common.status = 1;
> +		send_iu(iue, sizeof(*conf), VIOSRP_MAD_FORMAT);
> +		break;
> +	default:
> +		printk(KERN_ERR "Unknown type %u\n", iu->srp.rsp.opcode);

We should be sending back the MAD not supported response here (0xF1):

iu->mad.common.status = 0xF1;
send_iu(iue, sizeof(iu->mad.common), VIOSRP_MAD_FORMAT);

Should also be doing this for the unsupported MAD types above, otherwise
the client never receives a response to these commands and times them out.


> +	}
> +
> +	return 1;
> +}
> +


> +
> +static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
> +{
> +	struct ibmvscsis_cmnd *cmd =
> +		container_of(se_cmd, struct ibmvscsis_cmnd, se_cmd);
> +	struct scsi_cmnd *sc = &cmd->sc;
> +	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
> +	struct srp_cmd *scmd = iue->sbuf->buf;
> +	int ret;
> +
> +	/*
> +	 * Allocate the necessary tasks to complete the received CDB+data
> +	 */
> +	ret = transport_generic_allocate_tasks(se_cmd, scmd->cdb);
> +	if (ret == -1) {
> +		/* Out of Resources */
> +		return PYX_TRANSPORT_LU_COMM_FAILURE;
> +	} else if (ret == -2) {
> +		/*
> +		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
> +		 */
> +		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
> +			return PYX_TRANSPORT_RESERVATION_CONFLICT;

Does this imply the driver supports scsi reservations? If it supports SCSI-2 reservations,
there is a capability that could be set in the capabilities MAD to advertise this
fact such that it can be used by the client.

> +		/*
> +		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
> +		 * sense data
> +		 */
> +		return PYX_TRANSPORT_USE_SENSE_REASON;
> +	}
> +
> +	return 0;
> +}
> +

> +
> +static int ibmvscsis_inquery(struct ibmvscsis_adapter *adapter,

/inquery/inquiry/

> +			      struct srp_cmd *cmd, char *data)
> +{
> +	struct se_portal_group *se_tpg = &adapter->se_tpg;
> +	struct inquiry_data *id = (struct inquiry_data *)data;
> +	u64 unpacked_lun, lun = cmd->lun;
> +	u8 *cdb = cmd->cdb;
> +	int len;
> +
> +	if (!data)
> +		printk(KERN_INFO "%s %d: oomu\n", __func__, __LINE__);
> +
> +	if (((cdb[1] & 0x3) == 0x3) || (!(cdb[1] & 0x3) && cdb[2])) {
> +		printk(KERN_INFO "%s %d: invalid req\n", __func__, __LINE__);
> +		return 0;
> +	}
> +
> +	if (cdb[1] & 0x3)
> +		printk(KERN_INFO "%s %d: needs the normal path\n",
> +		       __func__, __LINE__);
> +	else {
> +		id->qual_type = TYPE_DISK;
> +		id->rmb_reserve = 0x00;
> +		id->version = 0x84; /* ISO/IE */
> +		id->aerc_naca_hisup_format = 0x22; /* naca & fmt 0x02 */
> +		id->addl_len = sizeof(*id) - 4;
> +		id->bque_encserv_vs_multip_mchngr_reserved = 0x00;
> +		id->reladr_reserved_linked_cmdqueue_vs = 0x02; /* CMDQ */
> +		memcpy(id->vendor, "IBM	    ", 8);
> +		/*
> +		 * Don't even ask about the next bit.  AIX uses
> +		 * hardcoded device naming to recognize device types
> +		 * and their client won't  work unless we use VOPTA and
> +		 * VDASD.
> +		 */
> +		if (id->qual_type == TYPE_ROM)
> +			memcpy(id->product, "VOPTA blkdev    ", 16);
> +		else
> +			memcpy(id->product, "VDASD blkdev    ", 16);
> +
> +		memcpy(id->revision, "0001", 4);
> +
> +		snprintf(id->unique, sizeof(id->unique),
> +			 "IBM-VSCSI-%s-P%d-%x-%d-%d-%d\n",
> +			 system_id,
> +			 partition_number,
> +			 adapter->dma_dev->unit_address,
> +			 GETBUS(lun),
> +			 GETTARGET(lun),
> +			 GETLUN(lun));
> +	}

Do we have any persistent unique identifying data which we could use to
build a page 0x83 response such that persistent naming would work in the client?

> +
> +	len = min_t(int, sizeof(*id), cdb[4]);
> +
> +	unpacked_lun = scsi_lun_to_int(cmd->lun);
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +
> +	if (unpacked_lun < TRANSPORT_MAX_LUNS_PER_TPG &&
> +	    se_tpg->tpg_lun_list[unpacked_lun].lun_status ==
> +	    TRANSPORT_LUN_STATUS_ACTIVE)
> +		;
> +	else
> +		data[0] = TYPE_NO_LUN;
> +
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +
> +	return len;
> +}

Thanks!

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


