From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 3/7] sym53c8xx: fix bogus free_irq() on error path
Date: Thu, 08 Jan 2009 12:54:45 -0500
Message-ID: <49663DE5.2010909@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:2630 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZAHRyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:54:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

If sym_attach() gets an error at or before request_irq(), then
sym_free_resources() will call free_irq() for an unregistered
interrupt handler.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-07 17:32:33.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-07 17:35:27.000000000 -0500
@@ -1238,12 +1238,13 @@ static int sym53c8xx_proc_info(struct Sc
 /*
  *	Free controller resources.
  */
-static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev)
+static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev,
+		int do_free_irq)
 {
 	/*
 	 *  Free O/S specific resources.
 	 */
-	if (pdev->irq)
+	if (do_free_irq)
 		free_irq(pdev->irq, np->s.host);
 	if (np->s.ioaddr)
 		pci_iounmap(pdev, np->s.ioaddr);
@@ -1275,6 +1276,7 @@ static struct Scsi_Host * __devinit sym_
 	struct pci_dev *pdev = dev->pdev;
 	unsigned long flags;
 	struct sym_fw *fw;
+	int do_free_irq = 0;
 
 	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq %u\n",
 		unit, dev->chip.name, pdev->revision, pci_name(pdev),
@@ -1364,6 +1366,7 @@ static struct Scsi_Host * __devinit sym_
 			sym_name(np), pdev->irq);
 		goto attach_failed;
 	}
+	do_free_irq = 1;
 
 	/*
 	 *  After SCSI devices have been opened, we cannot
@@ -1420,7 +1423,7 @@ static struct Scsi_Host * __devinit sym_
 		return NULL;
 	printf_info("sym%d: giving up ...\n", unit);
 	if (np)
-		sym_free_resources(np, pdev);
+		sym_free_resources(np, pdev, do_free_irq);
 	scsi_host_put(shost);
 
 	return NULL;
@@ -1659,7 +1662,7 @@ static int sym_detach(struct Scsi_Host *
 	udelay(10);
 	OUTB(np, nc_istat, 0);
 
-	sym_free_resources(np, pdev);
+	sym_free_resources(np, pdev, 1);
 	scsi_host_put(shost);
 
 	return 1;


