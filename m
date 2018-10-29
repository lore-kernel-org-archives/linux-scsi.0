From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 13:53:12 -0600
Message-ID: <ac755067-1432-54ce-6a4f-c7383f1ecc9d@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-11-axboe@kernel.dk>
 <1540842034.196084.89.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540842034.196084.89.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 1:40 PM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>> -static int cpu_to_queue_index(unsigned int nr_queues, const int cpu)
>> +static int cpu_to_queue_index(struct blk_mq_queue_map *qmap,
>> +			      unsigned int nr_queues, const int cpu)
>>  {
>> -	return cpu % nr_queues;
>> +	return qmap->queue_offset + (cpu % nr_queues);
>>  }
>>
>> [ ... ]
>>  
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -78,10 +78,11 @@ struct blk_mq_hw_ctx {
>>  struct blk_mq_queue_map {
>>  	unsigned int *mq_map;
>>  	unsigned int nr_queues;
>> +	unsigned int queue_offset;
>>  };
> 
> I think it's unfortunate that the blk-mq core uses the .queue_offset member but
> that mapping functions in block drivers are responsible for setting that member.
> Since the block driver mapping functions have to set blk_mq_queue_map.nr_queues,
> how about adding a loop in blk_mq_update_queue_map() that derives .queue_offset
> from .nr_queues from previous array entries?

It's not a simple increment, so the driver has to be the one setting it. If
we end up sharing queues, for instance, then the driver will need to set
it to the start offset of that set. If you go two patches forward you
can see that exact construct.

IOW, it's the driver that controls the offset, not the core.

-- 
Jens Axboe
