From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [2.6.0-test4] blocking access to mounted scsi devices
Date: Tue, 26 Aug 2003 20:20:50 +1000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F4B3482.4060304@torque.net>
References: <3F49B515.6010107@torque.net> <20030825130822.A4258@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030825130822.A4258@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ballen@gravity.phys.uwm.edu
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 25, 2003 at 05:04:53PM +1000, Douglas Gilbert wrote:
> 
>>A recent test of smartmontools on lk 2.6.0-test4 failed
>>miserably on my main SCSI disk. It would seem that
>>attempts to use either the:
>>    SCSI_IOCTL_SEND_COMMAND
>>    SG_IO
>>ioctls on a mounted SCSI "block" device fail with EBUSY.
>>These ioctls work fine on devices that don't have mounted
>>file systems on then. If this is a new policy then it needs
>>to be reconsidered. smartmontools still works ok on ATA disks
>>in lk 2.6.0-test4.
> 
> 
> That's because both mount (or e.g. volume managers) claims
> devices for exclusive use, as does drivers/block/scsi_ioctl.c

Well it is reasonable that mount should exclude other attempts
to mount. However the device holding the root file system
may be an ATA or SCSI disk and the ide-disk and sd drivers
do not support SMART probing directly.

Tools like smartmontools periodically (or on demand) probe disks
to find their SMART status. According to an IBM white paper
a significant percentage of disk failures can be predicted
by increased error rates and drive temperature. It doesn't
seem practical to unmount the root file system (and any other
mounted partitions) to allow such a probe then remount.

If this policy is to remain in lk 2.6 (for SCSI disks
but not ATA disks yet) then perhaps the sd and sr drivers
need to be changed to treat READ and WRITE commands differently
from other commands. Other commands should not be subject
block level policy.

Doug Gilbert
