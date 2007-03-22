From: thomas schorpp <t.schorpp@gmx.de>
Subject: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Thu, 22 Mar 2007 16:14:58 +0100
Message-ID: <46029D72.3060403@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933131AbXCVPPB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 11:15:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

lo,

well, ive several live cd systems < 2.6.19.5i386 that oops and hang boot in aic7xxx init,
only one booting here is knoppix 5.2,

the latest unofficial debian stable 2.6.8-12-amd64-generic, which 
says ACPI: PCI interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
aic7xxx: PCI0:6:0 MEM region 0x0 unavailable. Cannot memory map device.
but works ok,

a debian etch 2.6.18-4-amd64 which says:

SCSI subsystem initialized
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 169
BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ> [<ffffffff802a3fec>] softlockup_tick+0xdb/0xed
 [<ffffffff802881df>] update_process_times+0x42/0x68
 [<ffffffff8026cbd8>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8026d2cc>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8025904a>] apic_timer_interrupt+0x66/0x6c
 <EOI> [<ffffffff8038a412>] pci_conf1_write+0x0/0xc9
 [<ffffffff88053718>] :aic7xxx:ahc_pci_test_register_access+0xc2/0x391
 [<ffffffff880536a5>] :aic7xxx:ahc_pci_test_register_access+0x4f/0x391
 [<ffffffff88059416>] :aic7xxx:ahc_pci_map_registers+0x1bb/0x239
 [<ffffffff880523d2>] :aic7xxx:ahc_pci_config+0x4c/0x12d0
 [<ffffffff80389fb7>] pcibios_set_master+0x1e/0x84
 [<ffffffff88059186>] :aic7xxx:ahc_linux_pci_dev_probe+0x13e/0x213
 [<ffffffff80317eea>] pci_device_probe+0xdf/0x147
 [<ffffffff8036b9db>] driver_probe_device+0x52/0xa8
 [<ffffffff8036ba96>] __driver_attach+0x0/0x9a
 [<ffffffff8036bae6>] __driver_attach+0x50/0x9a
 [<ffffffff8036ba96>] __driver_attach+0x0/0x9a
 [<ffffffff8036b458>] bus_for_each_dev+0x43/0x6e
 [<ffffffff8036b09a>] bus_add_driver+0x7e/0x130
 [<ffffffff803180c4>] __pci_register_driver+0x57/0x7d
 [<ffffffff8805903e>] :aic7xxx:ahc_linux_pci_init+0x17/0x21
 [<ffffffff8806e325>] :aic7xxx:ahc_linux_init+0x325/0x336
 [<ffffffff8027d27d>] default_wake_function+0x0/0xe
 [<ffffffff8025e2e5>] __down_read+0x12/0x9a
 [<ffffffff80294fa1>] __link_module+0x0/0x25
 [<ffffffff802200e5>] __up_read+0x13/0x8a
 [<ffffffff80297695>] sys_init_module+0x16cc/0x1882
 [<ffffffff802584d6>] system_call+0x7e/0x83

BUG: soft lockup detected on CPU#0!

a kernel.org 2.6.20 with K8 config set but built in a 32Bit debian sid environment, 
but works ok,

and finally the latest kernel.org 2.6.20.3 AMD K8 built on debian amd64 etch userland that 
hangs boot on aic7xxx init without magic sysreq keys functionality:
Loading iSCSI transport class v2.0-724.
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17
... Kernel alive - Kernel direct mapping tables up to 100000000 @ 8000-d000

now trying latest scsi git and be on ##kernel at freenode if Q.

y
tom

SysRq : Resetting
Linux version 2.6.20.3amd64 (root@tom1) (gcc version 4.1.2 20061115 (prerelease7
Command line: root=/dev/sda1 ro single console=ttyS0,115200n8 aic7xxx=debug=255
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffd0000 (usable)
 BIOS-e820: 000000001ffd0000 - 000000001ffde000 (ACPI data)
 BIOS-e820: 000000001ffde000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
end_pfn_map = 1048576
DMI 2.3 present.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   131024
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists.  Total pages: 127672
Kernel command line: root=/dev/sda1 ro single console=ttyS0,115200n8 aic7xxx=de5
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2000.164 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Checking aperture...
CPU 0: aperture @ d0000000 size 128 MB
Memory: 509592k/524096k available (3711k kernel code, 13908k reserved, 1316k da)
Calibrating delay using timer specific routine.. 4005.05 BogoMIPS (lpj=8010104)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 02
ACPI: Core revision 20060707
 tbxface-0107 [01] load_tables           : ACPI Tables successfully acquired
Parsing all Control Methods:
Table [DSDT](id 0005) - 602 Objects with 65 Devices 164 Methods 27 Regions
ACPI Namespace successfully loaded at root ffffffff8079b8e0
evxfevnt-0089 [02] enable                : Transition to ACPI mode successful
Using local APIC timer interrupts.
result 12501044
Detected 12.501 MHz APIC timer.
testing NMI watchdog ... OK.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
evgpeblk-0951 [04] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 5 Wake, Enabled 0 Runtime GPEsk
Completing Region/Field/Buffer/Package initialization:..........................
Initialized 26/27 Regions 33/33 Fields 39/39 Buffers 15/16 Packages (611 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:
Executed 0 _INI methods requiring 0 _STA executions (examined 69 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
PCI: MSI-K8T-Neo2Fir, soundcard on
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 128M @ 0xd0000000
pnp: 00:08: ioport range 0x680-0x6ff has been reserved
pnp: 00:08: ioport range 0x295-0x296 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: e000-efff
  MEM window: fbf00000-fbffffff
  PREFETCH window: e8000000-faffffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
JFS: nTxBlock = 3982, nTxLock = 31862
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, nod
SGI XFS Quota Management subsystem
GFS2 (built Mar 22 2007 04:56:22) installed
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Loading iSCSI transport class v2.0-724.
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ 17


tom1:~# lspci -s 00:06.0 -vvv
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
        Subsystem: Adaptec 19160 Ultra160 SCSI Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        BIST result: 00
        Region 0: I/O ports at d800 [size=256]
        Region 1: Memory at <ignored> (64-bit, non-prefetchable) [disabled]
        Expansion ROM at fbee0000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


tom1:~# lspci
00:00.0 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 South]
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
00:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
00:08.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
00:0a.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
00:0e.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 46)
00:0f.0 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc R420 JI [Radeon X800PRO]
01:00.1 Display controller: ATI Technologies Inc R420 [Radeon X800 PRO/GTO] (Secondary)

