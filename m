Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4EFC3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C1C2063A
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEBMME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 08:12:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:39600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgEBMME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 08:12:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB5D1AA55;
        Sat,  2 May 2020 12:12:02 +0000 (UTC)
Subject: Re: [PATCH RFC v3 22/41] block: implement persistent commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-23-hare@suse.de>
 <4cd47cec-90cf-8e3b-c3f8-8dc9d4d22c80@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c65981a3-68b9-e7f5-ea10-efe57bbb3dfc@suse.de>
Date:   Sat, 2 May 2020 14:11:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4cd47cec-90cf-8e3b-c3f8-8dc9d4d22c80@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 6:59 AM, Bart Van Assche wrote:
> On 2020-04-30 06:18, Hannes Reinecke wrote:
>> Some LLDDs implement event handling by sending a command to the
>> firmware, which then will be completed once the firmware wants
>> to register an event.
>       ^^^^^^^^
>       report?
> 
>> So worst case a command is being sent to the firmware then the
>                                                          ^^^^
>                                                          when?
>> driver initializes, and will be returned once the driver unloads.
>> To avoid these commands to block the queues during freezing or
>> quiescing this patch implements support for 'persistent' commands,
>> which will be excluded from blk_queue_enter() and blk_queue_exit()
>> calls.
> 
> How is it prevented that the SCSI timeout handler is activated for
> persistent commands?
> 
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/blk-mq.c            | 12 +++++++++---
>>   include/linux/blk-mq.h    |  2 ++
>>   include/linux/blk_types.h |  4 ++++
>>   3 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 44482aaed11e..402cf104d183 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -402,9 +402,14 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
>>   {
>>   	struct blk_mq_alloc_data alloc_data = { .flags = flags, .cmd_flags = op };
>>   	struct request *rq;
>> -	int ret;
>> +	int ret = 0;
>>   
>> -	ret = blk_queue_enter(q, flags);
>> +	if (flags & BLK_MQ_REQ_PERSISTENT) {
>> +		if (blk_queue_dying(q))
>> +			ret = -ENODEV;
>> +		alloc_data.cmd_flags |= REQ_PERSISTENT;
>> +	} else
>> +		ret = blk_queue_enter(q, flags);
>>   	if (ret)
>>   		return ERR_PTR(ret);
>>   
> 
> I think that not calling blk_queue_enter() for persistent commands means
> opening a giant can of worms. There is quite some code in the block
> layer that assumes that neither .queue_rq() nor the request completion
> code will be called if q_usage_counter == 0. Skipping the
> blk_queue_enter() call for persistent commands breaks that assumption. I
> think we need a better solution.
> 
Well, yeah, maybe.
My aim here is that _all_ I/O requiring a tag from the hardware will be 
tracked by the blocklayer tagset. Only that will give the block-layer 
accurate information about outstanding commands, such that the ongoing 
CPU hotplug discussion can make the correct decisions and implement 
functions really covering all outstanding I/O.
It also allows us to use the scsi_host_busy_iter() functions within the 
driver, and will get rid of the hand-crafted iterations the driver has 
to do now.

It worked reasonably well, until I encountered the infamous AEN 
commands, which actually require the opposite: _not_ to be tracked by 
the block layer at all, as the commands themselves are just placeholders
to be returned by the firmware once an event occurs.
(And yes, I _do_ think this is a quite dangerous operation, because I 
can't quite see how one could reliably return this command in case of a 
firmware crash ...)
(But anyhow, that's how the firmware is written and we have to live with 
it.)

So I implemented this approach, to have tags which are ignored by the 
block layer. But I have to admit that this approach relies on quite some 
assumptions (like these tags are never actually submitted to the 
blocklayer itself, are never started etc), none of which are spelled out 
clearly (yet).
An alternative approach would be to arbitrary decrease the tagset size 
by one (eg by shifting the tags by one), and use the free tag for AENs).
That would have to be coded within the driver, though.

If that's a solution which you like better I could give it a go.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
