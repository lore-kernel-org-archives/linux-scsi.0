Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DC2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 05:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 760FA6108E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 05:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhIGGAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 02:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhIGGAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 02:00:31 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43921C061575
        for <linux-scsi@vger.kernel.org>; Mon,  6 Sep 2021 22:59:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i6so12323020edu.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Sep 2021 22:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZok/NYeJIVmnNlBtG5I/CW8J8qrthWmqhcf1RDr96w=;
        b=I/nZjbRJE13bf78OsHvR+X7axuKltUDn7YL8vZwcfQujVrN1xZ3V5RUZyg30CK7pX3
         iVh9mjEc1lnpOTlGLUQwaJFmP4i+M24Yi2+Blee9EtDADvuvzHIvNcXyQPYU70L3Reyn
         dq2/f+nS1/tzG1ZHw7Y1NwJD2l6vGpTfeLxXqxXos7mzDuU5fSBlz0Va7MFBJGYoSUhj
         3RjSPgwGs0p2BLzU4OACHe+yPkFyhxl51xi9wvrV+wq3CO+lgTarM3s3mLnahLR+TDUZ
         nAcvKia3+J28DO2drNcujMvOZ1zHDEYdZEzs0+SzeZJ+46UUBKIZZ6YApL4Z30tVe9SI
         +pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZok/NYeJIVmnNlBtG5I/CW8J8qrthWmqhcf1RDr96w=;
        b=NK8lwa7VqXeM9u5B//IwfGkHyAfZuwnSO/f9haIuIbr3i5RP4Ukbc9It2uBdp3ykAm
         2BHFz+9onrxC4NKTOD0ax+jUxQPVelXahxLAXqeWVq6F+eq2IA4AAHZT67joZ+cehZp4
         21qC5nwEITahy4GOOXBBWBd3JHai8SwHQOsGxlEVLgzhcn4D7nmOqPRGOfzEV7Wx5taw
         RJ59tN2okacN0leT4i46xxiTZr9GNllJOLh571oxw12laBPVydDmJiysF5s0HQK5Nclz
         QQ4IOOQCJiCsFFvSG9LjOC+szB0g4EJ6db1EXHhUtpYhJvdpRuqw3qpJqjhB3bFI4QH6
         TRBQ==
X-Gm-Message-State: AOAM530KmQNzIsWWNOHRsEAEpW1lsnZq/9smo0Pcd3esY53HghKH9fc2
        YobmCIzEQxv6nY0WV5HWd4W3Kz4Tr+F3JckhSmHZ4A==
X-Google-Smtp-Source: ABdhPJwp3Izi+9x7b6aWUpeJPiVkgvvt54yPMo70zVlfhW2NhIDSLmDF4TtsG1dZTrlxGyDzQJNhcW4htx+zBojmJtM=
X-Received: by 2002:aa7:c952:: with SMTP id h18mr16854145edt.18.1630994361766;
 Mon, 06 Sep 2021 22:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com> <20210906170404.5682-2-Ajish.Koshy@microchip.com>
In-Reply-To: <20210906170404.5682-2-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 7 Sep 2021 07:59:11 +0200
Message-ID: <CAMGffE=6kh=q5eZFvh06p4kXezjAzs5Skv4kuEf4ORTFvEb1fQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] scsi: pm80xx: fix incorrect port value when
 registering a device
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 6, 2021 at 6:09 PM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> During phyup event, firmware gives the phy_id and port_id
> and driver is supposed to use the same during device handle
> registration. Earlier, driver was using port id value from
> libsas during device handle registration and at times, it is
> different from firmware assigned port id. This will lead to
> wrong device registration and eventually we would not see
> those drives.
>
> Fix is to use firmware assigned portid during device
> registration.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Thanks for the update.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c  |  7 ++++++-
>  drivers/scsi/pm8001/pm8001_init.c |  1 +
>  drivers/scsi/pm8001/pm8001_sas.c  | 15 +++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  7 ++++++-
>  5 files changed, 30 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 63690508313b..c9ecddd0d719 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3358,6 +3358,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
>         unsigned long flags;
>         u8 deviceType = pPayload->sas_identify.dev_type;
> +       phy->port = port;
> +       port->port_id = port_id;
>         port->port_state =  portstate;
>         phy->phy_state = PHY_STATE_LINK_UP_SPC;
>         pm8001_dbg(pm8001_ha, MSG,
> @@ -3434,6 +3436,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         unsigned long flags;
>         pm8001_dbg(pm8001_ha, DEVIO, "HW_EVENT_SATA_PHY_UP port id = %d, phy id = %d\n",
>                    port_id, phy_id);
> +       phy->port = port;
> +       port->port_id = port_id;
>         port->port_state =  portstate;
>         phy->phy_state = PHY_STATE_LINK_UP_SPC;
>         port->port_attached = 1;
> @@ -4460,6 +4464,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>         u16 ITNT = 2000;
>         struct domain_device *dev = pm8001_dev->sas_device;
>         struct domain_device *parent_dev = dev->parent;
> +       struct pm8001_port *port = dev->port->lldd_port;
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>
>         memset(&payload, 0, sizeof(payload));
> @@ -4488,7 +4493,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>         linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
>                         pm8001_dev->sas_device->linkrate : dev->port->linkrate;
>         payload.phyid_portid =
> -               cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0x0F) |
> +               cpu_to_le32(((port->port_id) & 0x0F) |
>                 ((phy_id & 0x0F) << 4));
>         payload.dtype_dlr_retry = cpu_to_le32((retryFlag & 0x01) |
>                 ((linkrate & 0x0F) * 0x1000000) |
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 47db7e0beae6..613455a3e686 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -128,6 +128,7 @@ static struct sas_domain_function_template pm8001_transport_ops = {
>         .lldd_I_T_nexus_reset   = pm8001_I_T_nexus_reset,
>         .lldd_lu_reset          = pm8001_lu_reset,
>         .lldd_query_task        = pm8001_query_task,
> +       .lldd_port_formed       = pm8001_port_formed,
>  };
>
>  /**
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 32e60f0c3b14..83e73009db5c 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1355,3 +1355,18 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
>         tmf_task.tmf = TMF_CLEAR_TASK_SET;
>         return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
>  }
> +
> +void pm8001_port_formed(struct asd_sas_phy *sas_phy)
> +{
> +       struct sas_ha_struct *sas_ha = sas_phy->ha;
> +       struct pm8001_hba_info *pm8001_ha = sas_ha->lldd_ha;
> +       struct pm8001_phy *phy = sas_phy->lldd_phy;
> +       struct asd_sas_port *sas_port = sas_phy->port;
> +       struct pm8001_port *port = phy->port;
> +
> +       if (!sas_port) {
> +               pm8001_dbg(pm8001_ha, FAIL, "Received null port\n");
> +               return;
> +       }
> +       sas_port->lldd_port = port;
> +}
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 62d08b535a4b..1a016a421280 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -230,6 +230,7 @@ struct pm8001_port {
>         u8                      port_attached;
>         u16                     wide_port_phymap;
>         u8                      port_state;
> +       u8                      port_id;
>         struct list_head        list;
>  };
>
> @@ -651,6 +652,7 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun);
>  int pm8001_I_T_nexus_reset(struct domain_device *dev);
>  int pm8001_I_T_nexus_event_handler(struct domain_device *dev);
>  int pm8001_query_task(struct sas_task *task);
> +void pm8001_port_formed(struct asd_sas_phy *sas_phy);
>  void pm8001_open_reject_retry(
>         struct pm8001_hba_info *pm8001_ha,
>         struct sas_task *task_to_close,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 6ffe17b849ae..cec932f830b8 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3299,6 +3299,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
>         unsigned long flags;
>         u8 deviceType = pPayload->sas_identify.dev_type;
> +       phy->port = port;
> +       port->port_id = port_id;
>         port->port_state = portstate;
>         port->wide_port_phymap |= (1U << phy_id);
>         phy->phy_state = PHY_STATE_LINK_UP_SPCV;
> @@ -3380,6 +3382,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                    "port id %d, phy id %d link_rate %d portstate 0x%x\n",
>                    port_id, phy_id, link_rate, portstate);
>
> +       phy->port = port;
> +       port->port_id = port_id;
>         port->port_state = portstate;
>         phy->phy_state = PHY_STATE_LINK_UP_SPCV;
>         port->port_attached = 1;
> @@ -4808,6 +4812,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>         u16 ITNT = 2000;
>         struct domain_device *dev = pm8001_dev->sas_device;
>         struct domain_device *parent_dev = dev->parent;
> +       struct pm8001_port *port = dev->port->lldd_port;
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>
>         memset(&payload, 0, sizeof(payload));
> @@ -4840,7 +4845,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>                         pm8001_dev->sas_device->linkrate : dev->port->linkrate;
>
>         payload.phyid_portid =
> -               cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0xFF) |
> +               cpu_to_le32(((port->port_id) & 0xFF) |
>                 ((phy_id & 0xFF) << 8));
>
>         payload.dtype_dlr_mcn_ir_retry = cpu_to_le32((retryFlag & 0x01) |
> --
> 2.27.0
>
