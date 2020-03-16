Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7392CC1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 05:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424F020722
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 05:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jUfBYnlR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgCPFhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 01:37:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11273 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729719AbgCPFhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 01:37:00 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200316053655epoutp01d4ecaad51c22145620730ff93b028fbb~8sh8fYnok3220532205epoutp01x
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2020 05:36:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200316053655epoutp01d4ecaad51c22145620730ff93b028fbb~8sh8fYnok3220532205epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584337015;
        bh=NrrCuwosQQVNwkfxLmDklEPtN6ZOW0YcSOJ7CO0FKEk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=jUfBYnlR0M5hnYTGHXRvPRIutql3PhDLdc+MY3R2TNI4hE1eWq9tY6qiJ3C+2UDdb
         rzKG0KigozeWWOTFjYuRK+B8cfrBHhSJytqSiRTYAeDKT/Soz2b80FGsoJlFabOns4
         SfpuuAM3Qnr59ysw8JbAZTJpHUSX1mRbizD+mDDg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200316053655epcas2p4b66c24138ccccbf92c3789fcf8bbe7ee~8sh8GVdYg0169901699epcas2p4m;
        Mon, 16 Mar 2020 05:36:55 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 48glRS5rSvzMqYm3; Mon, 16 Mar
        2020 05:36:52 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.61.04105.4701F6E5; Mon, 16 Mar 2020 14:36:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200316053651epcas2p30661f8514a31eb35a5c30e40de51a017~8sh46ekSZ2005820058epcas2p3T;
        Mon, 16 Mar 2020 05:36:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200316053651epsmtrp16be58fc8361ba9fdb93a42d979ec892e~8sh45aI4m1463514635epsmtrp1N;
        Mon, 16 Mar 2020 05:36:51 +0000 (GMT)
X-AuditID: b6c32a47-15bff70000001009-3c-5e6f107429fa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.89.04024.3701F6E5; Mon, 16 Mar 2020 14:36:51 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200316053651epsmtip26ec8128a9b04e2e0a7139fb6971cad3b~8sh4qtmGN1257012570epsmtip2s;
        Mon, 16 Mar 2020 05:36:51 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Alim Akhtar'" <alim.akhtar@samsung.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <cpgs@samsung.com>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <cang@codeaurora.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
In-Reply-To: <20200306150529.3370-3-alim.akhtar@samsung.com>
Subject: RE: [PATCH 2/5] phy: samsung-ufs: add UFS PHY driver for samsung
 SoC
Date:   Mon, 16 Mar 2020 14:36:51 +0900
Message-ID: <000001d5fb54$e5139c70$af3ad550$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGcomJoogAapdSxIIuFJfiljU0eNAHRmbrXAkKAqlSonMQToA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmmW6JQH6cwZvPXBYP5m1js3j58yqb
        xaf1y1gtXh7StJh/5ByrxYWnPWwW589vYLfovr6DzWL58X9MFq17j7A7cHlc7utl8ti0qpPN
        4+PTWywefVtWMXocv7GdyePzJjmP9gPdTAHsUTk2GamJKalFCql5yfkpmXnptkrewfHO8aZm
        Boa6hpYW5koKeYm5qbZKLj4Bum6ZOUDnKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVIL
        UnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjJ6d/9hKji1hLGi6U9GA+OlNsYuRk4OCQET
        ianXXrGB2EICOxglJmzM72LkArI/MUr8vnuVCSLxjVHi511nmIbTl56yQxTtZZRonHCOFcJ5
        wSix8HQDK0gVm4C2xLSHu8FsEYHpjBK9RxxBipgF+hklHmxaCLaPU8BG4syRpywgtrCAv0T/
        l1lg61gEVCW2324EWsHBwStgKbH/YiRImFdAUOLkzCdg5cwC8hLb385hhrhIQeLn02VQu5wk
        vjT8hqoRkZjd2cYMsldCoJ9donfWFRaIBheJ238XQv0vLPHq+BZ2CFtK4mV/G5RdL7FvagMr
        RHMPo8TTff+gGowlZj1rZwQ5jllAU2L9Ln0QU0JAWeLILajxvBING3+zQ9zAJ9Fx+C87RAmv
        REebEESJssSvSZMZJzAqz0Ly2Swkn81C8sEshF0LGFlWMYqlFhTnpqcWGxUYI0f2JkZw0tVy
        38G47ZzPIUYBDkYlHl6JtLw4IdbEsuLK3EOMEhzMSiK8HTXZcUK8KYmVValF+fFFpTmpxYcY
        TYHhPpFZSjQ5H5gR8kriDU2NzMwMLE0tTM2MLJTEeTdx34wREkhPLEnNTk0tSC2C6WPi4JRq
        YDx++/9ThRn/7osZm+5Y1rvQUWO//MeXSyd4c4ZatnD8urgxfMXm6WLbzltpaziHKDAVZHJE
        etyyvsM708Rp7xFnRWNv5Sxb53nGFRYttvKHnmfmZS9nuB/xTIxp2lNvPodF2/jPNPx1FFp0
        6nLUhx1nJh2RXvr+UcnVa4eZVzPMv5ouoalvYKHEUpyRaKjFXFScCAC1Eg6p0AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSvG6xQH6cQf8HbYsH87axWbz8eZXN
        4tP6ZawWLw9pWsw/co7V4sLTHjaL8+c3sFt0X9/BZrH8+D8mi9a9R9gduDwu9/UyeWxa1cnm
        8fHpLRaPvi2rGD2O39jO5PF5k5xH+4FupgD2KC6blNSczLLUIn27BK6M3t1/mApOLWGsaPqT
        0cB4qY2xi5GTQ0LAROL0pafsXYxcHEICuxkltjxcwgqRkJQ4sfM5VJGwxP2WI6wQRc8YJeZO
        fc8MkmAT0JaY9nA3WIOIwGxGiVV9BiBFzAJTGSWOb7oE1bGXUeLjtF1MIFWcAjYSZ448ZQGx
        hQV8JZoe3wJbwSKgKrH9diPQHRwcvAKWEvsvRoKEeQUEJU7OfAJWzgy07OnNp1C2vMT2t3OY
        Ia5TkPj5dBnUEU4SXxp+Q9WISMzubGOewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sN
        CwzzUsv1ihNzi0vz0vWS83M3MYJjUEtzB+PlJfGHGAU4GJV4eCXS8uKEWBPLiitzDzFKcDAr
        ifB21GTHCfGmJFZWpRblxxeV5qQWH2KU5mBREud9mncsUkggPbEkNTs1tSC1CCbLxMEp1cCo
        fmjbQ/1pWg94trsuF114IcLTSmTG2l8qC4M+eO88xMD8cUH4ylu7b+Z95NFawnfq0im2T69+
        cu631nNjmVj7bOfkC69+F+QoMBjK5vd9+z3bXz5Odae4Y801raV84tpvXh2xcLmd0fLunPTH
        jdouFRcS7cvuLUv7a6Qnp6pxbv+NaotQn4pUJZbijERDLeai4kQAFn5Zm70CAAA=
X-CMS-MailID: 20200316053651epcas2p30661f8514a31eb35a5c30e40de51a017
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200306151023epcas5p40179ecb7edaea3357c9d652553075b8d
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151023epcas5p40179ecb7edaea3357c9d652553075b8d@epcas5p4.samsung.com>
        <20200306150529.3370-3-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Alim Akhtar <alim.akhtar@samsung.com>
> Sent: Saturday, March 7, 2020 12:05 AM
> To: robh+dt@kernel.org; devicetree@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Cc: krzk@kernel.org; avri.altman@wdc.com; martin.petersen@oracle.com;
> kwmad.kim@samsung.com; stanley.chu@mediatek.com; cang@codeaurora.org; Alim
> Akhtar <alim.akhtar@samsung.com>; Kishon Vijay Abraham I <kishon@ti.com>
> Subject: [PATCH 2/5] phy: samsung-ufs: add UFS PHY driver for samsung SoC
> 
> This patch introduces Samsung UFS PHY driver. This driver supports to deal
> with phy calibration and power control according to UFS host driver's
> behavior.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/samsung/Kconfig           |   9 +
>  drivers/phy/samsung/Makefile          |   1 +
>  drivers/phy/samsung/phy-exynos7-ufs.h |  85 +++++++
> drivers/phy/samsung/phy-samsung-ufs.c | 311 ++++++++++++++++++++++++++
> drivers/phy/samsung/phy-samsung-ufs.h | 100 +++++++++
>  include/linux/phy/phy-samsung-ufs.h   |  70 ++++++
>  6 files changed, 576 insertions(+)
>  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
>  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
>  create mode 100644 include/linux/phy/phy-samsung-ufs.h
> 
> diff --git a/drivers/phy/samsung/Kconfig b/drivers/phy/samsung/Kconfig
> index 9e483d1fdaf2..fc1e3c17f842 100644
> --- a/drivers/phy/samsung/Kconfig
> +++ b/drivers/phy/samsung/Kconfig
> @@ -29,6 +29,15 @@ config PHY_EXYNOS_PCIE
>  	  Enable PCIe PHY support for Exynos SoC series.
>  	  This driver provides PHY interface for Exynos PCIe controller.
> 
> +config PHY_SAMSUNG_UFS
> +	tristate "SAMSUNG SoC series UFS PHY driver"
> +	depends on OF && (ARCH_EXYNOS || COMPILE_TEST)
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the Samsung UFS PHY driver for
> +	  Samsung SoCs. This driver provides the interface for UFS
> +	  host controller to do PHY related programming.
> +
>  config PHY_SAMSUNG_USB2
>  	tristate "Samsung USB 2.0 PHY driver"
>  	depends on HAS_IOMEM
> diff --git a/drivers/phy/samsung/Makefile b/drivers/phy/samsung/Makefile
> index db9b1aa0de6e..3959100fe8a2 100644
> --- a/drivers/phy/samsung/Makefile
> +++ b/drivers/phy/samsung/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_EXYNOS_PCIE)		+= phy-exynos-pcie.o
> +obj-$(CONFIG_PHY_SAMSUNG_UFS)		+= phy-samsung-ufs.o
>  obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
>  phy-exynos-usb2-y			+= phy-samsung-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
> diff --git a/drivers/phy/samsung/phy-exynos7-ufs.h
> b/drivers/phy/samsung/phy-exynos7-ufs.h
> new file mode 100644
> index 000000000000..da981c1ac040
> --- /dev/null
> +++ b/drivers/phy/samsung/phy-exynos7-ufs.h
> @@ -0,0 +1,85 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * UFS PHY driver data for Samsung EXYNOS7 SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + */
> +#ifndef _PHY_EXYNOS7_UFS_H_
> +#define _PHY_EXYNOS7_UFS_H_
> +
> +#include "phy-samsung-ufs.h"
> +
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL	0x720
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
> +#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
> +
> +/* Calibration for phy initialization */ static const struct
> +samsung_ufs_phy_cfg exynos7_pre_init_cfg[] = {
> +	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_ANY),
> +	PHY_COMN_REG_CFG(0x017, 0x84, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x035, 0x58, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x037, 0x40, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x03b, 0x83, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x04c, 0x5b, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_ANY),
> +	PHY_TRSV_REG_CFG(0x05c, 0x14, PWR_MODE_ANY),
> +	END_UFS_PHY_CFG
> +};
> +
> +static const struct samsung_ufs_phy_cfg exynos7_post_init_cfg[] = {
> +	END_UFS_PHY_CFG
> +};
> +
> +/* Calibration for HS mode series A/B */ static const struct
> +samsung_ufs_phy_cfg exynos7_pre_pwr_hs_cfg[] = {
> +	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_HS_ANY),
> +	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_HS_ANY),
> +	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_HS_ANY),
> +	/* Setting order: 1st(0x16, 2nd(0x15) */
> +	PHY_COMN_REG_CFG(0x016, 0xff, PWR_MODE_HS_ANY),
> +	PHY_COMN_REG_CFG(0x015, 0x80, PWR_MODE_HS_ANY),
> +	PHY_COMN_REG_CFG(0x017, 0x94, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x037, 0x43, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x038, 0x3f, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_HS_G2_SER_A),
> +	PHY_TRSV_REG_CFG(0x042, 0xbb, PWR_MODE_HS_G2_SER_B),
> +	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x034, 0x35, PWR_MODE_HS_G2_SER_A),
> +	PHY_TRSV_REG_CFG(0x034, 0x36, PWR_MODE_HS_G2_SER_B),
> +	PHY_TRSV_REG_CFG(0x035, 0x5b, PWR_MODE_HS_G2_SER_A),
> +	PHY_TRSV_REG_CFG(0x035, 0x5c, PWR_MODE_HS_G2_SER_B),
> +	END_UFS_PHY_CFG
> +};
> +
> +/* Calibration for HS mode series A/B atfer PMC */ static const struct
> +samsung_ufs_phy_cfg exynos7_post_pwr_hs_cfg[] = {
> +	PHY_COMN_REG_CFG(0x015, 0x00, PWR_MODE_HS_ANY),
> +	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_HS_ANY),
> +	END_UFS_PHY_CFG
> +};
> +
> +static const struct samsung_ufs_phy_cfg *exynos7_ufs_phy_cfgs[CFG_TAG_MAX]
> = {
> +	[CFG_PRE_INIT]		= exynos7_pre_init_cfg,
> +	[CFG_POST_INIT]		= exynos7_post_init_cfg,
> +	[CFG_PRE_PWR_HS]	= exynos7_pre_pwr_hs_cfg,
> +	[CFG_POST_PWR_HS]	= exynos7_post_pwr_hs_cfg,
> +};
> +
> +static struct samsung_ufs_phy_drvdata exynos7_ufs_phy = {
> +	.cfg = exynos7_ufs_phy_cfgs,
> +	.isol = {
> +		.offset = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL,
> +		.mask = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK,
> +		.en = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN,
> +	},
> +};
> +
> +#endif /* _PHY_EXYNOS7_UFS_H_ */
> diff --git a/drivers/phy/samsung/phy-samsung-ufs.c
> b/drivers/phy/samsung/phy-samsung-ufs.c
> new file mode 100644
> index 000000000000..2d5db24de49b
> --- /dev/null
> +++ b/drivers/phy/samsung/phy-samsung-ufs.c
> @@ -0,0 +1,311 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * UFS PHY driver for Samsung SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + * Author: Seungwon Jeon <essuuj@gmail.com>
> + * Author: Alim Akhtar <alim.akhtar@samsung.com>
> + *
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-samsung-ufs.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +
> +#include "phy-samsung-ufs.h"
> +
> +#define for_each_phy_lane(phy, i) \
> +	for (i = 0; i < (phy)->lane_cnt; i++)
> +#define for_each_phy_cfg(cfg) \
> +	for (; (cfg)->id; (cfg)++)
> +
> +#define PHY_DEF_LANE_CNT	1
> +
> +static void samsung_ufs_phy_config(struct samsung_ufs_phy *phy,
> +			const struct samsung_ufs_phy_cfg *cfg, u8 lane) {
> +	enum {LANE_0, LANE_1}; /* lane index */
> +
> +	switch (lane) {
> +	case LANE_0:
> +		writel(cfg->val, (phy)->reg_pma + cfg->off_0);
> +		break;
> +	case LANE_1:
> +		if (cfg->id == PHY_TRSV_BLK)
> +			writel(cfg->val, (phy)->reg_pma + cfg->off_1);
> +		break;
> +	}
> +}
> +
> +int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy) {
> +	struct samsung_ufs_phy *ufs_phy = get_samsung_ufs_phy(phy);
> +	const unsigned int timeout_us = 100000;
> +	const unsigned int sleep_us = 10;
> +	u32 val;
> +	int err;
> +
> +	err = readl_poll_timeout(
> +			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
> +			val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
> +	if (err) {
> +		dev_err(ufs_phy->dev,
> +			"failed to get phy pll lock acquisition %d\n", err);
> +		goto out;
> +	}
> +
> +	err = readl_poll_timeout(
> +			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
> +			val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
> +	if (err) {
> +		dev_err(ufs_phy->dev,
> +			"failed to get phy cdr lock acquisition %d\n", err);
> +		goto out;
> +	}
> +
> +out:
> +	return err;
> +}
> +
> +int samsung_ufs_phy_calibrate(struct phy *phy) {
> +	struct samsung_ufs_phy *ufs_phy = get_samsung_ufs_phy(phy);
> +	struct samsung_ufs_phy_cfg **cfgs = ufs_phy->cfg;
> +	const struct samsung_ufs_phy_cfg *cfg;
> +	int i;
> +	int err = 0;
> +
> +	if (unlikely(ufs_phy->ufs_phy_state < CFG_PRE_INIT ||
> +		     ufs_phy->ufs_phy_state >= CFG_TAG_MAX)) {
> +		dev_err(ufs_phy->dev, "invalid phy config index %d\n",
> +							ufs_phy->ufs_phy_state);
> +		return -EINVAL;
> +	}
> +
> +	if (ufs_phy->is_pre_init)
> +		ufs_phy->is_pre_init = false;
> +	if (ufs_phy->is_post_init) {
> +		ufs_phy->is_post_init = false;
> +		ufs_phy->ufs_phy_state = CFG_POST_INIT;
> +	}
> +	if (ufs_phy->is_pre_pmc) {
> +		ufs_phy->is_pre_pmc = false;
> +		ufs_phy->ufs_phy_state = CFG_PRE_PWR_HS;
> +	}
> +	if (ufs_phy->is_post_pmc) {
> +		ufs_phy->is_post_pmc = false;
> +		ufs_phy->ufs_phy_state = CFG_POST_PWR_HS;
> +	}
> +
> +	switch (ufs_phy->ufs_phy_state) {
> +	case CFG_PRE_INIT:
> +		ufs_phy->is_post_init = true;
> +		break;
> +	case CFG_POST_INIT:
> +		ufs_phy->is_pre_pmc = true;
> +		break;
> +	case CFG_PRE_PWR_HS:
> +		ufs_phy->is_post_pmc = true;
> +		break;
> +	case CFG_POST_PWR_HS:
> +		break;
> +	default:
> +		dev_err(ufs_phy->dev, "wrong state for phy calibration\n");
> +	}
> +
> +	cfg = cfgs[ufs_phy->ufs_phy_state];
> +	if (!cfg)
> +		goto out;
> +
> +	for_each_phy_cfg(cfg) {
> +		for_each_phy_lane(ufs_phy, i) {
> +			samsung_ufs_phy_config(ufs_phy, cfg, i);
> +		}
> +	}
> +
> +	if (ufs_phy->ufs_phy_state == CFG_POST_PWR_HS)
> +		err = samsung_ufs_phy_wait_for_lock_acq(phy);
> +out:
> +	return err;
> +}
> +
> +static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy) {
> +	struct clk *child, *parent;
> +
> +	child = devm_clk_get(phy->dev, "ref_clk");
> +	if (IS_ERR(child))
> +		dev_err(phy->dev, "failed to get ref_clk clock\n");
> +	else
> +		phy->ref_clk = child;
> +
> +	parent = devm_clk_get(phy->dev, "ref_clk_parent");
> +	if (IS_ERR(parent))
> +		dev_err(phy->dev, "failed to get ref_clk_parent clock\n");
> +	else
> +		phy->ref_clk_parent = parent;
> +
> +	return clk_set_parent(child, parent);
> +}
> +
> +static int samsung_ufs_phy_init(struct phy *phy) {
> +	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
> +
> +	_phy->lane_cnt = phy->attrs.bus_width;
> +	_phy->ufs_phy_state = CFG_PRE_INIT;
> +
> +	_phy->is_pre_init = true;
> +	_phy->is_post_init = false;
> +	_phy->is_pre_pmc = false;
> +	_phy->is_post_pmc = false;
> +
> +	samsung_ufs_phy_clks_init(_phy);
> +
> +	samsung_ufs_phy_calibrate(phy);
> +
> +	return 0;
> +}
> +
> +static int samsung_ufs_phy_power_on(struct phy *phy) {
> +	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
> +	int ret;
> +
> +	ret = clk_prepare_enable(_phy->ref_clk);
> +	if (ret) {
> +		dev_err(_phy->dev, "%s: ref_clk enable failed %d\n",
> +				__func__, ret);
> +		return ret;
> +	}
> +
> +	samsung_ufs_phy_ctrl_isol(_phy, false);
> +	return 0;
> +}
> +
> +static int samsung_ufs_phy_power_off(struct phy *phy) {
> +	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
> +
> +	samsung_ufs_phy_ctrl_isol(_phy, true);
> +	clk_disable_unprepare(_phy->ref_clk);
> +	return 0;
> +}
> +
> +static int samsung_ufs_phy_set_mode(struct phy *generic_phy,
> +					enum phy_mode mode, int submode)
> +{
> +	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(generic_phy);
> +
> +	_phy->mode = PHY_MODE_INVALID;
> +
> +	if (mode > 0)
> +		_phy->mode = mode;
> +
> +	return 0;
> +}
> +
> +static struct phy_ops samsung_ufs_phy_ops = {
> +	.init		= samsung_ufs_phy_init,
> +	.power_on	= samsung_ufs_phy_power_on,
> +	.power_off	= samsung_ufs_phy_power_off,
> +	.calibrate	= samsung_ufs_phy_calibrate,
> +	.set_mode	= samsung_ufs_phy_set_mode,
> +}
> +;
> +static const struct of_device_id samsung_ufs_phy_match[];
> +
> +static int samsung_ufs_phy_probe(struct platform_device *pdev) {
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	const struct of_device_id *match;
> +	struct samsung_ufs_phy *phy;
> +	struct phy *gen_phy;
> +	struct phy_provider *phy_provider;
> +	const struct samsung_ufs_phy_drvdata *drvdata;
> +	int err = 0;
> +
> +	match = of_match_node(samsung_ufs_phy_match, dev->of_node);
> +	if (!match) {
> +		err = -EINVAL;
> +		dev_err(dev, "failed to get match_node\n");
> +		goto out;
> +	}
> +
> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy-pma");
> +	phy->reg_pma = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy->reg_pma)) {
> +		err = PTR_ERR(phy->reg_pma);
> +		goto out;
> +	}
> +
> +	phy->reg_pmu = syscon_regmap_lookup_by_phandle(
> +				dev->of_node, "samsung,pmu-syscon");
> +	if (IS_ERR(phy->reg_pmu)) {
> +		err = PTR_ERR(phy->reg_pmu);
> +		dev_err(dev, "failed syscon remap for pmu\n");
> +		goto out;
> +	}
> +
> +	gen_phy = devm_phy_create(dev, NULL, &samsung_ufs_phy_ops);
> +	if (IS_ERR(gen_phy)) {
> +		err = PTR_ERR(gen_phy);
> +		dev_err(dev, "failed to create PHY for ufs-phy\n");
> +		goto out;
> +	}
> +
> +	drvdata = match->data;
> +	phy->dev = dev;
> +	phy->drvdata = drvdata;
> +	phy->cfg = (struct samsung_ufs_phy_cfg **)drvdata->cfg;
> +	phy->isol = &drvdata->isol;
> +	phy->lane_cnt = PHY_DEF_LANE_CNT;
> +
> +	phy_set_drvdata(gen_phy, phy);
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		err = PTR_ERR(phy_provider);
> +		dev_err(dev, "failed to register phy-provider\n");
> +		goto out;
> +	}
> +out:
> +	return err;
> +}
> +
> +static const struct of_device_id samsung_ufs_phy_match[] = {
> +	{
> +		.compatible = "samsung,exynos7-ufs-phy",
> +		.data = &exynos7_ufs_phy,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, samsung_ufs_phy_match);
> +
> +static struct platform_driver samsung_ufs_phy_driver = {
> +	.probe  = samsung_ufs_phy_probe,
> +	.driver = {
> +		.name = "samsung-ufs-phy",
> +		.of_match_table = samsung_ufs_phy_match,
> +	},
> +};
> +module_platform_driver(samsung_ufs_phy_driver);
> +MODULE_DESCRIPTION("Samsung SoC UFS PHY Driver");
> +MODULE_AUTHOR("Seungwon Jeon <essuuj@gmail.com>"); MODULE_AUTHOR("Alim
> +Akhtar <alim.akhtar@samsung.com>"); MODULE_LICENSE("GPL v2");
> diff --git a/drivers/phy/samsung/phy-samsung-ufs.h
> b/drivers/phy/samsung/phy-samsung-ufs.h
> new file mode 100644
> index 000000000000..d0ae2b416b2b
> --- /dev/null
> +++ b/drivers/phy/samsung/phy-samsung-ufs.h
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * UFS PHY driver for Samsung EXYNOS SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + * Author: Seungwon Jeon <essuuj@gmail.com>
> + * Author: Alim Akhtar <alim.akhtar@samsung.com>
> + *
> + */
> +#ifndef _PHY_SAMSUNG_UFS_
> +#define _PHY_SAMSUNG_UFS_
> +
> +#define PHY_COMN_BLK	1
> +#define PHY_TRSV_BLK	2
> +#define END_UFS_PHY_CFG { 0 }
> +#define PHY_TRSV_CH_OFFSET	0x30
> +#define PHY_APB_ADDR(off)	((off) << 2)
> +
> +#define PHY_COMN_REG_CFG(o, v, d) {	\
> +	.off_0 = PHY_APB_ADDR((o)),	\
> +	.off_1 = 0,		\
> +	.val = (v),		\
> +	.desc = (d),		\
> +	.id = PHY_COMN_BLK,	\
> +}
> +
> +#define PHY_TRSV_REG_CFG(o, v, d) {	\
> +	.off_0 = PHY_APB_ADDR((o)),	\
> +	.off_1 = PHY_APB_ADDR((o) + PHY_TRSV_CH_OFFSET),	\
> +	.val = (v),		\
> +	.desc = (d),		\
> +	.id = PHY_TRSV_BLK,	\
> +}
> +
> +/* UFS PHY registers */
> +#define PHY_PLL_LOCK_STATUS	0x1e
> +#define PHY_CDR_LOCK_STATUS	0x5e
> +
> +#define PHY_PLL_LOCK_BIT	BIT(5)
> +#define PHY_CDR_LOCK_BIT	BIT(4)
> +
> +/* PHY calibration point/state */
> +enum {
> +	CFG_PRE_INIT,
> +	CFG_POST_INIT,
> +	CFG_PRE_PWR_HS,
> +	CFG_POST_PWR_HS,
> +	CFG_TAG_MAX,
> +};
> +
> +struct samsung_ufs_phy_cfg {
> +	u32 off_0;
> +	u32 off_1;
> +	u32 val;
> +	u8 desc;
> +	u8 id;
> +};
> +
> +struct samsung_ufs_phy_drvdata {
> +	const struct samsung_ufs_phy_cfg **cfg;
> +	struct pmu_isol {
> +		u32 offset;
> +		u32 mask;
> +		u32 en;
> +	} isol;
> +};
> +
> +struct samsung_ufs_phy {
> +	struct device *dev;
> +	void __iomem *reg_pma;
> +	struct regmap *reg_pmu;
> +	struct clk *ref_clk;
> +	struct clk *ref_clk_parent;
> +	const struct samsung_ufs_phy_drvdata *drvdata;
> +	struct samsung_ufs_phy_cfg **cfg;
> +	const struct pmu_isol *isol;
> +	u8 lane_cnt;
> +	int ufs_phy_state;
> +	enum phy_mode mode;
> +	bool is_pre_init;
> +	bool is_post_init;
> +	bool is_pre_pmc;
> +	bool is_post_pmc;
> +};
> +
> +static inline struct samsung_ufs_phy *get_samsung_ufs_phy(struct phy
> +*phy) {
> +	return (struct samsung_ufs_phy *)phy_get_drvdata(phy); }
> +
> +static inline void samsung_ufs_phy_ctrl_isol(
> +		struct samsung_ufs_phy *phy, u32 isol) {
> +	regmap_update_bits(phy->reg_pmu, phy->isol->offset,
> +			phy->isol->mask, isol ? 0 : phy->isol->en); }
> +
> +#include "phy-exynos7-ufs.h"
> +
> +#endif /* _PHY_SAMSUNG_UFS_ */
> diff --git a/include/linux/phy/phy-samsung-ufs.h b/include/linux/phy/phy-
> samsung-ufs.h
> new file mode 100644
> index 000000000000..1def56207f5d
> --- /dev/null
> +++ b/include/linux/phy/phy-samsung-ufs.h
> @@ -0,0 +1,70 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * phy-samsung-ufs.h - Header file for the UFS PHY of Samsung SoC
> + *
> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> + * Author: Seungwon Jeon <essuuj@gmail.com>
> + * Author: Alim Akhtar <alim.akhtar@samsung.com>
> + *
> + */
> +
> +#ifndef _PHY_EXYNOS_UFS_H_
> +#define _PHY_EXYNOS_UFS_H_
> +
> +#include "phy.h"
> +
> +/* description for PHY calibration */
> +enum {
> +	/* applicable to any */
> +	PWR_DESC_ANY	= 0,
> +	/* mode */
> +	PWR_DESC_PWM	= 1,
> +	PWR_DESC_HS	= 2,
> +	/* series */
> +	PWR_DESC_SER_A	= 1,
> +	PWR_DESC_SER_B	= 2,
> +	/* gear */
> +	PWR_DESC_G1	= 1,
> +	PWR_DESC_G2	= 2,
> +	PWR_DESC_G3	= 3,
> +	PWR_DESC_G4	= 4,
> +	PWR_DESC_G5	= 5,
> +	PWR_DESC_G6	= 6,
> +	PWR_DESC_G7	= 7,
> +	/* field mask */
> +	MD_MASK		= 0x3,
> +	SR_MASK		= 0x3,
> +	GR_MASK		= 0x7,
> +};
> +
> +#define PWR_MODE(g, s, m)	((((g) & GR_MASK) << 4) |\
> +				 (((s) & SR_MASK) << 2) | ((m) & MD_MASK))
> +#define PWR_MODE_HS(g, s)	((((g) & GR_MASK) << 4) |\
> +				 (((s) & SR_MASK) << 2) | PWR_DESC_HS)
> +#define PWR_MODE_HS_G1_ANY	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_ANY)
> +#define PWR_MODE_HS_G1_SER_A	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_A)
> +#define PWR_MODE_HS_G1_SER_B	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_B)
> +#define PWR_MODE_HS_G2_ANY	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_ANY)
> +#define PWR_MODE_HS_G2_SER_A	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_A)
> +#define PWR_MODE_HS_G2_SER_B	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_B)
> +#define PWR_MODE_HS_G3_ANY	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_ANY)
> +#define PWR_MODE_HS_G3_SER_A	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_A)
> +#define PWR_MODE_HS_G3_SER_B	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_B)
> +#define PWR_MODE_HS_ANY		PWR_MODE(PWR_DESC_ANY,\
> +					 PWR_DESC_ANY, PWR_DESC_HS)
> +#define PWR_MODE_PWM_ANY	PWR_MODE(PWR_DESC_ANY,\
> +					 PWR_DESC_ANY, PWR_DESC_PWM)
> +#define PWR_MODE_ANY		PWR_MODE(PWR_DESC_ANY,\
> +					 PWR_DESC_ANY, PWR_DESC_ANY)
> +#define IS_PWR_MODE_HS(d)	(((d) & MD_MASK) == PWR_DESC_HS)
> +#define IS_PWR_MODE_PWM(d)	(((d) & MD_MASK) == PWR_DESC_PWM)
> +#define IS_PWR_MODE_ANY(d)	((d) == PWR_MODE_ANY)
> +#define IS_PWR_MODE_HS_ANY(d)	((d) == PWR_MODE_HS_ANY)
> +#define COMP_PWR_MODE(a, b)		((a) == (b))
> +#define COMP_PWR_MODE_GEAR(a, b)	((((a) >> 4) & GR_MASK) == \
> +					 (((b) >> 4) & GR_MASK))
> +#define COMP_PWR_MODE_SER(a, b)		((((a) >> 2) & SR_MASK) == \
> +					 (((b) >> 2) & SR_MASK))
> +#define COMP_PWR_MODE_MD(a, b)		(((a) & MD_MASK) == ((b) &
> MD_MASK))
> +
> +#endif /* _PHY_EXYNOS_UFS_H_ */
> --
> 2.17.1

Looks good.
Reviewed-by: Kiwoong Kim <kwmad.kim@xxxxxxx>

