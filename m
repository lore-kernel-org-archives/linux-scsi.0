From: michaelc@cs.wisc.edu
Subject: [PATCH 19/25] iser: Modify iser to take a iscsi_endpoint struct in ep callouts and session setup
Date: Wed, 21 May 2008 15:54:14 -0500
Message-ID: <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937119AbYEUUyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:36 -0400
In-Reply-To: <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This hooks iser into the iscsi endpoint code. Previously it handled the
lookup and allocation. This has been made generic so bnx2i and iser can
share it. It also allows us to pass iser the leading conn's ep, so we
know the ib_deivce being used and can set it as the scsi_host's parent.
And that allows scsi-ml to set the dma_mask based on those values.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   87 +++++++++++++-----------------
 drivers/infiniband/ulp/iser/iscsi_iser.h |    4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c |   14 +----
 3 files changed, 43 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 3a89039..42e95b8 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -262,24 +262,6 @@ iscsi_iser_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
 	}
 }
 
-static struct iser_conn *
-iscsi_iser_ib_conn_lookup(__u64 ep_handle)
-{
-	struct iser_conn *ib_conn;
-	struct iser_conn *uib_conn = (struct iser_conn *)(unsigned long)ep_handle;
-
-	mutex_lock(&ig.connlist_mutex);
-	list_for_each_entry(ib_conn, &ig.connlist, conn_list) {
-		if (ib_conn == uib_conn) {
-			mutex_unlock(&ig.connlist_mutex);
-			return ib_conn;
-		}
-	}
-	mutex_unlock(&ig.connlist_mutex);
-	iser_err("no conn exists for eph %llx\n",(unsigned long long)ep_handle);
-	return NULL;
-}
-
 static struct iscsi_cls_conn *
 iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 {
@@ -335,6 +317,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_iser_conn *iser_conn;
 	struct iser_conn *ib_conn;
+	struct iscsi_endpoint *ep;
 	int error;
 
 	error = iscsi_conn_bind(cls_session, cls_conn, is_leading);
@@ -343,12 +326,14 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 
 	/* the transport ep handle comes from user space so it must be
 	 * verified against the global ib connections list */
-	ib_conn = iscsi_iser_ib_conn_lookup(transport_eph);
-	if (!ib_conn) {
+	ep = iscsi_lookup_endpoint(transport_eph);
+	if (!ep) {
 		iser_err("can't bind eph %llx\n",
 			 (unsigned long long)transport_eph);
 		return -EINVAL;
 	}
+	ib_conn = ep->dd_data;
+
 	/* binds the iSER connection retrieved from the previously
 	 * connected ep_handle to the iSCSI layer connection. exchanges
 	 * connection pointers */
@@ -401,21 +386,17 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 }
 
 static struct iscsi_cls_session *
-iscsi_iser_session_create(struct Scsi_Host *shost,
+iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			  uint16_t cmds_max, uint16_t qdepth,
 			  uint32_t initial_cmdsn, uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
+	struct Scsi_Host *shost;
 	int i;
 	struct iscsi_task *task;
 	struct iscsi_iser_task *iser_task;
-
-	if (shost) {
-		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
-		       shost->host_no);
-		return NULL;
-	}
+	struct iser_conn *ib_conn;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISCSI_MAX_CMD_PER_LUN);
 	if (!shost)
@@ -426,7 +407,15 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	shost->max_channel = 0;
 	shost->max_cmd_len = 16;
 
-	if (iscsi_host_add(shost, NULL))
+	/*
+	 * older userspace tools (before 2.0-870) did not pass us
+	 * the leading conn's ep so this will be NULL;
+	 */
+	if (ep)
+		ib_conn = ep->dd_data;
+
+	if (iscsi_host_add(shost,
+			   ep ? ib_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
 	*hostno = shost->host_no;
 
@@ -529,34 +518,37 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 	stats->custom[3].value = conn->fmr_unalign_cnt;
 }
 
-static int
-iscsi_iser_ep_connect(struct sockaddr *dst_addr, int non_blocking,
-		      __u64 *ep_handle)
+static struct iscsi_endpoint *
+iscsi_iser_ep_connect(struct sockaddr *dst_addr, int non_blocking)
 {
 	int err;
 	struct iser_conn *ib_conn;
+	struct iscsi_endpoint *ep;
 
-	err = iser_conn_init(&ib_conn);
-	if (err)
-		goto out;
+	ep = iscsi_create_endpoint(sizeof(*ib_conn));
+	if (!ep)
+		return ERR_PTR(-ENOMEM);
 
-	err = iser_connect(ib_conn, NULL, (struct sockaddr_in *)dst_addr, non_blocking);
-	if (!err)
-		*ep_handle = (__u64)(unsigned long)ib_conn;
+	ib_conn = ep->dd_data;
+	ib_conn->ep = ep;
+	iser_conn_init(ib_conn);
 
-out:
-	return err;
+	err = iser_connect(ib_conn, NULL, (struct sockaddr_in *)dst_addr,
+			   non_blocking);
+	if (err) {
+		iscsi_destroy_endpoint(ep);
+		return ERR_PTR(err);
+	}
+	return ep;
 }
 
 static int
-iscsi_iser_ep_poll(__u64 ep_handle, int timeout_ms)
+iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 {
-	struct iser_conn *ib_conn = iscsi_iser_ib_conn_lookup(ep_handle);
+	struct iser_conn *ib_conn;
 	int rc;
 
-	if (!ib_conn)
-		return -EINVAL;
-
+	ib_conn = ep->dd_data;
 	rc = wait_event_interruptible_timeout(ib_conn->wait,
 			     ib_conn->state == ISER_CONN_UP,
 			     msecs_to_jiffies(timeout_ms));
@@ -578,14 +570,11 @@ iscsi_iser_ep_poll(__u64 ep_handle, int timeout_ms)
 }
 
 static void
-iscsi_iser_ep_disconnect(__u64 ep_handle)
+iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct iser_conn *ib_conn;
 
-	ib_conn = iscsi_iser_ib_conn_lookup(ep_handle);
-	if (!ib_conn)
-		return;
-
+	ib_conn = ep->dd_data;
 	if (ib_conn->iser_conn)
 		/*
 		 * Must suspend xmit path if the ep is bound to the
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 05431f2..cdf4876 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -174,6 +174,7 @@ struct iser_data_buf {
 struct iser_device;
 struct iscsi_iser_conn;
 struct iscsi_iser_task;
+struct iscsi_endpoint;
 
 struct iser_mem_reg {
 	u32  lkey;
@@ -241,6 +242,7 @@ struct iser_device {
 
 struct iser_conn {
 	struct iscsi_iser_conn       *iser_conn; /* iser conn for upcalls  */
+	struct iscsi_endpoint	     *ep;
 	enum iser_ib_conn_state	     state;	    /* rdma connection state   */
 	atomic_t		     refcount;
 	spinlock_t		     lock;	    /* used for state changes  */
@@ -313,7 +315,7 @@ void iscsi_iser_recv(struct iscsi_conn *conn,
 		     char                   *rx_data,
 		     int                    rx_data_len);
 
-int  iser_conn_init(struct iser_conn **ib_conn);
+void iser_conn_init(struct iser_conn *ib_conn);
 
 void iser_conn_get(struct iser_conn *ib_conn);
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5daed2b..81b45d4 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -325,7 +325,7 @@ static void iser_conn_release(struct iser_conn *ib_conn)
 		iser_device_try_release(device);
 	if (ib_conn->iser_conn)
 		ib_conn->iser_conn->ib_conn = NULL;
-	kfree(ib_conn);
+	iscsi_destroy_endpoint(ib_conn->ep);
 }
 
 void iser_conn_get(struct iser_conn *ib_conn)
@@ -494,15 +494,8 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 	return ret;
 }
 
-int iser_conn_init(struct iser_conn **ibconn)
+void iser_conn_init(struct iser_conn *ib_conn)
 {
-	struct iser_conn *ib_conn;
-
-	ib_conn = kzalloc(sizeof *ib_conn, GFP_KERNEL);
-	if (!ib_conn) {
-		iser_err("can't alloc memory for struct iser_conn\n");
-		return -ENOMEM;
-	}
 	ib_conn->state = ISER_CONN_INIT;
 	init_waitqueue_head(&ib_conn->wait);
 	atomic_set(&ib_conn->post_recv_buf_count, 0);
@@ -510,9 +503,6 @@ int iser_conn_init(struct iser_conn **ibconn)
 	atomic_set(&ib_conn->refcount, 1);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
-
-	*ibconn = ib_conn;
-	return 0;
 }
 
  /**
-- 
1.5.4.1

