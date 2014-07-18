From: Christoph Hellwig <hch@lst.de>
Subject: scsi-mq V4
Date: Fri, 18 Jul 2014 12:12:59 +0200
Message-ID: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

At this point the code is ready for merging and use by developers and early
adopters.  Except for the newly added first patch all have been thru multiple
review cycles and I would like to merge the series early next week assuming
I can get reviews for this.  Please scream loud if you see any reason not
to merge it now.

The core blk-mq code isn't that suitable for slow devices
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

Changes from V3:
 - micro optimize the scsi_*_queue_ready functions (Webb Scales)
 - reverted an uninited but harmless transformation in
   scsi_host_queue_ready (Reported by Webb Scales)
 - remove a superflous cancel_delayed_work (Reported by Mike Christie)
 - fix for error handling during failed host initialization
   (Reported by Robert Elliot)

Changes from V2:
 - rebased on top of the I/O path cleanups

Changes from V1:
 - rebased on top of the core-for-3.17 branch, most notable the
   scsi logging changes
 - fixed handling of cmd_list to prevent crashes for some heavy
   workloads
 - fixed incorrect handling of !target->can_queue
 - avoid scheduling a workqueue on I/O completions when no queues
   are congested

In addition to the patches in this thread there also is a git available at:

	git://git.infradead.org/users/hch/scsi.git scsi-mq.4

This work was sponsored by the ION division of Fusion IO.
