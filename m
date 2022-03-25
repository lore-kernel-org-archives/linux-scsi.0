Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78789C3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbiHCQcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiHCQbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:31:35 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB1A95B9;
        Wed,  3 Aug 2022 09:30:16 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 71FC941306;
        Wed,  3 Aug 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544213; x=1661358614; bh=TvgIU7pD4ryCcfsdLEnvvPmpr
        25Q4u6JZGeMIGkWvsg=; b=YevSKbvdHKx65w8h1hpsbHkC59FNHheo+dUYUT8Zf
        yVOw+l5GgjvO8otm0MxwItcM8TnTYYgZY3NBpQ4Tb9LrCG43FbQME4AtJ4BtV3S3
        Qt3SeTiA3hJuteVKTZtIoEVxX+qCQHsUXh0EuIIUoQ+/YIIKgRbTbyaVjpOUaz5x
        Yg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oIdCX-8JyHok; Wed,  3 Aug 2022 19:30:13 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1D3504128A;
        Wed,  3 Aug 2022 19:29:27 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:27 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:26 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 47/48] target: cluster: split cluster sync function
Date:   Fri, 25 Mar 2022 09:35:45 +0300
Message-ID: <20220803162857.27770-48-d.bogdanov@yadro.com>
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

Split cluster sync function to two parts:
1. Read cluster data.
2. Apply cluster data.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c | 117 ++++++++++++++++++----------
 1 file changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 546e28062b8f..ff0c207be141 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -565,61 +565,53 @@ static void target_allocate_pr_ua(struct se_device *dev, u8 asc)
 	}
 }
 
-static void target_pr_sync_cb(void *arg)
+static int target_dlm_read_cluster_data(
+	struct se_device *dev,
+	struct pr_lvb *pr_data,
+	struct pr_reg_lvb **pr_reg_datap)
 {
-	struct se_device *dev = arg;
 	struct target_cluster_data *cluster_data = dev->cluster_data;
-	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
-	struct t10_pr_registration *pr_reg_res_holder = NULL;
-	struct t10_pr_registration *pr_prev_res_holder = NULL;
 	struct pr_reg_lvb *pr_reg_data = NULL;
-	LIST_HEAD(to_be_deleted_list);
-	LIST_HEAD(preempt_and_abort_list);
 	struct async_group grp;
-	struct pr_lvb pr_data;
-	bool res_to_delete = false;
-	struct se_node_acl *pr_reg_nacl;
-	u64 pr_res_mapped_lun;
-	bool reg_deleted = false;
-	bool was_held;
-	u8 was_type;
-	u8 was_scope;
-	bool found;
+	int res = 0;
 	int i = 0;
-	int res;
 
-	res = dlm_ckv_get(cluster_data->pr_data, (char *)&pr_data, sizeof(pr_data));
+	res = dlm_ckv_get(cluster_data->pr_data, (char *)pr_data,
+			  sizeof(struct pr_lvb));
 	if (res)
 		goto done;
 
-	if (!pr_data.version) {
+	if (!pr_data->version) {
 		pr_info("TARGET_CORE[%d]: PR data from cluster is invalid\n",
 			dev->dev_index);
 		goto done;
 	}
 
-	pr_reg_data = kzalloc(sizeof(struct pr_reg_lvb) * pr_data.nr_registrants,
+	if (pr_data->nr_registrants == 0)
+		goto done;
+
+	*pr_reg_datap = kzalloc(sizeof(struct pr_reg_lvb) * pr_data->nr_registrants,
 			    GFP_KERNEL);
+	pr_reg_data = *pr_reg_datap;
 	if (!pr_reg_data) {
 		res = -ENOMEM;
 		goto done;
 	}
 
-	res = pr_reg_realloc(cluster_data, pr_data.nr_registrants);
+	res = pr_reg_realloc(cluster_data, pr_data->nr_registrants);
 	if (res)
 		goto done;
 
-	if (pr_data.nr_registrants == 0)
-		goto skip_pr_reg;
-
 	refcount_set(&grp.pending, 1); /* 1 for a loop */
 	atomic_set(&grp.status, 0);
 	init_completion(&grp.compl);
 
-	for (i = 0; i < pr_data.nr_registrants; ++i) {
+	for (i = 0; i < pr_data->nr_registrants; ++i) {
 		refcount_inc(&grp.pending);
-		res = dlm_ckv_get_async(cluster_data->pr_reg_kv[i], (char *)(pr_reg_data + i),
-				sizeof(struct pr_reg_lvb), group_compl_cb, &grp);
+		res = dlm_ckv_get_async(cluster_data->pr_reg_kv[i],
+					(char *)(pr_reg_data + i),
+					sizeof(struct pr_reg_lvb),
+					group_compl_cb, &grp);
 		if (res) {
 			refcount_dec(&grp.pending);
 			break;
@@ -639,7 +631,33 @@ static void target_pr_sync_cb(void *arg)
 		goto done;
 	}
 
-skip_pr_reg:
+done:
+	if (res)
+		kfree(pr_reg_data);
+	return res;
+}
+
+static void target_dlm_apply_cluster_data(
+	struct se_device *dev,
+	struct pr_lvb *pr_data,
+	struct pr_reg_lvb *pr_reg_data)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
+	struct t10_pr_registration *pr_reg_res_holder = NULL;
+	struct t10_pr_registration *pr_prev_res_holder = NULL;
+	LIST_HEAD(to_be_deleted_list);
+	LIST_HEAD(preempt_and_abort_list);
+	bool res_to_delete = false;
+	struct se_node_acl *pr_reg_nacl;
+	u64 pr_res_mapped_lun;
+	bool reg_deleted = false;
+	bool was_held;
+	u8 was_type;
+	u8 was_scope;
+	bool found;
+	int i = 0;
+
 	/*
 	 * Update existing registrations
 	 */
@@ -656,7 +674,7 @@ static void target_pr_sync_cb(void *arg)
 				 pr_reg_list) {
 		found = false;
 
-		for (i = 0; i < pr_data.nr_registrants; ++i) {
+		for (i = 0; i < pr_data->nr_registrants; ++i) {
 			if (!pr_reg_data[i].version)
 				continue;
 
@@ -665,7 +683,7 @@ static void target_pr_sync_cb(void *arg)
 				found = true;
 				/* mark existing registrants */
 				pr_reg_data[i].version = 0;
-				target_update_pr_reg(dev, pr_reg, &pr_data,
+				target_update_pr_reg(dev, pr_reg, pr_data,
 						     &pr_reg_data[i],
 						     &pr_reg_res_holder);
 				break;
@@ -685,12 +703,12 @@ static void target_pr_sync_cb(void *arg)
 
 		if (dev->dev_pr_res_holder != pr_reg)
 			__core_scsi3_free_registration(dev, pr_reg,
-				(pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) ?
+				(pr_data->pro_sa == PRO_PREEMPT_AND_ABORT) ?
 				&preempt_and_abort_list : NULL, 0);
 		else
 			res_to_delete = true;
 
-		switch (pr_data.pro_sa) {
+		switch (pr_data->pro_sa) {
 		case PRO_CLEAR:
 			/*
 			 * establish a unit attention condition for the initiator
@@ -720,12 +738,12 @@ static void target_pr_sync_cb(void *arg)
 	spin_unlock(&dev->t10_pr.registration_lock);
 
 	/* register new entries */
-	for (i = 0; i < pr_data.nr_registrants; ++i) {
+	for (i = 0; i < pr_data->nr_registrants; ++i) {
 		/* skip existing registrants */
 		if (!pr_reg_data[i].version)
 			continue;
 
-		pr_reg = target_create_pr_reg(dev, &pr_data, &pr_reg_data[i]);
+		pr_reg = target_create_pr_reg(dev, pr_data, &pr_reg_data[i]);
 		if (!pr_reg)
 			pr_err("TARGET_CORE[%d]: can not create new registration\n",
 				dev->dev_index);
@@ -733,7 +751,7 @@ static void target_pr_sync_cb(void *arg)
 			pr_reg_res_holder = pr_reg;
 	}
 
-	switch (pr_data.pro_sa) {
+	switch (pr_data->pro_sa) {
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
 	case PRO_REGISTER:
 		/*
@@ -793,11 +811,11 @@ static void target_pr_sync_cb(void *arg)
 	}
 
 	/* update general data */
-	atomic_set(&dev->t10_pr.pr_generation, pr_data.pr_generation);
-	dev->t10_pr.pr_aptpl_active = pr_data.pr_aptpl;
+	atomic_set(&dev->t10_pr.pr_generation, pr_data->pr_generation);
+	dev->t10_pr.pr_aptpl_active = pr_data->pr_aptpl;
 
 	/* update SPC-2 reservation */
-	cluster_data->reserved_node_id = pr_data.reserved_by_nodeid;
+	cluster_data->reserved_node_id = pr_data->reserved_by_nodeid;
 	spin_lock(&dev->dev_reservation_lock);
 	if (cluster_data->reserved_node_id == cluster_data->local_nodeid &&
 	    dev->reservation_holder == NULL) {
@@ -826,18 +844,18 @@ static void target_pr_sync_cb(void *arg)
 
 	if (pr_reg_res_holder)
 		__core_scsi3_set_reservation(dev, pr_reg_res_holder,
-					pr_data.pr_scope, pr_data.pr_type);
+					pr_data->pr_scope, pr_data->pr_type);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (res_to_delete) {
 		spin_lock(&dev->t10_pr.registration_lock);
 		__core_scsi3_free_registration(dev, pr_prev_res_holder,
-				(pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) ?
+				(pr_data->pro_sa == PRO_PREEMPT_AND_ABORT) ?
 				&preempt_and_abort_list : NULL, 0);
 		spin_unlock(&dev->t10_pr.registration_lock);
 	}
 
-	if (pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) {
+	if (pr_data->pro_sa == PRO_PREEMPT_AND_ABORT) {
 		core_local_lun_reset(dev, NULL, &preempt_and_abort_list, NULL);
 
 		core_scsi3_release_preempt_and_abort(
@@ -845,7 +863,7 @@ static void target_pr_sync_cb(void *arg)
 					pr_reg_res_holder);
 	}
 
-	if (pr_data.pro_sa == PR_SYNC_REASON_RESET) {
+	if (pr_data->pro_sa == PR_SYNC_REASON_RESET) {
 		core_local_lun_reset(dev, NULL, NULL, NULL);
 
 		target_dev_ua_allocate(dev, 0x29,
@@ -856,10 +874,23 @@ static void target_pr_sync_cb(void *arg)
 
 	core_scsi3_update_and_write_aptpl(dev, dev->t10_pr.pr_aptpl_active);
 
-done:
 	kfree(pr_reg_data);
 }
 
+static void target_pr_sync_cb(void *arg)
+{
+	struct pr_reg_lvb *pr_reg_data = NULL;
+	struct se_device *dev = arg;
+	struct pr_lvb pr_data;
+	int res;
+
+	res = target_dlm_read_cluster_data(dev, &pr_data, &pr_reg_data);
+	if (res)
+		return;
+
+	target_dlm_apply_cluster_data(dev, &pr_data, pr_reg_data);
+}
+
 static void
 target_spc2_reserve(struct se_device *dev, struct se_session *sess)
 {
-- 
2.25.1

