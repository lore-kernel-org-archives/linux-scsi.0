From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/14] blk-mq: pass in request/bio flags to queue mapping
Date: Mon, 29 Oct 2018 11:33:32 -0600
Message-ID: <9b61eab8-0289-2127-5529-4f599fb1da24@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-5-axboe@kernel.dk> <1540834236.196084.61.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540834236.196084.61.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 11:30 AM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>> @@ -400,9 +402,15 @@ void blk_mq_sched_insert_requests(struct request_queue *q,
>>  				  struct blk_mq_ctx *ctx,
>>  				  struct list_head *list, bool run_queue_async)
>>  {
>> -	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
>> -	struct elevator_queue *e = hctx->queue->elevator;
>> +	struct blk_mq_hw_ctx *hctx;
>> +	struct elevator_queue *e;
>> +	struct request *rq;
>> +
>> +	/* For list inserts, requests better be on the same hw queue */
>> +	rq = list_first_entry(list, struct request, queuelist);
>> +	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
> 
> Passing all request cmd_flags bits to blk_mq_map_queue() makes it possible
> for that function to depend on every single cmd_flags bit even if different
> requests have different cmd_flags. Have you considered to pass the hw_ctx
> type only to blk_mq_map_queue() to avoid that that function would start
> depending on other cmd_flags?

The core only knows about the number of types, not what each type means
nor how to map it outside of using the mapping functions. So I don't
want to expose this is an explicit type, as that would then mean that
blk-mq had to know about them.

> Additionally, what guarantees that all requests in queuelist have the same
> hw_ctx type? If a later patch will guarantee that, please mention that in
> the comment about list_first_entry().

When the code is introduced, it's always the same hctx. Later on when we
do support multiple sets, the user of the list insert (plugging) explicitly
makes sure that a list only contains requests for the same hardware queue.

I'll improve the comment.

-- 
Jens Axboe
