Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3C7C5519F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 14:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E66121D40
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 14:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgKLOGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:06:30 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45191 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727934AbgKLOGa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 09:06:30 -0500
Received: by mail-oi1-f193.google.com with SMTP id j7so6445397oie.12;
        Thu, 12 Nov 2020 06:06:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGu5oH3VQ7eWe40maLCTjTDEjDF7H6L/YZ+Yi4SWhhQ=;
        b=Gyn/deUUNTYGJ9B3FSwO82A+M06DRLVxBoeYtbU2got9/XWEEXo1rbtwDnp56egkhk
         5FtfiQcq+em441kQWLa0yCOOMqVYsYcclQEL1ccB10EisR0+Yhu3KM9wCIc/tiBsxn0l
         pYwDmPXi8SkyvSA8P1yLtWo4HGpN+KO9ptsOAV2ugLlYSJFn7Bgqeqolowk1+9Z+K+Ow
         AGfQ2IlEE/L+Cyxmp7Nv9Y3982/W4vcMJU6Wz4lfpiQOLCJTS78ES/OTX+I+stXRMlcn
         +1uoap5s0ieLvDW/y2ztQzHTNjnoQeC/J0zgQiJMYYAXTntphmEAt57ipWYP9Q42+IoT
         X7fg==
X-Gm-Message-State: AOAM532wbFxDiaStue+eLjTdyWm6MVevdNYWIr0sLcN0uHKrgdyCNRUF
        u6UE7T/yk/cxBqh8DkfgFsF8mILD8aeZ7aUMptw=
X-Google-Smtp-Source: ABdhPJxpCp2qCzeHMj+SzRZmg2+cyQ0fJmsK4ddq2wFUq7KoWV5tdQEVQBG+ypkDNCW7qxO048aLaKhEEYd8bC/QY9U=
X-Received: by 2002:aca:52c9:: with SMTP id g192mr5844659oib.54.1605189987900;
 Thu, 12 Nov 2020 06:06:27 -0800 (PST)
MIME-Version: 1.0
References: <20200916084017.14086-1-huobean@gmail.com>
In-Reply-To: <20200916084017.14086-1-huobean@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Nov 2020 15:06:16 +0100
Message-ID: <CAMuHMdVZbAZN41jpRrSUD9F+nkgFBTeFoBEu-bumXciT=o4Svw@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: ufs-exynos: use devm_platform_ioremap_resource_byname()
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        stanley.chu@mediatek.com,
        =?UTF-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
        <beanhuo@micron.com>, Bart Van Assche <bvanassche@acm.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>, cang@codeaurora.org,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On Wed, Sep 16, 2020 at 10:43 AM Bean Huo <huobean@gmail.com> wrote:
> From: Bean Huo <beanhuo@micron.com>
>
> Use devm_platform_ioremap_resource_byname() to simplify the code.
>
> Signed-off-by: Bean Huo <beanhuo@micron.com>

Thanks for your patch, which is now commit 2dd39fad92a1f25f ("scsi: ufs:
ufs-exynos: Use devm_platform_ioremap_resource_byname()") in v5.10-rc1.

> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -940,7 +940,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>         struct device *dev = hba->dev;
>         struct platform_device *pdev = to_platform_device(dev);
>         struct exynos_ufs *ufs;
> -       struct resource *res;
>         int ret;
>
>         ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> @@ -948,24 +947,21 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>                 return -ENOMEM;
>
>         /* exynos-specific hci */
> -       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vs_hci");
> -       ufs->reg_hci = devm_ioremap_resource(dev, res);
> +       ufs->reg_hci = devm_platform_ioremap_resource_byname(pdev, "vs_hci");

Are you sure this is equivalent?
Before, devm_ioremap_resource() was called on "dev" (hba->dev),
after it is called on "&pdev->dev" .

>         if (IS_ERR(ufs->reg_hci)) {
>                 dev_err(dev, "cannot ioremap for hci vendor register\n");
>                 return PTR_ERR(ufs->reg_hci);
>         }
>
>         /* unipro */
> -       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "unipro");
> -       ufs->reg_unipro = devm_ioremap_resource(dev, res);
> +       ufs->reg_unipro = devm_platform_ioremap_resource_byname(pdev, "unipro");
>         if (IS_ERR(ufs->reg_unipro)) {
>                 dev_err(dev, "cannot ioremap for unipro register\n");
>                 return PTR_ERR(ufs->reg_unipro);
>         }
>
>         /* ufs protector */
> -       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ufsp");
> -       ufs->reg_ufsp = devm_ioremap_resource(dev, res);
> +       ufs->reg_ufsp = devm_platform_ioremap_resource_byname(pdev, "ufsp");
>         if (IS_ERR(ufs->reg_ufsp)) {
>                 dev_err(dev, "cannot ioremap for ufs protector register\n");
>                 return PTR_ERR(ufs->reg_ufsp);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
