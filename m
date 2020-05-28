Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA00C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B0F2145D
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="en0Iag1U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgE1Bcs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50212 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgE1Bcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:47 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200528013240epoutp03f9760ffe4381e3e23380f288894b1ec9~TDShIHwCP0188001880epoutp03e
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200528013240epoutp03f9760ffe4381e3e23380f288894b1ec9~TDShIHwCP0188001880epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629560;
        bh=sK/hFncn11WBScvtcYDk7R7CcwFLxOCyulZMUjKu6sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=en0Iag1UB7aEPKKuipNgo9pSt3hjIL7aGHYLXC9sP13dMgtMmWbOrGqwBANb1lOII
         Jc+HKo1e60tm/18+LDA5VQEVjnFIdDLX5XlCmB000u0Po0VxTUbMOC1Ag/AIUUAucV
         /z3W8QbuNjI9YMWYPs0aFp6YaouJ4Ep2UosXwilY=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200528013239epcas5p1b80d8ba86aca0ae5c3ee08a63829ccdf~TDSgOhBNB1882918829epcas5p1K;
        Thu, 28 May 2020 01:32:39 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.58.09703.6B41FCE5; Thu, 28 May 2020 10:32:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200528013238epcas5p3c00d834dbb0b26cc683f293385d77178~TDSf2Jt8m1669516695epcas5p3A;
        Thu, 28 May 2020 01:32:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528013238epsmtrp20a586e86ab57ed262ae03e8607edc1e2~TDSf1Lfwr2193121931epsmtrp2M;
        Thu, 28 May 2020 01:32:38 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-ea-5ecf14b6aabf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8E.77.08303.6B41FCE5; Thu, 28 May 2020 10:32:38 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013236epsmtip16e45c259db61d4695c6f443f22468c8a~TDSd2FRq51669416694epsmtip1l;
        Thu, 28 May 2020 01:32:36 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v10 07/10] phy: samsung-ufs: add UFS PHY driver for samsung
 SoC
Date:   Thu, 28 May 2020 06:46:55 +0530
Message-Id: <20200528011658.71590-8-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SWUwTURT1zUyHKaZ1LKhPUNFGNKLiLiOhSFwnRI1oIIpaacoECFCaqSAa
        jbUSBAoIglqRIImWRlAhtZSmiiAWC0pBg6K4RUCIaxVwDXErU6N/59xz7jv33jwCFTXwfIgE
        xR6GVciSxLgnZr45J2C+2btDutBxYgX1osyMU6+/P8CpoeoKHnXW1s6j7vbn4lRHR40H1W1q
        xihjXxeP6rSW4pSu4zpCaR9acMpg/4lQv65ZPCh9bTcIE9Kd+XkIbazMxukr5w/RGa0NGD3Y
        /xij802VgLY/qkPoYeM0+mijFtnMj/YMiWWSEtIYdkFojGf89+NFqPJpKUgvO9/LU4NhDcgB
        fAKSS6E1+wsvB3gSIvIqgGrHRzcZAlCrycU5Mgzg26EW9G/LyffNKCdYATyhKQIcyUBg3vMe
        D5cLJ+fCZ6dMiAt7k17Q9iVz1ISSGhR+0mtwl+BFRsCjjs+jk2CkPxzoeTgaISBDYM67q+4J
        /WBVTeOfOkHwSQmsLwjjLONh6+mXmAujfyxHas+4p7tLwL4zIg6vgW3NZnfdC76xmzw47AOH
        nfW460lIJsJc6xKufADqy25hHF4JG++XYi4LSs6B1dYFXJIQ5o28RLhOAczKdAf5wyPOB+5O
        X1io1fI4TMOGi0b3qQoANI9cBwXAr+S/BUr+W6DkX1o5QCvBZEapSo5jVMuUixXM3kCVLFmV
        qogLlKckG8HoHwsIt4CeFx8DmwBCgCYACVTsLVjluCMVCWJl+/YzbMpuNjWJUTUBXwITTxKI
        v7VJRWScbA+TyDBKhv2rIgTfR41kBd6L2jRBb1tTlYZHHtZvL06xTXS2RrQPnpPIa6qfFGLq
        igsCrDxxni6kdgc/4WD0h8sxzEC92dfPPmbZh9uVWKhuUsuQLdJibus0kBUBerXO+j7ifvH0
        Xad/4Lxe7bbiC4JZJ4WbV98I2ThDWZQ0e1DRKteF/SQXjou4FlyQWRu2db+vbeeNz+H6Jccv
        xRtWjNiljqp12UF5sUF196KzD6b/eN2+tWt9ueRAVsNMbUaX5FhaXXpMMDuwZcAwsjxmt78I
        lTilp6J+2eZueBYlDQ1+xaauNk2J7JR7OdfmhiPC3qaWBIsyyJC/Y4q2G+uTzwPp+VO/ju3v
        CRJGlrFiTBUvWxSAsirZb3dVfhvSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnO42kfNxBqunKVk8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvFhac9bBbnz29gt7i55SiLxabH11gtLu+aw2Yx4/w+Jovu6zvYLJYf/8dk
        8X/PDnaLpVtvMjrweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXxc9Jk5oI7cxgr5i15xNrA+LmJsYuRk0NCwERi2tujzF2M
        XBxCAjsYJW4/vMcMkZCWuL5xAjuELSyx8t9zdoiiJiaJ7VPngRWxCWhL3J2+hQnEFgEqOvKt
        jRGkiFlgArPE8l/fwFYIC/hLbPg9nRXEZhFQlXj28DpYM6+AjUTXm91QZ8hLrN5wACjOwcEp
        YCuxd4IDSFgIqGTCqr2MEOWCEidnPmEBKWEWUJdYP08IJMwM1Nm8dTbzBEbBWUiqZiFUzUJS
        tYCReRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnDMaWntYNyz6oPeIUYmDsZDjBIc
        zEoivE5nT8cJ8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoRTJaJg1Oq
        gcl80rGSUP/TSS9L1m7r0PFf6P3v4MMlu0xTebTOFcofjmwQ/BzaMmlLa1/ovh83Dm/mN3+R
        VHZ7TwtLRHnj0dqgdQ47ZrN22t4pOiGSfJTt67tZ16X1MqVem5lm1bHYchglLZafuFi3M5Oj
        Zcr1qbPs7NQN/0l7pu8/ZbJO6SRPnc5rTReRdceXx10werStc7pU3iv+MuecF4tba98k+yqY
        av8QVDn7Ru2vuc0v349aB9m951moGrP/mST8tKom9xDruxrz3WFX2LdP/iX/yDx7tv6x3GIp
        Lw3Glknz/iWcnHPlm73Gif9KF6qmzGD7efPpx7RctuOH7d/c0HfjzLhh0nty31WPNROmcc37
        U6bEUpyRaKjFXFScCAB+Jj3CKAMAAA==
X-CMS-MailID: 20200528013238epcas5p3c00d834dbb0b26cc683f293385d77178
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013238epcas5p3c00d834dbb0b26cc683f293385d77178
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013238epcas5p3c00d834dbb0b26cc683f293385d77178@epcas5p3.samsung.com>
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
 drivers/phy/samsung/phy-exynos7-ufs.h |  86 ++++++
 drivers/phy/samsung/phy-samsung-ufs.c | 380 ++++++++++++++++++++++++++
 drivers/phy/samsung/phy-samsung-ufs.h | 143 ++++++++++
 5 files changed, 619 insertions(+)
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
index 000000000000..c4aab792d30e
--- /dev/null
+++ b/drivers/phy/samsung/phy-exynos7-ufs.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS PHY driver data for Samsung EXYNOS7 SoC
+ *
+ * Copyright (C) 2020 Samsung Electronics Co., Ltd.
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
+	.has_symbol_clk = 1,
+};
+
+#endif /* _PHY_EXYNOS7_UFS_H_ */
diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
new file mode 100644
index 000000000000..be25617f622b
--- /dev/null
+++ b/drivers/phy/samsung/phy-samsung-ufs.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * UFS PHY driver for Samsung SoC
+ *
+ * Copyright (C) 2020 Samsung Electronics Co., Ltd.
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
+	int ret = 0;
+
+	phy->tx0_symbol_clk = devm_clk_get(phy->dev, "tx0_symbol_clk");
+	if (IS_ERR(phy->tx0_symbol_clk)) {
+		dev_err(phy->dev, "failed to get tx0_symbol_clk clock\n");
+		goto out;
+	}
+
+	phy->rx0_symbol_clk = devm_clk_get(phy->dev, "rx0_symbol_clk");
+	if (IS_ERR(phy->rx0_symbol_clk)) {
+		dev_err(phy->dev, "failed to get rx0_symbol_clk clock\n");
+		goto out;
+	}
+
+	phy->rx1_symbol_clk = devm_clk_get(phy->dev, "rx1_symbol_clk");
+	if (IS_ERR(phy->rx0_symbol_clk)) {
+		dev_err(phy->dev, "failed to get rx1_symbol_clk clock\n");
+		goto out;
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
+	int ret;
+
+	phy->ref_clk = devm_clk_get(phy->dev, "ref_clk");
+	if (IS_ERR(phy->ref_clk))
+		dev_err(phy->dev, "failed to get ref_clk clock\n");
+
+	ret = clk_prepare_enable(phy->ref_clk);
+	if (ret) {
+		dev_err(phy->dev, "%s: ref_clk enable failed %d\n",
+				__func__, ret);
+		return ret;
+	}
+
+	dev_info(phy->dev, "UFS MPHY ref_clk_rate = %ld\n", clk_get_rate(phy->ref_clk));
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
+	/**
+	 * In ufs, PHY need to be calibrated at different stages / state
+	 * mainly before Linkstartup, after Linkstartup, before power
+	 * mode change and after power mode change.
+	 * Below state machine initialize the initial state to handle
+	 * PHY calibration at various stages of UFS initialization and power
+	 * mode changes
+	 */
+	_phy->is_pre_init = true;
+	_phy->is_post_init = false;
+	_phy->is_pre_pmc = false;
+	_phy->is_post_pmc = false;
+
+
+	if (_phy->drvdata->has_symbol_clk) {
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
+static int samsung_ufs_phy_exit(struct phy *phy)
+{
+	struct samsung_ufs_phy *_phy = get_samsung_ufs_phy(phy);
+
+	clk_disable_unprepare(_phy->ref_clk);
+
+	if (_phy->drvdata->has_symbol_clk) {
+		clk_disable_unprepare(_phy->tx0_symbol_clk);
+		clk_disable_unprepare(_phy->rx0_symbol_clk);
+		clk_disable_unprepare(_phy->rx1_symbol_clk);
+	}
+
+	return 0;
+}
+
+static struct phy_ops samsung_ufs_phy_ops = {
+	.init		= samsung_ufs_phy_init,
+	.exit		= samsung_ufs_phy_exit,
+	.power_on	= samsung_ufs_phy_power_on,
+	.power_off	= samsung_ufs_phy_power_off,
+	.calibrate	= samsung_ufs_phy_calibrate,
+	.set_mode	= samsung_ufs_phy_set_mode,
+	.owner          = THIS_MODULE,
+};
+
+static const struct of_device_id samsung_ufs_phy_match[];
+
+static int samsung_ufs_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
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
+	phy->reg_pma = devm_platform_ioremap_resource_byname(pdev, "phy-pma");
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
index 000000000000..1cc814d972e8
--- /dev/null
+++ b/drivers/phy/samsung/phy-samsung-ufs.h
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * UFS PHY driver for Samsung EXYNOS SoC
+ *
+ * Copyright (C) 2020 Samsung Electronics Co., Ltd.
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
+	bool has_symbol_clk;
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

