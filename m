From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] pm8001: switch to pci_irq_alloc_vectors
Date: Wed, 1 Feb 2017 15:27:45 +0100
Message-ID: <9b5812e4-adb5-2932-f9cc-7ab9616cae17@profitbricks.com>
References: <1485958267-12768-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38755 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdBAO1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 09:27:52 -0500
Received: by mail-wm0-f47.google.com with SMTP id r141so41004412wmg.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2017 06:27:51 -0800 (PST)
In-Reply-To: <1485958267-12768-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, lindar_liu@usish.com, pmchba@pmcs.com
Cc: linux-scsi@vger.kernel.org



On 01.02.2017 15:11, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 35 ++++++++++++++---------------------
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 --
>  2 files changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9fc675f..417368c 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -888,7 +888,6 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  	u32 i = 0, j = 0;
>  	u32 number_of_intr;
>  	int flag = 0;
> -	u32 max_entry;
>  	int rc;
>  	static char intr_drvname[PM8001_MAX_MSIX_VEC][sizeof(DRV_NAME)+3];
>  
> @@ -900,18 +899,14 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  		flag &= ~IRQF_SHARED;
>  	}
>  
> -	max_entry = sizeof(pm8001_ha->msix_entries) /
> -		sizeof(pm8001_ha->msix_entries[0]);
> -	for (i = 0; i < max_entry ; i++)
> -		pm8001_ha->msix_entries[i].entry = i;
> -	rc = pci_enable_msix_exact(pm8001_ha->pdev, pm8001_ha->msix_entries,
> -		number_of_intr);
> -	pm8001_ha->number_of_intr = number_of_intr;
> -	if (rc)
> +	rc = pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
> +			number_of_intr, PCI_IRQ_MSIX);
> +	if (rc < 0)
>  		return rc;
> +	pm8001_ha->number_of_intr = number_of_intr;
>  
>  	PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
> -		"pci_enable_msix_exact request ret:%d no of intr %d\n",
> +		"pci_alloc_irq_vectors request ret:%d no of intr %d\n",
>  				rc, pm8001_ha->number_of_intr));
>  
>  	for (i = 0; i < number_of_intr; i++) {
> @@ -920,15 +915,15 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
>  		pm8001_ha->irq_vector[i].irq_id = i;
>  		pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
>  
> -		rc = request_irq(pm8001_ha->msix_entries[i].vector,
> +		rc = request_irq(pci_irq_vector(pm8001_ha->pdev, i),
>  			pm8001_interrupt_handler_msix, flag,
>  			intr_drvname[i], &(pm8001_ha->irq_vector[i]));
>  		if (rc) {
>  			for (j = 0; j < i; j++) {
> -				free_irq(pm8001_ha->msix_entries[j].vector,
> +				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
>  					&(pm8001_ha->irq_vector[i]));
>  			}
> -			pci_disable_msix(pm8001_ha->pdev);
> +			pci_free_irq_vectors(pm8001_ha->pdev);
>  			break;
>  		}
>  	}
> @@ -1102,11 +1097,10 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
>  
>  #ifdef PM8001_USE_MSIX
>  	for (i = 0; i < pm8001_ha->number_of_intr; i++)
> -		synchronize_irq(pm8001_ha->msix_entries[i].vector);
> +		synchronize_irq(pci_irq_vector(pdev, i));
>  	for (i = 0; i < pm8001_ha->number_of_intr; i++)
> -		free_irq(pm8001_ha->msix_entries[i].vector,
> -				&(pm8001_ha->irq_vector[i]));
> -	pci_disable_msix(pdev);
> +		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
> +	pci_free_irq_vectors(pdev);
>  #else
>  	free_irq(pm8001_ha->irq, sha);
>  #endif
> @@ -1152,11 +1146,10 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>  #ifdef PM8001_USE_MSIX
>  	for (i = 0; i < pm8001_ha->number_of_intr; i++)
> -		synchronize_irq(pm8001_ha->msix_entries[i].vector);
> +		synchronize_irq(pci_irq_vector(pdev, i));
>  	for (i = 0; i < pm8001_ha->number_of_intr; i++)
> -		free_irq(pm8001_ha->msix_entries[i].vector,
> -				&(pm8001_ha->irq_vector[i]));
> -	pci_disable_msix(pdev);
> +		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
> +	pci_free_irq_vectors(pdev);
>  #else
>  	free_irq(pm8001_ha->irq, sha);
>  #endif
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 6628cc3..e81a8fa 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -521,8 +521,6 @@ struct pm8001_hba_info {
>  	struct pm8001_device	*devices;
>  	struct pm8001_ccb_info	*ccb_info;
>  #ifdef PM8001_USE_MSIX
> -	struct msix_entry	msix_entries[PM8001_MAX_MSIX_VEC];
> -					/*for msi-x interrupt*/
>  	int			number_of_intr;/*will be used in remove()*/
>  #endif
>  #ifdef PM8001_USE_TASKLET
> 
Looks good, thanks!
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
