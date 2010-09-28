From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 10:15:45 -0400
Message-ID: <20100928141545.GA21587@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <4CA0CC38.5010804@fusionio.com>
 <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
 <4CA118FF.1080100@fusionio.com>
 <yq18w2mddav.fsf@sermon.lab.mkp.net>
 <20100927231551.GA15653@redhat.com>
 <4CA16F6A.1090904@fusionio.com>
 <4CA17B13.7080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0I1OPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 10:15:52 -0400
Content-Disposition: inline
In-Reply-To: <4CA17B13.7080801@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Tue, Sep 28 2010 at  1:20am -0400,
Eric Sandeen <sandeen@redhat.com> wrote:

> Jens Axboe wrote:
> > On 2010-09-28 08:15, Mike Snitzer wrote:
> >> On Mon, Sep 27 2010 at  6:36pm -0400,
> >> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> >>
> >>>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> >>> Jens> Does mkfs do the right thing?
> >>>
> >>> Depends on which mkfs it is. Mike has tested things and can chip in
> >>> here...
> >> I haven't test all mkfs.* but...
> >>
> >> mkfs.xfs just works with 1M physical_block_size.
> >>
> >> mkfs.ext4 won't by default but -F "fixes" that:
> >>
> >> # mkfs.ext4 -b 4096 -F /dev/mapper/20017380023360006
> >> mke2fs 1.41.12 (17-May-2010)
> >> Warning: specified blocksize 4096 is less than device physical sectorsize 1048576, forced to continue
> > 
> > OK, so that's not exactly doing the right thing, but at least you can
> > work around it with a parameter. So I'd say that is good enough.
> 
> Which part of it is the wrong thing...?
> 
> Today mkfs.ext4 refuses to create an fs blocksize which is smaller than logical
> or physical by default, because one is suboptimal and the other is impossible.
> -F (force) can override the suboptimal fs blocksize < logical blocksize case...

Actually, -F allows one to override fs blocksize < physical_block_size.

In this instance we have the following:
# cat /sys/block/dm-2/queue/physical_block_size 
1048576
# cat /sys/block/dm-2/queue/logical_block_size 
512
 
> Should we change something?

Unclear.  I could see maybe automatically capping the fs block size at
4096 if physical_block_size is larger and is a multiple of 4096?

> >> I'll check fdisk and parted tomorrow (I know lvm2 doesn't look at
> >> physical_block_size).

Both fdisk and parted look good (partitions are physical_block_size
aligned, will warn if you attempt to stray from that alignment).  I'll
spare you detials of the creation steps...

Results of fdisk:
-----------------

# fdisk /dev/sdb
...
The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.
...

# fdisk -l -u /dev/sdb

Disk /dev/sdb: 17.2 GB, 17179869184 bytes
255 heads, 63 sectors/track, 2088 cylinders, total 33554432 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 1048576 bytes
I/O size (minimum/optimal): 1048576 bytes / 1048576 bytes
Disk identifier: 0x0009bf46

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048    16775167     8386560   83  Linux


Results of parted:
------------------
Also looks good, doesn't care about physical_block_size.  Is more
concerned with {minimum,optimal}_io_size.

(parted) unit MiB
(parted) p
Model: XXXXXXXXXXXXX
Disk /dev/sdb: 16384MiB
Sector size (logical/physical): 512B/1048576B
Partition Table: msdos

Number  Start    End      Size     Type     File system  Flags
 1      1.00MiB  8191MiB  8190MiB  primary
