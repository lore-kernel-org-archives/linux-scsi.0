Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227FCC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E917C205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCMUbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:31:17 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36415 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:31:17 -0400
Received: by mail-pj1-f65.google.com with SMTP id nu11so1690938pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ClumS4y2znvDKE5RCEeauYDiXg3kLtaQUZfVwOEEKCM=;
        b=LP1OUrnIj8gdR6tYi88bI19T0nd3F3o2iPUUvQwJxtYXNLDpOr5k8D8g8lNXrQBAGP
         zaYiqfoAcHjHbnD0ffTtohAL+kPYm8k7BxYIGy7mVHuxZKIhIYyfQcSlQr2jwcPuPtYs
         37GELR1cED3U3n87w6vPH05bi3cuVopdY8a2riZHAco0zGHjhLGCg83BzAFqrqExWdQK
         wmfl4sRgaG7aDbdX7ZdyF519mn0CxGollN7CoMzMGbdIi20C4hmDBVBwSppbVsn5/GEe
         Bh14p8VVkPzU80LCl0lZjD8LFxPzy9/iOhBithvHmsw7OKNXE56ujMBoHG+Qn2U62RKo
         WerA==
X-Gm-Message-State: ANhLgQ1E3D982A5ne8lhUOqeQuiXrzLMWbeg5DxM//zOFTlqRBhPMAZy
        L3S+npu35/y2pAHaTsM3nHQ=
X-Google-Smtp-Source: ADFU+vse4XEHMiTvEhs2/oFKRhS2eAR/XP4c5dzwFwubZ2gSESMhgXGUuOzSSSAeogHpqJVayyHPug==
X-Received: by 2002:a17:90a:a109:: with SMTP id s9mr11858455pjp.49.1584131475674;
        Fri, 13 Mar 2020 13:31:15 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id m12sm12656000pjf.25.2020.03.13.13.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:31:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH v3 3/5] treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
Date:   Fri, 13 Mar 2020 13:31:00 -0700
Message-Id: <20200313203102.16613-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313203102.16613-1-bvanassche@acm.org>
References: <20200313203102.16613-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the get_unaligned_be24(), get_unaligned_le24() and
put_unaligned_le24() definitions from various drivers into
include/linux/unaligned/generic.h. Add a put_unaligned_be24()
implementation.

Cc: Keith Busch <kbusch@kernel.org>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@fb.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # For drivers/usb
Reviewed-by: Felipe Balbi <balbi@kernel.org> # For drivers/usb/gadget
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/host/rdma.c                     |  8 ----
 drivers/nvme/target/rdma.c                   |  6 ---
 drivers/usb/gadget/function/f_mass_storage.c |  1 +
 drivers/usb/gadget/function/storage_common.h |  5 ---
 include/linux/unaligned/generic.h            | 46 ++++++++++++++++++++
 include/target/target_core_backend.h         |  6 ---
 6 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 3e85c5cacefd..2845118e6e40 100644
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
index 37d262a65877..8fcede75e02a 100644
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
index 57d3114656e5..303289492859 100644
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
@@ -66,4 +68,48 @@ extern void __bad_unaligned_access_size(void);
 	}								\
 	(void)0; })
 
+static inline u32 __get_unaligned_be24(const u8 *p)
+{
+	return p[0] << 16 | p[1] << 8 | p[2];
+}
+
+static inline u32 get_unaligned_be24(const void *p)
+{
+	return __get_unaligned_be24(p);
+}
+
+static inline u32 __get_unaligned_le24(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16;
+}
+
+static inline u32 get_unaligned_le24(const void *p)
+{
+	return __get_unaligned_le24(p);
+}
+
+static inline void __put_unaligned_be24(const u32 val, u8 *p)
+{
+	*p++ = val >> 16;
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void put_unaligned_be24(const u32 val, void *p)
+{
+	__put_unaligned_be24(val, p);
+}
+
+static inline void __put_unaligned_le24(const u32 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+	*p++ = val >> 16;
+}
+
+static inline void put_unaligned_le24(const u32 val, void *p)
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
