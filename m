From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.0-test4] blocking access to mounted scsi devices
Date: Mon, 25 Aug 2003 13:08:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030825130822.A4258@infradead.org>
References: <3F49B515.6010107@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3F49B515.6010107@torque.net>; from dougg@torque.net on Mon, Aug 25, 2003 at 05:04:53PM +1000
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ballen@gravity.phys.uwm.edu
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 25, 2003 at 05:04:53PM +1000, Douglas Gilbert wrote:
> A recent test of smartmontools on lk 2.6.0-test4 failed
> miserably on my main SCSI disk. It would seem that
> attempts to use either the:
>     SCSI_IOCTL_SEND_COMMAND
>     SG_IO
> ioctls on a mounted SCSI "block" device fail with EBUSY.
> These ioctls work fine on devices that don't have mounted
> file systems on then. If this is a new policy then it needs
> to be reconsidered. smartmontools still works ok on ATA disks
> in lk 2.6.0-test4.

That's because both mount (or e.g. volume managers) claims
devices for exclusive use, as does drivers/block/scsi_ioctl.c

> Both the ioctls in question still work via the corresponding
> scsi generic device.

Well, we either want both to work or not work.  The current
situation is inconsistant.

> Will scsi generic devices make a
> re-appearance in sysfs (as indicated by Christoph when the
> relevant code in sg was removed)?

Yeah, I still need to come up with a way for class_interfaces
like sg to have sysfs entries.  the TODO list is growing but
I'll take a look at this, promised.
