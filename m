From: Chetan Loke <loke.chetan@gmail.com>
Subject: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand handler
Date: Tue, 14 Feb 2012 09:47:46 -0500
Message-ID: <1329230866-905-1-git-send-email-loke.chetan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36490 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760781Ab2BNOs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 09:48:26 -0500
Received: by qcqw6 with SMTP id w6so19297qcq.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 06:48:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com
Cc: linux-driver@qlogic.com, loke.chetan@gmail.com

Optimized queuecommand handler's to eliminate double head-room checks.
The checks are moved inside the 1st if-loop otherwise you would end up checking twice when there is enough head room.

Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 55a9676..825a046 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -383,9 +383,10 @@ qla2x00_start_scsi(srb_t *sp)
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
@@ -2349,11 +2349,10 @@ sufficient_dsds:
 			else
 				req->cnt = req->length -
 					(req->ring_index - cnt);
+			if (req->cnt < (req_cnt + 2))
+				goto queuing_error;
 		}
 
-		if (req->cnt < (req_cnt + 2))
-			goto queuing_error;
-
 		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!sp->ctx) {
 			ql_log(ql_log_fatal, vha, 0x3010,
-- 
1.7.5.2

