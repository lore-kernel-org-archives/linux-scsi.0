From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] libiscsi: fix data corruption when target has to resend data-in packets
Date: Wed, 24 Sep 2008 11:46:09 -0500
Message-ID: <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53699 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYIXQq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:27 -0400
In-Reply-To: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_tcp was updating the exp_statsn (exp_statsn acknowledges
status and tells the target it is ok to let the resources for
a iscsi pdu to be reused) before it got all the data for pdu read
into OS buffers. Data corruption was occuring if something happens
to a packet and the network layer requests a retransmit, and the
initiator has told the target about the udpated exp_statsn ack,
then the target may be sending data from a buffer it has reused
for a new iscsi pdu. This fixes the problem by having the LLD
(iscsi_tcp in this case) just handle the transferring of data, and
has libiscsi handle the processing of status (libiscsi completion
processing is done after LLD data transfers are complete).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   29 +++++------------------------
 drivers/scsi/libiscsi.c  |   41 +++++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2a2f009..e960f00 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -523,22 +523,20 @@ iscsi_tcp_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
 }
 
 /**
- * iscsi_data_rsp - SCSI Data-In Response processing
+ * iscsi_data_in - SCSI Data-In Response processing
  * @conn: iscsi connection
  * @task: scsi command task
  **/
 static int
-iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
+iscsi_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)tcp_conn->in.hdr;
-	struct iscsi_session *session = conn->session;
-	struct scsi_cmnd *sc = task->sc;
 	int datasn = be32_to_cpu(rhdr->datasn);
-	unsigned total_in_length = scsi_in(sc)->length;
+	unsigned total_in_length = scsi_in(task->sc)->length;
 
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
+	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
 	if (tcp_conn->in.datalen == 0)
 		return 0;
 
@@ -558,23 +556,6 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 		return ISCSI_ERR_DATA_OFFSET;
 	}
 
-	if (rhdr->flags & ISCSI_FLAG_DATA_STATUS) {
-		sc->result = (DID_OK << 16) | rhdr->cmd_status;
-		conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
-		if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
-		                   ISCSI_FLAG_DATA_OVERFLOW)) {
-			int res_count = be32_to_cpu(rhdr->residual_count);
-
-			if (res_count > 0 &&
-			    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
-			     res_count <= total_in_length))
-				scsi_in(sc)->resid = res_count;
-			else
-				sc->result = (DID_BAD_TARGET << 16) |
-					rhdr->cmd_status;
-		}
-	}
-
 	conn->datain_pdus_cnt++;
 	return 0;
 }
@@ -774,7 +755,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		if (!task)
 			rc = ISCSI_ERR_BAD_ITT;
 		else
-			rc = iscsi_data_rsp(conn, task);
+			rc = iscsi_data_in(conn, task);
 		if (rc) {
 			spin_unlock(&conn->session->lock);
 			break;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0e8f26b..f9539af 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -633,6 +633,40 @@ out:
 	__iscsi_put_task(task);
 }
 
+/**
+ * iscsi_data_in_rsp - SCSI Data-In Response processing
+ * @conn: iscsi connection
+ * @hdr:  iscsi pdu
+ * @task: scsi command task
+ **/
+static void
+iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+		  struct iscsi_task *task)
+{
+	struct iscsi_data_rsp *rhdr = (struct iscsi_data_rsp *)hdr;
+	struct scsi_cmnd *sc = task->sc;
+
+	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
+		return;
+
+	sc->result = (DID_OK << 16) | rhdr->cmd_status;
+	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
+	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
+	                   ISCSI_FLAG_DATA_OVERFLOW)) {
+		int res_count = be32_to_cpu(rhdr->residual_count);
+
+		if (res_count > 0 &&
+		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
+		     res_count <= scsi_in(sc)->length))
+			scsi_in(sc)->resid = res_count;
+		else
+			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
+	}
+
+	conn->scsirsp_pdus_cnt++;
+	__iscsi_put_task(task);
+}
+
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
 	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
@@ -818,12 +852,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
 		break;
 	case ISCSI_OP_SCSI_DATA_IN:
-		if (hdr->flags & ISCSI_FLAG_DATA_STATUS) {
-			conn->scsirsp_pdus_cnt++;
-			iscsi_update_cmdsn(session,
-					   (struct iscsi_nopin*) hdr);
-			__iscsi_put_task(task);
-		}
+		iscsi_data_in_rsp(conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
-- 
1.5.4.1

