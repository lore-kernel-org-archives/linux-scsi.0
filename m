From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/5] iscsi: dequeue all buffers from queue
Date: Tue, 02 May 2006 19:46:49 -0500
Message-ID: <1146617209.2601.19.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63149 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965059AbWECAot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:49 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430imfR010722
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

debugged by wrwhitehead@novell.com
patch and analysis by fujita.tomonori@lab.ntt.co.jp

Only tcp_read_sock and recv_actor (iscsi_tcp_data_recv for us) see
desc.count. It is is used just for permitting tcp_read_sock to read
the portion of data in the socket.

When iscsi_tcp_data_recv sees a partial header, it sets
desc.count. However, it is possible that the next skb (containing the
rest of the header) still does not come. So I'm not sure that this
scheme is completely correct.

Ideally, we should use the exact length of the data in the socket for
desc.count. However, it is not so simple (see SIOCINQ in
tcp_ioctl). So I think that iscsi_tcp_data_recv can just stop playing
with desc.count and tell tcp_read_sock to read the all skbs. As
proposed already, if iscsi_tcp_data_ready sets desc.count to
non-zero, tcp_read_sock does that.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>



diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c0ce6ab..d94038e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -922,11 +922,8 @@ more:
 
 		rc = iscsi_data_recv(conn);
 		if (rc) {
-			if (rc == -EAGAIN) {
-				rd_desc->count = tcp_conn->in.datalen -
-						tcp_conn->in.ctask->data_count;
+			if (rc == -EAGAIN)
 				goto again;
-			}
 			iscsi_conn_failure(conn, rc);
 			return 0;
 		}
@@ -983,9 +980,14 @@ iscsi_tcp_data_ready(struct sock *sk, in
 
 	read_lock(&sk->sk_callback_lock);
 
-	/* use rd_desc to pass 'conn' to iscsi_tcp_data_recv */
+	/*
+	 * Use rd_desc to pass 'conn' to iscsi_tcp_data_recv.
+	 * We set count to 1 because we want the network layer to
+	 * hand us all the skbs that are available. iscsi_tcp_data_recv
+	 * handled pdus that cross buffers or pdus that still need data.
+	 */
 	rd_desc.arg.data = conn;
-	rd_desc.count = 0;
+	rd_desc.count = 1;
 	tcp_read_sock(sk, &rd_desc, iscsi_tcp_data_recv);
 
 	read_unlock(&sk->sk_callback_lock);


