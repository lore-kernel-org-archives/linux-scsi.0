Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE4C4321E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 09:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiD1JuS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 05:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347569AbiD1JdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 05:33:08 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2078.outbound.protection.outlook.com [40.107.95.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB947CDF4;
        Thu, 28 Apr 2022 02:29:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSQvMR0lenDVaYr/e/49AFO5QaUXyRIZs6GRGzEbc1hiZuk/mCYjiNorJf1TDRoAmoE8ftJ8J4C3mXo2hBs6gkGkUYGKKVnnXKomV4dpalVmn8IKcrMLJcqHYhcCtRlLXV+LsRK6aq9gk/Bdr9Zj3b9x/Uwv5vEMDYw/2+tr52RdLqoD4TfLOtOPxwpa50hvLJZFMl8TRjpLlImrByvGyTadxAfOLUI1VV/jBaQLrXnIMici2e7w9FEFm3y0iBo+oJeEunNDhXGLHVOQLNICXnXLmsier1c0ae4rqvFVKiE6vZDZSqS0e/aEO/gV28GI4J9V8TkmlL3Bxd7u8MNaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1mvra6IdJIjqeRbSvwrTKWCdKc97oaEptahKS73CSU=;
 b=FCPt8uirZkCy00ZgWwFBq0vS4u2LZIh0EY5tV8MDHAfmmNYzEa4/ed8yQGrzE4Geqfhm3UHYxQ6kOwD3drxg7+e8H4RzAlFkjWlksNUQlXHxswozfwWmT8faHF1PlfDTaxPoZWWH3wC5Q2sCgnMCLUGxP5XDXIB/5XpHR0zYnNfgn0vIADAwkobKUr9sia81TxQcVjpQaIUHdCgLM8o87Z2EzHPYIdzNj7tN6sBCN5cGtgDlK8+ZtqAs8nr8pf7fsmQmDxuUopJ5C4qiEWMDmGwFSUxFHQ7ZhgU+q78fPBbzQN8tRlB5CX+Z7XusMnGxIdYV/k5lg1O8uYMtVPbNEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lst.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1mvra6IdJIjqeRbSvwrTKWCdKc97oaEptahKS73CSU=;
 b=Biv32Io98TGe2Kf8hzdd3evCvsZ2AquI/cf6WhsGTRUaFZg+VhP3UkJLdl2npmmfHoCb0hQA33et+q0YPUo52rCirOZ1WV9fhS/LSiCwP8Q30KilOZ/FbVkD5NJozh7AHwlfXyvO79dYhwnBH8jxz9ZyV6kM21Zry51DQRbwRS+rg9ApiuhmOoq/ArMIVoSY3C00+yfHtx06BPVF0X7U6ijmgtYSA6p9JHsdyD4X2RaD9k18wYSr4tEwH5ZJIm98UYtQIBe1ZZDz/+wOnW9rUgBCGMq+Pg7ywnWnQK4REkZMx2xpYfKMFwsARBAdCoSvpuCJXPtugZn6Jd7NhOfd2g==
Received: from BN8PR04CA0062.namprd04.prod.outlook.com (2603:10b6:408:d4::36)
 by MN2PR12MB3136.namprd12.prod.outlook.com (2603:10b6:208:d1::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 09:29:49 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::d1) by BN8PR04CA0062.outlook.office365.com
 (2603:10b6:408:d4::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Thu, 28 Apr 2022 09:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 09:29:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Apr 2022 09:29:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 28 Apr 2022 02:29:47 -0700
Received: from r-arch-stor04.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Thu, 28 Apr 2022 02:29:45 -0700
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <martin.petersen@oracle.com>
CC:     <hch@lst.de>, <sagi@grimberg.me>, <michael.christie@oracle.com>,
        "Max Gurtovoy" <mgurtovoy@nvidia.com>
Subject: [PATCH 3/3] target/iscsi: rename iscsi_session to iscsit_session
Date:   Thu, 28 Apr 2022 12:29:39 +0300
Message-ID: <20220428092939.36768-3-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20220428092939.36768-1-mgurtovoy@nvidia.com>
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24532a59-26fc-4a30-3b98-08da28f9a41a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3136:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB313619582635C602ED539950DEFD9@MN2PR12MB3136.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ms0BVJDtx7VugCURcMtQmodH7+2wT+ZQl9QnQaV3NKgSIHfuRx33AlLpOtrB8FjAJAqjKJxAxrs9LSzhJo/qtLKHqWNs6FEXb/YDwjRVxhAWarh26I44RhnmhW+NwLfyMEEMDf0ywXYRzIJBOKKp7dFcCJwhmE6WM76cApDcgiq8w0tsK74VLX38Eht0xnCjDede0O5usyfjjBpwlTHjDNUeNdQZ2LTrv8RAa55HbGZTvj43aTqwHlGCMRj9GPCXpbiqfU7ubWYbSmhLmwyzieu1Vuvmm/wr5f7WFdD7EmRrh1zX+VEKrpxR5l3HGAKzA5CG8xMibxgzv5y7Y+cq49yzZFeYpiikXCo1Ph1D8c1rqpA887PbfeUdUbcqN7ldE6qdUHuYDt2cv8p5dPufMM0ebCV0c4OLgiDEnJMQAKZ3zwMOV85QlMU1KpSPZlmm+jqJU0XhAOqPeODIxJhUjTix7aF1UlB2HuhBTkNS9dQiJoQ72Bnthevd5vQORYI7LVYBDxfZPWZwZUUiwfDOVmICWQGHY0Uzv5wVg/+lnDbkqV2Xan8qaJ3jJC1slENGwrtud9F8Fzc10a79+FiHgku9k/RtWaCiz0mwi3BXckv/vxT+2oQ5ZGN/KxTVXheqUWKE9SqC1w4Qxpvj8bcPshmgBawWgqYm91aD5+zpTk9gV5DPLPoc3gEkR3zHswoOBOWK7wRPtikHHMziSkROjQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(1076003)(426003)(336012)(186003)(47076005)(5660300002)(54906003)(82310400005)(36860700001)(36756003)(6666004)(26005)(19627235002)(70206006)(107886003)(316002)(8676002)(30864003)(356005)(4326008)(8936002)(83380400001)(508600001)(2906002)(40460700003)(110136005)(86362001)(81166007)(70586007)(36900700001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 09:29:48.8528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24532a59-26fc-4a30-3b98-08da28f9a41a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The structure iscsi_session naming is used by the iscsi initiator
driver. Rename the target session to iscsit_session to have more
readable code.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/target/iscsi/iscsi_target.c           | 28 +++++++++----------
 drivers/target/iscsi/iscsi_target.h           |  8 +++---
 drivers/target/iscsi/iscsi_target_configfs.c  | 12 ++++----
 drivers/target/iscsi/iscsi_target_device.c    |  4 +--
 drivers/target/iscsi/iscsi_target_device.h    |  6 ++--
 drivers/target/iscsi/iscsi_target_erl0.c      | 10 +++----
 drivers/target/iscsi/iscsi_target_erl0.h      |  8 +++---
 drivers/target/iscsi/iscsi_target_erl1.c      | 20 ++++++-------
 drivers/target/iscsi/iscsi_target_erl1.h      | 10 +++----
 drivers/target/iscsi/iscsi_target_erl2.c      | 18 ++++++------
 drivers/target/iscsi/iscsi_target_erl2.h      | 10 +++----
 drivers/target/iscsi/iscsi_target_login.c     | 20 ++++++-------
 drivers/target/iscsi/iscsi_target_nego.c      |  6 ++--
 .../target/iscsi/iscsi_target_nodeattrib.c    |  2 +-
 .../target/iscsi/iscsi_target_seq_pdu_list.c  |  2 +-
 drivers/target/iscsi/iscsi_target_stat.c      | 16 +++++------
 drivers/target/iscsi/iscsi_target_tmr.c       |  6 ++--
 drivers/target/iscsi/iscsi_target_tpg.c       |  2 +-
 drivers/target/iscsi/iscsi_target_tpg.h       |  4 +--
 drivers/target/iscsi/iscsi_target_util.c      | 28 +++++++++----------
 drivers/target/iscsi/iscsi_target_util.h      | 18 ++++++------
 include/target/iscsi/iscsi_target_core.h      | 10 +++----
 include/target/iscsi/iscsi_transport.h        |  2 +-
 23 files changed, 125 insertions(+), 125 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c4f94b76061..d425cc386d87 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2350,7 +2350,7 @@ iscsit_handle_text_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 {
 	struct iscsit_conn *conn_p;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	pr_debug("Received logout request CLOSESESSION on CID: %hu"
 		" for SID: %u.\n", conn->cid, conn->sess->sid);
@@ -2380,7 +2380,7 @@ int iscsit_logout_closesession(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 {
 	struct iscsit_conn *l_conn;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	pr_debug("Received logout request CLOSECONNECTION for CID:"
 		" %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
@@ -2427,7 +2427,7 @@ int iscsit_logout_closeconnection(struct iscsit_cmd *cmd, struct iscsit_conn *co
 
 int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *cmd, struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	pr_debug("Received explicit REMOVECONNFORRECOVERY logout for"
 		" CID: %hu on CID: %hu.\n", cmd->logout_cid, conn->cid);
@@ -2901,7 +2901,7 @@ iscsit_build_logout_rsp(struct iscsit_cmd *cmd, struct iscsit_conn *conn,
 {
 	struct iscsit_conn *logout_conn = NULL;
 	struct iscsi_conn_recovery *cr = NULL;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	/*
 	 * The actual shutting down of Sessions and/or Connections
 	 * for CLOSESESSION and CLOSECONNECTION Logout Requests
@@ -4145,7 +4145,7 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 {
 	LIST_HEAD(tmp_list);
 	struct iscsit_cmd *cmd = NULL, *cmd_tmp = NULL;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	/*
 	 * We expect this function to only ever be called from either RX or TX
 	 * thread context via iscsit_close_connection() once the other context
@@ -4201,7 +4201,7 @@ int iscsit_close_connection(
 	struct iscsit_conn *conn)
 {
 	int conn_logout = (conn->conn_state == TARG_CONN_STATE_IN_LOGOUT);
-	struct iscsi_session	*sess = conn->sess;
+	struct iscsit_session	*sess = conn->sess;
 
 	pr_debug("Closing iSCSI connection CID %hu on SID:"
 		" %u\n", conn->cid, sess->sid);
@@ -4438,7 +4438,7 @@ int iscsit_close_connection(
  * If the iSCSI Session for the iSCSI Initiator Node exists,
  * forcefully shutdown the iSCSI NEXUS.
  */
-int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
+int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
@@ -4508,7 +4508,7 @@ int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
 static void iscsit_logout_post_handler_closesession(
 	struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	int sleep = 1;
 	/*
 	 * Traditional iscsi/tcp will invoke this logic from TX thread
@@ -4557,7 +4557,7 @@ static void iscsit_logout_post_handler_diffcid(
 	u16 cid)
 {
 	struct iscsit_conn *l_conn;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	bool conn_found = false;
 
 	if (!sess)
@@ -4649,7 +4649,7 @@ int iscsit_logout_post_handler(
 }
 EXPORT_SYMBOL(iscsit_logout_post_handler);
 
-void iscsit_fail_session(struct iscsi_session *sess)
+void iscsit_fail_session(struct iscsit_session *sess)
 {
 	struct iscsit_conn *conn;
 
@@ -4665,7 +4665,7 @@ void iscsit_fail_session(struct iscsi_session *sess)
 }
 
 void iscsit_stop_session(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	int session_sleep,
 	int connection_sleep)
 {
@@ -4712,7 +4712,7 @@ void iscsit_stop_session(
 
 int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 {
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct se_session *se_sess, *se_sess_tmp;
 	LIST_HEAD(free_list);
@@ -4726,7 +4726,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
 			sess_list) {
-		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
+		sess = (struct iscsit_session *)se_sess->fabric_sess_ptr;
 
 		spin_lock(&sess->conn_lock);
 		if (atomic_read(&sess->session_fall_back_to_erl0) ||
@@ -4747,7 +4747,7 @@ int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *tpg, int force)
 	spin_unlock_bh(&se_tpg->session_lock);
 
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
-		sess = (struct iscsi_session *)se_sess->fabric_sess_ptr;
+		sess = (struct iscsit_session *)se_sess->fabric_sess_ptr;
 
 		list_del_init(&se_sess->sess_list);
 		iscsit_stop_session(sess, 1, 1);
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 314e29fcaa5a..0c997a08adec 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -9,7 +9,7 @@ struct iscsit_cmd;
 struct iscsit_conn;
 struct iscsi_np;
 struct iscsi_portal_group;
-struct iscsi_session;
+struct iscsit_session;
 struct iscsi_tpg_np;
 struct kref;
 struct sockaddr_storage;
@@ -41,9 +41,9 @@ extern void iscsit_thread_get_cpumask(struct iscsit_conn *);
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsit_conn *);
-extern int iscsit_close_session(struct iscsi_session *, bool can_sleep);
-extern void iscsit_fail_session(struct iscsi_session *);
-extern void iscsit_stop_session(struct iscsi_session *, int, int);
+extern int iscsit_close_session(struct iscsit_session *, bool can_sleep);
+extern void iscsit_fail_session(struct iscsit_session *);
+extern void iscsit_stop_session(struct iscsit_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
 
 extern struct iscsit_global *iscsit_global;
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index aadc855f67fa..72f5ff959636 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -443,7 +443,7 @@ static ssize_t iscsi_nacl_param_##name##_show(struct config_item *item,	\
 		char *page)						\
 {									\
 	struct se_node_acl *se_nacl = param_to_nacl(item);		\
-	struct iscsi_session *sess;					\
+	struct iscsit_session *sess;					\
 	struct se_session *se_sess;					\
 	ssize_t rb;							\
 									\
@@ -498,7 +498,7 @@ static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
 static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 {
 	struct se_node_acl *se_nacl = acl_to_nacl(item);
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct iscsit_conn *conn;
 	struct se_session *se_sess;
 	ssize_t rb = 0;
@@ -1347,7 +1347,7 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 
 static u32 lio_sess_get_index(struct se_session *se_sess)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	struct iscsit_session *sess = se_sess->fabric_sess_ptr;
 
 	return sess->session_index;
 }
@@ -1357,7 +1357,7 @@ static u32 lio_sess_get_initiator_sid(
 	unsigned char *buf,
 	u32 size)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	struct iscsit_session *sess = se_sess->fabric_sess_ptr;
 	/*
 	 * iSCSI Initiator Session Identifier from RFC-3720.
 	 */
@@ -1468,11 +1468,11 @@ static int lio_tpg_check_prot_fabric_only(
 
 /*
  * This function calls iscsit_inc_session_usage_count() on the
- * struct iscsi_session in question.
+ * struct iscsit_session in question.
  */
 static void lio_tpg_close_session(struct se_session *se_sess)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	struct iscsit_session *sess = se_sess->fabric_sess_ptr;
 	struct se_portal_group *se_tpg = &sess->tpg->tpg_se_tpg;
 
 	spin_lock_bh(&se_tpg->session_lock);
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index d57041b860bd..b565ce3b2677 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -17,7 +17,7 @@
 #include "iscsi_target_tpg.h"
 #include "iscsi_target_util.h"
 
-void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
+void iscsit_determine_maxcmdsn(struct iscsit_session *sess)
 {
 	struct se_node_acl *se_nacl;
 
@@ -42,7 +42,7 @@ void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
 	atomic_add(se_nacl->queue_depth - 1, &sess->max_cmd_sn);
 }
 
-void iscsit_increment_maxcmdsn(struct iscsit_cmd *cmd, struct iscsi_session *sess)
+void iscsit_increment_maxcmdsn(struct iscsit_cmd *cmd, struct iscsit_session *sess)
 {
 	u32 max_cmd_sn;
 
diff --git a/drivers/target/iscsi/iscsi_target_device.h b/drivers/target/iscsi/iscsi_target_device.h
index b6a463847720..366340120558 100644
--- a/drivers/target/iscsi/iscsi_target_device.h
+++ b/drivers/target/iscsi/iscsi_target_device.h
@@ -3,9 +3,9 @@
 #define ISCSI_TARGET_DEVICE_H
 
 struct iscsit_cmd;
-struct iscsi_session;
+struct iscsit_session;
 
-extern void iscsit_determine_maxcmdsn(struct iscsi_session *);
-extern void iscsit_increment_maxcmdsn(struct iscsit_cmd *, struct iscsi_session *);
+extern void iscsit_determine_maxcmdsn(struct iscsit_session *);
+extern void iscsit_increment_maxcmdsn(struct iscsit_cmd *, struct iscsit_session *);
 
 #endif /* ISCSI_TARGET_DEVICE_H */
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index e21f6c6dfd99..07e9cf431edd 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -743,7 +743,7 @@ int iscsit_check_post_dataout(
 
 void iscsit_handle_time2retain_timeout(struct timer_list *t)
 {
-	struct iscsi_session *sess = from_timer(sess, t, time2retain_timer);
+	struct iscsit_session *sess = from_timer(sess, t, time2retain_timer);
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
@@ -768,7 +768,7 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 	iscsit_close_session(sess, false);
 }
 
-void iscsit_start_time2retain_handler(struct iscsi_session *sess)
+void iscsit_start_time2retain_handler(struct iscsit_session *sess)
 {
 	int tpg_active;
 	/*
@@ -794,7 +794,7 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 		  jiffies + sess->sess_ops->DefaultTime2Retain * HZ);
 }
 
-int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
+int iscsit_stop_time2retain_timer(struct iscsit_session *sess)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
@@ -880,7 +880,7 @@ void iscsit_cause_connection_reinstatement(struct iscsit_conn *conn, int sleep)
 }
 EXPORT_SYMBOL(iscsit_cause_connection_reinstatement);
 
-void iscsit_fall_back_to_erl0(struct iscsi_session *sess)
+void iscsit_fall_back_to_erl0(struct iscsit_session *sess)
 {
 	pr_debug("Falling back to ErrorRecoveryLevel=0 for SID:"
 			" %u\n", sess->sid);
@@ -890,7 +890,7 @@ void iscsit_fall_back_to_erl0(struct iscsi_session *sess)
 
 static void iscsit_handle_connection_cleanup(struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	if ((sess->sess_ops->ErrorRecoveryLevel == 2) &&
 	    !atomic_read(&sess->session_reinstatement) &&
diff --git a/drivers/target/iscsi/iscsi_target_erl0.h b/drivers/target/iscsi/iscsi_target_erl0.h
index 9d34c1cd6b57..2a877d13977d 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.h
+++ b/drivers/target/iscsi/iscsi_target_erl0.h
@@ -6,17 +6,17 @@
 
 struct iscsit_cmd;
 struct iscsit_conn;
-struct iscsi_session;
+struct iscsit_session;
 
 extern void iscsit_set_dataout_sequence_values(struct iscsit_cmd *);
 extern int iscsit_check_pre_dataout(struct iscsit_cmd *, unsigned char *);
 extern int iscsit_check_post_dataout(struct iscsit_cmd *, unsigned char *, u8);
-extern void iscsit_start_time2retain_handler(struct iscsi_session *);
+extern void iscsit_start_time2retain_handler(struct iscsit_session *);
 extern void iscsit_handle_time2retain_timeout(struct timer_list *t);
-extern int iscsit_stop_time2retain_timer(struct iscsi_session *);
+extern int iscsit_stop_time2retain_timer(struct iscsit_session *);
 extern void iscsit_connection_reinstatement_rcfr(struct iscsit_conn *);
 extern void iscsit_cause_connection_reinstatement(struct iscsit_conn *, int);
-extern void iscsit_fall_back_to_erl0(struct iscsi_session *);
+extern void iscsit_fall_back_to_erl0(struct iscsit_session *);
 extern void iscsit_take_action_for_connection_exit(struct iscsit_conn *, bool *);
 
 #endif   /*** ISCSI_TARGET_ERL0_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 2c3ac5986b45..f460a66c0e7c 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -767,7 +767,7 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 }
 
 static int iscsit_attach_ooo_cmdsn(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsi_ooo_cmdsn *ooo_cmdsn)
 {
 	struct iscsi_ooo_cmdsn *ooo_tail, *ooo_tmp;
@@ -815,10 +815,10 @@ static int iscsit_attach_ooo_cmdsn(
 
 /*
  *	Removes an struct iscsi_ooo_cmdsn from a session's list,
- *	called with struct iscsi_session->cmdsn_mutex held.
+ *	called with struct iscsit_session->cmdsn_mutex held.
  */
 void iscsit_remove_ooo_cmdsn(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsi_ooo_cmdsn *ooo_cmdsn)
 {
 	list_del(&ooo_cmdsn->ooo_list);
@@ -828,7 +828,7 @@ void iscsit_remove_ooo_cmdsn(
 void iscsit_clear_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 {
 	struct iscsi_ooo_cmdsn *ooo_cmdsn;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	mutex_lock(&sess->cmdsn_mutex);
 	list_for_each_entry(ooo_cmdsn, &sess->sess_ooo_cmdsn_list, ooo_list) {
@@ -840,7 +840,7 @@ void iscsit_clear_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 	mutex_unlock(&sess->cmdsn_mutex);
 }
 
-int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
+int iscsit_execute_ooo_cmdsns(struct iscsit_session *sess)
 {
 	int ooo_count = 0;
 	struct iscsit_cmd *cmd = NULL;
@@ -994,7 +994,7 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 	return 0;
 }
 
-void iscsit_free_all_ooo_cmdsns(struct iscsi_session *sess)
+void iscsit_free_all_ooo_cmdsns(struct iscsit_session *sess)
 {
 	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
 
@@ -1009,7 +1009,7 @@ void iscsit_free_all_ooo_cmdsns(struct iscsi_session *sess)
 }
 
 int iscsit_handle_ooo_cmdsn(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsit_cmd *cmd,
 	u32 cmdsn)
 {
@@ -1097,7 +1097,7 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 	u32 r2t_length = 0, r2t_offset = 0;
 	struct iscsit_cmd *cmd = from_timer(cmd, t, dataout_timer);
 	struct iscsit_conn *conn = cmd->conn;
-	struct iscsi_session *sess = NULL;
+	struct iscsit_session *sess = NULL;
 	struct iscsi_node_attrib *na;
 
 	iscsit_inc_conn_usage_count(conn);
@@ -1182,7 +1182,7 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 void iscsit_mod_dataout_timer(struct iscsit_cmd *cmd)
 {
 	struct iscsit_conn *conn = cmd->conn;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&cmd->dataout_timeout_lock);
@@ -1202,7 +1202,7 @@ void iscsit_start_dataout_timer(
 	struct iscsit_cmd *cmd,
 	struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	lockdep_assert_held(&cmd->dataout_timeout_lock);
diff --git a/drivers/target/iscsi/iscsi_target_erl1.h b/drivers/target/iscsi/iscsi_target_erl1.h
index b1e60fb26d5f..12472eefe559 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.h
+++ b/drivers/target/iscsi/iscsi_target_erl1.h
@@ -10,7 +10,7 @@ struct iscsit_conn;
 struct iscsi_datain_req;
 struct iscsi_ooo_cmdsn;
 struct iscsi_pdu;
-struct iscsi_session;
+struct iscsit_session;
 
 extern int iscsit_dump_data_payload(struct iscsit_conn *, u32, int);
 extern int iscsit_create_recovery_datain_values_datasequenceinorder_yes(
@@ -25,11 +25,11 @@ extern int iscsit_handle_data_ack(struct iscsit_conn *, u32, u32, u32);
 extern int iscsit_dataout_datapduinorder_no_fbit(struct iscsit_cmd *, struct iscsi_pdu *);
 extern int iscsit_recover_dataout_sequence(struct iscsit_cmd *, u32, u32);
 extern void iscsit_clear_ooo_cmdsns_for_conn(struct iscsit_conn *);
-extern void iscsit_free_all_ooo_cmdsns(struct iscsi_session *);
-extern int iscsit_execute_ooo_cmdsns(struct iscsi_session *);
+extern void iscsit_free_all_ooo_cmdsns(struct iscsit_session *);
+extern int iscsit_execute_ooo_cmdsns(struct iscsit_session *);
 extern int iscsit_execute_cmd(struct iscsit_cmd *, int);
-extern int iscsit_handle_ooo_cmdsn(struct iscsi_session *, struct iscsit_cmd *, u32);
-extern void iscsit_remove_ooo_cmdsn(struct iscsi_session *, struct iscsi_ooo_cmdsn *);
+extern int iscsit_handle_ooo_cmdsn(struct iscsit_session *, struct iscsit_cmd *, u32);
+extern void iscsit_remove_ooo_cmdsn(struct iscsit_session *, struct iscsi_ooo_cmdsn *);
 extern void iscsit_handle_dataout_timeout(struct timer_list *t);
 extern void iscsit_mod_dataout_timer(struct iscsit_cmd *);
 extern void iscsit_start_dataout_timer(struct iscsit_cmd *, struct iscsit_conn *);
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 1dbdf7937e29..18e88d2ea5fd 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -74,7 +74,7 @@ void iscsit_create_conn_recovery_dataout_values(
 }
 
 static int iscsit_attach_active_connection_recovery_entry(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsi_conn_recovery *cr)
 {
 	spin_lock(&sess->cr_a_lock);
@@ -85,7 +85,7 @@ static int iscsit_attach_active_connection_recovery_entry(
 }
 
 static int iscsit_attach_inactive_connection_recovery_entry(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsi_conn_recovery *cr)
 {
 	spin_lock(&sess->cr_i_lock);
@@ -100,7 +100,7 @@ static int iscsit_attach_inactive_connection_recovery_entry(
 }
 
 struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	u16 cid)
 {
 	struct iscsi_conn_recovery *cr;
@@ -117,7 +117,7 @@ struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
 	return NULL;
 }
 
-void iscsit_free_connection_recovery_entries(struct iscsi_session *sess)
+void iscsit_free_connection_recovery_entries(struct iscsit_session *sess)
 {
 	struct iscsit_cmd *cmd, *cmd_tmp;
 	struct iscsi_conn_recovery *cr, *cr_tmp;
@@ -169,7 +169,7 @@ void iscsit_free_connection_recovery_entries(struct iscsi_session *sess)
 
 int iscsit_remove_active_connection_recovery_entry(
 	struct iscsi_conn_recovery *cr,
-	struct iscsi_session *sess)
+	struct iscsit_session *sess)
 {
 	spin_lock(&sess->cr_a_lock);
 	list_del(&cr->cr_list);
@@ -186,7 +186,7 @@ int iscsit_remove_active_connection_recovery_entry(
 
 static void iscsit_remove_inactive_connection_recovery_entry(
 	struct iscsi_conn_recovery *cr,
-	struct iscsi_session *sess)
+	struct iscsit_session *sess)
 {
 	spin_lock(&sess->cr_i_lock);
 	list_del(&cr->cr_list);
@@ -198,7 +198,7 @@ static void iscsit_remove_inactive_connection_recovery_entry(
  */
 int iscsit_remove_cmd_from_connection_recovery(
 	struct iscsit_cmd *cmd,
-	struct iscsi_session *sess)
+	struct iscsit_session *sess)
 {
 	struct iscsi_conn_recovery *cr;
 
@@ -219,7 +219,7 @@ void iscsit_discard_cr_cmds_by_expstatsn(
 {
 	u32 dropped_count = 0;
 	struct iscsit_cmd *cmd, *cmd_tmp;
-	struct iscsi_session *sess = cr->sess;
+	struct iscsit_session *sess = cr->sess;
 
 	spin_lock(&cr->conn_recovery_cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp,
@@ -268,7 +268,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *conn)
 	u32 dropped_count = 0;
 	struct iscsit_cmd *cmd, *cmd_tmp;
 	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	mutex_lock(&sess->cmdsn_mutex);
 	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
diff --git a/drivers/target/iscsi/iscsi_target_erl2.h b/drivers/target/iscsi/iscsi_target_erl2.h
index 5b311ed9ebc4..6655e4bcf893 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.h
+++ b/drivers/target/iscsi/iscsi_target_erl2.h
@@ -7,17 +7,17 @@
 struct iscsit_cmd;
 struct iscsit_conn;
 struct iscsi_conn_recovery;
-struct iscsi_session;
+struct iscsit_session;
 
 extern void iscsit_create_conn_recovery_datain_values(struct iscsit_cmd *, __be32);
 extern void iscsit_create_conn_recovery_dataout_values(struct iscsit_cmd *);
 extern struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
-			struct iscsi_session *, u16);
-extern void iscsit_free_connection_recovery_entries(struct iscsi_session *);
+			struct iscsit_session *, u16);
+extern void iscsit_free_connection_recovery_entries(struct iscsit_session *);
 extern int iscsit_remove_active_connection_recovery_entry(
-			struct iscsi_conn_recovery *, struct iscsi_session *);
+			struct iscsi_conn_recovery *, struct iscsit_session *);
 extern int iscsit_remove_cmd_from_connection_recovery(struct iscsit_cmd *,
-			struct iscsi_session *);
+			struct iscsit_session *);
 extern void iscsit_discard_cr_cmds_by_expstatsn(struct iscsi_conn_recovery *, u32);
 extern int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsit_conn *);
 extern int iscsit_prepare_cmds_for_reallegiance(struct iscsit_conn *);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index a303ba7d20c3..6b94eecc4790 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -133,7 +133,7 @@ int iscsi_check_for_session_reinstatement(struct iscsit_conn *conn)
 	int sessiontype;
 	struct iscsi_param *initiatorname_param = NULL, *sessiontype_param = NULL;
 	struct iscsi_portal_group *tpg = conn->tpg;
-	struct iscsi_session *sess = NULL, *sess_p = NULL;
+	struct iscsit_session *sess = NULL, *sess_p = NULL;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct se_session *se_sess, *se_sess_tmp;
 
@@ -204,7 +204,7 @@ int iscsi_check_for_session_reinstatement(struct iscsit_conn *conn)
 }
 
 static int iscsi_login_set_conn_values(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsit_conn *conn,
 	__be16 cid)
 {
@@ -256,11 +256,11 @@ static int iscsi_login_zero_tsih_s1(
 	struct iscsit_conn *conn,
 	unsigned char *buf)
 {
-	struct iscsi_session *sess = NULL;
+	struct iscsit_session *sess = NULL;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
 	int ret;
 
-	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
+	sess = kzalloc(sizeof(struct iscsit_session), GFP_KERNEL);
 	if (!sess) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -340,7 +340,7 @@ static int iscsi_login_zero_tsih_s2(
 	struct iscsit_conn *conn)
 {
 	struct iscsi_node_attrib *na;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	bool iser = false;
 
 	sess->tpg = conn->tpg;
@@ -474,7 +474,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	unsigned char *buf)
 {
 	struct iscsi_portal_group *tpg = conn->tpg;
-	struct iscsi_session *sess = NULL, *sess_p = NULL;
+	struct iscsit_session *sess = NULL, *sess_p = NULL;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 	struct se_session *se_sess, *se_sess_tmp;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
@@ -484,7 +484,7 @@ static int iscsi_login_non_zero_tsih_s2(
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
 			sess_list) {
 
-		sess_p = (struct iscsi_session *)se_sess->fabric_sess_ptr;
+		sess_p = (struct iscsit_session *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
 		    atomic_read(&sess_p->session_close) ||
@@ -552,7 +552,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 {
 	struct iscsit_conn *conn_ptr = NULL;
 	struct iscsi_conn_recovery *cr = NULL;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	/*
 	 * By following item 5 in the login table,  if we have found
@@ -614,7 +614,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 
 static void iscsi_post_login_start_timers(struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	/*
 	 * FIXME: Unsolicited NopIN support for ISER
 	 */
@@ -677,7 +677,7 @@ void iscsi_post_login_handler(
 	u8 zero_tsih)
 {
 	int stop_timer = 0;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct se_session *se_sess = sess->se_sess;
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b65c73fc6073..b34ac9ecac31 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -102,7 +102,7 @@ static u32 iscsi_handle_authentication(
 	int *out_length,
 	unsigned char *authtype)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_auth *auth;
 	struct iscsi_node_acl *iscsi_nacl;
 	struct iscsi_portal_group *iscsi_tpg;
@@ -1059,7 +1059,7 @@ int iscsi_target_locate_portal(
 {
 	char *i_buf = NULL, *s_buf = NULL, *t_buf = NULL;
 	char *tmpbuf, *start = NULL, *end = NULL, *key, *value;
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_tiqn *tiqn;
 	struct iscsi_tpg_np *tpg_np = NULL;
 	struct iscsi_login_req *login_req;
@@ -1232,7 +1232,7 @@ int iscsi_target_locate_portal(
 
 	/*
 	 * conn->sess->node_acl will be set when the referenced
-	 * struct iscsi_session is located from received ISID+TSIH in
+	 * struct iscsit_session is located from received ISID+TSIH in
 	 * iscsi_login_non_zero_tsih_s2().
 	 */
 	if (!login->leading_connection) {
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index 36671af6332f..874cb33c9be0 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -96,7 +96,7 @@ int iscsit_na_nopin_timeout(
 	u32 nopin_timeout)
 {
 	struct iscsi_node_attrib *a = &acl->node_attrib;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct iscsit_conn *conn;
 	struct se_node_acl *se_nacl = &a->nacl->se_node_acl;
 	struct se_session *se_sess;
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index 326efd762db0..66de2b8de463 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -493,7 +493,7 @@ int iscsit_build_pdu_and_seq_lists(
 	struct iscsi_pdu *pdu = NULL;
 	struct iscsi_seq *seq = NULL;
 
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na;
 
 	/*
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index cce3a827059e..367c6468b8e1 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -599,7 +599,7 @@ static ssize_t iscsi_stat_sess_node_show(struct config_item *item, char *page)
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -620,7 +620,7 @@ static ssize_t iscsi_stat_sess_indx_show(struct config_item *item, char *page)
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -642,7 +642,7 @@ static ssize_t iscsi_stat_sess_cmd_pdus_show(struct config_item *item,
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -664,7 +664,7 @@ static ssize_t iscsi_stat_sess_rsp_pdus_show(struct config_item *item,
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -686,7 +686,7 @@ static ssize_t iscsi_stat_sess_txdata_octs_show(struct config_item *item,
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -708,7 +708,7 @@ static ssize_t iscsi_stat_sess_rxdata_octs_show(struct config_item *item,
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -730,7 +730,7 @@ static ssize_t iscsi_stat_sess_conn_digest_errors_show(struct config_item *item,
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
@@ -752,7 +752,7 @@ static ssize_t iscsi_stat_sess_conn_timeout_errors_show(
 {
 	struct iscsi_node_acl *acl = iscsi_stat_nacl(item);
 	struct se_node_acl *se_nacl = &acl->se_node_acl;
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_session *se_sess;
 	ssize_t ret = 0;
 
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index e3c3a08db1e0..afc801f255f5 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -67,7 +67,7 @@ int iscsit_tmr_task_warm_reset(
 	struct iscsi_tmr_req *tmr_req,
 	unsigned char *buf)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_warm_reset) {
@@ -87,7 +87,7 @@ int iscsit_tmr_task_cold_reset(
 	struct iscsi_tmr_req *tmr_req,
 	unsigned char *buf)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!na->tmr_cold_reset) {
@@ -177,7 +177,7 @@ u8 iscsit_tmr_task_reassign(
 static void iscsit_task_reassign_remove_cmd(
 	struct iscsit_cmd *cmd,
 	struct iscsi_conn_recovery *cr,
-	struct iscsi_session *sess)
+	struct iscsit_session *sess)
 {
 	int ret;
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 2d5cf1714ae0..4339ee517434 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -390,7 +390,7 @@ int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *tpg, int force)
 }
 
 struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(
-	struct iscsi_session *sess)
+	struct iscsit_session *sess)
 {
 	struct se_session *se_sess = sess->se_sess;
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 88576f5d0ca4..839e45362776 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -5,7 +5,7 @@
 #include <linux/types.h>
 
 struct iscsi_np;
-struct iscsi_session;
+struct iscsit_session;
 struct iscsi_tiqn;
 struct iscsi_tpg_np;
 struct se_node_acl;
@@ -28,7 +28,7 @@ extern struct iscsi_node_acl *iscsit_tpg_add_initiator_node_acl(
 			struct iscsi_portal_group *, const char *, u32);
 extern void iscsit_tpg_del_initiator_node_acl(struct iscsi_portal_group *,
 			struct se_node_acl *);
-extern struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(struct iscsi_session *);
+extern struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(struct iscsit_session *);
 extern void iscsit_tpg_del_external_nps(struct iscsi_tpg_np *);
 extern struct iscsi_tpg_np *iscsit_tpg_locate_child_np(struct iscsi_tpg_np *, int);
 extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi_portal_group *,
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index be50f857d1b1..8d9f21372b67 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -238,7 +238,7 @@ struct iscsi_r2t *iscsit_get_holder_for_r2tsn(
 	return NULL;
 }
 
-static inline int iscsit_check_received_cmdsn(struct iscsi_session *sess, u32 cmdsn)
+static inline int iscsit_check_received_cmdsn(struct iscsit_session *sess, u32 cmdsn)
 {
 	u32 max_cmdsn;
 	int ret;
@@ -446,7 +446,7 @@ struct iscsit_cmd *iscsit_find_cmd_from_ttt(
 }
 
 int iscsit_find_cmd_for_recovery(
-	struct iscsi_session *sess,
+	struct iscsit_session *sess,
 	struct iscsit_cmd **cmd_ptr,
 	struct iscsi_conn_recovery **cr_ptr,
 	itt_t init_task_tag)
@@ -696,7 +696,7 @@ void iscsit_free_queue_reqs_for_conn(struct iscsit_conn *conn)
 
 void iscsit_release_cmd(struct iscsit_cmd *cmd)
 {
-	struct iscsi_session *sess;
+	struct iscsit_session *sess;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	WARN_ON(!list_empty(&cmd->i_conn_node));
@@ -762,7 +762,7 @@ void iscsit_free_cmd(struct iscsit_cmd *cmd, bool shutdown)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
 
-bool iscsit_check_session_usage_count(struct iscsi_session *sess,
+bool iscsit_check_session_usage_count(struct iscsit_session *sess,
 				      bool can_sleep)
 {
 	spin_lock_bh(&sess->session_usage_lock);
@@ -780,7 +780,7 @@ bool iscsit_check_session_usage_count(struct iscsi_session *sess,
 	return false;
 }
 
-void iscsit_dec_session_usage_count(struct iscsi_session *sess)
+void iscsit_dec_session_usage_count(struct iscsit_session *sess)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count--;
@@ -791,14 +791,14 @@ void iscsit_dec_session_usage_count(struct iscsi_session *sess)
 	spin_unlock_bh(&sess->session_usage_lock);
 }
 
-void iscsit_inc_session_usage_count(struct iscsi_session *sess)
+void iscsit_inc_session_usage_count(struct iscsit_session *sess)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count++;
 	spin_unlock_bh(&sess->session_usage_lock);
 }
 
-struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsi_session *sess, u16 cid)
+struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsit_session *sess, u16 cid)
 {
 	struct iscsit_conn *conn;
 
@@ -816,7 +816,7 @@ struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsi_session *sess, u16 cid
 	return NULL;
 }
 
-struct iscsit_conn *iscsit_get_conn_from_cid_rcfr(struct iscsi_session *sess, u16 cid)
+struct iscsit_conn *iscsit_get_conn_from_cid_rcfr(struct iscsit_session *sess, u16 cid)
 {
 	struct iscsit_conn *conn;
 
@@ -896,7 +896,7 @@ static int iscsit_add_nopin(struct iscsit_conn *conn, int want_response)
 void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 {
 	struct iscsit_conn *conn = from_timer(conn, t, nopin_response_timer);
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -921,7 +921,7 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 
 void iscsit_mod_nopin_response_timer(struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&conn->nopin_timer_lock);
@@ -937,7 +937,7 @@ void iscsit_mod_nopin_response_timer(struct iscsit_conn *conn)
 
 void iscsit_start_nopin_response_timer(struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&conn->nopin_timer_lock);
@@ -994,7 +994,7 @@ void iscsit_handle_nopin_timeout(struct timer_list *t)
 
 void __iscsit_start_nopin_timer(struct iscsit_conn *conn)
 {
-	struct iscsi_session *sess = conn->sess;
+	struct iscsit_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	lockdep_assert_held(&conn->nopin_timer_lock);
@@ -1198,7 +1198,7 @@ int iscsit_tx_login_rsp(struct iscsit_conn *conn, u8 status_class, u8 status_det
 	return conn->conn_transport->iscsit_put_login_tx(conn, login, 0);
 }
 
-void iscsit_print_session_params(struct iscsi_session *sess)
+void iscsit_print_session_params(struct iscsit_session *sess)
 {
 	struct iscsit_conn *conn;
 
@@ -1351,7 +1351,7 @@ struct iscsi_tiqn *iscsit_snmp_get_tiqn(struct iscsit_conn *conn)
 	return tpg->tpg_tiqn;
 }
 
-void iscsit_fill_cxn_timeout_err_stats(struct iscsi_session *sess)
+void iscsit_fill_cxn_timeout_err_stats(struct iscsit_session *sess)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index dcdcdfe4fd7e..33ea799a0850 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -10,7 +10,7 @@
 struct iscsit_cmd;
 struct iscsit_conn;
 struct iscsi_conn_recovery;
-struct iscsi_session;
+struct iscsit_session;
 
 extern int iscsit_add_r2t_to_list(struct iscsit_cmd *, u32, u32, int, u32);
 extern struct iscsi_r2t *iscsit_get_r2t_for_eos(struct iscsit_cmd *, u32, u32);
@@ -28,7 +28,7 @@ extern int iscsit_check_unsolicited_dataout(struct iscsit_cmd *, unsigned char *
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt_or_dump(struct iscsit_conn *,
 			itt_t, u32);
 extern struct iscsit_cmd *iscsit_find_cmd_from_ttt(struct iscsit_conn *, u32);
-extern int iscsit_find_cmd_for_recovery(struct iscsi_session *, struct iscsit_cmd **,
+extern int iscsit_find_cmd_for_recovery(struct iscsit_session *, struct iscsit_cmd **,
 			struct iscsi_conn_recovery **, itt_t);
 extern void iscsit_add_cmd_to_immediate_queue(struct iscsit_cmd *, struct iscsit_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsit_conn *);
@@ -40,11 +40,11 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsit_conn *);
 extern void iscsit_release_cmd(struct iscsit_cmd *);
 extern void __iscsit_free_cmd(struct iscsit_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsit_cmd *, bool);
-extern bool iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep);
-extern void iscsit_dec_session_usage_count(struct iscsi_session *);
-extern void iscsit_inc_session_usage_count(struct iscsi_session *);
-extern struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsi_session *, u16);
-extern struct iscsit_conn *iscsit_get_conn_from_cid_rcfr(struct iscsi_session *, u16);
+extern bool iscsit_check_session_usage_count(struct iscsit_session *sess, bool can_sleep);
+extern void iscsit_dec_session_usage_count(struct iscsit_session *);
+extern void iscsit_inc_session_usage_count(struct iscsit_session *);
+extern struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsit_session *, u16);
+extern struct iscsit_conn *iscsit_get_conn_from_cid_rcfr(struct iscsit_session *, u16);
 extern void iscsit_check_conn_usage_count(struct iscsit_conn *);
 extern void iscsit_dec_conn_usage_count(struct iscsit_conn *);
 extern void iscsit_inc_conn_usage_count(struct iscsit_conn *);
@@ -59,7 +59,7 @@ extern void iscsit_stop_nopin_timer(struct iscsit_conn *);
 extern int iscsit_send_tx_data(struct iscsit_cmd *, struct iscsit_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_tx_login_rsp(struct iscsit_conn *, u8, u8);
-extern void iscsit_print_session_params(struct iscsi_session *);
+extern void iscsit_print_session_params(struct iscsit_session *);
 extern int iscsit_print_dev_to_proc(char *, char **, off_t, int);
 extern int iscsit_print_sessions_to_proc(char *, char **, off_t, int);
 extern int iscsit_print_tpg_to_proc(char *, char **, off_t, int);
@@ -67,6 +67,6 @@ extern int rx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern int tx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern void iscsit_collect_login_stats(struct iscsit_conn *, u8, u8);
 extern struct iscsi_tiqn *iscsit_snmp_get_tiqn(struct iscsit_conn *);
-extern void iscsit_fill_cxn_timeout_err_stats(struct iscsi_session *);
+extern void iscsit_fill_cxn_timeout_err_stats(struct iscsit_session *);
 
 #endif /*** ISCSI_TARGET_UTIL_H ***/
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 76581e0f3d98..8e68ace428d9 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -482,7 +482,7 @@ struct iscsit_cmd {
 	/* Pointer to connection recovery entry */
 	struct iscsi_conn_recovery *cr;
 	/* Session the command is part of,  used for connection recovery */
-	struct iscsi_session	*sess;
+	struct iscsit_session	*sess;
 	/* list_head for connection list */
 	struct list_head	i_conn_node;
 	/* The TCM I/O descriptor that is accessed via container_of() */
@@ -598,7 +598,7 @@ struct iscsit_conn {
 	struct iscsi_portal_group *tpg;
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
-	struct iscsi_session	*sess;
+	struct iscsit_session	*sess;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
@@ -618,11 +618,11 @@ struct iscsi_conn_recovery {
 	struct list_head	conn_recovery_cmd_list;
 	spinlock_t		conn_recovery_cmd_lock;
 	struct timer_list	time2retain_timer;
-	struct iscsi_session	*sess;
+	struct iscsit_session	*sess;
 	struct list_head	cr_list;
 }  ____cacheline_aligned;
 
-struct iscsi_session {
+struct iscsit_session {
 	u8			initiator_vendor;
 	u8			isid[6];
 	enum iscsi_timer_flags_table time2retain_timer_flags;
@@ -885,7 +885,7 @@ struct iscsit_global {
 	struct iscsi_portal_group	*discovery_tpg;
 };
 
-static inline u32 session_get_next_ttt(struct iscsi_session *session)
+static inline u32 session_get_next_ttt(struct iscsit_session *session)
 {
 	u32 ttt;
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 2ab26bb6f808..42cfe02ea909 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -105,7 +105,7 @@ extern int iscsit_response_queue(struct iscsit_conn *, struct iscsit_cmd *, int)
 /*
  * From iscsi_target_device.c
  */
-extern void iscsit_increment_maxcmdsn(struct iscsit_cmd *, struct iscsi_session *);
+extern void iscsit_increment_maxcmdsn(struct iscsit_cmd *, struct iscsit_session *);
 /*
  * From iscsi_target_erl0.c
  */
-- 
2.18.2

