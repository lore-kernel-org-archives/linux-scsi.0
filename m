Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F414C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 01:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjHOB5V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 21:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjHOB5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 21:57:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C27DD;
        Mon, 14 Aug 2023 18:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46AE760FEB;
        Tue, 15 Aug 2023 01:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1647C433C7;
        Tue, 15 Aug 2023 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692064622;
        bh=BnzR/JN4oNvbYjYsWxX/nQrjfDT6Wa7vPjVlojN31cU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eWPmBITUguftG5dGUakQ6JNvTUzIlhZD82R1BjkvUwAwwZLePTT7rm+PTwMbXXndj
         uKYSGBtdxGZHz9ds2HMpspXbty0YLAFe8h9K3aMv26v938kk4i+5fAffUOGf3ejLBr
         X9AxGvX2u3nF5tCDpWpobc7HMYJfJO16oPFwpiRXh6fpsrNBNLcmG1+yYCEBYnAAnQ
         BR6+cYdxm6m1P569+/Y9LjwND0yFW4RLXNfli0G+oLqTvkaWfyhI/1adqGTH3obYqK
         Xeg3kCjrs6s+tOL3Z2IDDgTJs3/5fsxiilotzBu0nCvqzSR2szFLYr1S1bPtSXRD2B
         VT7dPk9HiJ6bA==
Message-ID: <7ffbe765-95b2-832c-e38a-c353674ab39d@kernel.org>
Date:   Tue, 15 Aug 2023 10:57:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 2/9] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-3-bvanassche@acm.org>
 <0ba79726-fb9c-c5ae-146f-ffc29703ec21@kernel.org>
 <e7054af1-d820-b808-80ac-1b636c0f6a40@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <e7054af1-d820-b808-80ac-1b636c0f6a40@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/23 02:00, Bart Van Assche wrote:
> On 8/14/23 05:33, Damien Le Moal wrote:
>> On 8/12/23 06:35, Bart Van Assche wrote:
>>> @@ -934,7 +936,7 @@ static void dd_finish_request(struct request *rq)
>>>   
>>>   	atomic_inc(&per_prio->stats.completed);
>>>   
>>> -	if (blk_queue_is_zoned(q)) {
>>> +	if (rq->q->limits.use_zone_write_lock) {
>>
>> This is all nice and simple ! However, an inline helper to check
>> rq->q->limits.use_zone_write_lock would be nice. E.g.
>> blk_queue_use_zone_write_lock() ?
> 
> Hi Damien,
> 
> Do you perhaps want me to introduce a function that does nothing else than
> returning the value of q->limits.use_zone_write_lock? I'm asking this because
> recently I have seen a fair number of patches that remove functions that do
> nothing else than returning the value of a single member variable.

I think that what you proposed in your other email (modify
blk_req_needs_zone_write_lock) is better when you need to test
use_zone_write_lock using a request.
Not sure about the cases where we need to test that limit using the queue only.
I personally like helpers that avoid hardcoding accesses to the queue limits,
but if such helpers are not OK, that is fine. No strong opinion.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

