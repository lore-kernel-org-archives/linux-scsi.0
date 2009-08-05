From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/7] mptsas : Code cleanup of host page alloc and diag reset.
Date: Wed, 5 Aug 2009 12:53:51 +0530
Message-ID: <20090805072341.GG14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:46165 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbZHEHou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:44:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Code cleanup of host page alloc and diag reset.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5d0ba4f..8ab7b37 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1297,12 +1297,8 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
 	psge = (char *)&ioc_init->HostPageBufferSGE;
 	flags_length = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI_SGE_FLAGS_SYSTEM_ADDRESS |
-	    MPI_SGE_FLAGS_32_BIT_ADDRESSING |
 	    MPI_SGE_FLAGS_HOST_TO_IOC |
 	    MPI_SGE_FLAGS_END_OF_BUFFER;
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-	    flags_length |= MPI_SGE_FLAGS_64_BIT_ADDRESSING;
-	}
 	flags_length = flags_length << MPI_SGE_FLAGS_SHIFT;
 	flags_length |= ioc->HostPageBuffer_sz;
 	ioc->add_sge(psge, flags_length, ioc->HostPageBuffer_dma);
@@ -2224,8 +2220,6 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	int	 hard;
 	int	 rc=0;
 	int	 ii;
-	u8	 cb_idx;
-	int	 handlers;
 	int	 ret = 0;
 	int	 reset_alt_ioc_active = 0;
 	int	 irq_allocated = 0;
@@ -2548,34 +2542,6 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		mpt_get_manufacturing_pg_0(ioc);
 	}
 
-	/*
-	 * Call each currently registered protocol IOC reset handler
-	 * with post-reset indication.
-	 * NOTE: If we're doing _IOC_BRINGUP, there can be no
-	 * MptResetHandlers[] registered yet.
-	 */
-	if (hard_reset_done) {
-		rc = handlers = 0;
-		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-			if ((ret == 0) && MptResetHandlers[cb_idx]) {
-				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				    "Calling IOC post_reset handler #%d\n",
-				    ioc->name, cb_idx));
-				rc += mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
-				handlers++;
-			}
-
-			if (alt_ioc_ready && MptResetHandlers[cb_idx]) {
-				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				    "Calling IOC post_reset handler #%d\n",
-				    ioc->alt_ioc->name, cb_idx));
-				rc += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_POST_RESET);
-				handlers++;
-			}
-		}
-		/* FIXME?  Examine results here? */
-	}
-
  out:
 	if ((ret != 0) && irq_allocated) {
 		free_irq(ioc->pci_irq, ioc);
@@ -3938,6 +3904,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 	int count = 0;
 	u32 diag1val = 0;
 	MpiFwHeader_t *cached_fw;	/* Pointer to FW */
+	u8	 cb_idx;
 
 	/* Clear any existing interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
@@ -3956,6 +3923,18 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 		else
 			mdelay(1);
 
+		/*
+		 * Call each currently registered protocol IOC reset handler
+		 * with pre-reset indication.
+		 * NOTE: If we're doing _IOC_BRINGUP, there can be no
+		 * MptResetHandlers[] registered yet.
+		 */
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx])
+				(*(MptResetHandlers[cb_idx]))(ioc,
+						MPT_IOC_PRE_RESET);
+		}
+
 		for (count = 0; count < 60; count ++) {
 			doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
 			doorbell &= MPI_IOC_STATE_MASK;
@@ -4052,25 +4031,15 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 		 * NOTE: If we're doing _IOC_BRINGUP, there can be no
 		 * MptResetHandlers[] registered yet.
 		 */
-		{
-			u8	 cb_idx;
-			int	 r = 0;
-
-			for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-				if (MptResetHandlers[cb_idx]) {
-					dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-						"Calling IOC pre_reset handler #%d\n",
-						ioc->name, cb_idx));
-					r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
-					if (ioc->alt_ioc) {
-						dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-							"Calling alt-%s pre_reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, cb_idx));
-						r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_PRE_RESET);
-					}
+		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+			if (MptResetHandlers[cb_idx]) {
+				mpt_signal_reset(cb_idx,
+					ioc, MPT_IOC_PRE_RESET);
+				if (ioc->alt_ioc) {
+					mpt_signal_reset(cb_idx,
+					ioc->alt_ioc, MPT_IOC_PRE_RESET);
 				}
 			}
-			/* FIXME?  Examine results here? */
 		}
 
 		if (ioc->cached_fw)
@@ -6956,7 +6925,7 @@ EXPORT_SYMBOL(mpt_halt_firmware);
 int
 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
-	int		 rc;
+	int	 rc;
 	u8	 cb_idx;
 	unsigned long	 flags;
 	unsigned long	 time_count;
@@ -6982,8 +6951,6 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 		ioc->alt_ioc->ioc_reset_in_progress = 1;
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
-	/* FIXME: If do_ioc_recovery fails, repeat....
-	 */
 
 	/* The SCSI driver needs to adjust timeouts on all current
 	 * commands prior to the diagnostic reset being issued.
@@ -7020,6 +6987,15 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	}
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_POST_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx,
+					ioc->alt_ioc, MPT_IOC_POST_RESET);
+		}
+	}
+
 	dtmprintk(ioc,
 	    printk(MYIOC_s_DEBUG_FMT
 		"HardResetHandler: completed (%d seconds): %s\n", ioc->name,
