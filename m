From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/12]  qla2xxx: Collapse ISP2xxx queuecommand implementations.
Date: Thu, 13 Oct 2005 16:16:04 -0700 (PDT)
Message-ID: <20051013231604.27191.9981.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:2469 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932531AbVJMXQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:16:04 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_os.c |  144 ++++++++++++-----------------------------
 1 files changed, 41 insertions(+), 103 deletions(-)

applies-to: 78d6d6feb3837ff269b56e589bfba93fd55f9d81
6575ef7122e7f3ce8fc8c90412b2ad4dba65e03c
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 141ff12..04d06a3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -355,111 +355,49 @@ qla2x00_get_new_sp(scsi_qla_host_t *ha, 
 	return sp;
 }
 
-static int
-qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	srb_t *sp;
-	int rval;
-
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
-		goto qc_fail_command;
-	}
-
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
-			cmd->result = DID_NO_CONNECT << 16;
-			goto qc_fail_command;
-		}
-		goto qc_host_busy;
-	}
-
-	spin_unlock_irq(ha->host->host_lock);
-
-	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
-	if (!sp)
-		goto qc_host_busy_lock;
-
-	rval = qla2x00_start_scsi(sp);
-	if (rval != QLA_SUCCESS)
-		goto qc_host_busy_free_sp;
-
-	spin_lock_irq(ha->host->host_lock);
-
-	return 0;
-
-qc_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
-	mempool_free(sp, ha->srb_mempool);
-
-qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
-
-qc_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
-qc_fail_command:
-	done(cmd);
-
-	return 0;
-}
-
-
-static int
-qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
-	srb_t *sp;
-	int rval;
-
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
-		goto qc24_fail_command;
-	}
-
-	if (atomic_read(&fcport->state) != FCS_ONLINE) {
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
-			cmd->result = DID_NO_CONNECT << 16;
-			goto qc24_fail_command;
-		}
-		goto qc24_host_busy;
-	}
-
-	spin_unlock_irq(ha->host->host_lock);
-
-	sp = qla2x00_get_new_sp(ha, fcport, cmd, done);
-	if (!sp)
-		goto qc24_host_busy_lock;
-
-	rval = qla24xx_start_scsi(sp);
-	if (rval != QLA_SUCCESS)
-		goto qc24_host_busy_free_sp;
-
-	spin_lock_irq(ha->host->host_lock);
-
-	return 0;
-
-qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
-	mempool_free(sp, ha->srb_mempool);
-
-qc24_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
-
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
-qc24_fail_command:
-	done(cmd);
-
-	return 0;
+#define QLA_QUEUE_COMMAND(isp)  \
+static int \
+isp##_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)) \
+{ \
+	scsi_qla_host_t *ha = to_qla_host(cmd->device->host); \
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata; \
+	srb_t *sp; \
+	int rval; \
+	if (!fcport) { \
+		cmd->result = DID_NO_CONNECT << 16; \
+		goto fail_command; \
+	} \
+	if (atomic_read(&fcport->state) != FCS_ONLINE) { \
+		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD || \
+		    atomic_read(&ha->loop_state) == LOOP_DEAD) { \
+			cmd->result = DID_NO_CONNECT << 16; \
+			goto fail_command; \
+		} \
+		goto host_busy; \
+	} \
+	spin_unlock_irq(ha->host->host_lock); \
+	sp = qla2x00_get_new_sp(ha, fcport, cmd, done); \
+	if (!sp) \
+		goto host_busy_lock; \
+	rval = isp##_start_scsi(sp); \
+	if (rval != QLA_SUCCESS) \
+		goto host_busy_free_sp; \
+	spin_lock_irq(ha->host->host_lock); \
+	return 0; \
+host_busy_free_sp: \
+	qla2x00_sp_free_dma(ha, sp); \
+	mempool_free(sp, ha->srb_mempool); \
+host_busy_lock: \
+	spin_lock_irq(ha->host->host_lock); \
+host_busy: \
+	return SCSI_MLQUEUE_HOST_BUSY; \
+fail_command: \
+	done(cmd); \
+	return 0; \
 }
 
+QLA_QUEUE_COMMAND(qla2x00);
+QLA_QUEUE_COMMAND(qla24xx);
 
 /*
  * qla2x00_eh_wait_on_command
---
0.99.8.GIT

-- 
Andrew Vasquez
