From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 09/22] qla2xxx: Refactor T10-DIF PI support
Date: Tue, 6 Dec 2016 12:30:38 -0800
Message-ID: <1481056251-2310-10-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0057.outbound.protection.outlook.com ([104.47.37.57]:47424
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752330AbcLFUbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:16 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

qla2xxx currently access T10-DIF protection opcode and type
field in se_cmd struct. Add translation code so qla2xxx driver
would not acces private TCM data structure.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h     |   1 +
 drivers/scsi/qla2xxx/qla_def.h     |  23 ++
 drivers/scsi/qla2xxx/qla_dfs.c     |  15 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   6 +-
 drivers/scsi/qla2xxx/qla_init.c    |   3 +
 drivers/scsi/qla2xxx/qla_inline.h  |  17 +
 drivers/scsi/qla2xxx/qla_iocb.c    |  17 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   3 +
 drivers/scsi/qla2xxx/qla_target.c  | 613 ++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.h  |  47 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 158 ++++++++--
 11 files changed, 661 insertions(+), 242 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index e1fc4e6..c6bffe9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -348,6 +348,7 @@ void __attribute__((format (printf, 4, 5)))
 #define ql_dbg_tgt	0x00004000 /* Target mode */
 #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
 #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
+#define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
 
 extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 07cda5a..8cee332 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2859,6 +2859,16 @@ struct qla_chip_state_84xx {
 	uint32_t gold_fw_version;
 };
 
+struct qla_dif_statistics {
+	uint64_t dif_input_bytes;
+	uint64_t dif_output_bytes;
+	uint64_t dif_input_requests;
+	uint64_t dif_output_requests;
+	uint32_t dif_guard_err;
+	uint32_t dif_ref_tag_err;
+	uint32_t dif_app_tag_err;
+};
+
 struct qla_statistics {
 	uint32_t total_isp_aborts;
 	uint64_t input_bytes;
@@ -2871,6 +2881,7 @@ struct qla_statistics {
 	uint32_t stat_max_pend_cmds;
 	uint32_t stat_max_qfull_cmds_alloc;
 	uint32_t stat_max_qfull_cmds_dropped;
+	struct qla_dif_statistics qla_dif_stats;
 };
 
 struct bidi_statistics {
@@ -2878,6 +2889,17 @@ struct bidi_statistics {
 	unsigned long long transfer_bytes;
 };
 
+/* DIF */
+struct qla_tc_param {
+	struct scsi_qla_host	*vha;
+	uint32_t		blk_sz;
+	uint32_t		bufflen;
+	struct scatterlist	*sg;
+	struct scatterlist	*prot_sg;
+	struct crc_context	*ctx;
+	uint8_t			*ctx_dsd_alloced;
+};
+
 /* Multi queue support */
 #define MBC_INITIALIZE_MULTIQ 0x1f
 #define QLA_QUE_PAGE 0X1000
@@ -3007,6 +3029,7 @@ struct qlt_hw_data {
 	uint16_t atio_q_length;
 	uint32_t __iomem *atio_q_in;
 	uint32_t __iomem *atio_q_out;
+	uint64_t        atio_ring_end_addr;
 
 	struct qla_tgt_func_tmpl *tgt_ops;
 	struct qla_tgt_cmd *cmds[DEFAULT_OUTSTANDING_COMMANDS];
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 6aa24ee..f69ff52 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -151,6 +151,21 @@
 	seq_printf(s, "num Q full sent = %lld\n",
 		vha->tgt_counters.num_q_full_sent);
 
+/* DIF stats */
+	seq_printf(s, "DIF Inp Bytes = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_input_bytes);
+	seq_printf(s, "DIF Outp Bytes = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_output_bytes);
+	seq_printf(s, "DIF Inp Req = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_input_requests);
+	seq_printf(s, "DIF Outp Req = %lld\n",
+		vha->qla_stats.qla_dif_stats.dif_output_requests);
+	seq_printf(s, "DIF Guard err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_guard_err);
+	seq_printf(s, "DIF Ref tag err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_ref_tag_err);
+	seq_printf(s, "DIF App tag err = %d\n",
+		vha->qla_stats.qla_dif_stats.dif_app_tag_err);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 13c4d51..9303dbe 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -243,11 +243,11 @@ int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 extern void *qla2x00_alloc_iocbs(scsi_qla_host_t *, srb_t *);
 extern int qla2x00_issue_marker(scsi_qla_host_t *, int);
 extern int qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *, srb_t *,
-	uint32_t *, uint16_t, struct qla_tgt_cmd *);
+	uint32_t *, uint16_t, struct qla_tc_param *);
 extern int qla24xx_walk_and_build_sglist(struct qla_hw_data *, srb_t *,
-	uint32_t *, uint16_t, struct qla_tgt_cmd *);
+	uint32_t *, uint16_t, struct qla_tc_param *);
 extern int qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *, srb_t *,
-	uint32_t *, uint16_t, struct qla_tgt_cmd *);
+	uint32_t *, uint16_t, struct qla_tc_param *);
 extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
 extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
 extern int qla24xx_build_scsi_crc_2_iocbs(srb_t *,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f3ea6b6..30c840d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2260,6 +2260,9 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 
 	ha->tgt.atio_ring_ptr = ha->tgt.atio_ring;
 	ha->tgt.atio_ring_index = 0;
+	ha->tgt.atio_ring_end_addr = (uint64_t)(ha->tgt.atio_ring +
+		(ha->tgt.atio_q_length - 1));
+
 	/* Initialize ATIO queue entries */
 	qlt_init_atio_q_entries(vha);
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 44e4045..5382b03 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -319,3 +319,20 @@
 		fcport->retry_delay_timestamp = jiffies +
 		    (retry_delay * HZ / 10);
 }
+
+static inline uint8_t *qla_atio_look_ahead(struct qlt_hw_data *ha_tgt,
+	struct atio *cur_atio, int index)
+{
+	struct atio *npkt = NULL;
+	int i;
+
+	/* index=1 : get the next IOCB. index=2: get 2nd iocb from cur_atio */
+	npkt = cur_atio;
+	for (i = 1; i <= index; i++) {
+		npkt++;
+		if ((uint64_t)npkt > ha_tgt->atio_ring_end_addr)
+			npkt = ha_tgt->atio_ring;
+	}
+
+	return (uint8_t *)npkt;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 61f4d21..2bb65c6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -889,7 +889,7 @@ struct fw_dif_context {
 
 int
 qla24xx_walk_and_build_sglist_no_difb(struct qla_hw_data *ha, srb_t *sp,
-	uint32_t *dsd, uint16_t tot_dsds, struct qla_tgt_cmd *tc)
+	uint32_t *dsd, uint16_t tot_dsds, struct qla_tc_param *tc)
 {
 	void *next_dsd;
 	uint8_t avail_dsds = 0;
@@ -966,7 +966,7 @@ struct fw_dif_context {
 			} else {
 				list_add_tail(&dsd_ptr->list,
 				    &(tc->ctx->dsd_list));
-				tc->ctx_dsd_alloced = 1;
+				*tc->ctx_dsd_alloced = 1;
 			}
 
 
@@ -1005,7 +1005,7 @@ struct fw_dif_context {
 
 int
 qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
-	uint16_t tot_dsds, struct qla_tgt_cmd *tc)
+	uint16_t tot_dsds, struct qla_tc_param *tc)
 {
 	void *next_dsd;
 	uint8_t avail_dsds = 0;
@@ -1066,7 +1066,7 @@ struct fw_dif_context {
 			} else {
 				list_add_tail(&dsd_ptr->list,
 				    &(tc->ctx->dsd_list));
-				tc->ctx_dsd_alloced = 1;
+				*tc->ctx_dsd_alloced = 1;
 			}
 
 			/* add new list to cmd iocb or last list */
@@ -1092,7 +1092,7 @@ struct fw_dif_context {
 
 int
 qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
-	uint32_t *dsd, uint16_t tot_dsds, struct qla_tgt_cmd *tc)
+	uint32_t *dsd, uint16_t tot_dsds, struct qla_tc_param *tc)
 {
 	void *next_dsd;
 	uint8_t avail_dsds = 0;
@@ -1158,7 +1158,7 @@ struct fw_dif_context {
 			} else {
 				list_add_tail(&dsd_ptr->list,
 				    &(tc->ctx->dsd_list));
-				tc->ctx_dsd_alloced = 1;
+				*tc->ctx_dsd_alloced = 1;
 			}
 
 			/* add new list to cmd iocb or last list */
@@ -1231,9 +1231,14 @@ struct fw_dif_context {
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->control_flags =
 		    cpu_to_le16(CF_WRITE_DATA);
+		vha->qla_stats.qla_dif_stats.dif_output_bytes += scsi_bufflen(cmd);
+		vha->qla_stats.qla_dif_stats.dif_output_requests++;
+
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->control_flags =
 		    cpu_to_le16(CF_READ_DATA);
+		vha->qla_stats.qla_dif_stats.dif_input_bytes += scsi_bufflen(cmd);
+		vha->qla_stats.qla_dif_stats.dif_input_requests++;
 	}
 
 	if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5fd3b07..ccdb890 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1872,6 +1872,7 @@ struct scsi_dif_tuple {
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		vha->qla_stats.qla_dif_stats.dif_guard_err++;
 		return 1;
 	}
 
@@ -1882,6 +1883,7 @@ struct scsi_dif_tuple {
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		vha->qla_stats.qla_dif_stats.dif_ref_tag_err++;
 		return 1;
 	}
 
@@ -1892,6 +1894,7 @@ struct scsi_dif_tuple {
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
 		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		vha->qla_stats.qla_dif_stats.dif_app_tag_err++;
 		return 1;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cf4f86d..8c42ff4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -36,8 +36,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
-#include <target/target_core_base.h>
-#include <target/target_core_fabric.h>
 
 #include "qla_def.h"
 #include "qla_target.h"
@@ -129,6 +127,28 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 LIST_HEAD(qla_tgt_glist);
 EXPORT_SYMBOL(qla_tgt_glist);
 
+static const char *prot_op_str(u32 prot_op)
+{
+	switch (prot_op) {
+	case QLA_PROT_NORMAL:
+	    return "NORMAL";
+	case QLA_PROT_DIN_INSERT:
+	    return "DIN_INSERT";
+	case QLA_PROT_DOUT_INSERT:
+	    return "DOUT_INSERT";
+	case QLA_PROT_DIN_STRIP:
+	    return "DIN_STRIP";
+	case QLA_PROT_DOUT_STRIP:
+	    return "DOUT_STRIP";
+	case QLA_PROT_DIN_PASS:
+	    return "DIN_PASS";
+	case QLA_PROT_DOUT_PASS:
+	    return "DOUT_PASS";
+	default:
+	    return "UNKNOWN";
+	}
+}
+
 /* This API intentionally takes dest as a parameter, rather than returning
  * int value to avoid caller forgetting to issue wmb() after the store */
 void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
@@ -1603,6 +1623,99 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	qla2x00_start_iocbs(ha, ha->req);
 }
 
+/* ha->hardware_lock supposed to be held on entry */
+static inline uint32_t qlt_make_handle(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t h;
+
+	h = ha->tgt.current_handle;
+	/* always increment cmd handle */
+	do {
+		++h;
+		if (h > DEFAULT_OUTSTANDING_COMMANDS)
+			h = 1; /* 0 is QLA_TGT_NULL_HANDLE */
+		if (h == ha->tgt.current_handle) {
+			ql_dbg(ql_dbg_io, vha, 0x305b,
+			    "qla_target(%d): Ran out of "
+			    "empty cmd slots in ha %p\n", vha->vp_idx, ha);
+			h = QLA_TGT_NULL_HANDLE;
+			break;
+		}
+	} while ((h == QLA_TGT_NULL_HANDLE) ||
+	    (h == QLA_TGT_SKIP_HANDLE) ||
+	    (ha->tgt.cmds[h-1] != NULL));
+
+	if (h != QLA_TGT_NULL_HANDLE)
+		ha->tgt.current_handle = h;
+
+	return h;
+}
+/* Code added for T10 DIF support */
+/*
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then reacquire
+ */
+void qlt_send_resp_ctio(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
+	uint8_t scsi_status, uint8_t sense_key, uint8_t asc, uint8_t ascq)
+{
+	struct atio_from_isp *atio = &cmd->atio;
+	struct ctio7_to_24xx *ctio;
+	uint16_t temp;
+
+
+	ql_dbg(ql_dbg_tgt_dif, vha, 0x3066,
+		  "Sending response CTIO7 (vha=%p, atio=%p, scsi_status=%02x, "
+		  "sense_key=%02x, asc=%02x, ascq=%02x",
+		  vha, atio, scsi_status, sense_key, asc, ascq);
+
+	ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs(vha, NULL);
+	if (ctio == NULL) {
+		ql_dbg(ql_dbg_async, vha, 0x3067,
+			"qla2x00t(%ld): %s failed: unable to allocate "
+			"request packet", vha->host_no, __func__);
+		goto out;
+	}
+
+	ctio->entry_type = CTIO_TYPE7;
+	ctio->entry_count = 1;
+	ctio->handle = QLA_TGT_SKIP_HANDLE;
+	ctio->nport_handle = cmd->sess->loop_id;
+	ctio->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio->vp_index = vha->vp_idx;
+	ctio->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
+	ctio->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
+	ctio->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
+	ctio->exchange_addr = atio->u.isp24.exchange_addr;
+	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
+	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio->u.status1.ox_id = cpu_to_le16(temp);
+	ctio->u.status1.scsi_status =
+	    cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID | scsi_status);
+	ctio->u.status1.response_len = __constant_cpu_to_le16(18);
+
+	ctio->u.status1.residual = get_unaligned((uint32_t *)
+		&atio->u.isp24.fcp_cmnd.add_cdb[0]);
+	if (ctio->u.status1.residual != 0)
+		ctio->u.status1.scsi_status |= __constant_cpu_to_le16(SS_RESIDUAL_UNDER);
+
+	/* Response code and sense key */
+	((uint32_t *)ctio->u.status1.sense_data)[0] =
+		cpu_to_le32((0x70 << 24) | (sense_key << 8));
+	/* Additional sense length */
+	((uint32_t *)ctio->u.status1.sense_data)[1] = __constant_cpu_to_le32(0x0a);
+	/* ASC and ASCQ */
+	((uint32_t *)ctio->u.status1.sense_data)[3] = cpu_to_le32((asc << 24) |
+							(ascq << 16));
+
+	/* Memory Barrier */
+	wmb();
+	qla2x00_start_iocbs(vha, vha->req);
+
+out:
+	return;
+}
+
 /* callback from target fabric module code */
 void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 {
@@ -1669,7 +1782,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 
 	prm->cmd->sg_mapped = 1;
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL) {
+	if (cmd->prot_op == QLA_PROT_NORMAL) {
 		/*
 		 * If greater than four sg entries then we need to allocate
 		 * the continuation entries
@@ -1680,8 +1793,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			prm->tgt->datasegs_per_cont);
 	} else {
 		/* DIF */
-		if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-		    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+		if ((cmd->prot_op == QLA_PROT_DIN_INSERT) ||
+		    (cmd->prot_op == QLA_PROT_DOUT_STRIP)) {
 			prm->seg_cnt = DIV_ROUND_UP(cmd->bufflen, cmd->blk_sz);
 			prm->tot_dsds = prm->seg_cnt;
 		} else
@@ -1695,8 +1808,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			if (unlikely(prm->prot_seg_cnt == 0))
 				goto out_err;
 
-			if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-			    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+			if ((cmd->prot_op == QLA_PROT_DIN_INSERT) ||
+			    (cmd->prot_op == QLA_PROT_DOUT_STRIP)) {
 				/* Dif Bundling not support here */
 				prm->prot_seg_cnt = DIV_ROUND_UP(cmd->bufflen,
 								cmd->blk_sz);
@@ -1782,34 +1895,6 @@ static inline void *qlt_get_req_pkt(struct scsi_qla_host *vha)
 	return (cont_entry_t *)vha->req->ring_ptr;
 }
 
-/* ha->hardware_lock supposed to be held on entry */
-static inline uint32_t qlt_make_handle(struct scsi_qla_host *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-	uint32_t h;
-
-	h = ha->tgt.current_handle;
-	/* always increment cmd handle */
-	do {
-		++h;
-		if (h > DEFAULT_OUTSTANDING_COMMANDS)
-			h = 1; /* 0 is QLA_TGT_NULL_HANDLE */
-		if (h == ha->tgt.current_handle) {
-			ql_dbg(ql_dbg_io, vha, 0x305b,
-			    "qla_target(%d): Ran out of "
-			    "empty cmd slots in ha %p\n", vha->vp_idx, ha);
-			h = QLA_TGT_NULL_HANDLE;
-			break;
-		}
-	} while ((h == QLA_TGT_NULL_HANDLE) ||
-	    (h == QLA_TGT_SKIP_HANDLE) ||
-	    (ha->tgt.cmds[h-1] != NULL));
-
-	if (h != QLA_TGT_NULL_HANDLE)
-		ha->tgt.current_handle = h;
-
-	return h;
-}
 
 /* ha->hardware_lock supposed to be held on entry */
 static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
@@ -2143,6 +2228,60 @@ static inline void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
 {}
 #endif
 
+
+static void qlt_print_dif_err(struct qla_tgt_prm *prm)
+{
+	struct qla_tgt_cmd *cmd;
+	struct scsi_qla_host *vha;
+
+
+	/* asc 0x10=dif error */
+	if (prm->sense_buffer && (prm->sense_buffer[12] == 0x10)) {
+
+		cmd = prm->cmd;
+		vha = cmd->vha;
+		/* ASCQ */
+		switch (prm->sense_buffer[13]) {
+		case 1:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+				"BE detected Guard TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+				"ulp_cmd=%p tag[%x]",
+				cmd->lba, cmd->lba,
+				cmd->num_blks, cmd->ulp_cmd,
+				cmd->atio.u.isp24.exchange_addr);
+			break;
+		case 2:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+				"BE detected APP TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+				"ulp_cmd=%p tag[%x]",
+				cmd->lba, cmd->lba,
+				cmd->num_blks, cmd->ulp_cmd,
+				cmd->atio.u.isp24.exchange_addr);
+			break;
+		case 3:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+				"BE detected REF TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+				"ulp_cmd=%p tag[%x]",
+				cmd->lba, cmd->lba,
+				cmd->num_blks, cmd->ulp_cmd,
+				cmd->atio.u.isp24.exchange_addr);
+			break;
+		default:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+				"BE detected Dif ERR: lba[%llx|%lld] len[%x] "
+				"ulp_cmd=%p tag[%x]",
+				cmd->lba, cmd->lba,
+				cmd->num_blks, cmd->ulp_cmd,
+				cmd->atio.u.isp24.exchange_addr);
+			break;
+		}
+
+		ql_dump_buffer(ql_dbg_tgt_dif, vha, 0xffff,
+			cmd->cdb, 16);
+	}
+}
+
+
 static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	struct qla_tgt_prm *prm)
 {
@@ -2183,18 +2322,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		for (i = 0; i < prm->sense_buffer_len/4; i++)
 			((uint32_t *)ctio->u.status1.sense_data)[i] =
 				cpu_to_be32(((uint32_t *)prm->sense_buffer)[i]);
-#if 0
-		if (unlikely((prm->sense_buffer_len % 4) != 0)) {
-			static int q;
-			if (q < 10) {
-				ql_dbg(ql_dbg_tgt, vha, 0xe04f,
-				    "qla_target(%d): %d bytes of sense "
-				    "lost", prm->tgt->ha->vp_idx,
-				    prm->sense_buffer_len % 4);
-				q++;
-			}
-		}
-#endif
+
+		qlt_print_dif_err(prm);
+
 	} else {
 		ctio->u.status1.flags &=
 		    ~cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
@@ -2212,7 +2342,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 /* diff  */
 static inline int
-qlt_hba_err_chk_enabled(struct se_cmd *se_cmd)
+qlt_hba_err_chk_enabled(struct qla_tgt_cmd *cmd)
 {
 	/*
 	 * Uncomment when corresponding SCSI changes are done.
@@ -2221,19 +2351,19 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	 return 0;
 	 *
 	 */
-	switch (se_cmd->prot_op) {
-	case TARGET_PROT_DOUT_INSERT:
-	case TARGET_PROT_DIN_STRIP:
+	switch (cmd->prot_op) {
+	case QLA_PROT_DOUT_INSERT:
+	case QLA_PROT_DIN_STRIP:
 		if (ql2xenablehba_err_chk >= 1)
 			return 1;
 		break;
-	case TARGET_PROT_DOUT_PASS:
-	case TARGET_PROT_DIN_PASS:
+	case QLA_PROT_DOUT_PASS:
+	case QLA_PROT_DIN_PASS:
 		if (ql2xenablehba_err_chk >= 2)
 			return 1;
 		break;
-	case TARGET_PROT_DIN_INSERT:
-	case TARGET_PROT_DOUT_STRIP:
+	case QLA_PROT_DIN_INSERT:
+	case QLA_PROT_DOUT_STRIP:
 		return 1;
 	default:
 		break;
@@ -2241,14 +2371,32 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	return 0;
 }
 
-/*
- * qla24xx_set_t10dif_tags_from_cmd - Extract Ref and App tags from SCSI command
- *
- */
-static inline void
-qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
+static inline int
+qla_tgt_ref_mask_check(struct qla_tgt_cmd *cmd)
+{
+	switch (cmd->prot_op) {
+	case QLA_PROT_DIN_INSERT:
+	case QLA_PROT_DOUT_INSERT:
+	case QLA_PROT_DIN_STRIP:
+	case QLA_PROT_DOUT_STRIP:
+	case QLA_PROT_DIN_PASS:
+	case QLA_PROT_DOUT_PASS:
+		return 1;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static void
+qla_tgt_set_dif_tags(struct qla_tgt_cmd *cmd, struct crc_context *ctx,
+    uint16_t *pfw_prot_opts)
 {
-	uint32_t lba = 0xffffffff & se_cmd->t_task_lba;
+	uint32_t lba = 0xffffffff & cmd->lba;
+	uint32_t t32 = 0;
+	scsi_qla_host_t *vha = cmd->tgt->vha;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* wait til Mode Sense/Select cmd, modepage Ah, subpage 2
 	 * have been immplemented by TCM, before AppTag is avail.
@@ -2258,17 +2406,32 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
-	switch (se_cmd->prot_type) {
-	case TARGET_DIF_TYPE0_PROT:
+	if (IS_PI_UNINIT_CAPABLE(ha)) {
+		if ((cmd->prot_type == QLA_TGT_PROT_TYPE1) ||
+			(cmd->prot_type == QLA_TGT_PROT_TYPE2))
+		*pfw_prot_opts |= PO_DIS_VALD_APP_ESC;
+		else if (cmd->prot_type == QLA_TGT_PROT_TYPE3)
+			*pfw_prot_opts |= PO_DIS_VALD_APP_REF_ESC;
+	}
+
+	t32 = ha->tgt.tgt_ops->get_dif_tags(cmd, pfw_prot_opts);
+
+#if 0
+	if (cmd->prot_op == TARGET_PROT_PASS_NOCHECK) {
+		*pfw_prot_opts |= PO_DISABLE_GUARD_CHECK|
+		PO_DIS_APP_TAG_VALD|PO_DIS_REF_TAG_VALD;
+		return;
+	}
+#endif
+
+	switch (cmd->prot_type) {
+	case QLA_TGT_PROT_TYPE0:
 		/*
 		 * No check for ql2xenablehba_err_chk, as it would be an
 		 * I/O error if hba tag generation is not done.
 		 */
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
-			break;
-
 		/* enable ALL bytes of the ref tag */
 		ctx->ref_tag_mask[0] = 0xff;
 		ctx->ref_tag_mask[1] = 0xff;
@@ -2279,11 +2442,14 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	 * For TYpe 1 protection: 16 bit GUARD tag, 32 bit REF tag, and
 	 * 16 bit app tag.
 	 */
-	case TARGET_DIF_TYPE1_PROT:
+	case QLA_TGT_PROT_TYPE1:
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
+		if (!qla_tgt_ref_mask_check(cmd) ||
+		    !(ha->tgt.tgt_ops->chk_dif_tags(t32))) {
+			*pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
 			break;
+		}
 
 		/* enable ALL bytes of the ref tag */
 		ctx->ref_tag_mask[0] = 0xff;
@@ -2295,11 +2461,14 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	 * For TYPE 2 protection: 16 bit GUARD + 32 bit REF tag has to
 	 * match LBA in CDB + N
 	 */
-	case TARGET_DIF_TYPE2_PROT:
+	case QLA_TGT_PROT_TYPE2:
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
+		if (!qla_tgt_ref_mask_check(cmd) ||
+		    !(ha->tgt.tgt_ops->chk_dif_tags(t32))) {
+			*pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
 			break;
+		}
 
 		/* enable ALL bytes of the ref tag */
 		ctx->ref_tag_mask[0] = 0xff;
@@ -2309,14 +2478,13 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		break;
 
 	/* For Type 3 protection: 16 bit GUARD only */
-	case TARGET_DIF_TYPE3_PROT:
+	case QLA_TGT_PROT_TYPE3:
+		*pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
 		ctx->ref_tag_mask[0] = ctx->ref_tag_mask[1] =
 			ctx->ref_tag_mask[2] = ctx->ref_tag_mask[3] = 0x00;
 		break;
 	}
 }
-
-
 static inline int
 qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 {
@@ -2332,10 +2500,10 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	dma_addr_t		crc_ctx_dma;
 	uint16_t		fw_prot_opts = 0;
 	struct qla_tgt_cmd	*cmd = prm->cmd;
-	struct se_cmd		*se_cmd = &cmd->se_cmd;
 	uint32_t h;
 	struct atio_from_isp *atio = &prm->cmd->atio;
 	uint16_t t16;
+	struct qla_tc_param     tc;
 
 	ha = vha->hw;
 
@@ -2345,28 +2513,29 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe071,
 	    "qla_target(%d):%s: ulp_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
-	    vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
+	    vha->vp_idx, __func__, cmd->ulp_cmd, cmd->prot_op,
 	    prm->prot_sg, prm->prot_seg_cnt, cmd->lba);
 
-	if ((se_cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
-	    (se_cmd->prot_op == TARGET_PROT_DOUT_STRIP))
+	if ((cmd->prot_op == QLA_PROT_DIN_INSERT) ||
+	    (cmd->prot_op == QLA_PROT_DOUT_STRIP))
 		bundling = 0;
 
 	/* Compute dif len and adjust data len to incude protection */
 	data_bytes = cmd->bufflen;
 	dif_bytes  = (data_bytes / cmd->blk_sz) * 8;
 
-	switch (se_cmd->prot_op) {
-	case TARGET_PROT_DIN_INSERT:
-	case TARGET_PROT_DOUT_STRIP:
+	switch (cmd->prot_op) {
+	case QLA_PROT_DIN_INSERT:
+	case QLA_PROT_DOUT_STRIP:
 		transfer_length = data_bytes;
-		data_bytes += dif_bytes;
+		if (cmd->prot_sg_cnt)
+			data_bytes += dif_bytes;
 		break;
 
-	case TARGET_PROT_DIN_STRIP:
-	case TARGET_PROT_DOUT_INSERT:
-	case TARGET_PROT_DIN_PASS:
-	case TARGET_PROT_DOUT_PASS:
+	case QLA_PROT_DIN_STRIP:
+	case QLA_PROT_DOUT_INSERT:
+	case QLA_PROT_DIN_PASS:
+	case QLA_PROT_DOUT_PASS:
 		transfer_length = data_bytes + dif_bytes;
 		break;
 
@@ -2374,29 +2543,30 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		BUG();
 		break;
 	}
-
-	if (!qlt_hba_err_chk_enabled(se_cmd))
+	if (!qlt_hba_err_chk_enabled(cmd))
 		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
 	/* HBA error checking enabled */
 	else if (IS_PI_UNINIT_CAPABLE(ha)) {
-		if ((se_cmd->prot_type == TARGET_DIF_TYPE1_PROT) ||
-		    (se_cmd->prot_type == TARGET_DIF_TYPE2_PROT))
+		if ((cmd->prot_type == QLA_TGT_PROT_TYPE1) ||
+		    (cmd->prot_type == QLA_TGT_PROT_TYPE2))
 			fw_prot_opts |= PO_DIS_VALD_APP_ESC;
-		else if (se_cmd->prot_type == TARGET_DIF_TYPE3_PROT)
+		else if (cmd->prot_type == QLA_TGT_PROT_TYPE3)
 			fw_prot_opts |= PO_DIS_VALD_APP_REF_ESC;
 	}
 
-	switch (se_cmd->prot_op) {
-	case TARGET_PROT_DIN_INSERT:
-	case TARGET_PROT_DOUT_INSERT:
+	switch (cmd->prot_op) {
+	case QLA_PROT_DIN_INSERT:
+	case QLA_PROT_DOUT_INSERT:
 		fw_prot_opts |= PO_MODE_DIF_INSERT;
+		bundling = 0;
 		break;
-	case TARGET_PROT_DIN_STRIP:
-	case TARGET_PROT_DOUT_STRIP:
+	case QLA_PROT_DIN_STRIP:
+	case QLA_PROT_DOUT_STRIP:
 		fw_prot_opts |= PO_MODE_DIF_REMOVE;
+		bundling = 0;
 		break;
-	case TARGET_PROT_DIN_PASS:
-	case TARGET_PROT_DOUT_PASS:
+	case QLA_PROT_DIN_PASS:
+	case QLA_PROT_DOUT_PASS:
 		fw_prot_opts |= PO_MODE_DIF_PASS;
 		/* FUTURE: does tcm require T10CRC<->IPCKSUM conversion? */
 		break;
@@ -2425,7 +2595,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 
 	pkt->handle  = h | CTIO_COMPLETION_HANDLE_MARK;
-	pkt->nport_handle = prm->cmd->loop_id;
+	pkt->nport_handle = cpu_to_le16(prm->cmd->loop_id);
 	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	pkt->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
@@ -2471,7 +2641,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	/* Set handle */
 	crc_ctx_pkt->handle = pkt->handle;
 
-	qlt_set_t10dif_tags(se_cmd, crc_ctx_pkt);
+	qla_tgt_set_dif_tags(cmd, crc_ctx_pkt, &fw_prot_opts);
 
 	pkt->crc_context_address[0] = cpu_to_le32(LSD(crc_ctx_dma));
 	pkt->crc_context_address[1] = cpu_to_le32(MSD(crc_ctx_dma));
@@ -2498,16 +2668,24 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
 	crc_ctx_pkt->guard_seed = cpu_to_le16(0);
 
+	memset((uint8_t *)&tc, 0 , sizeof(tc));
+	tc.vha     = vha;
+	tc.blk_sz  = cmd->blk_sz;
+	tc.bufflen = cmd->bufflen;
+	tc.sg      = cmd->sg;
+	tc.prot_sg = cmd->prot_sg;
+	tc.ctx     = crc_ctx_pkt;
+	tc.ctx_dsd_alloced = &cmd->ctx_dsd_alloced;
 
 	/* Walks data segments */
 	pkt->flags |= cpu_to_le16(CTIO7_FLAGS_DSD_PTR);
 
 	if (!bundling && prm->prot_seg_cnt) {
 		if (qla24xx_walk_and_build_sglist_no_difb(ha, NULL, cur_dsd,
-			prm->tot_dsds, cmd))
+			prm->tot_dsds, &tc))
 			goto crc_queuing_error;
 	} else if (qla24xx_walk_and_build_sglist(ha, NULL, cur_dsd,
-		(prm->tot_dsds - prm->prot_seg_cnt), cmd))
+		(prm->tot_dsds - prm->prot_seg_cnt), &tc))
 		goto crc_queuing_error;
 
 	if (bundling && prm->prot_seg_cnt) {
@@ -2516,13 +2694,14 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
 		if (qla24xx_walk_and_build_prot_sglist(ha, NULL, cur_dsd,
-			prm->prot_seg_cnt, cmd))
+			prm->prot_seg_cnt, &tc))
 			goto crc_queuing_error;
 	}
 	return QLA_SUCCESS;
 
 crc_queuing_error:
 	/* Cleanup will be performed by the caller */
+	vha->hw->tgt.cmds[h-1] = NULL;
 
 	return QLA_FUNCTION_FAILED;
 }
@@ -2598,10 +2777,14 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (unlikely(res))
 		goto out_unmap_unlock;
 
-	if (cmd->se_cmd.prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
+	if (cmd->prot_op &&
+	    (xmit_type & QLA_TGT_XMIT_DATA) &&
+	    qlt_has_data(cmd)) {
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
+	}
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
+
 	if (unlikely(res != 0)) {
 		vha->req->cnt += full_req_cnt;
 		goto out_unmap_unlock;
@@ -2614,7 +2797,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 		    cpu_to_le16(CTIO7_FLAGS_DATA_IN |
 			CTIO7_FLAGS_STATUS_MODE_0);
 
-		if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+		if (cmd->prot_op == QLA_PROT_NORMAL)
 			qlt_load_data_segments(&prm, vha);
 
 		if (prm.add_status_pkt == 0) {
@@ -2739,7 +2922,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	res = qlt_check_reserve_free_req(vha, prm.req_cnt);
 	if (res != 0)
 		goto out_unlock_free_unmap;
-	if (cmd->se_cmd.prot_op)
+	if (cmd->prot_op != QLA_PROT_NORMAL)
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
@@ -2753,7 +2936,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	pkt->u.status0.flags |= cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
 	    CTIO7_FLAGS_STATUS_MODE_0);
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+	if (cmd->prot_op == QLA_PROT_NORMAL)
 		qlt_load_data_segments(&prm, vha);
 
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
@@ -2776,50 +2959,47 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 
 /*
- * Checks the guard or meta-data for the type of error
- * detected by the HBA.
+ * it is assumed either hardware_lock or qpair lock is held.
  */
-static inline int
+static void
 qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
-		struct ctio_crc_from_fw *sts)
+	struct ctio_crc_from_fw *sts)
 {
 	uint8_t		*ap = &sts->actual_dif[0];
 	uint8_t		*ep = &sts->expected_dif[0];
-	uint32_t	e_ref_tag, a_ref_tag;
-	uint16_t	e_app_tag, a_app_tag;
-	uint16_t	e_guard, a_guard;
 	uint64_t	lba = cmd->lba;
+	uint8_t scsi_status, sense_key, asc, ascq;
+	unsigned long flags;
 
-	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
-	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
-	a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
+	cmd->trc_flags |= TRC_DIF_ERR;
 
-	e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
-	e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
-	e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
+	cmd->a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
+	cmd->a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
+	cmd->a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe075,
-	    "iocb(s) %p Returned STATUS.\n", sts);
+	cmd->e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
+	cmd->e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
+	cmd->e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
 
-	ql_dbg(ql_dbg_tgt, vha, 0xf075,
-	    "dif check TGT cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x]\n",
-	    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-	    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag, a_guard, e_guard);
+	ql_dbg(ql_dbg_tgt_dif, vha, 0xf075,
+	    "%s:  aborted %d state %d\n",
+		   __func__, cmd->aborted, cmd->state);
 
+	scsi_status = sense_key = asc = ascq = 0;
+
+#if 0
 	/*
 	 * Ignore sector if:
 	 * For type     3: ref & app tag is all 'f's
 	 * For type 0,1,2: app tag is all 'f's
 	 */
-	if ((a_app_tag == 0xffff) &&
-	    ((cmd->se_cmd.prot_type != TARGET_DIF_TYPE3_PROT) ||
-	     (a_ref_tag == 0xffffffff))) {
+	if ((cmd->a_app_tag == 0xffff) &&
+	    ((cmd->prot_type != QLA_TGT_PROT_TYPE3) ||
+	     (cmd->a_ref_tag == 0xffffffff))) {
 		uint32_t blocks_done;
 
 		/* 2TB boundary case covered automatically with this */
-		blocks_done = e_ref_tag - (uint32_t)lba + 1;
-		cmd->se_cmd.bad_sector = e_ref_tag;
-		cmd->se_cmd.pi_err = 0;
+		blocks_done = cmd->e_ref_tag - (uint32_t)lba + 1;
 		ql_dbg(ql_dbg_tgt, vha, 0xf074,
 			"need to return scsi good\n");
 
@@ -2828,7 +3008,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 			uint32_t i, k = 0, num_ent;
 			struct scatterlist *sg, *sgl;
 
-
 			sgl = cmd->prot_sg;
 
 			/* Patch the corresponding protection tags */
@@ -2845,68 +3024,97 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 			if (k != blocks_done) {
 				ql_log(ql_log_warn, vha, 0xf076,
 				    "unexpected tag values tag:lba=%u:%llu)\n",
-				    e_ref_tag, (unsigned long long)lba);
+				    cmd->e_ref_tag, (unsigned long long)lba);
 				goto out;
 			}
-
-#if 0
-			struct sd_dif_tuple *spt;
-			/* TODO:
-			 * This section came from initiator. Is it valid here?
-			 * should ulp be override with actual val???
-			 */
-			spt = page_address(sg_page(sg)) + sg->offset;
-			spt += j;
-
-			spt->app_tag = 0xffff;
-			if (cmd->se_cmd.prot_type == SCSI_PROT_DIF_TYPE3)
-				spt->ref_tag = 0xffffffff;
-#endif
 		}
-
-		return 0;
 	}
+#endif
 
-	/* check guard */
-	if (e_guard != a_guard) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->lba;
-
-		ql_log(ql_log_warn, vha, 0xe076,
-		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-		    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-		    a_guard, e_guard, cmd);
-		goto out;
+	/* check appl tag */
+	if (cmd->e_app_tag != cmd->a_app_tag) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"App Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard [%x|%x] cmd=%p ox_id[%04x]",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+
+		cmd->dif_err_code = DIF_ERR_APP;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x2;
 	}
 
 	/* check ref tag */
-	if (e_ref_tag != a_ref_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = e_ref_tag;
-
-		ql_log(ql_log_warn, vha, 0xe077,
-			"Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
+	if (cmd->e_ref_tag != cmd->a_ref_tag) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"Ref Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard[%x|%x] cmd=%p ox_id[%04x] ",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+
+		cmd->dif_err_code = DIF_ERR_REF;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x3;
 		goto out;
 	}
 
-	/* check appl tag */
-	if (e_app_tag != a_app_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->lba;
-
-		ql_log(ql_log_warn, vha, 0xe078,
-			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
+	/* check guard */
+	if (cmd->e_guard != cmd->a_guard) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"Guard ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard [%x|%x] cmd=%p ox_id[%04x]",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+
+		cmd->dif_err_code = DIF_ERR_GRD;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x1;
 		goto out;
 	}
+
 out:
-	return 1;
+	switch (cmd->state) {
+	case QLA_TGT_STATE_NEED_DATA:
+		/* handle_data will load DIF error code  */
+		cmd->state = QLA_TGT_STATE_DATA_IN;
+		vha->hw->tgt.tgt_ops->handle_data(cmd);
+		break;
+
+	default:
+		spin_lock_irqsave(&cmd->cmd_lock, flags);
+		if (cmd->aborted) {
+			spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+			vha->hw->tgt.tgt_ops->free_cmd(cmd);
+			break;
+		}
+		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+
+		qlt_send_resp_ctio(vha, cmd, scsi_status, sense_key, asc, ascq);
+		/* assume scsi status gets out on the wire.
+		 * Will not wait for completion.
+		 */
+		vha->hw->tgt.tgt_ops->free_cmd(cmd);
+
+		break;
+	}
 }
 
 
@@ -3046,8 +3254,7 @@ static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 
 	/* Most likely, it isn't needed */
 	ctio24->u.status1.residual = get_unaligned((uint32_t *)
-	    &atio->u.isp24.fcp_cmnd.add_cdb[
-	    atio->u.isp24.fcp_cmnd.add_cdb_len]);
+	    &atio->u.isp24.fcp_cmnd.add_cdb[0]);
 	if (ctio24->u.status1.residual != 0)
 		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
 
@@ -3281,6 +3488,17 @@ static int qlt_term_ctio_exchange(struct scsi_qla_host *vha, void *ctio,
 {
 	int term = 0;
 
+	if (cmd->prot_op) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			   "Term DIF cmd: lba[0x%llx|%lld] len[0x%x] "
+			   "ulp_cmd=%p tag[%x] op %#x/%s",
+			   cmd->lba, cmd->lba,
+			   cmd->num_blks, cmd->ulp_cmd,
+			   cmd->atio.u.isp24.exchange_addr,
+			   cmd->prot_op,
+			   prot_op_str(cmd->prot_op));
+	}
+
 	if (ctio != NULL) {
 		struct ctio7_from_24xx *c = (struct ctio7_from_24xx *)ctio;
 		term = !(c->flags &
@@ -3505,32 +3723,15 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
-			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, ulp_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
+			    "qla_target(%d): CTIO with DIF_ERROR status %x "
+			    "received (state %x, ulp_cmd %p) actual_dif[0x%llx] "
+			    "expect_dif[0x%llx]\n",
 			    vha->vp_idx, status, cmd->state, ulp_cmd,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
-			if (qlt_handle_dif_error(vha, cmd, ctio)) {
-				if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
-					/* scsi Write/xfer rdy complete */
-					goto skip_term;
-				} else {
-					/* scsi read/xmit respond complete
-					 * call handle dif to send scsi status
-					 * rather than terminate exchange.
-					 */
-					cmd->state = QLA_TGT_STATE_PROCESSED;
-					ha->tgt.tgt_ops->handle_dif_err(cmd);
-					return;
-				}
-			} else {
-				/* Need to generate a SCSI good completion.
-				 * because FW did not send scsi status.
-				 */
-				status = 0;
-				goto skip_term;
-			}
-			break;
+			qlt_handle_dif_error(vha, cmd, ctio);
+			return;
 		}
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
@@ -3554,7 +3755,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				return;
 		}
 	}
-skip_term:
+
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
 		cmd->trc_flags |= TRC_CTIO_DONE;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index b09445d..c43910b 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -725,7 +725,6 @@ struct qla_tgt_func_tmpl {
 	int (*handle_cmd)(struct scsi_qla_host *, struct qla_tgt_cmd *,
 			unsigned char *, uint32_t, uint8_t, int, int);
 	void (*handle_data)(struct qla_tgt_cmd *);
-	void (*handle_dif_err)(struct qla_tgt_cmd *);
 	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, u64, uint16_t,
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
@@ -750,6 +749,8 @@ struct qla_tgt_func_tmpl {
 
 	/* support routine */
 	void (*srr_get_cur_state)(struct qla_tgt_cmd *, srr_state_op_t op);
+	int (*get_dif_tags)(struct qla_tgt_cmd *cmd, uint16_t *pfw_prot_opts);
+	int (*chk_dif_tags)(uint32_t tag);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
@@ -907,6 +908,23 @@ enum qla_sess_deletion {
 	QLA_SESS_DELETION_IN_PROGRESS	= 2,
 };
 
+enum qla_tgt_prot_op {
+	QLA_PROT_NORMAL  = 0,
+	QLA_PROT_DIN_INSERT,
+	QLA_PROT_DOUT_INSERT,
+	QLA_PROT_DIN_STRIP,
+	QLA_PROT_DOUT_STRIP,
+	QLA_PROT_DIN_PASS,
+	QLA_PROT_DOUT_PASS,
+};
+
+enum qla_tgt_prot_type {
+	QLA_TGT_PROT_TYPE0,
+	QLA_TGT_PROT_TYPE1,
+	QLA_TGT_PROT_TYPE2,
+	QLA_TGT_PROT_TYPE3,
+};
+
 enum trace_flags {
 	TRC_NEW_CMD = BIT_0,
 	TRC_DO_WORK = BIT_1,
@@ -927,6 +945,7 @@ enum trace_flags {
 	TRC_CMD_CHK_STOP = BIT_16,
 	TRC_CMD_FREE = BIT_17,
 	TRC_DATA_IN = BIT_18,
+	TRC_DIF_ERR = BIT_19,
 };
 
 struct qla_tgt_cmd {
@@ -944,7 +963,6 @@ struct qla_tgt_cmd {
 	unsigned int sg_mapped:1;
 	unsigned int free_sg:1;
 	unsigned int write_data_transferred:1;
-	unsigned int ctx_dsd_alloced:1;
 	unsigned int q_full:1;
 	unsigned int term_exchg:1;
 	unsigned int cmd_sent_to_fw:1;
@@ -961,7 +979,6 @@ struct qla_tgt_cmd {
 	enum dma_data_direction dma_data_direction;
 	uint32_t reset_count;
 	int residual;				/* + = over, - = under */
-	int8_t scsi_status;
 
 	uint16_t loop_id;	/* to save extra sess dereferences */
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
@@ -973,9 +990,28 @@ struct qla_tgt_cmd {
 	struct scatterlist *prot_sg;
 	uint32_t prot_sg_cnt;
 	uint32_t blk_sz;
+	uint32_t num_blks;
+
+	uint8_t ctx_dsd_alloced; /* do not covert this field to bit field */
+
+	/* override scsi status in case of ULP does not T10-dif */
+	uint8_t dif_err_code;
+#define DIF_ERR_NONE 0
+#define DIF_ERR_GRD 1
+#define DIF_ERR_REF 2
+#define DIF_ERR_APP 3
+	uint8_t scsi_status;
+	uint8_t sense_key;
+	uint8_t asc;
+	uint8_t ascq;
+
 	struct crc_context *ctx;
+	uint32_t prot_op;			/* qla_tgt_prot_op */
+	uint32_t prot_type;
 	uint8_t  *cdb;
 	uint64_t lba;
+	uint32_t a_ref_tag, e_ref_tag;
+	uint16_t a_guard, e_guard, a_app_tag, e_app_tag;
 
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
@@ -1152,4 +1188,9 @@ extern void qlt_modify_vp_config(struct scsi_qla_host *,
 extern void qlt_logo_completion_handler(fc_port_t *, int);
 extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
+void qlt_set_t10dif_tags(struct qla_tgt_cmd *cmd, struct crc_context *ctx,
+    uint16_t *pfw_prot_opts);
+void qlt_send_resp_ctio(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
+	uint8_t scsi_status, uint8_t sense_key, uint8_t asc, uint8_t ascq);
+
 #endif /* __QLA_TARGET_H */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3fef40b..8facd3d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -490,10 +490,43 @@ static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
 	return 0;
 }
 
+static void tcm_qla2xxx_prot_op(struct qla_tgt_cmd *cmd)
+{
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+
+	switch (se_cmd->prot_op) {
+	case TARGET_PROT_NORMAL:
+		cmd->prot_op = QLA_PROT_NORMAL;
+		break;
+	case TARGET_PROT_DIN_INSERT:
+		cmd->prot_op = QLA_PROT_DIN_INSERT;
+		break;
+	case TARGET_PROT_DOUT_INSERT:
+		cmd->prot_op = QLA_PROT_DOUT_INSERT;
+		break;
+	case TARGET_PROT_DIN_STRIP:
+		cmd->prot_op = QLA_PROT_DIN_STRIP;
+		break;
+	case TARGET_PROT_DOUT_STRIP:
+		cmd->prot_op = QLA_PROT_DOUT_STRIP;
+		break;
+	case TARGET_PROT_DIN_PASS:
+		cmd->prot_op = QLA_PROT_DIN_PASS;
+		break;
+	case TARGET_PROT_DOUT_PASS:
+		cmd->prot_op = QLA_PROT_DOUT_PASS;
+		break;
+	}
+}
+
+static void tcm_qla2xxx_prot_type(struct qla_tgt_cmd *cmd)
+{
+	cmd->prot_type = (Q_TO_SE_CMD(cmd))->prot_type;
+}
+
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -519,6 +552,8 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	tcm_qla2xxx_prot_op(cmd);
+	tcm_qla2xxx_prot_type(cmd);
 	cmd->cdb = se_cmd->t_task_cdb;
 	cmd->lba = se_cmd->t_task_lba;
 
@@ -639,6 +674,80 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 				data_dir, flags);
 }
 
+static int
+tcm_qla2xxx_chk_dif_tags(uint32_t tag)
+{
+	return 0;
+}
+
+/* TODO: Return the type of check needed, similar to SCST */
+
+static int
+tcm_qla2xxx_dif_tags(struct qla_tgt_cmd *cmd, uint16_t *pfw_prot_opts)
+{
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+	uint32_t t32=0;
+
+	if (!(se_cmd->prot_checks & TARGET_DIF_CHECK_GUARD))
+		*pfw_prot_opts |= PO_DISABLE_GUARD_CHECK;
+
+	if (!(se_cmd->prot_checks & TARGET_DIF_CHECK_APPTAG))
+		*pfw_prot_opts |= PO_DIS_APP_TAG_VALD;
+
+        return t32;
+}
+
+static void tcm_qla2xxx_check_dif_err(struct qla_tgt_cmd *cmd)
+{
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+
+	if ((cmd->a_app_tag == 0xffff) &&
+	    ((cmd->prot_type != QLA_TGT_PROT_TYPE3) ||
+	     (cmd->a_ref_tag == 0xffffffff))) {
+		se_cmd->bad_sector = cmd->e_ref_tag;
+		se_cmd->pi_err = 0;
+		return;
+	}
+
+	/* check guard */
+	if (cmd->e_guard != cmd->a_guard) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->lba;
+
+		pr_err("Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba,
+		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+		    cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+
+	/* check ref tag */
+	if (cmd->e_ref_tag != cmd->a_ref_tag) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->e_ref_tag;
+
+		pr_err("Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+			cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba,
+			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+
+	/* check appl tag */
+	if (cmd->e_app_tag != cmd->a_app_tag) {
+		se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+		se_cmd->bad_sector = cmd->lba;
+
+		pr_err("App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
+			cmd->atio.u.isp24.fcp_cmnd.cdb[0], cmd->lba,
+			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard, cmd);
+		goto out;
+	}
+out:
+	return;
+}
+
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
@@ -663,6 +772,10 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 	cmd->vha->tgt_counters.qla_core_ret_ctio++;
+
+	if (cmd->prot_op)
+		tcm_qla2xxx_check_dif_err(cmd);
+
 	if (!cmd->write_data_transferred) {
 		/*
 		 * Check if se_cmd has already been aborted via LUN_RESET, and
@@ -673,6 +786,21 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 			return;
 		}
 
+		switch (cmd->dif_err_code) {
+		case DIF_ERR_GRD:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+			break;
+		case DIF_ERR_REF:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+			break;
+		case DIF_ERR_APP:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+			break;
+		case DIF_ERR_NONE:
+		default:
+			break;
+		}
+
 		if (se_cmd->pi_err)
 			transport_generic_request_failure(se_cmd,
 				se_cmd->pi_err);
@@ -697,27 +825,6 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
-static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
-{
-	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
-
-	/* take an extra kref to prevent cmd free too early.
-	 * need to wait for SCSI status/check condition to
-	 * finish responding generate by transport_generic_request_failure.
-	 */
-	kref_get(&se_cmd->cmd_kref);
-	transport_generic_request_failure(se_cmd, se_cmd->pi_err);
-}
-
-/*
- * Called from qla_target.c:qlt_do_ctio_completion()
- */
-static void tcm_qla2xxx_handle_dif_err(struct qla_tgt_cmd *cmd)
-{
-	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_dif_work);
-	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
-}
-
 /*
  * Called from qla_target.c:qlt_issue_task_mgmt()
  */
@@ -855,6 +962,8 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	tcm_qla2xxx_prot_op(cmd);
+	tcm_qla2xxx_prot_type(cmd);
 	cmd->cdb = se_cmd->t_task_cdb;
 	cmd->lba = se_cmd->t_task_lba;
 
@@ -1844,7 +1953,6 @@ static void tcm_qla2xxx_srr_get_cur_state(struct qla_tgt_cmd *cmd,
 static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.handle_cmd		= tcm_qla2xxx_handle_cmd,
 	.handle_data		= tcm_qla2xxx_handle_data,
-	.handle_dif_err		= tcm_qla2xxx_handle_dif_err,
 	.handle_tmr		= tcm_qla2xxx_handle_tmr,
 	.free_cmd		= tcm_qla2xxx_free_cmd,
 	.free_mcmd		= tcm_qla2xxx_free_mcmd,
@@ -1861,6 +1969,8 @@ static void tcm_qla2xxx_srr_get_cur_state(struct qla_tgt_cmd *cmd,
 	.alloc_cmd		= tcm_qla2xxx_alloc_cmd,
 	.alloc_mgmt_cmd		= tcm_qla2xxx_alloc_mgmt_cmd,
 	.srr_get_cur_state 	= tcm_qla2xxx_srr_get_cur_state,
+	.get_dif_tags		= tcm_qla2xxx_dif_tags,
+	.chk_dif_tags		= tcm_qla2xxx_chk_dif_tags,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
-- 
1.8.3.1

