From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V6 4/5] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 12 Oct 2017 23:22:47 +0800
Message-ID: <20171012152240.GA9275@ming.t460p>
References: <20171009112424.30524-1-ming.lei@redhat.com>
 <20171009112424.30524-5-ming.lei@redhat.com>
 <20171010182345.GD30738@vader.DHCP.thefacebook.com>
 <20171012100107.GA28224@ming.t460p>
 <82efff77-6b17-8bd8-e425-c143284ebb07@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82efff77-6b17-8bd8-e425-c143284ebb07@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Omar Sandoval <osandov@osandov.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2017 at 08:52:12AM -0600, Jens Axboe wrote:
> On 10/12/2017 04:01 AM, Ming Lei wrote:
> > On Tue, Oct 10, 2017 at 11:23:45AM -0700, Omar Sandoval wrote:
> >> On Mon, Oct 09, 2017 at 07:24:23PM +0800, Ming Lei wrote:
> >>> SCSI devices use host-wide tagset, and the shared driver tag space is
> >>> often quite big. Meantime there is also queue depth for each lun(
> >>> .cmd_per_lun), which is often small, for example, on both lpfc and
> >>> qla2xxx, .cmd_per_lun is just 3.
> >>>
> >>> So lots of requests may stay in sw queue, and we always flush all
> >>> belonging to same hw queue and dispatch them all to driver, unfortunately
> >>> it is easy to cause queue busy because of the small .cmd_per_lun.
> >>> Once these requests are flushed out, they have to stay in hctx->dispatch,
> >>> and no bio merge can participate into these requests, and sequential IO
> >>> performance is hurt a lot.
> >>>
> >>> This patch introduces blk_mq_dequeue_from_ctx for dequeuing request from
> >>> sw queue so that we can dispatch them in scheduler's way, then we can
> >>> avoid to dequeue too many requests from sw queue when ->dispatch isn't
> >>> flushed completely.
> >>>
> >>> This patch improves dispatching from sw queue when there is per-request-queue
> >>> queue depth by taking request one by one from sw queue, just like the way
> >>> of IO scheduler.
> >>
> >> This still didn't address Jens' concern about using q->queue_depth as
> >> the heuristic for whether to do the full sw queue flush or one-by-one
> >> dispatch. The EWMA approach is a bit too complex for now, can you please
> >> try the heuristic of whether the driver ever returned BLK_STS_RESOURCE?
> > 
> > That can be done easily, but I am not sure if it is good.
> > 
> > For example, inside queue rq path of NVMe, kmalloc(GFP_ATOMIC) is
> > often used, if kmalloc() returns NULL just once, BLK_STS_RESOURCE
> > will be returned to blk-mq, then blk-mq will never do full sw
> > queue flush even when kmalloc() always succeed from that time
> > on.
> 
> Have it be a bit more than a single bit, then. Reset it every x IOs or
> something like that, that'll be more representative of transient busy
> conditions anyway.

OK, that can be done via a simplified EWMA by considering
the dispatch result only.

I will address it in V6.


-- 
Ming
