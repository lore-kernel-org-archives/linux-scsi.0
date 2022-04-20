Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C732C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 06:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357079AbiDTGu7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 02:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343934AbiDTGu5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 02:50:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB326569;
        Tue, 19 Apr 2022 23:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cO+SO7n9mkI53mE+eQRjpm+XcnQGrE5grqRwzwXx9+c=; b=oX0mvWbSY5aonUq7nf+gStykFo
        1D+JIQZNctZOmnmdIlXaluB7SgrsTs1ULm6bDi6YYnedZaVL4mEDBnHDf62gXlg/R4YkuXW/5h7wo
        Ta61N1ZKxjPoIdaoJS/lhANqhYLdAOpVw+QTtZhvl+lnQd8sZiopTHLKalgtgG+zmnwJwM8hZ236S
        3iZ4ZCxYxu2Wb+x8CbCAElknOhpc+O0mSOdr1KPMolgWD+Dys+dYhR/8mA/zE9EIsvI9ZM6wcni6X
        y7Nn12WbIQkY6TnNVMzT2dYXjpphLG/LDgbB8vCFoP6dMJQl64EZX/BVp7UE8Ck7FJqkjHK5SD2Cw
        8akVXzsg==;
Received: from [2001:4bb8:191:364b:4299:55c7:4b14:f042] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nh480-007cZI-LV; Wed, 20 Apr 2022 06:47:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] blk-crypto: merge blk-crypto-sysfs.c into blk-crypto-profile.c
Date:   Wed, 20 Apr 2022 08:47:44 +0200
Message-Id: <20220420064745.1119823-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220420064745.1119823-1-hch@lst.de>
References: <20220420064745.1119823-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge blk-crypto-sysfs.c into blk-crypto-profile.c in preparation of
fixing the kobject lifetimes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Makefile             |   3 +-
 block/blk-crypto-profile.c | 164 ++++++++++++++++++++++++++++++++++-
 block/blk-crypto-sysfs.c   | 172 -------------------------------------
 3 files changed, 164 insertions(+), 175 deletions(-)
 delete mode 100644 block/blk-crypto-sysfs.c

diff --git a/block/Makefile b/block/Makefile
index 3950ecbc5c263..f38eaa6129296 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
 obj-$(CONFIG_BLK_DEBUG_FS_ZONED)+= blk-mq-debugfs-zoned.o
 obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
 obj-$(CONFIG_BLK_PM)		+= blk-pm.o
-obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
-					   blk-crypto-sysfs.o
+obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o
 obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
 obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 96c511967386d..4f444323cb491 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright 2019 Google LLC
+ * Copyright 2019-2021 Google LLC
  */
 
 /**
@@ -32,6 +32,7 @@
 #include <linux/wait.h>
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include "blk-crypto-internal.h"
 
 struct blk_crypto_keyslot {
 	atomic_t slot_refs;
@@ -41,6 +42,150 @@ struct blk_crypto_keyslot {
 	struct blk_crypto_profile *profile;
 };
 
+struct blk_crypto_kobj {
+	struct kobject kobj;
+	struct blk_crypto_profile *profile;
+};
+
+struct blk_crypto_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_crypto_profile *profile,
+			struct blk_crypto_attr *attr, char *page);
+};
+
+static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
+{
+	return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
+}
+
+static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
+{
+	return container_of(attr, struct blk_crypto_attr, attr);
+}
+
+static ssize_t max_dun_bits_show(struct blk_crypto_profile *profile,
+				 struct blk_crypto_attr *attr, char *page)
+{
+	return sysfs_emit(page, "%u\n", 8 * profile->max_dun_bytes_supported);
+}
+
+static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
+				 struct blk_crypto_attr *attr, char *page)
+{
+	return sysfs_emit(page, "%u\n", profile->num_slots);
+}
+
+#define BLK_CRYPTO_RO_ATTR(_name) \
+	static struct blk_crypto_attr _name##_attr = __ATTR_RO(_name)
+
+BLK_CRYPTO_RO_ATTR(max_dun_bits);
+BLK_CRYPTO_RO_ATTR(num_keyslots);
+
+static struct attribute *blk_crypto_attrs[] = {
+	&max_dun_bits_attr.attr,
+	&num_keyslots_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group blk_crypto_attr_group = {
+	.attrs = blk_crypto_attrs,
+};
+
+/*
+ * The encryption mode attributes.  To avoid hard-coding the list of encryption
+ * modes, these are initialized at boot time by blk_crypto_sysfs_init().
+ */
+static struct blk_crypto_attr __blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX];
+static struct attribute *blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX + 1];
+
+static umode_t blk_crypto_mode_is_visible(struct kobject *kobj,
+					  struct attribute *attr, int n)
+{
+	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
+	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
+	int mode_num = a - __blk_crypto_mode_attrs;
+
+	if (profile->modes_supported[mode_num])
+		return 0444;
+	return 0;
+}
+
+static ssize_t blk_crypto_mode_show(struct blk_crypto_profile *profile,
+				    struct blk_crypto_attr *attr, char *page)
+{
+	int mode_num = attr - __blk_crypto_mode_attrs;
+
+	return sysfs_emit(page, "0x%x\n", profile->modes_supported[mode_num]);
+}
+
+static const struct attribute_group blk_crypto_modes_attr_group = {
+	.name = "modes",
+	.attrs = blk_crypto_mode_attrs,
+	.is_visible = blk_crypto_mode_is_visible,
+};
+
+static const struct attribute_group *blk_crypto_attr_groups[] = {
+	&blk_crypto_attr_group,
+	&blk_crypto_modes_attr_group,
+	NULL,
+};
+
+static ssize_t blk_crypto_attr_show(struct kobject *kobj,
+				    struct attribute *attr, char *page)
+{
+	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
+	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
+
+	return a->show(profile, a, page);
+}
+
+static const struct sysfs_ops blk_crypto_attr_ops = {
+	.show = blk_crypto_attr_show,
+};
+
+static void blk_crypto_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct blk_crypto_kobj, kobj));
+}
+
+static struct kobj_type blk_crypto_ktype = {
+	.default_groups = blk_crypto_attr_groups,
+	.sysfs_ops	= &blk_crypto_attr_ops,
+	.release	= blk_crypto_release,
+};
+
+/*
+ * If the request_queue has a blk_crypto_profile, create the "crypto"
+ * subdirectory in sysfs (/sys/block/$disk/queue/crypto/).
+ */
+int blk_crypto_sysfs_register(struct request_queue *q)
+{
+	struct blk_crypto_kobj *obj;
+	int err;
+
+	if (!q->crypto_profile)
+		return 0;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+	obj->profile = q->crypto_profile;
+
+	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
+				   "crypto");
+	if (err) {
+		kobject_put(&obj->kobj);
+		return err;
+	}
+	q->crypto_kobject = &obj->kobj;
+	return 0;
+}
+
+void blk_crypto_sysfs_unregister(struct request_queue *q)
+{
+	kobject_put(q->crypto_kobject);
+}
+
 static inline void blk_crypto_hw_enter(struct blk_crypto_profile *profile)
 {
 	/*
@@ -558,3 +703,20 @@ void blk_crypto_update_capabilities(struct blk_crypto_profile *dst,
 	dst->max_dun_bytes_supported = src->max_dun_bytes_supported;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_update_capabilities);
+
+static int __init blk_crypto_sysfs_init(void)
+{
+	int i;
+
+	BUILD_BUG_ON(BLK_ENCRYPTION_MODE_INVALID != 0);
+	for (i = 1; i < BLK_ENCRYPTION_MODE_MAX; i++) {
+		struct blk_crypto_attr *attr = &__blk_crypto_mode_attrs[i];
+
+		attr->attr.name = blk_crypto_modes[i].name;
+		attr->attr.mode = 0444;
+		attr->show = blk_crypto_mode_show;
+		blk_crypto_mode_attrs[i - 1] = &attr->attr;
+	}
+	return 0;
+}
+subsys_initcall(blk_crypto_sysfs_init);
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
deleted file mode 100644
index fd93bd2f33b75..0000000000000
--- a/block/blk-crypto-sysfs.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright 2021 Google LLC
- *
- * sysfs support for blk-crypto.  This file contains the code which exports the
- * crypto capabilities of devices via /sys/block/$disk/queue/crypto/.
- */
-
-#include <linux/blk-crypto-profile.h>
-
-#include "blk-crypto-internal.h"
-
-struct blk_crypto_kobj {
-	struct kobject kobj;
-	struct blk_crypto_profile *profile;
-};
-
-struct blk_crypto_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_crypto_profile *profile,
-			struct blk_crypto_attr *attr, char *page);
-};
-
-static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
-{
-	return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
-}
-
-static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
-{
-	return container_of(attr, struct blk_crypto_attr, attr);
-}
-
-static ssize_t max_dun_bits_show(struct blk_crypto_profile *profile,
-				 struct blk_crypto_attr *attr, char *page)
-{
-	return sysfs_emit(page, "%u\n", 8 * profile->max_dun_bytes_supported);
-}
-
-static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
-				 struct blk_crypto_attr *attr, char *page)
-{
-	return sysfs_emit(page, "%u\n", profile->num_slots);
-}
-
-#define BLK_CRYPTO_RO_ATTR(_name) \
-	static struct blk_crypto_attr _name##_attr = __ATTR_RO(_name)
-
-BLK_CRYPTO_RO_ATTR(max_dun_bits);
-BLK_CRYPTO_RO_ATTR(num_keyslots);
-
-static struct attribute *blk_crypto_attrs[] = {
-	&max_dun_bits_attr.attr,
-	&num_keyslots_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group blk_crypto_attr_group = {
-	.attrs = blk_crypto_attrs,
-};
-
-/*
- * The encryption mode attributes.  To avoid hard-coding the list of encryption
- * modes, these are initialized at boot time by blk_crypto_sysfs_init().
- */
-static struct blk_crypto_attr __blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX];
-static struct attribute *blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX + 1];
-
-static umode_t blk_crypto_mode_is_visible(struct kobject *kobj,
-					  struct attribute *attr, int n)
-{
-	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
-	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
-	int mode_num = a - __blk_crypto_mode_attrs;
-
-	if (profile->modes_supported[mode_num])
-		return 0444;
-	return 0;
-}
-
-static ssize_t blk_crypto_mode_show(struct blk_crypto_profile *profile,
-				    struct blk_crypto_attr *attr, char *page)
-{
-	int mode_num = attr - __blk_crypto_mode_attrs;
-
-	return sysfs_emit(page, "0x%x\n", profile->modes_supported[mode_num]);
-}
-
-static const struct attribute_group blk_crypto_modes_attr_group = {
-	.name = "modes",
-	.attrs = blk_crypto_mode_attrs,
-	.is_visible = blk_crypto_mode_is_visible,
-};
-
-static const struct attribute_group *blk_crypto_attr_groups[] = {
-	&blk_crypto_attr_group,
-	&blk_crypto_modes_attr_group,
-	NULL,
-};
-
-static ssize_t blk_crypto_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *page)
-{
-	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
-	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
-
-	return a->show(profile, a, page);
-}
-
-static const struct sysfs_ops blk_crypto_attr_ops = {
-	.show = blk_crypto_attr_show,
-};
-
-static void blk_crypto_release(struct kobject *kobj)
-{
-	kfree(container_of(kobj, struct blk_crypto_kobj, kobj));
-}
-
-static struct kobj_type blk_crypto_ktype = {
-	.default_groups = blk_crypto_attr_groups,
-	.sysfs_ops	= &blk_crypto_attr_ops,
-	.release	= blk_crypto_release,
-};
-
-/*
- * If the request_queue has a blk_crypto_profile, create the "crypto"
- * subdirectory in sysfs (/sys/block/$disk/queue/crypto/).
- */
-int blk_crypto_sysfs_register(struct request_queue *q)
-{
-	struct blk_crypto_kobj *obj;
-	int err;
-
-	if (!q->crypto_profile)
-		return 0;
-
-	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
-	obj->profile = q->crypto_profile;
-
-	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
-				   "crypto");
-	if (err) {
-		kobject_put(&obj->kobj);
-		return err;
-	}
-	q->crypto_kobject = &obj->kobj;
-	return 0;
-}
-
-void blk_crypto_sysfs_unregister(struct request_queue *q)
-{
-	kobject_put(q->crypto_kobject);
-}
-
-static int __init blk_crypto_sysfs_init(void)
-{
-	int i;
-
-	BUILD_BUG_ON(BLK_ENCRYPTION_MODE_INVALID != 0);
-	for (i = 1; i < BLK_ENCRYPTION_MODE_MAX; i++) {
-		struct blk_crypto_attr *attr = &__blk_crypto_mode_attrs[i];
-
-		attr->attr.name = blk_crypto_modes[i].name;
-		attr->attr.mode = 0444;
-		attr->show = blk_crypto_mode_show;
-		blk_crypto_mode_attrs[i - 1] = &attr->attr;
-	}
-	return 0;
-}
-subsys_initcall(blk_crypto_sysfs_init);
-- 
2.30.2

