From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] iscsi: bidi support - iscsi_tcp
Date: Fri, 18 Apr 2008 10:11:53 -0500
Message-ID: <1208531513-5122-4-git-send-email-michaelc@cs.wisc.edu>
References: <1208531513-5122-1-git-send-email-michaelc@cs.wisc.edu>
 <1208531513-5122-2-git-send-email-michaelc@cs.wisc.edu>
 <1208531513-5122-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYDRPMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 11:12:36 -0400
In-Reply-To: <1208531513-5122-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Boaz Harrosh <bharrosh@panasas.com>

  bidi support for iscsi_tcp
  - access the right scsi_in() and/or scsi_out() side of things.
    also for resid

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8a17867..72b9b2a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -528,6 +528,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = ctask->sc;
 	int datasn = be32_to_cpu(rhdr->datasn);
+	unsigned total_in_length = scsi_in(sc)->length;
 
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 	if (tcp_conn->in.datalen == 0)
@@ -542,10 +543,10 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	tcp_ctask->exp_datasn++;
 
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
-	if (tcp_ctask->data_offset + tcp_conn->in.datalen > scsi_bufflen(sc)) {
+	if (tcp_ctask->data_offset + tcp_conn->in.datalen > total_in_length) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
 		          __FUNCTION__, tcp_ctask->data_offset,
-		          tcp_conn->in.datalen, scsi_bufflen(sc));
+		          tcp_conn->in.datalen, total_in_length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
@@ -558,8 +559,8 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 			if (res_count > 0 &&
 			    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-			     res_count <= scsi_bufflen(sc)))
-				scsi_set_resid(sc, res_count);
+			     res_count <= total_in_length))
+				scsi_in(sc)->resid = res_count;
 			else
 				sc->result = (DID_BAD_TARGET << 16) |
 					rhdr->cmd_status;
@@ -670,11 +671,11 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 			    r2t->data_length, session->max_burst);
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
-	if (r2t->data_offset + r2t->data_length > scsi_bufflen(ctask->sc)) {
+	if (r2t->data_offset + r2t->data_length > scsi_out(ctask->sc)->length) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
-				  r2t->data_offset, scsi_bufflen(ctask->sc));
+				  r2t->data_offset, scsi_out(ctask->sc)->length);
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
@@ -771,6 +772,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		if (tcp_conn->in.datalen) {
 			struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 			struct hash_desc *rx_hash = NULL;
+			struct scsi_data_buffer *sdb = scsi_in(ctask->sc);
 
 			/*
 			 * Setup copy of Data-In into the Scsi_Cmnd
@@ -788,8 +790,8 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 				  tcp_ctask->data_offset,
 				  tcp_conn->in.datalen);
 			return iscsi_segment_seek_sg(&tcp_conn->in.segment,
-						     scsi_sglist(ctask->sc),
-						     scsi_sg_count(ctask->sc),
+						     sdb->table.sgl,
+						     sdb->table.nents,
 						     tcp_ctask->data_offset,
 						     tcp_conn->in.datalen,
 						     iscsi_tcp_process_data_in,
@@ -1332,7 +1334,8 @@ iscsi_tcp_ctask_init(struct iscsi_cmd_task *ctask)
 		return 0;
 
 	/* If we have immediate data, attach a payload */
-	err = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc), scsi_sg_count(sc),
+	err = iscsi_tcp_send_data_prep(conn, scsi_out(sc)->table.sgl,
+				       scsi_out(sc)->table.nents,
 				       0, ctask->imm_count);
 	if (err)
 		return err;
@@ -1386,6 +1389,7 @@ iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 	struct scsi_cmnd *sc = ctask->sc;
+	struct scsi_data_buffer *sdb = scsi_out(sc);
 	int rc = 0;
 
 flush:
@@ -1412,9 +1416,8 @@ flush:
 				ctask->itt, tcp_ctask->sent, ctask->data_count);
 
 		iscsi_tcp_send_hdr_prep(conn, hdr, sizeof(*hdr));
-		rc = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc),
-					      scsi_sg_count(sc),
-					      tcp_ctask->sent,
+		rc = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
+					      sdb->table.nents, tcp_ctask->sent,
 					      ctask->data_count);
 		if (rc)
 			goto fail;
@@ -1460,8 +1463,8 @@ flush:
 		iscsi_tcp_send_hdr_prep(conn, &r2t->dtask.hdr,
 					sizeof(struct iscsi_hdr));
 
-		rc = iscsi_tcp_send_data_prep(conn, scsi_sglist(sc),
-					      scsi_sg_count(sc),
+		rc = iscsi_tcp_send_data_prep(conn, sdb->table.sgl,
+					      sdb->table.nents,
 					      r2t->data_offset + r2t->sent,
 					      r2t->data_count);
 		if (rc)
-- 
1.5.4.1

