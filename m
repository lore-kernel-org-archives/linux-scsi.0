Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF94C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbiHCQcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbiHCQbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:31:35 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE07663;
        Wed,  3 Aug 2022 09:30:16 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3D10C4137E;
        Wed,  3 Aug 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544213; x=1661358614; bh=/qy+AU5xyZkgMhCzOHh14ktfG
        ZtI8a6kol2zDDHecjw=; b=NSlHc3aUjNGuJIbNapupwKQqgUm7U9KZvydOI3sVr
        I6kajW9ViQTF2hzrITGYuSCwqAEY3k5adV4/14u/aHusaZlspXq8u39nX4hxgRPU
        HDZ3mS5SBtC7Ba6fT7NElhKAzVEdxmX7SzMvEvO6F+caMfK1/Y+9QgLgb0uyWzeg
        tc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tNjZMERgxICD; Wed,  3 Aug 2022 19:30:13 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6DE6341306;
        Wed,  3 Aug 2022 19:29:27 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
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
Subject: [RFC PATCH 48/48] target: cluster: request data on initial sync
Date:   Fri, 25 Mar 2022 10:58:34 +0300
Message-ID: <20220803162857.27770-49-d.bogdanov@yadro.com>
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

If there is no cluster data in cluster (master node died), request it
from alive nodes.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c | 36 ++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index ff0c207be141..39754d3671b7 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -19,6 +19,7 @@ struct target_cluster_data {
 	struct dlm_ckv_lock *pr_lock;
 	struct dlm_ckv_kv *pr_data;
 	struct dlm_ckv_notify *pr_sync_notify;
+	struct dlm_ckv_notify *init_sync_notify;
 	int reserved_node_id;
 	struct dlm_ckv_kv **pr_reg_kv;
 	size_t pr_reg_kv_len;
@@ -101,7 +102,10 @@ struct async_group {
 
 #define PR_SYNC_REASON_RESERVE	10
 #define PR_SYNC_REASON_RESET	11
+#define PR_SYNC_REASON_INIT	13
 
+static void target_initial_sync(struct se_device *dev);
+static void target_initial_sync_cb(void *arg);
 static void target_pr_sync_cb(void *arg);
 static void target_nodeleft_cb(void *arg, int nodeid);
 static int pr_reg_realloc(struct target_cluster_data *cluster_data,
@@ -157,15 +161,22 @@ static int target_init_dlm(struct se_device *dev)
 	if (!cluster_data->pr_sync_notify)
 		goto fail;
 
+	cluster_data->init_sync_notify = dlm_ckv_create_notification(
+		cluster_data->bucket, "init_sync", target_initial_sync_cb);
+	if (!cluster_data->init_sync_notify)
+		goto fail;
+
 	dev->cluster_data = cluster_data;
 
 	/* initial sync-up on joining the cluster */
 	dlm_ckv_lock_get(cluster_data->pr_lock);
-	target_pr_sync_cb(dev);
+	target_initial_sync(dev);
 	dlm_ckv_lock_release(cluster_data->pr_lock);
 
 	return err;
 fail:
+	if (cluster_data->init_sync_notify)
+		dlm_ckv_free_notification(cluster_data->init_sync_notify);
 	if (cluster_data->pr_sync_notify)
 		dlm_ckv_free_notification(cluster_data->pr_sync_notify);
 	if (cluster_data->pr_lock)
@@ -188,6 +199,7 @@ static int target_cleanup_dlm(struct se_device *dev)
 			dlm_ckv_free_kv(cluster_data->pr_reg_kv[i]);
 	kfree(cluster_data->pr_reg_kv);
 
+	dlm_ckv_free_notification(cluster_data->init_sync_notify);
 	dlm_ckv_free_notification(cluster_data->pr_sync_notify);
 	dlm_ckv_free_lock(cluster_data->pr_lock);
 	dlm_ckv_free_kv(cluster_data->pr_data);
@@ -410,6 +422,13 @@ static int target_pr_sync_dlm(struct se_device *dev, u8 pro_sa)
 	return res;
 }
 
+static void target_initial_sync_cb(void *arg)
+{
+	struct se_device *dev = arg;
+
+	target_pr_sync_dlm(dev, PR_SYNC_REASON_INIT);
+}
+
 static int target_update_pr_reg(struct se_device *dev,
 				struct t10_pr_registration *pr_reg,
 				const struct pr_lvb *pr_data,
@@ -584,6 +603,7 @@ static int target_dlm_read_cluster_data(
 	if (!pr_data->version) {
 		pr_info("TARGET_CORE[%d]: PR data from cluster is invalid\n",
 			dev->dev_index);
+		res = -ENOLCK;
 		goto done;
 	}
 
@@ -877,6 +897,20 @@ static void target_dlm_apply_cluster_data(
 	kfree(pr_reg_data);
 }
 
+static void target_initial_sync(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	struct pr_reg_lvb *pr_reg_data = NULL;
+	struct pr_lvb pr_data;
+	int res;
+
+	res = target_dlm_read_cluster_data(dev, &pr_data, &pr_reg_data);
+	if (!res)
+		target_dlm_apply_cluster_data(dev, &pr_data, pr_reg_data);
+	if (res == -ENOLCK)
+		dlm_ckv_notify(cluster_data->init_sync_notify);
+}
+
 static void target_pr_sync_cb(void *arg)
 {
 	struct pr_reg_lvb *pr_reg_data = NULL;
-- 
2.25.1

