From: Bob Picco <bob.picco@hp.com>
Subject: [PATCH] drivers/scsi/sym53c8xx_2/sym_glue.c
Date: Wed, 27 Apr 2005 15:39:24 -0400
Message-ID: <20050427193924.GT6147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:37847 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S261978AbVD0TlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 15:41:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, bob.picco@hp.com

I believe the attempt not to use 64-bit BARs caused an unintended
result.  The current code disables MMIO for all 64 bit BARs and not just 
those with an address >= 4Gb.

thanks,


bob

Signed-off-by: Bob Picco <bob.picco@hp.com>


Index: linux-memory-less-nodes/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- linux-memory-less-nodes.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-27 14:17:07.000000000 -0400
+++ linux-memory-less-nodes/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-27 14:18:21.000000000 -0400
@@ -155,10 +155,11 @@ pci_get_base_address(struct pci_dev *pde
 	base = tmp;
 	if ((tmp & 0x7) == PCI_BASE_ADDRESS_MEM_TYPE_64) {
 		pci_read_config_dword(pdev, PCI_BAR_OFFSET(index++), &tmp);
-		if (tmp > 0)
+		if (tmp > 0) {
 			dev_err(&pdev->dev,
 				"BAR %d is 64-bit, disabling\n", index - 1);
-		base = 0;
+			base = 0;
+		}
 	}
 
 	if ((base & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
