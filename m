Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AA6C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiLVONC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiLVOMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:12:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4D7286C0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:11:31 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso1988373pjh.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4X1A4TMvEV2bS5ohL9A0SpECVAvBKwWjyx8LJOjuk7U=;
        b=BxWVBMysDolWbx+Cppe3zn3m/KFARMGNqquNzCFgm75WofleLqYgk94x2rBFTc9Tvl
         MZBxo2wNJc4SWqNe81JTB57k0Z9JvK4i7vYyp8pREFAEhZvECn0YN+yQpOEEQoAdW96g
         Ncxo0MsLT3eNWetF7L6BRXvxqUXOLujvVgRPGzz+TfrkDHDGn6HL+Ao4kbaTlgGUaK6I
         8s7CDXnQPue+wbvAJXkvx3PqI8LwdJGqisMXJTTxK2jM1BQq3MM2uv7nVXM2+FVDYmWb
         ELL6DrURh9fTN/RBhRYcl7VaLD2A3s5w4uUj9klBISsKgTNuMTAhE7ydRglDOnG30Hx8
         sX8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4X1A4TMvEV2bS5ohL9A0SpECVAvBKwWjyx8LJOjuk7U=;
        b=c657o4z94vhgHhE+RX8IubV25XpzqFbE7dAmy9QmLpDI1q4CUDvHqdUkeCtyvhdYnV
         O9MtEZZCB+MOIv5uxIRzfi6m+5w7kJg8R7lzKfjX3orfNQjSR+ZJZHagfvGn6QI87uvS
         kq9ST4o29xEtlf1heN5XR9+nUp2Hdcp9Oz8VzheqX0fQdq3w2RbHYxzzK2Q+2Exa4pWw
         8F+YJvCl+RQ96MUHPCBvqisr9Ygb+SffnJcZZnD7cC+sC/WvgfpHRXJeiRDS7Y6UcMVO
         d/1Og3hwfLAwbjaowua2kBJ+53p5qJf7/+hEnjH5friM4M75DsFvEzTQyAEeMUi0cCbc
         b7jw==
X-Gm-Message-State: AFqh2kqWkKf7wzmpxLWt5H95qhjpZp93yinDeKeC0VQ+ArP6LTEodwLT
        3qs5/cb7z9DhAcB7LfF/4we8
X-Google-Smtp-Source: AMrXdXuZk/NEnRPNupNCna4VffVs4EjjF+9WNS/4kFEQ/Zy/NZFN/ZFkZIxohRNAc1flJSboQdPzHg==
X-Received: by 2002:a05:6a20:d80a:b0:ad:f82d:78ad with SMTP id iv10-20020a056a20d80a00b000adf82d78admr7597717pzb.46.1671718291165;
        Thu, 22 Dec 2022 06:11:31 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:11:30 -0800 (PST)
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
Subject: [PATCH v5 11/23] phy: qcom-qmp-ufs: Add HS G4 mode support to SM8450 SoC
Date:   Thu, 22 Dec 2022 19:39:49 +0530
Message-Id: <20221222141001.54849-12-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS PHY in SM8450 SoC is capable of operating at HS G4 mode and the init
sequence is compatible with SM8350. Hence, add the tbls_hs_g4 instance
reusing the G4 init sequence of SM8350.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
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

