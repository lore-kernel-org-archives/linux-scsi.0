From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] Revert "block: remove artifical max_hw_sectors cap"
Date: Thu, 30 Jul 2015 10:03:34 -0400
Message-ID: <x49oaitivyh.fsf@segfault.boston.devel.redhat.com>
References: <x49bnf6y443.fsf@segfault.boston.devel.redhat.com>
	<20150721130246.GA28676@infradead.org>
	<x49k2tihpnr.fsf@segfault.boston.devel.redhat.com>
	<94D0CD8314A33A4D9D801C0FE68B40295AA1726B@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295AA1726B@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Thu, 30 Jul 2015 00:25:28 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

"Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:

>> Christoph, did you have some hardware where a higher max_sectors_kb
>> improved performance?
>
> I don't still have performance numbers, but the old default of 
> 512 KiB was interfering with building large writes that RAID
> controllers can treat as full stripe writes (avoiding the need
> to read the old parity).

Too bad you don't still have data.  Does this mean you never posted the
data to the list?  What type of performance gains were there?  1%? 5%?
100%?

> The patch let 1 MiB IOs flow through the stack, which is a better fit
> for modern strip sizes than 512 KiB.

I agree in principle.  I'd love to see the numbers to back it up,
though.  And, keep in mind that the patch in question doesn't bump the
limit to 1MB.  It bumps it up to max_hw_sectors_kb, which is 32767 on
the hardware I tested.  I wouldn't be against raising the limit to 1MB,
or even 1280k to accommodate entire RAID stripe writes/reads.  The
numbers I posted didn't really seem to regress until I/Os got larger
than 1MB (though I didn't test anything between 1MB and 2MB).

> Software using large IOs must be prepared for long latencies in
> exchange for the potential bandwidth gains, and must use a low (but
> greater than 1) queue depth to keep the IOs flowing back-to-back.

> Are you finding real software generating such IOs but relying on the
> storage stack to break them up for decent performance?

As I stated at the beginning of this thread, the regression was reported
when running iozone.  I would be surprised, however, if there were no
real workloads that issued streaming I/Os through the page cache.
Writeback performance matters.  If you don't believe me, I'll CC Dave
Chinner, and he'll bore you into submission with details and data.

> Your fio script is using the sync IO engine, which means no queuing.
> This forces a turnaround time between IOs, preventing the device from
> looking ahead to see what's next (for sequential IOs, probably
> continuing data transfers with minimal delay).

I used the sync I/O engine with direct=1 because I was trying to
highlight the problem.  If I used direct=0, then we would get a lot of
caching, and even larger I/Os would be sent down, and I wouldn't be able
to tell whether 1M, 2M or 4M I/Os regressed.

> If the storage stack breaks up large sync IOs, the drive might be
> better at detecting that the access pattern is sequential (e.g., the
> gaps are between every set of 2 IOs rather than every IO).  This is
> very drive-specific.

Of course it's drive-specific!  I just showed you four drives, and only
two regressed.  The point I'm making is that I can't find a single
device that performs better.  Even the HP enterprise storage arrays
perform worse in this configuration.  But, by all means, PROVE ME
WRONG.  It' simple.  I showed you how, all you have to do is run the
tests and report the data.

> If we have to go back to that artificial limit, then modern drivers
> (e.g., blk-mq capable drivers) need a way to raise the default;
> relying on users to change the sysfs settings means they're usually
> not changed.

Do we?  I don't think anyone has shown the real need for this.  And it's
dead simple to show the need, which is the frustrating part.  Run your
favorite workload on your favorite storage with two different values of
max_sectors_kb.  Enough with the hand-waving, show me the data!

Cheers,
Jeff
