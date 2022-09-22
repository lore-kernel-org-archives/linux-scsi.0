Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1628EECAAD8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 18:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiIVSbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 14:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiIVSa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 14:30:56 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CA010BB2D
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:11 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b23so8471816iof.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Or6y/P+wCgw7ERLdnKk9k3MTRgFakhY9VTpCDMSU5NU=;
        b=DdaRIUVcXAC0PQL+apg/G+AjI2f67CbJodcek5ww9nFAO2BwNSHNCCxyA69h3aCoaM
         c8dFUovgd1Drm3MhsG5dCul89+q4n+Khw1JhESY3iHgB4ShRhp9VEMVUp57yjQm5v28v
         oSJnU2H3CgZTZONneZYK83VfiSHtzbfpxiz1QfnQqD0bs1K+5tmyijIqbnz6upfKVw3x
         lt4B+nt231UmP2KsK7u07z92rMmNfhf8WijKOrp2pSBhiq43clWLg1ATlroeeG6Z4C9l
         qkGtMckF44rjRNra0MuENekYeSNfiaLmxzoJ9wF2FaIxyxduFLHw9EDTkoOIEt05q2eq
         KFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Or6y/P+wCgw7ERLdnKk9k3MTRgFakhY9VTpCDMSU5NU=;
        b=CpxZIw6dxGZa4yPoh06QyrNaOo3MfbML8q1hyui7FPcnlc2iB44iClue6KbnWXyNeS
         ZNLxe5C2deHbE2BM/kXbAM+XuwnwKFnmJp7vKi2pNtXU/9fBhBAK2Pl3jfgaqrBk1HkY
         OgwMqWUmZBGZtz/HmYteuL5esY/PasIZsY5NDlSKx5fHMW25a7tsYQFA0oU1GADGjB2Y
         SoP2YC5B/lXcEqWLiDf9EQFmzW2ExZAIKSMslk7SvM2AhBM2EEV4VlIJJfkhl3J5iVMN
         EHVz4HlqXme6Q2QRWSSpwvEegzRf4NUbPTESnJmiiKki+KPBji+xC3OYh1rdB002lKCF
         3Z4A==
X-Gm-Message-State: ACrzQf2f95gzaCAA/j4GXZ7CkrQd/aqzFF5ZuwA6ViJJUiXyBtzroF/0
        2fNZSN73URV5Bt4zACXU+rOq7A==
X-Google-Smtp-Source: AMsMyM7+Xxg8rN7mARF8H/zFcQ5I90sT+zv1UiDqHoKrC8RjleUl2bwORbdfdB60pONvnVH5WKhLUQ==
X-Received: by 2002:a05:6602:2a42:b0:678:84be:c9ec with SMTP id k2-20020a0566022a4200b0067884bec9ecmr2211543iov.64.1663871290172;
        Thu, 22 Sep 2022 11:28:10 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q20-20020a05663810d400b0035a468b7fbesm2440646jad.71.2022.09.22.11.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:28:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>
Subject: [PATCH 3/5] block: allow end_io based requests in the completion batch handling
Date:   Thu, 22 Sep 2022 12:28:03 -0600
Message-Id: <20220922182805.96173-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922182805.96173-1-axboe@kernel.dk>
References: <20220922182805.96173-1-axboe@kernel.dk>
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
index a4e018c82b7c..523a201b9acf 100644
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
+	};
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

