From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 23:27:24 +0800
Message-ID: <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
References: <541C27BF.6070609@acm.org>
	<541C28E0.7010705@acm.org>
	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
	<541C49EC.6030404@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541C49EC.6030404-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 19, 2014 at 11:21 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 09/19/14 16:28, Ming Lei wrote:
>>
>> On Fri, Sep 19, 2014 at 9:00 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> wrote:
>>>
>>> @@ -2643,7 +2754,8 @@ static struct scsi_host_template srp_template = {
>>>          .proc_name                      = DRV_NAME,
>>>          .slave_configure                = srp_slave_configure,
>>>          .info                           = srp_target_info,
>>> -       .queuecommand                   = srp_queuecommand,
>>> +       .queuecommand                   = srp_sq_queuecommand,
>>> +       .mq_queuecommand                = srp_mq_queuecommand,
>>
>>
>> Another choice is to obtain hctx from request directly, then mq can
>> reuse the .queuecommand interface too.
>
>
> Hello Ming,
>
> Is the hctx information already available in the request data structure ? I
> have found a mq_ctx member but no hctx member. Did I perhaps overlook
> something ?

You are right, but the mq_ctx can be mapped to hctx like below way:

ctx = rq->mq_ctx;
hctx = q->mq_ops->map_queue(q, ctx->cpu);

Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
