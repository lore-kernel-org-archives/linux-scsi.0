From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] aacraid iomem annotations
Date: Fri, 22 Oct 2004 00:53:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021235351.GF24336@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49861 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271123AbUJUXxx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 19:53:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/aacraid.h RC9-bk4-aacraid/drivers/scsi/aacraid/aacraid.h
--- RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/aacraid.h	Wed Oct 20 10:56:02 2004
+++ RC9-bk4-aacraid/drivers/scsi/aacraid/aacraid.h	Wed Oct 20 13:46:08 2004
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
diff -urN RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/linit.c RC9-bk4-aacraid/drivers/scsi/aacraid/linit.c
--- RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/linit.c	Wed Oct 20 10:56:02 2004
+++ RC9-bk4-aacraid/drivers/scsi/aacraid/linit.c	Wed Oct 20 13:46:09 2004
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
 	
diff -urN RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/rkt.c RC9-bk4-aacraid/drivers/scsi/aacraid/rkt.c
--- RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/rkt.c	Sat Aug 14 03:46:23 2004
+++ RC9-bk4-aacraid/drivers/scsi/aacraid/rkt.c	Wed Oct 20 13:46:11 2004
@@ -405,7 +405,7 @@
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
+	if((dev->regs.rkt = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
 		goto error_iounmap;
diff -urN RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/rx.c RC9-bk4-aacraid/drivers/scsi/aacraid/rx.c
--- RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/rx.c	Sat Aug 14 03:46:23 2004
+++ RC9-bk4-aacraid/drivers/scsi/aacraid/rx.c	Wed Oct 20 13:46:13 2004
@@ -403,7 +403,7 @@
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-	if((dev->regs.rx = (struct rx_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
+	if((dev->regs.rx = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
 		return -1;
diff -urN RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/sa.c RC9-bk4-aacraid/drivers/scsi/aacraid/sa.c
--- RC9-bk4-ppc-uaccess/drivers/scsi/aacraid/sa.c	Sat Aug 14 03:46:23 2004
+++ RC9-bk4-aacraid/drivers/scsi/aacraid/sa.c	Wed Oct 20 13:46:15 2004
@@ -357,7 +357,7 @@
 	 */
 	dprintk(("PREMAP\n"));
 
-	if((dev->regs.sa = (struct sa_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
+	if((dev->regs.sa = ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map ARM.\n" );
 		goto error_iounmap;
