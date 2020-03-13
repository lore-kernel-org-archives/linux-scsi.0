Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD033C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 00:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B622120724
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 00:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U51NKX5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCMAy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 20:54:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35729 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCMAy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 20:54:56 -0400
Received: by mail-vs1-f68.google.com with SMTP id m9so5056494vso.2;
        Thu, 12 Mar 2020 17:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rpSdT3coCHP/ZOncgVyzEi26Ip6gZfmV5Ehd2LJuS98=;
        b=U51NKX5YvgpXhwF3sD8sQdMxvnkeZ8nWJbYaTHy2741bS/1qA1G7qs45vuLdrN0IZJ
         CsWeAyq7LDQ+IlJ2GVfhVk060RH0LDPMSpLgBbT7OI70xEQGzQqNfiUY98fb6xv+o4rX
         pMiLS0f4FA3JkSc+OjoVQYsIlHgLAESMHsE9zWTk5fC6P6RspghhcUtXYQPLQyxWZRIk
         7SFlATZabNF6PXawxPmCvo1uD/AUk/jb+FtZUdyy02v1aD5fs8UvYcR7vUFiHLV0vEUp
         XafsqffAe2Qj4tnGtZZlGgzNhpH2cWMSGAPH6as0WXzdLqib/QauGHV0aPKDIeFNrmK8
         dsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rpSdT3coCHP/ZOncgVyzEi26Ip6gZfmV5Ehd2LJuS98=;
        b=ldLxDuMtQX8qUbE44qSLuex5m2+wQkpPIknP37+qE4n0BZ2xAP92THLctb7vQ5Bda7
         SqbYy9+EHdF/BN2Y7dSNwgeHR/9SCVsVvZ9wsj6Q6VgX7fK+1SGAgH0myuURJkJ8+6XL
         3ewt2ftods+NZ+nVrA44D4l3CV+4z15h1yoNJLhuTkxOLSVvr0wSgHQGfxTVm9sIjjt7
         33Nf4S+gQCdBG3lVgQq773IFajqRNT9jfZ9oiGAcJ2OoyOXL1oHgfL7eI5SC4DcKxots
         vkzq0qEg6djNIMhQvnZPbv/sTQCXKiwatmmx5pWublu43qFg7g+wvNvq2XzxTnmUURmG
         ARRg==
X-Gm-Message-State: ANhLgQ3ZwY0+UD5JtI9blxoLkeiEaRVge7u+uUOLcQq6VXj1i+zOL+d7
        tvSa0yFFqRp/+OGdhcedVK+mfgDDJSMjg26vXA8=
X-Google-Smtp-Source: ADFU+vstfEVVNoaWK6nVnl9WOsHYQYiMsIvEB24vHZ2mqKTMO6kzIQQLjUhLx2U0OlcrMCCjINBAvIyRgYUTUjlPBoU=
X-Received: by 2002:a67:eb91:: with SMTP id e17mr3115816vso.179.1584060893760;
 Thu, 12 Mar 2020 17:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d@epcas5p1.samsung.com>
 <20200306150529.3370-1-alim.akhtar@samsung.com>
In-Reply-To: <20200306150529.3370-1-alim.akhtar@samsung.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 13 Mar 2020 06:24:17 +0530
Message-ID: <CAGOxZ50_XwsQ68gqGf1=S=WJJ-pc10h2_J8B4zzU7OMbgJna9A@mail.gmail.com>
Subject: Re: [PATCH 0/5] exynos-ufs: Add support for UFS HCI
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "robh+dt" <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ping!!!


On Fri, Mar 6, 2020 at 8:40 PM Alim Akhtar <alim.akhtar@samsung.com> wrote:
>
> This patch-set introduces UFS (Universal Flash Storage) host controller support
> for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.
>
> patch 1/5: define devicetree bindings for UFS PHY
> patch 2/5: Adds UFS PHY driver
> patch 3/5: define devicetree bindings for UFS HCI
> patch 4/5: Adds Samsung UFS HCI driver
> patch 5/5: Enabled UFS on exynos7 platform
>
> Note: This series is based on Linux-5.6-rc2
>       In past there was couple of attempt to upstream this driver, but
>       it didn't went upstream for some or other reason.
>
> Alim Akhtar (5):
>   dt-bindings: phy: Document Samsung UFS PHY bindings
>   phy: samsung-ufs: add UFS PHY driver for samsung SoC
>   Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
>     controller
>   scsi: ufs-exynos: add UFS host support for Exynos SoCs
>   arm64: dts: Add node for ufs exynos7
>
>  .../bindings/phy/samsung,ufs-phy.yaml         |   60 +
>  .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
>  .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
>  arch/arm64/boot/dts/exynos/exynos7.dtsi       |   56 +-
>  drivers/phy/samsung/Kconfig                   |    9 +
>  drivers/phy/samsung/Makefile                  |    1 +
>  drivers/phy/samsung/phy-exynos7-ufs.h         |   85 +
>  drivers/phy/samsung/phy-samsung-ufs.c         |  311 ++++
>  drivers/phy/samsung/phy-samsung-ufs.h         |  100 ++
>  drivers/scsi/ufs/Kconfig                      |   12 +
>  drivers/scsi/ufs/Makefile                     |    1 +
>  drivers/scsi/ufs/ufs-exynos.c                 | 1399 +++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h                 |  268 ++++
>  drivers/scsi/ufs/unipro.h                     |   41 +
>  include/linux/phy/phy-samsung-ufs.h           |   70 +
>  15 files changed, 2531 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.h
>  create mode 100644 include/linux/phy/phy-samsung-ufs.h
>
> --
> 2.17.1
>


--
Regards,
Alim
