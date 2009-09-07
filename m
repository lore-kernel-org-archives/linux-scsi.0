From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 7 Sep 2009 12:44:42 +0100
Message-ID: <20090907114442.GG18831@arachsys.com>
References: <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:42726 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZIGLor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 07:44:47 -0400
Content-Disposition: inline
In-Reply-To: <4A9BC023.10903@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

Sorry for the late follow up to this thread, but I'm also seeing symptoms that
look identical to these and would be grateful for any advice. I think I can
reasonably rule out a single faulty drive, controller or cabling set as I'm
seeing it across a cluster of Supermicro machines with six Seagate ST3750523AS
SATA drives in each and the drive that times out is apparently randomly
distributed across the cluster. (Of course, since the hardware is identical, it
could still be a hardware design or firmware problem.)

We're running x86-64 2.6.30.5 (and previously 2.6.30.4 where we also saw the
problem) with these drives on top of an on-motherboard ahci controller:

  ahci 0000:00:1f.2: version 3.0
    alloc irq_desc for 19 on cpu 0 node 0
    alloc kstat_irqs on cpu 0 node 0
  ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
  ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
  ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part 
  ahci 0000:00:1f.2: setting latency timer to 64
  scsi0 : ahci
  scsi1 : ahci
  scsi2 : ahci
  scsi3 : ahci
  scsi4 : ahci
  scsi5 : ahci
  ata1: SATA max UDMA/133 abar m1024@0xd8500400 port 0xd8500500 irq 19
  ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
  ata3: SATA max UDMA/133 irq 19
  ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
  ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
  ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
  [...]
  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata1.00: ATA-8: ST3750523AS, CC34, max UDMA/133
  ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
  ata1.00: configured for UDMA/133
  scsi 0:0:0:0: Direct-Access     ATA      ST3750523AS      CC34 PQ: 0 ANSI: 5
  sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
   sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
   sda1 sda2 sda3
  sd 0:0:0:0: [sda] Attached SCSI disk
  [etc]

These machines host large numbers of kvm virtual machines and have three RAID
arrays, a RAID1 of /dev/sd[abcdef]1 for /, a RAID10 of /dev/sd[abcdef]2 for
swap and a large RAID10 of /dev/sd[abcdef]3 which is used as an LVM2 PV, out of
which the virtual drives are carved.

Everything will be running fine when suddenly:

  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
          res 40/00:00:80:17:91/00:00:37:00:00/40 Emask 0x4 (timeout)
  ata1.00: status: { DRDY }
  ata1: hard resetting link
  ata1: softreset failed (device not ready)
  ata1: hard resetting link
  ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  ata1.00: configured for UDMA/133
  ata1: EH complete
  end_request: I/O error, dev sda, sector 1465147272
  md: super_written gets error=-5, uptodate=0
  raid10: Disk failure on sda3, disabling device.
  raid10: Operation continuing on 5 devices.

The drive shows no errors in the SMART log, it doesn't really have any read or
write problems at 1465147272 (verified with O_DIRECT dd), and the reallocated
sector count is still zero. mdadm --remove and mdadm --add on the component
bring everything back to life fine.

I'm using the deadline IO scheduler with default 5s timeout value for these
disks, in case that could be part of the problem? LVM2 does O_DIRECT reads and
writes to the md array to manipulate its metadata, and my virtual machines are
doing quite a lot of IO to the logical volumes too, which they open O_SYNC, so
the arrays are reasonably heavily loaded.

I think there are two things that concern me here. One is obviously that the
timeouts and resets are happening at all and I'd like to get to the bottom
of this. However, the other is that the response to a SCSI disk having to be
reset is to chuck it out of the array even though it'll be fine following
the reset! I'd very much like to stop this happening somehow.

A couple of other problems I'm seeing, which may be connected, and make this
problem more painful...

Perhaps it's inevitable because of the IO load the machine is under, but I
find I need to set /proc/sys/dev/raid/speed_limit_min right down to 0 before
any resync or all disk accesses seem to deadlock completely, including the
RAID resync itself. In this state, all attempts to dd even a single block
from /dev/md2 will hang forever. With the speed limit minimum reduced to 0,
resync proceeds fine most of the time, occasionally dropping down to zero
speed when other IO is going on (which is fine), but apparently not
deadlocking.

I have a bitmap on the array, but sometimes when I remove and re-add a
failed component, it doesn't seem to use the bitmap and does a lengthy full
recovery instead. One example that's ongoing at the moment:-

      [=>...................]  recovery =  5.7% (40219648/703205312) finish=7546.3min speed=1463K/sec
      bitmap: 34/126 pages [136KB], 8192KB chunk

which is rather painful and has to be throttled back with speed_limit_max to
avoid the virtual machines running on top of it from having extremely poor IO
latency.

Best wishes,

Chris.
