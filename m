From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/8] qla2xxx: Correct use-after-free issue in terminate_rport_io callback.
Date: Thu, 18 Feb 2010 08:38:30 -0800
Message-ID: <1266511114-307-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:34760 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757880Ab0BRQil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 11:38:41 -0500
In-Reply-To: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The explicit logout (LOGO) issued at the end of the callback will
flush (via normal scsi_cmnd->done()) any outstanding commands
(FCP2) the firmware is holding.  While iterating through the
outstanding_cmnd array in qla2x00_abort_fcport_cmds(), locking
and unlocking of the hardware spinlock, opens-up the driver to
cases where the processed SRB (sp) could be used after the
command completed from interrupt context.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 --
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 -
 drivers/scsi/qla2xxx/qla_os.c   |   38 --------------------------------------
 3 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 25596fe..90d1e06 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1531,8 +1531,6 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 		fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
 			fcport->loop_id, fcport->d_id.b.domain,
 			fcport->d_id.b.area, fcport->d_id.b.al_pa);
-
-	qla2x00_abort_fcport_cmds(fcport);
 }
 
 static int
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 91bb16c..e201650 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -96,7 +96,6 @@ extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
-extern void qla2x00_abort_fcport_cmds(fc_port_t *);
 extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 	struct qla_hw_data *);
 extern void qla2x00_free_host(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cdb089c..8249352 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -682,44 +682,6 @@ qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
 	return (return_status);
 }
 
-void
-qla2x00_abort_fcport_cmds(fc_port_t *fcport)
-{
-	int cnt;
-	unsigned long flags;
-	srb_t *sp;
-	scsi_qla_host_t *vha = fcport->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = vha->req;
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (!sp)
-			continue;
-		if (sp->fcport != fcport)
-			continue;
-		if (sp->ctx)
-			continue;
-
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(sp)) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			"Abort failed --  %lx\n",
-			sp->cmd->serial_number));
-		} else {
-			if (qla2x00_eh_wait_on_command(sp->cmd) !=
-				QLA_SUCCESS)
-				DEBUG2(qla_printk(KERN_WARNING, ha,
-				"Abort failed while waiting --  %lx\n",
-				sp->cmd->serial_number));
-		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
 /**************************************************************************
 * qla2xxx_eh_abort
 *
-- 
1.6.2.rc1.30.gd43c

