From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in
 scsi_dev_queue_ready()
Date: Tue, 5 Dec 2017 14:56:42 +0800
Message-ID: <20171205065641.GC9989@ming.t460p>
References: <20171202163150.1273-1-ming.lei@redhat.com>
 <1512400159.23838.1.camel@wdc.com>
 <20171204224507.GB6888@ming.t460p>
 <pan$2c3c7$7c7c04a5$f22df3ad$bef841cb@applied-asynchrony.com>
 <20171205051624.GB9989@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205051624.GB9989@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 01:16:24PM +0800, Ming Lei wrote:
> On Mon, Dec 04, 2017 at 11:48:07PM +0000, Holger Hoffstätte wrote:
> > On Tue, 05 Dec 2017 06:45:08 +0800, Ming Lei wrote:
> > 
> > > On Mon, Dec 04, 2017 at 03:09:20PM +0000, Bart Van Assche wrote:
> > >> On Sun, 2017-12-03 at 00:31 +0800, Ming Lei wrote:
> > >> > Fixes: 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
> > >> 
> > >> It might be safer to revert commit 0df21c86bdbf instead of trying to fix all
> > >> issues introduced by that commit for kernel version v4.15 ...
> > > 
> > > What are all issues in v4.15-rc? Up to now, it is the only issue reported,
> > > and can be fixed by this simple patch, which one can be thought as cleanup
> > > too.
> > 
> > Even with this patch I've encountered at least one hang that
> > seemed related. I'm using most of block/scsi-4.15 on top of 4.14 and
> > the hang in question was on a rotating disk. It could be solved by activating
> > a different scheduler on the hanging device; all hanging sync/df processes got
> > unstuck and all was fine again, which leads me to believe that there is at least
> > one more rare condition where delaying requests (as done in the budget patch)
> > leads to a hang.
> > 
> > This happened with mq-deadline which I was testing specifically to avoid
> > any BFQ-related side effects.
> 
> OK, this looks a new report.
> 
> Without any log, we can't make any progress, and even we can't guess
> what the issue is related with.
> 
> Could you post your dmesg log(include the hang process stack trace)? And
> dump the debugfs log by the following script when this hang happens?
> 
> 	http://people.redhat.com/minlei/tests/tools/dump-blk-info
> 
> BTW, you just need to pass the disk name to the script, such as: /dev/sda.

Thinking of the issue further, this patch only covers case of
scsi_set_blocked(), but don't consider the case in which .get_budget()
is called inside blk_mq_dispatch_rq_list() for request coming from
hctx->dispatch_list.

If .get_budget() is called in both blk_mq_do_dispatch_sched() and
blk_mq_do_dispatch_ctx(), we don't need to run queue if the queue
is idle. But if it is called from blk_mq_dispatch_rq_list() for request
coming from hctx->dispatch_list, we have to run queue if queue is
idle, as before.

So please ignore this patch, and will submit V2 for cover both cases.

Thanks,
Ming
