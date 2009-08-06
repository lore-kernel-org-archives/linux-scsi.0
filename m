From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/3] mptfusion: add support for blk-iopoll
Date: Thu,  6 Aug 2009 21:58:05 +0200
Message-ID: <1249588685-4662-4-git-send-email-jens.axboe@oracle.com>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:59756 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbZHFT6G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Aug 2009 15:58:06 -0400
In-Reply-To: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, jeff@garzik.org, Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/message/fusion/mptbase.c |   99 ++++++++++++++++++++++++++++++++-----
 drivers/message/fusion/mptbase.h |    3 +
 2 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5d0ba4f..24549d6 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -114,6 +114,9 @@ module_param_call(mpt_fwfault_debug, param_set_int, param_get_int,
 MODULE_PARM_DESC(mpt_fwfault_debug, "Enable detection of Firmware fault"
 	" and halt Firmware on fault - (default=0)");
 
+static int mpt_iopoll_w = 32;
+module_param(mpt_iopoll_w, int, 0);
+MODULE_PARM_DESC(mpt_iopoll_w, " blk iopoll budget (default=32");
 
 
 #ifdef MFCNT
@@ -515,6 +518,44 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 	mb();
 }
 
+static void mpt_irq_disable(MPT_ADAPTER *ioc)
+{
+	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
+	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+	CHIPREG_READ32(&ioc->chip->IntStatus);
+}
+
+static void mpt_irq_enable(MPT_ADAPTER *ioc)
+{
+	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
+}
+
+static inline void __mpt_handle_irq(MPT_ADAPTER *ioc, u32 pa)
+{
+	if (pa & MPI_ADDRESS_REPLY_A_BIT)
+		mpt_reply(ioc, pa);
+	else
+		mpt_turbo_reply(ioc, pa);
+}
+
+static int mpt_handle_irq(MPT_ADAPTER *ioc, unsigned int budget)
+{
+	int nr = 0;
+	u32 pa;
+
+	/*
+	 *  Drain the reply FIFO!
+	 */
+	while ((pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo)) != 0xffffffff) {
+		nr++;
+		__mpt_handle_irq(ioc, pa);
+		if (nr == budget)
+			break;
+	}
+
+	return nr;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_interrupt - MPT adapter (IOC) specific interrupt handler.
@@ -536,23 +577,48 @@ static irqreturn_t
 mpt_interrupt(int irq, void *bus_id)
 {
 	MPT_ADAPTER *ioc = bus_id;
-	u32 pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
+	int nr = 0;
+
+	if (!blk_iopoll_enabled)
+		nr = mpt_handle_irq(ioc, -1U);
+	else if (blk_iopoll_sched_prep(&ioc->iopoll)) {
+		mpt_irq_disable(ioc);
+		ioc->iopoll.data =CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
+		blk_iopoll_sched(&ioc->iopoll);
+		nr = 1;
+	} else {
+		/*
+		 * Not really handled, but it will be by iopoll.
+		 */
+		nr = 1;
+	}
 
-	if (pa == 0xFFFFFFFF)
-		return IRQ_NONE;
+	if (nr)
+		return IRQ_HANDLED;
 
-	/*
-	 *  Drain the reply FIFO!
-	 */
-	do {
-		if (pa & MPI_ADDRESS_REPLY_A_BIT)
-			mpt_reply(ioc, pa);
-		else
-			mpt_turbo_reply(ioc, pa);
-		pa = CHIPREG_READ32_dmasync(&ioc->chip->ReplyFifo);
-	} while (pa != 0xFFFFFFFF);
+	return IRQ_NONE;
+}
 
-	return IRQ_HANDLED;
+static int mpt_iopoll(struct blk_iopoll *iop, int budget)
+{
+	MPT_ADAPTER *ioc = container_of(iop, MPT_ADAPTER, iopoll);
+	int ret = 0;
+	u32 pa;
+
+	pa = iop->data;
+	iop->data = 0xffffffff;
+	if (pa != 0xffffffff) {
+		__mpt_handle_irq(ioc, pa);
+		ret = 1;
+	}
+
+	ret += mpt_handle_irq(ioc, budget - ret);
+	if (ret < budget) {
+		blk_iopoll_complete(iop);
+		mpt_irq_enable(ioc);
+	}
+
+	return ret;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2091,6 +2157,7 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* Clear any lingering interrupt */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
+	blk_iopoll_disable(&ioc->iopoll);
 	free_irq(ioc->pci_irq, ioc);
 	if (ioc->msi_enable)
 		pci_disable_msi(ioc->pcidev);
@@ -2358,6 +2425,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 				ret = -EBUSY;
 				goto out;
 			}
+			blk_iopoll_init(&ioc->iopoll, mpt_iopoll_w, mpt_iopoll);
+			blk_iopoll_enable(&ioc->iopoll);
 			irq_allocated = 1;
 			ioc->pci_irq = ioc->pcidev->irq;
 			pci_set_master(ioc->pcidev);		/* ?? */
@@ -2578,6 +2647,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 
  out:
 	if ((ret != 0) && irq_allocated) {
+		blk_iopoll_disable(&ioc->iopoll);
 		free_irq(ioc->pci_irq, ioc);
 		if (ioc->msi_enable)
 			pci_disable_msi(ioc->pcidev);
@@ -2786,6 +2856,7 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 	mpt_adapter_disable(ioc);
 
 	if (ioc->pci_irq != -1) {
+		blk_iopoll_disable(&ioc->iopoll);
 		free_irq(ioc->pci_irq, ioc);
 		if (ioc->msi_enable)
 			pci_disable_msi(ioc->pcidev);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1c8514d..954a59f 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -52,6 +52,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/blk-iopoll.h>
 
 #include "lsi/mpi_type.h"
 #include "lsi/mpi.h"		/* Fusion MPI(nterface) basic defs */
@@ -763,6 +764,8 @@ typedef struct _MPT_ADAPTER
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
 
+	struct blk_iopoll	iopoll;
+
 	u8			sg_addr_size;
 	u8			in_rescan;
 	u8			SGE_size;
-- 
1.6.3.2.306.g4f4fa

