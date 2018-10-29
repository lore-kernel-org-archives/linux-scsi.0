From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/14] blk-mq: support multiple hctx maps
Date: Mon, 29 Oct 2018 13:24:23 -0600
Message-ID: <214cdac8-9c13-213b-023f-2fb1bf67c8db@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-8-axboe@kernel.dk> <1540836903.196084.70.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540836903.196084.70.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 12:15 PM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>> -static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
>> -						     unsigned int flags,
>> -						     int cpu)
>> +static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *q,
>> +							  int type, int cpu)
>>  {
>>  	struct blk_mq_tag_set *set = q->tag_set;
>>  
>> -	return q->queue_hw_ctx[set->map[0].mq_map[cpu]];
>> +	return q->queue_hw_ctx[set->map[type].mq_map[cpu]];
>>  }
>>  
>> -static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *q,
>> -							  int type, int cpu)
>> +static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
>> +						     unsigned int flags,
>> +						     int cpu)
>>  {
>> -	return blk_mq_map_queue(q, type, cpu);
>> +	int type = 0;
>> +
>> +	if (q->mq_ops->flags_to_type)
>> +		type = q->mq_ops->flags_to_type(q, flags);
>> +
>> +	return blk_mq_map_queue_type(q, type, cpu);
>>  }
> 
> How about adding a comment above both these functions that explains their
> purpose? Since blk_mq_map_queue() maps rq->cmd_flags and the cpu index to
> a hardware context, how about renaming blk_mq_map_queue() into
> blk_mq_map_cmd_flags()?

I don't want to rename it, but I've added a kerneldoc function header to
both of them.

>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index f9e19962a22f..837087cf07cc 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -86,6 +86,7 @@ enum {
>>  
>>  struct blk_mq_tag_set {
>>  	struct blk_mq_queue_map	map[HCTX_MAX_TYPES];
>> +	unsigned int		nr_maps;
>>  	const struct blk_mq_ops	*ops;
>>  	unsigned int		nr_hw_queues;
>>  	unsigned int		queue_depth;	/* max hw supported */
>> @@ -109,6 +110,7 @@ struct blk_mq_queue_data {
>>  
>>  typedef blk_status_t (queue_rq_fn)(struct blk_mq_hw_ctx *,
>>  		const struct blk_mq_queue_data *);
>> +typedef int (flags_to_type_fn)(struct request_queue *, unsigned int);
> 
> How about adding a comment that the format of the second argument of
> flags_to_type_fn is the same as that of rq->cmd_flags?

Done

-- 
Jens Axboe
