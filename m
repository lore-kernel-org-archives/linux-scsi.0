From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 1/8] pm80xx: configure PHY settings based on subsystem
 vendor ID
Date: Mon, 2 Nov 2015 09:00:43 +0100
Message-ID: <CAD+HZHVV2f_RoqQjVRF-jbQrEtXO8tZ1jLKvMQt8WGmsjtdsNg@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-2-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34590 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbKBIAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:00:45 -0500
Received: by lfgh9 with SMTP id h9so11312007lfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:00:44 -0800 (PST)
In-Reply-To: <1446216811-2248-2-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> Previuosly, all PMC Sierra 80xx controllers are assumed to be a
> motherboard controller, except if the subsystem vendor ID was equal to
> PCI_VENDOR_ID_ADAPTEC.  The driver then attempts to load PHY settings
> from NVRAM.  While this may be correct behavior for most controllers, it
> does not work with Adaptec and ATTO controllers since they do not store
> PHY settings in NVRAM and choose to use either custom PHY settings or chip
> defaults.  Loading random values from NVRAM may cause the controllers to
> malfunction in this edge case.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 5c0356f..8c094fd 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -720,6 +720,23 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>         return 0;
>  }
>
> +/**
> + * pm8001_configure_phy_settings : Configures PHY settings based on vendor ID.
> + * @pm8001_ha : our hba.
> + */
> +static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
> +{
> +       switch (pm8001_ha->pdev->subsystem_vendor) {
> +       case PCI_VENDOR_ID_ATTO:
> +       case PCI_VENDOR_ID_ADAPTEC2:
> +       case 0:
> +               return 0;
> +
> +       default:
> +               return pm8001_get_phy_settings_info(pm8001_ha);
> +       }
> +}
> +
>  #ifdef PM8001_USE_MSIX
>  /**
>   * pm8001_setup_msix - enable MSI-X interrupt
> @@ -902,12 +919,9 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>
>         pm8001_init_sas_add(pm8001_ha);
>         /* phy setting support for motherboard controller */
> -       if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2 &&
> -               pdev->subsystem_vendor != 0) {
> -               rc = pm8001_get_phy_settings_info(pm8001_ha);
> -               if (rc)
> -                       goto err_out_shost;
> -       }
> +       if (pm8001_configure_phy_settings(pm8001_ha))
> +               goto err_out_shost;
> +
>         pm8001_post_sas_ha_init(shost, chip);
>         rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
>         if (rc)
> --
> 2.4.3
>
