Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ACFC6FA82
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 14:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiIWOw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 10:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiIWOwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 10:52:49 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E02413A380;
        Fri, 23 Sep 2022 07:52:42 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a2so668612lfb.6;
        Fri, 23 Sep 2022 07:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9en01QcZoVRB/nyuHix8atR26FaNJkFbsXv8c0H0Ewc=;
        b=PVuPZKBRqWaUP5aS/sM77IUimjHSDr9CQTadF85aA5q4O90CpCTMdaFBCYFy7EUFXz
         h2GNkjwON4xJaInS2D1O6t9ZUYI3n0jPsgeRluS3TCyfw6hB+baKudhs603HocyP4RWZ
         uA/S+BxHmq1DEjRf0na3JK9q171ECwNyKC/yRhSCmt2mpExCxJRLc0nqHtgVc7z5p33D
         dYFbTwIxvEIWV3ALkDpzQV3KNMjl82CdJikqWLsqO2zBZgiH8GBJWzoM0uyU/5LHQsYZ
         W0MtIBbrUaeQMxhsby/3QPjlPoUirew/kZRvI4Ts1vqlEWn4hAJlVxqKaPj3u2oHq6Pe
         tZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9en01QcZoVRB/nyuHix8atR26FaNJkFbsXv8c0H0Ewc=;
        b=LWitlc0nkg0QCvj0chdI2l3xMIhYNpRijraq/1kJBMbbK37Jvq1UoABtO5qxWbm6pT
         y7vwBP9aNyHnogn4Tlama7Nq/7bXE/9jRbogLls8Or2yexKJLyQdZw/nUbR8XBCYYe8O
         eHRUQko7oaQfOkpspkEc6IeeGpMW3WajBudJcvFG1BHF1x9alC1Sy8J0iQsXGpR50deC
         j9dM61eiD0k5V4Z/tDbnkhZPgof7YFzG4F5+liouUR/g0EK9M9Ky1pLPxkKBtEjnZUOX
         rvTAweAV/zgHM9Rjeh7CubnKdq8xN4I+kr2zPnaTw1SSYrgEZgcX3ajB7U9Fl06N8Saj
         0XqQ==
X-Gm-Message-State: ACrzQf0KQrV7GzO2++DVYtgBHioAEb59z0HXUNtVR8JREF3wCz3Rn8Jo
        ujhrv+NIPBwxTIgy4wHeJLbiaCUJ2ZM=
X-Google-Smtp-Source: AMsMyM6oT3NunHaRFH/pM9NAACYneBSq+ek5ly7lVSal3ZJ0a4JDlTxrbOSd4U+7r34vtj5BJRZzOA==
X-Received: by 2002:a05:6512:10d6:b0:49a:1fc0:cc62 with SMTP id k22-20020a05651210d600b0049a1fc0cc62mr3653475lfg.138.1663944760226;
        Fri, 23 Sep 2022 07:52:40 -0700 (PDT)
Received: from localhost (80-62-116-219-mobile.dk.customer.tdc.net. [80.62.116.219])
        by smtp.gmail.com with ESMTPSA id i16-20020a2ea230000000b0026aba858fbfsm1032999ljm.137.2022.09.23.07.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 07:52:39 -0700 (PDT)
Date:   Fri, 23 Sep 2022 16:52:36 +0200
From:   Pankaj Raghav <pankydev8@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pankaj Raghav <p.raghav@samsung.com>, joshi.k@samsung.com
Subject: Re: [PATCH 1/5] block: enable batched allocation for
 blk_mq_alloc_request()
Message-ID: <20220923145236.pr7ssckko4okklo2@quentin>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922182805.96173-2-axboe@kernel.dk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 12:28:01PM -0600, Jens Axboe wrote:
> The filesystem IO path can take advantage of allocating batches of
> requests, if the underlying submitter tells the block layer about it
> through the blk_plug. For passthrough IO, the exported API is the
> blk_mq_alloc_request() helper, and that one does not allow for
> request caching.
> 
> Wire up request caching for blk_mq_alloc_request(), which is generally
> done without having a bio available upfront.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 71 insertions(+), 9 deletions(-)
> 
I think we need this patch to ensure correct behaviour for passthrough:

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c11949d66163..840541c1ab40 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1213,7 +1213,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
        WARN_ON(!blk_rq_is_passthrough(rq));
 
        blk_account_io_start(rq);
-       if (current->plug)
+       if (blk_mq_plug(rq->bio))
                blk_add_rq_to_plug(current->plug, rq);
        else
                blk_mq_sched_insert_request(rq, at_head, true, false);

As the passthrough path can now support request caching via blk_mq_alloc_request(),
and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
devices:

static inline struct blk_plug *blk_mq_plug( struct bio *bio)
{
	/* Zoned block device write operation case: do not plug the BIO */
	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
		return NULL;
..

Am I missing something?
