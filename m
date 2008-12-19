From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 2/14]: Make iscsi_handle_authentication() use
	se_node_acl_t
Date: Fri, 19 Dec 2008 15:30:57 -0800
Message-ID: <1229729457.4560.104.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756148AbYLSXbl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From b8564cdaefbfa40510ac6c8afb37b97d195a5c4c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:51:27 -0800
Subject: [PATCH] [LIO-Target]: Make iscsi_handle_authentication() use se_node_acl_t

Replace iSCSI specific ACLs in iscsi_handle_authentication() to use generic
se_node_acl_t->initiatorname[].

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_auth_kernel.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/iscsi_auth_kernel.h b/drivers/lio-core/iscsi_auth_kernel.h
index cf789dd..2b385b0 100644
--- a/drivers/lio-core/iscsi_auth_kernel.h
+++ b/drivers/lio-core/iscsi_auth_kernel.h
@@ -45,6 +45,7 @@ extern u32 iscsi_handle_authentication (
 	u32			rc = 0, ret = 0;
 	auth_daemon_t		*iscsi_auth = NULL;
 	mm_segment_t		oldfs;
+	se_node_acl_t		*se_nacl;
 	struct iovec 		iov;
 	struct msghdr		msg;
 	struct sockaddr_in 	s_addr;
@@ -52,12 +53,11 @@ extern u32 iscsi_handle_authentication (
 
 	down(&iscsi_global->auth_sem);
 
-	if (!(iscsi_auth = (auth_daemon_t *) kmalloc(sizeof(auth_daemon_t), GFP_KERNEL))) {
+	if (!(iscsi_auth = (auth_daemon_t *) kzalloc(sizeof(auth_daemon_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_auth\n");
 		up(&iscsi_global->auth_sem);
 		return(2);
 	}
-	memset(iscsi_auth, 0, sizeof(auth_daemon_t));
 
 	if (authtype) {
 		memcpy(iscsi_auth->type, authtype, sizeof(iscsi_auth->type)); 
@@ -79,23 +79,20 @@ extern u32 iscsi_handle_authentication (
 	iscsi_auth->cid = conn->cid;
 	iscsi_auth->sid = SESS(conn)->sid;
 	iscsi_auth->auth_id = conn->auth_id;
-#ifdef _INITIATOR
-	iscsi_auth->channel_id = SESS(conn)->channel->channel_id;
-#else
 	iscsi_auth->tpgt = SESS(conn)->tpg->tpgt;
-	if (!SESS(conn)->node_acl) {
+
+	if (!(se_nacl = SESS(conn)->se_sess->se_node_acl)) {
 		ret = -1;
 		goto out;
 	}
-	strncpy(iscsi_auth->initiatorname, SESS(conn)->node_acl->initiatorname,
-		strlen(SESS(conn)->node_acl->initiatorname) + 1);
+	strncpy(iscsi_auth->initiatorname, se_nacl->initiatorname,
+		strlen(se_nacl->initiatorname) + 1);
 #ifdef SNMP_SUPPORT
 	if (strstr("CHAP", iscsi_auth->type))
 		strcpy(SESS(conn)->auth_type, "CHAP");
 	else
 		strcpy(SESS(conn)->auth_type, NONE);
 #endif /* SNMP_SUPPORT */
-#endif
 
 	s_addr.sin_family	= AF_INET;
 	s_addr.sin_addr.s_addr	= htonl(INADDR_LOOPBACK);
-- 
1.5.4.1
