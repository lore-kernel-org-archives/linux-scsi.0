From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 11:33:15 -0600
Message-ID: <541C68DB.1050002@kernel.dk>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org>	<CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>	<541C4D2F.9060907@acm.org>	<541C4DF1.4090604@kernel.dk> <CAF9gx6LxWiXAWuSe8zt08NTzi9CmPU1RxRPo3e2AGT_J7QCojg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49800 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbaISRdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 13:33:00 -0400
Received: by mail-pd0-f173.google.com with SMTP id y10so343137pdj.18
        for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2014 10:32:59 -0700 (PDT)
In-Reply-To: <CAF9gx6LxWiXAWuSe8zt08NTzi9CmPU1RxRPo3e2AGT_J7QCojg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>

On 09/19/2014 11:30 AM, Sagi Grimberg wrote:
> On 9/19/2014 6:38 PM, Jens Axboe wrote:
>> On 09/19/2014 09:35 AM, Bart Van Assche wrote:
>>> On 09/19/14 17:27, Ming Lei wrote:
>>>> On Fri, Sep 19, 2014 at 11:21 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>>>> On 09/19/14 16:28, Ming Lei wrote:
>>>>>>
>>>>>> On Fri, Sep 19, 2014 at 9:00 PM, Bart Van Assche <bvanassche@acm.org>
>>>>>> wrote:
>>>>>>>
>>>>>>> @@ -2643,7 +2754,8 @@ static struct scsi_host_template srp_template = {
>>>>>>>            .proc_name                      = DRV_NAME,
>>>>>>>            .slave_configure                = srp_slave_configure,
>>>>>>>            .info                           = srp_target_info,
>>>>>>> -       .queuecommand                   = srp_queuecommand,
>>>>>>> +       .queuecommand                   = srp_sq_queuecommand,
>>>>>>> +       .mq_queuecommand                = srp_mq_queuecommand,
>>>>>>
>>>>>>
>>>>>> Another choice is to obtain hctx from request directly, then mq can
>>>>>> reuse the .queuecommand interface too.
>>>>>
>>>>>
>>>>> Hello Ming,
>>>>>
>>>>> Is the hctx information already available in the request data structure ? I
>>>>> have found a mq_ctx member but no hctx member. Did I perhaps overlook
>>>>> something ?
>>>>
>>>> You are right, but the mq_ctx can be mapped to hctx like below way:
>>>>
>>>> ctx = rq->mq_ctx;
>>>> hctx = q->mq_ops->map_queue(q, ctx->cpu);
>>>
>>> Hello Ming,
>>>
>>> Had you already noticed that the blk_mq_ctx data structure is a private
>>> data structure (declared in block/blk-mq.h) and hence not available to
>>> SCSI LLDs ? However, what might be possible is to cache the hctx pointer
>>> in the request structure, e.g. like in the (completely untested) patch
>>> below.
>>
>> ctx was meant to be private, unfortunately it's leaked a bit into other
>> parts of block/. But it's still private within that, at least.
>>
>> Lets not add more stuff to struct request, it's already way too large.
>> We could add an exported
>>
>> struct blk_mq_hw_ctx *blk_mq_request_to_hctx(struct request *rq)
>> {
>> struct request_queue *q = rq->q;
>>
>> return q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
>> }
>>
>> for this.
>>
> 
> Hey,
> 
> So I agree that we shouldn't overload struct request with another
> pointer, but it also seems a bit unnecessary to map again just to get
> the hctx. Since in the future we would like LLDs to use scsi-mq why not
> modify existing .queuecommand to pass hctx (or even better
> hctx->driver_data) and for now LLDs won't use it. Once they choose to,
> it will be available to them.

That'd be fine as well. The mapping is cheap, though, but it would make
sense to have an appropriate way to just pass it in like it happens for
->queue_rq() for native blk-mq drivers.


-- 
Jens Axboe

