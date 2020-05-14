Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF9BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E74D620659
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t10gRpKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgENAxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46048 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731473AbgENAxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:13 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200514005308epoutp02a3ae6eac08cd0b18d28b28043aa9769d~OvuAY0Mh81742217422epoutp02P
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200514005308epoutp02a3ae6eac08cd0b18d28b28043aa9769d~OvuAY0Mh81742217422epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417588;
        bh=sK/hFncn11WBScvtcYDk7R7CcwFLxOCyulZMUjKu6sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t10gRpKPVa/eizfijPwR1lovg8TgYYNj3kaqBZvhwczwf/VydBezCnsYNGTwUhB9V
         RLugWBIjbf9AIIXmNC0x/leojFTVQ+xXdrCrQQIV8VqcN6jViP523tkaOljQ/56ZPf
         M3Mw3VCWXc08vVCXBqBHb4ZwtwyqC5qyYkbtGdT0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200514005307epcas5p34683dbc6b3566a18b1b306efc6211843~Ovt-6Lbul1578415784epcas5p3B;
        Thu, 14 May 2020 00:53:07 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.8E.23389.3769CBE5; Thu, 14 May 2020 09:53:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005307epcas5p28b00e2fb5e9526c447927b52127480f4~Ovt-gnZAK1337613376epcas5p2A;
        Thu, 14 May 2020 00:53:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514005307epsmtrp1494bd427208486b5d9b5ea0ad95071eb~Ovt-fuhs91129711297epsmtrp1h;
        Thu, 14 May 2020 00:53:07 +0000 (GMT)
X-AuditID: b6c32a4b-797ff70000005b5d-04-5ebc9673da39
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.82.25866.3769CBE5; Thu, 14 May 2020 09:53:07 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005304epsmtip26faba709658528a56c74fda8bb5a294e~Ovt9UJ1eR3265032650epsmtip2f;
        Thu, 14 May 2020 00:53:04 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v9 07/10] phy: samsung-ufs: add UFS PHY driver for samsung
 SoC
Date:   Thu, 14 May 2020 06:09:11 +0530
Message-Id: <20200514003914.26052-8-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsWy7bCmpm7xtD1xBlMvKls8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvFhac9bBbnz29gt7i55SiLxabH11gtLu+aw2Yx4/w+Jovu6zvYLJYf/8dk
        8X/PDnaLpVtvMjrweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXxc9Jk5oI7cxgr5i15xNrA+LmJsYuRk0NCwETi3431zF2M
        XBxCArsZJZrffYVyPjFKrPk+A8r5zCgxad0FuJbdzbcYIRK7GCWWnvgMVdXCJDFj9UuwKjYB
        bYm707cwgdgiAsISR761gXUwCzQxS3xZ2sQGkhAWCJDY9/E3M4jNIqAqcWzTf7A4r4CNxO6L
        v9kg1slLrN5wAKyGU8BWYsuXY6wQNYISJ2c+YQGxmYFqmrfOBrtCQuAMh8SCg9uZIJpdJNr+
        PWeFsIUlXh3fwg5hS0m87G8DsjmA7GyJnl3GEOEaiaXzjrFA2PYSB67MYQEpYRbQlFi/Sx9i
        FZ9E7+8nTBCdvBIdbUIQ1arAoLsK1SktMbG7G2qph8SPR1PArhcSmMAoMf1m7ARG+VlIHpiF
        5IFZCMsWMDKvYpRMLSjOTU8tNi0wzkst1ytOzC0uzUvXS87P3cQITmRa3jsYHz34oHeIkYmD
        8RCjBAezkgiv3/rdcUK8KYmVValF+fFFpTmpxYcYpTlYlMR5HzduiRMSSE8sSc1OTS1ILYLJ
        MnFwSjUwXUtrjX7kderIWYF7RtduiDlPWLq5N+uU7zJjkebjerohk/XWsrEoiHaKJfbN9DD5
        l/M5+E2+/FLN2xFc36+HzGCw95gXaBYdejnaZrXU6bavk0I0etqsbyf+19hqFmBTHDxBLKLk
        yKzpYvMfr5I53nDrzmbt9MVyYvf+1N70/fRTXrhVln1reNHzDXo9Jxf/izPw91Dlay7yczhe
        PbtcUf2m4lI3txiNy71fGurs7jrs+rlZOCRsMatV96S6/1yyMiu+1aVybzznfcSA06DAdKXT
        sZ/ZlyqX1eQ5hTJP5Voi4qlm96DF1H/yKxdNWXGtMpO5PUvu8YhvzPLPj/kkfqP/zpP0bf2z
        WhvO2imxFGckGmoxFxUnAgDXFer/0wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvG7xtD1xBqumc1g8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvFhac9bBbnz29gt7i55SiLxabH11gtLu+aw2Yx4/w+Jovu6zvYLJYf/8dk
        8X/PDnaLpVtvMjrweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJXxc9Jk5oI7cxgr5i15xNrA+LmJsYuRk0NCwERid/MtIJuL
        Q0hgB6NE3/+DTBAJaYnrGyewQ9jCEiv/PWeHKGpikjjU8ZAVJMEmoC1xd/oWsAYRoKIj39rA
        JjELTGCWWP7rG5DDwSEs4CfRd6MApIZFQFXi2Kb/bCA2r4CNxO6Lv9kgFshLrN5wgBnE5hSw
        ldjy5RjYfCGgmmVrljFC1AtKnJz5hAVkJLOAusT6eUIgYWag1uats5knMArOQlI1C6FqFpKq
        BYzMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgmNOS2sH455VH/QOMTJxMB5ilOBg
        VhLh9Vu/O06INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFIN
        TLN1LXsEDfh8HFJFRVZ/vMW7aRFv34T6vN0z1b/1rXdsaPC6+sghI1vjqb5AYeuJEr3TQWWX
        rRU/xCx8vavKrK5E5WNHwCN9z1/HEuR3r3nQf0V78Y7301uvaAuJ3N/N6ObA29T3T2L/XQnb
        LH/J6V+3zZlhNFXq1OKTDW8PrP2R+yjJ6oGfndLf3j/s7vMWs3B4T/ILsnwY16bvLtZUL/zn
        bLLHjQ+q+WfUmQ0fz9it8mCJgPPVbGdB3i/LtKZuTr2+vDGxZdvxK3vvx7N6OXxYdd7fO1eX
        jeNCzxr9jox+Fc5Jh9R3L9EtOjjrpVNF28xSl/M5IpdWzJuzX63Z1pIvavWDxzMFXHy/qeu3
        KrEUZyQaajEXFScCAHy6x0coAwAA
X-CMS-MailID: 20200514005307epcas5p28b00e2fb5e9526c447927b52127480f4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005307epcas5p28b00e2fb5e9526c447927b52127480f4
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005307epcas5p28b00e2fb5e9526c447927b52127480f4@epcas5p2.samsung.com>
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

