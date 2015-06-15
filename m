From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 1/4] ipr: Fix locking for unit attention handling
Date: Mon, 15 Jun 2015 10:44:20 -0400
Message-ID: <20150615104420.Horde.R1C8QcwnDQUPFtuoGeHRJw1@ltc.linux.ibm.com>
References: <201506120145.t5C1jFQW016709@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:44872 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbbFOOo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 10:44:26 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Mon, 15 Jun 2015 10:44:24 -0400
In-Reply-To: <201506120145.t5C1jFQW016709@d01av04.pok.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, gbertazi@linux.vnet.ibm.com, stable@vger.kernel.org

We have done stress test for a week with the patch and works fine.

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Make sure we have the host lock held when calling  
> scsi_report_bus_reset. Fixes
> a crash seen as the __devices list in the scsi host was changing as we were
> iterating through it.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff -puN drivers/scsi/ipr.c~ipr_erp_start_locking drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_erp_start_locking	2015-06-11  
> 20:18:13.806674185 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-06-11 20:18:13.814674115 -0500
> @@ -6263,21 +6263,23 @@ static void ipr_scsi_done(struct ipr_cmn
>  	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
>  	struct scsi_cmnd *scsi_cmd = ipr_cmd->scsi_cmd;
>  	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
> -	unsigned long hrrq_flags;
> +	unsigned long lock_flags;
>
>  	scsi_set_resid(scsi_cmd,  
> be32_to_cpu(ipr_cmd->s.ioasa.hdr.residual_data_len));
>
>  	if (likely(IPR_IOASC_SENSE_KEY(ioasc) == 0)) {
>  		scsi_dma_unmap(scsi_cmd);
>
> -		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
> +		spin_lock_irqsave(ipr_cmd->hrrq->lock, lock_flags);
>  		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
>  		scsi_cmd->scsi_done(scsi_cmd);
> -		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
> +		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, lock_flags);
>  	} else {
> -		spin_lock_irqsave(ipr_cmd->hrrq->lock, hrrq_flags);
> +		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
> +		spin_lock(&ipr_cmd->hrrq->_lock);
>  		ipr_erp_start(ioa_cfg, ipr_cmd);
> -		spin_unlock_irqrestore(ipr_cmd->hrrq->lock, hrrq_flags);
> +		spin_unlock(&ipr_cmd->hrrq->_lock);
> +		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>  	}
>  }
>
> _


