Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EC5C4167B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DAB6101B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbhJGIOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42995 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbhJGIOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:03 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081208epoutp012d1421ca406651855b35e8a98c98501b~rsWMRV-Aa1840918409epoutp01j
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081208epoutp012d1421ca406651855b35e8a98c98501b~rsWMRV-Aa1840918409epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594328;
        bh=Z0rWVibAhHHOcnmo5iFYLjOXpfmrEYDiWJZHkn/MLsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmoC2p48E4bPcf20Ia+dildI5dUEjM3TMmykEL9H1+9P1YBDdiQex14+P2zVmqyVE
         CXbhRz6bhpCCryWN6QEt9pWA1TdAKH4v3D8LiergIGrAW4u6LPwVAqjlx3kb/Qc1Hx
         1Ard8oZlu2rBA7jdKpLxToAb+CTSeK8blBjFVftA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081151epcas2p1fb7daaae8d0787a82d32ca0a82458340~rsV7031z40387803878epcas2p1Q;
        Thu,  7 Oct 2021 08:11:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3v23Bpjz4x9QH; Thu,  7 Oct
        2021 08:11:42 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.6F.09717.BBBAE516; Thu,  7 Oct 2021 17:11:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081135epcas2p365e055851e41fa5e95e00e641037da41~rsVtAxp_q0719807198epcas2p3E;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081135epsmtrp246de425973729da0f937e1407f156727~rsVs18EWu2686726867epsmtrp29;
        Thu,  7 Oct 2021 08:11:35 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-47-615eabbb0675
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.B7.08750.6BBAE516; Thu,  7 Oct 2021 17:11:35 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip27b2ee5f9df94210f3a934ae7b8a477c7~rsVsoXDDp0566205662epsmtip2-;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
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
Subject: [PATCH v4 12/16] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Thu,  7 Oct 2021 17:09:30 +0900
Message-Id: <20211007080934.108804-13-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeubdcLm41d0XcgYk21z0CCLZI4ThhiIhesJtkxBlIBl7hjgKl
        bXpbw7Zk8n5jcDgc1SlCprNAEKiMgU4sIBOMZmOLgFsQV8YgQeVhpDjYSls3//t+3/m+8/t9
        50HiIgvhRaapdJxWxSppYo2gvcdH5t/VkMhKLpbR6KalkUD3z7QTaMr6K4Guj5cIUPVjK47m
        ms+7oKFrfqj8+0g0WFmHIUuzAUd1w+0YGl4qdEEtM4sYGjH1CdBXd37AUNndDgJd6F/B0DOr
        GdspYoZ+2ccYsisIZuhYBca0fevL1F+ZwphWYwnBVNZ1A+ZpczHBzE6MCphjJiNg5ls3MkXd
        ZVjsKwkZoQqOTeG0Yk6VrE5JU6WG0fvikiKTZMESqb90OwqhxSo2kwujd8tj/fekKW3haPER
        Vqm3UbEsz9Nb3w3VqvU6TqxQ87owmtOkKDUhmgCezeT1qtQAFad7RyqRBMpswkMZillzLdAM
        78j6O28Aywa/S0uBGwmpIJjffg4vBWtIEdUB4IPB08BRzAGYPXuXcBTzALbmD7k8t8wZW5yW
        TgAHC3JdHcUsgNe+HCdWVQTlD02T0/a91lGPALT8ccKuwqkJHJ5ZrLCr3Kk4OGAw4atYQL0J
        2xZGbDxJCqmd0NjjbLcJ9i6V2CVuNvpKZ5PdKqRehTdrLIJVjNs0eZdP2UeC1F8kbCo5K3CY
        d8OuMSPmwO5wut/k6sBecP7hVcJhKAOw4ME/zoUGAEty5A4cDpdOmlxWB8IpH9jcuXUVQmoz
        7B119l0Li3uWXR20EBYXihzGt2H3dyedE3jDstPzzigMnOxqcR5pFYAj/fOgEogNL8QxvBDH
        8H/jWoAbwXpOw2emcnygRvrfHSerM1uB/bn7RnWAqpnHAWaAkcAMIInT64Tq8I9YkTCF/eRT
        TqtO0uqVHG8GMttZH8e9PJLVtv+i0iVJg7ZLgoKDpSGBMkkI/Zrw65VdrIhKZXVcBsdpOO1z
        H0a6eWVjWeHIPebpnl3WGe/y/e/Lx3IjtSs3Dg8cfVgk0edc1X7e90bdN5eq5foPU5vH8qpj
        fpOWdz/JWkvfe6nG6v3eoOo+wy+NH72xfGSQ17myfVxQ4/SpgjiFd+jlvazRD79UnK3drPvz
        WaMF5S58tmWk7a0DoZ5nt1Xc+tkjPr3z3rl07KDQYjHvzae2bAxP7CGUbNXHuuPRaR4/TW7a
        gLuJPaNnRuUD1ni/qChSfmdF7TNxviHytiyzUD8UMfX6hX5yYNmjfn+C/6PEWs60pIhIz7sl
        3BFz/eJit6BIllATPfZkoV0ZT9SP57hObMMOrD/sGdH7wcsHb2+YOyFu+vGL0kNjtIBXsFJf
        XMuz/wKDZw6edwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO721XGJBpu6mSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCyuLnlKIvFjPP7mCy6r+9gs1h+/B+Txe+fh5gchDwuX/H2mNXQy+Zxua+XyWPzCi2PxXte
        MnlsWtXJ5jFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgy
        Ph5awFhww7riT/MppgbGu4ZdjJwcEgImEp9WbWTuYuTiEBLYwSjx6WknC0RCVuLZux3sELaw
        xP2WI6wQRe8ZJV68PAyWYBPQldjy/BUjiC0i8JFRYs43LZAiZoGPzBJ3Vi4BmyQsEChx+v1j
        sAYWAVWJzV9usnUxcnDwCjhIrDrMCrFAXuLIr05mEJsTKLxn11qwEiEBe4muv5EgYV4BQYmT
        M5+ATWQGKm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525i
        BEegltYOxj2rPugdYmTiYDzEKMHBrCTCm28fmyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LX
        yXghgfTEktTs1NSC1CKYLBMHp1QDU8hP2VTPxjuylt4v780z0eWUWbVh08QPiwJZr9gc2HLM
        vn/6agH+uglKM3Ni+7JY99mwrfjJ3hku8M9stsLjfjfXlJ7QLqOJXbHp/M8fBIWucHu8uiqB
        X11br0nMNGzfci+j9tO/fGasLmcX+Pt6yoQNX73cF6afMyqWcni293F6xMf9MVXcau07D+kr
        PbEweCj/9csWA6O5u6p66nzza6o8XodbXBcLjfIKWmIXPkcoS/7DgUy/63XhtkEVgrY61t/f
        CyQnWh7bkm7/gD+g9Gh/3seq8NxPGhLXc9iPnVjL63nfXj6D7VVh6vxtZYfCuBq+hoXccF3W
        YSN04irDsvr/HME8c09JZwiYv1BiKc5INNRiLipOBABBWxZ7LwMAAA==
X-CMS-MailID: 20211007081135epcas2p365e055851e41fa5e95e00e641037da41
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p365e055851e41fa5e95e00e641037da41
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p365e055851e41fa5e95e00e641037da41@epcas2p3.samsung.com>
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
 drivers/scsi/ufs/ufs-exynos.c | 119 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  18 +++++
 2 files changed, 137 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index ae85942c08ae..9d32f19395b8 100644
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
@@ -932,6 +1023,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		goto out;
 	}
 
+	ufs->sysreg = syscon_regmap_lookup_by_phandle(np, "samsung,sysreg");
+	if (IS_ERR(ufs->sysreg))
+		ufs->sysreg = NULL;
+	else {
+		if (of_property_read_u32(np,
+					 "samsung,ufs-shareability-reg-offset",
+					 &ufs->shareability_reg_offset)) {
+			dev_warn(dev, "ufs-shareability-reg-offset is not specified. Set to default value\n");
+			ufs->shareability_reg_offset = UFS_SHAREABILITY_OFFSET;
+		}
+	}
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
@@ -1300,6 +1403,20 @@ static struct exynos_ufs_uic_attr exynos7_uic_attr = {
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
@@ -1325,6 +1442,8 @@ static struct exynos_ufs_drv_data exynos_ufs_drvs = {
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

