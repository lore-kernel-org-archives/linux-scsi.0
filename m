From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/11] iscsi bugfixes: pass errors from complete_pdu to
	caller
Date: Mon, 24 Jul 2006 15:47:45 -0500
Message-ID: <1153774065.1040.41.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19136 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751445AbWGXUux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:50:53 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKoWg1012568
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:50:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Must pass ISCSI_ERR values from the recv path and propogate them
upwards.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index aa20adc..33534f6 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -885,7 +885,7 @@ more:
 			}
 			tcp_conn->in_progress = IN_PROGRESS_DATA_RECV;
 		} else if (rc) {
-			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+			iscsi_conn_failure(conn, rc);
 			return 0;
 		}
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 03b3dee..c628c63 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -372,7 +372,8 @@ int __iscsi_complete_pdu(struct iscsi_co
 			 * login related PDU's exp_statsn is handled in
 			 * userspace
 			 */
-			rc = iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen);
+			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
+				rc = ISCSI_ERR_CONN_FAILED;
 			list_del(&mtask->running);
 			if (conn->login_mtask != mtask)
 				__kfifo_put(session->mgmtpool.queue,
@@ -393,7 +394,8 @@ int __iscsi_complete_pdu(struct iscsi_co
 			}
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 
-			rc = iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen);
+			if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
+				rc = ISCSI_ERR_CONN_FAILED;
 			list_del(&mtask->running);
 			if (conn->login_mtask != mtask)
 				__kfifo_put(session->mgmtpool.queue,
@@ -406,14 +408,21 @@ int __iscsi_complete_pdu(struct iscsi_co
 	} else if (itt == ISCSI_RESERVED_TAG) {
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
-			if (!datalen) {
-				rc = iscsi_check_assign_cmdsn(session,
-						 (struct iscsi_nopin*)hdr);
-				if (!rc && hdr->ttt != ISCSI_RESERVED_TAG)
-					rc = iscsi_recv_pdu(conn->cls_conn,
-							    hdr, NULL, 0);
-			} else
+			if (datalen) {
 				rc = ISCSI_ERR_PROTO;
+				break;
+			}
+
+			rc = iscsi_check_assign_cmdsn(session,
+						 (struct iscsi_nopin*)hdr);
+			if (rc)
+				break;
+
+			if (hdr->ttt == ISCSI_RESERVED_TAG)
+				break;
+
+			if (iscsi_recv_pdu(conn->cls_conn, hdr, NULL, 0))
+				rc = ISCSI_ERR_CONN_FAILED;
 			break;
 		case ISCSI_OP_REJECT:
 			/* we need sth like iscsi_reject_rsp()*/


