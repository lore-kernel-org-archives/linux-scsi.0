From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target/tcm_qla2xxx: Add/use target_reverse_dma_direction() in target_core_fabric.h
Date: Thu, 22 Aug 2013 05:04:44 +0000
Message-ID: <1377147884-10337-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Reversing the dma_data_direction for pci_map_sg() friends is useful
for other drivers, so move it from tcm_qla2xxx into inline code
within target_core_fabric.h.

Also drop internal usage of equivlient in tcm_qla2xxx fabric code.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  |   31 +++----------------------------
 include/target/target_core_fabric.h |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6a93a91..f790fca 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -497,38 +497,13 @@ static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
 	return 0;
 }
 
-/*
- * The LIO target core uses DMA_TO_DEVICE to mean that data is going
- * to the target (eg handling a WRITE) and DMA_FROM_DEVICE to mean
- * that data is coming from the target (eg handling a READ).  However,
- * this is just the opposite of what we have to tell the DMA mapping
- * layer -- eg when handling a READ, the HBA will have to DMA the data
- * out of memory so it can send it to the initiator, which means we
- * need to use DMA_TO_DEVICE when we map the data.
- */
-static enum dma_data_direction tcm_qla2xxx_mapping_dir(struct se_cmd *se_cmd)
-{
-	if (se_cmd->se_cmd_flags & SCF_BIDI)
-		return DMA_BIDIRECTIONAL;
-
-	switch (se_cmd->data_direction) {
-	case DMA_TO_DEVICE:
-		return DMA_FROM_DEVICE;
-	case DMA_FROM_DEVICE:
-		return DMA_TO_DEVICE;
-	case DMA_NONE:
-	default:
-		return DMA_NONE;
-	}
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
 
 	cmd->bufflen = se_cmd->data_length;
-	cmd->dma_data_direction = tcm_qla2xxx_mapping_dir(se_cmd);
+	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
 	cmd->sg_cnt = se_cmd->t_data_nents;
 	cmd->sg = se_cmd->t_data_sg;
@@ -664,7 +639,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 				struct qla_tgt_cmd, se_cmd);
 
 	cmd->bufflen = se_cmd->data_length;
-	cmd->dma_data_direction = tcm_qla2xxx_mapping_dir(se_cmd);
+	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
 
 	cmd->sg_cnt = se_cmd->t_data_nents;
@@ -688,7 +663,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	cmd->sg = NULL;
 	cmd->sg_cnt = 0;
 	cmd->offset = 0;
-	cmd->dma_data_direction = tcm_qla2xxx_mapping_dir(se_cmd);
+	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 	cmd->aborted = (se_cmd->transport_state & CMD_T_ABORTED);
 
 	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 192eb52..882b650e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -179,4 +179,30 @@ u32	iscsi_get_pr_transport_id_len(struct se_portal_group *, struct se_node_acl *
 char	*iscsi_parse_pr_out_transport_id(struct se_portal_group *, const char *,
 		u32 *, char **);
 
+/*
+ * The LIO target core uses DMA_TO_DEVICE to mean that data is going
+ * to the target (eg handling a WRITE) and DMA_FROM_DEVICE to mean
+ * that data is coming from the target (eg handling a READ).  However,
+ * this is just the opposite of what we have to tell the DMA mapping
+ * layer -- eg when handling a READ, the HBA will have to DMA the data
+ * out of memory so it can send it to the initiator, which means we
+ * need to use DMA_TO_DEVICE when we map the data.
+ */
+static inline enum dma_data_direction
+target_reverse_dma_direction(struct se_cmd *se_cmd)
+{
+	if (se_cmd->se_cmd_flags & SCF_BIDI)
+		return DMA_BIDIRECTIONAL;
+
+	switch (se_cmd->data_direction) {
+	case DMA_TO_DEVICE:
+		return DMA_FROM_DEVICE;
+	case DMA_FROM_DEVICE:
+		return DMA_TO_DEVICE;
+	case DMA_NONE:
+	default:
+		return DMA_NONE;
+	}
+}
+
 #endif /* TARGET_CORE_FABRICH */
-- 
1.7.10.4
