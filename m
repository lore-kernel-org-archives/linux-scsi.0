Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ADDC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B670060EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJRMrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18733 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhJRMrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:33 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018124513epoutp010257145117a46f8736cf3235df2f1a4f~vIKw8GhyF2806228062epoutp01P
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018124513epoutp010257145117a46f8736cf3235df2f1a4f~vIKw8GhyF2806228062epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561113;
        bh=JvMtR8qdLu91pqdZsW7lq+tE46+5iFYGIMUctUcSh3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dI8Bn1yttdpo95HKyDJ7gReBECC0QRTY6c8UX/MB53dUCNoyVPFVrHjD/NkaN2lf+
         kEiv5E2IgzgkFYgXTQsP5yLwor2mUhBkxAjcxMloMpOjeeuJsyAvQdspVM7scYh+GU
         oucwuSGzHNCdY5mjwb31d2sUHZgRD6FW9XHm6Jto=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018124512epcas2p1ea8077c21aba1c90622e88f35dbf3e3b~vIKv4j_sF2115521155epcas2p1R;
        Mon, 18 Oct 2021 12:45:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.102]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HXxRQ6GSXz4x9QB; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.6A.10018.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124506epcas2p27ae65b5e8ee4919cde0d989708c24ca6~vIKpvWehV2030920309epcas2p2E;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018124506epsmtrp2a65683cb7018f3eba77fed3164205e36~vIKpukSxS2052720527epsmtrp2N;
        Mon, 18 Oct 2021 12:45:06 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-58-616d6c52b50a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.50.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip2bf9f2433a333dc79b5b91b4c263ea1b7~vIKpc4Bbt0235702357epsmtip2i;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 11/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Mon, 18 Oct 2021 21:42:12 +0900
Message-Id: <20211018124216.153072-12-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmqW5QTm6iwZmN+hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8Udk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOyM37862Ev2GddMfv/I9YG
        xoOGXYycHBICJhLTvl5mA7GFBHYwSvz/ZAVhf2KUmPPQoIuRC8j+zChxaME+FpiGh9M3s0Ek
        djFKzHhylB3C+QhUda8fbBSbgK7EluevGEESIgLvGSWePJ4CVsUs8JRZYt6PXrAqYYFgiRWn
        HrOD2CwCqhIfZ+0AinNw8Ao4SJzdEA+xTl7iyK9OZhCbEyjcs+gIE4jNKyAocXLmE7CTmIFq
        mrfOZgaZLyHwgkOi/2wDK0Szi8SCTxOg7haWeHV8CzuELSXx+d1eNoiGbkaJ1kf/oRKrGSU6
        G30gbHuJX9O3sIIcxCygKbF+lz6IKSGgLHHkFtRePomOw3/ZIcK8Eh1tQhCN6hIHtk+H2ior
        0T3nM9Q1HhI7P35khQTvZEaJ9cedJzAqzELyzSwk38xC2LuAkXkVo1hqQXFuemqxUYERPIKT
        83M3MYLTupbbDsYpbz/oHWJk4mA8xCjBwawkwpvkmpsoxJuSWFmVWpQfX1Sak1p8iNEUGNQT
        maVEk/OBmSWvJN7QxNLAxMzM0NzI1MBcSZzXUjQ7UUggPbEkNTs1tSC1CKaPiYNTqoHp3E0z
        h+jb/7of5+Y8WblS59GiPWyVDmXv3Lcqb+Du2rnaxi8xoa8nwF/q7M65+Zb8ZRd3HrT+I/b6
        eZlBuvTib+FnxVOi4ma5P66vMks46cH7x2DLIQbLlBd5j0pVH9YLqX4VPnHt+vKH3pL266OY
        z87fck/HbPWyy0pP9JOSXU6rmV9bwm+/a6bA3n6O050itRsM4lSr/ipNX9ixS+3hd3c3ds6m
        GZy+539wVJXO0D5xW/6ai3REVs7CpdJWegLbJAPKr7Pu/Mx/K2BncY6he5Bp5yqFztuBHpOM
        X2j4x6RWzCxPVt37MX5jViCX6/25RTvXHojsmGnguyFG3Mq/Z+d8scXznnQvX8ama6PEUpyR
        aKjFXFScCAAt2I7BdAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwYcT1hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        P/71sBfss66Y/f8RawPjQcMuRk4OCQETiYfTN7N1MXJxCAnsYJS4O38hI0RCVuLZux3sELaw
        xP2WI6wQRe8ZJVYcOcECkmAT0JXY8vwVWIOIwEdGiTnftECKmAU+MkvcWbkEqIiDQ1ggUGLe
        E3eQGhYBVYmPs3awgYR5BRwkzm6Ih5gvL3HkVycziM0JFO5ZdIQJxBYSsJdY/HI2WJxXQFDi
        5MwnYGuZgeqbt85mnsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmb
        GMERqKW1g3HPqg96hxiZOBgPMUpwMCuJ8Ca55iYK8aYkVlalFuXHF5XmpBYfYpTmYFES573Q
        dTJeSCA9sSQ1OzW1ILUIJsvEwSnVwKQtvzr8j7YP3/PimLXhP3x4rMJlpc+mywpY8wpc3PYq
        XMntSBvPFPknPAV7W5RvVhnknfd6uqS9Nbe0MmGVs/J9b8u1hzQU1NfefGDxUr73PJ/9DOvf
        on9ePn60YXGPDfv2a0vbDjw7+eFYpIX3kw1LOeSUQ65EBrFGOW/rt3l1x/dUQXFQmEmwzGnD
        h2l/7JgmZAiluzg3xW3ffzv+szpv6P1S0SO2308slztzsXCt+Q+nKpviT5GNYn6dU4J0I/85
        bbD7y6JZN9/kn5JiyenK1Q/PCRdHSdTM0JcSXNd+457voyNLjq/m9Fp05Wt+mPOSZx7Siw/N
        CD3z4Lt9aqDF/xqZJTHlc9UirV72KrEUZyQaajEXFScCAI4qKjQvAwAA
X-CMS-MailID: 20211018124506epcas2p27ae65b5e8ee4919cde0d989708c24ca6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124506epcas2p27ae65b5e8ee4919cde0d989708c24ca6
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124506epcas2p27ae65b5e8ee4919cde0d989708c24ca6@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds to support ufs variant for ExynosAuto v9 SoC. This
requires control UFS IP sharability register via syscon and regmap.
The offset of the register can be different according to the ufs
instance and SoC specific offset value. So, we need to get the offset
value from DT property.
Unlike exynos7, it has different m-phy setting so it can be configured
by exynosauto_ufs_pre_link.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 118 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  18 ++++++
 2 files changed, 136 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index c9e933655322..2ff9bbd8b821 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -12,8 +12,10 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -75,6 +77,12 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
+/* FSYS UFS Shareability */
+#define UFS_WR_SHARABLE		BIT(2)
+#define UFS_RD_SHARABLE		BIT(1)
+#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
+#define UFS_SHAREABILITY_OFFSET	0x710
+
 enum {
 	UNIPRO_L1_5 = 0,/* PHY Adapter */
 	UNIPRO_L2,	/* Data Link */
@@ -150,6 +158,89 @@ static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	return 0;
 }
 
+static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
+{
+	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+
+	/* IO Coherency setting */
+	if (ufs->sysreg) {
+		return regmap_update_bits(ufs->sysreg,
+					  ufs->shareability_reg_offset,
+					  UFS_SHARABLE, UFS_SHARABLE);
+	}
+
+	attr->tx_dif_p_nsec = 3200000;
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs)
+{
+	struct ufs_hba *hba = ufs->hba;
+	int i;
+	u32 tx_line_reset_period, rx_line_reset_period;
+
+	rx_line_reset_period = (RX_LINE_RESET_TIME * ufs->mclk_rate) / NSEC_PER_MSEC;
+	tx_line_reset_period = (TX_LINE_RESET_TIME * ufs->mclk_rate) / NSEC_PER_MSEC;
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
+	for_each_ufs_rx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_CLK_PRD, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_CLK_PRD_EN, i), 0x0);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE2, i),
+			       (rx_line_reset_period >> 16) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE1, i),
+			       (rx_line_reset_period >> 8) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_RX_LINERESET_VALUE0, i),
+			       (rx_line_reset_period) & 0xFF);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x79);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
+	}
+
+	for_each_ufs_tx_lane(ufs, i) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_CLK_PRD, i),
+			       DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
+		/* Not to affect VND_TX_LINERESET_PVALUE to VND_TX_CLK_PRD */
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_CLK_PRD_EN, i),
+			       0x02);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE2, i),
+			       (tx_line_reset_period >> 16) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE1, i),
+			       (tx_line_reset_period >> 8) & 0xFF);
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VND_TX_LINERESET_PVALUE0, i),
+			       (tx_line_reset_period) & 0xFF);
+
+		/* TX PWM Gear Capability / PWM_G1_ONLY */
+		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
+	}
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
+
+	return 0;
+}
+
+static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
+					 struct ufs_pa_layer_attr *pwr)
+{
+	struct ufs_hba *hba = ufs->hba;
+
+	/* PACP_PWR_req and delivered to the remote DME */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
+
+	return 0;
+}
+
 static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
 {
 	struct ufs_hba *hba = ufs->hba;
@@ -932,6 +1023,17 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		goto out;
 	}
 
+	ufs->sysreg = syscon_regmap_lookup_by_phandle(np, "samsung,sysreg");
+	if (IS_ERR(ufs->sysreg))
+		ufs->sysreg = NULL;
+	else {
+		if (of_property_read_u32_index(np, "samsung,sysreg", 1,
+					       &ufs->shareability_reg_offset)) {
+			dev_warn(dev, "can't get an offset from sysreg. Set to default value\n");
+			ufs->shareability_reg_offset = UFS_SHAREABILITY_OFFSET;
+		}
+	}
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
@@ -1304,6 +1406,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
 	.pa_dbg_option_suite		= 0x30103,
 };
 
+static struct exynos_ufs_drv_data exynosauto_ufs_drvs = {
+	.uic_attr		= &exynos7_uic_attr,
+	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
+				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
+				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
+				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
+	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
+				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
+				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.drv_init		= exynosauto_ufs_drv_init,
+	.pre_link		= exynosauto_ufs_pre_link,
+	.pre_pwr_change		= exynosauto_ufs_pre_pwr_change,
+};
+
 static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 	.uic_attr		= &exynos7_uic_attr,
 	.quirks			= UFSHCD_QUIRK_PRDT_BYTE_GRAN |
@@ -1329,6 +1445,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
 static const struct of_device_id exynos_ufs_of_match[] = {
 	{ .compatible = "samsung,exynos7-ufs",
 	  .data	      = &exynos_ufs_drvs },
+	{ .compatible = "samsung,exynosautov9-ufs",
+	  .data	      = &exynosauto_ufs_drvs },
 	{},
 };
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 02308faea422..1c33e5466082 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -56,6 +56,22 @@
 #define TX_GRAN_NVAL_10_08	0x0296
 #define TX_GRAN_NVAL_H(v)	(((v) >> 8) & 0x3)
 
+#define VND_TX_CLK_PRD		0xAA
+#define VND_TX_CLK_PRD_EN	0xA9
+#define VND_TX_LINERESET_PVALUE0	0xAD
+#define VND_TX_LINERESET_PVALUE1	0xAC
+#define VND_TX_LINERESET_PVALUE2	0xAB
+
+#define TX_LINE_RESET_TIME	3200
+
+#define VND_RX_CLK_PRD		0x12
+#define VND_RX_CLK_PRD_EN	0x11
+#define VND_RX_LINERESET_VALUE0	0x1D
+#define VND_RX_LINERESET_VALUE1	0x1C
+#define VND_RX_LINERESET_VALUE2	0x1B
+
+#define RX_LINE_RESET_TIME	1000
+
 #define RX_FILLER_ENABLE	0x0316
 #define RX_FILLER_EN		(1 << 1)
 #define RX_LINERESET_VAL	0x0317
@@ -194,6 +210,8 @@ struct exynos_ufs {
 	struct ufs_phy_time_cfg t_cfg;
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
+	struct regmap *sysreg;
+	u32 shareability_reg_offset;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.33.0

