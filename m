From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 21 Sep 2009 11:26:54 +0100
Message-ID: <20090921102654.GD8789@arachsys.com>
References: <4AADF471.2020801@suse.de>
 <4AAE3B9A.2060306@rtr.ca>
 <4AAE3F86.8090804@suse.de>
 <4AAE524C.2030401@rtr.ca>
 <20090916231921.GL1924@arachsys.com>
 <4AB239C8.2020203@rtr.ca>
 <4AB25736.1060601@suse.de>
 <4AB260CA.8040308@rtr.ca>
 <4AB2610F.8010904@rtr.ca>
 <20090918170517.GI2141@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:59536 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZIUKbn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2009 06:31:43 -0400
Content-Disposition: inline
In-Reply-To: <20090918170517.GI2141@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

Chris Webb <chris@arachsys.com> writes:

> Mark Lord <liml@rtr.ca> writes:
> 
> > Speaking of which..
> > 
> > Chris:  I wonder if the errors will also vanish in your situation
> > by disabling the onboard write-caches in the drives ?
> > 
> > Eg.  hdparm -W0 /dev/sd?
> 
> Hi Mark. I've got a test machine on its way at the moment, so I'll make sure
> I check this one out on it too.

Our test machine is still being built, but we had an opportunity to try this on
a couple of the live machines when their RAID arrays failed over the weekend.
We still got timeouts, but (predictably!) they're not on flushes any more:

  ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata2.00: cmd 35/00:08:98:c6:00/00:00:4e:00:00/e0 tag 0 dm
          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  ata2.00: configured for UDMA/33
  ata2: EH complete
  [...] 
  ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata2.00: cmd 35/00:08:18:94:68/00:00:3d:00:00/e0 tag 0 dm
          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  ata2.00: configured for UDMA/33
  ata2: EH complete
  [...]

all the way through the night.

I also have these in the log, but they are immediately after turning off the
write caching in all drives, so may be a red herring with data still being
written out.

  ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata2.00: cmd c8/00:08:00:20:80/00:00:00:00:00/e0 tag 0 dm
          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  ata2.00: configured for UDMA/133
  ata2: EH complete
  ata2.00: limiting speed to UDMA/100:PIO4
  ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata2.00: cmd 25/00:08:80:3e:2d/00:00:4e:00:00/e0 tag 0 dm
          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: link is slow to respond, please be patient (ready=0
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  ata2.00: configured for UDMA/100
  ata2: EH complete

On another machine, I saw this with write caching turned off:

  ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
  ata2.00: cmd 61/08:00:28:1f:80/00:00:00:00:00/40 tag 0 ncq 4096 out
           res 40/00:00:40:1f:80/00:00:00:00:00/40 Emask 0x4 (timeout)
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata2.00: configured for UDMA/133
  ata2: EH complete
  ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
  ata2.00: cmd 61/08:00:28:1f:80/00:00:00:00:00/40 tag 0 ncq 4096 out
           res 40/00:00:20:1f:80/00:00:00:00:00/40 Emask 0x4 (timeout)
  ata2.00: status: { DRDY }
  ata2: hard resetting link
  ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata2.00: qc timeout (cmd 0xef)
  ata2.00: failed to set xfermode (err_mask=0x4)
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: link is slow to respond, please be patient (ready=0)
  ata2: softreset failed (device not ready)
  ata2: limiting SATA link speed to 1.5 Gbps
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: reset failed, giving up
  ata2.00: disabled
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: link is slow to respond, please be patient (ready=0)
  ata2: softreset failed (device not ready)
  ata2: hard resetting link
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
  ata2: EH complete
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 8396584
  end_request: I/O error, dev sdb, sector 8396584
  md: super_written gets error=-5, uptodate=0
  raid1: Disk failure on sdb1, disabling device.
  raid1: Operation continuing on 5 devices.
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 8396632
  end_request: I/O error, dev sdb, sector 8396632
  md: super_written gets error=-5, uptodate=0
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 654934840
  raid10: sdb3: rescheduling sector 1788594488
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 1311583568
  raid10: Disk failure on sdb3, disabling device.
  raid10: Operation continuing on 3 devices.
  Buffer I/O error on device dm-51, logical block 31930
  lost page write due to I/O error on dm-51
  Buffer I/O error on device dm-51, logical block 31931
  lost page write due to I/O error on dm-51
  Buffer I/O error on device dm-51, logical block 31932
  lost page write due to I/O error on dm-51
  Buffer I/O error on device dm-51, logical block 31933
  lost page write due to I/O error on dm-51
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 1465147272
  end_request: I/O error, dev sdb, sector 1465147272
  md: super_written gets error=-5, uptodate=0
  sd 1:0:0:0: [sdb] Unhandled error code
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  end_request: I/O error, dev sdb, sector 8396584
  end_request: I/O error, dev sdb, sector 8396584
  md: super_written gets error=-5, uptodate=0
  sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  sd 1:0:0:0: [sdb] Sense not available.
  sd 1:0:0:0: [sdb] READ CAPACITY failed
  sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
  sd 1:0:0:0: [sdb] Sense not available.
  sd 1:0:0:0: [sdb] Asking for cache data failed
  sd 1:0:0:0: [sdb] Assuming drive cache: write through
  sdb: detected capacity change from 750156374016 to 0
  raid10: sdb: unrecoverable I/O read error for block 1788594488
  Buffer I/O error on device dm-59, logical block 204023
  Buffer I/O error on device dm-59, logical block 204023
  Buffer I/O error on device dm-43, logical block 24845
  lost page write due to I/O error on dm-43
  Buffer I/O error on device dm-62, logical block 558722
  lost page write due to I/O error on dm-62
  Buffer I/O error on device dm-43, logical block 24846
  lost page write due to I/O error on dm-43
  RAID1 conf printout:
   --- wd:5 rd:6
   disk 0, wo:0, o:1, dev:sda1
   disk 1, wo:1, o:0, dev:sdb1
   disk 2, wo:0, o:1, dev:sdc1
  RAID1 conf printout:
   --- wd:5 rd:6
   disk 0, wo:0, o:1, dev:sda1
   disk 2, wo:0, o:1, dev:sdc1
   disk 3, wo:0, o:1, dev:sdd1
   disk 4, wo:0, o:1, dev:sde1
   disk 5, wo:0, o:1, dev:sdf1
  raid10: Disk failure on sdb2, disabling device.
  raid10: Operation continuing on 3 devices.
  raid10: sdb: unrecoverable I/O read error for block 0
  RAID10 conf printout:
   --- wd:3 rd:6
   disk 1, wo:1, o:0, dev:sdb2
   disk 2, wo:0, o:1, dev:sdc2
   disk 3, wo:0, o:1, dev:sdd2
   disk 5, wo:0, o:1, dev:sdf2
  RAID10 conf printout:
   --- wd:3 rd:6
   disk 2, wo:0, o:1, dev:sdc2
   disk 3, wo:0, o:1, dev:sdd2
   disk 5, wo:0, o:1, dev:sdf2
  md: md2: resync done.
  RAID10 conf printout:
   --- wd:3 rd:6
   disk 1, wo:1, o:0, dev:sdb3
   disk 2, wo:0, o:1, dev:sdc3
   disk 3, wo:0, o:1, dev:sdd3
   disk 5, wo:0, o:1, dev:sdf3
  RAID10 conf printout:
   --- wd:3 rd:6
   disk 2, wo:0, o:1, dev:sdc3
   disk 3, wo:0, o:1, dev:sdd3
   disk 5, wo:0, o:1, dev:sdf3

Cheers,

Chris.
