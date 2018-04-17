From: Jens Axboe <axboe@kernel.dk>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 10:46:48 -0600
Message-ID: <001d538b-dfc1-b39e-56ad-cd54c807f247@kernel.dk>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name>
 <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
 <CAGXu5jLsX+nmc8hRSdOa28js7=ggPSGkUuTHbc3DUEcKSpEDbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLsX+nmc8hRSdOa28js7=ggPSGkUuTHbc3DUEcKSpEDbw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/18 10:42 AM, Kees Cook wrote:
> On Mon, Apr 16, 2018 at 8:12 PM, Kees Cook <keescook@chromium.org> wrote:
>> With a hardware watchpoint, I've isolated the corruption to here:
>>
>> bfq_dispatch_request+0x2be/0x1610:
>> __bfq_dispatch_request at block/bfq-iosched.c:3902
>> 3900            if (rq) {
>> 3901    inc_in_driver_start_rq:
>> 3902                    bfqd->rq_in_driver++;
>> 3903    start_rq:
>> 3904                    rq->rq_flags |= RQF_STARTED;
>> 3905            }
> 
> FWIW, the stacktrace here (removing the ? lines) is:
> 
> [   34.311980] RIP: 0010:bfq_dispatch_request+0x2be/0x1610
> [   34.452491]  blk_mq_do_dispatch_sched+0x1d9/0x260
> [   34.454561]  blk_mq_sched_dispatch_requests+0x3da/0x4b0
> [   34.458789]  __blk_mq_run_hw_queue+0xae/0x130
> [   34.460001]  __blk_mq_delay_run_hw_queue+0x192/0x280
> [   34.460823]  blk_mq_run_hw_queue+0x10b/0x1b0
> [   34.463240]  blk_mq_sched_insert_request+0x3bd/0x4d0
> [   34.467342]  blk_execute_rq+0xcf/0x140
> [   34.468483]  sg_io+0x2f7/0x730
> 
> Can anyone tell me more about the memory allocation layout of the
> various variables here? It looks like struct request is a header in
> front of struct scsi_request? How do struct elevator_queue, struct
> blk_mq_ctx, and struct blk_mq_hw_ctx overlap these?

The scsi_request is a payload item for the block request, it's
located right after the request in memory. These are persistent
allocations, we don't allocate/free them per IO.

blk_mq_ctx are the blk-mq software queues, they are percpu and
allocated when the queue is setup.

blk_mq_hw_ctx is the hardware queue. You probably have just one,
it's allocated when the queue is setup.

struct elevator_queue is allocated when the scheduler is attached
to the queue. This can get freed and allocated if you switch
the scheduler on a queue, otherwise it persists until the queue
is torn down (and the scheduler data is freed).

> Regardless, I'll check for elevator data changing too...

It should not change unless you switch IO schedulers. If you're
using BFQ and not switching, then it won't change.

-- 
Jens Axboe
