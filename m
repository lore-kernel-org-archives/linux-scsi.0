From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Wed, 6 Dec 2017 00:28:31 +0800
Message-ID: <20171205162825.GA23788@ming.t460p>
References: <20171205075256.10319-1-ming.lei@redhat.com>
 <1512490099.2660.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512490099.2660.6.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 04:08:20PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 15:52 +0800, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index db9556662e27..1816dd8259b3 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1967,6 +1967,8 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
> >  out_put_device:
> >  	put_device(&sdev->sdev_gendev);
> >  out:
> > +	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
> > +		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> >  	return false;
> >  }
> 
> This cannot work since multiple threads can call scsi_mq_get_budget()

That is exactly the way we are handling these cases before 0df21c86bdbf(scsi:
implement .get_budget and .put_budget for blk-mq), so if it can't work,
that is not fault of commit 0df21c86bdbf.

> concurrently and hence it can happen that none of them sees
> atomic_read(&sdev->device_busy) == 0. BTW, the above patch is something I

If there is concurrent .get_budget(), one of them will see the counter
becoming zero finally because each sdev->device_busy is inc/dec
atomically. Or scsi_dev_queue_ready() return true.

Anyway, we need this patch to avoid possible regression. If you think
there are bugs in blk-mq RESTART, just root cause and and fix it.

> consider as a workaround. Have you considered to fix the root cause and to
> add blk_mq_sched_mark_restart_hctx() where these are missing, e.g. in 
> blk_mq_sched_dispatch_requests()? The patch below is not a full solution
> but resulted in a significant improvement in my tests:
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 69e3226e66ca..9d86876ec503 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -226,6 +226,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
>  		 * TODO: get more budgets, and dequeue more requests in
>  		 * one time.
>  		 */
> +		blk_mq_sched_mark_restart_hctx(hctx);
>  		blk_mq_do_dispatch_ctx(hctx);
>  	} else {
>  		blk_mq_flush_busy_ctxs(hctx, &rq_list);

This is still a workaround for RESTART, see my comment before:

	https://marc.info/?l=linux-block&m=151217500929341&w=2

-- 
Ming
