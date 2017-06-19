From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 2/6] qla2xxx: Add FC-NVMe command handling
Date: Mon, 19 Jun 2017 14:01:20 -0700
Message-ID: <add8f76c-e8f8-4462-12ad-ae405678549f@broadcom.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36739 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdFSVB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 17:01:29 -0400
Received: by mail-qk0-f178.google.com with SMTP id g83so43359808qkb.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 14:01:28 -0700 (PDT)
In-Reply-To: <20170616224744.3681-3-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
> @@ -615,8 +620,25 @@ struct sts_entry_24xx {
>   	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
>   
>   	uint32_t sense_len;		/* FCP SENSE length. */
> -	uint32_t rsp_data_len;		/* FCP response data length. */
> -	uint8_t data[28];		/* FCP response/sense information. */
> +
> +	union {
> +		struct {
> +			uint32_t rsp_data_len;	/* FCP response data length  */
> +			uint8_t data[28];	/* FCP rsp/sense information */
> +		};
> +		struct {
> +			/* nvme ersp hdr */
> +			__u8	status_code;
> +			__u8	rsvd0;
> +			__be16	iu_len;
> +			__be32	rsn;
> +			__be32	xfrd_len;
> +			__be32	rsvd12;
> +			uint8_t	cqe[16];
> +		};
> +		uint8_t nvme_ersp_data[32];
> +	};
> +

rather than defining a new structure for ersp - can't you use the struct 
nvme_fc_ersp_iu definition from include/linux/nvme-fc.h ?



>   	/*
>   	 * If DIF Error is set in comp_status, these additional fields are
>   	 * defined:
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 40385bc1d1fa..0d60fd0da604 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1799,6 +1799,86 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
>   	sp->done(sp, 0);
>   }
>   
> +static void
> +qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
> +{
> +	const char func[] = "NVME-IOCB";
> +	fc_port_t *fcport;
> +	srb_t *sp;
> +	struct srb_iocb *iocb;
> +	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
> +	uint16_t        state_flags;
> +	struct nvmefc_fcp_req *fd;
> +	struct srb_iocb *nvme;
> +
> +	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
> +	if (!sp)
> +		return;
> +
> +	iocb = &sp->u.iocb_cmd;
> +	fcport = sp->fcport;
> +	iocb->u.nvme.comp_status = le16_to_cpu(sts->comp_status);
> +	state_flags  = le16_to_cpu(sts->state_flags);
> +	fd = iocb->u.nvme.desc;
> +	nvme = &sp->u.iocb_cmd;
> +
> +	if (unlikely(nvme->u.nvme.aen_op)) {
> +		atomic_dec(&sp->vha->nvme_active_aen_cnt);
> +		/*
> +		 * Needed right now since the transport doesn't cleanup
> +		 * up AEN's IO's on remote port delete.
> +		 * they could have gone away while we still have the *fd.
> +		 */
> +		if (!atomic_read(&sp->fcport->nvme_ref_count)) {
> +			sp->done(sp, QLA_FUNCTION_FAILED);
> +			return;

The missing aen abort has been corrected for several months.. Should be 
no need for it.


> @@ -5996,6 +5998,18 @@ qla2x00_timer(scsi_qla_host_t *vha)
>   	if (!list_empty(&vha->work_list))
>   		start_dpc++;
>   
> +	/*
> +	 * FC-NVME
> +	 * see if the active AEN count has changed from what was last reported.
> +	 */
> +	if (atomic_read(&vha->nvme_active_aen_cnt) != vha->nvme_last_rptd_aen) {
> +		vha->nvme_last_rptd_aen =
> +		    atomic_read(&vha->nvme_active_aen_cnt);
> +		ql_log(ql_log_info, vha, 0x3002,
> +		    "reporting new aen count of %d to the fw TBD\n",
> +		    vha->nvme_last_rptd_aen);
> +	}
> +
>   	/* Schedule the DPC routine if needed */
>   	if ((test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
>   	    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) ||

Q: why does lldd need to track aen vs any other type of fcp operation ?
