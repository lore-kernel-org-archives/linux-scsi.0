From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix up ini9100 interrupt handling
Date: Fri, 6 Feb 2004 16:59:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206155922.GA4786@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:3269 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265533AbUBFP71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 10:59:27 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Currently is has a different irq handler for every "supported" chip.
Make use of the private data passed to request_irq instead.


--- 1.20/drivers/scsi/ini9100u.c	Tue Dec 23 00:28:28 2003
+++ edited/drivers/scsi/ini9100u.c	Wed Feb  4 05:38:11 2004
@@ -272,6 +272,17 @@
 	return (pSRB);
 }
 
+static irqreturn_t i91u_intr(int irqno, void *dev_id, struct pt_regs *regs)
+{
+	struct Scsi_Host *dev = dev_id;
+	unsigned long flags;
+	
+	spin_lock_irqsave(dev->host_lock, flags);
+	tul_isr((HCS *)hreg->base);
+	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
+}
+
 /* called from init/main.c */
 
 void i91u_setup(char *str, int *ints)
@@ -396,8 +407,7 @@
 
 		pHCB->HCS_Index = i;	/* 7/29/98 */
 		hreg = scsi_register(tpnt, sizeof(HCS));
-		if(hreg == NULL)
-		{
+		if(hreg == NULL) {
 			release_region(pHCB->HCS_Base, 256);
 			return 0;
 		}
@@ -413,48 +423,10 @@
 		hreg->sg_tablesize = TOTAL_SG_ENTRY;	/* Maximun support is 32 */
 
 		/* Initial tulip chip           */
-		switch (i) {
-		case 0:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr0, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 1:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr1, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 2:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr2, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 3:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr3, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 4:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr4, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 5:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr5, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 6:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr6, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		case 7:
-			ok = request_irq(pHCB->HCS_Intr, i91u_intr7, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
-			break;
-		default:
-			i91u_panic("i91u: Too many host adapters\n");
-			break;
-		}
+		ok = request_irq(pHCB->HCS_Intr, i91u_intr, SA_INTERRUPT | SA_SHIRQ, "i91u", hreg);
 		if (ok < 0) {
-			if (ok == -EINVAL) {
-				printk("i91u: bad IRQ %d.\n", pHCB->HCS_Intr);
-				printk("         Contact author.\n");
-			} else if (ok == -EBUSY)
-				printk("i91u: IRQ %d already in use. Configure another.\n",
-				       pHCB->HCS_Intr);
-			else {
-				printk("\ni91u: Unexpected error code on requesting IRQ %d.\n",
-				       pHCB->HCS_Intr);
-				printk("         Contact author.\n");
-			}
-			i91u_panic("i91u: driver needs an IRQ.\n");
+			printk(KERN_WARNING "i91u: unable to request IRQ %d\n\n", pHCB->HCS_Intr);
+			return 0;
 		}
 	}
 
@@ -729,137 +701,6 @@
 		tul_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 	}
 	return;
-}
-
-/*
- * Interrupts handler (main routine of the driver)
- */
-static irqreturn_t i91u_intr0(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[0].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[0]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr1(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[1].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[1]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr2(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[2].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[2]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr3(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[3].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[3]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr4(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[4].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[4]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr5(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[5].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[5]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-	
-static irqreturn_t i91u_intr6(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[6].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[6]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t i91u_intr7(int irqno, void *dev_id, struct pt_regs *regs)
-{
-	unsigned long flags;
-	struct Scsi_Host *dev = dev_id;
-	
-	if (tul_hcs[7].HCS_Intr != irqno)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(dev->host_lock, flags);
-
-	tul_isr(&tul_hcs[7]);
-
-	spin_unlock_irqrestore(dev->host_lock, flags);
-	return IRQ_HANDLED;
 }
 
 /* 
