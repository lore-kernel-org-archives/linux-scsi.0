From: Andrew Morton <akpm@osdl.org>
Subject: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 01:21:51 -0700
Message-ID: <20050428012151.2e207f47.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:42701 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261772AbVD1IWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 04:22:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>


With James's tree as-of today, on an ia64 tiger box, defconfig.

Unfortunately both add2line and gdb insist that 0xa0000001005419f1 points
at the start of mpt_interrupt, which is clearly wrong, so I have no simple
way of working out which source line is getting the null deref.

I tried with and without CONFIG_FUSION_FC.  The driver is statically linked.

I guess I'll test this on x86 next.  Is a bit of a bummer.



Linux version 2.6.12-rc3 (akpm@linux-tiger) (gcc version 3.3.2) #51 SMP Thu Apr 28 15:55:21 PDT 2005
EFI v1.10 by INTEL: SALsystab=0x3fe4c8c0 ACPI=0x3ff84000 ACPI 2.0=0x3ff83000 MPS=0x3ff82000 SMBIOS=0xf0000
efi.trim_top: ignoring 4KB of memory at 0x0 due to granule hole at 0x0
efi.trim_top: ignoring 24KB of memory at 0x1000 due to granule hole at 0x0
efi.trim_top: ignoring 8KB of memory at 0x7000 due to granule hole at 0x0
efi.trim_top: ignoring 484KB of memory at 0x9000 due to granule hole at 0x0
efi.trim_top: ignoring 4KB of memory at 0x84000 due to granule hole at 0x0
efi.trim_top: ignoring 108KB of memory at 0x85000 due to granule hole at 0x0
efi.trim_bottom: ignoring 15360KB of memory at 0x100000 due to granule hole at 0x0
SAL 3.1: Intel Corp                       SR870BN4                         version 3.0
SAL Platform features: BusLock IRQ_Redirection
SAL: AP wakeup using external interrupt vector 0xf0
No logical to physical processor mapping available
iosapic_system_init: Disabling PC-AT compatible 8259 interrupts
ACPI: Local APIC address c0000000fee00000
PLATFORM int CPEI (0x3): GSI 22 (level, low) -> CPU 0 (0xc618) vector 30
register_intr: changing vector 39 from IO-SAPIC-edge to IO-SAPIC-level
4 CPUs available, 4 CPUs total
MCA related initialization done
Built 1 zonelists
Kernel command line: BOOT_IMAGE=scsi0:\EFI\redhat\vmlinuz-2.6.12-rc3 root=/dev/sda3 initcall_debug console=ttyS1 console=tty0 ro
PID hash table entries: 4096 (order: 12, 131072 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 6, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 5, 524288 bytes)
Placing software IO TLB between 0x15bc000 - 0x1dbc000
Memory: 1000448k/1025920k available (6698k code, 25088k reserved, 3010k data, 192k init)
McKinley Errata 9 workaround not needed; disabling it
Mount-cache hash table entries: 1024
Boot processor id 0x0/0xc618
CPU 1: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 508 cycles)
CPU 2: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 508 cycles)
CPU 3: synchronized ITC with CPU 0 (last diff 0 cycles, maxerr 508 cycles)
Brought up 4 CPUs
Total of 4 processors activated (8359.04 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
ACPI: Subsystem revision 20050408
ACPI: Interpreter enabled
ACPI: Using IOSAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Ignoring range [0-5fff] (100)
ACPI: PCI Root Bridge [PCI1] (0000:02)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Root Bridge [PCI3] (0000:09)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Root Bridge [PCI4] (0000:0f)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: Device [CSFF] status [00000008]: functional but not present; setting present
ACPI: PCI Root Bridge [CSFF] (0000:ff)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Total HugeTLB memory allocated, 0
SGI XFS with large block/inode numbers, no debug enabled
Initializing Cryptographic API
EFI Time Services Driver v0.4
serio: i8042 AUX port at 0x60,0x64 irq 36
serio: i8042 KBD port at 0x60,0x64 irq 32
Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing enabled
acpi_serial_port: zero-length IO port range?
ttyS0 at I/O 0x3f8 (irq = 44) is a 16550A
acpi_serial_port: zero-length IO port range?
ttyS1 at I/O 0x2f8 (irq = 45) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Intel(R) PRO/1000 Network Driver - version 5.7.6-k2
Copyright (c) 1999-2004 Intel Corporation.
GSI 18 (level, low) -> CPU 0 (0xc618) vector 48
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 18 (level, low) -> IRQ 48
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Device 0000:00:1f.1 not available because of resource collisions
ACPI: PCI Interrupt 0000:00:1f.1[A]: no GSI - using IRQ 0
ICH4: BIOS configuration fixed.
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:pio, hdd:pio
hda: MATSHITADVD-ROM SR-8177, ATAPI CD/DVD-ROM drive
hdb: LS-120/240 00 UHD Floppy, ATAPI FLOPPY drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 34
hda: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
hdb: No disk in drive
hdb: 234752kB, 262/32/56 CHS, 2995 kBps, 512 sector size, 1500 rpm
Fusion MPT SPI Host driver 3.03.00
GSI 28 (level, low) -> CPU 1 (0xc018) vector 49
ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 28 (level, low) -> IRQ 49
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
Unable to handle kernel NULL pointer dereference (address 0000000000000000)
swapper[0]: Oops 11012296146944 [1]
Modules linked in:

Pid: 0, CPU 1, comm:              swapper
psr : 0000121008026018 ifs : 8000000000000d9e ip  : [<a0000001005419f1>]    Not tainted
ip is at mpt_interrupt+0x231/0x480
unat: 0000000000000000 pfs : 000000000000040b rsc : 0000000000000003
rnat: d664cd6dffbf8fe3 bsps: cf3651d39483314e pr  : 0000000001156527
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000dc630 b6  : a000000100003320 b7  : a0000001005417c0
f6  : 1003e0000000000000000 f7  : 0ffe7aa4e400000000000
f8  : 1003e0000000000000000 f9  : 1003e0000000000000060
f10 : 10009d74cccccc88ad800 f11 : 1003e0000000000000000
r1  : a000000100b65aa0 r2  : c0000000f8fd0044 r3  : c0000000f8fd0000
r8  : a000000100aa24c8 r9  : 00000000000000ff r10 : 0000000000000000
r11 : 0000000000000000 r12 : e00000003c8afbc0 r13 : e00000003c8a8000
r14 : 0000000000000004 r15 : 0000000000000000 r16 : e00000003da00008
r17 : e00000003da0000e r18 : 0000000000000060 r19 : 00000000000000ff
r20 : 0000000000000000 r21 : e00000003da0000a r22 : 0000000000000000
r23 : e00000003da00000 r24 : 0000000100000000 r25 : 000000003da00000
r26 : 0000000000000000 r27 : 0000000000000000 r28 : 000000000000001d
r29 : 0000000000800000 r30 : 0000000000000000 r31 : a0000001007f2728

Call Trace:
 [<a000000100010ec0>] show_stack+0x80/0xa0
                                sp=e00000003c8af780 bsp=e00000003c8a91b0
 [<a000000100011720>] show_regs+0x7e0/0x800
                                sp=e00000003c8af950 bsp=e00000003c8a9150
 [<a000000100035750>] die+0x150/0x1c0
                                sp=e00000003c8af960 bsp=e00000003c8a9110
 [<a000000100058130>] ia64_do_page_fault+0x370/0x9c0
                                sp=e00000003c8af960 bsp=e00000003c8a90a8
 [<a00000010000ba40>] ia64_leave_kernel+0x0/0x280
                                sp=e00000003c8af9f0 bsp=e00000003c8a90a8
 [<a0000001005419f0>] mpt_interrupt+0x230/0x480
                                sp=e00000003c8afbc0 bsp=e00000003c8a8fb0
 [<a0000001000dc630>] handle_IRQ_event+0x90/0x140
                                sp=e00000003c8afbc0 bsp=e00000003c8a8f70
 [<a0000001000dc980>] __do_IRQ+0x2a0/0x380
                                sp=e00000003c8afbc0 bsp=e00000003c8a8f18
 [<a00000010000fd20>] ia64_handle_irq+0xa0/0x140
                                sp=e00000003c8afbc0 bsp=e00000003c8a8ee0
 [<a00000010000ba40>] ia64_leave_kernel+0x0/0x280
                                sp=e00000003c8afbc0 bsp=e00000003c8a8ee0
 [<a000000100010260>] ia64_pal_call_static+0xa0/0xc0
                                sp=e00000003c8afd90 bsp=e00000003c8a8e90
 [<a000000100011960>] default_idle+0x120/0x1c0
                                sp=e00000003c8afd90 bsp=e00000003c8a8e40
 [<a000000100011db0>] cpu_idle+0x230/0x460
                                sp=e00000003c8afe30 bsp=e00000003c8a8d98
 [<a0000001000513c0>] start_secondary+0x80/0xa0
                                sp=e00000003c8afe30 bsp=e00000003c8a8d80
 [<a0000001000089c0>] _start+0x6a0/0x6d0
                                sp=e00000003c8afe30 bsp=e00000003c8a8d80
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
 
