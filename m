From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 3/4] target/iscsi: Remove macros that contain typecasts
Date: Wed,  9 Oct 2013 11:05:58 -0700
Message-ID: <1381341959-22254-4-git-send-email-agrover@redhat.com>
References: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381341959-22254-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These just want to return a pointer instead of a value, but are otherwise
the same.

ISCSI_TPG_LUN macro was unused.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |    2 +-
 drivers/target/iscsi/iscsi_target_auth.c  |    2 +-
 drivers/target/iscsi/iscsi_target_core.h  |    4 ----
 drivers/target/iscsi/iscsi_target_erl0.c  |   10 +++++-----
 drivers/target/iscsi/iscsi_target_login.c |   16 ++++++++--------
 drivers/target/iscsi/iscsi_target_nego.c  |    6 +++---
 6 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 35b61f7..934b5b9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4376,7 +4376,7 @@ int iscsit_close_connection(
 
 int iscsit_close_session(struct iscsi_session *sess)
 {
-	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	if (atomic_read(&sess->nconn)) {
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 7505fdd..164b871 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -111,7 +111,7 @@ static struct iscsi_chap *chap_server_open(
 	/*
 	 * Set Identifier.
 	 */
-	chap->id = ISCSI_TPG_C(conn)->tpg_chap_id++;
+	chap->id = conn->tpg->tpg_chap_id++;
 	*aic_len += sprintf(aic_str + *aic_len, "CHAP_I=%d", chap->id);
 	*aic_len += 1;
 	pr_debug("[server] Sending CHAP_I=%d\n", chap->id);
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 1d14f77..cf8a192 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -830,10 +830,6 @@ struct iscsi_portal_group {
 	struct list_head	tpg_list;
 } ____cacheline_aligned;
 
-#define ISCSI_TPG_C(c)		((struct iscsi_portal_group *)(c)->tpg)
-#define ISCSI_TPG_LUN(c, l)  ((iscsi_tpg_list_t *)(c)->tpg->tpg_lun_list_t[l])
-#define ISCSI_TPG_S(s)		((struct iscsi_portal_group *)(s)->tpg)
-
 struct iscsi_wwn_stat_grps {
 	struct config_group	iscsi_stat_group;
 	struct config_group	iscsi_instance_group;
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 41052e5..cbea7f1 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -757,7 +757,7 @@ int iscsit_check_post_dataout(
 static void iscsit_handle_time2retain_timeout(unsigned long data)
 {
 	struct iscsi_session *sess = (struct iscsi_session *) data;
-	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	spin_lock_bh(&se_tpg->session_lock);
@@ -801,9 +801,9 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 	 * Only start Time2Retain timer when the associated TPG is still in
 	 * an ACTIVE (eg: not disabled or shutdown) state.
 	 */
-	spin_lock(&ISCSI_TPG_S(sess)->tpg_state_lock);
-	tpg_active = (ISCSI_TPG_S(sess)->tpg_state == TPG_STATE_ACTIVE);
-	spin_unlock(&ISCSI_TPG_S(sess)->tpg_state_lock);
+	spin_lock(&sess->tpg->tpg_state_lock);
+	tpg_active = (sess->tpg->tpg_state == TPG_STATE_ACTIVE);
+	spin_unlock(&sess->tpg->tpg_state_lock);
 
 	if (!tpg_active)
 		return;
@@ -829,7 +829,7 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
  */
 int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 {
-	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
 	if (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1794c75..646632a 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -347,15 +347,15 @@ static int iscsi_login_zero_tsih_s2(
 	 * Assign a new TPG Session Handle.  Note this is protected with
 	 * struct iscsi_portal_group->np_login_sem from iscsit_access_np().
 	 */
-	sess->tsih = ++ISCSI_TPG_S(sess)->ntsih;
+	sess->tsih = ++sess->tpg->ntsih;
 	if (!sess->tsih)
-		sess->tsih = ++ISCSI_TPG_S(sess)->ntsih;
+		sess->tsih = ++sess->tpg->ntsih;
 
 	/*
 	 * Create the default params from user defined values..
 	 */
 	if (iscsi_copy_param_list(&conn->param_list,
-				ISCSI_TPG_C(conn)->param_list, 1) < 0) {
+				conn->tpg->param_list, 1) < 0) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		return -1;
@@ -380,7 +380,7 @@ static int iscsi_login_zero_tsih_s2(
 	 * In our case, we have already located the struct iscsi_tiqn at this point.
 	 */
 	memset(buf, 0, 32);
-	sprintf(buf, "TargetPortalGroupTag=%hu", ISCSI_TPG_S(sess)->tpgt);
+	sprintf(buf, "TargetPortalGroupTag=%hu", sess->tpg->tpgt);
 	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -575,7 +575,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	iscsi_login_set_conn_values(sess, conn, pdu->cid);
 
 	if (iscsi_copy_param_list(&conn->param_list,
-			ISCSI_TPG_C(conn)->param_list, 0) < 0) {
+			conn->tpg->param_list, 0) < 0) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		return -1;
@@ -593,7 +593,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	 * In our case, we have already located the struct iscsi_tiqn at this point.
 	 */
 	memset(buf, 0, 32);
-	sprintf(buf, "TargetPortalGroupTag=%hu", ISCSI_TPG_S(sess)->tpgt);
+	sprintf(buf, "TargetPortalGroupTag=%hu", sess->tpg->tpgt);
 	if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -691,7 +691,7 @@ int iscsi_post_login_handler(
 	int stop_timer = 0;
 	struct iscsi_session *sess = conn->sess;
 	struct se_session *se_sess = sess->se_sess;
-	struct iscsi_portal_group *tpg = ISCSI_TPG_S(sess);
+	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct iscsi_thread_set *ts;
 
@@ -1154,7 +1154,7 @@ old_sess_out:
 		spin_lock_bh(&conn->sess->conn_lock);
 		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
 			struct se_portal_group *se_tpg =
-					&ISCSI_TPG_C(conn)->tpg_se_tpg;
+					&conn->tpg->tpg_se_tpg;
 
 			atomic_set(&conn->sess->session_continuation, 0);
 			spin_unlock_bh(&conn->sess->conn_lock);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 973a27f..21265c9 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -789,7 +789,7 @@ static int iscsi_target_handle_csg_zero(
 		return -1;
 
 	if (!iscsi_check_negotiated_keys(conn->param_list)) {
-		if (ISCSI_TPG_C(conn)->tpg_attrib.authentication &&
+		if (conn->tpg->tpg_attrib.authentication &&
 		    !strncmp(param->value, NONE, 4)) {
 			pr_err("Initiator sent AuthMethod=None but"
 				" Target is enforcing iSCSI Authentication,"
@@ -799,7 +799,7 @@ static int iscsi_target_handle_csg_zero(
 			return -1;
 		}
 
-		if (ISCSI_TPG_C(conn)->tpg_attrib.authentication &&
+		if (conn->tpg->tpg_attrib.authentication &&
 		    !login->auth_complete)
 			return 0;
 
@@ -862,7 +862,7 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 	}
 
 	if (!login->auth_complete &&
-	     ISCSI_TPG_C(conn)->tpg_attrib.authentication) {
+	     conn->tpg->tpg_attrib.authentication) {
 		pr_err("Initiator is requesting CSG: 1, has not been"
 			 " successfully authenticated, and the Target is"
 			" enforcing iSCSI Authentication, login failed.\n");
-- 
1.7.1
