From: michaelc@cs.wisc.edu
Subject: [PATCH 09/25] libiscsi, iscsi_tcp, iser: add session cmds array accessor
Date: Wed, 21 May 2008 15:54:04 -0500
Message-ID: <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935670AbYEUUy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:29 -0400
In-Reply-To: <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Currently to get a ctask from the session cmd array, you have to
know to use the itt modifier. To make this easier on LLDs and
so in the future we can easilly kill the session array and use
the host shared map instead, this patch adds a nice wrapper
to strip the itt into a session->cmds index and return a ctask.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    8 +---
 drivers/infiniband/ulp/iser/iser_initiator.c |   23 ++++------
 drivers/scsi/iscsi_tcp.c                     |   13 ++++--
 drivers/scsi/libiscsi.c                      |   60 ++++++++++++++++++-------
 include/scsi/libiscsi.h                      |    4 +-
 5 files changed, 65 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8a1bfb7..7b14688 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -98,7 +98,6 @@ iscsi_iser_recv(struct iscsi_conn *conn,
 		struct iscsi_hdr *hdr, char *rx_data, int rx_data_len)
 {
 	int rc = 0;
-	uint32_t ret_itt;
 	int datalen;
 	int ahslen;
 
@@ -114,12 +113,7 @@ iscsi_iser_recv(struct iscsi_conn *conn,
 	/* read AHS */
 	ahslen = hdr->hlength * 4;
 
-	/* verify itt (itt encoding: age+cid+itt) */
-	rc = iscsi_verify_itt(conn, hdr, &ret_itt);
-
-	if (!rc)
-		rc = iscsi_complete_pdu(conn, hdr, rx_data, rx_data_len);
-
+	rc = iscsi_complete_pdu(conn, hdr, rx_data, rx_data_len);
 	if (rc && rc != ISCSI_ERR_NO_SCSI_CMD)
 		goto error;
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 08dc81c..b82a5f2 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -537,13 +537,11 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 {
 	struct iser_dto        *dto = &rx_desc->dto;
 	struct iscsi_iser_conn *conn = dto->ib_conn->iser_conn;
-	struct iscsi_session *session = conn->iscsi_conn->session;
 	struct iscsi_cmd_task *ctask;
 	struct iscsi_iser_cmd_task *iser_ctask;
 	struct iscsi_hdr *hdr;
 	char   *rx_data = NULL;
 	int     rx_data_len = 0;
-	unsigned int itt;
 	unsigned char opcode;
 
 	hdr = &rx_desc->iscsi_header;
@@ -559,19 +557,18 @@ void iser_rcv_completion(struct iser_desc *rx_desc,
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	if (opcode == ISCSI_OP_SCSI_CMD_RSP) {
-	        itt = get_itt(hdr->itt); /* mask out cid and age bits */
-		if (!(itt < session->cmds_max))
+		ctask = iscsi_itt_to_ctask(conn->iscsi_conn, hdr->itt);
+		if (!ctask)
 			iser_err("itt can't be matched to task!!! "
-				 "conn %p opcode %d cmds_max %d itt %d\n",
-				 conn->iscsi_conn,opcode,session->cmds_max,itt);
-		/* use the mapping given with the cmds array indexed by itt */
-		ctask = (struct iscsi_cmd_task *)session->cmds[itt];
-		iser_ctask = ctask->dd_data;
-		iser_dbg("itt %d ctask %p\n",itt,ctask);
-		iser_ctask->status = ISER_TASK_STATUS_COMPLETED;
-		iser_ctask_rdma_finalize(iser_ctask);
+				 "conn %p opcode %d itt %d\n",
+				 conn->iscsi_conn, opcode, hdr->itt);
+		else {
+			iser_ctask = ctask->dd_data;
+			iser_dbg("itt %d ctask %p\n",hdr->itt, ctask);
+			iser_ctask->status = ISER_TASK_STATUS_COMPLETED;
+			iser_ctask_rdma_finalize(iser_ctask);
+		}
 	}
-
 	iser_dto_buffs_release(dto);
 
 	iscsi_iser_recv(conn->iscsi_conn, hdr, rx_data, rx_data_len);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dfaf9fa..f2a08f7 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -740,7 +740,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_cmd_task *ctask;
-	uint32_t itt;
 
 	/* verify PDU length */
 	tcp_conn->in.datalen = ntoh24(hdr->dlength);
@@ -758,7 +757,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	/* verify itt (itt encoding: age+cid+itt) */
-	rc = iscsi_verify_itt(conn, hdr, &itt);
+	rc = iscsi_verify_itt(conn, hdr->itt);
 	if (rc)
 		return rc;
 
@@ -767,7 +766,10 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		ctask = session->cmds[itt];
+		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (!ctask)
+			return ISCSI_ERR_BAD_ITT;
+
 		spin_lock(&conn->session->lock);
 		rc = iscsi_data_rsp(conn, ctask);
 		spin_unlock(&conn->session->lock);
@@ -810,7 +812,10 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
 	case ISCSI_OP_R2T:
-		ctask = session->cmds[itt];
+		ctask = iscsi_itt_to_ctask(conn, hdr->itt);
+		if (!ctask)
+			return ISCSI_ERR_BAD_ITT;
+
 		if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
 		else if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 79bc49f..4bc63c4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -640,6 +640,10 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	uint32_t itt;
 
 	conn->last_recv = jiffies;
+	rc = iscsi_verify_itt(conn, hdr->itt);
+	if (rc)
+		return rc;
+
 	if (hdr->itt != RESERVED_ITT)
 		itt = get_itt(hdr->itt);
 	else
@@ -776,27 +780,22 @@ int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
 
-/* verify itt (itt encoding: age+cid+itt) */
-int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-		     uint32_t *ret_itt)
+int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_cmd_task *ctask;
-	uint32_t itt;
 
-	if (hdr->itt != RESERVED_ITT) {
-		if (((__force u32)hdr->itt & ISCSI_AGE_MASK) !=
-		    (session->age << ISCSI_AGE_SHIFT)) {
-			iscsi_conn_printk(KERN_ERR, conn,
-					  "received itt %x expected session "
-					  "age (%x)\n", (__force u32)hdr->itt,
-					  session->age & ISCSI_AGE_MASK);
-			return ISCSI_ERR_BAD_ITT;
-		}
+	if (itt == RESERVED_ITT)
+		return 0;
 
-		itt = get_itt(hdr->itt);
-	} else
-		itt = ~0U;
+	if (((__force u32)itt & ISCSI_AGE_MASK) !=
+	    (session->age << ISCSI_AGE_SHIFT)) {
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "received itt %x expected session age (%x)\n",
+				  (__force u32)itt,
+				  session->age & ISCSI_AGE_MASK);
+		return ISCSI_ERR_BAD_ITT;
+	}
 
 	if (itt < session->cmds_max) {
 		ctask = session->cmds[itt];
@@ -817,11 +816,38 @@ int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		}
 	}
 
-	*ret_itt = itt;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_verify_itt);
 
+struct iscsi_cmd_task *
+iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
+{
+	struct iscsi_session *session = conn->session;
+	struct iscsi_cmd_task *ctask;
+	uint32_t i;
+
+	if (iscsi_verify_itt(conn, itt))
+		return NULL;
+
+	if (itt == RESERVED_ITT)
+		return NULL;
+
+	i = get_itt(itt);
+	if (i >= session->cmds_max)
+		return NULL;
+
+	ctask = session->cmds[i];
+	if (!ctask->sc)
+		return NULL;
+
+	if (ctask->sc->SCp.phase != session->age)
+		return NULL;
+
+	return ctask;
+}
+EXPORT_SYMBOL_GPL(iscsi_itt_to_ctask);
+
 void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 {
 	struct iscsi_session *session = conn->session;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index f54aeb1..9be6a70 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -385,8 +385,8 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_conn *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
-extern int iscsi_verify_itt(struct iscsi_conn *, struct iscsi_hdr *,
-			    uint32_t *);
+extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
+extern struct iscsi_cmd_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_ctask(struct iscsi_cmd_task *ctask);
 extern void iscsi_free_mgmt_task(struct iscsi_conn *conn,
 				 struct iscsi_mgmt_task *mtask);
-- 
1.5.4.1

