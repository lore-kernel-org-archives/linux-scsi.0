From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 1/4] Scsi: am53c974.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 20:38:48 +0530
Message-ID: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35003 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbIYPJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 11:09:14 -0400
Received: by pacfv12 with SMTP id fv12so110200087pac.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 08:09:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.com>, Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org, Shraddha Barke <shraddha.6596@gmail.com>

Use module_pci_driver for drivers whose init and exit functions
only register and unregister respectively

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/scsi/am53c974.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index beea30e..0234b38 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -556,16 +556,6 @@ static struct pci_driver am53c974_driver = {
 	.remove         = pci_esp_remove_one,
 };
 
-static int __init am53c974_module_init(void)
-{
-	return pci_register_driver(&am53c974_driver);
-}
-
-static void __exit am53c974_module_exit(void)
-{
-	pci_unregister_driver(&am53c974_driver);
-}
-
 MODULE_DESCRIPTION("AM53C974 SCSI driver");
 MODULE_AUTHOR("Hannes Reinecke <hare@suse.de>");
 MODULE_LICENSE("GPL");
@@ -577,6 +567,4 @@ MODULE_PARM_DESC(am53c974_debug, "Enable debugging");
 
 module_param(am53c974_fenab, bool, 0444);
 MODULE_PARM_DESC(am53c974_fenab, "Enable 24-bit DMA transfer sizes");
-
-module_init(am53c974_module_init);
-module_exit(am53c974_module_exit);
+module_pci_driver(am53c974_driver);
-- 
2.1.4

