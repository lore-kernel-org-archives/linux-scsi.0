Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25631C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 06:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF9420BED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 06:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="EMjDhtqv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgKXGXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 01:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgKXGXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 01:23:24 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B641CC0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 22:23:22 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id q16so19608050edv.10
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 22:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g7rAnBCNEOexDsLeiBc8AFxW7GC6geHmTufT6HDd6+M=;
        b=EMjDhtqvKPL+LhyRWhJ7GpK/6OhFaDspFcOFurIEKoAsnfdSiQH/4lbZOBLFEszfST
         t3NAqoNEGqJXwsuYU9Ruxskatx7rQP8LPXaz4BIL5tKybwTWrH6IuBAw+kGevXt0twOS
         5ag1rMgG4v+X6GgUAbanNAQmI9M4AlShLlwH0w5iMaWgN7BuUbHdTLNU+xJ1GnkTuN9y
         HK3V2qg/n1YQ3juQRlx8hSy9BizRhSo/tvn410sDBBlDgtQ1rNyAmLs6wGZ+GihZvfr+
         nqu6jdpBjtHlI6TJw22fr9BLwTJ8py4qL7AQzF/73OG9qZ/yZ/yysC25Zehk2sl09QW7
         OIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7rAnBCNEOexDsLeiBc8AFxW7GC6geHmTufT6HDd6+M=;
        b=rSJsDAGiIBu+DFOsvL1AC5/ITGIWzHx/Qn1zBCojQMHQxvbeOhCPyED6wy4xae8ED/
         qX2p1rK8bG8veHSDLWxZlTuFxZoq/IqnVkI+NZ4Gx0p3J7rMKtLjMhzJlBuUv0+luC0z
         ZHfyGWMtmPHTG59MGKhILA2QDd6G/sWnDc6xZy19SdFsb4F3/iRp/ljBAmpya+BHpOIy
         uZU/F2ptL/NnO/dvcqbV6MliP3EfJ5SKQCbNWfne3UNZsAIIhaJXa32PIQhlGZ86aMC6
         Y4myuqpoZQZx4AxBY/6mNKVlSd2nf5Cuw7t7aqLkYpzqzlN+NXhljL6og63iuWF2lQzv
         eh8A==
X-Gm-Message-State: AOAM530BXMYo8/k6HbpUVSxjXUwq5d+q08p6bzaDtveREn7uu5XhT/Ic
        0GRoxbQdQkiD2fHKAwTVjWoSghecrkIE3eBqShKycQ==
X-Google-Smtp-Source: ABdhPJxQNen1PLZZm50zG1JSrV64LLgD6Xd2GhfeWhmbOTk8Unmf5NUXmVXU3AS/+Ldq1so0yJQO0ALxggx5z3poDXo=
X-Received: by 2002:aa7:d443:: with SMTP id q3mr2648810edr.262.1606199001305;
 Mon, 23 Nov 2020 22:23:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1606192458.git.joe@perches.com> <69dc34ff63adfa60b3f203ed2d58143b5692af57.1606192458.git.joe@perches.com>
In-Reply-To: <69dc34ff63adfa60b3f203ed2d58143b5692af57.1606192458.git.joe@perches.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 24 Nov 2020 07:23:10 +0100
Message-ID: <CAMGffE=JTjJkjJC68v5OjDGVs536be8_CxDTHbOh4tHNf8LaPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm8001: Convert pm8001_printk to pm8001_info
To:     Joe Perches <joe@perches.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2020 at 5:36 AM Joe Perches <joe@perches.com> wrote:
>
> Use the more common logging style.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 12 ++++++------
>  drivers/scsi/pm8001/pm8001_sas.c  |  4 ++--
>  drivers/scsi/pm8001/pm8001_sas.h  |  4 ++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 13530d7fb8a6..38907f45c845 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1293,8 +1293,8 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>                         tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
>         device_state = pci_choose_state(pdev, state);
> -       pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> -                     pdev, pm8001_ha->name, device_state);
> +       pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> +                   pdev, pm8001_ha->name, device_state);
>         pci_save_state(pdev);
>         pci_disable_device(pdev);
>         pci_set_power_state(pdev, device_state);
> @@ -1318,16 +1318,16 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>         pm8001_ha = sha->lldd_ha;
>         device_state = pdev->current_state;
>
> -       pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> -                     pdev, pm8001_ha->name, device_state);
> +       pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> +                   pdev, pm8001_ha->name, device_state);
>
>         pci_set_power_state(pdev, PCI_D0);
>         pci_enable_wake(pdev, PCI_D0, 0);
>         pci_restore_state(pdev);
>         rc = pci_enable_device(pdev);
>         if (rc) {
> -               pm8001_printk(pm8001_ha, "slot=%s Enable device failed during resume\n",
> -                             pm8001_ha->name);
> +               pm8001_info(pm8001_ha, "slot=%s Enable device failed during resume\n",
> +                           pm8001_ha->name);
>                 goto err_out_enable;
>         }
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 4562b0a5062a..d1e9dba2ef19 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1191,7 +1191,7 @@ int pm8001_abort_task(struct sas_task *task)
>         phy_id = pm8001_dev->attached_phy;
>         ret = pm8001_find_tag(task, &tag);
>         if (ret == 0) {
> -               pm8001_printk(pm8001_ha, "no tag for task:%p\n", task);
> +               pm8001_info(pm8001_ha, "no tag for task:%p\n", task);
>                 return TMF_RESP_FUNC_FAILED;
>         }
>         spin_lock_irqsave(&task->task_state_lock, flags);
> @@ -1313,7 +1313,7 @@ int pm8001_abort_task(struct sas_task *task)
>                 task->slow_task = NULL;
>         spin_unlock_irqrestore(&task->task_state_lock, flags);
>         if (rc != TMF_RESP_FUNC_COMPLETE)
> -               pm8001_printk(pm8001_ha, "rc= %d\n", rc);
> +               pm8001_info(pm8001_ha, "rc= %d\n", rc);
>         return rc;
>  }
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 5266756a268b..f2c8cbad3853 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -70,14 +70,14 @@
>  #define PM8001_DEVIO_LOGGING   0x100 /* development io message logging */
>  #define PM8001_IOERR_LOGGING   0x200 /* development io err message logging */
>
> -#define pm8001_printk(HBA, fmt, ...)                                   \
> +#define pm8001_info(HBA, fmt, ...)                                     \
>         pr_info("%s:: %s  %d:" fmt,                                     \
>                 (HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
>
>  #define pm8001_dbg(HBA, level, fmt, ...)                               \
>  do {                                                                   \
>         if (unlikely((HBA)->logging_level & PM8001_##level##_LOGGING))  \
> -               pm8001_printk(HBA, fmt, ##__VA_ARGS__);                 \
> +               pm8001_info(HBA, fmt, ##__VA_ARGS__);                   \
>  } while (0)
>
>  #define PM8001_USE_TASKLET
> --
> 2.26.0
>
