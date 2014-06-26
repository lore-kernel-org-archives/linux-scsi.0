From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq V2
Date: Wed, 25 Jun 2014 22:50:44 -0600
Message-ID: <53ABA6A4.8090400@kernel.dk>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2014-06-25 10:51, Christoph Hellwig wrote:
> This is the second post of the scsi-mq series.
>
> At this point the code is ready for merging and use by developers and early
> adopters.  The core blk-mq code isn't that suitable for slow devices
> yet, mostly due to the lack of an I/O scheduler, but Jens is working on it.
> Similarly there is no dm-multipath support for drivers using blk-mq yet,
> but I'm working on it.  It should also be noted that the code doesn't
> actually support multiple hardware queues or fine grained tuning of the
> blk-mq parameters yet.  All these could be added fairly easily as soon
> as low-level drivers want to make use of them.
>
> The amount of chances to the existing code are fairly small, and mostly
> speedups or cleanups that also apply to the old path as well.  Because
> of this I also haven't bothered to put it under a config option, just
> like the blk-mq core.
>
> The usage of blk-mq dramatically decreases CPU usage under all workloads going
> down from 100% CPU usage that the old setup can hit easily to usually less
> than 20% for maxing out storage subsystems with 512byte reads and writes,
> and it allows to easily archive millions of IOPS.  Bart and Robert have
> helped with some very detailed measurements that they might be able to send
> in reply to this, although these usually involve significantly reworked low
> level drivers to avoid other bottle necks.
>
> One major objection to previous iterations of this code was the simple
> replacement of the host_lock with atomic counters for the host and busy
> counters.  The host_lock avoidance on it's own already improves performance,
> and with the patch to avoid maintaining the per-target busy counter unless
> needed we now replace a lock round trip on the host_lock with just a single
> atomic increment in the submission path, and a single atomic decrement in
> completion path, which should provide benefits even for the oddest RISC
> architecture.  Longer term I'd still love to get rid of these entirely
> and use the counters in blk-mq, but due to the difference in how they
> are maintained this doesn't seem feasible as long as we still need to
> support the legacy request code path.
>
> Changes from V1:
>   - rebased on top of the core-for-3.17 branch, most notable the
>     scsi logging changes
>   - fixed handling of cmd_list to prevent crashes for some heavy
>     workloads
>   - fixed incorrect handling of !target->can_queue
>   - avoid scheduling a workqueue on I/O completions when no queues
>     are congested
>
> In addition to the patches in this thread there also is a git available at:
>
> 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2

You can add my acked/reviewed-by to the series.

-- 
Jens Axboe
