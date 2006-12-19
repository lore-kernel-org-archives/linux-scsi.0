From: akpm@osdl.org
Subject: [patch 19/26] SCSI: advansys, wrap PCI table inside ifdef CONFIG_PCI
Date: Tue, 19 Dec 2006 13:14:53 -0800
Message-ID: <200612192114.kBJLEsL2010733@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbWLSVPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:15:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, randy.dunlap@oracle.com, bobf@advansys.com

From: Randy Dunlap <randy.dunlap@oracle.com>

The Advansys ISA/EISA/PCI driver has a compile error when CONFIG_PCI=n, so
wrap the pci_device_id table inside ifdef CONFIG_PCI.

drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:18219: error: array type has incomplete element type
drivers/scsi/advansys.c:18221: error: 'PCI_ANY_ID' undeclared here (not in a function)
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <bobf@advansys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/advansys.c~scsi-advansys-wrap-pci-table-inside-ifdef-config_pci drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-advansys-wrap-pci-table-inside-ifdef-config_pci
+++ a/drivers/scsi/advansys.c
@@ -18133,6 +18133,7 @@ AdvInquiryHandling(
 }
 MODULE_LICENSE("Dual BSD/GPL");
 
+#ifdef CONFIG_PCI
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18150,4 +18151,4 @@ static struct pci_device_id advansys_pci
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
-
+#endif /* CONFIG_PCI */
_
