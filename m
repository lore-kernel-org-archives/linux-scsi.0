Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A6EC64E69
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 14:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D66022240
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 14:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgKLOLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:11:13 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33994 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgKLOLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 09:11:11 -0500
Received: by mail-ot1-f67.google.com with SMTP id j14so5694888ots.1;
        Thu, 12 Nov 2020 06:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pQc8/OHqV34abXaKJ3XXkNde3LOGpGHsN/PN8sKy4I=;
        b=Sa31ig72XXOGbwgR8fSlLKy3a7Xhma/pPlnAXunzOg4v7Zl0YDw3zE3hoQDshP16KO
         NcXCXbIpm0CBkzslrxDyZADifH1phcFpAY4dmWXwi99Fuzj+dm4wEivimMw+P9WALiZx
         6WlS8dtbc3BGZwxMjPQJTiqkbIsxKRcSzfidp4/2LEaecRQIjrigGB4mHhjiO6mrRQp9
         v33wgpZthVHosY6y83xK4oL1V2bwc6uClxuXKh/GiJKqvhcA2Xt9x4urGNya/33MhuGm
         bY+FMBTvai6769St1+6wtbUJMDJOYFVY+t/mj4wlox2GXa01lrF/wadMsDhBHN5boO0t
         84lA==
X-Gm-Message-State: AOAM532BO8/M12UMvaKi8PzYlaXk8Q9VklwyxuTntqYLrDYEpBNmNxLn
        9RTeBenUAVKyDnekOb7CplTD04BJ+658iG5hgkQ=
X-Google-Smtp-Source: ABdhPJyR2TQbBtdFO/y9NvrT8p/wU3zUXoqfeH4C3XCOR/as14ULtX2Qjk5+CMvB1IIqdnhuKRwC9q3Pu2MYDAhzJSk=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr5657008oth.250.1605190270725;
 Thu, 12 Nov 2020 06:11:10 -0800 (PST)
MIME-Version: 1.0
References: <20200916084017.14086-1-huobean@gmail.com> <CAMuHMdVZbAZN41jpRrSUD9F+nkgFBTeFoBEu-bumXciT=o4Svw@mail.gmail.com>
In-Reply-To: <CAMuHMdVZbAZN41jpRrSUD9F+nkgFBTeFoBEu-bumXciT=o4Svw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Nov 2020 15:10:59 +0100
Message-ID: <CAMuHMdVwo0Byb3eQ+AhxvXvSN+d88T5NnV5geHgCjjrP6F2ZDw@mail.gmail.com>
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

On Thu, Nov 12, 2020 at 3:06 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Sep 16, 2020 at 10:43 AM Bean Huo <huobean@gmail.com> wrote:
> > From: Bean Huo <beanhuo@micron.com>
> >
> > Use devm_platform_ioremap_resource_byname() to simplify the code.
> >
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
>
> Thanks for your patch, which is now commit 2dd39fad92a1f25f ("scsi: ufs:
> ufs-exynos: Use devm_platform_ioremap_resource_byname()") in v5.10-rc1.
>
> > --- a/drivers/scsi/ufs/ufs-exynos.c
> > +++ b/drivers/scsi/ufs/ufs-exynos.c
> > @@ -940,7 +940,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
> >         struct device *dev = hba->dev;
> >         struct platform_device *pdev = to_platform_device(dev);
> >         struct exynos_ufs *ufs;
> > -       struct resource *res;
> >         int ret;
> >
> >         ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> > @@ -948,24 +947,21 @@ static int exynos_ufs_init(struct ufs_hba *hba)
> >                 return -ENOMEM;
> >
> >         /* exynos-specific hci */
> > -       res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vs_hci");
> > -       ufs->reg_hci = devm_ioremap_resource(dev, res);
> > +       ufs->reg_hci = devm_platform_ioremap_resource_byname(pdev, "vs_hci");
>
> Are you sure this is equivalent?
> Before, devm_ioremap_resource() was called on "dev" (hba->dev),
> after it is called on "&pdev->dev" .

Yes it is, due to:

    struct platform_device *pdev = to_platform_device(dev);

Sorry for the noise.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
