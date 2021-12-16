Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6259C3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiHCQbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbiHCQat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:49 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8F34F65E;
        Wed,  3 Aug 2022 09:30:08 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 35E6741378;
        Wed,  3 Aug 2022 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544205; x=1661358606; bh=O/iIPyEyPOsenWf7AyLBCWTes
        vHKmHvcvCNKpQOR8uo=; b=eX8v/l0lMH13N6dAIbiop1YOdo8frZTIsWITeQYox
        RnqxBep+O0vIKOCKlRhVvvWML020GUI66U/YzktJaFITD/SMp+jxGuGUgK+ehJB3
        unZE/pw9rVBUSCNAgwVbIwcusDbpFA0jdOD63yqsj2RTYjAR66O8MJpK1Lz7pdjP
        L8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id umlnsauycaoX; Wed,  3 Aug 2022 19:30:05 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 81217412E6;
        Wed,  3 Aug 2022 19:29:24 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:24 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:23 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 42/48] target: cluster: sync SPC-2 reservations
Date:   Thu, 16 Dec 2021 13:20:31 +0300
Message-ID: <20220803162857.27770-43-d.bogdanov@yadro.com>
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

Reservation status is stored in DLM_CKV as part of PR data.
If a reservation holder node is left the cluster other nodes will clear
reservation status locally.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/dlm_ckv.c               | 16 ++++++-
 drivers/target/dlm_ckv.h               |  4 +-
 drivers/target/target_cluster_dlm.c    | 59 +++++++++++++++++++++++++-
 drivers/target/target_core_device.c    | 10 +++++
 drivers/target/target_core_pr.c        | 22 +++++++---
 drivers/target/target_core_pr.h        |  1 +
 drivers/target/target_core_tmr.c       |  4 +-
 drivers/target/target_core_transport.c |  2 +-
 include/target/target_core_base.h      |  1 +
 9 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/drivers/target/dlm_ckv.c b/drivers/target/dlm_ckv.c
index 417159f18fc6..f4e7bc410a08 100644
--- a/drivers/target/dlm_ckv.c
+++ b/drivers/target/dlm_ckv.c
@@ -49,6 +49,7 @@ struct dlm_ckv_bucket {
 	size_t num_nodes;
 	int nodeid[64];
 	void *userarg;
+	dlm_ckv_nodeleft_cb nodeleft_cb;
 	struct completion sync_compl;
 	struct workqueue_struct *notify_wq;
 };
@@ -79,7 +80,12 @@ static void dlm_ckv_recover_prep(void *arg)
 
 static void dlm_ckv_recover_slot(void *arg, struct dlm_slot *slot)
 {
-	pr_info("nodeid %d left the cluster\n", slot->nodeid);
+	struct dlm_ckv_bucket *bucket = arg;
+
+	pr_debug("nodeid %d left the cluster\n", slot->nodeid);
+
+	if (bucket->nodeleft_cb)
+		bucket->nodeleft_cb(bucket->userarg, slot->nodeid);
 }
 
 /* dlm calls after recover_slot and after it completes lock recovery */
@@ -667,7 +673,8 @@ static void bucket_release(struct kref *ref)
 }
 
 struct dlm_ckv_bucket *
-dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
+dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg,
+		    dlm_ckv_nodeleft_cb nodeleft_cb, int *local_nodeid)
 {
 	struct dlm_ckv_bucket *bucket;
 	int name_len = strlen(name);
@@ -677,6 +684,9 @@ dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
 	if (!name)
 		return ERR_PTR(-EINVAL);
 
+	if (!local_nodeid)
+		return ERR_PTR(-EINVAL);
+
 	if (name_len > DLM_LOCKSPACE_LEN)
 		return ERR_PTR(-EINVAL);
 
@@ -684,6 +694,7 @@ dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
 	kref_init(&bucket->refcount);
 
 	bucket->userarg = userarg;
+	bucket->nodeleft_cb = nodeleft_cb;
 	init_completion(&bucket->sync_compl);
 	bucket->notify_wq = alloc_ordered_workqueue("notify_wq-%s", 0, name);
 
@@ -708,6 +719,7 @@ dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
 		goto fail_init;
 	}
 
+	*local_nodeid = bucket->local_nodeid;
 	return bucket;
 
 fail_init:
diff --git a/drivers/target/dlm_ckv.h b/drivers/target/dlm_ckv.h
index e8045917067e..c5a69486a3bf 100644
--- a/drivers/target/dlm_ckv.h
+++ b/drivers/target/dlm_ckv.h
@@ -14,7 +14,9 @@ typedef void (*dlm_ckv_nodeleft_cb)(void *arg, int nodeid);
 
 struct dlm_ckv_bucket *dlm_ckv_open_bucket(const char *name,
 					   const char *cluster_name,
-					   void *userarg);
+					   void *userarg,
+					   dlm_ckv_nodeleft_cb nodeleft_cb,
+					   int *local_nodeid);
 int dlm_ckv_close_bucket(struct dlm_ckv_bucket *bucket);
 
 struct dlm_ckv_lock *
diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 16391a8661fa..4c4d337e6a1a 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -98,6 +98,7 @@ struct async_group {
 };
 
 static void target_pr_sync_cb(void *arg);
+static void target_nodeleft_cb(void *arg, int nodeid);
 static int pr_reg_realloc(struct target_cluster_data *cluster_data,
 			  size_t nr_registrants);
 
@@ -128,7 +129,8 @@ static int target_init_dlm(struct se_device *dev)
 
 	cluster_data->bucket = dlm_ckv_open_bucket(ls_name,
 						cluster_cfg.cluster_name,
-						dev);
+						dev, target_nodeleft_cb,
+						&cluster_data->local_nodeid);
 	if (!cluster_data->bucket) {
 		err = -EIO;
 		kfree(cluster_data);
@@ -679,6 +681,27 @@ static void target_pr_sync_cb(void *arg)
 	atomic_set(&dev->t10_pr.pr_generation, pr_data.pr_generation);
 	dev->t10_pr.pr_aptpl_active = pr_data.pr_aptpl;
 
+	/* update SPC-2 reservation */
+	cluster_data->reserved_node_id = pr_data.reserved_by_nodeid;
+	spin_lock(&dev->dev_reservation_lock);
+	if (cluster_data->reserved_node_id == cluster_data->local_nodeid &&
+	    dev->reservation_holder == NULL) {
+		pr_err("TARGET_CORE[%d]:SCP-2 reservation is out of sync. Cluster thinks that we are reservation holder\n",
+			dev->dev_index);
+	}
+	if (cluster_data->reserved_node_id != cluster_data->local_nodeid &&
+	    dev->reservation_holder != NULL) {
+		pr_err("TARGET_CORE[%d]: SPC-2 reservation is out of sync. Possible split-brain. Cluster thinks that reservation holder is other node\n",
+			dev->dev_index);
+		dev->reservation_holder = NULL;
+	}
+	if (cluster_data->reserved_node_id != 0)
+		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS;
+	else
+		target_release_reservation(dev);
+
+	spin_unlock(&dev->dev_reservation_lock);
+
 	/* update reservation */
 	spin_lock(&dev->dev_reservation_lock);
 	if (pr_prev_res_holder &&
@@ -703,6 +726,39 @@ static void target_pr_sync_cb(void *arg)
 	kfree(pr_reg_data);
 }
 
+static void
+target_spc2_reserve(struct se_device *dev, struct se_session *sess)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+
+	target_pr_lock_dlm(dev);
+
+	if (sess) {
+		target_get_reservation(dev, sess);
+		cluster_data->reserved_node_id = cluster_data->local_nodeid;
+	} else {
+		target_release_reservation(dev);
+		cluster_data->reserved_node_id = 0;
+	}
+
+	target_pr_sync_dlm(dev);
+	target_pr_unlock_dlm(dev);
+}
+
+static void target_nodeleft_cb(void *arg, int nodeid)
+{
+	struct se_device *dev = arg;
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+
+	if (cluster_data->reserved_node_id == nodeid &&
+	    dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
+		pr_info("TARGET_CORE[%d]: SPC-2 reservation holder left the cluster\n",
+			dev->dev_index);
+		dev->reservation_holder = NULL;
+		cluster_data->reserved_node_id = 0;
+	}
+}
+
 const struct target_cluster_ops dlm_cluster_ops = {
 	.name = "dlm",
 	.owner = THIS_MODULE,
@@ -715,6 +771,7 @@ const struct target_cluster_ops dlm_cluster_ops = {
 	.pr_lock = target_pr_lock_dlm,
 	.pr_unlock = target_pr_unlock_dlm,
 	.pr_sync = target_pr_sync_dlm,
+	.reserve = target_spc2_reserve,
 };
 
 static int __init target_cluster_dlm_module_init(void)
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 297bf5985f48..9f01a28ef72f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -788,6 +788,15 @@ int target_dummy_nodlm(struct se_device *dev)
 	return 0;
 }
 
+static void target_reserve2_nodlm(struct se_device *dev, struct se_session *sess)
+{
+	if (sess) {
+		target_get_reservation(dev, sess);
+	} else {
+		target_release_reservation(dev);
+	}
+}
+
 const struct target_cluster_ops nodlm_cluster_ops = {
 	.name = "single",
 	.owner = NULL,
@@ -798,6 +807,7 @@ const struct target_cluster_ops nodlm_cluster_ops = {
 	.pr_lock = target_dummy_nodlm,
 	.pr_unlock = target_dummy_nodlm,
 	.pr_sync = target_dummy_nodlm,
+	.reserve = target_reserve2_nodlm,
 };
 
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 22f2aa91cf2e..930f0bebd75d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -192,6 +192,7 @@ void target_release_reservation(struct se_device *dev)
 		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
 }
+EXPORT_SYMBOL(target_release_reservation);
 
 sense_reason_t
 target_scsi2_reservation_release(struct se_cmd *cmd)
@@ -222,7 +223,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	if (dev->dev_res_bin_isid != sess->sess_bin_isid)
 		goto out_unlock;
 
-	target_release_reservation(dev);
+	dev->cl_ops->reserve(dev, NULL);
 	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
 		" MAPPED LUN: %llu for %s\n",
@@ -237,6 +238,17 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	return 0;
 }
 
+void target_get_reservation(struct se_device *dev, struct se_session *sess)
+{
+	dev->reservation_holder = sess;
+	dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS;
+	if (sess->sess_bin_isid != 0) {
+		dev->dev_res_bin_isid = sess->sess_bin_isid;
+		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
+	}
+}
+EXPORT_SYMBOL(target_get_reservation);
+
 sense_reason_t
 target_scsi2_reservation_reserve(struct se_cmd *cmd)
 {
@@ -284,12 +296,8 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		goto out_unlock;
 	}
 
-	dev->reservation_holder = sess;
-	dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS;
-	if (sess->sess_bin_isid != 0) {
-		dev->dev_res_bin_isid = sess->sess_bin_isid;
-		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
-	}
+	dev->cl_ops->reserve(dev, sess);
+
 	pr_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu"
 		" for %s\n", tpg->se_tpg_tfo->fabric_name,
 		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index e7eff50a01f2..a3a6013dc530 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -59,6 +59,7 @@ extern struct kmem_cache *t10_pr_reg_cache;
 extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
 			char *, u32);
 extern void target_release_reservation(struct se_device *dev);
+extern void target_get_reservation(struct se_device *dev, struct se_session *sess);
 extern sense_reason_t target_scsi2_reservation_release(struct se_cmd *);
 extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2db45efedd97..26df0f685499 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -406,9 +406,7 @@ int core_tmr_lun_reset(
 	 * LOGICAL UNIT RESET
 	 */
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
-		spin_lock(&dev->dev_reservation_lock);
-		target_release_reservation(dev);
-		spin_unlock(&dev->dev_reservation_lock);
+		dev->cl_ops->reserve(dev, NULL);
 		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d3cbba294510..47b44a1e6925 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -612,7 +612,7 @@ static int target_release_res(struct se_device *dev, void *data)
 	struct se_session *sess = data;
 
 	if (dev->reservation_holder == sess)
-		target_release_reservation(dev);
+		dev->cl_ops->reserve(dev, NULL);
 	return 0;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b0f0a6b93f6e..c49ddf0828f6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -790,6 +790,7 @@ struct target_cluster_ops {
 	int (*pr_lock)(struct se_device *dev);
 	int (*pr_unlock)(struct se_device *dev);
 	int (*pr_sync)(struct se_device *dev);
+	void (*reserve)(struct se_device *dev, struct se_session *sess);
 };
 
 struct se_device {
-- 
2.25.1

