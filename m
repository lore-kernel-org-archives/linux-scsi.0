From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 28/29] qla2xxx: Stop iteration after first failure in *_id functions.
Date: Thu, 9 Feb 2012 11:16:00 -0800
Message-ID: <1328814961-21866-29-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:38706
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758470Ab2BITcX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:23 -0500
Received: from mail69-ch1 (localhost [127.0.0.1])	by mail69-ch1-R.bigfish.com
 (Postfix) with ESMTP id 5D4B8380477	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:12 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f82b00a..6cbbcde 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -371,9 +371,11 @@ qla2x00_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			/*EMPTY*/
 			ql_dbg(ql_dbg_disc, vha, 0x2056,
 			    "GPN_ID issue IOCB failed (%d).\n", rval);
+			break;
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
+			break;
 		} else {
 			/* Save portname */
 			memcpy(list[i].port_name,
@@ -431,9 +433,11 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			/*EMPTY*/
 			ql_dbg(ql_dbg_disc, vha, 0x2057,
 			    "GNN_ID issue IOCB failed (%d).\n", rval);
+			break;
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GNN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
+			break;
 		} else {
 			/* Save nodename */
 			memcpy(list[i].node_name,
@@ -1777,9 +1781,11 @@ qla2x00_gfpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			/*EMPTY*/
 			ql_dbg(ql_dbg_disc, vha, 0x2023,
 			    "GFPN_ID issue IOCB failed (%d).\n", rval);
+			break;
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GFPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
+			break;
 		} else {
 			/* Save fabric portname */
 			memcpy(list[i].fabric_port_name,
-- 
1.6.0.2


