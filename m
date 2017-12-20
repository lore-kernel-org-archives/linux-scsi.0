From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 11/43] qla2xxx: Move work element processing out of DPC thread
Date: Tue, 19 Dec 2017 22:56:12 -0800
Message-ID: <20171220065644.21511-12-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0074.outbound.protection.outlook.com ([104.47.36.74]:18597
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932372AbdLTG5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:07 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

DPC thread can stall during switch scan due to slow switch response.
This will stall other work element that needs attention. Moving work
element processing and relogin logic out of DPC thread and into its
own work queue.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  6 ++--
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
 drivers/scsi/qla2xxx/qla_init.c |  1 +
 drivers/scsi/qla2xxx/qla_mid.c  |  6 +---
 drivers/scsi/qla2xxx/qla_os.c   | 76 +++++++++++++++++++++++++++++++----------
 5 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 18b393453002..a2c0f3d78b35 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3183,6 +3183,7 @@ enum qla_work_type {
 	QLA_EVT_UPD_FCPORT,
 	QLA_EVT_GNL,
 	QLA_EVT_NACK,
+	QLA_EVT_RELOGIN,
 };
 
 
@@ -3513,10 +3514,6 @@ struct qlt_hw_data {
 
 #define LEAK_EXCHG_THRESH_HOLD_PERCENT 75	/* 75 percent */
 
-#define QLA_EARLY_LINKUP(_ha) \
-	((_ha->flags.n2n_ae || _ha->flags.lip_ae) && \
-	 _ha->flags.fw_started && !_ha->flags.fw_init_done)
-
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -4222,6 +4219,7 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED	28
 #define DETECT_SFP_CHANGE	29
 #define N2N_LOGIN_NEEDED	30
+#define IOCB_WORK_ACTIVE	31
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 66dcbdb91244..fb1c9ffdc05a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -204,7 +204,7 @@ void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_abort_cmd(srb_t *);
-
+int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
 /*
  * Global Functions in qla_mid.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0a1c287c2d66..61b74fd220a3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -901,6 +901,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		    __func__, fcport->port_name, fcport->last_rscn_gen,
 		    fcport->rscn_gen, fcport->last_login_gen,
 		    fcport->login_gen);
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return;
 	} else if (ea->sp->gen1 != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20d4, "%s %d %8phC post gidpn\n",
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index fc61fef5e305..b2fda398a098 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -319,8 +319,6 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_dpc + ql_dbg_verbose, vha, 0x4012,
 	    "Entering %s vp_flags: 0x%lx.\n", __func__, vha->vp_flags);
 
-	qla2x00_do_work(vha);
-
 	/* Check if Fw is ready to configure VP first */
 	if (test_bit(VP_CONFIG_OK, &base_vha->vp_flags)) {
 		if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
@@ -354,9 +352,7 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 
 			ql_dbg(ql_dbg_dpc, vha, 0x4018,
 			    "Relogin needed scheduled.\n");
-			qla2x00_relogin(vha);
-			ql_dbg(ql_dbg_dpc, vha, 0x4019,
-			    "Relogin needed end.\n");
+			qla24xx_post_relogin_work(vha);
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4a542a5a976d..66e6fe73a035 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2683,14 +2683,22 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 {
 	struct scsi_qla_host *vha = container_of(work,
 		struct scsi_qla_host, iocb_work);
-	int cnt = 0;
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	int i = 20;
+	unsigned long flags;
+
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
 
-	while (!list_empty(&vha->work_list)) {
+	while (!list_empty(&vha->work_list) && i > 0) {
 		qla2x00_do_work(vha);
-		cnt++;
-		if (cnt > 10)
-			break;
+		i--;
 	}
+
+	spin_lock_irqsave(&vha->work_lock, flags);
+	clear_bit(IOCB_WORK_ACTIVE, &vha->dpc_flags);
+	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
 
 /*
@@ -3192,7 +3200,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
-	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
+	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
 
 	if (ha->mqenable) {
 		bool mq = false;
@@ -4544,6 +4552,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	INIT_LIST_HEAD(&vha->gnl.fcports);
 	INIT_LIST_HEAD(&vha->nvme_rport_list);
 	INIT_LIST_HEAD(&vha->gpnid_list);
+	INIT_WORK(&vha->iocb_work, qla2x00_iocb_work_fn);
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
@@ -4596,15 +4605,18 @@ int
 qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
 	unsigned long flags;
+	bool q = false;
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
+
+	if (!test_and_set_bit(IOCB_WORK_ACTIVE, &vha->dpc_flags))
+		q = true;
+
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
-	if (QLA_EARLY_LINKUP(vha->hw))
-		schedule_work(&vha->iocb_work);
-	else
-		qla2xxx_wake_dpc(vha);
+	if (q)
+		queue_work(vha->hw->wq, &vha->iocb_work);
 
 	return QLA_SUCCESS;
 }
@@ -4736,6 +4748,9 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		fcport->d_id = e->u.new_sess.id;
 		if (pla) {
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
+			memcpy(fcport->node_name,
+			    pla->iocb.u.isp24.u.plogi.node_name,
+			    WWN_SIZE);
 			qlt_plogi_ack_link(vha, pla, fcport, QLT_PLOGI_LINK_SAME_WWN);
 			/* we took an extra ref_count to prevent PLOGI ACK when
 			 * fcport/sess has not been created.
@@ -4886,6 +4901,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_GPNID_DONE:
 			qla24xx_async_gpnid_done(vha, e->u.iosb.sp);
 			break;
+		case QLA_EVT_RELOGIN:
+			qla2x00_relogin(vha);
+			break;
 		case QLA_EVT_NEW_SESS:
 			qla24xx_create_new_sess(vha, e);
 			break;
@@ -4917,6 +4935,20 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 	}
 }
 
+int qla24xx_post_relogin_work(struct scsi_qla_host *vha)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_RELOGIN);
+
+	if (!e) {
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		return QLA_FUNCTION_FAILED;
+	}
+
+	return qla2x00_post_work(vha, e);
+}
+
 /* Relogins all the fcports of a vport
  * Context: dpc thread
  */
@@ -4972,6 +5004,9 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
 			break;
 	}
+
+	ql_dbg(ql_dbg_disc, vha, 0x400e,
+	    "Relogin end.\n");
 }
 
 /* Schedule work on any of the dpc-workqueues */
@@ -5747,8 +5782,6 @@ qla2x00_do_dpc(void *data)
 		if (test_bit(UNLOADING, &base_vha->dpc_flags))
 			break;
 
-		qla2x00_do_work(base_vha);
-
 		if (IS_P3P_TYPE(ha)) {
 			if (IS_QLA8044(ha)) {
 				if (test_and_clear_bit(ISP_UNRECOVERABLE,
@@ -5936,11 +5969,9 @@ qla2x00_do_dpc(void *data)
 				base_vha->relogin_jif = jiffies + HZ;
 				clear_bit(RELOGIN_NEEDED, &base_vha->dpc_flags);
 
-				ql_dbg(ql_dbg_dpc, base_vha, 0x400d,
+				ql_dbg(ql_dbg_disc, base_vha, 0x400d,
 				    "Relogin scheduled.\n");
-				qla2x00_relogin(base_vha);
-				ql_dbg(ql_dbg_dpc, base_vha, 0x400e,
-				    "Relogin end.\n");
+				qla24xx_post_relogin_work(base_vha);
 			}
 		}
 loop_resync_check:
@@ -6200,8 +6231,17 @@ qla2x00_timer(struct timer_list *t)
 	}
 
 	/* Process any deferred work. */
-	if (!list_empty(&vha->work_list))
-		start_dpc++;
+	if (!list_empty(&vha->work_list)) {
+		unsigned long flags;
+		bool q = false;
+
+		spin_lock_irqsave(&vha->work_lock, flags);
+		if (!test_and_set_bit(IOCB_WORK_ACTIVE, &vha->dpc_flags))
+			q = true;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+		if (q)
+			queue_work(vha->hw->wq, &vha->iocb_work);
+	}
 
 	/*
 	 * FC-NVME
-- 
2.12.0
