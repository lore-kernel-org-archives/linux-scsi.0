Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D736C32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjARWzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjARWzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:00 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B154EE3;
        Wed, 18 Jan 2023 14:54:59 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so4052050pjm.1;
        Wed, 18 Jan 2023 14:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvYPO0sC/uPwDQnSqus7cVpI1wskucgHde3IyPruEHI=;
        b=Ajke1CCETnqekarc92qSJs5o3yD3jnBgeTwC38jbrHYE3wTnb8HjojfxxrjrLcA1eB
         Ae0eaAWoqtSpTkHXd46EpRBXEaa0VTvVPH2OsSTgkAKF6Fxn4uNWC07GwSV5RuyiZ+2B
         dvzDcmyUAf/g1rEfiPqzXyyWgNqRT9avE8Lw1OSqzyDnmM9lZg3xc1thSaNVKFwJvAtE
         KcDRb4WlcZN29uPbso9CN8tDtjjoUMvuou1ANLOjrWFlYimpbgHrKzfQkOCjsFc8P68h
         ugERGW5jLXbK9syixL/5KsqIM6KwMGddEb7twlMWsuvfSi9QmCFtgFH4lUSkQKIsy1qr
         RroA==
X-Gm-Message-State: AFqh2kq6KEEYvkKtXbbBrsCzw0PJPITyT34NH7XKMi+kX1/wOaCpB1sG
        ts3nXZcqbAPm6eSGl/rwNjo=
X-Google-Smtp-Source: AMrXdXsRr3a0JeCAqsTbbATGBS2/KzQwT27fynbYNYjvIv02swEGM2OSqJ8aMinQ/SpmJi9SOAnkiQ==
X-Received: by 2002:a17:902:b598:b0:194:645a:fa9a with SMTP id a24-20020a170902b59800b00194645afa9amr9005792pls.8.1674082498880;
        Wed, 18 Jan 2023 14:54:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:54:58 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v3 2/9] block: Support configuring limits below the page size
Date:   Wed, 18 Jan 2023 14:54:40 -0800
Message-Id: <20230118225447.2809787-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow block drivers to configure the following if
CONFIG_BLK_SUB_PAGE_SEGMENTS=y:
* Maximum number of hardware sectors values smaller than
  PAGE_SIZE >> SECTOR_SHIFT. With PAGE_SIZE = 4096 this means that values
  below 8 are supported.
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
index 9c9713c9269c..9820ceb18c46 100644
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
@@ -282,10 +284,12 @@ EXPORT_SYMBOL_GPL(blk_queue_max_discard_segments);
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
