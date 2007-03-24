From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: RE: MPT Fusion LSI22320 ,  Domain validation loops .
Date: Fri, 23 Mar 2007 22:09:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703232202020.21973@filesrv1.baby-dragons.com>
References: <664A4EBB07F29743873A87CF62C26D70650FD9@NAMAIL4.ad.lsil.com>
 <Pine.LNX.4.64.0703202347010.27070@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([204.91.156.41]:51937 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbXCXFJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Mar 2007 01:09:38 -0400
In-Reply-To: <Pine.LNX.4.64.0703202347010.27070@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

 	Hello Eric ,

On Tue, 20 Mar 2007, Mr. James W. Laferriere wrote:
> On Mon, 19 Mar 2007, Moore, Eric wrote:
>> On Saturday, March 17, 2007 2:33 PM,  James W. Laferriere wrote:
>>>  	Hello All ,  I am have been having this problem since I
>>> purchased the
>>> controller and after changing out the disks I thought were
>>> the problem .
>>>  	I am still getting the continous :
>>> 
>>> mptscsih: ioc1: attempting task abort! (sc=f7a64500)
>>> scsi 3:0:4:0:
>>>          command: Inquiry: 12 00 00 00 60 00
>>> mptbase: Initiating ioc1 recovery
>>> mptscsih: ioc1: task abort: SUCCESS (sc=f7a64500)
>>>   target3:0:4: Domain Validation detected failure, dropping back
>>>   target3:0:4: Domain Validation skipping write tests
>>>   target3:0:4: Ending Domain Validation
>>>   target3:0:4: asynchronous
>>>   target3:0:5: Beginning Domain Validation
>>> mptscsih: ioc0: attempting target reset! (sc=f7a64380)
>>>
>>>  	The acutual device id's change and the driver
>>> continously resets the
>>> busses & starts all over .
>>>
>>>  	The disks are in a HP DS-SL13R-BA 4354R 14drive ultra3
>>> racKmount cabinet
>>> w/ dualbus & dualps ,  Which seems to present a ID6 ,  That
>>> does not show up in
>>> any of the bus scans .
>>>
>>>  	Now I have previously had the same cabinet with 18gb
>>> disks which had the
>>> same problem with this controller .  BUT I also have a LSI
>>> Logic / Symbios
>>> Logic 53c1010 66MHz Ultra3 dual SCSI bus Adapter which works
>>> flawlessly with the
>>> 18gb disks in this very same cabinet .
>>>  	The cables for connecting the adapter(s) to tha cabinet
>>> are less than 24
>>> inches in length .
>>>
>>>  	Would anyone please shed some light on what it is I am
>>> doing wrong or
>>> need to do or ....?  Too have this controller recognise these
>>> disk drives in
>>> this cabinet .
>> 
>> There is a seperate mailing list for scsi releated issues, e.g.
>> linux-scsi@.   I've posted a patch to address your issue several times,
>> however it seems its not been picked up by the scsi subsystem
>> maintainer.   The last time it was posted was here:
>> http://marc.info/?l=linux-scsi&m=117089244809072&w=2   An alternative is
>> you could obtain our latest drivers from the LSI download site, where
>> these drivers should have this patch
>> http://www.lsilogic.com/cm/DownloadSearch.do.
>> 
>> Eric
>
> 	Hello Eric ,  Fyi ,  linux-2.6.21-rc4 + mpt-fusion(*) patches from 
> Andrew Morton's patch tree .  Still gives me the ever looping reset .  But I 
> have just found sometrhing of interest one of the Powersuplies in the 
> cabiinet 'May be' failing .  I have to test that to be satisfied that is the 
> case .
> 	I'll report back soon on the PS & please look into this .  There is 
> no reason for the driver to keep a system in loop over a failing drive set .
> 		Tia ,  JimL
> (*)
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/broken-out/mpt-fusion-handle-pci-layer-error-on-resume.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/broken-out/mpt-fusion-handle-mpt_resume-failure-while-resuming.patch

 	Fyi ,  I finally dug out that old LSI22915A controller I have & attached 
the HP racKmount cabinet with the 14 146GB disks & I am now looking at 14 New 
devices in my udev dev tree (**) .  After configuring in the SYM53C8xx_2 driver 
of course .
 	Tho ,  I'd sure like to use my LSI22320 in a stock kernel .

 		Tia ,  JimL

(**)
dmesg | egrep -C3 -i '(scsi|target).*[23]'
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Loading iSCSI transport class v2.0-724.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
         <Adaptec AIC7902 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
scsi 0:0:0:0: Direct-Access     COMPAQ   BB01811C9C       3B07 PQ: 0 ANSI: 2
  target0:0:0: asynchronous
scsi0:A:0:0: Tagged Queuing enabled.  Depth 4
  target0:0:0: Beginning Domain Validation
  target0:0:0: wide asynchronous
  target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
  target0:0:0: Domain Validation skipping write tests
  target0:0:0: Ending Domain Validation
scsi 0:0:1:0: Direct-Access     COMPAQ   BB01811C9C       3B07 PQ: 0 ANSI: 2
  target0:0:1: asynchronous
scsi0:A:1:0: Tagged Queuing enabled.  Depth 4
  target0:0:1: Beginning Domain Validation
  target0:0:1: wide asynchronous
  target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
  target0:0:1: Domain Validation skipping write tests
  target0:0:1: Ending Domain Validation
scsi 0:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target0:0:2: asynchronous
scsi0:A:2:0: Tagged Queuing enabled.  Depth 4
  target0:0:2: Beginning Domain Validation
  target0:0:2: wide asynchronous
  target0:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target0:0:2: Ending Domain Validation
scsi 0:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 4
  target0:0:3: Beginning Domain Validation
  target0:0:3: wide asynchronous
  target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target0:0:3: Ending Domain Validation
scsi 0:0:6:0: Processor         SUPER    GEM318           0    PQ: 0 ANSI: 2
  target0:0:6: asynchronous
  target0:0:6: Beginning Domain Validation
  target0:0:6: Ending Domain Validation
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
         <Adaptec AIC7902 Ultra320 SCSI adapter>
         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Adaptec aacraid driver (1.1-5[2423]-mh3)
QLogic Fibre Channel HBA Driver
scsi 1:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target1:0:0: asynchronous
scsi1:A:0:0: Tagged Queuing enabled.  Depth 4
  target1:0:0: Beginning Domain Validation
  target1:0:0: wide asynchronous
  target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target1:0:0: Ending Domain Validation
scsi 1:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target1:0:1: asynchronous
scsi1:A:1:0: Tagged Queuing enabled.  Depth 4
  target1:0:1: Beginning Domain Validation
  target1:0:1: wide asynchronous
  target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target1:0:1: Ending Domain Validation
scsi 1:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target1:0:2: asynchronous
scsi1:A:2:0: Tagged Queuing enabled.  Depth 4
  target1:0:2: Beginning Domain Validation
  target1:0:2: wide asynchronous
  target1:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
sym0: <1010-66> rev 0x1 at pci 0000:04:01.0 irq 16
  target1:0:2: Ending Domain Validation
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
scsi 1:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target1:0:3: asynchronous
scsi1:A:3:0: Tagged Queuing enabled.  Depth 4
  target1:0:3: Beginning Domain Validation
sym0: SCSI BUS has been reset.
scsi2 : sym-2.2.3
  target1:0:3: wide asynchronous
  target1:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 
127)
  target1:0:3: Ending Domain Validation
sym1: <1010-66> rev 0x1 at pci 0000:04:01.1 irq 17
sym1: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
scsi3 : sym-2.2.3
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI device sda: 35565080 512-byte hdwr sectors (18209 MB)
sda: Write Protect is off
sda: Mode Sense: f3 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and 
FUA
SCSI device sda: 35565080 512-byte hdwr sectors (18209 MB)
sda: Write Protect is off
sda: Mode Sense: f3 00 10 08
SCSI device sda: write cache: disabled, read cache: enabled, supports DPO and 
FUA
  sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 35565080 512-byte hdwr sectors (18209 MB)
sdb: Write Protect is off
sdb: Mode Sense: f3 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and 
FUA
SCSI device sdb: 35565080 512-byte hdwr sectors (18209 MB)
sdb: Write Protect is off
sdb: Mode Sense: f3 00 10 08
SCSI device sdb: write cache: disabled, read cache: enabled, supports DPO and 
FUA
  sdb: sdb1 sdb2 sdb3
sd 0:0:1:0: Attached scsi disk sdb
SCSI device sdc: 287132440 512-byte hdwr sectors (147012 MB)
sdc: Write Protect is off
sdc: Mode Sense: b3 00 00 08
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdc: 287132440 512-byte hdwr sectors (147012 MB)
sdc: Write Protect is off
sdc: Mode Sense: b3 00 00 08
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdc: sdc1
sd 0:0:2:0: Attached scsi disk sdc
SCSI device sdd: 287132440 512-byte hdwr sectors (147012 MB)
sdd: Write Protect is off
sdd: Mode Sense: b3 00 00 08
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdd: 287132440 512-byte hdwr sectors (147012 MB)
sdd: Write Protect is off
sdd: Mode Sense: b3 00 00 08
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
--
sd 0:0:3:0: Attached scsi disk sdd
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 0:0:2:0: Attached scsi generic sg2 type 0
sd 0:0:3:0: Attached scsi generic sg3 type 0
scsi 0:0:6:0: Attached scsi generic sg4 type 3
SCSI Media Changer driver v0.25
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
mptbase: Initiating ioc0 bringup
scsi 1:0:6:0: Processor         SUPER    GEM318           0    PQ: 0 ANSI: 2
  target1:0:6: asynchronous
  target1:0:6: Beginning Domain Validation
  target1:0:6: Ending Domain Validation
ioc0: 53C1030: Capabilities={Initiator,Target}
scsi4 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
mptbase: Initiating ioc1 bringup
SCSI device sde: 287132440 512-byte hdwr sectors (147012 MB)
sde: Write Protect is off
sde: Mode Sense: b3 00 00 08
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sde: 287132440 512-byte hdwr sectors (147012 MB)
sde: Write Protect is off
sde: Mode Sense: b3 00 00 08
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sde: sde1
sd 1:0:0:0: Attached scsi disk sde
sd 1:0:0:0: Attached scsi generic sg5 type 0
SCSI device sdf: 287132440 512-byte hdwr sectors (147012 MB)
sdf: Write Protect is off
sdf: Mode Sense: b3 00 00 08
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdf: 287132440 512-byte hdwr sectors (147012 MB)
sdf: Write Protect is off
sdf: Mode Sense: b3 00 00 08
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdf: sdf1
ioc1: <5>sd 1:0:1:0: Attached scsi disk sdf
sd 1:0:1:0: Attached scsi generic sg6 type 0
SCSI device sdg: 287132440 512-byte hdwr sectors (147012 MB)
53C1030: Capabilities={Initiator,Target}
sdg: Write Protect is off
sdg: Mode Sense: b3 00 00 08
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdg: 287132440 512-byte hdwr sectors (147012 MB)
sdg: Write Protect is off
sdg: Mode Sense: b3 00 00 08
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdg: sdg1
sd 1:0:2:0: Attached scsi disk sdg
sd 1:0:2:0: Attached scsi generic sg7 type 0
SCSI device sdh: 287132440 512-byte hdwr sectors (147012 MB)
sdh: Write Protect is off
sdh: Mode Sense: b3 00 00 08
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdh: 287132440 512-byte hdwr sectors (147012 MB)
sdh: Write Protect is off
sdh: Mode Sense: b3 00 00 08
SCSI device sdh: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdh: sdh1
sd 1:0:3:0: Attached scsi disk sdh
sd 1:0:3:0: Attached scsi generic sg8 type 0
scsi 1:0:6:0: Attached scsi generic sg9 type 3
  target4:0:1: mpt_config failed
scsi 2:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:0: tagged command queuing enabled, command queue depth 16.
  target2:0:0: Beginning Domain Validation
  target2:0:0: asynchronous
  target2:0:0: wide asynchronous
  target2:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
scsi5 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=17
  target2:0:0: Ending Domain Validation
scsi 2:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:1: tagged command queuing enabled, command queue depth 16.
  target2:0:1: Beginning Domain Validation
  target2:0:1: asynchronous
  target2:0:1: wide asynchronous
  target2:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:1: Ending Domain Validation
scsi 2:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:2: tagged command queuing enabled, command queue depth 16.
  target2:0:2: Beginning Domain Validation
  target2:0:2: asynchronous
  target2:0:2: wide asynchronous
  target2:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:2: Ending Domain Validation
scsi 2:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:3: tagged command queuing enabled, command queue depth 16.
  target2:0:3: Beginning Domain Validation
  target2:0:3: asynchronous
  target2:0:3: wide asynchronous
scsi 3:0:0:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:0: tagged command queuing enabled, command queue depth 16.
  target3:0:0: Beginning Domain Validation
  target3:0:0: asynchronous
  target2:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:0: wide asynchronous
  target3:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:3: Ending Domain Validation
scsi 2:0:4:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:0: Ending Domain Validation
  target2:0:4: tagged command queuing enabled, command queue depth 16.
scsi 3:0:1:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:1: tagged command queuing enabled, command queue depth 16.
  target3:0:1: Beginning Domain Validation
  target3:0:1: asynchronous
  target2:0:4: Beginning Domain Validation
  target2:0:4: asynchronous
  target3:0:1: wide asynchronous
  target3:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:4: wide asynchronous
  target2:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:1: Ending Domain Validation
  target2:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
scsi 3:0:2:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:2: tagged command queuing enabled, command queue depth 16.
  target2:0:4: Ending Domain Validation
  target3:0:2: Beginning Domain Validation
scsi 2:0:5:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:5: tagged command queuing enabled, command queue depth 16.
  target2:0:5: Beginning Domain Validation
  target2:0:5: asynchronous
  target3:0:2: asynchronous
  target2:0:5: wide asynchronous
  target3:0:2: wide asynchronous
  target2:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:5: Ending Domain Validation
  target3:0:2: Ending Domain Validation
scsi 3:0:3:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:3: tagged command queuing enabled, command queue depth 16.
  target3:0:3: Beginning Domain Validation
  target3:0:3: asynchronous
  target3:0:3: wide asynchronous
  target3:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:3: Ending Domain Validation
scsi 3:0:4:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:4: tagged command queuing enabled, command queue depth 16.
  target3:0:4: Beginning Domain Validation
  target3:0:4: asynchronous
  target3:0:4: wide asynchronous
  target3:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:4: Ending Domain Validation
scsi 3:0:5:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:5: tagged command queuing enabled, command queue depth 16.
  target3:0:5: Beginning Domain Validation
  target3:0:5: asynchronous
  target3:0:5: wide asynchronous
  target3:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target3:0:5: Ending Domain Validation
scsi 2:0:8:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target2:0:8: tagged command queuing enabled, command queue depth 16.
  target2:0:8: Beginning Domain Validation
  target2:0:8: asynchronous
  target2:0:8: wide asynchronous
  target2:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
  target2:0:8: Ending Domain Validation
Fusion MPT FC Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
Fusion MPT misc device (ioctl) driver 3.04.04
--
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
scsi 3:0:8:0: Direct-Access     FUJITSU  MAP3147NC        0108 PQ: 0 ANSI: 3
  target3:0:8: tagged command queuing enabled, command queue depth 16.
  target3:0:8: Beginning Domain Validation
  target3:0:8: asynchronous
  target3:0:8: wide asynchronous
  target3:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
USB Universal Host Controller Interface driver v3.0
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
  target3:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001800
  target3:0:8: Ending Domain Validation
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
--
input: PC Speaker as /class/input/input1
input: PS/2 Generic Mouse as /class/input/input2
isl1208 2-006f: chip found, driver version 0.2
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
sdi: Write Protect is off
isl1208 2-006f: rtc core: registered isl1208 as rtc0
sdi: Mode Sense: b3 00 00 08
--
    pIII_sse  :  4009.000 MB/sec
raid5: using function: pIII_sse (4009.000 MB/sec)
md: multipath personality registered for level -4
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
sdi: Write Protect is off
sdi: Mode Sense: b3 00 00 08
--
  unknown partition table
sd 2:0:0:0: Attached scsi disk sdi
sd 2:0:0:0: Attached scsi generic sg10 type 0
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
sdj: Mode Sense: b3 00 00 08
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
sdj: Mode Sense: b3 00 00 08
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdj: unknown partition table
sd 2:0:1:0: Attached scsi disk sdj
sd 2:0:1:0: Attached scsi generic sg11 type 0
SCSI device sdk: 287132440 512-byte hdwr sectors (147012 MB)
sdk: Write Protect is off
sdk: Mode Sense: b3 00 00 08
SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdk: 287132440 512-byte hdwr sectors (147012 MB)
sdk: Write Protect is off
sdk: Mode Sense: b3 00 00 08
SCSI device sdk: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdk: unknown partition table
sd 2:0:2:0: Attached scsi disk sdk
sd 2:0:2:0: Attached scsi generic sg12 type 0
SCSI device sdl: 287132440 512-byte hdwr sectors (147012 MB)
sdl: Write Protect is off
sdl: Mode Sense: b3 00 00 08
SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdl: 287132440 512-byte hdwr sectors (147012 MB)
sdl: Write Protect is off
sdl: Mode Sense: b3 00 00 08
SCSI device sdl: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdl: unknown partition table
sd 2:0:3:0: Attached scsi disk sdl
sd 2:0:3:0: Attached scsi generic sg13 type 0
SCSI device sdm: 287132440 512-byte hdwr sectors (147012 MB)
sdm: Write Protect is off
sdm: Mode Sense: b3 00 00 08
SCSI device sdm: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdm: 287132440 512-byte hdwr sectors (147012 MB)
sdm: Write Protect is off
sdm: Mode Sense: b3 00 00 08
SCSI device sdm: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdm: unknown partition table
sd 2:0:4:0: Attached scsi disk sdm
sd 2:0:4:0: Attached scsi generic sg14 type 0
SCSI device sdn: 287132440 512-byte hdwr sectors (147012 MB)
sdn: Write Protect is off
sdn: Mode Sense: b3 00 00 08
SCSI device sdn: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdn: 287132440 512-byte hdwr sectors (147012 MB)
sdn: Write Protect is off
sdn: Mode Sense: b3 00 00 08
SCSI device sdn: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdn: unknown partition table
sd 2:0:5:0: Attached scsi disk sdn
sd 2:0:5:0: Attached scsi generic sg15 type 0
SCSI device sdo: 287132440 512-byte hdwr sectors (147012 MB)
sdo: Write Protect is off
sdo: Mode Sense: b3 00 00 08
SCSI device sdo: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdo: 287132440 512-byte hdwr sectors (147012 MB)
sdo: Write Protect is off
sdo: Mode Sense: b3 00 00 08
SCSI device sdo: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdo: unknown partition table
sd 2:0:8:0: Attached scsi disk sdo
sd 2:0:8:0: Attached scsi generic sg16 type 0
SCSI device sdp: 287132440 512-byte hdwr sectors (147012 MB)
sdp: Write Protect is off
sdp: Mode Sense: b3 00 00 08
SCSI device sdp: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdp: 287132440 512-byte hdwr sectors (147012 MB)
sdp: Write Protect is off
sdp: Mode Sense: b3 00 00 08
SCSI device sdp: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdp: unknown partition table
sd 3:0:0:0: Attached scsi disk sdp
sd 3:0:0:0: Attached scsi generic sg17 type 0
SCSI device sdq: 287132440 512-byte hdwr sectors (147012 MB)
sdq: Write Protect is off
sdq: Mode Sense: b3 00 00 08
SCSI device sdq: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdq: 287132440 512-byte hdwr sectors (147012 MB)
sdq: Write Protect is off
sdq: Mode Sense: b3 00 00 08
SCSI device sdq: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdq: unknown partition table
sd 3:0:1:0: Attached scsi disk sdq
sd 3:0:1:0: Attached scsi generic sg18 type 0
SCSI device sdr: 287132440 512-byte hdwr sectors (147012 MB)
sdr: Write Protect is off
sdr: Mode Sense: b3 00 00 08
SCSI device sdr: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdr: 287132440 512-byte hdwr sectors (147012 MB)
sdr: Write Protect is off
sdr: Mode Sense: b3 00 00 08
SCSI device sdr: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdr: unknown partition table
sd 3:0:2:0: Attached scsi disk sdr
sd 3:0:2:0: Attached scsi generic sg19 type 0
SCSI device sds: 287132440 512-byte hdwr sectors (147012 MB)
sds: Write Protect is off
sds: Mode Sense: b3 00 00 08
SCSI device sds: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sds: 287132440 512-byte hdwr sectors (147012 MB)
sds: Write Protect is off
sds: Mode Sense: b3 00 00 08
SCSI device sds: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sds: unknown partition table
sd 3:0:3:0: Attached scsi disk sds
sd 3:0:3:0: Attached scsi generic sg20 type 0
SCSI device sdt: 287132440 512-byte hdwr sectors (147012 MB)
sdt: Write Protect is off
sdt: Mode Sense: b3 00 00 08
SCSI device sdt: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdt: 287132440 512-byte hdwr sectors (147012 MB)
sdt: Write Protect is off
sdt: Mode Sense: b3 00 00 08
SCSI device sdt: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdt: unknown partition table
sd 3:0:4:0: Attached scsi disk sdt
sd 3:0:4:0: Attached scsi generic sg21 type 0
SCSI device sdu: 287132440 512-byte hdwr sectors (147012 MB)
sdu: Write Protect is off
sdu: Mode Sense: b3 00 00 08
SCSI device sdu: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdu: 287132440 512-byte hdwr sectors (147012 MB)
sdu: Write Protect is off
sdu: Mode Sense: b3 00 00 08
SCSI device sdu: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdu: unknown partition table
sd 3:0:5:0: Attached scsi disk sdu
sd 3:0:5:0: Attached scsi generic sg22 type 0
SCSI device sdv: 287132440 512-byte hdwr sectors (147012 MB)
sdv: Write Protect is off
sdv: Mode Sense: b3 00 00 08
SCSI device sdv: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
SCSI device sdv: 287132440 512-byte hdwr sectors (147012 MB)
sdv: Write Protect is off
sdv: Mode Sense: b3 00 00 08
SCSI device sdv: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdv: unknown partition table
sd 3:0:8:0: Attached scsi disk sdv
sd 3:0:8:0: Attached scsi generic sg23 type 0
isl1208 2-006f: hctosys: invalid date/time
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sdc1
--
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
sdi: Write Protect is off
sdi: Mode Sense: b3 00 00 08
SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdi: sdi1
SCSI device sdi: 287132440 512-byte hdwr sectors (147012 MB)
sdi: Write Protect is off
sdi: Mode Sense: b3 00 00 08
SCSI device sdi: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdi: sdi1
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
sdj: Mode Sense: b3 00 00 08
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA
  sdj: sdj1
SCSI device sdj: 287132440 512-byte hdwr sectors (147012 MB)
sdj: Write Protect is off
sdj: Mode Sense: b3 00 00 08
SCSI device sdj: write cache: enabled, read cache: enabled, doesn't support DPO 
or FUA

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
