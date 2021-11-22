Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D108EC3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbiHCQaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiHCQ3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:49 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A64491C8;
        Wed,  3 Aug 2022 09:29:47 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 26D0B4132C;
        Wed,  3 Aug 2022 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544184; x=1661358585; bh=mSDTwFr55J6/EqbLfDIs9OFkW
        BeHO79zTZOG0+WN3Oo=; b=PiBl76ZR7OH9T5HSctQ0q7kghZmZid52y8A2gXWBG
        /tiOlWdWf1twIAqH+jlBoYhngCEjLJ3hDzZICRgXUjBrwaMFcapbVi1lvp+CgQba
        5zHGjeFg7cme6umyMseUgTBOAR+iAC8wjk0WED9ty5OG7zbNwJOMEQqe7LoYC1vr
        lI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VAJANPcnqkoC; Wed,  3 Aug 2022 19:29:44 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C284E412D0;
        Wed,  3 Aug 2022 19:29:21 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
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
Subject: [RFC PATCH 33/48] dlm_ckv: add key-value storage service
Date:   Mon, 22 Nov 2021 20:12:57 +0300
Message-ID: <20220803162857.27770-34-d.bogdanov@yadro.com>
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

Simple key-value cluster storage.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/dlm_ckv.c | 128 +++++++++++++++++++++++++++++++++++++++
 drivers/target/dlm_ckv.h |   9 +++
 2 files changed, 137 insertions(+)

diff --git a/drivers/target/dlm_ckv.c b/drivers/target/dlm_ckv.c
index cffe4f2dcb82..22c5f0827595 100644
--- a/drivers/target/dlm_ckv.c
+++ b/drivers/target/dlm_ckv.c
@@ -25,6 +25,10 @@ struct dlm_ckv_lock {
 	char name[DLM_RESNAME_MAXLEN];
 };
 
+struct dlm_ckv_kv {
+	struct dlm_ckv_lock lock;
+};
+
 struct dlm_ckv_bucket {
 	dlm_lockspace_t *ls;
 	struct kref refcount;
@@ -240,6 +244,130 @@ dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock)
 }
 EXPORT_SYMBOL(dlm_ckv_lock_release);
 
+struct dlm_ckv_kv *
+dlm_ckv_create_kv(struct dlm_ckv_bucket *bucket, const char *key)
+{
+	struct dlm_ckv_lock *ckv_lock;
+	void *ptr;
+	int res;
+
+	ptr = kzalloc(DLM_CKV_LVB_SIZE, GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	ckv_lock = dlm_ckv_create_lock(bucket, key);
+	if (!ckv_lock)
+		goto create_fail;
+
+	ckv_lock->lksb.lksb.sb_lvbptr = ptr;
+
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_NL,
+				&ckv_lock->lksb, 0, ckv_lock->name, NULL);
+	if (res)
+		goto lock_failed;
+
+	return (struct dlm_ckv_kv *)ckv_lock;
+
+lock_failed:
+	dlm_ckv_free_lock(ckv_lock);
+create_fail:
+	kfree(ptr);
+	return NULL;
+}
+EXPORT_SYMBOL(dlm_ckv_create_kv);
+
+void
+dlm_ckv_free_kv(struct dlm_ckv_kv *kv)
+{
+	struct dlm_ckv_bucket *bucket = kv->lock.bucket;
+	struct dlm_ckv_lock *ckv_lock = &kv->lock;
+
+	dlm_ckv_unlock_wait(bucket->ls, &ckv_lock->lksb);
+
+	kfree(ckv_lock->lksb.lksb.sb_lvbptr);
+	kfree(ckv_lock);
+
+	kref_put(&bucket->refcount, bucket_release);
+
+}
+EXPORT_SYMBOL(dlm_ckv_free_kv);
+
+int
+dlm_ckv_get(struct dlm_ckv_kv *kv, char *value, size_t len)
+{
+	struct dlm_ckv_lock *ckv_lock = &kv->lock;
+	struct dlm_ckv_bucket *bucket;
+	int res;
+
+	BUG_ON(!ckv_lock);
+	bucket = ckv_lock->bucket;
+
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_CR,
+				&ckv_lock->lksb,
+				DLM_LKF_VALBLK | DLM_LKF_CONVERT,
+				ckv_lock->name, NULL);
+	if (res) {
+		pr_info("Can not get lock %s, rc=%d\n",
+			ckv_lock->name, res);
+		goto fail;
+	}
+
+	if (ckv_lock->lksb.lksb.sb_flags & DLM_SBF_VALNOTVALID) {
+		pr_info(" %s LVB was invalid\n", ckv_lock->name);
+		memset(value, 0, len);
+	} else
+		memcpy(value, ckv_lock->lksb.lksb.sb_lvbptr, len);
+
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_NL,
+				&ckv_lock->lksb,
+				DLM_LKF_CONVERT,
+				ckv_lock->name, NULL);
+	if (res) {
+		pr_info("Can not release lock %s\n", ckv_lock->name);
+		goto fail;
+	}
+
+	return res;
+fail:
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_get);
+
+int
+dlm_ckv_set(struct dlm_ckv_kv *kv, const char *value, size_t len)
+{
+	struct dlm_ckv_lock *ckv_lock = &kv->lock;
+	struct dlm_ckv_bucket *bucket;
+	int res;
+
+	BUG_ON(!ckv_lock);
+	bucket = ckv_lock->bucket;
+
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_EX,
+				&ckv_lock->lksb,
+				DLM_LKF_CONVERT,
+				ckv_lock->name, NULL);
+	if (res) {
+		pr_info("Can not get lock %s\n", ckv_lock->name);
+		goto fail;
+	}
+
+	memcpy(ckv_lock->lksb.lksb.sb_lvbptr, value, len);
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_NL,
+				&ckv_lock->lksb,
+				DLM_LKF_VALBLK | DLM_LKF_CONVERT,
+				ckv_lock->name, NULL);
+	if (res) {
+		pr_info("Can not release lock %s\n", ckv_lock->name);
+		goto fail;
+	}
+
+	return res;
+fail:
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_set);
+
 static void dlm_cvk_pre_n_bast(void *astarg, int mode)
 {
 	struct dlm_ckv_lksb *lksb = astarg;
diff --git a/drivers/target/dlm_ckv.h b/drivers/target/dlm_ckv.h
index 080d9498f5f9..c01904313f1e 100644
--- a/drivers/target/dlm_ckv.h
+++ b/drivers/target/dlm_ckv.h
@@ -4,6 +4,9 @@
 
 struct dlm_ckv_bucket;
 struct dlm_ckv_lock;
+struct dlm_ckv_kv;
+
+#define DLM_CKV_VALUE_MAX_SIZE	255
 
 typedef void (*dlm_ckv_notify_cb)(void *userarg);
 
@@ -18,6 +21,12 @@ void dlm_ckv_free_lock(struct dlm_ckv_lock *ckv_lock);
 int dlm_ckv_lock_get(struct dlm_ckv_lock *ckv_lock);
 int dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock);
 
+struct dlm_ckv_kv *
+dlm_ckv_create_kv(struct dlm_ckv_bucket *bucket, const char *key);
+void dlm_ckv_free_kv(struct dlm_ckv_kv *kv);
+int dlm_ckv_get(struct dlm_ckv_kv *kv, char *value, size_t len);
+int dlm_ckv_set(struct dlm_ckv_kv *kv, const char *value, size_t len);
+
 struct dlm_ckv_notify *
 dlm_ckv_create_notification(struct dlm_ckv_bucket *bucket, const char *name,
 			    dlm_ckv_notify_cb cb);
-- 
2.25.1

