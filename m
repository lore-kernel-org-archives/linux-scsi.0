From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Thu, 02 Oct 2014 10:55:04 -0600
Message-ID: <542D8368.8080604@kernel.dk>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org> <542C31C4.1020702@kernel.dk> <542D8143.3050305@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58843 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaJBQzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 12:55:03 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so2855242pab.6
        for <linux-scsi@vger.kernel.org>; Thu, 02 Oct 2014 09:55:02 -0700 (PDT)
In-Reply-To: <542D8143.3050305@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>

On 10/02/2014 10:45 AM, Bart Van Assche wrote:
> On 10/01/14 18:54, Jens Axboe wrote:
>> Lets get rid of the blk_mq_tag struct and just have it be an u32 or 
>> something. We could potentially typedef it, but I'd prefer to just have 
>> it be an unsigned 32-bit int.
>>
>> Probably also need some init time safety checks that 16-bits is enough 
>> to hold BLK_MQ_MAX_DEPTH. Just in case that is ever bumped, or the queue 
>> prefixing changes.
>>
>> And I think we need to name this better. Your comment correctly 
>> describes that this generates a unique tag queue wide, but the name of 
>> the function implies that we just return the request tag. Most drivers 
>> wont use this. Perhaps add a queue flag that tells us that we should 
>> generate these tags and have it setup ala:
>>
>> u32 blk_mq_unique_rq_tag(struct request *rq)
>> {
>>      struct request_queue *q = rq->q;
>>      u32 tag = rq->tag & ((1 << 16) - 1);
>>      struct blk_mq_hw_ctx *hctx;
>>
>>      hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
>>      return tag | (hctx->queue_num << 16);
>> }
>>
>> u32 blk_mq_rq_tag(struct request *rq)
>> {
>>      struct request_queue *q = rq->q;
>>
>>      if (q->mq_ops &&
>>          test_bit(QUEUE_FLAG_UNIQUE_TAGS, &q->queue_flags))
>>          return blk_mq_unique_rq_tag(rq);
>>
>>      return rq->tag;
>> }
> 
> Would it be acceptable to let blk_mq_rq_tag() always return the
> hardware context number and the per-hctx tag ? Block and SCSI LLD 

Sure, that's fine as well, but the function needs a more descriptive
name. I try to think of it like I have never looked at the code and need
to write a driver, it's a lot easier if the functions are named
appropriately. Seeing blk_mq_rq_tag() and even with reading the function
comment, I'm really none the wiser and would assume I need to use this
function to get the tag.

So we can do the single function, but lets call it
blk_mq_unique_rq_tag(). That's special enough that people will know this
is something that doesn't just return the request tag. Then add an extra
sentence to the comment you already have on when this is needed.

And lets roll those bitshift values and masks into a define or enum so
it's collected in one place.

-- 
Jens Axboe

