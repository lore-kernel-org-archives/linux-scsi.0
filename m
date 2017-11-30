From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 06/22] qla2xxx: Retry switch command on time out
Date: Wed, 29 Nov 2017 19:40:31 -0800
Message-ID: <20171130034047.15070-7-himanshu.madhani@cavium.com>
References: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0067.outbound.protection.outlook.com ([104.47.36.67]:32352
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752980AbdK3DlD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 22:41:03 -0500
In-Reply-To: <20171130034047.15070-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Retry GID_PN & GPN_ID switch commands for time out case.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8984f857bb34..ea1b562ebc8a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -175,6 +175,9 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 				set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			}
 			break;
+		case CS_TIMEOUT:
+			rval = QLA_FUNCTION_TIMEOUT;
+			/* drop through */
 		default:
 			ql_dbg(ql_dbg_disc, vha, 0x2033,
 			    "%s failed, completion status (%x) on port_id: "
@@ -2889,9 +2892,22 @@ static void qla2x00_async_gidpn_sp_done(void *s, int res)
 	ea.rc = res;
 	ea.event = FCME_GIDPN_DONE;
 
-	ql_dbg(ql_dbg_disc, vha, 0x204f,
-	    "Async done-%s res %x, WWPN %8phC ID %3phC \n",
-	    sp->name, res, fcport->port_name, id);
+	if (res == QLA_FUNCTION_TIMEOUT) {
+		ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
+		    "Async done-%s WWPN %8phC timed out.\n",
+		    sp->name, fcport->port_name);
+		qla24xx_post_gidpn_work(sp->vha, fcport);
+		sp->free(sp);
+		return;
+	} else if (res) {
+		ql_dbg(ql_dbg_disc, sp->vha, 0xffff,
+		    "Async done-%s fail res %x, WWPN %8phC\n",
+		    sp->name, res, fcport->port_name);
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0x204f,
+		    "Async done-%s good WWPN %8phC ID %3phC\n",
+		    sp->name, fcport->port_name, id);
+	}
 
 	qla2x00_fcport_event_handler(vha, &ea);
 
@@ -3217,11 +3233,6 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
 		    sp->name, ct_req->req.port_id.port_id,
 		    ct_rsp->rsp.gpn_id.port_name);
 
-	if (res) {
-		sp->free(sp);
-		return;
-	}
-
 	memset(&ea, 0, sizeof(ea));
 	memcpy(ea.port_name, ct_rsp->rsp.gpn_id.port_name, WWN_SIZE);
 	ea.sp = sp;
@@ -3231,6 +3242,13 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
 	ea.rc = res;
 	ea.event = FCME_GPNID_DONE;
 
+	if (res) {
+		if (res == QLA_FUNCTION_TIMEOUT)
+			qla24xx_post_gpnid_work(sp->vha, &ea.id);
+		sp->free(sp);
+		return;
+	}
+
 	qla2x00_fcport_event_handler(vha, &ea);
 
 	e = qla2x00_alloc_work(vha, QLA_EVT_GPNID_DONE);
-- 
2.12.0
