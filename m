From: Christoph Hellwig <hch@infradead.org>
Subject: Proposal for a scalable SCSI midlayer
Date: Wed, 5 Feb 2014 04:39:18 -0800
Message-ID: <20140205123918.GA15907@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBEMj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:39:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

We've run into many issues where the SCSI layer simply does not scale to
keep up with today's hardware, be that in simple single-thread IOPs, or
in lock contention when using multiple LUNs or targets under a single
SCSI host.  This proposal tries to draw a path how to fix this properly
and avoids workarounds where various driver that speak a SCSI command
set are implemented at the block layer because of these issues.

After the dramatic improvements that the scsi-mq prototype from
Nic Bellinger showed it is clear that using the block multiqueue
infrastructure will take a big role in this effort, but it goes much
further than that code base.

As an important goal of this project I want to replace the whole I/O
path in the SCSI midlayer, and not create largely parallel code paths
for small and fast devices.  We will have to find if this is actually
feasible for all cases, but I'd like to get an as broad as possible set
of drivers to use the new I/O path, and avoid API differences if we have
to keep the two paths around.

A specific non-goal is support for multiple hardware queues.  While
we will have to support this soon, the improvements from just using the
blk-mq code and fixing the obvious scalability issues in the SCSI midlayer
are larger enough to deal with this as a first step, and postpone problems
related to queue synchronization into the near future.


1) Summary of the scalability issues

The biggest problem in the current SCSI midlayer is the old block layer
request model in general, with it's large amount of lock round trips on
the queue_lock for every request, and a large amount of touched cache lines.

The way the old request code is used by the SCSI midlayer makes this even
worse by using the queue_lock to protect additional internal state, and
round tripping on a host-wide lock multiple times for each command.

Even when avoiding the host lock by replacing it with atomic counters we'd
run into multiple host or target-wide shared cache lines for each I/O
submission or completion.


2) Suggested way forward

I would suggest to attack the problems from two sides:

a) fixing the easy to hit scalability issues in the SCSI layer where we
   can, even if they are overshadowed by the block layer ones in small
   patch sets.

b) gradually moving the whole SCSI layer to be backed by blk-mq.  This
   is a different approach from Nic's current scsi-mq tree, in that it
   keeps all the per-device/target/shost accounting and fairness code in
   the SCSI midlayer in place for now, and uses the same APIs to talk
   to the LLDDs.  While this is certain to get less stellar results than
   a hard cut, it will allow to do a full move to the new infrastructure
   much easier, and avoid long term maintenance of parallel code paths.
   Additional optimization can and should be implemented on top of this
   baselines work.

3) Current status

I will send the first batch of patches implementing easy optimizations
in the SCSI midlayer after this RFC, as well as a very early prototype
of the blk-mq work based on that, as well as performance numbers.  We'll
need to work from there to improve it to be generally usable, mostly by
adding missing features to the blk-mq core.

4) Major TODO items

 - add support for partial completions, as the SCSI drivers might
   complete only part of a request for a given I/O completion.

 - either make the blk-mq tag allocator usable on a per-host basis for
   those drivers that currently use host-wide tagging, or find a way
   that they can use their own per-host tagging without getting into the
   way of blk-mq.

 - implement BIDI support in blk-mq.  This is currently missing entirely
   and will be needed to support the OSD2 protocol, as well as a few
   SBC commands through sg_io.

 - fix the tag allocation for sequenced FLUSH commands.

