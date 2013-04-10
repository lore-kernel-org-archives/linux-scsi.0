From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] iscsi_tcp: support PF_MEMALLOC/__GFP_MEMALLOC
Date: Wed, 10 Apr 2013 11:24:39 -0500
Message-ID: <1365611079-15011-3-git-send-email-michaelc@cs.wisc.edu>
References: <1365611079-15011-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37375 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936028Ab3DJQYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 12:24:52 -0400
In-Reply-To: <1365611079-15011-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch has software iscsi use PF_MEMALLOC/__GFP_MEMALLOC
to be able to better support swap over iscsi disks similar to
what was added for nbd.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1b91ca0..9e2588a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -370,17 +370,24 @@ static inline int iscsi_sw_tcp_xmit_qlen(struct iscsi_conn *conn)
 static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
 {
 	struct iscsi_conn *conn = task->conn;
-	int rc;
+	unsigned long pflags = current->flags;
+	int rc = 0;
+
+	current->flags |= PF_MEMALLOC;
 
 	while (iscsi_sw_tcp_xmit_qlen(conn)) {
 		rc = iscsi_sw_tcp_xmit(conn);
-		if (rc == 0)
-			return -EAGAIN;
+		if (rc == 0) {
+			rc = -EAGAIN;
+			break;
+		}
 		if (rc < 0)
-			return rc;
+			break;
+		rc = 0;
 	}
 
-	return 0;
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
+	return rc;
 }
 
 /*
@@ -665,6 +672,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_reuse = SK_CAN_REUSE;
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
+	sk_set_memalloc(sk);
 
 	iscsi_sw_tcp_conn_set_callbacks(conn);
 	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
-- 
1.7.1

