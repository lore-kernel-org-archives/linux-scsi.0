Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAC43ACB;
	Sat, 10 Aug 2024 09:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723282629; cv=none; b=AhW08oPskajU4BHL4emS4ySe7MxMNqMzA6s2kwugx8a0Be6RiHu17t6GFl+vvOQgYXUN9iM+zNdeAbnnLrELlRUn45ZmGpd1HnYHBLrbTyIj9dfzvmGwhZlAlgwqwQx3cFAxvJyexeTxu2IB8GxbUrDYoK4T55I9WJeSLMBYJS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723282629; c=relaxed/simple;
	bh=kB56kD/5z+M6WwPivevM45BfFeGz0ZSsLfLVcZSs9Z8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NqdhR4qw2nql3d4FLzb2wzqo9gnfp6mUvItPuaUYUsbqSzO+bXXi0cI47j7JuxiTX6c2zD9Ekq6s+AXCuVwvpaeWrEM8poWsQ0XagYDzCeqmtxNcIVrK8krVgk0IyJF9tl5BrTNzEQnS7GciCZJsqDa/fsr9QD4d8Ojd4jKA8gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wgwf738Rrzcd6S;
	Sat, 10 Aug 2024 17:36:47 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E8AB2180087;
	Sat, 10 Aug 2024 17:36:57 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 10 Aug
 2024 17:36:57 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <martin.petersen@oracle.com>, <yuehaibing@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: target: Remove unused declarations
Date: Sat, 10 Aug 2024 17:34:37 +0800
Message-ID: <20240810093437.2586476-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit 13247018d68f ("scsi: target: iscsi: Fix hang in the iSCSI login code")
removed iscsi_handle_login_thread_timeout() but leave declaration.
Commit 3e1c81a95f0d ("iscsi-target: Refactor RX PDU logic + export request PDU handling")
leave iscsi_target_get_initial_payload() declaration.
Commit d703ce2f7f4d ("iscsi/iser-target: Convert to command priv_size usage")
remove iscsit_alloc_cmd() but leave declaration.

And other declarations is never implenmented since introduction in commit
e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1").

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/target/iscsi/iscsi_target.h       | 2 --
 drivers/target/iscsi/iscsi_target_login.h | 1 -
 drivers/target/iscsi/iscsi_target_nego.h  | 2 --
 drivers/target/iscsi/iscsi_target_tpg.h   | 5 -----
 drivers/target/iscsi/iscsi_target_util.h  | 5 -----
 5 files changed, 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 0c997a08adec..873411e95ed2 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -15,7 +15,6 @@ struct kref;
 struct sockaddr_storage;
 
 extern struct iscsi_tiqn *iscsit_get_tiqn_for_login(unsigned char *);
-extern struct iscsi_tiqn *iscsit_get_tiqn(unsigned char *, int);
 extern void iscsit_put_tiqn_for_login(struct iscsi_tiqn *);
 extern struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *);
 extern void iscsit_del_tiqn(struct iscsi_tiqn *);
@@ -35,7 +34,6 @@ extern void iscsit_set_unsolicited_dataout(struct iscsit_cmd *);
 extern int iscsit_logout_closesession(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_logout_closeconnection(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_logout_removeconnforrecovery(struct iscsit_cmd *, struct iscsit_conn *);
-extern int iscsit_send_async_msg(struct iscsit_conn *, u16, u8, u8);
 extern int iscsit_build_r2ts_for_cmd(struct iscsit_conn *, struct iscsit_cmd *, bool recovery);
 extern void iscsit_thread_get_cpumask(struct iscsit_conn *);
 extern int iscsi_target_tx_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 3ca2f232b387..e8760735486b 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -24,6 +24,5 @@ extern int iscsit_start_kthreads(struct iscsit_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsit_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsit_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
-extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
 
 #endif   /*** ISCSI_TARGET_LOGIN_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/iscsi/iscsi_target_nego.h
index 41c3db3ddeaa..e60a46d34835 100644
--- a/drivers/target/iscsi/iscsi_target_nego.h
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -15,8 +15,6 @@ extern int extract_param(const char *, const char *, unsigned int, char *,
 		unsigned char *);
 extern int iscsi_target_check_login_request(struct iscsit_conn *,
 		struct iscsi_login *);
-extern int iscsi_target_get_initial_payload(struct iscsit_conn *,
-		struct iscsi_login *);
 extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsit_conn *,
 		struct iscsi_login *);
 extern int iscsi_target_start_negotiation(
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 71d067f62177..d44d09f2dde9 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -24,12 +24,7 @@ extern int iscsit_tpg_del_portal_group(struct iscsi_tiqn *, struct iscsi_portal_
 			int);
 extern int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *);
 extern int iscsit_tpg_disable_portal_group(struct iscsi_portal_group *, int);
-extern struct iscsi_node_acl *iscsit_tpg_add_initiator_node_acl(
-			struct iscsi_portal_group *, const char *, u32);
-extern void iscsit_tpg_del_initiator_node_acl(struct iscsi_portal_group *,
-			struct se_node_acl *);
 extern struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(struct iscsit_session *);
-extern void iscsit_tpg_del_external_nps(struct iscsi_tpg_np *);
 extern struct iscsi_tpg_np *iscsit_tpg_locate_child_np(struct iscsi_tpg_np *, int);
 extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi_portal_group *,
 			struct sockaddr_storage *, struct iscsi_tpg_np *,
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 24b8e577575a..336da4fb0a77 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -17,7 +17,6 @@ extern struct iscsi_r2t *iscsit_get_r2t_for_eos(struct iscsit_cmd *, u32, u32);
 extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsit_cmd *);
 extern void iscsit_free_r2t(struct iscsi_r2t *, struct iscsit_cmd *);
 extern void iscsit_free_r2ts_from_list(struct iscsit_cmd *);
-extern struct iscsit_cmd *iscsit_alloc_cmd(struct iscsit_conn *, gfp_t);
 extern struct iscsit_cmd *iscsit_allocate_cmd(struct iscsit_conn *, int);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_datain(struct iscsit_cmd *, u32);
 extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsit_cmd *);
@@ -34,7 +33,6 @@ extern void iscsit_add_cmd_to_immediate_queue(struct iscsit_cmd *, struct iscsit
 extern struct iscsi_queue_req *iscsit_get_cmd_from_immediate_queue(struct iscsit_conn *);
 extern int iscsit_add_cmd_to_response_queue(struct iscsit_cmd *, struct iscsit_conn *, u8);
 extern struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsit_conn *);
-extern void iscsit_remove_cmd_from_tx_queues(struct iscsit_cmd *, struct iscsit_conn *);
 extern bool iscsit_conn_all_queues_empty(struct iscsit_conn *);
 extern void iscsit_free_queue_reqs_for_conn(struct iscsit_conn *);
 extern void iscsit_release_cmd(struct iscsit_cmd *);
@@ -64,9 +62,6 @@ extern int iscsit_send_tx_data(struct iscsit_cmd *, struct iscsit_conn *, int);
 extern int iscsit_fe_sendpage_sg(struct iscsit_cmd *, struct iscsit_conn *);
 extern int iscsit_tx_login_rsp(struct iscsit_conn *, u8, u8);
 extern void iscsit_print_session_params(struct iscsit_session *);
-extern int iscsit_print_dev_to_proc(char *, char **, off_t, int);
-extern int iscsit_print_sessions_to_proc(char *, char **, off_t, int);
-extern int iscsit_print_tpg_to_proc(char *, char **, off_t, int);
 extern int rx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern int tx_data(struct iscsit_conn *, struct kvec *, int, int);
 extern void iscsit_collect_login_stats(struct iscsit_conn *, u8, u8);
-- 
2.34.1

