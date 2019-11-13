Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBEFC17440
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B7852067B
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DX/94/Dx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfKMCXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:23:50 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36048 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbfKMBwV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 20:52:21 -0500
Received: by mail-io1-f67.google.com with SMTP id s3so714731ioe.3;
        Tue, 12 Nov 2019 17:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VRa2p2uVA7mOe9eR+tZyl9qxFDNknjRkbjM2+ZG8/g=;
        b=DX/94/DxWwYaTp0UKS930L2xgAW1C6/s5Zao/F5UkmMRpkufMFlm3E0TItLjrFy7FT
         AdeLAL8qmrU1fh8BwzUhqIDSmsG0Yb6xzf2K6FSJec5tbSJRKHpXxoAjZ9trGmaC7YYN
         WCtRnrW1cHF/IP52b68DxJIP44iOzv7TH5Ova8UZzGUV9XBxHzS3PwLkreauXeV3UUmS
         Rhv0nGIPWb20nHvfQgOsq5O8VcijVhaEGQgqBKdUwr7ioxTm77yGiCeieRExK04D6GmO
         UOPqkgRn4x0BZnvAIeMkdwiWDn+OJR6IN2HVdorKSTTdRZthZeohheY4IOKoLmBomsqW
         9e1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VRa2p2uVA7mOe9eR+tZyl9qxFDNknjRkbjM2+ZG8/g=;
        b=QG2WbDZn09jN0LPK4K6WUZDu9zZDXhmmNgadRCwVNdNLnIH9AVywszbdE+ytHdjaim
         7iD4ZQeTdyceZWxjZt83I8vTSZtiC6bLGkD//ynTm7Z1P0m08YUuqChSb1WNcGuHkPzn
         2AU+ckWyDTbX7X/4AJKv2lrg9pCkHjb4TpynCxIsw4ISh4Z1frD/bQ8PZIPNBOk+CoZM
         vfco7u6H2fVUBZ8tSqVi6HdbbfsT2uOPDEdoQ9jrXoOBaxW8q7PHMwLDExJXXmB6Dyoo
         VwkoFP2+p4bOzNVONjZttX7TE3/eW2OH2SWwkg0jNDNEHNOB5M5RSM5D/bQwc79HfPKZ
         1TWA==
X-Gm-Message-State: APjAAAUiPkdt/ypHX4JpvoV1pj+sEdvrOqycJZLBMbKC/pqIB3wEBMed
        W96VlMxR/Ke8iESqQv6n+kP8q543v6wZKt6JaMA=
X-Google-Smtp-Source: APXvYqwMd8Urg3MvqLQzocQPrnCFpakQXd+ZDVh0NDjIQD5raobJsT1r9TH1o9QPPti9oFdXfY56Xq86x9avR45gooo=
X-Received: by 2002:a5d:8591:: with SMTP id f17mr963879ioj.198.1573609939605;
 Tue, 12 Nov 2019 17:52:19 -0800 (PST)
MIME-Version: 1.0
References: <20191108164857.11466-1-vigneshr@ti.com> <20191108164857.11466-3-vigneshr@ti.com>
In-Reply-To: <20191108164857.11466-3-vigneshr@ti.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 13 Nov 2019 07:21:39 +0530
Message-ID: <CAGOxZ50OqMYWs+j37=U9r0URQmTK_jxcsor8PejhEVVOXWq4Ww@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add driver for TI wrapper for Cadence
 UFS IP
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Vignesh

On Fri, Nov 8, 2019 at 10:20 PM Vignesh Raghavendra <vigneshr@ti.com> wrote:
>
> TI's J721e SoC has a Cadence UFS IP with a TI specific wrapper. This is
> a minimal driver to configure the wrapper. It releases the UFS slave
> device out of reset and sets up registers to indicate PHY reference
> clock input frequency before probing child Cadence UFS driver.
>
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
>
> v3:
> Fix macros to have TI_* prefix
>
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
> index 000000000000..5216d228cdd9
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
> +#define TI_UFS_SS_CTRL         0x4
> +#define TI_UFS_SS_RST_N_PCS    BIT(0)
> +#define TI_UFS_SS_CLK_26MHZ    BIT(4)
> +
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
> +       pm_runtime_enable(dev);
> +       ret = pm_runtime_get_sync(dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(dev);
> +               return ret;
> +       }
> +
> +       /* Select MPHY refclk frequency */
> +       clk = devm_clk_get(dev, NULL);
> +       if (IS_ERR(clk)) {
> +               dev_err(dev, "Cannot claim MPHY clock.\n");
> +               return PTR_ERR(clk);
> +       }
> +       clk_rate = clk_get_rate(clk);
> +       if (clk_rate == 26000000)
> +               reg |= TI_UFS_SS_CLK_26MHZ;
> +       devm_clk_put(dev, clk);
> +
> +       /*  Take UFS slave device out of reset */
> +       reg |= TI_UFS_SS_RST_N_PCS;
> +       writel(reg, regbase + TI_UFS_SS_CTRL);
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
> 2.24.0
>


-- 
Regards,
Alim
