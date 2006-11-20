From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Sun, 19 Nov 2006 18:53:43 -0800
Message-ID: <20061119185343.e4dde647.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:59484 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S933886AbWKTCzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 21:55:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data: from .text between 'i91u_detect' (at offset 0x26e8) and 'i91uSCBPost'
WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data:i91u_pci_devices from .text between 'i91u_detect' (at offset 0x26ef) and 'i91uSCBPost'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/initio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2619-rc6g2.orig/drivers/scsi/initio.c
+++ linux-2619-rc6g2/drivers/scsi/initio.c
@@ -170,7 +170,7 @@ static int setup_debug = 0;
 static void i91uSCBPost(BYTE * pHcb, BYTE * pScb);
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] __devinitdata = {
+static struct pci_device_id i91u_pci_devices[] = {
 	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},


---
