From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/22] Revert "qla2xxx: Ramp down queue depth for attached SCSI devices when driver resources are low."
Date: Wed, 30 Oct 2013 03:38:14 -0400
Message-ID: <1383118709-5569-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:27110 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752469Ab3J3ILW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:22 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

This reverts commit 3c290d0b5f8ff7b0fd2c964c5ec2c14191a9e790

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |   17 ++-----
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 -
 drivers/scsi/qla2xxx/qla_inline.h |   19 -------
 drivers/scsi/qla2xxx/qla_isr.c    |    4 --
 drivers/scsi/qla2xxx/qla_mr.c     |    4 --
 drivers/scsi/qla2xxx/qla_os.c     |  107 ++----------------------------------
 6 files changed, 10 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 93db74e..82b18c0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2734,7 +2734,6 @@ struct req_que {
 	srb_t **outstanding_cmds;
 	uint32_t current_outstanding_cmd;
 	uint16_t num_outstanding_cmds;
-#define	MAX_Q_DEPTH		32
 	int max_q_depth;
 
 	dma_addr_t  dma_fx00;
@@ -3303,12 +3302,6 @@ struct qla_hw_data {
 	struct work_struct idc_state_handler;
 	struct work_struct nic_core_unrecoverable;
 
-#define HOST_QUEUE_RAMPDOWN_INTERVAL           (60 * HZ)
-#define HOST_QUEUE_RAMPUP_INTERVAL             (30 * HZ)
-	unsigned long   host_last_rampdown_time;
-	unsigned long   host_last_rampup_time;
-	int             cfg_lun_q_depth;
-
 	struct mr_data_fx00 mr;
 
 	struct qlt_hw_data tgt;
@@ -3372,12 +3365,10 @@ typedef struct scsi_qla_host {
 #define MPI_RESET_NEEDED	19	/* Initiate MPI FW reset */
 #define ISP_QUIESCE_NEEDED	20	/* Driver need some quiescence */
 #define SCR_PENDING		21	/* SCR in target mode */
-#define HOST_RAMP_DOWN_QUEUE_DEPTH     22
-#define HOST_RAMP_UP_QUEUE_DEPTH       23
-#define PORT_UPDATE_NEEDED	24
-#define FX00_RESET_RECOVERY	25
-#define FX00_TARGET_SCAN	26
-#define FX00_CRITEMP_RECOVERY	27
+#define PORT_UPDATE_NEEDED	22
+#define FX00_RESET_RECOVERY	23
+#define FX00_TARGET_SCAN	24
+#define FX00_CRITEMP_RECOVERY	25
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4446bf5..826df52 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -98,7 +98,6 @@ extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
-extern int ql2xmaxqdepth;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xiidmaenable;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 957088b..ce8b5fb 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -261,25 +261,6 @@ qla2x00_gid_list_size(struct qla_hw_data *ha)
 }
 
 static inline void
-qla2x00_do_host_ramp_up(scsi_qla_host_t *vha)
-{
-	if (vha->hw->cfg_lun_q_depth >= ql2xmaxqdepth)
-		return;
-
-	/* Wait at least HOST_QUEUE_RAMPDOWN_INTERVAL before ramping up */
-	if (time_before(jiffies, (vha->hw->host_last_rampdown_time +
-	    HOST_QUEUE_RAMPDOWN_INTERVAL)))
-		return;
-
-	/* Wait at least HOST_QUEUE_RAMPUP_INTERVAL between each ramp up */
-	if (time_before(jiffies, (vha->hw->host_last_rampup_time +
-	    HOST_QUEUE_RAMPUP_INTERVAL)))
-		return;
-
-	set_bit(HOST_RAMP_UP_QUEUE_DEPTH, &vha->dpc_flags);
-}
-
-static inline void
 qla2x00_handle_mbx_completion(struct qla_hw_data *ha, int status)
 {
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e649d7..2e6eae3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1991,7 +1991,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
-		qla2x00_do_host_ramp_up(vha);
 		qla2x00_process_completed_request(vha, req, handle);
 
 		return;
@@ -2250,9 +2249,6 @@ out:
 		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
 		    resid_len, fw_resid_len);
 
-	if (!res)
-		qla2x00_do_host_ramp_up(vha);
-
 	if (rsp->status_srb == NULL)
 		sp->done(ha, sp, res);
 }
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 62ee713..ea03f85 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2421,7 +2421,6 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
-		qla2x00_do_host_ramp_up(vha);
 		qla2x00_process_completed_request(vha, req, handle);
 		return;
 	}
@@ -2632,9 +2631,6 @@ check_scsi_status:
 		    rsp_info_len, resid_len, fw_resid_len, sense_len,
 		    par_sense_len, rsp_info_len);
 
-	if (!res)
-		qla2x00_do_host_ramp_up(vha);
-
 	if (rsp->status_srb == NULL)
 		sp->done(ha, sp, res);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7d4f10d..01392d0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -110,7 +110,8 @@ MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
 
-int ql2xmaxqdepth = MAX_Q_DEPTH;
+#define MAX_Q_DEPTH	32
+static int ql2xmaxqdepth = MAX_Q_DEPTH;
 module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to set for each LUN. "
@@ -732,10 +733,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
-	if (!sp) {
-		set_bit(HOST_RAMP_DOWN_QUEUE_DEPTH, &vha->dpc_flags);
+	if (!sp)
 		goto qc24_host_busy;
-	}
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
@@ -748,7 +747,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3013,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
-		set_bit(HOST_RAMP_DOWN_QUEUE_DEPTH, &vha->dpc_flags);
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1478,81 +1476,6 @@ qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
 	return tag_type;
 }
 
-static void
-qla2x00_host_ramp_down_queuedepth(scsi_qla_host_t *vha)
-{
-	scsi_qla_host_t *vp;
-	struct Scsi_Host *shost;
-	struct scsi_device *sdev;
-	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags;
-
-	ha->host_last_rampdown_time = jiffies;
-
-	if (ha->cfg_lun_q_depth <= vha->host->cmd_per_lun)
-		return;
-
-	if ((ha->cfg_lun_q_depth / 2) < vha->host->cmd_per_lun)
-		ha->cfg_lun_q_depth = vha->host->cmd_per_lun;
-	else
-		ha->cfg_lun_q_depth = ha->cfg_lun_q_depth / 2;
-
-	/*
-	 * Geometrically ramp down the queue depth for all devices on this
-	 * adapter
-	 */
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
-		shost = vp->host;
-		shost_for_each_device(sdev, shost) {
-			if (sdev->queue_depth > shost->cmd_per_lun) {
-				if (sdev->queue_depth < ha->cfg_lun_q_depth)
-					continue;
-				ql_dbg(ql_dbg_io, vp, 0x3031,
-				    "%ld:%d:%d: Ramping down queue depth to %d",
-				    vp->host_no, sdev->id, sdev->lun,
-				    ha->cfg_lun_q_depth);
-				qla2x00_change_queue_depth(sdev,
-				    ha->cfg_lun_q_depth, SCSI_QDEPTH_DEFAULT);
-			}
-		}
-	}
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
-
-	return;
-}
-
-static void
-qla2x00_host_ramp_up_queuedepth(scsi_qla_host_t *vha)
-{
-	scsi_qla_host_t *vp;
-	struct Scsi_Host *shost;
-	struct scsi_device *sdev;
-	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags;
-
-	ha->host_last_rampup_time = jiffies;
-	ha->cfg_lun_q_depth++;
-
-	/*
-	 * Linearly ramp up the queue depth for all devices on this
-	 * adapter
-	 */
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
-		shost = vp->host;
-		shost_for_each_device(sdev, shost) {
-			if (sdev->queue_depth > ha->cfg_lun_q_depth)
-				continue;
-			qla2x00_change_queue_depth(sdev, ha->cfg_lun_q_depth,
-			    SCSI_QDEPTH_RAMP_UP);
-		}
-	}
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
-
-	return;
-}
-
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
@@ -2428,7 +2351,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
-	ha->cfg_lun_q_depth = ql2xmaxqdepth;
 
 	/* Assign ISP specific operations. */
 	if (IS_QLA2100(ha)) {
@@ -4999,17 +4921,6 @@ loop_resync_check:
 			qla2xxx_flash_npiv_conf(base_vha);
 		}
 
-		if (test_and_clear_bit(HOST_RAMP_DOWN_QUEUE_DEPTH,
-		    &base_vha->dpc_flags)) {
-			/* Prevents simultaneous ramp up and down */
-			clear_bit(HOST_RAMP_UP_QUEUE_DEPTH,
-			    &base_vha->dpc_flags);
-			qla2x00_host_ramp_down_queuedepth(base_vha);
-		}
-
-		if (test_and_clear_bit(HOST_RAMP_UP_QUEUE_DEPTH,
-		    &base_vha->dpc_flags))
-			qla2x00_host_ramp_up_queuedepth(base_vha);
 intr_on_check:
 		if (!ha->interrupts_on)
 			ha->isp_ops->enable_intrs(ha);
@@ -5191,7 +5102,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		    "Loop down - seconds remaining %d.\n",
 		    atomic_read(&vha->loop_down_timer));
 	}
-
 	/* Check if beacon LED needs to be blinked for physical host only */
 	if (!vha->vp_idx && (ha->beacon_blink_led == 1)) {
 		/* There is no beacon_blink function for ISP82xx */
@@ -5215,9 +5125,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	    test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags) ||
 	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) ||
 	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
-	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags) ||
-	    test_bit(HOST_RAMP_DOWN_QUEUE_DEPTH, &vha->dpc_flags) ||
-	    test_bit(HOST_RAMP_UP_QUEUE_DEPTH, &vha->dpc_flags))) {
+	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags))) {
 		ql_dbg(ql_dbg_timer, vha, 0x600b,
 		    "isp_abort_needed=%d loop_resync_needed=%d "
 		    "fcport_update_needed=%d start_dpc=%d "
@@ -5230,15 +5138,12 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_timer, vha, 0x600c,
 		    "beacon_blink_needed=%d isp_unrecoverable=%d "
 		    "fcoe_ctx_reset_needed=%d vp_dpc_needed=%d "
-		    "relogin_needed=%d, host_ramp_down_needed=%d "
-		    "host_ramp_up_needed=%d.\n",
+		    "relogin_needed=%d.\n",
 		    test_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags),
 		    test_bit(ISP_UNRECOVERABLE, &vha->dpc_flags),
 		    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags),
 		    test_bit(VP_DPC_NEEDED, &vha->dpc_flags),
-		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags),
-		    test_bit(HOST_RAMP_UP_QUEUE_DEPTH, &vha->dpc_flags),
-		    test_bit(HOST_RAMP_DOWN_QUEUE_DEPTH, &vha->dpc_flags));
+		    test_bit(RELOGIN_NEEDED, &vha->dpc_flags));
 		qla2xxx_wake_dpc(vha);
 	}
 
-- 
1.7.7

