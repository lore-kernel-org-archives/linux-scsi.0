From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 5/5] scsi: sni: use module_platform_driver() and platform_{set,get}_drvdata
Date: Thu, 30 May 2013 20:09:46 +0800
Message-ID: <1369915786-2660-6-git-send-email-wangkefeng.wang@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:15657 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3E3MLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 May 2013 08:11:39 -0400
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com, Kefeng Wang <wangkefeng.wang@huawei.com>

Use helper macro and wrapper functions to simpily code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/sni_53c710.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 52d54e7..eff84c4 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -104,7 +104,7 @@ static int snirm710_probe(struct platform_device *dev)
 		goto out_put_host;
 	}
 
-	dev_set_drvdata(&dev->dev, host);
+	platform_set_drvdata(dev, host);
 	scsi_scan_host(host);
 
 	return 0;
@@ -119,7 +119,7 @@ static int snirm710_probe(struct platform_device *dev)
 
 static int __exit snirm710_driver_remove(struct platform_device *dev)
 {
-	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
+	struct Scsi_Host *host = platform_get_drvdata(dev);
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
@@ -141,15 +141,4 @@ static struct platform_driver snirm710_driver = {
 	},
 };
 
-static int __init snirm710_init(void)
-{
-	return platform_driver_register(&snirm710_driver);
-}
-
-static void __exit snirm710_exit(void)
-{
-	platform_driver_unregister(&snirm710_driver);
-}
-
-module_init(snirm710_init);
-module_exit(snirm710_exit);
+module_platform_driver(snirm710_driver);
-- 
1.8.2.1


