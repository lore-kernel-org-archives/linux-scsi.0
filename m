From: Marc D Ronell <mronell@alumni.upenn.edu>
Subject: Adaptec 7902 driver. Possible NMI watchdog lockup; linux-2.6.16.19
Date: Sat, 03 Jun 2006 22:11:17 -0400
Message-ID: <87verhllfe.fsf@corps.glidepath.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:27362 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S1750740AbWFDRAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2006 13:00:13 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1FmvxK-0001V2-H0
	for linux-scsi@vger.kernel.org; Sun, 04 Jun 2006 19:00:03 +0200
Received: from dialup-4.156.150.141.dial1.boston1.level3.net ([4.156.150.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jun 2006 19:00:02 +0200
Received: from mronell by dialup-4.156.150.141.dial1.boston1.level3.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jun 2006 19:00:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

Apologies in advance if this is the wrong group to post this issue.  I
think the following is an Adaptec 7902 driver problem.

I am  testing the 2.6.16.19 linux  kernel on a  Tyan 2882 motherboard.
Its running with a pair of Opteron 250 processors.  When I try to boot
with the kernel,  it seems to fail on the scsi  driver.  A console log
of the errors is attached below.

Thanks for any help and suggestions,

Marc


	Coda Kernel/Venus communications, v5.3.20, coda@cs.cmu.edu
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.26 [Flags: R/O].
fuse init (API version 7.6)
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with large block/inode numbers, no debug enabled
Initializing Cryptographic API
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: MSI quirk detected. pci_msi_quirk set.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
fakephp: Fake PCI Hot Plug Controller Driver
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>=
acpiphp_ibm: ibm_find_ad
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.=
1
cpcihp_generic: not configured, disabling.
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU1] (supports 8 throttling states)
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.2
hw_random: AMD768 system management I/O registers at 0x1000.
hw_random hardware driver 1.0.0 loaded
ppdev: user-space parallel port driver
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabl=
ed
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 169
0000:02:02.0: ttyS2 at I/O 0x8800 (irq =3D 169) is a 16550A
parport0: PC-style at 0x378 [PCSPP]
lp0: using parport0 (polling).
lp0: console ready
isa bounce pool size: 16 pages
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 6.3.9-k4
Copyright (c) 1999-2005 Intel Corporation.
Ethernet Channel Bonding Driver: v3.0.1 (January 9, 2006)
bonding: Warning: either miimon or arp_interval and arp_ip_target modul=
e parameters must be sp.
pcnet32.c:v1.31c 01.Nov.2005 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 18 (level, low) -> IRQ 177
e100: eth0: e100_probe: addr 0xfeafb000, irq 177, MAC addr 00:E0:81:2A:=
59:7F
tg3.c:v3.49 (Feb 2, 2006)
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 24 (level, low) -> IRQ 185
eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether2
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[763f0000] dma_mask[64-bit]
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 25 (level, low) -> IRQ 193
eth2: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether3
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth2: dma_rwctrl[763f0000] dma_mask[64-bit]
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: PIONEER DVD-RW DVR-107D, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: SONY DVD RW DRU-800A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 24 (level, low) -> IRQ 185
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz,=
 512 SCBs

  Vendor: IBM       Model: IC35L073UWDY10-0  Rev: S27Q
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 32
 target0:0:3: Beginning Domain Validation
 target0:0:3: wide asynchronous
 target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW=
 PCOMP (6.25 ns, offset)
 0:0:3:0: Attempting to queue an ABORT message:CDB: 0x12 0x0 0x0 0x0 0x=
a4 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x26 Mode 0x33
Card was paused
INTSTAT[0x0] SELOID[0x3] SELID[0x0] HS_MAILBOX[0x0]=20
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11]=20
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE)=20
SCSISIGI[0x25]:(P_DATAOUT_DT|ACKI|BSYI) SCSIPHASE[0x1]:(DATA_OUT_PHASE)=
=20
SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)=20
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)=20
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4]:(SELECTOUT_Q=
=46ROZEN)=20
QFREEZE_COUNT[0x0] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]=20
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x11]:(REQINIT|PHASEMIS)=20
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO)=20
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)=20
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED)=20
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)=20

SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0=
xff00
qinstart =3D 14 qinfifonext =3D 14
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x37]=20
Total 1
Kernel Free SCB list: 2 1 0=20
Sequencer Complete DMA-inprog list:=20
Sequencer Complete list:=20
Sequencer DMA-Up and Complete list:=20
Sequencer On QFreeze and Complete list:=20


scsi0: FIFO0 Free, LONGJMP =3D=3D 0x80ff, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DAT=
A|ENSAVEPTRS)=20
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL=
)=20
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR =3D 0x00, SHCNT =3D=
 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)=20

scsi0: FIFO1 Free, LONGJMP =3D=3D 0x801b, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DAT=
A|ENSAVEPTRS)=20
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL=
)=20
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR =3D 0x00, SHCNT =3D=
 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)=20
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0 0x0=20
scsi0: LQISTATE =3D 0x1, LQOSTATE =3D 0x0, OPTIONMODE =3D 0x52
scsi0: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =3D 0x1
scsi0: SAVED_SCSIID =3D 0x0 SAVED_LUN =3D 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR)=20
CCSCBCTL[0x4]:(CCSCBDIR)=20
scsi0: REG0 =3D=3D 0xff00, SINDEX =3D 0x108, DINDEX =3D 0x108
scsi0: SCBPTR =3D=3D 0x3, SCB_NEXT =3D=3D 0xff00, SCB_NEXT2 =3D=3D 0xff=
cf
CDB 12 0 0 0 a4 0
STACK: 0x22 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
 0:0:3:0: BDR message in message buffer
scsi0: Recovery code sleeping
scsi0: Recovery code awake
scsi0: Timer Expired (active 1)
aic79xx_abort returns 0x2003
 0:0:3:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x0 0x0 =
0x0 0xa4 0x0
aic79xx_dev_reset returns 0x2003
Recovery SCB completes
NMI Watchdog detected LOCKUP on CPU 0
CPU 0=20
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.16.16 #2
RIP: 0010:[<ffffffff8060acfd>] <ffffffff8060acfd>{.text.lock.spinlock+2=
2}
RSP: 0000:ffffffff808873d8  EFLAGS: 00000082
RAX: ffffffff8093bfd8 RBX: ffff81007fcf0000 RCX: ffff81007fcf3178
RDX: ffffffff80887408 RSI: ffff810002c11938 RDI: ffff81007f967f80
RBP: 0000000000000040 R08: 000000000000007f R09: 0000000000000100
R10: ffff810002c10cc0 R11: 000000000000007f R12: ffffffff80429a50
R13: ffffffff80887408 R14: 000000000000000a R15: 0000000000000000
=46S:  0000000000000000(0000) GS:ffffffff8092e000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
=2E8cF`;s;=EC.=EC..0 :=B0:=EB..x=EAr0000=FC(cFw|p=B0x(2sks;=E8.|=F1````=
`````````=E0..=F1`.=D8.cFw|.=B0x..=F1p=AC.=AC=E6;=E8.|=F1a`````)
Linux version 2.6.16.18 (root@corps) (gcc version 3.3.5 (Debian 1:3.3.5=
-13)) #1 SMP Mon May 296
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000fbff0000 (usable)
 BIOS-e820: 00000000fbff0000 - 00000000fbfff000 (ACPI data)
 BIOS-e820: 00000000fbfff000 - 00000000fc000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 1 PXM 1 80000000-fc000000
SRAT: Node 1 PXM 1 80000000-100000000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000080000000
Bootmem setup node 1 0000000080000000-00000000fbff0000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfebff000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xfebff000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xfebfe000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xfebfe000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at fc400000 (gap: fc000000:3780000)
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
Built 2 zonelists
Kernel command line: root=3D/dev/md0 ro console=3DttyS0,38400n8 console=
=3Dtts/0,38400n8 console=3Dtty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2388.714 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 4056604k/4128704k available (5185k kernel code, 71712k reserved=
, 2507k data, 280k init)
Calibrating delay using timer specific routine.. 4789.09 BogoMIPS (lpj=3D=
9578182)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(1) -> Node 0 -> Core 0
Using local APIC timer interrupts.
result 12441231
Detected 12.441 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4777.66 BogoMIPS (lpj=3D=
9555335)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(1) -> Node 1 -> Core 0
AMD Opteron(tm) Processor 250 stepping 0a
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -2 cycles, maxerr 901 cyc=
les)
Brought up 2 CPUs
testing NMI watchdog ... OK.
migration_cost=3D776
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
PCI-DMA: Disabling IOMMU.
PCI: Bridge: 0000:00:06.0
  IO window: 9000-bfff
  MEM window: fc900000-feafffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: 7000-8fff
  MEM window: fc600000-fc8fffff
  PREFETCH window: ff500000-ff5fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Coda Kernel/Venus communications, v5.3.20, coda@cs.cmu.edu
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.26 [Flags: R/O].
fuse init (API version 7.6)
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with large block/inode numbers, no debug enabled
Initializing Cryptographic API
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: MSI quirk detected. pci_msi_quirk set.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
fakephp: Fake PCI Hot Plug Controller Driver
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>=
acpiphp_ibm: ibm_find_ad
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.=
1
cpcihp_generic: not configured, disabling.
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU1] (supports 8 throttling states)
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
hpet_acpi_add: no address or irqs in _CRS
Non-volatile memory driver v1.2
hw_random: AMD768 system management I/O registers at 0x1000.
hw_random hardware driver 1.0.0 loaded
ppdev: user-space parallel port driver
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabl=
ed
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 169
0000:02:02.0: ttyS2 at I/O 0x8800 (irq =3D 169) is a 16550A
parport0: PC-style at 0x378 [PCSPP]
lp0: using parport0 (polling).
lp0: console ready
isa bounce pool size: 16 pages
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 6.3.9-k4
Copyright (c) 1999-2005 Intel Corporation.
Ethernet Channel Bonding Driver: v3.0.1 (January 9, 2006)
bonding: Warning: either miimon or arp_interval and arp_ip_target modul=
e parameters must be sp.
pcnet32.c:v1.31c 01.Nov.2005 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 18 (level, low) -> IRQ 177
e100: eth0: e100_probe: addr 0xfeafb000, irq 177, MAC addr 00:E0:81:2A:=
59:7F
tg3.c:v3.49 (Feb 2, 2006)
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 24 (level, low) -> IRQ 185
eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether2
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[763f0000] dma_mask[64-bit]
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 25 (level, low) -> IRQ 193
eth2: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether3
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth2: dma_rwctrl[763f0000] dma_mask[64-bit]
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
NET: Registered protocol family 24
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: PIONEER DVD-RW DVR-107D, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: SONY DVD RW DRU-800A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 24 (level, low) -> IRQ 185
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz,=
 512 SCBs

  Vendor: IBM       Model: IC35L073UWDY10-0  Rev: S27Q
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 32
 target0:0:3: Beginning Domain Validation
 target0:0:3: wide asynchronous
 target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW=
 PCOMP (6.25 ns, offset)
 0:0:3:0: Attempting to queue an ABORT message:CDB: 0x12 0x0 0x0 0x0 0x=
a4 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x2 Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x3] SELID[0x0] HS_MAILBOX[0x0]=20
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11]=20
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE)=20
SCSISIGI[0x25]:(P_DATAOUT_DT|ACKI|BSYI) SCSIPHASE[0x1]:(DATA_OUT_PHASE)=
=20
SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)=20
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)=20
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4]:(SELECTOUT_Q=
=46ROZEN)=20
QFREEZE_COUNT[0x0] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]=20
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x11]:(REQINIT|PHASEMIS)=20
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]:(HIPERR|HIZERO)=20
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)=20
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED)=20
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)=20

SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0=
xff00
qinstart =3D 14 qinfifonext =3D 14
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x37]=20
Total 1
Kernel Free SCB list: 2 1 0=20
Sequencer Complete DMA-inprog list:=20
Sequencer Complete list:=20
Sequencer DMA-Up and Complete list:=20
Sequencer On QFreeze and Complete list:=20


scsi0: FIFO0 Free, LONGJMP =3D=3D 0x80ff, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DAT=
A|ENSAVEPTRS)=20
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL=
)=20
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR =3D 0x00, SHCNT =3D=
 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)=20

scsi0: FIFO1 Free, LONGJMP =3D=3D 0x801b, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DAT=
A|ENSAVEPTRS)=20
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL=
)=20
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR =3D 0x00, SHCNT =3D=
 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)=20
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0 0x0=20
scsi0: LQISTATE =3D 0x1, LQOSTATE =3D 0x0, OPTIONMODE =3D 0x52
scsi0: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =3D 0x1
scsi0: SAVED_SCSIID =3D 0x0 SAVED_LUN =3D 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR)=20
CCSCBCTL[0x4]:(CCSCBDIR)=20
scsi0: REG0 =3D=3D 0x3, SINDEX =3D 0x108, DINDEX =3D 0x108
scsi0: SCBPTR =3D=3D 0xff03, SCB_NEXT =3D=3D 0xff00, SCB_NEXT2 =3D=3D 0=
x0
CDB 3 1 0 0 0 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
 0:0:3:0: BDR message in message buffer
scsi0: Recovery code sleeping
scsi0: Recovery code awake
scsi0: Timer Expired (active 1)
aic79xx_abort returns 0x2003
 0:0:3:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x0 0x0 =
0x0 0xa4 0x0
aic79xx_dev_reset returns 0x2003
Recovery SCB completes
NMI Watchdog detected LOCKUP on CPU 0
CPU 0=20
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.16.18 #1
RIP: 0010:[<ffffffff8060ae3d>] <ffffffff8060ae3d>{.text.lock.spinlock+2=
2}
RSP: 0000:ffffffff808875d8  EFLAGS: 00000082
RAX: ffffffff8093bfd8 RBX: ffff81007fcf0000 RCX: ffff81007fcf3178
RDX: ffffffff80887608 RSI: ffff810002c11b88 RDI: ffff81007f90db00
RBP: 0000000000000040 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff80429b90
R13: ffffffff80887608 R14: 000000000000000a R15: 0000000000000000
=46S:  0000000000000000(0000) GS:ffffffff8092e000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffffffff8093a000, task ffffffff8073=
a180)
Stack: 0000000000000296 ffffffff80429bac 0000000000000100 ffff810002c10=
e00=20
       ffffffff80429b90 ffffffff8013adb3 ffffffff80887608 ffffffff80887=
608=20
=2E(cFq..=B0x(2sks;h.|=F1a``````````` =E0.8=F1`d=D8(cFw|.=B0x(2sks;=E8.=
|=F1`````````````=E0..=F1`.=D8.cFw|.=B0x..=F1p,.=AC=E6;)
Linux version 2.6.16.19 (root@corps) (gcc version 3.3.5 (Debian 1:3.3.5=
-13)) #1 SMP Sat Jun 3 6
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000fbff0000 (usable)
 BIOS-e820: 00000000fbff0000 - 00000000fbfff000 (ACPI data)
 BIOS-e820: 00000000fbfff000 - 00000000fc000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 1 PXM 1 80000000-fc000000
SRAT: Node 1 PXM 1 80000000-100000000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000080000000
Bootmem setup node 1 0000000080000000-00000000fbff0000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfebff000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xfebff000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xfebfe000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xfebfe000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at fc400000 (gap: fc000000:3780000)
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
SMP: Allowing 4 CPUs, 2 hotplug CPUs
Built 2 zonelists
Kernel command line: root=3D/dev/md0 ro console=3DttyS0,38400n8 console=
=3Dtts/0,38400n8 console=3Dtty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2387.448 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 4059464k/4128704k available (3133k kernel code, 68852k reserved=
, 1797k data, 204k init)
Calibrating delay using timer specific routine.. 4786.35 BogoMIPS (lpj=3D=
9572707)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(1) -> Node 0 -> Core 0
Using local APIC timer interrupts.
result 12434638
Detected 12.434 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4775.13 BogoMIPS (lpj=3D=
9550265)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(1) -> Node 1 -> Core 0
AMD Opteron(tm) Processor 250 stepping 0a
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -1 cycles, maxerr 900 cyc=
les)
Brought up 2 CPUs
testing NMI watchdog ... OK.
migration_cost=3D550
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs<7>Losing some ticks... checking i=
f CPU frequency changed.
 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
PCI-DMA: Disabling IOMMU.
PCI: Bridge: 0000:00:06.0
  IO window: 9000-bfff
  MEM window: fc900000-feafffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: 7000-8fff
  MEM window: fc600000-fc8fffff
  PREFETCH window: ff500000-ff5fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: MSI quirk detected. pci_msi_quirk set.
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU1] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
hpet_acpi_add: no address or irqs in _CRS
hw_random: AMD768 system management I/O registers at 0x1000.
hw_random hardware driver 1.0.0 loaded
Software Watchdog Timer: 0.07 initialized. soft_noboot=3D0 soft_margin=3D=
60 sec (nowayout=3D 0)
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabl=
ed
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 169
0000:02:02.0: ttyS2 at I/O 0x8800 (irq =3D 169) is a 16550A
isa bounce pool size: 16 pages
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 6.3.9-k4
Copyright (c) 1999-2005 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 18 (level, low) -> IRQ 177
e100: eth0: e100_probe: addr 0xfeafb000, irq 177, MAC addr 00:E0:81:2A:=
59:7F
tg3.c:v3.49 (Feb 2, 2006)
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 24 (level, low) -> IRQ 185
eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether2
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[763f0000] dma_mask[64-bit]
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 25 (level, low) -> IRQ 193
eth2: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether3
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth2: dma_rwctrl[763f0000] dma_mask[64-bit]
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: PIONEER DVD-RW DVR-107D, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: SONY DVD RW DRU-800A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 24 (level, low) -> IRQ 185
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz,=
 512 SCBs

  Vendor: IBM       Model: IC35L073UWDY10-0  Rev: S27Q
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 32
 target0:0:3: Beginning Domain Validation
 target0:0:3: wide asynchronous
 target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW=
 PCOMP (6.25 ns, offset)
 0:0:3:0: Attempting to queue an ABORT message:CDB: 0x12 0x0 0x0 0x0 0x=
a4 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x5 Mode 0x33
Card was paused
INTSTAT[0x0] SELOID[0x3] SELID[0x0] HS_MAILBOX[0x0]=20
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]=20
SCSISIGI[0x24] SCSIPHASE[0x1] SCSIBUS[0x0] LASTPHASE[0x1]=20
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]=20
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]=20
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]=20
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x11]=20
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4]=20
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80] LQOSTAT0[0x0]=20
LQOSTAT1[0x0] LQOSTAT2[0xe1]=20

SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0=
xff00
qinstart =3D 14 qinfifonext =3D 14
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x37]=20
Total 1
Kernel Free SCB list: 2 1 0=20
Sequencer Complete DMA-inprog list:=20
Sequencer Complete list:=20
Sequencer DMA-Up and Complete list:=20
Sequencer On QFreeze and Complete list:=20


scsi0: FIFO0 Free, LONGJMP =3D=3D 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]=20
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5] SHADDR =3D 0x00, SHCNT =3D 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]=20

scsi0: FIFO1 Free, LONGJMP =3D=3D 0x801b, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]=20
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5] SHADDR =3D 0x00, SHCNT =3D 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]=20
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0 0x0=20
scsi0: LQISTATE =3D 0x1, LQOSTATE =3D 0x0, OPTIONMODE =3D 0x52
scsi0: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =3D 0x1
=2E(cFq..=B0xqqqqqqqqqqqqqqqqqqqqqqqq=F1=D8ps=E70.cF``..0.0.Y0{=F2s3=FB=
=2E.=C7s :00000(cF``=FA.=FAxp=B2;.=EA.'.=E082`...00)
Linux version 2.6.16.19 (root@corps) (gcc version 3.3.5 (Debian 1:3.3.5=
-13)) #1 SMP Sat Jun 3 6
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000fbff0000 (usable)
 BIOS-e820: 00000000fbff0000 - 00000000fbfff000 (ACPI data)
 BIOS-e820: 00000000fbfff000 - 00000000fc000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 1 -> APIC 1 -> Node 1
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 1 PXM 1 80000000-fc000000
SRAT: Node 1 PXM 1 80000000-100000000
SRAT: Node 0 PXM 0 0-80000000
Bootmem setup node 0 0000000000000000-0000000080000000
Bootmem setup node 1 0000000080000000-00000000fbff0000
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:5 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfebff000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xfebff000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xfebfe000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xfebfe000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at fc400000 (gap: fc000000:3780000)
Checking aperture...
CPU 0: aperture @ 0 size 32 MB
No AGP bridge found
SMP: Allowing 4 CPUs, 2 hotplug CPUs
Built 2 zonelists
Kernel command line: root=3D/dev/md0 ro aic79xx=3Dverbose,no_reset,debu=
g:0xffff console=3DttyS0,38400
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2387.399 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Memory: 4059464k/4128704k available (3133k kernel code, 68852k reserved=
, 1797k data, 204k init)
Calibrating delay using timer specific routine.. 4786.32 BogoMIPS (lpj=3D=
9572657)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(1) -> Node 0 -> Core 0
Using local APIC timer interrupts.
result 12434382
Detected 12.434 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4774.83 BogoMIPS (lpj=3D=
9549661)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(1) -> Node 1 -> Core 0
AMD Opteron(tm) Processor 250 stepping 0a
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff -3 cycles, maxerr 900 cyc=
les)
Brought up 2 CPUs
testing NMI watchdog ... OK.
migration_cost=3D548
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs<7>Losing some ticks... checking i=
f CPU frequency changed.
 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
PCI-DMA: Disabling IOMMU.
PCI: Bridge: 0000:00:06.0
  IO window: 9000-bfff
  MEM window: fc900000-feafffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: 7000-8fff
  MEM window: fc600000-fc8fffff
  PREFETCH window: ff500000-ff5fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: MSI quirk detected. pci_msi_quirk set.
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU1] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
hpet_acpi_add: no address or irqs in _CRS
hw_random: AMD768 system management I/O registers at 0x1000.
hw_random hardware driver 1.0.0 loaded
Software Watchdog Timer: 0.07 initialized. soft_noboot=3D0 soft_margin=3D=
60 sec (nowayout=3D 0)
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabl=
ed
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 169
0000:02:02.0: ttyS2 at I/O 0x8800 (irq =3D 169) is a 16550A
isa bounce pool size: 16 pages
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 6.3.9-k4
Copyright (c) 1999-2005 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 18 (level, low) -> IRQ 177
e100: eth0: e100_probe: addr 0xfeafb000, irq 177, MAC addr 00:E0:81:2A:=
59:7F
tg3.c:v3.49 (Feb 2, 2006)
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 24 (level, low) -> IRQ 185
eth1: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether2
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[763f0000] dma_mask[64-bit]
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 25 (level, low) -> IRQ 193
eth2: Tigon3 [partno(BCM95704A7) rev 2003 PHY(5704)] (PCI:33MHz:64-bit)=
 10/100/1000BaseT Ether3
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth2: dma_rwctrl[763f0000] dma_mask[64-bit]
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
AMD8111: IDE controller at PCI slot 0000:00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:DMA, hdd:pio
hda: PIONEER DVD-RW DVR-107D, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdc: SONY DVD RW DRU-800A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 24 (level, low) -> IRQ 185
ahd_pci:2:6:0: Enabling 39Bit Addressing
ahd_pci:2:6:0: Reading VPD from SEEPROM...ahd_pci:2:6:0: VPD parsing su=
ccessful
ahd_pci:2:6:0: Reading SEEPROM...done.
ahd_pci:2:6:0: STPWLEVEL is on
ahd_pci:2:6:0: Manual Primary Termination
ahd_pci:2:6:0: Manual Secondary Termination
ahd_pci:2:6:0: Primary High byte termination Enabled
ahd_pci:2:6:0: Primary Low byte termination Enabled
ahd_pci:2:6:0: Secondary High byte termination Disabled
ahd_pci:2:6:0: Secondary Low byte termination Disabled
ahd_pci:2:6:0: Downloading Sequencer Program... 689 instructions downlo=
aded
ahd_pci:2:6:0: Features 0x7c101, Bugs 0x700002, Flags 0x143f1
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz,=
 512 SCBs

scsi0: Slave Alloc 0
 target0:0:0: FAST-5 SCSI 1.0 MB/s ST (1020 ns, offset 255)
scsi0: target 0 using 8bit transfers
 target0:0:0: asynchronous
scsi0: target 0 using asynchronous transfers
scsi0: Selection Timeout on A:0. 0 SCBs aborted
scsi0: Slave Destroy 0
scsi0: Slave Alloc 1
 target0:0:1: FAST-5 SCSI 1.0 MB/s ST (1020 ns, offset 255)
scsi0: target 1 using 8bit transfers
 target0:0:1: asynchronous
scsi0: target 1 using asynchronous transfers
scsi0: Selection Timeout on A:1. 0 SCBs aborted
scsi0: Slave Destroy 1
scsi0: Slave Alloc 2
 target0:0:2: FAST-5 SCSI 1.0 MB/s ST (1020 ns, offset 255)
scsi0: target 2 using 8bit transfers
 target0:0:2: asynchronous
scsi0: target 2 using asynchronous transfers
scsi0: Selection Timeout on A:2. 0 SCBs aborted
scsi0: Slave Destroy 2
scsi0: Slave Alloc 3
(scsi0:A:3:0): Sending WDTR 0
(scsi0:A:3:0): Received WDTR 0 filtered to 0
 target0:0:3: FAST-5 SCSI 1.0 MB/s ST (1020 ns, offset 255)
scsi0: target 3 using 8bit transfers
(scsi0:A:3:0): Sending SDTR period 44, offset 0
(scsi0:A:3:0): Received SDTR period 44, offset 0
        Filtered to period 0, offset 0
 target0:0:3: asynchronous
scsi0: target 3 using asynchronous transfers
  Vendor: IBM       Model: IC35L073UWDY10-0  Rev: S27Q
  Type:   Direct-Access                      ANSI SCSI revision: 03
 0:0:3:0: Slave Configure
 target0:0:3: asynchronous
scsi0:A:3:0: Tagged Queuing enabled.  Depth 32
 target0:0:3: Beginning Domain Validation
(scsi0:A:3:0): Sending WDTR 1
(scsi0:A:3:0): Received WDTR 1 filtered to 1
 target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 ns, offset 255)
scsi0: target 3 using 16bit transfers
(scsi0:A:3:0): Sending SDTR period 44, offset 0
(scsi0:A:3:0): Received SDTR period 44, offset 0
        Filtered to period 0, offset 0
 target0:0:3: wide asynchronous
scsi0: target 3 using asynchronous transfers
(scsi0:A:3:0): Sending WDTR 1
(scsi0:A:3:0): Received WDTR 1 filtered to 1
 target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 ns, offset 255)
scsi0: target 3 using 16bit transfers
(scsi0:A:3:0): Sending SDTR period 44, offset 0
(scsi0:A:3:0): Received SDTR period 44, offset 0
        Filtered to period 0, offset 0
 target0:0:3: wide asynchronous
scsi0: target 3 using asynchronous transfers
(scsi0:A:3:0): Sending WDTR 1
(scsi0:A:3:0): Received WDTR 1 filtered to 1
 target0:0:3: FAST-5 WIDE SCSI 2.0 MB/s ST (1020 ns, offset 255)
scsi0: target 3 using 16bit transfers
(scsi0:A:3:0): Sending SDTR period 44, offset 0
(scsi0:A:3:0): Received SDTR period 44, offset 0
        Filtered to period 0, offset 0
 target0:0:3: wide asynchronous
scsi0: target 3 using asynchronous transfers
(scsi0:A:3:0): Sending PPR bus_width 1, period 8, offset fe, ppr_option=
s f7
(scsi0:A:3:0): Received PPR width 1, period 8, offset 7f,options f7
        Filtered to width 1, period 8, offset 7f, options f7
 target0:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM RTI WRFLOW=
 PCOMP (6.25 ns, offset)
scsi0: target 3 synchronous with period =3D 0x8, offset =3D 0x7f(RDSTRM=
|DT|IU|RTI|QAS)
 0:0:3:0: Attempting to queue an ABORT message:CDB: 0x12 0x0 0x0 0x0 0x=
a4 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x5 Mode 0x33
Card was paused
INTSTAT[0x0] SELOID[0x3] SELID[0x0] HS_MAILBOX[0x0]=20
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]=20
SCSISIGI[0x24] SCSIPHASE[0x1] SCSIBUS[0x0] LASTPHASE[0x1]=20
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]=20
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]=20
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00]=20
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x11]=20
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4]=20
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80] LQOSTAT0[0x0]=20
LQOSTAT1[0x0] LQOSTAT2[0xe1]=20

SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0=
xff00
qinstart =3D 14 qinfifonext =3D 14
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x37]=20
Total 1
Kernel Free SCB list: 2 1 0=20
Sequencer Complete DMA-inprog list:=20
Sequencer Complete list:=20
Sequencer DMA-Up and Complete list:=20
Sequencer On QFreeze and Complete list:=20


scsi0: FIFO0 Free, LONGJMP =3D=3D 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]=20
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5] SHADDR =3D 0x00, SHCNT =3D 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]=20

scsi0: FIFO1 Free, LONGJMP =3D=3D 0x801b, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]=20
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]=20
SOFFCNT[0x2] MDFFSTAT[0x5] SHADDR =3D 0x00, SHCNT =3D 0x0=20
HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10]=20
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0=
x0 0x0 0x0 0x0=20
scsi0: LQISTATE =3D 0x1, LQOSTATE =3D 0x0, OPTIONMODE =3D 0x52
scsi0: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =3D 0x1
scsi0: SAVED_SCSIID =3D 0x0 SAVED_LUN =3D 0x0
SIMODE0[0xc]=20
CCSCBCTL[0x4]=20
scsi0: REG0 =3D=3D 0xff00, SINDEX =3D 0x108, DINDEX =3D 0x108
scsi0: SCBPTR =3D=3D 0x3, SCB_NEXT =3D=3D 0xff00, SCB_NEXT2 =3D=3D 0xff=
e8
CDB 12 0 0 0 a4 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
 0:0:3:0: BDR message in message buffer
scsi0: Recovery code sleeping
scsi0: Recovery code awake
scsi0: Timer Expired (active 1)
aic79xx_abort returns 0x2003
 0:0:3:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x0 0x0 =
0x0 0xa4 0x0
aic79xx_dev_reset returns 0x2003
Recovery SCB completes
 target0:0:3: FAST-160 SCSI 160.0 MB/s DT IU QAS RDSTRM RTI WRFLOW PCOM=
P (6.25 ns, offset 127)
scsi0: target 3 using 8bit transfers
 target0:0:3: asynchronous
scsi0: target 3 using asynchronous transfers
scsi0: target 4 using 8bit transfers
scsi0: target 4 using asynchronous transfers
scsi0: target 5 using 8bit transfers
scsi0: target 5 using asynchronous transfers
scsi0: target 6 using 8bit transfers
scsi0: target 6 using asynchronous transfers
scsi0: target 7 using 8bit transfers
scsi0: target 7 using asynchronous transfers
scsi0: target 8 using 8bit transfers
scsi0: target 8 using asynchronous transfers
scsi0: target 9 using 8bit transfers
scsi0: target 9 using asynchronous transfers
scsi0: target 10 using 8bit transfers
scsi0: target 10 using asynchronous transfers
scsi0: target 11 using 8bit transfers
scsi0: target 11 using asynchronous transfers
scsi0: target 12 using 8bit transfers
scsi0: target 12 using asynchronous transfers
scsi0: target 13 using 8bit transfers
scsi0: target 13 using asynchronous transfers
scsi0: target 14 using 8bit transfers
scsi0: target 14 using asynchronous transfers
scsi0: target 15 using 8bit transfers
scsi0: target 15 using asynchronous transfers
NMI Watchdog detected LOCKUP on CPU 0
CPU 0=20
Modules linked in:
Pid: 857, comm: scsi_eh_0 Tainted: G   M  2.6.16.19 #1
RIP: 0010:[<ffffffff8040a31d>] <ffffffff8040a31d>{.text.lock.spinlock+2=
2}
RSP: 0000:ffff81007fd27d88  EFLAGS: 00000086
RAX: 00000000012143e1 RBX: ffff81007fcf8000 RCX: 0000000000000002
RDX: 33ff810002e26ff0 RSI: 0000000000000003 RDI: ffff81007fd9b300
RBP: ffff81007fcf8000 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000010 R14: 0000000000000010 R15: 0000000000000001
=46S:  0000000000000000(0000) GS:ffffffff8065e000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
Process scsi_eh_0 (pid: 857, threadinfo ffff81007fd26000, task ffff8100=
82194300)
Stack: 0000000000000087 ffffffff8030debd 00000000012143e1 ffff81007fcfb=
148=20
       ffff81007fcf8000 ffffffff80305ace 0000000f00000007 0000000f02d28=
000=20
       00000041ffffffff 0000000000000000=20
Call Trace: <ffffffff8030debd>{ahd_freeze_simq+22} <ffffffff80305ace>{a=
hd_reset_channel+990}
       <ffffffff8030c0a4>{ahd_linux_bus_reset+68} <ffffffff802e9de3>{sc=
si_try_bus_reset+37}
       <ffffffff802e9f37>{scsi_eh_bus_reset+95} <ffffffff8014498f>{keve=
ntd_create_kthread+0}
       <ffffffff802ea342>{scsi_eh_ready_devs+54} <ffffffff802ea496>{scs=
i_unjam_host+149}
       <ffffffff802ea4a7>{scsi_error_handler+0} <ffffffff802ea506>{scsi=
_error_handler+95}
       <ffffffff80144966>{kthread+129} <ffffffff8010b5a2>{child_rip+8}
       <ffffffff8014498f>{keventd_create_kthread+0} <ffffffff801448e5>{=
kthread+0}
       <ffffffff8010b59a>{child_rip+0}

Code: 83 3f 00 7e f9 e9 62 fe ff ff f3 90 83 3f 00 7e f9 e9 66 fe=20
console shuts up ...
=20
=20


--=20



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
