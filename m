From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 09:19:26 +0800
Message-ID: <20170920011925.GB23062@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
 <20170919054308.GA2517@ming.t460p>
 <1505835394.2671.18.camel@wdc.com>
 <20170919155603.GB22809@redhat.com>
 <20170919160401.GC19830@ming.t460p>
 <1505839754.2671.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505839754.2671.42.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 04:49:15PM +0000, Bart Van Assche wrote:
> On Wed, 2017-09-20 at 00:04 +0800, Ming Lei wrote:
> > Run queue at end_io is definitely wrong, because blk-mq has SCHED_RESTART
> > to do that already.
> 
> Sorry but I disagree. If SCHED_RESTART is set that causes the blk-mq core to
> reexamine the software queues and the hctx dispatch list but not the requeue
> list. If a block driver returns BLK_STS_RESOURCE then requests end up on the
> requeue list. Hence the following code in scsi_end_request():
> 
> 	if (scsi_target(sdev)->single_lun || !list_empty(&sdev->host->starved_list))
> 		kblockd_schedule_work(&sdev->requeue_work);
> 	else
> 		blk_mq_run_hw_queues(q, true);

Let's focus on dm-rq.

I have explained before, dm-rq is different with SCSI's, we don't need
to requeue request any more in dm-rq if blk_get_request() returns NULL
in multipath_clone_and_map(), since SCHED_RESTART can cover that
definitely.

Not mention dm_mq_delay_requeue_request() will run the queue explicitly
if it has to be done. That needn't SCHED_RESTART to cover, right?

-- 
Ming
