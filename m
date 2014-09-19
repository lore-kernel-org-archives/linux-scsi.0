From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 17:21:16 +0200
Message-ID: <541C49EC.6030404@acm.org>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org> <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/19/14 16:28, Ming Lei wrote:
> On Fri, Sep 19, 2014 at 9:00 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> @@ -2643,7 +2754,8 @@ static struct scsi_host_template srp_template = {
>>          .proc_name                      = DRV_NAME,
>>          .slave_configure                = srp_slave_configure,
>>          .info                           = srp_target_info,
>> -       .queuecommand                   = srp_queuecommand,
>> +       .queuecommand                   = srp_sq_queuecommand,
>> +       .mq_queuecommand                = srp_mq_queuecommand,
>
> Another choice is to obtain hctx from request directly, then mq can
> reuse the .queuecommand interface too.

Hello Ming,

Is the hctx information already available in the request data structure 
? I have found a mq_ctx member but no hctx member. Did I perhaps 
overlook something ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
