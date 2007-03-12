From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 23:46:54 -0400
Message-ID: <20070312034654.GB5266@schatzie.adilger.int>
References: <45F48809.2060908@emc.com> <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr> <45F4BEC4.5090402@emc.com> <Pine.LNX.4.61.0703120423360.4339@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703120423360.4339@yvahk01.tjqt.qr>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mar 12, 2007  04:27 +0100, Jan Engelhardt wrote:
> Assume this partition table on my current HD:
> 
> 	Disk /dev/hdc: 251.0 GB, 251000193024 bytes
> 	255 heads, 63 sectors/track, 30515 cylinders
> 	Units = cylinders of 16065 * 512 = 8225280 bytes
> 	
> 	   Device Start  End      Blocks   Id  System
> 	/dev/hdc1   1     33      265041   82  Linux swap / Solaris
> 	/dev/hdc2  34  30515   244846665    5  Extended
> 
> That is, 255 * 63 * 30515 * 512 == roughly 251 GB.
> 
> Now, if this disk was copied byte per byte (/bin/dd) to a
> 4096-based disk, and Linux would start using a sector size of
> 4096

The easy answer is "don't do that".  You should make a new partition
table on the 4096-byte sector drive (each of the partitions at least
as large as the old ones), and then copy the content of each of the
partitions separately onto the new disk.

> Although I would not mind the 2 TB, the partition table would
> read quite differently (note the Blocks column which is
> multiplied by 4 (512x4=4096))
> 
>            Device Start  End      Blocks   Id  System
>         /dev/hdc1   1     33     1060164   82  Linux swap / Solaris
>         /dev/hdc2  34  30515   979386660    5  Extended
> 
> Which would mean that the swap partition reaches into the real
> data partition and would corrupt it.

In the same way you can't copy raw disks from one vendor's RAID 5
array and put them into another vendor's (or even model's) RAID 5 array,
or you can't do a raw copy of a partitioned disk and expect it to
suddenly become an LVM volume, you can't do raw disk copies between
drives with different sector size.

You also won't be able to use a copy of an ext3 filesystems with 1kB
blocksize onto a 4kB sector size device - the ext3 code will detect
this and refuse to mount.  At that point you need to do a tar/untar
(or whatever) to copy the data instead of a raw partition copy.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

