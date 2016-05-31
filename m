From: Dave Chinner <david@fromorbit.com>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Tue, 31 May 2016 10:21:52 +1000
Message-ID: <20160531002152.GQ26977@dastard>
References: <57448A5D.4050805@siemens.com>
 <20160524231328.GB387@thunk.org>
 <574BF988.5050202@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46506 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161860AbcEaAZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 20:25:53 -0400
Content-Disposition: inline
In-Reply-To: <574BF988.5050202@siemens.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gernot Hillier <gernot.hillier@siemens.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-ext4@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com

On Mon, May 30, 2016 at 10:27:52AM +0200, Gernot Hillier wrote:
> Hi!
> 
> On 25.05.2016 01:13, Theodore Ts'o wrote:
> > On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
> >> We experience strange delays with kernel 4.1.18 during dpkg
> >> package installation on an ext4 filesystem after switching from
> >> Ubuntu 14.04 to 16.04. We can reproduce the issue with kernel 4.6.
> >> Installation of the same package takes 2s with ext3 and 31s with
> >> ext4 on the same partition.
> >>
> >> Hardware is an Intel-based server with Supermicro X8DTH board and
> >> Seagate ST973451SS disks connected to an LSI SAS2008 controller (PCI
> >> 0x1000:0x0072, mpt2sas driver).
> [...]
> >> To me, the problem looks comparable to
> >> https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
> >> a full hang and there's no RAID involved for us), so a closer look on
> >> the SCSI layer or driver might be the next step?
> > 
> > What I would suggest is to create a small test case which compares the
> > time it takes to allocate 1 megabyte of memory, zero it, and then
> > write one megabytes of zeros using the write(2) system call.  Then try
> > writing one megabytes of zero using the BLKZEROOUT ioctl.
> 
> Ok, this is my test code:
> 
> 	const int SIZE = 1*1024*1024;
> 	char* buffer = malloc(SIZE);
> 	uint64_t range[2] = { 0, SIZE };
> 	int fd = open("/dev/sdb2", O_WRONLY);
> 
> 	bzero(buffer, SIZE);
> 	write(fd, buffer, SIZE);
> 	sync_file_range(fd, 0, 0, 2);
> 
> 	ioctl (fd, BLKZEROOUT, range);
> 
> 	close(fd);
> 	free(buffer);
> 
> # strace -tt ./test-tytso
> [...]
> 15:46:27.481636 open("/dev/sdb2", O_WRONLY) = 3
> 15:46:27.482004 write(3, "\0\0\0\0\0\0"..., 1048576) = 1048576
> 15:46:27.482438 sync_file_range(3, 0, 0, SYNC_FILE_RANGE_WRITE) = 0
> 15:46:27.482698 ioctl(3, BLKZEROOUT, [0, 100000]) = 0
> 15:46:27.546971 close(3)                = 0
> 
> So the write() and sync_file_range() in the first case takes ~400 us
> each while BLKZEROOUT takes... 60 ms. Wow.

Comparing apples to oranges.

Unlike the name implies, sync_file_range() does not provide any data
integrity semantics what-so-ever: SYNC_FILE_RANGE_WRITE only submits
IO to clean dirty pages - that only takes 400us of CPU time.  It
does not wait for completion, nor does it flush the drive cache and
so by the time the syscall returns to userspace the IO may not have
even been sent to the device (e.g. it could be queued by the IO
scheduler in the block layer). i.e. you're not timing IO, you're
timing CPU overhead of IO submission.

For an apples to apples comparison, you need to use fsync() to
physically force the written data to stable storage and wait for
completion. This is what BLKZEROOUT is effectively doing, so I think
you'll find fdatasync() also takes around 60ms...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
