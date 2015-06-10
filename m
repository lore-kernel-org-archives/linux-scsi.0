From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 9/9] qla2xxx: Add FW resource count in DebugFS.
Date: Wed, 10 Jun 2015 11:05:25 -0400
Message-ID: <1433948725-4073-10-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38735 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965986AbbFJPtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:11 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

DebugFS now will show fw_resource_count node.

FW Resource count

Original TGT exchg count[0]
current TGT exchg count[0]
original Initiator Exchange count[2048]
Current Initiator Exchange count[2048]
Original IOCB count[2078]
Current IOCB count[2067]
MAX VP count[254]
MAX FCF count[0]

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |   13 +++++++--
 drivers/scsi/qla2xxx/qla_dfs.c     |   50 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |    3 +-
 drivers/scsi/qla2xxx/qla_init.c    |   12 +++-----
 drivers/scsi/qla2xxx/qla_mbx.c     |   28 ++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c  |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 +-
 7 files changed, 81 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a87e42b..a47374d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2913,7 +2913,7 @@ struct qlt_hw_data {
 #define MAX_QFULL_CMDS_ALLOC	8192
 #define Q_FULL_THRESH_HOLD_PERCENT 90
 #define Q_FULL_THRESH_HOLD(ha) \
-	((ha->fw_xcb_count/100) * Q_FULL_THRESH_HOLD_PERCENT)
+	((ha->cur_fw_xcb_count/100) * Q_FULL_THRESH_HOLD_PERCENT)
 
 #define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
 
@@ -3273,8 +3273,14 @@ struct qla_hw_data {
 #define RISC_START_ADDRESS_2100 0x1000
 #define RISC_START_ADDRESS_2300 0x800
 #define RISC_START_ADDRESS_2400 0x100000
-	uint16_t	fw_xcb_count;
-	uint16_t	fw_iocb_count;
+
+	uint16_t	orig_fw_tgt_xcb_count;
+	uint16_t	cur_fw_tgt_xcb_count;
+	uint16_t	orig_fw_xcb_count;
+	uint16_t	cur_fw_xcb_count;
+	uint16_t	orig_fw_iocb_count;
+	uint16_t	cur_fw_iocb_count;
+	uint16_t	fw_max_fcf_count;
 
 	uint32_t	fw_shared_ram_start;
 	uint32_t	fw_shared_ram_end;
@@ -3317,6 +3323,7 @@ struct qla_hw_data {
 	struct dentry *dfs_dir;
 	struct dentry *dfs_fce;
         struct dentry *dfs_tgt_counters;
+	struct dentry *dfs_fw_resource_cnt;
 
 	dma_addr_t	fce_dma;
 	void		*fce;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 2f50c08..597abbc 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -13,6 +13,43 @@ static struct dentry *qla2x00_dfs_root;
 static atomic_t qla2x00_dfs_root_count;
 
 static int
+qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
+{
+	struct scsi_qla_host *vha = s->private;
+	struct qla_hw_data *ha = vha->hw;
+
+	seq_puts(s, "FW Resource count\n\n");
+	seq_printf(s, "Original TGT exchg count[%d]\n",
+	    ha->orig_fw_tgt_xcb_count);
+	seq_printf(s, "current TGT exchg count[%d]\n",
+	    ha->cur_fw_tgt_xcb_count);
+	seq_printf(s, "original Initiator Exchange count[%d]\n",
+	    ha->orig_fw_xcb_count);
+	seq_printf(s, "Current Initiator Exchange count[%d]\n",
+	    ha->cur_fw_xcb_count);
+	seq_printf(s, "Original IOCB count[%d]\n", ha->orig_fw_iocb_count);
+	seq_printf(s, "Current IOCB count[%d]\n", ha->cur_fw_iocb_count);
+	seq_printf(s, "MAX VP count[%d]\n", ha->max_npiv_vports);
+	seq_printf(s, "MAX FCF count[%d]\n", ha->fw_max_fcf_count);
+
+	return 0;
+}
+
+static int
+qla_dfs_fw_resource_cnt_open(struct inode *inode, struct file *file)
+{
+	struct scsi_qla_host *vha = inode->i_private;
+	return single_open(file, qla_dfs_fw_resource_cnt_show, vha);
+}
+
+static const struct file_operations dfs_fw_resource_cnt_ops = {
+	.open           = qla_dfs_fw_resource_cnt_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static int
 qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 {
         struct scsi_qla_host *vha = s->private;
@@ -188,6 +225,14 @@ create_dir:
 	atomic_inc(&qla2x00_dfs_root_count);
 
 create_nodes:
+	ha->dfs_fw_resource_cnt = debugfs_create_file("fw_resource_count",
+	    S_IRUSR, ha->dfs_dir, vha, &dfs_fw_resource_cnt_ops);
+	if (!ha->dfs_fw_resource_cnt) {
+		ql_log(ql_log_warn, vha, 0x00fd,
+		    "Unable to create debugFS fw_resource_count node.\n");
+		goto out;
+	}
+
 	ha->dfs_tgt_counters = debugfs_create_file("tgt_counters", S_IRUSR,
 	    ha->dfs_dir, vha, &dfs_tgt_counters_ops);
 	if (!ha->dfs_tgt_counters) {
@@ -212,6 +257,11 @@ qla2x00_dfs_remove(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	if (ha->dfs_fw_resource_cnt) {
+		debugfs_remove(ha->dfs_fw_resource_cnt);
+		ha->dfs_fw_resource_cnt = NULL;
+	}
+
 	if (ha->dfs_tgt_counters) {
 		debugfs_remove(ha->dfs_tgt_counters);
 		ha->dfs_tgt_counters = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7686bfe..1e2a05f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -323,8 +323,7 @@ extern int
 qla2x00_get_id_list(scsi_qla_host_t *, void *, dma_addr_t, uint16_t *);
 
 extern int
-qla2x00_get_resource_cnts(scsi_qla_host_t *, uint16_t *, uint16_t *,
-    uint16_t *, uint16_t *, uint16_t *, uint16_t *);
+qla2x00_get_resource_cnts(scsi_qla_host_t *);
 
 extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6e6cce8..0ea9d89 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1758,10 +1758,10 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 	    (ql2xmultique_tag || ql2xmaxqueues > 1)))
 		req->num_outstanding_cmds = DEFAULT_OUTSTANDING_COMMANDS;
 	else {
-		if (ha->fw_xcb_count <= ha->fw_iocb_count)
-			req->num_outstanding_cmds = ha->fw_xcb_count;
+		if (ha->cur_fw_xcb_count <= ha->cur_fw_iocb_count)
+			req->num_outstanding_cmds = ha->cur_fw_xcb_count;
 		else
-			req->num_outstanding_cmds = ha->fw_iocb_count;
+			req->num_outstanding_cmds = ha->cur_fw_iocb_count;
 	}
 
 	req->outstanding_cmds = kzalloc(sizeof(srb_t *) *
@@ -1856,9 +1856,7 @@ enable_82xx_npiv:
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
-				qla2x00_get_resource_cnts(vha, NULL,
-				    &ha->fw_xcb_count, NULL, &ha->fw_iocb_count,
-				    &ha->max_npiv_vports, NULL);
+				qla2x00_get_resource_cnts(vha);
 
 				/*
 				 * Allocate the array of outstanding commands
@@ -2245,7 +2243,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	if (IS_FWI2_CAPABLE(ha)) {
 		mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 		mid_init_cb->init_cb.execution_throttle =
-		    cpu_to_le16(ha->fw_xcb_count);
+		    cpu_to_le16(ha->cur_fw_xcb_count);
 		/* D-Port Status */
 		if (IS_DPORT_CAPABLE(ha))
 			mid_init_cb->init_cb.firmware_options_1 |=
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b2f713a..d6a81f8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2374,10 +2374,9 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
  *	Kernel context.
  */
 int
-qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
-    uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt,
-    uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports, uint16_t *max_fcfs)
+qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
@@ -2405,19 +2404,16 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 		    mcp->mb[3], mcp->mb[6], mcp->mb[7], mcp->mb[10],
 		    mcp->mb[11], mcp->mb[12]);
 
-		if (cur_xchg_cnt)
-			*cur_xchg_cnt = mcp->mb[3];
-		if (orig_xchg_cnt)
-			*orig_xchg_cnt = mcp->mb[6];
-		if (cur_iocb_cnt)
-			*cur_iocb_cnt = mcp->mb[7];
-		if (orig_iocb_cnt)
-			*orig_iocb_cnt = mcp->mb[10];
-		if (vha->hw->flags.npiv_supported && max_npiv_vports)
-			*max_npiv_vports = mcp->mb[11];
-		if ((IS_QLA81XX(vha->hw) || IS_QLA83XX(vha->hw) ||
-		    IS_QLA27XX(vha->hw)) && max_fcfs)
-			*max_fcfs = mcp->mb[12];
+		ha->orig_fw_tgt_xcb_count =  mcp->mb[1];
+		ha->cur_fw_tgt_xcb_count = mcp->mb[2];
+		ha->cur_fw_xcb_count = mcp->mb[3];
+		ha->orig_fw_xcb_count = mcp->mb[6];
+		ha->cur_fw_iocb_count = mcp->mb[7];
+		ha->orig_fw_iocb_count = mcp->mb[10];
+		if (ha->flags.npiv_supported)
+			ha->max_npiv_vports = mcp->mb[11];
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha))
+			ha->fw_max_fcf_count = mcp->mb[12];
 	}
 
 	return (rval);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ec76da4..5727e1a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2758,7 +2758,7 @@ static void qlt_init_term_exchange(struct scsi_qla_host *vha)
 	struct qla_tgt_cmd *cmd, *tcmd;
 
 	vha->hw->tgt.leak_exchg_thresh_hold =
-	    (vha->hw->fw_xcb_count/100) * LEAK_EXCHG_THRESH_HOLD_PERCENT;
+	    (vha->hw->cur_fw_xcb_count/100) * LEAK_EXCHG_THRESH_HOLD_PERCENT;
 
 	cmd = tcmd = NULL;
 	if (!list_empty(&vha->hw->tgt.q_full_list)) {
@@ -2788,7 +2788,7 @@ static void qlt_chk_exch_leak_thresh_hold(struct scsi_qla_host *vha)
 
 		ql_dbg(ql_dbg_tgt, vha, 0xe079,
 		    "Chip reset due to exchange starvation: %d/%d.\n",
-		    total_leaked, vha->hw->fw_xcb_count);
+		    total_leaked, vha->hw->cur_fw_xcb_count);
 
 		if (IS_P3P_TYPE(vha->hw))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 8c39edb..7dce62a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1592,7 +1592,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	struct qla_tgt_sess *sess = qla_tgt_sess;
 	unsigned char port_name[36];
 	unsigned long flags;
-	int num_tags = (ha->fw_xcb_count) ? ha->fw_xcb_count :
+	int num_tags = (ha->cur_fw_xcb_count) ? ha->cur_fw_xcb_count :
 		       TCM_QLA2XXX_DEFAULT_TAGS;
 
 	lport = vha->vha_tgt.target_lport_ptr;
-- 
1.7.7

