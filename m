Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0061DEE498F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357933AbjHRTph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379842AbjHRTpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:45:21 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560944239;
        Fri, 18 Aug 2023 12:44:44 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bf092a16c9so10943335ad.0;
        Fri, 18 Aug 2023 12:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387791; x=1692992591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FvsjixjHprGJoE6zHlkCW2HQWi6Q2BrxOyZzjpL+qb0=;
        b=aLr4VXwyeaAt8n+PBTH5xW4Y65weOGZ3Sh3OPa0xiE0OyKmGsfk5BGyLlWCPy0NSXQ
         PeAJ0MdEY7ue3JxdhLG+RhyacoJETMn60jINIgz9Gp5ANAguYFY5ePIwUgWbeSvfHqwF
         zWY+/CxjmxCtatJhnmmvF/FaC4LdDowcSAqNUnGM+ggx8Zp/Z5SCdiQ1+XGH/YcVtWrR
         tLFrtAwerWrIiQimY0Qn2Cg0RrjNj+fMpHcuSeHw8vtMCuDeRBXKmghMHFI4SZSrySqE
         /mKO5G3dpdG8v3/OEgBzmAsJdi2DvfZmJETKsNPeNqlwUQzjbK7QegBw0NcZ1uyHglhI
         mZoA==
X-Gm-Message-State: AOJu0YzHkK8ejvaqxEW+/P2tRm3FoKvSIq1t9Wt5kO6WBDjp0WuY3pOF
        Wv86p9+QazetLP4tQYtIlQDTc8OIdlQ=
X-Google-Smtp-Source: AGHT+IF4n0M75II18TdmYY9xJaoBhoB8sECgbX5jp9wZYLq3+MQPy1u2o1bjEOBxLNlzeHIoSichVg==
X-Received: by 2002:a17:902:8695:b0:1b8:2c6f:3248 with SMTP id g21-20020a170902869500b001b82c6f3248mr206100plo.39.1692387791269;
        Fri, 18 Aug 2023 12:43:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v10 02/18] block: Only use write locking if necessary
Date:   Fri, 18 Aug 2023 12:34:05 -0700
Message-ID: <20230818193546.2014874-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false.

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
