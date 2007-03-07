From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Wed, 07 Mar 2007 12:05:11 -0800
Message-ID: <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com>
References: <20070226133153.GC4095@skl-net.de>
	 <20070226182617.GC9968@andrew-vasquezs-computer.local>
	 <20070227101100.GA22572@skl-net.de>
	 <20070227185134.GJ20397@andrew-vasquezs-computer.local>
	 <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de>
	 <20070306203952.471218df.akpm@linux-foundation.org>
	 <20070307170955.GA4252@skl-net.de>
	 <20070307114525.08265c33.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20070307114525.08265c33.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andre Noll <maan@systemlinux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Adrian Bunk <bunk@stusta.de>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-03-07 at 11:45 -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2007 18:09:55 +0100 Andre Noll <maan@systemlinux.org> wrote:
> 
> > On 20:39, Andrew Morton wrote:
> > > On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.org> wrote:
> > > 
> > > > On 16:18, Andre Noll wrote:
> > > > 
> > > > > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > > > > writing to both raid systems at the same time via lvm still locks up
> > > > > the system within minutes.
> > > > 
> > > > Screenshot of the resulting kernel panic:
> > > > 
> > > > 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> > > > 
> > > 
> > > It died in CFQ.  Please try a different IO scheduler.  Use something
> > > like
> > > 
> > > 	echo deadline > /sys/block/sda/queue/scheduler
> > > 
> > > This could still be the old qla2xxx bug, or it could be a new qla2xxx bug,
> > > or it could be a block bug, or it could be an LVM bug.
> > 
> > OK. I'm running with deadline right now. But I guess this kernel
> > panic was caused by an LVM bug because lockdep reported problems with
> > LVM. Nobody responded to my bug report on the LVM mailing list (see
> > http://www.redhat.com/archives/linux-lvm/2007-February/msg00102.html).
> > 
> > Non-working snapshots and no help from the mailing list convinced me
> > to ditch the lvm setup [1] in favour of linear software raid. This
> > means I can't do lvm-related tests any more.
> 
> Sigh.
> 
> > BTW: Are ext3 filesystem sizes greater than 8T now officially
> > supported?
> 
> I think so, but I don't know how much 16TB testing developers and
> distros are doing - perhaps the linux-ext4 denizens can tell us?
> -

IBM has done some testing (dbench, fsstress, fsx, tiobench, iozone etc)
on 10TB ext3, I think RedHat and BULL have done similar test on >8TB
ext3 too.

Mingming
