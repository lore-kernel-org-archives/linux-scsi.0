From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 34/43] qla2xxx: Delay loop id allocation at login
Date: Tue, 19 Dec 2017 22:56:35 -0800
Message-ID: <20171220065644.21511-35-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0069.outbound.protection.outlook.com ([104.47.40.69]:41840
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932492AbdLTG50 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:26 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Delay loop id allocation to login time

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 64 ++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 80e9d80cce2b..185c106cec0c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -582,36 +582,29 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 	if (!found) {
 		/* fw has no record of this port */
-		if (fcport->loop_id == FC_NO_LOOP_ID) {
-			qla2x00_find_new_loop_id(vha, fcport);
-			fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
-		} else {
-			for (i = 0; i < n; i++) {
-				e = &vha->gnl.l[i];
-				id.b.domain = e->port_id[0];
-				id.b.area = e->port_id[1];
-				id.b.al_pa = e->port_id[2];
-				id.b.rsvd_1 = 0;
-				loop_id = le16_to_cpu(e->nport_handle);
-
-				if (fcport->d_id.b24 == id.b24) {
-					conflict_fcport =
-					    qla2x00_find_fcport_by_wwpn(vha,
-						e->port_name, 0);
-
-					ql_dbg(ql_dbg_disc, vha, 0x20e6,
-					    "%s %d %8phC post del sess\n",
-					    __func__, __LINE__,
-					    conflict_fcport->port_name);
-					qlt_schedule_sess_for_deletion
-						(conflict_fcport, 1);
-				}
-
-				if (fcport->loop_id == loop_id) {
-					/* FW already picked this loop id for another fcport */
-					qla2x00_find_new_loop_id(vha, fcport);
-				}
+		for (i = 0; i < n; i++) {
+			e = &vha->gnl.l[i];
+			id.b.domain = e->port_id[0];
+			id.b.area = e->port_id[1];
+			id.b.al_pa = e->port_id[2];
+			id.b.rsvd_1 = 0;
+			loop_id = le16_to_cpu(e->nport_handle);
+
+			if (fcport->d_id.b24 == id.b24) {
+				conflict_fcport =
+					qla2x00_find_fcport_by_wwpn(vha,
+					    e->port_name, 0);
+				ql_dbg(ql_dbg_disc, vha, 0x20e6,
+				    "%s %d %8phC post del sess\n",
+				    __func__, __LINE__,
+				    conflict_fcport->port_name);
+				qlt_schedule_sess_for_deletion
+					(conflict_fcport, 1);
 			}
+
+			/* FW already picked this loop id for another fcport */
+			if (fcport->loop_id == loop_id)
+				fcport->loop_id = FC_NO_LOOP_ID;
 		}
 		qla24xx_fcport_handle_login(vha, fcport);
 	}
@@ -1106,6 +1099,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	u8 login = 0;
+	int rc;
 
 	if (qla_tgt_mode_enabled(vha))
 		return;
@@ -1131,6 +1125,18 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	}
 
 	if (login) {
+		if (fcport->loop_id == FC_NO_LOOP_ID) {
+			fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
+			rc = qla2x00_find_new_loop_id(vha, fcport);
+			if (rc) {
+				ql_dbg(ql_dbg_disc, vha, 0x20e6,
+				    "%s %d %8phC post del sess - out of loopid\n",
+				    __func__, __LINE__, fcport->port_name);
+				fcport->scan_state = 0;
+				qlt_schedule_sess_for_deletion(fcport, true);
+				return;
+			}
+		}
 		ql_dbg(ql_dbg_disc, vha, 0x20bf,
 		    "%s %d %8phC post login\n",
 		    __func__, __LINE__, fcport->port_name);
-- 
2.12.0
