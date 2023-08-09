Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9809C04A94
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjHIUYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbjHIUYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:01 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFE8211D;
        Wed,  9 Aug 2023 13:24:01 -0700 (PDT)
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-56cc461f34fso208580eaf.0;
        Wed, 09 Aug 2023 13:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612640; x=1692217440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WWShbjlu/DYJqBGUFh6QWNO1w0dEUupKqXQuglIsyA=;
        b=YHWqmNFe6fAlxRDEwY9hYjPYK5OMasZ+uEtw5XiK0bs65HvMIhTXulY6XnZ5mThtQW
         eYLtT2BCnRGfjl1NrnCg2kqhVmr7PPQojdfOAr6fYqaIZAwUKSULCafK9NaaftB4CM+F
         6Lg6G2C3oCi5XsMXXqemmCS4WDm6ZFyxKaTXoOmiZBXpqdT15SK5OR1HqCUW6H8/giDf
         UYWJB4wxRYvHrsmC1yeY9ue1j1ar9K8zbKqXQeh675cxz9YSe8KE75TKQe13KncL7R1l
         5JiiDTtveYMzXzMaYGD96Ytjqvmr0+UHZwdjGfgHoLjgYTt0B20Ll4Ipk1kQmS0pcunG
         xNOw==
X-Gm-Message-State: AOJu0YxecTL8p+VZGw/GnU2GmsKhYAsKHWGa2juSxzShAjjMiEbh6b0G
        k9EItGbSyAtIZQuipSkZzu0=
X-Google-Smtp-Source: AGHT+IFvT3vLjwErnughpw3zqFH1GggoNKRjKpqsejwMGwJ4NTMcCZRAbfkr5UTMyE+oWbGCWT2Jfg==
X-Received: by 2002:a05:6808:199a:b0:3a7:9bc2:ff6b with SMTP id bj26-20020a056808199a00b003a79bc2ff6bmr604948oib.5.1691612640237;
        Wed, 09 Aug 2023 13:24:00 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:23:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member variable
Date:   Wed,  9 Aug 2023 13:23:42 -0700
Message-ID: <20230809202355.1171455-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230809202355.1171455-1-bvanassche@acm.org>
References: <20230809202355.1171455-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Writes in sequential write required zones must happen at the write
pointer. Even if the submitter of the write commands (e.g. a filesystem)
submits writes for sequential write required zones in order, the block
layer or the storage controller may reorder these write commands.

The zone locking mechanism in the mq-deadline I/O scheduler serializes
write commands for sequential zones. Some but not all storage controllers
require this serialization. Introduce a new request queue limit member
variable to allow block drivers to indicate that they preserve the order
of write commands and thus do not require serialization of writes per
zone.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 6 ++++++
 include/linux/blkdev.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0046b447268f..b75c97971860 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -56,6 +56,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->alignment_offset = 0;
 	lim->io_opt = 0;
 	lim->misaligned = 0;
+	lim->use_zone_write_lock = true;
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
@@ -685,6 +686,11 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 						   b->max_secure_erase_sectors);
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
+	/*
+	 * Whether or not the zone write lock should be used depends on the
+	 * bottom driver only.
+	 */
+	t->use_zone_write_lock = b->use_zone_write_lock;
 	t->zoned = max(t->zoned, b->zoned);
 	return ret;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2f5371b8482c..deffa1f13444 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -316,6 +316,7 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
+	bool			use_zone_write_lock;
 	enum blk_zoned_model	zoned;
 
 	/*
