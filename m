From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 4/5] ipr: Issue Configure Cache Parameters command.
Date: Wed, 04 Nov 2015 13:52:04 -0500
Message-ID: <20151104135204.Horde.9BGxEk3C1QJGsPnlaCsA4g2@ltc.linux.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-4-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:36137 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031045AbbKDSwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 13:52:09 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 4 Nov 2015 13:52:08 -0500
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 266AD38C803B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2015 13:52:06 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA4Iq6Z963438856
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 18:52:06 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA4Iq5Lh008272
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 13:52:05 -0500
In-Reply-To: <1446575170-18656-4-git-send-email-krisman@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>:

> Some new adapters require a special Configure Cache Parameters command
> to enable the adapter write cache, so send this during the adapter
> initialization if the adapter requires it.
>
> Changes since v1:
>         - Fix checkpatch.pl warnings.
>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c | 59  
> +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ipr.h |  4 ++++
>  2 files changed, 62 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 5efc7ef..79fd9ff 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -7675,6 +7675,63 @@ static int ipr_ioafp_query_ioa_cfg(struct  
> ipr_cmnd *ipr_cmd)
>  	return IPR_RC_JOB_RETURN;
>  }
>
> +static int ipr_ioa_service_action_failed(struct ipr_cmnd *ipr_cmd)
> +{
> +	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
> +
> +	if (ioasc == IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT)
> +		return IPR_RC_JOB_CONTINUE;
> +
> +	return ipr_reset_cmd_failed(ipr_cmd);
> +}
> +
> +static void ipr_build_ioa_service_action(struct ipr_cmnd *ipr_cmd,
> +					 __be32 res_handle, u8 sa_code)
> +{
> +	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
> +
> +	ioarcb->res_handle = res_handle;
> +	ioarcb->cmd_pkt.cdb[0] = IPR_IOA_SERVICE_ACTION;
> +	ioarcb->cmd_pkt.cdb[1] = sa_code;
> +	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
> +}
> +
> +/**
> + * ipr_ioafp_set_caching_parameters - Issue Set Cache parameters service
> + * action
> + *
> + * Return value:
> + *	none
> + **/
> +static int ipr_ioafp_set_caching_parameters(struct ipr_cmnd *ipr_cmd)
> +{
> +	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
> +	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
> +	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
> +
> +	ENTER;
> +
> +	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
> +
> +	if (pageC4->cache_cap[0] & IPR_CAP_SYNC_CACHE) {
> +		ipr_build_ioa_service_action(ipr_cmd,
> +					     cpu_to_be32(IPR_IOA_RES_HANDLE),
> +					     IPR_IOA_SA_CHANGE_CACHE_PARAMS);
> +
> +		ioarcb->cmd_pkt.cdb[2] = 0x40;
> +
> +		ipr_cmd->job_step_failed = ipr_ioa_service_action_failed;
> +		ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout,
> +			   IPR_SET_SUP_DEVICE_TIMEOUT);
> +
> +		LEAVE;
> +		return IPR_RC_JOB_RETURN;
> +	}
> +
> +	LEAVE;
> +	return IPR_RC_JOB_CONTINUE;
> +}
> +
>  /**
>   * ipr_ioafp_inquiry - Send an Inquiry to the adapter.
>   * @ipr_cmd:	ipr command struct
> @@ -7742,7 +7799,7 @@ static int ipr_ioafp_pageC4_inquiry(struct  
> ipr_cmnd *ipr_cmd)
>  	struct ipr_inquiry_pageC4 *pageC4 = &ioa_cfg->vpd_cbs->pageC4_data;
>
>  	ENTER;
> -	ipr_cmd->job_step = ipr_ioafp_query_ioa_cfg;
> +	ipr_cmd->job_step = ipr_ioafp_set_caching_parameters;
>  	memset(pageC4, 0, sizeof(*pageC4));
>
>  	if (ipr_inquiry_page_supported(page0, 0xC4)) {
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index 7be1271..b16bcd1 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -216,6 +216,10 @@
>  #define IPR_SET_ALL_SUPPORTED_DEVICES			0x80
>  #define IPR_IOA_SHUTDOWN				0xF7
>  #define	IPR_WR_BUF_DOWNLOAD_AND_SAVE			0x05
> +#define IPR_IOA_SERVICE_ACTION				0xD2
> +
> +/* IOA Service Actions */
> +#define IPR_IOA_SA_CHANGE_CACHE_PARAMS			0x14
>
>  /*
>   * Timeouts
> --
> 2.1.0


