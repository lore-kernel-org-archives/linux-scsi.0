From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Fri, 20 May 2011 14:51:39 -0400
Message-ID: <4DD6B83B.5000703@redhat.com>
References: <4DD6AEB7.2090900@redhat.com> <4DD6AF29.8090903@redhat.com> <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419Ab1ETSvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 14:51:42 -0400
In-Reply-To: <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan.Kallickal@Emulex.Com
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com



On 05/20/2011 02:33 PM, Jayamohan.Kallickal@Emulex.Com wrote:
> Thanks for the patch. Pl see my comments in line
>
>   

np.

> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 24e20ba..8d71e47 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -874,16 +874,20 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  	struct hwi_controller *phwi_ctrlr;
>  	struct hwi_context_memory *phwi_context;
>  	int ret, msix_vec, i, j;
> -	char desc[32];
>  
>  	phwi_ctrlr = phba->phwi_ctrlr;
>  	phwi_context = phwi_ctrlr->phwi_ctxt;
>  
>  	if (phba->msix_enabled) {
>  		for (i = 0; i < phba->num_cpus; i++) {
> -			sprintf(desc, "beiscsi_msix_%04x", i);
> +			phba->msi_name[i] = kzalloc(BEISCSI_MSI_NAME,
> +						    GFP_KERNEL);
> +			if (!phba->msi_name[i])
> +				goto free_msix_irqs;
> We need to ensure i != 0 before jumping to free_msix_irqs
>   

Will fix in next version ... I think I may have to do a bit more work
here because I just realized that if we free_irq() on a non-allocated
irq we'll get an angry message from the kernel ;)  Unfortunately this
may complicate the code.... I'll rework this and see if I can come up
with something better.

> +			sprintf(phba->msi_name[i], "beiscsi_msix_%04x", i);
>  			msix_vec = phba->msix_entries[i].vector;
> -			ret = request_irq(msix_vec, be_isr_msix, 0, desc,
> +			ret = request_irq(msix_vec, be_isr_msix, 0,
> +					  phba->msi_name[i],
>  					  &phwi_context->be_eq[i]);
>  			if (ret) {
>  				shost_printk(KERN_ERR, phba->shost,
> @@ -915,8 +919,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  	}
>  	return 0;
>  free_msix_irqs:
> -	for (j = i - 1; j == 0; j++)
> +	for (j = i - 1; j == 0; j++) {
>  		free_irq(msix_vec, &phwi_context->be_eq[j]);
> +		kfree(phba->msi_name[i]);
> +	}
>   

... I was looking at this, and I'm confused by it.

Should this really be 'j++'?  Or should it be j-- ?

It seems to make sense that this code is j-- ...


>  	return ret;
>  }
>  
> @@ -4117,10 +4123,13 @@ static void beiscsi_remove(struct pci_dev *pcidev)
>  		for (i = 0; i <= phba->num_cpus; i++) {
>  			msix_vec = phba->msix_entries[i].vector;
>  			free_irq(msix_vec, &phwi_context->be_eq[i]);
> +			kfree(phba->msi_name[i]);
>  		}
>  	} else
> -		if (phba->pcidev->irq)
> +		if (phba->pcidev->irq) {
>  			free_irq(phba->pcidev->irq, phba);
> +			kfree(phba->msi_name[i]);
> Do we need the free for non-msix case as we are not allocation?
>   

Fixed in next version.

<snip>

P.
