From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tmscsim: remove superflous global host list
Date: Wed, 29 Sep 2004 15:13:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929131302.GA27928@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47311 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268372AbUI2NNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 09:13:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's only used to "verify" the host pointer in the interrupt handler,
which better had to be correct or else 90% of the drivers would break.


--- 1.20/drivers/scsi/scsiiom.c	2004-08-17 19:56:00 +02:00
+++ edited/drivers/scsi/scsiiom.c	2004-09-28 16:43:25 +02:00
@@ -225,7 +225,7 @@
 static irqreturn_t __inline__
 DC390_Interrupt(int irq, void *dev_id, struct pt_regs *regs)
 {
-    struct dc390_acb *pACB, *pACB2;
+    struct dc390_acb *pACB = (struct dc390_acb*)dev_id;
     struct dc390_dcb *pDCB;
     struct dc390_srb *pSRB;
     u8  sstatus=0;
@@ -236,14 +236,6 @@
     u8  dstatus;
 #endif
 
-    pACB = (struct dc390_acb*)dev_id;
-    for (pACB2 = dc390_pACB_start; (pACB2 && pACB2 != pACB); pACB2 = pACB2->pNextACB);
-    if (!pACB2)
-    {
-	printk ("DC390: IRQ called with foreign dev_id %p!\n", pACB);
-	return IRQ_NONE;
-    }
-    
     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
 	return IRQ_NONE;
--- 1.52/drivers/scsi/tmscsim.c	2004-08-18 00:51:27 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-09-28 17:20:15 +02:00
@@ -279,8 +279,6 @@
 
 static void   dc390_updateDCB (struct dc390_acb* pACB, struct dc390_dcb* pDCB);
 
-static struct dc390_acb*	dc390_pACB_start= NULL;
-static struct dc390_acb*	dc390_pACB_current = NULL;
 static u32	dc390_laststatus = 0;
 static u8	dc390_adapterCnt = 0;
 
@@ -1202,7 +1200,7 @@
 static int __devinit dc390_probe_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
-	struct dc390_acb *pACB, *pACB2;
+	struct dc390_acb *pACB;
 	struct Scsi_Host *shost;
 	unsigned long io_port;
 	int error = -ENODEV, i;
@@ -1279,18 +1277,6 @@
 				"tmscsim", pACB)) {
 		printk(KERN_ERR "DC390: register IRQ error!\n");
 		goto out_release_region;
-	}
-
-	if (!dc390_pACB_start) {
-		pACB2 = NULL;
-		dc390_pACB_start = pACB;
-		dc390_pACB_current = pACB;
-		pACB->pNextACB = NULL;
-	} else {
-		pACB2 = dc390_pACB_current;
-		dc390_pACB_current->pNextACB = pACB;
-		dc390_pACB_current = pACB;
-		pACB->pNextACB = NULL;
 	}
 
 	dc390_init_hw(pACB, dc390_adapterCnt);
--- 1.9/drivers/scsi/tmscsim.h	2004-08-17 19:56:00 +02:00
+++ edited/drivers/scsi/tmscsim.h	2004-09-28 17:25:03 +02:00
@@ -140,7 +140,6 @@
 struct dc390_acb
 {
 struct Scsi_Host *pScsiHost;
-struct dc390_acb	*pNextACB;
 u16		IOPortBase;
 u8		IRQLevel;
 u8		status;
