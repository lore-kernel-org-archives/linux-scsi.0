Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDB9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 08:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447378AbiAYIkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 03:40:46 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:52710 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451020AbiAYIim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2022 03:38:42 -0500
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 7E8BEC030E;
        Tue, 25 Jan 2022 16:38:22 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mingzhe.zou@easystack.cn
Subject: [PATCH] target: add iscsi/cpus_allowed_list in configfs
Date:   Tue, 25 Jan 2022 16:38:21 +0800
Message-Id: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJJGktWSBgdSxhKTx5KSk
        lNVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDo6FDo5QzIwLyoOHygwOT0M
        PhIwFE1VSlVKTU9IS0JCQktISk1LVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTEpMSDcG
X-HM-Tid: 0a7e9062d3a5841ekuqw7e8bec030e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

The RX/TX threads for iSCSI connection can be scheduled to
any online cpus, and will not be rescheduled.

If bind other heavy load threads with iSCSI connection
RX/TX thread to the same cpu, the iSCSI performance will
be worse.

This patch add iscsi/cpus_allowed_list in configfs. The
available cpus set of iSCSI connection RX/TX threads is
allowed_cpus & online_cpus. If it is modified, all RX/TX
threads will be rescheduled.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/target/iscsi/iscsi_target.c          | 21 ++++++++++--
 drivers/target/iscsi/iscsi_target.h          | 17 ++++++++++
 drivers/target/iscsi/iscsi_target_configfs.c | 34 ++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_login.c    |  7 ++++
 include/target/iscsi/iscsi_target_core.h     |  1 +
 5 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2c54c5d8412d..a18d3fc3cfd1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -693,6 +693,11 @@ static int __init iscsi_target_init_module(void)
 	mutex_init(&auth_id_lock);
 	idr_init(&tiqn_idr);
 
+	/*
+	 * allow all cpus run iscsi_ttx and iscsi_trx
+	 */
+	cpumask_setall(&__iscsi_allowed_cpumask);
+
 	ret = target_register_template(&iscsi_ops);
 	if (ret)
 		goto out;
@@ -3587,6 +3592,15 @@ static int iscsit_send_reject(
 void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 {
 	int ord, cpu;
+	cpumask_t conn_allowed_cpumask;
+
+	/*
+	 * The available cpus set of iSCSI connection's RX/TX threads
+	 */
+	cpumask_and(&conn_allowed_cpumask,
+		&__iscsi_allowed_cpumask,
+		cpu_online_mask);
+
 	/*
 	 * bitmap_id is assigned from iscsit_global->ts_bitmap from
 	 * within iscsit_start_kthreads()
@@ -3595,8 +3609,9 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
 	 * iSCSI connection's RX/TX threads will be scheduled to
 	 * execute upon.
 	 */
-	ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
-	for_each_online_cpu(cpu) {
+	cpumask_clear(conn->conn_cpumask);
+	ord = conn->bitmap_id % cpumask_weight(&conn_allowed_cpumask);
+	for_each_cpu(cpu, &conn_allowed_cpumask) {
 		if (ord-- == 0) {
 			cpumask_set_cpu(cpu, conn->conn_cpumask);
 			return;
@@ -3821,6 +3836,7 @@ int iscsi_target_tx_thread(void *arg)
 		 * Ensure that both TX and RX per connection kthreads
 		 * are scheduled to run on the same CPU.
 		 */
+		iscsit_thread_reschedule(conn);
 		iscsit_thread_check_cpumask(conn, current, 1);
 
 		wait_event_interruptible(conn->queues_wq,
@@ -3966,6 +3982,7 @@ static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
 		 * Ensure that both TX and RX per connection kthreads
 		 * are scheduled to run on the same CPU.
 		 */
+		iscsit_thread_reschedule(conn);
 		iscsit_thread_check_cpumask(conn, current, 0);
 
 		memset(&iov, 0, sizeof(struct kvec));
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index b35a96ded9c1..cb97a316d76d 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -57,4 +57,21 @@ extern struct kmem_cache *lio_r2t_cache;
 extern struct ida sess_ida;
 extern struct mutex auth_id_lock;
 
+extern cpumask_t __iscsi_allowed_cpumask;
+
+static inline void iscsit_thread_reschedule(struct iscsi_conn *conn)
+{
+	/*
+	 * If __iscsi_allowed_cpumask modified, reschedule iSCSI connection's
+	 * RX/TX threads update conn->allowed_cpumask.
+	 */
+	if (!cpumask_equal(&__iscsi_allowed_cpumask, conn->allowed_cpumask)) {
+		iscsit_thread_get_cpumask(conn);
+		conn->conn_tx_reset_cpumask = 1;
+		conn->conn_rx_reset_cpumask = 1;
+		cpumask_copy(conn->allowed_cpumask,
+			&__iscsi_allowed_cpumask);
+	}
+}
+
 #endif   /*** ISCSI_TARGET_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 2a9de24a8bbe..dc12b1695838 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1127,8 +1127,42 @@ static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
 
 CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
 
+cpumask_t __iscsi_allowed_cpumask;
+
+static ssize_t lio_target_wwn_cpus_allowed_list_show(
+		struct config_item *item, char *page)
+{
+	return sprintf(page, "%*pbl\n",
+		cpumask_pr_args(&__iscsi_allowed_cpumask));
+}
+
+static ssize_t lio_target_wwn_cpus_allowed_list_store(
+		struct config_item *item, const char *page, size_t count)
+{
+	int ret;
+	char *orig;
+	cpumask_t new_allowed_cpumask;
+
+	orig = kstrdup(page, GFP_KERNEL);
+	if (!orig)
+		return -ENOMEM;
+
+	cpumask_clear(&new_allowed_cpumask);
+	ret = cpulist_parse(orig, &new_allowed_cpumask);
+
+	kfree(orig);
+	if (ret != 0)
+		return ret;
+
+	cpumask_copy(&__iscsi_allowed_cpumask, &new_allowed_cpumask);
+	return count;
+}
+
+CONFIGFS_ATTR(lio_target_wwn_, cpus_allowed_list);
+
 static struct configfs_attribute *lio_target_wwn_attrs[] = {
 	&lio_target_wwn_attr_lio_version,
+	&lio_target_wwn_attr_cpus_allowed_list,
 	NULL,
 };
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1a9c50401bdb..910f35e4648a 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1129,8 +1129,15 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
 		goto free_conn_ops;
 	}
 
+	if (!zalloc_cpumask_var(&conn->allowed_cpumask, GFP_KERNEL)) {
+		pr_err("Unable to allocate conn->allowed_cpumask\n");
+		goto free_conn_cpumask;
+	}
+
 	return conn;
 
+free_conn_cpumask:
+	free_cpumask_var(conn->allowed_cpumask);
 free_conn_ops:
 	kfree(conn->conn_ops);
 put_transport:
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 1eccb2ac7d02..c5e9cad187cf 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -580,6 +580,7 @@ struct iscsi_conn {
 	struct ahash_request	*conn_tx_hash;
 	/* Used for scheduling TX and RX connection kthreads */
 	cpumask_var_t		conn_cpumask;
+	cpumask_var_t		allowed_cpumask;
 	unsigned int		conn_rx_reset_cpumask:1;
 	unsigned int		conn_tx_reset_cpumask:1;
 	/* list_head of struct iscsi_cmd for this connection */
-- 
2.17.1

