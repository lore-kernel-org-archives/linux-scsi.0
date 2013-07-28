From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 9/9] drivers/scsi/ufs: don't check resource with devm_ioremap_resource
Date: Sun, 28 Jul 2013 22:40:37 +0530
Message-ID: <1375031437-10206-10-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52082 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:13:14 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so1456709pdj.21
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:13:13 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Wolfram Sang <wsa@the-dreams.de>, Santosh Y <santoshsy@gmail.com>

From: Wolfram Sang <wsa@the-dreams.de>

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 34f726c..3da4252 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -137,12 +137,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(dev, "Memory resource not available\n");
-		err = -ENODEV;
-		goto out;
-	}
-
 	mmio_base = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(mmio_base)) {
 		err = PTR_ERR(mmio_base);
-- 
1.8.3.1

