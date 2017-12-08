From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Fri, 8 Dec 2017 08:50:30 +0800
Message-ID: <20171208005024.GB21488@ming.t460p>
References: <20171205075256.10319-1-ming.lei@redhat.com>
 <1512490099.2660.6.camel@sandisk.com>
 <20171205162825.GA23788@ming.t460p>
 <1512680817.2624.29.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512680817.2624.29.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 07, 2017 at 09:06:58PM +0000, Bart Van Assche wrote:
> On Wed, 2017-12-06 at 00:28 +0800, Ming Lei wrote:
> > On Tue, Dec 05, 2017 at 04:08:20PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-12-05 at 15:52 +0800, Ming Lei wrote:
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index db9556662e27..1816dd8259b3 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -1967,6 +1967,8 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
> > > >  out_put_device:
> > > >  	put_device(&sdev->sdev_gendev);
> > > >  out:
> > > > +	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
> > > > +		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> > > >  	return false;
> > > >  }
> > > 
> > > This cannot work since multiple threads can call scsi_mq_get_budget()
> > 
> > That is exactly the way we are handling these cases before 0df21c86bdbf(scsi:
> > implement .get_budget and .put_budget for blk-mq), so if it can't work,
> > that is not fault of commit 0df21c86bdbf.
> > 
> > > concurrently and hence it can happen that none of them sees
> > > atomic_read(&sdev->device_busy) == 0. BTW, the above patch is something I
> > 
> > If there is concurrent .get_budget(), one of them will see the counter
> > becoming zero finally because each sdev->device_busy is inc/dec
> > atomically. Or scsi_dev_queue_ready() return true.
> > 
> > Anyway, we need this patch to avoid possible regression. If you think
> > there are bugs in blk-mq RESTART, just root cause and and fix it.
> 
> Hello Ming,
> 
> When I looked at the patch at the start of this thread for the first time I
> got frustrated because I didn't see how this patch could fix the queue stall
> I ran into myself. Today I started realizing that what Holger reported is
> probably another issue than what I ran into myself. Since this patch by
> itself looks now useful to me:
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Hi Bart,

Thanks for your Review!

> 
> BTW, do you think the patch at the start of this thread also fixes the issue
> that resulted in commit 826a70a08b12 ("SCSI: don't get target/host busy_count
> in scsi_mq_get_budget()")? Do you think we still need that patch?

Yeah, once the patch in this thread is in, IO hang shouldn't happen any more
even without 826a70a08b12.

But that commit is still the correct thing to do, since we let blk-mq's sbitmap
queue respect per-host queue depth, which way is much efficient than the
simple atomic operations used in scsi_host_queue_ready(). So I think that commit
is still useful.

When I was figuring out patch of 826a70a08b12, I just ignore the .get_budget() for
requests from hctx->dispatch_list, because we don't need to deal with queue idle
when .get_budget() is called from both blk_mq_do_dispatch_sched() and blk_mq_do_dispatch_ctx().

Thanks,
Ming
