Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8289C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 02:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiGFCFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 22:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiGFCFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 22:05:48 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C3193D3
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 19:05:46 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220706020542epoutp037a327a71c22d288911783e7784f55d59~-Gz5Qoy7R2471024710epoutp03U
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 02:05:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220706020542epoutp037a327a71c22d288911783e7784f55d59~-Gz5Qoy7R2471024710epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657073142;
        bh=SgyZ8l5ilZvt4lKHDTMUJsYr0/9AZoIdsir7I5NlDow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6orWYVbvPlGAI2XYCsprX/aV2E8qKtLBxr241+PhURI4a0eabngI3o1wO0frRhNI
         mjEgDaI5cTwajwDxGTztmSbkcIK77tIv+tC2fKwZmdddHeg6ff+dhr1xycrTzNrHnN
         kxeXYTQcdCybfxOVBUOWVs6mBOHthCfvTi2+/NOM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220706020541epcas2p372b09352fac23d8623fe61dd10585068~-Gz4ud5wt0174501745epcas2p3F;
        Wed,  6 Jul 2022 02:05:41 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Ld2v92x6cz4x9Pr; Wed,  6 Jul
        2022 02:05:41 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.B2.09666.5FDE4C26; Wed,  6 Jul 2022 11:05:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220706020540epcas2p2895857d7b056a456b3cd02bd5dd967b5~-Gz33EdY_3183331833epcas2p2V;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220706020540epsmtrp13898be2eb7284c370e32ae8dfb58ac4a~-Gz32LJCu1465814658epsmtrp1d;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
X-AuditID: b6c32a45-45bff700000025c2-07-62c4edf53959
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        08.5B.08802.4FDE4C26; Wed,  6 Jul 2022 11:05:40 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220706020540epsmtip2fe5a9356d2fbd7266d96292872d4bb25~-Gz3mQjFl1055610556epsmtip2C;
        Wed,  6 Jul 2022 02:05:40 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v2 1/3] phy: samsung-ufs: convert phy clk usage to clk_bulk
 API
Date:   Wed,  6 Jul 2022 11:02:53 +0900
Message-Id: <20220706020255.151177-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220706020255.151177-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmme7Xt0eSDFZvELV4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGZdtkpCam
        pBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2spFCWmFMKFApI
        LC5W0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOuHzwG3vB
        Lo+KzhefWBsY19t2MXJySAiYSEx538LcxcjFISSwg1Fiyfd9TBDOJ0aJzyuvMkI4nxkl1n/9
        zAjT0t/2FapqF6PE9m/z2EESQgIfGSUONCSA2GwCuhJbnr8C6xYR2MEkcatlIguIwyywmVGi
        /epONpAqYYFAiUmNf5lAbBYBVYlpW/4DFXFw8ArYS7QfioTYJi+x4eB2FhCbU8BB4vfvXmYQ
        m1dAUOLkzCdgcWagmuats5kh6ldySPxaEwBhu0gc2vIB6mphiVfHt7BD2FISL/vboOxiiaWz
        PoF9IyHQwChxedsvNoiEscSsZ+2MIPcwC2hKrN+lD2JKCChLHLkFtZZPouPwX3aIMK9ER5sQ
        RKO6xIHt01kgbFmJ7jmfWSFKPCRmLIuBBNtkRom521YyTWBUmIXkmVlInpmFsHcBI/MqRrHU
        guLc9NRiowJDeAQn5+duYgSnXy3XHYyT337QO8TIxMF4iFGCg1lJhHfVpINJQrwpiZVVqUX5
        8UWlOanFhxhNgSE9kVlKNDkfmAHySuINTSwNTMzMDM2NTA3MlcR5vVI2JAoJpCeWpGanphak
        FsH0MXFwSjUwTWU1kLRV/OC0ZzKjmYt86Te+yIPPQm/05yoKzQyqOhhySrv/8Y+vQmIRGYsX
        m9yvE+yxXneg9K+Y3FbBDqGwlPS2nRlM6zvMikPDug1sK9UyZGtv/JKIXdOVXXl13b3nbYda
        ra9dmBZ27ODjz+FTQr8/vbHutvCy9D2Ouhop39Mjv3L4LJqRcJB9b/Ja3QyGm3927J32YUHG
        JYWbGxbt/cWhMG2a/7kOvevrHvK9LJx/lvWw1OpKl8mV/EHs5Q7HlaaluaaeEn81Yaef+3dG
        Y8XaqAijebMqjrF909xzStDhwTyzmJwrj4Kc3zZbTdafKWMUGnabeV3FnTwl1xnHnaPfpO3f
        HlPwebWJz4YVSizFGYmGWsxFxYkA6kgCMUgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSvO6Xt0eSDNb+17Z4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGcdmkpOZk
        lqUW6dslcGVcPviNvWCXR0Xni0+sDYzrbbsYOTkkBEwk+tu+MnUxcnEICexglNj89hYzREJW
        4tm7HewQtrDE/ZYjrBBF7xklVl5eBpZgE9CV2PL8FSNIQkRgD5PEl3kbWEAcZoHtjBJT3l5n
        AakSFvCX+P99N1gHi4CqxLQt/4HiHBy8AvYS7YciITbIS2w4uB2snFPAQeL3716wK4SASu59
        Wg0W5xUQlDg58wmYzQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0u
        zUvXS87P3cQIjhYtrR2Me1Z90DvEyMTBeIhRgoNZSYR31aSDSUK8KYmVValF+fFFpTmpxYcY
        pTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwKTx99+HUXJGVnsGr58bKHHbP56gXZD7G
        ctS93duXXfff7pRXV/Zen8vC76P2Seao7IKzzDunbFjW7zktKF12+pSDjSadd2re32izmfFi
        as6Wfzcy2i/UlHN43y98bVLf8Jk93PCIm0N57KZuuYdrt3+ecWaOQ2OG27xSz42Zay4sm3X9
        sUKvUPE3s6Qc0+gE4SixvjVtTPPOH5RX+r9/bZmtveaKsvZSw0W3r1k+ebcrx5NZ4eGPw0mB
        i3dOjrq/fLEPU9rDbypHBJnO2hxaX/BvLvNE5+nSsUvizY1vP5vYFmMgJvNgpU1yBk+l3uS6
        U4dOt1sE5m/4LpS0061hXatlfJHJ36Oiy2/bcu+YpsRSnJFoqMVcVJwIAAB0qDoFAwAA
X-CMS-MailID: 20220706020540epcas2p2895857d7b056a456b3cd02bd5dd967b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220706020540epcas2p2895857d7b056a456b3cd02bd5dd967b5
References: <20220706020255.151177-1-chanho61.park@samsung.com>
        <CGME20220706020540epcas2p2895857d7b056a456b3cd02bd5dd967b5@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using separated clock manipulation, this converts the phy
clock usage to be clk_bulk APIs. By using this, we can completely
remove has_symbol_clk check and symbol clk variables.
Furthermore, clk_get should be moved to probe because there is no need
to get them in the phy_init callback.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/phy/samsung/phy-exynos7-ufs.c      |  7 +-
 drivers/phy/samsung/phy-exynosautov9-ufs.c |  7 +-
 drivers/phy/samsung/phy-fsd-ufs.c          |  7 +-
 drivers/phy/samsung/phy-samsung-ufs.c      | 99 +++++-----------------
 drivers/phy/samsung/phy-samsung-ufs.h      | 10 +--
 5 files changed, 42 insertions(+), 88 deletions(-)

diff --git a/drivers/phy/samsung/phy-exynos7-ufs.c b/drivers/phy/samsung/phy-exynos7-ufs.c
index 72854336f59d..a982e7c128c5 100644
--- a/drivers/phy/samsung/phy-exynos7-ufs.c
+++ b/drivers/phy/samsung/phy-exynos7-ufs.c
@@ -68,6 +68,10 @@ static const struct samsung_ufs_phy_cfg *exynos7_ufs_phy_cfgs[CFG_TAG_MAX] = {
 	[CFG_POST_PWR_HS]	= exynos7_post_pwr_hs_cfg,
 };
 
+static const char * const exynos7_ufs_phy_clks[] = {
+	"tx0_symbol_clk", "rx0_symbol_clk", "rx1_symbol_clk", "ref_clk",
+};
+
 const struct samsung_ufs_phy_drvdata exynos7_ufs_phy = {
 	.cfgs = exynos7_ufs_phy_cfgs,
 	.isol = {
@@ -75,6 +79,7 @@ const struct samsung_ufs_phy_drvdata exynos7_ufs_phy = {
 		.mask = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK,
 		.en = EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN,
 	},
-	.has_symbol_clk = 1,
+	.clk_list = exynos7_ufs_phy_clks,
+	.num_clks = ARRAY_SIZE(exynos7_ufs_phy_clks),
 	.cdr_lock_status_offset = EXYNOS7_EMBEDDED_COMBO_PHY_CDR_LOCK_STATUS,
 };
diff --git a/drivers/phy/samsung/phy-exynosautov9-ufs.c b/drivers/phy/samsung/phy-exynosautov9-ufs.c
index 2b256070d657..49e2bcbef0b4 100644
--- a/drivers/phy/samsung/phy-exynosautov9-ufs.c
+++ b/drivers/phy/samsung/phy-exynosautov9-ufs.c
@@ -57,6 +57,10 @@ static const struct samsung_ufs_phy_cfg *exynosautov9_ufs_phy_cfgs[CFG_TAG_MAX]
 	[CFG_PRE_PWR_HS]	= exynosautov9_pre_pwr_hs_cfg,
 };
 
+static const char * const exynosautov9_ufs_phy_clks[] = {
+	"ref_clk",
+};
+
 const struct samsung_ufs_phy_drvdata exynosautov9_ufs_phy = {
 	.cfgs = exynosautov9_ufs_phy_cfgs,
 	.isol = {
@@ -64,6 +68,7 @@ const struct samsung_ufs_phy_drvdata exynosautov9_ufs_phy = {
 		.mask = EXYNOSAUTOV9_EMBEDDED_COMBO_PHY_CTRL_MASK,
 		.en = EXYNOSAUTOV9_EMBEDDED_COMBO_PHY_CTRL_EN,
 	},
-	.has_symbol_clk = 0,
+	.clk_list = exynosautov9_ufs_phy_clks,
+	.num_clks = ARRAY_SIZE(exynosautov9_ufs_phy_clks),
 	.cdr_lock_status_offset = EXYNOSAUTOV9_EMBEDDED_COMBO_PHY_CDR_LOCK_STATUS,
 };
diff --git a/drivers/phy/samsung/phy-fsd-ufs.c b/drivers/phy/samsung/phy-fsd-ufs.c
index c78b6c16027d..d36cabd53434 100644
--- a/drivers/phy/samsung/phy-fsd-ufs.c
+++ b/drivers/phy/samsung/phy-fsd-ufs.c
@@ -46,6 +46,10 @@ static const struct samsung_ufs_phy_cfg *fsd_ufs_phy_cfgs[CFG_TAG_MAX] = {
 	[CFG_POST_PWR_HS]	= fsd_post_pwr_hs_cfg,
 };
 
+static const char * const fsd_ufs_phy_clks[] = {
+	"ref_clk",
+};
+
 const struct samsung_ufs_phy_drvdata fsd_ufs_phy = {
 	.cfgs = fsd_ufs_phy_cfgs,
 	.isol = {
@@ -53,6 +57,7 @@ const struct samsung_ufs_phy_drvdata fsd_ufs_phy = {
 		.mask = FSD_EMBEDDED_COMBO_PHY_CTRL_MASK,
 		.en = FSD_EMBEDDED_COMBO_PHY_CTRL_EN,
 	},
-	.has_symbol_clk = 0,
+	.clk_list = fsd_ufs_phy_clks,
+	.num_clks = ARRAY_SIZE(fsd_ufs_phy_clks),
 	.cdr_lock_status_offset = FSD_EMBEDDED_COMBO_PHY_CDR_LOCK_STATUS,
 };
diff --git a/drivers/phy/samsung/phy-samsung-ufs.c b/drivers/phy/samsung/phy-samsung-ufs.c
index e4334529ffbc..14cce2f2487e 100644
--- a/drivers/phy/samsung/phy-samsung-ufs.c
+++ b/drivers/phy/samsung/phy-samsung-ufs.c
@@ -131,73 +131,21 @@ static int samsung_ufs_phy_calibrate(struct phy *phy)
 	return err;
 }
 
-static int samsung_ufs_phy_symbol_clk_init(struct samsung_ufs_phy *phy)
-{
-	int ret;
-
-	phy->tx0_symbol_clk = devm_clk_get(phy->dev, "tx0_symbol_clk");
-	if (IS_ERR(phy->tx0_symbol_clk)) {
-		dev_err(phy->dev, "failed to get tx0_symbol_clk clock\n");
-		return PTR_ERR(phy->tx0_symbol_clk);
-	}
-
-	phy->rx0_symbol_clk = devm_clk_get(phy->dev, "rx0_symbol_clk");
-	if (IS_ERR(phy->rx0_symbol_clk)) {
-		dev_err(phy->dev, "failed to get rx0_symbol_clk clock\n");
-		return PTR_ERR(phy->rx0_symbol_clk);
-	}
-
-	phy->rx1_symbol_clk = devm_clk_get(phy->dev, "rx1_symbol_clk");
-	if (IS_ERR(phy->rx1_symbol_clk)) {
-		dev_err(phy->dev, "failed to get rx1_symbol_clk clock\n");
-		return PTR_ERR(phy->rx1_symbol_clk);
-	}
-
-	ret = clk_prepare_enable(phy->tx0_symbol_clk);
-	if (ret) {
-		dev_err(phy->dev, "%s: tx0_symbol_clk enable failed %d\n", __func__, ret);
-		goto out;
-	}
-
-	ret = clk_prepare_enable(phy->rx0_symbol_clk);
-	if (ret) {
-		dev_err(phy->dev, "%s: rx0_symbol_clk enable failed %d\n", __func__, ret);
-		goto out_disable_tx0_clk;
-	}
-
-	ret = clk_prepare_enable(phy->rx1_symbol_clk);
-	if (ret) {
-		dev_err(phy->dev, "%s: rx1_symbol_clk enable failed %d\n", __func__, ret);
-		goto out_disable_rx0_clk;
-	}
-
-	return 0;
-
-out_disable_rx0_clk:
-	clk_disable_unprepare(phy->rx0_symbol_clk);
-out_disable_tx0_clk:
-	clk_disable_unprepare(phy->tx0_symbol_clk);
-out:
-	return ret;
-}
-
 static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy)
 {
-	int ret;
-
-	phy->ref_clk = devm_clk_get(phy->dev, "ref_clk");
-	if (IS_ERR(phy->ref_clk))
-		dev_err(phy->dev, "failed to get ref_clk clock\n");
+	int i;
+	const struct samsung_ufs_phy_drvdata *drvdata = phy->drvdata;
+	int num_clks = drvdata->num_clks;
 
-	ret = clk_prepare_enable(phy->ref_clk);
-	if (ret) {
-		dev_err(phy->dev, "%s: ref_clk enable failed %d\n", __func__, ret);
-		return ret;
-	}
+	phy->clks = devm_kcalloc(phy->dev, num_clks, sizeof(*phy->clks),
+				 GFP_KERNEL);
+	if (!phy->clks)
+		return -ENOMEM;
 
-	dev_dbg(phy->dev, "UFS MPHY ref_clk_rate = %ld\n", clk_get_rate(phy->ref_clk));
+	for (i = 0; i < num_clks; i++)
+		phy->clks[i].id = drvdata->clk_list[i];
 
-	return 0;
+	return devm_clk_bulk_get(phy->dev, num_clks, phy->clks);
 }
 
 static int samsung_ufs_phy_init(struct phy *phy)
@@ -208,16 +156,12 @@ static int samsung_ufs_phy_init(struct phy *phy)
 	ss_phy->lane_cnt = phy->attrs.bus_width;
 	ss_phy->ufs_phy_state = CFG_PRE_INIT;
 
-	if (ss_phy->has_symbol_clk) {
-		ret = samsung_ufs_phy_symbol_clk_init(ss_phy);
-		if (ret)
-			dev_err(ss_phy->dev, "failed to set ufs phy symbol clocks\n");
+	ret = clk_bulk_prepare_enable(ss_phy->drvdata->num_clks, ss_phy->clks);
+	if (ret) {
+		dev_err(ss_phy->dev, "failed to enable ufs phy clocks\n");
+		return ret;
 	}
 
-	ret = samsung_ufs_phy_clks_init(ss_phy);
-	if (ret)
-		dev_err(ss_phy->dev, "failed to set ufs phy clocks\n");
-
 	ret = samsung_ufs_phy_calibrate(phy);
 	if (ret)
 		dev_err(ss_phy->dev, "ufs phy calibration failed\n");
@@ -258,13 +202,7 @@ static int samsung_ufs_phy_exit(struct phy *phy)
 {
 	struct samsung_ufs_phy *ss_phy = get_samsung_ufs_phy(phy);
 
-	clk_disable_unprepare(ss_phy->ref_clk);
-
-	if (ss_phy->has_symbol_clk) {
-		clk_disable_unprepare(ss_phy->tx0_symbol_clk);
-		clk_disable_unprepare(ss_phy->rx0_symbol_clk);
-		clk_disable_unprepare(ss_phy->rx1_symbol_clk);
-	}
+	clk_bulk_disable_unprepare(ss_phy->drvdata->num_clks, ss_phy->clks);
 
 	return 0;
 }
@@ -330,7 +268,6 @@ static int samsung_ufs_phy_probe(struct platform_device *pdev)
 	phy->dev = dev;
 	phy->drvdata = drvdata;
 	phy->cfgs = drvdata->cfgs;
-	phy->has_symbol_clk = drvdata->has_symbol_clk;
 	memcpy(&phy->isol, &drvdata->isol, sizeof(phy->isol));
 
 	if (!of_property_read_u32_index(dev->of_node, "samsung,pmu-syscon", 1,
@@ -339,6 +276,12 @@ static int samsung_ufs_phy_probe(struct platform_device *pdev)
 
 	phy->lane_cnt = PHY_DEF_LANE_CNT;
 
+	err = samsung_ufs_phy_clks_init(phy);
+	if (err) {
+		dev_err(dev, "failed to get phy clocks\n");
+		goto out;
+	}
+
 	phy_set_drvdata(gen_phy, phy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
diff --git a/drivers/phy/samsung/phy-samsung-ufs.h b/drivers/phy/samsung/phy-samsung-ufs.h
index 6320ac852f29..e122960cfee8 100644
--- a/drivers/phy/samsung/phy-samsung-ufs.h
+++ b/drivers/phy/samsung/phy-samsung-ufs.h
@@ -109,7 +109,8 @@ struct samsung_ufs_phy_pmu_isol {
 struct samsung_ufs_phy_drvdata {
 	const struct samsung_ufs_phy_cfg **cfgs;
 	struct samsung_ufs_phy_pmu_isol isol;
-	bool has_symbol_clk;
+	const char * const *clk_list;
+	int num_clks;
 	u32 cdr_lock_status_offset;
 };
 
@@ -117,15 +118,10 @@ struct samsung_ufs_phy {
 	struct device *dev;
 	void __iomem *reg_pma;
 	struct regmap *reg_pmu;
-	struct clk *ref_clk;
-	struct clk *ref_clk_parent;
-	struct clk *tx0_symbol_clk;
-	struct clk *rx0_symbol_clk;
-	struct clk *rx1_symbol_clk;
+	struct clk_bulk_data *clks;
 	const struct samsung_ufs_phy_drvdata *drvdata;
 	const struct samsung_ufs_phy_cfg * const *cfgs;
 	struct samsung_ufs_phy_pmu_isol isol;
-	bool has_symbol_clk;
 	u8 lane_cnt;
 	int ufs_phy_state;
 	enum phy_mode mode;
-- 
2.37.0

