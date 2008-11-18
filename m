From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] cciss: fix DEBUG printk formats
Date: Tue, 18 Nov 2008 11:55:14 -0800
Message-ID: <49231DA2.3070502@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:37782 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752319AbYKRUF0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 15:05:26 -0500
Received: from ::ffff:24.21.38.27 ([24.21.38.27]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2008 11:55:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, iss_storagedev@hp.com, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings when CCISS_DEBUG is defined.

drivers/block/cciss.c:2856: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3205: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3236: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'
drivers/block/cciss.c:3246: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

Mike, I have hit the oops in do_cciss_intr() 4 times today.
I'll try to track it down.  Please let me know if you have suggestions
for debugging.


 drivers/block/cciss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- lin2628-rc5.orig/drivers/block/cciss.c
+++ lin2628-rc5/drivers/block/cciss.c
@@ -2852,7 +2852,7 @@ static void do_cciss_request(struct requ
 		h->maxSG = seg;
 
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %d sectors in %d segments\n",
+	printk(KERN_DEBUG "cciss: Submitting %lu sectors in %d segments\n",
 	       creq->nr_sectors, seg);
 #endif				/* CCISS_DEBUG */
 
@@ -3202,7 +3202,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
-	printk("address 0 = %x\n", c->paddr);
+	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 	if (!c->vaddr) {
@@ -3233,7 +3233,8 @@ static int __devinit cciss_pci_init(ctlr
 #endif				/* CCISS_DEBUG */
 	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
 #ifdef CCISS_DEBUG
-	printk("cfg base address index = %x\n", cfg_base_addr_index);
+	printk("cfg base address index = %llx\n",
+		(unsigned long long)cfg_base_addr_index);
 #endif				/* CCISS_DEBUG */
 	if (cfg_base_addr_index == -1) {
 		printk(KERN_WARNING "cciss: Cannot find cfg_base_addr_index\n");
@@ -3243,7 +3244,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
 #ifdef CCISS_DEBUG
-	printk("cfg offset = %x\n", cfg_offset);
+	printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
 #endif				/* CCISS_DEBUG */
 	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
 						       cfg_base_addr_index) +
