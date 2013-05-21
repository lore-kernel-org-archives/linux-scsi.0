From: Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/6] scsi/dc395x: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:18 +0200
Message-ID: <1369172181-22070-3-git-send-email-peterhuewe@gmx.de>
References: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59966 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3EUVbO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 17:31:14 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MFfRr-1Uk6g00ISb-00Ec5h for
 <linux-scsi@vger.kernel.org>; Tue, 21 May 2013 23:31:13 +0200
In-Reply-To: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/dc395x.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 694e13c..4e6f29f 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4882,30 +4882,7 @@ static struct pci_driver dc395x_driver = {
 	.remove         = dc395x_remove_one,
 };
 
-
-/**
- * dc395x_module_init - Module initialization function
- *
- * Used by both module and built-in driver to initialise this driver.
- **/
-static int __init dc395x_module_init(void)
-{
-	return pci_register_driver(&dc395x_driver);
-}
-
-
-/**
- * dc395x_module_exit - Module cleanup function.
- **/
-static void __exit dc395x_module_exit(void)
-{
-	pci_unregister_driver(&dc395x_driver);
-}
-
-
-module_init(dc395x_module_init);
-module_exit(dc395x_module_exit);
-
+module_pci_driver(dc395x_driver);
 MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
 MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

