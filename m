From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch for playing] 2.5.65 patch to support > 256 disks
Date: Mon, 24 Mar 2003 14:57:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303241457.32655.pbadari@us.ibm.com>
References: <200303211056.04060.pbadari@us.ibm.com> <200303241332.56996.pbadari@us.ibm.com> <20030324161016.25a9a77a.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030324161016.25a9a77a.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: dougg@torque.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Monday 24 March 2003 04:10 pm, Andrew Morton wrote:
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > Here is the list of slab caches which consumed more than 1 MB
> > in the process of inserting 4000 disks.
>
> Thanks for doing this.
>
> > #insmod scsi_debug.ko add_host=4 num_devs=1000
> >
> > deadline_drq    before:1280 after:1025420 diff:1024140 size:64
> > incr:65544960 blkdev_requests  before:1280 after:1025400 diff:1024120
> > size:156 incr:159762720
> >
> > * deadline_drq, blkdev_requests consumed almost 80 MB. We need to fix
> > this.
>
> Yes, we do.  But.
>
> > inode_cache     before:700 after:140770 diff:140070 size:364
> > incr:50985480 dentry_cache    before:4977 after:145061 diff:140084
> > size:172 incr:24094448
> >
> > * inode cache increased by 50 MB, dentry cache 24 MB.
> > It looks like we cached 140,000 inodes. I wonder why ?
>
> # find /sys/block/hda | wc -l
>      43
>
> Oh shit, we're toast.
>
> How many partitions did these "disks" have?

These are all scsi_debug disks. No partitions. 
Yeah !! I know what you mean, with partitions we
are going to get 5 more inodes per partition..

[root@elm3b78 sdaaa]# find /sysfs/block/sdaa
/sysfs/block/sdaa
/sysfs/block/sdaa/iosched
/sysfs/block/sdaa/iosched/fifo_batch
/sysfs/block/sdaa/iosched/front_merges
/sysfs/block/sdaa/iosched/writes_starved
/sysfs/block/sdaa/iosched/write_expire
/sysfs/block/sdaa/iosched/read_expire
/sysfs/block/sdaa/device
/sysfs/block/sdaa/stat
/sysfs/block/sdaa/size
/sysfs/block/sdaa/range
/sysfs/block/sdaa/dev

Thanks,
Badari

