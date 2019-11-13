Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBBEC43215
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 18:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767AD206F0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 18:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfKMSid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 13:38:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:53434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727074AbfKMSi0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 13:38:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73D7BB022;
        Wed, 13 Nov 2019 18:38:23 +0000 (UTC)
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     John Garry <john.garry@huawei.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
Date:   Wed, 13 Nov 2019 19:38:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/19 5:21 PM, John Garry wrote:
> On 13/11/2019 15:38, Hannes Reinecke wrote:
>>>>> -        if (clear_ctx_on_error)
>>>>> -            data->ctx = NULL;
>>>>> -        blk_queue_exit(q);
>>>>> -        return NULL;
>>>>> +    if (data->hctx->shared_tags) {
>>>>> +        shared_tag = blk_mq_get_shared_tag(data);
>>>>> +        if (shared_tag == BLK_MQ_TAG_FAIL)
>>>>> +            goto err_shared_tag;
>>>>>        }
>>>>>    -    rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags,
>>>>> alloc_time_ns);
>>>>> +    tag = blk_mq_get_tag(data);
>>>>> +    if (tag == BLK_MQ_TAG_FAIL)
>>>>> +        goto err_tag;
>>>>> +
>>>>> +    rq = blk_mq_rq_ctx_init(data, tag, shared_tag, data->cmd_flags,
>>>>> alloc_time_ns);
>>>>>        if (!op_is_flush(data->cmd_flags)) {
>>>>>            rq->elv.icq = NULL;
>>>>>            if (e && e->type->ops.prepare_request) {
>>> Hi Hannes,
>>>
>>>> Why do you need to keep a parallel tag accounting between 'normal' and
>>>> 'shared' tags here?
>>>> Isn't is sufficient to get a shared tag only, and us that in lieo of 
>>>> the
>>>> 'real' one?
>>> In theory, yes. Just the 'shared' tag should be adequate.
>>>
>>> A problem I see with this approach is that we lose the identity of which
>>> tags are allocated for each hctx. As an example for this, consider
>>> blk_mq_queue_tag_busy_iter(), which iterates the bits for each hctx.
>>> Now, if you're just using shared tags only, that wouldn't work.
>>>
>>> Consider blk_mq_can_queue() as another example - this tells us if a hctx
>>> has any bits unset, while with only using shared tags it would tell if
>>> any bits unset over all queues, and this change in semantics could break
>>> things. At a glance, function __blk_mq_tag_idle() looks problematic 
>>> also.
>>>
>>> And this is where it becomes messy to implement.
>>>
> 
> Hi Hannes,
> 
>> Oh, my. Indeed, that's correct.
> 
> The tags could be kept in sync like this:
> 
> shared_tag = blk_mq_get_tag(shared_tagset);
> if (shared_tag != -1)
>      sbitmap_set(hctx->tags, shared_tag);
> 
> But that's obviously not ideal.
> 
Actually, I _do_ prefer keeping both in sync.
We might want to check if the 'normal' tag is set (typically it would 
not, but then, who knows ...)
The beauty here is that both 'shared' and 'normal' tag are in sync, so 
if a driver would be wanting to use the tag as index into a command 
array it can do so without any surprises.

Why do you think it's not ideal?

>>
>> But then we don't really care _which_ shared tag is assigned; so
>> wouldn't be we better off by just having an atomic counter here?
>> Cache locality will be blown anyway ...
> The atomic counter would solve the issuing more than Scsi_host.can_queue 
> to the LLDD, but we still need a unique tag, which is what the shared 
> tag is.
> 
Yeah, true. Daft idea :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
