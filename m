From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 00:07:38 +0800
Message-ID: <20170919160737.GD19830@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
 <20170919054308.GA2517@ming.t460p>
 <20170919154823.GA22809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919154823.GA22809@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 11:48:23AM -0400, Mike Snitzer wrote:
> On Tue, Sep 19 2017 at  1:43am -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Mon, Sep 18, 2017 at 03:18:16PM +0000, Bart Van Assche wrote:
> > > On Sun, 2017-09-17 at 20:40 +0800, Ming Lei wrote:
> > > > "if no request has completed before the delay has expired" can't be a
> > > > reason to rerun the queue, because the queue can still be busy.
> > > 
> > > That statement of you shows that there are important aspects of the SCSI
> > > core and dm-mpath driver that you don't understand.
> > 
> > Then can you tell me why blk-mq's SCHED_RESTART can't cover
> > the rerun when there are in-flight requests? What is the case
> > in which dm-rq can return BUSY and there aren't any in-flight
> > requests meantime?
> > 
> > Also you are the author of adding 'blk_mq_delay_run_hw_queue(
> > hctx, 100/*ms*/)' in dm-rq, you never explain in commit
> > 6077c2d706097c0(dm rq: Avoid that request processing stalls
> > sporadically) what the root cause is for your request stall
> > and why this patch fixes your issue. Even you don't explain
> > why is the delay 100ms?
> > 
> > So it is a workaound, isn't it?
> > 
> > My concern is that it isn't good to add blk_mq_delay_run_hw_queue(hctx, 100/*ms*/)
> > in the hot path since it should been covered by SCHED_RESTART
> > if there are in-flight requests.
> 
> This thread proves that it is definitely brittle to be relying on fixed
> delays like this:
> https://patchwork.kernel.org/patch/9703249/

I can't agree more, because no one mentioned the root cause, maybe the
request stall has been fixed recently. Keeping the workaound in hotpath
is a bit annoying.

-- 
Ming
