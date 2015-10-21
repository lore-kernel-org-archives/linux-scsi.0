From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] scsi: wd719x: Use module_pci_driver
Date: Thu, 22 Oct 2015 04:16:21 +0530
Message-ID: <1445467581-26377-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Fida Mohammad <fmthoker@gmail.com>, Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Remove boilerplate code by using macro module_pci_driver.
For drivers whose __init and __exit paths only register and
unregister to the pci API, it is preferred to use this macro.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/scsi/wd719x.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 2a9da2e..6d3bce3 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -976,18 +976,7 @@ static struct pci_driver wd719x_pci_driver = {
 	.remove =	wd719x_pci_remove,
 };
 
-static int __init wd719x_init(void)
-{
-	return pci_register_driver(&wd719x_pci_driver);
-}
-
-static void __exit wd719x_exit(void)
-{
-	pci_unregister_driver(&wd719x_pci_driver);
-}
-
-module_init(wd719x_init);
-module_exit(wd719x_exit);
+module_pci_driver(wd719x_pci_driver);
 
 MODULE_DESCRIPTION("Western Digital WD7193/7197/7296 SCSI driver");
 MODULE_AUTHOR("Ondrej Zary, Aaron Dewell, Juergen Gaertner");
-- 
1.9.1
