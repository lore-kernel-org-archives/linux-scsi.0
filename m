From: michaelc@cs.wisc.edu
Subject: [PATCH 9/12] iscsi_tcp: fix partial digest recv
Date: Thu, 31 Aug 2006 18:09:32 -0400
Message-ID: <1157062186420-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu> <1157062184454-git-send-email-michaelc@cs.wisc.edu> <11570621852186-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35718 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932478AbWHaXJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:30 -0400
In-Reply-To: <11570621852186-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When a digest is spread across two network buffers, we currently
ignore this and try to check the digest with the partial buffer.
Or course this fails. This patch has use iscsi_tcp_copy to
copy the whole digest before testing it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f00cf15..1b950fc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -648,10 +648,9 @@ iscsi_ctask_copy(struct iscsi_tcp_conn *
  *	byte counters.
  **/
 static inline int
-iscsi_tcp_copy(struct iscsi_conn *conn)
+iscsi_tcp_copy(struct iscsi_conn *conn, int buf_size)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	int buf_size = tcp_conn->in.datalen;
 	int buf_left = buf_size - tcp_conn->data_copied;
 	int size = min(tcp_conn->in.copy, buf_left);
 	int rc;
@@ -812,7 +811,7 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		 * Collect data segment to the connection's data
 		 * placeholder
 		 */
-		if (iscsi_tcp_copy(conn)) {
+		if (iscsi_tcp_copy(conn, tcp_conn->in.datalen)) {
 			rc = -EAGAIN;
 			goto exit;
 		}
@@ -899,10 +898,15 @@ more:
 
 		debug_tcp("extra data_recv offset %d copy %d\n",
 			  tcp_conn->in.offset, tcp_conn->in.copy);
-		skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
-				&recv_digest, 4);
-		tcp_conn->in.offset += 4;
-		tcp_conn->in.copy -= 4;
+		rc = iscsi_tcp_copy(conn, sizeof(uint32_t));
+		if (rc) {
+			if (rc == -EAGAIN)
+				goto again;
+			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+			return 0;
+		}	
+
+		memcpy(&recv_digest, conn->data, sizeof(uint32_t));
 		if (recv_digest != tcp_conn->in.datadgst) {
 			debug_tcp("iscsi_tcp: data digest error!"
 				  "0x%x != 0x%x\n", recv_digest,
@@ -942,9 +946,10 @@ more:
 						     &sg, 1);
 			}
 			crypto_digest_final(tcp_conn->rx_tfm,
-					    (u8 *) & tcp_conn->in.datadgst);
+					    (u8 *) &tcp_conn->in.datadgst);
 			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
 			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
+			tcp_conn->data_copied = 0;
 		} else
 			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	}
-- 
1.4.1.1

