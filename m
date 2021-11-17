Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C016DC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiHCQa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiHCQ37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:59 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9737A48E8A;
        Wed,  3 Aug 2022 09:29:53 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 10BE64131D;
        Wed,  3 Aug 2022 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544189; x=1661358590; bh=1/lLGStKju420GDKs/ya8qKkM
        bEQG4z1qGKFPfh/mR4=; b=TKX4M9Beo0i6jkWkGtjBbsMSP5c42IvwVW+D//+ES
        NM71mAWzoX3NIUkhl49ArInMZ97z/CfchUNqaVi/SK5xQfkKEMeShwcEoHpK0dbO
        pPfuF+5T9i47bf//8c74y4zfAtA6RGzTFAyw8uHZmiI/bu9CwrXt+qVJXNWhIJV3
        7I=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j2pcoCGPdKTC; Wed,  3 Aug 2022 19:29:49 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id AB8A5412ED;
        Wed,  3 Aug 2022 19:29:22 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:22 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:21 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 36/48] target: cluster: introduce cluster ops
Date:   Wed, 17 Nov 2021 14:12:29 +0300
Message-ID: <20220803162857.27770-37-d.bogdanov@yadro.com>
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

Introduce cluster ops common for all backend devices. Those ops
will implement cluster level locks, store clusterwide data (like
persistent reservations) and provide clusterwide notifications.
That ops could be registered dynamically. Ops have own configfs folder
in .../target/cluster/<cluster_impl_name>

Create default non-cluster ops implementation.

Use cluster ops for CAW lock.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_configfs.c |  63 +++++++++++-
 drivers/target/target_core_device.c   | 139 +++++++++++++++++++++++++-
 drivers/target/target_core_internal.h |   8 ++
 drivers/target/target_core_sbc.c      |  12 +--
 include/target/target_core_base.h     |  18 ++++
 5 files changed, 232 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f63c37344104..6c36b1f4bd92 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -69,6 +69,7 @@ static LIST_HEAD(g_tf_list);
 static DEFINE_MUTEX(g_tf_lock);
 
 static struct config_group target_core_hbagroup;
+static struct config_group *target_core_cluster_group;
 static struct config_group alua_group;
 static struct config_group alua_lu_gps_group;
 
@@ -1193,6 +1194,32 @@ static ssize_t pgr_support_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t cluster_impl_show(struct config_item *item, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%s\n",
+			to_attrib(item)->da_dev->cl_ops->name);
+}
+
+static ssize_t cluster_impl_store(struct config_item *item,
+				  const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	char cluster_impl[16];
+	int res;
+
+	strscpy(cluster_impl, page, 16);
+	if (cluster_impl[strlen(cluster_impl) - 1] == '\n')
+		cluster_impl[strlen(cluster_impl) - 1] = 0;
+
+	res = core_dev_set_cluster_mode(dev, cluster_impl);
+	if (res)
+		return res;
+
+	return count;
+}
+CONFIGFS_ATTR(, cluster_impl);
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1268,6 +1295,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_max_write_same_len,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_cluster_impl,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
@@ -3615,6 +3643,38 @@ static const struct config_item_type target_core_cit = {
 
 /* Stop functions for struct config_item_type target_core_hba_cit */
 
+static const struct config_item_type target_core_cluster_cit = {
+	.ct_owner	= THIS_MODULE,
+};
+
+int target_core_register_cluster_configfs(struct target_cluster_impl *tci)
+{
+	int ret = 0;
+
+	if (!target_core_cluster_group) {
+		target_core_cluster_group = configfs_register_default_group(
+					&target_core_fabrics.su_group,
+					"cluster",
+					&target_core_cluster_cit);
+		if (IS_ERR(target_core_cluster_group)) {
+			ret = PTR_ERR(target_core_cluster_group);
+			pr_err("Error %d while registering cluster group\n", ret);
+			goto err;
+		}
+	}
+
+	ret = configfs_register_group(target_core_cluster_group,
+				      tci->ops->cg_group);
+
+err:
+	return ret;
+}
+
+void target_core_unregister_cluster_configfs(struct target_cluster_impl *tci)
+{
+	configfs_unregister_group(tci->ops->cg_group);
+}
+
 void target_setup_backend_cits(struct target_backend *tb)
 {
 	target_core_setup_dev_cit(tb);
@@ -3749,7 +3809,8 @@ static void __exit target_core_exit_configfs(void)
 	configfs_remove_default_groups(&alua_lu_gps_group);
 	configfs_remove_default_groups(&alua_group);
 	configfs_remove_default_groups(&target_core_hbagroup);
-
+	if (target_core_cluster_group)
+		configfs_remove_default_groups(target_core_cluster_group);
 	/*
 	 * We expect subsys->su_group.default_groups to be released
 	 * by configfs subsystem provider logic..
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7c887792bb88..9c7f4dc1b85d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -44,6 +44,77 @@ static struct se_hba *lun0_hba;
 /* not static, needed by tpg.c */
 struct se_device *g_lun0_dev;
 
+static LIST_HEAD(cluster_impl_list);
+static DEFINE_MUTEX(cluster_impl_mutex);
+
+int target_cluster_impl_register(const struct target_cluster_ops *ops)
+{
+	struct target_cluster_impl *tci, *old;
+
+	tci = kzalloc(sizeof(*tci), GFP_KERNEL);
+	if (!tci)
+		return -ENOMEM;
+	tci->ops = ops;
+
+	mutex_lock(&cluster_impl_mutex);
+	list_for_each_entry(old, &cluster_impl_list, list) {
+		if (!strcmp(old->ops->name, ops->name)) {
+			pr_err("Target cluster implementation %s already registered.\n",
+			       ops->name);
+			mutex_unlock(&cluster_impl_mutex);
+			kfree(tci);
+			return -EEXIST;
+		}
+	}
+
+	target_core_register_cluster_configfs(tci);
+
+	list_add_tail(&tci->list, &cluster_impl_list);
+	mutex_unlock(&cluster_impl_mutex);
+
+	pr_debug("TCM: Registered cluster plugin: %s struct module: %p\n",
+			ops->name, ops->owner);
+	return 0;
+}
+EXPORT_SYMBOL(target_cluster_impl_register);
+
+void target_cluster_impl_unregister(const struct target_cluster_ops *ops)
+{
+	struct target_cluster_impl *tci;
+
+	mutex_lock(&cluster_impl_mutex);
+	list_for_each_entry(tci, &cluster_impl_list, list) {
+		if (tci->ops == ops) {
+			list_del(&tci->list);
+			target_core_unregister_cluster_configfs(tci);
+			mutex_unlock(&cluster_impl_mutex);
+			kfree(tci);
+			return;
+		}
+	}
+	mutex_unlock(&cluster_impl_mutex);
+}
+EXPORT_SYMBOL(target_cluster_impl_unregister);
+
+static struct target_cluster_impl *core_get_cluster_impl(const char *name)
+{
+	struct target_cluster_impl *tci;
+
+	mutex_lock(&cluster_impl_mutex);
+	list_for_each_entry(tci, &cluster_impl_list, list) {
+		if (!strcmp(tci->ops->name, name))
+			goto found;
+	}
+	mutex_unlock(&cluster_impl_mutex);
+	return NULL;
+found:
+	if (tci->ops->owner && !try_module_get(tci->ops->owner))
+		tci = NULL;
+	mutex_unlock(&cluster_impl_mutex);
+	return tci;
+}
+
+
 sense_reason_t
 transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 {
@@ -686,6 +757,40 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	pr_debug("  Type:   %s ", scsi_device_type(device_type));
 }
 
+static int target_init_nodlm(struct se_device *dev)
+{
+	sema_init(&dev->caw_sem, 1);
+
+	return 0;
+}
+
+static int target_cleanup_nodlm(struct se_device *dev)
+{
+	return 0;
+}
+
+static void *target_caw_lock_nodlm(struct se_device *dev, u64 lba)
+{
+	if (down_interruptible(&dev->caw_sem))
+		return NULL;
+	return &dev->caw_sem;
+}
+
+static int target_caw_unlock_nodlm(struct se_device *dev, void *lock)
+{
+	up(&dev->caw_sem);
+	return 0;
+}
+
+const struct target_cluster_ops nodlm_cluster_ops = {
+	.name = "single",
+	.owner = NULL,
+	.init = target_init_nodlm,
+	.cleanup = target_cleanup_nodlm,
+	.caw_lock = target_caw_lock_nodlm,
+	.caw_unlock = target_caw_unlock_nodlm,
+};
+
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct se_device *dev;
@@ -729,7 +834,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->se_port_lock);
 	spin_lock_init(&dev->se_tmr_lock);
 	spin_lock_init(&dev->qf_cmd_lock);
-	sema_init(&dev->caw_sem, 1);
 	INIT_LIST_HEAD(&dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&dev->t10_pr.registration_list);
@@ -779,6 +883,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 
+	dev->cl_ops = &nodlm_cluster_ops;
+	dev->cl_ops->init(dev);
+
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
 	init_completion(&xcopy_lun->lun_shutdown_comp);
@@ -987,6 +1094,9 @@ void target_free_device(struct se_device *dev)
 
 	WARN_ON(!list_empty(&dev->dev_sep_list));
 
+	dev->cl_ops->cleanup(dev);
+	module_put(dev->cl_ops->owner);
+
 	if (target_dev_configured(dev)) {
 		dev->transport->destroy_device(dev);
 
@@ -1058,6 +1168,33 @@ void core_dev_release_virtual_lun0(void)
 	core_delete_hba(hba);
 }
 
+int core_dev_set_cluster_mode(struct se_device *dev, const char *cluster_impl)
+{
+	int ret = 0;
+
+	struct target_cluster_impl *tci = core_get_cluster_impl(cluster_impl);
+
+	if (!tci)
+		return -EINVAL;
+
+	if (dev->cl_ops != tci->ops) {
+		ret = dev->cl_ops->cleanup(dev);
+		if (ret)
+			pr_err("cluster cleanup failed with %d\n", ret);
+
+		ret = tci->ops->init(dev);
+		if (ret)
+			pr_err("cluster init failed with %d\n", ret);
+
+		module_put(dev->cl_ops->owner);
+		dev->cl_ops = tci->ops;
+	} else {
+		module_put(tci->ops->owner);
+	}
+
+	return ret;
+}
+
 /*
  * Common CDB parsing for kernel and user passthrough.
  */
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index b0d29c30ab1e..58261c716776 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -55,6 +55,11 @@ struct target_fabric_configfs {
 	struct config_item_type tf_tpg_mappedlun_stat_cit;
 };
 
+struct target_cluster_impl {
+	const struct target_cluster_ops *ops;
+	struct list_head list;
+};
+
 /* target_core_alua.c */
 extern struct t10_alua_lu_gp *default_lu_gp;
 
@@ -83,6 +88,7 @@ void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *lacl);
 int	core_dev_setup_virtual_lun0(void);
 void	core_dev_release_virtual_lun0(void);
+int	core_dev_set_cluster_mode(struct se_device *dev, const char *cluster_impl);
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name);
 int	target_configure_device(struct se_device *dev);
 void	target_free_device(struct se_device *);
@@ -93,6 +99,8 @@ void	target_dev_ua_allocate(struct se_device *dev, u8 asc, u8 ascq);
 /* target_core_configfs.c */
 extern struct configfs_item_operations target_core_dev_item_ops;
 void	target_setup_backend_cits(struct target_backend *);
+int	target_core_register_cluster_configfs(struct target_cluster_impl *tci);
+void	target_core_unregister_cluster_configfs(struct target_cluster_impl *tci);
 
 /* target_core_fabric_configfs.c */
 int	target_fabric_setup_cits(struct target_fabric_configfs *);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 786ca58008b0..ab2038a510c0 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -367,7 +367,7 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
 	 * before the original READ I/O submission.
 	 */
-	up(&dev->caw_sem);
+	dev->cl_ops->caw_unlock(dev, cmd->cawlock);
 
 	return ret;
 }
@@ -550,7 +550,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * In the MISCOMPARE or failure case, unlock ->caw_sem obtained in
 	 * sbc_compare_and_write() before the original READ I/O submission.
 	 */
-	up(&dev->caw_sem);
+	dev->cl_ops->caw_unlock(dev, cmd->cawlock);
 	sg_free_table(&write_tbl);
 	return ret;
 }
@@ -561,13 +561,13 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	struct sbc_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
-	int rc;
+
 	/*
 	 * Submit the READ first for COMPARE_AND_WRITE to perform the
 	 * comparision using SGLs at cmd->t_bidi_data_sg..
 	 */
-	rc = down_interruptible(&dev->caw_sem);
-	if (rc != 0) {
+	cmd->cawlock = dev->cl_ops->caw_lock(dev, cmd->t_task_lba);
+	if (!cmd->cawlock) {
 		cmd->transport_complete_callback = NULL;
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -582,7 +582,7 @@ sbc_compare_and_write(struct se_cmd *cmd)
 			      DMA_FROM_DEVICE);
 	if (ret) {
 		cmd->transport_complete_callback = NULL;
-		up(&dev->caw_sem);
+		dev->cl_ops->caw_unlock(dev, cmd->cawlock);
 		return ret;
 	}
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5378e2d3825f..fbeb4777654b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -546,6 +546,7 @@ struct se_cmd {
 	 * initialized on. Drivers can override.
 	 */
 	int			cpuid;
+	void			*cawlock;
 };
 
 struct se_ua {
@@ -777,6 +778,17 @@ struct se_device_queue {
 	struct se_cmd_queue	sq;
 };
 
+struct target_cluster_ops {
+	char name[16];
+	struct module *owner;
+	struct config_group *cg_group;
+
+	int (*init)(struct se_device *dev);
+	int (*cleanup)(struct se_device *dev);
+	void *(*caw_lock)(struct se_device *dev, u64 lba);
+	int (*caw_unlock)(struct se_device *dev, void *lock);
+};
+
 struct se_device {
 	/* Used for SAM Task Attribute ordering */
 	u32			dev_cur_ordered_id;
@@ -847,6 +859,9 @@ struct se_device {
 	unsigned char		udev_path[SE_UDEV_PATH_LEN];
 	/* Pointer to template of function pointers for transport */
 	const struct target_backend_ops *transport;
+	/* Pointer to template of function pointers for cluster mode */
+	const struct target_cluster_ops *cl_ops;
+	void			*cluster_data;
 	struct se_lun		xcopy_lun;
 	/* Protection Information */
 	int			prot_length;
@@ -981,4 +996,7 @@ static inline void target_free_tag(struct se_session *sess, struct se_cmd *cmd)
 	sbitmap_queue_clear(&sess->sess_tag_pool, cmd->map_tag, cmd->map_cpu);
 }
 
+int target_cluster_impl_register(const struct target_cluster_ops *ops);
+void target_cluster_impl_unregister(const struct target_cluster_ops *ops);
+
 #endif /* TARGET_CORE_BASE_H */
-- 
2.25.1

