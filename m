Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01FAC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJCU1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 16:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJCU1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 16:27:48 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2A303EA;
        Mon,  3 Oct 2022 13:27:46 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B27E241220;
        Mon,  3 Oct 2022 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1664828863; x=1666643264; bh=ZFc/bde9yLuE7HUIDHaFgyP5c
        k6fy8KYB1sxGMvL1+U=; b=SZTQjlDW3y7yhZfxQvAT4SDwO3zlIhci4MPDgcxvD
        pdfIe23NIpGeZwH9QPD2yEvkxbxtls9OryAmiSKWR2LkeFPH/s7z4ua+rWMM9reo
        jU56Jahxqk3wzHewbBkjDJJ1yigj/UPw5Xx3Ek8WXuKL0ZLfF+eS1PPMq2Gmn+lK
        0M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D8mbbN7LCgmk; Mon,  3 Oct 2022 23:27:43 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E1F374120A;
        Mon,  3 Oct 2022 23:27:36 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
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
Subject: [PATCH 1/3] target: iscsi: schedule close_session at timeout
Date:   Mon, 3 Oct 2022 23:27:21 +0300
Message-ID: <20221003202723.22714-2-d.bogdanov@yadro.com>
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

iscsit_close_session in depth has sleepable dependencies, like:

iscsit_close_session()
  iscsit_free_connection_recovery_entries()
    iscsit_free_cmd()
      transport_generic_free_cmd()
        target_wait_free_cmd()
          wait_for_completion_timeout()

But iscsit_handle_time2retain_timeout calls it in timer-context that
leads to WARN on might_sleep();

Schedule iscsit_close_session in work queue.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c       | 8 ++++++++
 drivers/target/iscsi/iscsi_target.h       | 1 +
 drivers/target/iscsi/iscsi_target_erl0.c  | 4 +++-
 drivers/target/iscsi/iscsi_target_login.c | 1 +
 include/target/iscsi/iscsi_target_core.h  | 1 +
 5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..36166eabf595 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4495,6 +4495,14 @@ int iscsit_close_connection(
 	}
 }
 
+void iscsit_session_close_worker(struct work_struct *workp)
+{
+	struct iscsit_session *sess = container_of(workp, struct iscsit_session,
+						   session_close_worker);
+
+	iscsit_close_session(sess, true);
+}
+
 /*
  * If the iSCSI Session for the iSCSI Initiator Node exists,
  * forcefully shutdown the iSCSI NEXUS.
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 0c997a08adec..a529294a21ce 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -42,6 +42,7 @@ extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsit_conn *);
 extern int iscsit_close_session(struct iscsit_session *, bool can_sleep);
+extern void iscsit_session_close_worker(struct work_struct *workp);
 extern void iscsit_fail_session(struct iscsit_session *);
 extern void iscsit_stop_session(struct iscsit_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 07e9cf431edd..63890a72555b 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -764,8 +764,10 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 			" iSCSI session.\n", sess->sid);
 
 	iscsit_fill_cxn_timeout_err_stats(sess);
+	atomic_set(&sess->session_logout, 1);
 	spin_unlock_bh(&se_tpg->session_lock);
-	iscsit_close_session(sess, false);
+
+	schedule_work(&sess->session_close_worker);
 }
 
 void iscsit_start_time2retain_handler(struct iscsit_session *sess)
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..cc1895c56dd9 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -288,6 +288,7 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->cr_i_lock);
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
+	INIT_WORK(&sess->session_close_worker, iscsit_session_close_worker);
 
 	timer_setup(&sess->time2retain_timer,
 		    iscsit_handle_time2retain_timeout, 0);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..92436b3dd17b 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -684,6 +684,7 @@ struct iscsit_session {
 	struct completion	session_wait_comp;
 	struct completion	session_waiting_on_uc_comp;
 	struct timer_list	time2retain_timer;
+	struct work_struct	session_close_worker;
 	struct iscsi_sess_ops	*sess_ops;
 	struct se_session	*se_sess;
 	struct iscsi_portal_group *tpg;
-- 
2.25.1

