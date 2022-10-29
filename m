Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DDBFA3744
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJ2ORU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJ2OQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:16:59 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AC25F127
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:16:54 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h2so7163670pgp.4
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUgElLMFDRghXwZQM2277E5lbjtRUO+bSagQ51THrn8=;
        b=hlFw3VNhdEjhNbDugmqQbdr3ZoY7/PJIRYJ8nuzsfu57VEImN/daGMaKM8P0zRqK+k
         TH147l5elpo6UQsdFsJlfVTHfg6MvBSIxlemEQ5pCvROO2UBndr6y7uB+MGJyXBKRrVv
         QaQbNmGV6fvDA5rleWbpG4b6xHYyGkbhT+Y03ZjwHiHhclIsYYW5Ojg63cMipi5C4lbo
         akr65YxRr6VFHJ0Z7w/7dGZgjuHLqfMJTR1UMQbTKr0twgel+bwFwaJ8r7Lk4zJDdRe6
         F64HUqagS7yW2IC/2orTGobu+W9p6tBqjb6SxuIR/lcDJ+dxBRkP+YyBf8nh/d9RkmUl
         pXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUgElLMFDRghXwZQM2277E5lbjtRUO+bSagQ51THrn8=;
        b=0KVAGZ5PE0rWT1BCgcI6pZmmrW+habQUngJmieaVB3q+7QZzRjFbtYMCIm+UTVJPwC
         ck12qXnGaWE8OEHkak4Q5MyeCtnW12G/muYHQGuoYhbyWC/qTerIYG3ADkRw4it6EVU7
         N3TM6nhnPJf5kSZn+ZlDqOWSZtcUAUAVTVgWhJOri/XTexYkLM3kPjNJe8Lm/nk78fX+
         YKSA2dnCCzD9qf1txsQ26RZklDa1BVgzG1N+3tjdp0RmztDb2HTvaKSipEvj5t8ZElEL
         yukil8MnEVhJc+nYoEKf8TfUNcZxjzXQu6/p/UBi3sNPsj8pvuW23CvmSLD69a06jNQC
         IrNA==
X-Gm-Message-State: ACrzQf2Wo7tJqcPC/Ej1ilEGgsiyanOWbLtSTkRK8b+M8JOf8TFqSGk1
        7Cf65Y1bznKQC7A2LwGh0oQF
X-Google-Smtp-Source: AMsMyM61nYHwbC8ugbPRGE7JQBjSBZbAW3B6wYn1EzUISYGwQKkwHK4PcK7DahB/9BSqNiuIHZH2pA==
X-Received: by 2002:a63:9049:0:b0:46f:59b9:1645 with SMTP id a70-20020a639049000000b0046f59b91645mr4078692pge.541.1667053013986;
        Sat, 29 Oct 2022 07:16:53 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:16:53 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 02/15] phy: qcom-qmp-ufs: Add support for configuring PHY in HS Series B mode
Date:   Sat, 29 Oct 2022 19:46:20 +0530
Message-Id: <20221029141633.295650-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add separate tables_hs_b instance to allow the PHY driver to configure the
PHY in HS Series B mode. The individual SoC configs need to supply the
serdes register setting in tables_hs_b and the UFS driver can request the
Series B mode by calling phy_set_mode() with mode set to PHY_MODE_UFS_HS_B.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index cdfda4e6d575..4c6a2b5afc9a 100644
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
 	const struct qmp_phy_cfg_tables tables;
+	/* Additional sequence for HS Series B */
+	const struct qmp_phy_cfg_tables tables_hs_b;
 
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
@@ -983,6 +989,8 @@ static int qmp_ufs_power_on(struct phy *phy)
 	int ret;
 
 	qmp_ufs_serdes_init(qphy, &cfg->tables);
+	if (qphy->mode == PHY_MODE_UFS_HS_B)
+		qmp_ufs_serdes_init(qphy, &cfg->tables_hs_b);
 
 	qmp_ufs_lanes_init(qphy, &cfg->tables);
 
@@ -1070,6 +1078,15 @@ static int qmp_ufs_disable(struct phy *phy)
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
@@ -1105,6 +1122,7 @@ static int qmp_ufs_clk_init(struct device *dev, const struct qmp_phy_cfg *cfg)
 static const struct phy_ops qcom_qmp_ufs_ops = {
 	.power_on	= qmp_ufs_enable,
 	.power_off	= qmp_ufs_disable,
+	.set_mode	= qmp_ufs_set_mode,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.25.1

