From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Thu, 7 Dec 2017 09:31:28 +0800
Message-ID: <20171207013122.GA10214@ming.t460p>
References: <20171205075256.10319-1-ming.lei@redhat.com>
 <1512490099.2660.6.camel@sandisk.com>
 <20171205162825.GA23788@ming.t460p>
 <20171206015212.GB26512@ming.t460p>
 <1512576435.3297.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512576435.3297.3.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 06, 2017 at 04:07:17PM +0000, Bart Van Assche wrote:
> On Wed, 2017-12-06 at 09:52 +0800, Ming Lei wrote:
> > On Wed, Dec 06, 2017 at 12:28:25AM +0800, Ming Lei wrote:
> > > On Tue, Dec 05, 2017 at 04:08:20PM +0000, Bart Van Assche wrote:
> > > > The patch below is not a full solution but resulted in a significant
> > > > improvement in my tests:
> > > > 
> > > > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> > > > index 69e3226e66ca..9d86876ec503 100644
> > > > --- a/block/blk-mq-sched.c
> > > > +++ b/block/blk-mq-sched.c
> > > > @@ -226,6 +226,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
> > > >  		 * TODO: get more budgets, and dequeue more requests in
> > > >  		 * one time.
> > > >  		 */
> > > > +		blk_mq_sched_mark_restart_hctx(hctx);
> > > >  		blk_mq_do_dispatch_ctx(hctx);
> > > >  	} else {
> > > >  		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> > 
> > BTW, this kind of change can't cover scsi_set_blocked() which is
> > triggered by timeout, scsi dispatch failure. You will see that
> > easily if you run the SCSI test script I provided in the commit log.
> 
> Hello Ming,
> 
> I am aware that the above change does not cover all cases. That's why I wrote
> in my previous e-mail that that patch is not a full solution. The reason I
> posted that change anyway is because I prefer a solution that is not based on
> delayed queue runs over a solution that is based on delayed queue runs
> (blk_mq_delay_run_hw_queue()). My concern is that performance of a solution
> based on delayed queue runs will be suboptimal.

Hi,

The patch I posted won't cause any performance regression because it is
only triggered when queue is becoming idle, also that is exact the way for us
to deal with these cases before.

But if you always call blk_mq_sched_mark_restart_hctx() before a new
dispatch, that may affect performance on NVMe which may never trigger
BLK_STS_RESOURCE.

-- 
Ming
