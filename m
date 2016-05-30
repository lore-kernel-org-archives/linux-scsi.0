From: Gernot Hillier <gernot.hillier@siemens.com>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Mon, 30 May 2016 10:27:52 +0200
Message-ID: <574BF988.5050202@siemens.com>
References: <57448A5D.4050805@siemens.com> <20160524231328.GB387@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from goliath.siemens.de ([192.35.17.28]:52078 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbcE3JAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2016 05:00:05 -0400
In-Reply-To: <20160524231328.GB387@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Cc: linux-ext4@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com

Hi!

On 25.05.2016 01:13, Theodore Ts'o wrote:
> On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
>> We experience strange delays with kernel 4.1.18 during dpkg
>> package installation on an ext4 filesystem after switching from
>> Ubuntu 14.04 to 16.04. We can reproduce the issue with kernel 4.6.
>> Installation of the same package takes 2s with ext3 and 31s with
>> ext4 on the same partition.
>>
>> Hardware is an Intel-based server with Supermicro X8DTH board and
>> Seagate ST973451SS disks connected to an LSI SAS2008 controller (PCI
>> 0x1000:0x0072, mpt2sas driver).
[...]
>> To me, the problem looks comparable to
>> https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
>> a full hang and there's no RAID involved for us), so a closer look on
>> the SCSI layer or driver might be the next step?
> 
> What I would suggest is to create a small test case which compares the
> time it takes to allocate 1 megabyte of memory, zero it, and then
> write one megabytes of zeros using the write(2) system call.  Then try
> writing one megabytes of zero using the BLKZEROOUT ioctl.

Ok, this is my test code:

	const int SIZE = 1*1024*1024;
	char* buffer = malloc(SIZE);
	uint64_t range[2] = { 0, SIZE };
	int fd = open("/dev/sdb2", O_WRONLY);

	bzero(buffer, SIZE);
	write(fd, buffer, SIZE);
	sync_file_range(fd, 0, 0, 2);

	ioctl (fd, BLKZEROOUT, range);

	close(fd);
	free(buffer);

# strace -tt ./test-tytso
[...]
15:46:27.481636 open("/dev/sdb2", O_WRONLY) = 3
15:46:27.482004 write(3, "\0\0\0\0\0\0"..., 1048576) = 1048576
15:46:27.482438 sync_file_range(3, 0, 0, SYNC_FILE_RANGE_WRITE) = 0
15:46:27.482698 ioctl(3, BLKZEROOUT, [0, 100000]) = 0
15:46:27.546971 close(3)                = 0

So the write() and sync_file_range() in the first case takes ~400 us
each while BLKZEROOUT takes... 60 ms. Wow.

> I'm pretty sure you'll see same issue with BLKZEROOUT ioctl, but at
> this point, we'll be able to send bug reports to the SCSI and block
> layer developers with something that makes this very clear that it has
> nothing to do with ext4.

Ok, I included linux-scsi and mpt2sas maintainers to the thread. Can you
please help to narrow this down further?

> This way we can also do some differential diagnosis; given that I'm
> not seeing this complaint from most people, I suspect it will be a
> matter of adding some specific devices to a blacklist (so that even
> though the SCSI device claims to support WRITE SAME, we need to
> disable it because it has a really lousy implementation of the SCSI
> WRITE SAME command).

Even a BLKZEROOUT for 512 bytes takes nearly 5 ms on this machine. This
really qualifies as "lousy implementation".

Any idea how I could find out whether disks or controller are to blame
here? Getting physical access to the machine and replacing disks might
take us some days, so any other suggestion is greatly appreciated!

-- 
With kind regards,

Gernot Hillier, Siemens AG
Corporate Technology, Corporate Competence Center Embedded Linux

