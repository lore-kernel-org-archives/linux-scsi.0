Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799B4C4CECE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FDBE2074B
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584087840;
	bh=ETyKrmP0hGRDdxES6XCncS3YWPghJvpIb0l2B7LnEqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mghe5f+nPbfGDkiXtiPuIh0Ch4UOL0TKPhhTZPgKaQpGutYvoC5PNXgKx5pGHVqIi
	 onsqqC20t7XDSGHKjIvOfdgXJAxlEd5be9hi284mSHDWOYBELFC3+env1SPjqyLggR
	 1mKRT4565Fx0H/ajcKCYnYXy3L1mDUghbt0bAUaw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCMIX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 04:23:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33260 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgCMIX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 04:23:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id z65so10906380ede.0;
        Fri, 13 Mar 2020 01:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4tR4fgeFAv7oNvf3SR9Y+PFPOqEFlOUKa/4AnEg5Ajc=;
        b=lPnKSzEIuQVqXhQnKtAbEt+yIyxl5IuPZOnlE67J7SO9QzsxMklKlQyoLEzzIZdOtY
         7co7Dz0V/7gt3xAXjaHKtERQI85u/4ikQX8ClUk8RbU7nnZtoXx/LfoJ8zXDGpcNW/yw
         XnuVIEwAb6p0CuBwGGdjzxpPL8VQKwL4E6do2ZOnboQ5bvwJnQ2RCAbKyiMmb7UVx3Hx
         OherazbC1cnS3XAjTJhchGuAvheF6SEi5EeRdI+b2xDKkmMfRUt7PcfKHeCxNUK4vYjg
         2oW4ARz3j/FWsdvLoLN+3nXmfhRiO8nxCkGAJeafQyhCwSU3YrpKBW8rgdj38MO/gsrD
         d+yA==
X-Gm-Message-State: ANhLgQ3Q300fru7nTNjXRiP+Yd3VpR4Q9uSuinKyAMXSLAvVqoVvk0bo
        EnItPK+h3McFLd1/JVxWAyM=
X-Google-Smtp-Source: ADFU+vtDIGMumVvwsMfchwX0nbGRN7NDG8oDGe83g2SJLn6cIBS7QBe76XzUd1cuNOlmNMvjAs4hEw==
X-Received: by 2002:a17:906:689:: with SMTP id u9mr10624912ejb.78.1584087837029;
        Fri, 13 Mar 2020 01:23:57 -0700 (PDT)
Received: from pi3 ([194.230.155.125])
        by smtp.googlemail.com with ESMTPSA id ck21sm1816975ejb.51.2020.03.13.01.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 01:23:56 -0700 (PDT)
Date:   Fri, 13 Mar 2020 09:23:54 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        robh+dt <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH 0/5] exynos-ufs: Add support for UFS HCI
Message-ID: <20200313082354.GA7381@pi3>
References: <CGME20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d@epcas5p1.samsung.com>
 <20200306150529.3370-1-alim.akhtar@samsung.com>
 <CAGOxZ50_XwsQ68gqGf1=S=WJJ-pc10h2_J8B4zzU7OMbgJna9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGOxZ50_XwsQ68gqGf1=S=WJJ-pc10h2_J8B4zzU7OMbgJna9A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 13, 2020 at 06:24:17AM +0530, Alim Akhtar wrote:
> Ping!!!

Hi,

Please use the get_maintainers script to get list of Cc addresses. The
DTS patch for example misses the samsung-soc mailing list therefore it
is not in the patchwork. Patches to ARM/ARM64 Samsung SoC tree go from
patchwork:
https://patchwork.kernel.org/project/linux-samsung-soc/list/

Best regards,
Krzysztof

> 
> 
> On Fri, Mar 6, 2020 at 8:40 PM Alim Akhtar <alim.akhtar@samsung.com> wrote:
> >
> > This patch-set introduces UFS (Universal Flash Storage) host controller support
> > for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.
> >
> > patch 1/5: define devicetree bindings for UFS PHY
> > patch 2/5: Adds UFS PHY driver
> > patch 3/5: define devicetree bindings for UFS HCI
> > patch 4/5: Adds Samsung UFS HCI driver
> > patch 5/5: Enabled UFS on exynos7 platform
> >
> > Note: This series is based on Linux-5.6-rc2
> >       In past there was couple of attempt to upstream this driver, but
> >       it didn't went upstream for some or other reason.
> >
> > Alim Akhtar (5):
> >   dt-bindings: phy: Document Samsung UFS PHY bindings
> >   phy: samsung-ufs: add UFS PHY driver for samsung SoC
> >   Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
> >     controller
> >   scsi: ufs-exynos: add UFS host support for Exynos SoCs
> >   arm64: dts: Add node for ufs exynos7
> >
> >  .../bindings/phy/samsung,ufs-phy.yaml         |   60 +
> >  .../devicetree/bindings/ufs/ufs-exynos.txt    |  104 ++
> >  .../boot/dts/exynos/exynos7-espresso.dts      |   16 +
> >  arch/arm64/boot/dts/exynos/exynos7.dtsi       |   56 +-
> >  drivers/phy/samsung/Kconfig                   |    9 +
> >  drivers/phy/samsung/Makefile                  |    1 +
> >  drivers/phy/samsung/phy-exynos7-ufs.h         |   85 +
> >  drivers/phy/samsung/phy-samsung-ufs.c         |  311 ++++
> >  drivers/phy/samsung/phy-samsung-ufs.h         |  100 ++
> >  drivers/scsi/ufs/Kconfig                      |   12 +
> >  drivers/scsi/ufs/Makefile                     |    1 +
> >  drivers/scsi/ufs/ufs-exynos.c                 | 1399 +++++++++++++++++
> >  drivers/scsi/ufs/ufs-exynos.h                 |  268 ++++
> >  drivers/scsi/ufs/unipro.h                     |   41 +
> >  include/linux/phy/phy-samsung-ufs.h           |   70 +
> >  15 files changed, 2531 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> >  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> >  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
> >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
> >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
> >  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
> >  create mode 100644 drivers/scsi/ufs/ufs-exynos.h
> >  create mode 100644 include/linux/phy/phy-samsung-ufs.h
> >
> > --
> > 2.17.1
> >
> 
> 
> --
> Regards,
> Alim
