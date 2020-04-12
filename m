Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C0EC2BB86
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3304A2070A
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 07:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mL4ILFZ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgDLHmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 03:42:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30990 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgDLHmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 03:42:12 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200412074210epoutp040d231aa27c676ab8f2177ef55bca3e56~FAqAHQIZx2821328213epoutp04z
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 07:42:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200412074210epoutp040d231aa27c676ab8f2177ef55bca3e56~FAqAHQIZx2821328213epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586677330;
        bh=jkpBVnMapPYgnP/AWNxgzOKgM7k0/ctDUDDMnmkJf0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mL4ILFZ5ZhFoxf16T3hZpMHLJlN+Nw3rOtdkIZz7gY56koJMnOjV/SGhnPbjZeMi0
         k6U06h+fRvTFfGSzgtFoU0jX5sfq1UPluIRudx0oMvHBCZpAGlFCAMOwRdwQ+SJUEG
         //wRkI6rkkvgLtjlolpnPh5/GULw62IlRgmvxq14=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200412074208epcas5p4ec7425e4adddb4a4c1d153f53ebaa20e~FAp-FHR6G1693016930epcas5p46;
        Sun, 12 Apr 2020 07:42:08 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.B2.04782.056C29E5; Sun, 12 Apr 2020 16:42:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200412074208epcas5p3fb85c70701a9b6f65b8fc20f722a50ce~FAp_U1QZB1508915089epcas5p37;
        Sun, 12 Apr 2020 07:42:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200412074208epsmtrp1ef551694e82ec13ba0620c850875cbc6~FAp_T-eWn1966119661epsmtrp1u;
        Sun, 12 Apr 2020 07:42:08 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-f7-5e92c6504a75
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.3E.04024.F46C29E5; Sun, 12 Apr 2020 16:42:07 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200412074205epsmtip1b9453a8ad4e1957cfc1cd0596b196d05~FAp7zl5RU0407304073epsmtip1F;
        Sun, 12 Apr 2020 07:42:05 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Seungwon Jeon <essuuj@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v5 2/5] phy: samsung-ufs: add UFS PHY driver for samsung SoC
Date:   Sun, 12 Apr 2020 13:01:56 +0530
Message-Id: <20200412073159.37747-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200412073159.37747-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUhUYRSG+e4216mp6yj0NWLCgJRmmlhyf5j1I+JGClJB0GJOelHRUZtx
        DcE1tXHXcBmXhFxIA2VcGqfMcckFcyF1XNDSVNApNCeyzSVnrpL/nnPO+/Ke8/GRqFCHi8jA
        kHBWFiIJFhN8rKXLzv6MV0+e99niVRd6rryFoFd+jxO0ob4ap591D+F0zUglQo8sZRD08HAD
        j55qeofRqgUdTo9qSgm6aPgtQqdPqAm6pncboXfeqHl0VfMUuHSUGc3KRJhW5SyPUdU+IZjG
        yjgmub8dY9aXpjEmq6kWML2TrxDmu+oEk6pNR7z4t/lufmxwYCQrc3L34QcM/NKjYS+KQHT8
        nxYiHhTEKYAZCalzMOVjF64AfFJIvQbwy4+vgCsMALZ+W0O5YgPA6eoVfN+yszmCcIM2AOcT
        9XuWZATmrxcCo4qgTsPZwibEyJbUNbimHTaFoJQegd1L9TzjwILygKUGrUmEUbZQ19NAGFlA
        ucFPj8tQLs4G1jVoTWxGXYAVMwqE05jD/uJFzMjoriapucS0K6RUPDg7MIJw5stwo6CN4NgC
        6nubeByL4Ep2yi6TuxwEMzQuXDsWVpX3YBxfhNqxUswoQSk7WK9x4qKOwMy/iwjnFMC0FCGn
        toVJq+N7TiuYm56+91gM1KQtmBYQUjkAts3fzAE2ygMHKA8coPwfVgHQWnCcDZNL/Vn5+TDn
        EDbKUS6RyiNC/B19Q6UqYPpt9lfVQDnk0QkoEogPC7S6XG8hLomUx0g7ASRRsaVgMWq3JfCT
        xDxiZaH3ZRHBrLwTWJGY+JggDx+/K6T8JeFsEMuGsbL9KUKaieJBNorfaX9Wlxa0OZc26PuA
        2HSd2BrzjTYL1PELH2pPuUlCU2/MBj2Ny0gYc48tkeqLPntaz0w311xJVGQ49Aa6Lnu8LPrQ
        6GPZeL0xyrpvK+/Q5PPxDierwYb85fzsAYfyBEeqTOFv2O77ubFQ2+3ecdKgib1X5al2Fr2P
        WU++ZS7G5AESZ3tUJpf8A+XZyJ9pAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSnK7/sUlxBqd/2Vg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF8gtLmCwuPO1hszh/fgO7xc0tR1ksNj2+xmpxedccNosZ5/cxWXRf38Fm
        sfz4PyaL/3t2sFss3XqT0YHf43JfL5PHzll32T02repk89i8pN6j5eR+Fo+PT2+xePRtWcXo
        cfzGdiaPz5vkPNoPdDMFcEVx2aSk5mSWpRbp2yVwZZz+8Yq5YOUMxoqGX9vYGhin1XcxcnJI
        CJhI/P9zgamLkYtDSGA3o8S7D/OYIBLSEtc3TmCHsIUlVv57zg5R1MQkcWLqJxaQBJuAtsTd
        6VvAGkQE/CX+fD8GVsQs8INJ4teuFWwgCWEBH4k5nw6AFbEIqEpcO7YBLM4rYCNxv3UuM8QG
        eYnVGw6A2ZwCthIL7nSB1QsB1fzdcZwRol5Q4uTMJ0CLOYAWqEusnycEEmYGam3eOpt5AqPg
        LCRVsxCqZiGpWsDIvIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzgOtTR3MF5eEn+I
        UYCDUYmH98C1iXFCrIllxZW5hxglOJiVRHiflAOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8z7N
        OxYpJJCeWJKanZpakFoEk2Xi4JRqYGyM2xQXLTOJa/fJV6XHb9Zblr5t+nz72rkpL5ReJ6vU
        /Lk3K/2a9wTxsBWZp/JWKqmZ3/7GZcamqv3+oNb6835C95d6Sx/RvN/e+dtbV/96kIfD2vvB
        N38/LFU60zU30j0qR16ioVY3UeZBvQHr9z2O63if3myqtAr+G9fKeefJsaRl5zkjPiuxFGck
        GmoxFxUnAgCzw4s/vwIAAA==
X-CMS-MailID: 20200412074208epcas5p3fb85c70701a9b6f65b8fc20f722a50ce
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074208epcas5p3fb85c70701a9b6f65b8fc20f722a50ce
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
        <CGME20200412074208epcas5p3fb85c70701a9b6f65b8fc20f722a50ce@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch introduces Samsung UFS PHY driver. This driver
supports to deal with phy calibration and power control
according to UFS host driver's behavior.

Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Tested-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
---
 drivers/phy/samsung/Kconfig           |   9 +
 drivers/phy/samsung/Makefile          |   1 +
 drivers/phy/samsung/phy-exynos7-ufs.h |  85 ++++++
 drivers/phy/samsung/phy-samsung-ufs.c | 369 ++++++++++++++++++++++++++
 drivers/phy/samsung/phy-samsung-ufs.h | 142 ++++++++++
 5 files changed, 606 insertions(+)
 create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
 create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h

diff --git a/drivers/phy/samsung/Kconfig b/drivers/phy/samsung/Kconfig
index 9e483d1fdaf2..fc1e3c17f842 100644
--- a/drivers/phy/samsung/Kconfig
+++ b/drivers/phy/samsung/Kconfig
@@ -29,6 +29,15 @@ config PHY_EXYNOS_PCIE
 	  Enable PCIe PHY support for Exynos SoC series.
 	  This driver provides PHY interface for Exynos PCIe controller.
 
+config PHY_SAMSUNG_UFS
+	tristate "SAMSUNG SoC series UFS PHY driver"
+	depends on OF && (ARCH_EXYNOS || COMPILE_TEST)
+	select GENERIC_PHY
+	help
+	  Enable this to support the Samsung UFS PHY driver for
+	  Samsung SoCs. This driver provides the interface for UFS
+	  host controller to do PHY related programming.
+
 config PHY_SAMSUNG_USB2
 	tristate "Samsung USB 2.0 PHY driver"
 	depends on HAS_IOMEM
diff --git a/drivers/phy/samsung/Makefile b/drivers/phy/samsung/Makefile
index db9b1aa0de6e..3959100fe8a2 100644
--- a/drivers/phy/samsung/Makefile
+++ b/drivers/phy/samsung/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_EXYNOS_PCIE)		+= phy-exynos-pcie.o
+obj-$(CONFIG_PHY_SAMSUNG_UFS)		+= phy-samsung-ufs.o
 obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
 phy-exynos-usb2-y			+= phy-samsung-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
diff --git a/drivers/phy/samsung/phy-exynos7-ufs.h b/drivers/phy/samsung/phy-exynos7-ufs.h
new file mode 100644
index 000000000000..da981c1ac040
--- /dev/null
+++ b/drivers/phy/samsung/phy-exynos7-ufs.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS PHY driver data for Samsung EXYNOS7 SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ */
+#ifndef _PHY_EXYNOS7_UFS_H_
+#define _PHY_EXYNOS7_UFS_H_
+
+#include "phy-samsung-ufs.h"
+
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL	0x720
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
+#define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
+
+/* Calibration for phy initialization */
+static const struct samsung_ufs_phy_cfg exynos7_pre_init_cfg[] = {
+	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_ANY),
+	PHY_COMN_REG_CFG(0x017, 0x84, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x035, 0x58, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x037, 0x40, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x03b, 0x83, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x04c, 0x5b, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_ANY),
+	PHY_TRSV_REG_CFG(0x05c, 0x14, PWR_MODE_ANY),
+	END_UFS_PHY_CFG
+};
+
+static const struct samsung_ufs_phy_cfg exynos7_post_init_cfg[] = {
+	END_UFS_PHY_CFG
+};
+
+/* Calibration for HS mode series A/B */
+static const struct samsung_ufs_phy_cfg exynos7_pre_pwr_hs_cfg[] = {
+	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_HS_ANY),
+	/* Setting order: 1st(0x16, 2nd(0x15) */
+	PHY_COMN_REG_CFG(0x016, 0xff, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x015, 0x80, PWR_MODE_HS_ANY),
+	PHY_COMN_REG_CFG(0x017, 0x94, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x037, 0x43, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x038, 0x3f, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x042, 0xbb, PWR_MODE_HS_G2_SER_B),
+	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x034, 0x35, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x034, 0x36, PWR_MODE_HS_G2_SER_B),
+	PHY_TRSV_REG_CFG(0x035, 0x5b, PWR_MODE_HS_G2_SER_A),
+	PHY_TRSV_REG_CFG(0x035, 0x5c, PWR_MODE_HS_G2_SER_B),
+	END_UFS_PHY_CFG
+};
+
+/* Calibration for HS mode series A/B atfer PMC */
+static const struct samsung_ufs_phy_cfg exynos7_post_pwr_hs_cfg[] = {
+	PHY_COMN_REG_CFG(0x015, 0x00, PWR_MODE_HS_ANY),
+	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_HS_ANY),
+	END_UFS_PHY_CFG
+};
+
+static const struct samsung_ufs_phy_cfg *exynos7_ufs_phy_cfgs[CFG_TAG_MAX] = {
+	[CFG_PRE_INIT]		= exynos7_pre_init_cfg,
+	[CFG_POST_INIT]		= exynos7_post_init_cfg,
+	[CFG_PRE_PWR_HS]	= exynos7_pre_pwr_hs_cfg,
+	[CFG_POST_PWR_HS]	= exynos7_post_pwr_hs_cfg,
+};
+
+static struct samsung_ufs_phy_drvdata exynos7_ufs_phy = {
+	.cfg = exynos7_ufs_phy_cfgs,
+	.isol = {
+		.offset = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL,
+		.mask = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK,
+		.en = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN,
+	},
+};
+
+#endif /* _PHY_EXYNOS7_UFS_H_ */
diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
new file mode 100644
index 000000000000..4c8334bba3e9
--- /dev/null
+++ b/drivers/phy/samsung/phy-samsung-ufs.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * UFS PHY driver for Samsung SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj@gmail.com>
+ * Author: Alim Akhtar <alim.akhtar@samsung.com>
+ *
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#include "phy-samsung-ufs.h"
+
+#define for_each_phy_lane(phy, i) \
+	for (i = 0; i < (phy)->lane_cnt; i++)
+#define for_each_phy_cfg(cfg) \
+	for (; (cfg)->id; (cfg)++)
+
+#define PHY_DEF_LANE_CNT	1
+
+static void samsung_ufs_phy_config(struct samsung_ufs_phy *phy,
+			const struct samsung_ufs_phy_cfg *cfg, u8 lane)
+{
+	enum {LANE_0, LANE_1}; /* lane index */
+
+	switch (lane) {
+	case LANE_0:
+		writel(cfg->val, (phy)->reg_pma + cfg->off_0);
+		break;
+	case LANE_1:
+		if (cfg->id == PHY_TRSV_BLK)
+			writel(cfg->val, (phy)->reg_pma + cfg->off_1);
+		break;
+	}
+}
+
+int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy)
+{
+	struct samsung_ufs_phy *ufs_phy = get_samsung_ufs_phy(phy);
+	const unsigned int timeout_us = 100000;
+	const unsigned int sleep_us = 10;
+	u32 val;
+	int err;
+
+	err = readl_poll_timeout(
+			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
+			val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
+	if (err) {
+		dev_err(ufs_phy->dev,
+			"failed to get phy pll lock acquisition %d\n", err);
+		goto out;
+	}
+
+	err = readl_poll_timeout(
+			ufs_phy->reg_pma + PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
+			val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
+	if (err) {
+		dev_err(ufs_phy->dev,
+			"failed to get phy cdr lock acquisition %d\n", err);
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+int samsung_ufs_phy_calibrate(struct phy *phy)
+{
+	struct samsung_ufs_phy *ufs_phy = get_samsung_ufs_phy(phy);
+	struct samsung_ufs_phy_cfg **cfgs = ufs_phy->cfg;
+	const struct samsung_ufs_phy_cfg *cfg;
+	int i;
+	int err = 0;
+
+	if (unlikely(ufs_phy->ufs_phy_state < CFG_PRE_INIT ||
+		     ufs_phy->ufs_phy_state >= CFG_TAG_MAX)) {
+		dev_err(ufs_phy->dev, "invalid phy config index %d\n",
+							ufs_phy->ufs_phy_state);
+		return -EINVAL;
+	}
+
+	if (ufs_phy->is_pre_init)
+		ufs_phy->is_pre_init = false;
+	if (ufs_phy->is_post_init) {
+		ufs_phy->is_post_init = false;
+		ufs_phy->ufs_phy_state = CFG_POST_INIT;
+	}
+	if (ufs_phy->is_pre_pmc) {
+		ufs_phy->is_pre_pmc = false;
+		ufs_phy->ufs_phy_state = CFG_PRE_PWR_HS;
+	}
+	if (ufs_phy->is_post_pmc) {
+		ufs_phy->is_post_pmc = false;
+		ufs_phy->ufs_phy_state = CFG_POST_PWR_HS;
+	}
+
+	switch (ufs_phy->ufs_phy_state) {
+	case CFG_PRE_INIT:
+		ufs_phy->is_post_init = true;
+		break;
+	case CFG_POST_INIT:
+		ufs_phy->is_pre_pmc = true;
+		break;
+	case CFG_PRE_PWR_HS:
+		ufs_phy->is_post_pmc = true;
+		break;
+	case CFG_POST_PWR_HS:
+		break;
+	default:
+		dev_err(ufs_phy->dev, "wrong state for phy calibration\n");
+	}
+
+	cfg = cfgs[ufs_phy->ufs_phy_state];
+	if (!cfg)
+		goto out;
+
+	for_each_phy_cfg(cfg) {
+		for_each_phy_lane(ufs_phy, i) {
+			samsung_ufs_phy_config(ufs_phy, cfg, i);
+		}
+	}
+
+	if (ufs_phy->ufs_phy_state == CFG_POST_PWR_HS)
+		err = samsung_ufs_phy_wait_for_lock_acq(phy);
+out:
+	return err;
+}
+
+static int samsung_ufs_phy_symbol_clk_init(struct samsung_ufs_phy *phy)
+{
+	struct clk *clk;
+	int ret = 0;
+
+	clk = devm_clk_get(phy->dev, "tx0_symbol_clk");
+	if (IS_ERR(clk)) {
+		dev_err(phy->dev, "failed to get tx0_symbol_clk clock\n");
+		goto out;
+	} else {
+		phy->tx0_symbol_clk = clk;
+	}
+
+	clk = devm_clk_get(phy->dev, "rx0_symbol_clk");
+	if (IS_ERR(clk)) {
+		dev_err(phy->dev, "failed to get rx0_symbol_clk clock\n");
+		goto out;
+	} else {
+		phy->rx0_symbol_clk = clk;
+	}
+
+	clk = devm_clk_get(phy->dev, "rx1_symbol_clk");
+	if (IS_ERR(clk)) {
+		dev_err(phy->dev, "failed to get rx1_symbol_clk clock\n");
+		goto out;
+	} else {
+		phy->rx1_symbol_clk = clk;
+	}
+
+	ret = clk_prepare_enable(phy->tx0_symbol_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: tx0_symbol_clk enable failed %d\n",
+				__func__, ret);
+		goto out;
+	}
+	ret = clk_prepare_enable(phy->rx0_symbol_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: rx0_symbol_clk enable failed %d\n",
+				__func__, ret);
+		goto out;
+	}
+	ret = clk_prepare_enable(phy->rx1_symbol_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: rx1_symbol_clk enable failed %d\n",
+				__func__, ret);
+		goto out;
+	}
+out:
+	return ret;
+}
+
+static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy)
+{
+	struct clk *phy_ref_clk;
+	int ret;
+
+	phy_ref_clk = devm_clk_get(phy->dev, "ref_clk");
+	if (IS_ERR(phy_ref_clk))
+		dev_err(phy->dev, "failed to get ref_clk clock\n");
+	else
+		phy->ref_clk = phy_ref_clk;
+
+	ret = clk_prepare_enable(phy->ref_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: ref_clk enable failed %d\n",
+				__func__, ret);
+		return ret;
+	}
+
+	dev_info(phy->dev, "UFS MPHY ref_clk_rate = %ld\n", clk_get_rate(phy_ref_clk));
+
+	return 0;
+}
+
+static int samsung_ufs_phy_init(struct phy *phy)
+{
+	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
+	int ret;
+
+	_phy->lane_cnt = phy->attrs.bus_width;
+	_phy->ufs_phy_state = CFG_PRE_INIT;
+
+	_phy->is_pre_init = true;
+	_phy->is_post_init = false;
+	_phy->is_pre_pmc = false;
+	_phy->is_post_pmc = false;
+
+
+	if (of_device_is_compatible(_phy->dev->of_node,
+				"samsung,exynos7-ufs-phy")) {
+		ret = samsung_ufs_phy_symbol_clk_init(_phy);
+		if (ret)
+			dev_err(_phy->dev,
+				"failed to set ufs phy symbol clocks\n");
+	}
+
+	ret = samsung_ufs_phy_clks_init(_phy);
+	if (ret)
+		dev_err(_phy->dev, "failed to set ufs phy  clocks\n");
+
+	samsung_ufs_phy_calibrate(phy);
+
+	return 0;
+}
+
+static int samsung_ufs_phy_power_on(struct phy *phy)
+{
+	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
+
+	samsung_ufs_phy_ctrl_isol(_phy, false);
+	return 0;
+}
+
+static int samsung_ufs_phy_power_off(struct phy *phy)
+{
+	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
+
+	samsung_ufs_phy_ctrl_isol(_phy, true);
+	clk_disable_unprepare(_phy->ref_clk);
+	return 0;
+}
+
+static int samsung_ufs_phy_set_mode(struct phy *generic_phy,
+					enum phy_mode mode, int submode)
+{
+	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(generic_phy);
+
+	_phy->mode = PHY_MODE_INVALID;
+
+	if (mode > 0)
+		_phy->mode = mode;
+
+	return 0;
+}
+
+static struct phy_ops samsung_ufs_phy_ops = {
+	.init		= samsung_ufs_phy_init,
+	.power_on	= samsung_ufs_phy_power_on,
+	.power_off	= samsung_ufs_phy_power_off,
+	.calibrate	= samsung_ufs_phy_calibrate,
+	.set_mode	= samsung_ufs_phy_set_mode,
+}
+;
+static const struct of_device_id samsung_ufs_phy_match[];
+
+static int samsung_ufs_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	const struct of_device_id *match;
+	struct samsung_ufs_phy *phy;
+	struct phy *gen_phy;
+	struct phy_provider *phy_provider;
+	const struct samsung_ufs_phy_drvdata *drvdata;
+	int err = 0;
+
+	match = of_match_node(samsung_ufs_phy_match, dev->of_node);
+	if (!match) {
+		err = -EINVAL;
+		dev_err(dev, "failed to get match_node\n");
+		goto out;
+	}
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy-pma");
+	phy->reg_pma = devm_ioremap_resource(dev, res);
+	if (IS_ERR(phy->reg_pma)) {
+		err = PTR_ERR(phy->reg_pma);
+		goto out;
+	}
+
+	phy->reg_pmu = syscon_regmap_lookup_by_phandle(
+				dev->of_node, "samsung,pmu-syscon");
+	if (IS_ERR(phy->reg_pmu)) {
+		err = PTR_ERR(phy->reg_pmu);
+		dev_err(dev, "failed syscon remap for pmu\n");
+		goto out;
+	}
+
+	gen_phy = devm_phy_create(dev, NULL, &samsung_ufs_phy_ops);
+	if (IS_ERR(gen_phy)) {
+		err = PTR_ERR(gen_phy);
+		dev_err(dev, "failed to create PHY for ufs-phy\n");
+		goto out;
+	}
+
+	drvdata = match->data;
+	phy->dev = dev;
+	phy->drvdata = drvdata;
+	phy->cfg = (struct samsung_ufs_phy_cfg **)drvdata->cfg;
+	phy->isol = &drvdata->isol;
+	phy->lane_cnt = PHY_DEF_LANE_CNT;
+
+	phy_set_drvdata(gen_phy, phy);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		err = PTR_ERR(phy_provider);
+		dev_err(dev, "failed to register phy-provider\n");
+		goto out;
+	}
+out:
+	return err;
+}
+
+static const struct of_device_id samsung_ufs_phy_match[] = {
+	{
+		.compatible = "samsung,exynos7-ufs-phy",
+		.data = &exynos7_ufs_phy,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, samsung_ufs_phy_match);
+
+static struct platform_driver samsung_ufs_phy_driver = {
+	.probe  = samsung_ufs_phy_probe,
+	.driver = {
+		.name = "samsung-ufs-phy",
+		.of_match_table = samsung_ufs_phy_match,
+	},
+};
+module_platform_driver(samsung_ufs_phy_driver);
+MODULE_DESCRIPTION("Samsung SoC UFS PHY Driver");
+MODULE_AUTHOR("Seungwon Jeon <essuuj@gmail.com>");
+MODULE_AUTHOR("Alim Akhtar <alim.akhtar@samsung.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/samsung/phy-samsung-ufs.h b/drivers/phy/samsung/phy-samsung-ufs.h
new file mode 100644
index 000000000000..27dc1b573469
--- /dev/null
+++ b/drivers/phy/samsung/phy-samsung-ufs.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2015 Samsung Electronics Co., Ltd.
+ * Author: Seungwon Jeon <essuuj@gmail.com>
+ * Author: Alim Akhtar <alim.akhtar@samsung.com>
+ *
+ */
+#ifndef _PHY_SAMSUNG_UFS_
+#define _PHY_SAMSUNG_UFS_
+
+#define PHY_COMN_BLK	1
+#define PHY_TRSV_BLK	2
+#define END_UFS_PHY_CFG { 0 }
+#define PHY_TRSV_CH_OFFSET	0x30
+#define PHY_APB_ADDR(off)	((off) << 2)
+
+#define PHY_COMN_REG_CFG(o, v, d) {	\
+	.off_0 = PHY_APB_ADDR((o)),	\
+	.off_1 = 0,		\
+	.val = (v),		\
+	.desc = (d),		\
+	.id = PHY_COMN_BLK,	\
+}
+
+#define PHY_TRSV_REG_CFG(o, v, d) {	\
+	.off_0 = PHY_APB_ADDR((o)),	\
+	.off_1 = PHY_APB_ADDR((o) + PHY_TRSV_CH_OFFSET),	\
+	.val = (v),		\
+	.desc = (d),		\
+	.id = PHY_TRSV_BLK,	\
+}
+
+/* UFS PHY registers */
+#define PHY_PLL_LOCK_STATUS	0x1e
+#define PHY_CDR_LOCK_STATUS	0x5e
+
+#define PHY_PLL_LOCK_BIT	BIT(5)
+#define PHY_CDR_LOCK_BIT	BIT(4)
+
+/* description for PHY calibration */
+enum {
+	/* applicable to any */
+	PWR_DESC_ANY	= 0,
+	/* mode */
+	PWR_DESC_PWM	= 1,
+	PWR_DESC_HS	= 2,
+	/* series */
+	PWR_DESC_SER_A	= 1,
+	PWR_DESC_SER_B	= 2,
+	/* gear */
+	PWR_DESC_G1	= 1,
+	PWR_DESC_G2	= 2,
+	PWR_DESC_G3	= 3,
+	/* field mask */
+	MD_MASK		= 0x3,
+	SR_MASK		= 0x3,
+	GR_MASK		= 0x7,
+};
+
+#define PWR_MODE_HS_G1_ANY	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_ANY)
+#define PWR_MODE_HS_G1_SER_A	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G1_SER_B	PWR_MODE_HS(PWR_DESC_G1, PWR_DESC_SER_B)
+#define PWR_MODE_HS_G2_ANY	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_ANY)
+#define PWR_MODE_HS_G2_SER_A	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G2_SER_B	PWR_MODE_HS(PWR_DESC_G2, PWR_DESC_SER_B)
+#define PWR_MODE_HS_G3_ANY	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_ANY)
+#define PWR_MODE_HS_G3_SER_A	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_A)
+#define PWR_MODE_HS_G3_SER_B	PWR_MODE_HS(PWR_DESC_G3, PWR_DESC_SER_B)
+#define PWR_MODE(g, s, m)	((((g) & GR_MASK) << 4) |\
+				 (((s) & SR_MASK) << 2) | ((m) & MD_MASK))
+#define PWR_MODE_PWM_ANY	PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_PWM)
+#define PWR_MODE_HS(g, s)	((((g) & GR_MASK) << 4) |\
+				 (((s) & SR_MASK) << 2) | PWR_DESC_HS)
+#define PWR_MODE_HS_ANY		PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_HS)
+#define PWR_MODE_ANY		PWR_MODE(PWR_DESC_ANY,\
+					 PWR_DESC_ANY, PWR_DESC_ANY)
+/* PHY calibration point/state */
+enum {
+	CFG_PRE_INIT,
+	CFG_POST_INIT,
+	CFG_PRE_PWR_HS,
+	CFG_POST_PWR_HS,
+	CFG_TAG_MAX,
+};
+
+struct samsung_ufs_phy_cfg {
+	u32 off_0;
+	u32 off_1;
+	u32 val;
+	u8 desc;
+	u8 id;
+};
+
+struct samsung_ufs_phy_drvdata {
+	const struct samsung_ufs_phy_cfg **cfg;
+	struct pmu_isol {
+		u32 offset;
+		u32 mask;
+		u32 en;
+	} isol;
+};
+
+struct samsung_ufs_phy {
+	struct device *dev;
+	void __iomem *reg_pma;
+	struct regmap *reg_pmu;
+	struct clk *ref_clk;
+	struct clk *ref_clk_parent;
+	struct clk *tx0_symbol_clk;
+	struct clk *rx0_symbol_clk;
+	struct clk *rx1_symbol_clk;
+	const struct samsung_ufs_phy_drvdata *drvdata;
+	struct samsung_ufs_phy_cfg **cfg;
+	const struct pmu_isol *isol;
+	u8 lane_cnt;
+	int ufs_phy_state;
+	enum phy_mode mode;
+	bool is_pre_init;
+	bool is_post_init;
+	bool is_pre_pmc;
+	bool is_post_pmc;
+};
+
+static inline struct samsung_ufs_phy *get_samsung_ufs_phy(struct phy *phy)
+{
+	return (struct samsung_ufs_phy *)phy_get_drvdata(phy);
+}
+
+static inline void samsung_ufs_phy_ctrl_isol(
+		struct samsung_ufs_phy *phy, u32 isol)
+{
+	regmap_update_bits(phy->reg_pmu, phy->isol->offset,
+			phy->isol->mask, isol ? 0 : phy->isol->en);
+}
+
+#include "phy-exynos7-ufs.h"
+
+#endif /* _PHY_SAMSUNG_UFS_ */
-- 
2.17.1

