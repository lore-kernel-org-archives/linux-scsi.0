From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [RFC 1/2] mpt3sas/megaraid_sas : irq poll to avoid CPU hard and soft lockups
Date: Mon, 15 Jan 2018 17:42:35 +0530
Message-ID: <eca669d88fbd468c5dad2c9940632fff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:45985 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932793AbeAOMMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 07:12:37 -0500
Received: by mail-io0-f195.google.com with SMTP id p188so98695ioe.12
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 04:12:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

Patch for Fix-1 explained in PATCH 0.

Signed-off-by: Kashyap Desai < kashyap.desai@broadcom.com>
---
 mpt3sas/mpt3sas_base.c | 67
++++++++++++++++++++++++++++++++++++++------------
 mpt3sas/mpt3sas_base.h |  4 +++
 2 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/mpt3sas/mpt3sas_base.c b/mpt3sas/mpt3sas_base.c index
08237b8..0b351d4 100644
--- a/mpt3sas/mpt3sas_base.c
+++ b/mpt3sas/mpt3sas_base.c
@@ -963,17 +963,15 @@ union reply_descriptor {  };

 /**
- * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
- * @irq: irq number (not used)
- * @bus_id: bus identifier cookie == pointer to MPT_ADAPTER structure
- * @r: pt_regs pointer (not used)
+ * mpt3sas_process_reply_queue - Process the RDs from reply descriptor
+ queue
+ * @ reply_q- reply queue
+ * @ bugget- command completion budget
  *
- * Return IRQ_HANDLE if processed, else IRQ_NONE.
+ * Returns number of RDs processed.
  */
-static irqreturn_t
-_base_interrupt(int irq, void *bus_id)
+int
+mpt3sas_process_reply_queue(struct adapter_reply_queue *reply_q, u32
+budget)
 {
-	struct adapter_reply_queue *reply_q = bus_id;
 	union reply_descriptor rd;
 	u32 completed_cmds;
 	u8 request_desript_type;
@@ -985,18 +983,15 @@ _base_interrupt(int irq, void *bus_id)
 	Mpi2ReplyDescriptorsUnion_t *rpf;
 	u8 rc;

-	if (ioc->mask_interrupts)
-		return IRQ_NONE;
-
 	if (!atomic_add_unless(&reply_q->busy, 1, 1))
-		return IRQ_NONE;
+		return 0;

 	rpf = &reply_q->reply_post_free[reply_q->reply_post_host_index];
 	request_desript_type = rpf->Default.ReplyFlags
 	     & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 	if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
 		atomic_dec(&reply_q->busy);
-		return IRQ_NONE;
+		return 0;
 	}

 	completed_cmds = 0;
@@ -1072,7 +1067,7 @@ _base_interrupt(int irq, void *bus_id)
 		 * So that FW can find enough entries to post the Reply
 		 * Descriptors in the reply descriptor post queue.
 		 */
-		if (completed_cmds > ioc->hba_queue_depth/3) {
+		if (completed_cmds == budget) {
 			if (ioc->combined_reply_queue) {
 				writel(reply_q->reply_post_host_index |
 						((msix_index  & 7) <<
@@ -1084,6 +1079,8 @@ _base_interrupt(int irq, void *bus_id)

MPI2_RPHI_MSIX_INDEX_SHIFT),

&ioc->chip->ReplyPostHostIndex);
 			}
+			if (ioc->irqpoll_weight)
+				break;
 			completed_cmds = 1;
 		}
 		if (request_desript_type ==
MPI2_RPY_DESCRIPT_FLAGS_UNUSED) @@ -1098,14 +1095,14 @@
_base_interrupt(int irq, void *bus_id)

 	if (!completed_cmds) {
 		atomic_dec(&reply_q->busy);
-		return IRQ_NONE;
+		return 0;
 	}

 	if (ioc->is_warpdrive) {
 		writel(reply_q->reply_post_host_index,
 		ioc->reply_post_host_index[msix_index]);
 		atomic_dec(&reply_q->busy);
-		return IRQ_HANDLED;
+		return completed_cmds;
 	}

 	/* Update Reply Post Host Index.
@@ -1132,6 +1129,27 @@ _base_interrupt(int irq, void *bus_id)
 			MPI2_RPHI_MSIX_INDEX_SHIFT),
 			&ioc->chip->ReplyPostHostIndex);
 	atomic_dec(&reply_q->busy);
+	return completed_cmds;
+}
+
+/**
+ * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
+ * @irq: irq number (not used)
+ * @bus_id: bus identifier cookie == pointer to MPT_ADAPTER structure
+ * @r: pt_regs pointer (not used)
+ *
+ * Return IRQ_HANDLE if processed, else IRQ_NONE.
+ */
+static irqreturn_t
+_base_interrupt(int irq, void *bus_id)
+{
+	struct adapter_reply_queue *reply_q = bus_id;
+	struct MPT3SAS_ADAPTER *ioc = reply_q->ioc;
+
+	if (ioc->mask_interrupts)
+		return IRQ_NONE;
+
+	irq_poll_sched(&reply_q->irqpoll);
 	return IRQ_HANDLED;
 }

@@ -2285,6 +2303,20 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER
*ioc)
 	return 0;
 }

+int mpt3sas_irqpoll(struct irq_poll *irqpoll, int budget) {
+	struct adapter_reply_queue *reply_q;
+	int num_entries = 0;
+
+	reply_q = container_of(irqpoll, struct adapter_reply_queue,
irqpoll);
+
+	num_entries = mpt3sas_process_reply_queue(reply_q, budget);
+	if (num_entries < budget)
+		irq_poll_complete(irqpoll);
+
+	return num_entries;
+}
+
 /**
  * _base_free_irq - free irq
  * @ioc: per adapter object
@@ -2301,6 +2333,7 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)

 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list,
list) {
 		list_del(&reply_q->list);
+		irq_poll_disable(&reply_q->irqpoll);
 		free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index),
 			 reply_q);
 		kfree(reply_q);
@@ -2348,6 +2381,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8
index)

 	INIT_LIST_HEAD(&reply_q->list);
 	list_add_tail(&reply_q->list, &ioc->reply_queue_list);
+	irq_poll_init(&reply_q->irqpoll, ioc->irqpoll_weight,
+mpt3sas_irqpoll);
 	return 0;
 }

@@ -2482,6 +2516,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	}

 	ioc->msix_enable = 1;
+	ioc->irqpoll_weight = 50;
 	ioc->reply_queue_count = r;
 	for (i = 0; i < ioc->reply_queue_count; i++) {
 		r = _base_request_irq(ioc, i);
diff --git a/mpt3sas/mpt3sas_base.h b/mpt3sas/mpt3sas_base.h index
60f42ca..456d928 100644
--- a/mpt3sas/mpt3sas_base.h
+++ b/mpt3sas/mpt3sas_base.h
@@ -66,6 +66,7 @@
 #include <scsi/scsi_eh.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
+#include <linux/irq_poll.h>

 #include "mpt3sas_debug.h"
 #include "mpt3sas_trigger_diag.h"
@@ -846,6 +847,8 @@ struct _event_ack_list {  struct adapter_reply_queue {
 	struct MPT3SAS_ADAPTER	*ioc;
 	u8			msix_index;
+	u32			max_budget;
+	struct irq_poll		irqpoll;
 	u32			reply_post_host_index;
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
@@ -1353,6 +1356,7 @@ struct MPT3SAS_ADAPTER {
 	u16		device_remove_in_progress_sz;
 	u8		is_gen35_ioc;
 	u8		atomic_desc_capable;
+	u32		irqpoll_weight;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
--
2.5.5
