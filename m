From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Use an unsigned type for irq number
Date: Tue, 9 Oct 2007 15:36:22 -0600
Message-ID: <20071009213622.GK13842@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44604 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbXJIVgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 17:36:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There are three places in the sym2 driver which print out an interrupt
number; all need to be changed to unsigned

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 74300dd..0f214c0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1189,7 +1189,7 @@ static int sym_host_info(struct Scsi_Host *shost, char *ptr, off_t offset, int l
 	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
 			 "revision id 0x%x\n", np->s.chip_name,
 			 pdev->device, pdev->revision);
-	copy_info(&info, "At PCI address %s, IRQ %d\n",
+	copy_info(&info, "At PCI address %s, IRQ %u\n",
 			 pci_name(pdev), pdev->irq);
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
@@ -1275,7 +1275,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	unsigned long flags;
 	struct sym_fw *fw;
 
-	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq %d\n",
+	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq %u\n",
 		unit, dev->chip.name, pdev->revision, pci_name(pdev),
 		pdev->irq);
 
@@ -1359,7 +1359,7 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	 */
 	if (request_irq(pdev->irq, sym53c8xx_intr, IRQF_SHARED, NAME53C8XX,
 								shost)) {
-		printf_err("%s: request irq %d failure\n",
+		printf_err("%s: request irq %u failure\n",
 			sym_name(np), pdev->irq);
 		goto attach_failed;
 	}

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
