From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Fri, 21 Mar 2008 06:35:26 -0700 (PDT)
Message-ID: <20080321133526.D313210803D@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbYCUNf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 09:35:58 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2LDZS7W025208
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2008 06:35:29 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #26 from lkmlist@gmail.com  2008-03-21 06:35 -------
To make it short:

Attach drive for the first time: --> sdb1
The disk works, I can access it.

When I remove it is removed... somehow... but It looks like there is a ghost
disk added (still with the kernelname sdb1) but not accessible (of couse.. I
hold the disk in my hand...).

replugging the same device doesn't fix the problem and does not work.

here's a short version of the above dmsg:

#######################################################################
#######################################################################
###########1) Hotpluging a disk for the first time#####################
#######################################################################
#######################################################################

Oct 30 02:33:09 freax [  951.885385] ata2: exception Emask 0x10 SAct 0x0 SErr
0x10000 action 0x2 frozen
Oct 30 02:33:09 freax [  951.885390] ata2: irq_stat 0x00400000, PHY RDY changed
Oct 30 02:33:09 freax [  951.885396] ata2: hard resetting port
Oct 30 02:33:09 freax [  952.607499] ata2: SATA link down (SStatus 0 SControl
.
.
.
Oct 30 02:33:23 freax [  965.906251] ata2: EH complete
Oct 30 02:33:23 freax [  965.906264] ata2.00: detaching (SCSI 1:0:0:0)
Oct 30 02:33:23 freax [  965.906524] sd 1:0:0:0: [sdb] Stopping disk
Oct 30 02:33:23 freax [  966.062277] scsi 1:0:0:0: Direct-Access     ATA     
External Disk 0  RGL1 PQ: 0 ANSI: 5
Oct 30 02:33:23 freax [  966.062415] sd 1:0:0:0: [sdb] 145226112 512-byte
hardware sectors (74356 MB)
Oct 30 02:33:23 freax [  966.062467] sd 1:0:0:0: [sdb] Write Protect is off
Oct 30 02:33:23 freax [  966.062502] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 30 02:33:23 freax [  966.062557] sd 1:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Oct 30 02:33:23 freax [  966.062646] sd 1:0:0:0: [sdb] 145226112 512-byte
hardware sectors (74356 MB)
Oct 30 02:33:23 freax [  966.062695] sd 1:0:0:0: [sdb] Write Protect is off
Oct 30 02:33:23 freax [  966.062729] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 30 02:33:23 freax [  966.062781] sd 1:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Oct 30 02:33:24 freax [  966.062956]  sdb: sdb1
Oct 30 02:33:24 freax [  966.984134] sd 1:0:0:0: [sdb] Attached SCSI disk
Oct 30 02:33:24 freax [  966.984218] sd 1:0:0:0: Attached scsi generic sg1 type
0

#######################################################################
#######################################################################
###########2) removing the disk shows the following:###################
#######################################################################
#######################################################################

Oct 30 02:34:47 freax [ 1050.239909] ata2: exception Emask 0x10 SAct 0x0 SErr
0x10000 action 0x2 frozen
Oct 30 02:34:47 freax [ 1050.239914] ata2: irq_stat 0x00400000, PHY RDY changed
Oct 30 02:34:47 freax [ 1050.239920] ata2: hard resetting port
Oct 30 02:34:48 freax [ 1050.961633] ata2: SATA link down (SStatus 0 SControl
300)
Oct 30 02:34:48 freax [ 1050.961642] ata2: failed to recover some devices,
retrying in 5 secs
Oct 30 02:34:53 freax [ 1055.952117] ata2: hard resetting port
Oct 30 02:34:53 freax [ 1056.256843] ata2: SATA link down (SStatus 0 SControl
.
.
.
Feb 17 16:30:44 freax [ 4312.842519]          res
51/04:00:01:01:80/00:00:00:00:00/a0 Emask 0x1 (device error)
Feb 17 16:30:44 freax [ 4312.842521] ata2.00: status: { DRDY ERR }
Feb 17 16:30:44 freax [ 4312.842523] ata2.00: error: { ABRT }
Feb 17 16:30:44 freax [ 4312.842589] ata2.00: device is on DMA blacklist,
disabling DMA
Feb 17 16:30:44 freax [ 4312.842662] ata2.00: configured for PIO4
Feb 17 16:30:44 freax [ 4312.842666] ata2: EH complete
Feb 17 16:30:44 freax [ 4312.842685] ata2.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x0
Feb 17 16:30:44 freax [ 4312.842687] ata2.00: irq_stat 0x40000001
Feb 17 16:30:44 freax [ 4312.842690] ata2.00: cmd
e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
.
.
.
Feb 17 16:30:47 freax [ 4315.384346] ata2.00: device is on DMA blacklist,
disabling DMA
Feb 17 16:30:47 freax [ 4315.384425] ata2.00: configured for PIO4
Feb 17 16:30:47 freax [ 4315.384430] ata2: EH complete
Feb 17 16:30:47 freax [ 4315.384437] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
Feb 17 16:30:47 freax [ 4315.384440] sd 1:0:0:0: [sdb] Sense Key : Aborted
Command [current] [descriptor]
Feb 17 16:30:47 freax [ 4315.384456] sd 1:0:0:0: [sdb] Add. Sense: No
additional sense information
Feb 17 16:30:47 freax [ 4315.384469] sd 1:0:0:0: [sdb] Stopping disk
Feb 17 16:30:47 freax [ 4315.384614] scsi 1:0:0:0: Direct-Access     ATA     
Config  Disk     RGL1 PQ: 0 ANSI: 5
Feb 17 16:30:47 freax [ 4315.384699] sd 1:0:0:0: [sdb] 640 512-byte hardware
sectors (0 MB)
Feb 17 16:30:47 freax [ 4315.384710] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:30:47 freax [ 4315.384712] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:30:47 freax [ 4315.384731] sd 1:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:30:47 freax [ 4315.384796] sd 1:0:0:0: [sdb] 640 512-byte hardware
sectors (0 MB)
Feb 17 16:30:47 freax [ 4315.384816] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:30:47 freax [ 4315.384827] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:30:47 freax [ 4315.384853] sd 1:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:30:47 freax [ 4315.384872]  sdb: unknown partition table
Feb 17 16:30:47 freax [ 4315.385908] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 17 16:30:47 freax [ 4315.385954] sd 1:0:0:0: Attached scsi generic sg1 type
0
Feb 17 16:30:47 freax [ 4315.385988] sd 1:0:0:0: [sdb] 640 512-byte hardware
sectors (0 MB)
Feb 17 16:30:47 freax [ 4315.385999] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:30:47 freax [ 4315.386001] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:30:47 freax [ 4315.386020] sd 1:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:30:47 freax [ 4315.921044] ata2.00: exception Emask 0x10 SAct 0x0
SErr 0x10000 action 0xa frozen
.
.
.
Feb 17 16:31:04 freax [ 4332.745067] Buffer I/O error on device sdb, logical
block 79
Feb 17 16:31:04 freax [ 4332.745074] ata2.00: detaching (SCSI 1:0:0:0)
Feb 17 16:31:04 freax [ 4332.745342] sd 1:0:0:0: [sdb] Stopping disk
Feb 17 16:31:04 freax [ 4332.745690] scsi 1:0:0:0: Direct-Access     ATA     
Config  Disk     RGL1 PQ: 0 ANSI: 5
Feb 17 16:31:04 freax [ 4332.745768] sd 1:0:0:0: [sdb] 640 512-byte hardware
sectors (0 MB)
Feb 17 16:31:04 freax [ 4332.745779] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:31:04 freax [ 4332.745781] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:31:04 freax [ 4332.745800] sd 1:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:31:04 freax [ 4332.745845] sd 1:0:0:0: [sdb] 640 512-byte hardware
sectors (0 MB)
Feb 17 16:31:04 freax [ 4332.745855] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:31:04 freax [ 4332.745857] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:31:04 freax [ 4332.745875] sd 1:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:31:04 freax [ 4332.745878]  sdb: unknown partition table
Feb 17 16:31:04 freax [ 4332.745959] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 17 16:31:04 freax [ 4332.745998] sd 1:0:0:0: Attached scsi generic sg1 type




#######################################################################
#######################################################################
###########3) replugging the SAME disk:################################
#######################################################################
#######################################################################

Feb 17 16:41:50 freax [ 4977.840074] ata2: exception Emask 0x10 SAct 0x0 SErr
0x10000 action 0xa frozen
Feb 17 16:41:50 freax [ 4977.840080] ata2: irq_stat 0x00400000, PHY RDY changed
Feb 17 16:41:50 freax [ 4977.840083] ata2: SError: { PHYRdyChg }
Feb 17 16:41:50 freax [ 4977.840091] ata2: hard resetting link
Feb 17 16:41:51 freax [ 4978.576507] ata2: SATA link down (SStatus 0 SControl
300)
Feb 17 16:41:51 freax [ 4978.576516] ata2: failed to recover some devices,
retrying in 5 secs
Feb 17 16:41:56 freax [ 4983.678479] ata2: hard resetting link
Feb 17 16:41:57 freax [ 4983.989543] ata2: SATA link down (SStatus 0 SControl
300)
Feb 17 16:41:57 freax [ 4983.989553] ata2: failed to recover some devices,
retrying in 5 secs
Feb 17 16:42:02 freax [ 4989.090894] ata2: hard resetting link
Feb 17 16:42:04 freax [ 4991.638546] ata2: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Feb 17 16:42:04 freax [ 4991.638619] ata2.00: model number mismatch 'Config 
Disk' != 'External Disk 0'
Feb 17 16:42:04 freax [ 4991.638622] ata2.00: revalidation failed (errno=-19)
Feb 17 16:42:04 freax [ 4991.638624] ata2.00: disabled
Feb 17 16:42:05 freax [ 4992.149526] ata2: hard resetting link
Feb 17 16:42:07 freax [ 4994.695718] ata2: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Feb 17 16:42:07 freax [ 4994.695802] ata2.00: ATA-6: External Disk 0, RGL10364,
max UDMA/133
Feb 17 16:42:07 freax [ 4994.695805] ata2.00: 1 sectors, multi 1: LBA48
Feb 17 16:42:07 freax [ 4994.695914] ata2.00: configured for UDMA/133
Feb 17 16:42:07 freax [ 4994.695922] ata2: exception Emask 0x10 SAct 0x0 SErr
0x0 action 0x9 t4
Feb 17 16:42:07 freax [ 4994.695924] ata2: irq_stat 0x00000040, connection
status changed
Feb 17 16:42:07 freax [ 4994.696084] ata2.00: configured for UDMA/133
Feb 17 16:42:07 freax [ 4994.696087] ata2: EH complete
Feb 17 16:42:07 freax [ 4994.696095] ata2.00: detaching (SCSI 1:0:0:0)
Feb 17 16:42:07 freax [ 4994.696345] sd 1:0:0:0: [sdb] Stopping disk
Feb 17 16:42:08 freax [ 4995.139171] scsi 1:0:0:0: Direct-Access     ATA     
External Disk 0  RGL1 PQ: 0 ANSI: 5
Feb 17 16:42:08 freax [ 4995.139390] sd 1:0:0:0: [sdb] 1 512-byte hardware
sectors (0 MB)
Feb 17 16:42:08 freax [ 4995.139402] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:42:08 freax [ 4995.139405] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:42:08 freax [ 4995.139423] sd 1:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:42:08 freax [ 4995.139472] sd 1:0:0:0: [sdb] 1 512-byte hardware
sectors (0 MB)
Feb 17 16:42:08 freax [ 4995.139483] sd 1:0:0:0: [sdb] Write Protect is off
Feb 17 16:42:08 freax [ 4995.139485] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 17 16:42:08 freax [ 4995.139503] sd 1:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Feb 17 16:42:09 freax [ 4995.139506]  sdb: sdb1
Feb 17 16:42:09 freax [ 4996.266625]  sdb: p1 exceeds device capacity
Feb 17 16:42:09 freax [ 4996.266734] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 17 16:42:09 freax [ 4996.266791] sd 1:0:0:0: Attached scsi generic sg1 type
0
Feb 17 16:42:09 freax [ 4996.281486] attempt to access beyond end of device
Feb 17 16:42:09 freax [ 4996.281491] sdb: rw=0, want=65, limit=1
Feb 17 16:42:09 freax [ 4996.281494] Buffer I/O error on device sdb1, logical
block 0
.
.
.
Feb 17 16:42:09 freax [ 4996.287815] attempt to access beyond end of device
Feb 17 16:42:09 freax [ 4996.287816] sdb: rw=0, want=71, limit=1


##################################################################
##################################################################

Thats it.


Regards
Bjoern


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
