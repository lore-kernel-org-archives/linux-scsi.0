From: David Wuertele <dave-gnus@bfnet.com>
Subject: Trying to troubleshoot ornery Phison usb-storage
Date: Fri, 14 Mar 2003 10:39:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m34r65lrmq.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 18tuG3-0007tX-00
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2003 19:50:19 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-users@lists.sourceforge.net

I've got a board with a phison flash-card reader chip on it, and I
don't seem to be able to get any of the usb-storage features to work.
I'm looking for troubleshooting tips.

I'm using linux version 2.4.18 on a mipsel architecture.  I get the
same negative results whether or not I'm using the phison patch from
http://www.fuw.edu.pl/~pliszka/linux-USB/Phison.tgz. When I try to
fdisk a card inserted in the slot, I get:

  # fdisk /dev/scsi/host0/bus0/target0/lun1/disc
  Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
  Building a new DOS disklabel. Changes will remain in memory only,
  until you decide to write them. After that, of course, the previous
  content won't be recoverable.

The console always prints:

  SCSI error: host 0 id 0 lun 1 return code = 8000002
        Sense class 7, sense error 0, extended sense 7

I try to create a new Linux partion, which appears to work at first:

  Disk /dev/scsi/host0/bus0/target0/lun1/disc: 34 heads, 61 sectors, 1011 cylinders
  Units = cylinders of 2074 * 512 bytes

                                   Device Boot    Start       End    Blocks   Id  System
  /dev/scsi/host0/bus0/target0/lun1/part1             1      1011   1048376+  83  Linux

  Command (m for help): w
  The partition table has been altered!

  Calling ioctl() to re-read partition table.

  WARNING: If you have created or modified any DOS 6.x
  partitions, please see the fdisk manual page for additional
  information.
  Syncing disks.
  #

The console at this point has printed:

  sdb : READ CAPACITY failed.
  sdb : status = 1, message = 00, host = 0, driver = 08 
  Current sd00:00: sns = 70  7
  ASC=27 ASCQ= 0
  Raw sense data:0x70 0x00 0x07 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x27 0x00 0x00 0x00 0x00 0x00 
  sdb : block size assumed to be 512 bytes, disk size 1GB.  
  sdb: Write Protect is off
   p1
  sdb : READ CAPACITY failed.
  sdb : status = 1, message = 00, host = 0, driver = 08 
  Current sd00:00: sns = 70  7
  ASC=27 ASCQ= 0
  Raw sense data:0x70 0x00 0x07 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x27 0x00 0x00 0x00 0x00 0x00 
  sdb : block size assumed to be 512 bytes, disk size 1GB.  
  sdb: Write Protect is off
   p1

So I try to make a filesystem and mount:

  mkfs /dev/scsi/host0/bus0/target0/lun1/part1
  mke2fs 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
  Filesystem label=
  OS type: Linux
  Block size=4096 (log=2)
  Fragment size=4096 (log=2)
  131072 inodes, 262094 blocks
  13104 blocks (5.00%) reserved for the super user
  First data block=0
  8 block groups
  32768 blocks per group, 32768 fragments per group
  16384 inodes per group
  Superblock backups stored on blocks: 
          32768, 98304, 163840, 229376

  Writing inode tables: 0/81/82/83/84/85/86/87/8done                            
  Writing superblocks and filesystem accounting information: done

  This filesystem will be automatically checked every 20 mounts or
  180 days, whichever comes first.  Use tune2fs -c or -i to override.
  # mount /dev/scsi/host0/bus0/target0/lun1/part1 /mnt/test
  mount: Mounting /dev/scsi/host0/bus0/target0/lun1/part1 on /mnt/test failed: Invalid argument
  # 

The console now prints:

  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7
  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7
  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7
  VFS: Can't find ext2 filesystem on dev sd(8,17).
  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7
  FAT: bogus logical sector size 0
  VFS: Can't find a valid FAT filesystem on dev 08:11.
  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7
  SCSI error: host 0 id 0 lun 1 return code = 8000002
          Sense class 7, sense error 0, extended sense 7

Now when I try to fdisk the same card, it has forgotten the partition:

  # fdisk /dev/scsi/host0/bus0/target0/lun1/disc
  Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
  Building a new DOS disklabel. Changes will remain in memory only,
  until you decide to write them. After that, of course, the previous
  content won't be recoverable.


  Command (m for help): p

  Disk /dev/scsi/host0/bus0/target0/lun1/disc: 34 heads, 61 sectors, 1011 cylinders
  Units = cylinders of 2074 * 512 bytes

                                   Device Boot    Start       End    Blocks   Id  System

  Command (m for help): 

Any suggestions on how to troubleshoot this?  I've posted a more
verbose console output at http://www.rokulabs.com/phison-console.txt
and the shell that goes with it at http://www.rokulabs.com/phison-shell.txt.

Thanks,
Dave

