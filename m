Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C93CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiKWHvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbiKWHty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:49:54 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98314FA722
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:47 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 62so16062905pgb.13
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bgs3s1G1jssoUlSih9AtMddjkl0seI8sJyhiWnXePTs=;
        b=wUq6WL4djnJwsxvN1wYxuCnno9lsf6UoLa5/ahB19bSFnw/2RTLYZZlREaB2lhRbir
         lrR6BM2sfcWwDXLt/h6cO+jwX93SVOj4G6mKFLU1WmIZHtkxpP4wWu3r5iO4z/2tkG3P
         qJhHMGdo0zyJ4EEC936GDf9IXale45dNjGY4ST5eVp+SW3huBItJ4bPF1lSucYK0xESW
         Hc68DTKv0EXDtzQ1EEZYI257Sy4+iDXOuoL4/wpjSNksJQRo1wgzNViwFV/PUhbPWE0E
         aMON3M8s+S+Z58BZMW62O7Bjnqw/JAKLpUj+fZfWZ2TnF+2GSiDsg1ZUyXjsYbu6p0hS
         6ICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bgs3s1G1jssoUlSih9AtMddjkl0seI8sJyhiWnXePTs=;
        b=PfQWiZ6lD3Mlqdyn54blJGqPtReWLeB4uYyiMWXuih/j+Wx17L9Y080jHRcUiZLBRx
         zg2he5gUerkIUTJ/gp05ixKz8sLMFTNIUM1lK1XDP/Buk3YP+m0FiX2ofb+CCJYJhdeL
         Q64h35ij/mnQglr7wKMNktdBpyOZkWrNUoFDT9Co8fWKtEVfNQls0xmqgyx7BA/MJH3H
         oOzh0nIEr/2692bcZxhiixQkA66VAYxED1bTnhP7F7ki00ouPdf7FXb4nvs+AN8L5J8r
         fUyyrj8qr6cV7DRLMFajdqYQNwNxEXff4ZgymvDU7l+1FmdWNkj4xTCG77tftC5VpGsE
         ii9Q==
X-Gm-Message-State: ANoB5pnr2ZR3yeVHRH+PkA3o3XcgA/A8tefEezjVmoirI/x9XtRA3P4h
        35fSl8m90h2IfxrlnsTxCEPO
X-Google-Smtp-Source: AA0mqf6Mtq3CwE43GnB33Scv6zg2lNpAOH3e5wdqEMbp0mtC8rEfnc4NEBIbX7O1KkBJzVg/GwYD1g==
X-Received: by 2002:a63:ea52:0:b0:46f:9c0c:8673 with SMTP id l18-20020a63ea52000000b0046f9c0c8673mr8465805pgk.154.1669189786822;
        Tue, 22 Nov 2022 23:49:46 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:49:45 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 12/20] scsi: ufs: ufs-qcom: Use bitfields where appropriate
Date:   Wed, 23 Nov 2022 13:18:18 +0530
Message-Id: <20221123074826.95369-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use bitfield macros where appropriate to simplify the driver.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.h | 61 +++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 44466a395bb5..9d96ac71b27f 100644
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
@@ -76,24 +73,28 @@ enum {
 #define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
 
 /* bit definitions for REG_UFS_CFG1 register */
-#define QUNIPRO_SEL		0x1
-#define UTP_DBG_RAMS_EN		0x20000
+#define QUNIPRO_SEL		BIT(0)
+#define UFS_PHY_SOFT_RESET	BIT(1)
+#define UTP_DBG_RAMS_EN		BIT(17)
 #define TEST_BUS_EN		BIT(18)
 #define TEST_BUS_SEL		GENMASK(22, 19)
 #define UFS_REG_TEST_BUS_EN	BIT(30)
 
+#define UFS_PHY_RESET_ENABLE	1
+#define UFS_PHY_RESET_DISABLE	0
+
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
@@ -101,17 +102,11 @@ enum {
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
+#define MASK_TX_SYMBOL_CLK_1US_REG	GENMASK(9, 0)
+#define MASK_CLK_NS_REG			GENMASK(23, 10)
 
 /* QCOM UFS debug print bit mask */
 #define UFS_QCOM_DBG_PRINT_REGS_EN	BIT(0)
@@ -135,15 +130,15 @@ ufs_qcom_get_controller_revision(struct ufs_hba *hba,
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
+	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_ENABLE),
+		    REG_UFS_CFG1);
 
 	/*
 	 * Make sure assertion of ufs phy reset is written to
@@ -154,8 +149,8 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
 
 static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
 {
-	ufshcd_rmwl(hba, MASK_UFS_PHY_SOFT_RESET,
-			0 << OFFSET_UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
+	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_DISABLE),
+		    REG_UFS_CFG1);
 
 	/*
 	 * Make sure de-assertion of ufs phy reset is written to
-- 
2.25.1

