Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F321C25B06
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiHCQb4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiHCQaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486084D80E;
        Wed,  3 Aug 2022 09:30:05 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C8E144136D;
        Wed,  3 Aug 2022 16:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544201; x=1661358602; bh=pOcEOZn7zbrsXU9QO0/YYkQvP
        8Qm6scl2kk4JEHpRg4=; b=SWs8hly5oo4vgaiCMG/7lW462sYfhXNQ0wy/uOSTl
        TTxslmXiXnLXLjabbiZYlt21MuQs5+oda2e1/q8nQ11t1FKos1NvZkY25WWwOVLH
        LGRnexgOIp2Kgsfn0UOglmHji7DAXV0YU88ifNtf6B5AIvcTys21hwwtTlqT0pX9
        qQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IgCiEk_zx9-V; Wed,  3 Aug 2022 19:30:01 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 75EC4412EE;
        Wed,  3 Aug 2022 19:29:23 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
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
Subject: [RFC PATCH 39/48] target: cluster: read PR data from cluster
Date:   Mon, 6 Dec 2021 16:39:54 +0300
Message-ID: <20220803162857.27770-40-d.bogdanov@yadro.com>
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

Notify other nodes in cluster that PR data updated.
On notification do the following under PR cluster lock to read PR data:
	Update an existing registrants.
	Remove an outdated registrants (absent in cluster data).
	Create new registrants.
	Update Reservation status.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c     | 304 ++++++++++++++++++++++++
 drivers/target/target_core_device.c     |   1 +
 drivers/target/target_core_fabric_lib.c |   3 +-
 drivers/target/target_core_internal.h   |   5 -
 drivers/target/target_core_pr.c         |   8 +-
 drivers/target/target_core_pr.h         |   1 +
 include/target/target_core_base.h       |   5 +
 7 files changed, 320 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 14465764eaaf..6b7cb3175e3a 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -17,6 +17,7 @@ struct target_cluster_data {
 	struct mutex pr_lock_mutex;
 	struct dlm_ckv_lock *pr_lock;
 	struct dlm_ckv_kv *pr_data;
+	struct dlm_ckv_notify *pr_sync_notify;
 	int reserved_node_id;
 	struct dlm_ckv_kv **pr_reg_kv;
 	size_t pr_reg_kv_len;
@@ -96,6 +97,7 @@ struct async_group {
 	struct completion compl;
 };
 
+static void target_pr_sync_cb(void *arg);
 static int pr_reg_realloc(struct target_cluster_data *cluster_data,
 			  size_t nr_registrants);
 
@@ -143,10 +145,17 @@ static int target_init_dlm(struct se_device *dev)
 	if (!cluster_data->pr_data)
 		goto fail;
 
+	cluster_data->pr_sync_notify = dlm_ckv_create_notification(
+		cluster_data->bucket, "pr_sync", target_pr_sync_cb);
+	if (!cluster_data->pr_sync_notify)
+		goto fail;
+
 	dev->cluster_data = cluster_data;
 
 	return err;
 fail:
+	if (cluster_data->pr_sync_notify)
+		dlm_ckv_free_notification(cluster_data->pr_sync_notify);
 	if (cluster_data->pr_lock)
 		dlm_ckv_free_lock(cluster_data->pr_lock);
 	if (cluster_data->pr_data)
@@ -167,6 +176,7 @@ static int target_cleanup_dlm(struct se_device *dev)
 			dlm_ckv_free_kv(cluster_data->pr_reg_kv[i]);
 	kfree(cluster_data->pr_reg_kv);
 
+	dlm_ckv_free_notification(cluster_data->pr_sync_notify);
 	dlm_ckv_free_lock(cluster_data->pr_lock);
 	dlm_ckv_free_kv(cluster_data->pr_data);
 	res = dlm_ckv_close_bucket(cluster_data->bucket);
@@ -379,11 +389,305 @@ static int target_pr_sync_dlm(struct se_device *dev)
 
 skip_pr_reg:
 
+	/* request to update PR data on other nodes in cluster */
+	dlm_ckv_notify(cluster_data->pr_sync_notify);
+
 done:
 
 	return res;
 }
 
+static int target_update_pr_reg(struct se_device *dev,
+				struct t10_pr_registration *pr_reg,
+				const struct pr_lvb *pr_data,
+				const struct pr_reg_lvb *pr_reg_data,
+				struct t10_pr_registration **pr_reg_res_holder)
+{
+	/* update existing registrant */
+	pr_reg->pr_res_key = pr_reg_data->key;
+	pr_reg->pr_reg_all_tg_pt = pr_reg_data->is_all_tg_pt;
+
+	if (pr_reg_data->is_holder)
+		*pr_reg_res_holder = pr_reg;
+
+	return 0;
+}
+
+static struct t10_pr_registration *
+target_create_pr_reg(struct se_device *dev,
+		     struct pr_lvb *pr_data,
+		     struct pr_reg_lvb *pr_reg_data)
+{
+	struct t10_pr_registration *pr_reg = NULL;
+	struct se_lun *lun, *lun_tmp;
+	struct se_lun_acl *lacl_tmp;
+	struct se_node_acl *nacl_tmp;
+	struct se_dev_entry *deve;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	u8 initiatorname[PR_REG_ISID_LEN];
+	char *isid = NULL;
+
+	target_parse_pr_out_transport_id(pr_reg_data->tid, initiatorname, &isid);
+
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry_safe(lun, lun_tmp, &dev->dev_sep_list, lun_dev_link) {
+		if (!percpu_ref_tryget_live(&lun->lun_ref))
+			continue;
+
+		if (lun->lun_tpg->tpg_rtpi != pr_reg_data->rtpi) {
+			percpu_ref_put(&lun->lun_ref);
+			continue;
+		}
+		spin_unlock(&dev->se_port_lock);
+
+		spin_lock(&lun->lun_deve_lock);
+		list_for_each_entry(deve, &lun->lun_deve_list, lun_link) {
+			if (!deve->se_lun_acl)
+				continue;
+
+			lacl_tmp = deve->se_lun_acl;
+			nacl_tmp = lacl_tmp->se_lun_nacl;
+
+			if (strcmp(nacl_tmp->initiatorname, initiatorname))
+				continue;
+
+			kref_get(&deve->pr_kref);
+			pr_reg = __core_scsi3_do_alloc_registration(
+					dev, nacl_tmp,
+					nacl_tmp->initiatorname, lun->unpacked_lun,
+					pr_reg_data->rtpi,
+					deve, lacl_tmp->mapped_lun,
+					isid,
+					pr_reg_data->key,
+					pr_reg_data->is_all_tg_pt,
+					pr_data->pr_aptpl);
+
+			percpu_ref_put(&lun->lun_ref);
+			spin_unlock(&lun->lun_deve_lock);
+			goto out;
+		}
+		percpu_ref_put(&lun->lun_ref);
+		spin_unlock(&lun->lun_deve_lock);
+		spin_lock(&dev->se_port_lock);
+	}
+	spin_unlock(&dev->se_port_lock);
+out:
+
+	if (!pr_reg) {
+		/* target not yet configured,
+		 * allocate registration like for APTPL case
+		 */
+		pr_reg = __core_scsi3_do_alloc_registration(
+				dev, NULL, initiatorname, 0,
+				pr_reg_data->rtpi,
+				NULL, 0,
+				isid,
+				pr_reg_data->key,
+				pr_reg_data->is_all_tg_pt,
+				pr_data->pr_aptpl);
+	}
+
+	if (pr_reg) {
+		spin_lock(&dev->t10_pr.registration_lock);
+		memcpy(pr_reg->pr_tid, pr_reg_data->tid, PR_REG_TID_LEN);
+		list_add_tail(&pr_reg->pr_reg_list,
+				&dev->t10_pr.registration_list);
+
+		/*
+		 * Drop deve->pr_kref obtained in __core_scsi3_do_alloc_registration()
+		 */
+		rcu_read_lock();
+		deve = pr_reg->pr_reg_deve;
+		if (deve) {
+			set_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
+			kref_put(&deve->pr_kref, target_pr_kref_release);
+			pr_reg->pr_reg_deve = NULL;
+		}
+		rcu_read_unlock();
+
+		memset(&i_buf[0], 0, PR_REG_ISID_ID_LEN);
+		core_pr_dump_initiator_port(pr_reg, i_buf,
+						PR_REG_ISID_ID_LEN);
+		pr_debug("SPC-3 PR Service Action: REGISTER Initiator Node: %s%s\n",
+			initiatorname, i_buf);
+		pr_debug("SPC-3 PR registration on Target Port: %d\n",
+			pr_reg->tg_pt_sep_rtpi);
+		pr_debug("SPC-3 PR for %s TCM Subsystem %s Object Target Port(s)\n",
+			(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
+			dev->transport->name);
+		pr_debug("SPC-3 PR SA Res Key: 0x%016llx PRgeneration: 0x%08x  APTPL: %d\n",
+			pr_reg->pr_res_key,
+			pr_reg->pr_res_generation,
+			pr_reg->pr_reg_aptpl);
+		spin_unlock(&dev->t10_pr.registration_lock);
+		return pr_reg;
+	}
+
+	pr_warn("TARGET_CORE[%d]: PR data from cluster is invalid: could not find local nacl/deve for Initiator %s - RTPI %d\n",
+		dev->dev_index, initiatorname, pr_reg_data->rtpi);
+
+	return NULL;
+}
+
+static void target_pr_sync_cb(void *arg)
+{
+	struct se_device *dev = arg;
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
+	struct t10_pr_registration *pr_reg_res_holder = NULL;
+	struct t10_pr_registration *pr_prev_res_holder = NULL;
+	struct pr_reg_lvb *pr_reg_data = NULL;
+	LIST_HEAD(to_be_deleted_list);
+	struct async_group grp;
+	struct pr_lvb pr_data;
+	bool res_to_delete = false;
+	bool was_held;
+	u8 was_type;
+	u8 was_scope;
+	bool found;
+	int i = 0;
+	int res;
+
+	res = dlm_ckv_get(cluster_data->pr_data, (char *)&pr_data, sizeof(pr_data));
+	if (res)
+		goto done;
+
+	if (!pr_data.version) {
+		pr_info("TARGET_CORE[%d]: PR data from cluster is invalid\n",
+			dev->dev_index);
+		goto done;
+	}
+
+	pr_reg_data = kzalloc(sizeof(struct pr_reg_lvb) * pr_data.nr_registrants,
+			    GFP_KERNEL);
+	if (!pr_reg_data) {
+		res = -ENOMEM;
+		goto done;
+	}
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
+	for (i = 0; i < pr_data.nr_registrants; ++i) {
+		refcount_inc(&grp.pending);
+		res = dlm_ckv_get_async(cluster_data->pr_reg_kv[i], (char *)(pr_reg_data + i),
+				sizeof(struct pr_reg_lvb), group_compl_cb, &grp);
+		if (res) {
+			refcount_dec(&grp.pending);
+			break;
+		}
+	}
+	group_compl_cb(&grp, 0);
+	res = wait_for_completion_timeout(&grp.compl, 60 * HZ);
+	if (!res) {
+		pr_err("TARGET_CORE[%d]: timeout of waiting for dlm_ckv_get_async\n",
+			dev->dev_index);
+		goto done;
+	}
+	res = atomic_read(&grp.status);
+	if (res) {
+		pr_err("TARGET_CORE[%d]: fail of group for dlm_ckv_get_async %d\n",
+			dev->dev_index, res);
+		goto done;
+	}
+
+skip_pr_reg:
+	/*
+	 * Update existing registrations
+	 */
+	spin_lock(&dev->t10_pr.registration_lock);
+
+	was_held = !!dev->dev_pr_res_holder;
+	pr_prev_res_holder = dev->dev_pr_res_holder;
+	if (was_held) {
+		was_scope = pr_prev_res_holder->pr_res_scope;
+		was_type = pr_prev_res_holder->pr_res_type;
+	}
+
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &dev->t10_pr.registration_list,
+				 pr_reg_list) {
+		found = false;
+
+		for (i = 0; i < pr_data.nr_registrants; ++i) {
+			if (!pr_reg_data[i].version)
+				continue;
+
+			if (pr_reg->tg_pt_sep_rtpi == pr_reg_data[i].rtpi &&
+			   !target_cmp_pr_transport_id(pr_reg, pr_reg_data[i].tid)) {
+				found = true;
+				/* mark existing registrants */
+				pr_reg_data[i].version = 0;
+				target_update_pr_reg(dev, pr_reg, &pr_data,
+						     &pr_reg_data[i],
+						     &pr_reg_res_holder);
+				break;
+			}
+		}
+
+		if (!found)
+			list_move_tail(&pr_reg->pr_reg_list, &to_be_deleted_list);
+	}
+
+	/* deregister obsolete entries */
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &to_be_deleted_list,
+			pr_reg_list) {
+		if (dev->dev_pr_res_holder != pr_reg)
+			__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
+		else
+			res_to_delete = true;
+	}
+	spin_unlock(&dev->t10_pr.registration_lock);
+
+	/* register new entries */
+	for (i = 0; i < pr_data.nr_registrants; ++i) {
+		/* skip existing registrants */
+		if (!pr_reg_data[i].version)
+			continue;
+
+		pr_reg = target_create_pr_reg(dev, &pr_data, &pr_reg_data[i]);
+		if (!pr_reg)
+			pr_err("TARGET_CORE[%d]: can not create new registration\n",
+				dev->dev_index);
+		else if (pr_reg_data[i].is_holder)
+			pr_reg_res_holder = pr_reg;
+	}
+
+	/* update general data */
+	atomic_set(&dev->t10_pr.pr_generation, pr_data.pr_generation);
+	dev->t10_pr.pr_aptpl_active = pr_data.pr_aptpl;
+
+	/* update reservation */
+	spin_lock(&dev->dev_reservation_lock);
+	if (pr_prev_res_holder &&
+	    ((pr_reg_res_holder != pr_prev_res_holder) ||
+	     (was_type != pr_reg_res_holder->pr_res_type)))
+		__core_scsi3_complete_pro_release(dev, pr_prev_res_holder, 0, 0);
+
+	if (pr_reg_res_holder)
+		__core_scsi3_set_reservation(dev, pr_reg_res_holder,
+					pr_data.pr_scope, pr_data.pr_type);
+	spin_unlock(&dev->dev_reservation_lock);
+
+	if (res_to_delete) {
+		spin_lock(&dev->t10_pr.registration_lock);
+		__core_scsi3_free_registration(dev, pr_prev_res_holder, NULL, 0);
+		spin_unlock(&dev->t10_pr.registration_lock);
+	}
+
+	core_scsi3_update_and_write_aptpl(dev, dev->t10_pr.pr_aptpl_active);
+
+done:
+	kfree(pr_reg_data);
+}
+
 const struct target_cluster_ops dlm_cluster_ops = {
 	.name = "dlm",
 	.owner = THIS_MODULE,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f5da3fc17ad1..297bf5985f48 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -355,6 +355,7 @@ void target_pr_kref_release(struct kref *kref)
 						 pr_kref);
 	complete(&deve->pr_comp);
 }
+EXPORT_SYMBOL(target_pr_kref_release);
 
 /*
  * Establish UA condition on SCSI device - all LUNs
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 8232d872db35..2937bf4f6865 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -396,7 +396,7 @@ int target_cmp_pr_transport_id(
 
 	return memcmp(pr_reg->pr_tid, tid, len1);
 }
-
+EXPORT_SYMBOL(target_cmp_pr_transport_id);
 
 int target_gen_pr_transport_id(
 	struct t10_pr_registration *pr_reg,
@@ -444,3 +444,4 @@ u32 target_parse_pr_out_transport_id(
 	*port_nexus_ptr = NULL;
 	return 24;
 }
+EXPORT_SYMBOL(target_parse_pr_out_transport_id);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 8669ff6f48e9..89f0ddca35ed 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -65,7 +65,6 @@ extern struct t10_alua_lu_gp *default_lu_gp;
 
 /* target_core_device.c */
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
-void	target_pr_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
 void	core_update_device_list_access(u64, bool, struct se_node_acl *);
@@ -107,14 +106,10 @@ int	target_fabric_setup_cits(struct target_fabric_configfs *);
 
 /* target_core_fabric_lib.c */
 int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg);
-int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
-			       unsigned char *tid);
 int target_gen_pr_transport_id(struct t10_pr_registration *pr_reg,
 			       int proto_id,
 			       const char *initiatorname,
 			       unsigned char *isid);
-u32 target_parse_pr_out_transport_id(
-	const char *buf, char *initiatorname, char **port_nexus_ptr);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a9fe192f5fe4..fe2f64826e9e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -52,6 +52,7 @@ void core_pr_dump_initiator_port(
 
 	snprintf(buf, size, ",i,0x%s", pr_reg->pr_reg_isid);
 }
+EXPORT_SYMBOL(core_pr_dump_initiator_port);
 
 enum register_type {
 	REGISTER,
@@ -677,6 +678,7 @@ struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 
 	return pr_reg;
 }
+EXPORT_SYMBOL(__core_scsi3_do_alloc_registration);
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *);
 static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *);
@@ -1296,6 +1298,7 @@ void __core_scsi3_free_registration(
 	 */
 	list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
 }
+EXPORT_SYMBOL(__core_scsi3_free_registration);
 
 void core_scsi3_free_all_registrations(
 	struct se_device *dev)
@@ -1925,7 +1928,7 @@ static int __core_scsi3_write_aptpl_to_file(
  * Clear the APTPL metadata if APTPL has been disabled, otherwise
  * write out the updated metadata to struct file for this SCSI device.
  */
-static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, bool aptpl)
+sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, bool aptpl)
 {
 	unsigned char *buf;
 	int rc, len = PR_APTPL_BUF_LEN;
@@ -1965,6 +1968,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 	pr_debug("SPC-3 PR: Set APTPL Bit Activated\n");
 	return 0;
 }
+EXPORT_SYMBOL(core_scsi3_update_and_write_aptpl);
 
 static sense_reason_t
 core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
@@ -2214,6 +2218,7 @@ void __core_scsi3_set_reservation(struct se_device *dev,
 			pr_reg->pr_iport,
 			i_buf);
 }
+EXPORT_SYMBOL(__core_scsi3_set_reservation);
 
 static sense_reason_t
 core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
@@ -2430,6 +2435,7 @@ void __core_scsi3_complete_pro_release(
 	 */
 	pr_reg->pr_res_holder = pr_reg->pr_res_type = pr_reg->pr_res_scope = 0;
 }
+EXPORT_SYMBOL(__core_scsi3_complete_pro_release);
 
 static sense_reason_t
 core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 589fdac5470f..e7eff50a01f2 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -68,6 +68,7 @@ extern int core_scsi3_alloc_aptpl_registration(
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
 			struct se_node_acl *, u64);
+sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, bool aptpl);
 extern void core_scsi3_free_all_registrations(struct se_device *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9edf3c1ac204..b0f0a6b93f6e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -1004,5 +1004,10 @@ void target_cluster_impl_unregister(const struct target_cluster_ops *ops);
 
 int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
 				   unsigned char *buf);
+u32 target_parse_pr_out_transport_id(
+	const char *buf, char *initiatorname, char **port_nexus_ptr);
+int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
+			       unsigned char *tid);
+void	target_pr_kref_release(struct kref *kref);
 
 #endif /* TARGET_CORE_BASE_H */
-- 
2.25.1

