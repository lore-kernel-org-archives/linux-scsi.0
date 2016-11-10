From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Reduced latency is killing performance
Date: Thu, 10 Nov 2016 09:47:53 -0700
Message-ID: <0d0f1e6f-0f61-c316-8db8-112c4de1d8c9@kernel.dk>
References: <72489f3f-d181-09a2-fc17-27ba36ad9620@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <72489f3f-d181-09a2-fc17-27ba36ad9620@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/10/2016 09:04 AM, Hannes Reinecke wrote:
> Hi all,
>
> this really feels like a follow-up to the discussion we've had in Santa
> Fe, but finally I'm able to substantiate it with some numbers.
>
> I've made a patch to enable the megaraid_sas driver for multiqueue.
> While this is pretty straightforward (I'll be sending the patchset later
> on), the results are ... interesting.
>
> I've run the 'ssd-test.fio' script from Jens' repository, and these
> results for MQ/SQ (- is mq, + is sq):
>
>  Run status group 0 (all jobs):
> -   READ: io=10641MB, aggrb=181503KB/s, minb=181503KB/s,
> maxb=181503KB/s, mint=60033msec, maxt=60033msec
> +   READ: io=18370MB, aggrb=312572KB/s, minb=312572KB/s,
> maxb=312572KB/s, mint=60181msec, maxt=60181msec
>
>  Run status group 1 (all jobs):
> -   READ: io=441444KB, aggrb=7303KB/s, minb=7303KB/s, maxb=7303KB/s,
> mint=60443msec, maxt=60443msec
> +   READ: io=223108KB, aggrb=3707KB/s, minb=3707KB/s, maxb=3707KB/s,
> mint=60182msec, maxt=60182msec
>
>  Run status group 2 (all jobs):
> -  WRITE: io=22485MB, aggrb=383729KB/s, minb=383729KB/s,
> maxb=383729KB/s, mint=60001msec, maxt=60001msec
> +  WRITE: io=47421MB, aggrb=807581KB/s, minb=807581KB/s,
> maxb=807581KB/s, mint=60129msec, maxt=60129msec
>
>  Run status group 3 (all jobs):
> -  WRITE: io=489852KB, aggrb=8110KB/s, minb=8110KB/s, maxb=8110KB/s,
> mint=60399msec, maxt=60399msec
> +  WRITE: io=489748KB, aggrb=8134KB/s, minb=8134KB/s, maxb=8134KB/s,
> mint=60207msec, maxt=60207msec
>
>  Disk stats (read/write):
> -  sda: ios=2834412/5878578, merge=0/0, ticks=86269292/48364836,
> in_queue=135345876, util=99.20%
> +  sda: ios=205278/2680329, merge=4552593/9580622,
> ticks=12539912/12965228, in_queue=25512312, util=99.59%
>
> As you can see, we're really losing performance in the multiqueue case.
> And the main reason for that is that we submit about _10 times_ as much
> I/O as we do for the single-queue case.

What's the setup like? I'm going to need more details.

The baseline test is using the legacy path, single queue. The new test
is multiqueue, scsi-mq. What's sda?

> So I guess having an I/O scheduler is critical, even for the scsi-mq case.

Each of these sections is a single job. For some reason we are not
merging as well as we should, that's the reason for the performance
loss. In fact, we're not merging at all. That's not IO scheduling.

-- 
Jens Axboe

