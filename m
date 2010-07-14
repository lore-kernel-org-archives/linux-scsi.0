From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: fix transition to operational for new adapters
Date: Wed, 14 Jul 2010 15:18:23 -0500
Message-ID: <4C3E1B8F.9010007@linux.vnet.ibm.com>
References: <20100714174038.137807350@linux.vnet.ibm.com> <4C3DF8B7.6000903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:40838 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab0GNUSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 16:18:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6EK7O6R017998
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 14:07:24 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o6EKISHJ219722
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 14:18:29 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6EKLehw001252
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2010 14:21:40 -0600
In-Reply-To: <4C3DF8B7.6000903@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 07/14/2010 12:49 PM, Wayne Boyer wrote:
> The method of transitioning to operational for new adapters includes using
> initialization stages.  The current stage is indicated via a register read.
> The final good stage in the sequence is "operational" but does not necessarily
> indicate that the driver can proceed.  There is another bit that gets set in the
> adapter->host interrupt register when the adapter has completed enough of its
> bringup such that it can accept commands.  The driver was not checking that
> bit before proceeding which led to intermittent errors and adapter resets.
> 
> The fix is to check the "transition to operational" bit in the interrupt
> register after detecting that the initialization stage is "operational" and
> only proceed if both are set.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2010-07-08 17:16:09.000000000 -0700
> +++ b/drivers/scsi/ipr.c	2010-07-08 17:17:15.000000000 -0700
> @@ -7166,12 +7166,15 @@ static int ipr_reset_next_stage(struct i
>  		stage_time = ioa_cfg->transop_timeout;
>  		ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
>  	} else if (stage == IPR_IPL_INIT_STAGE_TRANSOP) {
> -		ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
> -		maskval = IPR_PCII_IPL_STAGE_CHANGE;
> -		maskval = (maskval << 32) | IPR_PCII_IOA_TRANS_TO_OPER;
> -		writeq(maskval, ioa_cfg->regs.set_interrupt_mask_reg);
> -		int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
> -		return IPR_RC_JOB_CONTINUE;
> +		int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
> +		if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
> +			ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
> +			maskval = IPR_PCII_IPL_STAGE_CHANGE;
> +			maskval = (maskval << 32) | IPR_PCII_IOA_TRANS_TO_OPER;
> +			writeq(maskval, ioa_cfg->regs.set_interrupt_mask_reg);
> +			int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
> +			return IPR_RC_JOB_CONTINUE;
> +		}
>  	}
> 
>  	ipr_cmd->timer.data = (unsigned long) ipr_cmd;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


