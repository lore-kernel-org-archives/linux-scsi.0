From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove internal queueing from inia100
Date: Sun, 12 Sep 2004 18:16:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040912161649.GA4519@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20145 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268487AbUILQQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2004 12:16:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

The driver had some trivial internal queueing for srb allocation failure
in ->queuecommand that can be done at the midlayer easily.


--- 1.27/drivers/scsi/inia100.c	2004-01-02 05:15:03 +01:00
+++ edited/drivers/scsi/inia100.c	2004-09-12 16:07:15 +02:00
@@ -117,50 +117,6 @@
 extern int init_orchid(ORC_HCS * hcsp);
 
 /*****************************************************************************
- Function name  : inia100AppendSRBToQueue
- Description    : This function will push current request into save list
- Input          : pSRB  -       Pointer to SCSI request block.
-		  pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : None.
-*****************************************************************************/
-static void inia100AppendSRBToQueue(ORC_HCS * pHCB, struct scsi_cmnd * pSRB)
-{
-	ULONG flags;
-
-	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
-
-	pSRB->SCp.ptr = NULL;	/* Pointer to next */
-	if (pHCB->pSRB_head == NULL)
-		pHCB->pSRB_head = pSRB;
-	else
-		pHCB->pSRB_tail->SCp.ptr = (char *)pSRB;	/* Pointer to next */
-	pHCB->pSRB_tail = pSRB;
-	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
-	return;
-}
-
-/*****************************************************************************
- Function name  : inia100PopSRBFromQueue
- Description    : This function will pop current request from save list
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-static struct scsi_cmnd *inia100PopSRBFromQueue(ORC_HCS * pHCB)
-{
-	struct scsi_cmnd *pSRB;
-	ULONG flags;
-	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
-	if ((pSRB = (struct scsi_cmnd *) pHCB->pSRB_head) != NULL) {
-		pHCB->pSRB_head = (struct scsi_cmnd *) pHCB->pSRB_head->SCp.ptr;
-		pSRB->SCp.ptr = NULL;
-	}
-	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
-	return (pSRB);
-}
-
-/*****************************************************************************
  Function name  : inia100BuildSCB
  Description    : 
  Input          : pHCB  -       Pointer to host adapter structure
@@ -248,11 +204,9 @@
 	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
 	SCpnt->scsi_done = done;
 	/* Get free SCSI control block  */
-	if ((pSCB = orc_alloc_scb(pHCB)) == NULL) {
-		inia100AppendSRBToQueue(pHCB, SCpnt);	/* Buffer this request  */
-		/* printk("inia100_entry: can't allocate SCB\n"); */
-		return (0);
-	}
+	if ((pSCB = orc_alloc_scb(pHCB)) == NULL)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	inia100BuildSCB(pHCB, pSCB, SCpnt);
 	orc_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
 
@@ -374,14 +328,7 @@
 	orc_release_dma(pHCB, pSRB);  /* release DMA before we call scsi_done */
 	pSRB->scsi_done(pSRB);	/* Notify system DONE           */
 
-	/* Find the next pending SRB    */
-	if ((pSRB = inia100PopSRBFromQueue(pHCB)) != NULL) {	/* Assume resend will success   */
-		inia100BuildSCB(pHCB, pSCB, pSRB);	/* Create corresponding SCB     */
-		orc_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
-	} else {
-		orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
-	}
-	return;
+	orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 }
 
 /*
@@ -453,9 +400,6 @@
 	pHCB->pdev = pdev;
 	pHCB->HCS_Base = port;
 	pHCB->HCS_BIOS = bios;
-	pHCB->pSRB_head = NULL;	/* Initial SRB save queue       */
-	pHCB->pSRB_tail = NULL;	/* Initial SRB save queue       */
-	pHCB->pSRB_lock = SPIN_LOCK_UNLOCKED; /* SRB save queue lock */
 	pHCB->BitAllocFlagLock = SPIN_LOCK_UNLOCKED;
 
 	/* Get total memory needed for SCB */
--- 1.17/drivers/scsi/inia100.h	2003-11-18 10:18:52 +01:00
+++ edited/drivers/scsi/inia100.h	2004-09-12 16:07:23 +02:00
@@ -330,9 +330,6 @@
 	ORC_TCS HCS_Tcs[16];	/* 28 */
 	U32 BitAllocFlag[MAX_CHANNELS][8];	/* Max STB is 256, So 256/32 */
 	spinlock_t BitAllocFlagLock;
-	struct scsi_cmnd *pSRB_head;
-	struct scsi_cmnd *pSRB_tail;
-	spinlock_t pSRB_lock;
 	struct pci_dev *pdev;
 } ORC_HCS;
 
