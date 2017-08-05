From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 13/20] lpfc: Fix MRQ > 1 context list handling
Date: Fri,  4 Aug 2017 17:47:24 -0700
Message-ID: <20170805004731.1335-14-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36647 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdHEAsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:05 -0400
Received: by mail-pg0-f67.google.com with SMTP id y129so3114201pgy.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:05 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Various oops including cpu LOCKUPs were seen.

For asynchronously received ius where the driver must assign
exchange resources, the resources were on a single get (free) list
and put list (finished, waiting to be put on get list). As all cpus
are sharing the lists, an interrupt for a receive frame may have to
wait for all the other cpus to place their done work onto the put
list before it can acquire the lock to pull from the list.

Fix by breaking the resource lists into per-cpu lists or at least
more than 1 list with cpu's sharing the lists). A cpu would allocate
from the free list for its own cpu, and put its done work on the its own
put list - avoiding the contention. As cpu load may vary, when empty, a
cpu may grab from another cpu, thereby changing resource distribution.
But searching for a resource only occurs on 1 or a few cpus until a
single resource can be allocated. if the condition reoccurs, it starts
looking at a different cpu.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    |  11 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   5 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  11 +-
 drivers/scsi/lpfc/lpfc_init.c    |  18 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c   | 265 ++++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.h   |  14 +++
 drivers/scsi/lpfc/lpfc_sli.c     |   2 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |   7 +-
 8 files changed, 236 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4ed48ed38e79..d3d01ff44423 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -245,13 +245,10 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 				atomic_read(&tgtp->xmt_abort_rsp),
 				atomic_read(&tgtp->xmt_abort_rsp_error));
 
-		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
-		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		tot = phba->sli4_hba.nvmet_xri_cnt -
-			(phba->sli4_hba.nvmet_ctx_get_cnt +
-			phba->sli4_hba.nvmet_ctx_put_cnt);
-		spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
+		/* Calculate outstanding IOs */
+		tot = atomic_read(&tgtp->rcv_fcp_cmd_drop);
+		tot += atomic_read(&tgtp->xmt_fcp_release);
+		tot = atomic_read(&tgtp->rcv_fcp_cmd_in) - tot;
 
 		len += snprintf(buf + len, PAGE_SIZE - len,
 				"IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index da669dce12fe..7e300734b345 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -556,9 +556,8 @@ int lpfc_nvmet_update_targetport(struct lpfc_hba *phba);
 void lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba);
 void lpfc_nvmet_unsol_ls_event(struct lpfc_hba *phba,
 			struct lpfc_sli_ring *pring, struct lpfc_iocbq *piocb);
-void lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba,
-			struct lpfc_sli_ring *pring,
-			struct rqb_dmabuf *nvmebuf, uint64_t isr_ts);
+void lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba, uint32_t idx,
+				struct rqb_dmabuf *nvmebuf, uint64_t isr_ts);
 void lpfc_nvme_mod_param_dep(struct lpfc_hba *phba);
 void lpfc_nvme_abort_fcreq_cmpl(struct lpfc_hba *phba,
 				struct lpfc_iocbq *cmdiocb,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 5cc8b0f7d885..c292264aa687 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -848,13 +848,10 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		}
 
-		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
-		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		tot = phba->sli4_hba.nvmet_xri_cnt -
-			(phba->sli4_hba.nvmet_ctx_get_cnt +
-			phba->sli4_hba.nvmet_ctx_put_cnt);
-		spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
+		/* Calculate outstanding IOs */
+		tot = atomic_read(&tgtp->rcv_fcp_cmd_drop);
+		tot += atomic_read(&tgtp->xmt_fcp_release);
+		tot = atomic_read(&tgtp->rcv_fcp_cmd_in) - tot;
 
 		len += snprintf(buf + len, size - len,
 				"IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5f32a7fe169d..897eb62ed4e6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1253,6 +1253,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 	unsigned long time_elapsed;
 	uint32_t tick_cqe, max_cqe, val;
 	uint64_t tot, data1, data2, data3;
+	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_register reg_data;
 	void __iomem *eqdreg = phba->sli4_hba.u.if_type2.EQDregaddr;
 
@@ -1281,13 +1282,12 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 		/* Check outstanding IO count */
 		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 			if (phba->nvmet_support) {
-				spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
-				spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
-				tot = phba->sli4_hba.nvmet_xri_cnt -
-					(phba->sli4_hba.nvmet_ctx_get_cnt +
-					phba->sli4_hba.nvmet_ctx_put_cnt);
-				spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-				spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
+				tgtp = (struct lpfc_nvmet_tgtport *)
+					phba->targetport->private;
+				/* Calculate outstanding IOs */
+				tot = atomic_read(&tgtp->rcv_fcp_cmd_drop);
+				tot += atomic_read(&tgtp->xmt_fcp_release);
+				tot = atomic_read(&tgtp->rcv_fcp_cmd_in) - tot;
 			} else {
 				tot = atomic_read(&phba->fc4NvmeIoCmpls);
 				data1 = atomic_read(
@@ -5937,8 +5937,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
-		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_get_list);
-		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_put_list);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_io_wait_list);
 
 		/* Fast-path XRI aborted CQ Event work queue list */
@@ -5947,8 +5945,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	/* This abort list used by worker thread */
 	spin_lock_init(&phba->sli4_hba.sgl_list_lock);
-	spin_lock_init(&phba->sli4_hba.nvmet_ctx_get_lock);
-	spin_lock_init(&phba->sli4_hba.nvmet_ctx_put_lock);
 	spin_lock_init(&phba->sli4_hba.nvmet_io_wait_lock);
 
 	/*
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fbeec344c6cc..cd6c93a17760 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -170,8 +170,10 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct rqb_dmabuf *nvmebuf;
+	struct lpfc_nvmet_ctx_info *infop;
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc;
+	int cpu;
 	unsigned long iflag;
 
 	if (ctxp->txrdy) {
@@ -267,11 +269,16 @@ lpfc_nvmet_ctxbuf_post(struct lpfc_hba *phba, struct lpfc_nvmet_ctxbuf *ctx_buf)
 	}
 	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_io_wait_lock, iflag);
 
-	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_put_lock, iflag);
-	list_add_tail(&ctx_buf->list,
-		      &phba->sli4_hba.lpfc_nvmet_ctx_put_list);
-	phba->sli4_hba.nvmet_ctx_put_cnt++;
-	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_put_lock, iflag);
+	/*
+	 * Use the CPU context list, from the MRQ the IO was received on
+	 * (ctxp->idx), to save context structure.
+	 */
+	cpu = smp_processor_id();
+	infop = lpfc_get_ctx_list(phba, cpu, ctxp->idx);
+	spin_lock_irqsave(&infop->nvmet_ctx_list_lock, iflag);
+	list_add_tail(&ctx_buf->list, &infop->nvmet_ctx_list);
+	infop->nvmet_ctx_list_cnt++;
+	spin_unlock_irqrestore(&infop->nvmet_ctx_list_lock, iflag);
 #endif
 }
 
@@ -860,51 +867,54 @@ static struct nvmet_fc_target_template lpfc_tgttemplate = {
 };
 
 static void
-lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
+__lpfc_nvmet_clean_io_for_cpu(struct lpfc_hba *phba,
+		struct lpfc_nvmet_ctx_info *infop)
 {
 	struct lpfc_nvmet_ctxbuf *ctx_buf, *next_ctx_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
-	spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
+	spin_lock_irqsave(&infop->nvmet_ctx_list_lock, flags);
 	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
-			&phba->sli4_hba.lpfc_nvmet_ctx_get_list, list) {
+				&infop->nvmet_ctx_list, list) {
 		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		list_del_init(&ctx_buf->list);
 		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
-		__lpfc_clear_active_sglq(phba,
-					 ctx_buf->sglq->sli4_lxritag);
+
+		__lpfc_clear_active_sglq(phba, ctx_buf->sglq->sli4_lxritag);
 		ctx_buf->sglq->state = SGL_FREED;
 		ctx_buf->sglq->ndlp = NULL;
 
 		spin_lock(&phba->sli4_hba.sgl_list_lock);
 		list_add_tail(&ctx_buf->sglq->list,
-			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
+				&phba->sli4_hba.lpfc_nvmet_sgl_list);
 		spin_unlock(&phba->sli4_hba.sgl_list_lock);
 
 		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
 		kfree(ctx_buf->context);
 	}
-	list_for_each_entry_safe(ctx_buf, next_ctx_buf,
-			&phba->sli4_hba.lpfc_nvmet_ctx_put_list, list) {
-		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
-		list_del_init(&ctx_buf->list);
-		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
-		__lpfc_clear_active_sglq(phba,
-					 ctx_buf->sglq->sli4_lxritag);
-		ctx_buf->sglq->state = SGL_FREED;
-		ctx_buf->sglq->ndlp = NULL;
+	spin_unlock_irqrestore(&infop->nvmet_ctx_list_lock, flags);
+}
 
-		spin_lock(&phba->sli4_hba.sgl_list_lock);
-		list_add_tail(&ctx_buf->sglq->list,
-			      &phba->sli4_hba.lpfc_nvmet_sgl_list);
-		spin_unlock(&phba->sli4_hba.sgl_list_lock);
+static void
+lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
+{
+	struct lpfc_nvmet_ctx_info *infop;
+	int i, j;
 
-		lpfc_sli_release_iocbq(phba, ctx_buf->iocbq);
-		kfree(ctx_buf->context);
+	/* The first context list, MRQ 0 CPU 0 */
+	infop = phba->sli4_hba.nvmet_ctx_info;
+	if (!infop)
+		return;
+
+	/* Cycle the the entire CPU context list for every MRQ */
+	for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
+		for (j = 0; j < phba->sli4_hba.num_present_cpu; j++) {
+			__lpfc_nvmet_clean_io_for_cpu(phba, infop);
+			infop++; /* next */
+		}
 	}
-	spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_get_lock, flags);
+	kfree(phba->sli4_hba.nvmet_ctx_info);
+	phba->sli4_hba.nvmet_ctx_info = NULL;
 }
 
 static int
@@ -913,15 +923,71 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 	struct lpfc_nvmet_ctxbuf *ctx_buf;
 	struct lpfc_iocbq *nvmewqe;
 	union lpfc_wqe128 *wqe;
-	int i;
+	struct lpfc_nvmet_ctx_info *last_infop;
+	struct lpfc_nvmet_ctx_info *infop;
+	int i, j, idx;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME,
 			"6403 Allocate NVMET resources for %d XRIs\n",
 			phba->sli4_hba.nvmet_xri_cnt);
 
+	phba->sli4_hba.nvmet_ctx_info = kcalloc(
+		phba->sli4_hba.num_present_cpu * phba->cfg_nvmet_mrq,
+		sizeof(struct lpfc_nvmet_ctx_info), GFP_KERNEL);
+	if (!phba->sli4_hba.nvmet_ctx_info) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6419 Failed allocate memory for "
+				"nvmet context lists\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Assuming X CPUs in the system, and Y MRQs, allocate some
+	 * lpfc_nvmet_ctx_info structures as follows:
+	 *
+	 * cpu0/mrq0 cpu1/mrq0 ... cpuX/mrq0
+	 * cpu0/mrq1 cpu1/mrq1 ... cpuX/mrq1
+	 * ...
+	 * cpuX/mrqY cpuX/mrqY ... cpuX/mrqY
+	 *
+	 * Each line represents a MRQ "silo" containing an entry for
+	 * every CPU.
+	 *
+	 * MRQ X is initially assumed to be associated with CPU X, thus
+	 * contexts are initially distributed across all MRQs using
+	 * the MRQ index (N) as follows cpuN/mrqN. When contexts are
+	 * freed, the are freed to the MRQ silo based on the CPU number
+	 * of the IO completion. Thus a context that was allocated for MRQ A
+	 * whose IO completed on CPU B will be freed to cpuB/mrqA.
+	 */
+	infop = phba->sli4_hba.nvmet_ctx_info;
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
+			INIT_LIST_HEAD(&infop->nvmet_ctx_list);
+			spin_lock_init(&infop->nvmet_ctx_list_lock);
+			infop->nvmet_ctx_list_cnt = 0;
+			infop++;
+		}
+	}
+
+	/*
+	 * Setup the next CPU context info ptr for each MRQ.
+	 * MRQ 0 will cycle thru CPUs 0 - X separately from
+	 * MRQ 1 cycling thru CPUs 0 - X, and so on.
+	 */
+	for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
+		last_infop = lpfc_get_ctx_list(phba, 0, j);
+		for (i = phba->sli4_hba.num_present_cpu - 1;  i >= 0; i--) {
+			infop = lpfc_get_ctx_list(phba, i, j);
+			infop->nvmet_ctx_next_cpu = last_infop;
+			last_infop = infop;
+		}
+	}
+
 	/* For all nvmet xris, allocate resources needed to process a
 	 * received command on a per xri basis.
 	 */
+	idx = 0;
 	for (i = 0; i < phba->sli4_hba.nvmet_xri_cnt; i++) {
 		ctx_buf = kzalloc(sizeof(*ctx_buf), GFP_KERNEL);
 		if (!ctx_buf) {
@@ -976,12 +1042,35 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 					"6407 Ran out of NVMET XRIs\n");
 			return -ENOMEM;
 		}
-		spin_lock(&phba->sli4_hba.nvmet_ctx_get_lock);
-		list_add_tail(&ctx_buf->list,
-			      &phba->sli4_hba.lpfc_nvmet_ctx_get_list);
-		spin_unlock(&phba->sli4_hba.nvmet_ctx_get_lock);
+
+		/*
+		 * Add ctx to MRQidx context list. Our initial assumption
+		 * is MRQidx will be associated with CPUidx. This association
+		 * can change on the fly.
+		 */
+		infop = lpfc_get_ctx_list(phba, idx, idx);
+		spin_lock(&infop->nvmet_ctx_list_lock);
+		list_add_tail(&ctx_buf->list, &infop->nvmet_ctx_list);
+		infop->nvmet_ctx_list_cnt++;
+		spin_unlock(&infop->nvmet_ctx_list_lock);
+
+		/* Spread ctx structures evenly across all MRQs */
+		idx++;
+		if (idx >= phba->cfg_nvmet_mrq)
+			idx = 0;
+	}
+
+	infop = phba->sli4_hba.nvmet_ctx_info;
+	for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
+		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME | LOG_INIT,
+					"6408 TOTAL NVMET ctx for CPU %d "
+					"MRQ %d: cnt %d nextcpu %p\n",
+					i, j, infop->nvmet_ctx_list_cnt,
+					infop->nvmet_ctx_next_cpu);
+			infop++;
+		}
 	}
-	phba->sli4_hba.nvmet_ctx_get_cnt = phba->sli4_hba.nvmet_xri_cnt;
 	return 0;
 }
 
@@ -1346,10 +1435,66 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 #endif
 }
 
+static struct lpfc_nvmet_ctxbuf *
+lpfc_nvmet_replenish_context(struct lpfc_hba *phba,
+			     struct lpfc_nvmet_ctx_info *current_infop)
+{
+	struct lpfc_nvmet_ctxbuf *ctx_buf = NULL;
+	struct lpfc_nvmet_ctx_info *get_infop;
+	int i;
+
+	/*
+	 * The current_infop for the MRQ a NVME command IU was received
+	 * on is empty. Our goal is to replenish this MRQs context
+	 * list from a another CPUs.
+	 *
+	 * First we need to pick a context list to start looking on.
+	 * nvmet_ctx_start_cpu has available context the last time
+	 * we needed to replenish this CPU where nvmet_ctx_next_cpu
+	 * is just the next sequential CPU for this MRQ.
+	 */
+	if (current_infop->nvmet_ctx_start_cpu)
+		get_infop = current_infop->nvmet_ctx_start_cpu;
+	else
+		get_infop = current_infop->nvmet_ctx_next_cpu;
+
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		if (get_infop == current_infop) {
+			get_infop = get_infop->nvmet_ctx_next_cpu;
+			continue;
+		}
+		spin_lock(&get_infop->nvmet_ctx_list_lock);
+
+		/* Just take the entire context list, if there are any */
+		if (get_infop->nvmet_ctx_list_cnt) {
+			list_splice(&get_infop->nvmet_ctx_list,
+				    &current_infop->nvmet_ctx_list);
+			INIT_LIST_HEAD(&get_infop->nvmet_ctx_list);
+			current_infop->nvmet_ctx_list_cnt =
+				get_infop->nvmet_ctx_list_cnt - 1;
+			get_infop->nvmet_ctx_list_cnt = 0;
+			spin_unlock(&get_infop->nvmet_ctx_list_lock);
+
+			current_infop->nvmet_ctx_start_cpu = get_infop;
+			list_remove_head(&current_infop->nvmet_ctx_list,
+					 ctx_buf, struct lpfc_nvmet_ctxbuf,
+					 list);
+			return ctx_buf;
+		}
+
+		/* Otherwise, move on to the next CPU for this MRQ */
+		spin_unlock(&get_infop->nvmet_ctx_list_lock);
+		get_infop = get_infop->nvmet_ctx_next_cpu;
+	}
+
+	/* Nothing found, all contexts for the MRQ are in-flight */
+	return NULL;
+}
+
 /**
  * lpfc_nvmet_unsol_fcp_buffer - Process an unsolicited event data buffer
  * @phba: pointer to lpfc hba data structure.
- * @pring: pointer to a SLI ring.
+ * @idx: relative index of MRQ vector
  * @nvmebuf: pointer to lpfc nvme command HBQ data structure.
  *
  * This routine is used for processing the WQE associated with a unsolicited
@@ -1361,7 +1506,7 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  **/
 static void
 lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
-			    struct lpfc_sli_ring *pring,
+			    uint32_t idx,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
@@ -1370,9 +1515,11 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_nvmet_ctxbuf *ctx_buf;
+	struct lpfc_nvmet_ctx_info *current_infop;
 	uint32_t *payload;
 	uint32_t size, oxid, sid, rc, qno;
 	unsigned long iflag;
+	int current_cpu;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint32_t id;
 #endif
@@ -1388,31 +1535,24 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 		goto dropit;
 	}
 
-	spin_lock_irqsave(&phba->sli4_hba.nvmet_ctx_get_lock, iflag);
-	if (phba->sli4_hba.nvmet_ctx_get_cnt) {
-		list_remove_head(&phba->sli4_hba.lpfc_nvmet_ctx_get_list,
+	/*
+	 * Get a pointer to the context list for this MRQ based on
+	 * the CPU this MRQ IRQ is associated with. If the CPU association
+	 * changes from our initial assumption, the context list could
+	 * be empty, thus it would need to be replenished with the
+	 * context list from another CPU for this MRQ.
+	 */
+	current_cpu = smp_processor_id();
+	current_infop = lpfc_get_ctx_list(phba, current_cpu, idx);
+	spin_lock_irqsave(&current_infop->nvmet_ctx_list_lock, iflag);
+	if (current_infop->nvmet_ctx_list_cnt) {
+		list_remove_head(&current_infop->nvmet_ctx_list,
 				 ctx_buf, struct lpfc_nvmet_ctxbuf, list);
-		phba->sli4_hba.nvmet_ctx_get_cnt--;
+		current_infop->nvmet_ctx_list_cnt--;
 	} else {
-		spin_lock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		if (phba->sli4_hba.nvmet_ctx_put_cnt) {
-			list_splice(&phba->sli4_hba.lpfc_nvmet_ctx_put_list,
-				    &phba->sli4_hba.lpfc_nvmet_ctx_get_list);
-			INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_ctx_put_list);
-			phba->sli4_hba.nvmet_ctx_get_cnt =
-				phba->sli4_hba.nvmet_ctx_put_cnt;
-			phba->sli4_hba.nvmet_ctx_put_cnt = 0;
-			spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-
-			list_remove_head(
-				&phba->sli4_hba.lpfc_nvmet_ctx_get_list,
-				ctx_buf, struct lpfc_nvmet_ctxbuf, list);
-			phba->sli4_hba.nvmet_ctx_get_cnt--;
-		} else {
-			spin_unlock(&phba->sli4_hba.nvmet_ctx_put_lock);
-		}
+		ctx_buf = lpfc_nvmet_replenish_context(phba, current_infop);
 	}
-	spin_unlock_irqrestore(&phba->sli4_hba.nvmet_ctx_get_lock, iflag);
+	spin_unlock_irqrestore(&current_infop->nvmet_ctx_list_lock, iflag);
 
 	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
 	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
@@ -1464,6 +1604,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 	ctxp->size = size;
 	ctxp->oxid = oxid;
 	ctxp->sid = sid;
+	ctxp->idx = idx;
 	ctxp->state = LPFC_NVMET_STE_RCV;
 	ctxp->entry_cnt = 1;
 	ctxp->flag = 0;
@@ -1561,7 +1702,7 @@ lpfc_nvmet_unsol_ls_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 /**
  * lpfc_nvmet_unsol_fcp_event - Process an unsolicited event from an nvme nport
  * @phba: pointer to lpfc hba data structure.
- * @pring: pointer to a SLI ring.
+ * @idx: relative index of MRQ vector
  * @nvmebuf: pointer to received nvme data structure.
  *
  * This routine is used to process an unsolicited event received from a SLI
@@ -1572,7 +1713,7 @@ lpfc_nvmet_unsol_ls_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  **/
 void
 lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba,
-			   struct lpfc_sli_ring *pring,
+			   uint32_t idx,
 			   struct rqb_dmabuf *nvmebuf,
 			   uint64_t isr_timestamp)
 {
@@ -1580,7 +1721,7 @@ lpfc_nvmet_unsol_fcp_event(struct lpfc_hba *phba,
 		lpfc_rq_buf_free(phba, &nvmebuf->hbuf);
 		return;
 	}
-	lpfc_nvmet_unsol_fcp_buffer(phba, pring, nvmebuf,
+	lpfc_nvmet_unsol_fcp_buffer(phba, idx, nvmebuf,
 				    isr_timestamp);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index e675ef17be08..88cd62a11c33 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -73,6 +73,19 @@ struct lpfc_nvmet_tgtport {
 	atomic_t xmt_abort_rsp_error;
 };
 
+struct lpfc_nvmet_ctx_info {
+	struct list_head nvmet_ctx_list;
+	spinlock_t	nvmet_ctx_list_lock; /* lock per CPU */
+	struct lpfc_nvmet_ctx_info *nvmet_ctx_next_cpu;
+	struct lpfc_nvmet_ctx_info *nvmet_ctx_start_cpu;
+	uint16_t	nvmet_ctx_list_cnt;
+	char pad[16];  /* pad to a cache-line */
+};
+
+/* This retrieves the context info associated with the specified cpu / mrq */
+#define lpfc_get_ctx_list(phba, cpu, mrq)  \
+	(phba->sli4_hba.nvmet_ctx_info + ((cpu * phba->cfg_nvmet_mrq) + mrq))
+
 struct lpfc_nvmet_rcv_ctx {
 	union {
 		struct nvmefc_tgt_ls_req ls_req;
@@ -91,6 +104,7 @@ struct lpfc_nvmet_rcv_ctx {
 	uint16_t size;
 	uint16_t entry_cnt;
 	uint16_t cpu;
+	uint16_t idx;
 	uint16_t state;
 	/* States */
 #define LPFC_NVMET_STE_LS_RCV		1
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9ccd8fed0bed..c46897c6b875 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13291,7 +13291,7 @@ lpfc_sli4_nvmet_handle_rcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		if (fc_hdr->fh_type == FC_TYPE_FCP) {
 			dma_buf->bytes_recv = bf_get(lpfc_rcqe_length,  rcqe);
 			lpfc_nvmet_unsol_fcp_event(
-				phba, phba->sli4_hba.els_wq->pring, dma_buf,
+				phba, idx, dma_buf,
 				cq->assoc_qp->isr_timestamp);
 			return false;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 540454b03587..7dc8c73b5903 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -622,8 +622,6 @@ struct lpfc_sli4_hba {
 	uint16_t scsi_xri_start;
 	uint16_t els_xri_cnt;
 	uint16_t nvmet_xri_cnt;
-	uint16_t nvmet_ctx_get_cnt;
-	uint16_t nvmet_ctx_put_cnt;
 	uint16_t nvmet_io_wait_cnt;
 	uint16_t nvmet_io_wait_total;
 	struct list_head lpfc_els_sgl_list;
@@ -632,9 +630,8 @@ struct lpfc_sli4_hba {
 	struct list_head lpfc_abts_nvmet_ctx_list;
 	struct list_head lpfc_abts_scsi_buf_list;
 	struct list_head lpfc_abts_nvme_buf_list;
-	struct list_head lpfc_nvmet_ctx_get_list;
-	struct list_head lpfc_nvmet_ctx_put_list;
 	struct list_head lpfc_nvmet_io_wait_list;
+	struct lpfc_nvmet_ctx_info *nvmet_ctx_info;
 	struct lpfc_sglq **lpfc_sglq_active_list;
 	struct list_head lpfc_rpi_hdr_list;
 	unsigned long *rpi_bmask;
@@ -665,8 +662,6 @@ struct lpfc_sli4_hba {
 	spinlock_t abts_nvme_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t sgl_list_lock; /* list of aborted els IOs */
-	spinlock_t nvmet_ctx_get_lock; /* list of avail XRI contexts */
-	spinlock_t nvmet_ctx_put_lock; /* list of avail XRI contexts */
 	spinlock_t nvmet_io_wait_lock; /* IOs waiting for ctx resources */
 	uint32_t physical_port;
 
-- 
2.13.1
