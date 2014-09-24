From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.18/core] blk-mq: start q->mq_usage_counter in
 atomic mode
Date: Wed, 24 Sep 2014 13:33:52 -0400
Message-ID: <20140924173352.GC29067@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <20140923060812.GH11740@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140923060812.GH11740@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2014 at 02:08:12AM -0400, Tejun Heo wrote:
> From 83b06f4fc6ca2f7f3d706a168b71c248bdada668 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 23 Sep 2014 01:58:34 -0400
> 
> blk-mq uses percpu_ref for its usage counter which tracks the number
> of in-flight commands and used to synchronously drain the queue on
> freeze.  percpu_ref shutdown takes measureable wallclock time as it
> involves a sched RCU grace period.  This means that draining a blk-mq
> takes measureable wallclock time.  One would think that this shouldn't
> matter as queue shutdown should be a rare event which takes place
> asynchronously w.r.t. userland.

Applied to percpu/for-3.18 on top of the klude, its revert and the
required percpu_ref changes.

Thanks.

-- 
tejun
