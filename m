From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Do not use 32-bit atomic request descriptor
 for Ventura controllers
Date: Tue, 13 Feb 2018 10:44:07 +0100
Message-ID: <66b2c0b0-165e-cced-5566-0c80c9449b7f@suse.de>
References: <1518413940-1657-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933818AbeBMJoJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 04:44:09 -0500
In-Reply-To: <1518413940-1657-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, stable@vger.kernel.org

On 02/12/2018 06:39 AM, Shivasharan S wrote:
> Problem Statement:
> Sending I/O through 32 bit descriptors to Ventura series of controller
> results in IO timeout on certain conditions.
>  
> This error only occurs on systems with high I/O activity on
> Ventura series controllers.
>   
> Changes in this patch will prevent driver from using 32 bit descriptor
> and use 64 bit Descriptors.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 37 ++++++++++-------------------
>  1 file changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 073ced07e662..09f2bdb14b0a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -226,26 +226,21 @@ static void
>  megasas_fire_cmd_fusion(struct megasas_instance *instance,
>  		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
>  {
> -	if (instance->adapter_type == VENTURA_SERIES)
> -		writel(le32_to_cpu(req_desc->u.low),
> -			&instance->reg_set->inbound_single_queue_port);
> -	else {
>  #if defined(writeq) && defined(CONFIG_64BIT)
> -		u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
> -				le32_to_cpu(req_desc->u.low));
> +	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
> +		le32_to_cpu(req_desc->u.low));
>  
> -		writeq(req_data, &instance->reg_set->inbound_low_queue_port);
> +	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
>  #else
> -		unsigned long flags;
> -		spin_lock_irqsave(&instance->hba_lock, flags);
> -		writel(le32_to_cpu(req_desc->u.low),
> -			&instance->reg_set->inbound_low_queue_port);
> -		writel(le32_to_cpu(req_desc->u.high),
> -			&instance->reg_set->inbound_high_queue_port);
> -		mmiowb();
> -		spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	unsigned long flags;
> +	spin_lock_irqsave(&instance->hba_lock, flags);
> +	writel(le32_to_cpu(req_desc->u.low),
> +		&instance->reg_set->inbound_low_queue_port);
> +	writel(le32_to_cpu(req_desc->u.high),
> +		&instance->reg_set->inbound_high_queue_port);
> +	mmiowb();
> +	spin_unlock_irqrestore(&instance->hba_lock, flags);
>  #endif
> -	}
>  }
>  
>  /**
> @@ -982,7 +977,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  	const char *sys_info;
>  	MFI_CAPABILITIES *drv_ops;
>  	u32 scratch_pad_2;
> -	unsigned long flags;
>  	ktime_t time;
>  	bool cur_fw_64bit_dma_capable;
>  
> @@ -1121,14 +1115,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  			break;
>  	}
>  
> -	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
> -	spin_lock_irqsave(&instance->hba_lock, flags);
> -	writel(le32_to_cpu(req_desc.u.low),
> -	       &instance->reg_set->inbound_low_queue_port);
> -	writel(le32_to_cpu(req_desc.u.high),
> -	       &instance->reg_set->inbound_high_queue_port);
> -	mmiowb();
> -	spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	megasas_fire_cmd_fusion(instance, &req_desc);
>  
>  	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
