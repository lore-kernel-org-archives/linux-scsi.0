From: Luben Tuikov <luben@splentec.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 20:43:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DACB63A.B748A97@splentec.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <3DAC7A05.31B17A39@splentec.com> <20021015142733.A2611@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9G0hcf29068
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 20:43:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> 
> I'm saying don't set the queue depth really high when it gives no or
> very little performance gain. If an adapter driver finds that a large
> queue depth helps more than it hurts for all IO loads (for sequential
> as well as random IO), go ahead, but I would guess that queue depths over
> 100 give zero or very little performance gain compared to a queue depth
> of say 50 for most devices. I was trying to run some tests on this
> in the past but never had time to get it working well, plus it would have
> been for only two different devices (disk and disk array), and the
> drives I have are not really fast (20 mb/sec for disk, about 50mb/sec for
> the disk array).

Ok, this may work, now and here, but then and there it doesn't have to.

Predicting on a number, say 100, is speculation at best. What if the
initiator is connected to fiber which is connected to another, etc.
And what if /dev/sda is an iSCSI initiator, connected to a bunch of
targets, which are arrays on another fiber...

You see, 100 means nothing anymore. That is sending 200 tagged commands
will NOT go to the same ``device''... (your imagination here)

The SCSI LLDD, being the gate to the interconnect/transport, knows best,
and has at its disposal features/abilities not easily exportable to ULP/userland.
Thus, it has the ability to at least hint at some number, being the
device queue depth.
 
> What is really needed are IO performance numbers for varying queue depths.

Yep, this is what you give your boss... (Essay topic for next Thursday :-))

But tomorrow, someone has decided to just change one little iota in the code
and those same numbers are out the window (just as has recently happened).
That is, this wouldn't work here.

Those numbers would of course depend on each subsystem getting it ``right'',
and the dependent variables become too many.

Thus, in my experience (and it is my opinion) it is best to approach matters
like this from an academic/reasearch point of view -- that is, we are speaking
of a _general_ architecture, and not of a few empirical tests, hinting at 10 five line
patches.
 
> With 2.5, the number of commands outstanding to the device is not
> subtracted from the blk request queue size (we don't release a blk request
> until the IO is completed, there is no call to blkdev_release_request in
> scsi_request_fn) - this means large queue depths will cause the blk request
> queue to fill up and even be full without any available blk request queue
> commands to merge or sort with.

Yes, ok, so we are involving the block layer, which can/should/may change
tomorrow BUT the SCSI core should/may not have to -- this would mean
that it's doing a great job. (cont'd below)

> There are also issues like Andrew had with the read latency - although
> his benchmark is aritificial, and has more to do with too many dirty
> pages, it still showed that higher queue depths can have an impact
> on interactive performance (i.e. read latencies).

Right! Meaning that the issue is/was elsewhere all along.

So if we involve the block layer too much, and tomorrow someone finds out
something was broken there, we SHOULD NOT HAVE TO change the SCSI core.
This would mean a fairly independent implementation (being a subsystem),
which implies general structrure, which implies research.

While it is good to look at who's below us and above us (SCSI core),
depending too much on their particulars is not generally a good investment.

((All this of course implies that SCSI Core would be quite minimal.))

-- 
Luben
