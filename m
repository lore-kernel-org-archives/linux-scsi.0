From: Gernot Hillier <gernot.hillier@siemens.com>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Wed, 1 Jun 2016 15:17:14 +0200
Message-ID: <574EE05A.9070302@siemens.com>
References: <57448A5D.4050805@siemens.com> <20160524231328.GB387@thunk.org>
 <574BF988.5050202@siemens.com> <20160531002152.GQ26977@dastard>
 <574EAE69.5040003@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <574EAE69.5040003@siemens.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-ext4@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 01.06.2016 11:44, Gernot Hillier wrote:
> Hi!
> 
> On 31.05.2016 02:21, Dave Chinner wrote:
>> On Mon, May 30, 2016 at 10:27:52AM +0200, Gernot Hillier wrote:
>>> Hi!
>>>
>>> On 25.05.2016 01:13, Theodore Ts'o wrote:
>>>> On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
>>>>> We experience strange delays with kernel 4.1.18 during dpkg
>>>>> package installation on an ext4 filesystem after switching from
>>>>> Ubuntu 14.04 to 16.04. We can reproduce the issue with kernel 4.6.
>>>>> Installation of the same package takes 2s with ext3 and 31s with
>>>>> ext4 on the same partition.
>>>>>
>>>>> Hardware is an Intel-based server with Supermicro X8DTH board and
>>>>> Seagate ST973451SS disks connected to an LSI SAS2008 controller (PCI
>>>>> 0x1000:0x0072, mpt2sas driver).
>>> [...]
>>>>> To me, the problem looks comparable to
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
>>>>> a full hang and there's no RAID involved for us), so a closer look on
>>>>> the SCSI layer or driver might be the next step?
>>>>
>>>> What I would suggest is to create a small test case which compares the
>>>> time it takes to allocate 1 megabyte of memory, zero it, and then
>>>> write one megabytes of zeros using the write(2) system call.  Then try
>>>> writing one megabytes of zero using the BLKZEROOUT ioctl.
>>>
>>> Ok, this is my test code:
>>>
>>> 	const int SIZE = 1*1024*1024;
>>> 	char* buffer = malloc(SIZE);
>>> 	uint64_t range[2] = { 0, SIZE };
>>> 	int fd = open("/dev/sdb2", O_WRONLY);
>>>
>>> 	bzero(buffer, SIZE);
>>> 	write(fd, buffer, SIZE);
>>> 	sync_file_range(fd, 0, 0, 2);
>>>
>>> 	ioctl (fd, BLKZEROOUT, range);
>>>
>>> 	close(fd);
>>> 	free(buffer);
>>>
>>> # strace -tt ./test-tytso
>>> [...]
>>> 15:46:27.481636 open("/dev/sdb2", O_WRONLY) = 3
>>> 15:46:27.482004 write(3, "\0\0\0\0\0\0"..., 1048576) = 1048576
>>> 15:46:27.482438 sync_file_range(3, 0, 0, SYNC_FILE_RANGE_WRITE) = 0
>>> 15:46:27.482698 ioctl(3, BLKZEROOUT, [0, 100000]) = 0
>>> 15:46:27.546971 close(3)                = 0
>>>
>>> So the write() and sync_file_range() in the first case takes ~400 us
>>> each while BLKZEROOUT takes... 60 ms. Wow.
>>
>> Comparing apples to oranges.
>>
>> Unlike the name implies, sync_file_range() does not provide any data
>> integrity semantics what-so-ever: SYNC_FILE_RANGE_WRITE only submits
>> IO to clean dirty pages - that only takes 400us of CPU time.  It
> [...]
>> completion. This is what BLKZEROOUT is effectively doing, so I think
>> you'll find fdatasync() also takes around 60ms...
> 
> Oops, sorry for that! I just copied the sync pattern which initially
> caused the delays in dpkg.
> 
> With updated test, I still reproducably see a factor of ~2.5 between
> write+fdatasync (16 ms) and BLKZEROOUT (40 ms), as an example:
> 
> 17:12:30.742679 open("/dev/sdb2", O_WRONLY) = 3
> 17:12:30.742733 fdatasync(3)            = 0
> 17:12:30.743148 write(3, "\0\0\0\0\0\0"..., 1048576) = 1048576
> 17:12:30.743605 fdatasync(3)            = 0
> 17:12:30.758984 ioctl(3, BLKZEROOUT, [0, 100000]) = 0
> 17:12:30.798937 close(3)                = 0
> 
> So, I'm a bit confused now. Does this mean we see three bugs here?
> 
> 1) inefficient use of fallocate() + sync_file_range() by dpkg
>    (was also reported as [1])
> 2) BLKZEROOUT more then 2 times slower than write+fsync
> 3) again unexpected ext4 delay caused by fallocate()+sync_file_range()
> 
> [1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=824636

BTW, that bug reminded me that we initially saw this issue also on a
second machine, sorry for not mentioning/checking this earlier:

- Intel server with Supermicro X9DR3-F board, Intel C606 SAS controller
(PCI id 8086:1d68) with Seagate ST300MM0006 disks.

I repeated the discussed tests and found comparable results on this machine:

- 3 seconds dpkg install time on ext3 vs. 80 seconds for ext4
  on same partition for same package
- 40 ms for fallocate+write+sync_file_range for writing a few bytes
- 15 ms for write+fdatasync vs. 45 ms for BLKZEROOUT on raw device

So this seems to be not bound to one specific disk+controller setup, but
it still can't be a common problem affecting many people as then we
would see more reports about it...

-- 
Gernot
