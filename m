From: Jaco van der Schyff <jvds@netgroup.co.za>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 6 Nov 2006 16:24:53 +0200
Message-ID: <20061106142453.GD9343@npjaco.netgroup.co.za>
References: <20061106090702.GA8071@npjaco.netgroup.co.za> <1162807123.3160.182.camel@laptopd505.fenrus.org> <20061106100806.GA9343@npjaco.netgroup.co.za> <1162809658.3160.205.camel@laptopd505.fenrus.org> <1162818008.4551.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netgroup.co.za ([196.25.213.80]:64466 "EHLO
	mail.netgroup.co.za") by vger.kernel.org with ESMTP
	id S1751049AbWKFOY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 09:24:59 -0500
Content-Disposition: inline
In-Reply-To: <1162818008.4551.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: arjan@infradead.org, linux-scsi@vger.kernel.org

On Mon, Nov 06, 2006 at 10:00:07PM +0900, James Bottomley wrote:
> On Mon, 2006-11-06 at 11:40 +0100, Arjan van de Ven wrote:
> > ok this is curious; the device claims to be rev 3 scsi, so the kernel
> > will have used the "REPORT_LUNS" command, which asks the device to tell
> > the kernel which LUNs it has.. it seems it just plain lies if it doesnt'
> > work for you.
> 
> I was about to remark on that too ... we need the dmesg of the boot
> sequence to tell us if there's a REPORT_LUNS problem (in which case the
> blacklist might need to be BLIST_NOREPORTLUN)

Okay, I made the changes to scsi_devinfo.c as Arjan suggested and for
some reason the patch didn't work for me (could be my superior
noobness). ps: Thanks Arjan for your help thus far!

I did make the changes manually.  But the driver still doesn't probe all
the LUNs.  One thing I did notice, is that the Model string of the
device:

Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: SA-6640S Model:                  Rev: R0.0
  Type:   Direct-Access                    ANSI SCSI revision: 03

Is not "" but 16 whitespaces ie: "                ".

I then made this change in scsi_devinfo.c:

from
{"SA-6640S", "", "R0.0", BLIST_FORCELUN}
to
{"SA-6640S", "                ", "R0.0", BLIST_FORCELUN}

This also doesn't force the LUN detection :(

So here is my dmesg if it helps *keeps thumbs crossed*

(sdb1 1:0:0:0 is the 1st LUN on the array, and sda is the boot disk on
the machine connected to a MegaRAID SCSI controller)


--------------------------------------------------------------------


 BIOS-e820: 000000007ffcfc00 - 000000007ffff000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec90000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
On node 0 totalpages: 524224
  DMA zone: 4096 pages, LIFO batch:0
  Normal zone: 225280 pages, LIFO batch:31
  HighMem zone: 294848 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 DELL                                  ) @ 0x000fd5b0
ACPI: RSDT (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd5c4
ACPI: FADT (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd620
ACPI: MADT (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd694
ACPI: SPCR (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd774
ACPI: HPET (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd7c4
ACPI: MCFG (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000a) @ 0x000fd7fc
ACPI: DSDT (v001 DELL   PE BKC   0x00000001 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x05] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[32])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 32-55
ACPI: IOAPIC (id[0x0a] address[0xfec83000] gsi_base[64])
IOAPIC[2]: apic_id 10, version 32, address 0xfec83000, GSI 64-87
ACPI: IOAPIC (id[0x0b] address[0xfec84000] gsi_base[96])
IOAPIC[3]: apic_id 11, version 32, address 0xfec84000, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 4 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ffff000:60001000)
Detected 2992.724 MHz processor.
Built 1 zonelists.  Total pages: 524224
Kernel command line: root=/dev/sda4
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec83000)
mapped IOAPIC to ffff9000 (fec84000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074400k/2096896k available (2581k kernel code, 21404k reserved, 932k data, 208k init, 1179392k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5988.34 BogoMIPS (lpj=29941737)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000180 0000641d 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 16k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Xeon(TM) CPU 3.00GHz stepping 0a
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5985.16 BogoMIPS (lpj=29925835)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000180 0000641d 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Intel(R) Xeon(TM) CPU 3.00GHz stepping 0a
Booting processor 2/6 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5985.25 BogoMIPS (lpj=29926294)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000180 0000641d 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
CPU2: Intel(R) Xeon(TM) CPU 3.00GHz stepping 0a
Booting processor 3/7 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5985.23 BogoMIPS (lpj=29926162)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
CPU: After vendor identify, caps: bfebfbff 20100000 00000000 00000000 0000641d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 20100000 00000000 00000180 0000641d 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
CPU3: Intel(R) Xeon(TM) CPU 3.00GHz stepping 0a
Total of 4 processors activated (23944.00 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
migration_cost=79,1857
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:acpi
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
Boot video device is 0000:0b:0d.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:04.0
PM: Adding info for pci:0000:00:05.0
PM: Adding info for pci:0000:00:06.0
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:01:00.2
PM: Adding info for pci:0000:02:0e.0
PM: Adding info for pci:0000:05:00.0
PM: Adding info for pci:0000:05:00.2
PM: Adding info for pci:0000:06:07.0
PM: Adding info for pci:0000:07:08.0
PM: Adding info for pci:0000:08:00.0
PM: Adding info for pci:0000:08:00.2
PM: Adding info for pci:0000:09:04.0
PM: Adding info for pci:0000:09:04.1
PM: Adding info for pci:0000:0a:02.0
PM: Adding info for pci:0000:0a:02.1
PM: Adding info for pci:0000:0b:0d.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO.DOBA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO.DOBB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBLO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI.PXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI.PXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.VPR1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.VPR1.PXC1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.VPR1.PXC2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PICH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:01:00.0
  IO window: disabled.
  MEM window: fe900000-feafffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:01:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: fe800000-feafffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: e000-efff
  MEM window: fe600000-fe7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.2
  IO window: d000-dfff
  MEM window: fe400000-fe5fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: d000-efff
  MEM window: fe300000-fe7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:08:00.0
  IO window: b000-cfff
  MEM window: fe100000-fe2fffff
  PREFETCH window: 80000000-800fffff
PCI: Bridge: 0000:08:00.2
  IO window: a000-afff
  MEM window: fdf00000-fe0fffff
  PREFETCH window: 80100000-801fffff
PCI: Bridge: 0000:00:06.0
  IO window: a000-cfff
  MEM window: fde00000-fe2fffff
  PREFETCH window: 80000000-801fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-9fff
  MEM window: fdc00000-fddfffff
  PREFETCH window: f0000000-f7ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
PCI: Setting latency timer of device 0000:05:00.2 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:08:00.0 to 64
PCI: Setting latency timer of device 0000:08:00.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
PM: Adding info for platform:pcspkr
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Initializing Cryptographic API
io scheduler noop registered
io scheduler cfq registered (default)
Intel E7520/7320/7525 detected.<6>lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.1.9-k4
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:06:07.0[A] -> GSI 64 (level, low) -> IRQ 17
e1000: 0000:06:07.0: e1000_probe: (PCI:66MHz:32-bit) 00:13:72:5d:c0:9a
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:07:08.0[A] -> GSI 65 (level, low) -> IRQ 18
e1000: 0000:07:08.0: e1000_probe: (PCI:66MHz:32-bit) 00:13:72:5d:c0:9b
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:0a:02.0[A] -> GSI 96 (level, low) -> IRQ 19
e1000: 0000:0a:02.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:9a:c8:9e
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:0a:02.1[B] -> GSI 97 (level, low) -> IRQ 20
e1000: 0000:0a:02.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:9a:c8:9f
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
megaraid: probe new device 0x1028:0x0013:0x1028:0x016d: bus 2:slot 14:func 0
ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 46 (level, low) -> IRQ 21
megaraid: fw version:[521X] bios version:[H430]
scsi0 : LSI Logic MegaRAID driver
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:target0:0:0
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
PM: Removing info for No Bus:target0:0:0
PM: Adding info for No Bus:target0:0:1
PM: Removing info for No Bus:target0:0:1
PM: Adding info for No Bus:target0:0:2
PM: Removing info for No Bus:target0:0:2
PM: Adding info for No Bus:target0:0:3
PM: Removing info for No Bus:target0:0:3
PM: Adding info for No Bus:target0:0:4
PM: Removing info for No Bus:target0:0:4
PM: Adding info for No Bus:target0:0:5
PM: Removing info for No Bus:target0:0:5
PM: Adding info for No Bus:target0:0:6
  Vendor: PE/PV     Model: 1x6 SCSI BP       Rev: 1.0 
  Type:   Processor                          ANSI SCSI revision: 02
PM: Adding info for scsi:0:0:6:0
PM: Adding info for No Bus:target0:0:8
PM: Removing info for No Bus:target0:0:8
PM: Adding info for No Bus:target0:0:9
PM: Removing info for No Bus:target0:0:9
PM: Adding info for No Bus:target0:0:10
PM: Removing info for No Bus:target0:0:10
PM: Adding info for No Bus:target0:0:11
PM: Removing info for No Bus:target0:0:11
PM: Adding info for No Bus:target0:0:12
PM: Removing info for No Bus:target0:0:12
PM: Adding info for No Bus:target0:0:13
PM: Removing info for No Bus:target0:0:13
PM: Adding info for No Bus:target0:0:14
PM: Removing info for No Bus:target0:0:14
PM: Adding info for No Bus:target0:0:15
PM: Removing info for No Bus:target0:0:15
PM: Adding info for No Bus:target0:0:16
PM: Removing info for No Bus:target0:0:16
PM: Adding info for No Bus:target0:0:17
PM: Removing info for No Bus:target0:0:17
PM: Adding info for No Bus:target0:0:18
PM: Removing info for No Bus:target0:0:18
PM: Adding info for No Bus:target0:0:19
PM: Removing info for No Bus:target0:0:19
PM: Adding info for No Bus:target0:0:20
PM: Removing info for No Bus:target0:0:20
PM: Adding info for No Bus:target0:0:21
PM: Removing info for No Bus:target0:0:21
PM: Adding info for No Bus:target0:0:22
PM: Removing info for No Bus:target0:0:22
PM: Adding info for No Bus:target0:0:23
PM: Removing info for No Bus:target0:0:23
PM: Adding info for No Bus:target0:0:24
PM: Removing info for No Bus:target0:0:24
PM: Adding info for No Bus:target0:0:25
PM: Removing info for No Bus:target0:0:25
PM: Adding info for No Bus:target0:0:26
PM: Removing info for No Bus:target0:0:26
PM: Adding info for No Bus:target0:0:27
PM: Removing info for No Bus:target0:0:27
PM: Adding info for No Bus:target0:0:28
PM: Removing info for No Bus:target0:0:28
PM: Adding info for No Bus:target0:0:29
PM: Removing info for No Bus:target0:0:29
PM: Adding info for No Bus:target0:0:30
PM: Removing info for No Bus:target0:0:30
PM: Adding info for No Bus:target0:0:31
PM: Removing info for No Bus:target0:0:31
PM: Adding info for No Bus:target0:0:32
PM: Removing info for No Bus:target0:0:32
PM: Adding info for No Bus:target0:0:33
PM: Removing info for No Bus:target0:0:33
PM: Adding info for No Bus:target0:0:34
PM: Removing info for No Bus:target0:0:34
PM: Adding info for No Bus:target0:0:35
PM: Removing info for No Bus:target0:0:35
PM: Adding info for No Bus:target0:0:36
PM: Removing info for No Bus:target0:0:36
PM: Adding info for No Bus:target0:0:37
PM: Removing info for No Bus:target0:0:37
PM: Adding info for No Bus:target0:0:38
PM: Removing info for No Bus:target0:0:38
PM: Adding info for No Bus:target0:0:39
PM: Removing info for No Bus:target0:0:39
PM: Adding info for No Bus:target0:0:40
PM: Removing info for No Bus:target0:0:40
PM: Adding info for No Bus:target0:1:0
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
PM: Removing info for No Bus:target0:1:0
PM: Adding info for No Bus:target0:1:1
PM: Removing info for No Bus:target0:1:1
PM: Adding info for No Bus:target0:1:2
PM: Removing info for No Bus:target0:1:2
PM: Adding info for No Bus:target0:1:3
PM: Removing info for No Bus:target0:1:3
PM: Adding info for No Bus:target0:1:4
PM: Removing info for No Bus:target0:1:4
PM: Adding info for No Bus:target0:1:5
PM: Removing info for No Bus:target0:1:5
PM: Adding info for No Bus:target0:1:6
PM: Removing info for No Bus:target0:1:6
PM: Adding info for No Bus:target0:1:8
PM: Removing info for No Bus:target0:1:8
PM: Adding info for No Bus:target0:1:9
PM: Removing info for No Bus:target0:1:9
PM: Adding info for No Bus:target0:1:10
PM: Removing info for No Bus:target0:1:10
PM: Adding info for No Bus:target0:1:11
PM: Removing info for No Bus:target0:1:11
PM: Adding info for No Bus:target0:1:12
PM: Removing info for No Bus:target0:1:12
PM: Adding info for No Bus:target0:1:13
PM: Removing info for No Bus:target0:1:13
PM: Adding info for No Bus:target0:1:14
PM: Removing info for No Bus:target0:1:14
PM: Adding info for No Bus:target0:1:15
PM: Removing info for No Bus:target0:1:15
PM: Adding info for No Bus:target0:1:16
PM: Removing info for No Bus:target0:1:16
PM: Adding info for No Bus:target0:1:17
PM: Removing info for No Bus:target0:1:17
PM: Adding info for No Bus:target0:1:18
PM: Removing info for No Bus:target0:1:18
PM: Adding info for No Bus:target0:1:19
PM: Removing info for No Bus:target0:1:19
PM: Adding info for No Bus:target0:1:20
PM: Removing info for No Bus:target0:1:20
PM: Adding info for No Bus:target0:1:21
PM: Removing info for No Bus:target0:1:21
PM: Adding info for No Bus:target0:1:22
PM: Removing info for No Bus:target0:1:22
PM: Adding info for No Bus:target0:1:23
PM: Removing info for No Bus:target0:1:23
PM: Adding info for No Bus:target0:1:24
PM: Removing info for No Bus:target0:1:24
PM: Adding info for No Bus:target0:1:25
PM: Removing info for No Bus:target0:1:25
PM: Adding info for No Bus:target0:1:26
PM: Removing info for No Bus:target0:1:26
PM: Adding info for No Bus:target0:1:27
PM: Removing info for No Bus:target0:1:27
PM: Adding info for No Bus:target0:1:28
PM: Removing info for No Bus:target0:1:28
PM: Adding info for No Bus:target0:1:29
PM: Removing info for No Bus:target0:1:29
PM: Adding info for No Bus:target0:1:30
PM: Removing info for No Bus:target0:1:30
PM: Adding info for No Bus:target0:1:31
PM: Removing info for No Bus:target0:1:31
PM: Adding info for No Bus:target0:1:32
PM: Removing info for No Bus:target0:1:32
PM: Adding info for No Bus:target0:1:33
PM: Removing info for No Bus:target0:1:33
PM: Adding info for No Bus:target0:1:34
PM: Removing info for No Bus:target0:1:34
PM: Adding info for No Bus:target0:1:35
PM: Removing info for No Bus:target0:1:35
PM: Adding info for No Bus:target0:1:36
PM: Removing info for No Bus:target0:1:36
PM: Adding info for No Bus:target0:1:37
PM: Removing info for No Bus:target0:1:37
PM: Adding info for No Bus:target0:1:38
PM: Removing info for No Bus:target0:1:38
PM: Adding info for No Bus:target0:1:39
PM: Removing info for No Bus:target0:1:39
PM: Adding info for No Bus:target0:1:40
PM: Removing info for No Bus:target0:1:40
PM: Adding info for No Bus:target0:2:0
scsi[0]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID1  139G  Rev: 521X
  Type:   Direct-Access                      ANSI SCSI revision: 02
PM: Adding info for scsi:0:2:0:0
PM: Adding info for No Bus:target0:2:1
PM: Removing info for No Bus:target0:2:1
PM: Adding info for No Bus:target0:2:2
PM: Removing info for No Bus:target0:2:2
PM: Adding info for No Bus:target0:2:3
PM: Removing info for No Bus:target0:2:3
PM: Adding info for No Bus:target0:2:4
PM: Removing info for No Bus:target0:2:4
PM: Adding info for No Bus:target0:2:5
PM: Removing info for No Bus:target0:2:5
PM: Adding info for No Bus:target0:2:6
PM: Removing info for No Bus:target0:2:6
PM: Adding info for No Bus:target0:2:8
PM: Removing info for No Bus:target0:2:8
PM: Adding info for No Bus:target0:2:9
PM: Removing info for No Bus:target0:2:9
PM: Adding info for No Bus:target0:2:10
PM: Removing info for No Bus:target0:2:10
PM: Adding info for No Bus:target0:2:11
PM: Removing info for No Bus:target0:2:11
PM: Adding info for No Bus:target0:2:12
PM: Removing info for No Bus:target0:2:12
PM: Adding info for No Bus:target0:2:13
PM: Removing info for No Bus:target0:2:13
PM: Adding info for No Bus:target0:2:14
PM: Removing info for No Bus:target0:2:14
PM: Adding info for No Bus:target0:2:15
PM: Removing info for No Bus:target0:2:15
PM: Adding info for No Bus:target0:2:16
PM: Removing info for No Bus:target0:2:16
PM: Adding info for No Bus:target0:2:17
PM: Removing info for No Bus:target0:2:17
PM: Adding info for No Bus:target0:2:18
PM: Removing info for No Bus:target0:2:18
PM: Adding info for No Bus:target0:2:19
PM: Removing info for No Bus:target0:2:19
PM: Adding info for No Bus:target0:2:20
PM: Removing info for No Bus:target0:2:20
PM: Adding info for No Bus:target0:2:21
PM: Removing info for No Bus:target0:2:21
PM: Adding info for No Bus:target0:2:22
PM: Removing info for No Bus:target0:2:22
PM: Adding info for No Bus:target0:2:23
PM: Removing info for No Bus:target0:2:23
PM: Adding info for No Bus:target0:2:24
PM: Removing info for No Bus:target0:2:24
PM: Adding info for No Bus:target0:2:25
PM: Removing info for No Bus:target0:2:25
PM: Adding info for No Bus:target0:2:26
PM: Removing info for No Bus:target0:2:26
PM: Adding info for No Bus:target0:2:27
PM: Removing info for No Bus:target0:2:27
PM: Adding info for No Bus:target0:2:28
PM: Removing info for No Bus:target0:2:28
PM: Adding info for No Bus:target0:2:29
PM: Removing info for No Bus:target0:2:29
PM: Adding info for No Bus:target0:2:30
PM: Removing info for No Bus:target0:2:30
PM: Adding info for No Bus:target0:2:31
PM: Removing info for No Bus:target0:2:31
PM: Adding info for No Bus:target0:2:32
PM: Removing info for No Bus:target0:2:32
PM: Adding info for No Bus:target0:2:33
PM: Removing info for No Bus:target0:2:33
PM: Adding info for No Bus:target0:2:34
PM: Removing info for No Bus:target0:2:34
PM: Adding info for No Bus:target0:2:35
PM: Removing info for No Bus:target0:2:35
PM: Adding info for No Bus:target0:2:36
PM: Removing info for No Bus:target0:2:36
PM: Adding info for No Bus:target0:2:37
PM: Removing info for No Bus:target0:2:37
PM: Adding info for No Bus:target0:2:38
PM: Removing info for No Bus:target0:2:38
PM: Adding info for No Bus:target0:2:39
PM: Removing info for No Bus:target0:2:39
PM: Adding info for No Bus:target0:2:40
PM: Removing info for No Bus:target0:2:40
SCSI device sda: 286515200 512-byte hdwr sectors (146696 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 286515200 512-byte hdwr sectors (146696 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4
sd 0:2:0:0: Attached scsi disk sda
scsi 0:0:6:0: Attached scsi generic sg0 type 3
sd 0:2:0:0: Attached scsi generic sg1 type 0
SCSI Media Changer driver v0.25 
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 22, io mem 0xfeb00000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00008ce0
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 23, io base 0x00008cc0
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 24
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 24, io base 0x00008ca0
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 2
PM: Adding info for No Bus:usbdev4.1_ep81
Initializing USB Mass Storage driver...
PM: Adding info for usb:1-3
PM: Adding info for No Bus:usbdev1.2_ep00
usb 1-3: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-3:1.0
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.2_ep81
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
PM: Adding info for platform:i8042
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
PM: Adding info for serio:serio1
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
PM: Adding info for No Bus:i2c-9191
ip_conntrack version 2.4 (8192 buckets, 65536 max) - 224 bytes per conntrack
input: AT Translated Set 2 keyboard as /class/input/input0
ip_conntrack_pptp version 3.1 loaded
ip_nat_pptp version 3.0 loaded
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP bic registered
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
Time: tsc clocksource has been installed.
ReiserFS: sda4: found reiserfs format "3.6" with standard journal
ReiserFS: sda4: using ordered data mode
ReiserFS: sda4: journal params: device sda4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda4: checking transaction log (sda4)
ReiserFS: sda4: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 208k freed
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
ACPI: PCI Interrupt 0000:09:04.0[A] -> GSI 106 (level, low) -> IRQ 25
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs

PM: Adding info for No Bus:host1
PM: Adding info for No Bus:target1:0:0
  Vendor: SA-6640S  Model:                   Rev: R0.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target1:0:0: asynchronous
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:0: Ending Domain Validation
PM: Adding info for scsi:1:0:0:0
SCSI device sdb: 2186985472 512-byte hdwr sectors (1119737 MB)
sdb: Write Protect is off
sdb: Mode Sense: bf 00 00 08
SCSI device sdb: drive cache: write back
SCSI device sdb: 2186985472 512-byte hdwr sectors (1119737 MB)
sdb: Write Protect is off
sdb: Mode Sense: bf 00 00 08
SCSI device sdb: drive cache: write back
 sdb: sdb1
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg2 type 0
PM: Adding info for No Bus:target1:0:1
PM: Removing info for No Bus:target1:0:1
PM: Adding info for No Bus:target1:0:2
PM: Removing info for No Bus:target1:0:2
PM: Adding info for No Bus:target1:0:3
PM: Removing info for No Bus:target1:0:3
PM: Adding info for No Bus:target1:0:4
PM: Removing info for No Bus:target1:0:4
PM: Adding info for No Bus:target1:0:5
PM: Removing info for No Bus:target1:0:5
PM: Adding info for No Bus:target1:0:6
PM: Removing info for No Bus:target1:0:6
PM: Adding info for No Bus:target1:0:8
PM: Removing info for No Bus:target1:0:8
PM: Adding info for No Bus:target1:0:9
PM: Removing info for No Bus:target1:0:9
PM: Adding info for No Bus:target1:0:10
PM: Removing info for No Bus:target1:0:10
PM: Adding info for No Bus:target1:0:11
PM: Removing info for No Bus:target1:0:11
PM: Adding info for No Bus:target1:0:12
PM: Removing info for No Bus:target1:0:12
PM: Adding info for No Bus:target1:0:13
PM: Removing info for No Bus:target1:0:13
PM: Adding info for No Bus:target1:0:14
PM: Removing info for No Bus:target1:0:14
PM: Adding info for No Bus:target1:0:15
PM: Removing info for No Bus:target1:0:15
ACPI: PCI Interrupt 0000:09:04.1[B] -> GSI 107 (level, low) -> IRQ 26
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs

PM: Adding info for No Bus:host2
PM: Adding info for No Bus:target2:0:0
PM: Removing info for No Bus:target2:0:0
PM: Adding info for No Bus:target2:0:1
PM: Removing info for No Bus:target2:0:1
PM: Adding info for No Bus:target2:0:2
PM: Removing info for No Bus:target2:0:2
PM: Adding info for No Bus:target2:0:3
PM: Removing info for No Bus:target2:0:3
PM: Adding info for No Bus:target2:0:4
PM: Removing info for No Bus:target2:0:4
PM: Adding info for No Bus:target2:0:5
PM: Removing info for No Bus:target2:0:5
PM: Adding info for No Bus:target2:0:6
PM: Removing info for No Bus:target2:0:6
PM: Adding info for No Bus:target2:0:8
PM: Removing info for No Bus:target2:0:8
PM: Adding info for No Bus:target2:0:9
PM: Removing info for No Bus:target2:0:9
PM: Adding info for No Bus:target2:0:10
PM: Removing info for No Bus:target2:0:10
PM: Adding info for No Bus:target2:0:11
PM: Removing info for No Bus:target2:0:11
PM: Adding info for No Bus:target2:0:12
PM: Removing info for No Bus:target2:0:12
PM: Adding info for No Bus:target2:0:13
PM: Removing info for No Bus:target2:0:13
PM: Adding info for No Bus:target2:0:14
PM: Removing info for No Bus:target2:0:14
PM: Adding info for No Bus:target2:0:15
PM: Removing info for No Bus:target2:0:15

-----------------------------------------------------------------


