From: michaelc@cs.wisc.edu
Subject: [PATCH 7/9] qla2xxx: convert to use fc helper and SCSI_MLQUEUE_TARGET_BUSY
Date: Sun,  2 Mar 2008 03:03:20 -0600
Message-ID: <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYCBJEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:10 -0500
In-Reply-To: <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When transitioning to the blocked state use SCSI_ML_TARGET_BUSY
instead of returning with DID_IMM_RETRY, because DID_IMM_RETRY
causes a requeue and then possibly (if under recursion limits)
a queuecommand call.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla2xxx/qla_os.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c1b433..36f1d9e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -379,11 +379,11 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc_fail_command;
 	}
 
-	rval = fc_remote_port_chkready(rport);
-	if (rval) {
-		cmd->result = rval;
+	rval = fc_remote_port_queue_ready(rport, cmd);
+	if (rval)
+		goto qc_busy;
+	if (cmd->result)
 		goto qc_fail_command;
-	}
 
 	/* Close window on fcport/rport state-transitioning. */
 	if (!*(fc_port_t **)rport->dd_data) {
@@ -397,7 +397,8 @@ qla2x00_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
-		goto qc_host_busy;
+		rval = SCSI_MLQUEUE_HOST_BUSY;
+		goto qc_busy;
 	}
 
 	spin_unlock_irq(ha->host->host_lock);
@@ -419,10 +420,11 @@ qc_host_busy_free_sp:
 	mempool_free(sp, ha->srb_mempool);
 
 qc_host_busy_lock:
+	rval = SCSI_MLQUEUE_HOST_BUSY;
 	spin_lock_irq(ha->host->host_lock);
 
-qc_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
+qc_busy:
+	return rval;
 
 qc_fail_command:
 	done(cmd);
@@ -446,11 +448,11 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc24_fail_command;
 	}
 
-	rval = fc_remote_port_chkready(rport);
-	if (rval) {
-		cmd->result = rval;
+	rval = fc_remote_port_queue_ready(rport, cmd);
+	if (rval)
+		goto qc24_busy;
+	if (cmd->result)
 		goto qc24_fail_command;
-	}
 
 	/* Close window on fcport/rport state-transitioning. */
 	if (!*(fc_port_t **)rport->dd_data) {
@@ -464,7 +466,8 @@ qla24xx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 		}
-		goto qc24_host_busy;
+		rval = SCSI_MLQUEUE_HOST_BUSY;
+		goto qc24_busy;
 	}
 
 	spin_unlock_irq(ha->host->host_lock);
@@ -486,10 +489,11 @@ qc24_host_busy_free_sp:
 	mempool_free(sp, pha->srb_mempool);
 
 qc24_host_busy_lock:
+	rval = SCSI_MLQUEUE_HOST_BUSY;
 	spin_lock_irq(ha->host->host_lock);
 
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
+qc24_busy:
+	return rval;
 
 qc24_fail_command:
 	done(cmd);
-- 
1.5.4.1

