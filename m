From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 8/9] ufshcd-pltfrm: remove redundant dev_err call in ufshcd_pltfrm_probe()
Date: Sun, 28 Jul 2013 22:40:36 +0530
Message-ID: <1375031437-10206-9-git-send-email-santoshsy@gmail.com>
References: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63777 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3G1RND (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 13:13:03 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so4633441pdj.14
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2013 10:13:02 -0700 (PDT)
In-Reply-To: <1375031437-10206-1-git-send-email-santoshsy@gmail.com>
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
index 13b8c5a..34f726c 100644
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

