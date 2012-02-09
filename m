From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 29/29] qla2xxx: Avoid invalid request queue dereference for bad response packets.
Date: Thu, 9 Feb 2012 11:16:01 -0800
Message-ID: <1328814961-21866-30-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:38706
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407Ab2BITc0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:26 -0500
Received: from mail85-ch1 (localhost [127.0.0.1])	by mail85-ch1-R.bigfish.com
 (Postfix) with ESMTP id 92A2F802AC	for <linux-scsi@vger.kernel.org>; Thu,  9
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
 drivers/scsi/qla2xxx/qla_isr.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 32ab837..6054900 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1883,28 +1883,34 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	struct qla_hw_data *ha = vha->hw;
 	const char func[] = "ERROR-IOCB";
 	uint16_t que = MSW(pkt->handle);
-	struct req_que *req = ha->req_q_map[que];
+	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
 
 	ql_dbg(ql_dbg_async, vha, 0x502a,
 	    "type of error status in response: 0x%x\n", pkt->entry_status);
 
+	if (que >= ha->max_req_queues || !ha->req_q_map[que])
+		goto fatal;
+
+	req = ha->req_q_map[que];
+
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
-	if (sp)
+	if (sp) {
 		sp->done(ha, sp, res);
-	else {
-		ql_log(ql_log_warn, vha, 0x5030,
-		    "Error entry - invalid handle.\n");
-
-		if (IS_QLA82XX(ha))
-			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
-		else
-			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
+		return;
 	}
+fatal:
+	ql_log(ql_log_warn, vha, 0x5030,
+	    "Error entry - invalid handle/queue.\n");
+
+	if (IS_QLA82XX(ha))
+		set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+	else
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
 }
 
 /**
-- 
1.6.0.2


