Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DBCCD13D9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjIRQ5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjIRQ5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:57:35 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04DE8E;
        Mon, 18 Sep 2023 09:57:29 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-578a91aca06so200392a12.3;
        Mon, 18 Sep 2023 09:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056249; x=1695661049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aH5XPQQCiAVF4r+XWGxE/2XmtFY/9NCJod7T1V555TM=;
        b=Ic9U28/DYMh58EjnRbZJp3tbcZhNtTUCHlqxmTptpyoeAfDnz7CDqm1xmdMot1aK3S
         94Y2YQlFWAHMxrK2euay7IEqgo/qJJCg++1Zle+2z6rweLKaxfPRAU9irF9LghrpSp1H
         NSmTBoYG84fxHCKV2oTpqpNZpzZEtIMfPVnVdRqEu+CoQ1U/9JV8bL4MHkvAUcJy1+6Y
         mv2Chu2NQ1TELVgnRb6Qo2TjzYj2OjHheji9gHpyx1t8o0kA05kGGzhWqCMhsNCYNPv9
         +rptVWfmD7UnK/lRwxYCyYHbCR/1Rl39BZYPKDyJTG0PJtEEHvJ2MblHuWY6tEJW1oV0
         YsBw==
X-Gm-Message-State: AOJu0YwJiiQJp64vVb6ZEl3WCIXs+Yw1x9tl09RYJramiZPkoR35lLPO
        +gdinzHAokw61Daq9IxF/Dc=
X-Google-Smtp-Source: AGHT+IHwIFPCWVs+eoI8ZrzbxXZvxe5RyQ+ermh1NZiDetnoETn8QuRuijxwoA8uU3Ep/VWimj4pmw==
X-Received: by 2002:a05:6a20:7351:b0:159:c2d0:9fc6 with SMTP id v17-20020a056a20735100b00159c2d09fc6mr11652967pzc.8.1695056248853;
        Mon, 18 Sep 2023 09:57:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:57:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v12 02/16] block: Only use write locking if necessary
Date:   Mon, 18 Sep 2023 09:55:41 -0700
Message-ID: <20230918165713.1598705-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
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
