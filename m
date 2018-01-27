From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 28 Jan 2018 07:41:57 +0800
Message-ID: <20180127234151.GA21710@ming.t460p>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517091161.3055.7.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 27, 2018 at 10:12:43PM +0000, Bart Van Assche wrote:
> On Sat, 2018-01-27 at 14:09 -0500, Mike Snitzer wrote:
> > Ming let me know that he successfully tested this V3 patch using both
> > your test (fio to both mpath and underlying path) and Bart's (02-mq with
> > can_queue in guest).
> > 
> > Would be great if you'd review and verify this fix works for you too.
> > 
> > Ideally we'd get a fix for this regression staged for 4.16 inclusion.
> > This V3 patch seems like the best option we have at this point.
> 
> Hello Mike,
> 
> There are several issues with the patch at the start of this thread:
> - It is an unnecessary change of the block layer API. Queue stalls can
>   already be addressed with the current block layer API, namely by inserting
>   a blk_mq_delay_run_hw_queue() call before returning BLK_STS_RESOURCE.

Again, both Jens and I concluded that it is a generic issue, which need
generic solution.

	https://marc.info/?l=linux-kernel&m=151638176727612&w=2

Otherwise, it needs to change the handling on every BLK_STS_RESOURCE in
drivers, do we really want to do that?

Not mention, the request isn't added to dispatch list yet in .queue_rq(),
strictly speaking, it is not correct to call blk_mq_delay_run_hw_queue() in
.queue_rq(), so the current block layer API can't handle it well enough.

> - The patch at the start of this thread complicates code further that is
>   already too complicated, namely the blk-mq core.

That is just your opinion, I don't agree.

> - The patch at the start of this thread introduces a regression in the
>   SCSI core, namely a queue stall if a request completion occurs concurrently
>   with the newly added BLK_MQ_S_SCHED_RESTART test in the blk-mq core.

This patch only moves the blk_mq_delay_run_hw_queue() from scsi_queue_rq()
to blk-mq, again, please explain it in detail how this patch V3 introduces this
regression on SCSI.

Actually this patch should fix a race on SCSI-MQ, because when scsi_queue_rq()
call blk_mq_delay_run_hw_queue(), the request isn't in dispatch list yet, so in
theory this request may not be visible when __blk_mq_run_hw_queue() is run. Don't
expect the 3ms delay will cover that, it is absolutely fragile to depend on timing
to deal with the race.

Maybe it can be one LSF/MM topic proposal...

thanks,
Ming
