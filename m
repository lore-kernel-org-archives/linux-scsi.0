From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 00:04:02 +0800
Message-ID: <20170919160401.GC19830@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
 <20170919054308.GA2517@ming.t460p>
 <1505835394.2671.18.camel@wdc.com>
 <20170919155603.GB22809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919155603.GB22809@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 11:56:03AM -0400, Mike Snitzer wrote:
> On Tue, Sep 19 2017 at 11:36am -0400,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Tue, 2017-09-19 at 13:43 +0800, Ming Lei wrote:
> > > On Mon, Sep 18, 2017 at 03:18:16PM +0000, Bart Van Assche wrote:
> > > > If you are still looking at removing the blk_mq_delay_run_hw_queue() calls
> > > > then I think you are looking in the wrong direction. What kind of problem
> > > > are you trying to solve? Is it perhaps that there can be a delay between
> > > 
> > > Actually the improvement on dm-rq IO schedule(the patch 2 ~ 5) doesn't
> > > need this patch.
> > 
> > The approach of this patch series looks wrong to me and patch 5/5 is an ugly
> > hack in my opinion. That's why I asked you to drop the entire patch series and
> > to test whether inserting a queue run call into the dm-mpath end_io callback
> > yields a similar performance improvement to the patches you posted. Please do
> > not expect me to spend more time on this patch series if you do not come up
> > with measurement results for the proposed alternative.
> 
> Bart, asserting that Ming's work is a hack doesn't help your apparent
> goal of deligitimizing Ming's work.
> 
> Nor does it take away from the fact that your indecision on appropriate
> timeouts (let alone ability to defend and/or explain them) validates
> Ming calling them into question (which you are now dodging regularly).
> 
> But please don't take this feedback and shut-down.  Instead please work
> together more constructively.  This doesn't need to be adversarial!  I
> am at a loss for why there is such animosity from your end Bart.
> 
> Please dial it back.  It is just a distraction that fosters needless
> in-fighting.
> 
> Believe it or not: Ming is just trying to improve the code because he
> has a testbed that is showing fairly abysmal performance with dm-mq
> multipath (on lpfc with scsi-mq).
> 
> Ming, if you can: please see if what Bart has proposed (instead: run
> queue at end_io) helps.  Though I don't yet see why that should be
> needed.

Run queue at end_io is definitely wrong, because blk-mq has SCHED_RESTART
to do that already.

The dm-mpath performance issue is nothing to do with that, actually
the issue is very similar with my improvement on SCSI-MQ, because
now dm_dispatch_clone_request() doesn't know if the underlying
queue is busy or not, and dm-rq/mpath is just trying to dispatch
more request to underlying queue even though it is busy, then IO
merge can't be done easily on dm-rq/mpath.

I am thinking another way to improve this issue, since some
SCSI device's queue_depth is different with .cmd_per_lun,
will post patchset soon.


-- 
Ming
