From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 10/12] scsi: sd_zbc: Disable zone write locking with
 scsi-mq
Date: Wed, 13 Sep 2017 09:13:12 +0900
Message-ID: <f1c3b0e2-4943-4be0-a97d-5138bad351cd@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-11-damien.lemoal@wdc.com>
 <20170908124329.GA18932@ming.t460p>
 <8c23a8c8-e945-fd4c-ee6c-da9b097de30b@wdc.com>
 <20170910051010.GB11628@ming.t460p>
 <5a10d60d-b18c-0956-59cd-69cb865019df@wdc.com>
 <20170912092629.GB15792@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170912092629.GB15792@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Ming,

On 9/12/17 18:26, Ming Lei wrote:
>>> OK, I suggest to document this guarantee of no write reorder for ZBC
>>> somewhere, so that people will keep it in mind when trying to change
>>> the current code.
>>
>> Have you looked at the comments in sd_zbc.c ? That is explained there.
>> Granted, this is a little deep in the stack, but this is after all
>> dependent on the implementation of scsi_request_fn(). I can add comments
>> there too if you prefer.
> 
> Yeah, I looked at that, but seems it is too coarse.

OK. Will improve that in V3.

>> Zoned disks are recent and all of them support FUA. This means that a
>> write with FUA will be processed like any other write request (if I read
>> the code in blk-flush.c correctly). Well, at least for the mq case,
>> which does a blk_mq_sched_insert_request(), while the direct call to
> 
> blk_mq_sched_bypass_insert() can be called for flush requests too,
> since requests in flush sequence share one driver tag(rq->tag != -1),
> then the rq can be added to front of hctx->dispatch directly.

For pure flush commands, any order is OK, since these are not actual
writes. the ZBC/ZAC standards do not modify the behavior of
flush/synchronize cache commands.

But I will look into more detail at the PREFLUSH/POSTFLUSH mechanic and
relation to write request ordering to make sure no corner cases are left
ignored.

Thanks for the comments.

Best regards.

-- 
Damien Le Moal,
Western Digital
