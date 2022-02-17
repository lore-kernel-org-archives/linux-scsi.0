Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2B4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242786AbiBQTtG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245539AbiBQTtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:49:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEC53587C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:48:48 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q17so11618470edd.4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oITgpYqtCHmsspN9hXzDAGJxIc/MVA8U/ghK2WfILEQ=;
        b=MCvxUVWjuHcZnT3RcCZefNGtaQJTgs9vX7Y07Eh7PBwECIE0+BRtMDZnJWiBCg65y2
         gBLTg1Dkc5NRpznvQT3/1fQjXfRPpwqDc/aklFJza57RjU3ny00/Y0mjIT2n+JbkzuKW
         xsD9F9HlgIrliwcmL65aniHXnfkbkffB9v8FSsLSbVkHsdUhiB99UKQ1vr0tgE87Dvnx
         cBXXlY7ajKXnLpEGsg307xnZ4Rp0f0h8Hn8G6Oah4PEh793WOxqWwfkHdqTZ+xSldCNv
         c72z9GSyAf5RfdyDMXvJ0G/P3z25szC609mmNwFGSg8cNovOhiLvJuNtcbhJXTDQshvY
         5jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oITgpYqtCHmsspN9hXzDAGJxIc/MVA8U/ghK2WfILEQ=;
        b=PY7A6k5lBSNRlQdtiTMc7UuIQk+z+ZGB3kYLNnu1uiEo55BLGTB1aSQQUKAM/NOcAN
         Wr4YU6PQkdKlohVRajfu9+OOeFPml0zIk55H8sNzgpXhSlQMkz708GgXcF12qjPLJVWB
         89Jbto+pWYuMt/+9/PPRj7XQk2I2aOwtldmR/BPZ5IQfUJA8+e6N9b30DtHbt/XyNEEl
         4RIbQz+DGxhLIQ3QQwllZu+AdU305tnUtfGdBE2eOEBQioxdp6msR03rP8wPrWpogKX8
         6BOSZVclYgbADodj5XIPUs8xTz7MTcYsbuoQsmZ+zdtHGPF00AI+lJlnF0Q08SRkHCsS
         yJOw==
X-Gm-Message-State: AOAM531xD35tSrRGHx6A5eAxpKZ5GnGF27rIygjHpP5h6pBH+H3dTzaE
        PFPx9B0O69MK8KrefjztEkGWBsSf1+uotL0jo0+bFg==
X-Google-Smtp-Source: ABdhPJybpYKjEnDiiMakh3N1HPdQFo2fFSRDuJK5Sq2ts+uqpSHsmIaakXw8yu0xYm6vhTjwANg0wQbFvua1RSmcwww=
X-Received: by 2002:a05:6402:2707:b0:410:d100:6937 with SMTP id
 y7-20020a056402270700b00410d1006937mr4418942edd.428.1645127326376; Thu, 17
 Feb 2022 11:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-30-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-30-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:48:35 +0100
Message-ID: <CAMGffE=dndywVMfDheCqNhyQnxpJ5OHXQH266vjtgxOV5Of1HA@mail.gmail.com>
Subject: Re: [PATCH v4 29/31] scsi: pm8001: Simplify pm8001_ccb_task_free()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> The task argument of the pm8001_ccb_task_free() function can be infered
> from the ccb argument ccb_task field. So there is no need to have this
> argument. Likewise, the ccb_index argument is always equal to the ccb
> tag field and is not needed either. Remove both arguments and update all
> call sites. The pm8001_ccb_task_free_done() helper is also modified to
> match this change.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 42 +++++++++++++++-----------------
>  drivers/scsi/pm8001/pm8001_sas.c | 25 +++++++++----------
>  drivers/scsi/pm8001/pm8001_sas.h | 12 ++++-----
>  drivers/scsi/pm8001/pm80xx_hwi.c | 35 ++++++++++++--------------
>  4 files changed, 52 insertions(+), 62 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 03bcf7497bf9..c2dbadb5d91e 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1564,11 +1564,11 @@ void pm8001_work_fn(struct work_struct *work)
>                         spin_unlock_irqrestore(&t->task_state_lock, flags1);
>                         pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                                    t, pw->handler, ts->resp, ts->stat);
> -                       pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
> +                       pm8001_ccb_task_free(pm8001_ha, ccb);
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                 } else {
>                         spin_unlock_irqrestore(&t->task_state_lock, flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
> +                       pm8001_ccb_task_free(pm8001_ha, ccb);
>                         mb();/* in order to force CPU ordering */
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                         t->task_done(t);
> @@ -1697,8 +1697,7 @@ void pm8001_work_fn(struct work_struct *work)
>                                         continue;
>                                 }
>                                 /*complete sas task and update to top layer */
> -                               pm8001_ccb_task_free(pm8001_ha, task, ccb,
> -                                                    ccb->ccb_tag);
> +                               pm8001_ccb_task_free(pm8001_ha, ccb);
>                                 ts->resp = SAS_TASK_COMPLETE;
>                                 task->task_done(task);
>                         } else if (ccb->ccb_tag != PM8001_INVALID_TAG) {
> @@ -2084,10 +2083,10 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>                 mb();/* in order to force CPU ordering */
>                 t->task_done(t);
>         }
> @@ -2251,10 +2250,10 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, event, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>                 mb();/* in order to force CPU ordering */
>                 t->task_done(t);
>         }
> @@ -2480,7 +2479,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         return;
>                 }
>                 break;
> @@ -2496,7 +2495,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         return;
>                 }
>                 break;
> @@ -2518,7 +2517,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         return;
>                 }
>                 break;
> @@ -2589,7 +2588,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                     IO_DS_NON_OPERATIONAL);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         return;
>                 }
>                 break;
> @@ -2609,7 +2608,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                     IO_DS_IN_ERROR);
>                         ts->resp = SAS_TASK_UNDELIVERED;
>                         ts->stat = SAS_QUEUE_FULL;
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         return;
>                 }
>                 break;
> @@ -2639,10 +2638,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>         }
>  }
>
> @@ -2994,12 +2993,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> -               mb();/* in order to force CPU ordering */
> -               t->task_done(t);
> +               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>         }
>  }
>
> @@ -3649,7 +3646,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>         t->task_state_flags |= SAS_TASK_STATE_DONE;
>         spin_unlock_irqrestore(&t->task_state_lock, flags);
> -       pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +       pm8001_ccb_task_free(pm8001_ha, ccb);
>         mb();
>
>         if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
> @@ -4287,12 +4284,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                                            "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
>                                            task, ts->resp,
>                                            ts->stat);
> -                               pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                               pm8001_ccb_task_free(pm8001_ha, ccb);
>                         } else {
>                                 spin_unlock_irqrestore(&task->task_state_lock,
>                                                         flags);
> -                               pm8001_ccb_task_free_done(pm8001_ha, task,
> -                                                               ccb, tag);
> +                               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                                 return 0;
>                         }
>                 }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 37aba0335f18..da8f39631fb5 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -499,22 +499,21 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
>  /**
>    * pm8001_ccb_task_free - free the sg for ssp and smp command, free the ccb.
>    * @pm8001_ha: our hba card information
> -  * @ccb: the ccb which attached to ssp task
> -  * @task: the task to be free.
> -  * @ccb_idx: ccb index.
> +  * @ccb: the ccb which attached to ssp task to free
>    */
>  void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
> -       struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)
> +                         struct pm8001_ccb_info *ccb)
>  {
> +       struct sas_task *task = ccb->task;
>         struct ata_queued_cmd *qc;
>         struct pm8001_device *pm8001_dev;
>
> -       if (!ccb->task)
> +       if (!task)
>                 return;
> -       if (!sas_protocol_ata(task->task_proto))
> -               if (ccb->n_elem)
> -                       dma_unmap_sg(pm8001_ha->dev, task->scatter,
> -                               task->num_scatter, task->data_dir);
> +
> +       if (!sas_protocol_ata(task->task_proto) && ccb->n_elem)
> +               dma_unmap_sg(pm8001_ha->dev, task->scatter,
> +                            task->num_scatter, task->data_dir);
>
>         switch (task->task_proto) {
>         case SAS_PROTOCOL_SMP:
> @@ -533,12 +532,12 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>         }
>
>         if (sas_protocol_ata(task->task_proto)) {
> -               // For SCSI/ATA commands uldd_task points to ata_queued_cmd
> +               /* For SCSI/ATA commands uldd_task points to ata_queued_cmd */
>                 qc = task->uldd_task;
>                 pm8001_dev = ccb->device;
>                 trace_pm80xx_request_complete(pm8001_ha->id,
>                         pm8001_dev ? pm8001_dev->attached_phy : PM8001_MAX_PHYS,
> -                       ccb_idx, 0 /* ctlr_opcode not known */,
> +                       ccb->ccb_tag, 0 /* ctlr_opcode not known */,
>                         qc ? qc->tf.command : 0, // ata opcode
>                         pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
>         }
> @@ -960,11 +959,11 @@ void pm8001_open_reject_retry(
>                                 & SAS_TASK_STATE_ABORTED))) {
>                         spin_unlock_irqrestore(&task->task_state_lock,
>                                 flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
> +                       pm8001_ccb_task_free(pm8001_ha, ccb);
>                 } else {
>                         spin_unlock_irqrestore(&task->task_state_lock,
>                                 flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
> +                       pm8001_ccb_task_free(pm8001_ha, ccb);
>                         mb();/* in order to force CPU ordering */
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                         task->task_done(task);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index aec4572906cf..2aab357d9a23 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -641,7 +641,7 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
>  void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
>  u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
>  void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
> -       struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
> +                         struct pm8001_ccb_info *ccb);
>  int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
>         void *funcdata);
>  void pm8001_scan_start(struct Scsi_Host *shost);
> @@ -786,12 +786,12 @@ static inline void pm8001_ccb_free(struct pm8001_hba_info *pm8001_ha,
>         pm8001_tag_free(pm8001_ha, tag);
>  }
>
> -static inline void
> -pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
> -                       struct sas_task *task, struct pm8001_ccb_info *ccb,
> -                       u32 ccb_idx)
> +static inline void pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
> +                                            struct pm8001_ccb_info *ccb)
>  {
> -       pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
> +       struct sas_task *task = ccb->task;
> +
> +       pm8001_ccb_task_free(pm8001_ha, ccb);
>         smp_mb(); /*in order to force CPU ordering*/
>         task->task_done(task);
>  }
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index ce19aa361d26..b5e1aaa0fd58 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2157,14 +2157,12 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>                 if (t->slow_task)
>                         complete(&t->slow_task->completion);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> -               mb();/* in order to force CPU ordering */
> -               t->task_done(t);
> +               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>         }
>  }
>
> @@ -2340,12 +2338,10 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, event, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> -               mb();/* in order to force CPU ordering */
> -               t->task_done(t);
> +               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>         }
>  }
>
> @@ -2579,7 +2575,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_QUEUE_FULL;
>                         spin_unlock_irqrestore(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         spin_lock_irqsave(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
>                         return;
> @@ -2599,7 +2595,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_QUEUE_FULL;
>                         spin_unlock_irqrestore(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         spin_lock_irqsave(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
>                         return;
> @@ -2627,7 +2623,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_QUEUE_FULL;
>                         spin_unlock_irqrestore(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         spin_lock_irqsave(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
>                         return;
> @@ -2702,7 +2698,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_QUEUE_FULL;
>                         spin_unlock_irqrestore(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         spin_lock_irqsave(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
>                         return;
> @@ -2726,7 +2722,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                         ts->stat = SAS_QUEUE_FULL;
>                         spin_unlock_irqrestore(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
> -                       pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                         spin_lock_irqsave(&circularQ->oq_lock,
>                                         circularQ->lock_flags);
>                         return;
> @@ -2760,14 +2756,14 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>                 if (t->slow_task)
>                         complete(&t->slow_task->completion);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
>                 spin_unlock_irqrestore(&circularQ->oq_lock,
>                                 circularQ->lock_flags);
> -               pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                 spin_lock_irqsave(&circularQ->oq_lock,
>                                 circularQ->lock_flags);
>         }
> @@ -3171,10 +3167,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_dbg(pm8001_ha, FAIL,
>                            "task 0x%p done with io_status 0x%x resp 0x%xstat 0x%x but aborted by upper layer!\n",
>                            t, status, ts->resp, ts->stat);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>         } else {
>                 spin_unlock_irqrestore(&t->task_state_lock, flags);
> -               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +               pm8001_ccb_task_free(pm8001_ha, ccb);
>                 mb();/* in order to force CPU ordering */
>                 t->task_done(t);
>         }
> @@ -4702,13 +4698,12 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>                                            "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
>                                            task, ts->resp,
>                                            ts->stat);
> -                               pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                               pm8001_ccb_task_free(pm8001_ha, ccb);
>                                 return 0;
>                         } else {
>                                 spin_unlock_irqrestore(&task->task_state_lock,
>                                                         flags);
> -                               pm8001_ccb_task_free_done(pm8001_ha, task,
> -                                                               ccb, tag);
> +                               pm8001_ccb_task_free_done(pm8001_ha, ccb);
>                                 atomic_dec(&pm8001_ha_dev->running_req);
>                                 return 0;
>                         }
> --
> 2.34.1
>
