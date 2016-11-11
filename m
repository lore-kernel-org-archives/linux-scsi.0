From: Hannes Reinecke <hare@suse.de>
Subject: Re: Reduced latency is killing performance
Date: Fri, 11 Nov 2016 12:39:08 +0100
Message-ID: <9ce7d6d2-cdb1-9aea-4333-c2733710cf98@suse.de>
References: <72489f3f-d181-09a2-fc17-27ba36ad9620@suse.de>
 <DF4PR84MB0169E701F447438730B8E954ABBB0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <DF4PR84MB0169E701F447438730B8E954ABBB0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-block-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/11/2016 08:02 AM, Elliott, Robert (Persistent Memory) wrote:
>
>
>> -----Original Message-----
>> From: linux-block-owner@vger.kernel.org [mailto:linux-block-
>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>> Sent: Thursday, November 10, 2016 10:05 AM
>> To: Jens Axboe <axboe@kernel.dk>; Christoph Hellwig <hch@lst.de>
>> Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>; linux-
>> block@vger.kernel.org
>> Subject: Reduced latency is killing performance
>>
>> Hi all,
>>
>> this really feels like a follow-up to the discussion we've had in
>> Santa Fe, but finally I'm able to substantiate it with some numbers.
>>
>> I've made a patch to enable the megaraid_sas driver for multiqueue.
>> While this is pretty straightforward (I'll be sending the patchset
>> later on), the results are ... interesting.
>>
>> I've run the 'ssd-test.fio' script from Jens' repository, and these
>> results for MQ/SQ (- is mq, + is sq):
>>
>>  Run status group 0 (all jobs):  [4 KiB sequential reads]
>> -   READ: io=10641MB, aggrb=181503KB/s
>> +   READ: io=18370MB, aggrb=312572KB/s
>>
>>  Run status group 1 (all jobs):  [4 KiB random reads]
>> -   READ: io=441444KB, aggrb=7303KB/s
>> +   READ: io=223108KB, aggrb=3707KB/s
>>
>>  Run status group 2 (all jobs):  [4 KiB sequential writes]
>> -  WRITE: io=22485MB, aggrb=383729KB/s
>> +  WRITE: io=47421MB, aggrb=807581KB/s
>>
>>  Run status group 3 (all jobs):  [4 KiB random writes]
>> -  WRITE: io=489852KB, aggrb=8110KB/s
>> +  WRITE: io=489748KB, aggrb=8134KB/s
>>
>>  Disk stats (read/write):
>> -  sda: ios=2834412/5878578, merge=0/0
>> +  sda: ios=205278/2680329, merge=4552593/9580622
>
> [deleted minb, maxb, mint, maxt, ticks, in_queue, and util above]
>
>>
>> As you can see, we're really losing performance in the multiqueue
>> case.
>> And the main reason for that is that we submit about _10 times_ as
>> much I/O as we do for the single-queue case.
>
> That script is running:
> 0) 4 KiB sequential reads
> 1) 4 KiB random reads
> 2) 4 KiB sequential writes
> 3) 4 KiB random writes
>
> I think you're just seeing a lack of merges for the tiny sequential
> workloads.  Those are the ones where mq has lower aggrb results.
>
Yep.

> Check the value in /sys/block/sda/queue/nomerges. The values are
>     0=search for fast and slower merges
>     1=only attempt fast merges
>     2=don't attempt any merges
>
It's set to '0'.

> The SNIA Enterprise Solid State Storage Performance Test Specification
> (SSS PTS-E) only measures 128 KiB and 1 MiB sequential IOs - it doesn't
> test tiny sequential IOs.  Applications may do anything, but I think
> most understand that fewer, bigger transfers are more efficient
> throughout the IO stack.  A blocksize of 128 KiB would reduce those
> IOs by 96%.
>
Note: it's just the test which has been named 'SSD'. The devices 
themselves were no SSDs; just normal disks.

> For hpsa, we often turned them off to avoid the overhead while running
> applications generating decent-sized IOs on their own.
>
> Note that the random read aggrb value doubled with mq, and random
> writes showed no impact.
>
> You might also want to set
>     cpus_allowed_policy=split
> to keep threads from wandering across CPUs (and thus changing queues).
>
Done so; no difference.

>> So I guess having an I/O scheduler is critical, even for the scsi-mq
>> case.
>
> blk-mq still supports merges without any scheduler.
>
But it doesn't _do_ merging, as the example nicely shows.

So if we could get merging going we should be halfway there ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
