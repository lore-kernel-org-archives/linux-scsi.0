From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] tmscsim: fix spinlock usage in isr
Date: Fri,  7 Nov 2014 13:49:44 +0100
Message-ID: <1415364584-28951-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaKGMtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 07:49:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Loading the tmscsim driver would result in kernel splat as
the interrupt service routine would only use spin_lock_irq,
not spin_lock_irqsave.
And while we're at it there is not need to release the
spin lock when calling udelay; it's implemented via a
processor counter, not via interrupts.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/tmscsim.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 7645757..2aecd2c 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -654,6 +654,7 @@ DC390_Interrupt(void *dev_id)
     u8  phase;
     void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
     u8  istate, istatus;
+    unsigned long flags;
 
     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
@@ -665,7 +666,7 @@ DC390_Interrupt(void *dev_id)
     //dstatus = DC390_read8 (DMA_Status);
     //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
 
-    spin_lock_irq(pACB->pScsiHost->host_lock);
+    spin_lock_irqsave(pACB->pScsiHost->host_lock, flags);
 
     istate = DC390_read8 (Intern_State);
     istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
@@ -736,7 +737,7 @@ DC390_Interrupt(void *dev_id)
     }
 
  unlock:
-    spin_unlock_irq(pACB->pScsiHost->host_lock);
+    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, flags);
     return IRQ_HANDLED;
 }
 
@@ -770,11 +771,8 @@ dc390_DataOut_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 
 	    /* Function called from the ISR with the host_lock held and interrupts disabled */
 	    if (pSRB->SGToBeXferLen)
-		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
-		    spin_unlock_irq(pACB->pScsiHost->host_lock);
+		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE))
 		    udelay(50);
-		    spin_lock_irq(pACB->pScsiHost->host_lock);
-		}
 	    if (!time_before(jiffies, timeout))
 		printk (KERN_CRIT "DC390: Deadlock in DataOut_0: DMA aborted unfinished: %06x bytes remain!!\n",
 			DC390_read32 (DMA_Wk_ByteCntr));
@@ -829,11 +827,8 @@ dc390_DataIn_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
 
 	    /* Function called from the ISR with the host_lock held and interrupts disabled */
 	    if (pSRB->SGToBeXferLen)
-		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
-		    spin_unlock_irq(pACB->pScsiHost->host_lock);
+		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE))
 		    udelay(50);
-		    spin_lock_irq(pACB->pScsiHost->host_lock);
-		}
 	    if (!time_before(jiffies, timeout)) {
 		printk (KERN_CRIT "DC390: Deadlock in DataIn_0: DMA aborted unfinished: %06x bytes remain!!\n",
 			DC390_read32 (DMA_Wk_ByteCntr));
-- 
1.8.5.2

