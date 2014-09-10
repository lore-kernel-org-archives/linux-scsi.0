From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 5/8] block: introduce blk_flush_queue to drive flush machinery
Date: Wed, 10 Sep 2014 09:23:27 +0800
Message-ID: <CACVXFVNjQyS6HzQy418jKGqjBr+waTx-gMrDnE9uhvfzUEJMaA@mail.gmail.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
	<1410267949-21904-6-git-send-email-ming.lei@canonical.com>
	<20140909184331.GE16750@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140909184331.GE16750@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2014 at 2:43 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Sep 09, 2014 at 09:05:46PM +0800, Ming Lei wrote:
>> This patch introduces 'struct blk_flush_queue' and puts all
>> flush machinery related stuff into this strcuture, so that
>
> s/stuff/fields/
> s/strcuture/structure/
>
> Looks good, but a few more nitpicks below.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
>> +int blk_init_flush(struct request_queue *q)
>> +{
>> +     int ret;
>> +     struct blk_flush_queue *fq = kzalloc(sizeof(*fq), GFP_KERNEL);
>>
>> +     if (!fq)
>>               return -ENOMEM;
>>
>> +     q->fq = fq;
>
> I think it would be cleaner to return the flush data structure and
> assign it in the caller.

OK, and most of this part is transitional.

>
>> +     INIT_LIST_HEAD(&fq->flush_queue[0]);
>> +     INIT_LIST_HEAD(&fq->flush_queue[1]);
>> +     INIT_LIST_HEAD(&fq->flush_data_in_flight);
>> +
>> +     if (q->mq_ops) {
>> +             ret = blk_mq_init_flush(q);
>
> I think we can just remove blk_mq_init_flush now that it's only
> called in blk-flush.c anyway.

blk_mq_init_flush() will become bigger in following patch.

>>  void blk_exit_flush(struct request_queue *q)
>>  {
>> +     if (q->mq_ops)
>> +             blk_mq_exit_flush(q);
>> +     else {
>> +             struct blk_flush_queue *fq = blk_get_flush_queue(q);
>> +             kfree(fq->flush_rq);
>> +             kfree(fq);
>> +     }
>
> Similarly I would pass the flush structure here.

OK.

>
>> +struct blk_flush_queue {
>> +     unsigned int            flush_queue_delayed:1;
>> +     unsigned int            flush_pending_idx:1;
>> +     unsigned int            flush_running_idx:1;
>> +     unsigned long           flush_pending_since;
>> +     struct list_head        flush_queue[2];
>> +     struct list_head        flush_data_in_flight;
>> +     struct request          *flush_rq;
>> +     spinlock_t              mq_flush_lock;
>> +};
>
> As this isn't really a queue I would call it blk_flush_data.

It is sort of a queue since there is a double buffer flush queue.

>
>> +static inline struct blk_flush_queue *blk_get_flush_queue(
>> +             struct request_queue *q)
>> +{
>> +     return q->fq;
>> +}
>
> I don't think there is a need for this helper.

No, the helper can simplify the following patch a lot since
the flush queue data is always obtained from this helper in both
legacy and mq case, which will take per-hw_queue flush queue.

Thanks,
