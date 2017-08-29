From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 3/6] pm80xx : Different SAS addresses for phys.
Date: Tue, 29 Aug 2017 13:25:15 +0200
Message-ID: <CAD+HZHVF83w-s9ih5FQRAH_-OYPCNBYEs=9x=09LOwZ0nxymaQ@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com> <20150130060645.23653-4-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38866 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbdH2LZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 07:25:16 -0400
Received: by mail-wm0-f67.google.com with SMTP id u26so3368294wma.5
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 04:25:16 -0700 (PDT)
In-Reply-To: <20150130060645.23653-4-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com

2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
> Different SAS addresses are assigned for each set of phys.
>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 13 +++++++++----
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  3 +--
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 034b2f7d1135..d282f1562615 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -132,7 +132,7 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
>         sas_phy->oob_mode = OOB_NOT_CONNECTED;
>         sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
>         sas_phy->id = phy_id;
> -       sas_phy->sas_addr = &pm8001_ha->sas_addr[0];
> +       sas_phy->sas_addr = (u8 *)&phy->dev_sas_addr;
>         sas_phy->frame_rcvd = &phy->frame_rcvd[0];
>         sas_phy->ha = (struct sas_ha_struct *)pm8001_ha->shost->hostdata;
>         sas_phy->lldd_phy = phy;
> @@ -593,10 +593,12 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
>         for (i = 0; i < chip_info->n_phy; i++) {
>                 sha->sas_phy[i] = &pm8001_ha->phy[i].sas_phy;
>                 sha->sas_port[i] = &pm8001_ha->port[i].sas_port;
> +               sha->sas_phy[i]->sas_addr =
> +                       (u8 *)&pm8001_ha->phy[i].dev_sas_addr;
>         }
>         sha->sas_ha_name = DRV_NAME;
>         sha->dev = pm8001_ha->dev;
> -
> +       sha->strict_wide_ports = 1;
>         sha->lldd_module = THIS_MODULE;
>         sha->sas_addr = &pm8001_ha->sas_addr[0];
>         sha->num_phys = chip_info->n_phy;
> @@ -613,6 +615,7 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
>  static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>  {
>         u8 i, j;
> +       u8 sas_add[8];
>  #ifdef PM8001_READ_VPD
>         /* For new SPC controllers WWN is stored in flash vpd
>         *  For SPC/SPCve controllers WWN is stored in EEPROM
> @@ -674,10 +677,12 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>                         pm8001_ha->sas_addr[j] =
>                                         payload.func_specific[0x804 + i];
>         }
> -
> +       memcpy(sas_add, pm8001_ha->sas_addr, SAS_ADDR_SIZE);
>         for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
> +               if (i && ((i % 4) == 0))
> +                       sas_add[7] = sas_add[7] + 4;
>                 memcpy(&pm8001_ha->phy[i].dev_sas_addr,
> -                       pm8001_ha->sas_addr, SAS_ADDR_SIZE);
> +                       sas_add, SAS_ADDR_SIZE);
>                 PM8001_INIT_DBG(pm8001_ha,
>                         pm8001_printk("phy %d sas_addr = %016llx\n", i,
>                         pm8001_ha->phy[i].dev_sas_addr));
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 8fb5ddf08cc4..a07b023c09bf 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3041,7 +3041,6 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         port->port_state = portstate;
>         phy->identify.device_type = 0;
>         phy->phy_attached = 0;
> -       memset(&phy->dev_sas_addr, 0, SAS_ADDR_SIZE);
>         switch (portstate) {
>         case PORT_VALID:
>                 break;
> @@ -4394,7 +4393,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
>         payload.sas_identify.dev_type = SAS_END_DEVICE;
>         payload.sas_identify.initiator_bits = SAS_PROTOCOL_ALL;
>         memcpy(payload.sas_identify.sas_addr,
> -               pm8001_ha->sas_addr, SAS_ADDR_SIZE);
> +               &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
>         payload.sas_identify.phy_id = phy_id;
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
>         return ret;
> --
> 2.12.3
>
This removes the possibility to form a wide port, why do you want to do it?
