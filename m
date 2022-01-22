Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD31C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbiAVLLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:11:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234155AbiAVLLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:11:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYSY5CHYNIA9hN8QVlij2GnIqK59IRJkhItz3wdmKVE=;
        b=dz2goOGe9YNdcgFe+oROnVakR9LUn3NJn/XODSkC5TO5jSoZlmdXkXh784W/frILhKwvzT
        SgNEVVGQtiMqlNHxLaSA7GuNvmtkmpDxNmelTH4XGau6Jq1QTIqvtDh9mW8ennjryqd09o
        Uu1xtNNaKCMbyIwJXtsB6WAX9ycehr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-jpdpLSJKOjeU72gf5C5rmA-1; Sat, 22 Jan 2022 06:11:29 -0500
X-MC-Unique: jpdpLSJKOjeU72gf5C5rmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B9191083F60;
        Sat, 22 Jan 2022 11:11:28 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC64E7316D;
        Sat, 22 Jan 2022 11:11:22 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 01/13] block: declare blkcg_[init|exit]_queue in private header
Date:   Sat, 22 Jan 2022 19:10:42 +0800
Message-Id: <20220122111054.1126146-2-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both two functions are used by block core code only, so move the
declaration into private header of block layer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk.h                | 8 ++++++++
 include/linux/blk-cgroup.h | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 8bd43b3ad33d..7b0f12260ae6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -406,6 +406,14 @@ extern int blk_iolatency_init(struct request_queue *q);
 static inline int blk_iolatency_init(struct request_queue *q) { return 0; }
 #endif
 
+#ifdef CONFIG_BLK_CGROUP
+int blkcg_init_queue(struct request_queue *q);
+void blkcg_exit_queue(struct request_queue *q);
+#else
+static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
+static inline void blkcg_exit_queue(struct request_queue *q) { }
+#endif
+
 struct bio *blk_next_bio(struct bio *bio, unsigned int nr_pages, gfp_t gfp);
 
 #ifdef CONFIG_BLK_DEV_ZONED
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index b4de2010fba5..d9dcd18d77f4 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -182,8 +182,6 @@ extern bool blkcg_debug_stats;
 
 struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
 				      struct request_queue *q, bool update_hint);
-int blkcg_init_queue(struct request_queue *q);
-void blkcg_exit_queue(struct request_queue *q);
 
 /* Blkio controller policy registration */
 int blkcg_policy_register(struct blkcg_policy *pol);
@@ -637,8 +635,6 @@ static inline void blkcg_schedule_throttle(struct request_queue *q, bool use_mem
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
 { return NULL; }
-static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
-static inline void blkcg_exit_queue(struct request_queue *q) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
-- 
2.31.1

