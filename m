Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC7DC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjKNVSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKNVSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:18 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15558C4;
        Tue, 14 Nov 2023 13:18:15 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ccbb7f79cdso46798365ad.3;
        Tue, 14 Nov 2023 13:18:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996694; x=1700601494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oel4Kf7Y7WF07iqdKA85OqM7IXICtU2wzVvg+2gGSoc=;
        b=AtbLysGGoT8WbWUqkVBo3t1nYlef3cWrDRQx9m1SA8LdGVnCXBcNqn0zYtOkCH7LZr
         aCdCfTyiJsUWpEJCB11RMbbz4OShr43oieo/IKkdDxsPfeU3e7NL5E5Ty18T1CsZQ2o/
         UmhpHHZ8oJUpb/IBxy9mfrk3zmCMatN0CTQZmKa/upSH0lbPtMBvJBuYInxUPD6xPrtB
         SQG+gv3oSUimQtJZuG2H0RJDgjL+S+NVflIB5KqFLAoIU4V4GPWQJVELEfxkItbIJm3M
         kaHyQfxKyAIjcQhLKAf/cqT1sI2XtqSHgLYSrvNpg94cxO/E/dAGkt0sZw0ONP4Zm9Ny
         H53Q==
X-Gm-Message-State: AOJu0YwAtyitZh3Tq2KBa9skMmJYMpZ4+Lg6vgpz1TR5q9KvsfhuG8tH
        Rv6fUAslEES/CHLSbnZgw7s=
X-Google-Smtp-Source: AGHT+IFa1bH/vGYxgfH/S0jrHh8ritrazrtDwJ1JAyog6EHCLtrlbM7nZ5eUjMSq5lzZbcdhy8RT3w==
X-Received: by 2002:a17:902:6acb:b0:1cc:6acc:8fa0 with SMTP id i11-20020a1709026acb00b001cc6acc8fa0mr3483797plt.34.1699996694399;
        Tue, 14 Nov 2023 13:18:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v15 02/19] block: Only use write locking if necessary
Date:   Tue, 14 Nov 2023 13:16:10 -0800
Message-ID: <20231114211804.1449162-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 112620985bff..d8a80cce832f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -53,11 +53,16 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
 EXPORT_SYMBOL_GPL(blk_zone_cond_str);
 
 /*
- * Return true if a request is a write requests that needs zone write locking.
+ * Return true if a request is a write request that needs zone write locking.
  */
 bool blk_req_needs_zone_write_lock(struct request *rq)
 {
-	if (!rq->q->disk->seq_zones_wlock)
+	struct request_queue *q = rq->q;
+
+	if (!q->limits.use_zone_write_lock)
+		return false;
+
+	if (!q->disk->seq_zones_wlock)
 		return false;
 
 	return blk_rq_is_seq_zoned_write(rq);
