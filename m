Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63AEC77B73
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 20:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjERUVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 16:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjERUVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 16:21:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA710D2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 13:21:03 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pzk7I-0002YB-Up; Thu, 18 May 2023 22:20:52 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pzk7F-0019uO-Ej; Thu, 18 May 2023 22:20:49 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pzk7E-005kwI-RA; Thu, 18 May 2023 22:20:48 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] scsi: hisi_sas: Convert to platform remove callback returning void
Date:   Thu, 18 May 2023 22:20:43 +0200
Message-Id: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4272; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=Fr4AdTOm26xRT/v5+ND70mcCKG9f+Qgf1scc+ROos3Q=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkZoibb8QR3vjcwNc6IGCZcRqg+EfunBeqWOnfw ZoLcc9K0yiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZGaImwAKCRCPgPtYfRL+ TmIRB/9ldQL2YCSPFZ/U6I+b9z1TqHuj264cgxuEkXhzgdqowxy41KOYv3C3u73VeueXCxawBq4 TJpgQLs+UjetcTBqKdiymNGwPpqWB/lh7v7ZCqZjhTNtF6rTPsx44YJFcd/6n0icRt/kTMnOap7 V7bj9ph0HqycEUh+S61Nr0lMPgoXwwvBle8KFoLbSGGlnkc8AANHNs5HT7ilMj8/9NMGyfQhpOC KmVJWpfoLQdC5xEWdkQH/uIk4NRZyQZxLfovJn9I1OYSC/VGH7uZT32Ho3LH3OxumtuRfcV8hIz pEs07G87B9f/uGsuvVqExwRGTxzPSMyhHFVH6dxuFHgdYBN7
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

hisi_sas_remove() returned zero unconditionally so this was changed to
return void. Then it has the right prototype to be used directly as
remove callback for the two hisi_sas drivers.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 +--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 7 +------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 7 +------
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index fb7c52c119df..9e73e9cbbcfc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -642,7 +642,7 @@ extern void hisi_sas_sata_done(struct sas_task *task,
 extern int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
-extern int hisi_sas_remove(struct platform_device *pdev);
+extern void hisi_sas_remove(struct platform_device *pdev);
 
 extern int hisi_sas_slave_configure(struct scsi_device *sdev);
 extern int hisi_sas_slave_alloc(struct scsi_device *sdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 412431c901a7..8f22ece957bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2560,7 +2560,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_probe);
 
-int hisi_sas_remove(struct platform_device *pdev)
+void hisi_sas_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
@@ -2573,7 +2573,6 @@ int hisi_sas_remove(struct platform_device *pdev)
 
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_sas_remove);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 0aa8c9c88535..94fbbceddc2e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1790,11 +1790,6 @@ static int hisi_sas_v1_probe(struct platform_device *pdev)
 	return hisi_sas_probe(pdev, &hisi_sas_v1_hw);
 }
 
-static int hisi_sas_v1_remove(struct platform_device *pdev)
-{
-	return hisi_sas_remove(pdev);
-}
-
 static const struct of_device_id sas_v1_of_match[] = {
 	{ .compatible = "hisilicon,hip05-sas-v1",},
 	{},
@@ -1810,7 +1805,7 @@ MODULE_DEVICE_TABLE(acpi, sas_v1_acpi_match);
 
 static struct platform_driver hisi_sas_v1_driver = {
 	.probe = hisi_sas_v1_probe,
-	.remove = hisi_sas_v1_remove,
+	.remove_new = hisi_sas_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v1_of_match,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cd78e4c983aa..87d8e408ccd1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3619,11 +3619,6 @@ static int hisi_sas_v2_probe(struct platform_device *pdev)
 	return hisi_sas_probe(pdev, &hisi_sas_v2_hw);
 }
 
-static int hisi_sas_v2_remove(struct platform_device *pdev)
-{
-	return hisi_sas_remove(pdev);
-}
-
 static const struct of_device_id sas_v2_of_match[] = {
 	{ .compatible = "hisilicon,hip06-sas-v2",},
 	{ .compatible = "hisilicon,hip07-sas-v2",},
@@ -3640,7 +3635,7 @@ MODULE_DEVICE_TABLE(acpi, sas_v2_acpi_match);
 
 static struct platform_driver hisi_sas_v2_driver = {
 	.probe = hisi_sas_v2_probe,
-	.remove = hisi_sas_v2_remove,
+	.remove_new = hisi_sas_remove,
 	.driver = {
 		.name = DRV_NAME,
 		.of_match_table = sas_v2_of_match,

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2

