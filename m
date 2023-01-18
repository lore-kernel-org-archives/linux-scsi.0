Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907D9C46467
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjARWzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjARWy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:54:58 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1BB3C14;
        Wed, 18 Jan 2023 14:54:57 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id q64so570950pjq.4;
        Wed, 18 Jan 2023 14:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wu5sPPFqMc2gBHaTHb+Yy396MxEjEU9ceKQwUeLcZM=;
        b=u5JESt4GF7HxezcqTi81/xI2hEtNlT0yG0gMrnIteLvu7TtIAF3seies0hOz0K7Yip
         EpPFPs1ruOi7axfHWqzU5SXXbWtR8ZoLrT1NCmvvWtWVI3pHDj35cKKmfRPlRy51Uiba
         scjw5jdfYhqE8gea784pu11jEPZX8usTLEVdxpzNTivuxc70pQC7prEq+UhRFxo0dUoX
         JG4nhddvfRmDl4p9q211iT11+dWEcQ9+H/mI5xDijHH0c4oayZSF5UJ4Mc/nfZMvpr11
         atM2bylZKQo9HSADpxRnIZpajSBucZFfNMsXkhnrwVYdsnUziCPZPBLKdb960w8PqoUw
         U4vw==
X-Gm-Message-State: AFqh2ko+ygyMnH8rlXOfXj6QP/wSMz06qaReVKi/+0jkxykitSw9uU76
        iHwEBrLy8oEOC6h57DUbxAs=
X-Google-Smtp-Source: AMrXdXs006pEZQv+FlK3LRVUZcPJiXtqaLcbVclirzXqcBfL7AtuI1m6WSnSroA2ZkWqBc1rEYKBbg==
X-Received: by 2002:a17:902:ebc9:b0:194:85da:16 with SMTP id p9-20020a170902ebc900b0019485da0016mr9752834plg.13.1674082497331;
        Wed, 18 Jan 2023 14:54:57 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:54:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v3 1/9] block: Introduce QUEUE_FLAG_SUB_PAGE_SEGMENTS and CONFIG_BLK_SUB_PAGE_SEGMENTS
Date:   Wed, 18 Jan 2023 14:54:39 -0800
Message-Id: <20230118225447.2809787-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for introducing support for segments smaller than the page size
by introducing the request queue flag QUEUE_FLAG_SUB_PAGE_SEGMENTS.
Introduce CONFIG_BLK_SUB_PAGE_SEGMENTS to prevent that performance of
block drivers that support segments >= PAGE_SIZE would be affected.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/Kconfig          | 9 +++++++++
 include/linux/blkdev.h | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 5d9d9c84d516..e85061d2175b 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -35,6 +35,15 @@ config BLOCK_LEGACY_AUTOLOAD
 	  created on demand, but scripts that manually create device nodes and
 	  then call losetup might rely on this behavior.
 
+config BLK_SUB_PAGE_SEGMENTS
+       bool "Support segments smaller than the page size"
+       default n
+       help
+	  Most storage controllers support DMA segments larger than the typical
+	  size of a virtual memory page. Some embedded controllers only support
+	  DMA segments smaller than the page size. Enable this option to support
+	  such controllers.
+
 config BLK_RQ_ALLOC_TIME
 	bool
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 89f51d68c68a..6cbb22fb93ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -547,6 +547,7 @@ struct request_queue {
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
 #define QUEUE_FLAG_DYING	1	/* queue being torn down */
+#define QUEUE_FLAG_SUB_PAGE_SEGMENTS 2	/* segments smaller than one page */
 #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
@@ -613,6 +614,12 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 #define blk_queue_skip_tagset_quiesce(q) \
 	test_bit(QUEUE_FLAG_SKIP_TAGSET_QUIESCE, &(q)->queue_flags)
+#ifdef CONFIG_BLK_SUB_PAGE_SEGMENTS
+#define blk_queue_sub_page_segments(q)				\
+	test_bit(QUEUE_FLAG_SUB_PAGE_SEGMENTS, &(q)->queue_flags)
+#else
+#define blk_queue_sub_page_segments(q) false
+#endif
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
