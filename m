From: Anton Blanchard <anton@samba.org>
Subject: sym2 hotplug fix
Date: Thu, 21 Aug 2003 17:37:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821073739.GC29476@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:37591 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262491AbTHUHj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 03:39:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

When testing sym2 hotplug I found a few places where we need to use
__devinit, not __init.

Anton

diff -urN --exclude-from=exclude x/drivers/scsi/sym53c8xx_2/sym_glue.c x_work/drivers/scsi/sym53c8xx_2/sym_glue.c
--- x/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-08-18 13:40:43.000000000 -0500
+++ x_work/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-08-21 02:28:00.000000000 -0500
@@ -57,7 +57,7 @@
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
 
-static int __init
+static int __devinit
 pci_get_base_address(struct pci_dev *pdev, int index, u_long *base)
 {
 	u32 tmp;
@@ -176,7 +176,7 @@
  *  Map/unmap a PCI memory window.
  */
 #ifndef SYM_OPT_NO_BUS_MEMORY_MAPPING
-static u_long __init pci_map_mem(u_long base, u_long size)
+static u_long __devinit pci_map_mem(u_long base, u_long size)
 {
 	u_long page_base	= ((u_long) base) & PAGE_MASK;
 	u_long page_offs	= ((u_long) base) - page_base;
@@ -185,7 +185,7 @@
 	return page_remapped? (page_remapped + page_offs) : 0UL;
 }
 
-static void __init pci_unmap_mem(u_long vaddr, u_long size)
+static void __devinit pci_unmap_mem(u_long vaddr, u_long size)
 {
 	if (vaddr)
 		iounmap((void *) (vaddr & PAGE_MASK));
@@ -1791,7 +1791,7 @@
  *  If all is OK, install interrupt handling and
  *  start the timer daemon.
  */
-static int __init 
+static int __devinit 
 sym_attach (struct scsi_host_template *tpnt, int unit, sym_device *dev)
 {
         struct host_data *host_data;
@@ -2039,7 +2039,7 @@
  *    Detect and try to read SYMBIOS and TEKRAM NVRAM.
  */
 #if SYM_CONF_NVRAM_SUPPORT
-static void __init sym_get_nvram(sym_device *devp, sym_nvram *nvp)
+static void __devinit sym_get_nvram(sym_device *devp, sym_nvram *nvp)
 {
 	if (!nvp)
 		return;
@@ -2269,7 +2269,7 @@
  *  boards and save data for attaching after all boards have 
  *  been detected.
  */
-static int __init
+static int __devinit
 sym53c8xx_pci_init(struct pci_dev *pdev, sym_device *device)
 {
 	u_short vendor_id, device_id, command, status_reg;
