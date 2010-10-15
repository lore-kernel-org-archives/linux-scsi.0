From: madhu.iyengar@qlogic.com
Subject: [PATCH 12/12] qla2xxx: Avoid depending on SCSI host_lock in queuecommand function.
Date: Fri, 15 Oct 2010 11:27:49 -0700
Message-ID: <1287167269-8034-13-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36964 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756371Ab0JOSg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:29 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    8 ++++----
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |   14 ++++++--------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a9ceb39..bc8194f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1538,6 +1538,10 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	/* Now that the rport has been deleted, set the fcport state to
+	   FCS_DEVICE_DEAD */
+	atomic_set(&fcport->state, FCS_DEVICE_DEAD);
+
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
@@ -1547,10 +1551,6 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	*((fc_port_t **)rport->dd_data) = NULL;
 	spin_unlock_irq(host->host_lock);
 
-	/* Now that the rport has been deleted, set the fcport state to
-	   FCS_DEVICE_DEAD */
-	atomic_set(&fcport->state, FCS_DEVICE_DEAD);
-
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a7ad22b..259f511 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2928,8 +2928,8 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
 	qla2x00_iidma_fcport(vha, fcport);
-	atomic_set(&fcport->state, FCS_ONLINE);
 	qla2x00_reg_remote_port(vha, fcport);
+	atomic_set(&fcport->state, FCS_ONLINE);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b0c7139..77203b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -545,6 +545,7 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	srb_t *sp;
 	int rval;
 
+	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -559,10 +560,6 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc24_fail_command;
 	}
 
-	/* Close window on fcport/rport state-transitioning. */
-	if (fcport->drport)
-		goto qc24_target_busy;
-
 	if (!vha->flags.difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
 			DEBUG2(qla_printk(KERN_ERR, ha,
@@ -573,15 +570,14 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
+			atomic_read(&fcport->state) == FCS_DEVICE_LOST ||
+			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
 		goto qc24_target_busy;
 	}
 
-	spin_unlock_irq(vha->host->host_lock);
-
 	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
 		goto qc24_host_busy_lock;
@@ -603,9 +599,11 @@ qc24_host_busy_lock:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
+	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
+	spin_lock_irq(vha->host->host_lock);
 	done(cmd);
 
 	return 0;
@@ -2613,12 +2611,12 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			atomic_set(&fcport->state, FCS_DEVICE_LOST);
 			if (defer)
 				qla2x00_schedule_rport_del(vha, fcport, defer);
 			else if (vha->vp_idx == fcport->vp_idx)
 				qla2x00_schedule_rport_del(vha, fcport, defer);
 		}
-		atomic_set(&fcport->state, FCS_DEVICE_LOST);
 	}
 }
 
-- 
1.6.0.2

