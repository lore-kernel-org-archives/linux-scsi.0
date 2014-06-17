From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] pm8001: Fix potential null pointer dereference and memory
 leak.
Date: Tue, 17 Jun 2014 14:28:56 +0200
Message-ID: <53A03488.9060407@gmail.com>
References: <1403003740-27487-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48836 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaFQM3L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 08:29:11 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so7075528wgg.5
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2014 05:29:10 -0700 (PDT)
In-Reply-To: <1403003740-27487-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: lindar_liu@usish.com, hch@infradead.org, jbottomley@parallels.com, linux-scsi@vger.kernel.org

On 06/17/2014 01:15 PM, Maurizio Lombardi wrote:
> The pm8001_get_phy_settings_info() function does not check
> the kzalloc() return value and does not free the allocated memory.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Looks good, thanks
Acked-by: Jack Wang <xjtuwjp@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index c4f31b21..e90c89f 100644
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

