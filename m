From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/3] iscsi-target: Convert iscsi_thread_set usage to kthread.h
Date: Sat, 21 Mar 2015 06:16:02 +0000
Message-ID: <1426918564-22581-2-git-send-email-nab@daterainc.com>
References: <1426918564-22581-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36306 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbCUGQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Mar 2015 02:16:40 -0400
Received: by obdfc2 with SMTP id fc2so92245690obd.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2015 23:16:39 -0700 (PDT)
In-Reply-To: <1426918564-22581-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iscsi-target code to use modern kthread.h API
callers for creating RX/TX threads for each new iscsi_conn descriptor,
and releasing associated RX/TX threads during connection shutdown.

This is done using iscsit_start_kthreads() -> kthread_run() to start
new kthreads from within iscsi_post_login_handler(), and invoking
kthread_stop() from existing iscsit_close_connection() code.

Also, convert iscsit_logout_post_handler_closesession() code to use
cmpxchg when determing when iscsit_cause_connection_reinstatement()
needs to sleep waiting for completion.

Reported-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c       | 106 +++++++++++++-----------------
 drivers/target/iscsi/iscsi_target_erl0.c  |  13 ++--
 drivers/target/iscsi/iscsi_target_login.c |  59 +++++++++++++++--
 include/target/iscsi/iscsi_target_core.h  |   7 ++
 4 files changed, 116 insertions(+), 69 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2accb6e..cb97b59 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -537,7 +537,7 @@ static struct iscsit_transport iscsi_target_transport = {
 
 static int __init iscsi_target_init_module(void)
 {
-	int ret = 0;
+	int ret = 0, size;
 
 	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
 
@@ -546,6 +546,7 @@ static int __init iscsi_target_init_module(void)
 		pr_err("Unable to allocate memory for iscsit_global\n");
 		return -1;
 	}
+	spin_lock_init(&iscsit_global->ts_bitmap_lock);
 	mutex_init(&auth_id_lock);
 	spin_lock_init(&sess_idr_lock);
 	idr_init(&tiqn_idr);
@@ -555,15 +556,11 @@ static int __init iscsi_target_init_module(void)
 	if (ret < 0)
 		goto out;
 
-	ret = iscsi_thread_set_init();
-	if (ret < 0)
+	size = BITS_TO_LONGS(ISCSIT_BITMAP_BITS) * sizeof(long);
+	iscsit_global->ts_bitmap = vzalloc(size);
+	if (!iscsit_global->ts_bitmap) {
+		pr_err("Unable to allocate iscsit_global->ts_bitmap\n");
 		goto configfs_out;
-
-	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=
-			TARGET_THREAD_SET_COUNT) {
-		pr_err("iscsi_allocate_thread_sets() returned"
-			" unexpected value!\n");
-		goto ts_out1;
 	}
 
 	lio_qr_cache = kmem_cache_create("lio_qr_cache",
@@ -572,7 +569,7 @@ static int __init iscsi_target_init_module(void)
 	if (!lio_qr_cache) {
 		pr_err("nable to kmem_cache_create() for"
 				" lio_qr_cache\n");
-		goto ts_out2;
+		goto bitmap_out;
 	}
 
 	lio_dr_cache = kmem_cache_create("lio_dr_cache",
@@ -617,10 +614,8 @@ dr_out:
 	kmem_cache_destroy(lio_dr_cache);
 qr_out:
 	kmem_cache_destroy(lio_qr_cache);
-ts_out2:
-	iscsi_deallocate_thread_sets();
-ts_out1:
-	iscsi_thread_set_free();
+bitmap_out:
+	vfree(iscsit_global->ts_bitmap);
 configfs_out:
 	iscsi_target_deregister_configfs();
 out:
@@ -630,8 +625,6 @@ out:
 
 static void __exit iscsi_target_cleanup_module(void)
 {
-	iscsi_deallocate_thread_sets();
-	iscsi_thread_set_free();
 	iscsit_release_discovery_tpg();
 	iscsit_unregister_transport(&iscsi_target_transport);
 	kmem_cache_destroy(lio_qr_cache);
@@ -641,6 +634,7 @@ static void __exit iscsi_target_cleanup_module(void)
 
 	iscsi_target_deregister_configfs();
 
+	vfree(iscsit_global->ts_bitmap);
 	kfree(iscsit_global);
 }
 
@@ -3710,17 +3704,16 @@ static int iscsit_send_reject(
 
 void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 {
-	struct iscsi_thread_set *ts = conn->thread_set;
 	int ord, cpu;
 	/*
-	 * thread_id is assigned from iscsit_global->ts_bitmap from
-	 * within iscsi_thread_set.c:iscsi_allocate_thread_sets()
+	 * bitmap_id is assigned from iscsit_global->ts_bitmap from
+	 * within iscsit_start_kthreads()
 	 *
-	 * Here we use thread_id to determine which CPU that this
-	 * iSCSI connection's iscsi_thread_set will be scheduled to
+	 * Here we use bitmap_id to determine which CPU that this
+	 * iSCSI connection's RX/TX threads will be scheduled to
 	 * execute upon.
 	 */
-	ord = ts->thread_id % cpumask_weight(cpu_online_mask);
+	ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
 	for_each_online_cpu(cpu) {
 		if (ord-- == 0) {
 			cpumask_set_cpu(cpu, conn->conn_cpumask);
@@ -3909,7 +3902,7 @@ check_rsp_state:
 	switch (state) {
 	case ISTATE_SEND_LOGOUTRSP:
 		if (!iscsit_logout_post_handler(cmd, conn))
-			goto restart;
+			return -ECONNRESET;
 		/* fall through */
 	case ISTATE_SEND_STATUS:
 	case ISTATE_SEND_ASYNCMSG:
@@ -3937,8 +3930,6 @@ check_rsp_state:
 
 err:
 	return -1;
-restart:
-	return -EAGAIN;
 }
 
 static int iscsit_handle_response_queue(struct iscsi_conn *conn)
@@ -3965,21 +3956,13 @@ static int iscsit_handle_response_queue(struct iscsi_conn *conn)
 int iscsi_target_tx_thread(void *arg)
 {
 	int ret = 0;
-	struct iscsi_conn *conn;
-	struct iscsi_thread_set *ts = arg;
+	struct iscsi_conn *conn = arg;
 	/*
 	 * Allow ourselves to be interrupted by SIGINT so that a
 	 * connection recovery / failure event can be triggered externally.
 	 */
 	allow_signal(SIGINT);
 
-restart:
-	conn = iscsi_tx_thread_pre_handler(ts);
-	if (!conn)
-		goto out;
-
-	ret = 0;
-
 	while (!kthread_should_stop()) {
 		/*
 		 * Ensure that both TX and RX per connection kthreads
@@ -3988,11 +3971,9 @@ restart:
 		iscsit_thread_check_cpumask(conn, current, 1);
 
 		wait_event_interruptible(conn->queues_wq,
-					 !iscsit_conn_all_queues_empty(conn) ||
-					 ts->status == ISCSI_THREAD_SET_RESET);
+					 !iscsit_conn_all_queues_empty(conn));
 
-		if ((ts->status == ISCSI_THREAD_SET_RESET) ||
-		     signal_pending(current))
+		if (signal_pending(current))
 			goto transport_err;
 
 get_immediate:
@@ -4003,15 +3984,14 @@ get_immediate:
 		ret = iscsit_handle_response_queue(conn);
 		if (ret == 1)
 			goto get_immediate;
-		else if (ret == -EAGAIN)
-			goto restart;
+		else if (ret == -ECONNRESET)
+			goto out;
 		else if (ret < 0)
 			goto transport_err;
 	}
 
 transport_err:
 	iscsit_take_action_for_connection_exit(conn);
-	goto restart;
 out:
 	return 0;
 }
@@ -4106,8 +4086,7 @@ int iscsi_target_rx_thread(void *arg)
 	int ret;
 	u8 buffer[ISCSI_HDR_LEN], opcode;
 	u32 checksum = 0, digest = 0;
-	struct iscsi_conn *conn = NULL;
-	struct iscsi_thread_set *ts = arg;
+	struct iscsi_conn *conn = arg;
 	struct kvec iov;
 	/*
 	 * Allow ourselves to be interrupted by SIGINT so that a
@@ -4115,11 +4094,6 @@ int iscsi_target_rx_thread(void *arg)
 	 */
 	allow_signal(SIGINT);
 
-restart:
-	conn = iscsi_rx_thread_pre_handler(ts);
-	if (!conn)
-		goto out;
-
 	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
 		struct completion comp;
 		int rc;
@@ -4129,7 +4103,7 @@ restart:
 		if (rc < 0)
 			goto transport_err;
 
-		goto out;
+		goto transport_err;
 	}
 
 	while (!kthread_should_stop()) {
@@ -4205,8 +4179,6 @@ transport_err:
 	if (!signal_pending(current))
 		atomic_set(&conn->transport_failed, 1);
 	iscsit_take_action_for_connection_exit(conn);
-	goto restart;
-out:
 	return 0;
 }
 
@@ -4268,7 +4240,26 @@ int iscsit_close_connection(
 	if (conn->conn_transport->transport_type == ISCSI_TCP)
 		complete(&conn->conn_logout_comp);
 
-	iscsi_release_thread_set(conn);
+	if (!strcmp(current->comm, ISCSI_RX_THREAD_NAME)) {
+		if (conn->tx_thread &&
+		    cmpxchg(&conn->tx_thread_active, true, false)) {
+			printk("close_conn signal tx_thread\n");
+			send_sig(SIGINT, conn->tx_thread, 1);
+			kthread_stop(conn->tx_thread);
+		}
+	} else if (!strcmp(current->comm, ISCSI_TX_THREAD_NAME)) {
+		if (conn->rx_thread &&
+		    cmpxchg(&conn->rx_thread_active, true, false)) {
+			printk("close_conn signal rx_thread\n");
+			send_sig(SIGINT, conn->rx_thread, 1);
+			kthread_stop(conn->rx_thread);
+		}
+	}
+
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+			      get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
 
 	iscsit_stop_timers_for_cmds(conn);
 	iscsit_stop_nopin_response_timer(conn);
@@ -4546,15 +4537,13 @@ static void iscsit_logout_post_handler_closesession(
 	struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
-
-	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
-	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+	int sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
 	complete(&conn->conn_logout_comp);
 
 	iscsit_dec_conn_usage_count(conn);
-	iscsit_stop_session(sess, 1, 1);
+	iscsit_stop_session(sess, sleep, sleep);
 	iscsit_dec_session_usage_count(sess);
 	target_put_session(sess->se_sess);
 }
@@ -4562,13 +4551,12 @@ static void iscsit_logout_post_handler_closesession(
 static void iscsit_logout_post_handler_samecid(
 	struct iscsi_conn *conn)
 {
-	iscsi_set_thread_clear(conn, ISCSI_CLEAR_TX_THREAD);
-	iscsi_set_thread_set_signal(conn, ISCSI_SIGNAL_TX_THREAD);
+	int sleep = cmpxchg(&conn->tx_thread_active, true, false);
 
 	atomic_set(&conn->conn_logout_remove, 0);
 	complete(&conn->conn_logout_comp);
 
-	iscsit_cause_connection_reinstatement(conn, 1);
+	iscsit_cause_connection_reinstatement(conn, sleep);
 	iscsit_dec_conn_usage_count(conn);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index bdd8731..e008ed2 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -860,7 +860,10 @@ void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *conn)
 	}
 	spin_unlock_bh(&conn->state_lock);
 
-	iscsi_thread_set_force_reinstatement(conn);
+	if (conn->tx_thread && conn->tx_thread_active)
+		send_sig(SIGINT, conn->tx_thread, 1);
+	if (conn->rx_thread && conn->rx_thread_active)
+		send_sig(SIGINT, conn->rx_thread, 1);
 
 sleep:
 	wait_for_completion(&conn->conn_wait_rcfr_comp);
@@ -885,10 +888,10 @@ void iscsit_cause_connection_reinstatement(struct iscsi_conn *conn, int sleep)
 		return;
 	}
 
-	if (iscsi_thread_set_force_reinstatement(conn) < 0) {
-		spin_unlock_bh(&conn->state_lock);
-		return;
-	}
+	if (conn->tx_thread && conn->tx_thread_active)
+		send_sig(SIGINT, conn->tx_thread, 1);
+	if (conn->rx_thread && conn->rx_thread_active)
+		send_sig(SIGINT, conn->rx_thread, 1);
 
 	atomic_set(&conn->connection_reinstatement, 1);
 	if (!sleep) {
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 153fb66..345f073 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -699,6 +699,51 @@ static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
 		iscsit_start_nopin_timer(conn);
 }
 
+int iscsit_start_kthreads(struct iscsi_conn *conn)
+{
+	int ret = 0;
+
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	conn->bitmap_id = bitmap_find_free_region(iscsit_global->ts_bitmap,
+					ISCSIT_BITMAP_BITS, get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
+
+	if (conn->bitmap_id < 0) {
+		pr_err("bitmap_find_free_region() failed for"
+		       " iscsit_start_kthreads()\n");
+		return -ENOMEM;
+	}
+
+	conn->tx_thread = kthread_run(iscsi_target_tx_thread, conn,
+				      "%s", ISCSI_TX_THREAD_NAME);
+	if (IS_ERR(conn->tx_thread)) {
+		pr_err("Unable to start iscsi_target_tx_thread\n");
+		ret = PTR_ERR(conn->tx_thread);
+		goto out_bitmap;
+	}
+	conn->tx_thread_active = true;
+
+	conn->rx_thread = kthread_run(iscsi_target_rx_thread, conn,
+				      "%s", ISCSI_RX_THREAD_NAME);
+	if (IS_ERR(conn->rx_thread)) {
+		pr_err("Unable to start iscsi_target_rx_thread\n");
+		ret = PTR_ERR(conn->rx_thread);
+		goto out_tx;
+	}
+	conn->rx_thread_active = true;
+
+	return 0;
+out_tx:
+	kthread_stop(conn->tx_thread);
+	conn->tx_thread_active = false;
+out_bitmap:
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+			      get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
+	return ret;
+}
+
 int iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsi_conn *conn,
@@ -709,7 +754,7 @@ int iscsi_post_login_handler(
 	struct se_session *se_sess = sess->se_sess;
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
-	struct iscsi_thread_set *ts;
+	int rc;
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -724,7 +769,6 @@ int iscsi_post_login_handler(
 	/*
 	 * SCSI Initiator -> SCSI Target Port Mapping
 	 */
-	ts = iscsi_get_thread_set();
 	if (!zero_tsih) {
 		iscsi_set_session_parameters(sess->sess_ops,
 				conn->param_list, 0);
@@ -751,9 +795,11 @@ int iscsi_post_login_handler(
 			sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
 
-		iscsi_post_login_start_timers(conn);
+		rc = iscsit_start_kthreads(conn);
+		if (rc)
+			return rc;
 
-		iscsi_activate_thread_set(conn, ts);
+		iscsi_post_login_start_timers(conn);
 		/*
 		 * Determine CPU mask to ensure connection's RX and TX kthreads
 		 * are scheduled on the same CPU.
@@ -810,8 +856,11 @@ int iscsi_post_login_handler(
 		" iSCSI Target Portal Group: %hu\n", tpg->nsessions, tpg->tpgt);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	rc = iscsit_start_kthreads(conn);
+	if (rc)
+		return rc;
+
 	iscsi_post_login_start_timers(conn);
-	iscsi_activate_thread_set(conn, ts);
 	/*
 	 * Determine CPU mask to ensure connection's RX and TX kthreads
 	 * are scheduled on the same CPU.
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index d3583d3..dd0f3ab 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -602,6 +602,11 @@ struct iscsi_conn {
 	struct iscsi_session	*sess;
 	/* Pointer to thread_set in use for this conn's threads */
 	struct iscsi_thread_set	*thread_set;
+	int			bitmap_id;
+	int			rx_thread_active;
+	struct task_struct	*rx_thread;
+	int			tx_thread_active;
+	struct task_struct	*tx_thread;
 	/* list_head for session connection list */
 	struct list_head	conn_list;
 } ____cacheline_aligned;
@@ -871,10 +876,12 @@ struct iscsit_global {
 	/* Unique identifier used for the authentication daemon */
 	u32			auth_id;
 	u32			inactive_ts;
+#define ISCSIT_BITMAP_BITS	262144
 	/* Thread Set bitmap count */
 	int			ts_bitmap_count;
 	/* Thread Set bitmap pointer */
 	unsigned long		*ts_bitmap;
+	spinlock_t		ts_bitmap_lock;
 	/* Used for iSCSI discovery session authentication */
 	struct iscsi_node_acl	discovery_acl;
 	struct iscsi_portal_group	*discovery_tpg;
-- 
1.9.1

