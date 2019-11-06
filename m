Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BAE1C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AF57217F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 10:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="cqD9eLE2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfKFK21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:28:27 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39906 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfKFK21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 05:28:27 -0500
Received: by mail-io1-f65.google.com with SMTP id k1so14586062ioj.6
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 02:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T5T5Vt9ZaeNvQOuays7x6TASDsvxueKTiEVBHFEDs0s=;
        b=cqD9eLE2eacFiuMyGh3bhPnYsBlm3b1CypDjo6b20N76+48nI4towiCD7svdLqSjf4
         IyyBD/KVS7sEkKoNhzTsD/YPOKhC16pznjEWvXqquO6vOvGWGdhFd0AblLD9VGhh+x4p
         ZKdVWJXMcepgWD/wqf32rNgZN2j1QHUnvtmTPTbxP5F59T2zoxQbx2XJ9583yAQXR7zZ
         VmQ/zfPktk3dl4Ow+BbEtHs0QFxU5tMj9tGFygvTuE+bk6o71M/Ip4u4LT24Aay70XcH
         OcRz1PSDVR+eaLA9zfKZJSc08J5TY3zfVxPago1OlpkxGXXvRQyXxq1tiQBVyN7UHvDI
         VNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T5T5Vt9ZaeNvQOuays7x6TASDsvxueKTiEVBHFEDs0s=;
        b=CeZm06SzLWLVeVdTqspS6BzPYznysollTaRPOrKY6uw6JPe0d7SF5tEKhIZenUuyhi
         tWKnXANb8bHdrqTk6Fiuq+xhv1FdYWdTZWxpunYliHZ1xHQTcwiAYxdYjesMtI8Nqln8
         yPTif5hMi0LKuX8dJCZnkGN2NAatwl4T7+/lvcvHh573cH9QDvcoD6arCWBLbDVmjHSL
         p3zc9WEqrGG6MV4cgGBIKjkgDXLyKmqEiCCogJ1bzP3fthx+LKyHJsLHjJES70fDqdKy
         Mc2ZtNhz7xeuJoQsxwtRv3yVBCTilg2+idZYYJnCG5KYE7p05AgeWpuHRNVGArSfK30c
         0ojQ==
X-Gm-Message-State: APjAAAUYgQ4LCWGPBUyPOMv9dWH1t6qjkQmCl0s1IMl6dueLsULoOOcf
        L7LIDcBgMy4AUxBYfPK3hhIBAR+pcwlpvx15aLJ3ag==
X-Google-Smtp-Source: APXvYqzvQoB7+mCDTek93Ozh2PvQVYfAhPjlEraKfS1vwMulgUMq37ssPq23HT5o97O648S9YorjxCH1y/i9qL0/iVM=
X-Received: by 2002:a5d:80d5:: with SMTP id h21mr28973103ior.298.1573036106933;
 Wed, 06 Nov 2019 02:28:26 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com> <20191031051241.6762-7-deepak.ukey@microchip.com>
In-Reply-To: <20191031051241.6762-7-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 6 Nov 2019 11:28:15 +0100
Message-ID: <CAMGffEkXQbGF-Tk4vQWuRpbTG7OcKAqMyHakJVDXBjPT1Z7n5A@mail.gmail.com>
Subject: Re: [PATCH 06/12] pm80xx : Fix dereferencing dangling pointer.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Vikram Auradkar <auradkar@google.com>
>
> sas_task structure should not be used after task_done is called.
> If the device is gone or not attached, we call task_done on t and
> continue to use in the sas_task in rest of the function. task_done
> is pointing to sas_ata_task_done, may free the memory associated
> with the task before returning.
>
> Signed-off-by: Vikram Auradkar <auradkar@google.com>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
Looks fine.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 447a66d60275..4491de8d40fc 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -388,6 +388,7 @@ static int pm8001_task_exec(struct sas_task *task,
>         struct pm8001_ccb_info *ccb;
>         u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
>         unsigned long flags = 0;
> +       enum sas_protocol task_proto = t->task_proto;
>
>         if (!dev->port) {
>                 struct task_status_struct *tsm = &t->task_status;
> @@ -412,7 +413,7 @@ static int pm8001_task_exec(struct sas_task *task,
>                 pm8001_dev = dev->lldd_dev;
>                 port = &pm8001_ha->port[sas_find_local_port_id(dev)];
>                 if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
> -                       if (sas_protocol_ata(t->task_proto)) {
> +                       if (sas_protocol_ata(task_proto)) {
>                                 struct task_status_struct *ts = &t->task_status;
>                                 ts->resp = SAS_TASK_UNDELIVERED;
>                                 ts->stat = SAS_PHY_DOWN;
> @@ -434,7 +435,7 @@ static int pm8001_task_exec(struct sas_task *task,
>                         goto err_out;
>                 ccb = &pm8001_ha->ccb_info[tag];
>
> -               if (!sas_protocol_ata(t->task_proto)) {
> +               if (!sas_protocol_ata(task_proto)) {
>                         if (t->num_scatter) {
>                                 n_elem = dma_map_sg(pm8001_ha->dev,
>                                         t->scatter,
> @@ -454,7 +455,7 @@ static int pm8001_task_exec(struct sas_task *task,
>                 ccb->ccb_tag = tag;
>                 ccb->task = t;
>                 ccb->device = pm8001_dev;
> -               switch (t->task_proto) {
> +               switch (task_proto) {
>                 case SAS_PROTOCOL_SMP:
>                         rc = pm8001_task_prep_smp(pm8001_ha, ccb);
>                         break;
> @@ -471,8 +472,7 @@ static int pm8001_task_exec(struct sas_task *task,
>                         break;
>                 default:
>                         dev_printk(KERN_ERR, pm8001_ha->dev,
> -                               "unknown sas_task proto: 0x%x\n",
> -                               t->task_proto);
> +                               "unknown sas_task proto: 0x%x\n", task_proto);
>                         rc = -EINVAL;
>                         break;
>                 }
> @@ -495,7 +495,7 @@ static int pm8001_task_exec(struct sas_task *task,
>         pm8001_tag_free(pm8001_ha, tag);
>  err_out:
>         dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
> -       if (!sas_protocol_ata(t->task_proto))
> +       if (!sas_protocol_ata(task_proto))
>                 if (n_elem)
>                         dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
>                                 t->data_dir);
> --
> 2.16.3
>
