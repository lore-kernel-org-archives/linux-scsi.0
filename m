From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aacraid iomem annotations
Date: Sat, 9 Oct 2004 15:48:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134845.GB20075@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21395 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266867AbUJINst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:48:49 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.24/drivers/scsi/aacraid/aacraid.h	2004-10-01 17:09:07 +02:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-10-09 14:40:37 +02:00
@@ -863,9 +863,9 @@
 	 */
 	union
 	{
-		struct sa_registers *sa;
-		struct rx_registers *rx;
-		struct rkt_registers *rkt;
+		struct sa_registers __iomem *sa;
+		struct rx_registers __iomem *rx;
+		struct rkt_registers __iomem *rkt;
 	} regs;
 	u32			OIMR; /* Mask Register Cache */
 	/*
===== drivers/scsi/aacraid/linit.c 1.41 vs edited =====
--- 1.41/drivers/scsi/aacraid/linit.c	2004-09-27 16:26:57 +02:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-10-09 14:41:05 +02:00
@@ -630,7 +630,7 @@
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	free_irq(pdev->irq, aac);
-	iounmap((void * )aac->regs.sa);
+	iounmap(aac->regs.sa);
  out_free_fibs:
 	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
@@ -659,7 +659,7 @@
 	kfree(aac->queues);
 
 	free_irq(pdev->irq, aac);
-	iounmap((void * )aac->regs.sa);
+	iounmap(aac->regs.sa);
 	
 	kfree(aac->fibs);
 	
===== drivers/scsi/aacraid/rkt.c 1.5 vs edited =====
--- 1.5/drivers/scsi/aacraid/rkt.c	2004-06-22 18:30:27 +02:00
+++ edited/drivers/scsi/aacraid/rkt.c	2004-10-09 14:42:31 +02:00
@@ -405,8 +405,8 @@
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
+	dev->regs.rkt = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192);
+	if (!dev->regs.rkt) {
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
 		goto error_iounmap;
 	}
===== drivers/scsi/aacraid/rx.c 1.10 vs edited =====
--- 1.10/drivers/scsi/aacraid/rx.c	2004-06-22 18:25:43 +02:00
+++ edited/drivers/scsi/aacraid/rx.c	2004-10-09 14:41:47 +02:00
@@ -403,8 +403,8 @@
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-	if((dev->regs.rx = (struct rx_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
+	dev->regs.rx = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192);
+	if (!dev->regs.rx) {
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
 		return -1;
 	}
===== drivers/scsi/aacraid/sa.c 1.11 vs edited =====
--- 1.11/drivers/scsi/aacraid/sa.c	2004-06-18 09:08:24 +02:00
+++ edited/drivers/scsi/aacraid/sa.c	2004-10-09 14:42:10 +02:00
@@ -357,8 +357,8 @@
 	 */
 	dprintk(("PREMAP\n"));
 
-	if((dev->regs.sa = (struct sa_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
-	{	
+	dev->regs.sa = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192);
+	if (!dev->regs.sa) {
 		printk(KERN_WARNING "aacraid: unable to map ARM.\n" );
 		goto error_iounmap;
 	}
