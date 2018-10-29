From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 10/14] blk-mq: initial support for multiple queue maps
Date: Mon, 29 Oct 2018 14:29:17 -0600
Message-ID: <50515ef4-35d4-b238-e0fe-799c2fc758cb@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-11-axboe@kernel.dk>
 <1540842034.196084.89.camel@acm.org>
 <ac755067-1432-54ce-6a4f-c7383f1ecc9d@kernel.dk>
 <1540843250.196084.93.camel@acm.org>
 <867d3e60-3edf-39e7-2bcb-02d7f1092f82@kernel.dk>
 <1540844730.196084.95.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540844730.196084.95.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 2:25 PM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 14:09 -0600, Jens Axboe wrote:
>> hctx->type will be set to the value of the first type. This is all driver
>> private, blk-mq could not care less what the value of the type means.
>>
>> As to the other question, it works just fine since that is the queue
>> that is being accessed. There's no confusion there. I think you're
>> misunderstanding how it's seutp. To use nvme as the example, type 0
>> would be reads, 1 writes, and 2 pollable queues. If reads and writes
>> share the same set of hardware queues, then type 1 simply doesn't
>> exist in terms of ->flags_to_type() return value. This is purely
>> driven by the driver. That hook is the only decider of where something
>> will go. If we share hctx sets, we share the same hardware queue as
>> well. There is just the one set for that case.
> 
> How about adding a comment in blk-mq.h that explains that hardware queues can
> be shared among different hardware queue types? I think this is nontrivial and
> deserves a comment.

Sure, I can do that. I guess a key concept that is confusing based on
your above question is that the sets don't have to be consecutive.
It's perfectly valid to have 0 and 2 be the available queues, and
nothing for 1. For example.

BTW, split up the incremental patch, find them here:

http://git.kernel.dk/cgit/linux-block/commit/?h=mq-maps&id=6890d88deecfd3723ce620d82f5fc80485f9caec

and

http://git.kernel.dk/cgit/linux-block/commit/?h=mq-maps&id=907725dff2f8cc6d1502a9123f930b8d3708bd02

-- 
Jens Axboe
