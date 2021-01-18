Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B44C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC2522252
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389351AbhARKsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388249AbhARKfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:35:33 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E921C0613C1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 02:26:50 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a10so6302959ejg.10
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 02:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULcxq0otArlyWPlj9ASZBX+QWN3PySkqrsI65p6o+dA=;
        b=FNeXmiWMMnEkMXWkBU9odr8LtMUXXIAz5TiG1IVDEGsMY8mcisV7QIzy57Yv32YM8Z
         cixq4IN16GpAhAYTMDhz1pUJeYE9gQimAV2hUcIeuoM0xuK6WS4erat/d8TXKSUBCXNq
         r8ifF8Vs33KNOMofOdgHwk5ahGBD/rMEJXe/Eftuut/6MSMJVNzdejeYXt+jAx4TeIsl
         8FuhXkRHTkn+TnjntIG8h7OgYJ/2nb1KYk2h+TjLABylzCycglSLg1CntlMDQkUBzQSm
         Re6KZixqnHxwqNORlb766BSEUCjBjATFY78K5FFn3g5IPl/mmMU+EgmofjyfB69YYu8s
         UGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULcxq0otArlyWPlj9ASZBX+QWN3PySkqrsI65p6o+dA=;
        b=pehlbWMkfJxYunfMA8Ps6VwHPRtMVQgqjXO1uNiCY3lqtwcs4X9NkzqF8bU2MNyp8G
         H/wPlUnfrgc4d+gQminOmJlJG0l9fr6GxHw1KiVF3gaUegxdWR/8RJ9G+OR8FMG/RiRZ
         DynN2xBgS+TJaLNTXerQ7dhQtBRYQicPs0RuZ0T3FRs9G1tJqUtCCUvgZzrfXev5Sacn
         SkNXIYrTCF5u2bZkaBjVpfbh42rra9U7nuSv7soRsqBZzi3C6oFjb6Qha0/Gj8x/RvnQ
         OG+ccaaSInmebtDT+nincfN+wrsffA5ODWEhjMk8mdxLD1ZhwCE3sAEaRTrPzk0GUzJR
         MQUg==
X-Gm-Message-State: AOAM5306BfkCY65xloSom+bfgNFImvsl5UYtQOZ9Xc/4FvYOC5CwxHDP
        GsnrUuta59iBVIU/34ulqDUeCB8+NDv/+Qnh8Zg3vA==
X-Google-Smtp-Source: ABdhPJzIM2nBjXlhkqoAO3vhp3uK80K4etcIafUi5yBsrDoAgUDKsYX9PFuzwlBtw+/X9AZRr1a0YEgqb04u+eWjnLk=
X-Received: by 2002:a17:906:4d8f:: with SMTP id s15mr13068479eju.389.1610965608734;
 Mon, 18 Jan 2021 02:26:48 -0800 (PST)
MIME-Version: 1.0
References: <20210118100955.1761652-1-a.darwish@linutronix.de> <20210118100955.1761652-10-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-10-a.darwish@linutronix.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Jan 2021 11:26:37 +0100
Message-ID: <CAMGffEnTdWj86O6qa9i3XyVLCuneEpuSRBbf_zkCNmZUOwOo3w@mail.gmail.com>
Subject: Re: [PATCH v3 09/19] scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 18, 2021 at 11:10 AM Ahmed S. Darwish
<a.darwish@linutronix.de> wrote:
>
> Use the new libsas event notifiers API, which requires callers to
> explicitly pass the gfp_t memory allocation flags.
>
> Call chain analysis, pm8001_hwi.c:
>
>   pm8001_interrupt_handler_msix() || pm8001_interrupt_handler_intx() || pm8001_tasklet()
>     -> PM8001_CHIP_DISP->isr() = pm80xx_chip_isr()
>       -> process_oq [spin_lock_irqsave(&pm8001_ha->lock, ...)]
>         -> process_one_iomb()
>           -> mpi_hw_event()
>             -> hw_event_sas_phy_up()
>               -> pm8001_bytes_dmaed()
>             -> hw_event_sata_phy_up
>               -> pm8001_bytes_dmaed()
>
> All functions are invoked by process_one_iomb(), which is invoked by the
> interrupt service routine and the tasklet handler. A similar call chain
> is also found at pm80xx_hwi.c. Pass GFP_ATOMIC.
>
> For pm8001_sas.c, pm8001_phy_control() runs in task context as it calls
> wait_for_completion() and msleep().  Pass GFP_KERNEL.
>
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 54 +++++++++++++++++++++-----------
>  drivers/scsi/pm8001/pm8001_sas.c |  8 ++---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 41 +++++++++++++++---------
>  3 files changed, 65 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index dd15246d5b03..c8bfa8e6f211 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3179,7 +3179,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
>         pm8001_dbg(pm8001_ha, MSG, "phy %d byte dmaded.\n", i);
>
>         sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
> -       sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
> +       sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
>  }
>
>  /* Get the link rate speed  */
> @@ -3336,7 +3336,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         else if (phy->identify.device_type != SAS_PHY_UNUSED)
>                 phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
>         phy->sas_phy.oob_mode = SAS_OOB_MODE;
> -       sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
>         spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
>         memcpy(phy->frame_rcvd, &pPayload->sas_identify,
>                 sizeof(struct sas_identify_frame)-4);
> @@ -3379,7 +3379,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         phy->phy_type |= PORT_TYPE_SATA;
>         phy->phy_attached = 1;
>         phy->sas_phy.oob_mode = SATA_OOB_MODE;
> -       sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
>         spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
>         memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
>                 sizeof(struct dev_to_host_fis));
> @@ -3726,11 +3726,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                 break;
>         case HW_EVENT_SATA_SPINUP_HOLD:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PHY_DOWN:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
> +                       GFP_ATOMIC);
>                 phy->phy_attached = 0;
>                 phy->phy_state = 0;
>                 hw_event_phy_down(pm8001_ha, piomb);
> @@ -3739,7 +3741,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         /* the broadcast change primitive received, tell the LIBSAS this event
>         to revalidate the sas domain*/
> @@ -3750,20 +3753,23 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PHY_ERROR:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
>                 sas_phy_disconnected(&phy->sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_BROADCAST_EXP:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_INVALID_DWORD:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3772,7 +3778,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                         HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3782,7 +3789,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_CODE_VIOLATION:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3792,7 +3800,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3802,7 +3811,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_MALFUNCTION:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
> @@ -3812,7 +3822,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_INBOUND_CRC_ERROR:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
> @@ -3822,13 +3833,15 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                 break;
>         case HW_EVENT_HARD_RESET_RECEIVED:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
> -               sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_ID_FRAME_TIMEOUT:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3838,20 +3851,23 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PORT_RESET_TIMER_TMO:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
>                 pm8001_dbg(pm8001_ha, MSG,
>                            "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PORT_RECOVER:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index e21c6cfff4cb..da444facd52e 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -207,16 +207,16 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
>                         if (pm8001_ha->phy[phy_id].phy_state ==
>                                 PHY_STATE_LINK_UP_SPCV) {
>                                 sas_phy_disconnected(&phy->sas_phy);
> -                               sas_notify_phy_event(&phy->sas_phy,
> -                                       PHYE_LOSS_OF_SIGNAL);
> +                               sas_notify_phy_event_gfp(&phy->sas_phy,
> +                                       PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
>                                 phy->phy_attached = 0;
>                         }
>                 } else {
>                         if (pm8001_ha->phy[phy_id].phy_state ==
>                                 PHY_STATE_LINK_UP_SPC) {
>                                 sas_phy_disconnected(&phy->sas_phy);
> -                               sas_notify_phy_event(&phy->sas_phy,
> -                                       PHYE_LOSS_OF_SIGNAL);
> +                               sas_notify_phy_event_gfp(&phy->sas_phy,
> +                                       PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
>                                 phy->phy_attached = 0;
>                         }
>                 }
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index f617177b7bb3..a43a4e5db043 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3287,7 +3287,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         else if (phy->identify.device_type != SAS_PHY_UNUSED)
>                 phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
>         phy->sas_phy.oob_mode = SAS_OOB_MODE;
> -       sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
>         spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
>         memcpy(phy->frame_rcvd, &pPayload->sas_identify,
>                 sizeof(struct sas_identify_frame)-4);
> @@ -3334,7 +3334,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         phy->phy_type |= PORT_TYPE_SATA;
>         phy->phy_attached = 1;
>         phy->sas_phy.oob_mode = SATA_OOB_MODE;
> -       sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> +       sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
>         spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
>         memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
>                 sizeof(struct dev_to_host_fis));
> @@ -3417,7 +3417,8 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>         }
>         if (port_sata && (portstate != PORT_IN_RESET))
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
> +                                       GFP_ATOMIC);
>  }
>
>  static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
> @@ -3515,7 +3516,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 break;
>         case HW_EVENT_SATA_SPINUP_HOLD:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PHY_DOWN:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
> @@ -3531,7 +3533,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         /* the broadcast change primitive received, tell the LIBSAS this event
>         to revalidate the sas domain*/
> @@ -3542,20 +3545,23 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PHY_ERROR:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
>                 sas_phy_disconnected(&phy->sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
> +               sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_BROADCAST_EXP:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_INVALID_DWORD:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3592,7 +3598,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
>                 sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
>                 spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
> -               sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_INBOUND_CRC_ERROR:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
> @@ -3602,13 +3609,15 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 break;
>         case HW_EVENT_HARD_RESET_RECEIVED:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
> -               sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_ID_FRAME_TIMEOUT:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
>                 pm8001_dbg(pm8001_ha, MSG,
> @@ -3618,7 +3627,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 break;
>         case HW_EVENT_PORT_RESET_TIMER_TMO:
>                 pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
> @@ -3626,7 +3636,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                         port_id, phy_id, 0, 0);
>                 sas_phy_disconnected(sas_phy);
>                 phy->phy_attached = 0;
> -               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
> +               sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
> +                       GFP_ATOMIC);
>                 if (pm8001_ha->phy[phy_id].reset_completion) {
>                         pm8001_ha->phy[phy_id].port_reset_status =
>                                         PORT_RESET_TMO;
> @@ -3643,8 +3654,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
>                         if (port->wide_port_phymap & (1 << i)) {
>                                 phy = &pm8001_ha->phy[i];
> -                               sas_notify_phy_event(&phy->sas_phy,
> -                                               PHYE_LOSS_OF_SIGNAL);
> +                               sas_notify_phy_event_gfp(&phy->sas_phy,
> +                                       PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
>                                 port->wide_port_phymap &= ~(1 << i);
>                         }
>                 }
> --
> 2.30.0
>
