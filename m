From: michaelc@cs.wisc.edu
Subject: [PATCH 06/14] iscsi_tcp: replace scsi_debug/tcp_debug logging with iscsi conn logging
Date: Thu,  5 Mar 2009 14:46:00 -0600
Message-ID: <12362859742776-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52799 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbZCEUqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:20 -0500
In-Reply-To: <12362859743025-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This makes the logging a compile time option and replaces
the tcp_debug macro with a iscsi connection one that prints
out a driver model id prefix.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   57 +++++++++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5a08ca4..9c2e527 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -48,13 +48,6 @@ MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-#undef DEBUG_TCP
-
-#ifdef DEBUG_TCP
-#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
-#else
-#define debug_tcp(fmt...)
-#endif
 
 static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
 static struct scsi_host_template iscsi_sw_tcp_sht;
@@ -63,6 +56,21 @@ static struct iscsi_transport iscsi_sw_tcp_transport;
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
+static int iscsi_sw_tcp_dbg;
+module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug_iscsi_tcp, "Turn on debugging for iscsi_tcp module "
+		 "Set to 1 to turn on, and zero to turn off. Default is off.");
+
+#define ISCSI_SW_TCP_DBG(_conn, dbg_fmt, arg...)		\
+	do {							\
+		if (iscsi_sw_tcp_dbg)				\
+			iscsi_conn_printk(KERN_INFO, _conn,	\
+					     "%s " dbg_fmt,	\
+					     __func__, ##arg);	\
+	} while (0);
+
+
 /**
  * iscsi_sw_tcp_recv - TCP receive in sendfile fashion
  * @rd_desc: read descriptor
@@ -77,7 +85,7 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 	unsigned int consumed, total_consumed = 0;
 	int status;
 
-	debug_tcp("in %d bytes\n", skb->len - offset);
+	ISCSI_SW_TCP_DBG(conn, "in %d bytes\n", skb->len - offset);
 
 	do {
 		status = 0;
@@ -86,7 +94,8 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		total_consumed += consumed;
 	} while (consumed != 0 && status != ISCSI_TCP_SKB_DONE);
 
-	debug_tcp("read %d bytes status %d\n", skb->len - offset, status);
+	ISCSI_SW_TCP_DBG(conn, "read %d bytes status %d\n",
+			 skb->len - offset, status);
 	return total_consumed;
 }
 
@@ -131,7 +140,8 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 	if ((sk->sk_state == TCP_CLOSE_WAIT ||
 	     sk->sk_state == TCP_CLOSE) &&
 	    !atomic_read(&sk->sk_rmem_alloc)) {
-		debug_tcp("iscsi_tcp_state_change: TCP_CLOSE|TCP_CLOSE_WAIT\n");
+		ISCSI_SW_TCP_DBG(conn, "iscsi_tcp_state_change: "
+				 "TCP_CLOSE|TCP_CLOSE_WAIT\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	}
 
@@ -155,7 +165,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
 	tcp_sw_conn->old_write_space(sk);
-	debug_tcp("iscsi_write_space: cid %d\n", conn->id);
+	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
 	scsi_queue_work(conn->session->host, &conn->xmitwork);
 }
 
@@ -283,7 +293,7 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 		}
 	}
 
-	debug_tcp("xmit %d bytes\n", consumed);
+	ISCSI_SW_TCP_DBG(conn, "xmit %d bytes\n", consumed);
 
 	conn->txdata_octets += consumed;
 	return consumed;
@@ -291,7 +301,7 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 error:
 	/* Transmit error. We could initiate error recovery
 	 * here. */
-	debug_tcp("Error sending PDU, errno=%d\n", rc);
+	ISCSI_SW_TCP_DBG(conn, "Error sending PDU, errno=%d\n", rc);
 	iscsi_conn_failure(conn, rc);
 	return -EIO;
 }
@@ -334,9 +344,10 @@ static int iscsi_sw_tcp_send_hdr_done(struct iscsi_tcp_conn *tcp_conn,
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
 	tcp_sw_conn->out.segment = tcp_sw_conn->out.data_segment;
-	debug_tcp("Header done. Next segment size %u total_size %u\n",
-		  tcp_sw_conn->out.segment.size,
-		  tcp_sw_conn->out.segment.total_size);
+	ISCSI_SW_TCP_DBG(tcp_conn->iscsi_conn,
+			 "Header done. Next segment size %u total_size %u\n",
+			 tcp_sw_conn->out.segment.size,
+			 tcp_sw_conn->out.segment.total_size);
 	return 0;
 }
 
@@ -346,8 +357,8 @@ static void iscsi_sw_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr,
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 
-	debug_tcp("%s(%p%s)\n", __func__, tcp_conn,
-			conn->hdrdgst_en? ", digest enabled" : "");
+	ISCSI_SW_TCP_DBG(conn, "%s\n", conn->hdrdgst_en ?
+			 "digest enabled" : "digest disabled");
 
 	/* Clear the data segment - needs to be filled in by the
 	 * caller using iscsi_tcp_send_data_prep() */
@@ -389,9 +400,9 @@ iscsi_sw_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __func__,
-			tcp_conn, offset, len,
-			conn->datadgst_en? ", digest enabled" : "");
+	ISCSI_SW_TCP_DBG(conn, "offset=%d, datalen=%d %s\n", offset, len,
+			 conn->datadgst_en ?
+			 "digest enabled" : "digest disabled");
 
 	/* Make sure the datalen matches what the caller
 	   said he would send. */
@@ -415,8 +426,8 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
-		  conn->datadgst_en? ", digest enabled" : "");
+	ISCSI_SW_TCP_DBG(conn, "datalen=%zd %s\n", len, conn->datadgst_en ?
+			 "digest enabled" : "digest disabled");
 
 	/* Make sure the datalen matches what the caller
 	   said he would send. */
-- 
1.6.0.6

