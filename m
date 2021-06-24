Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9244DC49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7823D6137D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhFXXce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 19:32:34 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:33582 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXXce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 19:32:34 -0400
Received: by mail-pl1-f177.google.com with SMTP id f10so3797542plg.0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 16:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYchIqvqeRJAmSQpJPHeP/GbdqYHckXtyiNl+4/I5uQ=;
        b=qrT1kweZx50lnkop1oEjkGgI7jxT7NrfnTtGriP+ST0WZARwk2tAgbXjHdtyUMNk//
         bbB1jzElQMPiMuWZAO75Ak1NsCAQCJhgtulHN910BeOLRlIyfi5LFftorLrSAtPbq2gj
         PIGcdTKnWdpcyjA2wqdTwhTJv3oNDVpc4Xjob6no6j2AvHRAYmjfyMYwcvHtHERMzr8R
         eyTYqK2IFVj0KExzCiSvSqPPFRU3rMoEM/wrAoic2QeTKB3vafsjpt65ZrfNV/QDmaTT
         9MwCFBsjIBPt8K0AdoA/LB4X/RZFiV6/oP0hMSNsxEwGH+bSZdmwCfwrZJcDeJV9HPC2
         grwg==
X-Gm-Message-State: AOAM530svfTXyIsCC4LO7smVRuemPyBvKtjh7J3EbdT7110WI4j7P/lR
        +6k/rf3dGNESUE+7yLac2nc=
X-Google-Smtp-Source: ABdhPJxLu8EYAF8fNYr3Pub9qDXy7Jg0bUtNI3WRoJkd5aEO8f4p+f+VI7hJbAmUuTKS8jRgkueLCA==
X-Received: by 2002:a17:90a:c08e:: with SMTP id o14mr13395702pjs.159.1624577411656;
        Thu, 24 Jun 2021 16:30:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j16sm3599908pgh.69.2021.06.24.16.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:30:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Yue Hu <huyue2@yulong.com>, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/3] ufs: Reduce code duplication in the runtime power managment implementation
Date:   Thu, 24 Jun 2021 16:29:55 -0700
Message-Id: <20210624232957.6805-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624232957.6805-1-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the dev_get_drvdata() calls into the ufshcd_{system,runtime}_*()
functions. Remove ufshcd_runtime_idle() since it is empty. This patch
does not change any functionality.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 34 +++------------------
 drivers/scsi/ufs/ufshcd-pci.c      | 48 ++----------------------------
 drivers/scsi/ufs/ufshcd-pltfrm.c   | 47 -----------------------------
 drivers/scsi/ufs/ufshcd.c          | 35 ++++++++++------------
 drivers/scsi/ufs/ufshcd.h          |  9 +++---
 5 files changed, 26 insertions(+), 147 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index ec4589afbc13..96ef98a95b85 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -23,31 +23,6 @@ static int tc_type = TC_G210_INV;
 module_param(tc_type, int, 0);
 MODULE_PARM_DESC(tc_type, "Test Chip Type (20 = 20-bit, 40 = 40-bit)");
 
-static int tc_dwc_g210_pci_suspend(struct device *dev)
-{
-	return ufshcd_system_suspend(dev_get_drvdata(dev));
-}
-
-static int tc_dwc_g210_pci_resume(struct device *dev)
-{
-	return ufshcd_system_resume(dev_get_drvdata(dev));
-}
-
-static int tc_dwc_g210_pci_runtime_suspend(struct device *dev)
-{
-	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
-}
-
-static int tc_dwc_g210_pci_runtime_resume(struct device *dev)
-{
-	return ufshcd_runtime_resume(dev_get_drvdata(dev));
-}
-
-static int tc_dwc_g210_pci_runtime_idle(struct device *dev)
-{
-	return ufshcd_runtime_idle(dev_get_drvdata(dev));
-}
-
 /*
  * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
  */
@@ -143,11 +118,10 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static const struct dev_pm_ops tc_dwc_g210_pci_pm_ops = {
-	.suspend	= tc_dwc_g210_pci_suspend,
-	.resume		= tc_dwc_g210_pci_resume,
-	.runtime_suspend = tc_dwc_g210_pci_runtime_suspend,
-	.runtime_resume  = tc_dwc_g210_pci_runtime_resume,
-	.runtime_idle    = tc_dwc_g210_pci_runtime_idle,
+	.suspend	 = ufshcd_system_suspend,
+	.resume		 = ufshcd_system_resume,
+	.runtime_suspend = ufshcd_runtime_suspend,
+	.runtime_resume  = ufshcd_runtime_resume,
 	.prepare	 = ufshcd_suspend_prepare,
 	.complete	 = ufshcd_resume_complete,
 };
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index e6c334bfb4c2..f07f4a490025 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -385,48 +385,6 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
-#ifdef CONFIG_PM_SLEEP
-/**
- * ufshcd_pci_suspend - suspend power management function
- * @dev: pointer to PCI device handle
- *
- * Returns 0 if successful
- * Returns non-zero otherwise
- */
-static int ufshcd_pci_suspend(struct device *dev)
-{
-	return ufshcd_system_suspend(dev_get_drvdata(dev));
-}
-
-/**
- * ufshcd_pci_resume - resume power management function
- * @dev: pointer to PCI device handle
- *
- * Returns 0 if successful
- * Returns non-zero otherwise
- */
-static int ufshcd_pci_resume(struct device *dev)
-{
-	return ufshcd_system_resume(dev_get_drvdata(dev));
-}
-
-#endif /* !CONFIG_PM_SLEEP */
-
-#ifdef CONFIG_PM
-static int ufshcd_pci_runtime_suspend(struct device *dev)
-{
-	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
-}
-static int ufshcd_pci_runtime_resume(struct device *dev)
-{
-	return ufshcd_runtime_resume(dev_get_drvdata(dev));
-}
-static int ufshcd_pci_runtime_idle(struct device *dev)
-{
-	return ufshcd_runtime_idle(dev_get_drvdata(dev));
-}
-#endif /* !CONFIG_PM */
-
 /**
  * ufshcd_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
@@ -510,10 +468,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static const struct dev_pm_ops ufshcd_pci_pm_ops = {
-	SET_RUNTIME_PM_OPS(ufshcd_pci_runtime_suspend,
-			   ufshcd_pci_runtime_resume,
-			   ufshcd_pci_runtime_idle)
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_pci_suspend, ufshcd_pci_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
 #ifdef CONFIG_PM_SLEEP
 	.prepare	= ufshcd_suspend_prepare,
 	.complete	= ufshcd_resume_complete,
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 298e22ef907e..8859c13f4e09 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -170,53 +170,6 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 	return err;
 }
 
-#ifdef CONFIG_PM
-/**
- * ufshcd_pltfrm_suspend - suspend power management function
- * @dev: pointer to device handle
- *
- * Returns 0 if successful
- * Returns non-zero otherwise
- */
-int ufshcd_pltfrm_suspend(struct device *dev)
-{
-	return ufshcd_system_suspend(dev_get_drvdata(dev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_suspend);
-
-/**
- * ufshcd_pltfrm_resume - resume power management function
- * @dev: pointer to device handle
- *
- * Returns 0 if successful
- * Returns non-zero otherwise
- */
-int ufshcd_pltfrm_resume(struct device *dev)
-{
-	return ufshcd_system_resume(dev_get_drvdata(dev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_resume);
-
-int ufshcd_pltfrm_runtime_suspend(struct device *dev)
-{
-	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_suspend);
-
-int ufshcd_pltfrm_runtime_resume(struct device *dev)
-{
-	return ufshcd_runtime_resume(dev_get_drvdata(dev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_resume);
-
-int ufshcd_pltfrm_runtime_idle(struct device *dev)
-{
-	return ufshcd_runtime_idle(dev_get_drvdata(dev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_idle);
-
-#endif /* CONFIG_PM */
-
 void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
 {
 	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5b31de83a63a..f097720b6b5e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9204,15 +9204,16 @@ static int ufshcd_resume(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_system_suspend - system suspend routine
- * @hba: per adapter instance
+ * ufshcd_system_suspend - system suspend callback
+ * @dev: Device associated with the UFS controller.
  *
  * Check the description of ufshcd_suspend() function for more details.
  *
  * Returns 0 for success and non-zero for failure
  */
-int ufshcd_system_suspend(struct ufs_hba *hba)
+int ufshcd_system_suspend(struct device *dev)
 {
+	struct ufs_hba *hba = dev_get_drvdata(dev);
 	int ret = 0;
 	ktime_t start = ktime_get();
 
@@ -9229,16 +9230,16 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 EXPORT_SYMBOL(ufshcd_system_suspend);
 
 /**
- * ufshcd_system_resume - system resume routine
- * @hba: per adapter instance
+ * ufshcd_system_resume - system resume callback
+ * @dev: Device associated with the UFS controller.
  *
  * Returns 0 for success and non-zero for failure
  */
-
-int ufshcd_system_resume(struct ufs_hba *hba)
+int ufshcd_system_resume(struct device *dev)
 {
-	int ret = 0;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
 	ktime_t start = ktime_get();
+	int ret = 0;
 
 	if (pm_runtime_suspended(hba->dev))
 		goto out;
@@ -9255,15 +9256,16 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 EXPORT_SYMBOL(ufshcd_system_resume);
 
 /**
- * ufshcd_runtime_suspend - runtime suspend routine
- * @hba: per adapter instance
+ * ufshcd_runtime_suspend - runtime suspend callback
+ * @dev: Device associated with the UFS controller.
  *
  * Check the description of ufshcd_suspend() function for more details.
  *
  * Returns 0 for success and non-zero for failure
  */
-int ufshcd_runtime_suspend(struct ufs_hba *hba)
+int ufshcd_runtime_suspend(struct device *dev)
 {
+	struct ufs_hba *hba = dev_get_drvdata(dev);
 	int ret;
 	ktime_t start = ktime_get();
 
@@ -9278,7 +9280,7 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
 
 /**
  * ufshcd_runtime_resume - runtime resume routine
- * @hba: per adapter instance
+ * @dev: Device associated with the UFS controller.
  *
  * This function basically brings controller
  * to active state. Following operations are done in this function:
@@ -9286,8 +9288,9 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
  * 1. Turn on all the controller related clocks
  * 2. Turn ON VCC rail
  */
-int ufshcd_runtime_resume(struct ufs_hba *hba)
+int ufshcd_runtime_resume(struct device *dev)
 {
+	struct ufs_hba *hba = dev_get_drvdata(dev);
 	int ret;
 	ktime_t start = ktime_get();
 
@@ -9300,12 +9303,6 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
-int ufshcd_runtime_idle(struct ufs_hba *hba)
-{
-	return 0;
-}
-EXPORT_SYMBOL(ufshcd_runtime_idle);
-
 /**
  * ufshcd_shutdown - shutdown routine
  * @hba: per adapter instance
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..dc75426c609f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1009,11 +1009,10 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 	return 0;
 }
 
-extern int ufshcd_runtime_suspend(struct ufs_hba *hba);
-extern int ufshcd_runtime_resume(struct ufs_hba *hba);
-extern int ufshcd_runtime_idle(struct ufs_hba *hba);
-extern int ufshcd_system_suspend(struct ufs_hba *hba);
-extern int ufshcd_system_resume(struct ufs_hba *hba);
+extern int ufshcd_runtime_suspend(struct device *dev);
+extern int ufshcd_runtime_resume(struct device *dev);
+extern int ufshcd_system_suspend(struct device *dev);
+extern int ufshcd_system_resume(struct device *dev);
 extern int ufshcd_shutdown(struct ufs_hba *hba);
 extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
 				      int agreed_gear,
