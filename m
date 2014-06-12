From: Christoph Hellwig <hch@lst.de>
Subject: scsi-mq
Date: Thu, 12 Jun 2014 15:48:52 +0200
Message-ID: <1402580946-11470-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With all the required blk-mq work, and the previous set of scsi midlayer
updates in Linus' tree this is the time for the first format scsi-mq
submission.

At this point the code is ready for merging and use by developers and early
adopters.  The core blk-mq code isn't that suitable for slow devices
yet, mostly due to the lack of an I/O scheduler, but Jens is working on it.
Similarly there is no dm-multipath support for drivers using blk-mq yet,
but I'm working on it.  It should also be noted that the code doesn't
actually support multiple hardware queues or fine grained tuning of the
blk-mq parameters yet.  All these could be added fairly easily as soon
as low-level drivers want to make use of them.

The amount of chances to the existing code are fairly small, and mostly
speedups or cleanups that also apply to the old path as well.  Because
of this I also haven't bothered to put it under a config option, just
like the blk-mq core.

The usage of blk-mq dramatically decreases CPU usage under all workloads going
down from 100% CPU usage that the old setup can hit easily to usually less
than 20% for maxing out storage subsystems with 512byte reads and writes,
and it allows to easily archive millions of IOPS.  Bart and Robert have
helped with some very detailed measurements that they might be able to send
in reply to this, although these usually involve significantly reworked low
level drivers to avoid other bottle necks.

One major objection to previous iterations of this code was the simple
replacement of the host_lock with atomic counters for the host and busy
counters.  The host_lock avoidance on it's own already improves performance,
and with the patch to avoid maintaining the per-target busy counter unless
needed we now replace a lock round trip on the host_lock with just a single
atomic increment in the submission path, and a single atomic decrement in
completion path, which should provide benefits even for the oddest RISC
architecture.  Longer term I'd still love to get rid of these entirely
and use the counters in blk-mq, but due to the difference in how they
are maintained this doesn't seem feasible as long as we still need to
support the legacy request code path.

In addition to the patches in this thread there also is a git available at:

	git://git.infradead.org/users/hch/scsi.git scsi-mq

This work was sponsored by the ION division of Fusion IO.
