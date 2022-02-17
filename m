Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07B4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbiBQTsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:48:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245488AbiBQTsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:48:14 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD4527FCF
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:47:44 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lw4so9698595ejb.12
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6QFka1J70KL7XQhNZLN1qABMs40CP+shJVVzWLUghSQ=;
        b=VVP7cTrhvPZTbGUWJaDu5TBS6uhYkvK/4f7CJbeuZYCRrKHW5M4Sj5j8vgHWn08uwZ
         34M0bYSIt2M+NZKxO1mAFe1ZcVgNRhb+q56WnYnFvBWoAoexVV7vzQMNgiu07AixJuE2
         +blJkruWF9ICWrIGqg4bYdN9MWZun6yax9jTy9+3zU70NXC6GBOrvFEAd/MFFjuUn3Ki
         hgbsyRRQH1oIwwYYUIz9IavFYXzkIWPfgg2DhX6OdFRieVxcfetGZBZggLP8PQnJTk0T
         OivxXS4+fvMHWx2kzH4omp4+zm1Zk2OtQgyi8vPoWeDrjQh8wxBLnt0mk4VpK66yCxNe
         EcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6QFka1J70KL7XQhNZLN1qABMs40CP+shJVVzWLUghSQ=;
        b=Pi+ZUyOBkEgNxdv4yKtPWQTKt0CmnLY1ka6BZoJTZoaxBbs1r5q0u2wuiSn8taxIol
         JGI/47IGfJpG4V/DWxh92lHfQ9vselJhWxffZtRX6nzzjR7Y3O/clpZMKthNZc7z4ono
         R8tiAJooDWZOKyUmfQxKi7te6DuHybbDomYZnfDs7hJfL06kMswX43PRk5jWFsHWpwhA
         i2ulv5XkjwENg0W+R+M9BiPEO9kHDslYVbA7CS9cxKyfp1dJYK6E56rHvs4SdQn6kUWL
         LPivsG/Mxu5Q2fvntP4ZFTuK/+na+S/yeehDpD+Gao2D1lUzvlC5eUCcXu3T3F7K3z2a
         M93w==
X-Gm-Message-State: AOAM532XYRUKUsi82vAEjSSGZyGoy6GiiUUcX3z2vSvGvP0lZbIVsmAL
        hkhzvB+i+r+ZCEy01BfIGQdnMOZ3eF7ZR2A0+z4eBA==
X-Google-Smtp-Source: ABdhPJxxgItJ+gWhzJ7Sl899xVSQ1bTqXUlhNcOx4SsmNmodIQdlgC0TfQNhPHCI/HYqgOyxj4X4o1XXkXFsvzHEosA=
X-Received: by 2002:a17:906:ae07:b0:6b8:f4ba:4421 with SMTP id
 le7-20020a170906ae0700b006b8f4ba4421mr3592187ejb.692.1645127263383; Thu, 17
 Feb 2022 11:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-29-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-29-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:47:32 +0100
Message-ID: <CAMGffEmo7HodeOhSkXLZEzQSytBk3=qvt14LWHOkrYpvWUz3Dw@mail.gmail.com>
Subject: Re: [PATCH v4 28/31] scsi: pm8001: Simplify pm8001_task_exec()
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
> The main part of the pm8001_task_exec() function uses a do {} while(0)
> loop that is useless and only makes the code harder to read. Remove this
> loop. The unnecessary local variable t is also removed.
>
> Additionally, avoid repeatedly declaring "struct task_status_struct *ts"
> to handle error cases by declaring this variable for the entire function
> scope. This allows simplifying the error cases, and together with the
> addition of blank lines make the code more readable.
>
> Finally, handling of the running_req counter is fixed to avoid
> decrementing it without a corresponding incrementation in the case of
> an invalid task protocol.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 174 ++++++++++++++-----------------
>  1 file changed, 80 insertions(+), 94 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 52507bc8f963..37aba0335f18 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -373,129 +373,115 @@ static int sas_find_local_port_id(struct domain_device *dev)
>    * @is_tmf: if it is task management task.
>    * @tmf: the task management IU
>    */
> -static int pm8001_task_exec(struct sas_task *task,
> -       gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
> +static int pm8001_task_exec(struct sas_task *task, gfp_t gfp_flags, int is_tmf,
> +                           struct pm8001_tmf_task *tmf)
>  {
> +       struct task_status_struct *ts = &task->task_status;
> +       enum sas_protocol task_proto = task->task_proto;
>         struct domain_device *dev = task->dev;
> +       struct pm8001_device *pm8001_dev = dev->lldd_dev;
>         struct pm8001_hba_info *pm8001_ha;
> -       struct pm8001_device *pm8001_dev;
>         struct pm8001_port *port = NULL;
> -       struct sas_task *t = task;
>         struct pm8001_ccb_info *ccb;
> -       u32 rc = 0, n_elem = 0;
> -       unsigned long flags = 0;
> -       enum sas_protocol task_proto = t->task_proto;
> +       unsigned long flags;
> +       u32 n_elem = 0;
> +       int rc = 0;
>
>         if (!dev->port) {
> -               struct task_status_struct *tsm = &t->task_status;
> -               tsm->resp = SAS_TASK_UNDELIVERED;
> -               tsm->stat = SAS_PHY_DOWN;
> +               ts->resp = SAS_TASK_UNDELIVERED;
> +               ts->stat = SAS_PHY_DOWN;
>                 if (dev->dev_type != SAS_SATA_DEV)
> -                       t->task_done(t);
> +                       task->task_done(task);
>                 return 0;
>         }
> -       pm8001_ha = pm8001_find_ha_by_dev(task->dev);
> -       if (pm8001_ha->controller_fatal_error) {
> -               struct task_status_struct *ts = &t->task_status;
>
> +       pm8001_ha = pm8001_find_ha_by_dev(dev);
> +       if (pm8001_ha->controller_fatal_error) {
>                 ts->resp = SAS_TASK_UNDELIVERED;
> -               t->task_done(t);
> +               task->task_done(task);
>                 return 0;
>         }
> +
>         pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device\n");
> +
>         spin_lock_irqsave(&pm8001_ha->lock, flags);
> -       do {
> -               dev = t->dev;
> -               pm8001_dev = dev->lldd_dev;
> -               port = &pm8001_ha->port[sas_find_local_port_id(dev)];
> -               if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
> -                       if (sas_protocol_ata(task_proto)) {
> -                               struct task_status_struct *ts = &t->task_status;
> -                               ts->resp = SAS_TASK_UNDELIVERED;
> -                               ts->stat = SAS_PHY_DOWN;
>
> -                               spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> -                               t->task_done(t);
> -                               spin_lock_irqsave(&pm8001_ha->lock, flags);
> -                               continue;
> -                       } else {
> -                               struct task_status_struct *ts = &t->task_status;
> -                               ts->resp = SAS_TASK_UNDELIVERED;
> -                               ts->stat = SAS_PHY_DOWN;
> -                               t->task_done(t);
> -                               continue;
> -                       }
> -               }
> +       pm8001_dev = dev->lldd_dev;
> +       port = &pm8001_ha->port[sas_find_local_port_id(dev)];
>
> -               ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
> -               if (!ccb) {
> -                       rc = -SAS_QUEUE_FULL;
> -                       goto err_out;
> +       if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
> +               ts->resp = SAS_TASK_UNDELIVERED;
> +               ts->stat = SAS_PHY_DOWN;
> +               if (sas_protocol_ata(task_proto)) {
> +                       spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +                       task->task_done(task);
> +                       spin_lock_irqsave(&pm8001_ha->lock, flags);
> +               } else {
> +                       task->task_done(task);
>                 }
> +               rc = -ENODEV;
> +               goto err_out;
> +       }
>
> -               if (!sas_protocol_ata(task_proto)) {
> -                       if (t->num_scatter) {
> -                               n_elem = dma_map_sg(pm8001_ha->dev,
> -                                       t->scatter,
> -                                       t->num_scatter,
> -                                       t->data_dir);
> -                               if (!n_elem) {
> -                                       rc = -ENOMEM;
> -                                       goto err_out_ccb;
> -                               }
> +       ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
> +       if (!ccb) {
> +               rc = -SAS_QUEUE_FULL;
> +               goto err_out;
> +       }
> +
> +       if (!sas_protocol_ata(task_proto)) {
> +               if (task->num_scatter) {
> +                       n_elem = dma_map_sg(pm8001_ha->dev, task->scatter,
> +                                           task->num_scatter, task->data_dir);
> +                       if (!n_elem) {
> +                               rc = -ENOMEM;
> +                               goto err_out_ccb;
>                         }
> -               } else {
> -                       n_elem = t->num_scatter;
>                 }
> +       } else {
> +               n_elem = task->num_scatter;
> +       }
>
> -               t->lldd_task = ccb;
> -               ccb->n_elem = n_elem;
> +       task->lldd_task = ccb;
> +       ccb->n_elem = n_elem;
>
> -               switch (task_proto) {
> -               case SAS_PROTOCOL_SMP:
> -                       atomic_inc(&pm8001_dev->running_req);
> -                       rc = pm8001_task_prep_smp(pm8001_ha, ccb);
> -                       break;
> -               case SAS_PROTOCOL_SSP:
> -                       atomic_inc(&pm8001_dev->running_req);
> -                       if (is_tmf)
> -                               rc = pm8001_task_prep_ssp_tm(pm8001_ha,
> -                                       ccb, tmf);
> -                       else
> -                               rc = pm8001_task_prep_ssp(pm8001_ha, ccb);
> -                       break;
> -               case SAS_PROTOCOL_SATA:
> -               case SAS_PROTOCOL_STP:
> -                       atomic_inc(&pm8001_dev->running_req);
> -                       rc = pm8001_task_prep_ata(pm8001_ha, ccb);
> -                       break;
> -               default:
> -                       dev_printk(KERN_ERR, pm8001_ha->dev,
> -                               "unknown sas_task proto: 0x%x\n", task_proto);
> -                       rc = -EINVAL;
> -                       break;
> -               }
> +       atomic_inc(&pm8001_dev->running_req);
>
> -               if (rc) {
> -                       pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
> -                       atomic_dec(&pm8001_dev->running_req);
> -                       goto err_out_ccb;
> -               }
> -               /* TODO: select normal or high priority */
> -       } while (0);
> -       rc = 0;
> -       goto out_done;
> +       switch (task_proto) {
> +       case SAS_PROTOCOL_SMP:
> +               rc = pm8001_task_prep_smp(pm8001_ha, ccb);
> +               break;
> +       case SAS_PROTOCOL_SSP:
> +               if (is_tmf)
> +                       rc = pm8001_task_prep_ssp_tm(pm8001_ha, ccb, tmf);
> +               else
> +                       rc = pm8001_task_prep_ssp(pm8001_ha, ccb);
> +               break;
> +       case SAS_PROTOCOL_SATA:
> +       case SAS_PROTOCOL_STP:
> +               rc = pm8001_task_prep_ata(pm8001_ha, ccb);
> +               break;
> +       default:
> +               dev_printk(KERN_ERR, pm8001_ha->dev,
> +                          "unknown sas_task proto: 0x%x\n", task_proto);
> +               rc = -EINVAL;
> +               break;
> +       }
>
> +       if (rc) {
> +               atomic_dec(&pm8001_dev->running_req);
> +               if (!sas_protocol_ata(task_proto) && n_elem)
> +                       dma_unmap_sg(pm8001_ha->dev, task->scatter,
> +                                    task->num_scatter, task->data_dir);
>  err_out_ccb:
> -       pm8001_ccb_free(pm8001_ha, ccb);
> +               pm8001_ccb_free(pm8001_ha, ccb);
> +
>  err_out:
> -       dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
> -       if (!sas_protocol_ata(task_proto))
> -               if (n_elem)
> -                       dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
> -                               t->data_dir);
> -out_done:
> +               pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec failed[%d]!\n", rc);
> +       }
> +
>         spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +
>         return rc;
>  }
>
> --
> 2.34.1
>
