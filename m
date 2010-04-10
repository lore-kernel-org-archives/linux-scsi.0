From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] iscsi_tcp: Change iscsi_sw_tcp_conn_restore_callbacks arguments
Date: Fri,  9 Apr 2010 22:07:38 -0500
Message-ID: <1270868859-5147-4-git-send-email-michaelc@cs.wisc.edu>
References: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-2-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab0DJDIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 23:08:02 -0400
In-Reply-To: <1270868859-5147-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Avi Kaplan <savik751@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Avi Kaplan <savik751@gmail.com>

This patch changes the arguments to iscsi_sw_tcp_conn_restore_callbacks,
so that it works like the function to set the callbacks and because
in upcoming patches we need a iscsi_conn.

Signed-off-by: Avi Kaplan <savik751@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0ee725c..d0bb1f9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -206,8 +206,10 @@ static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
 }
 
 static void
-iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_sw_tcp_conn *tcp_sw_conn)
+iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 {
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sock *sk = tcp_sw_conn->sock->sk;
 
 	/* restore socket callbacks, see also: iscsi_conn_set_callbacks() */
@@ -555,7 +557,7 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 		return;
 
 	sock_hold(sock->sk);
-	iscsi_sw_tcp_conn_restore_callbacks(tcp_sw_conn);
+	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
 
 	spin_lock_bh(&session->lock);
-- 
1.6.6.1

