From: Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 5/6] scsi/initio: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:20 +0200
Message-ID: <1369172181-22070-5-git-send-email-peterhuewe@gmx.de>
References: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/initio.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 280d5af..23e1b7d 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2995,19 +2995,7 @@ static struct pci_driver initio_pci_driver = {
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
+module_pci_driver(initio_pci_driver);
 MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("GPL");
-
-module_init(initio_init_driver);
-module_exit(initio_exit_driver);
-- 
1.8.1.5
