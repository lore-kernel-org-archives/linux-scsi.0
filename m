From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [patch] Revert "block: remove artifical max_hw_sectors cap"
Date: Thu, 30 Jul 2015 00:25:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295AA1726B@G9W0745.americas.hpqcorp.net>
References: <x49bnf6y443.fsf@segfault.boston.devel.redhat.com>
	<20150721130246.GA28676@infradead.org>
 <x49k2tihpnr.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49k2tihpnr.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jeff Moyer
> Sent: Wednesday, July 29, 2015 11:53 AM
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>; linux-kernel@vger.kernel.org;
> dmilburn@redhat.com

Adding linux-scsi...

> Subject: Re: [patch] Revert "block: remove artifical max_hw_sectors cap"
> 
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Mon, Jul 20, 2015 at 03:17:07PM -0400, Jeff Moyer wrote:
> >> For SAN storage, we've seen initial write and re-write performance drop
> >> 25-50% across all I/O sizes.  On locally attached storage, we've seen
> >> regressions of 40% for all I/O types, but only for I/O sizes larger
> than
> >> 1MB.
> >
> > Workload, and hardare please.  An only mainline numbers, not some old
> > hacked vendor kernel, please.
> 
> I've attached a simple fio config that reproduces the problem.  It just
> does sequential, O_DIRECT write I/O with I/O sizes of 1M, 2M and 4M.  So
> far I've tested it on an HP HSV400 and an IBM XIV SAN array connected
> via a qlogic adapter, a nearline sata driveand a WD Red (NAS) sata disk
> connected via an intel ich9r sata controller.  The kernel I tested was
> 4.2.0-rc3, and the testing was done across 3 different hosts (just
> because I don't have all the hardware connected to a single box).  I did
> 10 runs using max_sectors_kb set to 1024, and 10 runs with it set to
> 32767.  Results compare the averages of those 10 runs.  In no cases did
> I see a performance gain.  In two cases, there is a performance hit.
> 
> In addition to my testing, our performance teams have seen performance
> regressions running iozone on fibre channel-attached HP MSA1000 storage,
> as well as on an SSD hidden behind a megaraid controller.  I was not
> able to get the exact details on the SSD.  iozone configurations can be
> provided, but I think I've nailed the underlying problem with this test
> case.
> 
> But, don't take my word for it.  Run the fio script on your own
> hardware.  All you have to do is echo a couple of values into
> /sys/block/sdX/queue/max_sectors_kb to test, no kernel rebuilding
> required.
> 
> In the tables below, concentrate on the BW/IOPS numbers under the WRITE
> column.  Negative numbers indicate that max_sectors_kb of 32767 shows a
> performance regression of the indicated percentage when compared with a
> setting of 1024.
> 
> Christoph, did you have some hardware where a higher max_sectors_kb
> improved performance?

I don't still have performance numbers, but the old default of 
512 KiB was interfering with building large writes that RAID
controllers can treat as full stripe writes (avoiding the need
to read the old parity).

With the SCSI LLD value bumped up, some other limits remain:
* the block layer BIO_MAX_PAGES value of 256 limits IOs
  to a maximum of 1 MiB (bio chaining affects this too)
* the SCSI LLD maximum number of scatter gather entries
  reported in /sys/block/sdNN/queue/max_segments and
  /sys/block/sdNN/queue/max_segment_size creates a
  limit based on how fragmented the data buffer is
  in virtual memory
* the Block Limits VPD page MAXIMUM TRANSFER LENGTH field
  indicates the maximum transfer size for one command over
  the SCSI transport protocol supported by the drive itself

The patch let 1 MiB IOs flow through the stack, which
is a better fit for modern strip sizes than 512 KiB.

Software using large IOs must be prepared for long 
latencies in exchange for the potential bandwidth gains,
and must use a low (but greater than 1) queue depth 
to keep the IOs flowing back-to-back.

Are you finding real software generating such IOs
but relying on the storage stack to break them up
for decent performance?

Your fio script is using the sync IO engine, which
means no queuing.  This forces a turnaround time 
between IOs, preventing the device from looking ahead
to see what's next (for sequential IOs, probably
continuing data transfers with minimal delay).

If the storage stack breaks up large sync IOs, the 
drive might be better at detecting that the access
pattern is sequential (e.g., the gaps are between 
every set of 2 IOs rather than every IO).  This is
very drive-specific.

If we have to go back to that artificial limit, then
modern drivers (e.g., blk-mq capable drivers) need a
way to raise the default; relying on users to change
the sysfs settings means they're usually not changed.

---
Robert Elliott, HP Server Storage
