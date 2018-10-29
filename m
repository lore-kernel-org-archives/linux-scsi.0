From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 03/14] blk-mq: provide dummy blk_mq_map_queue_type()
 helper
Date: Mon, 29 Oct 2018 11:27:58 -0600
Message-ID: <ac06591d-f3de-514d-7d29-cbfc34ffeb1c@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-4-axboe@kernel.dk> <1540833779.196084.56.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540833779.196084.56.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 11:22 AM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index 889f0069dd80..79c300faa7ce 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -80,6 +80,12 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
>>  	return q->queue_hw_ctx[set->map[0].mq_map[cpu]];
>>  }
>>  
>> +static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *q,
>> +							  int type, int cpu)
>> +{
>> +	return blk_mq_map_queue(q, cpu);
>> +}
>> +
>>  /*
>>   * sysfs helpers
>>   */
> 
> How about renaming 'type' into something like hw_ctx_type to make it more
> clear what its meaning is? How about declaring both the 'type' and 'cpu'
> arguments as unsigned ints?

I can do that. For the CPU type, the existing prototype is already
int for CPU. But may as well just update them both in the same patch.

-- 
Jens Axboe
