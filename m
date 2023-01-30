Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112B1C636CD
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjA3V1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjA3V1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:09 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655C84742D;
        Mon, 30 Jan 2023 13:27:08 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id h9so4445679plf.9;
        Mon, 30 Jan 2023 13:27:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kOh/pSCbQUixF2/djzjgkt1h7JC/Pa8ZoAwxGOtFdE=;
        b=VksATimUMFQ5rwlFObX68KU+jvI99T5kyAP5Je/7S+Xqvql1ysin43ZbsjiE1YYuTY
         hb08WSlFud6ikdWrkiQi+Wve8ae+l+kPwOHky0tn1zAuLyRNqjvbYJPt4ICTohJUXAd2
         268OYItzFNC3BTrcN9z3NcKkCYyZFAae2z2Ojq3sMJyn0APKwcuPgu1Da4ptZunPCb5Z
         DOogJM7AxnmQg3++dnmxd3FSkoOqND+HpNaAKGhSK5MH10m+qzSK3h4IioGXrHmKN7rk
         7diyvYeQxXlzqi0L6A+CCQenRSCirV+dRG9mPG6klXstZrITnRSsp6aJsLmjBW4CPsOI
         NDGA==
X-Gm-Message-State: AO0yUKWaYu2UMU3lzZ03JfSBnMuNRbX+nYZ7iOj5gKKLcJbl6jw7+vxy
        8Kid9Cfnvni57XUPveZIdR2tPMUgy4iGEQ==
X-Google-Smtp-Source: AK7set9qNKIpeOLd9Isd+tQSc1vijkSsVlFqHFlUDZSQDYoMF7cziUBEJo1QlA90ALmJDwV3FE9LXQ==
X-Received: by 2002:a05:6a20:3d19:b0:b8:841d:85bb with SMTP id y25-20020a056a203d1900b000b8841d85bbmr12683057pzi.0.1675114027824;
        Mon, 30 Jan 2023 13:27:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4 2/7] block: Support configuring limits below the page size
Date:   Mon, 30 Jan 2023 13:26:51 -0800
Message-Id: <20230130212656.876311-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow block drivers to configure the following:
* Maximum number of hardware sectors values smaller than
  PAGE_SIZE >> SECTOR_SHIFT. With PAGE_SIZE = 4096 this means that values
  below 8 are supported.
* A maximum segment size below the page size. This is most useful
  for page sizes above 4096 bytes.

The blk_sub_page_segments static branch will be used in later patches to
prevent that performance of block drivers that support segments >=
PAGE_SIZE and max_hw_sectors >= PAGE_SIZE >> SECTOR_SHIFT would be affected.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       |  1 +
 block/blk-mq-debugfs.c |  5 +++
 block/blk-settings.c   | 82 +++++++++++++++++++++++++++++++++++++-----
 block/blk.h            | 10 ++++++
 include/linux/blkdev.h |  2 ++
 5 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0dacc2df9588..b193040c7c73 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -270,6 +270,7 @@ static void blk_free_queue(struct request_queue *q)
 
 	blk_free_queue_stats(q->stats);
 	kfree(q->poll_stat);
+	blk_disable_sub_page_limits(&q->limits);
 
 	if (queue_is_mq(q))
 		blk_mq_release(q);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 60d1de0ce624..4f06e02961f3 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -875,7 +875,12 @@ void blk_mq_debugfs_unregister_sched_hctx(struct blk_mq_hw_ctx *hctx)
 	hctx->sched_debugfs_dir = NULL;
 }
 
+DEFINE_DEBUGFS_ATTRIBUTE(blk_sub_page_limit_queues_fops,
+			blk_sub_page_limit_queues_get, NULL, "%llu\n");
+
 void blk_mq_debugfs_init(void)
 {
 	blk_debugfs_root = debugfs_create_dir("block", NULL);
+	debugfs_create_file("sub_page_limit_queues", 0400, blk_debugfs_root,
+			    NULL, &blk_sub_page_limit_queues_fops);
 }
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9c9713c9269c..46d43cef8377 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -18,6 +18,11 @@
 #include "blk.h"
 #include "blk-wbt.h"
 
+/* Protects blk_nr_sub_page_limit_queues and blk_sub_page_limits changes. */
+static DEFINE_MUTEX(blk_sub_page_limit_lock);
+static uint32_t blk_nr_sub_page_limit_queues;
+DEFINE_STATIC_KEY_FALSE(blk_sub_page_limits);
+
 void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
 {
 	q->rq_timeout = timeout;
@@ -58,6 +63,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
+	lim->sub_page_limits = false;
 }
 
 /**
@@ -100,6 +106,55 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
+/* For debugfs. */
+int blk_sub_page_limit_queues_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(blk_nr_sub_page_limit_queues);
+
+	return 0;
+}
+
+/**
+ * blk_enable_sub_page_limits - enable support for max_segment_size values smaller than PAGE_SIZE and for max_hw_sectors values below PAGE_SIZE >> SECTOR_SHIFT
+ * @lim: request queue limits for which to enable support of these features.
+ *
+ * Support for these features is not enabled all the time because of the
+ * runtime overhead of these features.
+ */
+static void blk_enable_sub_page_limits(struct queue_limits *lim)
+{
+	if (lim->sub_page_limits)
+		return;
+
+	lim->sub_page_limits = true;
+
+	mutex_lock(&blk_sub_page_limit_lock);
+	if (++blk_nr_sub_page_limit_queues == 1)
+		static_branch_enable(&blk_sub_page_limits);
+	mutex_unlock(&blk_sub_page_limit_lock);
+}
+
+/**
+ * blk_disable_sub_page_limits - disable support for max_segment_size values smaller than PAGE_SIZE and for max_hw_sectors values below PAGE_SIZE >> SECTOR_SHIFT
+ * @lim: request queue limits for which to enable support of these features.
+ *
+ * Support for these features is not enabled all the time because of the
+ * runtime overhead of these features.
+ */
+void blk_disable_sub_page_limits(struct queue_limits *lim)
+{
+	if (!lim->sub_page_limits)
+		return;
+
+	lim->sub_page_limits = false;
+
+	mutex_lock(&blk_sub_page_limit_lock);
+	WARN_ON_ONCE(blk_nr_sub_page_limit_queues <= 0);
+	if (--blk_nr_sub_page_limit_queues == 0)
+		static_branch_disable(&blk_sub_page_limits);
+	mutex_unlock(&blk_sub_page_limit_lock);
+}
+
 /**
  * blk_queue_max_hw_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
@@ -122,12 +177,17 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
 void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
 {
 	struct queue_limits *limits = &q->limits;
+	unsigned int min_max_hw_sectors = PAGE_SIZE >> SECTOR_SHIFT;
 	unsigned int max_sectors;
 
-	if ((max_hw_sectors << 9) < PAGE_SIZE) {
-		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_hw_sectors);
+	if (max_hw_sectors < min_max_hw_sectors) {
+		blk_enable_sub_page_limits(limits);
+		min_max_hw_sectors = 1;
+	}
+
+	if (max_hw_sectors < min_max_hw_sectors) {
+		max_hw_sectors = min_max_hw_sectors;
+		pr_info("%s: set to minimum %u\n", __func__, max_hw_sectors);
 	}
 
 	max_hw_sectors = round_down(max_hw_sectors,
@@ -282,10 +342,16 @@ EXPORT_SYMBOL_GPL(blk_queue_max_discard_segments);
  **/
 void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 {
-	if (max_size < PAGE_SIZE) {
-		max_size = PAGE_SIZE;
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_size);
+	unsigned int min_max_segment_size = PAGE_SIZE;
+
+	if (max_size < min_max_segment_size) {
+		blk_enable_sub_page_limits(&q->limits);
+		min_max_segment_size = SECTOR_SIZE;
+	}
+
+	if (max_size < min_max_segment_size) {
+		max_size = min_max_segment_size;
+		pr_info("%s: set to minimum %u\n", __func__, max_size);
 	}
 
 	/* see blk_queue_virt_boundary() for the explanation */
diff --git a/block/blk.h b/block/blk.h
index 4c3b3325219a..9a56d7002efc 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -13,6 +13,7 @@ struct elevator_type;
 #define BLK_MAX_TIMEOUT		(5 * HZ)
 
 extern struct dentry *blk_debugfs_root;
+DECLARE_STATIC_KEY_FALSE(blk_sub_page_limits);
 
 struct blk_flush_queue {
 	unsigned int		flush_pending_idx:1;
@@ -32,6 +33,15 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 					      gfp_t flags);
 void blk_free_flush_queue(struct blk_flush_queue *q);
 
+static inline bool blk_queue_sub_page_limits(const struct queue_limits *lim)
+{
+	return static_branch_unlikely(&blk_sub_page_limits) &&
+		lim->sub_page_limits;
+}
+
+int blk_sub_page_limit_queues_get(void *data, u64 *val);
+void blk_disable_sub_page_limits(struct queue_limits *q);
+
 void blk_freeze_queue(struct request_queue *q);
 void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 void blk_queue_start_drain(struct request_queue *q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b9637d63e6f0..af04bf241714 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -319,6 +319,8 @@ struct queue_limits {
 	 * due to possible offsets.
 	 */
 	unsigned int		dma_alignment;
+
+	bool			sub_page_limits;
 };
 
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
