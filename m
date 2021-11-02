Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0A5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F17F60E08
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhKBHJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhKBHJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:09:18 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1B0C061764
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 00:06:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f4so14215353edx.12
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 00:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ourVyS4AC4iuBQGU6SsK2yvQcDmpZN6aanCXQ4vfqYg=;
        b=Qktpq90E4f3HPvtvocKBkpP1JYRfu5ipHESL6EvrrsEeYc8qaO01v4mO6pX4In4Fz/
         tWCkHlk+o6MzN806f4thSlkdM63CyUbg0Pou2LJxcDCFVqH4KQi5W3Kgehke0vx601I7
         EtWYQ8BuoIAWgAK2nCtH0MqZKbVQKW74QdE7XPenmFqkmcD0cXEdEqxwXJ9W9+Bl6J2A
         nJ+QunD6YR4iFnqy2qEDm8enKtlN/4HxtsJugu3akJSOmtt+XAcaH9b1WtWbh3BeFq4w
         BEIkIVTGBuY50CYCKk41QkRSMh2hJtSO4TT/uRtrv6YUU60H7pu7oNz2XpJkUzXoElv5
         oZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ourVyS4AC4iuBQGU6SsK2yvQcDmpZN6aanCXQ4vfqYg=;
        b=WwyODBasb6yrdneGtOd5gHHlUzoimBBHrrxoxLPdmh3VbeX7bZiXmp9Tf95eg95fSX
         IVmX8+fl4rGTiMp3OFePRYImn4V3RqNyNOtbWnYlgcMC7dWXdqyBe5IFIgCFR8DsZZKg
         bI2mxViJyokEABYrL1oUXBUUb7NmXMumqaFxT8Kg+jIpqUD7WpMjhEe3XIxk1WzDdnSM
         rAzaGv0Cv7oy47Y+VUGFyK8tK5IuhNvDPezBrwQd241lzR+5b8N3yGgLdaLD4LrTIo7c
         pSKSAX1TYWv8J6o1SvyeE4+tP1VUEOfKS+uzGmCuSoHtLHvGmv/bb9mkgHH7pYTe2cqx
         xZ0w==
X-Gm-Message-State: AOAM531G/0Nnbj87JiLHvu0Qx3oNlxfwJkWwKLlUn3VBhTfgh/3/BC/M
        tQXotBOT++Vd/SJbGI61coWvBPm5uh9/kY7yQ0sq7A==
X-Google-Smtp-Source: ABdhPJw+7SCDjviiKXswTB9Yag8hKDULjjAi4YBobU8imbytTJod/siKY/pLUNTJGjhHlkwxT9+x1iyWm3+99YHBlVs=
X-Received: by 2002:a05:6402:615:: with SMTP id n21mr45322593edv.117.1635836802114;
 Tue, 02 Nov 2021 00:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com> <20211101232825.2350233-3-ipylypiv@google.com>
In-Reply-To: <20211101232825.2350233-3-ipylypiv@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 2 Nov 2021 08:06:30 +0100
Message-ID: <CAMGffEn+-Wg4SQXaL6ctuBdtyu1W2sy86R-LKfGH6Thwgv1xBw@mail.gmail.com>
Subject: Re: [PATCH 2/4] scsi: pm80xx: Do not check the address-of value for NULL
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 2, 2021 at 12:28 AM Igor Pylypiv <ipylypiv@google.com> wrote:
>
> Address-of operator cannot return NULL.
>
> Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 24 ++++--------------------
>  drivers/scsi/pm8001/pm80xx_hwi.c | 29 ++++++++---------------------
>  2 files changed, 12 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 63690508313b..1a593f2b2c87 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -2304,21 +2304,17 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>         psataPayload = (struct sata_completion_resp *)(piomb + 4);
>         status = le32_to_cpu(psataPayload->status);
> +       param = le32_to_cpu(psataPayload->param);
>         tag = le32_to_cpu(psataPayload->tag);
>
>         if (!tag) {
>                 pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
>                 return;
>         }
> +
>         ccb = &pm8001_ha->ccb_info[tag];
> -       param = le32_to_cpu(psataPayload->param);
> -       if (ccb) {
> -               t = ccb->task;
> -               pm8001_dev = ccb->device;
> -       } else {
> -               pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
> -               return;
> -       }
> +       t = ccb->task;
> +       pm8001_dev = ccb->device;
>
>         if (t) {
>                 if (t->dev && (t->dev->lldd_dev))
> @@ -2335,10 +2331,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         }
>
>         ts = &t->task_status;
> -       if (!ts) {
> -               pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
> -               return;
> -       }
>
>         if (status)
>                 pm8001_dbg(pm8001_ha, IOERR,
> @@ -2695,14 +2687,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         u32 dev_id = le32_to_cpu(psataPayload->device_id);
>         unsigned long flags;
>
> -       ccb = &pm8001_ha->ccb_info[tag];
> -
> -       if (ccb) {
> -               t = ccb->task;
> -               pm8001_dev = ccb->device;
> -       } else {
> -               pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
> -       }
>         if (event)
>                 pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 4f887925c9d2..f9e997b23d42 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2399,21 +2399,17 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>
>         psataPayload = (struct sata_completion_resp *)(piomb + 4);
>         status = le32_to_cpu(psataPayload->status);
> +       param = le32_to_cpu(psataPayload->param);
>         tag = le32_to_cpu(psataPayload->tag);
>
>         if (!tag) {
>                 pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
>                 return;
>         }
> +
>         ccb = &pm8001_ha->ccb_info[tag];
> -       param = le32_to_cpu(psataPayload->param);
> -       if (ccb) {
> -               t = ccb->task;
> -               pm8001_dev = ccb->device;
> -       } else {
> -               pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
> -               return;
> -       }
> +       t = ccb->task;
> +       pm8001_dev = ccb->device;
>
>         if (t) {
>                 if (t->dev && (t->dev->lldd_dev))
> @@ -2430,10 +2426,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         }
>
>         ts = &t->task_status;
> -       if (!ts) {
> -               pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
> -               return;
> -       }
>
>         if (status != IO_SUCCESS) {
>                 pm8001_dbg(pm8001_ha, FAIL,
> @@ -2804,15 +2796,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         u32 dev_id = le32_to_cpu(psataPayload->device_id);
>         unsigned long flags;
>
> -       ccb = &pm8001_ha->ccb_info[tag];
> -
> -       if (ccb) {
> -               t = ccb->task;
> -               pm8001_dev = ccb->device;
> -       } else {
> -               pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
> -               return;
> -       }
>         if (event)
>                 pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
>
> @@ -2826,6 +2809,10 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 return;
>         }
>
> +       ccb = &pm8001_ha->ccb_info[tag];
> +       t = ccb->task;
> +       pm8001_dev = ccb->device;
> +
>         if (unlikely(!t || !t->lldd_task || !t->dev)) {
>                 pm8001_dbg(pm8001_ha, FAIL, "task or dev null\n");
>                 return;
> --
> 2.33.1.1089.g2158813163f-goog
>
