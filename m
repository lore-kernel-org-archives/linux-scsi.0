From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Thu, 22 Mar 2007 17:57:26 +0100
Message-ID: <4602B576.6020602@gmx.de>
References: <46029D72.3060403@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50106 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934116AbXCVQ53 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 12:57:29 -0400
In-Reply-To: <46029D72.3060403@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

no fix in scsi rc fixes git, now examining code from the softlockup trace before...

[    0.000000] Linux version 2.6.21-rc3amd64-gbb9ba31c (root@tom1) (gcc version
4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Thu Mar 22 17:39:17 CE
T 2007
[    0.000000] Command line: root=/dev/sda1 ro single console=ttyS0,115200n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffd0000 (usable)
[    0.000000]  BIOS-e820: 000000001ffd0000 - 000000001ffde000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ffde000 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F92B0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 1FFD0000, 0030 (r1 A M I  OEMRSDT  10000612 MSFT
 97)
[    0.000000] ACPI: FACP 1FFD0200, 0084 (r2 A M I  OEMFACP  10000612 MSFT
 97)
[    0.000000] ACPI: DSDT 1FFD03F0, 3D20 (r1  1XXXX 1XXXX005        5 INTL  2002
026)
[    0.000000] ACPI: FACS 1FFDE000, 0040
[    0.000000] ACPI: APIC 1FFD0390, 005C (r1 A M I  OEMAPIC  10000612 MSFT
 97)
[    0.000000] ACPI: OEMB 1FFDE040, 0046 (r1 A M I  AMI_OEM  10000612 MSFT
 97)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   131024
[    0.000000] Looks like a VIA chipset. Disabling IOMMU. Override with iommu=al
lowed
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e4000
[    0.000000] Nosave address range: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec0
0000)
[    0.000000] Built 1 zonelists.  Total pages: 126532
[    0.000000] Kernel command line: root=/dev/sda1 ro single console=ttyS0,11520
0n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)
[   40.851937] time.c: Detected 2000.089 MHz processor.
[   40.853406] Console: colour VGA+ 80x25
[   41.128559] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo
 Molnar
[   41.136287] ... MAX_LOCKDEP_SUBCLASSES:    8
[   41.140560] ... MAX_LOCK_DEPTH:          30
[   41.144747] ... MAX_LOCKDEP_KEYS:        2048
[   41.149105] ... CLASSHASH_SIZE:           1024
[   41.153550] ... MAX_LOCKDEP_ENTRIES:     8192
[   41.157901] ... MAX_LOCKDEP_CHAINS:      16384
[   41.162346] ... CHAINHASH_SIZE:          8192
[   41.166704]  memory used by lock dependency info: 1648 kB
[   41.172093]  per task-struct memory footprint: 1680 bytes
[   41.177480] ------------------------
[   41.181041] | Locking API testsuite:
[   41.184615] -----------------------------------------------------------------
-----------
[   41.192694]                                  | spin |wlock |rlock |mutex | ws
em | rsem |
[   41.200771]   ---------------------------------------------------------------
-----------
[   41.208855]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.217928]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.226939]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.236020]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.245093]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.254251]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.263393]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.272560]                     double unlock:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.281529]                   initialize held:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.290645]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  o
k  |  ok  |
[   41.299657]   ---------------------------------------------------------------
-----------
[   41.307730]               recursive read-lock:             |  ok  |
   |  ok  |
[   41.316159]            recursive read-lock #2:             |  ok  |
   |  ok  |
[   41.324582]             mixed read-write-lock:             |  ok  |
   |  ok  |
[   41.333006]             mixed write-read-lock:             |  ok  |
   |  ok  |
[   41.341438]   ---------------------------------------------------------------
-----------
[   41.349511]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   41.356219]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   41.362929]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   41.369633]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   41.376327]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[   41.383029]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[   41.389732]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   41.396426]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   41.403146]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   41.409857]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   41.416568]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   41.423314]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   41.430060]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   41.436789]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   41.443527]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   41.450280]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   41.457019]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   41.463738]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   41.470476]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   41.477186]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   41.483881]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   41.490618]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   41.497347]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   41.504058]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   41.510795]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   41.517524]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   41.524244]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   41.530972]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   41.537709]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   41.544610]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   41.551331]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   41.558060]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   41.564793]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   41.571517]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   41.578245]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   41.584974]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   41.591694]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   41.598423]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   41.605160]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   41.611880]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   41.618625]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   41.625354]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   41.632066]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   41.638794]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   41.645523]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   41.652243]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   41.658963]       hard-irq read-recursion/123:  ok  |
[   41.664178]       soft-irq read-recursion/123:  ok  |
[   41.669393]       hard-irq read-recursion/132:  ok  |
[   41.674608]       soft-irq read-recursion/132:  ok  |
[   41.679824]       hard-irq read-recursion/213:  ok  |
[   41.685047]       soft-irq read-recursion/213:  ok  |
[   41.690262]       hard-irq read-recursion/231:  ok  |
[   41.695477]       soft-irq read-recursion/231:  ok  |
[   41.700700]       hard-irq read-recursion/312:  ok  |
[   41.705917]       soft-irq read-recursion/312:  ok  |
[   41.711131]       hard-irq read-recursion/321:  ok  |
[   41.716359]       soft-irq read-recursion/321:  ok  |
[   41.721579] -------------------------------------------------------
[   41.727836] Good, all 218 testcases passed! |
[   41.732193] ---------------------------------
[   41.736981] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[   41.744291] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[   41.758593] Memory: 505032k/524096k available (3805k kernel code, 18504k rese
rved, 1774k data, 224k init)
[   41.848082] Calibrating delay using timer specific routine.. 4006.34 BogoMIPS
 (lpj=8012697)
[   41.856557] Security Framework v1.0.0 initialized
[   41.861316] Mount-cache hash table entries: 256
[   41.866572] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   41.873697] CPU: L2 Cache: 512K (64 bytes/line)
[   41.878239] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 02
[   41.884124] ACPI: Core revision 20070126
[   41.895705] Parsing all Control Methods:
[   41.899595] Table [DSDT](id 0001) - 602 Objects with 65 Devices 164 Methods 2
7 Regions
[   41.907693]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables successful
ly acquired
[   41.920009] evxfevnt-0091 [02] enable                : Transition to ACPI mod
e successful
[   41.969333] Using local APIC timer interrupts.
[   42.023671] result 12500575
[   42.026462] Detected 12.500 MHz APIC timer.
[   42.031753] testing NMI watchdog ... OK.
[   42.076493] NET: Registered protocol family 16
[   42.081563] ACPI: bus type pci registered
[   42.085588] PCI: Using configuration type 1
[   42.094308] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2
regs on int 0x9
[   42.107904] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 5 Wake, Enabled
0 Runtime GPEs in this block
[   42.118132] Completing Region/Field/Buffer/Package initialization:...........
................................................................................
......................
[   42.145469] Initialized 26/27 Regions 33/33 Fields 39/39 Buffers 15/16 Packag
es (611 nodes)
[   42.153990] Initializing Device/Processor/Thermal objects by executing _INI m
ethods:
[   42.161611] Executed 0 _INI methods requiring 0 _STA executions (examined 69
objects)
[   42.169674] ACPI: Interpreter enabled
[   42.173336] ACPI: (supports S0 S1 S3 S4 S5)
[   42.177705] ACPI: Using IOAPIC for interrupt routing
[   42.212210] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   42.218513] 0000:00:0f.0: cannot adjust BAR0 (not I/O)
[   42.223757] 0000:00:0f.0: cannot adjust BAR1 (not I/O)
[   42.228886] 0000:00:0f.0: cannot adjust BAR2 (not I/O)
[   42.234013] 0000:00:0f.0: cannot adjust BAR3 (not I/O)
[   42.239699] PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
[   42.245778] PCI: MSI-K8T-Neo2Fir, soundcard on
[   42.295385] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   42.302960] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   42.310690] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   42.318253] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   42.325826] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *
0, disabled.
[   42.334518] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *
0, disabled.
[   42.343206] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *
0, disabled.
[   42.351892] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *
0, disabled.
[   42.360543] Linux Plug and Play Support v0.97 (c) Adam Belay
[   42.366236] pnp: PnP ACPI init
[   42.379607] pnp: PnP ACPI: found 12 devices
[   42.385132] SCSI subsystem initialized
[   42.389179] PCI: Using ACPI for IRQ routing
[   42.393359] PCI: If a device doesn't work, try "pci=routeirq".  If it helps,
post a report
[   42.401868] NET: Registered protocol family 8
[   42.406217] NET: Registered protocol family 20
[   42.410911] agpgart: Detected AGP bridge 0
[   42.419685] agpgart: AGP aperture is 128M @ 0xd0000000
[   42.425098] pnp: 00:08: ioport range 0x680-0x6ff has been reserved
[   42.431261] Time: tsc clocksource has been installed.
[   42.436317] pnp: 00:08: ioport range 0x295-0x296 has been reserved
[   42.442499] pnp: 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[   42.449444] pnp: 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[   42.456396] pnp: 00:0b: iomem range 0x0-0x9ffff could not be reserved
[   42.462822] pnp: 00:0b: iomem range 0xc0000-0xcffff has been reserved
[   42.469248] pnp: 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[   42.476020] pnp: 00:0b: iomem range 0x100000-0x1fffffff could not be reserved
[   42.484406] PCI: Bridge: 0000:00:01.0
[   42.488071]   IO window: e000-efff
[   42.491486]   MEM window: fbf00000-fbffffff
[   42.495663]   PREFETCH window: e8000000-faffffff
[   42.500353] NET: Registered protocol family 2
[   42.542896] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[   42.550166] TCP established hash table entries: 16384 (order: 8, 1310720 byte
s)
[   42.558898] TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
[   42.567343] TCP: Hash tables configured (established 16384 bind 16384)
[   42.573896] TCP reno registered
[   42.590823] Initializing RT-Tester: OK
[   42.594724] Total HugeTLB memory allocated, 0
[   42.599639] VFS: Disk quotas dquot_6.5.1
[   42.603580] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   42.610491] JFS: nTxBlock = 3946, nTxLock = 31575
[   42.618904] SGI XFS with ACLs, security attributes, realtime, large block/ino
de numbers, no debug enabled
[   42.628786] SGI XFS Quota Management subsystem
[   42.633553] GFS2 (built Mar 22 2007 17:21:49) installed
[   42.639065] io scheduler noop registered
[   42.643003] io scheduler anticipatory registered (default)
[   42.648520] io scheduler deadline registered
[   42.652822] io scheduler cfq registered
[   42.754015] Linux agpgart interface v0.102 (c) Dave Jones
[   42.759419] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
enabled
[   42.767495] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   42.775544] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   42.784273] RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 block
size
[   42.792265] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   42.798668] ide: Assuming 33MHz system bus speed for PIO modes; override with
 idebus=xx
[   42.807376] Loading iSCSI transport class v2.0-724.
[   42.812647] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ
 17
