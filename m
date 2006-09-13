From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Wed, 13 Sep 2006 17:37:07 +0200
Message-ID: <20060913153707.GA19796@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <20060911064008.GA26293@stat.unipd.it> <1157994026.3470.3.camel@mulgrave.il.steeleye.com> <20060912064514.GA28121@stat.unipd.it> <1158156671.3462.7.camel@mulgrave.il.steeleye.com> <45081936.4040209@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stavromula.stat.unipd.it ([147.162.35.208]:12933 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S1750957AbWIMPhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 11:37:22 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id 58DDF1AF574EF
	for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2006 17:37:18 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 31816-08 for <linux-scsi@vger.kernel.org>;
	Wed, 13 Sep 2006 17:37:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <45081936.4040209@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 13, 2006 at 10:44:06AM -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
[...]
> Yes dmesg would be useful. Is there something stopping
> the mid level scanning luns where lun>0 (perhaps something
> in the black list)?

	OK, here are the logs. Since last post I upgraded system to 
	Debian Sid, and tried to set up multipath (static in kernel). 
	This has complicated further the setup and messed up logs: device 
	mapper complains about something and logs some Oops...
	No surprise I'm not able to mount multipath devs from /dev/mapper/. 
	Since I'm new to multipath probably I'm doing some mistake.

	I'll see if I can try a -mm kernel tomorrow (I'm home now).

	Attached: 
	dmesg.1 	full dmesg from boot, _before_ issuing command rescan-scsi-bus.sh -l 
	dmesg.2 	same after rescanning.
	rescan.log	stdout from rescan, including related syslog messages 
	rescan.err 	is some error issued by rescan (v 1.18 2005/10/08 23:49:29 garloff)
	lsscsi.log 	lsscsi -g after rescanning 
	lsmod    	after rescanning 
	ps.log: 	processes after rescanning

	Thank you, 

		Alberto

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.1"

Linux version 2.6.18-rc6 (root@novantatre) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Sat Sep 9 09:46:54 CEST 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
 BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffcc140 (usable)
 BIOS-e820: 00000000bffcc140 - 00000000bffd0000 (ACPI data)
 BIOS-e820: 00000000bffd0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
2175MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 0009c140
On node 0 totalpages: 786380
  DMA zone: 4096 pages, LIFO batch:0
  Normal zone: 225280 pages, LIFO batch:31
  HighMem zone: 557004 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 IBM                                   ) @ 0x000fdfc0
ACPI: RSDT (v001 IBM    SERONYXP 0x00001000 IBM  0x45444f43) @ 0xbffcff80
ACPI: FADT (v001 IBM    SERONYXP 0x00001000 IBM  0x45444f43) @ 0xbffcff00
ACPI: MADT (v001 IBM    SERONYXP 0x00001000 IBM  0x45444f43) @ 0xbffcfe40
ACPI: MCFG (v001 IBM    SERONYXP 0x00001000 IBM  0x45444f43) @ 0xbffcfe00
ACPI: DSDT (v001 IBM    SERGEODE 0x00001000 MSFT 0x0100000b) @ 0x00000000
ACPI: PM-Timer IO Port: 0x588
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:3 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0c] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 12, version 32, address 0xfec80400, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
Detected 3400.456 MHz processor.
Built 1 zonelists.  Total pages: 786380
Kernel command line: root=/dev/sda1 ro 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80400)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3113528k/3145520k available (3291k kernel code, 30828k reserved, 1456k data, 244k init, 2228016k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6803.84 BogoMIPS (lpj=34019249)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20060707
 tbxface-0107 [01] load_tables           : ACPI Tables successfully acquired
Parsing all Control Methods:
Table [DSDT](id 0005) - 418 Objects with 56 Devices 136 Methods 19 Regions
ACPI Namespace successfully loaded at root c060af50
evxfevnt-0089 [02] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6800.48 BogoMIPS (lpj=34002410)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU1: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 2/6 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6800.53 BogoMIPS (lpj=34002653)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU2: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 3/7 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6800.54 BogoMIPS (lpj=34002723)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU3: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Total of 4 processors activated (27205.40 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
migration_cost=62,796
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on 8:1
PCI: No mmconfig possible on 9:1
Setting up standard PCI resources
evgpeblk-0951 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0951 [04] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 1 Runtime GPEs in this block
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:..................................
Initialized 11/19 Regions 0/0 Fields 11/12 Buffers 12/14 Packages (427 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 62 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0580-05ff claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0400-043f claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:01:06.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *5)
ACPI: PCI Interrupt Link [LP01] (IRQs *11)
ACPI: PCI Interrupt Link [LP02] (IRQs *5)
ACPI: PCI Interrupt Link [LP03] (IRQs *11)
ACPI: PCI Interrupt Link [LP04] (IRQs *11)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP06] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
Intel 82802 RNG detected
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 1 of device 0000:00:00.0
pnp: 00:01: ioport range 0x510-0x517 could not be reserved
pnp: 00:01: ioport range 0x504-0x507 could not be reserved
pnp: 00:01: ioport range 0x500-0x503 could not be reserved
pnp: 00:01: ioport range 0x520-0x53f has been reserved
pnp: 00:01: ioport range 0x540-0x547 has been reserved
pnp: 00:01: ioport range 0x460-0x461 has been reserved
pnp: 00:0f: ioport range 0x400-0x43f has been reserved
PCI: Failed to allocate mem resource #9:100000@cbc00000 for 0000:02:00.0
PCI: Bridge: 0000:02:00.0
  IO window: 4000-4fff
  MEM window: ce000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.2
  IO window: 5000-7fff
  MEM window: cbc00000-cdefffff
  PREFETCH window: cb800000-cbbfffff
PCI: Bridge: 0000:00:02.0
  IO window: 4000-7fff
  MEM window: cbc00000-cfffffff
  PREFETCH window: cb800000-cbbfffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: ca000000-cb7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: c8000000-c9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: 8000-ffff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: de000000-dfffffff
  PREFETCH window: d0000000-ddffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:02:00.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Initializing Cryptographic API
io scheduler noop registered (default)
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
PCI: Setting latency timer of device 0000:00:07.0 to 64
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie01]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
fakephp: Fake PCI Hot Plug Controller Driver
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 20 (level, low) -> IRQ 18
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=143.00 Mhz, System=143.00 MHz
radeonfb: PLL min 12000 max 35000
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type CRT found
radeonfb: EDID probed
Console: switching to colour frame buffer device 128x48
radeonfb (0000:01:06.0): ATI Radeon QY 
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Intel(R) PRO/1000 Network Driver - version 7.1.9-k4
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
tg3.c:v3.65 (August 07, 2006)
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:06:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:11:25:3f:09:04
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:07:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:11:25:3f:09:05
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: SAMSUNG CD-ROM SC-148A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 48X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 24 (level, low) -> IRQ 19
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

 target0:0:5: asynchronous
  Vendor: IBM       Model: ULT3580-TD3       Rev: 57F7
  Type:   Sequential-Access                  ANSI SCSI revision: 03
 target0:0:5: Beginning Domain Validation
 target0:0:5: wide asynchronous
 target0:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:5: Ending Domain Validation
  Vendor: IBM       Model: ULT3581-TA2       Rev: 3.10
  Type:   Medium Changer                     ANSI SCSI revision: 02
ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 38 (level, low) -> IRQ 20
scsi1 : IBM PCI ServeRAID 7.12.05  Build 761
  Vendor: IBM       Model: SERVERAID         Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: IBM       Model: SERVERAID         Rev: 1.00
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: IBM       Model: 25P3471a S320  2  Rev: 1   
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: IBM       Model: 02R0962a S320  1  Rev: 1   
  Type:   Processor                          ANSI SCSI revision: 02
st: Version 20050830, fixed bufsize 32768, s/g segs 256
st 0:0:5:0: Attached scsi tape st0
st0: try direct i/o: yes (alignment 512 B)
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 1:0:0:0: Attached scsi disk sda
SCSI Media Changer driver v0.25 
ch0: type #1 (mt): 0x52+1 [medium transport]
ch0: type #2 (st): 0x1+8 [storage]
ch0: type #3 (ie): 0x0+0 [import/export]
ch0: type #4 (dt): 0x56+1 [data transfer]
ch0: dt 0x56: ID 5, LUN 0, name: IBM      ULT3580-TD3      57F7
ch0: INITIALIZE ELEMENT STATUS, may take some time ...
ch0: ... finished
ch 0:0:5:1: Attached scsi changer ch0
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xf0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002200
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00002600
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x64,0x60 irq 1,12
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: multipath personality registered for level -4
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.4 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
input: AT Translated Set 2 keyboard as /class/input/input0
device-mapper: multipath emc: version 0.0.3 loaded
EDAC MC: Ver: 2.0.1 Sep  9 2006
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
All bugs added by David S. Miller <davem@redhat.com>
Starting balanced_irq
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
Time: tsc clocksource has been installed.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 244k freed
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 16 (level, low) -> IRQ 16
skge 1.6 addr 0xdfffc000 irq 16 chip Yukon rev 1
skge eth2: addr 00:0f:3d:f4:41:61
QLogic iSCSI HBA Driver (f98af000)
ACPI: PCI Interrupt 0000:03:0c.1[B] -> GSI 26 (level, low) -> IRQ 23
qla4xxx 0000:03:0c.1: Found an ISP4010, irq 23, iobase 0xf8818000
qla4xxx 0000:03:0c.1: Configuring PCI space...
qla4xxx 0000:03:0c.1: Configuring NVRAM ...
input: PC Speaker as /class/input/input2
Emulex LightPulse Fibre Channel SCSI driver 8.1.9
Copyright(c) 2004-2006 Emulex.  All rights reserved.
st 0:0:5:0: Attached scsi generic sg0 type 1
ch 0:0:5:1: Attached scsi generic sg1 type 8
sd 1:0:0:0: Attached scsi generic sg2 type 0
scsi 1:0:15:0: Attached scsi generic sg3 type 3
scsi 1:1:9:0: Attached scsi generic sg4 type 3
scsi 1:2:8:0: Attached scsi generic sg5 type 3
qla4xxx 0000:03:0c.1: Initializing firmware..
qla4xxx 0000:03:0c.1: Waiting for Firmware Ready..
qla4xxx 0000:03:0c.1: Firmware Ready..
qla4xxx 0000:03:0c.1: ISNS disabled...
qla4xxx 0000:03:0c.1: Initializing DDBs ...
qla4xxx 0000:03:0c.1: DDB[0] MB0 4000 Tot 3 Next 2 State 0000 ConnErr 00000000 0.0.0.0:3260 ""
qla4xxx 0000:03:0c.1: DDB[0] MB0 4000 Tot 3 Next 2 State 0000 ConnErr 00000000 0.0.0.0:3260 ""
qla4xxx 0000:03:0c.1: DDB[2] MB0 4000 Tot 3 Next 3 State 0006 ConnErr 00040006 10.10.10.100:3260 "iqn.2001-04.com.example:storage.disk2.sys1.xyz"
qla4xxx 0000:03:0c.1: DDB[2] MB0 4000 Tot 3 Next 3 State 0006 ConnErr 00040006 10.10.10.100:3260 "iqn.2001-04.com.example:storage.disk2.sys1.xyz"
qla4xxx 0000:03:0c.1: DDB[3] MB0 4000 Tot 3 Next 4 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm.2521335.20060811134620.l7"
qla4xxx 0000:03:0c.1: DDB[3] MB0 4000 Tot 3 Next 4 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm.2521335.20060811134620.l7"
qla4xxx 0000:03:0c.1: DDB[4] MB0 4000 Tot 3 Next 0 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm:2678f7.20060511125624.l8"
qla4xxx 0000:03:0c.1: DDB[4] MB0 4000 Tot 3 Next 0 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm:2678f7.20060511125624.l8"
qla4xxx 0000:03:0c.1: DDB list done..
scsi-qla0-mac=000d60b965c3\;
scsi2 : qla4xxx
 QLogic iSCSI HBA Driver version: 5.00.07-d2
  QLogic ISP4010 @ 0000:03:0c.1 hdma-, host#=2, fw=03.00.00.04
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 52 (level, low) -> IRQ 24
scsi3 :  on PCI bus 04 device 08 irq 24
lpfc 0000:04:01.0: 0:1303 Link Up Event x1 received Data: x1 x1 x0 x0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:0: Attached scsi generic sg6 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:0: Attached scsi generic sg7 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:0: Attached scsi generic sg8 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:0: Attached scsi generic sg9 type 0
Adding 3903784k swap on /dev/sda2.  Priority:-1 extents:1 across:3903784k
EXT3 FS on sda1, internal journal
8139cp: 10/100 PCI Ethernet driver v1.2 (Mar 22, 2004)
skge eth2: enabling interface
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
skge eth2: Link is up at 1000 Mbps, full duplex, flow control tx and rx
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
Loading iSCSI transport class v1.1-646.<5>iscsi: registered transport (tcp)
scsi4 : iSCSI Initiator over TCP/IP
  Vendor: IBM       Model: DS300    S320     Rev: 7.01
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdb: 716492800 512-byte hdwr sectors (366844 MB)
sdb: Write Protect is off
sdb: Mode Sense: 8f 00 00 08
SCSI device sdb: drive cache: write through
SCSI device sdb: 716492800 512-byte hdwr sectors (366844 MB)
sdb: Write Protect is off
sdb: Mode Sense: 8f 00 00 08
SCSI device sdb: drive cache: write through
 sdb: sdb1
sd 4:0:0:0: Attached scsi disk sdb
sd 4:0:0:0: Attached scsi generic sg10 type 0

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2"

s with 56 Devices 136 Methods 19 Regions
ACPI Namespace successfully loaded at root c060af50
evxfevnt-0089 [02] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6800.48 BogoMIPS (lpj=34002410)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU1: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 2/6 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6800.53 BogoMIPS (lpj=34002653)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU2: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Booting processor 3/7 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6800.54 BogoMIPS (lpj=34002723)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 20000000 00000000 00000000 0000459d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20000000 00000000 00000180 0000459d 00000000 00000000
CPU3: Intel(R) Xeon(TM) CPU 3.40GHz stepping 04
Total of 4 processors activated (27205.40 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
migration_cost=62,796
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on 8:1
PCI: No mmconfig possible on 9:1
Setting up standard PCI resources
evgpeblk-0951 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0951 [04] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 1 Runtime GPEs in this block
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:..................................
Initialized 11/19 Regions 0/0 Fields 11/12 Buffers 12/14 Packages (427 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 62 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0580-05ff claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0400-043f claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:01:06.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *5)
ACPI: PCI Interrupt Link [LP01] (IRQs *11)
ACPI: PCI Interrupt Link [LP02] (IRQs *5)
ACPI: PCI Interrupt Link [LP03] (IRQs *11)
ACPI: PCI Interrupt Link [LP04] (IRQs *11)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP06] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
Intel 82802 RNG detected
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 1 of device 0000:00:00.0
pnp: 00:01: ioport range 0x510-0x517 could not be reserved
pnp: 00:01: ioport range 0x504-0x507 could not be reserved
pnp: 00:01: ioport range 0x500-0x503 could not be reserved
pnp: 00:01: ioport range 0x520-0x53f has been reserved
pnp: 00:01: ioport range 0x540-0x547 has been reserved
pnp: 00:01: ioport range 0x460-0x461 has been reserved
pnp: 00:0f: ioport range 0x400-0x43f has been reserved
PCI: Failed to allocate mem resource #9:100000@cbc00000 for 0000:02:00.0
PCI: Bridge: 0000:02:00.0
  IO window: 4000-4fff
  MEM window: ce000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.2
  IO window: 5000-7fff
  MEM window: cbc00000-cdefffff
  PREFETCH window: cb800000-cbbfffff
PCI: Bridge: 0000:00:02.0
  IO window: 4000-7fff
  MEM window: cbc00000-cfffffff
  PREFETCH window: cb800000-cbbfffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: ca000000-cb7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: c8000000-c9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: 8000-ffff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: de000000-dfffffff
  PREFETCH window: d0000000-ddffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:02:00.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Initializing Cryptographic API
io scheduler noop registered (default)
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
PCI: Setting latency timer of device 0000:00:07.0 to 64
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie01]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
fakephp: Fake PCI Hot Plug Controller Driver
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 20 (level, low) -> IRQ 18
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=143.00 Mhz, System=143.00 MHz
radeonfb: PLL min 12000 max 35000
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type CRT found
radeonfb: EDID probed
Console: switching to colour frame buffer device 128x48
radeonfb (0000:01:06.0): ATI Radeon QY 
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
Intel(R) PRO/1000 Network Driver - version 7.1.9-k4
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
tg3.c:v3.65 (August 07, 2006)
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:06:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:11:25:3f:09:04
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:07:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:11:25:3f:09:05
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: SAMSUNG CD-ROM SC-148A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 48X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt 0000:03:0d.0[A] -> GSI 24 (level, low) -> IRQ 19
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

 target0:0:5: asynchronous
  Vendor: IBM       Model: ULT3580-TD3       Rev: 57F7
  Type:   Sequential-Access                  ANSI SCSI revision: 03
 target0:0:5: Beginning Domain Validation
 target0:0:5: wide asynchronous
 target0:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:5: Ending Domain Validation
  Vendor: IBM       Model: ULT3581-TA2       Rev: 3.10
  Type:   Medium Changer                     ANSI SCSI revision: 02
ACPI: PCI Interrupt 0000:03:0e.0[A] -> GSI 38 (level, low) -> IRQ 20
scsi1 : IBM PCI ServeRAID 7.12.05  Build 761
  Vendor: IBM       Model: SERVERAID         Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: IBM       Model: SERVERAID         Rev: 1.00
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: IBM       Model: 25P3471a S320  2  Rev: 1   
  Type:   Processor                          ANSI SCSI revision: 02
  Vendor: IBM       Model: 02R0962a S320  1  Rev: 1   
  Type:   Processor                          ANSI SCSI revision: 02
st: Version 20050830, fixed bufsize 32768, s/g segs 256
st 0:0:5:0: Attached scsi tape st0
st0: try direct i/o: yes (alignment 512 B)
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 1:0:0:0: Attached scsi disk sda
SCSI Media Changer driver v0.25 
ch0: type #1 (mt): 0x52+1 [medium transport]
ch0: type #2 (st): 0x1+8 [storage]
ch0: type #3 (ie): 0x0+0 [import/export]
ch0: type #4 (dt): 0x56+1 [data transfer]
ch0: dt 0x56: ID 5, LUN 0, name: IBM      ULT3580-TD3      57F7
ch0: INITIALIZE ELEMENT STATUS, may take some time ...
ch0: ... finished
ch 0:0:5:1: Attached scsi changer ch0
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xf0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002200
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00002600
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x64,0x60 irq 1,12
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: multipath personality registered for level -4
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.4 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
input: AT Translated Set 2 keyboard as /class/input/input0
device-mapper: multipath emc: version 0.0.3 loaded
EDAC MC: Ver: 2.0.1 Sep  9 2006
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
All bugs added by David S. Miller <davem@redhat.com>
Starting balanced_irq
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
Time: tsc clocksource has been installed.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 244k freed
ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 16 (level, low) -> IRQ 16
skge 1.6 addr 0xdfffc000 irq 16 chip Yukon rev 1
skge eth2: addr 00:0f:3d:f4:41:61
QLogic iSCSI HBA Driver (f98af000)
ACPI: PCI Interrupt 0000:03:0c.1[B] -> GSI 26 (level, low) -> IRQ 23
qla4xxx 0000:03:0c.1: Found an ISP4010, irq 23, iobase 0xf8818000
qla4xxx 0000:03:0c.1: Configuring PCI space...
qla4xxx 0000:03:0c.1: Configuring NVRAM ...
input: PC Speaker as /class/input/input2
Emulex LightPulse Fibre Channel SCSI driver 8.1.9
Copyright(c) 2004-2006 Emulex.  All rights reserved.
st 0:0:5:0: Attached scsi generic sg0 type 1
ch 0:0:5:1: Attached scsi generic sg1 type 8
sd 1:0:0:0: Attached scsi generic sg2 type 0
scsi 1:0:15:0: Attached scsi generic sg3 type 3
scsi 1:1:9:0: Attached scsi generic sg4 type 3
scsi 1:2:8:0: Attached scsi generic sg5 type 3
qla4xxx 0000:03:0c.1: Initializing firmware..
qla4xxx 0000:03:0c.1: Waiting for Firmware Ready..
qla4xxx 0000:03:0c.1: Firmware Ready..
qla4xxx 0000:03:0c.1: ISNS disabled...
qla4xxx 0000:03:0c.1: Initializing DDBs ...
qla4xxx 0000:03:0c.1: DDB[0] MB0 4000 Tot 3 Next 2 State 0000 ConnErr 00000000 0.0.0.0:3260 ""
qla4xxx 0000:03:0c.1: DDB[0] MB0 4000 Tot 3 Next 2 State 0000 ConnErr 00000000 0.0.0.0:3260 ""
qla4xxx 0000:03:0c.1: DDB[2] MB0 4000 Tot 3 Next 3 State 0006 ConnErr 00040006 10.10.10.100:3260 "iqn.2001-04.com.example:storage.disk2.sys1.xyz"
qla4xxx 0000:03:0c.1: DDB[2] MB0 4000 Tot 3 Next 3 State 0006 ConnErr 00040006 10.10.10.100:3260 "iqn.2001-04.com.example:storage.disk2.sys1.xyz"
qla4xxx 0000:03:0c.1: DDB[3] MB0 4000 Tot 3 Next 4 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm.2521335.20060811134620.l7"
qla4xxx 0000:03:0c.1: DDB[3] MB0 4000 Tot 3 Next 4 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm.2521335.20060811134620.l7"
qla4xxx 0000:03:0c.1: DDB[4] MB0 4000 Tot 3 Next 0 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm:2678f7.20060511125624.l8"
qla4xxx 0000:03:0c.1: DDB[4] MB0 4000 Tot 3 Next 0 State 0006 ConnErr 00060009 10.10.10.200:3260 "iqn.1986-03.com.ibm:2678f7.20060511125624.l8"
qla4xxx 0000:03:0c.1: DDB list done..
scsi-qla0-mac=000d60b965c3\;
scsi2 : qla4xxx
 QLogic iSCSI HBA Driver version: 5.00.07-d2
  QLogic ISP4010 @ 0000:03:0c.1 hdma-, host#=2, fw=03.00.00.04
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 52 (level, low) -> IRQ 24
scsi3 :  on PCI bus 04 device 08 irq 24
lpfc 0000:04:01.0: 0:1303 Link Up Event x1 received Data: x1 x1 x0 x0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:0: Attached scsi generic sg6 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:0: Attached scsi generic sg7 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:0: Attached scsi generic sg8 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:0: Attached scsi generic sg9 type 0
Adding 3903784k swap on /dev/sda2.  Priority:-1 extents:1 across:3903784k
EXT3 FS on sda1, internal journal
8139cp: 10/100 PCI Ethernet driver v1.2 (Mar 22, 2004)
skge eth2: enabling interface
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
skge eth2: Link is up at 1000 Mbps, full duplex, flow control tx and rx
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
Loading iSCSI transport class v1.1-646.<5>iscsi: registered transport (tcp)
scsi4 : iSCSI Initiator over TCP/IP
  Vendor: IBM       Model: DS300    S320     Rev: 7.01
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdb: 716492800 512-byte hdwr sectors (366844 MB)
sdb: Write Protect is off
sdb: Mode Sense: 8f 00 00 08
SCSI device sdb: drive cache: write through
SCSI device sdb: 716492800 512-byte hdwr sectors (366844 MB)
sdb: Write Protect is off
sdb: Mode Sense: 8f 00 00 08
SCSI device sdb: drive cache: write through
 sdb: sdb1
sd 4:0:0:0: Attached scsi disk sdb
sd 4:0:0:0: Attached scsi generic sg10 type 0
  Vendor: IBM       Model: SERVERAID         Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 143372288 512-byte hdwr sectors (73407 MB)
sdc: assuming Write Enabled
sdc: assuming drive cache: write through
SCSI device sdc: 143372288 512-byte hdwr sectors (73407 MB)
sdc: assuming Write Enabled
sdc: assuming drive cache: write through
 sdc: sdc1 sdc2 sdc3
sd 1:0:0:1: Attached scsi disk sdc
sd 1:0:0:1: Attached scsi generic sg11 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:1: Attached scsi generic sg12 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:2: Attached scsi generic sg13 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:3: Attached scsi generic sg14 type 0
  Vendor: DGC       Model: RAID 0            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdd: 1252566144 512-byte hdwr sectors (641314 MB)
sdd: Write Protect is off
sdd: Mode Sense: 63 00 00 08
sdd: cache data unavailable
sdd: assuming drive cache: write through
SCSI device sdd: 1252566144 512-byte hdwr sectors (641314 MB)
sdd: Write Protect is off
sdd: Mode Sense: 63 00 00 08
sdd: cache data unavailable
sdd: assuming drive cache: write through
 sdd: sdd1
sd 3:0:0:4: Attached scsi disk sdd
sd 3:0:0:4: Attached scsi generic sg15 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:5: Attached scsi generic sg16 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:6: Attached scsi generic sg17 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:0:7: Attached scsi generic sg18 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sde: 546279424 512-byte hdwr sectors (279695 MB)
sde: Write Protect is off
sde: Mode Sense: 63 00 00 08
sde: cache data unavailable
sde: assuming drive cache: write through
SCSI device sde: 546279424 512-byte hdwr sectors (279695 MB)
sde: Write Protect is off
sde: Mode Sense: 63 00 00 08
sde: cache data unavailable
sde: assuming drive cache: write through
 sde: sde1
sd 3:0:1:1: Attached scsi disk sde
sd 3:0:1:1: Attached scsi generic sg19 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:2: Attached scsi generic sg20 type 0
device-mapper: multipath emc: long trespass command will be send
device-mapper: multipath emc: honor reservation bit will not be set (default)
device-mapper: multipath: Failing path 8:48.
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdf: 2097152 512-byte hdwr sectors (1074 MB)
sdf: Write Protect is off
sdf: Mode Sense: 63 00 00 08
sdf: cache data unavailable
sdf: assuming drive cache: write through
SCSI device sdf: 2097152 512-byte hdwr sectors (1074 MB)
sdf: Write Protect is off
sdf: Mode Sense: 63 00 00 08
sdf: cache data unavailable
sdf: assuming drive cache: write through
 sdf:
sd 3:0:1:3: Attached scsi disk sdf
sd 3:0:1:3: Attached scsi generic sg21 type 0
  Vendor: DGC       Model: RAID 0            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:4: Attached scsi generic sg22 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:5: Attached scsi generic sg23 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:6: Attached scsi generic sg24 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:1:7: Attached scsi generic sg25 type 0
device-mapper: multipath emc: long trespass command will be send
device-mapper: multipath emc: honor reservation bit will not be set (default)
device-mapper: multipath: Failing path 8:64.
device-mapper: multipath emc: long trespass command will be send
device-mapper: multipath emc: honor reservation bit will not be set (default)
device-mapper: multipath: Failing path 8:80.
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:1: Attached scsi generic sg26 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:2: Attached scsi generic sg27 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:3: Attached scsi generic sg28 type 0
  Vendor: DGC       Model: RAID 0            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdg: 1252566144 512-byte hdwr sectors (641314 MB)
sdg: Write Protect is off
sdg: Mode Sense: 63 00 00 08
sdg: cache data unavailable
sdg: assuming drive cache: write through
SCSI device sdg: 1252566144 512-byte hdwr sectors (641314 MB)
sdg: Write Protect is off
sdg: Mode Sense: 63 00 00 08
sdg: cache data unavailable
sdg: assuming drive cache: write through
 sdg: sdg1
sd 3:0:2:4: Attached scsi disk sdg
sd 3:0:2:4: Attached scsi generic sg29 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:5: Attached scsi generic sg30 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:6: Attached scsi generic sg31 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:2:7: Attached scsi generic sg32 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdh: 546279424 512-byte hdwr sectors (279695 MB)
sdh: Write Protect is off
sdh: Mode Sense: 63 00 00 08
sdh: cache data unavailable
sdh: assuming drive cache: write through
SCSI device sdh: 546279424 512-byte hdwr sectors (279695 MB)
sdh: Write Protect is off
sdh: Mode Sense: 63 00 00 08
sdh: cache data unavailable
sdh: assuming drive cache: write through
 sdh: sdh1
sd 3:0:3:1: Attached scsi disk sdh
sd 3:0:3:1: Attached scsi generic sg33 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:2: Attached scsi generic sg34 type 0
  Vendor: DGC       Model: RAID 5            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdi: 2097152 512-byte hdwr sectors (1074 MB)
sdi: Write Protect is off
sdi: Mode Sense: 63 00 00 08
sdi: cache data unavailable
sdi: assuming drive cache: write through
SCSI device sdi: 2097152 512-byte hdwr sectors (1074 MB)
sdi: Write Protect is off
sdi: Mode Sense: 63 00 00 08
sdi: cache data unavailable
sdi: assuming drive cache: write through
 sdi:
sd 3:0:3:3: Attached scsi disk sdi
sd 3:0:3:3: Attached scsi generic sg35 type 0
  Vendor: DGC       Model: RAID 0            Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:4: Attached scsi generic sg36 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:5: Attached scsi generic sg37 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:6: Attached scsi generic sg38 type 0
  Vendor: DGC       Model:                   Rev: 0850
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi 3:0:3:7: Attached scsi generic sg39 type 0
device-mapper: multipath emc: long trespass command will be send
device-mapper: multipath emc: honor reservation bit will not be set (default)
Buffer I/O error on device dm-2, logical block 0
Buffer I/O error on device dm-2, logical block 1
Buffer I/O error on device dm-2, logical block 2
Buffer I/O error on device dm-2, logical block 3
device-mapper: multipath: Failing path 8:48.
device-mapper: multipath: Failing path 8:96.
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
 printing eip:
c03cad6f
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: iscsi_tcp libiscsi scsi_transport_iscsi via_velocity crc_ccitt b44 8139cp hwmon sg lpfc pcspkr qla4xxx scsi_transport_fc skge
CPU:    3
EIP:    0060:[<c03cad6f>]    Not tainted VLI
EFLAGS: 00010202   (2.6.18-rc6 #1) 
EIP is at process_queued_ios+0x92/0xbb
eax: c2926800   ebx: f6a32bc0   ecx: c2926318   edx: 00000010
esi: 00000000   edi: 00000246   ebp: f6a32bd0   esp: f7597f2c
ds: 007b   es: 007b   ss: 0068
Process kmpathd/3 (pid: 1061, ti=f7596000 task=c2abf030 task.ti=f7596000)
Stack: 00000010 00000001 00000001 f6a32c0c f6a32c10 c2926300 00000212 c0125b36 
       f6a32bc0 f6a32bc0 c03cacdd c2926300 f7597f8c f7597fac 00000005 c0125c79 
       c2926300 ffffffff ffffffff 00000001 00000000 c01133a1 00010000 00000000 
Call Trace:
 [<c0125b36>] run_workqueue+0x83/0xc1
 [<c03cacdd>] process_queued_ios+0x0/0xbb
 [<c0125c79>] worker_thread+0x105/0x139
 [<c01133a1>] default_wake_function+0x0/0x12
 [<c01133a1>] default_wake_function+0x0/0x12
 [<c0125b74>] worker_thread+0x0/0x139
 [<c01285b6>] kthread+0x82/0xa7
 [<c0128534>] kthread+0x0/0xa7
 [<c0100e4d>] kernel_thread_helper+0x5/0xb
Code: 00 00 00 00 c7 43 28 01 00 00 00 c7 44 24 04 01 00 00 00 8d 43 0c 89 fa e8 81 b4 06 00 83 7c 24 04 00 74 14 8d 56 10 8b 45 00 52 <8b> 56 08 ff 72 18 55 ff 50 10 83 c4 0c 83 3c 24 00 75 0f 89 5c 
EIP: [<c03cad6f>] process_queued_ios+0x92/0xbb SS:ESP 0068:f7597f2c
 <4>device-mapper: multipath emc: long trespass command will be send
device-mapper: multipath emc: honor reservation bit will not be set (default)
Buffer I/O error on device dm-3, logical block 0
Buffer I/O error on device dm-3, logical block 1
Buffer I/O error on device dm-3, logical block 2
Buffer I/O error on device dm-3, logical block 3

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lsscsi.log"

[0:0:5:0]    tape    IBM      ULT3580-TD3      57F7  /dev/st0  /dev/sg0
[0:0:5:1]    mediumx IBM      ULT3581-TA2      3.10  /dev/sch0  /dev/sg1
[1:0:0:0]    disk    IBM      SERVERAID        1.00  /dev/sda  /dev/sg2
[1:0:0:1]    disk    IBM      SERVERAID        1.00  /dev/sdc  /dev/sg11
[1:0:15:0]   process IBM      SERVERAID        1.00  -         /dev/sg3
[1:1:9:0]    process IBM      25P3471a S320  2 1     -         /dev/sg4
[1:2:8:0]    process IBM      02R0962a S320  1 1     -         /dev/sg5
[3:0:0:0]    disk    DGC                       0850  -         /dev/sg6
[3:0:0:1]    disk    DGC      RAID 5           0850  -         /dev/sg12
[3:0:0:2]    disk    DGC                       0850  -         /dev/sg13
[3:0:0:3]    disk    DGC      RAID 5           0850  -         /dev/sg14
[3:0:0:4]    disk    DGC      RAID 0           0850  /dev/sdd  /dev/sg15
[3:0:0:5]    disk    DGC                       0850  -         /dev/sg16
[3:0:0:6]    disk    DGC                       0850  -         /dev/sg17
[3:0:0:7]    disk    DGC                       0850  -         /dev/sg18
[3:0:1:0]    disk    DGC                       0850  -         /dev/sg7
[3:0:1:1]    disk    DGC      RAID 5           0850  /dev/sde  /dev/sg19
[3:0:1:2]    disk    DGC                       0850  -         /dev/sg20
[3:0:1:3]    disk    DGC      RAID 5           0850  /dev/sdf  /dev/sg21
[3:0:1:4]    disk    DGC      RAID 0           0850  -         /dev/sg22
[3:0:1:5]    disk    DGC                       0850  -         /dev/sg23
[3:0:1:6]    disk    DGC                       0850  -         /dev/sg24
[3:0:1:7]    disk    DGC                       0850  -         /dev/sg25
[3:0:2:0]    disk    DGC                       0850  -         /dev/sg8
[3:0:2:1]    disk    DGC      RAID 5           0850  -         /dev/sg26
[3:0:2:2]    disk    DGC                       0850  -         /dev/sg27
[3:0:2:3]    disk    DGC      RAID 5           0850  -         /dev/sg28
[3:0:2:4]    disk    DGC      RAID 0           0850  /dev/sdg  /dev/sg29
[3:0:2:5]    disk    DGC                       0850  -         /dev/sg30
[3:0:2:6]    disk    DGC                       0850  -         /dev/sg31
[3:0:2:7]    disk    DGC                       0850  -         /dev/sg32
[3:0:3:0]    disk    DGC                       0850  -         /dev/sg9
[3:0:3:1]    disk    DGC      RAID 5           0850  /dev/sdh  /dev/sg33
[3:0:3:2]    disk    DGC                       0850  -         /dev/sg34
[3:0:3:3]    disk    DGC      RAID 5           0850  /dev/sdi  /dev/sg35
[3:0:3:4]    disk    DGC      RAID 0           0850  -         /dev/sg36
[3:0:3:5]    disk    DGC                       0850  -         /dev/sg37
[3:0:3:6]    disk    DGC                       0850  -         /dev/sg38
[3:0:3:7]    disk    DGC                       0850  -         /dev/sg39
[4:0:0:0]    disk    IBM      DS300    S320    7.01  /dev/sdb  /dev/sg10

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ps.log"

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.1  0.0   1948   656 ?        Ss   16:42   0:04 init [2]  
root         2  0.0  0.0      0     0 ?        S    16:42   0:00 [migration/0]
root         3  0.0  0.0      0     0 ?        SN   16:42   0:00 [ksoftirqd/0]
root         4  0.0  0.0      0     0 ?        S    16:42   0:00 [migration/1]
root         5  0.0  0.0      0     0 ?        SN   16:42   0:00 [ksoftirqd/1]
root         6  0.0  0.0      0     0 ?        S    16:42   0:00 [migration/2]
root         7  0.0  0.0      0     0 ?        SN   16:42   0:00 [ksoftirqd/2]
root         8  0.0  0.0      0     0 ?        S    16:42   0:00 [migration/3]
root         9  0.0  0.0      0     0 ?        SN   16:42   0:00 [ksoftirqd/3]
root        10  0.0  0.0      0     0 ?        S<   16:42   0:00 [events/0]
root        11  0.0  0.0      0     0 ?        S<   16:42   0:00 [events/1]
root        12  0.0  0.0      0     0 ?        S<   16:42   0:00 [events/2]
root        13  0.0  0.0      0     0 ?        S<   16:42   0:00 [events/3]
root        14  0.0  0.0      0     0 ?        S<   16:42   0:00 [khelper]
root        15  0.0  0.0      0     0 ?        S<   16:42   0:00 [kthread]
root        21  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kblockd/0]
root        22  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kblockd/1]
root        23  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kblockd/2]
root        24  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kblockd/3]
root        25  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kacpid]
root       141  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [khubd]
root       143  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kseriod]
root       253  0.0  0.0      0     0 ?        S    16:42   0:00  \_ [pdflush]
root       254  0.0  0.0      0     0 ?        D    16:42   0:00  \_ [pdflush]
root       255  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [kswapd0]
root       256  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [aio/0]
root       257  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [aio/1]
root       258  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [aio/2]
root       259  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [aio/3]
root       260  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfslogd/0]
root       261  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfslogd/1]
root       262  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfslogd/2]
root       263  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfslogd/3]
root       264  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfsdatad/0]
root       265  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfsdatad/1]
root       266  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfsdatad/2]
root       267  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [xfsdatad/3]
root       957  0.0  0.0      0     0 ?        S<   16:42   0:00  \_ [scsi_eh_0]
root       994  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [scsi_eh_1]
root      1021  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [khpsbpkt]
root      1051  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kpsmoused]
root      1054  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kcryptd/0]
root      1055  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kcryptd/1]
root      1056  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kcryptd/2]
root      1057  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kcryptd/3]
root      1058  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kmpathd/0]
root      1059  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kmpathd/1]
root      1060  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kmpathd/2]
root      1064  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kmirrord]
root      1067  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kedac]
root      1073  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [kjournald]
root      2047  0.0  0.0      0     0 ?        S<   16:43   0:00  \_ [scsi_eh_2]
root      2630  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [scsi_eh_3]
root      2631  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [lpfc_worker_0]
root      2632  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [scsi_wq_3]
root      2633  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [fc_wq_3]
root      2634  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [fc_dl_3]
root      3762  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [scsi_eh_4]
root      3764  0.0  0.0      0     0 ?        S<   16:45   0:00  \_ [scsi_wq_4]
root      9848  0.0  0.0      0     0 ?        S<   17:22   0:00  \_ [xfsbufd]
root      9849  0.0  0.0      0     0 ?        S<   17:22   0:00  \_ [xfssyncd]
root       305  0.0  0.0      0     0 ?        S    16:42   0:00 [pciehpd_event]
root      1070  0.0  0.0      0     0 ?        S    16:43   0:00 [kirqd]
root      1176  0.0  0.0   2184   588 ?        S<s  16:43   0:00 udevd --daemon
root      2629  0.0  0.0      0     0 ?        S<   16:45   0:00 [qla4xxx_2_dpc]
root      3622  0.0  0.0   2560   932 ?        Ss   16:45   0:00 /sbin/syslogd
root      3628  0.0  0.0   1584   388 ?        Ss   16:45   0:00 /sbin/klogd -x
102       3668  0.0  0.0   5392   996 ?        Ss   16:45   0:00 /usr/sbin/exim4 -bd -q30m
root      3680  0.0  0.1   4332  3380 ?        SLl  16:45   0:00 /sbin/multipathd
root      3693  0.0  0.0   2684   876 ?        Ss   16:45   0:00 /usr/sbin/inetd
root      3700  0.0  0.0   4920  1056 ?        Ss   16:45   0:00 /usr/sbin/sshd
root      4092  0.0  0.0   8784  2672 ?        Ss   16:48   0:00  \_ sshd: root@pts/0 
root      4095  0.0  0.0   3152  1736 pts/0    Ss   16:48   0:00  |   \_ -bash
root      8744  0.0  0.0   2848  1348 pts/0    D+   17:15   0:00  |       \_ /bin/bash /sbin/rescan-scsi-bus.sh --version
root      9261  0.0  0.0   8628  2604 ?        Ss   17:17   0:00  \_ sshd: root@pts/1 
root      9264  0.0  0.0   3140  1712 pts/1    Ss   17:17   0:00      \_ -bash
root     10948  0.0  0.0   2540   972 pts/1    R+   17:30   0:00          \_ ps faux
www-data  3707  0.0  0.0   3244  1200 ?        Ss   16:45   0:00 thy                                                                                       
root      3754  0.0  0.0   1704   420 ?        Ss   16:45   0:00 /sbin/iscsid
root      3755  0.0  0.0   2180  2180 ?        S<Ls 16:45   0:00 /sbin/iscsid
ntp       3808  0.0  0.0   5064  1584 ?        Ss   16:45   0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -u 103:105 -g
daemon    3821  0.0  0.0   1960   600 ?        S    16:45   0:00 /usr/sbin/safte-monitor
daemon    3831  0.0  0.0   1832   412 ?        Ss   16:45   0:00 /usr/sbin/atd
root      3838  0.0  0.0   2192   876 ?        Ss   16:45   0:00 /usr/sbin/cron
root      3889  0.0  0.1   8024  5780 ?        Ss   16:45   0:00 /usr/sbin/munin-node
root      3941  0.0  0.0   1576   488 tty1     Ss+  16:45   0:00 /sbin/getty 38400 tty1
root      3942  0.0  0.0   1576   488 tty2     Ss+  16:45   0:00 /sbin/getty 38400 tty2
root      3943  0.0  0.0   1576   488 tty3     Ss+  16:45   0:00 /sbin/getty 38400 tty3
root      3944  0.0  0.0   1580   488 tty4     Ss+  16:45   0:00 /sbin/getty 38400 tty4
root      3945  0.0  0.0   1580   492 tty5     Ss+  16:45   0:00 /sbin/getty 38400 tty5
root      3946  0.0  0.0   1580   492 tty6     Ss+  16:45   0:00 /sbin/getty 38400 tty6
root      4123  0.0  0.0   4472   824 ?        Ss   16:48   0:00 ssh-agent
root      5937  0.0  0.0   2004   652 ?        D<   16:54   0:00 /sbin/kpartx -a /dev/mapper/yellow
root      6080  0.0  0.0   2004   652 ?        D<   16:54   0:00 /sbin/kpartx -a /dev/mapper/red
root      6091  0.0  0.0   2008   656 ?        D<   16:54   0:00 /sbin/kpartx -a /dev/mapper/private-1

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rescan.log"

novantatre:~# less rescan.err 
novantatre:~# rescan-scsi-bus.sh -l 2> rescan.err 
Host adapter 0 (aic79xx) found.
Host adapter 1 (ips) found.
Host adapter 2 (qla4xxx) found.
Host adapter 3 (<NULL>) found.
Host adapter 4 (iscsi_tcp) found.
Scanning hosts  0 1 2 3 4 channels 0 for 
 SCSI target IDs  0 1 2 3 4 5 6 7 , LUNs  0 1 2 3 4 5 6 7
Scanning for device 0 0 5 0 ...
OLD: Host: scsi0 Channel: 00 Id: 05 Lun: 00
      Vendor: IBM      Model: ULT3580-TD3      Rev: 57F7
      Type:   Sequential-Access                ANSI SCSI revision: 03
Scanning for device 0 0 5 1 ...
OLD: Host: scsi0 Channel: 00 Id: 05 Lun: 01
      Vendor: IBM      Model: ULT3581-TA2      Rev: 3.10
      Type:   Medium Changer                   ANSI SCSI revision: 02
Scanning for device 1 0 0 0 ...
OLD: Host: scsi1 Channel: 00 Id: 00 Lun: 00
      Vendor: IBM      Model: SERVERAID        Rev: 1.00
      Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 1 0 0 1 ...
NEW: Host: scsi1 Channel: 00 Id: 00 Lun: 01
      Vendor: IBM      Model: SERVERAID        Rev: 1.00
      Type:   Direct-Access                    ANSI SCSI revision: 02
Scanning for device 3 0 0 0 ...
OLD: Host: scsi3 Channel: 00 Id: 00 Lun: 00
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 1 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 01
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 2 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 02
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 3 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 03
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 4 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 04
      Vendor: DGC      Model: RAID 0           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 5 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 05
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 6 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 06
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 0 7 ...
NEW: Host: scsi3 Channel: 00 Id: 00 Lun: 07
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 0 ...
OLD: Host: scsi3 Channel: 00 Id: 01 Lun: 00
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 1 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 01
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 2 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 02
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 3 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 03
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 4 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 04
      Vendor: DGC      Model: RAID 0           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 5 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 05
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 6 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 06
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 1 7 ...
NEW: Host: scsi3 Channel: 00 Id: 01 Lun: 07
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 0 ...
OLD: Host: scsi3 Channel: 00 Id: 02 Lun: 00
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 1 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 01
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 2 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 02
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 3 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 03
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 4 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 04
      Vendor: DGC      Model: RAID 0           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 5 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 05
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 6 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 06
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 2 7 ...
NEW: Host: scsi3 Channel: 00 Id: 02 Lun: 07
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 0 ...
OLD: Host: scsi3 Channel: 00 Id: 03 Lun: 00
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 1 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 01
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 2 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 02
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 3 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 03
      Vendor: DGC      Model: RAID 5           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 4 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 04
      Vendor: DGC      Model: RAID 0           Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 5 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 05
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 6 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 06
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 3 0 3 7 ...
NEW: Host: scsi3 Channel: 00 Id: 03 Lun: 07
      Vendor: DGC      Model:                  Rev: 0850
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 4 0 0 0 ...
OLD: Host: scsi4 Channel: 00 Id: 00 Lun: 00
      Vendor: IBM      Model: DS300    S320    Rev: 7.01
      Type:   Direct-Access                    ANSI SCSI revision: 04
Scanning for device 4 0 4 0 ...
NEW: 
Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: Oops: 0000 [#1]

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: SMP 

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: CPU:    3

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: EIP is at process_queued_ios+0x92/0xbb

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: eax: c2926800   ebx: f6a32bc0   ecx: c2926318   edx: 00000010

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: esi: 00000000   edi: 00000246   ebp: f6a32bd0   esp: f7597f2c

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
Scanning for device 4 0 5 0 ...s: 007b   ss: 0068
OLD: 
Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: Process kmpathd/3 (pid: 1061, ti=f7596000 task=c2abf030 task.ti=f7596000)

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: Stack: 00000010 00000001 00000001 f6a32c0c f6a32c10 c2926300 00000212 c0125b36 

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel:        f6a32bc0 f6a32bc0 c03cacdd c2926300 f7597f8c f7597fac 00000005 c0125c79 

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel:        c2926300 ffffffff ffffffff 00000001 00000000 c01133a1 00010000 00000000 

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: Call Trace:

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
novantatre kernel: Code: 00 00 00 00 c7 43 28 01 00 00 00 c7 44 24 04 01 00 00 00 8d 43 0c 89 fa e8 81 b4 06 00 83 7c 24 04 00
 74 14 8d 56 10 8b 45 00 52 <8b> 56 08 ff 72 18 55 ff 50 10 83 c4 0c 83 3c 24 00 75 0f 89 5c 

Message from syslogd@novantatre at Wed Sep 13 16:54:39 2006 ...
29 new device(s) found.               rocess_queued_ios+0x92/0xbb SS:ESP 0068:f7597f2c
0 device(s) removed.                 

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rescan.err"

/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument
/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument
/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument
/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument
/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument
/sbin/rescan-scsi-bus.sh: line 183: echo: write error: Invalid argument

--jRHKVT23PllUwdXP--
