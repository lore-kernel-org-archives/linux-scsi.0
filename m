From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/8] iscsi: redirect fix
Date: Tue, 29 Nov 2005 23:12:49 -0600
Message-ID: <1133327569.28356.40.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47546 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751026AbVK3FNE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:04 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5D2nD009275
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:03 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From tomof@acm.org:

There is one more issue about Equallogic systems. They send
re-direction info with FIN. I think that the kernel module needs to
let iscsid to read data from the socket before killing it.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ae2f7be..6e21798 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1237,8 +1237,9 @@ iscsi_tcp_state_change(struct sock *sk)
 	conn = (struct iscsi_conn*)sk->sk_user_data;
 	session = conn->session;
 
-	if (sk->sk_state == TCP_CLOSE_WAIT ||
-	    sk->sk_state == TCP_CLOSE) {
+	if ((sk->sk_state == TCP_CLOSE_WAIT ||
+	     sk->sk_state == TCP_CLOSE) &&
+	    !atomic_read(&sk->sk_rmem_alloc)) {
 		debug_tcp("iscsi_tcp_state_change: TCP_CLOSE|TCP_CLOSE_WAIT\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 	}


