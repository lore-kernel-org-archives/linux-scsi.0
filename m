Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5845C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbiHCQbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238455AbiHCQaY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:24 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3405A4D4C2;
        Wed,  3 Aug 2022 09:30:03 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9EA7B412F7;
        Wed,  3 Aug 2022 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544199; x=1661358600; bh=7RN/zxZr+Ny4BQZWDFA8hJi+M
        a8n+gx9BFIwRKD77sU=; b=hONNWuWrG0oZD8oVwh0p09z+fzezas0wM8ojUrQvY
        uJQWPS9iLRBezVvZ8dTIbFgigiK0J2LPgpEd1NgVak4bs2IQehH19V1uH5cggu2y
        lAGxAzcrGQ6MAIpC7/aaX3jMXQVyrh0HP+aGFj5I1sDJh489HGyXZgZmUZRxbOCH
        eA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hN1wkk2GzYSa; Wed,  3 Aug 2022 19:29:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 368EA412CC;
        Wed,  3 Aug 2022 19:29:23 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:23 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:22 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 38/48] target: cluster: store PR data in DLM cluster
Date:   Mon, 29 Nov 2021 12:00:46 +0300
Message-ID: <20220803162857.27770-39-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Follow the sequence bellow to sync all PR data throughout nodes in
cluster:

	pr_lock()
	Handle PR OUT locally
	if (success)
		pr_sync()
	pr_unlock()

where pr_sync() is a synchronical function.
That will garantee an atomic update of PR data in a cluster.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c     | 247 +++++++++++++++++++++++-
 drivers/target/target_core_device.c     |   8 +
 drivers/target/target_core_fabric_lib.c |   1 +
 drivers/target/target_core_internal.h   |   2 -
 drivers/target/target_core_pr.c         |   7 +
 include/target/target_core_base.h       |   6 +
 6 files changed, 268 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 2edae188811d..14465764eaaf 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -5,12 +5,21 @@
 #include <linux/module.h>
 #include <linux/configfs.h>
 #include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include <target/target_core_backend.h>
+#include "target_core_pr.h"
 
 #include "dlm_ckv.h"
 
 struct target_cluster_data {
 	struct dlm_ckv_bucket *bucket;
 	u32 local_nodeid;
+	struct mutex pr_lock_mutex;
+	struct dlm_ckv_lock *pr_lock;
+	struct dlm_ckv_kv *pr_data;
+	int reserved_node_id;
+	struct dlm_ckv_kv **pr_reg_kv;
+	size_t pr_reg_kv_len;
 };
 
 struct target_lksb {
@@ -60,6 +69,44 @@ static const struct config_item_type ci_cluster_config = {
 };
 
 static struct target_cluster_config cluster_cfg;
+struct pr_lvb {
+	u32	nr_registrants;
+	u32	pr_generation;
+	u8	version;
+	u8	pr_is_set;
+	u8	pr_type;
+	u8	pr_scope;
+	u8	pr_aptpl;
+	u8	reserved[3];
+	u32	reserved_by_nodeid;
+};
+
+struct pr_reg_lvb {
+	u64	key;
+	u16	rtpi;
+	u8	version;
+	u8	is_holder;
+	u8	is_all_tg_pt;
+	u8	tid[PR_REG_TID_LEN];
+} __packed ; /* to fit in 256 bytes */
+
+struct async_group {
+	refcount_t pending;
+	atomic_t status;
+	struct completion compl;
+};
+
+static int pr_reg_realloc(struct target_cluster_data *cluster_data,
+			  size_t nr_registrants);
+
+static void group_compl_cb(void *arg, int res)
+{
+	struct async_group *grp = arg;
+
+	atomic_cmpxchg(&grp->status, 0, res);
+	if (refcount_dec_and_test(&grp->pending))
+		complete(&grp->compl);
+}
 
 static int target_init_dlm(struct se_device *dev)
 {
@@ -68,6 +115,7 @@ static int target_init_dlm(struct se_device *dev)
 	int err = 0;
 
 	BUG_ON(dev->cluster_data);
+	BUILD_BUG_ON(sizeof(struct pr_reg_lvb) > DLM_CKV_VALUE_MAX_SIZE);
 
 	snprintf(ls_name, sizeof(ls_name), "%s%s",
 			       dev->t10_wwn.model, dev->t10_wwn.unit_serial);
@@ -85,16 +133,42 @@ static int target_init_dlm(struct se_device *dev)
 		dev->cluster_data = NULL;
 		return err;
 	}
+
+	mutex_init(&cluster_data->pr_lock_mutex);
+	cluster_data->pr_lock = dlm_ckv_create_lock(cluster_data->bucket, "pr_lock");
+	if (!cluster_data->pr_lock)
+		goto fail;
+
+	cluster_data->pr_data = dlm_ckv_create_kv(cluster_data->bucket, "pr_data");
+	if (!cluster_data->pr_data)
+		goto fail;
+
 	dev->cluster_data = cluster_data;
 
 	return err;
+fail:
+	if (cluster_data->pr_lock)
+		dlm_ckv_free_lock(cluster_data->pr_lock);
+	if (cluster_data->pr_data)
+		dlm_ckv_free_kv(cluster_data->pr_data);
+	dlm_ckv_close_bucket(cluster_data->bucket);
+	kfree(cluster_data);
+	return -EIO;
 }
 
 static int target_cleanup_dlm(struct se_device *dev)
 {
 	struct target_cluster_data *cluster_data = dev->cluster_data;
 	int res;
+	int i;
+
+	for (i = 0; i < cluster_data->pr_reg_kv_len; i++)
+		if (cluster_data->pr_reg_kv[i])
+			dlm_ckv_free_kv(cluster_data->pr_reg_kv[i]);
+	kfree(cluster_data->pr_reg_kv);
 
+	dlm_ckv_free_lock(cluster_data->pr_lock);
+	dlm_ckv_free_kv(cluster_data->pr_data);
 	res = dlm_ckv_close_bucket(cluster_data->bucket);
 	if (res)
 		pr_err("TARGET_CORE[%d]:  closing bucket failed: %d\n",
@@ -142,7 +216,175 @@ static int target_caw_unlock_dlm(struct se_device *dev, void *lock)
 	return res;
 }
 
-struct target_cluster_ops dlm_cluster_ops = {
+static int target_pr_lock_dlm(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	int res = -ENOMEM;
+
+	mutex_lock(&cluster_data->pr_lock_mutex);
+	res = dlm_ckv_lock_get(cluster_data->pr_lock);
+	if (res) {
+		pr_warn("target_dlm_lock_wait failed with %d\n", res);
+		mutex_unlock(&cluster_data->pr_lock_mutex);
+	}
+
+	return res;
+}
+
+static int target_pr_unlock_dlm(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	int res;
+
+	res = dlm_ckv_lock_release(cluster_data->pr_lock);
+	mutex_unlock(&cluster_data->pr_lock_mutex);
+
+	return res;
+}
+
+static int target_get_nr_registrants(struct se_device *dev)
+{
+	struct t10_pr_registration *pr_reg;
+	int count = 0;
+
+	list_for_each_entry(pr_reg,
+			&dev->t10_pr.registration_list, pr_reg_list)
+		count++;
+
+	return count;
+}
+
+static int pr_reg_realloc(struct target_cluster_data *cluster_data,
+			  size_t nr_registrants)
+{
+	char key_name[16];
+	void *p;
+	int res = 0;
+	int i;
+
+	if (nr_registrants > cluster_data->pr_reg_kv_len) {
+		p = krealloc(cluster_data->pr_reg_kv,
+			     nr_registrants * sizeof(struct dlm_ckv_kv *),
+			     GFP_KERNEL | __GFP_ZERO);
+		if (!p) {
+			res = -ENOMEM;
+			goto done;
+		}
+		cluster_data->pr_reg_kv = p;
+		for (i = cluster_data->pr_reg_kv_len;
+		     i < nr_registrants; i++) {
+			snprintf(key_name, sizeof(key_name), "pr_reg.%d", i);
+			if (!cluster_data->pr_reg_kv[i])
+				cluster_data->pr_reg_kv[i] = dlm_ckv_create_kv(
+								cluster_data->bucket,
+								key_name);
+			if (!cluster_data->pr_reg_kv[i]) {
+				res = -ENOMEM;
+				goto fail_create;
+			}
+		}
+		cluster_data->pr_reg_kv_len = nr_registrants;
+	}
+done:
+	return res;
+fail_create:
+	/* free newly created objects */
+	for (i = cluster_data->pr_reg_kv_len;
+	     i < nr_registrants; i++) {
+		if (!cluster_data->pr_reg_kv[i])
+			dlm_ckv_free_kv(cluster_data->pr_reg_kv[i]);
+	}
+	return res;
+}
+
+static int target_pr_sync_dlm(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	struct t10_pr_registration *pr_reg;
+	struct pr_reg_lvb pr_reg_data;
+	struct async_group grp;
+	struct pr_lvb pr_data;
+	int i = 0;
+	int res;
+
+	spin_lock(&dev->t10_pr.registration_lock);
+
+	pr_data.version = 1;
+	pr_data.pr_generation = atomic_read(&dev->t10_pr.pr_generation);
+	pr_data.nr_registrants = target_get_nr_registrants(dev);
+	pr_data.pr_is_set = !!dev->dev_pr_res_holder;
+	pr_data.pr_aptpl = dev->t10_pr.pr_aptpl_active;
+	if (dev->dev_pr_res_holder) {
+		pr_data.pr_type = dev->dev_pr_res_holder->pr_res_type;
+		pr_data.pr_scope = dev->dev_pr_res_holder->pr_res_scope;
+	}
+	pr_data.reserved_by_nodeid = cluster_data->reserved_node_id;
+
+	spin_unlock(&dev->t10_pr.registration_lock);
+
+	res = dlm_ckv_set(cluster_data->pr_data, (char *)&pr_data,
+			  sizeof(pr_data));
+	if (res)
+		goto done;
+
+
+	res = pr_reg_realloc(cluster_data, pr_data.nr_registrants);
+	if (res)
+		goto done;
+
+	if (pr_data.nr_registrants == 0)
+		goto skip_pr_reg;
+
+	refcount_set(&grp.pending, 1); /* 1 for a loop */
+	atomic_set(&grp.status, 0);
+	init_completion(&grp.compl);
+
+	list_for_each_entry(pr_reg,
+			&dev->t10_pr.registration_list, pr_reg_list) {
+
+		pr_reg_data.key = pr_reg->pr_res_key;
+		pr_reg_data.rtpi = pr_reg->tg_pt_sep_rtpi;
+		pr_reg_data.version = 1;
+		pr_reg_data.is_holder = pr_reg->pr_res_holder;
+		pr_reg_data.is_all_tg_pt = !!pr_reg->pr_reg_all_tg_pt;
+		target_get_pr_transport_id(pr_reg, pr_reg_data.tid);
+
+		refcount_inc(&grp.pending);
+		res = dlm_ckv_set_async(cluster_data->pr_reg_kv[i],
+					(char *)&pr_reg_data,
+					sizeof(pr_reg_data),
+					group_compl_cb,
+					&grp);
+		if (res) {
+			pr_err("TARGET_CORE[%d]: set pr_reg_%d failed: %d\n",
+			       dev->dev_index, i, res);
+			refcount_dec(&grp.pending);
+			break;
+		}
+		i++;
+	}
+	group_compl_cb(&grp, 0);
+	res = wait_for_completion_timeout(&grp.compl, 60 * HZ);
+	if (!res) {
+		pr_err("TARGET_CORE[%d]: timeout of waiting for dlm_ckv_set_async\n",
+			dev->dev_index);
+		goto done;
+	}
+	res = atomic_read(&grp.status);
+	if (res) {
+		pr_err("TARGET_CORE[%d]: fail of group for dlm_ckv_set_async %d\n",
+			dev->dev_index, res);
+		goto done;
+	}
+
+skip_pr_reg:
+
+done:
+
+	return res;
+}
+
+const struct target_cluster_ops dlm_cluster_ops = {
 	.name = "dlm",
 	.owner = THIS_MODULE,
 	.cg_group = &cluster_cfg.cg_group,
@@ -151,6 +393,9 @@ struct target_cluster_ops dlm_cluster_ops = {
 	.cleanup = target_cleanup_dlm,
 	.caw_lock = target_caw_lock_dlm,
 	.caw_unlock = target_caw_unlock_dlm,
+	.pr_lock = target_pr_lock_dlm,
+	.pr_unlock = target_pr_unlock_dlm,
+	.pr_sync = target_pr_sync_dlm,
 };
 
 static int __init target_cluster_dlm_module_init(void)
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 9c7f4dc1b85d..f5da3fc17ad1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -782,6 +782,11 @@ static int target_caw_unlock_nodlm(struct se_device *dev, void *lock)
 	return 0;
 }
 
+int target_dummy_nodlm(struct se_device *dev)
+{
+	return 0;
+}
+
 const struct target_cluster_ops nodlm_cluster_ops = {
 	.name = "single",
 	.owner = NULL,
@@ -789,6 +794,9 @@ const struct target_cluster_ops nodlm_cluster_ops = {
 	.cleanup = target_cleanup_nodlm,
 	.caw_lock = target_caw_lock_nodlm,
 	.caw_unlock = target_caw_unlock_nodlm,
+	.pr_lock = target_dummy_nodlm,
+	.pr_unlock = target_dummy_nodlm,
+	.pr_sync = target_dummy_nodlm,
 };
 
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 0eb03d7b9e78..8232d872db35 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -382,6 +382,7 @@ int target_get_pr_transport_id(
 
 	return  len;
 }
+EXPORT_SYMBOL(target_get_pr_transport_id);
 
 int target_cmp_pr_transport_id(
 		struct t10_pr_registration *pr_reg,
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 58261c716776..8669ff6f48e9 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -107,8 +107,6 @@ int	target_fabric_setup_cits(struct target_fabric_configfs *);
 
 /* target_core_fabric_lib.c */
 int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg);
-int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
-				   unsigned char *buf);
 int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
 			       unsigned char *tid);
 int target_gen_pr_transport_id(struct t10_pr_registration *pr_reg,
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a984987f0a82..a9fe192f5fe4 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3560,6 +3560,8 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->cl_ops->pr_lock(dev))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3598,9 +3600,14 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	default:
 		pr_err("Unknown PERSISTENT_RESERVE_OUT service"
 			" action: 0x%02x\n", sa);
+		dev->cl_ops->pr_unlock(dev);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+	if (!ret)
+		dev->cl_ops->pr_sync(dev);
+	dev->cl_ops->pr_unlock(dev);
+
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fbeb4777654b..9edf3c1ac204 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -787,6 +787,9 @@ struct target_cluster_ops {
 	int (*cleanup)(struct se_device *dev);
 	void *(*caw_lock)(struct se_device *dev, u64 lba);
 	int (*caw_unlock)(struct se_device *dev, void *lock);
+	int (*pr_lock)(struct se_device *dev);
+	int (*pr_unlock)(struct se_device *dev);
+	int (*pr_sync)(struct se_device *dev);
 };
 
 struct se_device {
@@ -999,4 +1002,7 @@ static inline void target_free_tag(struct se_session *sess, struct se_cmd *cmd)
 int target_cluster_impl_register(const struct target_cluster_ops *ops);
 void target_cluster_impl_unregister(const struct target_cluster_ops *ops);
 
+int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
+				   unsigned char *buf);
+
 #endif /* TARGET_CORE_BASE_H */
-- 
2.25.1

