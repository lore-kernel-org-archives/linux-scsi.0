Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3838C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 13:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67823613C4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 13:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEDNNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 09:13:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:51136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhEDNNG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 09:13:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9EAE7B1D7;
        Tue,  4 May 2021 13:12:10 +0000 (UTC)
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
 <3e41e5ea-6313-9718-c07d-20f8b203efd2@acm.org>
 <1db7fc49-17a9-1c8d-9d94-9a1b3694f392@suse.de>
 <7a9ceb36-32dc-4fcc-49a2-f4c2ca2286c3@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e2d2b5f7-6f8d-241e-5a38-44cbcd7fc772@suse.de>
Date:   Tue, 4 May 2021 15:12:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <7a9ceb36-32dc-4fcc-49a2-f4c2ca2286c3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 12:55 PM, John Garry wrote:
> On 04/05/2021 07:17, Hannes Reinecke wrote:
>> On 5/4/21 5:20 AM, Bart Van Assche wrote:
>>> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>>> These commands are set aside before allocating the block-mq tag bitmap,
>>>> so they'll never show up as busy in the tag map.
>>>
>>> That doesn't sound correct to me. Should the above perhaps be changed
>>> into "blk_mq_start_request() is never called for internal commands so
>>> they'll never show up as busy in the tag map"?
>>>
>> Yes, will do.
> 
> So why don't these - or shouldn't these - turn up in the busy tag map?
> 
> One of the motivations to use these block requests for internal commands 
> is that we can take advantage of the block layer handling for CPU 
> hotplug for MQ hosts, i.e. if blk-mq can't see these are inflight, then 
> they would be missed in blk_mq_hctx_notify_offline() -> 
> blk_mq_hctx_has_requests(), right? And who knows what else...
> 
Oh, but of course it's possible to call 'start' on these requests to 
have them counted in the busy map.
I just didn't see the need for it until now, that's all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
