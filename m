From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 35/43] qla2xxx: Add retry limit for fabric scan logic
Date: Tue, 19 Dec 2017 22:56:36 -0800
Message-ID: <20171220065644.21511-36-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:8134
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932474AbdLTG5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:44 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Switch scan is assumed to succeed most of the time.
If the scan failed, then scan is limit 5 retries.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c  | 33 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_isr.c |  1 +
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f061483475ce..3811ccd1c60b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3036,6 +3036,8 @@ struct fab_scan_rp {
 struct fab_scan {
 	struct fab_scan_rp *l;
 	u32 size;
+	u16 scan_retry;
+#define MAX_SCAN_RETRIES 5
 	enum scan_flags_t scan_flags;
 	struct delayed_work scan_work;
 };
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 903f924f6273..8256b65e9e7a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3924,13 +3924,17 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 
 	rc = sp->rc;
 	if (rc) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-		    "GPNFT failed. FC4type %x. Rescanning.\n",
-		    fc4type);
-		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		vha->scan.scan_retry++;
+		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "Fabric scan failed on all retries.\n");
+		}
 		goto out;
 	}
+	vha->scan.scan_retry = 0;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
 		fcport->scan_state = QLA_FCPORT_SCAN;
@@ -4013,7 +4017,6 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 
 out:
 	qla24xx_sp_unmap(vha, sp);
-
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
 	spin_unlock_irqrestore(&vha->work_lock, flags);
@@ -4041,16 +4044,20 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 	if (res) {
 		unsigned long flags;
 
-		ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
-		    "Async done-%s timed out.\n",
-		    sp->name);
 		sp->free(sp);
 		spin_lock_irqsave(&vha->work_lock, flags);
 		vha->scan.scan_flags &= ~SF_SCANNING;
-		spin_unlock_irqrestore(&vha->work_lock, flags);
-		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+		vha->scan.scan_retry++;
+
+		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		} else {
+			ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
+			    "Async done-%s rescan failed on all retries\n",
+			    sp->name);
+		}
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f02c98b3e8a7..6974657dd8c6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1059,6 +1059,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		 * Mark all devices as missing so we will login again.
 		 */
 		atomic_set(&vha->loop_state, LOOP_UP);
+		vha->scan.scan_retry = 0;
 
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
-- 
2.12.0
