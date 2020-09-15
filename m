Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CE2C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4C520738
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tQEqOEqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgIOSJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgIOSI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 14:08:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FC3C061797;
        Tue, 15 Sep 2020 11:07:27 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a12so3903555eds.13;
        Tue, 15 Sep 2020 11:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vvxOGxNKj/7yxq3LDFIGsq+9PQEexQTaLJnBkK3tSHg=;
        b=tQEqOEqMWWwt2fWyREs3dQj94iTfe6kl3oM9wFHmaJ4HPYJiupV069c1OIfEPQYorl
         kWYVZRsah58o5Tn8a8Q1vLjtmxH5vUe87cIHcGxPvYoW6NbM5piXCwvoAQZgi/9rGXmx
         2RSZ37eqH9Y23mB7Yz+CgTg9UTW5x8BDyvTSXWQYA3MUfkgSLkn/irrjwRYO9Z+drmHD
         U3dlQAeK7i4zszrn+yEM8HvguHPSlYpys2u4Q2pU7D2NxssO2Zgf8tDbQOb1lPeAP26b
         0ZFfaPXXHVohIoDsAtwn40w1hnCsQyfg9X7LbpqCgAD26G8HFwXIbLkTdTYN5liz0hvo
         eM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vvxOGxNKj/7yxq3LDFIGsq+9PQEexQTaLJnBkK3tSHg=;
        b=kHv9i+Z48GKEjqjX3mQlIYJN4IDBN1omqnkxBXgoeKnQ82g+HaG46xJEIwt1Neow7R
         7ROV6YYzLY9hK5Pu5kgT4m1DMa1ooHhN2OyseFg8om2EMbOCnE6zkpx/l78sqWQDfPVj
         uMQzzoUaSyhdctXxQ+mgAWipQJYZzqrwb55tR/5ZaaZUtiGWqXcPQVm9on+slEnTGY5h
         bsESYYJUKHHvpUdO9LsMvTJnn6K8Mwckxdm3V1FYsT2jLzKGOCXSLL8BMZOB9mjA1Ief
         DEWRTxnjBsAue/x1KLeMT8nVCrn/v+LPkpsRKdxQjiQGDXdZHXofC9GA9GrKjPUBDK/q
         KD3A==
X-Gm-Message-State: AOAM533XLNolykSQsQ4rAx7xxDVYIVWJn39Enm3xm9seIn8eCoxYVuox
        O7cj813uS6IsQOLDAE52HWE=
X-Google-Smtp-Source: ABdhPJwwmJtEBhCSFDITxvEDupYDusK1WH0s4Kua1S4sxBDhRbbXG5dHdaH+NP8G3je5YgPgPAhz4w==
X-Received: by 2002:a05:6402:1641:: with SMTP id s1mr24493949edx.66.1600193245886;
        Tue, 15 Sep 2020 11:07:25 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b890:1ee4:75d6:3bdd:1167:483e])
        by smtp.gmail.com with ESMTPSA id k25sm10687083ejk.3.2020.09.15.11.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:07:25 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: ufs-qcom: use devm_platform_ioremap_resource_byname()
Date:   Tue, 15 Sep 2020 20:07:08 +0200
Message-Id: <20200915180708.12311-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915180708.12311-1-huobean@gmail.com>
References: <20200915180708.12311-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Use devm_platform_ioremap_resource_byname() to simplify the code.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-qcom-ice.c |  9 +--------
 drivers/scsi/ufs/ufs-qcom.c     | 23 +++++++++--------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index bbb0ad7590ec..cd67869a725e 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -97,25 +97,18 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	struct ufs_hba *hba = host->hba;
 	struct device *dev = hba->dev;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct resource *res;
 	int err;
 
 	if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
 	      MASK_CRYPTO_SUPPORT))
 		return 0;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice");
-	if (!res) {
-		dev_warn(dev, "ICE registers not found\n");
-		goto disable;
-	}
-
 	if (!qcom_scm_ice_available()) {
 		dev_warn(dev, "ICE SCM interface not found\n");
 		goto disable;
 	}
 
-	host->ice_mmio = devm_ioremap_resource(dev, res);
+	host->ice_mmio = devm_platform_ioremap_resource_byname(pdev, "ice");
 	if (IS_ERR(host->ice_mmio)) {
 		err = PTR_ERR(host->ice_mmio);
 		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f9d6ef356540..c0c76da5472a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -976,7 +976,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ufs_qcom_host *host;
-	struct resource *res;
 
 	if (strlen(android_boot_dev) && strcmp(android_boot_dev, dev_name(dev)))
 		return -ENODEV;
@@ -1059,20 +1058,16 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		host->dev_ref_clk_en_mask = BIT(26);
 	} else {
 		/* "dev_ref_clk_ctrl_mem" is optional resource */
-		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						   "dev_ref_clk_ctrl_mem");
-		if (res) {
-			host->dev_ref_clk_ctrl_mmio =
-					devm_ioremap_resource(dev, res);
-			if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
-				dev_warn(dev,
-					"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
-					__func__,
-					PTR_ERR(host->dev_ref_clk_ctrl_mmio));
-				host->dev_ref_clk_ctrl_mmio = NULL;
-			}
-			host->dev_ref_clk_en_mask = BIT(5);
+		host->dev_ref_clk_ctrl_mmio =
+			devm_platform_ioremap_resource_byname(pdev,
+							"dev_ref_clk_ctrl_mem");
+		if (IS_ERR(host->dev_ref_clk_ctrl_mmio)) {
+			dev_warn(dev,
+			"%s: could not map dev_ref_clk_ctrl_mmio, err %ld\n",
+			__func__, PTR_ERR(host->dev_ref_clk_ctrl_mmio));
+			host->dev_ref_clk_ctrl_mmio = NULL;
 		}
+		host->dev_ref_clk_en_mask = BIT(5);
 	}
 
 	err = ufs_qcom_init_lane_clks(host);
-- 
2.17.1

