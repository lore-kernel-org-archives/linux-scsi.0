Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DACFC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiHCQaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiHCQ3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:48 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C974167D4;
        Wed,  3 Aug 2022 09:29:46 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BB8F54131B;
        Wed,  3 Aug 2022 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544183; x=1661358584; bh=JCrp/0ZWIAF1PCh2kq7jIhBKx
        KyR4CV/wOZ0aRubvw4=; b=bQKmR/MKZiCe616HheFN7X80plgLh/7StAEJcpfUJ
        yN8QMLwyf4oPm/isood6CRf6JLY8eWtiIgFRDCZozwVO/vDvr/R7VFJECtBgAx1I
        w4GgRnM+rv54rT6H/libLSeiScunCfOLZGXThKvReovv4PEfya3fTXU3RCQkm6Rv
        7o=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zXCii_bqgW6q; Wed,  3 Aug 2022 19:29:43 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4331D412C6;
        Wed,  3 Aug 2022 19:29:21 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:21 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:20 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 32/48] dlm_ckv: add notification service
Date:   Mon, 22 Nov 2021 20:07:17 +0300
Message-ID: <20220803162857.27770-33-d.bogdanov@yadro.com>
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

Notification broadcasts over DLM cluster.
They do not have any payload. Used to be used to notify other nodes to
read an updated data.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/dlm_ckv.c | 186 +++++++++++++++++++++++++++++++++++++++
 drivers/target/dlm_ckv.h |   8 ++
 2 files changed, 194 insertions(+)

diff --git a/drivers/target/dlm_ckv.c b/drivers/target/dlm_ckv.c
index a2e1a191c433..cffe4f2dcb82 100644
--- a/drivers/target/dlm_ckv.c
+++ b/drivers/target/dlm_ckv.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
+#include <linux/workqueue.h>
 #include <target/target_core_base.h>
 #include "dlm_ckv.h"
 
@@ -33,8 +34,17 @@ struct dlm_ckv_bucket {
 	int nodeid[64];
 	void *userarg;
 	struct completion sync_compl;
+	struct workqueue_struct *notify_wq;
 };
 
+struct dlm_ckv_notify {
+	dlm_ckv_notify_cb notify_cb;
+	char name[DLM_RESNAME_MAXLEN];
+	struct dlm_ckv_lock pre_n;
+	struct dlm_ckv_lock post_n;
+	struct work_struct pre_n_work;
+	struct work_struct post_n_work;
+};
 
 #define DLM_CKV_LVB_SIZE	256
 
@@ -230,6 +240,179 @@ dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock)
 }
 EXPORT_SYMBOL(dlm_ckv_lock_release);
 
+static void dlm_cvk_pre_n_bast(void *astarg, int mode)
+{
+	struct dlm_ckv_lksb *lksb = astarg;
+	struct dlm_ckv_lock *ckv_lock;
+	struct dlm_ckv_bucket *bucket;
+	struct dlm_ckv_notify *notify;
+
+	ckv_lock = container_of(lksb, struct dlm_ckv_lock, lksb);
+	notify = container_of(ckv_lock, struct dlm_ckv_notify, pre_n);
+	bucket = ckv_lock->bucket;
+
+	queue_work(bucket->notify_wq, &notify->pre_n_work);
+}
+
+static void dlm_cvk_post_n_bast(void *astarg, int mode)
+{
+	struct dlm_ckv_lksb *lksb = astarg;
+	struct dlm_ckv_lock *ckv_lock;
+	struct dlm_ckv_bucket *bucket;
+	struct dlm_ckv_notify *notify;
+
+	ckv_lock = container_of(lksb, struct dlm_ckv_lock, lksb);
+	notify = container_of(ckv_lock, struct dlm_ckv_notify, post_n);
+	bucket = ckv_lock->bucket;
+
+	queue_work(bucket->notify_wq, &notify->post_n_work);
+}
+
+static void
+dlm_cvk_pre_n_work(struct work_struct *work)
+{
+	struct dlm_ckv_notify *notify = container_of(work,
+				struct dlm_ckv_notify, pre_n_work);
+	struct dlm_ckv_bucket *bucket = notify->pre_n.bucket;
+
+	dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_EX,
+			  &notify->post_n.lksb,
+			  DLM_LKF_CONVERT,
+			  notify->post_n.name, dlm_cvk_post_n_bast);
+	dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_NL,
+			  &notify->pre_n.lksb,
+			  DLM_LKF_CONVERT,
+			  notify->pre_n.name, dlm_cvk_pre_n_bast);
+}
+
+static void
+dlm_cvk_post_n_work(struct work_struct *work)
+{
+	struct dlm_ckv_notify *notify = container_of(work,
+				struct dlm_ckv_notify, post_n_work);
+	struct dlm_ckv_bucket *bucket = notify->post_n.bucket;
+
+	dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_EX,
+			  &notify->pre_n.lksb,
+			  DLM_LKF_CONVERT,
+			  notify->pre_n.name, dlm_cvk_pre_n_bast);
+
+	notify->notify_cb(bucket->userarg);
+
+	dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_NL,
+			  &notify->post_n.lksb,
+			  DLM_LKF_CONVERT,
+			  notify->post_n.name, dlm_cvk_post_n_bast);
+}
+
+struct dlm_ckv_notify *
+dlm_ckv_create_notification(struct dlm_ckv_bucket *bucket, const char *name,
+			      dlm_ckv_notify_cb cb)
+{
+	char lockname[DLM_RESNAME_MAXLEN];
+	struct dlm_ckv_notify *notify;
+	int res;
+
+	notify = kzalloc(sizeof(struct dlm_ckv_bucket), GFP_KERNEL);
+	if (!notify)
+		return NULL;
+
+	INIT_WORK(&notify->post_n_work, dlm_cvk_post_n_work);
+	INIT_WORK(&notify->pre_n_work, dlm_cvk_pre_n_work);
+
+	strscpy(notify->name, name, DLM_RESNAME_MAXLEN);
+	notify->notify_cb = cb;
+
+	kref_get(&bucket->refcount);
+
+	sprintf(lockname, "pre.%s.%d", name, bucket->local_nodeid);
+	dlm_ckv_lock_init(&notify->pre_n, bucket, lockname);
+
+	sprintf(lockname, "post.%s.%d", name, bucket->local_nodeid);
+	dlm_ckv_lock_init(&notify->post_n, bucket, lockname);
+
+	res = dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_EX,
+				&notify->pre_n.lksb, 0,
+				notify->pre_n.name, dlm_cvk_pre_n_bast);
+	if (res)
+		goto fail_locks;
+
+	res = dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_NL,
+				&notify->post_n.lksb, 0,
+				notify->post_n.name, dlm_cvk_post_n_bast);
+	if (res)
+		goto fail_locks;
+
+	return notify;
+
+fail_locks:
+	kref_put(&bucket->refcount, bucket_release);
+	kfree(notify);
+
+	return NULL;
+}
+EXPORT_SYMBOL(dlm_ckv_create_notification);
+
+void
+dlm_ckv_free_notification(struct dlm_ckv_notify *notify)
+{
+	struct dlm_ckv_bucket *bucket = notify->pre_n.bucket;
+
+	cancel_work_sync(&notify->pre_n_work);
+	cancel_work_sync(&notify->post_n_work);
+
+	kfree(notify);
+	kref_put(&bucket->refcount, bucket_release);
+}
+EXPORT_SYMBOL(dlm_ckv_free_notification);
+
+static void
+dlm_ckv_toggle_lock(struct dlm_ckv_bucket *bucket, const char *name_prefix)
+{
+	char lockname[DLM_RESNAME_MAXLEN];
+	struct dlm_ckv_lksb lksb;
+	int res;
+	int i;
+
+	init_completion(&lksb.compl);
+
+	for (i = 0; i < bucket->num_nodes; ++i) {
+		if (bucket->nodeid[i] == bucket->local_nodeid)
+			continue;
+		snprintf(lockname, sizeof(lockname), "%s.%d", name_prefix,
+			 bucket->nodeid[i]);
+
+		lksb.lksb.sb_lkid = 0;
+		res = dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_PR,
+				&lksb, 0, lockname, NULL);
+		if (res < 0)
+			pr_warn("Locking %s failed (%d)", lockname, res);
+		if (!lksb.lksb.sb_lkid)
+			continue;
+
+		dlm_ckv_lock_wait(bucket->ls, DLM_LOCK_NL, &lksb,
+					DLM_LKF_CONVERT, lockname, NULL);
+		dlm_ckv_unlock_wait(bucket->ls, &lksb);
+	}
+}
+
+int dlm_ckv_notify(struct dlm_ckv_notify *notify)
+{
+	struct dlm_ckv_bucket *bucket = notify->pre_n.bucket;
+	char lockname[DLM_RESNAME_MAXLEN];
+
+	snprintf(lockname, sizeof(lockname), "post.%s", notify->name);
+	dlm_ckv_toggle_lock(bucket, lockname);
+
+	snprintf(lockname, sizeof(lockname), "pre.%s", notify->name);
+	dlm_ckv_toggle_lock(bucket, lockname);
+
+	snprintf(lockname, sizeof(lockname), "post.%s", notify->name);
+	dlm_ckv_toggle_lock(bucket, lockname);
+
+	return 0;
+}
+EXPORT_SYMBOL(dlm_ckv_notify);
 
 static void bucket_release(struct kref *ref)
 {
@@ -237,6 +420,8 @@ static void bucket_release(struct kref *ref)
 						     refcount);
 	int res;
 
+	destroy_workqueue(bucket->notify_wq);
+
 	res = dlm_release_lockspace(bucket->ls, 2);
 	if (res)
 		pr_err("forcibly releasing lockspace failed: %d\n",
@@ -264,6 +449,7 @@ dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
 
 	bucket->userarg = userarg;
 	init_completion(&bucket->sync_compl);
+	bucket->notify_wq = alloc_ordered_workqueue("notify_wq-%s", 0, name);
 
 	err = dlm_new_lockspace(name, cluster_name,
 				DLM_LSFL_FS | DLM_LSFL_NEWEXCL, DLM_CKV_LVB_SIZE,
diff --git a/drivers/target/dlm_ckv.h b/drivers/target/dlm_ckv.h
index 1a3f79e42bf6..080d9498f5f9 100644
--- a/drivers/target/dlm_ckv.h
+++ b/drivers/target/dlm_ckv.h
@@ -5,6 +5,8 @@
 struct dlm_ckv_bucket;
 struct dlm_ckv_lock;
 
+typedef void (*dlm_ckv_notify_cb)(void *userarg);
+
 struct dlm_ckv_bucket *dlm_ckv_open_bucket(const char *name,
 					   const char *cluster_name,
 					   void *userarg);
@@ -16,4 +18,10 @@ void dlm_ckv_free_lock(struct dlm_ckv_lock *ckv_lock);
 int dlm_ckv_lock_get(struct dlm_ckv_lock *ckv_lock);
 int dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock);
 
+struct dlm_ckv_notify *
+dlm_ckv_create_notification(struct dlm_ckv_bucket *bucket, const char *name,
+			    dlm_ckv_notify_cb cb);
+void dlm_ckv_free_notification(struct dlm_ckv_notify *notify);
+int dlm_ckv_notify(struct dlm_ckv_notify *notify);
+
 #endif
-- 
2.25.1

