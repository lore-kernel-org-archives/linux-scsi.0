From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym53c8xx 2.1.18b
Date: Thu, 11 Sep 2003 03:33:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911023346.GF21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9604 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263485AbTIKCdr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 22:33:47 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 19xHHG-0006gU-TT
	for linux-scsi@vger.kernel.org; Thu, 11 Sep 2003 03:33:46 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch fixes two bugs in sym 2.1.18.  James, could you apply to your
scsi-misc tree?

 - 40-bit addressing doesn't fit into 32-bits, so PciDmaMask needs
   to be an ULL.
 - Add terminating entries to pci_device_id tables.  Bug spotted by
   Matt Domsch.

Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.30
retrieving revision 1.32
diff -u -p -r1.30 -r1.32
--- drivers/scsi/sym53c8xx_2/sym_glue.c	8 Sep 2003 22:00:25 -0000	1.30
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	11 Sep 2003 00:33:22 -0000	1.32
@@ -1617,7 +1617,7 @@ static int sym_setup_bus_dma_mask(struct
 		goto out_err32;
 #else
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 1
-#define	PciDmaMask	0xffffffffff
+#define	PciDmaMask	0xffffffffffULL
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
 #define	PciDmaMask	0xffffffffffffffffULL
 #endif
@@ -2316,6 +2316,7 @@ static void pqs_remove()
 
 static struct pci_device_id pqs_id_table[] __devinitdata = {
 	{ 0x101a, 0x0009, },
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, pqs_id_table);
@@ -2411,6 +2412,7 @@ static struct pci_device_id sym2_id_tabl
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.12
retrieving revision 1.14
diff -u -p -r1.12 -r1.14
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	9 Sep 2003 01:44:37 -0000	1.12
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	11 Sep 2003 00:33:22 -0000	1.14
@@ -50,7 +50,7 @@
  * SUCH DAMAGE.
  */
 
-#define SYM_DRIVER_NAME	"sym-2.1.18"
+#define SYM_DRIVER_NAME	"sym-2.1.18b"
 
 #ifdef __FreeBSD__
 #include <dev/sym/sym_glue.h>

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
