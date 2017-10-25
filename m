From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:01:45 -0700
Message-ID: <20171025100145.GA144703@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Jiang Yi <jiangyilism@gmail.com>, Varun Prakash <varun@chelsio.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. Includes a fix for correcting an
on-stack timer usage.

Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jiang Yi <jiangyilism@gmail.com>
Cc: Varun Prakash <varun@chelsio.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/target/iscsi/iscsi_target_erl0.c  |  9 ++++-----
 drivers/target/iscsi/iscsi_target_erl1.c  |  8 +++-----
 drivers/target/iscsi/iscsi_target_login.c |  8 +++-----
 drivers/target/iscsi/iscsi_target_nego.c  | 23 ++++++++++++++---------
 drivers/target/iscsi/iscsi_target_util.c  | 21 ++++++++-------------
 5 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 7fe2aa73cff6..4c9db2525d01 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -749,9 +749,9 @@ int iscsit_check_post_dataout(
 	}
 }
 
-static void iscsit_handle_time2retain_timeout(unsigned long data)
+static void iscsit_handle_time2retain_timeout(struct timer_list *t)
 {
-	struct iscsi_session *sess = (struct iscsi_session *) data;
+	struct iscsi_session *sess = from_timer(sess, t, time2retain_timer);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
@@ -809,11 +809,10 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 	pr_debug("Starting Time2Retain timer for %u seconds on"
 		" SID: %u\n", sess->sess_ops->DefaultTime2Retain, sess->sid);
 
-	init_timer(&sess->time2retain_timer);
+	timer_setup(&sess->time2retain_timer,
+		    iscsit_handle_time2retain_timeout, 0);
 	sess->time2retain_timer.expires =
 		(get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
-	sess->time2retain_timer.data = (unsigned long)sess;
-	sess->time2retain_timer.function = iscsit_handle_time2retain_timeout;
 	sess->time2retain_timer_flags &= ~ISCSI_TF_STOP;
 	sess->time2retain_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&sess->time2retain_timer);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index fe9b7f1e44ac..6655a01e6b94 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1148,11 +1148,11 @@ static int iscsit_set_dataout_timeout_values(
 /*
  *	NOTE: Called from interrupt (timer) context.
  */
-static void iscsit_handle_dataout_timeout(unsigned long data)
+static void iscsit_handle_dataout_timeout(struct timer_list *t)
 {
 	u32 pdu_length = 0, pdu_offset = 0;
 	u32 r2t_length = 0, r2t_offset = 0;
-	struct iscsi_cmd *cmd = (struct iscsi_cmd *) data;
+	struct iscsi_cmd *cmd = from_timer(cmd, t, dataout_timer);
 	struct iscsi_conn *conn = cmd->conn;
 	struct iscsi_session *sess = NULL;
 	struct iscsi_node_attrib *na;
@@ -1264,10 +1264,8 @@ void iscsit_start_dataout_timer(
 	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
 		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
 
-	init_timer(&cmd->dataout_timer);
+	timer_setup(&cmd->dataout_timer, iscsit_handle_dataout_timeout, 0);
 	cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
-	cmd->dataout_timer.data = (unsigned long)cmd;
-	cmd->dataout_timer.function = iscsit_handle_dataout_timeout;
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&cmd->dataout_timer);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index dc13afbd4c88..1825579b4eef 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -839,9 +839,9 @@ void iscsi_post_login_handler(
 	iscsit_dec_conn_usage_count(conn);
 }
 
-static void iscsi_handle_login_thread_timeout(unsigned long data)
+static void iscsi_handle_login_thread_timeout(struct timer_list *t)
 {
-	struct iscsi_np *np = (struct iscsi_np *) data;
+	struct iscsi_np *np = from_timer(np, t, np_login_timer);
 
 	spin_lock_bh(&np->np_thread_lock);
 	pr_err("iSCSI Login timeout on Network Portal %pISpc\n",
@@ -866,10 +866,8 @@ static void iscsi_start_login_thread_timer(struct iscsi_np *np)
 	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeout
 	 */
 	spin_lock_bh(&np->np_thread_lock);
-	init_timer(&np->np_login_timer);
+	timer_setup(&np->np_login_timer, iscsi_handle_login_thread_timeout, 0);
 	np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	np->np_login_timer.data = (unsigned long)np;
-	np->np_login_timer.function = iscsi_handle_login_thread_timeout;
 	np->np_login_timer_flags &= ~ISCSI_TF_STOP;
 	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&np->np_login_timer);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 7a6751fecd32..7d8d53a5a4c2 100644
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
 
@@ -618,15 +624,14 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	conn->login_kworker = current;
 	allow_signal(SIGINT);
 
-	init_timer(&login_timer);
-	login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	login_timer.data = (unsigned long)conn;
-	login_timer.function = iscsi_target_login_timeout;
-	add_timer(&login_timer);
+	timer_setup_on_stack(&timeout.timer, iscsi_target_login_timeout, 0);
+	timeout.timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
+	add_timer(&timeout.timer);
 	pr_debug("Starting login_timer for %s/%d\n", current->comm, current->pid);
 
 	rc = conn->conn_transport->iscsit_get_login_rx(conn, login);
-	del_timer_sync(&login_timer);
+	del_timer_sync(&timeout.timer);
+	destroy_timer_on_stack(&timeout.timer);
 	flush_signals(current);
 	conn->login_kworker = NULL;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1e36f83b5961..32aa06cf9a27 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -880,9 +880,9 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 	return 0;
 }
 
-static void iscsit_handle_nopin_response_timeout(unsigned long data)
+static void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *) data;
+	struct iscsi_conn *conn = from_timer(conn, t, nopin_response_timer);
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -949,11 +949,10 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 		return;
 	}
 
-	init_timer(&conn->nopin_response_timer);
+	timer_setup(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, 0);
 	conn->nopin_response_timer.expires =
 		(get_jiffies_64() + na->nopin_response_timeout * HZ);
-	conn->nopin_response_timer.data = (unsigned long)conn;
-	conn->nopin_response_timer.function = iscsit_handle_nopin_response_timeout;
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_response_timer);
@@ -980,9 +979,9 @@ void iscsit_stop_nopin_response_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
-static void iscsit_handle_nopin_timeout(unsigned long data)
+static void iscsit_handle_nopin_timeout(struct timer_list *t)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn *) data;
+	struct iscsi_conn *conn = from_timer(conn, t, nopin_timer);
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -1015,10 +1014,8 @@ void __iscsit_start_nopin_timer(struct iscsi_conn *conn)
 	if (conn->nopin_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
-	init_timer(&conn->nopin_timer);
+	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
 	conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
-	conn->nopin_timer.data = (unsigned long)conn;
-	conn->nopin_timer.function = iscsit_handle_nopin_timeout;
 	conn->nopin_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_timer);
@@ -1043,10 +1040,8 @@ void iscsit_start_nopin_timer(struct iscsi_conn *conn)
 		return;
 	}
 
-	init_timer(&conn->nopin_timer);
+	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
 	conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
-	conn->nopin_timer.data = (unsigned long)conn;
-	conn->nopin_timer.function = iscsit_handle_nopin_timeout;
 	conn->nopin_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_timer);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
