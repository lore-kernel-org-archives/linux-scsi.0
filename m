From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 05/12] blk-mq: Introduce blk_mq_quiesce_queue()
Date: Thu, 27 Oct 2016 10:31:44 +0800
Message-ID: <CACVXFVNvdNXm4JXsXo2p1_pZLqDpCos0MTTR+svR98p_vw5PCA@mail.gmail.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <5143c240-39af-9fe2-d3e6-ed69f9c20531@sandisk.com> <CACVXFVPWL=izFmUPtpi-+RLrhNX0LFfw2m6eurgMC5GvfDWsxQ@mail.gmail.com>
 <7690b469-f5b7-ab04-4b6f-fa0d679e0f18@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35969 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933459AbcJ0Cbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 22:31:46 -0400
In-Reply-To: <7690b469-f5b7-ab04-4b6f-fa0d679e0f18@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Thu, Oct 27, 2016 at 10:04 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 10/26/16 18:30, Ming Lei wrote:
>>
>> On Thu, Oct 27, 2016 at 6:53 AM, Bart Van Assche
>> <bart.vanassche@sandisk.com> wrote:
>>>
>>> blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
>>> have finished. This function does *not* wait until all outstanding
>>> requests have finished (this means invocation of request.end_io()).
>>> The algorithm used by blk_mq_quiesce_queue() is as follows:
>>> * Hold either an RCU read lock or an SRCU read lock around
>>>   .queue_rq() calls. The former is used if .queue_rq() does not
>>>   block and the latter if .queue_rq() may block.
>>> * blk_mq_quiesce_queue() calls synchronize_srcu() or
>>>   synchronize_rcu() to wait for .queue_rq() invocations that
>>>   started before blk_mq_quiesce_queue() was called.
>>> * The blk_mq_hctx_stopped() calls that control whether or not
>>>   .queue_rq() will be called are called with the (S)RCU read lock
>>>   held. This is necessary to avoid race conditions against
>>>   the "blk_mq_stop_hw_queues(q); blk_mq_quiesce_queue(q);"
>>>   sequence from another thread.
>>>
>>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Ming Lei <tom.leiming@gmail.com>
>>> Cc: Hannes Reinecke <hare@suse.com>
>>> Cc: Johannes Thumshirn <jthumshirn@suse.de>
>>> ---
>>>  block/Kconfig          |  1 +
>>>  block/blk-mq.c         | 69
>>> +++++++++++++++++++++++++++++++++++++++++++++-----
>>>  include/linux/blk-mq.h |  3 +++
>>>  include/linux/blkdev.h |  1 +
>>>  4 files changed, 67 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/block/Kconfig b/block/Kconfig
>>> index 1d4d624..0562ef9 100644
>>> --- a/block/Kconfig
>>> +++ b/block/Kconfig
>>> @@ -5,6 +5,7 @@ menuconfig BLOCK
>>>         bool "Enable the block layer" if EXPERT
>>>         default y
>>>         select SBITMAP
>>> +       select SRCU
>>>         help
>>>          Provide block layer support for the kernel.
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 0cf21c2..4945437 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -115,6 +115,31 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
>>>  }
>>>  EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
>>>
>>> +/**
>>> + * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have
>>> finished
>>> + * @q: request queue.
>>> + *
>>> + * Note: this function does not prevent that the struct request end_io()
>>> + * callback function is invoked. Additionally, it is not prevented that
>>> + * new queue_rq() calls occur unless the queue has been stopped first.
>>> + */
>>> +void blk_mq_quiesce_queue(struct request_queue *q)
>>> +{
>>> +       struct blk_mq_hw_ctx *hctx;
>>> +       unsigned int i;
>>> +       bool rcu = false;
>>
>>
>> Before synchronizing SRCU/RCU, we have to set a per-hctx flag
>> or per-queue flag to block comming .queue_rq(), seems I mentioned
>> that before:
>>
>>    https://www.spinics.net/lists/linux-rdma/msg41389.html
>
>
> Hello Ming,
>
> Thanks for having included an URL to an archived version of that discussion.
> What I remember about that discussion is that I proposed to use the existing
> flag BLK_MQ_S_STOPPED instead of introducing a
> new QUEUE_FLAG_QUIESCING flag and that you agreed with that proposal. See
> also https://www.spinics.net/lists/linux-rdma/msg41430.html.

Yes, I am fine with either one, but the flag need to set in
blk_mq_quiesce_queue(), doesnt't it?


Thanks,
Ming Lei
