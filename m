Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8093FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiBQTkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:40:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245337AbiBQTkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:40:04 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF49D4199B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:39:48 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m3so5558325eda.10
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pyfSBhsUmVE7HwOu0BJJ4OL9R8MZ5qAhFkKFgBMGBbM=;
        b=TM2nrWluuHOuKb2qANQLgL3ztPSgUEXjvOkyylrcOVaX6FguxnYSpaq3NXRO0uWQed
         W4H9QUUYfprN29MT6ZU6/gU+RDiWGKpKGp0iTM6s878VfmAqFKb6F5k5TTI8acLaI+/K
         mYz6KQZ/Ke+yDSTVrA0klCPB3cx1SQDu6puAqXxHEqPr8IA88mITDl7loQVa1Z70Skv0
         n2vAlam/920zLETx/tHfLCYy9weulu4oA1TxlMEBKFYGUojsZjjH0izkbdNALu9UgUcM
         lkAAPfrLI/ZKW2wsCzhVP9sTNumSbz7HoK6X8BWEAR+fVIMZ7igHeM5vdkcByceWp/NT
         RE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pyfSBhsUmVE7HwOu0BJJ4OL9R8MZ5qAhFkKFgBMGBbM=;
        b=m3+PiiJdWjjC4k2ehDzCrUgAi9lY5KsZO6NL2RrghX6cyIKk+qH9skpAylSboSLQDp
         kZEWfiCdhqRkmuUcyssLiKNu6w+RE3/xu/a9LsD8OHKEKJhqbjgkePwTx3NRBEXcqxEv
         yLA9GKjtRVDX+2QX+0NVL2FDUJWzmI8Pl+2/cKF+EOG4BBDAL4XsDqq2UrV2uBEuvI1u
         ziL0XhLtl2+OOnhdMT+AtUSR5m0+dEmquUTPAgP8oOQgXNXNcE3vsdIA7ffQPP6qTzUt
         NDd2bPmRn5kdCX0TfOVYfSc8xeKLhRi0jmm2hYHtds0GtUttCgpCUIU8yNi41nR0E8Np
         GInQ==
X-Gm-Message-State: AOAM533FFvPYPD9ytXlm4O3vVDg3a7mwmCbInIPsZ+FpXAiUakHi6VQ/
        2ncG3qhPGW2+UO0ChWWqJ6Lxv40PsE/yCS7N6PSW/F/sxzY3mg==
X-Google-Smtp-Source: ABdhPJwEg8tdZxqTZkMgafJu3yP1HNJrzB0Mn0izgtjTrum/NCRAS+hbyhqBgekzU3icAcFhUTGrJDHWuVuvaIcH/bI=
X-Received: by 2002:a05:6402:2707:b0:410:d100:6937 with SMTP id
 y7-20020a056402270700b00410d1006937mr4383332edd.428.1645126787440; Thu, 17
 Feb 2022 11:39:47 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-21-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-21-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:39:36 +0100
Message-ID: <CAMGffEkfQ3MVOK1RL75jS0p5XXwvbxyio9qzVMLCoCo2=uYqPA@mail.gmail.com>
Subject: Re: [PATCH v4 20/31] scsi: pm8001: Fix tag values handling
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
> The function pm8001_tag_alloc() determines free tags using the function
> find_first_zero_bit() which can return 0 when the first bit of the
> bitmap being inspected is 0. As such, tag 0 is a valid tag value that
> should not be dismissed as invalid. Fix the functions pm8001_work_fn(),
> mpi_sata_completion(), pm8001_mpi_task_abort_resp() and
> pm8001_open_reject_retry() to not dismiss 0 tags as invalid.
>
> The value 0xffffffff is used for invalid tags for unused ccb
> information structures. Add the macro definition PM8001_INVALID_TAG to
> define this value.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c  | 52 +++++++++++--------------------
>  drivers/scsi/pm8001/pm8001_init.c |  3 +-
>  drivers/scsi/pm8001/pm8001_sas.c  | 13 ++++----
>  drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  |  5 ---
>  5 files changed, 28 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 5cad5504301e..3dc628b0384d 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1522,7 +1522,6 @@ void pm8001_work_fn(struct work_struct *work)
>         case IO_XFER_ERROR_BREAK:
>         {       /* This one stashes the sas_task instead */
>                 struct sas_task *t = (struct sas_task *)pm8001_dev;
> -               u32 tag;
>                 struct pm8001_ccb_info *ccb;
>                 struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
>                 unsigned long flags, flags1;
> @@ -1544,8 +1543,8 @@ void pm8001_work_fn(struct work_struct *work)
>                 /* Search for a possible ccb that matches the task */
>                 for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
>                         ccb = &pm8001_ha->ccb_info[i];
> -                       tag = ccb->ccb_tag;
> -                       if ((tag != 0xFFFFFFFF) && (ccb->task == t))
> +                       if ((ccb->ccb_tag != PM8001_INVALID_TAG) &&
> +                           (ccb->task == t))
>                                 break;
>                 }
>                 if (!ccb) {
> @@ -1566,11 +1565,11 @@ void pm8001_work_fn(struct work_struct *work)
>                         spin_unlock_irqrestore(&t->task_state_lock, flags1);
>                         pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
>                                    t, pw->handler, ts->resp, ts->stat);
> -                       pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                 } else {
>                         spin_unlock_irqrestore(&t->task_state_lock, flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> +                       pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
>                         mb();/* in order to force CPU ordering */
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                         t->task_done(t);
> @@ -1579,7 +1578,6 @@ void pm8001_work_fn(struct work_struct *work)
>         case IO_XFER_OPEN_RETRY_TIMEOUT:
>         {       /* This one stashes the sas_task instead */
>                 struct sas_task *t = (struct sas_task *)pm8001_dev;
> -               u32 tag;
>                 struct pm8001_ccb_info *ccb;
>                 struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
>                 unsigned long flags, flags1;
> @@ -1613,8 +1611,8 @@ void pm8001_work_fn(struct work_struct *work)
>                 /* Search for a possible ccb that matches the task */
>                 for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
>                         ccb = &pm8001_ha->ccb_info[i];
> -                       tag = ccb->ccb_tag;
> -                       if ((tag != 0xFFFFFFFF) && (ccb->task == t))
> +                       if ((ccb->ccb_tag != PM8001_INVALID_TAG) &&
> +                           (ccb->task == t))
>                                 break;
>                 }
>                 if (!ccb) {
> @@ -1685,19 +1683,13 @@ void pm8001_work_fn(struct work_struct *work)
>                 struct task_status_struct *ts;
>                 struct sas_task *task;
>                 int i;
> -               u32 tag, device_id;
> +               u32 device_id;
>
>                 for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
>                         ccb = &pm8001_ha->ccb_info[i];
>                         task = ccb->task;
>                         ts = &task->task_status;
> -                       tag = ccb->ccb_tag;
> -                       /* check if tag is NULL */
> -                       if (!tag) {
> -                               pm8001_dbg(pm8001_ha, FAIL,
> -                                       "tag Null\n");
> -                               continue;
> -                       }
> +
>                         if (task != NULL) {
>                                 dev = task->dev;
>                                 if (!dev) {
> @@ -1706,10 +1698,11 @@ void pm8001_work_fn(struct work_struct *work)
>                                         continue;
>                                 }
>                                 /*complete sas task and update to top layer */
> -                               pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                               pm8001_ccb_task_free(pm8001_ha, task, ccb,
> +                                                    ccb->ccb_tag);
>                                 ts->resp = SAS_TASK_COMPLETE;
>                                 task->task_done(task);
> -                       } else if (tag != 0xFFFFFFFF) {
> +                       } else if (ccb->ccb_tag != PM8001_INVALID_TAG) {
>                                 /* complete the internal commands/non-sas task */
>                                 pm8001_dev = ccb->device;
>                                 if (pm8001_dev->dcompletion) {
> @@ -1717,7 +1710,7 @@ void pm8001_work_fn(struct work_struct *work)
>                                         pm8001_dev->dcompletion = NULL;
>                                 }
>                                 complete(pm8001_ha->nvmd_completion);
> -                               pm8001_tag_free(pm8001_ha, tag);
> +                               pm8001_tag_free(pm8001_ha, ccb->ccb_tag);
>                         }
>                 }
>                 /* Deregister all the device ids  */
> @@ -2313,11 +2306,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         param = le32_to_cpu(psataPayload->param);
>         tag = le32_to_cpu(psataPayload->tag);
>
> -       if (!tag) {
> -               pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
> -               return;
> -       }
> -
>         ccb = &pm8001_ha->ccb_info[tag];
>         t = ccb->task;
>         pm8001_dev = ccb->device;
> @@ -3051,7 +3039,7 @@ void pm8001_mpi_set_dev_state_resp(struct pm8001_hba_info *pm8001_ha,
>                    device_id, pds, nds, status);
>         complete(pm8001_dev->setds_completion);
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         pm8001_tag_free(pm8001_ha, tag);
>  }
>
> @@ -3069,7 +3057,7 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                                 dlen_status);
>         }
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         pm8001_tag_free(pm8001_ha, tag);
>  }
>
> @@ -3096,7 +3084,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                  * freed by requesting path anywhere.
>                  */
>                 ccb->task = NULL;
> -               ccb->ccb_tag = 0xFFFFFFFF;
> +               ccb->ccb_tag = PM8001_INVALID_TAG;
>                 pm8001_tag_free(pm8001_ha, tag);
>                 return;
>         }
> @@ -3142,7 +3130,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         complete(pm8001_ha->nvmd_completion);
>         pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         pm8001_tag_free(pm8001_ha, tag);
>  }
>
> @@ -3555,7 +3543,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         }
>         complete(pm8001_dev->dcompletion);
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         pm8001_tag_free(pm8001_ha, htag);
>         return 0;
>  }
> @@ -3627,7 +3615,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
>         }
>         kfree(ccb->fw_control_context);
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         pm8001_tag_free(pm8001_ha, tag);
>         complete(pm8001_ha->nvmd_completion);
>         return 0;
> @@ -3663,10 +3651,6 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>         status = le32_to_cpu(pPayload->status);
>         tag = le32_to_cpu(pPayload->tag);
> -       if (!tag) {
> -               pm8001_dbg(pm8001_ha, FAIL, " TAG NULL. RETURNING !!!\n");
> -               return -1;
> -       }
>
>         scp = le32_to_cpu(pPayload->scp);
>         ccb = &pm8001_ha->ccb_info[tag];
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 4b9a26f008a9..8f44be8364dc 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1216,10 +1216,11 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
>                         goto err_out;
>                 }
>                 pm8001_ha->ccb_info[i].task = NULL;
> -               pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
> +               pm8001_ha->ccb_info[i].ccb_tag = PM8001_INVALID_TAG;
>                 pm8001_ha->ccb_info[i].device = NULL;
>                 ++pm8001_ha->tags_num;
>         }
> +
>         return 0;
>
>  err_out_noccb:
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 4ab0ea9483f2..d0f5feb4f2d3 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -563,7 +563,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
>
>         task->lldd_task = NULL;
>         ccb->task = NULL;
> -       ccb->ccb_tag = 0xFFFFFFFF;
> +       ccb->ccb_tag = PM8001_INVALID_TAG;
>         ccb->open_retry = 0;
>         pm8001_tag_free(pm8001_ha, ccb_idx);
>  }
> @@ -948,9 +948,11 @@ void pm8001_open_reject_retry(
>                 struct task_status_struct *ts;
>                 struct pm8001_device *pm8001_dev;
>                 unsigned long flags1;
> -               u32 tag;
>                 struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[i];
>
> +               if (ccb->ccb_tag == PM8001_INVALID_TAG)
> +                       continue;
> +
>                 pm8001_dev = ccb->device;
>                 if (!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED))
>                         continue;
> @@ -962,9 +964,6 @@ void pm8001_open_reject_retry(
>                                 continue;
>                 } else if (pm8001_dev != device_to_close)
>                         continue;
> -               tag = ccb->ccb_tag;
> -               if (!tag || (tag == 0xFFFFFFFF))
> -                       continue;
>                 task = ccb->task;
>                 if (!task || !task->task_done)
>                         continue;
> @@ -984,11 +983,11 @@ void pm8001_open_reject_retry(
>                                 & SAS_TASK_STATE_ABORTED))) {
>                         spin_unlock_irqrestore(&task->task_state_lock,
>                                 flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                       pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
>                 } else {
>                         spin_unlock_irqrestore(&task->task_state_lock,
>                                 flags1);
> -                       pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
> +                       pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
>                         mb();/* in order to force CPU ordering */
>                         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                         task->task_done(task);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index a17da1cebce1..1791cdf30276 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -738,6 +738,8 @@ void pm8001_free_dev(struct pm8001_device *pm8001_dev);
>  /* ctl shared API */
>  extern const struct attribute_group *pm8001_host_groups[];
>
> +#define PM8001_INVALID_TAG     ((u32)-1)
> +
>  static inline void
>  pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
>                         struct sas_task *task, struct pm8001_ccb_info *ccb,
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index a5a99d23cfbe..4419fdb0db78 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2402,11 +2402,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
>         param = le32_to_cpu(psataPayload->param);
>         tag = le32_to_cpu(psataPayload->tag);
>
> -       if (!tag) {
> -               pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
> -               return;
> -       }
> -
>         ccb = &pm8001_ha->ccb_info[tag];
>         t = ccb->task;
>         pm8001_dev = ccb->device;
> --
> 2.34.1
>
