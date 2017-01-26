From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Thu, 26 Jan 2017 16:26:01 -0700
Message-ID: <e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485472465.2540.19.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 04:14 PM, Bart Van Assche wrote:
> On Thu, 2017-01-26 at 14:51 -0700, Jens Axboe wrote:
>> That is exactly what it means, looks like that one path doesn't handle
>> that.  You'd have to exhaust the pool with atomic allocs for this to
>> trigger, we don't do that at all in the normal IO path. So good catch,
>> must be the dm part that enables this since it does NOWAIT allocations.
>>
>>
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>> index 3136696f4991..c27613de80c5 100644
>> --- a/block/blk-mq-sched.c
>> +++ b/block/blk-mq-sched.c
>> @@ -134,7 +134,8 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
>>  			rq = __blk_mq_alloc_request(data, op);
>>  	} else {
>>  		rq = __blk_mq_alloc_request(data, op);
>> -		data->hctx->tags->rqs[rq->tag] = rq;
>> +		if (rq)
>> +			data->hctx->tags->rqs[rq->tag] = rq;
>>  	}
>>  
>>  	if (rq) {
> 
> Hello Jens,
> 
> With these two patches applied the scheduling-while-atomic complaint and
> the oops are gone. However, some tasks get stuck. Is the console output
> below enough to figure out what is going on or do you want me to bisect
> this? I don't think that any requests got stuck since no pending requests
> are shown in /sys/block/*/mq/*/{pending,*/rq_list}.

What device is stuck? Is it running with an mq scheduler attached, or
with "none"?

Would also be great to see the output of /sys/block/*/mq/*/tags and
sched_tags so we can see if they have anything pending.

>From a quick look at the below, it looks like a request leak. Bisection
would most likely be very helpful.

-- 
Jens Axboe
