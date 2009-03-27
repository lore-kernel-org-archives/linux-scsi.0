From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [eSATA] 2.6.28.7: IO errors
Date: Sat, 28 Mar 2009 00:18:38 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0903280001020.4635@axis700.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753116AbZC0XSi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 19:18:38 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1LnLJu-000321-3T
	for linux-scsi@vger.kernel.org; Sat, 28 Mar 2009 00:18:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm using an external eSATA / USB / Firewire 2x1T RAID from WD in RAID1 
configuration for backups with ext4 under 2.6.28.7. I've got a couple of 
problems with it before, and today a backup aborted with error messages 
below. Actually, those errors come from two backup attempts: the first one 
over NFS, and the second one locally. The system is one year old with an 
Intel chipset:

00:00.0 Host bridge: Intel Corporation Unknown device 29b0 (rev 02)

with a Core-2D 2.66GHz, so, it does have 3Gbps SATA, and below the driver 
drops down to 1.5Gbps.

The problems I had before with the disk were, that it has a badly built 
eSATA connector, the connector doesn't sit firmly enough in it. So, the 
main question, I guess - cann errors below be caused by that? I think, 
I'll have to contact WD for an update, or use Firewire for now...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer


ata4.00: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x6 frozen
ata4: SError: { HostInt 10B8B }
ata4.00: cmd 35/00:f8:27:87:4a/00:03:09:00:00/e0 tag 0 dma 520192 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 300)
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata4: irq_stat 0x00000040, connection status changed
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
nfsd: last server has exited, flushing export cache
EXT4-fs: mballoc: 517405 blocks 709 reqs (308 success)
EXT4-fs: mballoc: 656 extents scanned, 582 goal hits, 77 2^N hits, 0 breaks, 0 lost
EXT4-fs: mballoc: 99 generated and it took 850048
EXT4-fs: mballoc: 443177 preallocated, 441245 discarded
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period

[here starts the local backup almost an hour later]

EXT4-fs: barriers enabled
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sdb1, internal journal on sdb1:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem with ordered data mode.
ata4.00: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x6 frozen
ata4: SError: { HostInt 10B8B }
ata4.00: cmd 35/00:00:4f:98:44/00:04:31:00:00/e0 tag 0 dma 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 300)
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata4: irq_stat 0x00000040, connection status changed
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x6 frozen
ata4: SError: { HostInt 10B8B }
ata4.00: cmd 35/00:00:87:51:47/00:04:31:00:00/e0 tag 0 dma 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4: limiting SATA link speed to 1.5 Gbps
ata4.00: exception Emask 0x40 SAct 0x0 SErr 0x80800 action 0x6 frozen
ata4: SError: { HostInt 10B8B }
ata4.00: cmd 35/00:00:af:ad:05/00:04:09:00:00/e0 tag 0 dma 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdb] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: exception Emask 0x50 SAct 0x0 SErr 0x280900 action 0x6 frozen
ata4.00: irq_stat 0x08000000, interface fatal error
ata4: SError: { UnrecovData HostInt 10B8B BadCRC }
ata4.00: cmd c8/00:08:57:97:08/00:00:00:00:00/e9 tag 0 dma 4096 in
         res 50/00:00:36:06:34/00:00:01:00:00/41 Emask 0x50 (ATA bus error)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 310)
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 310)
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 310)
ata4.00: disabled
ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
ata4: irq_stat 0x00400040, connection status changed
ata4: hard resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-6: WD      My Book         1105, 1010, max UDMA/133
ata4.00: 1953508784 sectors, multi 0: LBA48
ata4.00: configured for UDMA/133
sd 3:0:0:0: [sdb] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 3:0:0:0: [sdb] Sense Key : Aborted Command [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        01 34 06 36
sd 3:0:0:0: [sdb] Add. Sense: No additional sense information
end_request: I/O error, dev sdb, sector 151557975
sd 3:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 2099128
lost page write due to I/O error on sdb1
Buffer I/O error on device sdb1, logical block 2099129
lost page write due to I/O error on sdb1
Buffer I/O error on device sdb1, logical block 2099130
lost page write due to I/O error on sdb1
Buffer I/O error on device sdb1, logical block 2099131
lost page write due to I/O error on sdb1
Buffer I/O error on device sdb1, logical block 2099132
lost page write due to I/O error on sdb1
sd 3:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 2101059
lost page write due to I/O error on sdb1
sd 3:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 2101205
lost page write due to I/O error on sdb1
sd 3:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 2104385
lost page write due to I/O error on sdb1
Buffer I/O error on device sdb1, logical block 2104386
lost page write due to I/O error on sdb1
sd 3:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb1, logical block 2104398
lost page write due to I/O error on sdb1
sd 3:0:0:0: rejecting I/O to offline device

[last message repeated multiple times]

sd 3:0:0:0: rejecting I/O to offline device
ata4: EH complete
sd 3:0:0:0: rejecting I/O to offline device
sd 3:0:0:0: rejecting I/O to offline device
EXT4-fs error (device sdb1): ext4_find_entry: reading directory #4741319 offset 0
sd 3:0:0:0: rejecting I/O to offline device
ext4: I/O error while writing superblock for sdb1.
sd 3:0:0:0: rejecting I/O to offline device

[repeated again]

sd 3:0:0:0: rejecting I/O to offline device
ata4.00: detaching (SCSI 3:0:0:0)
Aborting journal on device sdb1:8.
JBD2: I/O error detected when updating journal superblock for sdb1:8.
journal commit I/O error
EXT4-fs error (device sdb1): ext4_find_entry: reading directory #2 offset 0
ext4: I/O error while writing superblock for sdb1.
sd 3:0:0:0: [sdb] Synchronizing SCSI cache
sd 3:0:0:0: [sdb] Stopping disk
scsi 3:0:0:0: Direct-Access     ATA      WD      My Book  1010 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 1953508784 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
