From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111381] New: mvsas 0.8.16 on Marvell 88SE9485 reports timeouts
 on load
Date: Wed, 27 Jan 2016 21:56:17 +0000
Message-ID: <bug-111381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42822 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161971AbcA0V4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 16:56:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BF6B020274
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2016 21:56:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7BC7120265
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2016 21:56:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111381

            Bug ID: 111381
           Summary: mvsas 0.8.16 on Marvell 88SE9485 reports timeouts on
                    load
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.1.15
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: gdevenyi@gmail.com
        Regression: No

Motherboard: P9A-I/C2550/SAS/4L

lsscsi -t -v:
[0:0:0:0]    disk    sas:0x5000c50034367baa          /dev/sdb 
  dir: /sys/bus/scsi/devices/0:0:0:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0]
[0:0:1:0]    disk    sas:0x5000c50034367ba9          /dev/sdc 
  dir: /sys/bus/scsi/devices/0:0:1:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0]
[0:0:2:0]    disk    sas:0x5000c5003432eafe          /dev/sdd 
  dir: /sys/bus/scsi/devices/0:0:2:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:2/end_device-0:2/target0:0:2/0:0:2:0]
[0:0:3:0]    disk    sas:0x5000c5003432eafd          /dev/sde 
  dir: /sys/bus/scsi/devices/0:0:3:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:3/end_device-0:3/target0:0:3/0:0:3:0]
[0:0:4:0]    disk    sas:0x5000c500741d842a          /dev/sdf 
  dir: /sys/bus/scsi/devices/0:0:4:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:4/end_device-0:4/target0:0:4/0:0:4:0]
[0:0:5:0]    disk    sas:0x5000c500741d8429          /dev/sdg 
  dir: /sys/bus/scsi/devices/0:0:5:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:5/end_device-0:5/target0:0:5/0:0:5:0]
[0:0:6:0]    disk    sas:0x5000c5003c9335ca          /dev/sdh 
  dir: /sys/bus/scsi/devices/0:0:6:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:6/end_device-0:6/target0:0:6/0:0:6:0]
[0:0:7:0]    disk    sas:0x5000c5003c9335c9          /dev/sdi 
  dir: /sys/bus/scsi/devices/0:0:7:0 
[/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host0/port-0:7/end_device-0:7/target0:0:7/0:0:7:0]
[2:0:0:0]    disk    sata:                           /dev/sda 
  dir: /sys/bus/scsi/devices/2:0:0:0 
[/sys/devices/pci0000:00/0000:00:18.0/ata2/host2/target2:0:0/2:0:0:0]
[3:0:0:0]    disk    sas:0x5000c5005d722942          /dev/sdj 
  dir: /sys/bus/scsi/devices/3:0:0:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:0/end_device-3:0/target3:0:0/3:0:0:0]
[3:0:1:0]    disk    sas:0x5000c5005d722941          /dev/sdk 
  dir: /sys/bus/scsi/devices/3:0:1:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:1/end_device-3:1/target3:0:1/3:0:1:0]
[3:0:2:0]    disk    sas:0x5000c5005d84e1a6          /dev/sdl 
  dir: /sys/bus/scsi/devices/3:0:2:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:2/end_device-3:2/target3:0:2/3:0:2:0]
[3:0:3:0]    disk    sas:0x5000c5005d84e1a5          /dev/sdm 
  dir: /sys/bus/scsi/devices/3:0:3:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:3/end_device-3:3/target3:0:3/3:0:3:0]
[3:0:4:0]    disk    sas:0x5000c5007408d282          /dev/sdn 
  dir: /sys/bus/scsi/devices/3:0:4:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:4/end_device-3:4/target3:0:4/3:0:4:0]
[3:0:5:0]    disk    sas:0x5000c5007408d281          /dev/sdo 
  dir: /sys/bus/scsi/devices/3:0:5:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:5/end_device-3:5/target3:0:5/3:0:5:0]
[3:0:6:0]    disk    sas:0x5000c500740c1212          /dev/sdp 
  dir: /sys/bus/scsi/devices/3:0:6:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:6/end_device-3:6/target3:0:6/3:0:6:0]
[3:0:7:0]    disk    sas:0x5000c500740c1211          /dev/sdq 
  dir: /sys/bus/scsi/devices/3:0:7:0 
[/sys/devices/pci0000:00/0000:00:04.0/0000:01:00.0/host3/port-3:7/end_device-3:7/target3:0:7/3:0:7:0]
[4:0:0:0]    cd/dvd  usb: 1-1.3.2:1.0                /dev/sr0 
  dir: /sys/bus/scsi/devices/4:0:0:0 
[/sys/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.3/1-1.3.2/1-1.3.2:1.0/host4/target4:0:0/4:0:0:0]
[5:0:0:0]    disk    usb: 1-1.3.3:1.0                /dev/sdr 
  dir: /sys/bus/scsi/devices/5:0:0:0 
[/sys/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.3/1-1.3.3/1-1.3.3:1.0/host5/target5:0:0/5:0:0:0]
[6:0:0:0]    disk    usb: 1-1.3.4:1.0                /dev/sds 
  dir: /sys/bus/scsi/devices/6:0:0:0 
[/sys/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.3/1-1.3.4/1-1.3.4:1.0/host6/target6:0:0/6:0:0:0]

Relevant dmesg snip:
[    1.274088] mvsas 0000:02:00.0: mvsas: driver version 0.8.16
[    1.276086] dca service started, version 1.12.1
[    1.296857] mvsas 0000:02:00.0: mvsas: PCI-E x4, Bandwidth Usage: 5.0 Gbps
[    1.303168] ahci 0000:00:18.0: version 3.0
[    1.303887] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[    1.310071] igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.318636] ahci 0000:00:18.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x3
impl SATA mode
[    1.325008] ahci 0000:00:18.0: flags: 64bit ncq led clo pio deso sadm sds
apst 
[    1.332076] scsi host1: ahci
[    1.338704] scsi host2: ahci
[    1.345099] ata1: SATA max UDMA/133 abar m2048@0xde412000 port 0xde412100
irq 28
[    1.351516] ata2: SATA max UDMA/133 abar m2048@0xde412000 port 0xde412180
irq 28
[    1.535197] usb 1-1: New USB device found, idVendor=8087, idProduct=07db
[    1.541442] usb 1-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[    1.548138] hub 1-1:1.0: USB hub found
[    1.554581] hub 1-1:1.0: 4 ports detected
[    1.682855] ata1: SATA link down (SStatus 0 SControl 300)
[    1.689116] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.696299] ata2.00: ATA-9: TS32GMTS400, N1126I, max UDMA/133
[    1.700761] igb 0000:00:14.0: added PHC on eth0
[    1.700763] igb 0000:00:14.0: Intel(R) Gigabit Ethernet Network Connection
[    1.700866] igb 0000:00:14.0: eth0: PBA No: 001800-000
[    1.700868] igb 0000:00:14.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx
queue(s)
[    1.727495] ata2.00: 62533296 sectors, multi 2: LBA48 NCQ (depth 31/32), AA
[    1.734384] ata2.00: configured for UDMA/133
[    1.740435] tsc: Refined TSC clocksource calibration: 2393.903 MHz
[    1.740675] scsi 2:0:0:0: Direct-Access     ATA      TS32GMTS400      6I  
PQ: 0 ANSI: 5
[    1.741127] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.741163] sd 2:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0
GB/29.8 GiB)
[    1.741356] sd 2:0:0:0: [sda] Write Protect is off
[    1.741359] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.741416] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.771415]  sda: sda1 sda2 sda3
[    1.772620] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.795221] clocksource tsc: mask: 0xffffffffffffffff max_cycles:
0x2281b7b41ef, max_idle_ns: 440795228866 ns
[    1.848857] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    1.854997] EXT4-fs (sda2): write access will be enabled during recovery
[    1.862974] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
[    2.048981] igb 0000:00:14.1: added PHC on eth1
[    2.055033] igb 0000:00:14.1: Intel(R) Gigabit Ethernet Network Connection
[    2.061179] igb 0000:00:14.1: eth1: PBA No: 001800-000
[    2.067121] igb 0000:00:14.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx
queue(s)
[    2.073980] usb 1-1.2: New USB device found, idVendor=051d, idProduct=0002
[    2.080015] usb 1-1.2: New USB device strings: Mfr=3, Product=1,
SerialNumber=2
[    2.086172] usb 1-1.2: Product: Back-UPS XS 1300 LCD FW:836.H8 .D USB FW:H8 
[    2.092281] usb 1-1.2: Manufacturer: American Power Conversion
[    2.098478] usb 1-1.2: SerialNumber: BB0820012670  
[    2.112737] hidraw: raw HID events driver (C) Jiri Kosina
[    2.148885] EXT4-fs (sda2): orphan cleanup on readonly fs
[    2.155061] EXT4-fs (sda2): 2 orphan inodes deleted
[    2.161145] EXT4-fs (sda2): recovery complete
[    2.176864] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts:
(null)
[    2.183027] usb 1-1.3: new high-speed USB device number 4 using ehci-pci
[    2.425276] igb 0000:00:14.2: added PHC on eth2
[    2.431530] igb 0000:00:14.2: Intel(R) Gigabit Ethernet Network Connection
[    2.438023] igb 0000:00:14.2: eth2: PBA No: 001800-000
[    2.444316] igb 0000:00:14.2: Using MSI-X interrupts. 4 rx queue(s), 4 tx
queue(s)
[    2.485000] usb 1-1.3: New USB device found, idVendor=046b, idProduct=ff01
[    2.491400] usb 1-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    2.497736] usb 1-1.3: Product: Virtual Hub
[    2.503956] usb 1-1.3: Manufacturer: American Megatrends Inc.
[    2.510176] usb 1-1.3: SerialNumber: serial
[    2.516878] hub 1-1.3:1.0: USB hub found
[    2.522991] hub 1-1.3:1.0: 5 ports detected
[    2.712822] usbcore: registered new interface driver usbhid
[    2.718787] usbhid: USB HID core driver
[    2.797332] igb 0000:00:14.3: added PHC on eth3
[    2.803157] igb 0000:00:14.3: Intel(R) Gigabit Ethernet Network Connection
[    2.808999] igb 0000:00:14.3: eth3: PBA No: 001800-000
[    2.814722] igb 0000:00:14.3: Using MSI-X interrupts. 4 rx queue(s), 4 tx
queue(s)
[    2.821282] Switched to clocksource tsc
[    2.851520] usb 1-1.3.1: new low-speed USB device number 5 using ehci-pci
[    3.012794] usb 1-1.3.1: New USB device found, idVendor=046b, idProduct=ff10
[    3.018561] usb 1-1.3.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    3.024327] usb 1-1.3.1: Product: Virtual Keyboard and Mouse
[    3.030071] usb 1-1.3.1: Manufacturer: American Megatrends Inc.
[    3.159691] usb 1-1.3.2: new high-speed USB device number 6 using ehci-pci
[    3.320714] usb 1-1.3.2: New USB device found, idVendor=046b, idProduct=ff20
[    3.326434] usb 1-1.3.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    3.332120] usb 1-1.3.2: Product: Virtual Cdrom Device
[    3.337745] usb 1-1.3.2: Manufacturer: American Megatrends Inc.
[    3.343394] usb 1-1.3.2: SerialNumber: AAAABBBBCCCC1
[    3.475869] usb 1-1.3.3: new high-speed USB device number 7 using ehci-pci
[    3.636901] usb 1-1.3.3: New USB device found, idVendor=046b, idProduct=ff40
[    3.642636] usb 1-1.3.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    3.648426] usb 1-1.3.3: Product: Virtual Floppy Device
[    3.654156] usb 1-1.3.3: Manufacturer: American Megatrends Inc.
[    3.659810] usb 1-1.3.3: SerialNumber: AAAABBBBCCCC2
[    3.788051] usb 1-1.3.4: new high-speed USB device number 8 using ehci-pci
[    3.949074] usb 1-1.3.4: New USB device found, idVendor=046b, idProduct=ff31
[    3.954635] usb 1-1.3.4: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    3.960087] usb 1-1.3.4: Product: Virtual HardDisk Device
[    3.965503] usb 1-1.3.4: Manufacturer: American Megatrends Inc.
[    3.970899] usb 1-1.3.4: SerialNumber: AAAABBBBCCCC3
[    8.691723] scsi host0: mvsas
[    8.697850] mvsas 0000:01:00.0: mvsas: driver version 0.8.16
[    8.703663] mvsas 0000:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 5.0 Gbps
[    8.707897] sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5000c50034367baa)
[    8.707900] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 1
[    8.727818] sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5000c50034367ba9)
[    8.727823] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 2
[    8.757662] sas: phy-0:2 added to port-0:2, phy_mask:0x4 (5000c5003432eafe)
[    8.757665] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 4
[    8.797395] sas: DOING DISCOVERY on port 0, pid:155
[    8.797399] sas: DONE DISCOVERY on port 0, pid:155, result:0
[    8.797448] sas: phy-0:3 added to port-0:3, phy_mask:0x8 (5000c5003432eafd)
[    8.797451] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 8
[    8.847156] sas: phy-0:4 added to port-0:4, phy_mask:0x1 (5000c500741d842a)
[    8.847160] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 1
[    8.867071] sas: phy-0:5 added to port-0:5, phy_mask:0x2 (5000c500741d8429)
[    8.867074] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 2
[    8.896874] sas: DOING DISCOVERY on port 1, pid:155
[    8.896877] sas: DONE DISCOVERY on port 1, pid:155, result:0
[    8.896927] sas: phy-0:6 added to port-0:6, phy_mask:0x4 (5000c5003c9335ca)
[    8.896930] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 4
[    8.936699] sas: phy-0:7 added to port-0:7, phy_mask:0x8 (5000c5003c9335c9)
[    8.936702] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 8
[    8.986359] sas: DOING DISCOVERY on port 2, pid:155
[    8.986363] sas: DONE DISCOVERY on port 2, pid:155, result:0
[    8.987647] scsi 0:0:0:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    8.995126] sas: DOING DISCOVERY on port 3, pid:155
[    8.995136] sas: DONE DISCOVERY on port 3, pid:155, result:0
[    8.995145] sas: DOING DISCOVERY on port 4, pid:155
[    8.995149] sas: DONE DISCOVERY on port 4, pid:155, result:0
[    8.995161] sas: DOING DISCOVERY on port 5, pid:155
[    8.995166] sas: DONE DISCOVERY on port 5, pid:155, result:0
[    8.996181] scsi 0:0:1:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    9.003056] sas: DOING DISCOVERY on port 6, pid:155
[    9.003062] sas: DONE DISCOVERY on port 6, pid:155, result:0
[    9.003071] sas: DOING DISCOVERY on port 7, pid:155
[    9.003074] sas: DONE DISCOVERY on port 7, pid:155, result:0
[    9.004324] scsi 0:0:2:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    9.012459] scsi 0:0:3:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    9.020051] scsi 0:0:4:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[    9.026562] scsi 0:0:5:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[    9.033522] scsi 0:0:6:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    9.040745] scsi 0:0:7:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[    9.047242] sd 0:0:0:0: Attached scsi generic sg1 type 0
[    9.052400] sd 0:0:1:0: Attached scsi generic sg2 type 0
[    9.052502] sd 0:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.053230] sd 0:0:1:0: [sdc] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.057101] sd 0:0:0:0: [sdb] Write Protect is off
[    9.057104] sd 0:0:0:0: [sdb] Mode Sense: d7 00 10 08
[    9.058949] sd 0:0:1:0: [sdc] Write Protect is off
[    9.058952] sd 0:0:1:0: [sdc] Mode Sense: d7 00 10 08
[    9.059533] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.061023] sd 0:0:1:0: [sdc] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.077443]  sdb: sdb1 sdb9
[    9.080843]  sdc: sdc1 sdc9
[    9.090572] sd 0:0:0:0: [sdb] Attached SCSI disk
[    9.091371] sd 0:0:1:0: [sdc] Attached SCSI disk
[    9.101422] sd 0:0:2:0: Attached scsi generic sg3 type 0
[    9.105866] sd 0:0:3:0: Attached scsi generic sg4 type 0
[    9.106006] sd 0:0:2:0: [sdd] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.106774] sd 0:0:3:0: [sde] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.109925] sd 0:0:2:0: [sdd] Write Protect is off
[    9.109928] sd 0:0:2:0: [sdd] Mode Sense: d7 00 10 08
[    9.111779] sd 0:0:3:0: [sde] Write Protect is off
[    9.111782] sd 0:0:3:0: [sde] Mode Sense: d7 00 10 08
[    9.112379] sd 0:0:2:0: [sdd] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.113844] sd 0:0:3:0: [sde] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.133888] sd 0:0:4:0: Attached scsi generic sg5 type 0
[    9.134050] sd 0:0:4:0: [sdf] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.137751] sd 0:0:4:0: [sdf] Write Protect is off
[    9.137754] sd 0:0:4:0: [sdf] Mode Sense: d7 00 10 08
[    9.138307] sd 0:0:4:0: [sdf] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.138761]  sdd: sdd1 sdd9
[    9.142160]  sde: sde1 sde9
[    9.146352] random: nonblocking pool is initialized
[    9.154838] sd 0:0:2:0: [sdd] Attached SCSI disk
[    9.156295] sd 0:0:3:0: [sde] Attached SCSI disk
[    9.168918] sd 0:0:5:0: Attached scsi generic sg6 type 0
[    9.172961] sd 0:0:6:0: Attached scsi generic sg7 type 0
[    9.173030] sd 0:0:5:0: [sdg] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.173418] sd 0:0:6:0: [sdh] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.173786]  sdf: sdf1 sdf9
[    9.176797] sd 0:0:5:0: [sdg] Write Protect is off
[    9.176800] sd 0:0:5:0: [sdg] Mode Sense: d7 00 10 08
[    9.177650] sd 0:0:6:0: [sdh] Write Protect is off
[    9.177653] sd 0:0:6:0: [sdh] Mode Sense: d7 00 10 08
[    9.177853] sd 0:0:5:0: [sdg] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.181519] sd 0:0:6:0: [sdh] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.182154] sd 0:0:4:0: [sdf] Attached SCSI disk
[    9.192969]  sdg: sdg1 sdg9
[    9.202032] sd 0:0:5:0: [sdg] Attached SCSI disk
[    9.202056]  sdh: sdh1 sdh9
[    9.212823] sd 0:0:6:0: [sdh] Attached SCSI disk
[    9.226675] sd 0:0:7:0: Attached scsi generic sg8 type 0
[    9.227054] sd 0:0:7:0: [sdi] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[    9.236118] sd 0:0:7:0: [sdi] Write Protect is off
[    9.240479] sd 0:0:7:0: [sdi] Mode Sense: d7 00 10 08
[    9.241806] sd 0:0:7:0: [sdi] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[    9.253848]  sdi: sdi1 sdi9
[    9.263261] sd 0:0:7:0: [sdi] Attached SCSI disk
[   16.099998] scsi host3: mvsas
[   16.175273] sas: phy-3:0 added to port-3:0, phy_mask:0x1 (5000c5005d722942)
[   16.175277] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 1
[   16.195203] sas: phy-3:1 added to port-3:1, phy_mask:0x2 (5000c5005d722941)
[   16.195206] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 2
[   16.225049] sas: phy-3:2 added to port-3:2, phy_mask:0x4 (5000c5005d84e1a6)
[   16.225052] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 4
[   16.264821] sas: phy-3:3 added to port-3:3, phy_mask:0x8 (5000c5005d84e1a5)
[   16.264824] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 8
[   16.314519] sas: phy-3:4 added to port-3:4, phy_mask:0x1 (5000c5007408d282)
[   16.314523] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 1
[   16.334436] sas: phy-3:5 added to port-3:5, phy_mask:0x2 (5000c5007408d281)
[   16.334439] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 2
[   16.364281] sas: phy-3:6 added to port-3:6, phy_mask:0x4 (5000c500740c1212)
[   16.364285] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 4
[   16.404052] sas: phy-3:7 added to port-3:7, phy_mask:0x8 (5000c500740c1211)
[   16.404055] /home/kernel/COD/linux/drivers/scsi/mvsas/mv_sas.c 1116:set wide
port phy map 8
[   16.453711] sas: DOING DISCOVERY on port 0, pid:6
[   16.453716] sas: DONE DISCOVERY on port 0, pid:6, result:0
[   16.453725] sas: DOING DISCOVERY on port 1, pid:6
[   16.453728] sas: DONE DISCOVERY on port 1, pid:6, result:0
[   16.453735] sas: DOING DISCOVERY on port 2, pid:6
[   16.453740] sas: DONE DISCOVERY on port 2, pid:6, result:0
[   16.453747] sas: DOING DISCOVERY on port 3, pid:6
[   16.453751] sas: DONE DISCOVERY on port 3, pid:6, result:0
[   16.453757] sas: DOING DISCOVERY on port 4, pid:6
[   16.453760] sas: DONE DISCOVERY on port 4, pid:6, result:0
[   16.453767] sas: DOING DISCOVERY on port 5, pid:6
[   16.453771] sas: DONE DISCOVERY on port 5, pid:6, result:0
[   16.453780] sas: DOING DISCOVERY on port 6, pid:6
[   16.453785] sas: DONE DISCOVERY on port 6, pid:6, result:0
[   16.453791] sas: DOING DISCOVERY on port 7, pid:6
[   16.453794] sas: DONE DISCOVERY on port 7, pid:6, result:0
[   16.454955] scsi 3:0:0:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[   16.462566] scsi 3:0:1:0: Direct-Access     SEAGATE  ST32000444SS     0006
PQ: 0 ANSI: 5
[   16.469684] scsi 3:0:2:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.475938] scsi 3:0:3:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.482286] scsi 3:0:4:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.488166] scsi 3:0:5:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.494331] scsi 3:0:6:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.500037] scsi 3:0:7:0: Direct-Access     SEAGATE  ST2000NM0001     0002
PQ: 0 ANSI: 6
[   16.505321] sd 3:0:0:0: Attached scsi generic sg9 type 0
[   16.505715] sd 3:0:0:0: [sdj] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.509529] sd 3:0:0:0: [sdj] Write Protect is off
[   16.509532] sd 3:0:0:0: [sdj] Mode Sense: d7 00 10 08
[   16.510861] sd 3:0:0:0: [sdj] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.522593] sd 3:0:1:0: Attached scsi generic sg10 type 0
[   16.522759]  sdj: sdj1 sdj9
[   16.523057] sd 3:0:1:0: [sdk] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.528211] sd 3:0:1:0: [sdk] Write Protect is off
[   16.528214] sd 3:0:1:0: [sdk] Mode Sense: d7 00 10 08
[   16.530029] sd 3:0:1:0: [sdk] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.535869] sd 3:0:0:0: [sdj] Attached SCSI disk
[   16.545809]  sdk: sdk1 sdk9
[   16.553421] sd 3:0:1:0: [sdk] Attached SCSI disk
[   16.559721] sd 3:0:2:0: Attached scsi generic sg11 type 0
[   16.559930] sd 3:0:2:0: [sdl] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.560876] sd 3:0:2:0: [sdl] Write Protect is off
[   16.560880] sd 3:0:2:0: [sdl] Mode Sense: d7 00 10 08
[   16.561424] sd 3:0:2:0: [sdl] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.579652] sd 3:0:3:0: Attached scsi generic sg12 type 0
[   16.584941] sd 3:0:4:0: Attached scsi generic sg13 type 0
[   16.585205] sd 3:0:4:0: [sdn] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.590244] sd 3:0:4:0: [sdn] Write Protect is off
[   16.590247] sd 3:0:4:0: [sdn] Mode Sense: d7 00 10 08
[   16.590820] sd 3:0:4:0: [sdn] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.595308] sd 3:0:3:0: [sdm] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.595927]  sdl: sdl1 sdl9
[   16.599987] sd 3:0:3:0: [sdm] Write Protect is off
[   16.599996] sd 3:0:3:0: [sdm] Mode Sense: d7 00 10 08
[   16.601006] sd 3:0:3:0: [sdm] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.611179] sd 3:0:2:0: [sdl] Attached SCSI disk
[   16.621188]  sdm: sdm1 sdm9
[   16.621920]  sdn: sdn1 sdn9
[   16.631919] sd 3:0:3:0: [sdm] Attached SCSI disk
[   16.641101] sd 3:0:4:0: [sdn] Attached SCSI disk
[   16.651243] sd 3:0:5:0: Attached scsi generic sg14 type 0
[   16.651458] sd 3:0:5:0: [sdo] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.652367] sd 3:0:5:0: [sdo] Write Protect is off
[   16.652370] sd 3:0:5:0: [sdo] Mode Sense: d7 00 10 08
[   16.656289] sd 3:0:5:0: [sdo] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.672397]  sdo: sdo1 sdo9
[   16.672628] sd 3:0:6:0: Attached scsi generic sg15 type 0
[   16.672895] sd 3:0:6:0: [sdp] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.672926] sd 3:0:7:0: Attached scsi generic sg16 type 0
[   16.673456] sd 3:0:7:0: [sdq] 3907029168 512-byte logical blocks: (2.00
TB/1.81 TiB)
[   16.674218] sd 3:0:6:0: [sdp] Write Protect is off
[   16.674222] sd 3:0:6:0: [sdp] Mode Sense: d7 00 10 08
[   16.678415] sd 3:0:6:0: [sdp] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.678646] sd 3:0:7:0: [sdq] Write Protect is off
[   16.678649] sd 3:0:7:0: [sdq] Mode Sense: d7 00 10 08
[   16.679391] sd 3:0:7:0: [sdq] Write cache: enabled, read cache: enabled,
supports DPO and FUA
[   16.718785]  sdp: sdp1 sdp9
[   16.718975]  sdq: sdq1 sdq9
[   16.732110] sd 3:0:6:0: [sdp] Attached SCSI disk
[   16.741467] sd 3:0:7:0: [sdq] Attached SCSI disk
[   16.747488] sd 3:0:5:0: [sdo] Attached SCSI disk

And finally reported errors on load:
[ 2007.415225] sd 0:0:6:0: [sdh] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 2007.415239] sd 0:0:6:0: [sdh] tag#0 Sense Key : Aborted Command [current] 
[ 2007.415246] sd 0:0:6:0: [sdh] tag#0 Add. Sense: Ack/nak timeout
[ 2007.415252] sd 0:0:6:0: [sdh] tag#0 CDB: Read(10) 28 00 2d 02 9d 24 00 00 dc
00
[ 2007.415257] blk_update_request: I/O error, dev sdh, sector 755146020
[ 2958.428448] sd 0:0:6:0: [sdh] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 2958.428466] sd 0:0:6:0: [sdh] tag#0 Sense Key : Aborted Command [current] 
[ 2958.428474] sd 0:0:6:0: [sdh] tag#0 Add. Sense: Ack/nak timeout
[ 2958.428481] sd 0:0:6:0: [sdh] tag#0 CDB: Read(10) 28 00 08 fe 2f c9 00 00 dd
00
[ 2958.428486] blk_update_request: I/O error, dev sdh, sector 150876105

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
