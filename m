Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779C5CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A1F208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfJ1UHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46693 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732192AbfJ1UHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id b25so7628670pfi.13;
        Mon, 28 Oct 2019 13:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sm2lOxknf5zvtUoPgIgD9u4NTyPopFFJnLUpKIDnglg=;
        b=sHM3iPkhm0H/H2s7Y03rIH1bGH8RQ31t/rOeRIsQD82aGTtqWCC186ENJIxweJ6Wta
         ojYbgafI0E6uRHCC18Jbzyh4kIIiXdIXvVHlJKS0ZkkS+R8P1VyuZV12XpmtlGpdmoMw
         nna77NG2AtjZMkt9BoE88aYfqTThdxi4SDG9ikL7ENgpV6W478Appl7aQrKgGZEa3otK
         iTlwMxMRTcPWsVDla6Ziqs6RK1rBxYNc4opSV6KBSAJdMa0dO9hjQeqCulkt11CIyvXv
         0yM2YTaQTNgv3s95TpJ/3kUE2mugjQWLz72ray+hCG165KswRa6BgplPnusqLipQe8T5
         rUQw==
X-Gm-Message-State: APjAAAXWkeIzjqZnFoCc064lVkqxdzxKtFGD3QQC8JwPSgW3H8cUUD7x
        VDvEf7wVCXuv4jz8OEBEZC8=
X-Google-Smtp-Source: APXvYqwmrv+nMd3B/OcGVw2oEZbfvNIw/JuIYZDh8cPShh0jvan9U/+UmSzU1FwlMF/Kty+h1W+X+Q==
X-Received: by 2002:a62:fb15:: with SMTP id x21mr21541125pfm.79.1572293232727;
        Mon, 28 Oct 2019 13:07:12 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Felipe Balbi <balbi@kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/9] treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
Date:   Mon, 28 Oct 2019 13:06:54 -0700
Message-Id: <20191028200700.213753-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the get_unaligned_be24(), get_unaligned_le24() and
put_unaligned_le24() definitions from various drivers into
include/linux/unaligned/generic.h. Add a put_unaligned_be24() and
get_unaligned_signed_[bl]e24() definitions. Change the functions that
depend on get_unaligned_be32() into macros because
<linux/unaligned/generic.h> may be included before get_unaligned_be32()
has been redefined as a macro.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@fb.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/host/rdma.c                     |  8 ----
 drivers/nvme/target/rdma.c                   |  6 ---
 drivers/usb/gadget/function/f_mass_storage.c |  1 +
 drivers/usb/gadget/function/storage_common.h |  5 ---
 include/linux/unaligned/generic.h            | 44 ++++++++++++++++++++
 include/target/target_core_backend.h         |  6 ---
 6 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index dfa07bb9dfeb..66d9c8cc0c5c 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -142,14 +142,6 @@ static void nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static const struct blk_mq_ops nvme_rdma_mq_ops;
 static const struct blk_mq_ops nvme_rdma_admin_mq_ops;
 
-/* XXX: really should move to a generic header sooner or later.. */
-static inline void put_unaligned_le24(u32 val, u8 *p)
-{
-	*p++ = val;
-	*p++ = val >> 8;
-	*p++ = val >> 16;
-}
-
 static inline int nvme_rdma_queue_idx(struct nvme_rdma_queue *queue)
 {
 	return queue - queue->ctrl->queues;
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 36d906a7f70d..dc193526d4da 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -143,12 +143,6 @@ static int num_pages(int len)
 	return 1 + (((len - 1) & PAGE_MASK) >> PAGE_SHIFT);
 }
 
-/* XXX: really should move to a generic header sooner or later.. */
-static inline u32 get_unaligned_le24(const u8 *p)
-{
-	return (u32)p[0] | (u32)p[1] << 8 | (u32)p[2] << 16;
-}
-
 static inline bool nvmet_rdma_need_data_in(struct nvmet_rdma_rsp *rsp)
 {
 	return nvme_is_write(rsp->req.cmd) &&
diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 7c96c4665178..950d2a85f098 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -216,6 +216,7 @@
 #include <linux/freezer.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
diff --git a/drivers/usb/gadget/function/storage_common.h b/drivers/usb/gadget/function/storage_common.h
index e5e3a2553aaa..bdeb1e233fc9 100644
--- a/drivers/usb/gadget/function/storage_common.h
+++ b/drivers/usb/gadget/function/storage_common.h
@@ -172,11 +172,6 @@ enum data_direction {
 	DATA_DIR_NONE
 };
 
-static inline u32 get_unaligned_be24(u8 *buf)
-{
-	return 0xffffff & (u32) get_unaligned_be32(buf - 1);
-}
-
 static inline struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 {
 	return container_of(dev, struct fsg_lun, dev);
diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
index 57d3114656e5..f7fa3f248c85 100644
--- a/include/linux/unaligned/generic.h
+++ b/include/linux/unaligned/generic.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_UNALIGNED_GENERIC_H
 #define _LINUX_UNALIGNED_GENERIC_H
 
+#include <linux/types.h>
+
 /*
  * Cause a link-time error if we try an unaligned access other than
  * 1,2,4 or 8 bytes long
@@ -66,4 +68,46 @@ extern void __bad_unaligned_access_size(void);
 	}								\
 	(void)0; })
 
+/* Only use get_unaligned_be24() if reading p - 1 is allowed. */
+#define get_unaligned_be24(p) (get_unaligned_be32((p) - 1) & 0xffffffu)
+
+#define get_unaligned_le24(p) (get_unaligned_le32((p)) & 0xffffffu)
+
+/* Sign-extend a 24-bit into a 32-bit integer. */
+static inline s32 sign_extend_24_to_32(u32 i)
+{
+	i &= 0xffffffu;
+	return i - ((i >> 23) << 24);
+}
+
+#define get_unaligned_signed_be24(p)			\
+	sign_extend_24_to_32(get_unaligned_be24((p)))
+
+#define get_unaligned_signed_le24(p)			\
+	sign_extend_24_to_32(get_unaligned_le24((p)))
+
+static inline void __put_unaligned_be24(u32 val, u8 *p)
+{
+	*p++ = val >> 16;
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void put_unaligned_be24(u32 val, void *p)
+{
+	__put_unaligned_be24(val, p);
+}
+
+static inline void __put_unaligned_le24(u32 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+	*p++ = val >> 16;
+}
+
+static inline void put_unaligned_le24(u32 val, void *p)
+{
+	__put_unaligned_le24(val, p);
+}
+
 #endif /* _LINUX_UNALIGNED_GENERIC_H */
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 51b6f50eabee..1b752d8ea529 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -116,10 +116,4 @@ static inline bool target_dev_configured(struct se_device *se_dev)
 	return !!(se_dev->dev_flags & DF_CONFIGURED);
 }
 
-/* Only use get_unaligned_be24() if reading p - 1 is allowed. */
-static inline uint32_t get_unaligned_be24(const uint8_t *const p)
-{
-	return get_unaligned_be32(p - 1) & 0xffffffU;
-}
-
 #endif /* TARGET_CORE_BACKEND_H */
-- 
2.24.0.rc0.303.g954a862665-goog

