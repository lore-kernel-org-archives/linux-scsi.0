From: Anton Blanchard <anton@samba.org>
Subject: Re: Make sym2 driver use pci_enable_device
Date: Wed, 16 Apr 2003 01:41:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030415154159.GG2067@krispykreme>
References: <20030414233239.GD2067@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:5048 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261675AbTDOPcG
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 11:32:06 -0400
Content-Disposition: inline
In-Reply-To: <20030414233239.GD2067@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: groudier@free.fr


> The sym2 driver should use the generic pci_enable_device() and
> pci_set_master() functions.

Sorry, wrong patch. We need to read COMMAND after doing
pci_enable_device/pci_set_master. We should also check the return
valie of pci_enable_device.

Anton

===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.16 vs edited =====
--- 1.16/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Feb 20 23:16:32 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Tue Apr 15 08:51:04 2003
@@ -2556,35 +2556,17 @@
 	bcopy(chip, &device->chip, sizeof(device->chip));
 	device->chip.revision_id = revision;
 
+	if (pci_enable_device(pdev))
+		return -1;
+
+	pci_set_master(pdev);
+
 	/*
 	 *  Read additionnal info from the configuration space.
 	 */
-	pci_read_config_word(pdev, PCI_COMMAND,		&command);
 	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE,	&cache_line_size);
 
 	/*
-	 * Enable missing capabilities in the PCI COMMAND register.
-	 */
-#ifdef SYM_CONF_IOMAPPED
-#define	PCI_COMMAND_BITS_TO_ENABLE (PCI_COMMAND_IO | \
-	PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER | PCI_COMMAND_PARITY)
-#else
-#define	PCI_COMMAND_BITS_TO_ENABLE \
-	(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER | PCI_COMMAND_PARITY)
-#endif
-	if ((command & PCI_COMMAND_BITS_TO_ENABLE)
-		    != PCI_COMMAND_BITS_TO_ENABLE) {
-		printf_info("%s: setting%s%s%s%s...\n", sym_name(device),
-		(command & PCI_COMMAND_IO)     ? "" : " PCI_COMMAND_IO",
-		(command & PCI_COMMAND_MEMORY) ? "" : " PCI_COMMAND_MEMORY",
-		(command & PCI_COMMAND_MASTER) ? "" : " PCI_COMMAND_MASTER",
-		(command & PCI_COMMAND_PARITY) ? "" : " PCI_COMMAND_PARITY");
-		command |= PCI_COMMAND_BITS_TO_ENABLE;
-		pci_write_config_word(pdev, PCI_COMMAND, command);
-	}
-#undef	PCI_COMMAND_BITS_TO_ENABLE
-
-	/*
 	 *  If cache line size is not configured, suggest
 	 *  a value for well known CPUs.
 	 */
@@ -2623,6 +2605,7 @@
 		            sym_name(device), cache_line_size);
 	}
 
+	pci_read_config_word(pdev, PCI_COMMAND,	&command);
 	if ((pci_fix_up & 2) && cache_line_size &&
 	    (chip->features & FE_WRIE) && !(command & PCI_COMMAND_INVALIDATE)) {
 		printf_info("%s: setting PCI_COMMAND_INVALIDATE.\n",
