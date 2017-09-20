From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 09:13:53 +0800
Message-ID: <20170920011347.GA23062@ming.t460p>
References: <20170919054308.GA2517@ming.t460p>
 <1505835394.2671.18.camel@wdc.com>
 <20170919155603.GB22809@redhat.com>
 <20170919160401.GC19830@ming.t460p>
 <1505839754.2671.42.camel@wdc.com>
 <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
 <1505846549.2671.52.camel@wdc.com>
 <20170919224410.GA21829@ming.t460p>
 <1505863546.2671.55.camel@wdc.com>
 <20170919235006.GB23864@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170919235006.GB23864@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

On Tue, Sep 19, 2017 at 07:50:06PM -0400, Mike Snitzer wrote:
> On Tue, Sep 19 2017 at  7:25pm -0400,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Wed, 2017-09-20 at 06:44 +0800, Ming Lei wrote:
> > > For this issue, it isn't same between SCSI and dm-rq.
> > > 
> > > We don't need to run queue in .end_io of dm, and the theory is
> > > simple, otherwise it isn't performance issue, and should be I/O hang.
> > > 
> > > 1) every dm-rq's request is 1:1 mapped to SCSI's request
> > > 
> > > 2) if there is any mapped SCSI request not finished, either
> > > in-flight or in requeue list or whatever, there will be one
> > > corresponding dm-rq's request in-flight
> > > 
> > > 3) once the mapped SCSI request is completed, dm-rq's completion
> > > path will be triggered and dm-rq's queue will be rerun because of
> > > SCHED_RESTART in dm-rq
> > > 
> > > So the hw queue of dm-rq has been run in dm-rq's completion path
> > > already, right? Why do we need to do it again in the hot path?
> > 
> > The measurement data in the description of patch 5/5 shows a significant
> > performance regression for an important workload, namely random I/O.
> > Additionally, the performance improvement for sequential I/O was achieved
> > for an unrealistically low queue depth.
> 
> So you've ignored Ming's question entirely and instead decided to focus
> on previous questions you raised to Ming that he ignored.  This is
> getting tedious.

Sorry for not making it clear, I mentioned I will post a new version
to address the random I/O regression.

> 
> Especially given that Ming said the first patch that all this fighting
> has been over isn't even required to attain the improvements.
> 
> Ming, please retest both your baseline and patched setup with a
> queue_depth of >= 32.  Also, please do 3 - 5 runs to get a avg and std
> dev across the runs.

Taking a bigger queue_depth won't be helpful on this issue,
and it can make the situation worse, because .cmd_per_lun won't
be changed, and queue often becomes busy when number of in-flight
requests is bigger than .cmd_per_lun.

I will post one new version, which will use another simple way to
figure out if underlying queue is busy, so that random I/O perf
won't be affected, but this new version need to depend on the
following patchset:

	https://marc.info/?t=150436555700002&r=1&w=2

So it may take a while since that patchset is still under review.

I will post them all together in 'blk-mq-sched: improve SCSI-MQ performance(V5)'.

The approach taken in patch 5 depends on q->queue_depth, but some SCSI
host's .cmd_per_lun is different with q->queue_depth, so causes
the random I/O regression.

-- 
Ming
