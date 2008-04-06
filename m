From: Wakko Warner <wakko@animx.eu.org>
Subject: mptsas problem
Date: Sun, 6 Apr 2008 15:56:29 -0400
Message-ID: <20080406195628.GA1084@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:43723 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbYDFUpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Apr 2008 16:45:02 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.64 #1 (Debian Bug?  What bug /\oo/\))
	id 1Jiayb-0000r3-0i
	for linux-scsi@vger.kernel.org; Sun, 06 Apr 2008 15:56:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recall seeing some of this problem on the list a few days ago, but I can't
remember what the subject was and was unable to find the thread.

I'm seeing this:
Apr  5 17:10:07 ani kernel: [519452.504149] mptscsih: ioc0: attempting task abort! (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519452.504157] sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 44 57 eb 99 00 00 28 00
Apr  5 17:10:36 ani kernel: [519452.760082] mptscsih: ioc0: task abort: FAILED (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519452.760092] mptscsih: ioc0: attempting target reset! (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519452.760100] sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 44 57 eb 99 00 00 28 00
Apr  5 17:10:36 ani kernel: [519453.016015] mptscsih: ioc0: target reset: SUCCESS (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519454.164003] mptbase: ioc0: LogInfo(0x31110e00): Originator={PL}, Code={Reset}, SubCode(0x0e00)
Apr  5 17:10:36 ani kernel: [519454.164016] mptscsih: ioc0: attempting bus reset! (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519454.164019] sd 0:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 44 57 eb 99 00 00 28 00
Apr  5 17:10:36 ani kernel: [519454.419666] mptscsih: ioc0: bus reset: SUCCESS (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519464.427314] mptbase: ioc0: LogInfo(0x31110e00): Originator={PL}, Code={Reset}, SubCode(0x0e00)
Apr  5 17:10:36 ani kernel: [519464.427327] mptscsih: ioc0: attempting host reset! (sc=ebd80500)
Apr  5 17:10:36 ani kernel: [519464.427331] mptbase: ioc0: Initiating recovery
Apr  5 17:10:36 ani kernel: [519481.736841] mptscsih: ioc0: host reset: SUCCESS (sc=ebd80500)
Apr  5 17:10:37 ani kernel: [519481.736847] sd 0:0:0:0: Device offlined - not ready after error recovery
Apr  5 17:10:37 ani kernel: [519481.736860] sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x06
Apr  5 17:10:37 ani kernel: [519481.736864] end_request: I/O error, dev sda, sector 1146612633
Apr  5 17:10:37 ani kernel: [519481.736883] sd 0:0:0:0: rejecting I/O to offline device

This is from boot up:
Mar 30 16:53:48 ani kernel: [   84.772554] mptbase: ioc0: Initiating bringup
Mar 30 16:53:48 ani kernel: [   85.474583] ioc0: LSISAS1068 B0: Capabilities={Initiator}
Mar 30 16:53:48 ani kernel: [   98.944823] scsi0 : ioc0: LSISAS1068 B0, FwRev=01060000h, Ports=1, MaxQ=511, IRQ=16
Mar 30 16:53:48 ani kernel: [   98.957157] scsi 0:0:0:0: Direct-Access     ATA      ST3750640AS      E    PQ: 0 ANSI: 5
Mar 30 16:53:48 ani kernel: [   98.957626] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:48 ani kernel: [   98.958701] sd 0:0:0:0: [sda] Write Protect is off
Mar 30 16:53:48 ani kernel: [   98.958747] sd 0:0:0:0: [sda] Mode Sense: 67 00 00 08
Mar 30 16:53:48 ani kernel: [   98.960814] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:48 ani kernel: [   98.961067] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:48 ani kernel: [   98.962139] sd 0:0:0:0: [sda] Write Protect is off
Mar 30 16:53:48 ani kernel: [   98.962184] sd 0:0:0:0: [sda] Mode Sense: 67 00 00 08
Mar 30 16:53:48 ani kernel: [   98.964235] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:48 ani kernel: [   98.964293]  sda: sda1 sda2
Mar 30 16:53:48 ani kernel: [   98.984038] sd 0:0:0:0: [sda] Attached SCSI disk
Mar 30 16:53:48 ani kernel: [   98.988380] scsi 0:0:1:0: Direct-Access     ATA      ST3750640AS      E    PQ: 0 ANSI: 5
Mar 30 16:53:48 ani kernel: [   98.988853] sd 0:0:1:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:48 ani kernel: [   98.989922] sd 0:0:1:0: [sdb] Write Protect is off
Mar 30 16:53:48 ani kernel: [   98.989968] sd 0:0:1:0: [sdb] Mode Sense: 67 00 00 08
Mar 30 16:53:48 ani kernel: [   98.992016] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:48 ani kernel: [   98.992257] sd 0:0:1:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:48 ani kernel: [   98.993326] sd 0:0:1:0: [sdb] Write Protect is off
Mar 30 16:53:48 ani kernel: [   98.993371] sd 0:0:1:0: [sdb] Mode Sense: 67 00 00 08
Mar 30 16:53:48 ani kernel: [   98.995419] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:48 ani kernel: [   98.995476]  sdb: sdb1 sdb2
Mar 30 16:53:48 ani kernel: [   99.019001] sd 0:0:1:0: [sdb] Attached SCSI disk
Mar 30 16:53:48 ani kernel: [   99.023408] scsi 0:0:2:0: Direct-Access     ATA      ST3750640AS      E    PQ: 0 ANSI: 5
Mar 30 16:53:49 ani kernel: [   99.023877] sd 0:0:2:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:49 ani kernel: [   99.024955] sd 0:0:2:0: [sdc] Write Protect is off
Mar 30 16:53:49 ani kernel: [   99.025000] sd 0:0:2:0: [sdc] Mode Sense: 67 00 00 08
Mar 30 16:53:49 ani kernel: [   99.027040] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:49 ani kernel: [   99.027283] sd 0:0:2:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
Mar 30 16:53:49 ani kernel: [   99.028352] sd 0:0:2:0: [sdc] Write Protect is off
Mar 30 16:53:49 ani kernel: [   99.028398] sd 0:0:2:0: [sdc] Mode Sense: 67 00 00 08
Mar 30 16:53:49 ani kernel: [   99.030434] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:49 ani kernel: [   99.030491]  sdc: sdc1 sdc2
Mar 30 16:53:49 ani kernel: [   99.056963] sd 0:0:2:0: [sdc] Attached SCSI disk
Mar 30 16:53:49 ani kernel: [   99.058503] scsi 0:0:3:0: Direct-Access     ATA      WDC WD800JD-75MS 1E04 PQ: 0 ANSI: 5
Mar 30 16:53:49 ani kernel: [   99.058990] sd 0:0:3:0: [sdd] 156250000 512-byte hardware sectors (80000 MB)
Mar 30 16:53:49 ani kernel: [   99.059669] sd 0:0:3:0: [sdd] Write Protect is off
Mar 30 16:53:49 ani kernel: [   99.059715] sd 0:0:3:0: [sdd] Mode Sense: 67 00 00 08
Mar 30 16:53:49 ani kernel: [   99.060975] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:49 ani kernel: [   99.061247] sd 0:0:3:0: [sdd] 156250000 512-byte hardware sectors (80000 MB)
Mar 30 16:53:49 ani kernel: [   99.061921] sd 0:0:3:0: [sdd] Write Protect is off
Mar 30 16:53:49 ani kernel: [   99.061966] sd 0:0:3:0: [sdd] Mode Sense: 67 00 00 08
Mar 30 16:53:49 ani kernel: [   99.063235] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 30 16:53:49 ani kernel: [   99.063291]  sdd: unknown partition table
Mar 30 16:53:49 ani kernel: [   99.091033] sd 0:0:3:0: [sdd] Attached SCSI disk

My configuration:
LSI SAS PCI-X LSISAS1068 controller
SuperMicro X5DAE motherboard (Intel E7505 chipset)
4GB memory
Pristine Kernel 2.6.24.3
3x Seagate ST3750640AS SATA (Not sure what the firmware is, ident just shows
"E") sda sdb and sdc.  These disks are in RAID1 (partition 1) and RAID5
(partition 2)
1x WDC WD800JD-75MS SATA sdd.

I've had sda, sdb, and sdc stop working as show in the above log for sda.  I
checked /sys/block/sd[abc]/device/queue_depth.  All 4 of my drives were 64. 
(NOTE: I have 6 of the same seagate drives on a supermicro X7DA3 with an
adaptec sas onboard.  Those show 31 in queue_depth).  I have since changed
queue_depth to 1.

The last time the disk dropped out was when I was compressing a large file
to a usb device.

One more thing that I tried (which didn't effect queue_depth).  I changed
CONFIG_FUSION_MAX_SGE from the max (128 I think) to the minimum of 16.

Anyone tell me what's going on?


lspci output:
00:00.0 Host bridge: Intel Corporation E7505 Memory Controller Hub (rev 03)
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, fast devsel, latency 0
        Memory at dc000000 (32-bit, prefetchable) [size=64M]
        Capabilities: <access denied>

00:00.1 Class ff00: Intel Corporation E7505/E7205 Series RAS Controller (rev 03)
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: fast devsel

00:01.0 PCI bridge: Intel Corporation E7505/E7205 PCI-to-AGP Bridge (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 96
        Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: d8100000-d81fffff
        Prefetchable memory behind bridge: e8000000-f7ffffff
        Capabilities: <access denied>

00:02.0 PCI bridge: Intel Corporation E7505 Hub Interface B PCI-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 64
        Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
        I/O behind bridge: 00004000-00005fff
        Memory behind bridge: d8200000-d84fffff
        Prefetchable memory behind bridge: d4000000-d41fffff

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 18
        I/O ports at 2440 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at 2460 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 20
        I/O ports at 2480 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 21
        Memory at d8000000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=64

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 02)
        Flags: bus master, medium devsel, latency 0

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 20
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at 24a0 [size=16]
        Memory at d8000400 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 02)
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: medium devsel, IRQ 22
        I/O ports at 1100 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 02)
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, medium devsel, latency 0, IRQ 22
        I/O ports at 2000 [size=256]
        I/O ports at 2400 [size=64]
        Memory at d8000c00 (32-bit, non-prefetchable) [size=512]
        Memory at d8000800 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (rev 01) (prog-if 00 [VGA])
        Subsystem: Hightech Information System Ltd. Unknown device 320e
        Flags: bus master, fast Back2Back, 66MHz, medium devsel, latency 66, IRQ 23
        Memory at e8000000 (32-bit, prefetchable) [size=128M]
        I/O ports at 3000 [size=256]
        Memory at d8100000 (32-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d8120000 [disabled] [size=128K]
        Capabilities: <access denied>

01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 SE] (Secondary) (rev 01)
        Subsystem: Hightech Information System Ltd. Unknown device 320f
        Flags: fast Back2Back, 66MHz, medium devsel
        Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Memory at d8110000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>

02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 20 [IO(X)-APIC])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, 66MHz, fast devsel, latency 0
        Memory at d8200000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 64
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: d8300000-d83fffff
        Capabilities: <access denied>

02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 20 [IO(X)-APIC])
        Subsystem: Super Micro Computer Inc Unknown device 4080
        Flags: bus master, 66MHz, fast devsel, latency 0
        Memory at d8201000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 64
        Bus: primary=02, secondary=04, subordinate=04, sec-latency=64
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: d8400000-d84fffff
        Prefetchable memory behind bridge: 00000000d4000000-00000000d41fffff
        Capabilities: <access denied>

03:03.0 Ethernet controller: Intel Corporation 82545EM Gigabit Ethernet Controller (Copper) (rev 01)
        Subsystem: Intel Corporation Unknown device 1011
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
        Memory at d8300000 (64-bit, non-prefetchable) [size=128K]
        I/O ports at 4000 [size=64]
        Capabilities: <access denied>

04:02.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01)
        Subsystem: LSI Logic / Symbios Logic Unknown device 3030
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 16
        I/O ports at 5000 [disabled] [size=256]
        Memory at d8410000 (64-bit, non-prefetchable) [size=16K]
        Memory at d8400000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d4000000 [disabled] [size=2M]
        Capabilities: <access denied>

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
