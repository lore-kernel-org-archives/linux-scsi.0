From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq queue selection and queue_rq preemption
Date: Mon, 07 Apr 2014 13:45:39 -0600
Message-ID: <53430063.1020503@kernel.dk>
References: <53429DA2.4030708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52813 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaDGTpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 15:45:40 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so6976782pdj.41
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2014 12:45:40 -0700 (PDT)
In-Reply-To: <53429DA2.4030708@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>

On 04/07/2014 06:44 AM, Sagi Grimberg wrote:
> Hey Jens, Christoph & Co,
>
> I raised this question at LSF but didn't get a clear answer on this matter.
> So it seems to me that the hctx selection and the actual request
> dispatch (queue_rq) are preemptive:
> (1) blk_mq_get_ctx(q);
> (2) map_queue(q, ctx->cpu);
> ...
> (3) blk_mq_put_ctx(ctx);
> (4) blk_mq_run_hw_queue(hctx, async);
>
> It is possible that an MQ device driver may want to implement a lockless
> scheme counting on (running) CPU <-> hctx attachment.
> Generally speaking, I think that LLDs will be more comfortable knowing
> that they are not preemptive in the dispatch flow.
>
> My question is, is this a must? if so can you please explain why?
>
> Is it possible to put the hctx (restoring preemption) after run_hw_queue
> allowing to LLDs to be sure that the selected queue
> match the running CPU?

It's a good question, and one I have thought about before. As you note, 
in the existing code, the mappings are what I would refer to as "soft". 
Generally speaking, CPU X will always map to hardware queue Y, but there 
are no specific guarantees made to effect. It would be trivial to make 
this mapping hard, and I'd be very open to doing that. But so far I 
haven't seen cases where it would improve things. If you end up being 
preempted and moved to a different CPU, it doesn't really matter if this 
happens before or after you queued the IO - the completion will end up 
in the "wrong" location regardless.

But if drivers can be simplified and improved through relying on hard 
mappings (and preempt hence disabled), then I would definitely provide 
that possibility as well. If it doesn't hurt by default, we can just 
switch to that model.

-- 
Jens Axboe

