Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337A4CCA482
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 06:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiGEG5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 02:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiGEG5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 02:57:34 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B967E1147C
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 23:57:29 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220705065723epoutp0102d17c2d0888b52e390acd5c6e58f769~_3JSbnA510259902599epoutp01V
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 06:57:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220705065723epoutp0102d17c2d0888b52e390acd5c6e58f769~_3JSbnA510259902599epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657004243;
        bh=beDNbN5+hVC4ohLyniAKT+fD+NWS3tAHbhrqM23SPvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqvCkc71j/214rvN968e8DJitYj/9zD8B3mzxcORj7fUY1BMq95rZi64Ex88faVTk
         NhsDmLoE5DWYp0viXQFe6grLnvPFfz7Cv6EAks6ULkP/qmfl9EAV4/zht5oABGcYB3
         PHfszYJiVLRGiffXGvx4j8I7QukpCl3qRd5VogFo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220705065723epcas2p17b5d5e413f6df7568816389bad9cf079~_3JR8Xjn20425204252epcas2p1O;
        Tue,  5 Jul 2022 06:57:23 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.70]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LcYQB6GXRz4x9Q4; Tue,  5 Jul
        2022 06:57:22 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.D4.09662.2D0E3C26; Tue,  5 Jul 2022 15:57:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220705065722epcas2p2973795cc88ee436480abcb48435059a8~_3JRKAGSS2076820768epcas2p2X;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220705065722epsmtrp126994bbd1d4e3de06c09b2d2ba853d92~_3JRJIp-Y0044600446epsmtrp1T;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
X-AuditID: b6c32a48-9f7ff700000025be-20-62c3e0d2aad3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.9C.08905.2D0E3C26; Tue,  5 Jul 2022 15:57:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220705065722epsmtip162659f880acf5aa45d675f4d8dc4184f~_3JQ8u4Zp3025130251epsmtip1C;
        Tue,  5 Jul 2022 06:57:22 +0000 (GMT)
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
Subject: [PATCH 1/3] phy: samsung-ufs: convert phy clk usage to clk_bulk API
Date:   Tue,  5 Jul 2022 15:54:38 +0900
Message-Id: <20220705065440.117864-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705065440.117864-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmqe6lB4eTDFZ807N4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGZdtkpCam
        pBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2spFCWmFMKFApI
        LC5W0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOOHBqF3vB
        d/eK59fqGhg/2nQxcnJICJhILHt+gLGLkYtDSGAHo8S1yV8ZQRJCAp8YJT5N8oBIfGOU+Hq6
        mbWLkQOso6lbFCK+l1FiwZHzzBDOR0aJg11TwLrZBHQltjx/BTZWRGAHk8StloksIA6zwGZG
        ifarO9lAqoQFfCQ6+vYwg9gsAqoS1xZ/AYvzCthLPD+7mB3iQHmJDQe3s4DYnAIOEic/TmeB
        qBGUODnzCZjNDFTTvHU22BkSAks5JJqnNTBB3OoiceCrEcQcYYlXx7dAzZSSeNnfBmUXSyyd
        9YkJoreBUeLytl9sEAljiVnP2hlB5jALaEqs36UPMVJZ4sgtqLV8Eh2H/7JDhHklOtqEIBrV
        JQ5sh7hSQkBWonvOZ1YI20Ni561fLJDAmswo8f72TpYJjAqzkHwzC8k3sxAWL2BkXsUollpQ
        nJueWmxUYAKP4OT83E2M4PSr5bGDcfbbD3qHGJk4GA8xSnAwK4nwrpp0MEmINyWxsiq1KD++
        qDQntfgQoykwrCcyS4km5wMzQF5JvKGJpYGJmZmhuZGpgbmSOK9XyoZEIYH0xJLU7NTUgtQi
        mD4mDk6pBqalb8rTfp3f8vbx3U7WG35u3NvFt0sH+Hx/UH1w322Vw0EluQ/3/rkw6+LuRb23
        DFc38DIzuKSLx4l2bJr657vrxzaBdbHiNRUZ/adnJEcvYpR7wPDCQfn/Rjsxp5dOG0+ej/uR
        nctyaQpzrGWcZHDODJ5Wnofu3R++Z4nfSw77Jil8NeV3IFdu1XsjixsLFz9N2bns48OaSY8X
        2HkoByV8sOtjKBSfuTvpml1gkcjMyy77880LTwh43ne9/NRhc0rXDd3PPmHPV/jnKRacqN/B
        NOuGs9uazLdpauzmNs/7Dgl88/+f0VCgseTEqQO1k/7cyxbZfPX9LXmZNPn5L+ew3hWv1Fy4
        7Fx4TMC+RFclluKMREMt5qLiRAAaVyX/SAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSnO6lB4eTDH5dErR4MG8bm8W0Dz+Z
        LS7v17ZYdGMbk8WFpz1sFntfb2W32PT4GqvFhFXfWCxmnN/HZNF9fQebxfLj/5gsdt45wezA
        43H5irfHplWdbB53ru1h85iw6ACjx+Yl9R4fn95i8ejbsorR4/iN7UwenzfJBXBGcdmkpOZk
        lqUW6dslcGUcOLWLveC7e8Xza3UNjB9tuhg5OCQETCSaukW7GLk4hAR2M0r8e9PI1MXICRSX
        lXj2bgc7hC0scb/lCCtE0XtGiSkXO5hBEmwCuhJbnr9iBEmICOxhkvgybwMLiMMssB2o6u11
        FpAqYQEfiY6+PWAdLAKqEtcWf2EDsXkF7CWen10MtUJeYsPB7WD1nAIOEic/TgezhYBq/j2+
        xg5RLyhxcuYTsDgzUH3z1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQv
        XS85P3cTIzhWtDR3MG5f9UHvECMTB+MhRgkOZiUR3lWTDiYJ8aYkVlalFuXHF5XmpBYfYpTm
        YFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwKQ9d2NW01KHqfp99ncer55i9UlpwroXE54l
        nM2yN7ta7mpXzd17ZNfU6Nn5L/vWR+pvbG/XKe3awXwoQpNFVOsE+6wrHZ8eql11jjYRO8b7
        rHuh5B+GJXK2i+o9K6008yodKr6UfzYs2q5zanump/t8qa7DKhlvntxwU3m+9X65W5lBr9a8
        k9cFN7lkufUxLHY3e8z6IUTa0WPL8/+/O5qFw16+zT8pUnxy4v696U9/ZVlNC1XTEBHmnFB0
        ODjuS9JcjvhGxXanSfuLd1Z+VE46sib/48lVJ46fU98UFa69fPes2ac07zW3T8pQfOnnzVR6
        4xybcdleoyW+89LLl5VyH/EKvHWCfWH2Fo3dpkosxRmJhlrMRcWJABK429QEAwAA
X-CMS-MailID: 20220705065722epcas2p2973795cc88ee436480abcb48435059a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220705065722epcas2p2973795cc88ee436480abcb48435059a8
References: <20220705065440.117864-1-chanho61.park@samsung.com>
        <CGME20220705065722epcas2p2973795cc88ee436480abcb48435059a8@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of using separated clock manipulation, this converts the phy
clock usage to be clk_bulk APIs. By using this, we can completely
remove has_symbol_clk check and symbol clk variables.
Furthermore, clk_get should be moved to probe because there is no need
to get them in the phy_init callback.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
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

