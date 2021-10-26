Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81103C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 20:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2406103B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 20:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhJZUNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 16:13:18 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:33542 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbhJZUNN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 16:13:13 -0400
Received: by mail-pf1-f173.google.com with SMTP id t184so582206pfd.0;
        Tue, 26 Oct 2021 13:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRJjKdjODsDGNWpTgbNuHe6+D24pXZwSNAIhUexlwMs=;
        b=jDbk+p2zIgkMoUByPGY2akf4AziCqbnNV9g7vFCdsQP8x9QgTzw3OUntbeP5ABqxhi
         Qn088XunBk4JPaqzYKozinY7+GvzoNLWr6mBKu7Nn5iwadFAw7HhN2kpk2UdMwvjnGgB
         MPNfAiwEcu6TsHW4vnNDAA4CjTPPG+AhwM9QztmiMq/MkgFJmOyCNzxXHAXhWvAPqbKj
         4175Rn9EIn+QQGna+hGDx3SLH+D0Ai8STM5lFQiJN4I0KkNrIXF7DambvOXR7GWnQqtO
         qphg4fv+J3UllZ4FdRrn138nS7TSzog4meXnR1mWJ/vESsTZu20CmRto2XkfWKUnj8bj
         BOgQ==
X-Gm-Message-State: AOAM5339gDSfcLCq7vjcQAYCeZfAlTvR5YdLvrrL53OvIK5Pg86k3Z3T
        MjetXyouDGPGE9f5fmqCry0/w9OC6gXk2g==
X-Google-Smtp-Source: ABdhPJwI7XCn3zcIGTyqriWQKSmtKZJohOznCObtdW6KYCTBJhmaQSDtvqMkBUe3M32uOuR8CsT4jQ==
X-Received: by 2002:aa7:90d0:0:b0:44d:b8a:8837 with SMTP id k16-20020aa790d0000000b0044d0b8a8837mr28167199pfk.47.1635279048754;
        Tue, 26 Oct 2021 13:10:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:26a4:3b5f:3c4f:53f5])
        by smtp.gmail.com with ESMTPSA id l11sm25486514pfu.55.2021.10.26.13.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 13:10:48 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
Date:   Tue, 26 Oct 2021 13:10:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 11:27 AM, Martin K. Petersen wrote:
>> Agreed, that was my initial proposed solution: get rid of the write
>> buffer optimzation now to fix the API abuse and see if we can add it
>> back in a more acceptable form later.
> 
> Doesn't matter to me whether we back out the 2.0 stuff or mark it as
> broken. I merely objected to reverting all of HPB since I don't think
> that would solve anything.
> 
> But obviously we'll need a patch to fix 5.15 ASAP...

I do not have access to a test setup that supports HPB.

If blk_insert_cloned_request() is moved into the device mapper then I
think that blk_mq_request_issue_directly() will need to be exported. How
about the (totally untested) patch below for removing the
blk_insert_cloned_request() call from the UFS-HPB code?

Thanks,

Bart.


---
  block/blk-mq.c            | 1 +
  block/blk-mq.h            | 1 -
  drivers/scsi/ufs/ufshpb.c | 2 +-
  include/linux/blkdev.h    | 1 +
  4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 108a352051be..186321f450f6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2084,6 +2084,7 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)

  	return ret;
  }
+EXPORT_SYMBOL_GPL(blk_mq_request_issue_directly);

  void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
  		struct list_head *list)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d08779f77a26..ffba52189b18 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -74,7 +74,6 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
  				struct list_head *list);

  /* Used by blk_insert_cloned_request() to issue request directly */
-blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
  void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
  				    struct list_head *list);

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 66b19500844e..458eadcb604f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -547,7 +547,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
  				 read_id);
  	rq->cmd_len = scsi_command_size(rq->cmd);

-	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
+	if (blk_mq_request_issue_directly(req, true) != BLK_STS_OK)
  		return -EAGAIN;

  	hpb->stats.pre_req_cnt++;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 12b9dbcc980e..f203c7ea205b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -867,6 +867,7 @@ extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
  extern void blk_rq_unprep_clone(struct request *rq);
  extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
  				     struct request *rq);
+blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
  int blk_rq_append_bio(struct request *rq, struct bio *bio);
  extern void blk_queue_split(struct bio **);
  extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
