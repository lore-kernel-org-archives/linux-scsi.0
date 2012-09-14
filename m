From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 10/42] qla2xxx: Implemetation of mctp.
Date: Fri, 14 Sep 2012 17:28:49 +0100
Message-ID: <1347640129.2450.15.camel@dabdike.int.hansenpartnership.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
	 <1345659696-3670-11-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59215 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab2INQ2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 12:28:53 -0400
In-Reply-To: <1345659696-3670-11-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Wed, 2012-08-22 at 14:21 -0400, Chad Dupuis wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 71310d3..c8d1aff 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4110,6 +4110,59 @@ exit:
>  	return rval;
>  }
>  
> +int
> +qla2xxx_mctp_dump(scsi_qla_host_t *vha)
> +{
> +	struct qla_hw_data *ha = vha->hw;
> +	int rval = QLA_FUNCTION_FAILED;
> +
> +	if (!IS_MCTP_CAPABLE(ha)) {
> +		/* This message can be removed from the final version */
> +		ql_log(ql_log_info, vha, 0x506d,
> +		    "This board is not MCTP capable\n");
> +		return rval;
> +	}
> +
> +	if (!ha->mctp_dump) {
> +		ha->mctp_dump = dma_alloc_coherent(&ha->pdev->dev,
> +		    MCTP_DUMP_SIZE, &ha->mctp_dump_dma, GFP_KERNEL);
> +
> +		if (!ha->mctp_dump) {
> +			ql_log(ql_log_warn, vha, 0x506e,
> +			    "Failed to allocate memory for mctp dump\n");
> +			return rval;
> +		}
> +	}
> +
> +#define MCTP_DUMP_STR_ADDR	0x00000000
> +	rval = qla2x00_dump_mctp_data(vha, ha->mctp_dump_dma,
> +	    MCTP_DUMP_STR_ADDR, MCTP_DUMP_SIZE/4);
> +	if (rval != QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x506f,
> +		    "Failed to capture mctp dump\n");
> +	} else {
> +		ql_log(ql_log_info, vha, 0x5070,
> +		    "Mctp dump capture for host (%ld/%p).\n",
> +		    vha->host_no, ha->mctp_dump);
> +		ha->mctp_dumped = 1;
> +	}
> +
> +	if (!ha->flags.nic_core_reset_hdlr_active) {
> +		ha->flags.nic_core_reset_hdlr_active = 1;
> +		if ((rval = qla83xx_restart_nic_firmware(vha)))

Assignment in if clause is a serious checkpatch error.  I can fix it up
this time, but please run your patches through checkpatch.

Thanks,

James


