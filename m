From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/5] iscsi: increment expstatsn during login
Date: Tue, 02 May 2006 19:46:47 -0500
Message-ID: <1146617207.2601.17.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:62637 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965058AbWECAon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:43 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430ig5P010719
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

debugged by Ming and Rohan:

The problem Ming and Rohan debugged was that during a normal session
login, open-iscsi is not incrementing the exp_statsn counter. It was
stuck at zero. From the RFC, it looks like if the login response PDU has
a successful status then we should be incrementing that value. Also from
the RFC, it looks like if when we drop a connection then reconnect, we
should be using the exp_statsn from the old connection in the next
relogin attempt.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 41f4bb5..c0ce6ab 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2298,6 +2298,9 @@ iscsi_conn_set_param(struct iscsi_cls_co
 		BUG_ON(value);
 		session->ofmarker_en = value;
 		break;
+	case ISCSI_PARAM_EXP_STATSN:
+		conn->exp_statsn = value;
+		break;
 	default:
 		break;
 	}
@@ -2381,6 +2384,9 @@ iscsi_conn_get_param(struct iscsi_cls_co
 		inet = inet_sk(tcp_conn->sock->sk);
 		*value = be16_to_cpu(inet->dport);
 		mutex_unlock(&conn->xmitmutex);
+	case ISCSI_PARAM_EXP_STATSN:
+		*value = conn->exp_statsn;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2548,7 +2554,8 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_DATASEQ_INORDER_EN |
 				  ISCSI_ERL |
 				  ISCSI_CONN_PORT |
-				  ISCSI_CONN_ADDRESS,
+				  ISCSI_CONN_ADDRESS |
+				  ISCSI_EXP_STATSN,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a99f2ef..4750d48 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -333,15 +333,21 @@ int __iscsi_complete_pdu(struct iscsi_co
 		debug_scsi("immrsp [op 0x%x cid %d itt 0x%x len %d]\n",
 			   opcode, conn->id, mtask->itt, datalen);
 
+		rc = iscsi_check_assign_cmdsn(session,
+					      (struct iscsi_nopin*)hdr);
+		if (rc)
+			goto done;
+
 		switch(opcode) {
+		case ISCSI_OP_LOGOUT_RSP:
+			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+			/* fall through */
 		case ISCSI_OP_LOGIN_RSP:
 		case ISCSI_OP_TEXT_RSP:
-		case ISCSI_OP_LOGOUT_RSP:
-			rc = iscsi_check_assign_cmdsn(session,
-						 (struct iscsi_nopin*)hdr);
-			if (rc)
-				break;
-
+			/*
+			 * login related PDU's exp_statsn is handled in
+			 * userspace
+			 */
 			rc = iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen);
 			list_del(&mtask->running);
 			if (conn->login_mtask != mtask)
@@ -349,15 +355,12 @@ int __iscsi_complete_pdu(struct iscsi_co
 					    (void*)&mtask, sizeof(void*));
 			break;
 		case ISCSI_OP_SCSI_TMFUNC_RSP:
-			rc = iscsi_check_assign_cmdsn(session,
-						 (struct iscsi_nopin*)hdr);
-			if (rc)
-				break;
-
 			if (datalen) {
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
+
+			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 			conn->tmfrsp_pdus_cnt++;
 			if (conn->tmabort_state == TMABORT_INITIAL) {
 				conn->tmabort_state =
@@ -373,10 +376,6 @@ int __iscsi_complete_pdu(struct iscsi_co
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
-			rc = iscsi_check_assign_cmdsn(session,
-						(struct iscsi_nopin*)hdr);
-			if (rc)
-				break;
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 
 			rc = iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen);
@@ -404,6 +403,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 		case ISCSI_OP_REJECT:
 			/* we need sth like iscsi_reject_rsp()*/
 		case ISCSI_OP_ASYNC_EVENT:
+			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 			/* we need sth like iscsi_async_event_rsp() */
 			rc = ISCSI_ERR_BAD_OPCODE;
 			break;
@@ -414,6 +414,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 	} else
 		rc = ISCSI_ERR_BAD_ITT;
 
+done:
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -730,6 +731,7 @@ iscsi_conn_send_generic(struct iscsi_con
 	        BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 	        BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
+		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
 		if (!__kfifo_get(session->mgmtpool.queue,
 				 (void*)&mtask, sizeof(void*))) {
 			spin_unlock_bh(&session->lock);
@@ -738,7 +740,7 @@ iscsi_conn_send_generic(struct iscsi_con
 	}
 
 	/*
-	 * pre-format CmdSN and ExpStatSN for outgoing PDU.
+	 * pre-format CmdSN for outgoing PDU.
 	 */
 	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {
 		hdr->itt = mtask->itt | (conn->id << ISCSI_CID_SHIFT) |
@@ -751,8 +753,6 @@ iscsi_conn_send_generic(struct iscsi_con
 		/* do not advance CmdSN */
 		nop->cmdsn = cpu_to_be32(session->cmdsn);
 
-	nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
-
 	if (data_size) {
 		memcpy(mtask->data, data, data_size);
 		mtask->data_count = data_size;
@@ -1647,7 +1647,7 @@ void iscsi_conn_stop(struct iscsi_cls_co
 	case STOP_CONN_RECOVER:
 	case STOP_CONN_TERM:
 		iscsi_start_session_recovery(session, conn, flag);
-		return;
+		break;
 	case STOP_CONN_SUSPEND:
 		if (session->tt->suspend_conn_recv)
 			session->tt->suspend_conn_recv(conn);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1b96f7c..44adafa 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -32,7 +32,7 @@
 #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 11
-#define ISCSI_CONN_ATTRS 10
+#define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 0
 
 struct iscsi_internal {
@@ -1156,6 +1156,7 @@ iscsi_conn_int_attr(ifmarker, ISCSI_PARA
 iscsi_conn_int_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN, "%d");
 iscsi_conn_int_attr(persistent_port, ISCSI_PARAM_PERSISTENT_PORT, "%d");
 iscsi_conn_int_attr(port, ISCSI_PARAM_CONN_PORT, "%d");
+iscsi_conn_int_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN, "%u");
 
 #define iscsi_conn_str_attr_show(param)					\
 static ssize_t								\
@@ -1406,6 +1407,7 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_CONN_RD_ATTR(ofmarker, ISCSI_OFMARKER_EN);
 	SETUP_CONN_RD_ATTR(address, ISCSI_CONN_ADDRESS);
 	SETUP_CONN_RD_ATTR(port, ISCSI_CONN_PORT);
+	SETUP_CONN_RD_ATTR(exp_statsn, ISCSI_EXP_STATSN);
 
 	if (tt->param_mask & ISCSI_PERSISTENT_ADDRESS)
 		SETUP_CONN_RD_ATTR(persistent_address, ISCSI_PERSISTENT_ADDRESS);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index feff74e..253797c 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -188,6 +188,7 @@ enum iscsi_param {
 	ISCSI_PARAM_ERL,
 	ISCSI_PARAM_IFMARKER_EN,
 	ISCSI_PARAM_OFMARKER_EN,
+	ISCSI_PARAM_EXP_STATSN,
 	ISCSI_PARAM_TARGET_NAME,
 	ISCSI_PARAM_TPGT,
 	ISCSI_PARAM_PERSISTENT_ADDRESS,
@@ -216,6 +217,7 @@ enum iscsi_param {
 #define ISCSI_ERL			(1 << ISCSI_PARAM_ERL)
 #define ISCSI_IFMARKER_EN		(1 << ISCSI_PARAM_IFMARKER_EN)
 #define ISCSI_OFMARKER_EN		(1 << ISCSI_PARAM_OFMARKER_EN)
+#define ISCSI_EXP_STATSN		(1 << ISCSI_PARAM_EXP_STATSN)
 #define ISCSI_TARGET_NAME		(1 << ISCSI_PARAM_TARGET_NAME)
 #define ISCSI_TPGT			(1 << ISCSI_PARAM_TPGT)
 #define ISCSI_PERSISTENT_ADDRESS	(1 << ISCSI_PARAM_PERSISTENT_ADDRESS)


