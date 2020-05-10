Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27034C54E8E
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0AC2082E
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XSOxUp/Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgEJV6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50264 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729501AbgEJV6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 17:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zz6krBf2Ix60rJx6HA/JfqgDeMycXLjzXeXFme7uBVw=;
        b=XSOxUp/YhfJHXHnFvUbS9Yb9lv0kS3SIZk6pFJY3JchpC4+SfGldyfxew6RDuwMJ4zTzS5
        fCpWj05Yc/qF+Msr7a8BO+hmSccQIXFUWGohG1gnb8zqX4RuQOCyb3QwaXfBGh7Tg1e0+W
        ripkCwwzoR94Bo6NzPrEtcRZQkrDv30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-jsFI3l7KMn-YHbkT9Xj2KQ-1; Sun, 10 May 2020 17:58:10 -0400
X-MC-Unique: jsFI3l7KMn-YHbkT9Xj2KQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECC7835B8B;
        Sun, 10 May 2020 21:58:09 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 948A610002CD;
        Sun, 10 May 2020 21:58:08 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 14/15] iscsi target: use session sysfs helpers
Date:   Sun, 10 May 2020 16:57:43 -0500
Message-Id: <20200510215744.21999-15-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi target login process breaks up session allocation and
registration, so it does not use target_setup_session like every one else.
This converts iscsi to use the session sysfs helpers and drops its session
id to use the common one.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
V3:
- Fix goto use. Actually moved sysfs addition call to after nego
  to avoid sysfs additions when login ends up failing.

 drivers/target/iscsi/iscsi_target.c          |  3 +--
 drivers/target/iscsi/iscsi_target_configfs.c |  4 +---
 drivers/target/iscsi/iscsi_target_login.c    | 16 ++--------------
 drivers/target/iscsi/iscsi_target_nego.c     |  8 ++++++++
 drivers/target/iscsi/iscsi_target_stat.c     |  3 +--
 include/target/iscsi/iscsi_target_core.h     |  2 --
 6 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d6..e04aba4 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -49,7 +49,6 @@
 static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
-DEFINE_IDA(sess_ida);
 struct mutex auth_id_lock;
 
 struct iscsit_global *iscsit_global;
@@ -4359,6 +4358,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	target_sysfs_remove_session(sess->se_sess);
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4403,7 +4403,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
 
-	ida_free(&sess_ida, sess->session_index);
 	kfree(sess->sess_ops);
 	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 4513740..9301793 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1344,9 +1344,7 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 
 static u32 lio_sess_get_index(struct se_session *se_sess)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
-
-	return sess->session_index;
+	return se_sess->sid;
 }
 
 static int lio_queue_data_in(struct se_cmd *se_cmd)
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 731ee67..619ea09 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -257,7 +257,6 @@ static int iscsi_login_zero_tsih_s1(
 {
 	struct iscsi_session *sess = NULL;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
-	int ret;
 
 	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
 	if (!sess) {
@@ -291,15 +290,6 @@ static int iscsi_login_zero_tsih_s1(
 	timer_setup(&sess->time2retain_timer,
 		    iscsit_handle_time2retain_timeout, 0);
 
-	ret = ida_alloc(&sess_ida, GFP_KERNEL);
-	if (ret < 0) {
-		pr_err("Session ID allocation failed %d\n", ret);
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		goto free_sess;
-	}
-
-	sess->session_index = ret;
 	sess->creation_time = get_jiffies_64();
 	/*
 	 * The FFP CmdSN window values will be allocated from the TPG's
@@ -313,7 +303,7 @@ static int iscsi_login_zero_tsih_s1(
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_sess_ops.\n");
-		goto free_id;
+		goto free_sess;
 	}
 
 	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
@@ -327,8 +317,6 @@ static int iscsi_login_zero_tsih_s1(
 
 free_ops:
 	kfree(sess->sess_ops);
-free_id:
-	ida_free(&sess_ida, sess->session_index);
 free_sess:
 	kfree(sess);
 	conn->sess = NULL;
@@ -1183,8 +1171,8 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	if (!zero_tsih || !conn->sess)
 		goto old_sess_out;
 
+	target_sysfs_remove_session(conn->sess->se_sess);
 	transport_free_session(conn->sess->se_sess);
-	ida_free(&sess_ida, conn->sess->session_index);
 	kfree(conn->sess->sess_ops);
 	kfree(conn->sess);
 	conn->sess = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index c44613a2..c5184c0 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -359,6 +359,13 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
 			return -1;
 		}
+
+		if (target_sysfs_add_session(&conn->tpg->tpg_se_tpg,
+					     conn->sess->se_sess)) {
+			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+			return -1;
+		}
 	}
 
 	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
@@ -1276,6 +1283,7 @@ int iscsi_target_locate_portal(
 	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
 	if (ret < 0)
 		goto return_oom;
+	sess->se_sess->tfo = &iscsi_ops;
 
 	if (conn->tpg != iscsit_global->discovery_tpg) {
 		if (iscsi_setup_i_tpt_id(sess, i_buf))
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 35e75a3..8167fdc 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -630,8 +630,7 @@ static ssize_t iscsi_stat_sess_indx_show(struct config_item *item, char *page)
 	if (se_sess) {
 		sess = se_sess->fabric_sess_ptr;
 		if (sess)
-			ret = snprintf(page, PAGE_SIZE, "%u\n",
-					sess->session_index);
+			ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	}
 	spin_unlock_bh(&se_nacl->nacl_sess_lock);
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 591cd9e..443c5af 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -657,8 +657,6 @@ struct iscsi_session {
 	/* LIO specific session ID */
 	u32			sid;
 	char			auth_type[8];
-	/* unique within the target */
-	int			session_index;
 	/* Used for session reference counting */
 	int			session_usage_count;
 	int			session_waiting_on_uc;
-- 
1.8.3.1

