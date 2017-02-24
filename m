From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 01/14] qla2xxx: Fix delayed response to command for loop mode/direct connect.
Date: Fri, 24 Feb 2017 13:37:30 -0800
Message-ID: <1487972263-3795-2-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0044.outbound.protection.outlook.com ([104.47.32.44]:52174
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751287AbdBXVhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:37:51 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Current driver wait for FW to be in the ready state before
processing in-coming commands. For Arbitrated Loop or
Point-to- Point (not switch), FW Ready state can take a while.
FW will transition to ready state after all Nports have been
logged in. In the mean time, certain initiators have completed
the login and starts IO. Driver needs to start processing all
queues if FW is already started.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 12 ++++++++++--
 drivers/scsi/qla2xxx/qla_init.c   | 12 ++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    | 14 +++++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c    |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c     | 22 +++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c | 38 +++++++++++++++++++++++++-------------
 6 files changed, 84 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 625d438..c264ced 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3290,6 +3290,10 @@ struct qlt_hw_data {
 
 #define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
 
+#define QLA_EARLY_LINKUP(_ha) \
+	((_ha->flags.n2n_ae || _ha->flags.lip_ae) && \
+	 _ha->flags.fw_started && !_ha->flags.fw_init_done)
+
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -3339,7 +3343,11 @@ struct qla_hw_data {
 		uint32_t	fawwpn_enabled:1;
 		uint32_t	exlogins_enabled:1;
 		uint32_t	exchoffld_enabled:1;
-		/* 35 bits */
+
+		uint32_t	lip_ae:1;
+		uint32_t	n2n_ae:1;
+		uint32_t	fw_started:1;
+		uint32_t	fw_init_done:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -3432,7 +3440,6 @@ struct qla_hw_data {
 #define P2P_LOOP  3
 	uint8_t		interrupts_on;
 	uint32_t	isp_abort_cnt;
-
 #define PCI_DEVICE_ID_QLOGIC_ISP2532    0x2532
 #define PCI_DEVICE_ID_QLOGIC_ISP8432    0x8432
 #define PCI_DEVICE_ID_QLOGIC_ISP8001	0x8001
@@ -3913,6 +3920,7 @@ struct qla_tgt_counters {
 	struct list_head vp_fcports;	/* list of fcports */
 	struct list_head work_list;
 	spinlock_t work_lock;
+	struct work_struct iocb_work;
 
 	/* Commonly used flags and state information. */
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ac579fc..6b0ec11 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3212,6 +3212,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
+		ha->flags.fw_started = 1;
 	}
 
 	return (rval);
@@ -4036,6 +4037,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			atomic_set(&vha->loop_state, LOOP_READY);
 			ql_dbg(ql_dbg_disc, vha, 0x2069,
 			    "LOOP READY.\n");
+			ha->flags.fw_init_done = 1;
 
 			/*
 			 * Process any ATIO queue entries that came in
@@ -5526,6 +5528,11 @@ int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
 	if (!(IS_P3P_TYPE(ha)))
 		ha->isp_ops->reset_chip(vha);
 
+	ha->flags.n2n_ae = 0;
+	ha->flags.lip_ae = 0;
+	ha->current_topology = 0;
+	ha->flags.fw_started = 0;
+	ha->flags.fw_init_done = 0;
 	ha->chip_reset++;
 
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
@@ -6802,6 +6809,8 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		return;
 	if (!ha->fw_major_version)
 		return;
+	if (!ha->flags.fw_started)
+		return;
 
 	ret = qla2x00_stop_firmware(vha);
 	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
@@ -6815,6 +6824,9 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		    "Attempting retry of stop-firmware command.\n");
 		ret = qla2x00_stop_firmware(vha);
 	}
+
+	ha->flags.fw_started = 0;
+	ha->flags.fw_init_done = 0;
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 352cfb6..a5faf37 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -708,6 +708,8 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 		    "mbx7=%xh.\n", mb[1], mb[2], mb[3], mbx);
 
 		ha->isp_ops->fw_dump(vha, 1);
+		ha->flags.fw_init_done = 0;
+		ha->flags.fw_started = 0;
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
@@ -761,6 +763,9 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
+		ha->flags.lip_ae = 1;
+		ha->flags.n2n_ae = 0;
+
 		ql_dbg(ql_dbg_async, vha, 0x5009,
 		    "LIP occurred (%x).\n", mb[1]);
 
@@ -797,6 +802,10 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
+		ha->flags.n2n_ae = 0;
+		ha->flags.lip_ae = 0;
+		ha->current_topology = 0;
+
 		mbx = (IS_QLA81XX(ha) || IS_QLA8031(ha))
 			? RD_REG_WORD(&reg24->mailbox4) : 0;
 		mbx = (IS_P3P_TYPE(ha)) ? RD_REG_WORD(&reg82->mailbox_out[4])
@@ -866,6 +875,9 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 
 	/* case MBA_DCBX_COMPLETE: */
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
+		ha->flags.lip_ae = 0;
+		ha->flags.n2n_ae = 1;
+
 		if (IS_QLA2100(ha))
 			break;
 
@@ -2693,7 +2705,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct sts_entry_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!vha->flags.online)
+	if (!ha->flags.fw_started)
 		return;
 
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 35079f4..db6bd92 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3612,11 +3612,11 @@ struct tsk_mgmt_cmd {
 
 	if (rptid_entry->format == 0) {
 		/* loop */
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b7,
+		ql_dbg(ql_dbg_async, vha, 0x10b7,
 		    "Format 0 : Number of VPs setup %d, number of "
 		    "VPs acquired %d.\n", rptid_entry->vp_setup,
 		    rptid_entry->vp_acquired);
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b8,
+		ql_dbg(ql_dbg_async, vha, 0x10b8,
 		    "Primary port id %02x%02x%02x.\n",
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
@@ -3631,7 +3631,7 @@ struct tsk_mgmt_cmd {
 
 	} else if (rptid_entry->format == 1) {
 		/* fabric */
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b9,
+		ql_dbg(ql_dbg_async, vha, 0x10b9,
 		    "Format 1: VP[%d] enabled - status %d - with "
 		    "port id %02x%02x%02x.\n", rptid_entry->vp_idx,
 			rptid_entry->vp_status,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bbf1ad95..312972b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2564,6 +2564,21 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
+static void qla2x00_iocb_work_fn(struct work_struct *work)
+{
+	struct scsi_qla_host *vha = container_of(work,
+		struct scsi_qla_host, iocb_work);
+	int cnt = 0;
+
+	while (!list_empty(&vha->work_list)) {
+		qla2x00_do_work(vha);
+		cnt++;
+		if (cnt > 10)
+			break;
+	}
+	schedule_work(&vha->iocb_work);
+}
+
 /*
  * PCI driver interface
  */
@@ -3082,6 +3097,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	 */
 	qla2xxx_wake_dpc(base_vha);
 
+	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
 	INIT_WORK(&ha->board_disable, qla2x00_disable_board_on_pci_error);
 
 	if (IS_QLA8031(ha) || IS_MCTP_CAPABLE(ha)) {
@@ -4323,7 +4339,11 @@ struct qla_work_evt *
 	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
 	spin_unlock_irqrestore(&vha->work_lock, flags);
-	qla2xxx_wake_dpc(vha);
+
+	if (QLA_EARLY_LINKUP(vha->hw))
+		schedule_work(&vha->iocb_work);
+	else
+		qla2xxx_wake_dpc(vha);
 
 	return QLA_SUCCESS;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 45f5077..d7fc9db 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -613,6 +613,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 		break;
 	case SRB_NACK_PRLI:
 		fcport->fw_login_state = DSC_LS_PRLI_PEND;
+		fcport->deleted = 0;
 		c = "PRLI";
 		break;
 	case SRB_NACK_LOGO:
@@ -1551,6 +1552,9 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	request_t *pkt;
 	struct nack_to_isp *nack;
 
+	if (!ha->flags.fw_started)
+		return;
+
 	ql_dbg(ql_dbg_tgt, vha, 0xe004, "Sending NOTIFY_ACK (ha=%p)\n", ha);
 
 	/* Send marker if required */
@@ -2906,7 +2910,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	else
 		vha->tgt_counters.core_qla_que_buf++;
 
-	if (!vha->flags.online || cmd->reset_count != ha->chip_reset) {
+	if (!ha->flags.fw_started || cmd->reset_count != ha->chip_reset) {
 		/*
 		 * Either the port is not online or this request was from
 		 * previous life, just abort the processing.
@@ -3047,7 +3051,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (!vha->flags.online || (cmd->reset_count != ha->chip_reset) ||
+	if (!ha->flags.fw_started || (cmd->reset_count != ha->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
 		 * Either the port is not online or this request was from
@@ -3251,7 +3255,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_tgt_tmr, vha, 0xe01c,
 	    "Sending TERM ELS CTIO (ha=%p)\n", ha);
 
-	pkt = (request_t *)qla2x00_alloc_iocbs_ready(vha, NULL);
+	pkt = (request_t *)qla2x00_alloc_iocbs(vha, NULL);
 	if (pkt == NULL) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe080,
 		    "qla_target(%d): %s failed: unable to allocate "
@@ -4584,7 +4588,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (sess != NULL) {
-			if (sess->fw_login_state == DSC_LS_PLOGI_PEND) {
+			if (sess->fw_login_state != DSC_LS_PLOGI_PEND &&
+			    sess->fw_login_state != DSC_LS_PLOGI_COMP) {
 				/*
 				 * Impatient initiator sent PRLI before last
 				 * PLOGI could finish. Will force him to re-try,
@@ -4623,15 +4628,23 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 		/* Make session global (not used in fabric mode) */
 		if (ha->current_topology != ISP_CFG_F) {
-			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
+			if (sess) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC post nack\n",
+				    __func__, __LINE__, sess->port_name);
+				qla24xx_post_nack_work(vha, sess, iocb,
+					SRB_NACK_PRLI);
+				res = 0;
+			} else {
+				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+				qla2xxx_wake_dpc(vha);
+			}
 		} else {
 			if (sess) {
 				ql_dbg(ql_dbg_disc, vha, 0xffff,
-					   "%s %d %8phC post nack\n",
-					   __func__, __LINE__, sess->port_name);
-
+				    "%s %d %8phC post nack\n",
+				    __func__, __LINE__, sess->port_name);
 				qla24xx_post_nack_work(vha, sess, iocb,
 					SRB_NACK_PRLI);
 				res = 0;
@@ -4639,7 +4652,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 		break;
 
-
 	case ELS_TPRLO:
 		if (le16_to_cpu(iocb->u.isp24.flags) &
 			NOTIFY24XX_FLAGS_GLOBAL_TPRLO) {
@@ -5103,7 +5115,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	unsigned long flags;
 
 	if (unlikely(tgt == NULL)) {
-		ql_dbg(ql_dbg_io, vha, 0x3064,
+		ql_dbg(ql_dbg_tgt, vha, 0x3064,
 		    "ATIO pkt, but no tgt (ha %p)", ha);
 		return;
 	}
@@ -6234,7 +6246,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	struct atio_from_isp *pkt;
 	int cnt, i;
 
-	if (!vha->flags.online)
+	if (!ha->flags.fw_started)
 		return;
 
 	while ((ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) ||
-- 
1.8.3.1
