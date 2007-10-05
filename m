From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 14/17] sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
Date: Fri,  5 Oct 2007 15:55:11 -0400
Message-ID: <11916141153666-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:47899 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761371AbXJETzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:22 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

These macros aren't needed any more.  They used to be used for SPARC.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e731618..a82ed13 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -54,9 +54,6 @@
 #define NAME53C		"sym53c"
 #define NAME53C8XX	"sym53c8xx"
 
-#define IRQ_FMT "%d"
-#define IRQ_PRM(x) (x)
-
 struct sym_driver_setup sym_driver_setup = SYM_LINUX_DRIVER_SETUP;
 unsigned int sym_debug_flags = 0;
 
@@ -1196,8 +1193,8 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n", np->s.chip_name,
 			 np->s.device->device, np->s.device->revision);
-	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
-		pci_name(np->s.device), IRQ_PRM(np->s.device->irq));
+	copy_info(&info, "At PCI address %s, IRQ %d\n",
+			 pci_name(np->s.device), np->s.device->irq);
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
 			 np->maxwide ? "Wide" : "Narrow",
@@ -1283,9 +1280,9 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	unsigned long flags;
 	struct sym_fw *fw;
 
-	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq " IRQ_FMT "\n",
+	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq %d\n",
 		unit, dev->chip.name, pdev->revision, pci_name(pdev),
-		IRQ_PRM(pdev->irq));
+		pdev->irq);
 
 	/*
 	 *  Get the firmware for this chip.
-- 
1.4.4.2

