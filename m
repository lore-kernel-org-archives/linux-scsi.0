From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] regression, megaraid - fix irq setup process
Date: Tue, 02 Jun 2015 16:29:25 +0200
Message-ID: <556DBDC5.5090503@redhat.com>
References: <201506021043.t52Ah6Cb032634@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbbFBO31 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jun 2015 10:29:27 -0400
In-Reply-To: <201506021043.t52Ah6Cb032634@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org

On 06/02/2015 12:39 PM, Sumit.Saxena@avagotech.com wrote:
> From:Tomas Henzl<thenzl@redhat.com>
> 
> This fixes a regression caused by commit
> d3557fc8be11d25f316884581f487684f8e7dad3
> megaraid_sas : Add separate function for setting up IRQs This makes boot end with 'root does not exist' message on certain adapters.
> 
> The bug is that the driver does not setup ints for cards without msi-x support.
> This patch fixes it, in addition to that it moves tasklet initialisation before enable_intr, otherwise a kernel panic may occur, when an
> interrupt arrives before the tasklet is ready.
> 
> Signed-off-by: Tomas Henzl<thenzl@redhat.com>
> Signed-off-by: Sumit Saxena<sumit.saxena@avagotech.com>
This modified version fixes the issue too.
Thanks,  Tomas

> ---
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index a022c39..da26ac4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4619,18 +4619,18 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  			instance->msix_vectors = i;
>  		else
>  			instance->msix_vectors = 0;
> +	}
>  
> -		dev_info(&instance->pdev->dev,
> -			"firmware supports msix\t: (%d)", fw_msix_count);
> -		dev_info(&instance->pdev->dev,
> -			"current msix/online cpus\t: (%d/%d)\n",
> -			instance->msix_vectors, (unsigned int)num_online_cpus());
> +	dev_info(&instance->pdev->dev,
> +		"firmware supports msix\t: (%d)", fw_msix_count);
> +	dev_info(&instance->pdev->dev,
> +		"current msix/online cpus\t: (%d/%d)\n",
> +		instance->msix_vectors, (unsigned int)num_online_cpus());
>  
> -		if (instance->msix_vectors ?
> -				megasas_setup_irqs_msix(instance, 1) :
> -				megasas_setup_irqs_ioapic(instance))
> -			goto fail_setup_irqs;
> -	}
> +	if (instance->msix_vectors ?
> +		megasas_setup_irqs_msix(instance, 1) :
> +		megasas_setup_irqs_ioapic(instance))
> +		goto fail_setup_irqs;
>  
>  	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
>  				GFP_KERNEL);
> @@ -4646,6 +4646,10 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  	/* Get operational params, sge flags, send init cmd to controller */
>  	if (instance->instancet->init_adapter(instance))
>  		goto fail_init_adapter;
> +
> +	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
> +		(unsigned long)instance);
> +
>  	instance->instancet->enable_intr(instance);
>  
>  	printk(KERN_ERR "megasas: INIT adapter done\n");
> @@ -4762,12 +4766,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  		instance->throttlequeuedepth =
>  				MEGASAS_THROTTLE_QUEUE_DEPTH;
>  
> -        /*
> -	* Setup tasklet for cmd completion
> -	*/
> -
> -	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
> -		(unsigned long)instance);
>  
>  	/* Launch SR-IOV heartbeat timer */
>  	if (instance->requestorId) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

