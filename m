Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9415CC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 20:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJCU1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJCU1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 16:27:48 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8343A3E771;
        Mon,  3 Oct 2022 13:27:47 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1C4CD4120A;
        Mon,  3 Oct 2022 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1664828864; x=1666643265; bh=l8noP737ebxNzhobzoU0QPz+R
        SYdA8cPCJ9qKGVOn9s=; b=T/hHJEgWYnnxu0UTj01jXZUkJkcTeH/iKiw2Petfi
        yzGgC+xK5ZyxMrnW1xhHiEKm8qxhTvPIFux3Z4V/n18a6bhZE4HNerntmuxoeA0a
        l4DctXg8p6Pif8M6fSj6ZkroVbwBIOnuTbCOGizYE4dBqLz6rzd0RjZ/TB0yAr4n
        Hw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Y2c-weysgCFy; Mon,  3 Oct 2022 23:27:44 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7439D4120D;
        Mon,  3 Oct 2022 23:27:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 3 Oct 2022 23:27:36 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 3 Oct 2022 23:27:35 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/3] target: iscsi: forbid call iscsit_close_session() from atomic context
Date:   Mon, 3 Oct 2022 23:27:22 +0300
Message-ID: <20221003202723.22714-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003202723.22714-1-d.bogdanov@yadro.com>
References: <20221003202723.22714-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since all calls iscsit_close_session() are now from non-atomic context,
remove can_sleep argument and forbid call iscsit_close_session() from
an atomic context in the future.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c      | 22 +++++++++-------------
 drivers/target/iscsi/iscsi_target.h      |  2 +-
 drivers/target/iscsi/iscsi_target_util.c |  5 +----
 drivers/target/iscsi/iscsi_target_util.h |  2 +-
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 36166eabf595..3e91523e540b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4460,7 +4460,7 @@ int iscsit_close_connection(
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
 		complete_all(&sess->session_wait_comp);
-		iscsit_close_session(sess, true);
+		iscsit_close_session(sess);
 
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
@@ -4470,7 +4470,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess, true);
+			iscsit_close_session(sess);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4486,7 +4486,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess, true);
+			iscsit_close_session(sess);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4500,18 +4500,20 @@ void iscsit_session_close_worker(struct work_struct *workp)
 	struct iscsit_session *sess = container_of(workp, struct iscsit_session,
 						   session_close_worker);
 
-	iscsit_close_session(sess, true);
+	iscsit_close_session(sess);
 }
 
 /*
  * If the iSCSI Session for the iSCSI Initiator Node exists,
  * forcefully shutdown the iSCSI NEXUS.
  */
-int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
+int iscsit_close_session(struct iscsit_session *sess)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
+	might_sleep();
+
 	if (atomic_read(&sess->nconn)) {
 		pr_err("%d connection(s) still exist for iSCSI session"
 			" to %s\n", atomic_read(&sess->nconn),
@@ -4536,15 +4538,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	/*
 	 * If any other processes are accessing this session pointer we must
-	 * wait until they have completed.  If we are in an interrupt (the
-	 * time2retain handler) and contain and active session usage count we
-	 * restart the timer and exit.
+	 * wait until they have completed.
 	 */
-	if (iscsit_check_session_usage_count(sess, can_sleep)) {
-		atomic_set(&sess->session_logout, 0);
-		iscsit_start_time2retain_handler(sess);
-		return 0;
-	}
+	iscsit_check_session_usage_count(sess);
 
 	transport_deregister_session(sess->se_sess);
 
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index a529294a21ce..054a47711bed 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -41,7 +41,7 @@ extern void iscsit_thread_get_cpumask(struct iscsit_conn *);
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsit_conn *);
-extern int iscsit_close_session(struct iscsit_session *, bool can_sleep);
+extern int iscsit_close_session(struct iscsit_session *sess);
 extern void iscsit_session_close_worker(struct work_struct *workp);
 extern void iscsit_fail_session(struct iscsit_session *);
 extern void iscsit_stop_session(struct iscsit_session *, int, int);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 8d9f21372b67..b618468e766c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -762,15 +762,12 @@ void iscsit_free_cmd(struct iscsit_cmd *cmd, bool shutdown)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
 
-bool iscsit_check_session_usage_count(struct iscsit_session *sess,
-				      bool can_sleep)
+bool iscsit_check_session_usage_count(struct iscsit_session *sess)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	if (sess->session_usage_count != 0) {
 		sess->session_waiting_on_uc = 1;
 		spin_unlock_bh(&sess->session_usage_lock);
-		if (!can_sleep)
-			return true;
 
 		wait_for_completion(&sess->session_waiting_on_uc_comp);
 		return false;
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 33ea799a0850..8f99971c0f2d 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -40,7 +40,7 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsit_conn *);
 extern void iscsit_release_cmd(struct iscsit_cmd *);
 extern void __iscsit_free_cmd(struct iscsit_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsit_cmd *, bool);
-extern bool iscsit_check_session_usage_count(struct iscsit_session *sess, bool can_sleep);
+extern bool iscsit_check_session_usage_count(struct iscsit_session *sess);
 extern void iscsit_dec_session_usage_count(struct iscsit_session *);
 extern void iscsit_inc_session_usage_count(struct iscsit_session *);
 extern struct iscsit_conn *iscsit_get_conn_from_cid(struct iscsit_session *, u16);
-- 
2.25.1

