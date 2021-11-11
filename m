Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DBDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 13:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E090C60C40
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 13:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhKKNku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 08:40:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232778AbhKKNkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 08:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636637880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MlnqQ7ly4klw7WQJ5BlWyKDfOaJYsxCwVIzv9m5ceD4=;
        b=M6goEsgxVkGyFgaJ48xo2PuD7gZkLFwksj8mXyIEiqmO9HEu3ybAhUGeU3kiuYKz+nqo3P
        DmKKstzbIQ8Prc55fj2h21EpBp3DxNvst8ynh3hnfE06Fhk4t0bWaLUnarC0dPisRHdG1r
        V0ysF8sP3jnpCwcP7Et4hs624zMgC8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-KCHJhQdiOoq3a0vp_A50AQ-1; Thu, 11 Nov 2021 08:37:56 -0500
X-MC-Unique: KCHJhQdiOoq3a0vp_A50AQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 725641017965;
        Thu, 11 Nov 2021 13:37:55 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.193.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF5431017CF3;
        Thu, 11 Nov 2021 13:37:53 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        k.shelekhin@yadro.com
Subject: [PATCH V2] target: iscsi: simplify the connection closing mechanism
Date:   Thu, 11 Nov 2021 14:37:52 +0100
Message-Id: <20211111133752.159379-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the connection reinstatement is performed, the target driver
executes a complex scheme of complete()/wait_for_completion() that is not
really needed.

Considering that:

1) The callers of iscsit_connection_reinstatement_rcfr() and
   iscsit_cause_connection_reinstatement() hold a reference
   to the conn structure.

2) iscsit_close_connection() will sleep when calling
   iscsit_check_conn_usage_count() until the conn structure's refcount
   reaches zero.

we can optimize the driver the following way:

* The threads that must sleep until the connection is closed
  will all wait for the "conn_wait_comp" completion,
  iscsit_close_connection() will then call complete_all() to wake them up.
  No need to have multiple completion structures.

* The conn_post_wait_comp completion is not necessary and can be removed
  because iscsit_close_connection() sleeps until all the other threads
  release the conn structure.
  (see the iscsit_check_conn_usage_count() function)

V2: do not set connection_reinstatement to 1 in iscsit_close_connection(),
    leave iscsit_cause_connection_reinstatement() deal with reentrancy.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       | 27 +++--------------------
 drivers/target/iscsi/iscsi_target_erl0.c  |  6 +----
 drivers/target/iscsi/iscsi_target_login.c |  2 --
 drivers/target/iscsi/iscsi_target_util.c  |  3 ---
 include/target/iscsi/iscsi_target_core.h  |  4 ----
 5 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..d558c4c064cb 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4226,31 +4226,10 @@ int iscsit_close_connection(
 	/*
 	 * If connection reinstatement is being performed on this connection,
 	 * up the connection reinstatement semaphore that is being blocked on
-	 * in iscsit_cause_connection_reinstatement().
+	 * in iscsit_cause_connection_reinstatement() or
+	 * in iscsit_connection_reinstatement_rcfr()
 	 */
-	spin_lock_bh(&conn->state_lock);
-	if (atomic_read(&conn->sleep_on_conn_wait_comp)) {
-		spin_unlock_bh(&conn->state_lock);
-		complete(&conn->conn_wait_comp);
-		wait_for_completion(&conn->conn_post_wait_comp);
-		spin_lock_bh(&conn->state_lock);
-	}
-
-	/*
-	 * If connection reinstatement is being performed on this connection
-	 * by receiving a REMOVECONNFORRECOVERY logout request, up the
-	 * connection wait rcfr semaphore that is being blocked on
-	 * an iscsit_connection_reinstatement_rcfr().
-	 */
-	if (atomic_read(&conn->connection_wait_rcfr)) {
-		spin_unlock_bh(&conn->state_lock);
-		complete(&conn->conn_wait_rcfr_comp);
-		wait_for_completion(&conn->conn_post_wait_comp);
-		spin_lock_bh(&conn->state_lock);
-	}
-	atomic_set(&conn->connection_reinstatement, 1);
-	spin_unlock_bh(&conn->state_lock);
-
+	complete_all(&conn->conn_wait_comp);
 	/*
 	 * If any other processes are accessing this connection pointer we
 	 * must wait until they have completed.
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 102c9cbf59f3..584e0a0b517d 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -839,8 +839,7 @@ void iscsit_connection_reinstatement_rcfr(struct iscsi_conn *conn)
 		send_sig(SIGINT, conn->rx_thread, 1);
 
 sleep:
-	wait_for_completion(&conn->conn_wait_rcfr_comp);
-	complete(&conn->conn_post_wait_comp);
+	wait_for_completion(&conn->conn_wait_comp);
 }
 
 void iscsit_cause_connection_reinstatement(struct iscsi_conn *conn, int sleep)
@@ -871,12 +870,9 @@ void iscsit_cause_connection_reinstatement(struct iscsi_conn *conn, int sleep)
 		spin_unlock_bh(&conn->state_lock);
 		return;
 	}
-
-	atomic_set(&conn->sleep_on_conn_wait_comp, 1);
 	spin_unlock_bh(&conn->state_lock);
 
 	wait_for_completion(&conn->conn_wait_comp);
-	complete(&conn->conn_post_wait_comp);
 }
 EXPORT_SYMBOL(iscsit_cause_connection_reinstatement);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1a9c50401bdb..982c23459272 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1096,9 +1096,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
 	INIT_LIST_HEAD(&conn->immed_queue_list);
 	INIT_LIST_HEAD(&conn->response_queue_list);
-	init_completion(&conn->conn_post_wait_comp);
 	init_completion(&conn->conn_wait_comp);
-	init_completion(&conn->conn_wait_rcfr_comp);
 	init_completion(&conn->conn_waiting_on_uc_comp);
 	init_completion(&conn->conn_logout_comp);
 	init_completion(&conn->rx_half_close_comp);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 6dd5810e2af1..d7b1f9110d49 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -824,9 +824,6 @@ struct iscsi_conn *iscsit_get_conn_from_cid_rcfr(struct iscsi_session *sess, u16
 	list_for_each_entry(conn, &sess->sess_conn_list, conn_list) {
 		if (conn->cid == cid) {
 			iscsit_inc_conn_usage_count(conn);
-			spin_lock(&conn->state_lock);
-			atomic_set(&conn->connection_wait_rcfr, 1);
-			spin_unlock(&conn->state_lock);
 			spin_unlock_bh(&sess->conn_lock);
 			return conn;
 		}
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 1eccb2ac7d02..aeb8932507c2 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -542,12 +542,8 @@ struct iscsi_conn {
 	atomic_t		connection_exit;
 	atomic_t		connection_recovery;
 	atomic_t		connection_reinstatement;
-	atomic_t		connection_wait_rcfr;
-	atomic_t		sleep_on_conn_wait_comp;
 	atomic_t		transport_failed;
-	struct completion	conn_post_wait_comp;
 	struct completion	conn_wait_comp;
-	struct completion	conn_wait_rcfr_comp;
 	struct completion	conn_waiting_on_uc_comp;
 	struct completion	conn_logout_comp;
 	struct completion	tx_half_close_comp;
-- 
2.27.0

