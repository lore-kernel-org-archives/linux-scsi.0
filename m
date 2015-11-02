From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 5/8] pm80xx: set PHY profiles for ATTO 12Gb SAS controllers
Date: Mon, 2 Nov 2015 09:08:20 +0100
Message-ID: <CAD+HZHWmy1=Yi38rnwgO=cX2SQo0fBYCsbtSVs3rSi1LkfqoWA@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-6-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35239 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbKBIIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:08:22 -0500
Received: by lbbes7 with SMTP id es7so82444129lbb.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:08:20 -0800 (PST)
In-Reply-To: <1446216811-2248-6-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> PHY profiles are not saved in NVRAM on ATTO 12Gb SAS controllers.
> Therefore, in order for the controller to function in a wide range of
> configurations, the PHY profiles must be statically set.  This patch
> provides the necessary functionality to do so.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 130 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |   2 +
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  32 ++++++++++
>  3 files changed, 164 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index fdbfab6..a0e55d4 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -732,6 +732,131 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
>         return 0;
>  }
>
> +struct pm8001_mpi3_phy_pg_trx_config {
> +       u32 LaneLosCfg;
> +       u32 LanePgaCfg1;
> +       u32 LanePisoCfg1;
> +       u32 LanePisoCfg2;
> +       u32 LanePisoCfg3;
> +       u32 LanePisoCfg4;
> +       u32 LanePisoCfg5;
> +       u32 LanePisoCfg6;
> +       u32 LaneBctCtrl;
> +};
> +
> +/**
> + * pm8001_get_internal_phy_settings : Retrieves the internal PHY settings
> + * @pm8001_ha : our adapter
> + * @phycfg : PHY config page to populate
> + */
> +static
> +void pm8001_get_internal_phy_settings(struct pm8001_hba_info *pm8001_ha,
> +               struct pm8001_mpi3_phy_pg_trx_config *phycfg)
> +{
> +       phycfg->LaneLosCfg   = 0x00000132;
> +       phycfg->LanePgaCfg1  = 0x00203949;
> +       phycfg->LanePisoCfg1 = 0x000000FF;
> +       phycfg->LanePisoCfg2 = 0xFF000001;
> +       phycfg->LanePisoCfg3 = 0xE7011300;
> +       phycfg->LanePisoCfg4 = 0x631C40C0;
> +       phycfg->LanePisoCfg5 = 0xF8102036;
> +       phycfg->LanePisoCfg6 = 0xF74A1000;
> +       phycfg->LaneBctCtrl  = 0x00FB33F8;
> +}
> +
> +/**
> + * pm8001_get_external_phy_settings : Retrieves the external PHY settings
> + * @pm8001_ha : our adapter
> + * @phycfg : PHY config page to populate
> + */
> +static
> +void pm8001_get_external_phy_settings(struct pm8001_hba_info *pm8001_ha,
> +               struct pm8001_mpi3_phy_pg_trx_config *phycfg)
> +{
> +       phycfg->LaneLosCfg   = 0x00000132;
> +       phycfg->LanePgaCfg1  = 0x00203949;
> +       phycfg->LanePisoCfg1 = 0x000000FF;
> +       phycfg->LanePisoCfg2 = 0xFF000001;
> +       phycfg->LanePisoCfg3 = 0xE7011300;
> +       phycfg->LanePisoCfg4 = 0x63349140;
> +       phycfg->LanePisoCfg5 = 0xF8102036;
> +       phycfg->LanePisoCfg6 = 0xF80D9300;
> +       phycfg->LaneBctCtrl  = 0x00FB33F8;
> +}
> +
> +/**
> + * pm8001_get_phy_mask : Retrieves the mask that denotes if a PHY is int/ext
> + * @pm8001_ha : our adapter
> + * @phymask : The PHY mask
> + */
> +static
> +void pm8001_get_phy_mask(struct pm8001_hba_info *pm8001_ha, int *phymask)
> +{
> +       switch (pm8001_ha->pdev->subsystem_device) {
> +       case 0x0070: /* H1280 - 8 external 0 internal */
> +       case 0x0072: /* H12F0 - 16 external 0 internal */
> +               *phymask = 0x0000;
> +               break;
> +
> +       case 0x0071: /* H1208 - 0 external 8 internal */
> +       case 0x0073: /* H120F - 0 external 16 internal */
> +               *phymask = 0xFFFF;
> +               break;
> +
> +       case 0x0080: /* H1244 - 4 external 4 internal */
> +               *phymask = 0x00F0;
> +               break;
> +
> +       case 0x0081: /* H1248 - 4 external 8 internal */
> +               *phymask = 0x0FF0;
> +               break;
> +
> +       case 0x0082: /* H1288 - 8 external 8 internal */
> +               *phymask = 0xFF00;
> +               break;
> +
> +       default:
> +               PM8001_INIT_DBG(pm8001_ha,
> +                       pm8001_printk("Unknown subsystem device=0x%.04x",
> +                               pm8001_ha->pdev->subsystem_device));
> +       }
> +}
> +
> +/**
> + * pm8001_set_phy_settings_ven_117c_12Gb : Configure ATTO 12Gb PHY settings
> + * @pm8001_ha : our adapter
> + */
> +static
> +int pm8001_set_phy_settings_ven_117c_12G(struct pm8001_hba_info *pm8001_ha)
> +{
> +       struct pm8001_mpi3_phy_pg_trx_config phycfg_int;
> +       struct pm8001_mpi3_phy_pg_trx_config phycfg_ext;
> +       int phymask = 0;
> +       int i = 0;
> +
> +       memset(&phycfg_int, 0, sizeof(phycfg_int));
> +       memset(&phycfg_ext, 0, sizeof(phycfg_ext));
> +
> +       pm8001_get_internal_phy_settings(pm8001_ha, &phycfg_int);
> +       pm8001_get_external_phy_settings(pm8001_ha, &phycfg_ext);
> +       pm8001_get_phy_mask(pm8001_ha, &phymask);
> +
> +       for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
> +               if (phymask & (1 << i)) {/* Internal PHY */
> +                       pm8001_set_phy_profile_single(pm8001_ha, i,
> +                                       sizeof(phycfg_int) / sizeof(u32),
> +                                       (u32 *)&phycfg_int);
> +
> +               } else { /* External PHY */
> +                       pm8001_set_phy_profile_single(pm8001_ha, i,
> +                                       sizeof(phycfg_ext) / sizeof(u32),
> +                                       (u32 *)&phycfg_ext);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * pm8001_configure_phy_settings : Configures PHY settings based on vendor ID.
>   * @pm8001_ha : our hba.
> @@ -740,6 +865,11 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
>  {
>         switch (pm8001_ha->pdev->subsystem_vendor) {
>         case PCI_VENDOR_ID_ATTO:
> +               if (pm8001_ha->pdev->device == 0x0042) /* 6Gb */
> +                       return 0;
> +               else
> +                       return pm8001_set_phy_settings_ven_117c_12G(pm8001_ha);
> +
>         case PCI_VENDOR_ID_ADAPTEC2:
>         case 0:
>                 return 0;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 9fa9705..6628cc3 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -710,6 +710,8 @@ int pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha);
>  int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
>  void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
>         u32 length, u8 *buf);
> +void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
> +               u32 phy, u32 length, u32 *buf);
>  int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
>  ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 struct device_attribute *attr, char *buf);
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 9a389f1..29c548b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4576,6 +4576,38 @@ void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
>         }
>         PM8001_INIT_DBG(pm8001_ha, pm8001_printk("phy settings completed\n"));
>  }
> +
> +void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
> +               u32 phy, u32 length, u32 *buf)
> +{
> +       u32 tag, opc;
> +       int rc, i;
> +       struct set_phy_profile_req payload;
> +       struct inbound_queue_table *circularQ;
> +
> +       memset(&payload, 0, sizeof(payload));
> +
> +       rc = pm8001_tag_alloc(pm8001_ha, &tag);
> +       if (rc)
> +               PM8001_INIT_DBG(pm8001_ha, pm8001_printk("Invalid tag"));
> +
> +       circularQ = &pm8001_ha->inbnd_q_tbl[0];
> +       opc = OPC_INB_SET_PHY_PROFILE;
> +
> +       payload.tag = cpu_to_le32(tag);
> +       payload.ppc_phyid = (((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
> +                               | (phy & 0xFF));
> +
> +       for (i = 0; i < length; i++)
> +               payload.reserved[i] = cpu_to_le32(*(buf + i));
> +
> +       rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
> +       if (rc)
> +               pm8001_tag_free(pm8001_ha, tag);
> +
> +       PM8001_INIT_DBG(pm8001_ha,
> +               pm8001_printk("PHY %d settings applied", phy));
> +}
>  const struct pm8001_dispatch pm8001_80xx_dispatch = {
>         .name                   = "pmc80xx",
>         .chip_init              = pm80xx_chip_init,
> --
> 2.4.3
>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
