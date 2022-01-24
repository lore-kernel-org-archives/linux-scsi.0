Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94231C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 03:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356388AbiAYDmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387605AbiAYAFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2022 19:05:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA47BC06175D
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2022 13:51:42 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id s5so25212491ejx.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2022 13:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPLZbYlFwwtKJwjjjmGHYauZ/GuF7QlAiQhS7WwkaNE=;
        b=Rc/SAPRpcr1gc0pGZO7Z1kjigiB6V5SXqwU7r6VIlbZkD5A3tqgjaKa71OOQyDrHtb
         5RRX48IpDupZmw5WPS1LoDGOKXLIo7F9FhlBc0rjfqSwticT/U/FKZxcnkS+WUP6uPQd
         XBpNU1xPSqHgVxABpZDoTtXXH94uzsEOLkHu20LO86+/dX6a05GDx+bPx1SOJbupHEIE
         LJzT4FPaBbXHs4al78YP+Lp7bh9U2hj0LRm9W4v3626mztWoRrgkXZMP76bH/Br1aMGp
         ON7y9U/UQcJtDkDbM7KvmCf3fTsLysE5j+yYn/HFAEi3wOA5gSktGE03HHdvwUFI5R9w
         d/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPLZbYlFwwtKJwjjjmGHYauZ/GuF7QlAiQhS7WwkaNE=;
        b=4HdXinnYVijj5yDN8uzoawc61JK4HBOgD76J5ccVCkMKwaHq4xuq1CFpQILWpBG3R0
         Kfa2ViG+jF30WmLDUUa1aklBr29y4vSdbeSbuPeKOE84UDlbISOe3Y3wc0/WMc/tzWtY
         tqLTP1bLjlDI9j1t+aMulaI3dQB1gXAGgrPm2uuYEwq7LX2BjtN63LbM1tEDzAyfxwqK
         COh5GwhYG7J7OxH7+B9ngcAJPUk7vau5wZ8B4pCaE8lFa/lJLCkZdT5yycDEhg4hxvYS
         kwzCdniIwXaZpJ6kspFhCJvXKpWKtJ6DJMBiolR/AbM92JoyzwPvhcK2YDmu0wcxOwxs
         K7Cg==
X-Gm-Message-State: AOAM532zyUu4ddiXQg2X+L9Q0LPhBkdAenOcP+6IcAD0m8z89gwQNLeR
        u6386YnrIuYdXPMg6BPJhDT0x/uJ+5foRNjuVvVaqA==
X-Google-Smtp-Source: ABdhPJzsNHUkrfbOFfrbtP22byKaQzjunpLq2VzICuIA88AAQjZOK01YPWEA4iPXV2Sr1S5q/t27QLJT9/Dej/Ol4B4=
X-Received: by 2002:a17:906:c110:: with SMTP id do16mr13824989ejc.441.1643061101156;
 Mon, 24 Jan 2022 13:51:41 -0800 (PST)
MIME-Version: 1.0
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
In-Reply-To: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 24 Jan 2022 22:51:30 +0100
Message-ID: <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 24, 2022 at 9:20 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> For SATA devices, correct the double
> completion issue.
>
> Current code handles completions for sata
> devices in  mpi_sata_completion() and
> mpi_sata_event().
>
> But at the time when any sata event happens,
> for almost all the event types, the command
> is still in the target. It is wrong to
> complete the task in sata_event().

Is it also an issue for SSP? what is the side effect, the current code
will lead to (w/o this patch)?
why SATA is different?

Thanks!
>
> There are some events for which we get
> sata_completions, for some needs recovery
> procedure and for others abort.
>
> All the tasks must be completed via
> sata_completion() path.
>
> Have just removed the task done related code
> from sata_events().
> For tasks where we don't get completions,
> let top layer call abort() to abort the
> command post timeout.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 18 ------------------
>  drivers/scsi/pm8001/pm80xx_hwi.c | 26 --------------------------
>  2 files changed, 44 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index c814e5071712..9ec310b795c3 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -2692,7 +2692,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         u32 tag = le32_to_cpu(psataPayload->tag);
>         u32 port_id = le32_to_cpu(psataPayload->port_id);
>         u32 dev_id = le32_to_cpu(psataPayload->device_id);
> -       unsigned long flags;
>
>         if (event)
>                 pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
> @@ -2724,8 +2723,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 ts->resp = SAS_TASK_COMPLETE;
>                 ts->stat = SAS_DATA_OVERRUN;
>                 ts->residual = 0;
> -               if (pm8001_dev)
> -                       atomic_dec(&pm8001_dev->running_req);
>                 break;
>         case IO_XFER_ERROR_BREAK:
>                 pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
> @@ -2767,7 +2764,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_COMPLETE;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
>                         return;
>                 }
>                 break;
> @@ -2853,20 +2849,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 ts->stat = SAS_OPEN_TO;
>                 break;
>         }
> -       spin_lock_irqsave(&t->task_state_lock, flags);
> -       t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
> -       t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
> -       t->task_state_flags |= SAS_TASK_STATE_DONE;
> -       if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_dbg(pm8001_ha, FAIL,
> -                          "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
> -                          t, event, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> -       } else {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> -       }
>  }
>
>  /*See the comments for mpi_ssp_completion */
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 0849ecc913c7..1e573be04407 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2821,7 +2821,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
>         u32 tag = le32_to_cpu(psataPayload->tag);
>         u32 port_id = le32_to_cpu(psataPayload->port_id);
>         u32 dev_id = le32_to_cpu(psataPayload->device_id);
> -       unsigned long flags;
>
>         if (event)
>                 pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
> @@ -2854,8 +2853,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
>                 ts->resp = SAS_TASK_COMPLETE;
>                 ts->stat = SAS_DATA_OVERRUN;
>                 ts->residual = 0;
> -               if (pm8001_dev)
> -                       atomic_dec(&pm8001_dev->running_req);
>                 break;
>         case IO_XFER_ERROR_BREAK:
>                 pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
> @@ -2904,11 +2901,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_COMPLETE;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       spin_unlock_irqrestore(&circularQ->oq_lock,
> -                                       circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> -                       spin_lock_irqsave(&circularQ->oq_lock,
> -                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -3008,24 +3000,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
>                 ts->stat = SAS_OPEN_TO;
>                 break;
>         }
> -       spin_lock_irqsave(&t->task_state_lock, flags);
> -       t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
> -       t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
> -       t->task_state_flags |= SAS_TASK_STATE_DONE;
> -       if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_dbg(pm8001_ha, FAIL,
> -                          "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
> -                          t, event, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> -       } else {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               spin_unlock_irqrestore(&circularQ->oq_lock,
> -                               circularQ->lock_flags);
> -               pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> -               spin_lock_irqsave(&circularQ->oq_lock,
> -                               circularQ->lock_flags);
> -       }
>  }
>
>  /*See the comments for mpi_ssp_completion */
> --
> 2.27.0
>
