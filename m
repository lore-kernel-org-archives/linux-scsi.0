From: Anton Blanchard <anton@samba.org>
Subject: Make sym2 driver use pci_enable_device
Date: Tue, 15 Apr 2003 09:32:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414233239.GD2067@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:22422 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263924AbTDNXZE (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 19:25:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: groudier@free.fr


Hi,

The sym2 driver should use the generic pci_enable_device() and
pci_set_master() functions.

The next step is to use pci_enable_mwi(), however that needs some more
thought. The current code warns of chip bugs requiring MWI to be enabled.
If this is so we should use the generic MWI hook and if that returns an
error we should warn or fail to load. The driver should not be guessing:

#if defined(__i386__) && !defined(MODULE)
        if (!cache_line_size && boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
                switch(boot_cpu_data.x86) {
                case 4: suggested_cache_line_size = 4;   break;
                case 6: if (boot_cpu_data.x86_model > 8) break;
                case 5: suggested_cache_line_size = 8;   break;
                }
        }
#endif  /* __i386__ */

Anton

===== sym_glue.c 1.16 vs edited =====
--- 1.16/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Feb 20 23:16:32 2003
+++ edited/sym_glue.c	Tue Apr 15 07:06:05 2003
@@ -2562,41 +2561,8 @@
 	pci_read_config_word(pdev, PCI_COMMAND,		&command);
 	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE,	&cache_line_size);
 
-	/*
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
-	 *  If cache line size is not configured, suggest
-	 *  a value for well known CPUs.
-	 */
-#if defined(__i386__) && !defined(MODULE)
-	if (!cache_line_size && boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
-		switch(boot_cpu_data.x86) {
-		case 4:	suggested_cache_line_size = 4;   break;
-		case 6: if (boot_cpu_data.x86_model > 8) break;
-		case 5:	suggested_cache_line_size = 8;   break;
-		}
-	}
-#endif	/* __i386__ */
+	pci_enable_device(pdev);
+	pci_set_master(pdev);
 
 	/*
 	 *  Some features are required to be enabled in order to 
