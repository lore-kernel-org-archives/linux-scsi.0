Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B881C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C582070E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgFVOUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:20:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:34118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728956AbgFVOUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 10:20:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0ED32C1A8;
        Mon, 22 Jun 2020 14:19:58 +0000 (UTC)
Subject: Re: [PATCH 2/2] block: only return started requests from
 blk_mq_tag_to_rq()
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <keith.busch@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200619140159.141905-1-hare@suse.de>
 <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
 <3d073c18-50da-a4c8-2f1e-332a1e717efc@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ec87fc5f-a938-87ee-12c2-a08d76248b2e@suse.de>
Date:   Mon, 22 Jun 2020 16:13:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3d073c18-50da-a4c8-2f1e-332a1e717efc@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/20 11:59 PM, Bart Van Assche wrote:
> On 2020-06-19 07:09, Hannes Reinecke wrote:
>> On 6/19/20 4:01 PM, Hannes Reinecke wrote:
>>> blk_mq_tag_to_rq() is used from within the driver to map a tag
>>> to a request. As such it should only return requests which are
>>> already started (ie passed to the driver); otherwise the driver
>>> might trip over requests which it has never seen and random
>>> crashes will occur.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>    block/blk-mq.c | 6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 4f57d27bfa73..f02d18113f9e 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -815,9 +815,13 @@ EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
>>>      struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags,
>>> unsigned int tag)
>>>    {
>>> +    struct request *rq;
>>> +
>>>        if (tag < tags->nr_tags) {
>>>            prefetch(tags->rqs[tag]);
>>> -        return tags->rqs[tag];
>>> +        rq = tags->rqs[tag];
>>> +        if (blk_mq_request_started(rq))
>>> +            return rq;
>>>        }
>>>          return NULL;
>>>
>> This becomes particularly obnoxious for SCSI drivers using
>> scsi_host_find_tag() for cleaning up stale commands (ie drivers like
>> qla4xxx, fnic, and snic).
>> All other drivers use it from the completion routine, so one can expect
>> a valid (and started) tag here. So for those it shouldn't matter.
>>
>> But still, if there are objections I could look at fixing it within the
>> SCSI stack; although that would most likely mean I'll have to implement
>> the above patch as an additional function.
> 
> Hi Hannes,
> 
> Will the above patch make the fast path of every block driver slightly
> slower?
> 
> Shouldn't SCSI drivers (and other block drivers) use
> blk_mq_tagset_busy_iter() to clean up stale commands instead of
> iterating over all tags and calling blk_mq_tag_to_rq() directly?
> 
You can only iterate over all tags with blk_mq_tag_to_rq() if requests 
are identified with tags, ie if there is a 1:1 mapping between tags and 
internal commands.
Quite some drivers have their internal housekeeping (like hpsa), or do 
not track all commands via tags (eg fnic or csiostor).
For those the block layer iterator will not work as designed.

I'm currently preparing a patchset to clean that up (cf my patchset 
'reserved tags for SCSI'), but that will probably take some time until 
it'll be accepted.

And even then some drivers have to rely on scsi_host_find_tag() in eg 
TMF completions to figure out if the command for which the TMF was sent
is still active.

But we can move the check into the drivers if you are worried about 
performance impacts; it's a bit lame if you ask me, but if that's the 
way it should be handled, fine by me.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
