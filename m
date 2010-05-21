From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi_tcp: remove sk_sleep check
Date: Fri, 21 May 2010 18:24:16 -0500
Message-ID: <1274484256-2794-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0EUXWv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2010 19:22:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There is no need to call sk_sleep before calling wake_up_interruptible,
because the wait_queue_head is now with the socket.

This patch is made over Linus's tree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index bf55d30..fec47de 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -601,10 +601,8 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
-	if (sk_sleep(sock->sk)) {
-		sock->sk->sk_err = EIO;
-		wake_up_interruptible(sk_sleep(sock->sk));
-	}
+	sock->sk->sk_err = EIO;
+	wake_up_interruptible(sk_sleep(sock->sk));
 
 	iscsi_conn_stop(cls_conn, flag);
 	iscsi_sw_tcp_release_conn(conn);
-- 
1.6.6.1

