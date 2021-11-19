Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535CDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4274D610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhKSUAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:00:55 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:53823 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKSUAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:00:53 -0500
Received: by mail-pj1-f44.google.com with SMTP id iq11so8688138pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:57:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CpjyyyUfC934HYm6clNX7WAhROKsKwSDkyvy01BNbGo=;
        b=N6jP3Wi/VPwknfPGiZSVVOpwI9WCQpijO8Nlc6woUCZ2mVwArjUYuYQqzXnHH2WJ1j
         Xj+K3hylryHk1zzRASSizSAqvpOVF3JzAf/WYv1gxDDOSiDlxAa1QZwc95PiJRmCHZ4R
         zbCudKzNyE90RZL/wMgU1xJ7kckhnQjUHKNKsRF4ZfTfdj7zK7UEfE9tgYpmMBtSbDL+
         qmyy6c3WbLvc+bmtbxY3VJhdzuGNjvwDTDPXICTsbNeLTgbHhrl3ko8paLlrojkyyZq1
         9uCS+2UlBe5cqgJHKyCg4aBw7UrdNmdo38WjfQuP/tPgx8TShYsO9Ma1K/oWdi48j24L
         KVvg==
X-Gm-Message-State: AOAM531PcRaWbEoWrNsft1rYY85YtnWvCr7Of41cE23eXLXF3n+W5oPn
        8DCis0oQWP3FgG+9lVfnf7GXt9GV12Q=
X-Google-Smtp-Source: ABdhPJzQMz9va8KR/1hiUMJAkQBPWXxaR3HNCHuj4JcmChJbfDIaQr0OHFbizX7j8BiughZIXFD3gw==
X-Received: by 2002:a17:902:c947:b0:141:e7f6:d688 with SMTP id i7-20020a170902c94700b00141e7f6d688mr79446782pla.56.1637351871530;
        Fri, 19 Nov 2021 11:57:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:57:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 01/20] block: Add a flag for internal commands
Date:   Fri, 19 Nov 2021 11:57:24 -0800
Message-Id: <20211119195743.2817-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Some drivers use a single tag space for requests submitted by the block
layer and driver-internal requests. Driver-internal requests will never
pass through the block layer but require a valid tag. This patch adds a
new request flag REQ_INTERNAL to mark such requests and a terminates any
such commands in blk_execute_rq_nowait() with a WARN_ON_ONCE() to signal
such an invalid usage.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: modified patch description ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-exec.c          | 5 +++++
 include/linux/blk-mq.h    | 5 +++++
 include/linux/blk_types.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 1b8b47f6e79b..27d2e3779c13 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -53,6 +53,11 @@ void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
 
+	if (WARN_ON_ONCE(blk_rq_is_internal(rq))) {
+		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
+		return;
+	}
+
 	blk_account_io_start(rq);
 
 	/*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2949d9ac7484..3b42fcdf0c15 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -208,6 +208,11 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
 	return blk_op_is_passthrough(req_op(rq));
 }
 
+static inline bool blk_rq_is_internal(struct request *rq)
+{
+	return rq->cmd_flags & REQ_INTERNAL;
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fe065c394fff..1ae2365e02d1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -411,6 +411,7 @@ enum req_flag_bits {
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
+	__REQ_INTERNAL,		/* driver-internal command */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -435,6 +436,7 @@ enum req_flag_bits {
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
+#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
