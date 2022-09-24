Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCBAC04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 01:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiIXBBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 21:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiIXBBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 21:01:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D500123852
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 18:01:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so1725634pjk.2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 18:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=jM/NFW+dzaacI3soZGyv7jPWC6pA1pw7cDCJhuL2E/8=;
        b=19NqT5W8oYJqWXv7sK7tkZgw39YSavL6E7bqfJ9W9KMEmQx3kAR99oSffuNcIST7zT
         Zk+EjQ0KoBTA3bP/Wlle4apJAXhuM9VXeSUp8Pca9Q0iBaKpdx8VC7m/SbCksnS6KAxt
         q1PtKeeStJt49FozhjDpPV/jqIgJgPmcFt0LwS7JdfoPws44U6DDHa5yYgWtLgdDc35G
         /4odI4rVtHwgTVC1k/sdl6DImwC/QXLL9zQI87xkcJuEivVAeUO1IcyH/1+NbGk/sxFT
         yxn4qlYjBsLKLqZG2IbYOubTheMoS15IJPe9enN+tmIU9Mpn+VMdRBmjzpeisMRi1lch
         kGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jM/NFW+dzaacI3soZGyv7jPWC6pA1pw7cDCJhuL2E/8=;
        b=xD9h45Ad9+s+lngESUAU2LidnCML+hqCqRySChGq9ZEPO+enUmX7uBdNr28UYfJfjT
         LnQtYvejBg6TApu11kL+TyiVKVlflfws8UI8wm0/PIzAo9PAQU7KaE3ByrKIW37xeXWw
         kQId5g9dw3ZWsDHHf8DSscnlvkvVt2oGupRHqXcqv2ODBTPX39gAuWyJ9WRn/Fka3Rtg
         BfiR7imhLw1DJFQuJHVcqemACqDNXnNUZYuFDl6TbwYCbozLxx8dGTcCxFL+4DqksJAa
         Wll7uSMHHpwt+zHX+PTrbZfvKafRs0YI3/lAbgOJyOhKuhBTyW5K6u/qlZ3w2doUSGQd
         VDrw==
X-Gm-Message-State: ACrzQf3yWV8x3RmlrL2tZy2u6rXAdlhP4oZrwafiMd4+6NVNlctusAOu
        2LwJaeNkEPxRRIPNwNJP7zsunw==
X-Google-Smtp-Source: AMsMyM6PjtMQW7Bi+dRsT6bCwYk/CGUTy4KNjBaElrFqSDHtnOFOVbl4Bxk2w4yKvUFJjESeMIldcA==
X-Received: by 2002:a17:90a:cf92:b0:202:ae52:43a4 with SMTP id i18-20020a17090acf9200b00202ae5243a4mr12298778pju.141.1663981279032;
        Fri, 23 Sep 2022 18:01:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f22-20020a635116000000b004308422060csm6157835pgb.69.2022.09.23.18.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:01:18 -0700 (PDT)
Message-ID: <ba0b3ae4-7001-af42-3549-cc52049ccccb@kernel.dk>
Date:   Fri, 23 Sep 2022 19:01:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/5] block: enable batched allocation for
 blk_mq_alloc_request()
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, joshi.k@samsung.com,
        Pankaj Raghav <pankydev8@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-2-axboe@kernel.dk>
 <CGME20220923145245eucas1p107655755f446bb1e1318539a3f82d301@eucas1p1.samsung.com>
 <20220923145236.pr7ssckko4okklo2@quentin>
 <c7b76fa1-f7e3-3ac6-c92d-35baa0d9a40a@samsung.com>
 <2e484ccb-b65b-2991-e259-d3f7be6ad1a6@kernel.dk>
 <a06df4ba-a968-0ee1-f8ff-062def0ec031@opensource.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a06df4ba-a968-0ee1-f8ff-062def0ec031@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/22 6:59 PM, Damien Le Moal wrote:
> On 9/24/22 05:54, Jens Axboe wrote:
>> On 9/23/22 9:13 AM, Pankaj Raghav wrote:
>>> On 2022-09-23 16:52, Pankaj Raghav wrote:
>>>> On Thu, Sep 22, 2022 at 12:28:01PM -0600, Jens Axboe wrote:
>>>>> The filesystem IO path can take advantage of allocating batches of
>>>>> requests, if the underlying submitter tells the block layer about it
>>>>> through the blk_plug. For passthrough IO, the exported API is the
>>>>> blk_mq_alloc_request() helper, and that one does not allow for
>>>>> request caching.
>>>>>
>>>>> Wire up request caching for blk_mq_alloc_request(), which is generally
>>>>> done without having a bio available upfront.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>  block/blk-mq.c | 80 ++++++++++++++++++++++++++++++++++++++++++++------
>>>>>  1 file changed, 71 insertions(+), 9 deletions(-)
>>>>>
>>>> I think we need this patch to ensure correct behaviour for passthrough:
>>>>
>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>> index c11949d66163..840541c1ab40 100644
>>>> --- a/block/blk-mq.c
>>>> +++ b/block/blk-mq.c
>>>> @@ -1213,7 +1213,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
>>>>         WARN_ON(!blk_rq_is_passthrough(rq));
>>>>  
>>>>         blk_account_io_start(rq);
>>>> -       if (current->plug)
>>>> +       if (blk_mq_plug(rq->bio))
>>>>                 blk_add_rq_to_plug(current->plug, rq);
>>>>         else
>>>>                 blk_mq_sched_insert_request(rq, at_head, true, false);
>>>>
>>>> As the passthrough path can now support request caching via blk_mq_alloc_request(),
>>>> and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
>>>> devices:
>>>>
>>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>>> {
>>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>>> 	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
>>>> 		return NULL;
>>>> ..
>>>
>>> Thinking more about it, even this will not fix it because op is
>>> REQ_OP_DRV_OUT if it is a NVMe write for passthrough requests.
>>>
>>> @Damien Should the condition in blk_mq_plug() be changed to:
>>>
>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>> {
>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>> 	if (bdev_is_zoned(bio->bi_bdev) && !op_is_read(bio_op(bio)))
>>> 		return NULL;
>>
>> That looks reasonable to me. It'll prevent plug optimizations even
>> for passthrough on zoned devices, but that's probably fine.
> 
> Could do:
> 
> 	if (blk_op_is_passthrough(bio_op(bio)) ||
> 	    (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio))))
> 		return NULL;
> 
> Which I think is way cleaner. No ?
> Unless you want to preserve plugging with passthrough commands on regular
> (not zoned) drives ?

We most certainly do, without plugging this whole patchset is not
functional. Nor is batched dispatch, for example.

-- 
Jens Axboe
