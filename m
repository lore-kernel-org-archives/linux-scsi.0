From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 11/22] qla2xxx: Fix Relogin being triggered too fast
Date: Mon, 4 Dec 2017 14:45:06 -0800
Message-ID: <20171204224517.3409-12-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0051.outbound.protection.outlook.com ([104.47.36.51]:44697
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752377AbdLDWpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:46 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current driver design schedules relogin process via DPC thread
every 1 second. In a large fabric, this DPC thread tries to
schedule too many jobs and might get overloaded. As a result of
this processing of DPC thread, it can schedule relogin earlier
than 1 second.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_mid.c | 24 +++++++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c  | 22 ++++++++++++++--------
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d9b4a0651a0f..93ff92e2363f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4110,6 +4110,7 @@ typedef struct scsi_qla_host {
 #define LOOP_READY	5
 #define LOOP_DEAD	6
 
+	unsigned long   relogin_jif;
 	unsigned long   dpc_flags;
 #define RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
 #define RESET_ACTIVE		1
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index bd9f14bf7ac2..618ca272d01a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -343,15 +343,21 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 		    "FCPort update end.\n");
 	}
 
-	if ((test_and_clear_bit(RELOGIN_NEEDED, &vha->dpc_flags)) &&
-		!test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
-		atomic_read(&vha->loop_state) != LOOP_DOWN) {
-
-		ql_dbg(ql_dbg_dpc, vha, 0x4018,
-		    "Relogin needed scheduled.\n");
-		qla2x00_relogin(vha);
-		ql_dbg(ql_dbg_dpc, vha, 0x4019,
-		    "Relogin needed end.\n");
+	if (test_bit(RELOGIN_NEEDED, &vha->dpc_flags) &&
+	    !test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
+	    atomic_read(&vha->loop_state) != LOOP_DOWN) {
+
+		if (!vha->relogin_jif ||
+		    time_after_eq(jiffies, vha->relogin_jif)) {
+			vha->relogin_jif = jiffies + HZ;
+			clear_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+
+			ql_dbg(ql_dbg_dpc, vha, 0x4018,
+			    "Relogin needed scheduled.\n");
+			qla2x00_relogin(vha);
+			ql_dbg(ql_dbg_dpc, vha, 0x4019,
+			    "Relogin needed end.\n");
+		}
 	}
 
 	if (test_and_clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) &&
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 820d1c185beb..2ec77b9f78b8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4905,7 +4905,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	 */
 		if (atomic_read(&fcport->state) != FCS_ONLINE &&
 		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
-			fcport->login_retry--;
+
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
 				ql_dbg(ql_dbg_disc, fcport->vha, 0x2108,
 				    "%s %8phC DS %d LS %d\n", __func__,
@@ -4916,6 +4916,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 				ea.fcport = fcport;
 				qla2x00_fcport_event_handler(vha, &ea);
 			} else {
+				fcport->login_retry--;
 				status = qla2x00_local_device_login(vha,
 								fcport);
 				if (status == QLA_SUCCESS) {
@@ -5898,16 +5899,21 @@ qla2x00_do_dpc(void *data)
 		}
 
 		/* Retry each device up to login retry count */
-		if ((test_and_clear_bit(RELOGIN_NEEDED,
-						&base_vha->dpc_flags)) &&
+		if (test_bit(RELOGIN_NEEDED, &base_vha->dpc_flags) &&
 		    !test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags) &&
 		    atomic_read(&base_vha->loop_state) != LOOP_DOWN) {
 
-			ql_dbg(ql_dbg_dpc, base_vha, 0x400d,
-			    "Relogin scheduled.\n");
-			qla2x00_relogin(base_vha);
-			ql_dbg(ql_dbg_dpc, base_vha, 0x400e,
-			    "Relogin end.\n");
+			if (!base_vha->relogin_jif ||
+			    time_after_eq(jiffies, base_vha->relogin_jif)) {
+				base_vha->relogin_jif = jiffies + HZ;
+				clear_bit(RELOGIN_NEEDED, &base_vha->dpc_flags);
+
+				ql_dbg(ql_dbg_dpc, base_vha, 0x400d,
+				    "Relogin scheduled.\n");
+				qla2x00_relogin(base_vha);
+				ql_dbg(ql_dbg_dpc, base_vha, 0x400e,
+				    "Relogin end.\n");
+			}
 		}
 loop_resync_check:
 		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
-- 
2.12.0
