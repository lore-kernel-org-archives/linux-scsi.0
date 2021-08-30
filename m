Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4890DC432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 225F861008
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 08:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhH3IXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 04:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhH3IXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 04:23:11 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F61C061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:22:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i21so29446313ejd.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 01:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YN1Mai9hnBEoeubXxJkBxUZ1Voq+vAGmqANu9esva+4=;
        b=bppMyj9FngmIZNEgtQ19aRNNw0lKeFEFMvXZf488bxDUO+7mlzzYIEIcW/6dWSQB8x
         k3n7KUm/vbXCJB2/UHVIDhk/waO4tzVtPZ5fd8XwT8bFMXYXjrhx9f3+FIXRTpo1a9G3
         qjqGNl6NVsFxtVTBF2Nn5uQBamdt+OzgvehketaTH54BQIDtK8FrHV2aR7Zc0diQara0
         HUrMggFDKguTvdIRqOBzY1IeVzupz/KwhvdCEpHS4KoybLL4qBwzsbtXvZqiMQQf/8ln
         bw17i0sKP9UgyZUXhCN4GI12MiXcMl2vL11nOKNlWAMQdWtR5e/psiMzyfKBeSw53s+8
         Nw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YN1Mai9hnBEoeubXxJkBxUZ1Voq+vAGmqANu9esva+4=;
        b=R57QIWs9Loaq9Knegc2RPLMbRMTwCkVhFXpgPda8vPVszd5ZhB+jPqYYU+71NKooiy
         YOZ3td6mY92nYMia6oY9V4H109/aoYhRTM56QzmKCtFbk1P8BWfPF+zFQGdCIzMaj0Be
         3SCW29oSdvlSjHiwUF5g1fdkCy1oFBWntFc7RWoLAlVWga/6IqwIjp7dE9UchGWfGGDI
         woUEkHCM0dpYBWOzeS41c7VL6DJ3d+AWZ5eNhM+0mRy9y/TG7r51lPWLmYtEzz1Uh7EX
         OuMWUeuR78MxMVcfo55PkbgOBPjxkFkkfwr5u2QSlaM6TXfgkeQh4ULOM3FV7wjp/bDn
         rYTw==
X-Gm-Message-State: AOAM532vXlc/HzgXJ7W7jbcenqW7tDfRqBSgp1RRfeB5NdNhipmB3wDb
        T5Lcc1OJ862akhicJKvHvWa7qCVvmybAptFQZqYyAQ==
X-Google-Smtp-Source: ABdhPJwG5t+TWOyXVEvsyfqCI1yqwJa6XDLUvR5xyNUjU0sqVOD21apUAqFmtNQ4SuUxZOn7BKTVCyT8IJBtymarrk4=
X-Received: by 2002:a17:907:6297:: with SMTP id nd23mr22933758ejc.62.1630311736679;
 Mon, 30 Aug 2021 01:22:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com> <20210823082338.67309-3-Ajish.Koshy@microchip.com>
In-Reply-To: <20210823082338.67309-3-Ajish.Koshy@microchip.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 30 Aug 2021 10:22:06 +0200
Message-ID: <CAMGffE=NFchDVbnC1X0yaGW7dXmeYvVz+fgo7bZfzX12DzooJA@mail.gmail.com>
Subject: Re: [PATCH 2/4] scsi: pm80xx: fix lockup due to commit <1f02beff224e>
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

On Mon, Aug 23, 2021 at 9:28 AM Ajish Koshy <Ajish.Koshy@microchip.com> wrote:
>
> Upstream commit <1f02beff224e> introduced a lock per outbound
> queue, where the driver before that was using a global lock
> for all outbound queues. While processing the IO responses
> and events, driver takes the outbound queue spinlock and
> later it is supposed to release the same spin lock in
> pm8001_ccb_task_free_done() before calling command done().
> Since the older code was using a global lock,
> pm8001_ccb_task_free_done() was also releasing the global
> spin lock. With the commit <1f02beff224e>,
> pm8001_ccb_task_free_done() remains the same and it was
> still using the global lock.
>
> So when driver completes a SATA command,the global spinlock
> will be in a locked state.
> mpi_sata_completion()->spin_lock(&pm8001_ha->lock);
>
> Later when driver gets a scsi command for SATA drive,
> pm8001_task_exec() tries to acquire the global lock and leads
> to lockup crash.
>
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
The code looks correct, just please refer the commit with standard way eg:
1f02beff224e ("scsi: pm80xx: Remove global lock from outbound queue processing")

Please also add the fixes tag as above, so the stable tree can pick it up.
Thanks!

> ---
>  drivers/scsi/pm8001/pm8001_sas.h |  3 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 53 ++++++++++++++++++++++++++------
>  2 files changed, 45 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 1a016a421280..3274d88a9ccc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -458,6 +458,7 @@ struct outbound_queue_table {
>         __le32                  producer_index;
>         u32                     consumer_idx;
>         spinlock_t              oq_lock;
> +       unsigned long           lock_flags;
>  };
>  struct pm8001_hba_memspace {
>         void __iomem            *memvirtaddr;
> @@ -740,9 +741,7 @@ pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
>  {
>         pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
>         smp_mb(); /*in order to force CPU ordering*/
> -       spin_unlock(&pm8001_ha->lock);
>         task->task_done(task);
> -       spin_lock(&pm8001_ha->lock);
>  }
>
>  #endif
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index cec932f830b8..1ae2f5c6042c 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2379,7 +2379,8 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>  /*See the comments for mpi_ssp_completion */
>  static void
> -mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
> +mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
> +               struct outbound_queue_table *circularQ, void *piomb)
>  {
>         struct sas_task *t;
>         struct pm8001_ccb_info *ccb;
> @@ -2616,7 +2617,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -2632,7 +2637,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -2656,7 +2665,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -2727,7 +2740,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                         IO_DS_NON_OPERATIONAL);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -2747,7 +2764,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                         IO_DS_IN_ERROR);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -2785,12 +2806,17 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> +               spin_unlock_irqrestore(&circularQ->oq_lock,
> +                               circularQ->lock_flags);
>                 pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +               spin_lock_irqsave(&circularQ->oq_lock,
> +                               circularQ->lock_flags);
>         }
>  }
>
>  /*See the comments for mpi_ssp_completion */
> -static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
> +static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
> +               struct outbound_queue_table *circularQ, void *piomb)
>  {
>         struct sas_task *t;
>         struct task_status_struct *ts;
> @@ -2890,7 +2916,11 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_COMPLETE;
>                         ts->stat = SAS_QUEUE_FULL;
> +                       spin_unlock_irqrestore(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       spin_lock_irqsave(&circularQ->oq_lock,
> +                                       circularQ->lock_flags);
>                         return;
>                 }
>                 break;
> @@ -3002,7 +3032,11 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> +               spin_unlock_irqrestore(&circularQ->oq_lock,
> +                               circularQ->lock_flags);
>                 pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +               spin_lock_irqsave(&circularQ->oq_lock,
> +                               circularQ->lock_flags);
>         }
>  }
>
> @@ -3906,7 +3940,8 @@ static int ssp_coalesced_comp_resp(struct pm8001_hba_info *pm8001_ha,
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> -static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
> +static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
> +               struct outbound_queue_table *circularQ, void *piomb)
>  {
>         __le32 pHeader = *(__le32 *)piomb;
>         u32 opc = (u32)((le32_to_cpu(pHeader)) & 0xFFF);
> @@ -3948,11 +3983,11 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 break;
>         case OPC_OUB_SATA_COMP:
>                 pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_COMP\n");
> -               mpi_sata_completion(pm8001_ha, piomb);
> +               mpi_sata_completion(pm8001_ha, circularQ, piomb);
>                 break;
>         case OPC_OUB_SATA_EVENT:
>                 pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SATA_EVENT\n");
> -               mpi_sata_event(pm8001_ha, piomb);
> +               mpi_sata_event(pm8001_ha, circularQ, piomb);
>                 break;
>         case OPC_OUB_SSP_EVENT:
>                 pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SSP_EVENT\n");
> @@ -4121,7 +4156,6 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>         void *pMsg1 = NULL;
>         u8 bc;
>         u32 ret = MPI_IO_STATUS_FAIL;
> -       unsigned long flags;
>         u32 regval;
>
>         if (vec == (pm8001_ha->max_q_num - 1)) {
> @@ -4138,7 +4172,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                 }
>         }
>         circularQ = &pm8001_ha->outbnd_q_tbl[vec];
> -       spin_lock_irqsave(&circularQ->oq_lock, flags);
> +       spin_lock_irqsave(&circularQ->oq_lock, circularQ->lock_flags);
>         do {
>                 /* spurious interrupt during setup if kexec-ing and
>                  * driver doing a doorbell access w/ the pre-kexec oq
> @@ -4149,7 +4183,8 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                 ret = pm8001_mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
>                 if (MPI_IO_STATUS_SUCCESS == ret) {
>                         /* process the outbound message */
> -                       process_one_iomb(pm8001_ha, (void *)(pMsg1 - 4));
> +                       process_one_iomb(pm8001_ha, circularQ,
> +                                               (void *)(pMsg1 - 4));
>                         /* free the message from the outbound circular buffer */
>                         pm8001_mpi_msg_free_set(pm8001_ha, pMsg1,
>                                                         circularQ, bc);
> @@ -4164,7 +4199,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>                                 break;
>                 }
>         } while (1);
> -       spin_unlock_irqrestore(&circularQ->oq_lock, flags);
> +       spin_unlock_irqrestore(&circularQ->oq_lock, circularQ->lock_flags);
>         return ret;
>  }
>
> --
> 2.27.0
>
