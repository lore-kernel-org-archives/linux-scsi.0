From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 4/9] iscsi-target: Add iser-target parameter keys + setup during login
Date: Fri, 12 Apr 2013 20:52:37 +0000
Message-ID: <1365799962-13543-5-git-send-email-nab@linux-iscsi.org>
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds RDMAExtensions, InitiatorRecvDataSegmentLength and
TargetRecvDataSegmentLength parameters keys necessary for iser-target
login to occur.

This includes setting the necessary parameters during login path
code within iscsi_login_zero_tsih_s2(), and currently PAGE_SIZE
aligning the target's advertised MRDSL for immediate data and
unsolicited data-out incoming payloads.

v3 changes:
- Add iscsi_post_login_start_timers FIXME for ISER

v2 changes:

- Fix RDMAExtentions -> RDMAExtensions typo (andy)
- Drop unnecessary '== true' conditional checks for type bool

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_core.h       |   10 +++
 drivers/target/iscsi/iscsi_target_login.c      |   77 ++++++++++++++++++++----
 drivers/target/iscsi/iscsi_target_parameters.c |   75 +++++++++++++++++++++--
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +++++-
 4 files changed, 161 insertions(+), 17 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 2587677..53400b0 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -244,6 +244,11 @@ struct iscsi_conn_ops {
 	u8	IFMarker;			/* [0,1] == [No,Yes] */
 	u32	OFMarkInt;			/* [1..65535] */
 	u32	IFMarkInt;			/* [1..65535] */
+	/*
+	 * iSER specific connection parameters
+	 */
+	u32	InitiatorRecvDataSegmentLength;	/* [512..2**24-1] */
+	u32	TargetRecvDataSegmentLength;	/* [512..2**24-1] */
 };
 
 struct iscsi_sess_ops {
@@ -265,6 +270,10 @@ struct iscsi_sess_ops {
 	u8	DataSequenceInOrder;		/* [0,1] == [No,Yes] */
 	u8	ErrorRecoveryLevel;		/* [0..2] */
 	u8	SessionType;			/* [0,1] == [Normal,Discovery]*/
+	/*
+	 * iSER specific session parameters
+	 */
+	u8	RDMAExtensions;			/* [0,1] == [No,Yes] */
 };
 
 struct iscsi_queue_req {
@@ -284,6 +293,7 @@ struct iscsi_data_count {
 };
 
 struct iscsi_param_list {
+	bool			iser;
 	struct list_head	param_list;
 	struct list_head	extra_response_list;
 };
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 0de5c47..e6a8269 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -340,6 +340,7 @@ static int iscsi_login_zero_tsih_s2(
 	struct iscsi_node_attrib *na;
 	struct iscsi_session *sess = conn->sess;
 	unsigned char buf[32];
+	bool iser = false;
 
 	sess->tpg = conn->tpg;
 
@@ -361,7 +362,10 @@ static int iscsi_login_zero_tsih_s2(
 		return -1;
 	}
 
-	iscsi_set_keys_to_negotiate(0, conn->param_list);
+	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
+		iser = true;
+
+	iscsi_set_keys_to_negotiate(conn->param_list, iser);
 
 	if (sess->sess_ops->SessionType)
 		return iscsi_set_keys_irrelevant_for_discovery(
@@ -399,6 +403,56 @@ static int iscsi_login_zero_tsih_s2(
 
 	if (iscsi_login_disable_FIM_keys(conn->param_list, conn) < 0)
 		return -1;
+	/*
+	 * Set RDMAExtensions=Yes by default for iSER enabled network portals
+	 */
+	if (iser) {
+		struct iscsi_param *param;
+		unsigned long mrdsl, off;
+		int rc;
+
+		sprintf(buf, "RDMAExtensions=Yes");
+		if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
+		/*
+		 * Make MaxRecvDataSegmentLength PAGE_SIZE aligned for
+		 * Immediate Data + Unsolicitied Data-OUT if necessary..
+		 */
+		param = iscsi_find_param_from_key("MaxRecvDataSegmentLength",
+						  conn->param_list);
+		if (!param) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
+		rc = strict_strtoul(param->value, 0, &mrdsl);
+		if (rc < 0) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
+		off = mrdsl % PAGE_SIZE;
+		if (!off)
+			return 0;
+
+		if (mrdsl < PAGE_SIZE)
+			mrdsl = PAGE_SIZE;
+		else
+			mrdsl -= off;
+
+		pr_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
+			" to PAGE_SIZE\n", mrdsl);
+
+		sprintf(buf, "MaxRecvDataSegmentLength=%lu\n", mrdsl);
+		if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+				ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
+	}
 
 	return 0;
 }
@@ -478,6 +532,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct se_session *se_sess, *se_sess_tmp;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
+	bool iser = false;
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
@@ -527,7 +582,10 @@ static int iscsi_login_non_zero_tsih_s2(
 		return -1;
 	}
 
-	iscsi_set_keys_to_negotiate(0, conn->param_list);
+	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
+		iser = true;
+
+	iscsi_set_keys_to_negotiate(conn->param_list, iser);
 	/*
 	 * Need to send TargetPortalGroupTag back in first login response
 	 * on any iSCSI connection where the Initiator provides TargetName.
@@ -615,13 +673,15 @@ int iscsi_login_post_auth_non_zero_tsih(
 
 static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
 {
-#warning FIXME: Reenable iscsit_start_nopin_timer
-#if 0
 	struct iscsi_session *sess = conn->sess;
+	/*
+	 * FIXME: Unsolicitied NopIN support for ISER
+	 */
+	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
+		return;
 
 	if (!sess->sess_ops->SessionType)
 		iscsit_start_nopin_timer(conn);
-#endif
 }
 
 static int iscsi_post_login_handler(
@@ -678,12 +738,7 @@ static int iscsi_post_login_handler(
 
 		iscsi_post_login_start_timers(conn);
 
-		if (conn->conn_transport == ISCSI_TCP) {
-			iscsi_activate_thread_set(conn, ts);
-		} else {
-			printk("Not calling iscsi_activate_thread_set....\n");
-			dump_stack();
-		}
+		iscsi_activate_thread_set(conn, ts);
 		/*
 		 * Determine CPU mask to ensure connection's RX and TX kthreads
 		 * are scheduled on the same CPU.
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 84ce94a..f690be9 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -433,6 +433,28 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 			TYPERANGE_MARKINT, USE_INITIAL_ONLY);
 	if (!param)
 		goto out;
+	/*
+	 * Extra parameters for ISER from RFC-5046
+	 */
+	param = iscsi_set_default_param(pl, RDMAEXTENTIONS, INITIAL_RDMAEXTENTIONS,
+			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
+			TYPERANGE_BOOL_AND, USE_LEADING_ONLY);
+	if (!param)
+		goto out;
+
+	param = iscsi_set_default_param(pl, INITIATORRECVDATASEGMENTLENGTH,
+			INITIAL_INITIATORRECVDATASEGMENTLENGTH,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_512_TO_16777215, USE_ALL);
+	if (!param)
+		goto out;
+
+	param = iscsi_set_default_param(pl, TARGETRECVDATASEGMENTLENGTH,
+			INITIAL_TARGETRECVDATASEGMENTLENGTH,
+			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
+			TYPERANGE_512_TO_16777215, USE_ALL);
+	if (!param)
+		goto out;
 
 	*param_list_ptr = pl;
 	return 0;
@@ -442,19 +464,23 @@ out:
 }
 
 int iscsi_set_keys_to_negotiate(
-	int sessiontype,
-	struct iscsi_param_list *param_list)
+	struct iscsi_param_list *param_list,
+	bool iser)
 {
 	struct iscsi_param *param;
 
+	param_list->iser = iser;
+
 	list_for_each_entry(param, &param_list->param_list, p_list) {
 		param->state = 0;
 		if (!strcmp(param->name, AUTHMETHOD)) {
 			SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, HEADERDIGEST)) {
-			SET_PSTATE_NEGOTIATE(param);
+			if (iser == false)
+				SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, DATADIGEST)) {
-			SET_PSTATE_NEGOTIATE(param);
+			if (iser == false)
+				SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, MAXCONNECTIONS)) {
 			SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, TARGETNAME)) {
@@ -473,7 +499,8 @@ int iscsi_set_keys_to_negotiate(
 		} else if (!strcmp(param->name, IMMEDIATEDATA)) {
 			SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, MAXRECVDATASEGMENTLENGTH)) {
-			SET_PSTATE_NEGOTIATE(param);
+			if (iser == false)
+				SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, MAXXMITDATASEGMENTLENGTH)) {
 			continue;
 		} else if (!strcmp(param->name, MAXBURSTLENGTH)) {
@@ -502,6 +529,15 @@ int iscsi_set_keys_to_negotiate(
 			SET_PSTATE_NEGOTIATE(param);
 		} else if (!strcmp(param->name, OFMARKINT)) {
 			SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, RDMAEXTENTIONS)) {
+			if (iser == true)
+				SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, INITIATORRECVDATASEGMENTLENGTH)) {
+			if (iser == true)
+				SET_PSTATE_NEGOTIATE(param);
+		} else if (!strcmp(param->name, TARGETRECVDATASEGMENTLENGTH)) {
+			if (iser == true)
+				SET_PSTATE_NEGOTIATE(param);
 		}
 	}
 
@@ -544,6 +580,12 @@ int iscsi_set_keys_irrelevant_for_discovery(
 			param->state &= ~PSTATE_NEGOTIATE;
 		else if (!strcmp(param->name, OFMARKINT))
 			param->state &= ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, RDMAEXTENTIONS))
+			param->state &= ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, INITIATORRECVDATASEGMENTLENGTH))
+			param->state &= ~PSTATE_NEGOTIATE;
+		else if (!strcmp(param->name, TARGETRECVDATASEGMENTLENGTH))
+			param->state &= ~PSTATE_NEGOTIATE;
 	}
 
 	return 0;
@@ -1759,6 +1801,9 @@ void iscsi_set_connection_parameters(
 		 * this key is not sent over the wire.
 		 */
 		if (!strcmp(param->name, MAXXMITDATASEGMENTLENGTH)) {
+			if (param_list->iser == true)
+				continue;
+
 			ops->MaxXmitDataSegmentLength =
 				simple_strtoul(param->value, &tmpptr, 0);
 			pr_debug("MaxXmitDataSegmentLength:     %s\n",
@@ -1804,6 +1849,22 @@ void iscsi_set_connection_parameters(
 				simple_strtoul(param->value, &tmpptr, 0);
 			pr_debug("IFMarkInt:                    %s\n",
 				param->value);
+		} else if (!strcmp(param->name, INITIATORRECVDATASEGMENTLENGTH)) {
+			ops->InitiatorRecvDataSegmentLength =
+				simple_strtoul(param->value, &tmpptr, 0);
+			pr_debug("InitiatorRecvDataSegmentLength: %s\n",
+				param->value);
+			ops->MaxRecvDataSegmentLength =
+					ops->InitiatorRecvDataSegmentLength;
+			pr_debug("Set MRDSL from InitiatorRecvDataSegmentLength\n");
+		} else if (!strcmp(param->name, TARGETRECVDATASEGMENTLENGTH)) {
+			ops->TargetRecvDataSegmentLength =
+				simple_strtoul(param->value, &tmpptr, 0);
+			pr_debug("TargetRecvDataSegmentLength:  %s\n",
+				param->value);
+			ops->MaxXmitDataSegmentLength =
+					ops->TargetRecvDataSegmentLength;
+			pr_debug("Set MXDSL from TargetRecvDataSegmentLength\n");
 		}
 	}
 	pr_debug("----------------------------------------------------"
@@ -1916,6 +1977,10 @@ void iscsi_set_session_parameters(
 			ops->SessionType = !strcmp(param->value, DISCOVERY);
 			pr_debug("SessionType:                  %s\n",
 				param->value);
+		} else if (!strcmp(param->name, RDMAEXTENTIONS)) {
+			ops->RDMAExtensions = !strcmp(param->value, YES);
+			pr_debug("RDMAExtensions:               %s\n",
+				param->value);
 		}
 	}
 	pr_debug("----------------------------------------------------"
diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 1e1b750..f31b9c4 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -27,7 +27,7 @@ extern void iscsi_dump_conn_ops(struct iscsi_conn_ops *);
 extern void iscsi_dump_sess_ops(struct iscsi_sess_ops *);
 extern void iscsi_print_params(struct iscsi_param_list *);
 extern int iscsi_create_default_params(struct iscsi_param_list **);
-extern int iscsi_set_keys_to_negotiate(int, struct iscsi_param_list *);
+extern int iscsi_set_keys_to_negotiate(struct iscsi_param_list *, bool);
 extern int iscsi_set_keys_irrelevant_for_discovery(struct iscsi_param_list *);
 extern int iscsi_copy_param_list(struct iscsi_param_list **,
 			struct iscsi_param_list *, int);
@@ -89,6 +89,13 @@ extern void iscsi_set_session_parameters(struct iscsi_sess_ops *,
 #define X_EXTENSIONKEY_CISCO_OLD	"X-com.cisco.iscsi.draft"
 
 /*
+ * Parameter names of iSCSI Extentions for RDMA (iSER).  See RFC-5046
+ */
+#define RDMAEXTENTIONS			"RDMAExtensions"
+#define INITIATORRECVDATASEGMENTLENGTH	"InitiatorRecvDataSegmentLength"
+#define TARGETRECVDATASEGMENTLENGTH	"TargetRecvDataSegmentLength"
+
+/*
  * For AuthMethod.
  */
 #define KRB5				"KRB5"
@@ -133,6 +140,13 @@ extern void iscsi_set_session_parameters(struct iscsi_sess_ops *,
 #define INITIAL_OFMARKINT			"2048~65535"
 
 /*
+ * Initial values for iSER parameters following RFC-5046 Section 6
+ */
+#define INITIAL_RDMAEXTENTIONS			NO
+#define INITIAL_INITIATORRECVDATASEGMENTLENGTH	"262144"
+#define INITIAL_TARGETRECVDATASEGMENTLENGTH	"8192"
+
+/*
  * For [Header,Data]Digests.
  */
 #define CRC32C				"CRC32C"
-- 
1.7.2.5
