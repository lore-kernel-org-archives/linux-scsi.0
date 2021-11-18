Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8C4C19F2D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbiHCQaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiHCQ3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:47 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E68481EE;
        Wed,  3 Aug 2022 09:29:45 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 376294131D;
        Wed,  3 Aug 2022 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544182; x=1661358583; bh=3V8PNmQx6JMWrGXlflRLkYHv1
        l+opJDmmQGxfMLHRRQ=; b=p8rn44AoQJmAFK+qgsTAiF/72iFrfz3JobEofbje7
        zH0+Irt+PIcRHHFtGHOpeiS/jNpb9V7+8V81J02Zgc3osHGfrHVanRnTptepvNXT
        VMBHs19vCrXdC4hOlkXzdDNw61Bwxbt7FkSIQtUlFfXbM9hSErYTR2oFuyd0duMO
        8U=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 03OqYSBL-xlQ; Wed,  3 Aug 2022 19:29:42 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1F5AA412D6;
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
Subject: [RFC PATCH 31/48] dlm_ckv: introduce DLM cluster key-value storage
Date:   Thu, 18 Nov 2021 10:52:33 +0300
Message-ID: <20220803162857.27770-32-d.bogdanov@yadro.com>
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

Introduce the first version of DLM CKV module that could be used by
different kernel subsystems to share some information in a cluster.

This commit has just cluster level locks.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/Kconfig   |   6 +
 drivers/target/Makefile  |   2 +
 drivers/target/dlm_ckv.c | 323 +++++++++++++++++++++++++++++++++++++++
 drivers/target/dlm_ckv.h |  19 +++
 4 files changed, 350 insertions(+)
 create mode 100644 drivers/target/dlm_ckv.c
 create mode 100644 drivers/target/dlm_ckv.h

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 72171ea3dd53..75d5e1d23a1c 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -35,6 +35,12 @@ config TCM_PSCSI
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device
 
+config DLM_CKV
+	tristate "Cluster key value storage over DLM"
+	depends on DLM
+	help
+	Say Y here to enable the cluster key value storage over DLM
+
 config TCM_USER2
 	tristate "TCM/USER Subsystem Plugin for Linux"
 	depends on UIO && NET
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 45634747377e..8bc9ac2bd629 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -30,3 +30,5 @@ obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
 obj-$(CONFIG_SBP_TARGET)	+= sbp/
+
+obj-$(CONFIG_DLM_CKV)			+= dlm_ckv.o
diff --git a/drivers/target/dlm_ckv.c b/drivers/target/dlm_ckv.c
new file mode 100644
index 000000000000..a2e1a191c433
--- /dev/null
+++ b/drivers/target/dlm_ckv.c
@@ -0,0 +1,323 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <asm-generic/errno-base.h>
+#include <linux/kthread.h>
+#include <linux/dlmconstants.h>
+#include <linux/mutex.h>
+#include <linux/dlm.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <target/target_core_base.h>
+#include "dlm_ckv.h"
+
+struct dlm_ckv_lksb {
+	struct dlm_lksb lksb;
+	struct completion compl;
+};
+
+struct dlm_ckv_lock {
+	struct dlm_ckv_bucket *bucket;
+	struct dlm_ckv_lksb lksb;
+	char name[DLM_RESNAME_MAXLEN];
+};
+
+struct dlm_ckv_bucket {
+	dlm_lockspace_t *ls;
+	struct kref refcount;
+	u32 local_nodeid;
+	u32 local_slotid;
+	size_t num_nodes;
+	int nodeid[64];
+	void *userarg;
+	struct completion sync_compl;
+};
+
+
+#define DLM_CKV_LVB_SIZE	256
+
+static void bucket_release(struct kref *ref);
+
+/* dlm calls before it does lock recovery */
+
+static void dlm_ckv_recover_prep(void *arg)
+{
+
+}
+
+/* dlm calls after recover_prep has been completed on all lockspace members;
+ * identifies slot/jid of failed member
+ */
+
+static void dlm_ckv_recover_slot(void *arg, struct dlm_slot *slot)
+{
+	pr_info("nodeid %d left the cluster\n", slot->nodeid);
+}
+
+/* dlm calls after recover_slot and after it completes lock recovery */
+
+static void dlm_ckv_recover_done(void *arg, struct dlm_slot *slots, int num_slots,
+			      int our_slot, uint32_t generation)
+{
+	struct dlm_ckv_bucket *bucket = arg;
+	int i;
+
+	for (i = 0; i < num_slots; i++) {
+		bucket->nodeid[i] = slots[i].nodeid;
+		if (slots[i].slot == our_slot)
+			bucket->local_nodeid = slots[i].nodeid;
+	}
+	bucket->local_slotid = our_slot;
+	bucket->num_nodes = num_slots;
+	complete(&bucket->sync_compl);
+}
+
+static const struct dlm_lockspace_ops dlm_ckv_lockspace_ops = {
+	.recover_prep = dlm_ckv_recover_prep,
+	.recover_slot = dlm_ckv_recover_slot,
+	.recover_done = dlm_ckv_recover_done,
+};
+
+static void dlm_ast(void *astarg)
+{
+	struct dlm_ckv_lksb *dlm_ckv_lksb = astarg;
+
+	complete(&dlm_ckv_lksb->compl);
+}
+
+/*
+ * dlm_ckv_cancel - Synchronously cancel a pending dlm_lock() operation
+ */
+static int dlm_ckv_cancel(dlm_lockspace_t *ls, struct dlm_ckv_lksb *lksb,
+			   int flags, const char *name)
+{
+	int res;
+
+	res = dlm_unlock(ls, lksb->lksb.sb_lkid,
+			      DLM_LKF_CANCEL | (flags & DLM_LKF_VALBLK),
+			      &lksb->lksb, lksb);
+	if (res < 0)
+		goto out;
+	res = wait_for_completion_timeout(&lksb->compl, 10 * HZ);
+
+out:
+	return res;
+}
+
+/**
+ * dlm_ckv_lock_wait - Wait until a DLM lock has been granted
+ * @ls:     DLM lock space.
+ * @mode:   DLM lock mode.
+ * @lksb:   DLM lock status block.
+ * @flags:  DLM flags.
+ * @name:   DLM lock name. Only required for non-conversion requests.
+ * @bast:   AST to be invoked in case this lock blocks another one.
+ */
+static int dlm_ckv_lock_wait(dlm_lockspace_t *ls, int mode,
+				struct dlm_ckv_lksb *lksb, int flags,
+				const char *name, void (*bast)(void *, int))
+{
+	int res;
+
+	res = dlm_lock(ls, mode, &lksb->lksb, flags,
+		       (void *)name, name ? strlen(name) : 0, 0,
+		       dlm_ast, lksb, bast);
+	if (res < 0)
+		goto out;
+	res = wait_for_completion_timeout(&lksb->compl, 60 * HZ);
+	if (res > 0)
+		res = lksb->lksb.sb_status;
+	else if (res == 0)
+		res = -ETIMEDOUT;
+	if (res < 0) {
+		int res2 = dlm_ckv_cancel(ls, lksb, flags, name);
+
+		if (res2 < 0)
+			pr_warn("canceling lock %s / %08x failed: %d\n",
+				name ? : "?", lksb->lksb.sb_lkid, res2);
+	}
+
+out:
+	return res;
+}
+
+/*
+ * dlm_ckv_unlock_wait - Release a DLM lock
+ */
+static int dlm_ckv_unlock_wait(dlm_lockspace_t *ls, struct dlm_ckv_lksb *lksb)
+{
+	int res;
+
+	res = dlm_unlock(ls, lksb->lksb.sb_lkid, 0, &lksb->lksb, lksb);
+	if (res < 0)
+		goto out;
+	res = wait_for_completion_timeout(&lksb->compl, 60 * HZ);
+	if (res > 0) {
+		res = lksb->lksb.sb_status;
+		if (res == -DLM_EUNLOCK || res == -DLM_ECANCEL)
+			res = 0;
+	} else if (res == 0) {
+		res = -ETIMEDOUT;
+	}
+
+out:
+	return res;
+}
+
+static void
+dlm_ckv_lock_init(struct dlm_ckv_lock *ckv_lock,
+		  struct dlm_ckv_bucket *bucket,
+		  const char *name)
+{
+	init_completion(&ckv_lock->lksb.compl);
+	strscpy(ckv_lock->name, name, DLM_RESNAME_MAXLEN);
+	ckv_lock->bucket = bucket;
+}
+
+struct dlm_ckv_lock *
+dlm_ckv_create_lock(struct dlm_ckv_bucket *bucket, const char *name)
+{
+	struct dlm_ckv_lock *ckv_lock;
+
+	ckv_lock = kzalloc(sizeof(struct dlm_ckv_lock), GFP_KERNEL);
+	if (!ckv_lock)
+		return NULL;
+
+	kref_get(&bucket->refcount);
+	dlm_ckv_lock_init(ckv_lock, bucket, name);
+
+	return ckv_lock;
+}
+EXPORT_SYMBOL(dlm_ckv_create_lock);
+
+void
+dlm_ckv_free_lock(struct dlm_ckv_lock *ckv_lock)
+{
+	struct dlm_ckv_bucket *bucket = ckv_lock->bucket;
+
+	kfree(ckv_lock);
+
+	kref_put(&bucket->refcount, bucket_release);
+}
+EXPORT_SYMBOL(dlm_ckv_free_lock);
+
+int
+dlm_ckv_lock_get(struct dlm_ckv_lock *ckv_lock)
+{
+	int res;
+
+	BUG_ON(!ckv_lock);
+
+	res = dlm_ckv_lock_wait(ckv_lock->bucket->ls, DLM_LOCK_EX,
+				&ckv_lock->lksb, 0, ckv_lock->name, NULL);
+
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_lock_get);
+
+int
+dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock)
+{
+	int res;
+
+	BUG_ON(!ckv_lock);
+
+	res = dlm_ckv_unlock_wait(ckv_lock->bucket->ls, &ckv_lock->lksb);
+
+	return res;
+}
+EXPORT_SYMBOL(dlm_ckv_lock_release);
+
+
+static void bucket_release(struct kref *ref)
+{
+	struct dlm_ckv_bucket *bucket = container_of(ref, struct dlm_ckv_bucket,
+						     refcount);
+	int res;
+
+	res = dlm_release_lockspace(bucket->ls, 2);
+	if (res)
+		pr_err("forcibly releasing lockspace failed: %d\n",
+		       res);
+
+	kfree(bucket);
+}
+
+struct dlm_ckv_bucket *
+dlm_ckv_open_bucket(const char *name, const char *cluster_name, void *userarg)
+{
+	struct dlm_ckv_bucket *bucket;
+	int name_len = strlen(name);
+	int ops_result;
+	int err;
+
+	if (!name)
+		return ERR_PTR(-EINVAL);
+
+	if (name_len > DLM_LOCKSPACE_LEN)
+		return ERR_PTR(-EINVAL);
+
+	bucket = kzalloc(sizeof(struct dlm_ckv_bucket), GFP_KERNEL);
+	kref_init(&bucket->refcount);
+
+	bucket->userarg = userarg;
+	init_completion(&bucket->sync_compl);
+
+	err = dlm_new_lockspace(name, cluster_name,
+				DLM_LSFL_FS | DLM_LSFL_NEWEXCL, DLM_CKV_LVB_SIZE,
+				&dlm_ckv_lockspace_ops, bucket, &ops_result,
+				&bucket->ls);
+	if (err) {
+		pr_err("dlm_new_lockspace error %d\n", err);
+		goto fail_free;
+	}
+
+	if (ops_result < 0) {
+		pr_err("dlm does not support ops callbacks\n");
+		err = -EOPNOTSUPP;
+		goto fail_free;
+	}
+
+	wait_for_completion_timeout(&bucket->sync_compl, 10 * HZ);
+	if (bucket->num_nodes == 0) {
+		pr_err("Cluster joining timed out\n");
+		goto fail_init;
+	}
+
+	return bucket;
+
+fail_init:
+	dlm_release_lockspace(bucket->ls, 2);
+fail_free:
+	kfree(bucket);
+
+	return NULL;
+}
+EXPORT_SYMBOL(dlm_ckv_open_bucket);
+
+int dlm_ckv_close_bucket(struct dlm_ckv_bucket *bucket)
+{
+	kref_put(&bucket->refcount, bucket_release);
+
+	return 0;
+}
+EXPORT_SYMBOL(dlm_ckv_close_bucket);
+
+static int __init dlm_ckv_module_init(void)
+{
+	return 0;
+}
+
+static void __exit dlm_ckv_module_exit(void)
+{
+
+}
+
+MODULE_DESCRIPTION("Cluster KV storage over DLM");
+MODULE_AUTHOR("Dmitry Bogdanov <d.bogdanov@yadro.com>");
+MODULE_LICENSE("GPL");
+
+module_init(dlm_ckv_module_init);
+module_exit(dlm_ckv_module_exit);
diff --git a/drivers/target/dlm_ckv.h b/drivers/target/dlm_ckv.h
new file mode 100644
index 000000000000..1a3f79e42bf6
--- /dev/null
+++ b/drivers/target/dlm_ckv.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef DLM_CKV_H
+#define DLM_CKV_H
+
+struct dlm_ckv_bucket;
+struct dlm_ckv_lock;
+
+struct dlm_ckv_bucket *dlm_ckv_open_bucket(const char *name,
+					   const char *cluster_name,
+					   void *userarg);
+int dlm_ckv_close_bucket(struct dlm_ckv_bucket *bucket);
+
+struct dlm_ckv_lock *
+dlm_ckv_create_lock(struct dlm_ckv_bucket *bucket, const char *name);
+void dlm_ckv_free_lock(struct dlm_ckv_lock *ckv_lock);
+int dlm_ckv_lock_get(struct dlm_ckv_lock *ckv_lock);
+int dlm_ckv_lock_release(struct dlm_ckv_lock *ckv_lock);
+
+#endif
-- 
2.25.1

