From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: qlogic 2312 problems on 2.6.16.22, 2.6.18rc4
Date: Wed, 16 Aug 2006 23:10:26 +0200
Message-ID: <200608162310.26541.arekm@pld-linux.org>
References: <200608140946.50411.arekm@pld-linux.org> <200608151429.09082.arekm@pld-linux.org> <20060816181445.GU3674@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outgoing3.smtp.agnat.pl ([193.239.44.85]:54740 "EHLO
	outgoing3.smtp.agnat.pl") by vger.kernel.org with ESMTP
	id S932228AbWHPVKi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2006 17:10:38 -0400
In-Reply-To: <20060816181445.GU3674@andrew-vasquezs-computer.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wednesday 16 August 2006 20:14, Andrew Vasquez wrote:

> > Everything works fine on 32-bit dual xeon machine with card inserte=
d into
> > PCI slot. Here in new dual core opteron machine the card sits in PC=
I-X
> > slot. It's Thunder K8SRE S2891 mainboard, Transport GT24 B2891 1U
> > barebone, Tyan M2075 riser card, 2 x Opteron 270, 6GB ram.
>
> Have you ruled out motherboard/memory issues?  We've run 23xx and 24x=
x
> boards on a variety of AMD64 motherboards with more than 4GB of
> memory.
Not exactly. I have three such servers (the same board, cpu, ram).

One of these has PCI-E scsi raid controller and works without any probl=
em.=20

Second one (which I'm using for testing) has Adaptec SCSI controller=20
in Tyan specific TARRO slot (which afaik sits on the same PCI-X bus as =
PCI-X slot).
I had an array on that adaptec for some time and there were no problems=
=2E
The second one also got own qlogic 2312 card.

Third machine has other qlogic 2312 card and I tried it two times,
too - the same issues observed.

So mainboards and memory should be fine but I guess there is possibilit=
y
that PCI-X slot is somehow broken there. I'll test that in several week=
s
(unfortunately I have no physical access to these now) by putting some
typical scsi controller into that pci-x slot.

> > Note that booting with 32-bit kernel (which works fine on Xeon syst=
em)
> > doesn't cure the problem on Opteron system. Booting 64bit 2.6.18rc4
> > kernel with mem=3D3G also doesn't fix anything.
>
> Hmm...  Can you send your dmesg output post boot and driver load?

dmesg and lspci -vvv attached.

There is one thing that worries me:
  QLogic QLA2340 -=20
  ISP2312: PCI-X (133 MHz) @ 0000:09:08.0 hdma+, host#=3D0, fw=3D3.03.2=
0 IPX

Why it's showing 133MHz here?=20

Tyan manual ftp://ftp.tyan.com/manuals/m_s2891_100.pdf says on page 4
,,One PCI-X 100MHz slot (PCI-X B)''.

Hm, while looking at that manual I see that on page 13 it says ,,one pc=
i-x 100MHz device''.
Maybe that's the problem since I didn't remove Adaptec TARO controller.=
 I should be able to
get this tested again without adaptec sooner than several weeks. Maybe =
I misunderstand
what documentation says here.

Anyway still don't know why driver displays 133Mhz while manual says ab=
out
100MHz one pci-x slot.

> > /t is on tmpfs, /dev/sda2 in on FC array. Reading the same data sev=
eral
> > times and I get different md5sum results each time, see below.
> >
> > How I can track where corruption occurs?

I started dd'ing text file onto /dev/sda2, then back to tmpfs and diffi=
ng these. Corruption
is one byte, several not corrupted bytes and again one corrupted byte. =
Some regular pattern.

>
> Regards,
> Andrew Vasquez

Bootdata ok (command line is initrd=3D/initrd-test.gz init=3D/linuxrc r=
oot=3D/dev/ram0 ramdisk_size=3D54000 console=3Dtty0 console=3DttyS0,115=
200n81 panic=3D60 BOOT_IMAGE=3Dvmlinuz-test ip=3D192.168.0.127:192.168.=
0.1:192.168.0.1:255.255.255.0 )
Linux version 2.6.18-rc4-dirty (root@db01new) (gcc version 3.3.6 (PLD L=
inux)) #7 Wed Aug 16 22:43:23 CEST 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
 BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff99000 (ACPI data)
 BIOS-e820: 000000007ff99000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 0000000080000000 - 00000000bff80000 (usable)
 BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000e8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
DMI present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x0000000000=
0f7040
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x000000=
007ff95407
ACPI: FADT (v001 NVIDIA CK8S     0x06040000 PTL_ 0x000f4240) @ 0x000000=
007ff98d72
ACPI: SRAT (v001 AMD    HAMMER   0x06040000 AMD  0x00000001) @ 0x000000=
007ff98de6
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @ 0x000000=
007ff98ef6
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0x000000=
007ff98f46
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x000000=
007ff98fd8
ACPI: DSDT (v001 NVIDIA      CK8 0x06040000 MSFT 0x0100000e) @ 0x000000=
0000000000
On node 0 totalpages: 1545657
  DMA zone: 2161 pages, LIFO batch:0
  DMA32 zone: 767816 pages, LIFO batch:31
  Normal zone: 775680 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2 15:1 APIC version 16
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3 15:1 APIC version 16
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xdf200000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 17, address 0xdf200000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xdf201000] gsi_base[28])
IOAPIC[2]: apic_id 6, version 17, address 0xdf201000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
Built 1 zonelists.  Total pages: 1545657
Kernel command line: initrd=3D/initrd-test.gz init=3D/linuxrc root=3D/d=
ev/ram0 ramdisk_size=3D54000 console=3Dtty0 console=3DttyS0,115200n81 p=
anic=3D60 BOOT_IMAGE=3Dvmlinuz-test ip=3D192.168.0.127:192.168.0.1:192.=
168.0.1:255.255.255.0=20
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2009.273 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molna=
r
=2E.. MAX_LOCKDEP_SUBCLASSES:    8
=2E.. MAX_LOCK_DEPTH:          30
=2E.. MAX_LOCKDEP_KEYS:        2048
=2E.. CLASSHASH_SIZE:           1024
=2E.. MAX_LOCKDEP_ENTRIES:     8192
=2E.. MAX_LOCKDEP_CHAINS:      8192
=2E.. CHAINHASH_SIZE:          4096
 memory used by lock dependency info: 1120 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
CPU 0: aperture @ c0000000 size 256 MB
CPU 1: aperture @ c0000000 size 256 MB
Memory: 6168496k/7340032k available (2114k kernel code, 121284k reserve=
d, 1130k data, 192k init)
Calibrating delay using timer specific routine.. 4021.70 BogoMIPS (lpj=3D=
8043410)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: Dual Core AMD Opteron(tm) Processor 270 stepping 02
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12557973
Detected 12.557 MHz APIC timer.
testing NMI watchdog ... OK.
checking if image is initramfs...it isn't (no cpio magic); looks like a=
n initrd
=46reeing initrd memory: 780k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
Boot video device is 0000:01:07.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Root Bridge [PCI2] (0000:08)
PCI: Probing PCI hardware (bus 08)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c0000000 size 262144 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 256MB of IOMMU area in the AGP aperture
pnp: 00:08: ioport range 0x8000-0x807f could not be reserved
pnp: 00:08: ioport range 0x8080-0x80ff has been reserved
pnp: 00:08: ioport range 0x8400-0x847f has been reserved
pnp: 00:08: ioport range 0x8480-0x84ff has been reserved
pnp: 00:08: ioport range 0x8800-0x887f has been reserved
pnp: 00:08: ioport range 0x8880-0x88ff has been reserved
pnp: 00:08: ioport range 0x5000-0x503f has been reserved
pnp: 00:08: ioport range 0x5040-0x507f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: 2000-2fff
  MEM window: dd100000-deffffff
  PREFETCH window: c2000000-c20fffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:08:0a.0
  IO window: 3000-3fff
  MEM window: df300000-df3fffff
  PREFETCH window: c2100000-c21fffff
PCI: Bridge: 0000:08:0b.0
  IO window: disabled.
  MEM window: df400000-df4fffff
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 32768 (order: 9, 2359296 bytes)
TCP bind hash table entries: 16384 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 32768 bind 16384)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1155768349.728:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for subordinate bus.
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for subordinate bus.
PCI: Setting latency timer of device 0000:00:0e.0 to 64
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enable=
d
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:02: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:03: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 54000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI: (supports S0 S1 S4 S5)
IP-Config: No network devices available.
RAMDISK: Compressed image found at block 0
VFS: Mounted root (romfs filesystem) readonly.
=46reeing unused kernel memory: 192k freed
tg3.c:v3.64 (July 31, 2006)
GSI 16 sharing vector 0xC1 and IRQ 16
ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 28 (level, low) -> IRQ 193
eth0: Tigon3 [partno(BCM95704) rev 2003 PHY(5704)] (PCIX:133MHz:64-bit)=
 10/100/1000BaseT Ethernet 00:e0:81:33:5e:ae
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TS=
Ocap[0]=20
eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
GSI 17 sharing vector 0xC9 and IRQ 17
ACPI: PCI Interrupt 0000:0a:09.1[B] -> GSI 29 (level, low) -> IRQ 201
eth1: Tigon3 [partno(BCM95704) rev 2003 PHY(5704)] (PCIX:133MHz:64-bit)=
 10/100/1000BaseT Ethernet 00:e0:81:33:5e:af
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
PM: Writing back config space on device 0000:0a:09.0 at offset 3 (was 8=
04000, writing 804010)
PM: Writing back config space on device 0000:0a:09.0 at offset 2 (was 2=
000000, writing 2000003)
PM: Writing back config space on device 0000:0a:09.0 at offset 1 (was 2=
b00000, writing 2b00106)
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
eth0: no IPv6 routers present
SCSI subsystem initialized
QLogic Fibre Channel HBA Driver
GSI 18 sharing vector 0xD1 and IRQ 18
ACPI: PCI Interrupt 0000:09:08.0[A] -> GSI 24 (level, low) -> IRQ 209
qla2xxx 0000:09:08.0: Found an ISP2312, irq 209, iobase 0xffffc20000004=
000
qla2xxx 0000:09:08.0: Configuring PCI space...
qla2xxx 0000:09:08.0: Configure NVRAM parameters...
qla2xxx 0000:09:08.0: Verifying loaded RISC code...
scsi(0): **** Load RISC code ****
scsi(0): Verifying Checksum of loaded RISC code.
scsi(0): Checksum OK, start firmware.
qla2xxx 0000:09:08.0: Allocated (412 KB) for firmware dump...
scsi(0): Issue init firmware.
scsi(0): Asynchronous LIP RESET (f7f7).
qla2xxx 0000:09:08.0: LIP reset occured (f7f7).
qla2xxx 0000:09:08.0: Waiting for LIP to complete...
scsi(0): Asynchronous P2P MODE received.
scsi(0): Asynchronous LOOP UP (2 Gbps).
qla2xxx 0000:09:08.0: LOOP UP detected (2 Gbps).
scsi(0): Asynchronous PORT UPDATE.
scsi(0): Port database changed ffff 0006 0000.
scsi(0): F/W Ready - OK=20
scsi(0): fw_state=3D3 curr time=3Dffff0467.
qla2xxx 0000:09:08.0: Topology - (F_Port), Host Loop address 0xffff
scsi(0): Configure loop -- dpc flags =3D0x4080040
scsi(0): RSCN queue entry[0] =3D [00/000000].
scsi(0): device_resync: rscn overflow.
scsi(0): RFT_ID exiting normally.
scsi(0): RFF_ID exiting normally.
scsi(0): RNN_ID exiting normally.
scsi(0): RSNN_NN exiting normally.
scsi(0): Asynchronous PORT UPDATE ignored 0000/0006/bd92.
scsi(0): GID_PT entry - nn 500508b300917e50 pn 500508b300917e51 portid=3D=
010000.
scsi(0): GID_PT entry - nn 200000e08b8051d6 pn 210000e08b8051d6 portid=3D=
010100.
scsi(0): GID_PT entry - nn 200000e08b950428 pn 210000e08b950428 portid=3D=
010200.
scsi(0): device wrap (010200)
scsi(0): Trying Fabric Login w/loop id 0x0081 for port 010000.
scsi(0): Trying Fabric Login w/loop id 0x0082 for port 010100.
qla2x00_mailbox_command(0): **** FAILED. mbx0=3D4007, mbx1=3D0, mbx2=3D=
100, cmd=3D6f ****
qla2x00_login_fabric(0): failed=3D102 mb[0]=3D4007 mb[1]=3D0 mb[2]=3D10=
0.
=46abric Login: port in use - next loop id=3D0x0000, port Id=3D010100.
scsi(0): Trying Fabric Login w/loop id 0x0000 for port 010100.
scsi(0): LOOP READY
DEBUG: detect hba 0 at address =3D ffff8101bd9807e0
scsi0 : qla2xxx
qla2xxx 0000:09:08.0:=20
 QLogic Fibre Channel HBA Driver: 8.01.05-k3
  QLogic QLA2340 -=20
  ISP2312: PCI-X (133 MHz) @ 0000:09:08.0 hdma+, host#=3D0, fw=3D3.03.2=
0 IPX
  Vendor: COMPAQ    Model: MSA1000           Rev: 4.96
  Type:   RAID                               ANSI SCSI revision: 04
  Vendor: COMPAQ    Model: MSA1000 VOLUME    Rev: 4.96
  Type:   Direct-Access                      ANSI SCSI revision: 04
  Vendor: COMPAQ    Model: MSA1000 VOLUME    Rev: 4.96
  Type:   Direct-Access                      ANSI SCSI revision: 04
scsi(0): Asynchronous PORT UPDATE ignored 0001/0006/bd92.
scsi(0): Asynchronous PORT UPDATE ignored 0001/0007/bd92.
scsi(0): Asynchronous PORT UPDATE ignored 0001/0004/bd92.
SCSI device sda: 513790830 512-byte hdwr sectors (263061 MB)
sda: Write Protect is off
sda: Mode Sense: 83 00 00 08
SCSI device sda: drive cache: write back
SCSI device sda: 513790830 512-byte hdwr sectors (263061 MB)
sda: Write Protect is off
sda: Mode Sense: 83 00 00 08
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3
sd 0:0:0:2: Attached scsi disk sda
SCSI device sdb: 1381590 512-byte hdwr sectors (707 MB)
sdb: Write Protect is off
sdb: Mode Sense: 83 00 00 08
SCSI device sdb: drive cache: write back
SCSI device sdb: 1381590 512-byte hdwr sectors (707 MB)
sdb: Write Protect is off
sdb: Mode Sense: 83 00 00 08
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
 sdb: p2 exceeds device capacity
sd 0:0:0:4: Attached scsi disk sdb


00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (=
rev a3)
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=3D0 UnitCnt=3D15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0 =
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut- LWI=3D16bit=
 DwFcInEn- LWO=3D16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0 =
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut- LWI=3D8bit Dw=
=46cInEn- LWO=3D8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 800MHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ =
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- =
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- =
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] HyperTransport: MSI Mapping

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: I/O ports at <ignored>

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 0
	Region 0: I/O ports at 1000 [size=3D32]
	Region 4: I/O ports at 5000 [size=3D64]
	Region 5: I/O ports at 5040 [size=3D64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2=
) (prog-if 10 [OHCI])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at dd000000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3=
) (prog-if 20 [EHCI])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at dd001000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8=
a [Master SecP PriP])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 4: I/O ports at 1400 [size=3D16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (=
rev f3) (prog-if 85 [Master SecO PriO])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1440 [size=3D8]
	Region 1: I/O ports at 1434 [size=3D4]
	Region 2: I/O ports at 1438 [size=3D8]
	Region 3: I/O ports at 1430 [size=3D4]
	Region 4: I/O ports at 1410 [size=3D16]
	Region 5: Memory at dd002000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (=
rev f3) (prog-if 85 [Master SecO PriO])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at 1458 [size=3D8]
	Region 1: I/O ports at 144c [size=3D4]
	Region 2: I/O ports at 1450 [size=3D8]
	Region 3: I/O ports at 1448 [size=3D4]
	Region 4: I/O ports at 1420 [size=3D16]
	Region 5: Memory at dd003000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-=
if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: dd100000-deffffff
	Prefetchable memory behind bridge: c2000000-c20fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog=
-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size 10
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=3D0/1 En=
able+
		Address: 00000000fee00000  Data: 40b9
	Capabilities: [58] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 0
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Revision ID: 1.02
	Capabilities: [a0] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3DN/C LWO=3DN/C
		Revision ID: 1.02
	Capabilities: [c0] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0
		Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3DN/C LWO=3DN/C
		Revision ID: 1.02

00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=
 Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-

01:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27=
) (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc Rage XL
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 66 (2000ns min), Cache Line Size 10
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: I/O ports at 2000 [size=3D256]
	Region 2: Memory at dd100000 (32-bit, non-prefetchable) [size=3D4K]
	[virtual] Expansion ROM at c2000000 [disabled] [size=3D128K]
	Capabilities: [5c] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

08:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge =
(rev 12) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D08, secondary=3D09, subordinate=3D09, sec-latency=3D72
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: df300000-df3fffff
	Prefetchable memory behind bridge: 00000000c2100000-00000000c2100000
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [a0] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=3D133MHz
		Status: Dev=3D08:0a.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
		Upstream: Capacity=3D14 CommitmentLimit=3D65535
		Downstream: Capacity=3D2 CommitmentLimit=3D65535
	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configurati=
on
	Capabilities: [c0] HyperTransport: Slave or Primary Interface
		!!! Possibly incomplete decoding
		Command: BaseUnitID=3D10 UnitCnt=3D2 MastHost- DefDir-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=3D0
		Link Config 0: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D16bit
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=3D0
		Link Config 1: MLWI=3D8bit MLWO=3D8bit LWI=3DN/C LWO=3DN/C
		Revision ID: 1.02

08:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01=
) (prog-if 10 [IO-APIC])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at df200000 (64-bit, non-prefetchable) [size=3D4K]

08:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge =
(rev 12) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D08, secondary=3D0a, subordinate=3D0a, sec-latency=3D64
	Memory behind bridge: df400000-df4fffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [a0] PCI-X bridge device
		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=3D133MHz
		Status: Dev=3D08:0b.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
		Upstream: Capacity=3D14 CommitmentLimit=3D65535
		Downstream: Capacity=3D2 CommitmentLimit=3D65535
	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configurati=
on

08:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01=
) (prog-if 10 [IO-APIC])
	Subsystem: Tyan Computer Unknown device 2891
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at df201000 (64-bit, non-prefetchable) [size=3D4K]

09:08.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev =
02)
	Subsystem: Compaq Computer Corporation Unknown device 0100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 128 (16000ns min), Cache Line Size 10
	Interrupt: pin A routed to IRQ 209
	Region 0: I/O ports at 3000 [size=3D256]
	Region 1: Memory at df300000 (64-bit, non-prefetchable) [size=3D4K]
	[virtual] Expansion ROM at c2180000 [disabled] [size=3D128K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [4c] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=3D1024 OST=3D2
		Status: Dev=3D09:08.0 64bit+ 133MHz+ SCD- USC- DC=3Dsimple DMMRBC=3D4=
096 DMOST=3D3 DMCRS=3D32 RSCEM- 266MHz- 533MHz-
	Capabilities: [54] Message Signalled Interrupts: 64bit+ Queue=3D0/3 En=
able-
		Address: 0000000000000000  Data: 0000
	Capabilities: [64] #06 [0080]

09:0a.0 SCSI storage controller: Adaptec AIC-7901 U320 (rev 10)
	Subsystem: Adaptec Unknown device 005f
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR-
	Latency: 72 (10000ns min, 6250ns max), Cache Line Size 10
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 3800 [size=3D256]
	Region 1: Memory at df302000 (64-bit, non-prefetchable) [size=3D8K]
	Region 3: I/O ports at 3400 [size=3D256]
	[virtual] Expansion ROM at c2100000 [disabled] [size=3D512K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D=
3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=3D0/1 En=
able-
		Address: 0000000000000000  Data: 0000
	Capabilities: [94] PCI-X non-bridge device
		Command: DPERE- ERO+ RBC=3D512 OST=3D3
		Status: Dev=3D09:0a.0 64bit+ 133MHz+ SCD- USC- DC=3Dsimple DMMRBC=3D5=
12 DMOST=3D8 DMCRS=3D16 RSCEM- 266MHz- 533MHz-

0a:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gig=
abit Ethernet (rev 03)
	Subsystem: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size 10
	Interrupt: pin A routed to IRQ 193
	Region 0: Memory at df410000 (64-bit, non-prefetchable) [size=3D64K]
	Region 2: Memory at df400000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D2048 OST=3D1
		Status: Dev=3D0a:09.0 64bit+ 133MHz+ SCD- USC- DC=3Dsimple DMMRBC=3D2=
048 DMOST=3D1 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 PME-Enable+ DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/3 En=
able-
		Address: 0000000100000000  Data: 00a0

0a:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gig=
abit Ethernet (rev 03)
	Subsystem: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ St=
epping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TA=
bort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size 10
	Interrupt: pin B routed to IRQ 201
	Region 0: Memory at df430000 (64-bit, non-prefetchable) [size=3D64K]
	Region 2: Memory at df420000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D2048 OST=3D1
		Status: Dev=3D0a:09.1 64bit+ 133MHz+ SCD- USC- DC=3Dsimple DMMRBC=3D2=
048 DMOST=3D1 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/3 En=
able-
		Address: 0000000100000000  Data: 0000



--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
