From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
Date: Tue, 23 Sep 2014 13:29:03 -0600
Message-ID: <5421C9FF.5030903@kernel.dk>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org> <5421968B.7080309@kernel.dk> <20140923192432.GA24441@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140923192432.GA24441@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/23/2014 01:24 PM, Tejun Heo wrote:
> blk-mq uses percpu_ref for its usage counter which tracks the number
> of in-flight commands and used to synchronously drain the queue on
> freeze.  percpu_ref shutdown takes measureable wallclock time as it
> involves a sched RCU grace period.  This means that draining a blk-mq
> takes measureable wallclock time.  One would think that this shouldn't
> matter as queue shutdown should be a rare event which takes place
> asynchronously w.r.t. userland.
> 
> Unfortunately, SCSI probing involves synchronously setting up and then
> tearing down a lot of request_queues back-to-back for non-existent
> LUNs.  This means that SCSI probing may take more than ten seconds
> when scsi-mq is used.
> 
> This will be properly fixed by implementing a mechanism to keep
> q->mq_usage_counter in atomic mode till genhd registration; however,
> that involves rather big updates to percpu_ref which is difficult to
> apply late in the devel cycle (v3.17-rc6 at the moment).  As a
> stop-gap measure till the proper fix can be implemented in the next
> cycle, this patch introduces __percpu_ref_kill_expedited() and makes
> blk_mq_freeze_queue() use it.  This is heavy-handed but should work
> for testing the experimental SCSI blk-mq implementation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Link: http://lkml.kernel.org/g/20140919113815.GA10791@lst.de
> Fixes: add703fda981 ("blk-mq: use percpu_ref for mq usage count")
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
> Hello, Jens, Christoph.
> 
> How about this one?  This is kinda ugly but should work fine in most
> cases and easy to apply to v3.17 and take out during v3.18.

The hack looks fine to me, if it passes Christophs boot stall test. The
hack isn't THAT nasty, since you already have a series queued up to fix
it for real for 3.18.

-- 
Jens Axboe
