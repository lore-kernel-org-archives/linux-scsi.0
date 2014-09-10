From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 5/8] block: introduce blk_flush_queue to drive flush machinery
Date: Wed, 10 Sep 2014 09:25:59 +0800
Message-ID: <CACVXFVO_u+S+iNuUn-85XvbrTRzxj2a9=_So7fTCsoxUBkpYcw@mail.gmail.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
	<1410267949-21904-6-git-send-email-ming.lei@canonical.com>
	<20140909184331.GE16750@infradead.org>
	<540F4D07.4080103@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <540F4D07.4080103@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2014 at 2:55 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/09/2014 12:43 PM, Christoph Hellwig wrote:
>> On Tue, Sep 09, 2014 at 09:05:46PM +0800, Ming Lei wrote:
>>> This patch introduces 'struct blk_flush_queue' and puts all
>>> flush machinery related stuff into this strcuture, so that
>>
>> s/stuff/fields/
>> s/strcuture/structure/
>>
>> Looks good, but a few more nitpicks below.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>>> +int blk_init_flush(struct request_queue *q)
>>> +{
>>> +    int ret;
>>> +    struct blk_flush_queue *fq = kzalloc(sizeof(*fq), GFP_KERNEL);
>>>
>>> +    if (!fq)
>>>              return -ENOMEM;
>>>
>>> +    q->fq = fq;
>>
>> I think it would be cleaner to return the flush data structure and
>> assign it in the caller.
>
> I was going to suggest renaming because of this as well. If we do this:
>
>         q->fq = blk_init_flush(q);
>
> then it's immediately clear what it does, whereas blk_init_flush(q)
> means very little on its own. I'd change the naming to
> blk_alloc_flush_queue() and blk_free_flush_queue().

Exactly these two functions are introduced in patch 8/8, and I
will try to name them earlier in V1.

Thanks,
