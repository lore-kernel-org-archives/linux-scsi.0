From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill useless spinlock wrappers in BusLogic
Date: Tue, 14 Sep 2004 20:24:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914182418.GB16223@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44936 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269458AbUINSYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 14:24:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.33/drivers/scsi/BusLogic.c	2004-08-29 16:58:42 +02:00
+++ edited/drivers/scsi/BusLogic.c	2004-09-14 22:11:49 +02:00
@@ -2619,7 +2621,7 @@
 	/*
 	   Acquire exclusive access to Host Adapter.
 	 */
-	BusLogic_AcquireHostAdapterLockIH(HostAdapter, &ProcessorFlags);
+	spin_lock_irqsave(HostAdapter->SCSI_Host->host_lock, ProcessorFlags);
 	/*
 	   Handle Interrupts appropriately for each Host Adapter type.
 	 */
@@ -2687,7 +2689,7 @@
 	/*
 	   Release exclusive access to Host Adapter.
 	 */
-	BusLogic_ReleaseHostAdapterLockIH(HostAdapter, &ProcessorFlags);
+	spin_unlock_irqrestore(HostAdapter->SCSI_Host->host_lock, ProcessorFlags);
 	return IRQ_HANDLED;
 }
 
@@ -2775,9 +2777,9 @@
 	 */
 	CCB = BusLogic_AllocateCCB(HostAdapter);
 	if (CCB == NULL) {
-		BusLogic_ReleaseHostAdapterLock(HostAdapter);
+		spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 		BusLogic_Delay(1);
-		BusLogic_AcquireHostAdapterLock(HostAdapter);
+		spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 		CCB = BusLogic_AllocateCCB(HostAdapter);
 		if (CCB == NULL) {
 			Command->result = DID_ERROR << 16;
@@ -2901,10 +2903,10 @@
 		   error as a Host Adapter Hard Reset should be initiated soon.
 		 */
 		if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
-			BusLogic_ReleaseHostAdapterLock(HostAdapter);
+			spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 			BusLogic_Warning("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", HostAdapter);
 			BusLogic_Delay(1);
-			BusLogic_AcquireHostAdapterLock(HostAdapter);
+			spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 			if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
 				BusLogic_Warning("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", HostAdapter);
 				BusLogic_DeallocateCCB(CCB);
@@ -3042,9 +3044,9 @@
 	 */
 
 	if (HardReset) {
-		BusLogic_ReleaseHostAdapterLock(HostAdapter);
+		spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 		BusLogic_Delay(HostAdapter->BusSettleTime);
-		BusLogic_AcquireHostAdapterLock(HostAdapter);
+		spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 	}
 
 	for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++) {
===== drivers/scsi/BusLogic.h 1.19 vs edited =====
--- 1.19/drivers/scsi/BusLogic.h	2004-08-29 16:58:54 +02:00
+++ edited/drivers/scsi/BusLogic.h	2004-09-14 22:11:58 +02:00
@@ -1169,46 +1169,6 @@
 	unsigned char ProductRevisionLevel[4];	/* Bytes 32-35 */
 };
 
-/*
-  BusLogic_AcquireHostAdapterLock acquires exclusive access to Host Adapter.
-*/
-
-static inline void BusLogic_AcquireHostAdapterLock(struct BusLogic_HostAdapter *HostAdapter)
-{
-	spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
-}
-
-/*
-  BusLogic_ReleaseHostAdapterLock releases exclusive access to Host Adapter.
-*/
-
-static inline void BusLogic_ReleaseHostAdapterLock(struct BusLogic_HostAdapter *HostAdapter)
-{
-	spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
-}
-
-
-/*
-  BusLogic_AcquireHostAdapterLockIH acquires exclusive access to Host Adapter,
-  but is only called from the interrupt handler.
-*/
-
-static inline void BusLogic_AcquireHostAdapterLockIH(struct BusLogic_HostAdapter *HostAdapter, unsigned long *ProcessorFlags)
-{
-	spin_lock_irqsave(HostAdapter->SCSI_Host->host_lock, *ProcessorFlags);
-}
-
-
-/*
-  BusLogic_ReleaseHostAdapterLockIH releases exclusive access to Host Adapter,
-  but is only called from the interrupt handler.
-*/
-
-static inline void BusLogic_ReleaseHostAdapterLockIH(struct BusLogic_HostAdapter *HostAdapter, unsigned long *ProcessorFlags)
-{
-	spin_unlock_irqrestore(HostAdapter->SCSI_Host->host_lock, *ProcessorFlags);
-}
-
 
 /*
   Define functions to provide an abstraction for reading and writing the
