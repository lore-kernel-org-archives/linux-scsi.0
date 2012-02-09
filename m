From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] qla2xxx: Drop legacy pre 24xx target mode support
Date: Thu,  9 Feb 2012 02:45:33 +0000
Message-ID: <1328755534-8668-2-git-send-email-nab@linux-iscsi.org>
References: <1328755534-8668-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1328755534-8668-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes qla2xxx LLD target mode support for pre 24xx
(PCI-X) legacy hardware, and makes qla_target.c only support
>= QLA 24xx (PCI-E) adapters for mainline target LLD code.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Madhuranath Iyengar <mni@risingtidesystems.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_init.c   |    9 -
 drivers/scsi/qla2xxx/qla_isr.c    |    5 -
 drivers/scsi/qla2xxx/qla_mbx.c    |    8 +-
 drivers/scsi/qla2xxx/qla_mid.c    |    4 -
 drivers/scsi/qla2xxx/qla_target.c | 1260 +++++++++----------------------------
 drivers/scsi/qla2xxx/qla_target.h |  133 ----
 6 files changed, 290 insertions(+), 1129 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6a28592..a2d2704 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -592,9 +592,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
-	if (rval == QLA_SUCCESS)
-		qla_tgt_initialize_adapter(vha, ha);
-
 	return (rval);
 }
 
@@ -2326,8 +2323,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	}
 #endif
 
-	qla_tgt_2xxx_config_nvram_stage1(vha, nv);
-
 	/* Reset Initialization control block */
 	memset(icb, 0, ha->init_cb_size);
 
@@ -2402,8 +2397,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
 	}
 
-	qla_tgt_2xxx_config_nvram_stage2(vha, icb);
-
 	/* Prepare nodename */
 	if ((icb->firmware_options[1] & BIT_6) == 0) {
 		/*
@@ -4155,8 +4148,6 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 			vha->flags.online = 1;
 
-			qla_tgt_abort_isp(vha);
-
 			ha->isp_ops->enable_intrs(ha);
 
 			ha->isp_abort_cnt = 0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5ff35ea..accbf08 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1366,10 +1366,6 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			    "Process error entry.\n");
 
 			qla2x00_error_entry(vha, rsp, pkt);
-
-			if (qla_tgt_2xxx_process_response_error(vha, pkt) == 1)
-				break;
-
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 			continue;
@@ -1381,7 +1377,6 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		case CTIO_A64_TYPE:
 		case IMMED_NOTIFY_TYPE:
 		case NOTIFY_ACK_TYPE:
-		case ENABLE_LUN_TYPE:
 		case MODIFY_LUN_TYPE:
 			qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3437e34..3e34f67 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1214,9 +1214,6 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 	ulong dma_size;
 	int rval, left;
 
-	BUILD_BUG_ON(sizeof(struct qla_port_24xx_data) <
-			sizeof(struct qla_port_2xxx_data));
-
 	left = 1;
 	while (left > 0) {
 		dma_size = left * sizeof(*list);
@@ -1245,10 +1242,7 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 		if (rval != QLA_SUCCESS) {
 			if ((mc.mb[0] == MBS_COMMAND_ERROR) &&
 			    (mc.mb[1] == 0xA)) {
-				if (IS_FWI2_CAPABLE(ha))
-					left += le16_to_cpu(mc.mb[2]) / sizeof(struct qla_port_24xx_data);
-				else
-					left += le16_to_cpu(mc.mb[2]) / sizeof(struct qla_port_2xxx_data);
+				left += le16_to_cpu(mc.mb[2]) / sizeof(struct qla_port_24xx_data);
 				goto restart;
 			}
 			goto out_free;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 4ada731..2d1e5b6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -302,10 +302,6 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	if (ret)
 		return ret;
 
-	/* Enable target response to SCSI bus. */
-	if (qla_tgt_mode_enabled(vha))
-		qla_tgt_2xxx_send_enable_lun(vha, true);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 51de953..90bb55e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -92,9 +92,6 @@ enum fcp_resp_rsp_codes {
  *     cross those functions boundaries, except tgt_stop, which
  *     additionally protected by irq_cmd_count.
  */
-
-static int __qla_tgt_24xx_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
-
 /* Predefs for callbacks handed to qla2xxx LLD */
 static void qla_tgt_24xx_atio_pkt(struct scsi_qla_host *ha, atio_from_isp_t *pkt);
 static void qla_tgt_response_pkt(struct scsi_qla_host *ha, response_t *pkt);
@@ -159,6 +156,7 @@ static inline
 struct scsi_qla_host *qla_tgt_find_host_by_d_id(struct scsi_qla_host *vha, uint8_t *d_id)
 {
 	struct qla_hw_data *ha = vha->hw;
+	uint8_t vp_idx;
 
 	if ((vha->d_id.b.area != d_id[1]) || (vha->d_id.b.domain != d_id[0]))
 		return NULL;
@@ -166,13 +164,10 @@ struct scsi_qla_host *qla_tgt_find_host_by_d_id(struct scsi_qla_host *vha, uint8
 	if (vha->d_id.b.al_pa == d_id[2])
 		return vha;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		uint8_t vp_idx;
-		BUG_ON(ha->tgt_vp_map == NULL);
-		vp_idx = ha->tgt_vp_map[d_id[2]].idx;
-		if (likely(test_bit(vp_idx, ha->vp_idx_map)))
-			return ha->tgt_vp_map[vp_idx].vha;
-	}
+	BUG_ON(ha->tgt_vp_map == NULL);
+	vp_idx = ha->tgt_vp_map[d_id[2]].idx;
+	if (likely(test_bit(vp_idx, ha->vp_idx_map)))
+		return ha->tgt_vp_map[vp_idx].vha;
 
 	return NULL;
 }
@@ -185,19 +180,15 @@ struct scsi_qla_host *qla_tgt_find_host_by_vp_idx(struct scsi_qla_host *vha, uin
 	if (vha->vp_idx == vp_idx)
 		return vha;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		BUG_ON(ha->tgt_vp_map == NULL);
-		if (likely(test_bit(vp_idx, ha->vp_idx_map)))
-			return ha->tgt_vp_map[vp_idx].vha;
-	}
+	BUG_ON(ha->tgt_vp_map == NULL);
+	if (likely(test_bit(vp_idx, ha->vp_idx_map)))
+		return ha->tgt_vp_map[vp_idx].vha;
 
 	return NULL;
 }
 
 void qla_tgt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha, atio_from_isp_t *atio)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (atio->u.raw.entry_type) {
 	case ATIO_TYPE7:
 	{
@@ -218,20 +209,18 @@ void qla_tgt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha, atio_from_isp_t *a
 	case IMMED_NOTIFY_TYPE:
 	{
 		struct scsi_qla_host *host = vha;
+		imm_ntfy_from_isp_t *entry = (imm_ntfy_from_isp_t *)atio;
 
-		if (IS_FWI2_CAPABLE(ha)) {
-			imm_ntfy_from_isp_t *entry = (imm_ntfy_from_isp_t *)atio;
-			if ((entry->u.isp24.vp_index != 0xFF) &&
-			    (entry->u.isp24.nport_handle != 0xFFFF)) {
-				host = qla_tgt_find_host_by_vp_idx(vha,
-							entry->u.isp24.vp_index);
-				if (unlikely(!host)) {
-					printk(KERN_ERR "qla_target(%d): Received "
-						"ATIO (IMMED_NOTIFY_TYPE) "
-						"with unknown vp_index %d\n",
-						vha->vp_idx, entry->u.isp24.vp_index);
-					break;
-				}
+		if ((entry->u.isp24.vp_index != 0xFF) &&
+		    (entry->u.isp24.nport_handle != 0xFFFF)) {
+			host = qla_tgt_find_host_by_vp_idx(vha,
+						entry->u.isp24.vp_index);
+			if (unlikely(!host)) {
+				printk(KERN_ERR "qla_target(%d): Received "
+					"ATIO (IMMED_NOTIFY_TYPE) "
+					"with unknown vp_index %d\n",
+					vha->vp_idx, entry->u.isp24.vp_index);
+				break;
 			}
 		}
 		qla_tgt_24xx_atio_pkt(host, atio);
@@ -249,8 +238,6 @@ void qla_tgt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha, atio_from_isp_t *a
 
 void qla_tgt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 {
-	struct qla_hw_data *ha = vha->hw;
-
 	switch (pkt->entry_type) {
 	case CTIO_TYPE7:
 	{
@@ -270,16 +257,15 @@ void qla_tgt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 	case IMMED_NOTIFY_TYPE:
 	{
 		struct scsi_qla_host *host = vha;
-		if (IS_FWI2_CAPABLE(ha)) {
-			imm_ntfy_from_isp_t *entry = (imm_ntfy_from_isp_t *)pkt;
-			host = qla_tgt_find_host_by_vp_idx(vha, entry->u.isp24.vp_index);
-			if (unlikely(!host)) {
-				printk(KERN_ERR "qla_target(%d): Response pkt "
-					"(IMMED_NOTIFY_TYPE) received, "
-					"with unknown vp_index %d\n",
-					vha->vp_idx, entry->u.isp24.vp_index);
-				break;
-			}
+		imm_ntfy_from_isp_t *entry = (imm_ntfy_from_isp_t *)pkt;
+
+		host = qla_tgt_find_host_by_vp_idx(vha, entry->u.isp24.vp_index);
+		if (unlikely(!host)) {
+			printk(KERN_ERR "qla_target(%d): Response pkt "
+				"(IMMED_NOTIFY_TYPE) received, "
+				"with unknown vp_index %d\n",
+				vha->vp_idx, entry->u.isp24.vp_index);
+			break;
 		}
 		qla_tgt_response_pkt(host, pkt);
 		break;
@@ -288,19 +274,18 @@ void qla_tgt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 	case NOTIFY_ACK_TYPE:
 	{
 		struct scsi_qla_host *host = vha;
-		if (IS_FWI2_CAPABLE(ha)) {
-			nack_to_isp_t *entry = (nack_to_isp_t *)pkt;
-			if (0xFF != entry->u.isp24.vp_index) {
-				host = qla_tgt_find_host_by_vp_idx(vha,
-						entry->u.isp24.vp_index);
-				if (unlikely(!host)) {
-					printk(KERN_ERR "qla_target(%d): Response "
-						"pkt (NOTIFY_ACK_TYPE) "
-						"received, with unknown "
-						"vp_index %d\n", vha->vp_idx,
-						entry->u.isp24.vp_index);
-					break;
-				}
+		nack_to_isp_t *entry = (nack_to_isp_t *)pkt;
+
+		if (0xFF != entry->u.isp24.vp_index) {
+			host = qla_tgt_find_host_by_vp_idx(vha,
+					entry->u.isp24.vp_index);
+			if (unlikely(!host)) {
+				printk(KERN_ERR "qla_target(%d): Response "
+					"pkt (NOTIFY_ACK_TYPE) "
+					"received, with unknown "
+					"vp_index %d\n", vha->vp_idx,
+					entry->u.isp24.vp_index);
+				break;
 			}
 		}
 		qla_tgt_response_pkt(host, pkt);
@@ -433,16 +418,14 @@ static int qla_tgt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	int res = 0;
 	uint8_t s_id[3];
 	imm_ntfy_from_isp_t *n = (imm_ntfy_from_isp_t *)iocb;
+	atio_from_isp_t *a = (atio_from_isp_t *)iocb;
 
 	memset(&s_id, 0, 3);
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		loop_id = le16_to_cpu(n->u.isp24.nport_handle);
-		s_id[0] = n->u.isp24.port_id[0];
-		s_id[1] = n->u.isp24.port_id[1];
-		s_id[2] = n->u.isp24.port_id[2];
-	} else
-		loop_id = GET_TARGET_ID(ha, (atio_from_isp_t *)n);
+	loop_id = le16_to_cpu(n->u.isp24.nport_handle);
+	s_id[0] = n->u.isp24.port_id[0];
+	s_id[1] = n->u.isp24.port_id[1];
+	s_id[2] = n->u.isp24.port_id[2];
 
 	if (loop_id == 0xFFFF) {
 #warning FIXME: Re-enable Global event handling..
@@ -495,12 +478,7 @@ static int qla_tgt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 		sess->port_name[6], sess->port_name[7],
 		mcmd, loop_id);
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		atio_from_isp_t *a = (atio_from_isp_t *)iocb;
-		lun = a->u.isp24.fcp_cmnd.lun;
-	} else
-		lun = swab16(le16_to_cpu(n->u.isp2x.lun));
-
+	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	return qla_tgt_issue_task_mgmt(sess, unpacked_lun, mcmd,
@@ -602,6 +580,7 @@ out_free_id_list:
 static bool qla_tgt_check_fcport_exist(struct scsi_qla_host *vha, struct qla_tgt_sess *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
+	struct qla_port_24xx_data *pmap24;
 	bool res, found = false;
 	int rc, i;
 	uint16_t loop_id = 0xFFFF; /* to eliminate compiler's warning */
@@ -620,43 +599,21 @@ retry:
 		goto out;
 	}
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		struct qla_port_24xx_data *pmap24 = pmap;
-
-		entries = pmap_len/sizeof(*pmap24);
-
-		for (i = 0; i < entries; ++i) {
-			if ((sess->port_name[0] == pmap24[i].port_name[0]) &&
-			    (sess->port_name[1] == pmap24[i].port_name[1]) &&
-			    (sess->port_name[2] == pmap24[i].port_name[2]) &&
-			    (sess->port_name[3] == pmap24[i].port_name[3]) &&
-			    (sess->port_name[4] == pmap24[i].port_name[4]) &&
-			    (sess->port_name[5] == pmap24[i].port_name[5]) &&
-			    (sess->port_name[6] == pmap24[i].port_name[6]) &&
-			    (sess->port_name[7] == pmap24[i].port_name[7])) {
-				loop_id = le16_to_cpu(pmap24[i].loop_id);
-				found = true;
-				break;
-			}
-		}
-	} else {
-		struct qla_port_2xxx_data *pmap2x = pmap;
-
-		entries = pmap_len/sizeof(*pmap2x);
-
-		for (i = 0; i < entries; ++i) {
-			if ((sess->port_name[0] == pmap2x[i].port_name[0]) &&
-			    (sess->port_name[1] == pmap2x[i].port_name[1]) &&
-			    (sess->port_name[2] == pmap2x[i].port_name[2]) &&
-			    (sess->port_name[3] == pmap2x[i].port_name[3]) &&
-			    (sess->port_name[4] == pmap2x[i].port_name[4]) &&
-			    (sess->port_name[5] == pmap2x[i].port_name[5]) &&
-			    (sess->port_name[6] == pmap2x[i].port_name[6]) &&
-			    (sess->port_name[7] == pmap2x[i].port_name[7])) {
-				loop_id = le16_to_cpu(pmap2x[i].loop_id);
-				found = true;
-				break;
-			}
+	pmap24 = pmap;
+	entries = pmap_len/sizeof(*pmap24);
+
+	for (i = 0; i < entries; ++i) {
+		if ((sess->port_name[0] == pmap24[i].port_name[0]) &&
+		    (sess->port_name[1] == pmap24[i].port_name[1]) &&
+		    (sess->port_name[2] == pmap24[i].port_name[2]) &&
+		    (sess->port_name[3] == pmap24[i].port_name[3]) &&
+		    (sess->port_name[4] == pmap24[i].port_name[4]) &&
+		    (sess->port_name[5] == pmap24[i].port_name[5]) &&
+		    (sess->port_name[6] == pmap24[i].port_name[6]) &&
+		    (sess->port_name[7] == pmap24[i].port_name[7])) {
+			loop_id = le16_to_cpu(pmap24[i].loop_id);
+			found = true;
+			break;
 		}
 	}
 
@@ -1149,54 +1106,6 @@ static int qla_tgt_sched_sess_work(struct qla_tgt *tgt, int type,
 
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
- * This function issues a modify LUN IOCB to ISP 2xxx to change or modify
- * the command count.
- */
-static void qla_tgt_2xxx_send_modify_lun(struct scsi_qla_host *vha, int cmd_count,
-	int imm_count)
-{
-	struct qla_hw_data *ha = vha->hw;
-	modify_lun_t *pkt;
-
-	printk(KERN_INFO "Sending MODIFY_LUN (ha=%p, cmd=%d, imm=%d)\n",
-		  ha, cmd_count, imm_count);
-
-	/* Sending marker isn't necessary, since we called from ISR */
-
-	pkt = (modify_lun_t *)qla2x00_req_pkt(vha);
-	if (!pkt) {
-		printk(KERN_ERR "qla_target(%d): %s failed: unable to allocate "
-			"request packet\n", vha->vp_idx, __func__);
-		return;
-	}
-
-	ha->qla_tgt->modify_lun_expected++;
-
-	pkt->entry_type = MODIFY_LUN_TYPE;
-	pkt->entry_count = 1;
-	if (cmd_count < 0) {
-		pkt->operators = MODIFY_LUN_CMD_SUB;	/* Subtract from command count */
-		pkt->command_count = -cmd_count;
-	} else if (cmd_count > 0) {
-		pkt->operators = MODIFY_LUN_CMD_ADD;	/* Add to command count */
-		pkt->command_count = cmd_count;
-	}
-
-	if (imm_count < 0) {
-		pkt->operators |= MODIFY_LUN_IMM_SUB;
-		pkt->immed_notify_count = -imm_count;
-	} else if (imm_count > 0) {
-		pkt->operators |= MODIFY_LUN_IMM_ADD;
-		pkt->immed_notify_count = imm_count;
-	}
-
-	pkt->timeout = 0;	/* Use default */
-
-	qla2x00_isp_cmd(vha, vha->req);
-}
-
-/*
- * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
 static void qla_tgt_send_notify_ack(struct scsi_qla_host *vha,
 	imm_ntfy_from_isp_t *ntfy,
@@ -1228,55 +1137,26 @@ static void qla_tgt_send_notify_ack(struct scsi_qla_host *vha,
 
 	nack = (nack_to_isp_t *)pkt;
 	nack->ox_id = ntfy->ox_id;
-	if (IS_FWI2_CAPABLE(ha)) {
-		nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
-		if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
-			nack->u.isp24.flags = ntfy->u.isp24.flags &
-				__constant_cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
-		}
-		nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
-		nack->u.isp24.status = ntfy->u.isp24.status;
-		nack->u.isp24.status_subcode = ntfy->u.isp24.status_subcode;
-		nack->u.isp24.exchange_address = ntfy->u.isp24.exchange_address;
-		nack->u.isp24.srr_rel_offs = ntfy->u.isp24.srr_rel_offs;
-		nack->u.isp24.srr_ui = ntfy->u.isp24.srr_ui;
-		nack->u.isp24.srr_flags = cpu_to_le16(srr_flags);
-		nack->u.isp24.srr_reject_code = srr_reject_code;
-		nack->u.isp24.srr_reject_code_expl = srr_explan;
-		nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
-
-		ql_dbg(ql_dbg_tgt_pkt, vha, 0xe201,
-			"qla_target(%d): Sending 24xx Notify Ack %d\n",
-			vha->vp_idx, nack->u.isp24.status);
-	} else {
-		SET_TARGET_ID(ha, nack->u.isp2x.target,
-			GET_TARGET_ID(ha, (atio_from_isp_t *)ntfy));
-		nack->u.isp2x.status = ntfy->u.isp2x.status;
-		nack->u.isp2x.task_flags = ntfy->u.isp2x.task_flags;
-		nack->u.isp2x.seq_id = ntfy->u.isp2x.seq_id;
-		/* Do not increment here, the chip isn't decrementing */
-		/* nack->u.isp2x.flags = __constant_cpu_to_le16(NOTIFY_ACK_RES_COUNT); */
-		nack->u.isp2x.flags |= cpu_to_le16(add_flags);
-		nack->u.isp2x.srr_rx_id = ntfy->u.isp2x.srr_rx_id;
-		nack->u.isp2x.srr_rel_offs = ntfy->u.isp2x.srr_rel_offs;
-		nack->u.isp2x.srr_ui = ntfy->u.isp2x.srr_ui;
-		nack->u.isp2x.srr_flags = cpu_to_le16(srr_flags);
-		nack->u.isp2x.srr_reject_code = cpu_to_le16(srr_reject_code);
-		nack->u.isp2x.srr_reject_code_expl = srr_explan;
-
-		if (resp_code_valid) {
-			nack->u.isp2x.resp_code = cpu_to_le16(resp_code);
-			nack->u.isp2x.flags |= __constant_cpu_to_le16(
-				NOTIFY_ACK_TM_RESP_CODE_VALID);
-		}
 
-		ql_dbg(ql_dbg_tgt_pkt, vha, 0xe200, "qla_target(%d): Sending Notify Ack"
-			" Seq %#x -> I %#x St %#x RC %#x\n", vha->vp_idx,
-			le16_to_cpu(ntfy->u.isp2x.seq_id),
-			GET_TARGET_ID(ha, (atio_from_isp_t *)ntfy),
-			le16_to_cpu(ntfy->u.isp2x.status),
-			le16_to_cpu(nack->u.isp2x.resp_code));
-	}
+	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
+	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
+		nack->u.isp24.flags = ntfy->u.isp24.flags &
+			__constant_cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
+	}
+	nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
+	nack->u.isp24.status = ntfy->u.isp24.status;
+	nack->u.isp24.status_subcode = ntfy->u.isp24.status_subcode;
+	nack->u.isp24.exchange_address = ntfy->u.isp24.exchange_address;
+	nack->u.isp24.srr_rel_offs = ntfy->u.isp24.srr_rel_offs;
+	nack->u.isp24.srr_ui = ntfy->u.isp24.srr_ui;
+	nack->u.isp24.srr_flags = cpu_to_le16(srr_flags);
+	nack->u.isp24.srr_reject_code = srr_reject_code;
+	nack->u.isp24.srr_reject_code_expl = srr_explan;
+	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
+
+	ql_dbg(ql_dbg_tgt_pkt, vha, 0xe201,
+		"qla_target(%d): Sending 24xx Notify Ack %d\n",
+		vha->vp_idx, nack->u.isp24.status);
 
 	qla2x00_isp_cmd(vha, vha->req);
 }
@@ -1552,20 +1432,15 @@ void qla_tgt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		mcmd->flags);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (IS_FWI2_CAPABLE(ha)) {
-		if (mcmd->flags == QLA24XX_MGMT_SEND_NACK)
-			qla_tgt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
-				0, 0, 0, 0, 0, 0);
-		else {
-			if (mcmd->se_tmr_req->function == ABORT_TASK)
-				qla_tgt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
-					mcmd->fc_tm_rsp, false);
-			else
-				qla_tgt_24xx_send_task_mgmt_ctio(vha, mcmd, mcmd->fc_tm_rsp);
-		}
-	} else {
-		qla_tgt_send_notify_ack(vha, (void *)&mcmd->orig_iocb,
-			0, mcmd->fc_tm_rsp, 1, 0, 0, 0);
+	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK)
+		qla_tgt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
+			0, 0, 0, 0, 0, 0);
+	else {
+		if (mcmd->se_tmr_req->function == ABORT_TASK)
+			qla_tgt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
+				mcmd->fc_tm_rsp, false);
+		else
+			qla_tgt_24xx_send_task_mgmt_ctio(vha, mcmd, mcmd->fc_tm_rsp);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -1620,12 +1495,8 @@ static int qla_tgt_check_reserve_free_req(struct scsi_qla_host *vha, uint32_t re
 	uint32_t cnt;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
-		if (IS_FWI2_CAPABLE(ha))
-			cnt = (uint16_t)RD_REG_DWORD(
-				    &reg->isp24.req_q_out);
-		else
-			cnt = qla2x00_debounce_register(
-				    ISP_REQ_Q_OUT(ha, &reg->isp));
+		cnt = (uint16_t)RD_REG_DWORD(&reg->isp24.req_q_out);
+
 		ql_dbg(ql_dbg_tgt, vha, 0xe00d, "Request ring circled: cnt=%d, "
 			"vha->->ring_index=%d, vha->req->cnt=%d, req_cnt=%d\n",
 			cnt, vha->req->ring_index, vha->req->cnt, req_cnt);
@@ -1693,46 +1564,6 @@ static inline uint32_t qla_tgt_make_handle(struct scsi_qla_host *vha)
 }
 
 /* ha->hardware_lock supposed to be held on entry */
-static void qla_tgt_2xxx_build_ctio_pkt(struct qla_tgt_prm *prm, struct scsi_qla_host *vha)
-{
-	uint32_t h;
-	ctio_to_2xxx_t *pkt;
-	atio_from_isp_t *atio = &prm->cmd->atio;
-	struct qla_hw_data *ha = vha->hw;
-
-	pkt = (ctio_to_2xxx_t *)vha->req->ring_ptr;
-	prm->pkt = pkt;
-	memset(pkt, 0, sizeof(*pkt));
-
-	if (prm->tgt->tgt_enable_64bit_addr)
-		pkt->entry_type = CTIO_A64_TYPE;
-	else
-		pkt->entry_type = CONTINUE_TGT_IO_TYPE;
-
-	pkt->entry_count = (uint8_t)prm->req_cnt;
-
-	h = qla_tgt_make_handle(vha);
-	if (h != QLA_TGT_NULL_HANDLE)
-		ha->cmds[h-1] = prm->cmd;
-
-	pkt->handle = h | CTIO_COMPLETION_HANDLE_MARK;
-	pkt->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
-
-	/* Set initiator ID */
-	h = GET_TARGET_ID(ha, atio);
-	SET_TARGET_ID(ha, pkt->target, h);
-
-	pkt->rx_id = atio->u.isp2x.rx_id;
-	pkt->relative_offset = cpu_to_le32(prm->cmd->offset);
-
-	ql_dbg(ql_dbg_tgt_pkt, vha, 0xe202, "qla_target(%d): handle(se_cmd) -> %08x, "
-		"timeout %d L %#x -> I %#x E %#x\n", vha->vp_idx,
-		pkt->handle, QLA_TGT_TIMEOUT,
-		le16_to_cpu(atio->u.isp2x.lun),
-		GET_TARGET_ID(ha, atio), pkt->rx_id);
-}
-
-/* ha->hardware_lock supposed to be held on entry */
 static int qla_tgt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm, struct scsi_qla_host *vha)
 {
 	uint32_t h;
@@ -1847,43 +1678,24 @@ static void qla_tgt_load_cont_data_segments(struct qla_tgt_prm *prm, struct scsi
 static void qla_tgt_load_data_segments(struct qla_tgt_prm *prm,
 	struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
 	int cnt;
 	uint32_t *dword_ptr;
 	int enable_64bit_addressing = prm->tgt->tgt_enable_64bit_addr;
+	ctio7_to_24xx_t *pkt24 = (ctio7_to_24xx_t *)prm->pkt;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		ctio7_to_24xx_t *pkt24 = (ctio7_to_24xx_t *)prm->pkt;
+	ql_dbg(ql_dbg_tgt, vha, 0xe00f,
+		"iocb->scsi_status=%x, iocb->flags=%x\n",
+		le16_to_cpu(pkt24->u.status0.scsi_status),
+		le16_to_cpu(pkt24->u.status0.flags));
 
-		ql_dbg(ql_dbg_tgt, vha, 0xe00f,
-			"iocb->scsi_status=%x, iocb->flags=%x\n",
-			le16_to_cpu(pkt24->u.status0.scsi_status),
-			le16_to_cpu(pkt24->u.status0.flags));
+	pkt24->u.status0.transfer_length = cpu_to_le32(prm->cmd->bufflen);
 
-		pkt24->u.status0.transfer_length = cpu_to_le32(prm->cmd->bufflen);
+	/* Setup packet address segment pointer */
+	dword_ptr = pkt24->u.status0.dseg_0_address;
 
-		/* Setup packet address segment pointer */
-		dword_ptr = pkt24->u.status0.dseg_0_address;
-
-		/* Set total data segment count */
-		if (prm->seg_cnt)
-			pkt24->dseg_count = cpu_to_le16(prm->seg_cnt);
-	} else {
-		ctio_to_2xxx_t *pkt2x = (ctio_to_2xxx_t *)prm->pkt;
-
-		ql_dbg(ql_dbg_tgt_pkt, vha, 0xe204,
-			"iocb->scsi_status=%x, iocb->flags=%x\n",
-			le16_to_cpu(pkt2x->scsi_status), le16_to_cpu(pkt2x->flags));
-
-		pkt2x->transfer_length = cpu_to_le32(prm->cmd->bufflen);
-
-		/* Setup packet address segment pointer */
-		dword_ptr = &pkt2x->dseg_0_address;
-
-		/* Set total data segment count */
-		if (prm->seg_cnt)
-			pkt2x->dseg_count = cpu_to_le16(prm->seg_cnt);
-	}
+	/* Set total data segment count */
+	if (prm->seg_cnt)
+		pkt24->dseg_count = cpu_to_le16(prm->seg_cnt);
 
 	if (prm->seg_cnt == 0) {
 		/* No data transfer */
@@ -2032,135 +1844,6 @@ static inline int qla_tgt_need_explicit_conf(struct qla_hw_data *ha,
 		return ha->enable_explicit_conf && cmd->conf_compl_supported;
 }
 
-static void qla_tgt_2xxx_init_ctio_to_isp(ctio_from_2xxx_t *ctio_m1,
-	struct qla_tgt_prm *prm, struct scsi_qla_host *vha)
-{
-	struct qla_hw_data *ha = vha->hw;
-
-	prm->sense_buffer_len = min((uint32_t)prm->sense_buffer_len,
-				    (uint32_t)sizeof(ctio_m1->sense_data));
-
-	ctio_m1->flags = __constant_cpu_to_le16(OF_SSTS | OF_FAST_POST |
-				     OF_NO_DATA | OF_SS_MODE_1);
-	ctio_m1->flags |= __constant_cpu_to_le16(OF_INC_RC);
-	if (qla_tgt_need_explicit_conf(ha, prm->cmd, 0)) {
-		ctio_m1->flags |= __constant_cpu_to_le16(OF_EXPL_CONF |
-					OF_CONF_REQ);
-	}
-	ctio_m1->scsi_status = cpu_to_le16(prm->rq_result);
-	ctio_m1->residual = cpu_to_le32(prm->residual);
-	if (QLA_TGT_SENSE_VALID(prm->sense_buffer)) {
-		if (qla_tgt_need_explicit_conf(ha, prm->cmd, 1)) {
-			ctio_m1->flags |= __constant_cpu_to_le16(OF_EXPL_CONF |
-						OF_CONF_REQ);
-		}
-		ctio_m1->scsi_status |= __constant_cpu_to_le16(
-						SS_SENSE_LEN_VALID);
-		ctio_m1->sense_length = cpu_to_le16(prm->sense_buffer_len);
-		memcpy(ctio_m1->sense_data, prm->sense_buffer,
-		       prm->sense_buffer_len);
-	} else {
-		memset(ctio_m1->sense_data, 0, sizeof(ctio_m1->sense_data));
-		ctio_m1->sense_length = 0;
-	}
-
-	/* Sense with len > 26, is it possible ??? */
-
-	return;
-}
-
-static int __qla_tgt_2xxx_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
-	uint8_t scsi_status)
-{
-	struct scsi_qla_host *vha = cmd->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_prm prm;
-	ctio_to_2xxx_t *pkt;
-	unsigned long flags = 0;
-	uint32_t full_req_cnt = 0;
-	int res;
-
-	memset(&prm, 0, sizeof(prm));
-
-	res = qla_tgt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status, &full_req_cnt);
-	if (unlikely(res != 0)) {
-		if (res == QLA_TGT_PRE_XMIT_RESP_CMD_ABORTED)
-			return 0;
-
-		return res;
-	}
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-
-	/* Does F/W have an IOCBs for this request */
-	res = qla_tgt_check_reserve_free_req(vha, full_req_cnt);
-	if (unlikely(res))
-		goto out_unmap_unlock;
-
-	qla_tgt_2xxx_build_ctio_pkt(&prm, cmd->vha);
-	pkt = (ctio_to_2xxx_t *)prm.pkt;
-
-	if (qla_tgt_has_data(cmd) && (xmit_type & QLA_TGT_XMIT_DATA)) {
-		pkt->flags |= __constant_cpu_to_le16(OF_FAST_POST | OF_DATA_IN);
-		pkt->flags |= __constant_cpu_to_le16(OF_INC_RC);
-
-		qla_tgt_load_data_segments(&prm, vha);
-
-		if (prm.add_status_pkt == 0) {
-			if (xmit_type & QLA_TGT_XMIT_STATUS) {
-				pkt->scsi_status = cpu_to_le16(prm.rq_result);
-				pkt->residual = cpu_to_le32(prm.residual);
-				pkt->flags |= __constant_cpu_to_le16(OF_SSTS);
-				if (qla_tgt_need_explicit_conf(ha, cmd, 0)) {
-					pkt->flags |= __constant_cpu_to_le16(
-							OF_EXPL_CONF |
-							OF_CONF_REQ);
-				}
-			}
-		} else {
-			/*
-			 * We have already made sure that there is sufficient
-			 * amount of request entries to not drop HW lock in
-			 * req_pkt().
-			 */
-			ctio_from_2xxx_t *ctio_m1 =
-				(ctio_from_2xxx_t *)qla_tgt_get_req_pkt(vha);
-
-			ql_dbg(ql_dbg_tgt, vha, 0xe015, "%s", "Building"
-				" additional status packet");
-
-			memcpy(ctio_m1, pkt, sizeof(*ctio_m1));
-			ctio_m1->entry_count = 1;
-			ctio_m1->dseg_count = 0;
-
-			/* Real finish is ctio_m1's finish */
-			pkt->handle |= CTIO_INTERMEDIATE_HANDLE_MARK;
-			pkt->flags &= ~__constant_cpu_to_le16(OF_INC_RC);
-
-			qla_tgt_2xxx_init_ctio_to_isp(ctio_m1, &prm, cmd->vha);
-		}
-	} else
-		qla_tgt_2xxx_init_ctio_to_isp((ctio_from_2xxx_t *)pkt,
-					&prm, cmd->vha);
-
-	cmd->state = QLA_TGT_STATE_PROCESSED; /* Mid-level is done processing */
-
-	ql_dbg(ql_dbg_tgt, vha, 0xe016, "Xmitting CTIO7 response pkt for 2xxx:"
-			" %p scsi_status: 0x%02x\n", pkt, scsi_status);
-
-	qla2x00_isp_cmd(vha, vha->req);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	return 0;
-
-out_unmap_unlock:
-	if (cmd->sg_mapped)
-		qla_tgt_unmap_sg(vha, cmd);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	return res;
-}
-
 #ifdef CONFIG_QLA_TGT_DEBUG_SRR
 /*
  *  Original taken from the XFS code
@@ -2245,21 +1928,6 @@ static void qla_tgt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
 static inline void qla_tgt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type) {}
 #endif
 
-int qla_tgt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type, uint8_t scsi_status)
-{
-	qla_tgt_check_srr_debug(cmd, &xmit_type);
-
-	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe017, "is_send_status=%d,"
-		" cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d",
-		(xmit_type & QLA_TGT_XMIT_STATUS) ? 1 : 0, cmd->bufflen,
-		cmd->sg_cnt, cmd->dma_data_direction);
-
-	return (IS_FWI2_CAPABLE(cmd->tgt->ha)) ?
-		__qla_tgt_24xx_xmit_response(cmd, xmit_type, scsi_status) :
-		__qla_tgt_2xxx_xmit_response(cmd, xmit_type, scsi_status);
-}
-EXPORT_SYMBOL(qla_tgt_xmit_response);
-
 static void qla_tgt_24xx_init_ctio_to_isp(ctio7_to_24xx_t *ctio,
 	struct qla_tgt_prm *prm)
 {
@@ -2320,8 +1988,7 @@ skip_explict_conf:
  * Callback to setup response of xmit_type of QLA_TGT_XMIT_DATA and * QLA_TGT_XMIT_STATUS
  * for >= 24xx silicon
  */
-static int __qla_tgt_24xx_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
-	uint8_t scsi_status)
+int qla_tgt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type, uint8_t scsi_status)
 {
 	struct scsi_qla_host *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
@@ -2332,6 +1999,12 @@ static int __qla_tgt_24xx_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	int res;
 
 	memset(&prm, 0, sizeof(prm));
+	qla_tgt_check_srr_debug(cmd, &xmit_type);
+
+	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe017, "is_send_status=%d,"
+		" cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d",
+		(xmit_type & QLA_TGT_XMIT_STATUS) ? 1 : 0, cmd->bufflen,
+		cmd->sg_cnt, cmd->dma_data_direction);
 
 	res = qla_tgt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status, &full_req_cnt);
 	if (unlikely(res != 0)) {
@@ -2421,9 +2094,11 @@ out_unmap_unlock:
 
 	return res;
 }
+EXPORT_SYMBOL(qla_tgt_xmit_response);
 
 int qla_tgt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 {
+	ctio7_to_24xx_t *pkt;
 	struct scsi_qla_host *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = cmd->tgt;
@@ -2454,22 +2129,13 @@ int qla_tgt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	if (res != 0)
 		goto out_unlock_free_unmap;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		ctio7_to_24xx_t *pkt;
-		res = qla_tgt_24xx_build_ctio_pkt(&prm, vha);
-		if (unlikely(res != 0))
-			goto out_unlock_free_unmap;
-		pkt = (ctio7_to_24xx_t *)prm.pkt;
-		pkt->u.status0.flags |= __constant_cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
-				CTIO7_FLAGS_STATUS_MODE_0);
-		qla_tgt_load_data_segments(&prm, vha);
-	} else {
-		ctio_to_2xxx_t *pkt;
-		qla_tgt_2xxx_build_ctio_pkt(&prm, vha);
-		pkt = (ctio_to_2xxx_t *)prm.pkt;
-		pkt->flags = __constant_cpu_to_le16(OF_FAST_POST | OF_DATA_OUT);
-		qla_tgt_load_data_segments(&prm, vha);
-	}
+	res = qla_tgt_24xx_build_ctio_pkt(&prm, vha);
+	if (unlikely(res != 0))
+		goto out_unlock_free_unmap;
+	pkt = (ctio7_to_24xx_t *)prm.pkt;
+	pkt->u.status0.flags |= __constant_cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
+			CTIO7_FLAGS_STATUS_MODE_0);
+	qla_tgt_load_data_segments(&prm, vha);
 
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
 
@@ -2492,6 +2158,7 @@ EXPORT_SYMBOL(qla_tgt_rdy_to_xfer);
 static int __qla_tgt_send_term_exchange(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	atio_from_isp_t *atio)
 {
+	ctio7_to_24xx_t *ctio24;
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	int ret = 0;
@@ -2517,44 +2184,25 @@ static int __qla_tgt_send_term_exchange(struct scsi_qla_host *vha, struct qla_tg
 	pkt->entry_count = 1;
 	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		ctio7_to_24xx_t *ctio24 = (ctio7_to_24xx_t *)pkt;
-		ctio24->entry_type = CTIO_TYPE7;
-		if (cmd == NULL)
-			ctio24->nport_handle = CTIO7_NHANDLE_UNRECOGNIZED;
-		ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
-		ctio24->vp_index = vha->vp_idx;
-		ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
-		ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
-		ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
-		ctio24->exchange_addr = atio->u.isp24.exchange_addr;
-		ctio24->u.status1.flags = (atio->u.isp24.attr << 9) | __constant_cpu_to_le16(
-			CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_TERMINATE);
-		ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
-
-		/* Most likely, it isn't needed */
-		ctio24->u.status1.residual = get_unaligned((uint32_t *)
-			&atio->u.isp24.fcp_cmnd.add_cdb[atio->u.isp24.fcp_cmnd.add_cdb_len]);
-		if (ctio24->u.status1.residual != 0)
-			ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
-	} else {
-		ctio_from_2xxx_t *ctio = (ctio_from_2xxx_t *)pkt;
-
-		ctio->entry_type = CTIO_RET_TYPE;
-
-		/* Set IDs */
-		SET_TARGET_ID(ha, ctio->target, GET_TARGET_ID(ha, atio));
-		ctio->rx_id = atio->u.isp2x.rx_id;
-
-		/* Most likely, it isn't needed */
-		ctio->residual = atio->u.isp2x.data_length;
-		if (ctio->residual != 0)
-			ctio->scsi_status |= SS_RESIDUAL_UNDER;
-
-		ctio->flags = __constant_cpu_to_le16(OF_FAST_POST | OF_TERM_EXCH |
-				OF_NO_DATA | OF_SS_MODE_1);
-		ctio->flags |= __constant_cpu_to_le16(OF_INC_RC);
-	}
+	ctio24 = (ctio7_to_24xx_t *)pkt;
+	ctio24->entry_type = CTIO_TYPE7;
+	if (cmd == NULL)
+		ctio24->nport_handle = CTIO7_NHANDLE_UNRECOGNIZED;
+	ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio24->vp_index = vha->vp_idx;
+	ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
+	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
+	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
+	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
+	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) | __constant_cpu_to_le16(
+		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_TERMINATE);
+	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+
+	/* Most likely, it isn't needed */
+	ctio24->u.status1.residual = get_unaligned((uint32_t *)
+		&atio->u.isp24.fcp_cmnd.add_cdb[atio->u.isp24.fcp_cmnd.add_cdb_len]);
+	if (ctio24->u.status1.residual != 0)
+		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
 
 	qla2x00_isp_cmd(vha, vha->req);
 	return ret;
@@ -2681,34 +2329,18 @@ static int qla_tgt_prepare_srr_ctio(struct scsi_qla_host *vha, struct qla_tgt_cm
 static int qla_tgt_term_ctio_exchange(struct scsi_qla_host *vha, void *ctio,
 	struct qla_tgt_cmd *cmd, uint32_t status)
 {
-	struct qla_hw_data *ha = vha->hw;
 	int term = 0;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		if (ctio != NULL) {
-			ctio7_from_24xx_t *c = (ctio7_from_24xx_t *)ctio;
-			term = !(c->flags &
-				__constant_cpu_to_le16(OF_TERM_EXCH));
-		} else
-			term = 1;
-		if (term)
-			qla_tgt_send_term_exchange(vha, cmd, &cmd->atio, 1);
-	} else {
-		if (status != CTIO_SUCCESS)
-			qla_tgt_2xxx_send_modify_lun(vha, 1, 0);
-#if 0 /* seems, it isn't needed */
-		if (ctio != NULL) {
-			ctio_to_2xxx_t *c = (ctio_to_2xxx_t *)ctio;
-			term = !(c->flags &
-				__constant_cpu_to_le16(
-					CTIO7_FLAGS_TERMINATE));
-		} else
-			term = 1;
-		if (term) {
-			qla_tgt_send_term_exchange(vha, cmd, &cmd->atio, 1);
-		}
-#endif
-	}
+	if (ctio != NULL) {
+		ctio7_from_24xx_t *c = (ctio7_from_24xx_t *)ctio;
+		term = !(c->flags &
+			__constant_cpu_to_le16(OF_TERM_EXCH));
+	} else
+		term = 1;
+
+	if (term)
+		qla_tgt_send_term_exchange(vha, cmd, &cmd->atio, 1);
+
 	return term;
 }
 
@@ -2730,7 +2362,6 @@ static inline struct qla_tgt_cmd *qla_tgt_get_cmd(struct scsi_qla_host *vha, uin
 static struct qla_tgt_cmd *qla_tgt_ctio_to_cmd(struct scsi_qla_host *vha, uint32_t handle,
 	void *ctio)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_cmd *cmd = NULL;
 
 	/* Clear out internal marks */
@@ -2755,30 +2386,11 @@ static struct qla_tgt_cmd *qla_tgt_ctio_to_cmd(struct scsi_qla_host *vha, uint32
 			return NULL;
 		}
 	} else if (ctio != NULL) {
-		struct qla_tgt_sess *sess;
-		int tag;
-		uint16_t loop_id;
-
-		if (IS_FWI2_CAPABLE(ha)) {
-			/* We can't get loop ID from CTIO7 */
-			printk(KERN_ERR "qla_target(%d): Wrong CTIO received: "
-				"QLA24xx doesn't support NULL handles\n",
-				vha->vp_idx);
-			return NULL;
-		} else {
-			ctio_to_2xxx_t *c = (ctio_to_2xxx_t *)ctio;
-			loop_id = GET_TARGET_ID(ha, (atio_from_isp_t *)ctio);
-			tag = c->rx_id;
-		}
-
-		sess = ha->tgt_ops->find_sess_by_loop_id(vha, loop_id);
-		if (!sess) {
-			printk(KERN_WARNING "qla_target(%d): Suspicious: "
-				   "ctio_completion for non-existing session "
-				   "(loop_id %d, tag %d)\n",
-				   vha->vp_idx, loop_id, tag);
-			return NULL;
-		}
+		/* We can't get loop ID from CTIO7 */
+		printk(KERN_ERR "qla_target(%d): Wrong CTIO received: "
+			"QLA24xx doesn't support NULL handles\n",
+			vha->vp_idx);
+		return NULL;
 	}
 
 	return cmd;
@@ -2969,10 +2581,7 @@ static void qla_tgt_do_work(struct work_struct *work)
 		uint8_t *s_id = NULL;
 		uint16_t loop_id = 0;
 
-		if (IS_FWI2_CAPABLE(ha))
-			s_id = atio->u.isp24.fcp_hdr.s_id;
-		else
-			loop_id = GET_TARGET_ID(ha, atio);
+		s_id = atio->u.isp24.fcp_hdr.s_id;
 
 		mutex_lock(&ha->tgt_mutex);
 		sess = qla_tgt_make_local_sess(vha, s_id, loop_id);
@@ -2986,50 +2595,27 @@ static void qla_tgt_do_work(struct work_struct *work)
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
-		cmd->tag = atio->u.isp24.exchange_addr;
-		cmd->unpacked_lun = scsilun_to_int(
-				(struct scsi_lun *)&atio->u.isp24.fcp_cmnd.lun);
-
-		if (atio->u.isp24.fcp_cmnd.rddata &&
-		    atio->u.isp24.fcp_cmnd.wrdata) {
-			bidi = 1;
-			data_dir = DMA_TO_DEVICE;
-		} else if (atio->u.isp24.fcp_cmnd.rddata)
-			data_dir = DMA_FROM_DEVICE;
-		else if (atio->u.isp24.fcp_cmnd.wrdata)
-			data_dir = DMA_TO_DEVICE;
-		else
-			data_dir = DMA_NONE;
-
-		fcp_task_attr = qla_tgt_get_fcp_task_attr(
-				atio->u.isp24.fcp_cmnd.task_attr);
-		data_length = be32_to_cpu(get_unaligned((uint32_t *)
-				&atio->u.isp24.fcp_cmnd.add_cdb[
-					atio->u.isp24.fcp_cmnd.add_cdb_len]));
-	} else {
-		uint16_t lun;
-
-		cdb = &atio->u.isp2x.cdb[0];
-		cmd->tag = atio->u.isp2x.rx_id;
-		lun = swab16(le16_to_cpu(atio->u.isp2x.lun));
-		cmd->unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
-
-		if ((atio->u.isp2x.execution_codes & (ATIO_EXEC_READ | ATIO_EXEC_WRITE)) ==
-					(ATIO_EXEC_READ | ATIO_EXEC_WRITE)) {
-			bidi = 1;
-			data_dir = DMA_TO_DEVICE;
-		} else if (atio->u.isp2x.execution_codes & ATIO_EXEC_READ)
-			data_dir = DMA_FROM_DEVICE;
-		else if (atio->u.isp2x.execution_codes & ATIO_EXEC_WRITE)
-			data_dir = DMA_TO_DEVICE;
-		else
-			data_dir = DMA_NONE;
+	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
+	cmd->tag = atio->u.isp24.exchange_addr;
+	cmd->unpacked_lun = scsilun_to_int(
+			(struct scsi_lun *)&atio->u.isp24.fcp_cmnd.lun);
+
+	if (atio->u.isp24.fcp_cmnd.rddata &&
+	    atio->u.isp24.fcp_cmnd.wrdata) {
+		bidi = 1;
+		data_dir = DMA_TO_DEVICE;
+	} else if (atio->u.isp24.fcp_cmnd.rddata)
+		data_dir = DMA_FROM_DEVICE;
+	else if (atio->u.isp24.fcp_cmnd.wrdata)
+		data_dir = DMA_TO_DEVICE;
+	else
+		data_dir = DMA_NONE;
 
-		fcp_task_attr = qla_tgt_get_fcp_task_attr(atio->u.isp2x.task_codes);
-		data_length = le32_to_cpu(atio->u.isp2x.data_length);
-	}
+	fcp_task_attr = qla_tgt_get_fcp_task_attr(
+			atio->u.isp24.fcp_cmnd.task_attr);
+	data_length = be32_to_cpu(get_unaligned((uint32_t *)
+			&atio->u.isp24.fcp_cmnd.add_cdb[
+				atio->u.isp24.fcp_cmnd.add_cdb_len]));
 
 	ql_dbg(ql_dbg_tgt_pkt, vha, 0xe207, "qla_target: START qla command: %p"
 		" lun: 0x%04x (tag %d)\n", cmd, cmd->unpacked_lun, cmd->tag);
@@ -3087,27 +2673,16 @@ static int qla_tgt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	cmd->tgt = ha->qla_tgt;
 	cmd->vha = vha;
 
-	if (IS_FWI2_CAPABLE(ha))
-		sess = ha->tgt_ops->find_sess_by_s_id(vha,
-					atio->u.isp24.fcp_hdr.s_id);
-	else
-		sess = ha->tgt_ops->find_sess_by_loop_id(vha,
-					GET_TARGET_ID(ha, atio));
-
+	sess = ha->tgt_ops->find_sess_by_s_id(vha,
+				atio->u.isp24.fcp_hdr.s_id);
 	if (unlikely(!sess)) {
-		if (IS_FWI2_CAPABLE(ha)) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe125, "qla_target(%d):"
-				" Unable to find wwn login (s_id %x:%x:%x),"
-				" trying to create it manually\n", vha->vp_idx,
-				atio->u.isp24.fcp_hdr.s_id[0],
-				atio->u.isp24.fcp_hdr.s_id[1],
-				atio->u.isp24.fcp_hdr.s_id[2]);
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe126, "qla_target(%d):"
-				" Unable to find wwn login (loop_id=%d), trying"
-				" to create it manually\n", vha->vp_idx,
-				GET_TARGET_ID(ha, atio));
-		}
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe125, "qla_target(%d):"
+			" Unable to find wwn login (s_id %x:%x:%x),"
+			" trying to create it manually\n", vha->vp_idx,
+			atio->u.isp24.fcp_hdr.s_id[0],
+			atio->u.isp24.fcp_hdr.s_id[1],
+			atio->u.isp24.fcp_hdr.s_id[2]);
+
 		if (atio->u.raw.entry_count > 1) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe127, "Dropping multy entry"
 					" cmd %p\n", cmd);
@@ -3242,6 +2817,7 @@ static int qla_tgt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 /* ha->hardware_lock supposed to be held on entry */
 static int qla_tgt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 {
+	atio_from_isp_t *a = (atio_from_isp_t *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt;
 	struct qla_tgt_sess *sess;
@@ -3249,31 +2825,19 @@ static int qla_tgt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	int lun_size, fn, res = 0;
 
 	tgt = ha->qla_tgt;
-	if (IS_FWI2_CAPABLE(ha)) {
-		atio_from_isp_t *a = (atio_from_isp_t *)iocb;
-
-		lun = a->u.isp24.fcp_cmnd.lun;
-		lun_size = sizeof(a->u.isp24.fcp_cmnd.lun);
-		fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
-		sess = ha->tgt_ops->find_sess_by_s_id(vha,
-					a->u.isp24.fcp_hdr.s_id);
-	} else {
-		imm_ntfy_from_isp_t *n = (imm_ntfy_from_isp_t *)iocb;
-		/* make it be in network byte order */
-		lun = swab16(le16_to_cpu(n->u.isp2x.lun));
-		lun_size = sizeof(lun);
-		fn = n->u.isp2x.task_flags >> IMM_NTFY_TASK_MGMT_SHIFT;
-		sess = ha->tgt_ops->find_sess_by_loop_id(vha,
-					GET_TARGET_ID(ha, (atio_from_isp_t *)iocb));
-	}
+
+	lun = a->u.isp24.fcp_cmnd.lun;
+	lun_size = sizeof(a->u.isp24.fcp_cmnd.lun);
+	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
+	sess = ha->tgt_ops->find_sess_by_s_id(vha,
+				a->u.isp24.fcp_hdr.s_id);
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe128, "qla_target(%d): task mgmt fn 0x%x for "
 			"non-existant session\n", vha->vp_idx, fn);
 		res = qla_tgt_sched_sess_work(tgt, QLA_TGT_SESS_WORK_TM, iocb,
-			IS_FWI2_CAPABLE(ha) ? sizeof(atio_from_isp_t) :
-					      sizeof(imm_ntfy_from_isp_t));
+			sizeof(atio_from_isp_t));
 		if (res != 0)
 			tgt->tm_to_unknown = 1;
 
@@ -3287,6 +2851,7 @@ static int qla_tgt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 static int __qla_tgt_abort_task(struct scsi_qla_host *vha,
 	imm_ntfy_from_isp_t *iocb, struct qla_tgt_sess *sess)
 {
+	atio_from_isp_t *a = (atio_from_isp_t *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
 	uint32_t lun, unpacked_lun;
@@ -3306,12 +2871,7 @@ static int __qla_tgt_abort_task(struct scsi_qla_host *vha,
 
 	tag = le16_to_cpu(iocb->u.isp2x.seq_id);
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		atio_from_isp_t *a = (atio_from_isp_t *)iocb;
-		lun = a->u.isp24.fcp_cmnd.lun;
-	} else
-		lun = swab16(le16_to_cpu(iocb->u.isp2x.lun));
-
+	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	rc = ha->tgt_ops->handle_tmr(mcmd, unpacked_lun, ABORT_TASK);
@@ -3524,13 +3084,8 @@ static void qla_tgt_handle_srr(struct scsi_qla_host *vha, struct qla_tgt_srr_cti
 	uint32_t offset;
 	uint16_t srr_ui;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		offset = le32_to_cpu(ntfy->u.isp24.srr_rel_offs);
-		srr_ui = ntfy->u.isp24.srr_ui;
-	} else {
-		offset = le32_to_cpu(ntfy->u.isp2x.srr_rel_offs);
-		srr_ui = ntfy->u.isp2x.srr_ui;
-	}
+	offset = le32_to_cpu(ntfy->u.isp24.srr_rel_offs);
+	srr_ui = ntfy->u.isp24.srr_ui;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe12c, "SRR cmd %p, srr_ui %x\n",
 			cmd, srr_ui);
@@ -3613,10 +3168,7 @@ static void qla_tgt_handle_srr(struct scsi_qla_host *vha, struct qla_tgt_srr_cti
 
 	/* Transmit response in case of status and data-in cases */
 	if (resp) {
-		if (IS_FWI2_CAPABLE(ha))
-			__qla_tgt_24xx_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
-		else
-			__qla_tgt_2xxx_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
+		qla_tgt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
 	}
 
 	return;
@@ -3830,18 +3382,11 @@ static void qla_tgt_handle_imm_notify(struct scsi_qla_host *vha,
 	switch (status) {
 	case IMM_NTFY_LIP_RESET:
 	{
-		if (IS_FWI2_CAPABLE(ha)) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe137, "qla_target(%d): LIP reset"
-				" (loop %#x), subcode %x\n", vha->vp_idx,
-				le16_to_cpu(iocb->u.isp24.nport_handle),
-				iocb->u.isp24.status_subcode);
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe138, "qla_target(%d): LIP reset"
-				" (I %#x)\n", vha->vp_idx,
-				GET_TARGET_ID(ha, (atio_from_isp_t *)iocb));
-			/* set the Clear LIP reset event flag */
-			add_flags |= NOTIFY_ACK_CLEAR_LIP_RESET;
-		}
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe137, "qla_target(%d): LIP reset"
+			" (loop %#x), subcode %x\n", vha->vp_idx,
+			le16_to_cpu(iocb->u.isp24.nport_handle),
+			iocb->u.isp24.status_subcode);
+
 		if (qla_tgt_reset(vha, iocb, QLA_TGT_ABORT_ALL) == 0)
 			send_notify_ack = 0;
 		break;
@@ -3869,17 +3414,11 @@ static void qla_tgt_handle_imm_notify(struct scsi_qla_host *vha,
 	}
 
 	case IMM_NTFY_PORT_LOGOUT:
-		if (IS_FWI2_CAPABLE(ha)) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe13a, "qla_target(%d): Port logout (loop "
-				"%#x, subcode %x)\n", vha->vp_idx,
-				le16_to_cpu(iocb->u.isp24.nport_handle),
-				iocb->u.isp24.status_subcode);
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe13b, "qla_target(%d): Port logout (S "
-				"%08x -> L %#x)\n", vha->vp_idx,
-				le16_to_cpu(iocb->u.isp2x.seq_id),
-				le16_to_cpu(iocb->u.isp2x.lun));
-		}
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe13a, "qla_target(%d): Port logout (loop "
+			"%#x, subcode %x)\n", vha->vp_idx,
+			le16_to_cpu(iocb->u.isp24.nport_handle),
+			iocb->u.isp24.status_subcode);
+
 		if (qla_tgt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS) == 0)
 			send_notify_ack = 0;
 		/* The sessions will be cleared in the callback, if needed */
@@ -3965,18 +3504,16 @@ static void qla_tgt_handle_imm_notify(struct scsi_qla_host *vha,
 static void qla_tgt_send_busy(struct scsi_qla_host *vha,
 	atio_from_isp_t *atio, uint16_t status)
 {
+	ctio7_to_24xx_t *ctio24;
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	struct qla_tgt_sess *sess = NULL;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		sess = ha->tgt_ops->find_sess_by_s_id(vha, atio->u.isp24.fcp_hdr.s_id);
-		if (!sess) {
-			qla_tgt_send_term_exchange(vha, NULL, atio, 1);
-			return;
-		}
+	sess = ha->tgt_ops->find_sess_by_s_id(vha, atio->u.isp24.fcp_hdr.s_id);
+	if (!sess) {
+		qla_tgt_send_term_exchange(vha, NULL, atio, 1);
+		return;
 	}
-
 	/* Sending marker isn't necessary, since we called from ISR */
 
 	pkt = (request_t *)qla2x00_req_pkt(vha);
@@ -3989,53 +3526,28 @@ static void qla_tgt_send_busy(struct scsi_qla_host *vha,
 	pkt->entry_count = 1;
 	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		ctio7_to_24xx_t *ctio24 = (ctio7_to_24xx_t *)pkt;
-
-		ctio24->entry_type = CTIO_TYPE7;
-		ctio24->nport_handle = sess->loop_id;
-		ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
-		ctio24->vp_index = vha->vp_idx;
-		ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
-		ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
-		ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
-		ctio24->exchange_addr = atio->u.isp24.exchange_addr;
-		ctio24->u.status1.flags = (atio->u.isp24.attr << 9) | __constant_cpu_to_le16(
-			CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS |
-			CTIO7_FLAGS_DONT_RET_CTIO);
-		/*
-		 * CTIO from fw w/o se_cmd doesn't provide enough info to retry it,
-		 * if the explicit conformation is used.
-		 */
-		ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
-		ctio24->u.status1.scsi_status = cpu_to_le16(status);
-		ctio24->u.status1.residual = get_unaligned((uint32_t *)
-			&atio->u.isp24.fcp_cmnd.add_cdb[atio->u.isp24.fcp_cmnd.add_cdb_len]);
-		if (ctio24->u.status1.residual != 0)
-			ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
-	} else {
-		ctio_from_2xxx_t *ctio2x = (ctio_from_2xxx_t *)pkt;
-
-		ctio2x->entry_type = CTIO_RET_TYPE;
-		ctio2x->entry_count = 1;
-		ctio2x->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
-		ctio2x->scsi_status = __constant_cpu_to_le16(SAM_STAT_BUSY);
-		ctio2x->residual = atio->u.isp2x.data_length;
-		if (ctio2x->residual != 0)
-			ctio2x->scsi_status |= SS_RESIDUAL_UNDER;
-
-		/* Set IDs */
-		SET_TARGET_ID(ha, ctio2x->target, GET_TARGET_ID(ha, atio));
-		ctio2x->rx_id = atio->u.isp2x.rx_id;
-
-		ctio2x->flags = __constant_cpu_to_le16(OF_SSTS | OF_FAST_POST |
-				OF_NO_DATA | OF_SS_MODE_1);
-		ctio2x->flags |= __constant_cpu_to_le16(OF_INC_RC);
-		/*
-		 * CTIO from fw w/o se_cmd doesn't provide enough info to retry it,
-		 * if the explicit conformation is used.
-		 */
-	}
+	ctio24 = (ctio7_to_24xx_t *)pkt;
+	ctio24->entry_type = CTIO_TYPE7;
+	ctio24->nport_handle = sess->loop_id;
+	ctio24->timeout = __constant_cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio24->vp_index = vha->vp_idx;
+	ctio24->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
+	ctio24->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
+	ctio24->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
+	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
+	ctio24->u.status1.flags = (atio->u.isp24.attr << 9) | __constant_cpu_to_le16(
+		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS |
+		CTIO7_FLAGS_DONT_RET_CTIO);
+	/*
+	 * CTIO from fw w/o se_cmd doesn't provide enough info to retry it,
+	 * if the explicit conformation is used.
+	 */
+	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
+	ctio24->u.status1.scsi_status = cpu_to_le16(status);
+	ctio24->u.status1.residual = get_unaligned((uint32_t *)
+		&atio->u.isp24.fcp_cmnd.add_cdb[atio->u.isp24.fcp_cmnd.add_cdb_len]);
+	if (ctio24->u.status1.residual != 0)
+		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
 
 	qla2x00_isp_cmd(vha, vha->req);
 }
@@ -4321,28 +3833,6 @@ static void qla_tgt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		}
 		break;
 
-	case ENABLE_LUN_TYPE:
-	{
-		enable_lun_t *entry = (enable_lun_t *)pkt;
-		ql_dbg(ql_dbg_tgt, vha, 0xe031, "ENABLE_LUN %x imm %u cmd %u \n",
-			  entry->status, entry->immed_notify_count,
-			  entry->command_count);
-		if (entry->status == ENABLE_LUN_ALREADY_ENABLED) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe032, "LUN is already enabled: %#x\n",
-				  entry->status);
-			entry->status = ENABLE_LUN_SUCCESS;
-		} else if (entry->status == ENABLE_LUN_RC_NONZERO) {
-			ql_dbg(ql_dbg_tgt, vha, 0xe033, "ENABLE_LUN succeeded, but with "
-				"error: %#x\n", entry->status);
-			entry->status = ENABLE_LUN_SUCCESS;
-		} else if (entry->status != ENABLE_LUN_SUCCESS) {
-			printk(KERN_ERR "qla_target(%d): ENABLE_LUN "
-				"failed %x\n", vha->vp_idx, entry->status);
-			qla_tgt_clear_mode(vha);
-		} /* else success */
-		break;
-	}
-
 	default:
 		printk(KERN_ERR "qla_target(%d): Received unknown response pkt "
 		     "type %x\n", vha->vp_idx, pkt->entry_type);
@@ -4484,25 +3974,23 @@ static struct qla_tgt_sess *qla_tgt_make_local_sess(struct scsi_qla_host *vha,
 retry:
 	global_resets = atomic_read(&ha->qla_tgt->tgt_global_resets_count);
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		rc = qla24xx_get_loop_id(vha, s_id, &loop_id);
-		if (rc != 0) {
-			if ((s_id[0] == 0xFF) &&
-			    (s_id[1] == 0xFC)) {
-				/*
-				 * This is Domain Controller, so it should be
-				 * OK to drop SCSI commands from it.
-				 */
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xe149, "Unable to find"
-					" initiator with S_ID %x:%x:%x", s_id[0],
-					s_id[1], s_id[2]);
-			} else
-				printk(KERN_ERR "qla_target(%d): Unable to find "
-					"initiator with S_ID %x:%x:%x",
-					vha->vp_idx, s_id[0], s_id[1],
-					s_id[2]);
-			return NULL;
-		}
+	rc = qla24xx_get_loop_id(vha, s_id, &loop_id);
+	if (rc != 0) {
+		if ((s_id[0] == 0xFF) &&
+		    (s_id[1] == 0xFC)) {
+			/*
+			 * This is Domain Controller, so it should be
+			 * OK to drop SCSI commands from it.
+			 */
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe149, "Unable to find"
+				" initiator with S_ID %x:%x:%x", s_id[0],
+				s_id[1], s_id[2]);
+		} else
+			printk(KERN_ERR "qla_target(%d): Unable to find "
+				"initiator with S_ID %x:%x:%x",
+				vha->vp_idx, s_id[0], s_id[1],
+				s_id[2]);
+		return NULL;
 	}
 
 	fcport = qla_tgt_get_port_database(vha, s_id, loop_id);
@@ -4540,22 +4028,17 @@ static void qla_tgt_abort_work(struct qla_tgt *tgt,
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		be_s_id = (prm->abts.fcp_hdr_le.s_id[0] << 16) |
-			(prm->abts.fcp_hdr_le.s_id[1] << 8) |
-			prm->abts.fcp_hdr_le.s_id[2];
-
-		sess = ha->tgt_ops->find_sess_by_s_id(vha,
-				(unsigned char *)&be_s_id);
-		if (!sess) {
-			s_id = local_s_id;
-			s_id[0] = prm->abts.fcp_hdr_le.s_id[2];
-			s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
-			s_id[2] = prm->abts.fcp_hdr_le.s_id[0];
-		}
-	} else {
-		loop_id = GET_TARGET_ID(ha, (atio_from_isp_t *)&prm->tm_iocb);
-		sess = ha->tgt_ops->find_sess_by_loop_id(vha, loop_id);
+	be_s_id = (prm->abts.fcp_hdr_le.s_id[0] << 16) |
+		(prm->abts.fcp_hdr_le.s_id[1] << 8) |
+		prm->abts.fcp_hdr_le.s_id[2];
+
+	sess = ha->tgt_ops->find_sess_by_s_id(vha,
+			(unsigned char *)&be_s_id);
+	if (!sess) {
+		s_id = local_s_id;
+		s_id[0] = prm->abts.fcp_hdr_le.s_id[2];
+		s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
+		s_id[2] = prm->abts.fcp_hdr_le.s_id[0];
 	}
 
 	if (sess) {
@@ -4578,10 +4061,7 @@ static void qla_tgt_abort_work(struct qla_tgt *tgt,
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	if (IS_FWI2_CAPABLE(ha))
-		rc = __qla_tgt_24xx_handle_abts(vha, &prm->abts, sess);
-	else
-		rc = __qla_tgt_abort_task(vha, &prm->tm_iocb, sess);
+	rc = __qla_tgt_24xx_handle_abts(vha, &prm->abts, sess);
 	if (rc != 0)
 		goto out_term;
 
@@ -4591,14 +4071,7 @@ static void qla_tgt_abort_work(struct qla_tgt *tgt,
 	return;
 
 out_term:
-	if (IS_FWI2_CAPABLE(ha)) {
-		qla_tgt_24xx_send_abts_resp(vha, &prm->abts,
-			FCP_TMF_REJECTED, false);
-	} else {
-		qla_tgt_send_notify_ack(vha, (void *)&prm->tm_iocb,
-			0, 0, 0, 0, 0, 0);
-	}
-
+	qla_tgt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
 	if (sess)
 		__qla_tgt_sess_put(sess);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4607,6 +4080,7 @@ out_term:
 static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 	struct qla_tgt_sess_work_param *prm)
 {
+	atio_from_isp_t *a = &prm->tm_iocb2;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess = NULL;
@@ -4622,13 +4096,8 @@ static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
-		sess = ha->tgt_ops->find_sess_by_s_id(vha, s_id);
-	} else {
-		loop_id = GET_TARGET_ID(ha, (atio_from_isp_t *)&prm->tm_iocb);
-		sess = ha->tgt_ops->find_sess_by_loop_id(vha, loop_id);
-	}
+	s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
+	sess = ha->tgt_ops->find_sess_by_s_id(vha, s_id);
 
 	if (sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe14c, "sess %p found\n", sess);
@@ -4646,21 +4115,10 @@ static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 			goto out_term;
 	}
 
-
-	if (IS_FWI2_CAPABLE(ha)) {
-		atio_from_isp_t *a = &prm->tm_iocb2;
-		iocb = a;
-		lun = a->u.isp24.fcp_cmnd.lun;
-		lun_size = sizeof(lun);
-		fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
-	} else {
-		imm_ntfy_from_isp_t *n = &prm->tm_iocb;
-		iocb = n;
-		/* make it be in network byte order */
-		lun = swab16(le16_to_cpu(n->u.isp2x.lun));
-		lun_size = sizeof(lun);
-		fn = n->u.isp2x.task_flags >> IMM_NTFY_TASK_MGMT_SHIFT;
-	}
+	iocb = a;
+	lun = a->u.isp24.fcp_cmnd.lun;
+	lun_size = sizeof(lun);
+	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	rc = qla_tgt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
@@ -4673,11 +4131,7 @@ static void qla_tgt_tmr_work(struct qla_tgt *tgt,
 	return;
 
 out_term:
-	if (IS_FWI2_CAPABLE(ha))
-		qla_tgt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1);
-	else
-		qla_tgt_send_notify_ack(vha, &prm->tm_iocb,
-			0, 0, 0, 0, 0, 0);
+	qla_tgt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1);
 	if (sess)
 		__qla_tgt_sess_put(sess);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4768,34 +4222,13 @@ int qla_tgt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	
 	ha->qla_tgt = tgt;
 
-	if (IS_FWI2_CAPABLE(ha)) {
-		printk(KERN_INFO "qla_target(%d): using 64 Bit PCI "
+	printk(KERN_INFO "qla_target(%d): using 64 Bit PCI "
 			   "addressing", base_vha->vp_idx);
-			tgt->tgt_enable_64bit_addr = 1;
-			/* 3 is reserved */
-			tgt->sg_tablesize =
-			    QLA_TGT_MAX_SG_24XX(base_vha->req->length - 3);
-			tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD_24XX;
-			tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT_24XX;
-	} else {
-		if (ha->flags.enable_64bit_addressing) {
-			printk(KERN_INFO "qla_target(%d): 64 Bit PCI "
-				   "addressing enabled", base_vha->vp_idx);
-			tgt->tgt_enable_64bit_addr = 1;
-			/* 3 is reserved */
-			tgt->sg_tablesize =
-				QLA_TGT_MAX_SG64(base_vha->req->length - 3);
-			tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD64;
-			tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT64;
-		} else {
-			printk(KERN_INFO "qla_target(%d): Using 32 Bit "
-				   "PCI addressing", base_vha->vp_idx);
-			tgt->sg_tablesize =
-				QLA_TGT_MAX_SG32(base_vha->req->length - 3);
-			tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD32;
-			tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT32;
-		}
-	}
+	tgt->tgt_enable_64bit_addr = 1;
+	/* 3 is reserved */
+	tgt->sg_tablesize = QLA_TGT_MAX_SG_24XX(base_vha->req->length - 3);
+	tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD_24XX;
+	tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT_24XX;
 
 	mutex_lock(&qla_tgt_mutex);
 	list_add_tail(&tgt->tgt_list_entry, &qla_tgt_glist);
@@ -5052,7 +4485,6 @@ qla_tgt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 	mutex_init(&ha->tgt_mutex);
 	mutex_init(&ha->tgt_host_action_mutex);
 	qla_tgt_clear_mode(vha);
-	qla_tgt_2xxx_send_enable_lun(vha, false);
 
 	/*
 	 * NOTE: Currently the value is kept the same for <24xx and
@@ -5080,19 +4512,6 @@ qla_tgt_rff_id(struct scsi_qla_host *vha, struct ct_sns_req *ct_req)
 }
 
 /*
- * Called from qla_init.c:qla2x00_initialize_adapter()
- */
-void
-qla_tgt_initialize_adapter(struct scsi_qla_host *vha, struct qla_hw_data *ha)
-{
-	/* Enable target response to SCSI bus. */
-	if (qla_tgt_mode_enabled(vha))
-		qla_tgt_2xxx_send_enable_lun(vha, true);
-	else if (qla_ini_mode_enabled(vha))
-		qla_tgt_2xxx_send_enable_lun(vha, false);
-}
-
-/*
  * qla_tgt_init_atio_q_entries() - Initializes ATIO queue entries.
  * @ha: HA context
  *
@@ -5175,76 +4594,6 @@ qla_tgt_24xx_config_rings(struct scsi_qla_host *vha, device_reg_t __iomem *reg)
 }
 
 void
-qla_tgt_2xxx_config_nvram_stage1(struct scsi_qla_host *vha, nvram_t *nv)
-{
-	struct qla_hw_data *ha = vha->hw;
-	/*
-	 * Setup driver NVRAM options.
-	 */
-	if (!IS_QLA2100(ha)) {
-		/* Check if target mode enabled */
-		if (qla_tgt_mode_enabled(vha)) {
-			if (!ha->saved_set) {
-				/* We save only once */
-				ha->saved_firmware_options[0] = nv->firmware_options[0];
-				ha->saved_firmware_options[1] = nv->firmware_options[1];
-				ha->saved_add_firmware_options[0] = nv->add_firmware_options[0];
-				ha->saved_add_firmware_options[1] = nv->add_firmware_options[1];
-				ha->saved_set = 1;
-			}
-			/* Enable target mode */
-			nv->firmware_options[0] |= BIT_4;
-			/* Disable ini mode, if requested */
-			if (!qla_ini_mode_enabled(vha))
-				nv->firmware_options[0] |= BIT_5;
-
-			/* Disable Full Login after LIP */
-			nv->firmware_options[1] &= ~BIT_5;
-			/* Enable initial LIP */
-			nv->firmware_options[1] &= BIT_1;
-			/* Enable FC tapes support */
-			nv->add_firmware_options[1] |= BIT_4;
-			/* Enable Command Queuing in Target Mode */
-			nv->add_firmware_options[1] |= BIT_6;
-		} else {
-			if (ha->saved_set) {
-				nv->firmware_options[0] = ha->saved_firmware_options[0];
-				nv->firmware_options[1] = ha->saved_firmware_options[1];
-				nv->add_firmware_options[0] = ha->saved_add_firmware_options[0];
-				nv->add_firmware_options[1] = ha->saved_add_firmware_options[1];
-			}
-		}
-	}
-
-	if (!IS_QLA2100(ha)) {
-		if (ha->enable_class_2) {
-			if (vha->flags.init_done) {
-				fc_host_supported_classes(vha->host) =
-					FC_COS_CLASS2 | FC_COS_CLASS3;
-			}
-			nv->add_firmware_options[1] |= BIT_0;
-		} else {
-			if (vha->flags.init_done) {
-				fc_host_supported_classes(vha->host) =
-					FC_COS_CLASS3;
-			}
-			nv->add_firmware_options[1] &= BIT_0;
-		}
-	}
-}
-
-void
-qla_tgt_2xxx_config_nvram_stage2(struct scsi_qla_host *vha, init_cb_t *icb)
-{
-	struct qla_hw_data *ha = vha->hw;
-
-	if (ha->node_name_set) {
-		memcpy(icb->node_name, ha->tgt_node_name, WWN_SIZE);
-		icb->firmware_options[1] |= BIT_6;
-	}
-}
-
-void
 qla_tgt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -5315,34 +4664,6 @@ qla_tgt_24xx_config_nvram_stage2(struct scsi_qla_host *vha, struct init_cb_24xx
 	}
 }
 
-void
-qla_tgt_abort_isp(struct scsi_qla_host *vha)
-{
-	/* Enable target response to SCSI bus. */
-	if (qla_tgt_mode_enabled(vha))
-		qla_tgt_2xxx_send_enable_lun(vha, true);
-}
-
-int
-qla_tgt_2xxx_process_response_error(struct scsi_qla_host *vha, sts_entry_t *pkt)
-{
-	if (!qla_tgt_mode_enabled(vha))
-		return 0;
-
-	switch (pkt->entry_type) {
-	case ACCEPT_TGT_IO_TYPE:
-	case CONTINUE_TGT_IO_TYPE:
-	case CTIO_A64_TYPE:
-	case IMMED_NOTIFY_TYPE:
-	case NOTIFY_ACK_TYPE:
-	case ENABLE_LUN_TYPE:
-	case MODIFY_LUN_TYPE:
-		return 1;
-	default:
-		return 0;
-	}
-}
-
 int
 qla_tgt_24xx_process_response_error(struct scsi_qla_host *vha, struct sts_entry_24xx *pkt)
 {
@@ -5378,21 +4699,18 @@ qla_tgt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 int
 qla_tgt_mem_alloc(struct qla_hw_data *ha)
 {
-	if (IS_FWI2_CAPABLE(ha)) {
-		ha->tgt_vp_map = kzalloc(sizeof(struct qla_tgt_vp_map) *
-					MAX_MULTI_ID_FABRIC, GFP_KERNEL);
-		if (!ha->tgt_vp_map)
-			return -ENOMEM;
-
-		ha->atio_ring = dma_alloc_coherent(&ha->pdev->dev,
-				(ha->atio_q_length + 1) * sizeof(atio_from_isp_t),
-				&ha->atio_dma, GFP_KERNEL);
-		if (!ha->atio_ring) {
-			kfree(ha->tgt_vp_map);
-			return -ENOMEM;
-		}
-	}
+	ha->tgt_vp_map = kzalloc(sizeof(struct qla_tgt_vp_map) *
+				MAX_MULTI_ID_FABRIC, GFP_KERNEL);
+	if (!ha->tgt_vp_map)
+		return -ENOMEM;
 
+	ha->atio_ring = dma_alloc_coherent(&ha->pdev->dev,
+			(ha->atio_q_length + 1) * sizeof(atio_from_isp_t),
+			&ha->atio_dma, GFP_KERNEL);
+	if (!ha->atio_ring) {
+		kfree(ha->tgt_vp_map);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index a49c64b..343fc1e 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -109,40 +109,6 @@
    (min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
 
-/********************************************************************\
- * ISP Queue types left out of new QLogic driver (from old version)
-\********************************************************************/
-
-#ifndef ENABLE_LUN_TYPE
-#define ENABLE_LUN_TYPE 0x0B		/* Enable LUN entry. */
-/*
- * ISP queue - enable LUN entry structure definition.
- */
-typedef struct {
-	uint8_t	 entry_type;		/* Entry type. */
-	uint8_t	 entry_count;		/* Entry count. */
-	uint8_t	 sys_define;		/* System defined. */
-	uint8_t	 entry_status;		/* Entry Status. */
-	uint32_t sys_define_2;		/* System defined. */
-	uint8_t	 reserved_8;
-	uint8_t	 reserved_1;
-	uint16_t reserved_2;
-	uint32_t reserved_3;
-	uint8_t	 status;
-	uint8_t	 reserved_4;
-	uint8_t	 command_count;		/* Number of ATIOs allocated. */
-	uint8_t	 immed_notify_count;	/* Number of Immediate Notify entries allocated. */
-	uint16_t reserved_5;
-	uint16_t timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t reserved_6[20];
-} __attribute__((packed)) enable_lun_t;
-#define ENABLE_LUN_SUCCESS          0x01
-#define ENABLE_LUN_RC_NONZERO       0x04
-#define ENABLE_LUN_INVALID_REQUEST  0x06
-#define ENABLE_LUN_ALREADY_ENABLED  0x3E
-#endif
-
-#ifndef MODIFY_LUN_TYPE
 #define MODIFY_LUN_TYPE 0x0C	  /* Modify LUN entry. */
 /*
  * ISP queue - modify LUN entry structure definition.
@@ -363,31 +329,6 @@ typedef struct {
 
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
-/*
- * ISP queue - CTIO from ISP 2xxx to target driver returned entry structure.
- */
-typedef struct {
-	uint8_t	 entry_type;		    /* Entry type. */
-	uint8_t	 entry_count;		    /* Entry count. */
-	uint8_t	 sys_define;		    /* System defined. */
-	uint8_t	 entry_status;		    /* Entry Status. */
-	uint32_t handle;		    /* System defined handle. */
-	target_id_t target;
-	uint16_t rx_id;
-	uint16_t flags;
-	uint16_t status;
-	uint16_t timeout;	    /* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;	    /* Data segment count. */
-	uint32_t relative_offset;
-	uint32_t residual;
-	uint16_t reserved_1[2];
-	uint16_t sense_length;
-	uint16_t scsi_status;
-	uint16_t response_length;
-	uint8_t	 sense_data[26];
-} __attribute__((packed)) ctio_from_2xxx_t;
-#endif
-
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
 
 typedef struct {
@@ -819,11 +760,6 @@ int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
 #define QLA_TGT_SENSE_VALID(sense)  ((sense != NULL) && \
 				(((const uint8_t *)(sense))[0] & 0x70) == 0x70)
 
-struct qla_port_2xxx_data {
-	uint8_t port_name[WWN_SIZE];
-	uint16_t loop_id;
-};
-
 struct qla_port_24xx_data {
 	uint8_t port_name[WWN_SIZE];
 	uint16_t loop_id;
@@ -1045,70 +981,6 @@ static inline void qla_reverse_ini_mode(struct scsi_qla_host *ha)
 		ha->host->active_mode |= MODE_INITIATOR;
 }
 
-/********************************************************************\
- * ISP Queue types left out of new QLogic driver (from old version)
-\********************************************************************/
-
-/*
- * qla_tgt_2xxx_send_enable_lun
- *	Issue enable or disable LUN entry IOCB to ISP 2xxx.
- *	NOTE: This IOCB is not available, and so not issued to ISPs >=24xx.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Caller MUST have hardware lock held. This function might release it,
- * then reaquire.
- */
-static inline void
-__qla_tgt_2xxx_send_enable_lun(struct scsi_qla_host *vha, int enable)
-{
-	enable_lun_t *pkt;
-
-	pkt = (enable_lun_t *)qla2x00_alloc_iocbs(vha, 0);
-	if (pkt != NULL) {
-		pkt->entry_type = ENABLE_LUN_TYPE;
-		if (enable) {
-			pkt->command_count = QLA2XXX_COMMAND_COUNT_INIT;
-			pkt->immed_notify_count = QLA2XXX_IMMED_NOTIFY_COUNT_INIT;
-			pkt->timeout = 0xffff;
-		} else {
-			pkt->command_count = 0;
-			pkt->immed_notify_count = 0;
-			pkt->timeout = 0;
-		}
-
-		/* Issue command to ISP */
-		qla2x00_isp_cmd(vha, vha->req);
-
-	} else
-		qla_tgt_clear_mode(vha);
-	if (!pkt)
-		printk (KERN_ERR "%s: **** FAILED ****\n", __func__);
-
-	return;
-}
-
-/*
- * qla_tgt_2xxx_send_enable_lun
- *      Issue enable LUN entry IOCB.
- *
- * Input:
- *      ha = adapter block pointer.
- *	enable = enable/disable flag.
- */
-static inline void
-qla_tgt_2xxx_send_enable_lun(struct scsi_qla_host *vha, bool enable)
-{
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!IS_FWI2_CAPABLE(ha)) {
-		unsigned long flags;
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		__qla_tgt_2xxx_send_enable_lun(vha, enable);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
-}
 /*
  * Exported symbols from qla_target.c LLD logic used by qla2xxx code..
  */
@@ -1126,16 +998,11 @@ extern void qla_tgt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qla_tgt_enable_vha(struct scsi_qla_host *);
 extern void qla_tgt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
 extern void qla_tgt_rff_id(struct scsi_qla_host *, struct ct_sns_req *);
-extern void qla_tgt_initialize_adapter(struct scsi_qla_host *, struct qla_hw_data *);
 extern void qla_tgt_init_atio_q_entries(struct scsi_qla_host *);
 extern void qla_tgt_24xx_process_atio_queue(struct scsi_qla_host *);
 extern void qla_tgt_24xx_config_rings(struct scsi_qla_host *, device_reg_t __iomem *);
-extern void qla_tgt_2xxx_config_nvram_stage1(struct scsi_qla_host *, nvram_t *);
-extern void qla_tgt_2xxx_config_nvram_stage2(struct scsi_qla_host *, init_cb_t *);
 extern void qla_tgt_24xx_config_nvram_stage1(struct scsi_qla_host *, struct nvram_24xx *);
 extern void qla_tgt_24xx_config_nvram_stage2(struct scsi_qla_host *, struct init_cb_24xx *);
-extern void qla_tgt_abort_isp(struct scsi_qla_host *);
-extern int qla_tgt_2xxx_process_response_error(struct scsi_qla_host *, sts_entry_t *);
 extern int qla_tgt_24xx_process_response_error(struct scsi_qla_host *, struct sts_entry_24xx *);
 extern void qla_tgt_modify_vp_config(struct scsi_qla_host *, struct vp_config_entry_24xx *);
 extern void qla_tgt_probe_one_stage1(struct scsi_qla_host *, struct qla_hw_data *);
-- 
1.7.2.5
