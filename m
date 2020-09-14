Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56A6C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 06:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8548921548
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 06:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgINGbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 02:31:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11829 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726082AbgINGbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 02:31:35 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6E366DE75CDFA232D192;
        Mon, 14 Sep 2020 14:31:32 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 14 Sep 2020
 14:31:24 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] scsi: use module_platform_driver to simplify the code
Date:   Mon, 14 Sep 2020 14:54:03 +0800
Message-ID: <20200914065403.3726462-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

module_platform_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/scsi/jazz_esp.c   | 14 +-------------
 drivers/scsi/mac_esp.c    | 14 +-------------
 drivers/scsi/qlogicpti.c  | 14 +-------------
 drivers/scsi/sni_53c710.c | 14 +-------------
 drivers/scsi/sun3x_esp.c  | 14 +-------------
 drivers/scsi/sun_esp.c    | 14 +-------------
 6 files changed, 6 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 7f683e42c798..f0ed6863cc70 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -201,21 +201,9 @@ static struct platform_driver esp_jazz_driver = {
 		.name	= "jazz_esp",
 	},
 };
-
-static int __init jazz_esp_init(void)
-{
-	return platform_driver_register(&esp_jazz_driver);
-}
-
-static void __exit jazz_esp_exit(void)
-{
-	platform_driver_unregister(&esp_jazz_driver);
-}
+module_platform_driver(esp_jazz_driver);
 
 MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(jazz_esp_init);
-module_exit(jazz_esp_exit);
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 1c78bc10c790..6d23ab5aee56 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -439,22 +439,10 @@ static struct platform_driver esp_mac_driver = {
 		.name	= DRV_MODULE_NAME,
 	},
 };
-
-static int __init mac_esp_init(void)
-{
-	return platform_driver_register(&esp_mac_driver);
-}
-
-static void __exit mac_esp_exit(void)
-{
-	platform_driver_unregister(&esp_mac_driver);
-}
+module_platform_driver(esp_mac_driver);
 
 MODULE_DESCRIPTION("Mac ESP SCSI driver");
 MODULE_AUTHOR("Finn Thain");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_MODULE_NAME);
-
-module_init(mac_esp_init);
-module_exit(mac_esp_exit);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 48ff7d88af86..d84e218d32cb 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1468,22 +1468,10 @@ static struct platform_driver qpti_sbus_driver = {
 	.probe		= qpti_sbus_probe,
 	.remove		= qpti_sbus_remove,
 };
-
-static int __init qpti_init(void)
-{
-	return platform_driver_register(&qpti_sbus_driver);
-}
-
-static void __exit qpti_exit(void)
-{
-	platform_driver_unregister(&qpti_sbus_driver);
-}
+module_platform_driver(qpti_sbus_driver);
 
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("2.1");
 MODULE_FIRMWARE("qlogic/isp1000.bin");
-
-module_init(qpti_init);
-module_exit(qpti_exit);
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 03d43f016397..9e2e196bc202 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -124,16 +124,4 @@ static struct platform_driver snirm710_driver = {
 		.name	= "snirm_53c710",
 	},
 };
-
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
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index f37df79e37e1..7de82f2c9757 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -270,22 +270,10 @@ static struct platform_driver esp_sun3x_driver = {
 		.name   = "sun3x_esp",
 	},
 };
-
-static int __init sun3x_esp_init(void)
-{
-	return platform_driver_register(&esp_sun3x_driver);
-}
-
-static void __exit sun3x_esp_exit(void)
-{
-	platform_driver_unregister(&esp_sun3x_driver);
-}
+module_platform_driver(esp_sun3x_driver);
 
 MODULE_DESCRIPTION("Sun3x ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sun3x_esp_init);
-module_exit(sun3x_esp_exit);
 MODULE_ALIAS("platform:sun3x_esp");
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 964130d2c8a6..5dc38d35745b 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -606,21 +606,9 @@ static struct platform_driver esp_sbus_driver = {
 	.probe		= esp_sbus_probe,
 	.remove		= esp_sbus_remove,
 };
-
-static int __init sunesp_init(void)
-{
-	return platform_driver_register(&esp_sbus_driver);
-}
-
-static void __exit sunesp_exit(void)
-{
-	platform_driver_unregister(&esp_sbus_driver);
-}
+module_platform_driver(esp_sbus_driver);
 
 MODULE_DESCRIPTION("Sun ESP SCSI driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(sunesp_init);
-module_exit(sunesp_exit);
-- 
2.25.1

