Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB62C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 21:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjEYVQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 17:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjEYVQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 17:16:17 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62198194
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 14:16:16 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5307502146aso14435a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 14:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685049376; x=1687641376;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yvehLfblu4+AaFGGy8iOwW4VnC2kZV0sQTYF1Z2o6mM=;
        b=krVeEUKFrw+gwyZ1HkhGydAMKZ7+VEO4lcgJbGDjElAPMkebZ5e8CtmkFRLUpVrA3o
         OH3wiR3UhKooKozCXFb/AK+DB14igSOBFWRv4wIZXdGEK2d8AuCUEfEYvBhZP0Cg5paq
         6pOOAJwDnxwBUFMQpUyk4VIkCdFWscLadAegP5D4BALp9F5sGH/Q25eHYqeOAHup8X5s
         dseCPzrpB3XLhFNiqqMZmowIiZndMVtO6KoFjpqy4hmBQqGyRxWrePNTBO2g9n0CcKGl
         NJICma9j4SBeuDB2cdcW8ewWzm6VnXJAQyBIJr9RQ2R/87EKEG2E+5BsCTQiolLe8LTt
         3Q5Q==
X-Gm-Message-State: AC+VfDzKX6l+10XFZS4FK+2kOHUzEVr54HxDQf48AaMEqUw2J+OSoRfS
        ikyABfVaEE1sBeuLMhLXXLVablwcHoc=
X-Google-Smtp-Source: ACHHUZ5jk4zVAGlzc8jJElwjaaKfZajOtQpAtV2UyVNZ78JFnea4BPAilTyAuzHctIJnMIswgm6ntA==
X-Received: by 2002:a17:903:22c8:b0:1ac:8def:db2a with SMTP id y8-20020a17090322c800b001ac8defdb2amr178185plg.0.1685049375677;
        Thu, 25 May 2023 14:16:15 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b0019ef86c2574sm1816189plx.270.2023.05.25.14.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 14:16:15 -0700 (PDT)
Message-ID: <6112c17a-15f3-4517-c73f-8cbbdde20a6b@acm.org>
Date:   Thu, 25 May 2023 14:16:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
 <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
 <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
 <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
 <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
Content-Language: en-US
In-Reply-To: <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 22:55, Adrian Hunter wrote:
> On 23/05/23 22:57, Bart Van Assche wrote:
>> On 5/23/23 12:19, Adrian Hunter wrote:
>>> On 23/05/23 20:10, Bart Van Assche wrote:
>>>> The overhead of BLK_MQ_F_BLOCKING is small relative to the
>>>> time required to queue a UFS command so I think enabling 
>>>> BLK_MQ_F_BLOCKING for all UFS host controllers is fine.
>>> 
>>> Doesn't it also force the queue to be run asynchronously always?
>>> 
>>> But in any case, it doesn't seem like something to force on 
>>> drivers just because it would take a bit more coding to make it 
>>> optional.
>> 
>> Making BLK_MQ_F_BLOCKING optional would complicate testing of the 
>> UFS driver. Although it is possible to make BLK_MQ_F_BLOCKING 
>> optional, I'm wondering whether it is worth it? I haven't noticed 
>> any performance difference in my tests with BLK_MQ_F_BLOCKING 
>> enabled compared to BLK_MQ_F_BLOCKING disabled.
> 
> It is hard to know the effects, especially wrt to future hardware.

Are you perhaps referring to performance effects? I think the block
layer can be modified to run the queue synchronously in most cases even
if BLK_MQ_F_BLOCKING is set. The patch below works fine but is probably
not acceptable for upstream because it uses in_atomic():


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 551e7760f45e..00fbe0aa56b5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1471,9 +1471,23 @@ static void blk_mq_requeue_work(struct work_struct *work)
  	blk_mq_run_hw_queues(q, false);
  }

+static bool may_sleep(void)
+{
+#ifdef CONFIG_PREEMPT_COUNT
+	return !in_atomic() && !irqs_disabled();
+#else
+	return false;
+#endif
+}
+
  void blk_mq_kick_requeue_list(struct request_queue *q)
  {
+	if (may_sleep()) {
+		blk_mq_requeue_work(&q->requeue_work.work);
+		return;
+	}
  	kblockd_mod_delayed_work_on(WORK_CPU_UNBOUND, &q->requeue_work, 0);
+
  }
  EXPORT_SYMBOL(blk_mq_kick_requeue_list);

@@ -2228,7 +2242,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
  	if (!need_run)
  		return;

-	if (async || (hctx->flags & BLK_MQ_F_BLOCKING) ||
+	if (async || (hctx->flags & BLK_MQ_F_BLOCKING && !may_sleep()) ||
  	    !cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask)) {
  		blk_mq_delay_run_hw_queue(hctx, 0);
  		return;


> What about something like this? [ ... ]

This introduces a redundancy and a potential for a conflict between the
"nonblocking" flag and the UFSHCD_CAP_CLK_GATING flag. It is unfortunate
that hba->caps is set so late otherwise we could use the result of
(hba->caps & UFSHCD_CAP_CLK_GATING) to check whether or not
BLK_MQ_F_BLOCKING is needed.

Additionally, this patch introduces a use-after-free issue since it
causes scsi_host_alloc() to store a pointer to a stack variable (sht)
into a SCSI host structure.

Bart.
