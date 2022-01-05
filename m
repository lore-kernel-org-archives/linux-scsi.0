Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEA3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 06:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiAEGUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 01:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiAEGUG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 01:20:06 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5BC061761
        for <linux-scsi@vger.kernel.org>; Tue,  4 Jan 2022 22:20:06 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id o6so157747045edc.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Jan 2022 22:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dbwTz/U9/kWTiksfN1CoupuNfs/1Lt4uudOM9uQsZCE=;
        b=dG/26lZ8NH9gLB3fm3/m7tfsEjTP2NVwcM/Fr2kPqEvf6Sd+jipdXgYIFknK+SAcIA
         XPfMvEvB7DyVmDXjZuAx4zCz16gyJTYqfeTbUJkRjA0iXlpxrmu2pt5wxLqAReW9na8d
         5s5mcQgWuItLFpZu9ziRdCcdyZo5+Xa72rSYqrRPKfaTd3hy3Bd9KAQEUIhGGAhLbJxm
         dluZsq8ND9ZKT6LwQZE4eBmo0D4J6ZJ70dMxP4tLnFQCGmrGLPDgqsRNN77Zn6+luyQf
         xxGcSk5wxx+iWR4TYTXHp4kTPwUChgm6w3WNT/bqqp0c1PHg6MBflBR0vf/1VZF0kMi2
         AB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dbwTz/U9/kWTiksfN1CoupuNfs/1Lt4uudOM9uQsZCE=;
        b=PLDaSHkpE/pBOEvo8qlPTrT92lUhg4aJUglMUslMU2/6AfYIZWZ2Xo9Wpm4kRxKVeo
         EBqm5JBn32crxk4/i74lznaAtyW+7BUVJXrn4oBNgdgvJMWzh3rXlakojko+DE8NJ4A1
         mLrhjWfXsLiQ59welK3ffKiibO6AISokkTI4RLGidGtP36hgbVh2cPncUHZBl9ZEJCa2
         2Wb1aVE8+P23rsRLPf37WM+IPT/RedT+9Xw3VVY/oV8jUU3gJBuyRU6QSrW3pl2tGy21
         EA4pA2vaR6XM0QUfVJGI6X2gtYgC2sTqaNHGR/JD6P798tsh+t0tiKr/DOgrN6iOVj69
         SZ7Q==
X-Gm-Message-State: AOAM533/8qAA2SypO+d7RX0i1MfNrIUJ+fVSfFwXxBYGavzNxWc17V3w
        i/PU2NGZYmNExGYZth41IOz0l1S8Ufi/UEK1cMyjQw==
X-Google-Smtp-Source: ABdhPJwSY87aq5HBOiAkdF22qh60t9SJtmxrO3wrMubRMxSHqo5xsmEeLRJkmvwKaApzT+QG1wRn4ISj29lJ6YwRDzs=
X-Received: by 2002:a05:6402:50c8:: with SMTP id h8mr49873878edb.210.1641363604703;
 Tue, 04 Jan 2022 22:20:04 -0800 (PST)
MIME-Version: 1.0
References: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
In-Reply-To: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 5 Jan 2022 07:19:53 +0100
Message-ID: <CAMGffEnufGurL0FYetFKGe+ZpuEuwf69z1Hccn9Ppb+tQyT7Zg@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: port reset timeout error handling correction.
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ajish,


On Tue, Dec 28, 2021 at 12:15 PM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> Error handling steps were not in sequence as per the programmers
> manual. Expected sequence:
>  -PHY_DOWN (PORT_IN_RESET)
>  -PORT_RESET_TIMER_TMO
>  -Host aborts pending I/Os
>  -Host deregister the device
>  -Host sends HW_EVENT_PHY_DOWN ack

Just to make sure, does the same sequence work for old pm8001 chip?
>
> Earlier, we were sending HW_EVENT_PHY_DOWN ack first and then
> deregister the device.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 7 ++++++-
>  drivers/scsi/pm8001/pm8001_sas.h | 3 +++
>  drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++--
>  3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index c9a16eef38c1..160ee8b228c9 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1199,7 +1199,7 @@ int pm8001_abort_task(struct sas_task *task)
>         struct pm8001_device *pm8001_dev;
>         struct pm8001_tmf_task tmf_task;
>         int rc = TMF_RESP_FUNC_FAILED, ret;
> -       u32 phy_id;
> +       u32 phy_id, port_id;
>         struct sas_task_slow slow_task;
>
>         if (unlikely(!task || !task->lldd_task || !task->dev))
> @@ -1246,6 +1246,7 @@ int pm8001_abort_task(struct sas_task *task)
>                         DECLARE_COMPLETION_ONSTACK(completion_reset);
>                         DECLARE_COMPLETION_ONSTACK(completion);
>                         struct pm8001_phy *phy = pm8001_ha->phy + phy_id;
> +                       port_id = phy->port->port_id;
>
>                         /* 1. Set Device state as Recovery */
>                         pm8001_dev->setds_completion = &completion;
> @@ -1297,6 +1298,10 @@ int pm8001_abort_task(struct sas_task *task)
>                                                 PORT_RESET_TMO);
>                                 if (phy->port_reset_status == PORT_RESET_TMO) {
>                                         pm8001_dev_gone_notify(dev);
> +                                       PM8001_CHIP_DISP->hw_event_ack_req(
> +                                               pm8001_ha, 0,
> +                                               0x07, /*HW_EVENT_PHY_DOWN ack*/
> +                                               port_id, phy_id, 0, 0);
>                                         goto out;
>                                 }
>                         }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 83eec16d021d..a17da1cebce1 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -216,6 +216,9 @@ struct pm8001_dispatch {
>                 u32 state);
>         int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
>         int (*fatal_errors)(struct pm8001_hba_info *pm8001_ha);
> +       void (*hw_event_ack_req)(struct pm8001_hba_info *pm8001_ha,
> +               u32 Qnum, u32 SEA, u32 port_id, u32 phyId, u32 param0,
> +               u32 param1);
>  };
>
>  struct pm8001_chip_info {
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 0849ecc913c7..97750d0ebee9 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3709,8 +3709,10 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 break;
>         case HW_EVENT_PORT_RESET_TIMER_TMO:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
> -               pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
> -                       port_id, phy_id, 0, 0);
> +               if (!pm8001_ha->phy[phy_id].reset_completion) {
> +                       pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
> +                               port_id, phy_id, 0, 0);
> +               }
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
>                 sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
> @@ -5051,4 +5053,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
>         .fw_flash_update_req    = pm8001_chip_fw_flash_update_req,
>         .set_dev_state_req      = pm8001_chip_set_dev_state_req,
>         .fatal_errors           = pm80xx_fatal_errors,
> +       .hw_event_ack_req       = pm80xx_hw_event_ack_req,
>  };
> --
> 2.27.0
>
