From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] scsi: a100u2w: use module_pci_driver
Date: Wed, 16 Nov 2016 21:00:57 +0800
Message-ID: <42d7656b1c64b458b59eb55f32aed3c53ff1bc0d.1479278712.git.geliangtang@gmail.com>
References: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use module_pci_driver() helper to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/scsi/a100u2w.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 8086bd0..b2942ec 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1222,19 +1222,8 @@ static struct pci_driver inia100_pci_driver = {
 	.remove		= inia100_remove_one,
 };
 
-static int __init inia100_init(void)
-{
-	return pci_register_driver(&inia100_pci_driver);
-}
-
-static void __exit inia100_exit(void)
-{
-	pci_unregister_driver(&inia100_pci_driver);
-}
+module_pci_driver(inia100_pci_driver);
 
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-
-module_init(inia100_init);
-module_exit(inia100_exit);
-- 
2.9.3
