From: michaelc@cs.wisc.edu
Subject: [PATCH 8/19] iscsi: Some fixes in preparation for bidirectional support - exp_datasn
Date: Wed, 30 May 2007 12:57:14 -0500
Message-ID: <11805478543860-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478531743-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes handling of expected datasn/r2tsn as received from
target. It is done according to: T10 rfc3720 section 3.2.2.3. Data Sequencing.

. unify expected datasn/r2tsn into one counter
. calculate than check expected datasn/r2tsn. On error print a message
  and fail the request. (TODO use iscsi retransmits)
. remove the FIXME   ;)
. avoid zero length memset

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   18 +++++++++++-------
 drivers/scsi/iscsi_tcp.h |    2 +-
 drivers/scsi/libiscsi.c  |    5 +++--
 include/scsi/libiscsi.h  |    1 -
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8201e6c..17fc79c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -229,10 +229,13 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 	if (tcp_conn->in.datalen == 0)
 		return 0;
 
-	if (ctask->datasn != datasn)
+	if (tcp_ctask->exp_datasn != datasn) {
+		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->datasn(%d)\n",
+		          __FUNCTION__, tcp_ctask->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
+	}
 
-	ctask->datasn++;
+	tcp_ctask->exp_datasn++;
 
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
 	if (tcp_ctask->data_offset + tcp_conn->in.datalen > ctask->total_length)
@@ -365,15 +368,16 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 		return ISCSI_ERR_DATALEN;
 	}
 
-	if (tcp_ctask->exp_r2tsn && tcp_ctask->exp_r2tsn != r2tsn)
+	if (tcp_ctask->exp_datasn != r2tsn){
+		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
+		          __FUNCTION__, tcp_ctask->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
+	}
 
 	rc = iscsi_check_assign_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	if (rc)
 		return rc;
 
-	/* FIXME: use R2TSN to detect missing R2T */
-
 	/* fill-in new R2T associated with the task */
 	spin_lock(&session->lock);
 	if (!ctask->sc || ctask->mtask ||
@@ -414,7 +418,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, s
 
 	iscsi_solicit_data_init(conn, ctask, r2t);
 
-	tcp_ctask->exp_r2tsn = r2tsn + 1;
+	tcp_ctask->exp_datasn = r2tsn + 1;
 	__kfifo_put(tcp_ctask->r2tqueue, (void*)&r2t, sizeof(void*));
 	tcp_ctask->xmstate |= XMSTATE_SOL_HDR;
 	list_move_tail(&ctask->running, &conn->xmitqueue);
@@ -1284,10 +1288,10 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 
 	tcp_ctask->sent = 0;
 	tcp_ctask->sg_count = 0;
+	tcp_ctask->exp_datasn = 0;
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		tcp_ctask->xmstate = XMSTATE_W_HDR;
-		tcp_ctask->exp_r2tsn = 0;
 		BUG_ON(ctask->total_length == 0);
 
 		if (sc->use_sg) {
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 3273683..f909edb 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -152,7 +152,7 @@ struct iscsi_tcp_cmd_task {
 	struct scatterlist	*sg;			/* per-cmd SG list  */
 	struct scatterlist	*bad_sg;		/* assert statement */
 	int			sg_count;		/* SG's to process  */
-	uint32_t		exp_r2tsn;
+	uint32_t		exp_datasn;		/* expected target's R2TSN/DataSN */
 	int			data_offset;
 	struct iscsi_r2t_info	*r2t;			/* in progress R2T    */
 	struct iscsi_queue	r2tpool;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5e6a424..eb51136 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -120,7 +120,9 @@ static void iscsi_prep_scsi_cmd_pdu(stru
         session->cmdsn++;
         hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
         memcpy(hdr->cdb, sc->cmnd, sc->cmd_len);
-        memset(&hdr->cdb[sc->cmd_len], 0, MAX_COMMAND_SIZE - sc->cmd_len);
+	if (sc->cmd_len < MAX_COMMAND_SIZE)
+		memset(&hdr->cdb[sc->cmd_len], 0,
+			MAX_COMMAND_SIZE - sc->cmd_len);
 
 	ctask->data_count = 0;
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
@@ -165,7 +167,6 @@ static void iscsi_prep_scsi_cmd_pdu(stru
 			/* No unsolicit Data-Out's */
 			ctask->hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
-		ctask->datasn = 0;
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 		zero_data(hdr->dlength);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index deae90a..61e0692 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -99,7 +99,6 @@ struct iscsi_cmd_task {
 	 */
 	struct iscsi_cmd	*hdr;
 	int			itt;		/* this ITT */
-	int			datasn;		/* DataSN */
 
 	uint32_t		unsol_datasn;
 	int			imm_count;	/* imm-data (bytes)   */
-- 
1.4.1.1

