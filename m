From: Grant Grundler <grundler@parisc-linux.org>
Subject: PATCH 2.6.18-rc1 SYM2 claim only "Storage" class
Date: Mon, 17 Jul 2006 07:22:45 -0600
Message-ID: <20060717132245.GA2771@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:25272 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S1750704AbWGQNWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jul 2006 09:22:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: willy@parisc-linux.org
Cc: linux-scsi@vger.kernel.org

Willy,
The follow patch fixes a problem for Matt Taggart.
The Compaq system he had (dl380?) has a SmartArray device that exposes
the 53c1510 device in both RAID and "normal" modes. The difference
is in RAID mode, the smart array driver (IIRC) should claim the
device instead of sym2 driver. Patch below prevents sym2 from
claiming the device when the RAID "daughter board" is attached.

thanks,
grant

ps. I may have submitted this before but I didn't see it in -rc1

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

--- linux-2.6.18-rc1/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ ggg/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2083,7 +2083,7 @@ static struct pci_device_id sym2_id_tabl
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895,
