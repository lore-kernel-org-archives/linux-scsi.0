Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A443AC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 22 May 2022 11:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiEVLLm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 May 2022 07:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiEVLLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2022 07:11:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9354D1CB12
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 04:11:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so11299535pjq.2
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 04:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQWN+Pa7VYDz6AB26tEqSSqecDHhaP47IKRXvSBTIr0=;
        b=anfj9lRZPB8AMmlNxxl2GaKUD3J645vQIUA7e67yEQBNGJbPMvKa17em4yL1c/h0oj
         v+VQN7ERxQecZdybMf0wBZBjMwRQPjrZmpBuPKixFNJa9oZ//4Jszl5aTHWn7Vok0aC2
         WT8ZCvlnCwZ/NQMHju4X1s1ndgpc4XKj2swimndm+2QTdMlbh51AA5StEnYThGXrwi+M
         bbdFbpCbVhFcyjogvPenrqyVJ9yb7SlC4A/K01Bb9WIracMexeTsPIL4y3VKsAWqV02J
         ibCNx50UDeaxbv8tMjOpOyPnE6P2A/+55RjqcFxeaoX6T06Nv+4h56ufavbvAkaGlZ7E
         2GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQWN+Pa7VYDz6AB26tEqSSqecDHhaP47IKRXvSBTIr0=;
        b=EVUxN5Q+9TOVeI2HuFtD991zv7cT+TBTX9Y6/Ln29UCv8/t1ysNw/yntUqWd+Zp5sC
         vd9a0E2ju76U7eDT3ZhVogVYovW+g0j9vGKEyzmQwVOLlQcj2HLfNvjCCf3ex2PWE/rT
         fYPDmIQLjFmuSOeoyAOgyxAMZqNp8dC1ZM3d+4/I19UHblk2CIwbLB7l3GVbzkO6Z68Q
         4RU2HEKdL/Irvc1tjj/RBEuX7cA00EQvYmRjD0pDJ9LI1twgQGEMGMkDLn9F55v42xp5
         PhKHbxM758x9j8djLtYI6BnDTJuCCKPqZ32CS8630DbK/JU3pvsBmL+lYLKP4uilVyYL
         scog==
X-Gm-Message-State: AOAM530R1KUaSQzq5E1OmziCv7pWrQpSM+IYWSiOUrHARfJsVYNlLunr
        21XqQIc5DXjyTeGi/TqLjMleeig3xjvc3Xg8/A==
X-Google-Smtp-Source: ABdhPJyHI27QxHixBsvA1MPpJ8BzE0HOfCl/ywf7rtlJL9RbWgQK1sNDkxyU4iXWO0MU3oFXkQ0QMCZjyi2NN0FNBG4=
X-Received: by 2002:a17:903:240b:b0:14b:1100:aebc with SMTP id
 e11-20020a170903240b00b0014b1100aebcmr18445356plo.133.1653217899076; Sun, 22
 May 2022 04:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220522081921.105515-1-hare@suse.de>
In-Reply-To: <20220522081921.105515-1-hare@suse.de>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sun, 22 May 2022 19:11:28 +0800
Message-ID: <CAMhUBjk35rph5pkWJbVmtW8P5O+=FvAS=BHVtzciYdZ0ROK6Tg@mail.gmail.com>
Subject: Re: [PATCH] myrb: fixup null pointer access on myrb_cleanup()
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 22, 2022 at 4:19 PM Hannes Reinecke <hare@suse.de> wrote:
>
> When myrb_probe() fails the callback might not be set, so we need
> to validate the 'disable_intr' callback in myrb_cleanup() to not
> cause a null pointer exception. And while at it do not call
> myrb_cleanup() if we cannot enable the PCI device at all.
>
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/myrb.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 71585528e8db..f460aed2435f 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1239,7 +1239,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
>         myrb_unmap(cb);
>
>         if (cb->mmio_base) {
> -               cb->disable_intr(cb->io_base);
> +               if (cb->disable_intr)
> +                       cb->disable_intr(cb->io_base);
>                 iounmap(cb->mmio_base);
>         }
>         if (cb->irq)
> @@ -3414,8 +3415,11 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
>         mutex_init(&cb->dma_mutex);
>         cb->pdev = pdev;
>
> -       if (pci_enable_device(pdev))
> -               goto failure;
> +       if (pci_enable_device(pdev)) {
> +               dev_err(&pdev->dev, "Failed to enable PCI device\n");
> +               scsi_host_put(shost);
> +               return NULL;
> +       }
>
>         if (privdata->hw_init == DAC960_PD_hw_init ||
>             privdata->hw_init == DAC960_P_hw_init) {
> --
> 2.29.2
>

Thanks for your patch, it works for me :)
But after applying the patch, I got another panic:

[    0.957522] myrb 0000:00:05.0: Unknown Initialization Error 49
[    0.957804] myrb 0000:00:05.0: Failed to initialize Controller
[    0.963581] general protection fault, probably for non-canonical
address 0xdffffc0000000075: 0000 [#1]
[    0.963942] RIP: 0010:kobject_put+0x2f/0x1d0
[    0.963942] Call Trace:
[    0.963942]  <TASK>
[    0.963942]  put_device+0x1b/0x30
[    0.963942]  myrb_probe.cold+0x182/0x12d3

The bug occurs when the driver fails at hw_init() in line 3443 and
then goes to myrb_cleanup(). The panic occurs at scsi_host_put().

Thanks,
Zheyu Ma
