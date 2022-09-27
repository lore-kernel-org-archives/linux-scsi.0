Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AE0C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 01:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiI0Boc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 21:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiI0Bo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 21:44:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D25A722E
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso8652707pjd.4
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Nz/B6jdwrrOsf5JLn/R8YVwnmVtMrvsX8isrBntB0gc=;
        b=YT5XveMQNm31+MTJZ+0kPwthf1yXMJQ1wFLUuRB4zypjMZ05Qqnq+P+1friBnnl77p
         KK60FLMIHFVWxiWnFKEELBnnjeeaaHf2qbOuV4Qdfa94HJQGydL7bQ/t4I7UNG8HESrS
         iAkRfMZxl9iupPkubKeTmJd1BkFZajiZTLcUWR8mfMrNJQaLSs7sHmpmHNyj3ZM5FDfO
         +M7oADYj71hjFcKq22AZjw+9JA7DV3xtA2/NNc6EY0fj+yG6OixAA0LQw+9E/MMmTcCI
         22ybrhzADauGcmi87SYE8KgOzPoTihQPwmT9QcpNB4uP/SN6h/yUDZtBk9GUkauHG5LD
         0ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Nz/B6jdwrrOsf5JLn/R8YVwnmVtMrvsX8isrBntB0gc=;
        b=dSI/lvwraN3JHSC3UOzS9PkXD0OI3F1V9OabjxlZJ4zMvbIno2VmluUjBoJI6vLLd0
         H3rqhBc8tKWuXYmpgXhXa1DEiNLUEuBC1fCsOpNCjLDdule1akxl9uVGhh4ylKfZGWOq
         sa/iS0eForH7DZV0qUzhvJvmTxSV+C02XGhUUxsfq+5hTf1VMYFTf2rfkGj45IW5VpKG
         40ugAAfkZdIyECkQJ/j75e8pJuB3qualUDcw2/MaN3fBQlJElw+2nSMH5YO/XOUsV9rb
         fJZTE4EtE8mO69UJEwU0nG98WltM50qqqiorlVn5v4tBVRHPup+Wb0LwWNdk5jbEhPv5
         AMMw==
X-Gm-Message-State: ACrzQf3vzXDzY8g/sezJdoefMcF3A5oLNm9dcMo7OcjOWqOxf+EfGWkE
        Zfw5P7V3I4A/EC9jF+Wd+wQ7jLqUjGYYIQ==
X-Google-Smtp-Source: AMsMyM4ePwz2HRsSpw7tWuMO8WEprrgKRsdcXCPFgXwQUx9CiC45lyoJblyFaY69/biPTWfpxqiSog==
X-Received: by 2002:a17:902:ce81:b0:178:8e0a:5615 with SMTP id f1-20020a170902ce8100b001788e0a5615mr25192700plg.109.1664243065770;
        Mon, 26 Sep 2022 18:44:25 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o2-20020aa79782000000b00537d60286c9sm183062pfp.113.2022.09.26.18.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:44:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>
Subject: [PATCH 3/5] block: allow end_io based requests in the completion batch handling
Date:   Mon, 26 Sep 2022 19:44:18 -0600
Message-Id: <20220927014420.71141-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927014420.71141-1-axboe@kernel.dk>
References: <20220927014420.71141-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With end_io handlers now being able to potentially pass ownership of
the request upon completion, we can allow requests with end_io handlers
in the batch completion handling.

Co-developed-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c         | 13 +++++++++++--
 include/linux/blk-mq.h |  3 ++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a4e018c82b7c..a7dfe7a898a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -823,8 +823,10 @@ static void blk_complete_request(struct request *req)
 	 * can find how many bytes remain in the request
 	 * later.
 	 */
-	req->bio = NULL;
-	req->__data_len = 0;
+	if (!req->end_io) {
+		req->bio = NULL;
+		req->__data_len = 0;
+	}
 }
 
 /**
@@ -1055,6 +1057,13 @@ void blk_mq_end_request_batch(struct io_comp_batch *iob)
 
 		rq_qos_done(rq->q, rq);
 
+		/*
+		 * If end_io handler returns NONE, then it still has
+		 * ownership of the request.
+		 */
+		if (rq->end_io && rq->end_io(rq, 0) == RQ_END_IO_NONE)
+			continue;
+
 		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 		if (!req_ref_put_and_test(rq))
 			continue;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e6fa49dd6196..50811d0fb143 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -853,8 +853,9 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 				       struct io_comp_batch *iob, int ioerror,
 				       void (*complete)(struct io_comp_batch *))
 {
-	if (!iob || (req->rq_flags & RQF_ELV) || req->end_io || ioerror)
+	if (!iob || (req->rq_flags & RQF_ELV) || ioerror)
 		return false;
+
 	if (!iob->complete)
 		iob->complete = complete;
 	else if (iob->complete != complete)
-- 
2.35.1

