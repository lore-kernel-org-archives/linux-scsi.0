From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/14] qla2xxx: Remove qla2x00_wait_for_loop_ready function.
Date: Fri, 18 Nov 2011 09:02:09 -0800
Message-ID: <1321635742-16426-2-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:47087 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758198Ab1KRRP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:29 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

This function can wait for 5min under certain scenarios. One of them is when
the port is down from switch and bus reset is issued. The bus reset used to
wait for 5 minutes for the loop and upper layer callers used to hang and give
stack trace because of getting stuck for 120 sec. Its legacy code that was used
when the driver used to do queuing of the commands.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   70 ++--------------------------------------
 1 files changed, 4 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fd14c7b..93673d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -814,49 +814,6 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
 	return return_status;
 }
 
-/*
- * qla2x00_wait_for_loop_ready
- *    Wait for MAX_LOOP_TIMEOUT(5 min) value for loop
- *    to be in LOOP_READY state.
- * Input:
- *     ha - pointer to host adapter structure
- *
- * Note:
- *    Does context switching-Release SPIN_LOCK
- *    (if any) before calling this routine.
- *
- *
- * Return:
- *    Success (LOOP_READY) : 0
- *    Failed  (LOOP_NOT_READY) : 1
- */
-static inline int
-qla2x00_wait_for_loop_ready(scsi_qla_host_t *vha)
-{
-	int 	 return_status = QLA_SUCCESS;
-	unsigned long loop_timeout ;
-	struct qla_hw_data *ha = vha->hw;
-	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
-
-	/* wait for 5 min at the max for loop to be ready */
-	loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ);
-
-	while ((!atomic_read(&base_vha->loop_down_timer) &&
-	    atomic_read(&base_vha->loop_state) == LOOP_DOWN) ||
-	    atomic_read(&base_vha->loop_state) != LOOP_READY) {
-		if (atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
-			return_status = QLA_FUNCTION_FAILED;
-			break;
-		}
-		msleep(1000);
-		if (time_after_eq(jiffies, loop_timeout)) {
-			return_status = QLA_FUNCTION_FAILED;
-			break;
-		}
-	}
-	return (return_status);
-}
-
 static void
 sp_get(struct srb *sp)
 {
@@ -1035,12 +992,6 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		    "Wait for hba online failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
-	err = 1;
-	if (qla2x00_wait_for_loop_ready(vha) != QLA_SUCCESS) {
-		ql_log(ql_log_warn, vha, 0x800b,
-		    "Wait for loop ready failed for cmd=%p.\n", cmd);
-		goto eh_reset_failed;
-	}
 	err = 2;
 	if (do_reset(fcport, cmd->device->lun, cmd->request->cpu + 1)
 		!= QLA_SUCCESS) {
@@ -1137,10 +1088,9 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		goto eh_bus_reset_done;
 	}
 
-	if (qla2x00_wait_for_loop_ready(vha) == QLA_SUCCESS) {
-		if (qla2x00_loop_reset(vha) == QLA_SUCCESS)
-			ret = SUCCESS;
-	}
+	if (qla2x00_loop_reset(vha) == QLA_SUCCESS)
+		ret = SUCCESS;
+
 	if (ret == FAILED)
 		goto eh_bus_reset_done;
 
@@ -1206,15 +1156,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_wait_for_reset_ready(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
 
-	/*
-	 * Fixme-may be dpc thread is active and processing
-	 * loop_resync,so wait a while for it to
-	 * be completed and then issue big hammer.Otherwise
-	 * it may cause I/O failure as big hammer marks the
-	 * devices as lost kicking of the port_down_timer
-	 * while dpc is stuck for the mailbox to complete.
-	 */
-	qla2x00_wait_for_loop_ready(vha);
 	if (vha != base_vha) {
 		if (qla2x00_vp_abort_isp(vha))
 			goto eh_host_reset_lock;
@@ -1297,16 +1238,13 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 		qla2x00_mark_all_devices_lost(vha, 0);
-		qla2x00_wait_for_loop_ready(vha);
 	}
 
 	if (ha->flags.enable_lip_reset) {
 		ret = qla2x00_lip_reset(vha);
-		if (ret != QLA_SUCCESS) {
+		if (ret != QLA_SUCCESS)
 			ql_dbg(ql_dbg_taskm, vha, 0x802e,
 			    "lip_reset failed (%d).\n", ret);
-		} else
-			qla2x00_wait_for_loop_ready(vha);
 	}
 
 	/* Issue marker command only when we are going to start the I/O */
-- 
1.6.0.2


