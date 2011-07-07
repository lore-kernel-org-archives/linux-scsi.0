From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 19/20] target/iscsi: Remove unneeded parens in conditional statements
Date: Thu,  7 Jul 2011 15:33:30 -0700
Message-ID: <1310078011-15504-20-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1GGWdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:49 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Similar to the previous two csets, this one removes unneeded parens from
conditional statements in the iscsi fabric, where there is no issue
of precedence that may occur.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c              |    2 +-
 drivers/target/iscsi/iscsi_target_login.c        |   10 +-
 drivers/target/iscsi/iscsi_target_parameters.c   |  120 +++++++++++-----------
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c |   10 +-
 drivers/target/iscsi/iscsi_target_tq.c           |   16 ++--
 drivers/target/iscsi/iscsi_target_util.c         |    4 +-
 6 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3007956..6b92b5b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3736,7 +3736,7 @@ check_rsp_state:
 				break;
 			case ISTATE_SEND_LOGOUTRSP:
 				spin_unlock_bh(&cmd->istate_lock);
-				if (!(iscsit_logout_post_handler(cmd, conn)))
+				if (!iscsit_logout_post_handler(cmd, conn))
 					goto restart;
 				spin_lock_bh(&cmd->istate_lock);
 				use_misc = 0;
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c54e500..9c83478 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -62,7 +62,7 @@ static int iscsi_login_init_conn(struct iscsi_conn *conn)
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
 
-	if (!(zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL))) {
+	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
 		pr_err("Unable to allocate conn->conn_cpumask\n");
 		return -ENOMEM;
 	}
@@ -437,8 +437,8 @@ static int iscsi_login_non_zero_tsih_s2(
 		    atomic_read(&sess_p->session_logout) ||
 		   (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED))
 			continue;
-		if (!(memcmp((const void *)sess_p->isid,
-		     (const void *)pdu->isid, 6)) &&
+		if (!memcmp((const void *)sess_p->isid,
+		     (const void *)pdu->isid, 6) &&
 		     (sess_p->tsih == pdu->tsih)) {
 			iscsit_inc_session_usage_count(sess_p);
 			iscsit_stop_time2retain_timer(sess_p);
@@ -1014,10 +1014,10 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			goto new_sess_out;
 		}
 #if 0
-		if (!(iscsi_ntop6((const unsigned char *)
+		if (!iscsi_ntop6((const unsigned char *)
 				&sock_in6.sin6_addr.in6_u,
 				(char *)&conn->ipv6_login_ip[0],
-				IPV6_ADDRESS_SPACE))) {
+				IPV6_ADDRESS_SPACE)) {
 			pr_err("iscsi_ntop6() failed\n");
 			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 					ISCSI_LOGIN_STATUS_TARGET_ERROR);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 3e2ad2c..86896ef 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -148,20 +148,20 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 	struct iscsi_param *param = NULL;
 
 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
-	if (!(param)) {
+	if (!param) {
 		pr_err("Unable to allocate memory for parameter.\n");
 		goto out;
 	}
 	INIT_LIST_HEAD(&param->p_list);
 
 	param->name = kzalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!(param->name)) {
+	if (!param->name) {
 		pr_err("Unable to allocate memory for parameter name.\n");
 		goto out;
 	}
 
 	param->value = kzalloc(strlen(value) + 1, GFP_KERNEL);
-	if (!(param->value)) {
+	if (!param->value) {
 		pr_err("Unable to allocate memory for parameter value.\n");
 		goto out;
 	}
@@ -231,7 +231,7 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 	struct iscsi_param_list *pl;
 
 	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
-	if (!(pl)) {
+	if (!pl) {
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_param_list.\n");
 		return -1 ;
@@ -253,178 +253,178 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 	param = iscsi_set_default_param(pl, AUTHMETHOD, INITIAL_AUTHMETHOD,
 			PHASE_SECURITY, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_AUTH, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, HEADERDIGEST, INITIAL_HEADERDIGEST,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, DATADIGEST, INITIAL_DATADIGEST,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, MAXCONNECTIONS,
 			INITIAL_MAXCONNECTIONS, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, SENDTARGETS, INITIAL_SENDTARGETS,
 			PHASE_FFP0, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_UTF8, 0);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, TARGETNAME, INITIAL_TARGETNAME,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_ISCSINAME, USE_ALL);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, INITIATORNAME,
 			INITIAL_INITIATORNAME, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_ISCSINAME, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, TARGETALIAS, INITIAL_TARGETALIAS,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_UTF8, USE_ALL);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, INITIATORALIAS,
 			INITIAL_INITIATORALIAS, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_INITIATOR, TYPERANGE_UTF8,
 			USE_ALL);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, TARGETADDRESS,
 			INITIAL_TARGETADDRESS, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_TARGETADDRESS, USE_ALL);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, TARGETPORTALGROUPTAG,
 			INITIAL_TARGETPORTALGROUPTAG,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_0_TO_65535, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, INITIALR2T, INITIAL_INITIALR2T,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, IMMEDIATEDATA,
 			INITIAL_IMMEDIATEDATA, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_AND,
 			USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, MAXRECVDATASEGMENTLENGTH,
 			INITIAL_MAXRECVDATASEGMENTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_ALL);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, MAXBURSTLENGTH,
 			INITIAL_MAXBURSTLENGTH, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, FIRSTBURSTLENGTH,
 			INITIAL_FIRSTBURSTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, DEFAULTTIME2WAIT,
 			INITIAL_DEFAULTTIME2WAIT,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, DEFAULTTIME2RETAIN,
 			INITIAL_DEFAULTTIME2RETAIN,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, MAXOUTSTANDINGR2T,
 			INITIAL_MAXOUTSTANDINGR2T,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, DATAPDUINORDER,
 			INITIAL_DATAPDUINORDER, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_OR,
 			USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, DATASEQUENCEINORDER,
 			INITIAL_DATASEQUENCEINORDER,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, ERRORRECOVERYLEVEL,
 			INITIAL_ERRORRECOVERYLEVEL,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_2, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, SESSIONTYPE, INITIAL_SESSIONTYPE,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_SESSIONTYPE, USE_LEADING_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, IFMARKER, INITIAL_IFMARKER,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, OFMARKER, INITIAL_OFMARKER,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, IFMARKINT, INITIAL_IFMARKINT,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_MARKINT, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	param = iscsi_set_default_param(pl, OFMARKINT, INITIAL_OFMARKINT,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_MARKINT, USE_INITIAL_ONLY);
-	if (!(param))
+	if (!param)
 		goto out;
 
 	*param_list_ptr = pl;
@@ -549,7 +549,7 @@ int iscsi_copy_param_list(
 	struct iscsi_param_list *param_list = NULL;
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
-	if (!(param_list)) {
+	if (!param_list) {
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_param_list.\n");
 		goto err_out;
@@ -566,7 +566,7 @@ int iscsi_copy_param_list(
 		}
 
 		new_param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
-		if (!(new_param)) {
+		if (!new_param) {
 			pr_err("Unable to allocate memory for"
 				" struct iscsi_param.\n");
 			goto err_out;
@@ -581,7 +581,7 @@ int iscsi_copy_param_list(
 		new_param->type_range = param->type_range;
 
 		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
-		if (!(new_param->name)) {
+		if (!new_param->name) {
 			pr_err("Unable to allocate memory for"
 				" parameter name.\n");
 			goto err_out;
@@ -589,7 +589,7 @@ int iscsi_copy_param_list(
 
 		new_param->value = kzalloc(strlen(param->value) + 1,
 				GFP_KERNEL);
-		if (!(new_param->value)) {
+		if (!new_param->value) {
 			pr_err("Unable to allocate memory for"
 				" parameter value.\n");
 			goto err_out;
@@ -603,7 +603,7 @@ int iscsi_copy_param_list(
 		list_add_tail(&new_param->p_list, &param_list->param_list);
 	}
 
-	if (!(list_empty(&param_list->param_list)))
+	if (!list_empty(&param_list->param_list))
 		*dst_param_list = param_list;
 	else {
 		pr_err("No parameters allocated.\n");
@@ -672,7 +672,7 @@ struct iscsi_param *iscsi_find_param_from_key(
 int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
-	if (!(*value)) {
+	if (!*value) {
 		pr_err("Unable to locate \"=\" seperator for key,"
 				" ignoring request.\n");
 		return -1;
@@ -690,7 +690,7 @@ int iscsi_update_param_value(struct iscsi_param *param, char *value)
 	kfree(param->value);
 
 	param->value = kzalloc(strlen(value) + 1, GFP_KERNEL);
-	if (!(param->value)) {
+	if (!param->value) {
 		pr_err("Unable to allocate memory for value.\n");
 		return -1;
 	}
@@ -717,7 +717,7 @@ static int iscsi_add_notunderstood_response(
 	}
 
 	extra_response = kzalloc(sizeof(struct iscsi_extra_response), GFP_KERNEL);
-	if (!(extra_response)) {
+	if (!extra_response) {
 		pr_err("Unable to allocate memory for"
 			" struct iscsi_extra_response.\n");
 		return -1;
@@ -888,10 +888,10 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	char *tilde_ptr = NULL, *tmp_ptr = NULL;
 	u32 left_val, right_val, local_left_val, local_right_val;
 
-	if ((strcmp(param->name, IFMARKINT)) &&
-			(strcmp(param->name, OFMARKINT))) {
+	if (strcmp(param->name, IFMARKINT) &&
+	    strcmp(param->name, OFMARKINT)) {
 		pr_err("Only parameters \"%s\" or \"%s\" may contain a"
-			" numerical range value.\n", IFMARKINT, OFMARKINT);
+		       " numerical range value.\n", IFMARKINT, OFMARKINT);
 		return -1;
 	}
 
@@ -899,7 +899,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 		return 0;
 
 	tilde_ptr = strchr(value, '~');
-	if (!(tilde_ptr)) {
+	if (!tilde_ptr) {
 		pr_err("Unable to locate numerical range indicator"
 			" \"~\" for \"%s\".\n", param->name);
 		return -1;
@@ -929,7 +929,7 @@ static int iscsi_check_numerical_range_value(struct iscsi_param *param, char *va
 	 * For now,  enforce reasonable defaults for [I,O]FMarkInt.
 	 */
 	tilde_ptr = strchr(param->value, '~');
-	if (!(tilde_ptr)) {
+	if (!tilde_ptr) {
 		pr_err("Unable to locate numerical range indicator"
 			" \"~\" for \"%s\".\n", param->name);
 		return -1;
@@ -1016,13 +1016,13 @@ static char *iscsi_get_value_from_number_range(
 	u32 acceptor_right_value, proposer_right_value;
 
 	tilde_ptr1 = strchr(value, '~');
-	if (!(tilde_ptr1))
+	if (!tilde_ptr1)
 		return NULL;
 	*tilde_ptr1++ = '\0';
 	proposer_right_value = simple_strtoul(tilde_ptr1, &end_ptr, 0);
 
 	tilde_ptr2 = strchr(param->value, '~');
-	if (!(tilde_ptr2))
+	if (!tilde_ptr2)
 		return NULL;
 	*tilde_ptr2++ = '\0';
 	acceptor_right_value = simple_strtoul(tilde_ptr2, &end_ptr, 0);
@@ -1045,7 +1045,7 @@ static char *iscsi_check_valuelist_for_support(
 		if (!proposer_values)
 			return NULL;
 		tmp1 = strchr(proposer_values, ',');
-		if ((tmp1))
+		if (tmp1)
 			*tmp1 = '\0';
 		acceptor_values = param->value;
 		do {
@@ -1055,7 +1055,7 @@ static char *iscsi_check_valuelist_for_support(
 				return NULL;
 			}
 			tmp2 = strchr(acceptor_values, ',');
-			if ((tmp2))
+			if (tmp2)
 				*tmp2 = '\0';
 			if (!acceptor_values || !proposer_values) {
 				if (tmp1)
@@ -1165,14 +1165,14 @@ static int iscsi_check_acceptor_state(struct iscsi_param *param, char *value)
 	} else if (IS_TYPE_NUMBER_RANGE(param)) {
 		negoitated_value = iscsi_get_value_from_number_range(
 					param, value);
-		if (!(negoitated_value))
+		if (!negoitated_value)
 			return -1;
 		if (iscsi_update_param_value(param, negoitated_value) < 0)
 			return -1;
 	} else if (IS_TYPE_VALUE_LIST(param)) {
 		negoitated_value = iscsi_check_valuelist_for_support(
 					param, value);
-		if (!(negoitated_value)) {
+		if (!negoitated_value) {
 			pr_err("Proposer's value list \"%s\" contains"
 				" no valid values from Acceptor's value list"
 				" \"%s\".\n", value, param->value);
@@ -1209,13 +1209,13 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 		}
 
 		tilde_ptr = strchr(value, '~');
-		if ((tilde_ptr)) {
+		if (tilde_ptr) {
 			pr_err("Illegal \"~\" in response for \"%s\".\n",
 					param->name);
 			return -1;
 		}
 		tilde_ptr = strchr(param->value, '~');
-		if (!(tilde_ptr)) {
+		if (!tilde_ptr) {
 			pr_err("Unable to locate numerical range"
 				" indicator \"~\" for \"%s\".\n", param->name);
 			return -1;
@@ -1241,14 +1241,14 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 		char *comma_ptr = NULL, *tmp_ptr = NULL;
 
 		comma_ptr = strchr(value, ',');
-		if ((comma_ptr)) {
+		if (comma_ptr) {
 			pr_err("Illegal \",\" in response for \"%s\".\n",
 					param->name);
 			return -1;
 		}
 
 		tmp_ptr = iscsi_check_valuelist_for_support(param, value);
-		if (!(tmp_ptr))
+		if (!tmp_ptr)
 			return -1;
 	}
 
@@ -1353,7 +1353,7 @@ static struct iscsi_param *__iscsi_check_key(
 	}
 
 	param = iscsi_find_param_from_key(key, param_list);
-	if (!(param))
+	if (!param)
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
@@ -1390,7 +1390,7 @@ static struct iscsi_param *iscsi_check_key(
 	}
 
 	param = iscsi_find_param_from_key(key, param_list);
-	if (!(param))
+	if (!param)
 		return NULL;
 
 	if ((sender & SENDER_INITIATOR) && !IS_SENDER_INITIATOR(param)) {
@@ -1560,7 +1560,7 @@ int iscsi_decode_text_input(
 	char *tmpbuf, *start = NULL, *end = NULL;
 
 	tmpbuf = kzalloc(length + 1, GFP_KERNEL);
-	if (!(tmpbuf)) {
+	if (!tmpbuf) {
 		pr_err("Unable to allocate memory for tmpbuf.\n");
 		return -1;
 	}
@@ -1591,7 +1591,7 @@ int iscsi_decode_text_input(
 		}
 
 		param = iscsi_check_key(key, phase, sender, param_list);
-		if (!(param)) {
+		if (!param) {
 			if (iscsi_add_notunderstood_response(key,
 					value, param_list) < 0) {
 				kfree(tmpbuf);
@@ -1718,11 +1718,11 @@ int iscsi_change_param_value(
 
 	if (!check_key) {
 		param = __iscsi_check_key(keyvalue, sender, param_list);
-		if (!(param))
+		if (!param)
 			return -1;
 	} else {
 		param = iscsi_check_key(keyvalue, 0, sender, param_list);
-		if (!(param))
+		if (!param)
 			return -1;
 
 		param->set_param = 1;
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index f0965a3..f2cb05e 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -136,7 +136,7 @@ redo:
 			continue;
 		}
 		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
-		if (!(array)) {
+		if (!array) {
 			pr_err("Unable to allocate memory"
 				" for random array.\n");
 			return -1;
@@ -156,7 +156,7 @@ redo:
 
 	if (seq_count) {
 		array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
-		if (!(array)) {
+		if (!array) {
 			pr_err("Unable to allocate memory for"
 				" random array.\n");
 			return -1;
@@ -188,7 +188,7 @@ static int iscsit_randomize_seq_lists(
 		return 0;
 
 	array = kzalloc(seq_count * sizeof(u32), GFP_KERNEL);
-	if (!(array)) {
+	if (!array) {
 		pr_err("Unable to allocate memory for random array.\n");
 		return -1;
 	}
@@ -508,7 +508,7 @@ int iscsit_do_build_list(
 
 	if (!conn->sess->sess_ops->DataSequenceInOrder) {
 		seq = kzalloc(seq_count * sizeof(struct iscsi_seq), GFP_ATOMIC);
-		if (!(seq)) {
+		if (!seq) {
 			pr_err("Unable to allocate struct iscsi_seq list\n");
 			return -1;
 		}
@@ -518,7 +518,7 @@ int iscsit_do_build_list(
 
 	if (!conn->sess->sess_ops->DataPDUInOrder) {
 		pdu = kzalloc(pdu_count * sizeof(struct iscsi_pdu), GFP_ATOMIC);
-		if (!(pdu)) {
+		if (!pdu) {
 			pr_err("Unable to allocate struct iscsi_pdu list.\n");
 			kfree(seq);
 			return -1;
diff --git a/drivers/target/iscsi/iscsi_target_tq.c b/drivers/target/iscsi/iscsi_target_tq.c
index 0ecd22f..afcbc89 100644
--- a/drivers/target/iscsi/iscsi_target_tq.c
+++ b/drivers/target/iscsi/iscsi_target_tq.c
@@ -83,7 +83,7 @@ extern int iscsi_allocate_thread_sets(u32 thread_pair_count)
 
 	for (i = 0; i < thread_pair_count; i++) {
 		ts = kzalloc(sizeof(struct iscsi_thread_set), GFP_KERNEL);
-		if (!(ts)) {
+		if (!ts) {
 			pr_err("Unable to allocate memory for"
 					" thread set.\n");
 			return allocated_thread_pair_count;
@@ -185,7 +185,7 @@ static void iscsi_deallocate_extra_thread_sets(void)
 
 	while ((iscsit_global->inactive_ts + 1) > orig_count) {
 		ts = iscsi_get_ts_from_inactive_list();
-		if (!(ts))
+		if (!ts)
 			break;
 
 		spin_lock_bh(&ts->ts_state_lock);
@@ -248,7 +248,7 @@ struct iscsi_thread_set *iscsi_get_thread_set(void)
 	 */
 get_set:
 	ts = iscsi_get_ts_from_inactive_list();
-	if (!(ts)) {
+	if (!ts) {
 		if (allocate_ts == 2)
 			iscsi_allocate_thread_sets(1);
 
@@ -319,11 +319,11 @@ int iscsi_release_thread_set(struct iscsi_conn *conn)
 	spin_lock_bh(&ts->ts_state_lock);
 	ts->status = ISCSI_THREAD_SET_RESET;
 
-	if (!(strncmp(current->comm, ISCSI_RX_THREAD_NAME,
-			strlen(ISCSI_RX_THREAD_NAME))))
+	if (!strncmp(current->comm, ISCSI_RX_THREAD_NAME,
+			strlen(ISCSI_RX_THREAD_NAME)))
 		thread_called = ISCSI_RX_THREAD;
-	else if (!(strncmp(current->comm, ISCSI_TX_THREAD_NAME,
-			strlen(ISCSI_TX_THREAD_NAME))))
+	else if (!strncmp(current->comm, ISCSI_TX_THREAD_NAME,
+			strlen(ISCSI_TX_THREAD_NAME)))
 		thread_called = ISCSI_TX_THREAD;
 
 	if (ts->rx_thread && (thread_called == ISCSI_TX_THREAD) &&
@@ -531,7 +531,7 @@ int iscsi_thread_set_init(void)
 
 	size = BITS_TO_LONGS(iscsit_global->ts_bitmap_count) * sizeof(long);
 	iscsit_global->ts_bitmap = kzalloc(size, GFP_KERNEL);
-	if (!(iscsit_global->ts_bitmap)) {
+	if (!iscsit_global->ts_bitmap) {
 		pr_err("Unable to allocate iscsit_global->ts_bitmap\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 842df2e..a9e7add 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -765,7 +765,7 @@ static void iscsit_remove_cmd_from_response_queue(
 	struct iscsi_queue_req *qr, *qr_tmp;
 
 	spin_lock_bh(&conn->response_queue_lock);
-	if (!(atomic_read(&cmd->response_queue_count))) {
+	if (!atomic_read(&cmd->response_queue_count)) {
 		spin_unlock_bh(&conn->response_queue_lock);
 		return;
 	}
@@ -1749,7 +1749,7 @@ void iscsit_collect_login_stats(
 	struct iscsi_login_stats *ls;
 
 	tiqn = iscsit_snmp_get_tiqn(conn);
-	if (!(tiqn))
+	if (!tiqn)
 		return;
 
 	ls = &tiqn->login_stats;
-- 
1.7.1

