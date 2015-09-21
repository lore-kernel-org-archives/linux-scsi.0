From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Scsi: Use module_pci_driver
Date: Mon, 21 Sep 2015 20:47:40 +0530
Message-ID: <1442848660-10288-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Shraddha Barke <shraddha.6596@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use module_pci_driver for drivers whose init and exit functions
only register and unregister

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/scsi/initio.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 6a926ba..ea12a66 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2994,19 +2994,7 @@ static struct pci_driver initio_pci_driver = {
 	.remove		= initio_remove_one,
 };
 
-static int __init initio_init_driver(void)
-{
-	return pci_register_driver(&initio_pci_driver);
-}
-
-static void __exit initio_exit_driver(void)
-{
-	pci_unregister_driver(&initio_pci_driver);
-}
-
 MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("GPL");
-
-module_init(initio_init_driver);
-module_exit(initio_exit_driver);
+module_pci_driver(initio_pci_driver);
-- 
2.1.4
