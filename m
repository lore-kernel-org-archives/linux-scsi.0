Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B721C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 10:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352767AbiELKph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 06:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352777AbiELKpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 06:45:31 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346E68FAB;
        Thu, 12 May 2022 03:45:28 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8758E41467;
        Thu, 12 May 2022 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1652352326; x=1654166727; bh=ZWUVB8LjXAyp9FUkWw1swZxA/
        2Ll3CnE3X6aydYTBbg=; b=IB9J+amNUQh6g8903YL75HWJvZZ/O3v31E/ohUYql
        1MkQrh992blOXv4iKrolEGNMQUhGEWSegB0njZnRSapy2CML/BFh+1ixVI7f/y7q
        /hYnd5nx6xUxZqb4r14CFl48heFwFRcwC3yX6PoIDmRTZtiZO0fPF+CMlH4BrKSJ
        3Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vQe0LsOj4iTW; Thu, 12 May 2022 13:45:26 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2E4AD41468;
        Thu, 12 May 2022 13:45:26 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 12 May 2022 13:45:26 +0300
Received: from NB-591.corp.yadro.com (10.178.114.42) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Thu, 12 May 2022 13:45:25 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v4 2/3] scsi: target: iscsi: extract auth functions
Date:   Thu, 12 May 2022 13:45:07 +0300
Message-ID: <20220512104508.8680-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220512104508.8680-1-d.bogdanov@yadro.com>
References: <20220512104508.8680-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create functions that answers simple questions:
whether authentication is required, what credentials, whether
connection is autenticated.

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 140 +++++++++++++++--------
 1 file changed, 92 insertions(+), 48 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f0769708e4fb..89b24d7d031d 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -94,6 +94,31 @@ int extract_param(
 	return 0;
 }
 
+static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsi_conn *conn)
+{
+	struct iscsi_portal_group *tpg;
+	struct iscsi_node_acl *nacl;
+	struct se_node_acl *se_nacl;
+
+	if (conn->sess->sess_ops->SessionType)
+		return &iscsit_global->discovery_acl.node_auth;
+
+	se_nacl = conn->sess->se_sess->se_node_acl;
+	if (!se_nacl) {
+		pr_err("Unable to locate struct se_node_acl for CHAP auth\n");
+		return NULL;
+	}
+
+	if (se_nacl->dynamic_node_acl) {
+		tpg = to_iscsi_tpg(se_nacl->se_tpg);
+		return &tpg->tpg_demo_auth;
+	}
+
+	nacl = to_iscsi_nacl(se_nacl);
+
+	return &nacl->node_auth;
+}
+
 static u32 iscsi_handle_authentication(
 	struct iscsi_conn *conn,
 	char *in_buf,
@@ -102,38 +127,11 @@ static u32 iscsi_handle_authentication(
 	int *out_length,
 	unsigned char *authtype)
 {
-	struct iscsi_session *sess = conn->sess;
 	struct iscsi_node_auth *auth;
-	struct iscsi_node_acl *nacl;
-	struct iscsi_portal_group *tpg;
-	struct se_node_acl *se_nacl;
-
-	if (!sess->sess_ops->SessionType) {
-		/*
-		 * For SessionType=Normal
-		 */
-		se_nacl = conn->sess->se_sess->se_node_acl;
-		if (!se_nacl) {
-			pr_err("Unable to locate struct se_node_acl for"
-					" CHAP auth\n");
-			return -1;
-		}
-
-		if (se_nacl->dynamic_node_acl) {
-			tpg = to_iscsi_tpg(se_nacl->se_tpg);
-
-			auth = &tpg->tpg_demo_auth;
-		} else {
-			nacl = to_iscsi_nacl(se_nacl);
 
-			auth = &nacl->node_auth;
-		}
-	} else {
-		/*
-		 * For SessionType=Discovery
-		 */
-		auth = &iscsit_global->discovery_acl.node_auth;
-	}
+	auth = iscsi_get_node_auth(conn);
+	if (!auth)
+		return -1;
 
 	if (strstr("CHAP", authtype))
 		strcpy(conn->sess->auth_type, "CHAP");
@@ -813,6 +811,37 @@ static int iscsi_target_do_authentication(
 	return 0;
 }
 
+static bool iscsi_conn_auth_required(struct iscsi_conn *conn)
+{
+	struct se_node_acl *se_nacl;
+
+	if (conn->sess->sess_ops->SessionType) {
+		/*
+		 * For SessionType=Discovery
+		 */
+		return conn->tpg->tpg_attrib.authentication;
+	}
+	/*
+	 * For SessionType=Normal
+	 */
+	se_nacl = conn->sess->se_sess->se_node_acl;
+	if (!se_nacl) {
+		pr_debug("Unknown ACL %s is trying to connect\n",
+			 se_nacl->initiatorname);
+		return true;
+	}
+
+	if (se_nacl->dynamic_node_acl) {
+		pr_debug("Dynamic ACL %s is trying to connect\n",
+			 se_nacl->initiatorname);
+		return conn->tpg->tpg_attrib.authentication;
+	}
+
+	pr_debug("Known ACL %s is trying to connect\n",
+		 se_nacl->initiatorname);
+	return conn->tpg->tpg_attrib.authentication;
+}
+
 static int iscsi_target_handle_csg_zero(
 	struct iscsi_conn *conn,
 	struct iscsi_login *login)
@@ -874,22 +903,26 @@ static int iscsi_target_handle_csg_zero(
 		return -1;
 
 	if (!iscsi_check_negotiated_keys(conn->param_list)) {
-		if (conn->tpg->tpg_attrib.authentication &&
-		    !strncmp(param->value, NONE, 4)) {
-			pr_err("Initiator sent AuthMethod=None but"
-				" Target is enforcing iSCSI Authentication,"
-					" login failed.\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
-					ISCSI_LOGIN_STATUS_AUTH_FAILED);
-			return -1;
-		}
+		bool auth_required = iscsi_conn_auth_required(conn);
+
+		if (auth_required) {
+			if (!strncmp(param->value, NONE, 4)) {
+				pr_err("Initiator sent AuthMethod=None but"
+				       " Target is enforcing iSCSI Authentication,"
+				       " login failed.\n");
+				iscsit_tx_login_rsp(conn,
+						ISCSI_STATUS_CLS_INITIATOR_ERR,
+						ISCSI_LOGIN_STATUS_AUTH_FAILED);
+				return -1;
+			}
 
-		if (conn->tpg->tpg_attrib.authentication &&
-		    !login->auth_complete)
-			return 0;
+			if (!login->auth_complete)
+				return 0;
 
-		if (strncmp(param->value, NONE, 4) && !login->auth_complete)
-			return 0;
+			if (strncmp(param->value, NONE, 4) &&
+			    !login->auth_complete)
+				return 0;
+		}
 
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
@@ -904,6 +937,18 @@ static int iscsi_target_handle_csg_zero(
 	return iscsi_target_do_authentication(conn, login);
 }
 
+static bool iscsi_conn_authenticated(struct iscsi_conn *conn,
+				     struct iscsi_login *login)
+{
+	if (!iscsi_conn_auth_required(conn))
+		return true;
+
+	if (login->auth_complete)
+		return true;
+
+	return false;
+}
+
 static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_login *login)
 {
 	int ret;
@@ -947,11 +992,10 @@ static int iscsi_target_handle_csg_one(struct iscsi_conn *conn, struct iscsi_log
 		return -1;
 	}
 
-	if (!login->auth_complete &&
-	     conn->tpg->tpg_attrib.authentication) {
+	if (!iscsi_conn_authenticated(conn, login)) {
 		pr_err("Initiator is requesting CSG: 1, has not been"
-			 " successfully authenticated, and the Target is"
-			" enforcing iSCSI Authentication, login failed.\n");
+		       " successfully authenticated, and the Target is"
+		       " enforcing iSCSI Authentication, login failed.\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
 				ISCSI_LOGIN_STATUS_AUTH_FAILED);
 		return -1;
-- 
2.25.1

