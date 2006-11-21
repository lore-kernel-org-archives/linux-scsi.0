From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] SCSI: advansys, wrap PCI table inside ifdef CONFIG_PCI
Date: Tue, 21 Nov 2006 13:50:47 -0800
Message-ID: <20061121135047.bbedcff6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:28967 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S966547AbWKUVuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 16:50:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, bobf@advansys.com, akpm <akpm@osdl.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

The Advansys ISA/EISA/PCI driver has a compile error when
CONFIG_PCI=n, so wrap the pci_device_id table inside
ifdef CONFIG_PCI.

drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:18219: error: array type has incomplete element type
drivers/scsi/advansys.c:18221: error: 'PCI_ANY_ID' undeclared here (not in a function)
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/advansys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2619-rc6g4.orig/drivers/scsi/advansys.c
+++ linux-2619-rc6g4/drivers/scsi/advansys.c
@@ -18215,6 +18215,7 @@ AdvInquiryHandling(
 }
 MODULE_LICENSE("Dual BSD/GPL");
 
+#ifdef CONFIG_PCI
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18232,4 +18233,4 @@ static struct pci_device_id advansys_pci
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
-
+#endif /* CONFIG_PCI */


---
