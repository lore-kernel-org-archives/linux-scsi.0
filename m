Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2B5C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 20:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjEXUiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 16:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjEXUiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 16:38:03 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8D710B
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:38:01 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so1127308b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960681; x=1687552681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EPgN+x11j9c7CWViTXwWdIynoIvPviij1iooN8SHTFo=;
        b=feRIZICVfOxrsKuiozoHtp8qJm0Cq7IDCH7hT6RClzovhhVIZZfdzyw9cKCTIxxffM
         bdcgu+7J93xdiETuehiyr+LhK0AwWhCzyH6KNWKpwjb72nAQXB+OCpUx0F6ENmj2DpjB
         LHmHbgAyIadVSPYPT9Ca7gvkkcyeHU9MIjLQ7GsuyleDTpdEyJfTyoDu7WeIh8XuIWbV
         HFiXIh98MBZSfr9fXu6rAWDNGITKf/3Fq3STab+I8HKMR91Pp6oJ+J419X1dPP7D7TQB
         2fPscZ3Sz9lrNd8BZasECaxSQey3vvc8DwgfkMbwjvZNJD80iDUnBd9YXYrNsFShz5Mw
         L7YA==
X-Gm-Message-State: AC+VfDwxvn7+AU9rOo4CSUhNPBvxn7NFGqPT8hTs7LBIZe4RKHRFynJ5
        y5Au4MSPCqzKlzU2b7vpucE=
X-Google-Smtp-Source: ACHHUZ73CIT8cWGTx7xgzrtP1vE8FBs14g5XK/mv4KweHv5a0dF7KrsCTc1UUKVGHQTmW7Q1okST0w==
X-Received: by 2002:a05:6a21:998f:b0:10a:c0cb:43ea with SMTP id ve15-20020a056a21998f00b0010ac0cb43eamr19368895pzb.49.1684960680643;
        Wed, 24 May 2023 13:38:00 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090a70c700b002535dc42bb5sm1690122pjm.47.2023.05.24.13.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:38:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Zhe Wang <zhe.wang1@unisoc.com>,
        Daniil Lunev <dlunev@chromium.org>, Liang He <windhl@126.com>,
        Can Guo <quic_cang@quicinc.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 4/4] scsi: ufs: Simplify driver shutdown
Date:   Wed, 24 May 2023 13:36:22 -0700
Message-ID: <20230524203659.1394307-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org>
References: <20230524203659.1394307-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All UFS host drivers call ufshcd_shutdown(). Hence, instead of calling
ufshcd_shutdown() from the host driver .shutdown() callback, inline that
function into ufshcd_wl_shutdown().

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c             | 23 +++++------------------
 drivers/ufs/host/cdns-pltfrm.c        |  1 -
 drivers/ufs/host/tc-dwc-g210-pci.c    | 10 ----------
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |  1 -
 drivers/ufs/host/ufs-exynos.c         |  1 -
 drivers/ufs/host/ufs-hisi.c           |  1 -
 drivers/ufs/host/ufs-mediatek.c       |  1 -
 drivers/ufs/host/ufs-qcom.c           |  1 -
 drivers/ufs/host/ufs-sprd.c           |  1 -
 drivers/ufs/host/ufshcd-pci.c         | 10 ----------
 drivers/ufs/host/ufshcd-pltfrm.c      |  6 ------
 drivers/ufs/host/ufshcd-pltfrm.h      |  1 -
 include/ufs/ufshcd.h                  |  1 -
 13 files changed, 5 insertions(+), 53 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 908b9f98b2e0..abe9a430cc37 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9936,9 +9936,7 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
 static void ufshcd_wl_shutdown(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
+	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
 	hba->shutting_down = true;
@@ -9953,27 +9951,16 @@ static void ufshcd_wl_shutdown(struct device *dev)
 		scsi_device_quiesce(sdev);
 	}
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
-}
 
-/**
- * ufshcd_shutdown - shutdown routine
- * @hba: per adapter instance
- *
- * This function would turn off both UFS device and UFS hba
- * regulators. It would also disable clocks.
- *
- * Returns 0 always to allow force shutdown even in case of errors.
- */
-int ufshcd_shutdown(struct ufs_hba *hba)
-{
+	/*
+	 * Next, turn off the UFS controller and the UFS regulators. Disable
+	 * clocks.
+	 */
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		ufshcd_suspend(hba);
 
 	hba->is_powered = false;
-	/* allow force shutdown even in case of errors */
-	return 0;
 }
-EXPORT_SYMBOL(ufshcd_shutdown);
 
 /**
  * ufshcd_remove - de-allocate SCSI host and host memory space
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index e05c0ae64eea..26761425a76c 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -328,7 +328,6 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
 static struct platform_driver cdns_ufs_pltfrm_driver = {
 	.probe	= cdns_ufs_pltfrm_probe,
 	.remove	= cdns_ufs_pltfrm_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name   = "cdns-ufshcd",
 		.pm     = &cdns_ufs_dev_pm_ops,
diff --git a/drivers/ufs/host/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
index 92b8ad4b58fe..f96fe5855841 100644
--- a/drivers/ufs/host/tc-dwc-g210-pci.c
+++ b/drivers/ufs/host/tc-dwc-g210-pci.c
@@ -32,15 +32,6 @@ static struct ufs_hba_variant_ops tc_dwc_g210_pci_hba_vops = {
 	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
 };
 
-/**
- * tc_dwc_g210_pci_shutdown - main function to put the controller in reset state
- * @pdev: pointer to PCI device handle
- */
-static void tc_dwc_g210_pci_shutdown(struct pci_dev *pdev)
-{
-	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
-}
-
 /**
  * tc_dwc_g210_pci_remove - de-allocate PCI/SCSI host and host memory space
  *		data structure memory
@@ -137,7 +128,6 @@ static struct pci_driver tc_dwc_g210_pci_driver = {
 	.id_table = tc_dwc_g210_pci_tbl,
 	.probe = tc_dwc_g210_pci_probe,
 	.remove = tc_dwc_g210_pci_remove,
-	.shutdown = tc_dwc_g210_pci_shutdown,
 	.driver = {
 		.pm = &tc_dwc_g210_pci_pm_ops
 	},
diff --git a/drivers/ufs/host/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
index f15a84d0c176..4d5389dd9585 100644
--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -92,7 +92,6 @@ static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
 static struct platform_driver tc_dwc_g210_pltfm_driver = {
 	.probe		= tc_dwc_g210_pltfm_probe,
 	.remove		= tc_dwc_g210_pltfm_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver		= {
 		.name	= "tc-dwc-g210-pltfm",
 		.pm	= &tc_dwc_g210_pltfm_pm_ops,
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 0bf5390739e1..f41056f57fd7 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1757,7 +1757,6 @@ static const struct dev_pm_ops exynos_ufs_pm_ops = {
 static struct platform_driver exynos_ufs_pltform = {
 	.probe	= exynos_ufs_probe,
 	.remove	= exynos_ufs_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name	= "exynos-ufshc",
 		.pm	= &exynos_ufs_pm_ops,
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 4c423eba8aa9..18b72e2e68c1 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -593,7 +593,6 @@ static const struct dev_pm_ops ufs_hisi_pm_ops = {
 static struct platform_driver ufs_hisi_pltform = {
 	.probe	= ufs_hisi_probe,
 	.remove	= ufs_hisi_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name	= "ufshcd-hisi",
 		.pm	= &ufs_hisi_pm_ops,
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index a054810e321d..33b301649757 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1647,7 +1647,6 @@ static const struct dev_pm_ops ufs_mtk_pm_ops = {
 static struct platform_driver ufs_mtk_pltform = {
 	.probe      = ufs_mtk_probe,
 	.remove     = ufs_mtk_remove,
-	.shutdown   = ufshcd_pltfrm_shutdown,
 	.driver = {
 		.name   = "ufshcd-mtk",
 		.pm     = &ufs_mtk_pm_ops,
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 82d02e7f3b4f..059de74dfea3 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1723,7 +1723,6 @@ static const struct dev_pm_ops ufs_qcom_pm_ops = {
 static struct platform_driver ufs_qcom_pltform = {
 	.probe	= ufs_qcom_probe,
 	.remove	= ufs_qcom_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name	= "ufshcd-qcom",
 		.pm	= &ufs_qcom_pm_ops,
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 051f3f40d92c..2bad75dd6d58 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -444,7 +444,6 @@ static const struct dev_pm_ops ufs_sprd_pm_ops = {
 static struct platform_driver ufs_sprd_pltform = {
 	.probe = ufs_sprd_probe,
 	.remove = ufs_sprd_remove,
-	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver = {
 		.name = "ufshcd-sprd",
 		.pm = &ufs_sprd_pm_ops,
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 9c911787f84c..38276dac8e52 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -504,15 +504,6 @@ static int ufshcd_pci_restore(struct device *dev)
 }
 #endif
 
-/**
- * ufshcd_pci_shutdown - main function to put the controller in reset state
- * @pdev: pointer to PCI device handle
- */
-static void ufshcd_pci_shutdown(struct pci_dev *pdev)
-{
-	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
-}
-
 /**
  * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
  *		data structure memory
@@ -618,7 +609,6 @@ static struct pci_driver ufshcd_pci_driver = {
 	.id_table = ufshcd_pci_tbl,
 	.probe = ufshcd_pci_probe,
 	.remove = ufshcd_pci_remove,
-	.shutdown = ufshcd_pci_shutdown,
 	.driver = {
 		.pm = &ufshcd_pci_pm_ops
 	},
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 5739ff007828..0b7430033047 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -190,12 +190,6 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 	return err;
 }
 
-void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
-{
-	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
-}
-EXPORT_SYMBOL_GPL(ufshcd_pltfrm_shutdown);
-
 static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index 2e4ba2bfbcad..2df108f4ac13 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -31,7 +31,6 @@ int ufshcd_get_pwr_dev_param(const struct ufs_dev_params *dev_param,
 void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       const struct ufs_hba_variant_ops *vops);
-void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
 			 struct ufs_vreg **out_vreg);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f7553293ba98..db2e669985d5 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1277,7 +1277,6 @@ extern int ufshcd_system_freeze(struct device *dev);
 extern int ufshcd_system_thaw(struct device *dev);
 extern int ufshcd_system_restore(struct device *dev);
 #endif
-extern int ufshcd_shutdown(struct ufs_hba *hba);
 
 extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
 				      int agreed_gear,
