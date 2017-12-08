From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Fri, 8 Dec 2017 08:36:38 +0800
Message-ID: <20171208003637.GA21488@ming.t460p>
References: <20171205075256.10319-1-ming.lei@redhat.com>
 <1512490099.2660.6.camel@sandisk.com>
 <20171205162825.GA23788@ming.t460p>
 <20171206015212.GB26512@ming.t460p>
 <1512576435.3297.3.camel@wdc.com>
 <20171207013122.GA10214@ming.t460p>
 <1512681113.2624.33.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512681113.2624.33.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 07, 2017 at 09:11:54PM +0000, Bart Van Assche wrote:
> On Thu, 2017-12-07 at 09:31 +0800, Ming Lei wrote:
> > But if you always call blk_mq_sched_mark_restart_hctx() before a new
> > dispatch, that may affect performance on NVMe which may never trigger
> > BLK_STS_RESOURCE.
> 
> Hmm ... only the SCSI core implements .get_budget() and .put_budget() and
> I proposed to insert a blk_mq_sched_mark_restart_hctx() call under "if
> (q->mq_ops->get_budget)". In other words, I proposed to insert a
> blk_mq_sched_mark_restart_hctx() call in a code path that is never triggered
> by the NVMe driver. So I don't see how the change I proposed could affect
> the performance of the NVMe driver?

You only add the check on none scheduler, right?

But this race isn't related with scheduler, that means it can't fix the
race with other schedulers.

I have test case to trigger this issue on both none and mq-deadline, and
my patch fixes them all.

Thanks,
Ming
