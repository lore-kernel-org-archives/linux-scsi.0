From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/19] qla2xxx: Use correct Request-Q-Out register during bidirectional request processing
Date: Wed, 21 Nov 2012 02:40:33 -0500
Message-ID: <1353483644-17262-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:18477 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753362Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code was not corrected for ISP83xx support. Instead code should used
the cached reference from the req_que structure, rather than the legacy
'if (ISP-TYPE(X))... else if (ISP-TYPE(Y))...' codes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b610404..a481684 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2748,7 +2748,6 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	struct rsp_que *rsp;
 	struct req_que *req;
 	int rval = EXT_STATUS_OK;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, vha->req->id);
 
 	rval = QLA_SUCCESS;
 
@@ -2786,15 +2785,7 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
-		if (ha->mqenable)
-			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
-		else if (IS_QLA82XX(ha))
-			cnt = RD_REG_DWORD(&reg->isp82.req_q_out);
-		else if (IS_FWI2_CAPABLE(ha))
-			cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
-		else
-			cnt = qla2x00_debounce_register(
-					ISP_REQ_Q_OUT(ha, &reg->isp));
+		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
 
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
-- 
1.7.7

