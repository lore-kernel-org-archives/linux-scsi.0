From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 33/43] qla2xxx: Increase verbosity of debug messages logged
Date: Tue, 19 Dec 2017 22:56:34 -0800
Message-ID: <20171220065644.21511-34-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:8134
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932424AbdLTG5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:24 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add verbose bit for debug messages to reduce excessive
log messages

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 598ec3481a8c..43e210757840 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -209,7 +209,7 @@ struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
 
 	host = btree_lookup32(&vha->hw->tgt.host_map, key);
 	if (!host)
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
+		ql_dbg(ql_dbg_tgt_mgt + ql_dbg_verbose, vha, 0xf005,
 		    "Unable to find host %06x\n", key);
 
 	return host;
@@ -310,17 +310,17 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 
 		host = qlt_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
 		if (host != NULL) {
-			ql_dbg(ql_dbg_async, vha, 0x502f,
+			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x502f,
 			    "Requeuing unknown ATIO_TYPE7 %p\n", u);
 			qlt_24xx_atio_pkt(host, &u->atio, ha_locked);
 		} else if (tgt->tgt_stop) {
-			ql_dbg(ql_dbg_async, vha, 0x503a,
+			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x503a,
 			    "Freeing unknown %s %p, because tgt is being stopped\n",
 			    "ATIO_TYPE7", u);
 			qlt_send_term_exchange(vha->hw->base_qpair, NULL,
 			    &u->atio, ha_locked, 0);
 		} else {
-			ql_dbg(ql_dbg_async, vha, 0x503d,
+			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x503d,
 			    "Reschedule u %p, vha %p, host %p\n", u, vha, host);
 			if (!queued) {
 				queued = 1;
-- 
2.12.0
