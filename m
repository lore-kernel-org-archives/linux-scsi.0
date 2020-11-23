Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1511C63777
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 05:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 706D82145D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 05:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XBe6W6gF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgKWFvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 00:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgKWFvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 00:51:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FD7C061A4C
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2020 21:51:10 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id mc24so484782ejb.6
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2020 21:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qgA3ucO6pJx4Po5ypwNmL1aURBC/9bk4JTFs/7xb34=;
        b=XBe6W6gFQe0AmpCqpdOlzS+N2b8yiTEjAH5i97TL+FYtvHXAIgJjcvjHFwtD459CaH
         TPrdj7wdUofqAbg3rnibRxF4I43112Dnuifx/sXYHPoNAihgOqmbfojo6LGvCNWMT+yW
         fqP6C5ERIb03c3LTlIL12NLz7ghDkuTzxFU4dPzIkKrGZ1xC8gx1p7eWJ+8t9vdw0YJ4
         wAGhNPzUo/pXKfJWsDcsIT9eyRpftQy6nKYTd3gfhyNeDeWBJfZZpk7Y0lSmnpMMbMVu
         8v51ZYROenpXyZ9+WDuDebbuD3nx0FE6XKvYL6Pln+G88WDfn3NbHIhKhkGbQ08BKPMN
         gruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qgA3ucO6pJx4Po5ypwNmL1aURBC/9bk4JTFs/7xb34=;
        b=bJguMnckAhd8peM9knAsj/PoVUJRb+ep2JO10jcr1lFzWnQrHkduxxZnJ7Q5g5AwPw
         +9Hr4UMO6wsYT3kkrYc3umu8/9zhTFhTUSxzy8y7ebB3nXWJNxPuVfSkNIDM7V1ixqTJ
         wTJc4r6UeMsXrnwutxnfm9lVTZYSWFNVsTbQa35RmgE/AwuMs6nOvnO9KGB7ETdlyIwn
         omZP5ny+x4gqCM+YM3jUe+17MPrJOww3SHO7asxIsmNuryiK0rbvOGmO7CmDyOt7dw6E
         BA6r90nV+QWLrOjflT6U6npzQeXdkpMDfP6tydVZE71k0wUeRA6LX+9NSbZLiTaVe05g
         SXNw==
X-Gm-Message-State: AOAM532u58SKuQef+f2sxL3oFBQoDORKVXuY5vdrbvBIiUj8sQvMHqEg
        CG4Pc2D1lqZFbHNmMKEjOd5ot6Qh2rSW8UQhD3BYJA==
X-Google-Smtp-Source: ABdhPJw2tkTfWOMevrks6e4V4LMKSmWyto2oP59T/1sI8Pu5b8V0fkyL6eSjpLZk05DAApKFvd5bI47W9V9hWwOEa/w=
X-Received: by 2002:a17:906:1682:: with SMTP id s2mr7369415ejd.62.1606110669180;
 Sun, 22 Nov 2020 21:51:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605914030.git.joe@perches.com> <0e17a4c845f15e18f98b346ffb9b039584d21cdd.1605914030.git.joe@perches.com>
In-Reply-To: <0e17a4c845f15e18f98b346ffb9b039584d21cdd.1605914030.git.joe@perches.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 23 Nov 2020 06:50:58 +0100
Message-ID: <CAMGffE=DyJ=M_5sDpkQ_dLfKMMSduXr+UJKi44YVLjOqBWt4Rg@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: pm8001: Make implicit use of pm8001_ha in
 pm8001_printk explicit
To:     Joe Perches <joe@perches.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 21, 2020 at 12:16 AM Joe Perches <joe@perches.com> wrote:
>
> Make the pm8001_printk macro take an explicit HBA instead of
> assuming the existence of an unspecified pm8001_ha argument
>
> Miscellanea:
>
> o Add pm8001_ha to the few uses of pm8001_printk
> o Add HBA to the pm8001_dbg macro call to pm8001_printk
>
> Signed-off-by: Joe Perches <joe@perches.com>
Looks good!
Thanks!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 11 +++++------
>  drivers/scsi/pm8001/pm8001_sas.c  |  4 ++--
>  drivers/scsi/pm8001/pm8001_sas.h  |  6 +++---
>  3 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 96b7281b2fca..13530d7fb8a6 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1293,9 +1293,8 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>                         tasklet_kill(&pm8001_ha->tasklet[j]);
>  #endif
>         device_state = pci_choose_state(pdev, state);
> -       pm8001_printk("pdev=0x%p, slot=%s, entering "
> -                     "operating state [D%d]\n", pdev,
> -                     pm8001_ha->name, device_state);
> +       pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> +                     pdev, pm8001_ha->name, device_state);
>         pci_save_state(pdev);
>         pci_disable_device(pdev);
>         pci_set_power_state(pdev, device_state);
> @@ -1319,15 +1318,15 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>         pm8001_ha = sha->lldd_ha;
>         device_state = pdev->current_state;
>
> -       pm8001_printk("pdev=0x%p, slot=%s, resuming from previous "
> -               "operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
> +       pm8001_printk(pm8001_ha, "pdev=0x%p, slot=%s, resuming from previous operating state [D%d]\n",
> +                     pdev, pm8001_ha->name, device_state);
>
>         pci_set_power_state(pdev, PCI_D0);
>         pci_enable_wake(pdev, PCI_D0, 0);
>         pci_restore_state(pdev);
>         rc = pci_enable_device(pdev);
>         if (rc) {
> -               pm8001_printk("slot=%s Enable device failed during resume\n",
> +               pm8001_printk(pm8001_ha, "slot=%s Enable device failed during resume\n",
>                               pm8001_ha->name);
>                 goto err_out_enable;
>         }
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 505a885b4c77..4562b0a5062a 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -1191,7 +1191,7 @@ int pm8001_abort_task(struct sas_task *task)
>         phy_id = pm8001_dev->attached_phy;
>         ret = pm8001_find_tag(task, &tag);
>         if (ret == 0) {
> -               pm8001_printk("no tag for task:%p\n", task);
> +               pm8001_printk(pm8001_ha, "no tag for task:%p\n", task);
>                 return TMF_RESP_FUNC_FAILED;
>         }
>         spin_lock_irqsave(&task->task_state_lock, flags);
> @@ -1313,7 +1313,7 @@ int pm8001_abort_task(struct sas_task *task)
>                 task->slow_task = NULL;
>         spin_unlock_irqrestore(&task->task_state_lock, flags);
>         if (rc != TMF_RESP_FUNC_COMPLETE)
> -               pm8001_printk("rc= %d\n", rc);
> +               pm8001_printk(pm8001_ha, "rc= %d\n", rc);
>         return rc;
>  }
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index 5cd6fe6a7d2d..5266756a268b 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -70,14 +70,14 @@
>  #define PM8001_DEVIO_LOGGING   0x100 /* development io message logging */
>  #define PM8001_IOERR_LOGGING   0x200 /* development io err message logging */
>
> -#define pm8001_printk(fmt, ...)                                                \
> +#define pm8001_printk(HBA, fmt, ...)                                   \
>         pr_info("%s:: %s  %d:" fmt,                                     \
> -               pm8001_ha->name, __func__, __LINE__, ##__VA_ARGS__)
> +               (HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
>
>  #define pm8001_dbg(HBA, level, fmt, ...)                               \
>  do {                                                                   \
>         if (unlikely((HBA)->logging_level & PM8001_##level##_LOGGING))  \
> -               pm8001_printk(fmt, ##__VA_ARGS__);                      \
> +               pm8001_printk(HBA, fmt, ##__VA_ARGS__);                 \
>  } while (0)
>
>  #define PM8001_USE_TASKLET
> --
> 2.26.0
>
