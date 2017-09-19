From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 06:44:16 +0800
Message-ID: <20170919224410.GA21829@ming.t460p>
References: <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
 <20170919054308.GA2517@ming.t460p>
 <1505835394.2671.18.camel@wdc.com>
 <20170919155603.GB22809@redhat.com>
 <20170919160401.GC19830@ming.t460p>
 <1505839754.2671.42.camel@wdc.com>
 <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
 <1505846549.2671.52.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505846549.2671.52.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 06:42:30PM +0000, Bart Van Assche wrote:
> On Wed, 2017-09-20 at 00:55 +0800, Ming Lei wrote:
> > On Wed, Sep 20, 2017 at 12:49 AM, Bart Van Assche
> > <Bart.VanAssche@wdc.com> wrote:
> > > On Wed, 2017-09-20 at 00:04 +0800, Ming Lei wrote:
> > > > Run queue at end_io is definitely wrong, because blk-mq has SCHED_RESTART
> > > > to do that already.
> > > 
> > > Sorry but I disagree. If SCHED_RESTART is set that causes the blk-mq core to
> > > reexamine the software queues and the hctx dispatch list but not the requeue
> > > list. If a block driver returns BLK_STS_RESOURCE then requests end up on the
> > > requeue list. Hence the following code in scsi_end_request():
> > 
> > That doesn't need SCHED_RESTART, because it is requeue's
> > responsibility to do that,
> > see blk_mq_requeue_work(), which will run hw queue at the end of this func.
> 
> That's not what I was trying to explain. What I was trying to explain is that
> every block driver that can cause a request to end up on the requeue list is
> responsible for kicking the requeue list at a later time. Hence the
> kblockd_schedule_work(&sdev->requeue_work) call in the SCSI core and the
> blk_mq_kick_requeue_list() and blk_mq_delay_kick_requeue_list() calls in the
> dm code. What I would like to see is measurement results for dm-mpath without
> this patch series and a call to kick the requeue list added to the dm-mpath
> end_io code.

For this issue, it isn't same between SCSI and dm-rq.

We don't need to run queue in .end_io of dm, and the theory is
simple, otherwise it isn't performance issue, and should be I/O hang.

1) every dm-rq's request is 1:1 mapped to SCSI's request

2) if there is any mapped SCSI request not finished, either
in-flight or in requeue list or whatever, there will be one
corresponding dm-rq's request in-flight

3) once the mapped SCSI request is completed, dm-rq's completion
path will be triggered and dm-rq's queue will be rerun because of
SCHED_RESTART in dm-rq

So the hw queue of dm-rq has been run in dm-rq's completion path
already, right? Why do we need to do it again in the hot path?

-- 
Ming
