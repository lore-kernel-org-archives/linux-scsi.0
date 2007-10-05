From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/17] sym53c8xx: Use pci_dev irq number
Date: Fri,  5 Oct 2007 15:54:59 -0400
Message-ID: <11916141142823-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:54609 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Don't cache a private copy of the interrupt number

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    7 +++----
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d5455e3..11e0a28 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1288,7 +1288,7 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
 			 "revision id 0x%x\n",
 			 np->s.chip_name, np->device_id, np->revision_id);
 	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
-		pci_name(np->s.device), IRQ_PRM(np->s.irq));
+		pci_name(np->s.device), IRQ_PRM(np->s.device->irq));
 	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
 			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
 			 np->maxwide ? "Wide" : "Narrow",
@@ -1341,8 +1341,8 @@ static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev)
 	/*
 	 *  Free O/S specific resources.
 	 */
-	if (np->s.irq)
-		free_irq(np->s.irq, np);
+	if (pdev->irq)
+		free_irq(pdev->irq, np);
 	if (np->s.ioaddr)
 		pci_iounmap(pdev, np->s.ioaddr);
 	if (np->s.ramaddr)
@@ -1491,7 +1491,6 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 			sym_name(np), pdev->irq);
 		goto attach_failed;
 	}
-	np->s.irq = pdev->irq;
 
 	/*
 	 *  After SCSI devices have been opened, we cannot
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index 0f097ba..bea7bcc 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -184,7 +184,6 @@ struct sym_shcb {
 	void __iomem *	ioaddr;		/* MMIO kernel io address	*/
 	void __iomem *	ramaddr;	/* RAM  kernel io address	*/
 	u_short		io_ws;		/* IO window size		*/
-	int		irq;		/* IRQ number			*/
 
 	struct timer_list timer;	/* Timer handler link header	*/
 	u_long		lasttime;
-- 
1.4.4.2

