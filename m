From: Christoph Fritz <chf.fritz@googlemail.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 17:13:08 +0200
Message-ID: <20110702151308.GA14652@lovely.krouter>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
 <20110701181406.GA1614@redhat.com>
 <20110701183227.GF23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110701183227.GF23059@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 01, 2011 at 08:32:27PM +0200, Andi Kleen wrote:
> On Fri, Jul 01, 2011 at 02:14:06PM -0400, Dave Jones wrote:
> > On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> > 
> >  > I found I can reliably crash a 3.0 system by pulling the
> >  > USB cable of a mounted USB cdrom (or rather a USB device which
> >  > has a builtin fake CD-ROM) 
> >  > 
> >  > I suspect it's a regression too.
> > 
> > We've been seeing a lot of similar bugs in Fedora since we pushed
> > a 2.6.38.8 update.  Some of the traces are different, but some
> 
> I've also seen one with an earlier kernel where the NULL 
> reference was in elv_.* something.  Don't have a written down backtrace
> for this, but perhaps you have.

Do you mean https://bugzilla.kernel.org/show_bug.cgi?id=38412 ?

[..]
Process eject (pid: 5846, ti=f5b9a000 task=f5b19a80 task.ti=f5b9a000)
Stack:
c1198600 c119ac69 00000256 00000000 00000002 c119b2f9 f4eed270 c11a3237
00000000 f5297200 f637e418 00005309 0000005d c11a3378 0000005d 00000000
f5c1b700 00000000 f5c02e00 00000000 f4a2e1f4 f59c0700 c10d1bc3 f53ed001
Call Trace:
[<c1198600>] ? elv_put_request+0x10/0x20
[<c119ac69>] ? __blk_put_request+0x99/0xc0
[<c119b2f9>] ? blk_put_request+0x19/0x40
[<c11a3237>] ? T.593+0x77/0x90
[<c11a3378>] ? scsi_cmd_ioctl+0x128/0x440
[<c10d1bc3>] ? blkdev_get+0x43/0x380
[<c10d1000>] ? bd_acquire+0x20/0xd0
[<c10a2a6d>] ? __dentry_open+0x1cd/0x2a0
[<c10a2c30>] ? nameidata_to_filp+0x70/0x80
[<c10d1f00>] ? blkdev_get+0x380/0x380
[<c125e582>] ? sd_ioctl+0x82/0xc0
[<c125e500>] ? sd_check_events+0x140/0x140
[<c11a02d9>] ? __blkdev_driver_ioctl+0x29/0x40
[<c11a07d3>] ? blkdev_ioctl+0x213/0x7e0
[<c10b1854>] ? do_filp_open+0x34/0x90
[<c10d0715>] ? block_ioctl+0x35/0x50
[<c10d06e0>] ? blkdev_get_block+0x50/0x50
[<c10b2b92>] ? do_vfs_ioctl+0x92/0x610
[<c10a262e>] ? do_sys_open+0x16e/0x1c0
[<c10a262e>] ? do_sys_open+0x16e/0x1c0
[<c10b314d>] ? sys_ioctl+0x3d/0x70
[<c1394ad0>] ? sysenter_do_call+0x12/0x26
Code:  Bad EIP value.
EIP: [<2f327473>] 0x2f327473 SS:ESP 0068:f5b9bdb0
CR2: 000000002f327473
---[ end trace 4877fe842f054f84 ]---


Thanks,
 -- Christoph
