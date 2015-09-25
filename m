From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 3/4] Scsi: dc395x.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 20:38:50 +0530
Message-ID: <1443193731-12587-3-git-send-email-shraddha.6596@gmail.com>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34328 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbbIYPJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 11:09:10 -0400
Received: by padhy16 with SMTP id hy16so108387109pad.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 08:09:10 -0700 (PDT)
In-Reply-To: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.com>, Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org, Shraddha Barke <shraddha.6596@gmail.com>

Use module_pci_driver for drivers whose init and exit functions
only register and unregister respectively

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/scsi/dc395x.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44..a0a6eaf 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4870,30 +4870,7 @@ static struct pci_driver dc395x_driver = {
 	.probe          = dc395x_init_one,
 	.remove         = dc395x_remove_one,
 };
-
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
2.1.4

