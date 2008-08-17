From: michaelc@cs.wisc.edu
Subject: [PATCH 3/6] qla2xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has detected rport error or race
Date: Sun, 17 Aug 2008 15:24:40 -0500
Message-ID: <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47573 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYHQUZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:25:09 -0400
In-Reply-To: <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

If the fcport is not online then we do not want to block IO to all ports on
the host. We just want to stop IO on port not online, so we should be using
the SCSI_MLQUEUE_TARGET_BUSY return value.

For the case where we race with the rport memset initialization
we do not want the queuecommand to be called again so we can just use
SCSI_MLQUEUE_TARGET_BUSY for this.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_os.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c8af7e..a5888f8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -394,10 +394,8 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	/* Close window on fcport/rport state-transitioning. */
-	if (fcport->drport) {
-		cmd->result = DID_IMM_RETRY << 16;
-		goto qc_fail_command;
-	}
+	if (fcport->drport)
+		goto qc_target_busy;
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
@@ -405,7 +403,7 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
-		goto qc_host_busy;
+		goto qc_target_busy;
 	}
 
 	spin_unlock_irq(ha->host->host_lock);
@@ -428,10 +426,11 @@ qc_host_busy_free_sp:
 
 qc_host_busy_lock:
 	spin_lock_irq(ha->host->host_lock);
-
-qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
+qc_target_busy:
+	return SCSI_MLQUEUE_TARGET_BUSY;
+
 qc_fail_command:
 	done(cmd);
 
@@ -461,10 +460,8 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	/* Close window on fcport/rport state-transitioning. */
-	if (fcport->drport) {
-		cmd->result = DID_IMM_RETRY << 16;
-		goto qc24_fail_command;
-	}
+	if (fcport->drport)
+		goto qc24_target_busy;
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
@@ -472,7 +469,7 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
-		goto qc24_host_busy;
+		goto qc24_target_busy;
 	}
 
 	spin_unlock_irq(ha->host->host_lock);
@@ -495,10 +492,11 @@ qc24_host_busy_free_sp:
 
 qc24_host_busy_lock:
 	spin_lock_irq(ha->host->host_lock);
-
-qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
+qc24_target_busy:
+	return SCSI_MLQUEUE_TARGET_BUSY;
+
 qc24_fail_command:
 	done(cmd);
 
-- 
1.5.4.1

