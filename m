Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48456C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiLARoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLARoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:44:01 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377EABA1E
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:43:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id h28so2535561pfq.9
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8Prfpr3oc2tLft1FOD4p/J5s4+OQsVjEgvPH1u5Vbs=;
        b=Xw9CRciIz53PZPdMk7lkngGz8gXxTKgi6VJujVpA67luXeOjEH/2Bhfz8v7TloPMtU
         VUWTn4Pbo2o4Wo2CwBdXsa3onvvCq911PhaV/9s2PlJsnhix61rND9ATpguMkwjF+Mjr
         tCySdweo9lKoCj2vU0Vb2CeHgOHE95omuq2YGkeuKjZYoWoSip6wZkkszXV9xal6EWXS
         WA7kqFEn4CcA/N6JoVxE7V6JIiYB1lT9g56pjT0FF3f6hNt+Ikmw49GV+Z5pS0OaDZ/+
         na8IPLlUswvt+4FBVlYybjuSF9Hri2vVxq3xEhWLDkoFZlYAVJ96055EqAjPpzkPGQ4f
         fQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8Prfpr3oc2tLft1FOD4p/J5s4+OQsVjEgvPH1u5Vbs=;
        b=55q4x+BtLJ7YHQhhnZ7VAMGlq9vxxD8H7+e6s3BxeHsHB4HPvn+oA2OU28YFE28vQN
         FC0vsRHExdKUSasLxMY/ITjY42ykCahQ0/dcwatXNYWe+VvkPWTEHYTip64BDQv++SFn
         RZpSYywyqVDYckxOr2dZYoBd3n0zigRSK36GD6vSTnM7xUMxzY3AeSuDBAJy4Lmv1NHL
         FBytpqy6nA50QbvI/gXBsT6T0H0JJgY3DqfpN5RF+xxG0SvsEMbfb5OzXIIjSXrL4wH+
         6dXs8D20+KJunf2Udk0t7ChsOMMce/HxChCkpHpw4e3KfS0lH1norS4Uj8qbWw76nrBq
         iK6Q==
X-Gm-Message-State: ANoB5pmblxN1bRj40u00AlDTM4nOS+4amvmFhoVkAxKTwoZN0iv31uus
        qikQFr4NkPyDGuWUjrmvVzDj
X-Google-Smtp-Source: AA0mqf7ZcWsFJiEynv852ZFY9E+pVMzD8VKR1Nz6Y6A/GC/SmqhJJWQjWydGIdHzqGqJHVXkd+hH8A==
X-Received: by 2002:aa7:8d88:0:b0:562:69d4:f9f3 with SMTP id i8-20020aa78d88000000b0056269d4f9f3mr49579586pfr.5.1669916635488;
        Thu, 01 Dec 2022 09:43:55 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:43:54 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v4 02/23] phy: qcom-qmp-ufs: Rename MSM8996 PHY definitions
Date:   Thu,  1 Dec 2022 23:13:07 +0530
Message-Id: <20221201174328.870152-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only MSM8996 is using "_ufs_" naming convention for PHY definitions instead
of "_ufsphy_" as like other SoCs. So to maintain the uniformity, let's
rename all of the definitions to use "_ufsphy_".

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 20fcdbef8c77..35b77cd79e57 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -94,7 +94,7 @@ static const unsigned int sm8150_ufsphy_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V4_PCS_UFS_POWER_DOWN_CONTROL,
 };
 
-static const struct qmp_phy_init_tbl msm8996_ufs_serdes[] = {
+static const struct qmp_phy_init_tbl msm8996_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_CMN_CONFIG, 0x0e),
 	QMP_PHY_INIT_CFG(QSERDES_COM_SYSCLK_EN_SEL, 0xd7),
 	QMP_PHY_INIT_CFG(QSERDES_COM_CLK_SELECT, 0x30),
@@ -143,12 +143,12 @@ static const struct qmp_phy_init_tbl msm8996_ufs_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_COM_LOCK_CMP3_MODE1, 0x00),
 };
 
-static const struct qmp_phy_init_tbl msm8996_ufs_tx[] = {
+static const struct qmp_phy_init_tbl msm8996_ufsphy_tx[] = {
 	QMP_PHY_INIT_CFG(QSERDES_TX_HIGHZ_TRANSCEIVEREN_BIAS_DRVR_EN, 0x45),
 	QMP_PHY_INIT_CFG(QSERDES_TX_LANE_MODE, 0x02),
 };
 
-static const struct qmp_phy_init_tbl msm8996_ufs_rx[] = {
+static const struct qmp_phy_init_tbl msm8996_ufsphy_rx[] = {
 	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_LVL, 0x24),
 	QMP_PHY_INIT_CFG(QSERDES_RX_SIGDET_CNTRL, 0x02),
 	QMP_PHY_INIT_CFG(QSERDES_RX_RX_INTERFACE_MODE, 0x00),
@@ -629,15 +629,15 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v5 = {
 	.rx2		= 0xa00,
 };
 
-static const struct qmp_phy_cfg msm8996_ufs_cfg = {
+static const struct qmp_phy_cfg msm8996_ufsphy_cfg = {
 	.lanes			= 1,
 
-	.serdes_tbl		= msm8996_ufs_serdes,
-	.serdes_tbl_num		= ARRAY_SIZE(msm8996_ufs_serdes),
-	.tx_tbl			= msm8996_ufs_tx,
-	.tx_tbl_num		= ARRAY_SIZE(msm8996_ufs_tx),
-	.rx_tbl			= msm8996_ufs_rx,
-	.rx_tbl_num		= ARRAY_SIZE(msm8996_ufs_rx),
+	.serdes_tbl		= msm8996_ufsphy_serdes,
+	.serdes_tbl_num		= ARRAY_SIZE(msm8996_ufsphy_serdes),
+	.tx_tbl			= msm8996_ufsphy_tx,
+	.tx_tbl_num		= ARRAY_SIZE(msm8996_ufsphy_tx),
+	.rx_tbl			= msm8996_ufsphy_rx,
+	.rx_tbl_num		= ARRAY_SIZE(msm8996_ufsphy_rx),
 
 	.clk_list		= msm8996_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(msm8996_ufs_phy_clk_l),
@@ -1156,7 +1156,7 @@ static int qmp_ufs_probe(struct platform_device *pdev)
 static const struct of_device_id qmp_ufs_of_match_table[] = {
 	{
 		.compatible = "qcom,msm8996-qmp-ufs-phy",
-		.data = &msm8996_ufs_cfg,
+		.data = &msm8996_ufsphy_cfg,
 	}, {
 		.compatible = "qcom,msm8998-qmp-ufs-phy",
 		.data = &sdm845_ufsphy_cfg,
-- 
2.25.1

