Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358F7C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiHCQaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbiHCQ3v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:51 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF904A815;
        Wed,  3 Aug 2022 09:29:49 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A35544133A;
        Wed,  3 Aug 2022 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544186; x=1661358587; bh=ZbDUJV5W2MMKsVdc3cnlzmakj
        9+yeRVqsuaxQTcQkZU=; b=LFbHOwpDRIJNXonPCwzXKAkw9SHB9f+dNYqCyTrpU
        aW//dzaCpfE7EKlwJTvzq3yh1cXtY0onHzeA8ymK55rLF5sglWSArz6cM2inr6m6
        QBvCloEOHpiaDDEr4xLI5cK2kvtRPdNN6royphgKLBxOtSHBwcSI6kShssYaKQah
        BA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8WDluY1MB3D9; Wed,  3 Aug 2022 19:29:46 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 05ADE412E5;
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
Subject: [RFC PATCH 34/48] dlm_ckv: add KV get/set async API
Date:   Wed, 22 Dec 2021 15:38:14 +0300
Message-ID: <20220803162857.27770-35-d.bogdanov@yadro.com>
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

The sync versions of KV set/get functions may take too long time if user
want to store/read a number of keys.
Add async versions of KV get/set functions to allow the user to group
the requests and to wait for completion of all requests together.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/dlm_ckv.c | 110 ++++++++++++++++++++++++++++++++++++++-
 drivers/target/dlm_ckv.h |   6 +++
 2 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/target/dlm_ckv.c b/drivers/target/dlm_ckv.c
index 22c5f0827595..417159f18fc6 100644
--- a/drivers/target/dlm_ckv.c
+++ b/drivers/target/dlm_ckv.c
@@ -14,15 +14,27 @@
 #include <target/target_core_base.h>
 #include "dlm_ckv.h"
 
+enum dlm_lksb_state {
+	ONE_STAGE_SYNC,
+	READ_FIRST_STAGE,
+	READ_SECOND_STAGE,
+	WRITE_FIRST_STAGE,
+	WRITE_SECOND_STAGE,
+};
 struct dlm_ckv_lksb {
 	struct dlm_lksb lksb;
 	struct completion compl;
+	enum dlm_lksb_state state;
 };
 
 struct dlm_ckv_lock {
 	struct dlm_ckv_bucket *bucket;
 	struct dlm_ckv_lksb lksb;
 	char name[DLM_RESNAME_MAXLEN];
+	dlm_ckv_async_cb async_cb;
+	void *cb_arg;
+	void *value;
+	size_t len;
 };
 
 struct dlm_ckv_kv {
@@ -97,8 +109,48 @@ static const struct dlm_lockspace_ops dlm_ckv_lockspace_ops = {
 static void dlm_ast(void *astarg)
 {
 	struct dlm_ckv_lksb *dlm_ckv_lksb = astarg;
+	struct dlm_ckv_lock *ckv_lock;
+	struct dlm_ckv_bucket *bucket;
+	int res;
+
+	ckv_lock = container_of(dlm_ckv_lksb, struct dlm_ckv_lock, lksb);
+	bucket = ckv_lock->bucket;
 
-	complete(&dlm_ckv_lksb->compl);
+	switch (dlm_ckv_lksb->state) {
+	case ONE_STAGE_SYNC:
+		complete(&dlm_ckv_lksb->compl);
+		break;
+	case READ_FIRST_STAGE:
+		if (dlm_ckv_lksb->lksb.sb_flags & DLM_SBF_VALNOTVALID) {
+			pr_debug("%s LVB was invalid\n", ckv_lock->name);
+			memset(ckv_lock->value, 0, ckv_lock->len);
+		} else
+			memcpy(ckv_lock->value, dlm_ckv_lksb->lksb.sb_lvbptr,
+			       ckv_lock->len);
+
+		dlm_ckv_lksb->state = READ_SECOND_STAGE;
+		res = dlm_lock(ckv_lock->bucket->ls, DLM_LOCK_NL,
+			       &dlm_ckv_lksb->lksb, DLM_LKF_CONVERT, 0, 0, 0,
+			       dlm_ast, dlm_ckv_lksb, NULL);
+		if (res)
+			ckv_lock->async_cb(ckv_lock->cb_arg, res);
+		break;
+	case WRITE_FIRST_STAGE:
+
+		dlm_ckv_lksb->state = WRITE_SECOND_STAGE;
+		res = dlm_lock(ckv_lock->bucket->ls, DLM_LOCK_NL,
+			       &dlm_ckv_lksb->lksb,
+			       DLM_LKF_VALBLK | DLM_LKF_CONVERT, 0, 0, 0,
+			       dlm_ast, dlm_ckv_lksb, NULL);
+		if (res)
+			ckv_lock->async_cb(ckv_lock->cb_arg, res);
+		break;
+	case READ_SECOND_STAGE:
+		fallthrough;
+	case WRITE_SECOND_STAGE:
+		ckv_lock->async_cb(ckv_lock->cb_arg, dlm_ckv_lksb->lksb.sb_status);
+		break;
+	}
 }
 
 /*
@@ -135,6 +187,7 @@ static int dlm_ckv_lock_wait(dlm_lockspace_t *ls, int mode,
 {
 	int res;
 
+	lksb->state = ONE_STAGE_SYNC;
 	res = dlm_lock(ls, mode, &lksb->lksb, flags,
 		       (void *)name, name ? strlen(name) : 0, 0,
 		       dlm_ast, lksb, bast);
@@ -164,6 +217,7 @@ static int dlm_ckv_unlock_wait(dlm_lockspace_t *ls, struct dlm_ckv_lksb *lksb)
 {
 	int res;
 
+	lksb->state = ONE_STAGE_SYNC;
 	res = dlm_unlock(ls, lksb->lksb.sb_lkid, 0, &lksb->lksb, lksb);
 	if (res < 0)
 		goto out;
@@ -333,6 +387,32 @@ dlm_ckv_get(struct dlm_ckv_kv *kv, char *value, size_t len)
 }
 EXPORT_SYMBOL(dlm_ckv_get);
 
+int
+dlm_ckv_get_async(struct dlm_ckv_kv *kv, char *value, size_t len,
+		  dlm_ckv_async_cb cb, void *cb_arg)
+{
+	struct dlm_ckv_lock *ckv_lock = &kv->lock;
+	struct dlm_ckv_bucket *bucket;
+	int res;
+
+	BUG_ON(!ckv_lock);
+	bucket = ckv_lock->bucket;
+
+	ckv_lock->lksb.state = READ_FIRST_STAGE;
+	ckv_lock->len = len;
+	ckv_lock->value = value;
+	ckv_lock->async_cb = cb;
+	ckv_lock->cb_arg = cb_arg;
+	res = dlm_lock(ckv_lock->bucket->ls, DLM_LOCK_CR, &ckv_lock->lksb.lksb,
+		       DLM_LKF_VALBLK | DLM_LKF_CONVERT, NULL, 0, 0,
+		       dlm_ast, &ckv_lock->lksb, NULL);
+	if (res)
+		pr_info("Can not get lock %s, rc=%d\n", ckv_lock->name, res);
+
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_get_async);
+
 int
 dlm_ckv_set(struct dlm_ckv_kv *kv, const char *value, size_t len)
 {
@@ -368,6 +448,34 @@ dlm_ckv_set(struct dlm_ckv_kv *kv, const char *value, size_t len)
 }
 EXPORT_SYMBOL(dlm_ckv_set);
 
+int
+dlm_ckv_set_async(struct dlm_ckv_kv *kv, char *value, size_t len,
+		  dlm_ckv_async_cb cb, void *cb_arg)
+{
+	struct dlm_ckv_lock *ckv_lock = &kv->lock;
+	struct dlm_ckv_bucket *bucket;
+	int res;
+
+	BUG_ON(!ckv_lock);
+	bucket = ckv_lock->bucket;
+
+	ckv_lock->lksb.state = WRITE_FIRST_STAGE;
+	ckv_lock->len = len;
+	ckv_lock->value = value;
+	ckv_lock->async_cb = cb;
+	ckv_lock->cb_arg = cb_arg;
+	memcpy(ckv_lock->lksb.lksb.sb_lvbptr, ckv_lock->value, ckv_lock->len);
+
+	res = dlm_lock(ckv_lock->bucket->ls, DLM_LOCK_EX, &ckv_lock->lksb.lksb,
+		       DLM_LKF_CONVERT, NULL, 0, 0,
+		       dlm_ast, &ckv_lock->lksb, NULL);
+	if (res)
+		pr_info("Can not get lock %s\n", ckv_lock->name);
+
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_set_async);
+
 static void dlm_cvk_pre_n_bast(void *astarg, int mode)
 {
 	struct dlm_ckv_lksb *lksb = astarg;
diff --git a/drivers/target/dlm_ckv.h b/drivers/target/dlm_ckv.h
index c01904313f1e..e8045917067e 100644
--- a/drivers/target/dlm_ckv.h
+++ b/drivers/target/dlm_ckv.h
@@ -9,6 +9,8 @@ struct dlm_ckv_kv;
 #define DLM_CKV_VALUE_MAX_SIZE	255
 
 typedef void (*dlm_ckv_notify_cb)(void *userarg);
+typedef void (*dlm_ckv_async_cb)(void *userarg, int res);
+typedef void (*dlm_ckv_nodeleft_cb)(void *arg, int nodeid);
 
 struct dlm_ckv_bucket *dlm_ckv_open_bucket(const char *name,
 					   const char *cluster_name,
@@ -26,6 +28,10 @@ dlm_ckv_create_kv(struct dlm_ckv_bucket *bucket, const char *key);
 void dlm_ckv_free_kv(struct dlm_ckv_kv *kv);
 int dlm_ckv_get(struct dlm_ckv_kv *kv, char *value, size_t len);
 int dlm_ckv_set(struct dlm_ckv_kv *kv, const char *value, size_t len);
+int dlm_ckv_get_async(struct dlm_ckv_kv *kv, char *value, size_t len,
+		      dlm_ckv_async_cb cb, void *cb_arg);
+int dlm_ckv_set_async(struct dlm_ckv_kv *kv, char *value, size_t len,
+		      dlm_ckv_async_cb cb, void *cb_arg);
 
 struct dlm_ckv_notify *
 dlm_ckv_create_notification(struct dlm_ckv_bucket *bucket, const char *name,
-- 
2.25.1

