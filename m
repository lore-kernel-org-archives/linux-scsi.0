Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45557C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiKWHu1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiKWHtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:49:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC94FAEA0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:29 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v28so16594204pfi.12
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80dm928QYjr4oaUe835NN0o7sI/usasikkVJKdylirU=;
        b=WRVpYhROFvYz65xUbt//WOCcZo2HgsBSoiXl2Q3Ne20Ne4BN3GFVoxtgxgbccnZvLS
         pv04Zmdx/RMc0DlJUDEkIHKgtwlChJYrcZWHGfNQMtKeya9eYHwdoFvEhGgQ67rNk41e
         YqAg6gXjnJET2hbT0QUcqm33o3UivXWLzkA7Pq9r4MKYGo84ZPNRqXpyPS7hUXZgS6KK
         Dic7KWjLZlS/GUNtbQj1LGWlDTvLoofpwP5bwUOl+F8gW3bDWwuciu8LaFdvmEsqj9Jw
         FoOLUD1tH6mxuq3LwpLK5dgQ8WjWUOKRrW5lg1tkHsicMznq7Arw8UonE2hAn4jx6mPv
         c0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80dm928QYjr4oaUe835NN0o7sI/usasikkVJKdylirU=;
        b=BkLrq/fYZuy9iwV/WLCV/yi2liQNWEAqL68m3gWlTiaOM3kyPanWgyiAn/RNDKpVSq
         KS9QZY7meAiiy9uV+0rETdlZo4caaPRYSSmzIFDVKb80/crsk59O1a/+OBQv98GEXfpk
         Y5N7KAXXYY+e42gU8vRuNZ9itVf8Q4BsF5Y4p2Yl/YQx3FEyh4dBhT6rbdJsT5VYQmsg
         80fJrv8NEjZ9gOWO0QclYbtMrUd9RoLR014WIHaXSZEMuM2PmnN6v8i52V53Twc66xW/
         rrfgILYNvuUjU+U9rW3gTyebrxkTqxlQIAHygnJ4ZxAS9j+taYLnAAI2+UZyIOXzRvpa
         P6Vw==
X-Gm-Message-State: ANoB5plqDs997wkrcIoh6OXZzlC02Kk7Frikpd2Glt9V3ytWk41XTlI5
        zoyQpzwVK2KjNiEowzRTdw4c
X-Google-Smtp-Source: AA0mqf6Snp7j5kDvcsF+9bMBzw+agm/tT1gkk+PUrpXpKcXUq0qzTWx9Xu2gZT0tp8E79AK9NkFcPw==
X-Received: by 2002:a63:461d:0:b0:456:d859:2143 with SMTP id t29-20020a63461d000000b00456d8592143mr6261885pga.396.1669189769348;
        Tue, 22 Nov 2022 23:49:29 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:49:28 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 09/20] phy: qcom-qmp-ufs: Add HS G4 mode support to SM8450 SoC
Date:   Wed, 23 Nov 2022 13:18:15 +0530
Message-Id: <20221123074826.95369-10-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS PHY in SM8450 SoC is capable of operating at HS G4 mode. Hence, add the
required register settings using the tables_hs_g4 struct instance.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h    |  1 +
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 48 +++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h
index bcca23493b7e..3aa4232f84a6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v5.h
@@ -13,6 +13,7 @@
 #define QPHY_V5_PCS_UFS_PLL_CNTL			0x02c
 #define QPHY_V5_PCS_UFS_TX_LARGE_AMP_DRV_LVL		0x030
 #define QPHY_V5_PCS_UFS_TX_SMALL_AMP_DRV_LVL		0x038
+#define QPHY_V5_PCS_UFS_BIST_FIXED_PAT_CTRL		0x060
 #define QPHY_V5_PCS_UFS_TX_HSGEAR_CAPABILITY		0x074
 #define QPHY_V5_PCS_UFS_RX_HSGEAR_CAPABILITY		0x0b4
 #define QPHY_V5_PCS_UFS_DEBUG_BUS_CLKSEL		0x124
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index d39ee28fb6a3..7a77db3196db 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -592,6 +592,46 @@ static const struct qmp_phy_init_tbl sm8350_ufsphy_pcs[] = {
 	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 };
 
+static const struct qmp_phy_init_tbl sm8350_ufsphy_g4_tx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_V5_TX_LANE_MODE_1, 0xe5),
+};
+
+static const struct qmp_phy_init_tbl sm8350_ufsphy_g4_rx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_PI_CTRL2, 0x81),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_TERM_BW, 0x6f),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL2, 0x00),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL3, 0x4a),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL4, 0x0a),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_IDAC_MEASURE_TIME, 0x20),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_IDAC_TSETTLE_LOW, 0x80),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_IDAC_TSETTLE_HIGH, 0x01),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_00_LOW, 0xbf),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_00_HIGH, 0xbf),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_00_HIGH2, 0x7f),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_00_HIGH3, 0x7f),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_00_HIGH4, 0x2d),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_01_LOW, 0x6d),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_01_HIGH, 0x6d),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_01_HIGH2, 0xed),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_MODE_01_HIGH4, 0x3c),
+};
+
+static const struct qmp_phy_init_tbl sm8350_ufsphy_g4_pcs[] = {
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_BIST_FIXED_PAT_CTRL, 0x0a),
+	/*
+	 * Following registers are not required for HS-G4 mode, but since these
+	 * are already programmed as part of previous init sequence, we'll program
+	 * again with reset values.
+	 */
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_PLL_CNTL, 0x0b),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TIMER_20US_CORECLK_STEPS_MSB, 0x2d),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TIMER_20US_CORECLK_STEPS_LSB, 0xb0),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_PWM_GEAR_BAND, 0xff),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_HS_GEAR_BAND, 0x15),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x04),
+	QMP_PHY_INIT_CFG(QPHY_V5_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x04),
+};
+
 struct qmp_phy_cfg_tbls {
 	/* Init sequence for PHY blocks - serdes, tx, rx, pcs */
 	const struct qmp_phy_init_tbl *serdes;
@@ -934,6 +974,14 @@ static const struct qmp_phy_cfg sm8450_ufsphy_cfg = {
 		.serdes		= sm8350_ufsphy_hs_b_serdes,
 		.serdes_num	= ARRAY_SIZE(sm8350_ufsphy_hs_b_serdes),
 	},
+	.tbls_hs_g4 = {
+		.tx		= sm8350_ufsphy_g4_tx,
+		.tx_num		= ARRAY_SIZE(sm8350_ufsphy_g4_tx),
+		.rx		= sm8350_ufsphy_g4_rx,
+		.rx_num		= ARRAY_SIZE(sm8350_ufsphy_g4_rx),
+		.pcs		= sm8350_ufsphy_g4_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8350_ufsphy_g4_pcs),
+	},
 	.clk_list		= sm8450_ufs_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(sm8450_ufs_phy_clk_l),
 	.vreg_list		= qmp_phy_vreg_l,
-- 
2.25.1

