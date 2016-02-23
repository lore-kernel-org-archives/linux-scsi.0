From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM ATTEND] Online Logical Head Depop and SMR disks
 chunked writepages
Date: Tue, 23 Feb 2016 09:40:42 +0100
Message-ID: <20160223084042.GA24086@quack.suse.cz>
References: <05353ADC-601C-412D-80E2-1F1972324A37@hgst.com>
 <56CBD878.4070600@sandisk.com>
 <20F4EEF6-8F58-42A0-99E9-E932B51D0387@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbcBWIkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 03:40:23 -0500
Content-Disposition: inline
In-Reply-To: <20F4EEF6-8F58-42A0-99E9-E932B51D0387@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Matias Bjorling <m@bjorling.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue 23-02-16 05:31:13, Damien Le Moal wrote:
> 
> >On 02/22/16 18:56, Damien Le Moal wrote:
> >> 2) Write back of dirty pages to SMR block devices:
> >>
> >> Dirty pages of a block device inode are currently processed using the
> >> generic_writepages function, which can be executed simultaneously
> >> by multiple contexts (e.g sync, fsync, msync, sync_file_range, etc).
> >> Mutual exclusion of the dirty page processing being achieved only at
> >> the page level (page lock & page writeback flag), multiple processes
> >> executing a "sync" of overlapping block ranges over the same zone of
> >> an SMR disk can cause an out-of-LBA-order sequence of write requests
> >> being sent to the underlying device. On a host managed SMR disk, where
> >> sequential write to disk zones is mandatory, this result in errors and
> >> the impossibility for an application using raw sequential disk write
> >> accesses to be guaranteed successful completion of its write or fsync
> >> requests.
> >>
> >> Using the zone information attached to the SMR block device queue
> >> (introduced by Hannes), calls to the generic_writepages function can
> >> be made mutually exclusive on a per zone basis by locking the zones.
> >> This guarantees sequential request generation for each zone and avoid
> >> write errors without any modification to the generic code implementing
> >> generic_writepages.
> >>
> >> This is but one possible solution for supporting SMR host-managed
> >> devices without any major rewrite of page cache management and
> >> write-back processing. The opinion of the audience regarding this
> >> solution and discussing other potential solutions would be greatly
> >> appreciated.
> >
> >Hello Damien,
> >
> >Is it sufficient to support filesystems like BTRFS on top of SMR drives 
> >or would you also like to see that filesystems like ext4 can use SMR 
> >drives ? In the latter case: the behavior of SMR drives differs so 
> >significantly from that of other block devices that I'm not sure that we 
> >should try to support these directly from infrastructure like the page 
> >cache. If we look e.g. at NAND SSDs then we see that the characteristics 
> >of NAND do not match what filesystems expect (e.g. large erase blocks). 
> >That is why every SSD vendor provides an FTL (Flash Translation Layer), 
> >either inside the SSD or as a separate software driver. An FTL 
> >implements a so-called LFS (log-structured filesystem). With what I know 
> >about SMR this technology looks also suitable for implementation of a 
> >LFS. Has it already been considered to implement an LFS driver for SMR 
> >drives ? That would make it possible for any filesystem to access an SMR 
> >drive as any other block device. I'm not sure of this but maybe it will 
> >be possible to share some infrastructure with the LightNVM driver 
> >(directory drivers/lightnvm in the Linux kernel tree). This driver 
> >namely implements an FTL.
> 
> I totally agree with you that trying to support SMR disks by only modifying
> the page cache so that unmodified standard file systems like BTRFS or ext4
> remain operational is not realistic at best, and more likely simply impossible.
> For this kind of use case, as you said, an FTL or a device mapper driver are
> much more suitable.
> 
> The case I am considering for this discussion is for raw block device accesses
> by an application (writes from user space to /dev/sdxx). This is a very likely
> use case scenario for high capacity SMR disks with applications like distributed
> object stores / key value stores.
> 
> In this case, write-back of dirty pages in the block device file inode mapping
> is handled in fs/block_dev.c using the generic helper function generic_writepages.
> This does not guarantee the generation of the required sequential write pattern
> per zone necessary for host-managed disks. As I explained, aligning calls of this
> function to zone boundaries while locking the zones under write-back solves
> simply the problem (implemented and tested). This is of course only one possible
> solution. Pushing modifications deeper in the code or providing a
> "generic_sequential_writepages" helper function are other potential solutions
> that in my opinion are worth discussing as other types of devices may benefit also
> in terms of performance (e.g. regular disk drives prefer sequential writes, and
> SSDs as well) and/or lighten the overhead on an underlying FTL or device mapper
> driver.
> 
> For a file system, an SMR compliant implementation of a file inode mapping
> writepages method should be provided by the file system itself as the sequentiality
> of the write pattern depends further on the block allocation mechanism of the file
> system.
> 
> Note that the goal here is not to hide to applications the sequential write
> constraint of SMR disks. The page cache itself (the mapping of the block
> device inode) remains unchanged. But the modification proposed guarantees that
> a well behaved application writing sequentially to zones through the page cache
> will see successful sync operations.

So the easiest solution for the OS, when the application is already aware
of the storage constraints, would be for an application to use direct IO.
Because when using page-cache and writeback there are all sorts of
unexpected things that can happen (e.g. writeback decides to skip a page
because someone else locked it temporarily). So it will work in 99.9% of
cases but sometimes things will be out of order for hard-to-track down
reasons. And for ordinary drives this is not an issue because we just slow
down writeback a bit but rareness of this makes it non-issue. But for host
managed SMR the IO fails and that is something the application does not
expect.

So I would really say just avoid using page-cache when you are using SMR
drives directly without a translation layer. For writes your throughput
won't suffer anyway since you have to do big sequential writes. Using
page-cache for reads may still be beneficial and if you are careful enough
not to do direct IO writes to the same range as you do buffered reads, this
will work fine.

Thinking some more - if you want to make it foolproof, you could implement
something like read-only page cache for block devices. Any write will be in
fact direct IO write, writeable mmaps will be disallowed, reads will honor
O_DIRECT flag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
