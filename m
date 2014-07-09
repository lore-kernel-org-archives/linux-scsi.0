From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH 4/8][RESEND] pm8001: Fix potential null pointer dereference
 and memory leak.
Date: Wed, 09 Jul 2014 13:57:28 +0200
Message-ID: <53BD2E28.8030103@redhat.com>
References: <1404906632-15766-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbaGIL6l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 07:58:41 -0400
In-Reply-To: <1404906632-15766-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, thenzl@redhat.com

Hi,

On 07/09/2014 01:50 PM, Suresh Thiagarajan wrote:
> From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> 
> The pm8001_get_phy_settings_info() function does not check the
> kzalloc() return value and does not free the allocated memory.

This patch is already in mainline.

Regards,
Maurizio Lombardi

> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> Acked-by: Jack Wang <xjtuwjp@gmail.com>
> Acked-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 86cf03a..aad060a 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -677,7 +677,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>   * pm8001_get_phy_settings_info : Read phy setting values.
>   * @pm8001_ha : our hba.
>   */
> -void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
> +static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>  {
>  
>  #ifdef PM8001_READ_VPD
> @@ -691,11 +691,15 @@ void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>  	payload.offset = 0;
>  	payload.length = 4096;
>  	payload.func_specific = kzalloc(4096, GFP_KERNEL);
> +	if (!payload.func_specific)
> +		return -ENOMEM;
>  	/* Read phy setting values from flash */
>  	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
>  	wait_for_completion(&completion);
>  	pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
> +	kfree(payload.func_specific);
>  #endif
> +	return 0;
>  }
>  
>  #ifdef PM8001_USE_MSIX
> @@ -879,8 +883,11 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>  	pm8001_init_sas_add(pm8001_ha);
>  	/* phy setting support for motherboard controller */
>  	if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2 &&
> -		pdev->subsystem_vendor != 0)
> -		pm8001_get_phy_settings_info(pm8001_ha);
> +		pdev->subsystem_vendor != 0) {
> +		rc = pm8001_get_phy_settings_info(pm8001_ha);
> +		if (rc)
> +			goto err_out_shost;
> +	}
>  	pm8001_post_sas_ha_init(shost, chip);
>  	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>  	if (rc)
> 
