From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 05/17] qla2xxx: Fix path recovery
Date: Tue, 30 May 2017 10:54:20 -0700
Message-ID: <20170530175432.26984-6-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:43520
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751032AbdE3Ry5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:54:57 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

If the port is moved/changed, current code would trigger
a deletion. If the port is already deleted, then do relogin.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 9bc9aa9e164a..5acebaf57796 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3118,16 +3118,27 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	if (fcport) {
 		/* cable moved. just plugged in */
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-			   "%s %d %8phC post del sess\n",
-			   __func__, __LINE__, fcport->port_name);
-
 		fcport->rscn_gen++;
 		fcport->d_id = ea->id;
 		fcport->scan_state = QLA_FCPORT_FOUND;
 		fcport->flags |= FCF_FABRIC_DEVICE;
 
-		qlt_schedule_sess_for_deletion_lock(fcport);
+		switch (fcport->disc_state) {
+		case DSC_DELETED:
+			ql_dbg(ql_dbg_disc, vha, 0x210d,
+			    "%s %d %8phC login\n", __func__, __LINE__,
+			    fcport->port_name);
+			qla24xx_fcport_handle_login(vha, fcport);
+			break;
+		case DSC_DELETE_PEND:
+			break;
+		default:
+			ql_dbg(ql_dbg_disc, vha, 0x2064,
+			    "%s %d %8phC post del sess\n",
+			    __func__, __LINE__, fcport->port_name);
+			qlt_schedule_sess_for_deletion_lock(fcport);
+			break;
+		}
 	} else {
 		/* create new fcport */
 		ql_dbg(ql_dbg_disc, vha, 0xffff,
-- 
2.12.0
