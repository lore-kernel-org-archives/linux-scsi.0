From: michaelc@cs.wisc.edu
Subject: [PATCH 08/25] iser: fix handling of scsi cmnds during recovery.
Date: Wed, 21 May 2008 15:54:03 -0500
Message-ID: <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936506AbYEUUy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:28 -0400
In-Reply-To: <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

>From Mike Christie:

After the stop_conn callback has returned the LLD should not
touch the scsi cmds. iscsi_tcp and libiscsi use the
conn->recv_lock and suspend_rx field to halt recv path
processing, but iser does not have any protection.

This patch modifies iser so that userspace can just
call the ep_disconnect callback, which will halt
all recv IO, before calling the stop_conn callback so
we do not have to worry about the conn->recv_lock and
suspend rx field. iser just needs to stop the send side
from accessing the ib conn.

Fixup to handle when the ep poll fails and ep disconnect
is called from Erez.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   42 +++++++++++++++++++++++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h |    5 +++
 drivers/infiniband/ulp/iser/iser_verbs.c |   14 +++++++++-
 drivers/scsi/libiscsi.c                  |    3 +-
 4 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9b34946..8a1bfb7 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -305,10 +305,18 @@ iscsi_iser_conn_destroy(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
+	struct iser_conn *ib_conn = iser_conn->ib_conn;
 
-	if (iser_conn->ib_conn)
-		iser_conn->ib_conn->iser_conn = NULL;
 	iscsi_conn_teardown(cls_conn);
+	/*
+	 * Userspace will normally call the stop callback and
+	 * already have freed the ib_conn, but if it goofed up then
+	 * we free it here.
+	 */
+	if (ib_conn) {
+		ib_conn->iser_conn = NULL;
+		iser_conn_put(ib_conn);
+	}
 }
 
 static int
@@ -340,12 +348,29 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	iser_conn = conn->dd_data;
 	ib_conn->iser_conn = iser_conn;
 	iser_conn->ib_conn  = ib_conn;
+	iser_conn_get(ib_conn);
 
 	conn->recv_lock = &iser_conn->lock;
 
 	return 0;
 }
 
+static void
+iscsi_iser_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_iser_conn *iser_conn = conn->dd_data;
+	struct iser_conn *ib_conn = iser_conn->ib_conn;
+
+	iscsi_conn_stop(cls_conn, flag);
+	/*
+	 * There is no unbind event so the stop callback
+	 * must release the ref from the bind.
+	 */
+	iser_conn_put(ib_conn);
+	iser_conn->ib_conn = NULL;
+}
+
 static int
 iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
 {
@@ -564,6 +589,17 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
 	if (!ib_conn)
 		return;
 
+	if (ib_conn->iser_conn)
+		/*
+		 * Must suspend xmit path if the ep is bound to the
+		 * iscsi_conn, so we know we are not accessing the ib_conn
+		 * when we free it.
+		 *
+		 * This may not be bound if the ep poll failed.
+		 */
+		iscsi_suspend_tx(ib_conn->iser_conn->iscsi_conn);
+
+
 	iser_err("ib conn %p state %d\n",ib_conn, ib_conn->state);
 	iser_conn_terminate(ib_conn);
 }
@@ -622,7 +658,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.get_conn_param		= iscsi_conn_get_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn             = iscsi_iser_conn_start,
-	.stop_conn              = iscsi_conn_stop,
+	.stop_conn              = iscsi_iser_conn_stop,
 	/* iscsi host params */
 	.get_host_param		= iscsi_host_get_param,
 	.set_host_param		= iscsi_host_set_param,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 66a2f30..bd5c1a5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -242,6 +242,7 @@ struct iser_device {
 struct iser_conn {
 	struct iscsi_iser_conn       *iser_conn; /* iser conn for upcalls  */
 	enum iser_ib_conn_state	     state;	    /* rdma connection state   */
+	atomic_t		     refcount;
 	spinlock_t		     lock;	    /* used for state changes  */
 	struct iser_device           *device;       /* device context          */
 	struct rdma_cm_id            *cma_id;       /* CMA ID		       */
@@ -314,6 +315,10 @@ void iscsi_iser_recv(struct iscsi_conn *conn,
 
 int  iser_conn_init(struct iser_conn **ib_conn);
 
+void iser_conn_get(struct iser_conn *ib_conn);
+
+void iser_conn_put(struct iser_conn *ib_conn);
+
 void iser_conn_terminate(struct iser_conn *ib_conn);
 
 void iser_rcv_completion(struct iser_desc *desc,
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index d19cfe6..5daed2b 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -328,6 +328,17 @@ static void iser_conn_release(struct iser_conn *ib_conn)
 	kfree(ib_conn);
 }
 
+void iser_conn_get(struct iser_conn *ib_conn)
+{
+	atomic_inc(&ib_conn->refcount);
+}
+
+void iser_conn_put(struct iser_conn *ib_conn)
+{
+	if (atomic_dec_and_test(&ib_conn->refcount))
+		iser_conn_release(ib_conn);
+}
+
 /**
  * triggers start of the disconnect procedures and wait for them to be done
  */
@@ -349,7 +360,7 @@ void iser_conn_terminate(struct iser_conn *ib_conn)
 	wait_event_interruptible(ib_conn->wait,
 				 ib_conn->state == ISER_CONN_DOWN);
 
-	iser_conn_release(ib_conn);
+	iser_conn_put(ib_conn);
 }
 
 static void iser_connect_error(struct rdma_cm_id *cma_id)
@@ -496,6 +507,7 @@ int iser_conn_init(struct iser_conn **ibconn)
 	init_waitqueue_head(&ib_conn->wait);
 	atomic_set(&ib_conn->post_recv_buf_count, 0);
 	atomic_set(&ib_conn->post_send_buf_count, 0);
+	atomic_set(&ib_conn->refcount, 1);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 784a935..79bc49f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1383,11 +1383,12 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 	}
 }
 
-static void iscsi_suspend_tx(struct iscsi_conn *conn)
+void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	scsi_flush_work(conn->session->host);
 }
+EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-- 
1.5.4.1

