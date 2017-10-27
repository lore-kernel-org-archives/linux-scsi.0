From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Fri, 27 Oct 2017 02:19:30 -0700
Message-ID: <20171027091930.GA14728@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jiang Yi <jiangyilism@gmail.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. Includes a fix for correcting an
on-stack timer usage.

Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jiang Yi <jiangyilism@gmail.com>
Cc: Varun Prakash <varun@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is rebased on top of Bart's timer clean-up patch:
https://www.spinics.net/lists/target-devel/msg15385.html
---
 drivers/target/iscsi/iscsi_target.c       |  3 +--
 drivers/target/iscsi/iscsi_target_erl0.c  |  4 ++--
 drivers/target/iscsi/iscsi_target_erl0.h  |  2 +-
 drivers/target/iscsi/iscsi_target_erl1.c  |  4 ++--
 drivers/target/iscsi/iscsi_target_erl1.h  |  2 +-
 drivers/target/iscsi/iscsi_target_login.c | 15 +++++++--------
 drivers/target/iscsi/iscsi_target_login.h |  2 +-
 drivers/target/iscsi/iscsi_target_nego.c  | 23 +++++++++++++++--------
 drivers/target/iscsi/iscsi_target_util.c  | 11 +++++------
 drivers/target/iscsi/iscsi_target_util.h  |  4 ++--
 10 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7d619160b3d3..9e67c7678c86 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -372,8 +372,7 @@ struct iscsi_np *iscsit_add_np(
 	init_completion(&np->np_restart_comp);
 	INIT_LIST_HEAD(&np->np_list);
 
-	setup_timer(&np->np_login_timer, iscsi_handle_login_thread_timeout,
-		    (unsigned long)np);
+	timer_setup(&np->np_login_timer, iscsi_handle_login_thread_timeout, 0);
 
 	ret = iscsi_target_setup_login_socket(np, sockaddr);
 	if (ret != 0) {
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index f164098594e9..718fe9a1b709 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -749,9 +749,9 @@ int iscsit_check_post_dataout(
 	}
 }
 
-void iscsit_handle_time2retain_timeout(unsigned long data)
+void iscsit_handle_time2retain_timeout(struct timer_list *t)
 {
-	struct iscsi_session *sess = (struct iscsi_session *) data;
+	struct iscsi_session *sess = from_timer(sess, t, time2retain_timer);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 97e4ae728926..dba5e7826574 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -11,7 +11,7 @@ extern void iscsit_set_dataout_sequence_values(struct iscsi_cmd *);
 extern int iscsit_check_pre_dataout(struct iscsi_cmd *, unsigned char *);
 extern int iscsit_check_post_dataout(struct iscsi_cmd *, unsigned char *, u8);
 extern void iscsit_start_time2retain_handler(struct iscsi_session *);
-extern void iscsit_handle_time2retain_timeout(unsigned long data);
+extern void iscsit_handle_time2retain_timeout(struct timer_list *t);
 extern int iscsit_stop_time2retain_timer(struct iscsi_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsi_conn *, int);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 19b28255b687..76184094a0cf 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1148,11 +1148,11 @@ static int iscsit_set_dataout_timeout_values(
 /*
  *	NOTE: Called from interrupt (timer) context.
  */
-void iscsit_handle_dataout_timeout(unsigned long data)
+void iscsit_handle_dataout_timeout(struct timer_list *t)
 {
 	u32 pdu_length = 0, pdu_offset = 0;
 	u32 r2t_length = 0, r2t_offset = 0;
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *) data;
+	struct iscsi_cmd *cmd = from_timer(cmd, t, dataout_timer);
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_session *sess = NULL;
 	struct iscsi_node_attrib *na;
diff --git a/drivers/target/iscsi/iscsi_target_erl1.h b/drivers/target/iscsi/iscsi_target_erl1.h
index 0ff6e310ca36..6a6e182674de 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.h
+++ b/drivers/target/iscsi/iscsi_target_erl1.h
@@ -29,7 +29,7 @@ extern int iscsit_execute_ooo_cmdsns(struct iscsi_session *);
 extern int iscsit_execute_cmd(struct iscsi_cmd *, int);
 extern int iscsit_handle_ooo_cmdsn(struct iscsi_session *, struct iscsi_cmd *, u32);
 extern void iscsit_remove_ooo_cmdsn(struct iscsi_session *, struct iscsi_ooo_cmdsn *);
-extern void iscsit_handle_dataout_timeout(unsigned long data);
+extern void iscsit_handle_dataout_timeout(struct timer_list *t);
 extern void iscsit_mod_dataout_timer(struct iscsi_cmd *);
 extern void iscsit_start_dataout_timer(struct iscsi_cmd *, struct iscsi_conn *);
 extern void iscsit_stop_dataout_timer(struct iscsi_cmd *);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8be9221b6b9d..64c5a57b92e4 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -333,8 +333,8 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
-	setup_timer(&sess->time2retain_timer, iscsit_handle_time2retain_timeout,
-		    (unsigned long)sess);
+	timer_setup(&sess->time2retain_timer,
+		    iscsit_handle_time2retain_timeout, 0);
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_bh(&sess_idr_lock);
@@ -842,9 +842,9 @@ void iscsi_post_login_handler(
 	iscsit_dec_conn_usage_count(conn);
 }
 
-void iscsi_handle_login_thread_timeout(unsigned long data)
+void iscsi_handle_login_thread_timeout(struct timer_list *t)
 {
-	struct iscsi_np *np = (struct iscsi_np *) data;
+	struct iscsi_np *np = from_timer(np, t, np_login_timer);
 
 	spin_lock_bh(&np->np_thread_lock);
 	pr_err("iSCSI Login timeout on Network Portal %pISpc\n",
@@ -1265,10 +1265,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 
-	setup_timer(&conn->nopin_response_timer,
-		    iscsit_handle_nopin_response_timeout, (unsigned long)conn);
-	setup_timer(&conn->nopin_timer, iscsit_handle_nopin_timeout,
-		    (unsigned long)conn);
+	timer_setup(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, 0);
+	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
 
 	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
 		kfree(conn);
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index f77850bf3e58..f3c4e7bf5763 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -24,6 +24,6 @@ extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8)
 extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
 				bool, bool);
 extern int iscsi_target_login_thread(void *);
-extern void iscsi_handle_login_thread_timeout(unsigned long data);
+extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
 
 #endif   /*** ISCSI_TARGET_LOGIN_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index c851bd9f3175..b686e2ce9c0e 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -559,9 +559,15 @@ static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login
 	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
 }
 
-static void iscsi_target_login_timeout(unsigned long data)
+struct conn_timeout {
+	struct timer_list timer;
+	struct iscsi_conn *conn;
+};
+
+static void iscsi_target_login_timeout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *)data;
+	struct conn_timeout *timeout = from_timer(timeout, t, timer);
+	struct iscsi_conn *conn = timeout->conn;
 
 	pr_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
 
@@ -580,7 +586,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	struct iscsi_np *np = login->np;
 	struct iscsi_portal_group *tpg = conn->tpg;
 	struct iscsi_tpg_np *tpg_np = conn->tpg_np;
-	struct timer_list login_timer;
+	struct conn_timeout timeout;
 	int rc, zero_tsih = login->zero_tsih;
 	bool state;
 
@@ -618,13 +624,14 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	conn->login_kworker = current;
 	allow_signal(SIGINT);
 
-	setup_timer_on_stack(&login_timer, iscsi_target_login_timeout,
-			     (unsigned long)conn);
-	mod_timer(&login_timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
-	pr_debug("Starting login_timer for %s/%d\n", current->comm, current->pid);
+	timeout.conn = conn;
+	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
+	mod_timer(&timeout.timer, jiffies + TA_LOGIN_TIMEOUT * HZ);
+	pr_debug("Starting login timer for %s/%d\n", current->comm, current->pid);
 
 	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
-	del_timer_sync(&login_timer);
+	del_timer_sync(&timeout.timer);
+	destroy_timer_on_stack(&timeout.timer);
 	flush_signals(current);
 	conn->login_kworker = NULL;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 505dad5dab7f..54f20f184dd6 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -176,8 +176,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, int state)
 	spin_lock_init(&cmd->istate_lock);
 	spin_lock_init(&cmd->error_lock);
 	spin_lock_init(&cmd->r2t_lock);
-	setup_timer(&cmd->dataout_timer, iscsit_handle_dataout_timeout,
-		    (unsigned long)cmd);
+	timer_setup(&cmd->dataout_timer, iscsit_handle_dataout_timeout, 0);
 
 	return cmd;
 }
@@ -882,9 +881,9 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 	return 0;
 }
 
-void iscsit_handle_nopin_response_timeout(unsigned long data)
+void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *) data;
+	struct iscsi_conn *conn = from_timer(conn, t, nopin_response_timer);
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -978,9 +977,9 @@ void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-void iscsit_handle_nopin_timeout(unsigned long data)
+void iscsit_handle_nopin_timeout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *) data;
+	struct iscsi_conn *conn = from_timer(conn, t, nopin_timer);
 
 	iscsit_inc_conn_usage_count(conn);
 
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 78b3b9d20963..5a5f27877f49 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -47,11 +47,11 @@ extern struct iscsi_conn *iscsit_get_conn_from_cid_rcfr(struct iscsi_session *,
 extern void iscsit_check_conn_usage_count(struct iscsi_conn *);
 extern void iscsit_dec_conn_usage_count(struct iscsi_conn *);
 extern void iscsit_inc_conn_usage_count(struct iscsi_conn *);
-extern void iscsit_handle_nopin_response_timeout(unsigned long data);
+extern void iscsit_handle_nopin_response_timeout(struct timer_list *t);
 extern void iscsit_mod_nopin_response_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_response_timer(struct iscsi_conn *);
 extern void iscsit_stop_nopin_response_timer(struct iscsi_conn *);
-extern void iscsit_handle_nopin_timeout(unsigned long data);
+extern void iscsit_handle_nopin_timeout(struct timer_list *t);
 extern void __iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_start_nopin_timer(struct iscsi_conn *);
 extern void iscsit_stop_nopin_timer(struct iscsi_conn *);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
