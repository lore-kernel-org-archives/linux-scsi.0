Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57B7C19F29
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 21:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiG0Vlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG0Vlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 17:41:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A44422DA;
        Wed, 27 Jul 2022 14:41:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7A4B7412E1;
        Wed, 27 Jul 2022 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658958094; x=1660772495; bh=X/13rGCj3Z+k+S2YJnLzmVd6Z
        kC3cOAIPY/Yg4xDIKY=; b=GinbO9sE3U6TJMQKKYiPUMtS/z3UwPcqLDO5vCvoe
        tovVGK6mhXxJhJjGvMBDyPUMeI6/0AoplaKU3LDPmkmj0ZiRMj4KhXliYWMl6i0F
        t5zYrqZm9DfHzhh4JsH0VNYj3DOm9UkJcdFeGV5dxSLvajo/K6OfKyhzv6aClzCh
        rI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EWGY0e4LGtE5; Thu, 28 Jul 2022 00:41:34 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A7727412D8;
        Thu, 28 Jul 2022 00:41:34 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 28 Jul 2022 00:41:34 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 28 Jul 2022 00:41:33 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 2/2] target: core: de-RCU of se_lun and se_lun acl
Date:   Thu, 28 Jul 2022 00:41:25 +0300
Message-ID: <20220727214125.19647-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220727214125.19647-1-d.bogdanov@yadro.com>
References: <20220727214125.19647-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

se_lun and se_lun_acl are immutable pointers of struct se_dev_entry.
Remove RCU usage for access to those pointers.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
  remove misformatting
---
 drivers/target/target_core_alua.c   |  3 +--
 drivers/target/target_core_device.c | 29 +++++++++++------------------
 drivers/target/target_core_pr.c     | 28 ++++++++--------------------
 drivers/target/target_core_stat.c   | 10 ++++------
 drivers/target/target_core_xcopy.c  |  2 +-
 include/target/target_core_base.h   |  4 ++--
 6 files changed, 27 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 58df0145e8d0..fb91423a4e2e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -934,8 +934,7 @@ static void core_alua_queue_state_change_ua(struct t10_alua_tg_pt_gp *tg_pt_gp)
 
 		spin_lock(&lun->lun_deve_lock);
 		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link) {
-			lacl = rcu_dereference_check(se_deve->se_lun_acl,
-					lockdep_is_held(&lun->lun_deve_lock));
+			lacl = se_deve->se_lun_acl;
 
 			/*
 			 * spc4r37 p.242:
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 88a844ae1fd0..b7f16ee8aa0e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -75,7 +75,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 			return TCM_WRITE_PROTECTED;
 		}
 
-		se_lun = rcu_dereference(deve->se_lun);
+		se_lun = deve->se_lun;
 
 		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
 			se_lun = NULL;
@@ -152,7 +152,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
 	if (deve) {
-		se_lun = rcu_dereference(deve->se_lun);
+		se_lun = deve->se_lun;
 
 		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
 			se_lun = NULL;
@@ -216,7 +216,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
-		lun = rcu_dereference(deve->se_lun);
+		lun = deve->se_lun;
 		if (!lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
@@ -243,11 +243,8 @@ void core_free_device_list_for_node(
 	struct se_dev_entry *deve;
 
 	mutex_lock(&nacl->lun_entry_mutex);
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
-		struct se_lun *lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
-		core_disable_device_list_for_node(lun, deve, nacl, tpg);
-	}
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+		core_disable_device_list_for_node(deve->se_lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 }
 
@@ -334,8 +331,7 @@ int core_enable_device_list_for_node(
 	mutex_lock(&nacl->lun_entry_mutex);
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->se_lun) {
-		struct se_lun *orig_lun = rcu_dereference_check(orig->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+		struct se_lun *orig_lun = orig->se_lun;
 
 		if (orig_lun != lun) {
 			pr_err("Existing orig->se_lun doesn't match new lun"
@@ -355,8 +351,8 @@ int core_enable_device_list_for_node(
 			return -EINVAL;
 		}
 
-		rcu_assign_pointer(new->se_lun, lun);
-		rcu_assign_pointer(new->se_lun_acl, lun_acl);
+		new->se_lun = lun;
+		new->se_lun_acl = lun_acl;
 		hlist_del_rcu(&orig->link);
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 		mutex_unlock(&nacl->lun_entry_mutex);
@@ -374,8 +370,8 @@ int core_enable_device_list_for_node(
 		return 0;
 	}
 
-	rcu_assign_pointer(new->se_lun, lun);
-	rcu_assign_pointer(new->se_lun_acl, lun_acl);
+	new->se_lun = lun;
+	new->se_lun_acl = lun_acl;
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
@@ -454,10 +450,7 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 
 		mutex_lock(&nacl->lun_entry_mutex);
 		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
-			struct se_lun *tmp_lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
-
-			if (lun != tmp_lun)
+			if (lun != deve->se_lun)
 				continue;
 
 			core_disable_device_list_for_node(lun, deve, nacl, tpg);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3829b61b56c1..a1d67554709f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -739,8 +739,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (!deve_tmp->se_lun_acl)
 				continue;
 
-			lacl_tmp = rcu_dereference_check(deve_tmp->se_lun_acl,
-						lockdep_is_held(&lun_tmp->lun_deve_lock));
+			lacl_tmp = deve_tmp->se_lun_acl;
 			nacl_tmp = lacl_tmp->se_lun_nacl;
 			/*
 			 * Skip the matching struct se_node_acl that is allocated
@@ -784,8 +783,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 * the original *pr_reg is processed in
 			 * __core_scsi3_add_registration()
 			 */
-			dest_lun = rcu_dereference_check(deve_tmp->se_lun,
-				kref_read(&deve_tmp->pr_kref) != 0);
+			dest_lun = deve_tmp->se_lun;
 
 			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
 						nacl_tmp, dest_lun, deve_tmp,
@@ -1437,34 +1435,26 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 {
-	struct se_lun_acl *lun_acl;
-
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
-	lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
-				kref_read(&se_deve->pr_kref) != 0);
-	if (!lun_acl)
+	if (!se_deve->se_lun_acl)
 		return 0;
 
-	return target_depend_item(&lun_acl->se_lun_group.cg_item);
+	return target_depend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
 }
 
 static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 {
-	struct se_lun_acl *lun_acl;
-
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
-	lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
-				kref_read(&se_deve->pr_kref) != 0);
-	if (!lun_acl) {
+	if (!se_deve->se_lun_acl) {
 		kref_put(&se_deve->pr_kref, target_pr_kref_release);
 		return;
 	}
 
-	target_undepend_item(&lun_acl->se_lun_group.cg_item);
+	target_undepend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
 	kref_put(&se_deve->pr_kref, target_pr_kref_release);
 }
 
@@ -1751,8 +1741,7 @@ core_scsi3_decode_spec_i_port(
 		 * and then call __core_scsi3_add_registration() in the
 		 * 2nd loop which will never fail.
 		 */
-		dest_lun = rcu_dereference_check(dest_se_deve->se_lun,
-				kref_read(&dest_se_deve->pr_kref) != 0);
+		dest_lun = dest_se_deve->se_lun;
 
 		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 					dest_node_acl, dest_lun, dest_se_deve,
@@ -3446,8 +3435,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
 	if (!dest_pr_reg) {
-		struct se_lun *dest_lun = rcu_dereference_check(dest_se_deve->se_lun,
-				kref_read(&dest_se_deve->pr_kref) != 0);
+		struct se_lun *dest_lun = dest_se_deve->se_lun;
 
 		spin_unlock(&dev->dev_reservation_lock);
 		if (core_scsi3_alloc_registration(cmd->se_dev, dest_node_acl,
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 62d15bcc3d93..f85ee5b0fd80 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -877,7 +877,6 @@ static ssize_t target_stat_auth_dev_show(struct config_item *item,
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_dev_entry *deve;
-	struct se_lun *lun;
 	ssize_t ret;
 
 	rcu_read_lock();
@@ -886,9 +885,9 @@ static ssize_t target_stat_auth_dev_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
-	lun = rcu_dereference(deve->se_lun);
+
 	/* scsiDeviceIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_index);
+	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->se_lun->lun_index);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1217,7 +1216,6 @@ static ssize_t target_stat_iport_dev_show(struct config_item *item,
 	struct se_lun_acl *lacl = iport_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_dev_entry *deve;
-	struct se_lun *lun;
 	ssize_t ret;
 
 	rcu_read_lock();
@@ -1226,9 +1224,9 @@ static ssize_t target_stat_iport_dev_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
-	lun = rcu_dereference(deve->se_lun);
+
 	/* scsiDeviceIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_index);
+	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->se_lun->lun_index);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6bb20aa9c5bc..8713cda0c2fb 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -88,7 +88,7 @@ static int target_xcopy_locate_se_dev_e4(struct se_session *sess,
 		struct se_device *this_dev;
 		int rc;
 
-		this_lun = rcu_dereference(deve->se_lun);
+		this_lun = deve->se_lun;
 		this_dev = rcu_dereference_raw(this_lun->lun_se_dev);
 
 		rc = target_xcopy_locate_se_dev_e4_iter(this_dev, dev_wwn);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c2b36f7d917d..8c920456edd9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -665,9 +665,9 @@ struct se_dev_entry {
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	struct kref		pr_kref;
 	struct completion	pr_comp;
-	struct se_lun_acl __rcu	*se_lun_acl;
+	struct se_lun_acl	*se_lun_acl;
 	spinlock_t		ua_lock;
-	struct se_lun __rcu	*se_lun;
+	struct se_lun		*se_lun;
 #define DEF_PR_REG_ACTIVE		1
 	unsigned long		deve_flags;
 	struct list_head	alua_port_list;
-- 
2.25.1

