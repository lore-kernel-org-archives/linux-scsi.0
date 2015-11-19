From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RESEND 2] SCSI: initio: remove duplicate module device table
Date: Thu, 19 Nov 2015 15:33:41 +0100
Message-ID: <5318263.D61echQrl2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

The initio driver has for many years had two copies of the
same module device table. One of them is also used for registering
the other driver, the other one is entirely useless after the
large scale cleanup that Alan Cox did back in 2007.

The compiler warns about this whenever the driver is built-in:

drivers/scsi/initio.c:131:29: warning: 'i91u_pci_devices' defined but not used [-Wunused-variable]

This removes the extraneous table and the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 72d39fea901 ("[SCSI] initio: Convert into a real Linux driver and update to modern style")
---
I sent this patch originally in January 2015, then again in May, but got no
reply. Please apply.

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 6a926bae76b2..7a91cf3ff173 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -110,11 +110,6 @@
 #define i91u_MAXQUEUE		2
 #define i91u_REVID "Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a"
 
-#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
-#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
-#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
-#define I920_DEVICE_ID	0x0002	/* Initio's other product ID      */
-
 #ifdef DEBUG_i91u
 static unsigned int i91u_debug = DEBUG_DEFAULT;
 #endif
@@ -127,17 +122,6 @@ static int setup_debug = 0;
 
 static void i91uSCBPost(u8 * pHcb, u8 * pScb);
 
-/* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] = {
-	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
-
 #define DEBUG_INTERRUPT 0
 #define DEBUG_QUEUE     0
 #define DEBUG_STATE     0
