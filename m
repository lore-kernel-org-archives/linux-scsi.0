From: michaelc@cs.wisc.edu
Subject: [PATCH 5/6] iscsi_tcp: wake xmit thread when killing session
Date: Wed, 10 Feb 2010 16:51:47 -0600
Message-ID: <1265842308-2051-6-git-send-email-michaelc@cs.wisc.edu>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-4-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0BJWuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:50:09 -0500
In-Reply-To: <1265842308-2051-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the connection is bad, then the xmit thread could
end up waiting a long time (up to sendtmeo seconds) in
tcp_sendpage. This patch has us set the sk_error and
wake up the xmit thread so we can quickly fail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 517da3f..8a89ba9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -584,9 +584,10 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct socket *sock = tcp_sw_conn->sock;
 
 	/* userspace may have goofed up and not bound us */
-	if (!tcp_sw_conn->sock)
+	if (!sock)
 		return;
 	/*
 	 * Make sure our recv side is stopped.
@@ -597,6 +598,11 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
+	if (sock->sk->sk_sleep && waitqueue_active(sock->sk->sk_sleep)) {
+		sock->sk->sk_err = EIO;
+		wake_up_interruptible(sock->sk->sk_sleep);
+	}
+
 	iscsi_conn_stop(cls_conn, flag);
 	iscsi_sw_tcp_release_conn(conn);
 }
-- 
1.6.6

