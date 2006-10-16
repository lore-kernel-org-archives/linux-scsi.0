From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] libiscsi: fix oops in connection create failure path
Date: Mon, 16 Oct 2006 18:09:39 -0400
Message-ID: <1161036584778-git-send-email-michaelc@cs.wisc.edu>
References: <11610365823995-git-send-email-michaelc@cs.wisc.edu> <1161036583544-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60097 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422903AbWJPXJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:38 -0400
In-Reply-To: <1161036583544-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If connection creation fails we end up calling list_del
on a invalid struct. This then causes an oops. We are not
acutally using the lists (old MCS code we thought might
be useful elsewhere) so this patch just removes that
code.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   38 ++++++++------------------------------
 include/scsi/libiscsi.h |    3 ---
 2 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c542d0e..1000fe9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -778,6 +778,10 @@ int iscsi_queuecommand(struct scsi_cmnd 
 	}
 
 	conn = session->leadconn;
+	if (!conn) {
+		reason = FAILURE_SESSION_FREED;
+		goto fault;
+	}
 
 	if (!__kfifo_get(session->cmdpool.queue, (void*)&ctask,
 			 sizeof(void*))) {
@@ -1377,7 +1381,6 @@ iscsi_session_setup(struct iscsi_transpo
 	}
 
 	spin_lock_init(&session->lock);
-	INIT_LIST_HEAD(&session->connections);
 
 	/* initialize immediate command pool */
 	if (iscsi_pool_init(&session->mgmtpool, session->mgmtpool_max,
@@ -1580,16 +1583,11 @@ void iscsi_conn_teardown(struct iscsi_cl
 	kfree(conn->persistent_address);
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
-	list_del(&conn->item);
-	if (list_empty(&session->connections))
+	if (session->leadconn == conn) {
 		session->leadconn = NULL;
-	if (session->leadconn && session->leadconn == conn)
-		session->leadconn = container_of(session->connections.next,
-			struct iscsi_conn, item);
-
-	if (session->leadconn == NULL)
 		/* no connections exits.. reset sequencing */
 		session->cmdsn = session->max_cmdsn = session->exp_cmdsn = 1;
+	}
 	spin_unlock_bh(&session->lock);
 
 	kfifo_free(conn->immqueue);
@@ -1777,32 +1775,12 @@ int iscsi_conn_bind(struct iscsi_cls_ses
 		    struct iscsi_cls_conn *cls_conn, int is_leading)
 {
 	struct iscsi_session *session = class_to_transport_session(cls_session);
-	struct iscsi_conn *tmp = ERR_PTR(-EEXIST), *conn = cls_conn->dd_data;
+	struct iscsi_conn *conn = cls_conn->dd_data;
 
-	/* lookup for existing connection */
 	spin_lock_bh(&session->lock);
-	list_for_each_entry(tmp, &session->connections, item) {
-		if (tmp == conn) {
-			if (conn->c_stage != ISCSI_CONN_STOPPED ||
-			    conn->stop_stage == STOP_CONN_TERM) {
-				printk(KERN_ERR "iscsi: can't bind "
-				       "non-stopped connection (%d:%d)\n",
-				       conn->c_stage, conn->stop_stage);
-				spin_unlock_bh(&session->lock);
-				return -EIO;
-			}
-			break;
-		}
-	}
-	if (tmp != conn) {
-		/* bind new iSCSI connection to session */
-		conn->session = session;
-		list_add(&conn->item, &session->connections);
-	}
-	spin_unlock_bh(&session->lock);
-
 	if (is_leading)
 		session->leadconn = conn;
+	spin_unlock_bh(&session->lock);
 
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 401192e..61eebec 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -136,7 +136,6 @@ struct iscsi_conn {
 
 	/* control data */
 	int			id;		/* CID */
-	struct list_head	item;		/* maintains list of conns */
 	int			c_stage;	/* connection state */
 	/*
 	 * Preallocated buffer for pdus that have data but do not
@@ -235,10 +234,8 @@ struct iscsi_session {
 						 * - mgmtpool,		   *
 						 * - r2tpool		   */
 	int			state;		/* session state           */
-	struct list_head	item;
 	int			age;		/* counts session re-opens */
 
-	struct list_head	connections;	/* list of connections */
 	int			cmds_max;	/* size of cmds array */
 	struct iscsi_cmd_task	**cmds;		/* Original Cmds arr */
 	struct iscsi_queue	cmdpool;	/* PDU's pool */
-- 
1.4.1

