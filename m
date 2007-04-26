From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: filesystem corruption with md raid6
Date: Thu, 26 Apr 2007 16:17:19 -0400
Message-ID: <1177618639.6284.161.camel@mulgrave.il.steeleye.com>
References: <200704261827.l3QIRX0T023077@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48864 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbXDZURV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 16:17:21 -0400
In-Reply-To: <200704261827.l3QIRX0T023077@focus.uchicago.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Clem Pryke <pryke@focus.uchicago.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-04-26 at 13:27 -0500, Clem Pryke wrote:
> I have a system with 12 SATA disks attached via SAS. When copying into the 
> array during re-sync I get filesystem errors and corruption for raid6 but not 
> for raid5. This problem is repeatable. I actually have 2 separate 12 disk 
> arrays and get the same behavior on both.

If the data is sound for raid5 but not raid6, it tends to indicate that
it might be a md issue; you should perhaps crosspost to
linux-raid@vger.kernel.org which is where the md people hang out.

> Does this sound familiar to anyone?
> 
> Here's a little more detail:
> 
> - 8 core AMD64 system running RHEL4U4 kernel 2.6.9-42.0.3.ELsmp

This is a vendor supported kernel ... perhaps you should start first
with them ... most linux lists are going to want you to try and
reproduce this with the latest kernel ...

> - 12 Seagate ST3750640NS disks via LSI SAS1068 card and mptsas driver provided 
> with kernel. Disk chassis is Promise VTrak J300s
> - build raid5/6 arrays using mdadm in the normal way
> - build filesystem using e2fs in the normal way
> - mount the array
> - fail out and re-add a disk using "mdadm -f/-r/-a /dev/sdd1"
> - while re-sync in progress start an rsync to copy large amount of data into 
> the array
> 
> For raid 5 array while rsync is running re-sync slows down enormously (as 
> shown in /proc/mdstat), then speeds up again once rsync complete and all is 
> good. Unmounting the array and running e2fsck shows no errors.
> 
> For raid 6 re-sync slows down once rsync starts, but then after a few minutes 
> I see the errors below and rsync stops. In this case unmounting and running 
> e2fsck shows loads of errors.
> 
> Apr 26 11:30:50 spt kernel: attempt to access beyond end of device
> Apr 26 11:30:50 spt kernel: md0: rw=1, want=14801215240, limit=14651489280
> Apr 26 11:30:50 spt kernel: Aborting journal on device md0.
> Apr 26 11:30:50 spt kernel: ext3_abort called.
> Apr 26 11:30:50 spt kernel: EXT3-fs error (device md0): ext3_journal_start_sb: 
> Detected aborted journal
> Apr 26 11:30:50 spt kernel: Remounting filesystem read-only
> Apr 26 11:30:50 spt kernel: EXT3-fs error (device md0) in start_transaction: 
> Journal has aborted

This definitely indicates some type of corruption.  I assume a corrupt
inode value caused a read beyond the limits of the device ...
unfortunately, with no other kernel messages, it's difficult to tell
whether it was MD, SCSI or the device driver (or even the device) that
caused it.  Like I said, if it doesn't occur with RAID5, my money would
be on MD.

James


