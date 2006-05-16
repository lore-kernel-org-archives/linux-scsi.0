From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: Poor NFS performance with Adaptec 2820SA
Date: Mon, 15 May 2006 22:24:24 -0700
Message-ID: <40b437200605152224n2e49027emcf59e28078c6b9eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:8155 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751305AbWEPFYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2006 01:24:25 -0400
Received: by py-out-1112.google.com with SMTP id x31so1563050pye
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2006 22:24:24 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a Supermicro system with an Adaptec 2820SA SATA-II RAID
controller. 4 x 400GB SATA disks in a RAID-5/one hotspare config
(approx 740GB).

I am running a RedHat system with RedHat kernel 2.6.9-34.ELsmp and
seeing very slow performance over NFS.

"top" shows almost no cpu activity, while "uptime" shows load figures
approaching 2.  The problem seems to be related to creating files --
for example, it took about 5 minutes to un-tar a 15MB file (running
tar on another machine with the files mounted via NFS on the
Supermicro server). With a single file, it was able to copy a 3GB file
in 5 minutes over NFS (not fast, but acceptable).

Running un-tar locally took approx 2 seconds.

I am going to try the latest vanilla kernel (2.6.16.16), but in the
meanwhile has anyone seen anything like this? Any pointers to solve
this?

I should also mention that the system was very slow to build the
filesystem: it spent over an hour writing inodes (a little over 1
inode per second) for the ext3 filesystem.

My first install, I used LVM. With this performance (even locally) was
terrible.

lspci:
]# lspci
00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 11)
00:01.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 11)
00:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge (rev 11)
00:02.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 11)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:04.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
02:01.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
02:03.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
Gigabit Ethernet (rev 10)
02:03.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704
Gigabit Ethernet (rev 10)
03:03.0 RAID bus controller: Marvell Technology Group Ltd. MV88SX6041
4-port SATA II PCI-X Controller (rev 03)

/proc/cpuinfo:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 270
stepping        : 2
cpu MHz         : 2005.107
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht sysc
all nx mmxext lm 3dnowext 3dnow pni
bogomips        : 4014.79

processor       : 1
vendor_id       : AuthenticAMD
.....

dmesg
Linux version 2.6.9-34.ELsmp (bhcompile@hs20-bc1-7.build.redhat.com)
(gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)) #1 SMP Fri Feb 24
16:54:53 EST 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
 BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
NX (Execute Disable) protection: active
On node 0 totalpages: 524272
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 294896 pages, LIFO batch:16
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP (v000 ACPIAM                                ) @ 0x000f97a0
ACPI: RSDT (v001 A M I  OEMRSDT  0x04000610 MSFT 0x00000097) @ 0x7fff0000
ACPI: FADT (v002 A M I  OEMFACP  0x04000610 MSFT 0x00000097) @ 0x7fff0200
ACPI: MADT (v001 A M I  OEMAPIC  0x04000610 MSFT 0x00000097) @ 0x7fff0380
ACPI: OEMB (v001 A M I  OEMBIOS  0x04000610 MSFT 0x00000097) @ 0x7ffff040
ACPI: DSDT (v001  H8DAR H8DAR010 0x00000000 INTL 0x02002026) @ 0x00000000
ACPI: PM-Timer IO Port: 0x5008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Enabling APIC mode:  Flat.  Using 0 I/O APICs
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x07] address[0xfebfe000] gsi_base[40])
IOAPIC[1]: apic_id 7, version 17, address 0xfebfe000, GSI 40-46
ACPI: IOAPIC (id[0x08] address[0xfebff000] gsi_base[47])
IOAPIC[2]: apic_id 8, version 17, address 0xfebff000, GSI 47-53
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
Built 1 zonelists
Kernel command line: ro root=LABEL=/ rhgb quiet
Initializing CPU#0
CPU 0 irqstacks, hard=c03ea000 soft=c03ca000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 2005.107 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2073636k/2097088k available (1868k kernel code, 22428k
reserved, 755k data, 180k init, 1179584k highmem)
Calibrating delay using timer specific routine.. 4014.79 BogoMIPS (lpj=2007397)
Security Scaffold v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
There is already a security framework initialized, register_security failed.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000
CPU: After vendor identify, caps:  178bfbff e3d3fbff 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: After all inits, caps:        178bfbff e3d3fbff 00000000 00000010
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: AMD Dual Core AMD Opteron(tm) Processor 270 stepping 02
per-CPU timeslice cutoff: 2925.70 usecs.
task migration cache decay timeout: 3 msecs.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c03eb000 soft=c03cb000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4008.51 BogoMIPS (lpj=2004258)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000
CPU: After vendor identify, caps:  178bfbff e3d3fbff 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: After all inits, caps:        178bfbff e3d3fbff 00000000 00000010
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Dual Core AMD Opteron(tm) Processor 270 stepping 02
Total of 2 processors activated (8023.31 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
zapping low mappings.
checking if image is initramfs... it is
Freeing initrd memory: 476k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=3
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040816
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.POGA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.POGB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
ACPI: PCI interrupt 0000:00:07.2[D] -> GSI 19 (level, low) -> IRQ 169
ACPI: PCI interrupt 0000:03:03.0[A] -> GSI 42 (level, low) -> IRQ 177
ACPI: PCI interrupt 0000:02:01.0[A] -> GSI 47 (level, low) -> IRQ 185
ACPI: PCI interrupt 0000:02:03.0[A] -> GSI 49 (level, low) -> IRQ 193
ACPI: PCI interrupt 0000:02:03.1[B] -> GSI 50 (level, low) -> IRQ 201
ACPI: PCI interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -> IRQ 169
ACPI: PCI interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -> IRQ 169
ACPI: PCI interrupt 0000:01:04.0[A] -> GSI 17 (level, low) -> IRQ 209
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1147608466.509:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key 63EFDF11AD6BAA3
- User ID: Red Hat, Inc. (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU1] (supports C1, 8 throttling states)
ACPI: Processor [CPU2] (supports C1)
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
divert: not allocating divert_blk for non-ethernet device lo
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: CD-224E-N, ATAPI CD/DVD-ROM drive
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
Probing IDE interface ide2...
Probing IDE interface ide3...
Probing IDE interface ide4...
Probing IDE interface ide5...
hda: ATAPI 24X CD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
input: GenPS/2 Genius Wheel Mouse on isa0060/serio1
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 8192 buckets, 128Kbytes
TCP: Hash tables configured (established 262144 bind 43690)
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI: (supports S0 S1 S4 S5)
ACPI wakeup devices:
PCI1 USB0 USB1 PS2K PS2M UAR1 UAR2 POGA POGB PWRB
Freeing unused kernel memory: 180k freed
SCSI subsystem initialized
Adaptec aacraid driver (1.1-5[2412])
ACPI: PCI interrupt 0000:02:01.0[A] -> GSI 47 (level, low) -> IRQ 185
aacraid0: kernel 5.1-0[8832]
aacraid0: monitor 5.1-0[8832]
aacraid0: bios 5.1-0[8832]
aacraid0: serial 504e8b
scsi0 : aacraid
  Vendor: Adaptec   Model: ned               Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 1562193920 512-byte hdwr sectors (799843 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
SCSI device sda: drive cache: write through
SCSI device sda: 1562193920 512-byte hdwr sectors (799843 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
security:  3 users, 4 roles, 354 types, 26 bools
security:  55 classes, 21833 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), not configured for labeling
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
inserting floppy driver for 2.6.9-34.ELsmp
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
tg3.c:v3.43-rh (Oct 24, 2005)
ACPI: PCI interrupt 0000:02:03.0[A] -> GSI 49 (level, low) -> IRQ 193
divert: allocating divert_blk for eth0
eth0: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)]
(PCIX:133MHz:64-bit) 10/100/1000BaseT Ethernet 00:30:48:58:df:ae
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[769f4000]
ACPI: PCI interrupt 0000:02:03.1[B] -> GSI 50 (level, low) -> IRQ 201
divert: allocating divert_blk for eth1
eth1: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)]
(PCIX:133MHz:64-bit) 10/100/1000BaseT Ethernet 00:30:48:58:df:af
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[769f4000]
hw_random: AMD768 system management I/O registers at 0x5000.
hw_random hardware driver 1.0.0 loaded
shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: HPC vendor_id 1022 device_id 7460 ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -> IRQ 169
ohci_hcd 0000:01:00.0: OHCI Host Controller
ohci_hcd 0000:01:00.0: irq 169, pci mem f881a000
SELinux: initialized (dev usbdevfs, type usbdevfs), uses genfs_contexts
ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ACPI: PCI interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -> IRQ 169
ohci_hcd 0000:01:00.1: OHCI Host Controller
ohci_hcd 0000:01:00.1: irq 169, pci mem f881c000
ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ACPI: Power Button (FF) [PWRF]
EXT3 FS on sda1, internal journal
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
cdrom: open failed.
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
Adding 2048276k swap on /dev/sda2.  Priority:-1 extents:1
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
ip_tables: (C) 2000-2002 Netfilter core team
ip_tables: (C) 2000-2002 Netfilter core team
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
ip_tables: (C) 2000-2002 Netfilter core team
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
i2c /dev entries driver
parport0: PC-style at 0x378 [PCSPP,TRISTATE]
lp0: using parport0 (polling).
lp0: console ready
NET: Registered protocol family 10
Disabled Privacy Extensions on device c0342040(lo)
IPv6 over IPv4 tunneling driver
divert: not allocating divert_blk for non-ethernet device sit0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
eth1: no IPv6 routers present
eth0: no IPv6 routers present
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SCSI device sda: 1562193920 512-byte hdwr sectors (799843 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
SCSI device sda: drive cache: write through
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
i2c-sensor.o: Unknown VRM version of your x86 CPU
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts

Regards,
Simon
