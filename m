From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.18-rc7
Date: Tue, 31 Jul 2018 08:24:32 -0700
Message-ID: <1533050672.3219.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nine fixes, five in the qla2xxx driver, the most serious of which is
the uninitialized list head crash which can be observed in most systems
under a sufficiently loaded low memory environment.  The two sg fixes
are minor but obvious and two target ones which seem reasonable but not
high impact.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anil Gurumurthy (1):
      scsi: qla2xxx: Return error when TMF returns

Quinn Tran (4):
      scsi: qla2xxx: Fix ISP recovery on unload
      scsi: qla2xxx: Fix driver unload by shutting down chip
      scsi: qla2xxx: Fix NPIV deletion by calling wait_for_sess_deletion
      scsi: qla2xxx: Fix unintialized List head crash

Tony Battersby (2):
      scsi: sg: update comment for blk_get_request()
      scsi: sg: fix minor memory leak in error path

Varun Prakash (2):
      scsi: libiscsi: fix possible NULL pointer dereference in case of TMF
      scsi: target: iscsi: cxgbit: fix max iso npdu calculation

And the diffstat:

 drivers/scsi/libiscsi.c                     | 12 +++----
 drivers/scsi/qla2xxx/qla_attr.c             |  1 +
 drivers/scsi/qla2xxx/qla_gbl.h              |  1 +
 drivers/scsi/qla2xxx/qla_gs.c               |  4 +++
 drivers/scsi/qla2xxx/qla_init.c             |  7 ++--
 drivers/scsi/qla2xxx/qla_inline.h           |  2 ++
 drivers/scsi/qla2xxx/qla_isr.c              |  3 ++
 drivers/scsi/qla2xxx/qla_mbx.c              |  6 ++++
 drivers/scsi/qla2xxx/qla_mid.c              | 11 +++++--
 drivers/scsi/qla2xxx/qla_os.c               | 51 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_sup.c              |  3 ++
 drivers/scsi/sg.c                           | 15 ++++-----
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 16 +++++----
 13 files changed, 75 insertions(+), 57 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d6093838f5f2..c972cc2b3d5b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -284,11 +284,11 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 */
 		if (opcode != ISCSI_OP_SCSI_DATA_OUT) {
 			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x/%x itt "
+					  "task [op %x itt "
 					  "0x%x/0x%x] "
 					  "rejected.\n",
-					  task->hdr->opcode, opcode,
-					  task->itt, task->hdr_itt);
+					  opcode, task->itt,
+					  task->hdr_itt);
 			return -EACCES;
 		}
 		/*
@@ -297,10 +297,10 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		 */
 		if (conn->session->fast_abort) {
 			iscsi_conn_printk(KERN_INFO, conn,
-					  "task [op %x/%x itt "
+					  "task [op %x itt "
 					  "0x%x/0x%x] fast abort.\n",
-					  task->hdr->opcode, opcode,
-					  task->itt, task->hdr_itt);
+					  opcode, task->itt,
+					  task->hdr_itt);
 			return -EACCES;
 		}
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 89a4999fa631..c8731568f9c4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2141,6 +2141,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		msleep(1000);
 
 	qla24xx_disable_vp(vha);
+	qla2x00_wait_for_sess_deletion(vha);
 
 	vha->flags.delete_progress = 1;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f68eb6096559..2660a48d918a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -214,6 +214,7 @@ void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_abort_cmd(srb_t *);
 int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
+void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 2c35b0b2baa0..7a3744006419 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3708,6 +3708,10 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	return rval;
 
 done_free_sp:
+	spin_lock_irqsave(&vha->hw->vport_slock, flags);
+	list_del(&sp->elem);
+	spin_unlock_irqrestore(&vha->hw->vport_slock, flags);
+
 	if (sp->u.iocb_cmd.u.ctarg.req) {
 		dma_free_coherent(&vha->hw->pdev->dev,
 			sizeof(struct ct_sns_pkt),
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index db0e3279e07a..1b19b954bbae 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1489,11 +1489,10 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 	wait_for_completion(&tm_iocb->u.tmf.comp);
 
-	rval = tm_iocb->u.tmf.comp_status == CS_COMPLETE ?
-	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
+	rval = tm_iocb->u.tmf.data;
 
-	if ((rval != QLA_SUCCESS) || tm_iocb->u.tmf.data) {
-		ql_dbg(ql_dbg_taskm, vha, 0x8030,
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x8030,
 		    "TM IOCB failed (%x).\n", rval);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 37ae0f6d8ae5..59fd5a9dfeb8 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -222,6 +222,8 @@ qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
 	sp->fcport = fcport;
 	sp->iocbs = 1;
 	sp->vha = qpair->vha;
+	INIT_LIST_HEAD(&sp->elem);
+
 done:
 	if (!sp)
 		QLA_QPAIR_MARK_NOT_BUSY(qpair);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9fa5a2557f2c..7756106d4555 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -631,6 +631,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	unsigned long	flags;
 	fc_port_t	*fcport = NULL;
 
+	if (!vha->hw->flags.fw_started)
+		return;
+
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
 	if (IS_CNA_CAPABLE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7e875f575229..f0ec13d48bf3 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4220,6 +4220,9 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!ha->flags.fw_started)
+		return QLA_SUCCESS;
+
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d3,
 	    "Entered %s.\n", __func__);
 
@@ -4289,6 +4292,9 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!ha->flags.fw_started)
+		return QLA_SUCCESS;
+
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10d6,
 	    "Entered %s.\n", __func__);
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f6f0a759a7c2..aa727d07b702 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -152,11 +152,18 @@ int
 qla24xx_disable_vp(scsi_qla_host_t *vha)
 {
 	unsigned long flags;
-	int ret;
+	int ret = QLA_SUCCESS;
+	fc_port_t *fcport;
+
+	if (vha->hw->flags.fw_started)
+		ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 
-	ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		fcport->logout_on_delete = 0;
+
+	qla2x00_mark_all_devices_lost(vha, 0);
 
 	/* Remove port id from vp target map */
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f309e572be4..1fbd16c8c9a7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -303,6 +303,7 @@ static void qla2x00_free_device(scsi_qla_host_t *);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
 static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
 
+
 struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
@@ -1147,7 +1148,7 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
  * qla2x00_wait_for_sess_deletion can only be called from remove_one.
  * it has dependency on UNLOADING flag to stop device discovery
  */
-static void
+void
 qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 {
 	qla2x00_mark_all_devices_lost(vha, 0);
@@ -3603,6 +3604,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
+	ql_log(ql_log_info, base_vha, 0xb079,
+	    "Removing driver\n");
 
 	/* Indicate device removal to prevent future board_disable and wait
 	 * until any pending board_disable has completed. */
@@ -3625,6 +3628,21 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	}
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha)) {
+		if (ha->flags.fw_started)
+			qla2x00_abort_isp_cleanup(base_vha);
+	} else if (!IS_QLAFX00(ha)) {
+		if (IS_QLA8031(ha)) {
+			ql_dbg(ql_dbg_p3p, base_vha, 0xb07e,
+			    "Clearing fcoe driver presence.\n");
+			if (qla83xx_clear_drv_presence(base_vha) != QLA_SUCCESS)
+				ql_dbg(ql_dbg_p3p, base_vha, 0xb079,
+				    "Error while clearing DRV-Presence.\n");
+		}
+
+		qla2x00_try_to_stop_firmware(base_vha);
+	}
+
 	qla2x00_wait_for_sess_deletion(base_vha);
 
 	/*
@@ -3648,14 +3666,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_delete_all_vps(ha, base_vha);
 
-	if (IS_QLA8031(ha)) {
-		ql_dbg(ql_dbg_p3p, base_vha, 0xb07e,
-		    "Clearing fcoe driver presence.\n");
-		if (qla83xx_clear_drv_presence(base_vha) != QLA_SUCCESS)
-			ql_dbg(ql_dbg_p3p, base_vha, 0xb079,
-			    "Error while clearing DRV-Presence.\n");
-	}
-
 	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
 
 	qla2x00_dfs_remove(base_vha);
@@ -3715,24 +3725,6 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 		qla2x00_stop_timer(vha);
 
 	qla25xx_delete_queues(vha);
-
-	if (ha->flags.fce_enabled)
-		qla2x00_disable_fce_trace(vha, NULL, NULL);
-
-	if (ha->eft)
-		qla2x00_disable_eft_trace(vha);
-
-	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha)) {
-		if (ha->flags.fw_started)
-			qla2x00_abort_isp_cleanup(vha);
-	} else {
-		if (ha->flags.fw_started) {
-			/* Stop currently executing firmware. */
-			qla2x00_try_to_stop_firmware(vha);
-			ha->flags.fw_started = 0;
-		}
-	}
-
 	vha->flags.online = 0;
 
 	/* turn-off interrupts on the card */
@@ -6028,8 +6020,9 @@ qla2x00_do_dpc(void *data)
 				set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 		}
 
-		if (test_and_clear_bit(ISP_ABORT_NEEDED,
-						&base_vha->dpc_flags)) {
+		if (test_and_clear_bit
+		    (ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
+		    !test_bit(UNLOADING, &base_vha->dpc_flags)) {
 
 			ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
 			    "ISP abort scheduled.\n");
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 04458eb19d38..4499c787165f 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1880,6 +1880,9 @@ qla24xx_beacon_off(struct scsi_qla_host *vha)
 	if (IS_P3P_TYPE(ha))
 		return QLA_SUCCESS;
 
+	if (!ha->flags.fw_started)
+		return QLA_SUCCESS;
+
 	ha->beacon_blink_led = 0;
 
 	if (IS_QLA2031(ha) || IS_QLA27XX(ha))
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cd2fdac000c9..ba9ba0e04f42 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1741,15 +1741,11 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	 *
 	 * With scsi-mq enabled, there are a fixed number of preallocated
 	 * requests equal in number to shost->can_queue.  If all of the
-	 * preallocated requests are already in use, then using GFP_ATOMIC with
-	 * blk_get_request() will return -EWOULDBLOCK, whereas using GFP_KERNEL
-	 * will cause blk_get_request() to sleep until an active command
-	 * completes, freeing up a request.  Neither option is ideal, but
-	 * GFP_KERNEL is the better choice to prevent userspace from getting an
-	 * unexpected EWOULDBLOCK.
-	 *
-	 * With scsi-mq disabled, blk_get_request() with GFP_KERNEL usually
-	 * does not sleep except under memory pressure.
+	 * preallocated requests are already in use, then blk_get_request()
+	 * will sleep until an active command completes, freeing up a request.
+	 * Although waiting in an asynchronous interface is less than ideal, we
+	 * do not want to use BLK_MQ_REQ_NOWAIT here because userspace might
+	 * not expect an EWOULDBLOCK from this condition.
 	 */
 	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
@@ -2185,6 +2181,7 @@ sg_add_sfp(Sg_device * sdp)
 	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	if (atomic_read(&sdp->detaching)) {
 		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 514986b57c2d..25eb3891e34b 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -652,6 +652,7 @@ static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
 	struct iscsi_param *param;
 	u32 mrdsl, mbl;
 	u32 max_npdu, max_iso_npdu;
+	u32 max_iso_payload;
 
 	if (conn->login->leading_connection) {
 		param = iscsi_find_param_from_key(MAXBURSTLENGTH,
@@ -670,8 +671,10 @@ static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
 	mrdsl = conn_ops->MaxRecvDataSegmentLength;
 	max_npdu = mbl / mrdsl;
 
-	max_iso_npdu = CXGBIT_MAX_ISO_PAYLOAD /
-			(ISCSI_HDR_LEN + mrdsl +
+	max_iso_payload = rounddown(CXGBIT_MAX_ISO_PAYLOAD, csk->emss);
+
+	max_iso_npdu = max_iso_payload /
+		       (ISCSI_HDR_LEN + mrdsl +
 			cxgbit_digest_len[csk->submode]);
 
 	csk->max_iso_npdu = min(max_npdu, max_iso_npdu);
@@ -741,6 +744,9 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 	if (conn_ops->MaxRecvDataSegmentLength > cdev->mdsl)
 		conn_ops->MaxRecvDataSegmentLength = cdev->mdsl;
 
+	if (cxgbit_set_digest(csk))
+		return -1;
+
 	if (conn->login->leading_connection) {
 		param = iscsi_find_param_from_key(ERRORRECOVERYLEVEL,
 						  conn->param_list);
@@ -764,7 +770,7 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 			if (is_t5(cdev->lldi.adapter_type))
 				goto enable_ddp;
 			else
-				goto enable_digest;
+				return 0;
 		}
 
 		if (test_bit(CDEV_ISO_ENABLE, &cdev->flags)) {
@@ -781,10 +787,6 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 		}
 	}
 
-enable_digest:
-	if (cxgbit_set_digest(csk))
-		return -1;
-
 	return 0;
 }
 
