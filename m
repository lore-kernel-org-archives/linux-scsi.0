From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 13:03:21 -0700
Message-ID: <1224273801.5556.354.camel@haakon2.linux-iscsi.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017074453.GA4850@kroah.com>
	 <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
	 <20081017194857.GD5633@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:39506 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755998AbYJQUDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 16:03:24 -0400
In-Reply-To: <20081017194857.GD5633@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Fri, 2008-10-17 at 12:48 -0700, Joel Becker wrote:
> On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> > > What is the problem you are attempting to solve here?
> > > 
> > 
> > So, the generic target_core_mod engine that lives
> > under /sys/kernel/config/target/core needs a method to locate struct
> > block_device and struct scsi_device for access via bio_submit() and
> > scsi_execute_() respectively.
> > 
> > Originally, target_core_mod used key echoed through configfs attributes
> > like so:
> > 
> > export TARGET=/sys/kernel/config/target/core/
> > 
> > # Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
> > mkdir -p $TARGET/iblock_0/lvm_test0
> > # OLD METHOD to reference struct block_device
> > echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
> > echo 1 > $TARGET/iblock_0/lvm_test0/enable
> > # NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
> > ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2
> 
> 	Pass an open file descriptor.  In bash(1):
> 
>     exec 3<>/dev/dm-7
>     echo 3 >$TARGET/iblock_0/lvm_test0/control  # I'd call it 'fd'
> 
> In kernel, in the ->store() function of 'control':
> 
> 	p = (char *)page;
> 	fd = simple_strtol(p, &p, 0);
> 	filp = fget(fd);
> 	inode = igrab(filp->f_mapping->host);
> 	dev = I_BDEV(filp->f_mapping->host);
> 	blkdev_get(dev, FMODE_WRITE | FMODE_READ, 0);
> 
> Error handling is left up to you (validate the strtol, fd range, ISBLK,
> etc).  This assumes you want the struct block_device and want to pin it
> in memory.  I assume you do.
> 

<nod>  Sounds good..  I will go about converting the target_core_mod
subsystem plugins to use this method.. 

Thanks Joel!

--nab

> Joel
> 

