From: Andrew Morton <akpm@digeo.com>
Subject: Re: [patch for playing] 2.5.65 patch to support > 256 disks
Date: Sat, 22 Mar 2003 04:05:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030322040550.0b8baeec.akpm@digeo.com>
References: <200303211056.04060.pbadari@us.ibm.com>
	<3E7C4251.4010406@torque.net>
	<20030322030419.1451f00b.akpm@digeo.com>
	<3E7C4D05.2030500@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E7C4D05.2030500@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: pbadari@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Douglas Gilbert <dougg@torque.net> wrote:
>
> Andrew Morton wrote:
> > Douglas Gilbert <dougg@torque.net> wrote:
> > 
> >>>Slab:           464364 kB
> >>
> > 
> > It's all in slab.
> > 
> > 
> >>I did notice a rather large growth of nodes
> >>in sysfs. For 84 added scsi_debug pseudo disks the number
> >>of sysfs nodes went from 686 to 3347.
> >>
> >>Does anybody know what is the per node memory cost of sysfs?
> > 
> > 
> > Let's see all of /pro/slabinfo please.
> 
> Andrew,
> Attachments are /proc/slabinfo pre and post:
>   $ modprobe scsi_debug add_host=42 num_devs=2
> which adds 84 pseudo disks.
> 

OK, thanks.  So with 48 disks you've lost five megabytes to blkdev_requests
and deadline_drq objects.  With 4000 disks, you're toast.  That's enough
request structures to put 200 gigabytes of memory under I/O ;)

We need to make the request structures dymanically allocated for other
reasons (which I cannot immediately remember) but it didn't happen.  I guess
we have some motivation now.

