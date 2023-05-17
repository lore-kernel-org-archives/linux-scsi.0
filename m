Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83D5C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjEQWcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjEQWcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:32:09 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B48AC
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:07 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1ae4baa77b2so10564585ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362727; x=1686954727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNBZ4pfz37Qx0O+ufK0jGonDDsHVaEvqDiXkYwzfYuQ=;
        b=hXgTpvRSexjtp8gMF46MKpryqnDKY2KNqTsTTvNlvWgxLa1Oi+W9Rq7QBqYYsiMbhX
         ggcH/EOFIkOmuzs1KxZqbprzZBNKLPJAGDlLnpFUMONSYz5HkNmeoEIuL2pHooF3Il97
         HJOBaQ2+2rjcT9h8AlUXK5td41ROstXcKPsfd3Y3CMF0kUJUSH0sawIU4gjWoTB76COV
         gLQi2Wf+4RaRNDf/50N8hqb5O5hzovbbCY6b6tdrVvyNro8D9lBxF0R/pjYJBgPb9H1/
         rbyQ8fcMqOQ/2lvdlIKQyp6AmN2BGf0ieWE0wYUW6CSrxs+uC7c4ghIZhGQh20paKiUC
         OSog==
X-Gm-Message-State: AC+VfDzMN3U/bNA1PEK4QLfIN73xQSuVRZ6W5DJxlwmofaEVOSUWlYsY
        6cptvaKJqMpyvQ8rwi9vuBirInce2zs=
X-Google-Smtp-Source: ACHHUZ4gDUE9MznvY4EUyxaTjAGGRIduNkLZ+tckKjSCaFaIGkvQtHzym8RhYeaErt9F5n2DNMVBWw==
X-Received: by 2002:a17:902:cecb:b0:1a6:413c:4a3e with SMTP id d11-20020a170902cecb00b001a6413c4a3emr398069plg.5.1684362726808;
        Wed, 17 May 2023 15:32:06 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a9f0100b00250d908a771sm61938pjp.50.2023.05.17.15.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:32:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 4/4] scsi: ufs: Simplify driver shutdown
Date:   Wed, 17 May 2023 15:31:57 -0700
Message-ID: <20230517223157.1068210-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517223157.1068210-1-bvanassche@acm.org>
References: <20230517223157.1068210-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All UFS host drivers call ufshcd_shutdown(). Hence, instead of calling
ufshcd_shutdown() from the host driver .shutdown() callback, inline that
function into ufshcd_wl_shutdown().

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
index 0f426d46d91e..7ee150d67d49 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9933,9 +9933,7 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
 static void ufshcd_wl_shutdown(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ufs_hba *hba;
-
-	hba = shost_priv(sdev->host);
+	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
 	hba->shutting_down = true;
@@ -9950,27 +9948,16 @@ static void ufshcd_wl_shutdown(struct device *dev)
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
