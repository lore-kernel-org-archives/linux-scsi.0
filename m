From: michaelc@cs.wisc.edu
Subject: [PATCH 14/19] iscsi_tcp: fix handling of data buffer padding
Date: Wed, 30 May 2007 12:57:20 -0500
Message-ID: <11805478611832-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbXE3R5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:48 -0400
In-Reply-To: <11805478601019-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we got the padding, data and header in different skbs,
we were not handling the padding correctly because we attributed it
to the data's skb. This resulted in the initiator reading from
pad bytes + skb offset instead of the correct offset.

If you could not connect with the open solaris target, this
will fix the lock up problem you were hitting.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   61 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/iscsi_tcp.h |    1 +
 2 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index eca4d61..6eaa2e3 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -896,11 +896,27 @@ more:
 		}
 	}
 
-	if (tcp_conn->in_progress == IN_PROGRESS_DDIGEST_RECV) {
+	if (tcp_conn->in_progress == IN_PROGRESS_DDIGEST_RECV &&
+	    tcp_conn->in.copy) {
 		uint32_t recv_digest;
 
 		debug_tcp("extra data_recv offset %d copy %d\n",
 			  tcp_conn->in.offset, tcp_conn->in.copy);
+
+		if (!tcp_conn->data_copied) {
+			if (tcp_conn->in.padding) {
+				debug_tcp("padding -> %d\n",
+					  tcp_conn->in.padding);
+				memset(pad, 0, tcp_conn->in.padding);
+				sg_init_one(&sg, pad, tcp_conn->in.padding);
+				crypto_hash_update(&tcp_conn->rx_hash,
+						   &sg, sg.length);
+			}
+			crypto_hash_final(&tcp_conn->rx_hash,
+					  (u8 *) &tcp_conn->in.datadgst);
+			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
+		}
+
 		rc = iscsi_tcp_copy(conn, sizeof(uint32_t));
 		if (rc) {
 			if (rc == -EAGAIN)
@@ -925,8 +941,7 @@ more:
 	}
 
 	if (tcp_conn->in_progress == IN_PROGRESS_DATA_RECV &&
-	   tcp_conn->in.copy) {
-
+	    tcp_conn->in.copy) {
 		debug_tcp("data_recv offset %d copy %d\n",
 		       tcp_conn->in.offset, tcp_conn->in.copy);
 
@@ -937,24 +952,32 @@ more:
 			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 			return 0;
 		}
-		tcp_conn->in.copy -= tcp_conn->in.padding;
-		tcp_conn->in.offset += tcp_conn->in.padding;
-		if (conn->datadgst_en) {
-			if (tcp_conn->in.padding) {
-				debug_tcp("padding -> %d\n",
-					  tcp_conn->in.padding);
-				memset(pad, 0, tcp_conn->in.padding);
-				sg_init_one(&sg, pad, tcp_conn->in.padding);
-				crypto_hash_update(&tcp_conn->rx_hash,
-						   &sg, sg.length);
-			}
-			crypto_hash_final(&tcp_conn->rx_hash,
-					  (u8 *) &tcp_conn->in.datadgst);
-			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
+
+		if (tcp_conn->in.padding)
+			tcp_conn->in_progress = IN_PROGRESS_PAD_RECV;
+		else if (conn->datadgst_en)
 			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
-			tcp_conn->data_copied = 0;
-		} else
+		else
+			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
+		tcp_conn->data_copied = 0;
+	}
+
+	if (tcp_conn->in_progress == IN_PROGRESS_PAD_RECV &&
+	    tcp_conn->in.copy) {
+		int copylen = min(tcp_conn->in.padding - tcp_conn->data_copied,
+				  tcp_conn->in.copy);
+
+		tcp_conn->in.copy -= copylen;
+		tcp_conn->in.offset += copylen;
+		tcp_conn->data_copied += copylen;
+
+		if (tcp_conn->data_copied != tcp_conn->in.padding)
+			tcp_conn->in_progress = IN_PROGRESS_PAD_RECV;
+		else if (conn->datadgst_en)
+			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
+		else
 			tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
+		tcp_conn->data_copied = 0;
 	}
 
 	debug_tcp("f, processed %d from out of %d padding %d\n",
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index b039160..7eba44d 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -29,6 +29,7 @@ #define IN_PROGRESS_WAIT_HEADER		0x0
 #define IN_PROGRESS_HEADER_GATHER	0x1
 #define IN_PROGRESS_DATA_RECV		0x2
 #define IN_PROGRESS_DDIGEST_RECV	0x3
+#define IN_PROGRESS_PAD_RECV		0x4
 
 /* xmit state machine */
 #define XMSTATE_IDLE			0x0
-- 
1.4.1.1

