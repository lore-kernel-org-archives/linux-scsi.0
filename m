From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH V2] pm80xx: Fix hibernation issue
Date: Fri, 20 Jun 2014 09:21:58 +0200
Message-ID: <53A3E116.4040709@gmail.com>
References: <1403190800-15022-1-git-send-email-bgrove@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47571 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaFTHWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2014 03:22:02 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so274488wib.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2014 00:22:00 -0700 (PDT)
In-Reply-To: <1403190800-15022-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bradley.grove@gmail.com
Cc: linux-scsi@vger.kernel.org, Bradley Grove <bgrove@attotech.com>, JBottomley@parallels.com, ebrown@attotech.com, pcullen@attotech.com


Thanks Brad for testing and fixing.
Acked-by: Jack Wang <xjtuwjp@gmail.com>

On 06/19/2014 05:13 PM, bradley.grove@gmail.com wrote:
> From: Bradley Grove <bgrove@attotech.com>
> 
> During hibernation, the HBA firmware may lose power and forget the device
> id info.   This causes the HBA to reject IO upon resume.   The fix is
> to call the libsas power management routines to make the domain device
> forgetful.
> 
> This fixes bug 76681: https://bugzilla.kernel.org/show_bug.cgi?id=76681
> 
> Signed-off-by: Bradley Grove <bgrove@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index c4f31b21..86cf03a 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -957,6 +957,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  	int  i, j;
>  	u32 device_state;
>  	pm8001_ha = sha->lldd_ha;
> +	sas_suspend_ha(sha);
>  	flush_workqueue(pm8001_wq);
>  	scsi_block_requests(pm8001_ha->shost);
>  	if (!pdev->pm_cap) {
> @@ -1006,6 +1007,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  	int rc;
>  	u8 i = 0, j;
>  	u32 device_state;
> +	DECLARE_COMPLETION_ONSTACK(completion);
>  	pm8001_ha = sha->lldd_ha;
>  	device_state = pdev->current_state;
>  
> @@ -1026,7 +1028,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  	rc = pci_go_44(pdev);
>  	if (rc)
>  		goto err_out_disable;
> -
> +	sas_prep_resume_ha(sha);
>  	/* chip soft rst only for spc */
>  	if (pm8001_ha->chip_id == chip_8001) {
>  		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
> @@ -1058,7 +1060,13 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  		for (i = 1; i < pm8001_ha->number_of_intr; i++)
>  			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
>  	}
> -	scsi_unblock_requests(pm8001_ha->shost);
> +	pm8001_ha->flags = PM8001F_RUN_TIME;
> +	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
> +		pm8001_ha->phy[i].enable_completion = &completion;
> +		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
> +		wait_for_completion(&completion);
> +	}
> +	sas_resume_ha(sha);
>  	return 0;
>  
>  err_out_disable:
> 

