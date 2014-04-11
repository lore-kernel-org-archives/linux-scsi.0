From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 40/42] qla2xxx: Do logins from a chip reset in DPC thread instead of the error handler thread.
Date: Fri, 11 Apr 2014 16:54:45 -0400
Message-ID: <1397249687-32666-41-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:40689 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbaDKVcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:06 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Attempting to do any logins from the SCSI reset handler can lead to a deadlock
scenario if a rport times out and the FC transport layer.  Move doing any port
logins to the DPC thread so as not to impede the progress of the SCSI error
handler thread and avoid deadlock situations.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    6 +++-
 drivers/scsi/qla2xxx/qla_init.c |   40 ++------------------------------------
 2 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 781ca5b..96f7d71 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -45,8 +45,10 @@
  * |                              |                    | 0x70ad-0x70ae  |
  * |                              |                    | 0x70d7-0x70db  |
  * |                              |                    | 0x70de-0x70df  |
- * | Task Management              |       0x803d       | 0x8025-0x8026  |
- * |                              |                    | 0x800b,0x8039  |
+ * | Task Management              |       0x803d       | 0x8000,0x800b  |
+ * |                              |                    | 0x8025,0x8026  |
+ * |                              |                    | 0x8031,0x8032  |
+ * |                              |                    | 0x8039,0x803c  |
  * | AER/EEH                      |       0x9011       |		|
  * | Virtual Port                 |       0xa007       |		|
  * | ISP82XX Specific             |       0xb157       | 0xb002,0xb024  |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 20b569e..e218441 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4736,7 +4736,6 @@ static int
 qla2x00_restart_isp(scsi_qla_host_t *vha)
 {
 	int status = 0;
-	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
@@ -4753,14 +4752,12 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 	if (!status && !(status = qla2x00_init_rings(vha))) {
 		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 		ha->flags.chip_reset_done = 1;
+
 		/* Initialize the queues in use */
 		qla25xx_init_queues(ha);
 
 		status = qla2x00_fw_ready(vha);
 		if (!status) {
-			ql_dbg(ql_dbg_taskm, vha, 0x8031,
-			    "Start configure loop status = %d.\n", status);
-
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
 
@@ -4775,24 +4772,12 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 				qlt_24xx_process_atio_queue(vha);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-			/* Wait at most MAX_TARGET RSCNs for a stable link. */
-			wait_time = 256;
-			do {
-				clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-				qla2x00_configure_loop(vha);
-				wait_time--;
-			} while (!atomic_read(&vha->loop_down_timer) &&
-				!(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
-				&& wait_time && (test_bit(LOOP_RESYNC_NEEDED,
-				&vha->dpc_flags)));
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
 
 		/* if no cable then assume it's good */
 		if ((vha->device_flags & DFLG_NO_CABLE))
 			status = 0;
-
-		ql_dbg(ql_dbg_taskm, vha, 0x8032,
-		    "Configure loop done, status = 0x%x.\n", status);
 	}
 	return (status);
 }
@@ -6139,7 +6124,6 @@ int
 qla82xx_restart_isp(scsi_qla_host_t *vha)
 {
 	int status, rval;
-	uint32_t wait_time;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
@@ -6153,31 +6137,15 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 
 		status = qla2x00_fw_ready(vha);
 		if (!status) {
-			ql_log(ql_log_info, vha, 0x803c,
-			    "Start configure loop, status =%d.\n", status);
-
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
-
 			vha->flags.online = 1;
-			/* Wait at most MAX_TARGET RSCNs for a stable link. */
-			wait_time = 256;
-			do {
-				clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-				qla2x00_configure_loop(vha);
-				wait_time--;
-			} while (!atomic_read(&vha->loop_down_timer) &&
-			    !(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags)) &&
-			    wait_time &&
-			    (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)));
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
 
 		/* if no cable then assume it's good */
 		if ((vha->device_flags & DFLG_NO_CABLE))
 			status = 0;
-
-		ql_log(ql_log_info, vha, 0x8000,
-		    "Configure loop done, status = 0x%x.\n", status);
 	}
 
 	if (!status) {
@@ -6191,8 +6159,6 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 			vha->marker_needed = 1;
 		}
 
-		vha->flags.online = 1;
-
 		ha->isp_ops->enable_intrs(ha);
 
 		ha->isp_abort_cnt = 0;
-- 
1.7.7

