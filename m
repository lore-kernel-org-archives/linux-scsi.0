Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51917C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiKWU6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbiKWU6K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:10 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54DF580;
        Wed, 23 Nov 2022 12:58:05 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id b62so17811610pgc.0;
        Wed, 23 Nov 2022 12:58:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vi68gSKm8AaGgHkr2eCWaAuUOEyq7Y6kAABVSvzrER4=;
        b=dlHHuPftvHvYf1A1TR5rqch7oJFiiYX9pm/L2A9L0aOW+Q99uM0lXP4JdUi6rWfIVy
         8SE4tpvEYuisCFPf4jksaSvu7T646miXnKvXOurq7C0+g3sjL2u6p4gbYoLuRDuwCNlg
         PUBLk1WhEDc+qjw2mFnqGdSXWpHLe0G+AK3Vyewd6LCK46mVWgGZnGl3/+Ydu0sjm4H3
         LnITe6IxfZo2OVZqysODVqgM6lOIZevr+borFwidfZZ2YqARfWcqYYmkwfOIYRjfEqTD
         +1Luueu2BHNsMZ6nhm+I2vTnDeNbAsdBQJujQ6VIPS4Mp17rqWpGHi7SBcF2V1R01Ara
         sOVw==
X-Gm-Message-State: ANoB5plQe0WFmJP1BWinFDrj773x2UhL3OwCuYTMLlv5Nvz9qb9LV9TB
        KZmK+Eg4qiMnaSO1brgpjAA=
X-Google-Smtp-Source: AA0mqf44ID5su45eYuFdJ9rAu/qDePvGNIr2FBHHKC3nwX8kURz1QBzbfoHhoV3VqB2VZYwWAFYsYg==
X-Received: by 2002:a62:5f46:0:b0:56b:cc74:4bd5 with SMTP id t67-20020a625f46000000b0056bcc744bd5mr12240835pfb.79.1669237084446;
        Wed, 23 Nov 2022 12:58:04 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 1/8] block: Introduce CONFIG_BLK_SUB_PAGE_SEGMENTS and QUEUE_FLAG_SUB_PAGE_SEGMENTS
Date:   Wed, 23 Nov 2022 12:57:33 -0800
Message-Id: <20221123205740.463185-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
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
index 444c5ab3b67e..c3857795fc0d 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -36,6 +36,15 @@ config BLOCK_LEGACY_AUTOLOAD
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
index 3dbd45725b9f..a2362cf07366 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -548,6 +548,7 @@ struct request_queue {
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
 #define QUEUE_FLAG_DYING	1	/* queue being torn down */
+#define QUEUE_FLAG_SUB_PAGE_SEGMENTS 2	/* segments smaller than one page */
 #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
@@ -614,6 +615,12 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
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
