From: Andrew Morton <akpm@digeo.com>
Subject: Re: [patch for playing] 2.5.65 patch to support > 256 disks
Date: Mon, 24 Mar 2003 16:10:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030324161016.25a9a77a.akpm@digeo.com>
References: <200303211056.04060.pbadari@us.ibm.com>
	<3E7C4D05.2030500@torque.net>
	<20030322040550.0b8baeec.akpm@digeo.com>
	<200303241332.56996.pbadari@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200303241332.56996.pbadari@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: dougg@torque.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

Badari Pulavarty <pbadari@us.ibm.com> wrote:
>
> Here is the list of slab caches which consumed more than 1 MB
> in the process of inserting 4000 disks.

Thanks for doing this.

> #insmod scsi_debug.ko add_host=4 num_devs=1000
> 
> deadline_drq    before:1280 after:1025420 diff:1024140 size:64 incr:65544960
> blkdev_requests  before:1280 after:1025400 diff:1024120 size:156 incr:159762720
> 
> * deadline_drq, blkdev_requests consumed almost 80 MB. We need to fix this.

Yes, we do.  But.

> inode_cache     before:700 after:140770 diff:140070 size:364 incr:50985480
> dentry_cache    before:4977 after:145061 diff:140084 size:172 incr:24094448
> 
> * inode cache increased by 50 MB, dentry cache 24 MB. 
> It looks like we cached 140,000 inodes. I wonder why ? 

# find /sys/block/hda | wc -l
     43

Oh shit, we're toast.

How many partitions did these "disks" have?

> size-2048       before:112 after:4102 diff:3990 size:2060 incr:8219400
> size-512        before:87 after:8085 diff:7998 size:524 incr:4190952
> size-192        before:907 after:16910 diff:16003 size:204 incr:3264612
> size-64         before:459 after:76500 diff:76041 size:76 incr:5779116
> size-32         before:523 after:24528 diff:24005 size:44 incr:1056220
> 
> * 30MB for all other structures. I need to look closely on what these are..

Yes, that will take some work.  What I would do is to change kmalloc:

+ int foo;

  kmalloc(...)
  {
+	if (foo)
+		dump_stack();


and then set `foo' in gdb across the registration of one disk.

Probably you can set foo by hand in scsi_register_device() or wherever it
happens.
