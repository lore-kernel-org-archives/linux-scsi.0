From: Mailing Lists <thelittleprince-lists@asteroid-b612.org>
Subject: Problems with Adaptec 39160
Date: Tue, 25 Mar 2003 08:45:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303250819080.31885-100000@mydns2.compustrat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (localhost [127.0.0.1])
	by mydns2.compustrat.com (Postfix) with ESMTP id 740AD7E0A
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2003 08:45:04 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


BACKGROUND:
I've installed a Adaptec 39160 in a customer's RH 8.0 machine. The 39160 
came with a Dell PowerVault 128T we bought for them to back up around 
800G. The machine is a Supermicro quad P3/700/Xeon, 4G ram, AMI megaraid 
raid5 off-board (OS), Adaptec 7899(?) on-board (connected to a Promise 
raid 5 ext. array), and the 39160 card (Powervault on Ch. A), 2.4.20 
vanilla (compiled-in SCSI drivers)


PROBLEM:
Get errors (below) trying to do test back ups (about 200MB) (using Backup 
Professional). (Side Note: if anyone has suggestions for backup software 
to back up around 800G to this hardware with a failure complex rotation 
scheme, that'd be great)
Nothing has been changed on the 39160 card config/bios wise. On boot, it 
does recognize the 7200,Ultrium in the scan but then says "SCSI Bios not 
installed!" I'm not sure if this means anything or why this would happen? 
Can only 1 SCSI bios be installed at a time, and the detected 
onboard aic7899 takes precedence?


ERRORS:
-- Before Backup (various backup prog. tape accesses)
st0: Error with sense data: Current st09:00: sense key Not Ready
Additional sense indicates Medium not present
st0: Error with sense data: Current st09:00: sense key Not Ready
Additional sense indicates Medium not present
st0: Error with sense data: Current st09:00: sense key Not Ready
Additional sense indicates Medium not present
st0: Block limits 1 - 16777215 bytes.

-- During Backup (prog. doing backup right to drive (st0) not 
through jukebox/changer access (sg2))
scsi1:0:1:0: Attempting to queue an ABORT message
scsi1: Dumping Card State in Data-out phase, at SEQADDR 0x55
ACCUM = 0x0, SINDEX = 0x18, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0
SCSISEQ = 0x12, SBLKCTL = 0xa
 DFCNTRL = 0x2c, DFSTATUS = 0x0
LASTPHASE = 0x0, SCSISIGI = 0x4, SXFRCTL0 = 0x80
SSTAT0 = 0x0, SSTAT1 = 0x0
SCSIPHASE = 0x0
STACK == 0x8b, 0x0, 0x167, 0x64
SCB count = 4
Kernel NEXTQSCB = 3
Card NEXTQSCB = 3
QINFIFO entries:
Waiting Queue entries:
Disconnected Queue entries:
QOUTFIFO entries:
Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 
20 21 2
2 23 24 25 26 27 28 29 30 31
Sequencer SCB Info: 0(c 0x40, s 0x17, l 0, t 0x2) 1(c 0x0, s 0xff, l 255, 
t 0xff
) 2(c 0x0, s 0xff, l 255, t 0xff) 3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, 
s 0xf
f, l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, 
t 0xff
) 7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, 
s 0xf
f, l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 
255, t 0x
ff) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff) 14(c 
0x0,
s 0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, 
l 255,
 t 0xff) 17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 
19(c
0x0, s 0xff, l 255, t 0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 
0xff, l
 255, t 0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t 
0xff)
24(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t 0xff) 26(c 
0x0, s 0x
ff, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t 0xff) 28(c 0x0, s 0xff, l 
255, t 0
xff) 29(c 0x0, s 0xff, l 255, t 0xff) 30(c 0x0, s 0xff, l 255, t 0xff) 
31(c 0x0,
 s 0xff, l 255, t 0xff)
Pending list: 2(c 0x40, s 0x17, l 0)
Kernel Free SCB list: 1 0
Untagged Q(1): 2
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
scsi1:0:1:0: Device is active, asserting ATN
Recovery code sleeping
Recovery code awake
Timer Expired
aic7xxx_abort returns 0x2003
scsi1:0:1:0: Attempting to queue a TARGET RESET message
aic7xxx_dev_reset returns 0x2003
Recovery SCB completes
scsi: device set offline - not ready or command retry failed after bus 
reset: host 1 channel 0 id 1 lun 0
st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
st0: Error on write filemark.
st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).


DEVICE/BOOT INFO:
SCSI subsystem driver Revision: 1.00
scsi: host order: megaraid:aic7xxx
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

blk: queue f7a09e18, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: HP        Model: C7200             Rev: 141D
  Type:   Medium Changer                     ANSI SCSI revision: 03
blk: queue f7a09c18, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: HP        Model: Ultrium 1-SCSI    Rev: E15V
  Type:   Sequential-Access                  ANSI SCSI revision: 03
blk: queue f7a09818, I/O limit 524287Mb (mask 0x7fffffffff)
(scsi1:A:1): 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
  Vendor: Promise   Model: 8 Disk RAID5      Rev: 1.10
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f77ee818, I/O limit 524287Mb (mask 0x7fffffffff)
(scsi4:A:1): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
scsi4:A:1:0: Tagged Queuing enabled.  Depth 253
megaraid: v1.18 (Release Date: Thu Oct 11 15:02:53 EDT 2001)
megaraid: found 0x8086:0x1960:idx 0:bus 1:slot 3:func 1
scsi0 : Found a MegaRAID controller at 0xf8817000, IRQ: 20
megaraid: [GH6E:1.48] detected 1 logical drives
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID GH6E 254 commands 16 targs 4 chans 7 luns
scsi0: scanning channel 0 for devices.
  Vendor: SUPER     Model: GEM354 REV001     Rev: 1.04
  Type:   Processor                          ANSI SCSI revision: 02
blk: queue f75dda18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning virtual channel 1 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID5 05006R  Rev: GH6E
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue f75d9618, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning virtual channel 2 for logical drives.
scsi0: scanning virtual channel 3 for logical drives.
scsi0: scanning virtual channel 4 for logical drives.
st: Version 20020805, bufsize 32768, wrt 30720, max init. bufs 4, s/g segs 
16
Attached scsi tape st0 at scsi1, channel 0, id 1, lun 0
Attached scsi disk sda at scsi0, channel 1, id 0, lun 0
Attached scsi disk sdb at scsi4, channel 0, id 1, lun 0
SCSI device sda: 215052288 512-byte hdwr sectors (110107 MB)
Partition check:
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 > sda4
SCSI device sdb: 1626952320 512-byte hdwr sectors (-266511 MB)
 sdb: sdb1 sdb2 sdb3
Attached scsi generic sg0 at scsi0, channel 0, id 6, lun 0,  type 3
Attached scsi generic sg2 at scsi1, channel 0, id 0, lun 0,  type 8


/PROC/SCSI/AIX7XXX/*
::::::::::::::
1
::::::::::::::
Adaptec AIC7xxx driver version: 6.2.8
aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xb8f4 0x7c5d 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x934e

Channel A Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
        Goal: 3.300MB/s transfers
        Curr: 3.300MB/s transfers
        Channel A Target 0 Lun 0 Settings
                Commands Queued 31
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Channel A Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
        Goal: 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
        Curr: 3.300MB/s transfers
        Channel A Target 1 Lun 0 Settings
                Commands Queued 7917
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Channel A Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
::::::::::::::
2
::::::::::::::
Adaptec AIC7xxx driver version: 6.2.8
aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xb8f4 0x7c5d 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x934e

Channel A Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
::::::::::::::
3
::::::::::::::
Adaptec AIC7xxx driver version: 6.2.8
aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0x58f4 0x5c5e 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x134f

Channel A Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
::::::::::::::
4
::::::::::::::
Adaptec AIC7xxx driver version: 6.2.8
aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0x58f4 0x5c5e 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x134f

Channel A Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
        Channel A Target 1 Lun 0 Settings
                Commands Queued 45225
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Channel A Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
Channel A Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)


/PROC/SCSI/SG/*
::::::::::::::
allow_dio
::::::::::::::
0
::::::::::::::
debug
::::::::::::::
dev_max(currently)=11 max_active_device=5 (origin 1)
 scsi_dma_free_sectors=2224 sg_pool_secs_aval=320 def_reserved_size=32768
::::::::::::::
def_reserved_size
::::::::::::::
32768
::::::::::::::
device_hdr
::::::::::::::
host    chan    id      lun     type    opens   qdepth  busy    online
::::::::::::::
device_strs
::::::::::::::
SUPER           GEM354 REV001           1.04
MegaRAID        LD0 RAID5 05006R        GH6E
HP              C7200                   141D
HP              Ultrium 1-SCSI          E15V
Promise         8 Disk RAID5            1.10
::::::::::::::
devices
::::::::::::::
0       0       6       0       3       0       63      0       1
0       1       0       0       0       10      63      0       1
1       0       0       0       8       0       2       0       1
1       0       1       0       1       0       2       0       0
4       0       1       0       0       3       253     0       1
::::::::::::::
host_hdr
::::::::::::::
uid     busy    cpl     scatg   isa     emul
::::::::::::::
host_strs
::::::::::::::
LSI Logic MegaRAID GH6E 254 commands 16 targs 4 chans 7 luns
Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8         <Adaptec 
3960D U
ltra160 SCSI adapter>         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 
32/25
3 SCBs
Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8         <Adaptec 
3960D U
ltra160 SCSI adapter>         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 
32/25
3 SCBs
Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8         <Adaptec 
aic7899
 Ultra160 SCSI adapter>         aic7899: Ultra160 Wide Channel A, SCSI 
Id=7, 32/
253 SCBs
Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8         <Adaptec 
aic7899
 Ultra160 SCSI adapter>         aic7899: Ultra160 Wide Channel B, SCSI 
Id=7, 32/
253 SCBs
::::::::::::::
hosts
::::::::::::::
281     0       63      26      0       0
0       0       2       128     0       0
1       0       2       128     0       0
2       0       2       128     0       0
3       0       2       128     0       0
::::::::::::::
version
::::::::::::::
30124   Version: 3.1.24 (20020505)



Thanx!

-Tony




