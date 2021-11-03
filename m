Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954F4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F7D2610A8
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhKCDXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 23:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhKCDXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 23:23:49 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BB2C061205
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 20:21:14 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id w10so1135221ilc.13
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 20:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nndE3bXje7v1hNIF7AwZXvSEQQyGas46aJLK284tBE=;
        b=j9z7xjNnS5ETYg8Q72T5Xdf6iuSHyqOGf0yU1wJNbbqUezM2apSlpnMP3RHZ2oZm8P
         /WzviMl42aB+xpNu0obC9UpvYGKIDHcEfdEcBYN0HpesuAvPnY9TqxHnty/ltR5xTTxh
         /z/g5LvMy4RYv583LPMF6urmOVXTTu8rSFR8gmz+53+OvUCvSGm9M2k7FpunFsN0M/D/
         rE0UCcgkJy/7DAB3gqL2PQRBXn8ipB+nn2NuDufjeeYS7ieObPR9gyQeVWGzvKOp2/C9
         uTsSFvgi9AlgzH+ho1jbS0TvpSq0C+f83gyzHYfgwlI7vbjp4dKNBRz48mD8aYS7beRE
         htTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nndE3bXje7v1hNIF7AwZXvSEQQyGas46aJLK284tBE=;
        b=e1FxyxVPs/Qyhro24XyCQL5hzq09yU1vnO/QCEXMV07N+Hw0xh8F/ReZdWSoRysQdz
         fa9Nvp1/vaqvae5aS5p4ZIUKDZyEsqwlmVRp/nb1c1HOu8bksMp587bNmFh4DLBsEvA8
         LauYDnq61h1mPZgjhvW8fZLicn2L53lZ4AiF8+bmSed73ytlH9z5vc+OD/Q1H7HU2Y1J
         pdQbFmdOFgPy4dYFFOX1RNbjbDlUapFtRwOvJUnRNPAIW6YHeMa0O20N9LbcAtKc6gQy
         NP+Z+ZSjb6Odg9ynIVBMyyBUBJJpvrQivbEg/LN8Ez5wmDIFy2QFW8bWiFnNL9/MVLsy
         Q2gw==
X-Gm-Message-State: AOAM532yiXm8ZBFpNyi2c1HvGDxzbsIqBINICe1eLqnPoA6/LpPXWgZB
        RVCT7Yd2af6BwNDTIL9he++quV1KCFIzZw==
X-Google-Smtp-Source: ABdhPJzGYSHWgG5gxXyAsqg8Tw8gDMfzIc938IuDdh0mkt+a7Zficg5mNUWgA+73MBBxMI6zSTOGtQ==
X-Received: by 2002:a05:6e02:1d9e:: with SMTP id h30mr21815713ila.138.1635909673421;
        Tue, 02 Nov 2021 20:21:13 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s12sm435613iol.30.2021.11.02.20.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:21:13 -0700 (PDT)
Subject: Re: [bug report] WARNING: CPU: 1 PID: 1386 at
 block/blk-mq-sched.c:432 blk_mq_sched_insert_request+0x54/0x178
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        linux-block <linux-block@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <CAHj4cs-NUKzGj5pgzRhDgdrGGbgPBqUoQ44+xgvk6njH9a_RYQ@mail.gmail.com>
 <1cf57bc2-5283-a2ce-0bbc-db6a62953c8f@linux.ibm.com>
 <e9965a7c-faba-496e-8110-dbe8f7065080@kernel.dk>
 <4f3811f6-88d9-c0c6-055f-1a3220357e22@kernel.dk>
 <CAHj4cs_+ZDe3KVbKYUK0XnupTxU2MqfA6ARxMkhkTwg9hYBiLg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb1c00aa-8d06-ef04-4621-0f7b02f54d93@kernel.dk>
Date:   Tue, 2 Nov 2021 21:21:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHj4cs_+ZDe3KVbKYUK0XnupTxU2MqfA6ARxMkhkTwg9hYBiLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 8:21 PM, Yi Zhang wrote:
>>
>> Can either one of you try with this patch? Won't fix anything, but it'll
>> hopefully shine a bit of light on the issue.
>>
> Hi Jens
> 
> Here is the full log:

Thanks! I think I see what it could be - can you try this one as well,
would like to confirm that the condition I think is triggering is what
is triggering.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 07eb1412760b..81dede885231 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2515,6 +2515,8 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (plug && plug->cached_rq) {
 		rq = rq_list_pop(&plug->cached_rq);
 		INIT_LIST_HEAD(&rq->queuelist);
+		WARN_ON_ONCE(q->elevator && !(rq->rq_flags & RQF_ELV));
+		WARN_ON_ONCE(!q->elevator && (rq->rq_flags & RQF_ELV));
 	} else {
 		struct blk_mq_alloc_data data = {
 			.q		= q,
@@ -2535,6 +2537,8 @@ void blk_mq_submit_bio(struct bio *bio)
 				bio_wouldblock_error(bio);
 			goto queue_exit;
 		}
+		WARN_ON_ONCE(q->elevator && !(rq->rq_flags & RQF_ELV));
+		WARN_ON_ONCE(!q->elevator && (rq->rq_flags & RQF_ELV));
 	}
 
 	trace_block_getrq(bio);

-- 
Jens Axboe

