Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0049C4CECE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 01:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9416B21835
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 01:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKclVLvn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfJOBfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Oct 2019 21:35:33 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37229 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfJOBfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2019 21:35:32 -0400
Received: by mail-io1-f67.google.com with SMTP id b19so42281376iob.4;
        Mon, 14 Oct 2019 18:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMY9A2MWun3N4rIjA8XhC7qKiKrGnVrImDpx4GGsAwM=;
        b=NKclVLvn+bBs5xiuN7LD9CcQuO0U8OPvzkmuBFD1EQI0Y/k8p6R1yLgpLuPo/6vldX
         IzUcWMwd1ydA/ALP4jkud3EvO0PCYjw0GJQ8XlBPRCyMRqHCOO8M6WfOG5MMSdLbMWu6
         XiqAqUal8+s7GmGTfwgePoHg7ub2tw0d7xtC26JUrR6AdXlab/WR2MaRcOYQE+t88oEW
         zHzNa/e5s8kWqt13Lop9Idl+v0esnOJNpPJ2YbevACcdIddPNzehT8P/d3QjqrmUNWdW
         DJwR5yqKF0hSJ+P7yFdeow/55etT51DU9SQzbPSEBS3LvD+zI6juzHOPt9eVPJolzQXR
         jiug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMY9A2MWun3N4rIjA8XhC7qKiKrGnVrImDpx4GGsAwM=;
        b=K84dbuNRqUUfrBqgXZpymrQ0gJCoZhohClfgH4xUteP0jCtlT0T4Xltk8pi3FVHqep
         XIPKGCMcyAQMawES3XwG24NWk7+xUuPHksIjVbfI7jTG1s4oFrgPPZ4iGSThI1SEP+XV
         LCUxQ/fcXaKuSSU48P5/2lTEvpzPu1y6owvYadgf4YkWhoXPnTdNdVUwcZb+r4JugTVQ
         KiFhSxYC610t2t2HFSsH80qWhhA8lETV+ne6DGj9g06DzHMwwV9AlqYQ64xoasNi2gSx
         dc5PdISK/bOA16cXBkL3DBvgWYbKwUfKj9PzaOOvRdwdEGX6irMzwYc88w2MM9YWaLK5
         roZQ==
X-Gm-Message-State: APjAAAVaElNqZHqQ0jL0rcR8bkR5pKk7WkPn7jihk2vLmpMFlCNwoR80
        LD1pVJWnIJ4HTybhZg6VjQDfeV2guN1z1OUR2h0=
X-Google-Smtp-Source: APXvYqz8Ha4k/ZFwcmxeOTXm/19dNF3CDpsOsle/rLaKbW5bnB3IWD8YdYulQnh7zwr5Jy3TUBgfsiWCOwQaltLCFtQ=
X-Received: by 2002:a6b:e813:: with SMTP id f19mr11949466ioh.105.1571103331377;
 Mon, 14 Oct 2019 18:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191010083357.28982-1-vigneshr@ti.com> <20191010083357.28982-3-vigneshr@ti.com>
In-Reply-To: <20191010083357.28982-3-vigneshr@ti.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 15 Oct 2019 07:04:55 +0530
Message-ID: <CAGOxZ51-ds99wNomK3xbws3G9nZgmhyox9k=fKrLmnJL68N2Vw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Add driver for TI wrapper for Cadence
 UFS IP
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nsekhar@ti.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Vignesh

On Thu, Oct 10, 2019 at 2:05 PM Vignesh Raghavendra <vigneshr@ti.com> wrote:
>
> TI's J721e SoC has a Cadence UFS IP with a TI specific wrapper. This is
> a minimal driver to configure the wrapper. It releases the UFS slave
> device out of reset and sets up registers to indicate PHY reference
> clock input frequency before probing child Cadence UFS driver.
>
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> ---
>
> v2: No change
>
>  drivers/scsi/ufs/Kconfig        | 10 ++++
>  drivers/scsi/ufs/Makefile       |  1 +
>  drivers/scsi/ufs/ti-j721e-ufs.c | 90 +++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+)
>  create mode 100644 drivers/scsi/ufs/ti-j721e-ufs.c
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 0b845ab7c3bf..d14c2243e02a 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -132,6 +132,16 @@ config SCSI_UFS_HISI
>           Select this if you have UFS controller on Hisilicon chipset.
>           If unsure, say N.
>
> +config SCSI_UFS_TI_J721E
> +       tristate "TI glue layer for Cadence UFS Controller"
> +       depends on OF && HAS_IOMEM && (ARCH_K3 || COMPILE_TEST)
> +       help
> +         This selects driver for TI glue layer for Cadence UFS Host
> +         Controller IP.
> +
> +         Selects this if you have TI platform with UFS controller.
> +         If unsure, say N.
> +
>  config SCSI_UFS_BSG
>         bool "Universal Flash Storage BSG device node"
>         depends on SCSI_UFSHCD
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 2a9097939bcb..94c6c5d7334b 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>  obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
> +obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
> diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
> new file mode 100644
> index 000000000000..a653bf1902f3
> --- /dev/null
> +++ b/drivers/scsi/ufs/ti-j721e-ufs.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//
> +// Copyright (C) 2019 Texas Instruments Incorporated - http://www.ti.com/
> +//
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#define UFS_SS_CTRL            0x4
> +#define UFS_SS_RST_N_PCS       BIT(0)
> +#define UFS_SS_CLK_26MHZ       BIT(4)
> +
These looks like vendor specific defines, if so, please add TI_* suffix.

> +static int ti_j721e_ufs_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       unsigned long clk_rate;
> +       void __iomem *regbase;
> +       struct clk *clk;
> +       u32 reg = 0;
> +       int ret;
> +
> +       regbase = devm_platform_ioremap_resource(pdev, 0);
> +       if (IS_ERR(regbase))
> +               return PTR_ERR(regbase);
> +
> +       /* Select MPHY refclk frequency */
> +       clk = devm_clk_get(dev, NULL);
> +       if (IS_ERR(clk)) {
> +               dev_err(dev, "Cannot claim MPHY clock.\n");
> +               return PTR_ERR(clk);
> +       }
No need to enable MPHY clock? Moreover this clock belongs to MPHY and
should be handled using generic PHY framework to do that.
> +       clk_rate = clk_get_rate(clk);
> +       if (clk_rate == 26000000)
> +               reg |= UFS_SS_CLK_26MHZ;
> +       devm_clk_put(dev, clk);
> +
Is this only needed to select one bit in UFS_SS_CLK_26MHz? if so, just
have a DT property and get this selection from there.

> +       pm_runtime_enable(dev);
> +       ret = pm_runtime_get_sync(dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(dev);
> +               return ret;
> +       }
> +
> +       /*  Take UFS slave device out of reset */
> +       reg |= UFS_SS_RST_N_PCS;
What is the default value of UFS_SS_CLK_26MHZ bit above? Incase 26MHZ
is not set, then what is default?
> +       writel(reg, regbase + UFS_SS_CTRL);
> +
> +       ret = of_platform_populate(pdev->dev.of_node, NULL, NULL,
> +                                  dev);
> +       if (ret) {
> +               dev_err(dev, "failed to populate child nodes %d\n", ret);
> +               pm_runtime_put_sync(dev);
> +       }
> +
> +       return ret;
> +}
> +
> +static int ti_j721e_ufs_remove(struct platform_device *pdev)
> +{
> +       of_platform_depopulate(&pdev->dev);
> +       pm_runtime_put_sync(&pdev->dev);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id ti_j721e_ufs_of_match[] = {
> +       {
> +               .compatible = "ti,j721e-ufs",
> +       },
> +       { },
> +};
> +
> +static struct platform_driver ti_j721e_ufs_driver = {
> +       .probe  = ti_j721e_ufs_probe,
> +       .remove = ti_j721e_ufs_remove,
> +       .driver = {
> +               .name   = "ti-j721e-ufs",
> +               .of_match_table = ti_j721e_ufs_of_match,
> +       },
> +};
> +module_platform_driver(ti_j721e_ufs_driver);
> +
> +MODULE_AUTHOR("Vignesh Raghavendra <vigneshr@ti.com>");
> +MODULE_DESCRIPTION("TI UFS host controller glue driver");
> +MODULE_LICENSE("GPL v2");
> --
> 2.23.0
>


-- 
Regards,
Alim
