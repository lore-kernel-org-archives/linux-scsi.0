From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V6 4/5] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 12 Oct 2017 18:01:08 +0800
Message-ID: <20171012100107.GA28224@ming.t460p>
References: <20171009112424.30524-1-ming.lei@redhat.com>
 <20171009112424.30524-5-ming.lei@redhat.com>
 <20171010182345.GD30738@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010182345.GD30738@vader.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2017 at 11:23:45AM -0700, Omar Sandoval wrote:
> On Mon, Oct 09, 2017 at 07:24:23PM +0800, Ming Lei wrote:
> > SCSI devices use host-wide tagset, and the shared driver tag space is
> > often quite big. Meantime there is also queue depth for each lun(
> > .cmd_per_lun), which is often small, for example, on both lpfc and
> > qla2xxx, .cmd_per_lun is just 3.
> > 
> > So lots of requests may stay in sw queue, and we always flush all
> > belonging to same hw queue and dispatch them all to driver, unfortunately
> > it is easy to cause queue busy because of the small .cmd_per_lun.
> > Once these requests are flushed out, they have to stay in hctx->dispatch,
> > and no bio merge can participate into these requests, and sequential IO
> > performance is hurt a lot.
> > 
> > This patch introduces blk_mq_dequeue_from_ctx for dequeuing request from
> > sw queue so that we can dispatch them in scheduler's way, then we can
> > avoid to dequeue too many requests from sw queue when ->dispatch isn't
> > flushed completely.
> > 
> > This patch improves dispatching from sw queue when there is per-request-queue
> > queue depth by taking request one by one from sw queue, just like the way
> > of IO scheduler.
> 
> This still didn't address Jens' concern about using q->queue_depth as
> the heuristic for whether to do the full sw queue flush or one-by-one
> dispatch. The EWMA approach is a bit too complex for now, can you please
> try the heuristic of whether the driver ever returned BLK_STS_RESOURCE?

That can be done easily, but I am not sure if it is good.

For example, inside queue rq path of NVMe, kmalloc(GFP_ATOMIC) is
often used, if kmalloc() returns NULL just once, BLK_STS_RESOURCE
will be returned to blk-mq, then blk-mq will never do full sw
queue flush even when kmalloc() always succeed from that time
on.

Even EWMA approach isn't good on SCSI-MQ too, because
some SCSI's .cmd_per_lun is very small, such as 3 on
lpfc and qla2xxx, and one full flush will trigger
BLK_STS_RESOURCE easily.

So I suggest to use the way of q->queue_depth first, since we
don't get performance degrade report on other devices(!q->queue_depth)
with blk-mq. We can improve this way in the future if we
have better approach.

What do you think about it?


-- 
Ming
