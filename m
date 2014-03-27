From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/6] be2iscsi: Fix interrupt Coalescing mechanism.
Date: Thu, 27 Mar 2014 12:39:28 -0400
Message-ID: <1395938371-2149-4-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42316 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaC0Qjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:46 -0400
Received: by mail-pa0-f50.google.com with SMTP id kq14so3707575pab.23
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:45 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

	This patch fixes lack of support for interrupt moderation.
This moderates the coalescing based on the rate of IO Completion

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be.h      | 11 ++++++++
 drivers/scsi/be2iscsi/be_cmds.h | 10 ++++++-
 drivers/scsi/be2iscsi/be_main.c | 58 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/be2iscsi/be_main.h |  5 ++--
 drivers/scsi/be2iscsi/be_mgmt.c | 37 ++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |  2 ++
 6 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 1bfb0bd..25c2164 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -83,9 +83,20 @@ static inline void queue_tail_inc(struct be_queue_info *q)
 
 /*ISCSI */
 
+struct be_aic_obj {		/* Adaptive interrupt coalescing (AIC) info */
+	bool enable;
+	u32 min_eqd;		/* in usecs */
+	u32 max_eqd;		/* in usecs */
+	u32 prev_eqd;		/* in usecs */
+	u32 et_eqd;		/* configured val when aic is off */
+	ulong time_val;
+	u64 eq_prev;		/* Used to calculate eqe */
+};
+
 struct be_eq_obj {
 	bool todo_mcc_cq;
 	bool todo_cq;
+	u32 cq_count;
 	struct be_queue_info q;
 	struct beiscsi_hba *phba;
 	struct be_queue_info *cq;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 7cf7f99..cd4410f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -271,6 +271,12 @@ struct be_cmd_resp_eq_create {
 	u16 rsvd0;		/* sword */
 } __packed;
 
+struct be_set_eqd {
+	u32 eq_id;
+	u32 phase;
+	u32 delay_multiplier;
+} __packed;
+
 struct mgmt_chap_format {
 	u32 flags;
 	u8  intr_chap_name[256];
@@ -622,7 +628,7 @@ struct be_cmd_req_modify_eq_delay {
 		u32 eq_id;
 		u32 phase;
 		u32 delay_multiplier;
-	} delay[8];
+	} delay[MAX_CPUS];
 } __packed;
 
 /******************** Get MAC ADDR *******************/
@@ -708,6 +714,8 @@ unsigned int be_cmd_get_port_speed(struct beiscsi_hba *phba);
 
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 
+int be_cmd_modify_eq_delay(struct beiscsi_hba *phba, struct be_set_eqd *,
+			    int num);
 int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 			uint32_t tag, struct be_mcc_wrb **wrb,
 			struct be_dma_mem *mbx_cmd_mem);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 317deee..4e7eded 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2346,6 +2346,7 @@ static int be_iopoll(struct blk_iopoll *iop, int budget)
 	hwi_ring_eq_db(phba, eq->id, 1, num_eq_processed, 0, 1);
 
 	ret = beiscsi_process_cq(pbe_eq);
+	pbe_eq->cq_count += ret;
 	if (ret < budget) {
 		blk_iopoll_complete(iop);
 		beiscsi_log(phba, KERN_INFO,
@@ -3899,9 +3900,9 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
-	phwi_context->max_eqd = 0;
+	phwi_context->max_eqd = 128;
 	phwi_context->min_eqd = 0;
-	phwi_context->cur_eqd = 64;
+	phwi_context->cur_eqd = 0;
 	be_cmd_fw_initialize(&phba->ctrl);
 
 	status = beiscsi_create_eqs(phba, phwi_context);
@@ -5357,6 +5358,57 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 	return;
 }
 
+static void be_eqd_update(struct beiscsi_hba *phba)
+{
+	struct be_set_eqd set_eqd[MAX_CPUS];
+	struct be_aic_obj *aic;
+	struct be_eq_obj *pbe_eq;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	int eqd, i, num = 0;
+	ulong now;
+	u32 pps, delta;
+	unsigned int tag;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	for (i = 0; i <= phba->num_cpus; i++) {
+		aic = &phba->aic_obj[i];
+		pbe_eq = &phwi_context->be_eq[i];
+		now = jiffies;
+		if (!aic->time_val || time_before(now, aic->time_val) ||
+		    pbe_eq->cq_count < aic->eq_prev) {
+			aic->time_val = now;
+			aic->eq_prev = pbe_eq->cq_count;
+			continue;
+		}
+		delta = jiffies_to_msecs(now - aic->time_val);
+		pps = (((u32)(pbe_eq->cq_count - aic->eq_prev) * 1000) / delta);
+		eqd = (pps / 1500) << 2;
+
+		if (eqd < 8)
+			eqd = 0;
+		eqd = min_t(u32, eqd, phwi_context->max_eqd);
+		eqd = max_t(u32, eqd, phwi_context->min_eqd);
+
+		aic->time_val = now;
+		aic->eq_prev = pbe_eq->cq_count;
+
+		if (eqd != aic->prev_eqd) {
+			set_eqd[num].delay_multiplier = (eqd * 65)/100;
+			set_eqd[num].eq_id = pbe_eq->q.id;
+			aic->prev_eqd = eqd;
+			num++;
+		}
+	}
+	if (num) {
+		tag = be_cmd_modify_eq_delay(phba, set_eqd, num);
+		if (tag)
+			beiscsi_mccq_compl(phba, tag, NULL, NULL);
+	}
+}
+
 /*
  * beiscsi_hw_health_check()- Check adapter health
  * @work: work item to check HW health
@@ -5370,6 +5422,8 @@ beiscsi_hw_health_check(struct work_struct *work)
 		container_of(work, struct beiscsi_hba,
 			     beiscsi_hw_check_task.work);
 
+	be_eqd_update(phba);
+
 	beiscsi_ue_detect(phba);
 
 	schedule_delayed_work(&phba->beiscsi_hw_check_task,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 581ebdb..b3716e3 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -72,8 +72,8 @@
 
 #define BEISCSI_SGLIST_ELEMENTS	30
 
-#define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
-#define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
+#define BEISCSI_CMD_PER_LUN	128 /* scsi_host->cmd_per_lun */
+#define BEISCSI_MAX_SECTORS	1024 /* scsi_host->max_sectors */
 #define BEISCSI_TEMPLATE_HDR_PER_CXN_SIZE 128 /* Template size per cxn */
 
 #define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
@@ -429,6 +429,7 @@ struct beiscsi_hba {
 	struct mgmt_session_info boot_sess;
 	struct invalidate_command_table inv_tbl[128];
 
+	struct be_aic_obj aic_obj[MAX_CPUS];
 	unsigned int attr_log_enable;
 	int (*iotask_fn)(struct iscsi_task *,
 			struct scatterlist *sg,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 712911f..52a36fb 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -155,6 +155,43 @@ void beiscsi_ue_detect(struct beiscsi_hba *phba)
 	}
 }
 
+int be_cmd_modify_eq_delay(struct beiscsi_hba *phba,
+		 struct be_set_eqd *set_eqd, int num)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_modify_eq_delay *req;
+	unsigned int tag = 0;
+	int i;
+
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+
+	wrb = wrb_from_mccq(phba);
+	req = embedded_payload(wrb);
+
+	wrb->tag0 |= tag;
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+		OPCODE_COMMON_MODIFY_EQ_DELAY, sizeof(*req));
+
+	req->num_eq = cpu_to_le32(num);
+	for (i = 0; i < num; i++) {
+		req->delay[i].eq_id = cpu_to_le32(set_eqd[i].eq_id);
+		req->delay[i].phase = 0;
+		req->delay[i].delay_multiplier =
+				cpu_to_le32(set_eqd[i].delay_multiplier);
+	}
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+	return tag;
+}
+
 /**
  * mgmt_reopen_session()- Reopen a session based on reopen_type
  * @phba: Device priv structure instance
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 01b8c97..24a8fc5 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -335,5 +335,7 @@ void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 			     struct wrb_handle *pwrb_handle);
 void beiscsi_ue_detect(struct beiscsi_hba *phba);
+int be_cmd_modify_eq_delay(struct beiscsi_hba *phba,
+			 struct be_set_eqd *, int num);
 
 #endif
-- 
1.8.5.3

