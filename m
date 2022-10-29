Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269C3C38A02
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJ2OSz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiJ2OSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:18:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9175FDC6
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:37 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u6so7182032plq.12
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPevE9Sh9eft9CvrrFJCCIetkvqvkKgpjjhTImTV4/g=;
        b=RgWcT1WgSGpcqiPdFNxstMjSKLJ1/3c7FPBBzjWoL+uMaUSVdSdXEo60vJoE9qoVKR
         9SQustPoRxFfq38euBRKG0REXWuvHM1yEJ3nVq1WU4BCqomup9cSJqGPP73PSO2g/wHk
         NBaq4kIwhiKPoMqoZ9B6y0reZPw8SVUGrKZBg96Ig7sfC92cphvg7g2Yqju2OIq1q8GW
         kbFUvP6QT2TdB043MvDCRDic8x+Me8CkxFvt16mWrBNv5809ml5Pzb2uUNoUmcKj7ss/
         XH17ytdsaP0GktHH238TSd7jlivTD/Qk2RbyDL4M2CoL2sHwDP1JXRPJvuPCA9STov6N
         YgWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPevE9Sh9eft9CvrrFJCCIetkvqvkKgpjjhTImTV4/g=;
        b=DcVRuU1APFuRnFALiZlCN3aGKEeJ3ibGqQRKfUcyHJQEyJ/nzIi5F8nddgsZHk7KNi
         eC28t3UKFiaLbvjo9vMg55nXWnUyqwJjfzSb9JO1tl4bzLxqxyIE9mKJlxNc21ohs1ox
         liqcJnxNPr8m28IlNWvooCTlFBgi1JQEc6aneohUU90fXaf0pyTTpJS48ApIbABwlrA0
         vthN7/Im6b3D5vT4MruyfKlBlgv3LLjkp550qsuj+3U9KckRbL8A3alCyN2UmG7SUX5y
         YuQIrSIhX95UBailD5o95O2uExGsD/FqzVUVBhR6iqDVOU+vTda5rgmSLrLZQeJs4qwT
         /68Q==
X-Gm-Message-State: ACrzQf28F7LN/IMY+tWLD92ANyIOS9HZ8Mxlh+xZ7o/aKNWUeUd4jyQ7
        0jT7gltlEYLvQlWQvJr+uzZJ
X-Google-Smtp-Source: AMsMyM62YUS5QBWrpRdTRJlP3R8PeCklLVuBSc7yrVwOlA1RFgktjS1qWcOJod4G5cdm1PLZsX31Jw==
X-Received: by 2002:a17:90a:24b:b0:213:9da2:5c98 with SMTP id t11-20020a17090a024b00b002139da25c98mr4953272pje.123.1667053056498;
        Sat, 29 Oct 2022 07:17:36 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:17:35 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 10/15] scsi: ufs: ufs-qcom: Use bitfields where appropriate
Date:   Sat, 29 Oct 2022 19:46:28 +0530
Message-Id: <20221029141633.295650-11-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use bitfield macros where appropriate to simplify the driver.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.h | 58 ++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 44466a395bb5..6cb0776456b3 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -17,12 +17,9 @@
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define BUS_VECTOR_NAME_LEN     32
 
-#define UFS_HW_VER_MAJOR_SHFT	(28)
-#define UFS_HW_VER_MAJOR_MASK	(0x000F << UFS_HW_VER_MAJOR_SHFT)
-#define UFS_HW_VER_MINOR_SHFT	(16)
-#define UFS_HW_VER_MINOR_MASK	(0x0FFF << UFS_HW_VER_MINOR_SHFT)
-#define UFS_HW_VER_STEP_SHFT	(0)
-#define UFS_HW_VER_STEP_MASK	(0xFFFF << UFS_HW_VER_STEP_SHFT)
+#define UFS_HW_VER_MAJOR_MASK	GENMASK(31, 28)
+#define UFS_HW_VER_MINOR_MASK	GENMASK(27, 16)
+#define UFS_HW_VER_STEP_MASK	GENMASK(15, 0)
 
 /* vendor specific pre-defined parameters */
 #define SLOW 1
@@ -76,24 +73,24 @@ enum {
 #define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
 
 /* bit definitions for REG_UFS_CFG1 register */
-#define QUNIPRO_SEL		0x1
-#define UTP_DBG_RAMS_EN		0x20000
+#define QUNIPRO_SEL		BIT(0)
+#define UTP_DBG_RAMS_EN		BIT(17)
 #define TEST_BUS_EN		BIT(18)
 #define TEST_BUS_SEL		GENMASK(22, 19)
 #define UFS_REG_TEST_BUS_EN	BIT(30)
 
 /* bit definitions for REG_UFS_CFG2 register */
-#define UAWM_HW_CGC_EN		(1 << 0)
-#define UARM_HW_CGC_EN		(1 << 1)
-#define TXUC_HW_CGC_EN		(1 << 2)
-#define RXUC_HW_CGC_EN		(1 << 3)
-#define DFC_HW_CGC_EN		(1 << 4)
-#define TRLUT_HW_CGC_EN		(1 << 5)
-#define TMRLUT_HW_CGC_EN	(1 << 6)
-#define OCSC_HW_CGC_EN		(1 << 7)
+#define UAWM_HW_CGC_EN		BIT(0)
+#define UARM_HW_CGC_EN		BIT(1)
+#define TXUC_HW_CGC_EN		BIT(2)
+#define RXUC_HW_CGC_EN		BIT(3)
+#define DFC_HW_CGC_EN		BIT(4)
+#define TRLUT_HW_CGC_EN		BIT(5)
+#define TMRLUT_HW_CGC_EN	BIT(6)
+#define OCSC_HW_CGC_EN		BIT(7)
 
 /* bit definition for UFS_UFS_TEST_BUS_CTRL_n */
-#define TEST_BUS_SUB_SEL_MASK	0x1F  /* All XXX_SEL fields are 5 bits wide */
+#define TEST_BUS_SUB_SEL_MASK	GENMASK(4, 0)  /* All XXX_SEL fields are 5 bits wide */
 
 #define REG_UFS_CFG2_CGC_EN_ALL (UAWM_HW_CGC_EN | UARM_HW_CGC_EN |\
 				 TXUC_HW_CGC_EN | RXUC_HW_CGC_EN |\
@@ -101,17 +98,12 @@ enum {
 				 TMRLUT_HW_CGC_EN | OCSC_HW_CGC_EN)
 
 /* bit offset */
-enum {
-	OFFSET_UFS_PHY_SOFT_RESET           = 1,
-	OFFSET_CLK_NS_REG                   = 10,
-};
+#define OFFSET_CLK_NS_REG		0xa
 
 /* bit masks */
-enum {
-	MASK_UFS_PHY_SOFT_RESET             = 0x2,
-	MASK_TX_SYMBOL_CLK_1US_REG          = 0x3FF,
-	MASK_CLK_NS_REG                     = 0xFFFC00,
-};
+#define MASK_UFS_PHY_SOFT_RESET		BIT(1)
+#define MASK_TX_SYMBOL_CLK_1US_REG	GENMASK(9, 0)
+#define MASK_CLK_NS_REG			GENMASK(23, 10)
 
 /* QCOM UFS debug print bit mask */
 #define UFS_QCOM_DBG_PRINT_REGS_EN	BIT(0)
@@ -135,15 +127,15 @@ ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 {
 	u32 ver = ufshcd_readl(hba, REG_UFS_HW_VERSION);
 
-	*major = (ver & UFS_HW_VER_MAJOR_MASK) >> UFS_HW_VER_MAJOR_SHFT;
-	*minor = (ver & UFS_HW_VER_MINOR_MASK) >> UFS_HW_VER_MINOR_SHFT;
-	*step = (ver & UFS_HW_VER_STEP_MASK) >> UFS_HW_VER_STEP_SHFT;
+	*major = FIELD_GET(UFS_HW_VER_MAJOR_MASK, ver);
+	*minor = FIELD_GET(UFS_HW_VER_MINOR_MASK, ver);
+	*step = FIELD_GET(UFS_HW_VER_STEP_MASK, ver);
 };
 
 static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 {
-	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
-			1 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET, FIELD_PREP(MASK_UFS_PHY_SOFT_RESET, 1),
+		    REG_UFS_CFG1);
 
 	/*
 	 * Make sure assertion of ufs phy reset is written to
@@ -154,8 +146,8 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 {
-	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
-			0 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET, FIELD_PREP(MASK_UFS_PHY_SOFT_RESET, 0),
+		    REG_UFS_CFG1);
 
 	/*
 	 * Make sure de-assertion of ufs phy reset is written to
-- 
2.25.1

