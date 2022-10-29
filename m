Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE2EC38A02
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJ2ORw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJ2ORZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:17:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1635F7DD
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e4so7109595pfl.2
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOMm8BaOvfEJM7NF+uICaNkya2n9h9Ru0iVe5CxvYeE=;
        b=Cu+M3uSkfljr/GyQWX3BrmFRiA0yhF3F9il+A4srLwErnN2elI4aKL9n4tbUbhmwSj
         tVb3J86z32atPqD70Nn8G/KGwgChE/T2hx6FIsuZx7orKCz1ozBogB4d7wM0IFVyoJT6
         iwurglsAIT+Wsbpx8p1bIdnT5rnB6XOneVPKwrVumQx4jqI0OyDYGMsT65zNB1oH5Rnq
         Q2eIKlxbAXpe21Q5GA+idVBZUhV8ZxSaCxSYdBFdwglMN+aNuP4SQVHz1EmUMEpJ2mR3
         xF6BSzDuuH2LFZL0L4KxGMxIuw4EjrjA8g4zK2UUXyEk4QjZ0T1TYPefZmt0v5yfrT/X
         s3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOMm8BaOvfEJM7NF+uICaNkya2n9h9Ru0iVe5CxvYeE=;
        b=zDebcqd43YhVdvJ4oWBnFR4OLPxyPaSr1kE5WdX6oVSoBKvq7sLPH5ZaGIj6oQJuS+
         ehpHoMdcn0kXjzEa4PCpa5WqL9q0ZTwPC1dJSrPuTMwgbVPmSmp8PUwJduNZOO3stjxJ
         RK1CdYUeQWGKmmvWvStIM3aBcE269lYFEkhMKNfaOkTgqtuthEpKPAxtkJ2HCfJvfcIi
         swVt3wYv1wc4VzVH8MGnGsq0w0JEMSgGKpOB3WGTmHvKHGMb28VT5r32IIk0sLdPTNzs
         XXVC+v2d1quPJTRpOXWvAo4mpLiDvI3bYPJZfcIoenyAksSoclJporYWkSGkt4yD7oIq
         hXxw==
X-Gm-Message-State: ACrzQf1T5e8tETTj/VA1+ExwqoXjNhSNJJ0V0pUWLacW1fgPM0L2sy9a
        Mi/luq8sLfz/+TrkxkO4uP0u
X-Google-Smtp-Source: AMsMyM64kF9+lfMT4V+UR8pVmKJSCyWeW2UbFSOLCQIIsgyRLbEnp0+/dD9je70O9TUKRj17uYSBJw==
X-Received: by 2002:a63:8942:0:b0:46e:c02e:2eb5 with SMTP id v63-20020a638942000000b0046ec02e2eb5mr4212687pgd.141.1667053030836;
        Sat, 29 Oct 2022 07:17:10 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:17:09 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 05/15] phy: qcom-qmp-ufs: Move HS Rate B register setting to tables_hs_b
Date:   Sat, 29 Oct 2022 19:46:23 +0530
Message-Id: <20221029141633.295650-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since now there is support for configuring the HS Rate B mode properly,
let's move the register setting to tables_hs_b struct for all SoCs.

This allows the PHY to be configured in Rate A initially and then in
Rate B if requested by the UFS driver.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 32 +++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index fa7457c0202b..c55c85a8f95e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -228,8 +228,9 @@ static const struct qmp_phy_init_tbl sm6115_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_BG_TRIM, 0x0f),
 	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_INITVAL1, 0xff),
 	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_INITVAL2, 0x00),
+};
 
-	/* Rate B */
+static const struct qmp_phy_init_tbl sm6115_ufsphy_hs_b_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_VCO_TUNE_MAP, 0x44),
 };
 
@@ -305,8 +306,9 @@ static const struct qmp_phy_init_tbl sdm845_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V3_COM_VCO_TUNE2_MODE1, 0x00),
 	QMP_PHY_INIT_CFG(QSERDES_V3_COM_LOCK_CMP1_MODE1, 0x32),
 	QMP_PHY_INIT_CFG(QSERDES_V3_COM_LOCK_CMP2_MODE1, 0x0f),
+};
 
-	/* Rate B */
+static const struct qmp_phy_init_tbl sdm845_ufsphy_hs_b_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V3_COM_VCO_TUNE_MAP, 0x44),
 };
 
@@ -371,8 +373,9 @@ static const struct qmp_phy_init_tbl sm8150_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V4_COM_LOCK_CMP2_MODE1, 0x0f),
 	QMP_PHY_INIT_CFG(QSERDES_V4_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xdd),
 	QMP_PHY_INIT_CFG(QSERDES_V4_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
+};
 
-	/* Rate B */
+static const struct qmp_phy_init_tbl sm8150_ufsphy_hs_b_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V4_COM_VCO_TUNE_MAP, 0x06),
 };
 
@@ -492,8 +495,9 @@ static const struct qmp_phy_init_tbl sm8350_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V5_COM_LOCK_CMP2_MODE1, 0x1e),
 	QMP_PHY_INIT_CFG(QSERDES_V5_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xdd),
 	QMP_PHY_INIT_CFG(QSERDES_V5_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
+};
 
-	/* Rate B */
+static const struct qmp_phy_init_tbl sm8350_ufsphy_hs_b_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V5_COM_VCO_TUNE_MAP, 0x06),
 };
 
@@ -746,6 +750,10 @@ static const struct qmp_phy_cfg sdm845_ufsphy_cfg = {
 		.pcs		= sdm845_ufsphy_pcs,
 		.pcs_num	= ARRAY_SIZE(sdm845_ufsphy_pcs),
 	},
+	.tables_hs_b = {
+		.serdes		= sdm845_ufsphy_hs_b_serdes,
+		.serdes_num	= ARRAY_SIZE(sdm845_ufsphy_hs_b_serdes),
+	},
 	.clk_list		= sdm845_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sdm845_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
@@ -772,6 +780,10 @@ static const struct qmp_phy_cfg sm6115_ufsphy_cfg = {
 		.pcs		= sm6115_ufsphy_pcs,
 		.pcs_num	= ARRAY_SIZE(sm6115_ufsphy_pcs),
 	},
+	.tables_hs_b = {
+		.serdes		= sm6115_ufsphy_hs_b_serdes,
+		.serdes_num	= ARRAY_SIZE(sm6115_ufsphy_hs_b_serdes),
+	},
 	.clk_list		= sdm845_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sdm845_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
@@ -797,6 +809,10 @@ static const struct qmp_phy_cfg sm8150_ufsphy_cfg = {
 		.pcs		= sm8150_ufsphy_pcs,
 		.pcs_num	= ARRAY_SIZE(sm8150_ufsphy_pcs),
 	},
+	.tables_hs_b = {
+		.serdes		= sm8150_ufsphy_hs_b_serdes,
+		.serdes_num	= ARRAY_SIZE(sm8150_ufsphy_hs_b_serdes),
+	},
 	.clk_list		= sdm845_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sdm845_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
@@ -829,6 +845,10 @@ static const struct qmp_phy_cfg sm8250_ufsphy_cfg = {
 		.pcs		= sm8250_ufsphy_hs_g4_pcs,
 		.pcs_num	= ARRAY_SIZE(sm8250_ufsphy_hs_g4_pcs),
 	},
+	.tables_hs_b = {
+		.serdes		= sm8150_ufsphy_hs_b_serdes,
+		.serdes_num	= ARRAY_SIZE(sm8150_ufsphy_hs_b_serdes),
+	},
 	.clk_list		= sdm845_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sdm845_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
@@ -853,6 +873,10 @@ static const struct qmp_phy_cfg sm8350_ufsphy_cfg = {
 		.pcs		= sm8350_ufsphy_pcs,
 		.pcs_num	= ARRAY_SIZE(sm8350_ufsphy_pcs),
 	},
+	.tables_hs_b = {
+		.serdes		= sm8350_ufsphy_hs_b_serdes,
+		.serdes_num	= ARRAY_SIZE(sm8350_ufsphy_hs_b_serdes),
+	},
 	.clk_list		= sdm845_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sdm845_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
-- 
2.25.1

