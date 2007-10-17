From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 12:22:11 -0400
Message-ID: <471636B3.10907@cybernetics.com>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com> <20071017152019.GA1871@1wt.eu> <47162DC8.5050700@cybernetics.com> <20071017155256.GA2820@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:3470 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935274AbXJQQWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 12:22:09 -0400
In-Reply-To: <20071017155256.GA2820@1wt.eu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

This patch fixes two problems with sym53c8xx_2.o in 2.4.x kernels:

1) A system hang when loading sym53c8xx_2.o on a SMP system with two
dual-channel LSI HBAs (http://bugzilla.kernel.org/show_bug.cgi?id=3680)

2) A function improperly marked __init.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.4.35/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2007-10-17 12:07:37.000000000 -0400
+++ linux-2.4.35/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-17 12:08:32.000000000 -0400
@@ -224,15 +224,26 @@ static u_long __init pci_map_mem(u_long 
 {
 	u_long page_base	= ((u_long) base) & PAGE_MASK;
 	u_long page_offs	= ((u_long) base) - page_base;
-	u_long page_remapped	= (u_long) ioremap(page_base, page_offs+size);
+	u_long page_remapped;
+
+	spin_unlock_irq(&io_request_lock);
+	page_remapped = (u_long) ioremap(page_base, page_offs+size);
+	spin_lock_irq(&io_request_lock);
 
 	return page_remapped? (page_remapped + page_offs) : 0UL;
 }
 
-static void __init pci_unmap_mem(u_long vaddr, u_long size)
-{
-	if (vaddr)
+static void pci_unmap_mem(u_long vaddr,
+                          u_long size,
+                          int holding_io_request_lock)
+{
+	if (vaddr) {
+		if (holding_io_request_lock)
+			spin_unlock_irq(&io_request_lock);
 		iounmap((void *) (vaddr & PAGE_MASK));
+		if (holding_io_request_lock)
+			spin_lock_irq(&io_request_lock);
+	}
 }
 #endif
 
@@ -1840,7 +1851,7 @@ static int sym53c8xx_proc_info(char *buf
 /*
  *	Free controller resources.
  */
-static void sym_free_resources(hcb_p np)
+static void sym_free_resources(hcb_p np, int holding_io_request_lock)
 {
 	/*
 	 *  Free O/S specific resources.
@@ -1851,9 +1862,13 @@ static void sym_free_resources(hcb_p np)
 		release_region(np->s.io_port, np->s.io_ws);
 #ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
 	if (np->s.mmio_va)
-		pci_unmap_mem(np->s.mmio_va, np->s.io_ws);
+		pci_unmap_mem(np->s.mmio_va,
+		              np->s.io_ws,
+		              holding_io_request_lock);
 	if (np->s.ram_va)
-		pci_unmap_mem(np->s.ram_va, np->ram_ws);
+		pci_unmap_mem(np->s.ram_va,
+		              np->ram_ws,
+		              holding_io_request_lock);
 #endif
 	/*
 	 *  Free O/S independant resources.
@@ -2155,7 +2170,7 @@ attach_failed:
 	if (!instance) return -1;
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
-		sym_free_resources(np);
+		sym_free_resources(np, 1);
 	scsi_unregister(instance);
 
         return -1;
@@ -2197,7 +2212,7 @@ static void __init sym_get_nvram(sym_dev
 #ifdef SYM_CONF_IOMAPPED
 	release_region(devp->s.io_port, 128);
 #else
-	pci_unmap_mem((u_long) devp->s.mmio_va, 128ul);
+	pci_unmap_mem((u_long) devp->s.mmio_va, 128ul, 1);
 #endif
 }
 #endif	/* SYM_CONF_NVRAM_SUPPORT */
@@ -2551,7 +2566,7 @@ sym53c8xx_pci_init(Scsi_Host_Template *t
 		ram_ptr = pci_map_mem(base_2_c, ram_size);
 		if (ram_ptr) {
 			ram_val = readl_raw(ram_ptr + ram_size - 16);
-			pci_unmap_mem(ram_ptr, ram_size);
+			pci_unmap_mem(ram_ptr, ram_size, 1);
 			if (ram_val == 0x52414944) {
 				printf_info("%s: not initializing, "
 				            "driven by RAID controller.\n",
@@ -2980,7 +2995,7 @@ static int sym_detach(hcb_p np)
 	/*
 	 *  Free host resources
 	 */
-	sym_free_resources(np);
+	sym_free_resources(np, 0);
 
 	return 1;
 }


