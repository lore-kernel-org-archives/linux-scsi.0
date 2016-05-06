From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 6/6] mpt3sas: Used "synchronize_irq()"API to synchronize  timed-out IO & TMs
Date: Fri,  6 May 2016 14:29:31 +0530
Message-ID: <1462525171-6877-7-git-send-email-chaitra.basappa@broadcom.com>
References: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Replaced mpt3sas_base_flush_reply_queues()with
mpt3sas_base_sync_reply_irqs(),as mpt3sas_base_flush_reply_queues()
skips over reply queues that are currently busy (i.e. being handled
by interrupt processing in another core). If a reply queue is busy,
then call to synchronize_irq()in mpt3sas_base_sync_reply_irqs()make
sures the other core has finished flushing the queue and completed
any calls to the mid-layer scsi_done() routine.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 15 +++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 +++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4e9142f..fd9002d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1103,18 +1103,16 @@ _base_is_controller_msix_enabled(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt3sas_base_flush_reply_queues - flushing the MSIX reply queues
+ * mpt3sas_base_sync_reply_irqs - flush pending MSIX interrupts
  * @ioc: per adapter object
- * Context: ISR conext
+ * Context: non ISR conext
  *
- * Called when a Task Management request has completed. We want
- * to flush the other reply queues so all the outstanding IO has been
- * completed back to OS before we process the TM completetion.
+ * Called when a Task Management request has completed.
  *
  * Return nothing.
  */
 void
-mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
+mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct adapter_reply_queue *reply_q;
 
@@ -1125,12 +1123,13 @@ mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		return;
 
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-		if (ioc->shost_recovery)
+		if (ioc->shost_recovery || ioc->remove_host ||
+				ioc->pci_error_recovery)
 			return;
 		/* TMs are on msix_index == 0 */
 		if (reply_q->msix_index == 0)
 			continue;
-		_base_interrupt(reply_q->vector, (void *)reply_q);
+		synchronize_irq(reply_q->vector);
 	}
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e1befba..1a614d7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1236,7 +1236,8 @@ void *mpt3sas_base_get_msg_frame(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void *mpt3sas_base_get_sense_buffer(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
-void mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc);
+
+void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
 
 /* hi-priority queue */
 u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index abd8717..928214f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2126,7 +2126,6 @@ _scsih_tm_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		return 1;
 	if (ioc->tm_cmds.smid != smid)
 		return 1;
-	mpt3sas_base_flush_reply_queues(ioc);
 	ioc->tm_cmds.status |= MPT3_CMD_COMPLETE;
 	mpi_reply =  mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
@@ -2311,6 +2310,9 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 		}
 	}
 
+	/* sync IRQs in case those were busy during flush. */
+	mpt3sas_base_sync_reply_irqs(ioc);
+
 	if (ioc->tm_cmds.status & MPT3_CMD_REPLY_VALID) {
 		mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
 		mpi_reply = ioc->tm_cmds.reply;
-- 
1.8.3.1
