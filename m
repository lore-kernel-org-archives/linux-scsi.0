From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/43] qla2xxx: Use IOCB path to submit Control VP MBX command
Date: Tue, 19 Dec 2017 22:56:04 -0800
Message-ID: <20171220065644.21511-4-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:56045
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932344AbdLTG44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:56:56 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Use IOCB patch to submit Control VP MBX command to reduce
bottle-neck for mbx interface.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  9 ++++-
 drivers/scsi/qla2xxx/qla_gs.c     |  1 +
 drivers/scsi/qla2xxx/qla_init.c   |  1 +
 drivers/scsi/qla2xxx/qla_inline.h |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c   | 23 +++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    | 35 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c    | 77 -----------------------------------
 drivers/scsi/qla2xxx/qla_mid.c    | 85 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 154 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4d65fd973a12..50a570595969 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -472,6 +472,10 @@ struct srb_iocb {
 			uint32_t timeout_sec;
 			struct	list_head   entry;
 		} nvme;
+		struct {
+			u16 cmd;
+			u16 vp_index;
+		} ctrlvp;
 	} u;
 
 	struct timer_list timer;
@@ -507,6 +511,7 @@ enum {
 	SPCN_PRLI,
 	SPCN_NVME_LS,
 	SPCN_NVME_CMD,
+	SPCN_CTRL_VP,
 };
 
 struct sp_name {
@@ -536,7 +541,7 @@ struct sp_name {
 #define SRB_NVME_CMD	19
 #define SRB_NVME_LS	20
 #define SRB_PRLI_CMD	21
-
+#define SRB_CTRL_VP	22
 enum {
 	TYPE_SRB,
 	TYPE_TGT_CMD,
@@ -562,6 +567,8 @@ typedef struct srb {
 	struct list_head elem;
 	u32 gen1;	/* scratch */
 	u32 gen2;	/* scratch */
+	int rc;
+	struct completion comp;
 	union {
 		struct srb_iocb iocb_cmd;
 		struct bsg_job *bsg_job;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7e88e8289157..6aa6dd74fe86 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -41,6 +41,7 @@ struct sp_name sp_str[] = {
 	{ SPCN_PRLI, "prli" },
 	{ SPCN_NVME_LS, "nvme_ls" },
 	{ SPCN_NVME_CMD, "nvme_cmd" },
+	{ SPCN_CTRL_VP, "ctrl_vp" },
 };
 
 const char *sp_to_str(uint16_t cmd)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9d65fbe85e30..24d0f9d419d2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -135,6 +135,7 @@ qla2x00_async_iocb_timeout(void *data)
 	case SRB_NACK_PLOGI:
 	case SRB_NACK_PRLI:
 	case SRB_NACK_LOGO:
+	case SRB_CTRL_VP:
 		sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 17d2c20f1f75..4d32426393c7 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -273,6 +273,7 @@ qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
+	init_completion(&sp->comp);
 	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	if (sp->type == SRB_ELS_DCMD)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b5d1423f933d..62b3d0a8a961 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3368,6 +3368,26 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 	return rval;
 }
 
+static void
+qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
+{
+	int map, pos;
+
+	vce->entry_type = VP_CTRL_IOCB_TYPE;
+	vce->handle = sp->handle;
+	vce->entry_count = 1;
+	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
+	vce->vp_count = cpu_to_le16(1);
+
+	/*
+	 * index map in firmware starts with 1; decrement index
+	 * this is ok as we never use index 0
+	 */
+	map = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
+	pos = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
+	vce->vp_idx_map[map] |= 1 << pos;
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3446,6 +3466,9 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_NACK_LOGO:
 		qla2x00_send_notify_ack_iocb(sp, pkt);
 		break;
+	case SRB_CTRL_VP:
+		qla25xx_ctrlvp_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a55bfaa790a3..a265c2d8c9cc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1937,6 +1937,37 @@ qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	sp->done(sp, ret);
 }
 
+static void qla_ctrlvp_completed(scsi_qla_host_t *vha, struct req_que *req,
+    struct vp_ctrl_entry_24xx *vce)
+{
+	const char func[] = "CTRLVP-IOCB";
+	srb_t *sp;
+	int rval = QLA_SUCCESS;
+
+	sp = qla2x00_get_sp_from_handle(vha, func, req, vce);
+	if (!sp)
+		return;
+
+	if (vce->entry_status != 0) {
+		ql_dbg(ql_dbg_vport, vha, 0x10c4,
+		    "%s: Failed to complete IOCB -- error status (%x)\n",
+		    sp->name, vce->entry_status);
+		rval = QLA_FUNCTION_FAILED;
+	} else if (vce->comp_status != cpu_to_le16(CS_COMPLETE)) {
+		ql_dbg(ql_dbg_vport, vha, 0x10c5,
+		    "%s: Failed to complete IOCB -- completion status (%x) vpidx %x\n",
+		    sp->name, le16_to_cpu(vce->comp_status),
+		    le16_to_cpu(vce->vp_idx_failed));
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		ql_dbg(ql_dbg_vport, vha, 0x10c6,
+		    "Done %s.\n", __func__);
+	}
+
+	sp->rc = rval;
+	sp->done(sp, rval);
+}
+
 /**
  * qla2x00_process_response_queue() - Process response queue entries.
  * @ha: SCSI driver HA context
@@ -3001,6 +3032,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla24xx_mbx_iocb_entry(vha, rsp->req,
 			    (struct mbx_24xx_entry *)pkt);
 			break;
+		case VP_CTRL_IOCB_TYPE:
+			qla_ctrlvp_completed(vha, rsp->req,
+			    (struct vp_ctrl_entry_24xx *)pkt);
+			break;
 		default:
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f5cbdaeaea1f..956d121cc396 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3946,83 +3946,6 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 }
 
 /*
- * qla24xx_control_vp
- *	Enable a virtual port for given host
- *
- * Input:
- *	ha = adapter block pointer.
- *	vhba = virtual adapter (unused)
- *	index = index number for enabled VP
- *
- * Returns:
- *	qla2xxx local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
-{
-	int		rval;
-	int		map, pos;
-	struct vp_ctrl_entry_24xx   *vce;
-	dma_addr_t	vce_dma;
-	struct qla_hw_data *ha = vha->hw;
-	int	vp_index = vha->vp_idx;
-	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c1,
-	    "Entered %s enabling index %d.\n", __func__, vp_index);
-
-	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
-		return QLA_PARAMETER_ERROR;
-
-	vce = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
-	if (!vce) {
-		ql_log(ql_log_warn, vha, 0x10c2,
-		    "Failed to allocate VP control IOCB.\n");
-		return QLA_MEMORY_ALLOC_FAILED;
-	}
-
-	vce->entry_type = VP_CTRL_IOCB_TYPE;
-	vce->entry_count = 1;
-	vce->command = cpu_to_le16(cmd);
-	vce->vp_count = cpu_to_le16(1);
-
-	/* index map in firmware starts with 1; decrement index
-	 * this is ok as we never use index 0
-	 */
-	map = (vp_index - 1) / 8;
-	pos = (vp_index - 1) & 7;
-	mutex_lock(&ha->vport_lock);
-	vce->vp_idx_map[map] |= 1 << pos;
-	mutex_unlock(&ha->vport_lock);
-
-	rval = qla2x00_issue_iocb(base_vha, vce, vce_dma, 0);
-	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_mbx, vha, 0x10c3,
-		    "Failed to issue VP control IOCB (%x).\n", rval);
-	} else if (vce->entry_status != 0) {
-		ql_dbg(ql_dbg_mbx, vha, 0x10c4,
-		    "Failed to complete IOCB -- error status (%x).\n",
-		    vce->entry_status);
-		rval = QLA_FUNCTION_FAILED;
-	} else if (vce->comp_status != cpu_to_le16(CS_COMPLETE)) {
-		ql_dbg(ql_dbg_mbx, vha, 0x10c5,
-		    "Failed to complete IOCB -- completion status (%x).\n",
-		    le16_to_cpu(vce->comp_status));
-		rval = QLA_FUNCTION_FAILED;
-	} else {
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c6,
-		    "Done %s.\n", __func__);
-	}
-
-	dma_pool_free(ha->s_dma_pool, vce, vce_dma);
-
-	return rval;
-}
-
-/*
  * qla2x00_send_change_request
  *	Receive or disable RSCN request from fabric controller
  *
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 522d585a1a08..fc61fef5e305 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -894,3 +894,88 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 failed:
 	return 0;
 }
+
+static void qla_ctrlvp_sp_done(void *s, int res)
+{
+	struct srb *sp = s;
+
+	complete(&sp->comp);
+	/* don't free sp here. Let the caller do the free */
+}
+
+/*
+ * qla24xx_control_vp
+ *	Enable a virtual port for given host
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *	vhba = virtual adapter (unused)
+ *	index = index number for enabled VP
+ *
+ * Returns:
+ *	qla2xxx local function return status code.
+ *
+ * Context:
+ *	Kernel context.
+ */
+int
+qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
+{
+	int rval = QLA_MEMORY_ALLOC_FAILED;
+	struct qla_hw_data *ha = vha->hw;
+	int	vp_index = vha->vp_idx;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	srb_t *sp;
+
+	ql_dbg(ql_dbg_vport, vha, 0x10c1,
+	    "Entered %s cmd %x index %d.\n", __func__, cmd, vp_index);
+
+	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
+		return QLA_PARAMETER_ERROR;
+
+	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_CTRL_VP;
+	sp->name = sp_to_str(SPCN_CTRL_VP);
+	sp->done = qla_ctrlvp_sp_done;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	sp->u.iocb_cmd.u.ctrlvp.cmd = cmd;
+	sp->u.iocb_cmd.u.ctrlvp.vp_index = vp_index;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "%s: %s Failed submission. %x.\n",
+		    __func__, sp->name, rval);
+		goto done_free_sp;
+	}
+
+	ql_dbg(ql_dbg_vport, vha, 0x113f, "%s hndl %x submitted\n",
+	    sp->name, sp->handle);
+
+	wait_for_completion(&sp->comp);
+	rval = sp->rc;
+	switch (rval) {
+	case QLA_FUNCTION_TIMEOUT:
+		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s Timeout. %x.\n",
+		    __func__, sp->name, rval);
+		break;
+	case QLA_SUCCESS:
+		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s done.\n",
+		    __func__, sp->name);
+		goto done_free_sp;
+	default:
+		ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s Failed. %x.\n",
+		    __func__, sp->name, rval);
+		goto done_free_sp;
+	}
+done:
+	return rval;
+
+done_free_sp:
+	sp->free(sp);
+	return rval;
+}
-- 
2.12.0
