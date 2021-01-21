Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6DAC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404662399A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 08:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbhAUIji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 03:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbhAUIYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 03:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5F123976;
        Thu, 21 Jan 2021 08:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611217400;
        bh=Nb6omxaa1wVNGLVlPe38PisO9ENPDbQX3d2m6I4vlcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlX91mut2CCVxM6K8c1RbAQqfBAscsCcePa5hQZm6DIdy6x92WkeIFpGsYiDtSaad
         3HFXHe1nnzIEiFM437dWQrZ+ad5BYID318jP6WCxZ/JJYkMmue+pbfSPo2bnm0wk+k
         DLZ34QCeJazLLLzgBCbn3lmJqGUYVNCSERIu+SNThwWq6shNp/RRGajXxlcvIQ5egT
         ua25Y3ngcWmi/z1mLETVZ0BaBU2uaWJ07lEYMVepXSyqQcIYkn2TkohINYK/4a7HBo
         b4tzh/CYjyqA/zv4ZTkBOQPztZgooEn7Nzac3M/WFCpruAkwEF11y1+0R5oxfQ2Rr9
         5Wz68dYAlTviQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/2] block/keyslot-manager: introduce devm_blk_ksm_init()
Date:   Thu, 21 Jan 2021 00:21:54 -0800
Message-Id: <20210121082155.111333-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210121082155.111333-1-ebiggers@kernel.org>
References: <20210121082155.111333-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a resource-managed variant of blk_ksm_init() so that drivers don't
have to worry about calling blk_ksm_destroy().

Note that the implementation uses a custom devres action to call
blk_ksm_destroy() rather than switching the two allocations to be
directly devres-managed, e.g. with devm_kmalloc().  This is because we
need to keep zeroing the memory containing the keyslots when it is
freed, and also because we want to continue using kvmalloc() (and there
is no devm_kvmalloc()).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst | 12 +++++-----
 block/keyslot-manager.c                   | 29 +++++++++++++++++++++++
 include/linux/keyslot-manager.h           |  3 +++
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index e75151e467d39..7f9b40d6b416b 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -182,8 +182,9 @@ API presented to device drivers
 
 A :c:type:``struct blk_keyslot_manager`` should be set up by device drivers in
 the ``request_queue`` of the device. The device driver needs to call
-``blk_ksm_init`` on the ``blk_keyslot_manager``, which specifying the number of
-keyslots supported by the hardware.
+``blk_ksm_init`` (or its resource-managed variant ``devm_blk_ksm_init``) on the
+``blk_keyslot_manager``, while specifying the number of keyslots supported by
+the hardware.
 
 The device driver also needs to tell the KSM how to actually manipulate the
 IE hardware in the device to do things like programming the crypto key into
@@ -202,10 +203,9 @@ needs each and every of its keyslots to be reprogrammed with the key it
 "should have" at the point in time when the function is called. This is useful
 e.g. if a device loses all its keys on runtime power down/up.
 
-``blk_ksm_destroy`` should be called to free up all resources used by a keyslot
-manager upon ``blk_ksm_init``, once the ``blk_keyslot_manager`` is no longer
-needed.
-
+If the driver used ``blk_ksm_init`` instead of ``devm_blk_ksm_init``, then
+``blk_ksm_destroy`` should be called to free up all resources used by a
+``blk_keyslot_manager`` once it is no longer needed.
 
 Layered Devices
 ===============
diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index 86f8195d8039e..324bf4244f5fb 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -29,6 +29,7 @@
 #define pr_fmt(fmt) "blk-crypto: " fmt
 
 #include <linux/keyslot-manager.h>
+#include <linux/device.h>
 #include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
@@ -127,6 +128,34 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
 }
 EXPORT_SYMBOL_GPL(blk_ksm_init);
 
+static void blk_ksm_destroy_callback(void *ksm)
+{
+	blk_ksm_destroy(ksm);
+}
+
+/**
+ * devm_blk_ksm_init() - Resource-managed blk_ksm_init()
+ * @dev: The device which owns the blk_keyslot_manager.
+ * @ksm: The blk_keyslot_manager to initialize.
+ * @num_slots: The number of key slots to manage.
+ *
+ * Like blk_ksm_init(), but causes blk_ksm_destroy() to be called automatically
+ * on driver detach.
+ *
+ * Return: 0 on success, or else a negative error code.
+ */
+int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
+		      unsigned int num_slots)
+{
+	int err = blk_ksm_init(ksm, num_slots);
+
+	if (err)
+		return err;
+
+	return devm_add_action_or_reset(dev, blk_ksm_destroy_callback, ksm);
+}
+EXPORT_SYMBOL_GPL(devm_blk_ksm_init);
+
 static inline struct hlist_head *
 blk_ksm_hash_bucket_for_key(struct blk_keyslot_manager *ksm,
 			    const struct blk_crypto_key *key)
diff --git a/include/linux/keyslot-manager.h b/include/linux/keyslot-manager.h
index 18f3f5346843f..443ad817c6c57 100644
--- a/include/linux/keyslot-manager.h
+++ b/include/linux/keyslot-manager.h
@@ -85,6 +85,9 @@ struct blk_keyslot_manager {
 
 int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots);
 
+int devm_blk_ksm_init(struct device *dev, struct blk_keyslot_manager *ksm,
+		      unsigned int num_slots);
+
 blk_status_t blk_ksm_get_slot_for_key(struct blk_keyslot_manager *ksm,
 				      const struct blk_crypto_key *key,
 				      struct blk_ksm_keyslot **slot_ptr);
-- 
2.30.0

