Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE05ECD13CF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Sep 2023 14:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbjIQO66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Sep 2023 10:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjIQO60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Sep 2023 10:58:26 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8AA11B
        for <linux-scsi@vger.kernel.org>; Sun, 17 Sep 2023 07:58:20 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhtDy-0008W9-RM; Sun, 17 Sep 2023 16:58:14 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhtDw-0070ZO-9d; Sun, 17 Sep 2023 16:58:12 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qhtDv-002Lb9-WC; Sun, 17 Sep 2023 16:58:12 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH] scsi: ufs: Convert all platform drivers to return void
Date:   Sun, 17 Sep 2023 16:57:22 +0200
Message-Id: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=9840; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=dEuIoPoYlIz5oSnh7UYvBopHU40OX673tMlwci88goU=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlR24YvtSkFRK79Pt17TyC5mtKi/UY/F76rd7rQZhS8vZ bX7LRfqZDRmYWDkYpAVU2Sxb1yTaVUlF9m59t9lmEGsTCBTGLg4BWAiK3zY/wdfnaO9xbg+dlXl luKnXEYH4h5viu9MUgrtmaZ1RrSl7gejnVNjjWB0n3CxbK7oDH2R+QqzZvLecvfb0vdT1a/evfS cU0FBv/L93NlVv57dzTKe2xx0ML5o/f//zNWra3ZEvd7uHv1cPW+z/9GPa824L7Dqzy9l4pD2ar Iz1zv0bplh7GSlMN1JETw9x3nOK/hdf25x/UumJkeHdNJyiegjBgv33n1weaLI1AVODcsFj3W9D X1z1LmLuaqvQ4HzRXlifVuAn1vPOWVB/3uK9r9vRlvsCglc0WZwxuTqHL3ziWznxFZvv8Pye87F y+zTXCfZNvplTH1VcvNczjkBrSkbPWzMDZOkTryuO/0eAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

All platform drivers below drivers/ufs/ unconditionally return zero in
their remove callback and so can be converted trivially to the variant
returning void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/ufs/host/cdns-pltfrm.c        | 5 ++---
 drivers/ufs/host/tc-dwc-g210-pltfrm.c | 6 ++----
 drivers/ufs/host/ti-j721e-ufs.c       | 6 ++----
 drivers/ufs/host/ufs-exynos.c         | 6 ++----
 drivers/ufs/host/ufs-hisi.c           | 5 ++---
 drivers/ufs/host/ufs-mediatek.c       | 5 ++---
 drivers/ufs/host/ufs-qcom.c           | 5 ++---
 drivers/ufs/host/ufs-renesas.c        | 6 ++----
 drivers/ufs/host/ufs-sprd.c           | 5 ++---
 9 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index 2491e7e87028..bb30267da471 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -305,12 +305,11 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
  *
  * Return: 0 (success).
  */
-static int cdns_ufs_pltfrm_remove(struct platform_device *pdev)
+static void cdns_ufs_pltfrm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	ufshcd_remove(hba);
-	return 0;
 }
 
 static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
@@ -322,7 +321,7 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
 
 static struct platform_driver cdns_ufs_pltfrm_driver = {
 	.probe	= cdns_ufs_pltfrm_probe,
-	.remove	= cdns_ufs_pltfrm_remove,
+	.remove_new = cdns_ufs_pltfrm_remove,
 	.driver	= {
 		.name   = "cdns-ufshcd",
 		.pm     = &cdns_ufs_dev_pm_ops,
diff --git a/drivers/ufs/host/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
index 4d5389dd9585..a3877592604d 100644
--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -74,14 +74,12 @@ static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
  * @pdev: pointer to platform device structure
  *
  */
-static int tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
+static void tc_dwc_g210_pltfm_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
-
-	return 0;
 }
 
 static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
@@ -91,7 +89,7 @@ static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
 
 static struct platform_driver tc_dwc_g210_pltfm_driver = {
 	.probe		= tc_dwc_g210_pltfm_probe,
-	.remove		= tc_dwc_g210_pltfm_remove,
+	.remove_new	= tc_dwc_g210_pltfm_remove,
 	.driver		= {
 		.name	= "tc-dwc-g210-pltfm",
 		.pm	= &tc_dwc_g210_pltfm_pm_ops,
diff --git a/drivers/ufs/host/ti-j721e-ufs.c b/drivers/ufs/host/ti-j721e-ufs.c
index 117eb7da92ac..250c22df000d 100644
--- a/drivers/ufs/host/ti-j721e-ufs.c
+++ b/drivers/ufs/host/ti-j721e-ufs.c
@@ -65,13 +65,11 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ti_j721e_ufs_remove(struct platform_device *pdev)
+static void ti_j721e_ufs_remove(struct platform_device *pdev)
 {
 	of_platform_depopulate(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static const struct of_device_id ti_j721e_ufs_of_match[] = {
@@ -85,7 +83,7 @@ MODULE_DEVICE_TABLE(of, ti_j721e_ufs_of_match);
 
 static struct platform_driver ti_j721e_ufs_driver = {
 	.probe	= ti_j721e_ufs_probe,
-	.remove	= ti_j721e_ufs_remove,
+	.remove_new = ti_j721e_ufs_remove,
 	.driver	= {
 		.name   = "ti-j721e-ufs",
 		.of_match_table = ti_j721e_ufs_of_match,
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 3396e0388512..3178efe0889e 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1605,7 +1605,7 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int exynos_ufs_remove(struct platform_device *pdev)
+static void exynos_ufs_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -1615,8 +1615,6 @@ static int exynos_ufs_remove(struct platform_device *pdev)
 
 	phy_power_off(ufs->phy);
 	phy_exit(ufs->phy);
-
-	return 0;
 }
 
 static struct exynos_ufs_uic_attr exynos7_uic_attr = {
@@ -1756,7 +1754,7 @@ static const struct dev_pm_ops exynos_ufs_pm_ops = {
 
 static struct platform_driver exynos_ufs_pltform = {
 	.probe	= exynos_ufs_probe,
-	.remove	= exynos_ufs_remove,
+	.remove_new = exynos_ufs_remove,
 	.driver	= {
 		.name	= "exynos-ufshc",
 		.pm	= &exynos_ufs_pm_ops,
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 5b3060cd0ab8..0229ac0a8dbe 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -575,12 +575,11 @@ static int ufs_hisi_probe(struct platform_device *pdev)
 	return ufshcd_pltfrm_init(pdev, of_id->data);
 }
 
-static int ufs_hisi_remove(struct platform_device *pdev)
+static void ufs_hisi_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	ufshcd_remove(hba);
-	return 0;
 }
 
 static const struct dev_pm_ops ufs_hisi_pm_ops = {
@@ -592,7 +591,7 @@ static const struct dev_pm_ops ufs_hisi_pm_ops = {
 
 static struct platform_driver ufs_hisi_pltform = {
 	.probe	= ufs_hisi_probe,
-	.remove	= ufs_hisi_remove,
+	.remove_new = ufs_hisi_remove,
 	.driver	= {
 		.name	= "ufshcd-hisi",
 		.pm	= &ufs_hisi_pm_ops,
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 941f58744d08..fc61790d289b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1748,13 +1748,12 @@ static int ufs_mtk_probe(struct platform_device *pdev)
  *
  * Always return 0
  */
-static int ufs_mtk_remove(struct platform_device *pdev)
+static void ufs_mtk_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1818,7 +1817,7 @@ static const struct dev_pm_ops ufs_mtk_pm_ops = {
 
 static struct platform_driver ufs_mtk_pltform = {
 	.probe      = ufs_mtk_probe,
-	.remove     = ufs_mtk_remove,
+	.remove_new = ufs_mtk_remove,
 	.driver = {
 		.name   = "ufshcd-mtk",
 		.pm     = &ufs_mtk_pm_ops,
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a6078d5939ed..2128db0293b5 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2031,14 +2031,13 @@ static int ufs_qcom_probe(struct platform_device *pdev)
  *
  * Always returns 0
  */
-static int ufs_qcom_remove(struct platform_device *pdev)
+static void ufs_qcom_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
 	platform_msi_domain_free_irqs(hba->dev);
-	return 0;
 }
 
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
@@ -2070,7 +2069,7 @@ static const struct dev_pm_ops ufs_qcom_pm_ops = {
 
 static struct platform_driver ufs_qcom_pltform = {
 	.probe	= ufs_qcom_probe,
-	.remove	= ufs_qcom_remove,
+	.remove_new = ufs_qcom_remove,
 	.driver	= {
 		.name	= "ufshcd-qcom",
 		.pm	= &ufs_qcom_pm_ops,
diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index cc94970b86c9..8711e5cbc968 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -388,18 +388,16 @@ static int ufs_renesas_probe(struct platform_device *pdev)
 	return ufshcd_pltfrm_init(pdev, &ufs_renesas_vops);
 }
 
-static int ufs_renesas_remove(struct platform_device *pdev)
+static void ufs_renesas_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba = platform_get_drvdata(pdev);
 
 	ufshcd_remove(hba);
-
-	return 0;
 }
 
 static struct platform_driver ufs_renesas_platform = {
 	.probe	= ufs_renesas_probe,
-	.remove	= ufs_renesas_remove,
+	.remove_new = ufs_renesas_remove,
 	.driver	= {
 		.name	= "ufshcd-renesas",
 		.of_match_table	= of_match_ptr(ufs_renesas_of_match),
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 2bad75dd6d58..d8b165908809 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -425,13 +425,12 @@ static int ufs_sprd_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int ufs_sprd_remove(struct platform_device *pdev)
+static void ufs_sprd_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
-	return 0;
 }
 
 static const struct dev_pm_ops ufs_sprd_pm_ops = {
@@ -443,7 +442,7 @@ static const struct dev_pm_ops ufs_sprd_pm_ops = {
 
 static struct platform_driver ufs_sprd_pltform = {
 	.probe = ufs_sprd_probe,
-	.remove = ufs_sprd_remove,
+	.remove_new = ufs_sprd_remove,
 	.driver = {
 		.name = "ufshcd-sprd",
 		.pm = &ufs_sprd_pm_ops,

base-commit: dfa449a58323de195773cf928d99db4130702bf7
-- 
2.40.1

