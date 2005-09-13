From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/9] iscsi: fix nop-in handling
Date: Mon, 12 Sep 2005 21:02:04 -0500
Message-ID: <1126576924.29245.28.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20921 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932405AbVIMCC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:02:28 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D22RwK010046
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:02:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from zhenyu.z.wang@intel.com

This add check to NOOP_IN's ttt, when it's ~0UL we should not send
NOOP_OUT by spec (plus some cleanup).

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -672,34 +672,6 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			else
 				rc = ISCSI_ERR_PROTO;
 			break;
-		case ISCSI_OP_NOOP_IN:
-		case ISCSI_OP_TEXT_RSP:
-		case ISCSI_OP_LOGOUT_RSP:
-		case ISCSI_OP_ASYNC_EVENT:
-		case ISCSI_OP_REJECT:
-			rc = iscsi_check_assign_cmdsn(session,
-						 (struct iscsi_nopin*)hdr);
-			if (rc)
-				break;
-
-			/* update ExpStatSN */
-			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-			if (!conn->in.datalen) {
-				struct iscsi_mgmt_task *mtask;
-
-				rc = iscsi_recv_pdu(iscsi_handle(conn), hdr,
-						    NULL, 0);
-				mtask = (struct iscsi_mgmt_task *)
-					session->mgmt_cmds[conn->in.itt -
-						ISCSI_MGMT_ITT_OFFSET];
-				if (conn->login_mtask != mtask) {
-					spin_lock(&session->lock);
-					__kfifo_put(session->mgmtpool.queue,
-					    (void*)&mtask, sizeof(void*));
-					spin_unlock(&session->lock);
-				}
-			}
-			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
 			break;
@@ -718,6 +690,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 		switch(conn->in.opcode) {
 		case ISCSI_OP_LOGIN_RSP:
 		case ISCSI_OP_TEXT_RSP:
+		case ISCSI_OP_LOGOUT_RSP: 
 			rc = iscsi_check_assign_cmdsn(session,
 						 (struct iscsi_nopin*)hdr);
 			if (rc)
@@ -758,20 +731,59 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			}
 			spin_unlock(&session->lock);
 			break;
+		case ISCSI_OP_NOOP_IN: 
+			if (hdr->ttt != ISCSI_RESERVED_TAG) {
+				rc = ISCSI_ERR_PROTO;
+				break;
+			}
+			rc = iscsi_check_assign_cmdsn(session, 
+						(struct iscsi_nopin*)hdr);
+			if (rc)
+				break;
+			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+
+			if (!conn->in.datalen) {
+				struct iscsi_mgmt_task *mtask;
+
+				rc = iscsi_recv_pdu(iscsi_handle(conn), hdr,
+						    NULL, 0);
+				mtask = (struct iscsi_mgmt_task *)
+					session->mgmt_cmds[conn->in.itt -
+							ISCSI_MGMT_ITT_OFFSET];
+				if (conn->login_mtask != mtask) {
+					spin_lock(&session->lock);
+					__kfifo_put(session->mgmtpool.queue,
+						  (void*)&mtask, sizeof(void*));
+					spin_unlock(&session->lock);
+				}
+			}
+			break;
 		default:
 			rc = ISCSI_ERR_BAD_OPCODE;
 			break;
 		}
 	} else if (conn->in.itt == ISCSI_RESERVED_TAG) {
-		if (conn->in.opcode == ISCSI_OP_NOOP_IN && !conn->in.datalen) {
-			rc = iscsi_check_assign_cmdsn(session,
+		switch(conn->in.opcode) {
+		case ISCSI_OP_NOOP_IN:
+			if (!conn->in.datalen) {
+				rc = iscsi_check_assign_cmdsn(session,
 						 (struct iscsi_nopin*)hdr);
-			if (!rc)
-				rc = iscsi_recv_pdu(iscsi_handle(conn),
-						    hdr, NULL, 0);
-		}
-		else
+				if (!rc && hdr->ttt != ISCSI_RESERVED_TAG)
+					rc = iscsi_recv_pdu(iscsi_handle(conn),
+							    hdr, NULL, 0);
+			} else 
+				rc = ISCSI_ERR_PROTO;
+			break;
+		case ISCSI_OP_REJECT:
+			/* we need sth like iscsi_reject_rsp()*/
+		case ISCSI_OP_ASYNC_EVENT:
+			/* we need sth like iscsi_async_event_rsp() */
 			rc = ISCSI_ERR_BAD_OPCODE;
+			break;
+		default:
+			rc = ISCSI_ERR_BAD_OPCODE;
+			break;
+		}
 	} else
 		rc = ISCSI_ERR_BAD_ITT;
 


