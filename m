Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B97C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbiKWU6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239236AbiKWU6K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:10 -0500
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4AAF03D;
        Wed, 23 Nov 2022 12:58:07 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id k7so17702722pll.6;
        Wed, 23 Nov 2022 12:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jowSlLiL6KGV55IcMYZWeqN5/FXu2HkeW31efA29JJQ=;
        b=LXXQh3Gbn8XLGJNm7OWvlADu0zl9mkxUOQqkTd4u4nJ8oLnHiK7wNvdN2xBT0QOU5p
         GvWmZsfzzoNjEw0B9Ex0fkY7Wb/H6GyGgMvN8nkODtbgIA+TeH4mESG1W8JM4MpOyuRh
         Ya0jrfzPaqGc+ydx5r63NZ4kXTAvkbh9pJevZQuduFDqm5w5gLnDAIgg+F/4W+k0KXbf
         vHh4G/y2CcK7K0cP9noycyPqfjVKBjTzs2jMVOEtp2Pd9oHaUy/VAyZ0Ha3bekoEARiq
         YCwI7uaip9ggrC4hGtgpC2Fx5JPLp/WPRikM6w+BnfHe8O3wQzEMeProQTGDV0OtXDBd
         qzRg==
X-Gm-Message-State: ANoB5pkD3/CcMpEcDNsplpawe5cXc4XJHMQBxEsY7RbGPfR98qwSzwEa
        tZJHKlyxbGo36FJ2GVXup7o=
X-Google-Smtp-Source: AA0mqf4CgXq1JETjQQHzqHw5wv3EFngdoURmA4ZaHIijk5irbPmboc3q7nHo1/0eQkOKhGEv7lR78Q==
X-Received: by 2002:a17:902:f391:b0:188:537d:78d9 with SMTP id f17-20020a170902f39100b00188537d78d9mr19512555ple.48.1669237086424;
        Wed, 23 Nov 2022 12:58:06 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 2/8] block: Support configuring limits below the page size
Date:   Wed, 23 Nov 2022 12:57:34 -0800
Message-Id: <20221123205740.463185-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow block drivers to configure the following if
CONFIG_BLK_SUB_PAGE_SEGMENTS=y:
* Maximum number of hardware sectors values smaller than
  PAGE_SIZE >> SECTOR_SHIFT. With PAGE_SIZE = 4096 this means that values
  below 8 become supported.
* A maximum segment size smaller than the page size. This is most useful
  for page sizes above 4096 bytes.

The behavior of the block layer is not modified if
CONFIG_BLK_SUB_PAGE_SEGMENTS=n.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0477c4d527fe..f9d78dea0291 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -122,12 +122,14 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
 void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
 {
 	struct queue_limits *limits = &q->limits;
+	unsigned int min_max_hw_sectors = blk_queue_sub_page_segments(q) ? 1 :
+		PAGE_SIZE >> SECTOR_SHIFT;
 	unsigned int max_sectors;
 
-	if ((max_hw_sectors << 9) < PAGE_SIZE) {
-		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_hw_sectors);
+	if (max_hw_sectors < min_max_hw_sectors) {
+		max_hw_sectors = min_max_hw_sectors;
+		printk(KERN_INFO "%s: set to minimum %u\n", __func__,
+		       max_hw_sectors);
 	}
 
 	max_hw_sectors = round_down(max_hw_sectors,
@@ -277,10 +279,12 @@ EXPORT_SYMBOL_GPL(blk_queue_max_discard_segments);
  **/
 void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 {
-	if (max_size < PAGE_SIZE) {
-		max_size = PAGE_SIZE;
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_size);
+	unsigned int min_max_segment_size = blk_queue_sub_page_segments(q) ?
+		SECTOR_SIZE : PAGE_SIZE;
+
+	if (max_size < min_max_segment_size) {
+		max_size = min_max_segment_size;
+		printk(KERN_INFO "%s: set to minimum %u\n", __func__, max_size);
 	}
 
 	/* see blk_queue_virt_boundary() for the explanation */
