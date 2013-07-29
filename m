From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 8/9] ufshcd-pltfrm: remove redundant dev_err call in ufshcd_pltfrm_probe()
Date: Tue, 30 Jul 2013 00:36:04 +0530
Message-ID: <1375124765-4110-9-git-send-email-santoshsy@gmail.com>
References: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57911 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3G2TIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 15:08:21 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so5200655pad.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 12:08:21 -0700 (PDT)
In-Reply-To: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Santosh Y <santoshsy@gmail.com>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8b4a27f..880d19f 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -145,7 +145,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	mmio_base = devm_ioremap_resource(dev, mem_res);
 	if (IS_ERR(mmio_base)) {
-		dev_err(dev, "memory map failed\n");
 		err = PTR_ERR(mmio_base);
 		goto out;
 	}
-- 
1.8.3.1

