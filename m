From: michaelc@cs.wisc.edu
Subject: [PATCH 05/13] iscsi_tcp: remove unused r2t handling
Date: Tue,  2 Dec 2008 00:32:08 -0600
Message-ID: <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYLBGcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:23 -0500
In-Reply-To: <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

libiscsi's iscsi_prep_data_out_pdu now handles what
iscsi_tcp's helpers were so we can remove iscsi_tcp's helpers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   91 ----------------------------------------------
 1 files changed, 0 insertions(+), 91 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 739602e..f70b68f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -554,48 +554,6 @@ iscsi_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 }
 
 /**
- * iscsi_solicit_data_init - initialize first Data-Out
- * @conn: iscsi connection
- * @task: scsi command task
- * @r2t: R2T info
- *
- * Notes:
- *	Initialize first Data-Out within this R2T sequence and finds
- *	proper data_offset within this SCSI command.
- *
- *	This function is called with connection lock taken.
- **/
-static void
-iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_task *task,
-			struct iscsi_r2t_info *r2t)
-{
-	struct iscsi_data *hdr;
-
-	hdr = &r2t->dtask.hdr;
-	memset(hdr, 0, sizeof(struct iscsi_data));
-	hdr->ttt = r2t->ttt;
-	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
-	r2t->solicit_datasn++;
-	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
-	hdr->itt = task->hdr->itt;
-	hdr->exp_statsn = r2t->exp_statsn;
-	hdr->offset = cpu_to_be32(r2t->data_offset);
-	if (r2t->data_length > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
-		r2t->data_count = conn->max_xmit_dlength;
-		hdr->flags = 0;
-	} else {
-		hton24(hdr->dlength, r2t->data_length);
-		r2t->data_count = r2t->data_length;
-		hdr->flags = ISCSI_FLAG_CMD_FINAL;
-	}
-	conn->dataout_pdus_cnt++;
-
-	r2t->sent = 0;
-}
-
-/**
  * iscsi_r2t_rsp - iSCSI R2T Response processing
  * @conn: iscsi connection
  * @task: scsi command task
@@ -1311,55 +1269,6 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 				data, len, NULL, tx_hash);
 }
 
-/**
- * iscsi_solicit_data_cont - initialize next Data-Out
- * @conn: iscsi connection
- * @task: scsi command task
- * @r2t: R2T info
- * @left: bytes left to transfer
- *
- * Notes:
- *	Initialize next Data-Out within this R2T sequence and continue
- *	to process next Scatter-Gather element(if any) of this SCSI command.
- *
- *	Called under connection lock.
- **/
-static int
-iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_task *task,
-			struct iscsi_r2t_info *r2t)
-{
-	struct iscsi_data *hdr;
-	int new_offset, left;
-
-	BUG_ON(r2t->data_length - r2t->sent < 0);
-	left = r2t->data_length - r2t->sent;
-	if (left == 0)
-		return 0;
-
-	hdr = &r2t->dtask.hdr;
-	memset(hdr, 0, sizeof(struct iscsi_data));
-	hdr->ttt = r2t->ttt;
-	hdr->datasn = cpu_to_be32(r2t->solicit_datasn);
-	r2t->solicit_datasn++;
-	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, task->hdr->lun, sizeof(hdr->lun));
-	hdr->itt = task->hdr->itt;
-	hdr->exp_statsn = r2t->exp_statsn;
-	new_offset = r2t->data_offset + r2t->sent;
-	hdr->offset = cpu_to_be32(new_offset);
-	if (left > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
-		r2t->data_count = conn->max_xmit_dlength;
-	} else {
-		hton24(hdr->dlength, left);
-		r2t->data_count = left;
-		hdr->flags = ISCSI_FLAG_CMD_FINAL;
-	}
-
-	conn->dataout_pdus_cnt++;
-	return 1;
-}
-
 static int iscsi_tcp_pdu_init(struct iscsi_task *task,
 			      unsigned int offset, unsigned int count)
 {
-- 
1.5.6.5

