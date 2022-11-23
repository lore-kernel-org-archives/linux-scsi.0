Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC352C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiKWHtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiKWHtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:49:02 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B464FFAE86
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:48:59 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k15so16632592pfg.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17DUm1BHWO+9+pCruDSwXwFA2DWaV0LvIvFJmkLFp/8=;
        b=szHgLObizdRjU8Uhq446KGApvra49ApA5BIcru3Ey/6Do2T56DSsWvR5g9jLZHc476
         MSlgWT8MIf8p+f/sxml/uIYI/OfERwdOxx5UrTrYqsRwWRZFHtuRDyZJ5Rx4UxQu9KFi
         bHD+ee5c55d9SFNG5Pwp6XrqCpbVMI7Noo/UYKv4oy6hdO4XzjAQT10xIo8VNGpS1lk0
         Z20HdS4+82s4XqLdrE2uV7dVCOiPbh7w+y4ldF3k1iYZtAtLx40Dsl+kKesa4AdfKKoU
         pHw3S/F4iNp6nK3l1atD4eXQ9Qt72dI6wxGZlj7nTc6si+4kweYwgd/xG8XerHXUsBmF
         dhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17DUm1BHWO+9+pCruDSwXwFA2DWaV0LvIvFJmkLFp/8=;
        b=1DtglAFo5+8OABXW5T0bXpVM9h1uSBhRVWzpVmSwh1xEh+zNJSGbIsAB69Enc0oiW1
         Ljs6U2d7waDgK1j2Z5WY2cj8JMyHXH4Z1uleIR8AW1p+iJt85lvuZ4zXSDSjsrYJ9Bzc
         rsN1em4cW+etm/7DxEbC5o6JgdfpGxcSYT+CyBkFXYsghrsh17rgFWI1l3GQ4l4dpeMj
         7fexaopxA5xxKN/ZxrdJiY/w8AFe+i8etdW7+p1AZypRPAG+2wK3dCF17zYPrNAgshy7
         oyygb7ywDD7BqGQlVbcOHYfdjnmV2ptD8D0Oa70xRSKzTPkJxs9ne0mAVWWdlqJWt/fk
         xVqg==
X-Gm-Message-State: ANoB5pnVh7zWTyCHA/mnMY+87qJcf7CR0cz5Aqt8d3N+RObpr3yUqLzZ
        WSqXw/YyFdGxa4y8EYRMzzls
X-Google-Smtp-Source: AA0mqf5p/xJXOPvTRxbeUxcJCUOhwd51+9yIUCWj0RA8EwvAT98+ugBHbeaX8uInPuYuqUPJ+lVyfQ==
X-Received: by 2002:a63:5007:0:b0:45f:beda:4116 with SMTP id e7-20020a635007000000b0045fbeda4116mr8165671pgb.618.1669189739616;
        Tue, 22 Nov 2022 23:48:59 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:48:58 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 04/20] phy: qcom-qmp-ufs: Add support for configuring PHY in HS Series B mode
Date:   Wed, 23 Nov 2022 13:18:10 +0530
Message-Id: <20221123074826.95369-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add separate tables_hs_b instance to allow the PHY driver to configure the
PHY in HS Series B mode. The individual SoC configs need to supply the
serdes register setting in tables_hs_b and the UFS driver can request the
Series B mode by calling phy_set_mode() with mode set to PHY_MODE_UFS_HS_B.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 3b7b36e32f5d..694b1d6c1f9c 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -20,6 +20,8 @@
 #include <linux/reset.h>
 #include <linux/slab.h>
 
+#include <ufs/unipro.h>
+
 #include <dt-bindings/phy/phy.h>
 
 #include "phy-qcom-qmp.h"
@@ -549,6 +551,8 @@ struct qmp_phy_cfg {
 
 	/* Main init sequence for PHY blocks - serdes, tx, rx, pcs */
 	const struct qmp_phy_cfg_tbls tbls;
+	/* Additional sequence for HS Series B */
+	const struct qmp_phy_cfg_tbls tbls_hs_b;
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -582,6 +586,7 @@ struct qmp_phy_cfg {
  * @rx2: iomapped memory space for second lane's rx (in dual lane PHYs)
  * @pcs_misc: iomapped memory space for lane's pcs_misc
  * @qmp: QMP phy to which this lane belongs
+ * @mode: PHY mode configured by the UFS driver
  */
 struct qmp_phy {
 	struct phy *phy;
@@ -594,6 +599,7 @@ struct qmp_phy {
 	void __iomem *rx2;
 	void __iomem *pcs_misc;
 	struct qcom_qmp *qmp;
+	u32 mode;
 };
 
 /**
@@ -885,6 +891,8 @@ static void qmp_ufs_pcs_init(struct qmp_phy *qphy, const struct qmp_phy_cfg_tbls
 static void qmp_ufs_init_registers(struct qmp_phy *qphy, const struct qmp_phy_cfg *cfg)
 {
 	qmp_ufs_serdes_init(qphy, &cfg->tbls);
+	if (qphy->mode == PHY_MODE_UFS_HS_B)
+		qmp_ufs_serdes_init(qphy, &cfg->tbls_hs_b);
 	qmp_ufs_lanes_init(qphy, &cfg->tbls);
 	qmp_ufs_pcs_init(qphy, &cfg->tbls);
 }
@@ -1073,6 +1081,15 @@ static int qmp_ufs_disable(struct phy *phy)
 	return qmp_ufs_exit(phy);
 }
 
+static int qmp_ufs_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct qmp_phy *qphy = phy_get_drvdata(phy);
+
+	qphy->mode = mode;
+
+	return 0;
+}
+
 static int qmp_ufs_vreg_init(struct device *dev, const struct qmp_phy_cfg *cfg)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
@@ -1108,6 +1125,7 @@ static int qmp_ufs_clk_init(struct device *dev, const struct qmp_phy_cfg *cfg)
 static const struct phy_ops qcom_qmp_ufs_ops = {
 	.power_on	= qmp_ufs_enable,
 	.power_off	= qmp_ufs_disable,
+	.set_mode	= qmp_ufs_set_mode,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.25.1

