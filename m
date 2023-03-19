Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FBCC76196
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCSB4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCSB4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A0F23106;
        Sat, 18 Mar 2023 18:56:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32IMhPLj004217;
        Sun, 19 Mar 2023 01:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=Bwhq5XR2raTVEtpcdJxY9++wOuI7JTgDaLHhrcEaak0=;
 b=ZW32ux4fZClLhMXvxBk7bZKeZV6vd828VrNS64Iqtosa0ICyRbzH/XIRzSTfos5awidf
 q72yAnrwgPIsWWAnqChGcLfZKbTDLDmn2+dg1Hex2MUhfCGBMlxNj73TV70xsHChiv3z
 uz8uDE532fTuQhvOcwVS37z8/5QuxyvB6J0U83ZgjN5Yl/e/RzS8OYkNRpSXTSGpXdns
 Qx+R7Zo6G85GZuxly5ekQzev5DI4EZOsvbUA9vEt2AcPCrwjgyqvK1y3NkkOUfe/Kg77
 DY9PGIxzHwefQZer26EC7+U0Rnu64JtwTo12r6AwthtMF4TcybMPxA5T+SE9WUfo3p+S Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5uu911k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INUPOc030373;
        Sun, 19 Mar 2023 01:56:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaubv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:26 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5G014254;
        Sun, 19 Mar 2023 01:56:26 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-2;
        Sun, 19 Mar 2023 01:56:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 1/9] scsi: target: Move sess cmd counter to new struct
Date:   Sat, 18 Mar 2023 20:56:12 -0500
Message-Id: <20230319015620.96006-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-GUID: UlKn8CNWI_zPN_uYXxjkIA48Wi_VrNo-
X-Proofpoint-ORIG-GUID: UlKn8CNWI_zPN_uYXxjkIA48Wi_VrNo-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
drivers do. It can't use target_stop_session because for MCS support we
can't stop the entire session during recovery because if other connections
are ok then we want to be able to continue to execute IO on them.

This patch moves the per session cmd counters to a new struct, so iSCSI
can allocate it per connection. The xcopy code can also just not allocate
it in the future since it doesn't need to track commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_tpg.c         |   2 +-
 drivers/target/target_core_transport.c   | 135 ++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  13 ++-
 4 files changed, 107 insertions(+), 44 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..8ebccdbd94f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
-		if (atomic_read(&sess->stopped))
+		if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped))
 			continue;
 
 		list_del_init(&sess->sess_acl_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..3d6034f00dcd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+static void target_release_cmd_refcnt(struct percpu_ref *ref)
 {
-	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+	struct target_cmd_counter *cmd_cnt  = container_of(ref,
+							   typeof(*cmd_cnt),
+							   refcnt);
+	wake_up(&cmd_cnt->refcnt_wq);
+}
+
+static struct target_cmd_counter *target_alloc_cmd_counter(void)
+{
+	struct target_cmd_counter *cmd_cnt;
+	int rc;
+
+	cmd_cnt = kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
+	if (!cmd_cnt)
+		return NULL;
 
-	wake_up(&sess->cmd_count_wq);
+	init_completion(&cmd_cnt->stop_done);
+	init_waitqueue_head(&cmd_cnt->refcnt_wq);
+	atomic_set(&cmd_cnt->stopped, 0);
+
+	rc = percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcnt, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto free_cmd_cnt;
+
+	return cmd_cnt;
+
+free_cmd_cnt:
+	kfree(cmd_cnt);
+	return NULL;
+}
+
+static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	/*
+	 * Drivers like loop do not call target_stop_session during session
+	 * shutdown so we have to drop the ref taken at init time here.
+	 */
+	if (!atomic_read(&cmd_cnt->stopped))
+		percpu_ref_put(&cmd_cnt->refcnt);
+
+	percpu_ref_exit(&cmd_cnt->refcnt);
 }
 
 /**
@@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	init_waitqueue_head(&se_sess->cmd_count_wq);
-	init_completion(&se_sess->stop_done);
-	atomic_set(&se_sess->stopped, 0);
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!se_sess->cmd_cnt)
+		return -ENOMEM;
+
+	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
-	/*
-	 * Drivers like iscsi and loop do not call target_stop_session
-	 * during session shutdown so we have to drop the ref taken at init
-	 * time here.
-	 */
-	if (!atomic_read(&se_sess->stopped))
-		percpu_ref_put(&se_sess->cmd_count);
-
-	percpu_ref_exit(&se_sess->cmd_count);
+	target_free_cmd_counter(se_sess->cmd_cnt);
 }
 
 /**
@@ -2970,9 +3000,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
-		ret = -ESHUTDOWN;
-
+	/*
+	 * Users like xcopy do not use counters since they never do a stop
+	 * and wait.
+	 */
+	if (se_sess->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+			ret = -ESHUTDOWN;
+		else
+			se_cmd->cmd_cnt = se_sess->cmd_cnt;
+	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
 
@@ -2993,7 +3030,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
 static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct target_cmd_counter *cmd_cnt = se_cmd->cmd_cnt;
 	struct completion *free_compl = se_cmd->free_compl;
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 
@@ -3004,7 +3041,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (abrt_compl)
 		complete(abrt_compl);
 
-	percpu_ref_put(&se_sess->cmd_count);
+	if (cmd_cnt)
+		percpu_ref_put(&cmd_cnt->refcnt);
 }
 
 /**
@@ -3123,46 +3161,65 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-static void target_stop_session_confirm(struct percpu_ref *ref)
+static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
+{
+	struct target_cmd_counter *cmd_cnt = container_of(ref,
+						struct target_cmd_counter,
+						refcnt);
+	complete_all(&cmd_cnt->stop_done);
+}
+
+/**
+ * target_stop_cmd_counter - Stop new IO from being added to the counter.
+ * @cmd_cnt: counter to stop
+ */
+static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
-	struct se_session *se_sess = container_of(ref, struct se_session,
-						  cmd_count);
-	complete_all(&se_sess->stop_done);
+	pr_debug("Stopping command counter.\n");
+	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
+		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
+					    target_stop_cmd_counter_confirm);
 }
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
- * @se_sess:    session to stop
+ * @se_sess: session to stop
  */
 void target_stop_session(struct se_session *se_sess)
 {
-	pr_debug("Stopping session queue.\n");
-	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) == 0)
-		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
-					    target_stop_session_confirm);
+	target_stop_cmd_counter(se_sess->cmd_cnt);
 }
 EXPORT_SYMBOL(target_stop_session);
 
 /**
- * target_wait_for_sess_cmds - Wait for outstanding commands
- * @se_sess:    session to wait for active I/O
+ * target_wait_for_cmds - Wait for outstanding cmds.
+ * @cmd_cnt: counter to wait for active I/O for.
  */
-void target_wait_for_sess_cmds(struct se_session *se_sess)
+static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
-	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
+	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
 		pr_debug("Waiting for running cmds to complete.\n");
-		ret = wait_event_timeout(se_sess->cmd_count_wq,
-				percpu_ref_is_zero(&se_sess->cmd_count),
-				180 * HZ);
+		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
+					 percpu_ref_is_zero(&cmd_cnt->refcnt),
+					 180 * HZ);
 	} while (ret <= 0);
 
-	wait_for_completion(&se_sess->stop_done);
+	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
+ * @se_sess: session to wait for active I/O
+ */
+void target_wait_for_sess_cmds(struct se_session *se_sess)
+{
+	target_wait_for_cmds(se_sess->cmd_cnt);
+}
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
 /*
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..229118156a1f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -600,6 +600,7 @@ struct iscsit_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsit_session	*sess;
+	struct target_cmd_counter *cmd_cnt;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..bd299790e99c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,6 +494,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
+	struct target_cmd_counter *cmd_cnt;
 	struct se_tmr_req	*se_tmr_req;
 	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
@@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
-struct se_session {
+struct target_cmd_counter {
+	struct percpu_ref	refcnt;
+	wait_queue_head_t	refcnt_wq;
+	struct completion	stop_done;
 	atomic_t		stopped;
+};
+
+struct se_session {
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	spinlock_t		sess_cmd_lock;
-	wait_queue_head_t	cmd_count_wq;
-	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct target_cmd_counter *cmd_cnt;
 };
 
 struct se_device;
-- 
2.25.1

