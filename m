Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD20EC47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiLARp4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLARpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:45:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19FCB9561
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:44:57 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x66so2568224pfx.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHyB7436weYMuPIAQRzFHHIdfwli/IaDh2memTnfiz4=;
        b=HwHJwJOkwvSEBUNX+i+oZEnpWllIswdC70KvR+kb0qoQXwyW7rXmt9ffX/6u2JdVIu
         oSzW/56vt5Tl7xWubzhe5dxi/84xaOBStPC3lv/k39zV3eekwlbqyC+dEBNNYfmTZfAJ
         X61OSRbasOgl6D1799NcneY8nu6gC952PM9kUZaumvHBxBfPfGkZq5XbetEBplXlnVGp
         hoDLJVJFZuFUYVj3+C2Jsd0y4EbnJofFBeknYgcBgHFyA7R2S2kLHiy7EY9sKGBDpSUQ
         LigNfvAbSg4RyyZiVHTbKKy3SwNmfgC8BiyqqE+mKyw4tac1l3wjFLw01kaycvmK+ojQ
         bq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uHyB7436weYMuPIAQRzFHHIdfwli/IaDh2memTnfiz4=;
        b=PCuw1udXZ0Z7msqA/XWwBNaVnoXMG7l95f8a5yNFpdmZMTxClaO0gut4nwCwqUSLeT
         r1A9yauB+a54JyVBt4qwKN3NpCCMxhJQX6HLnC2keKj795jH5pifpy3kQudbxI4DzaYw
         7qX33mFzfS7xISh79bLMwC9iUyPZMiSl14202O+hRYB2DUY55jQpuUddZfPmaULX6UeR
         fl+XE6RIPrFAzH49GATLRDsPv3ZKZtVjGrQyHkSPVZmhfMCxxh/hQtlaSztCpjFmgp1r
         OqZv+6qduTnXIUbED6Dx16E3/qJaER0JTmwvyDj1/HscjB8utd8bwYL4W3ZfQP7Gy5Na
         UakA==
X-Gm-Message-State: ANoB5pnEuuSMhvOC9oD7FL51Nr0X4I2QQG4gcuO7oaunM6WCm19IJWcB
        wm4IL7tI82itvv3heUZXGt6T
X-Google-Smtp-Source: AA0mqf7pE3rCyuCdvjQkNP/HRiYfLrj8jcDj6Hur/yJdWj3IQEMvPUxutM5ggF5nePqmhnq/mu1Zhw==
X-Received: by 2002:a63:2251:0:b0:477:9bc8:dffb with SMTP id t17-20020a632251000000b004779bc8dffbmr41247741pgm.306.1669916697598;
        Thu, 01 Dec 2022 09:44:57 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:44:56 -0800 (PST)
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
Subject: [PATCH v4 11/23] phy: qcom-qmp-ufs: Add HS G4 mode support to SM8450 SoC
Date:   Thu,  1 Dec 2022 23:13:16 +0530
Message-Id: <20221201174328.870152-12-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS PHY in SM8450 SoC is capable of operating at HS G4 mode and the init
sequence is compatible with SM8350. Hence, add the tbls_hs_g4 instance
reusing the G4 init sequence of SM8350.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 75e55c4181c9..96e03d4249da 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -935,6 +935,14 @@ static const struct qmp_phy_cfg sm8450_ufsphy_cfg = {
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

