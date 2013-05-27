From: Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 02/24] drivers/scsi/dc395x: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:46:29 +0800
Message-ID: <1369622789-7876-1-git-send-email-libo.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:36370 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3E0CrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 22:47:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, JBottomley@parallels.com
Cc: dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com, gregkh@linuxfoundation.org

use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/dc395x.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
old mode 100644
new mode 100755
index 694e13c..e73445b
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4882,29 +4882,7 @@ static struct pci_driver dc395x_driver = {
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
+module_pci_driver(dc395x_driver);
 
 MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
 MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
-- 
1.7.1


