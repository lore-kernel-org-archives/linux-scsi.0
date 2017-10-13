From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 10:20:01 -0600
Message-ID: <7e318bdf-a4dd-16dc-3963-a3f1a6fc426a@kernel.dk>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013161739.GB30899@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:51014 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdJMQUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2017 12:20:05 -0400
Received: by mail-io0-f169.google.com with SMTP id 97so9533165iok.7
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2017 09:20:04 -0700 (PDT)
In-Reply-To: <20171013161739.GB30899@ming.t460p>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>

On 10/13/2017 10:17 AM, Ming Lei wrote:
> On Fri, Oct 13, 2017 at 08:44:23AM -0600, Jens Axboe wrote:
>> On 10/12/2017 06:19 PM, Ming Lei wrote:
>>> On Thu, Oct 12, 2017 at 12:46:24PM -0600, Jens Axboe wrote:
>>>> On 10/12/2017 12:37 PM, Ming Lei wrote:
>>>>> For SCSI devices, there is often per-request-queue depth, which need
>>>>> to be respected before queuing one request.
>>>>>
>>>>> The current blk-mq always dequeues one request first, then calls .queue_rq()
>>>>> to dispatch the request to lld. One obvious issue of this way is that I/O
>>>>> merge may not be good, because when the per-request-queue depth can't be
>>>>> respected,  .queue_rq() has to return BLK_STS_RESOURCE, then this request
>>>>> has to staty in hctx->dispatch list, and never got chance to participate
>>>>> into I/O merge.
>>>>>
>>>>> This patch introduces .get_budget and .put_budget callback in blk_mq_ops,
>>>>> then we can try to get reserved budget first before dequeuing request.
>>>>> Once we can't get budget for queueing I/O, we don't need to dequeue request
>>>>> at all, then I/O merge can get improved a lot.
>>>>
>>>> I can't help but think that it would be cleaner to just be able to
>>>> reinsert the request into the scheduler properly, if we fail to
>>>> dispatch it. Bart hinted at that earlier as well.
>>>
>>> Actually when I start to investigate the issue, the 1st thing I tried
>>> is to reinsert, but that way is even worse on qla2xxx.
>>>
>>> Once request is dequeued, the IO merge chance is decreased a lot.
>>> With none scheduler, it becomes not possible to merge because
>>> we only try to merge over the last 8 requests. With mq-deadline,
>>> when one request is reinserted, another request may be dequeued
>>> at the same time.
>>
>> I don't care too much about 'none'. If perfect merging is crucial for
>> getting to the performance level you want on the hardware you are using,
>> you should not be using 'none'. 'none' will work perfectly fine for NVMe
>> etc style devices, where we are not dependent on merging to the same
>> extent that we are on other devices.
> 
> We still have some SCSI device, such as qla2xxx, which is 1:1 multi-queue
> device, like NVMe, in my test, the big lock of mq-deadline has been
> an issue for this kind of device, and none actually is better than
> mq-deadline, even though its merge isn't good.

Kyber should be able to fill that hole, hopefully.

-- 
Jens Axboe
