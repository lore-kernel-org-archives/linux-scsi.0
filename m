From: Patrick Mansfield <patmans@us.ibm.com>
Subject: scsi per-device lock [was Re: [RFC][PATCH] ... ]
Date: Thu, 6 Mar 2003 11:40:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306114010.A24155@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 06, 2003 at 12:04:04PM -0600, James Bottomley wrote:
> On Thu, 2003-03-06 at 11:41, Patrick Mansfield wrote:
> > Such a solution complicates moving to a per-device queue lock - we need a
> > per-host lock while pulling off the restart list, and we need a
> > per-queue-lock prior to calling __blk_run_queue(); but when starving in
> > the scsi_request_fn(), we have a per-queue-lock and need the per-host lock
> > to add to the restart list. So we have to allow dropping a lock in both
> > cases without leading to a hung requeset queue.
> 
> Actually, I don't think it does. Any driver that can truly have a per
> device lock can't have a fixed size pool of resources that device
> requests are competing for (otherwise it would need a host lock to
> access these resources), thus can_queue should always be set to a number
> much greater than the aggregate of the local device queue depths (we'd
> need a comment in the code to this effect).

I don't quite follow the above - you mean a per device lock in the actual
LLDD probably has no benefit? Yes, I agree with that.

But we do not need the host_lock while processing the request queue, or
modifying scsi_device values. Holding the host_lock in such cases not only
prevents IO from completing (i.e. host_busy decrement), but also blocks
other disks on the same adapter from prepping a request, allocating a
scsi_cmnd or checking scsi_device limits.

An LLDD that uses host_lock to protect scsi_device or its request queue is
doing something wrong (it can reference invariant fields of scsi_device
such as host/chan/id/lun without a lock, and generally it can reference
scsi_cmnd fields without a lock).

> Do we actually have any LLDs in the tree today that can benefit from a
> device based locking approach?  (i.e. they must manage their resource
> pools on a device basis and also have a mailbox scheme that doesn't
> require host based locking).
> 
> James

I'm not proposing changing the LLDD's to use a per-device lock, rather
that scsi-core use a per device lock to protect the request queue and the
scsi_device. The scsi core would still use the host_lock to protect
scsi_host and LLDD calls (the silly lock/call/unlock sequences).

Do you see any major problems with this approach?

I have a lock split patch, built on top of the previous pending_cmd queue
patch; it still needs code to handle the single_lun case, and it has a
lock hierarchy. I can post it as-is but it is still in progress, and I
(now) have to change the pending_cmd to instead be a queue of starved
request queues.

I ran with and without the lock split on a 4 processor NUMAQ with 10
drives on a single qla 2300 adapter using the feral driver. I also ran
some tests on the same system NUMAQ with 8 procs and about 39 drives.

I used a simple program to try and maximize IOs/second - it uses O_DIRECT
and rereads the first 512 bytes of the disk. One of these is run per disk
for a fixed number of IO's.

The 4x with 10 drives, each drive rereading 20000 times using the
current code gave (don't know how it got 103%):

0.51user 21.21system 0:21.08elapsed 103%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6670major+2705minor)pagefaults 0swaps

Top oprofile users (low to high):

c0168180 1156     1.10736     dio_await_one
c0180105 1365     1.30757     .text.lock.inode
c01e0ab0 1512     1.44839     scsi_dispatch_cmd
c0115cb0 1545     1.48        try_to_wake_up
c01164c0 1621     1.5528      load_balance
c01e7087 1772     1.69745     .text.lock.scsi_lib
c0151cc9 3380     3.2378      .text.lock.block_dev
c0116d20 3491     3.34413     schedule
c01e1cf5 4148     3.97348     .text.lock.scsi
c01cb945 7584     7.26492     .text.lock.ll_rw_blk
c0107010 25712    24.6302     default_idle

With the lock split the same test gave:

0.43user 14.33system 0:20.55elapsed 71%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (6670major+2705minor)pagefaults 0swaps

Top oprofile users (low to high):

c01077a0 880      1.02679     __switch_to
c0180105 888      1.03612     .text.lock.inode
c01896b0 894      1.04313     start_this_handle
c01e6cc0 912      1.06413     scsi_check_shost
c01e07f0 965      1.12597     scsi_get_command
c0168180 1106     1.29049     dio_await_one
c0115cb0 1483     1.73037     try_to_wake_up
c01164c0 1489     1.73738     load_balance
c0151cc9 2706     3.15738     .text.lock.block_dev
c0116d20 3470     4.04882     schedule
c0107010 24072    28.0874     default_idle

Even though elapsed times were nearly equal with and without the lock
split, system time went from 21 to 14 seconds, a fairly significant drop
for this super-micro-mini benchmark.

I don't have the 8x numbers with 39 drives available, but the *elapsed*
time went from about 60 seconds to about 40 seconds.

Any suggestions for a simple multiple-disk benchmark?

-- Patrick Mansfield
