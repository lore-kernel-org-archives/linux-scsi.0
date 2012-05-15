From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 02/22] qla2xxx: Micro optimization in queuecommand handler
Date: Tue, 15 May 2012 14:34:09 -0400
Message-ID: <1337106869-14191-3-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:52293 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966393Ab2EOS5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:34 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chetan Loke <loke.chetan@gmail.com>

Optimized queuecommand handler's to eliminate double head-room checks.
The checks are moved inside the 1st if-loop otherwise you would end up checking twice when there is
enough head room.

Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
Reviewed-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Reviewed-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index eac9509..1ae0d1d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -385,9 +385,10 @@ qla2x00_start_scsi(srb_t *sp)
 		else
 			req->cnt = req->length -
 			    (req->ring_index - cnt);
+		/* If still no head room then bail out */
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
 	}
-	if (req->cnt < (req_cnt + 2))
-		goto queuing_error;
 
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
@@ -1502,9 +1503,9 @@ qla24xx_start_scsi(srb_t *sp)
 		else
 			req->cnt = req->length -
 				(req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
 	}
-	if (req->cnt < (req_cnt + 2))
-		goto queuing_error;
 
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
@@ -1717,11 +1718,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
 		else
 			req->cnt = req->length -
 				(req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
 	}
 
-	if (req->cnt < (req_cnt + 2))
-		goto queuing_error;
-
 	status |= QDSS_GOT_Q_SPACE;
 
 	/* Build header part of command packet (excluding the OPCODE). */
@@ -2343,11 +2343,10 @@ sufficient_dsds:
 			else
 				req->cnt = req->length -
 					(req->ring_index - cnt);
+			if (req->cnt < (req_cnt + 2))
+				goto queuing_error;
 		}
 
-		if (req->cnt < (req_cnt + 2))
-			goto queuing_error;
-
 		ctx = sp->u.scmd.ctx =
 		    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!ctx) {
-- 
1.7.7

