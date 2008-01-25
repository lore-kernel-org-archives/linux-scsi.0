From: Halim Issa <yallaone@gmail.com>
Subject: sd incorrectly reports write cache disabled on cache-capable drives/controllers
Date: Fri, 25 Jan 2008 21:59:20 +0100
Message-ID: <200801252159.20858.yallaone@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:64372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbYAYU72 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 15:59:28 -0500
Received: by fg-out-1718.google.com with SMTP id e21so772908fga.17
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2008 12:59:26 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is my first post to any of the vger lists. I have tried to comply with 
the list recommendations and be specific while to the point. If anything is 
missing, kindly let me know.

I am having trouble getting the scsi-subsystem on an IBM x336 eServer with LSI 
Logic53c1030 SCSI RAID controller to recognize the write cache on my 
harddrives/controller. It reports:

sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA.

Both the drives and controller do indeed support caching and Disable Page Out 
+ Force Unit Access. The system works well with caching on "other" operating 
systems as well as with linux kernel version 2.6.16 (to which I do not have 
access to the .config unfortunately). What I have noticed is that with the 
other OS/older kernel, the scsi controller appears to be moved from GSI 28 to 
IRQ193, while in 2.6.22 and later (currently 2.6.24) it remains on IRQ 28...

I also appear to be able to turn this on manually by typing: sdparm -s 
WCE=1 /dev/sg2  (and same with sg3, the other disk in the RAID), so it 
doesn't make sense to me that I can turn it on manually, but the 
driver/modules doesn't do it themselves on system boot/driver load.

If anyone could kindly point me in the right direction on how to get this 
working I would greatly appreciate it, as several months of googling + trying 
to understand how sd.c gets the WCE parameter has left me blank.
What exactly controls how the sd.c driver reads the write and read cache 
capability of the LSI Logic controller/IBM harddrives, and what could be 
missing causing the sd.c driver to incorrectly believe that it's not capable?

The full kernel configuration, dmesg output, lspci -vv and lsscsi -vv, 
interrupts, lsdev and lsmod and much more system information is available at 
www.hiawata.com/linux.

The system is not (yet) in production, and can as such be experimented with.

Thank you in advance for any insight!

Hardware spec:

====> SCSI Controller (lspci -vv):

04:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X 
Fusion-
MPT Dual Ultra320 SCSI (rev 08)
        Subsystem: IBM Unknown device 026d
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ 
Step
ping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort
- <MAbort- >SERR- <PERR-
        Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 28
        Region 0: I/O ports at 4000 [size=256]
        Region 1: Memory at deff0000 (64-bit, non-prefetchable) [size=64K]
        Region 3: Memory at defe0000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at f9100000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=16
                Status: Dev=04:01.0 64bit+ 133MHz+ SCD- USC- DC=simple 
DMMRBC=20
48 DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-

===> SCSI drives (lsscsi -vv):
 sysfsroot: /sys
[0:0:0:0]    disk    LSILOGIC 1030 IM          1000  /dev/sda
  dir: /sys/bus/scsi/devices/0:0:0:0  
[/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0/0000:04:01.0/host0/target0:0:0/0:0:0:0]
[0:0:8:0]    process IBM      25P3495a S320  1 1     -
  dir: /sys/bus/scsi/devices/0:0:8:0  
[/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0/0000:04:01.0/host0/target0:0:8/0:0:8:0]
[0:1:0:0]    disk    IBM-ESXS ST373453LC    FN B85D  -
  dir: /sys/bus/scsi/devices/0:1:0:0  
[/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0/0000:04:01.0/host0/target0:1:0/0:1:0:0]
[0:1:1:0]    disk    IBM-ESXS ST373453LC    FN B85D  -
  dir: /sys/bus/scsi/devices/0:1:1:0  
[/sys/devices/pci0000:00/0000:00:04.0/0000:03:00.0/0000:04:01.0/host0/target0:1:1/0:1:1:0]



===> Modules loaded (lsmod) :
Module                  Size  Used by
ipt_ULOG                9992  2
ipt_REJECT              5120  2
ipt_recent              9760  5
xt_limit                3968  2
xt_tcpudp               4608  20
nf_conntrack_ipv4      16144  17
xt_state                3456  17
nf_conntrack           58352  2 nf_conntrack_ipv4,xt_state
xt_pkttype              3072  1
iptable_filter          3840  1
ip_tables              19240  1 iptable_filter
x_tables               16520  8 
ipt_ULOG,ipt_REJECT,ipt_recent,xt_limit,xt_tcpudp,xt_state,xt_pkttype,ip_tables
nfs                   130488  1
lockd                  65968  2 nfs
sunrpc                176648  8 nfs,lockd
ide_scsi               15112  0
ide_cd                 39072  0
tg3                   114180  0
rtc_cmos                8888  0
cdrom                  36904  1 ide_cd
i2c_i801               10012  0
evdev                  11392  2
rtc_core               17804  1 rtc_cmos
serio_raw               7172  0
button                  8608  0
pcspkr                  3968  0
rtc_lib                 4224  1 rtc_core
i2c_core               21632  1 i2c_i801
iTCO_wdt               13264  0
sg                     31384  0
iTCO_vendor_support     4740  1 iTCO_wdt
dm_mod                 53360  0
mptspi                 19088  5
mptscsih               35968  1 mptspi
mptbase                76260  2 mptspi,mptscsih
scsi_transport_spi     26624  1 mptspi
sd_mod                 24576  6
scsi_mod              139568  6 
ide_scsi,sg,mptspi,mptscsih,scsi_transport_spi,sd_mod

===> dmesg output (edited for space, made effort to keep relevant parts):

Linux version 2.6.24 (root@spirou) (gcc version 4.1.2) #1 SMP Fri Jan 25 
19:51:00 CET 2008
Command line: BOOT_IMAGE=Linux.test ro root=801
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7fccf00 (usable)
 BIOS-e820: 00000000d7fccf00 - 00000000d7fd0000 (ACPI data)
 BIOS-e820: 00000000d7fd0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001a8000000 (usable)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 884684) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1736704) 2 entries of 256 used
end_pfn_map = 1736704
DMI 2.3 present.
ACPI: RSDP 000FDFB0, 0024 (r2 IBM   )
ACPI: XSDT D7FCFF00, 003C (r1 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: FACP D7FCFE40, 0084 (r2 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: DSDT D7FCCF00, 2346 (r2 IBM    SERTURQU     1000 INTL 20041203)
ACPI: FACS D7FCFD00, 0040
ACPI: APIC D7FCFD80, 009C (r1 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: MCFG D7FCFD40, 003C (r1 IBM    SERONYXP     1001 IBM  45444F43)
Entering add_active_range(0, 0, 157) 0 entries of 256 used
Entering add_active_range(0, 256, 884684) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1736704) 2 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1736704
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      157
    0:      256 ->   884684
    0:  1048576 ->  1736704
On node 0 totalpages: 1572713
  DMA zone: 56 pages used for memmap
  DMA zone: 1129 pages reserved
  DMA zone: 2812 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 866308 pages, LIFO batch:31
  Normal zone: 9408 pages used for memmap
  Normal zone: 678720 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x588
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec82000] gsi_base[24])
IOAPIC[1]: apic_id 13, address 0xfec82000, GSI 24-47
ACPI: IOAPIC (id[0x0c] address[0xfec82400] gsi_base[48])
IOAPIC[2]: apic_id 12, address 0xfec82400, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
PERCPU: Allocating 33248 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1547840
Kernel command line: BOOT_IMAGE=Linux.test ro root=801
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 3200.107 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x792f000 - 0xb92f000
Memory: 6112440k/6946816k available (2218k kernel code, 178168k reserved, 
1018k data, 256k init)
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 6404.96 BogoMIPS 
(lpj=32024848)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
Freeing SMP alternatives: 24k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12500369
Detected 12.500 MHz APIC timer.
Booting processor 1/4 APIC 0x6
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.29 BogoMIPS 
(lpj=32001481)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 6400.25 BogoMIPS 
(lpj=32001299)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/4 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 6400.30 BogoMIPS 
(lpj=32001544)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG 
support.
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
Force enabled HPET at base address 0xfed00000
PCI quirk: region 0580-05ff claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0400-043f claimed by ICH4 GPIO
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *11)
ACPI: PCI Interrupt Link [LP01] (IRQs *3)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP02] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP03] (IRQs *3)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP04] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP06] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x540-0x547 has been reserved
system 00:0c: ioport range 0x400-0x43f has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x540-0x55f could not be reserved
system 00:0c: ioport range 0x580-0x5ff has been reserved
system 00:0c: ioport range 0x800-0x80f has been reserved
system 00:0c: ioport range 0xca8-0xcaf has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0c: iomem range 0xfed20800-0xfed208ff has been reserved
system 00:0c: iomem range 0xfed30800-0xfed308ff has been reserved
system 00:0c: iomem range 0xff000000-0xff000fff has been reserved
system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.0
  IO window: 4000-4fff
  MEM window: dd000000-deffffff
  PREFETCH window: f9100000-f91fffff
PCI: Bridge: 0000:03:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: 4000-4fff
  MEM window: dd000000-deffffff
  PREFETCH window: f9100000-f91fffff
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: db000000-dcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: 5000-ffff
  MEM window: d9000000-daffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: f8000000-f8ffffff
  PREFETCH window: f0000000-f7ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:03:00.0 to 64
PCI: Setting latency timer of device 0000:03:00.2 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 555k freed
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:01.0
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
PCI: Setting latency timer of device 0000:00:07.0 to 64
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie01]
AER service couldn't init device 0000:00:02.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:07.0:pcie01 - no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
loop: module loaded
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: HL-DT-STDVD-ROM GDR8083N, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x64,0x60 irq 1,12
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 256k freed
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 28 (level, low) -> IRQ 28
mptbase: ioc0: Initiating bringup
input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input0
ioc0: LSI53C1030 C0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=222, IRQ=28
scsi 0:0:0:0: Direct-Access     LSILOGIC 1030 IM          1000 PQ: 0 ANSI: 2
sd 0:0:0:0: [sda] 143372288 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
sd 0:0:0:0: [sda] 143372288 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 03 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:8:0: Processor         IBM      25P3495a S320  1 1    PQ: 0 ANSI: 2
 target0:0:8: Beginning Domain Validation
 target0:0:8: Ending Domain Validation
 target0:0:8: asynchronous
scsi 0:1:0:0: Direct-Access     IBM-ESXS ST373453LC    FN B85D PQ: 0 ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
 target0:1:0: Beginning Domain Validation
 target0:1:0: Domain Validation skipping write tests
 target0:1:0: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online
 target0:1:0: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 63)
scsi 0:1:1:0: Direct-Access     IBM-ESXS ST373453LC    FN B85D PQ: 0 ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online, quiesced
 target0:1:1: Beginning Domain Validation
 target0:1:1: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0 id=0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1 id=0
mptbase: ioc0:   PhysDisk is now online
 target0:1:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, 
offset 63)
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: 
dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
iTCO_vendor_support: vendor-support=0
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:8:0: Attached scsi generic sg1 type 3
scsi 0:1:0:0: Attached scsi generic sg2 type 0
scsi 0:1:1:0: Attached scsi generic sg3 type 0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH5 or ICH5R TCO device (Version=1, TCOBASE=0x05e0)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
intel_rng: FWH not detected
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
rtc_cmos: probe of 00:09 failed with error -16
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:06:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 
10/100/1000Base-T Ethernet 00:11:25:41:1d:34
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:07:00.0 to 64
Adding 6000268k swap on /dev/sda2.  Priority:-1 extents:1 across:6000268k
