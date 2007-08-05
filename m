From: "Paul Bright" <Paul.Bright@gossinteractive.com>
Subject: Megaraid2: Dell PERC 4/DC connected to Dell Powervault 220S, poor performance.
Date: Sun, 5 Aug 2007 13:05:03 +0100
Message-ID: <798CB1570E93D245815FC1545D41FBA24AD3E8@Paperboy.lan.gossinteractive.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.gossinteractive.com ([212.104.154.111]:2903 "EHLO
	relay.gossinteractive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbXHEM0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 08:26:21 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
 
Im wondering if anyone can help me out with the megaraid2 driver.  Ive
got a Dell PERC 4/DC connected to a Dell powervault 220S, cluster mode
is enabled (write cache OFF) because eventually there will be two
machines connected to the powervault for shared scsi.  Ive tried the
Dell PERC 4 card in 2 different servers; a Dell 1850 and currently its
all set up on a Dual P3 1Ghz and I get the same results with each
server.
 
Ive tried a few recent 2.6 kernels but currently Im running kernel
2.6.21.5.  The problem is that the performance of this set up is
incredibly poor.  Ive done some experimenting with the megaraid2 module
params (Ive set cmd_per_lun=126 and max_sectors=1024 after reading
various forum posts) and managed to get the transfer rate up a bit but
it still performs very badly.  I see some "reservation conflict" and
"unit not ready" messages when the megaraid2 module loads which I am
unsure of.
 
After doing some googling I found someone saying that the megaraid2
driver in kernel 2.4.31 is the only version that they got any decent
performance out of the Dell PERC 4.  I tried kernel 2.4.31 and indeed
the performance is much more like what you would expect (only thing I
have to go by is a windows box with a PERC 4 in it).   Ive tested both
kernel 2.4.31 and 2.6.21.5 with our application, dd, bonnie and iozone
on RAID 5 and RAID 1 arrays - kernel 2.4.31 performs better in each
case.   The partitions are formatted as ext3 but Ive tried a few other
filesystems such as XFS with various options and Im getting similar
differences between the results for each kernel.
 
Heres an example comparison of bonnie benchmark results when using
kernel 2.4.31 and kernel 2.6.21.5, I used the following command; bonnie
-d ./ -s 512 -r 256 -x 5 -u 0 -g 0
 
 
Kernel 2.4.31 / RAID 5
----------------------
Version  1.03      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
saasfs1        512M 11324  99 27539  27  6236   6  9113  67 42385  15
1392.7   4
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
saasfs1          16   686  97 +++++ +++ +++++ +++   635  96 +++++ +++
2097  88
 
 
Kernel 2.6.21.5 / RAID 5
------------------------
Version  1.03      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
saasfs1        512M 10357  64 10649  12  4957   5 11079  59 72623  39
1761.0   4
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
saasfs1          16 19748  96 +++++ +++ 27202 100 20052  97 +++++ +++
26070  99
 
 
 
Kernel 2.4.31 / RAID 1
----------------------
Version  1.03      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
saasfs1        512M 11303  99 44858  45 12319  10  8862  65 51459  17
2201.2   7
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
saasfs1          16   631  96 +++++ +++ +++++ +++   621  94 +++++ +++
2349  97
 
 
Kernel 2.6.21.5 / RAID 1
------------------------
Version  1.03      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
saasfs1        512M 15803  98 29338  34 10693  10 14016  75 95105  49
2172.1   5
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
saasfs1          16   651  98 +++++ +++ +++++ +++   631  97 +++++ +++
2137  96
 
 

I dont really want to have to stick with kernel 2.4.31 so if anyone
could shed some light on this issue it would be much appreciated.  Maybe
Ive got the values Im passing into the module parameters completely
wrong or theres something else I need to tweak to get the Dell PERC 4 to
work better with the kernel 2.6 megaraid2 driver.
 
Just below Ive put together the details of the scsi raid card and both
kernels 2.4.31 and 2.6.21.5 (including kernel options, megaraid version,
modprobe command, relevent dmesg and lspci output).  Im willing to do
any testing if necessary.
 
Thanks,
Paul Bright.
 
 
 
SCSI RAID
---------
Card: Dell PERC4/DC
Card firmware: 352B
Card BIOS Ver: 1.10
Card DRAM: 128MB
Card Config:
 - Cluster Mode: enabled (write cache off - there will be two machines
connected to the JBOD)
 - Emulation: mass storage
 - SCSI transfer rate: 320M
 
JBOD: Dell PowerVault 220S
JBOD Firmware:  E19
 
RAID Config for testing:
/dev/sdb: RAID 5 - 3 Drives
/dev/sdc: RAID 1 - 2 Drives

 
--------------
Kernel: 2.4.31
--------------
Kernel options: pci=noacpi
Megaraid: v2.10.8.2 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
modprobe command:  modprobe megaraid2 max_cmd_per_lun=126
max_sectors_per_io=1024
 
 
dmesg output
------------
megaraid: v2.10.8.2 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
megaraid: found 0x1000:0x1960:bus 0:slot 11:func 0
scsi2:Found MegaRAID controller at 0xe09d6000, IRQ:7
megaraid: [352B:1.10] detected 2 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: Cluster driver, initiator id:7
megaraid: no BIOS enabled.
scsi2 : LSI Logic MegaRAID 352B 254 commands 16 targs 5 chans 7 luns
scsi2: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID5  139G  Rev: 352B
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: MegaRAID  Model: LD 1 RAID1   69G  Rev: 352B
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi2: scanning scsi channel 1 for logical drives.
scsi2: scanning scsi channel 2 for logical drives.
scsi2: scanning scsi channel 3 for logical drives.
scsi2: scanning scsi channel 4 [P0] for physical devices.
scsi2: scanning scsi channel 5 [P1] for physical devices.
Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
Attached scsi disk sdc at scsi2, channel 0, id 1, lun 0
scsi2 (0,0,0) : RESERVATION CONFLICT
scsi2 (0,0,0) : RESERVATION CONFLICT
scsi2 (0,0,0) : RESERVATION CONFLICT
sdb: Unit Not Ready, error = 0x70018
SCSI device sdb: 286228480 512-byte hdwr sectors (146549 MB)
 /dev/scsi/host2/bus0/target0/lun0: p1
scsi2 (0,1,0) : RESERVATION CONFLICT
scsi2 (0,1,0) : RESERVATION CONFLICT
scsi2 (0,1,0) : RESERVATION CONFLICT
sdc: Unit Not Ready, error = 0x70018
SCSI device sdc: 143114240 512-byte hdwr sectors (73274 MB)
 /dev/scsi/host2/bus0/target1/lun0: p1
 
 
lspci output
------------
0000:00:0b.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID
(rev 01)
        Subsystem: Dell MegaRAID 518 DELL PERC 4/DC RAID Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ 
 
FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- 
 
>SERR- <PERR-
        Latency: 64, Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 7
        Region 0: Memory at f4110000 (32-bit, prefetchable) [size=64K]
        Expansion ROM at <unassigned> [disabled] [size=64K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 
 
 
----------------
kernel: 2.6.21.5
----------------
kernel options: acpi=off elevator=cfq
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
modprobe command:  modprobe megaraid_mbox cmd_per_lun=126
max_sectors=1024
 
 
dmesg output
------------
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megaraid: probe new device 0x1000:0x1960:0x1028:0x0518: bus 0:slot
11:func 0
megaraid: fw version:[352B] bios version:[1.10]
megaraid: cluster firmware, initiator ID: 7
scsi3 : LSI Logic MegaRAID driver
scsi[3]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[3]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[3]: scanning scsi channel 2 [virtual] for logical drives
scsi 3:2:0:0: Direct-Access     MegaRAID LD 0 RAID5  139G 352B PQ: 0
ANSI: 2
sd 3:2:0:0: reservation conflict
sd 3:2:0:0: reservation conflict
sd 3:2:0:0: reservation conflict
sdb: Unit Not Ready, error = 0x70018
SCSI device sdb: 286228480 512-byte hdwr sectors (146549 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 00 00 00
sdb: asking for cache data failed
sdb: assuming drive cache: write through
sd 3:2:0:0: reservation conflict
sd 3:2:0:0: reservation conflict
sd 3:2:0:0: reservation conflict
sdb: Unit Not Ready, error = 0x70018
SCSI device sdb: 286228480 512-byte hdwr sectors (146549 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 00 00 00
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: sdb1
sd 3:2:0:0: Attached scsi disk sdb
sd 3:2:0:0: Attached scsi generic sg2 type 0
scsi 3:2:1:0: Direct-Access     MegaRAID LD 1 RAID1   69G 352B PQ: 0
ANSI: 2
sd 3:2:1:0: reservation conflict
sd 3:2:1:0: reservation conflict
sd 3:2:1:0: reservation conflict
sdc: Unit Not Ready, error = 0x70018
SCSI device sdc: 143114240 512-byte hdwr sectors (73274 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 00 00 00
sdc: asking for cache data failed
sdc: assuming drive cache: write through
sd 3:2:1:0: reservation conflict
sd 3:2:1:0: reservation conflict
sd 3:2:1:0: reservation conflict
sdc: Unit Not Ready, error = 0x70018
SCSI device sdc: 143114240 512-byte hdwr sectors (73274 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 00 00 00
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 sdc: sdc1
sd 3:2:1:0: Attached scsi disk sdc
sd 3:2:1:0: Attached scsi generic sg3 type 0
 
 
lspci output
------------
00:0b.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID (rev 01)
        Subsystem: Dell MegaRAID 518 DELL PERC 4/DC RAID Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ 
 
FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- 
 
>SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 7
        Region 0: Memory at f4110000 (32-bit, prefetchable) [size=64K]
        [virtual] Expansion ROM at 30120000 [disabled] [size=64K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 

 
 

Registered Office: c/o Bishop Fleming, Cobourg House, Mayflower Street, Plymouth, PL1 1LG.  Company Registration No: 3553908  

GOSS  a leading UK supplier of Enterprise Content Management solutions has won a place in the Deloitte Technology Fast 50 Awards 2006 for the third consecutive year.

This email contains proprietary information, some or all of which may be legally privileged. It is for the intended recipient only. If an addressing or transmission error has misdirected this email, please notify the author by replying to this email. If you are not the intended recipient you may not use, disclose, distribute, copy, print or rely on this email. 

 

Email transmission cannot be guaranteed to be secure or error free, as information may be intercepted, corrupted, lost, destroyed, arrive late or incomplete or contain viruses. This email and any files attached to it have been checked with virus detection software before transmission. You should nonetheless carry out your own virus check before opening any attachment. GOSS Interactive Ltd accepts no liability for any loss or damage that may be caused by software viruses.


