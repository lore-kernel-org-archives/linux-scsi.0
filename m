From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi_tcp: fix relogin/shutdown hang
Date: Wed, 31 Mar 2010 14:41:35 -0500
Message-ID: <1270064495-4152-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0CaThe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2010 15:37:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is a bug fix patch for 2.6.34. It was built over
scsi-rx-fixes.

When I made this patch:
b64e77f70b8c11766e967e3485331a9e6ef01390
it was to solve a problem where we were already on the waitqueue
becuase a connection problem/logout caused us to be on there
when we were cleaning up the session. If we happen to get
on queue for more normal reasons like their just does not happen
to be any send space at the same time we are closing the connection
we hit a race and get stuck in the wait.

We should not check if the waitqueue is active
because we could race with the network code. If
the network xmit code is just about to enter the
prepare to wait when we check for the waitqueue to
be active then we will miss each other and the
network code will fall into the wait and we will
not run wake_up.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 249053a..a36ad73 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -598,7 +598,7 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
-	if (sock->sk->sk_sleep && waitqueue_active(sock->sk->sk_sleep)) {
+	if (sock->sk->sk_sleep) {
 		sock->sk->sk_err = EIO;
 		wake_up_interruptible(sock->sk->sk_sleep);
 	}
-- 
1.6.6.1

