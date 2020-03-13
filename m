Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C16C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 002C320770
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awa/Ihlm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCMRHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 13:07:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726414AbgCMRHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 13:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584119228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4zgvwKwYV/4yMfWv8NTDZm1wSvjDdKggXey56FT3bs=;
        b=awa/Ihlm8s7pqtszNXOU/Lr7uhjdJhfa/Qc+0q1oZNjM8sRNIDTQl+o3Wpl/j79k9yJ0Og
        qIFyyQN8lfpjIV3wKe+3eV04WxNmvrofMciaSVNiudW7XG5kssW7tgKjsW3MZZzQvBgQyC
        0AWjuVfnaIwmbrd/Uej5sjuc/OWCtKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-hShqJV-iONqcGyjt_UWRTA-1; Fri, 13 Mar 2020 13:07:07 -0400
X-MC-Unique: hShqJV-iONqcGyjt_UWRTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2671DB6A;
        Fri, 13 Mar 2020 17:07:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-206-24.brq.redhat.com [10.40.206.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A78F373862;
        Fri, 13 Mar 2020 17:07:03 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de,
        mcoleman@datto.com, linux-scsi@vger.kernel.org
Subject: [PATCH RESEND 2/3] target: fix target hang when multiple threads try to destroy the same iscsi session.
Date:   Fri, 13 Mar 2020 18:06:55 +0100
Message-Id: <20200313170656.9716-3-mlombard@redhat.com>
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com>
References: <20200313170656.9716-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A number of hangs have been reported against the target driver; they
are due to the fact that multiple threads may try to destroy the
iscsi session at the same time, this may be reproduced
for example when a "targetcli iscsi/iqn.../tpg1 disable" command
is executed while a logout operation is underway.

When this happens, two or more threads may end up sleeping and waiting fo=
r
iscsit_close_connection() to execute "complete(session_wait_comp)".
Only one of the threads will wake up and proceed to destroy
the session structure, the remaining threads will hang forever.

Note that if the blocked threads are somehow forced to
wake up with complete_all(), they will try to free the same
iscsi session structure destroyed by the first thread, causing
double frees, memory corruptions etc...

With this patch, the threads that want to destroy the iscsi session will
increase the session refcount and will set the "session_close" flag to 1;
then they wait for the driver to close the remaining active connections.
When the last connection is closed, iscsit_close_connection() will wake
up all the threads and will wait for the session's refcount to reach zero=
;
when this happens, iscsit_close_connection() will destroy the session
structure because no one is referencing it anymore.

 INFO: task targetcli:5971 blocked for more than 120 seconds.
       Tainted: P           OE    4.15.0-72-generic #81~16.04.1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message=
.
 targetcli       D    0  5971      1 0x00000080
 Call Trace:
  __schedule+0x3d6/0x8b0
  ? vprintk_func+0x44/0xe0
  schedule+0x36/0x80
  schedule_timeout+0x1db/0x370
  ? __dynamic_pr_debug+0x8a/0xb0
  wait_for_completion+0xb4/0x140
  ? wake_up_q+0x70/0x70
  iscsit_free_session+0x13d/0x1a0 [iscsi_target_mod]
  iscsit_release_sessions_for_tpg+0x16b/0x1e0 [iscsi_target_mod]
  iscsit_tpg_disable_portal_group+0xca/0x1c0 [iscsi_target_mod]
  lio_target_tpg_enable_store+0x66/0xe0 [iscsi_target_mod]
  configfs_write_file+0xb9/0x120
  __vfs_write+0x1b/0x40
  vfs_write+0xb8/0x1b0
  SyS_write+0x5c/0xe0
  do_syscall_64+0x73/0x130
  entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Reported-by: Matt Coleman <mcoleman@datto.com>
Tested-by: Matt Coleman <mcoleman@datto.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          | 35 ++++++++++++--------
 drivers/target/iscsi/iscsi_target_configfs.c |  5 ++-
 drivers/target/iscsi/iscsi_target_login.c    |  5 +--
 include/target/iscsi/iscsi_target_core.h     |  2 +-
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
index a955ab73eaae..9e90edc875f1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4311,30 +4311,37 @@ int iscsit_close_connection(
 	if (!atomic_read(&sess->session_reinstatement) &&
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
+		complete_all(&sess->session_wait_comp);
 		iscsit_close_session(sess);
=20
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
 		pr_debug("Moving to TARG_SESS_STATE_FREE.\n");
 		sess->session_state =3D TARG_SESS_STATE_FREE;
-		spin_unlock_bh(&sess->conn_lock);
=20
-		if (atomic_read(&sess->sleep_on_sess_wait_comp))
-			complete(&sess->session_wait_comp);
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			complete_all(&sess->session_wait_comp);
+			iscsit_close_session(sess);
+		} else {
+			spin_unlock_bh(&sess->conn_lock);
+		}
=20
 		return 0;
 	} else {
 		pr_debug("Moving to TARG_SESS_STATE_FAILED.\n");
 		sess->session_state =3D TARG_SESS_STATE_FAILED;
=20
-		if (!atomic_read(&sess->session_continuation)) {
-			spin_unlock_bh(&sess->conn_lock);
+		if (!atomic_read(&sess->session_continuation))
 			iscsit_start_time2retain_handler(sess);
-		} else
-			spin_unlock_bh(&sess->conn_lock);
=20
-		if (atomic_read(&sess->sleep_on_sess_wait_comp))
-			complete(&sess->session_wait_comp);
+		if (atomic_read(&sess->session_close)) {
+			spin_unlock_bh(&sess->conn_lock);
+			complete_all(&sess->session_wait_comp);
+			iscsit_close_session(sess);
+		} else {
+			spin_unlock_bh(&sess->conn_lock);
+		}
=20
 		return 0;
 	}
@@ -4440,9 +4447,9 @@ static void iscsit_logout_post_handler_closesession=
(
 	complete(&conn->conn_logout_comp);
=20
 	iscsit_dec_conn_usage_count(conn);
+	atomic_set(&sess->session_close, 1);
 	iscsit_stop_session(sess, sleep, sleep);
 	iscsit_dec_session_usage_count(sess);
-	iscsit_close_session(sess);
 }
=20
 static void iscsit_logout_post_handler_samecid(
@@ -4587,8 +4594,6 @@ void iscsit_stop_session(
 	int is_last;
=20
 	spin_lock_bh(&sess->conn_lock);
-	if (session_sleep)
-		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
=20
 	if (connection_sleep) {
 		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
@@ -4646,12 +4651,15 @@ int iscsit_release_sessions_for_tpg(struct iscsi_=
portal_group *tpg, int force)
 		spin_lock(&sess->conn_lock);
 		if (atomic_read(&sess->session_fall_back_to_erl0) ||
 		    atomic_read(&sess->session_logout) ||
+		    atomic_read(&sess->session_close) ||
 		    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 			spin_unlock(&sess->conn_lock);
 			continue;
 		}
+		iscsit_inc_session_usage_count(sess);
 		atomic_set(&sess->session_reinstatement, 1);
 		atomic_set(&sess->session_fall_back_to_erl0, 1);
+		atomic_set(&sess->session_close, 1);
 		spin_unlock(&sess->conn_lock);
=20
 		list_move_tail(&se_sess->sess_list, &free_list);
@@ -4661,8 +4669,9 @@ int iscsit_release_sessions_for_tpg(struct iscsi_po=
rtal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
=20
+		list_del_init(&se_sess->sess_list);
 		iscsit_stop_session(sess, 1, 1);
-		iscsit_close_session(sess);
+		iscsit_dec_session_usage_count(sess);
 		session_count++;
 	}
=20
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/targe=
t/iscsi/iscsi_target_configfs.c
index cac94c94ef5d..fce192a0d0ba 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1484,20 +1484,23 @@ static void lio_tpg_close_session(struct se_sessi=
on *se_sess)
 	spin_lock(&sess->conn_lock);
 	if (atomic_read(&sess->session_fall_back_to_erl0) ||
 	    atomic_read(&sess->session_logout) ||
+	    atomic_read(&sess->session_close) ||
 	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 		spin_unlock(&sess->conn_lock);
 		spin_unlock_bh(&se_tpg->session_lock);
 		return;
 	}
+	iscsit_inc_session_usage_count(sess);
 	atomic_set(&sess->session_reinstatement, 1);
 	atomic_set(&sess->session_fall_back_to_erl0, 1);
+	atomic_set(&sess->session_close, 1);
 	spin_unlock(&sess->conn_lock);
=20
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
=20
 	iscsit_stop_session(sess, 1, 1);
-	iscsit_close_session(sess);
+	iscsit_dec_session_usage_count(sess);
 }
=20
 static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/i=
scsi/iscsi_target_login.c
index 683d04580eb3..9de7abedfebe 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -164,6 +164,7 @@ int iscsi_check_for_session_reinstatement(struct iscs=
i_conn *conn)
 		spin_lock(&sess_p->conn_lock);
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		    (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 			spin_unlock(&sess_p->conn_lock);
 			continue;
@@ -174,6 +175,7 @@ int iscsi_check_for_session_reinstatement(struct iscs=
i_conn *conn)
 		   (sess_p->sess_ops->SessionType =3D=3D sessiontype))) {
 			atomic_set(&sess_p->session_reinstatement, 1);
 			atomic_set(&sess_p->session_fall_back_to_erl0, 1);
+			atomic_set(&sess_p->session_close, 1);
 			spin_unlock(&sess_p->conn_lock);
 			iscsit_inc_session_usage_count(sess_p);
 			iscsit_stop_time2retain_timer(sess_p);
@@ -198,7 +200,6 @@ int iscsi_check_for_session_reinstatement(struct iscs=
i_conn *conn)
 	if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
 		spin_unlock_bh(&sess->conn_lock);
 		iscsit_dec_session_usage_count(sess);
-		iscsit_close_session(sess);
 		return 0;
 	}
 	spin_unlock_bh(&sess->conn_lock);
@@ -206,7 +207,6 @@ int iscsi_check_for_session_reinstatement(struct iscs=
i_conn *conn)
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
=20
-	iscsit_close_session(sess);
 	return 0;
 }
=20
@@ -494,6 +494,7 @@ static int iscsi_login_non_zero_tsih_s2(
 		sess_p =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
 		if (atomic_read(&sess_p->session_fall_back_to_erl0) ||
 		    atomic_read(&sess_p->session_logout) ||
+		    atomic_read(&sess_p->session_close) ||
 		   (sess_p->time2retain_timer_flags & ISCSI_TF_EXPIRED))
 			continue;
 		if (!memcmp(sess_p->isid, pdu->isid, 6) &&
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/is=
csi/iscsi_target_core.h
index a49d37140a64..591cd9e4692c 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -676,7 +676,7 @@ struct iscsi_session {
 	atomic_t		session_logout;
 	atomic_t		session_reinstatement;
 	atomic_t		session_stop_active;
-	atomic_t		sleep_on_sess_wait_comp;
+	atomic_t		session_close;
 	/* connection list */
 	struct list_head	sess_conn_list;
 	struct list_head	cr_active_list;
--=20
2.21.0

