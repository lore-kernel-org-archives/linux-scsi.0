From: Michael Reed <mdr@sgi.com>
Subject: 2.6.16-rc2 OOPS in scsi_device_get() via scsi_error_handler() during
 boot
Date: Tue, 07 Feb 2006 12:00:00 -0600
Message-ID: <43E8E020.6070700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:21181 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932110AbWBGSAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 13:00:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, Christoph Hellwig <hch@lst.de>, Michael Reed <mdr@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

I took an oops during startup of a 4P ia64 system with numerous
qlogic 234x ports.  There were some devices taken offline during
boot.

I haven't seen this one before.

Linux version 2.6.16-rc2 (root@duck) (gcc version 4.1.0 20060123 (prerelease) (SUSE Linux)) #4 SMP PREEMPT Tue Feb 7 10:58:17 CST 2006
EFI v1.10 by INTEL: SALsystab=0x3002815070 ACPI 2.0=0x3002815840
Number of logical nodes in system = 2
Number of memory chunks in system = 2
Initial ramdisk at: 0xe00000b07a0a7000 (3360821 bytes)
SAL 2.9: SGI SN2 version 4.41
SAL Platform features: ITC_Drift
SAL: AP wakeup using external interrupt vector 0x12
No logical to physical processor mapping available
ACPI: Local APIC address c0000000fee00000
ACPI: Error parsing MADT - no IOSAPIC entries
register_intr: No IOSAPIC for GSI 52
4 CPUs available, 4 CPUs total
Increasing MCA rendezvous timeout from 20000 to 49000 milliseconds
MCA related initialization done
SGI SAL version 4.41
Virtual mem_map starts at 0xa0007fff65938000
Built 2 zonelists
Kernel command line: BOOT_IMAGE=scsi0:\efi\SuSE\vmlinuz root=/dev/sda3 selinux=0   kdb=on console=ttySG0 splash=silent thash_entries=2097152 ro
PID hash table entries: 4096 (order: 12, 131072 bytes)
Console: colour dummy device 80x25
Memory: 9857552k/10024192k available (7165k code, 183600k reserved, 4176k data, 352k init)
McKinley Errata 9 workaround not needed; disabling it
kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
kdb_cmd[0]: defcmd archkdb "" "First line arch debugging"
kdb_cmd[7]: defcmd archkdbcpu "" "archkdb with only tasks on cpus"
kdb_cmd[14]: defcmd archkdbshort "" "archkdb with less detailed backtrace"
kdb_cmd[21]: defcmd archkdbcommon "" "Common arch debugging"
kdb_cmd[31]: set LINES 2000
Dentry cache hash table entries: 2097152 (order: 10, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 9, 8388608 bytes)
Mount-cache hash table entries: 1024
Boot processor id 0x0/0x0
Brought up 4 CPUs
Total of 4 processors activated (5980.16 BogoMIPS).
migration_cost=3991,17957
checking if image is initramfs... it is
Freeing initrd memory: 3264kB freed
NET: Registered protocol family 16
ACPI: bus type pci registered

                Altix IO Topology Information
                *****************************


Serial Number:R2001376

PCI SEGMENT PCIBUS NUMBER     BRICK  RACK:SLOT  BUS       CONNECTION TOPOLOGY
----------- -------------     ---------------------       -------------------
  0x0001        0x00         OPbrick  001:27    01      001c27:slot0:slab0:widget15:bus0
  0x0002        0x00         OPbrick  001:27    02      001c27:slot0:slab0:widget15:bus1
  0x0002        0x01         PPB Device on PCI Bus Number 0x00 Device Number 2
  0x0011        0x00         OPbrick  001:29    01      001c29:slot0:slab0:widget15:bus0
  0x0012        0x00         OPbrick  001:29    02      001c29:slot0:slab0:widget15:bus1

PROM version < 4.50 -- implementing old PROM flush WAR
ACPI: Subsystem revision 20060127
ACPI: SCI (ACPI GSI 52) not registered
ACPI: Interpreter enabled
ACPI: Using IOSAPIC for interrupt routing
SCSI subsystem initialized
perfmon: version 2.0 IRQ 238
perfmon: Itanium 2 PMU detected, 16 PMCs, 18 PMDs, 4 counters (47 bits)
PAL Information Facility v0.5
perfmon: added sampling format default_format
perfmon_default_smpl: default_format v2.0 registered
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 2048 (order 0, 16384 bytes)
SGI XFS with ACLs, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
SGI Altix RTC Timer: v2.1, 20 MHz
EFI Time Services Driver v0.4
Linux agpgart interface v0.101 (c) Dave Jones
sn_console: Console driver init
ttySG0 at I/O 0x0 (irq = 0) is a SGI SN L1
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
tg3.c:v3.48 (Jan 16, 2006)
ACPI: PCI Interrupt 0001:00:02.0[A]: no GSI
eth0: Tigon3 [partno(9210289) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 08:00:69:14:9d:d7
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0]
eth0: dma_rwctrl[76ff3f0f]
ACPI: PCI Interrupt 0001:00:04.0[A]: no GSI
eth1: Tigon3 [partno(030-1771-000) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 08:00:69:13:ff:14
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0]
eth1: dma_rwctrl[76ff3f0f]
ACPI: PCI Interrupt 0011:00:02.0[A]: no GSI
eth2: Tigon3 [partno(9210289) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 08:00:69:14:c0:78
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0]
eth2: dma_rwctrl[76ff3f0f]
ACPI: PCI Interrupt 0011:00:04.0[A]: no GSI
eth3: Tigon3 [partno(030-1771-000) rev 0105 PHY(5701)] (PCI:66MHz:64-bit) 10/100/1000BaseT Ethernet 08:00:69:13:fe:c7
eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[0]
eth3: dma_rwctrl[76ff3f0f]
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
qla1280: QLA12160 found on PCI bus 0, dev 3
ACPI: PCI Interrupt 0001:00:03.0[A]: no GSI
scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(0): Enabling SN2 PCI DMA workaround
scsi(0:0): Resetting SCSI BUS
scsi(0:1): Resetting SCSI BUS
scsi0 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.42, Driver version 3.26
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:1:0): Sync: period 9, offset 14, Wide, DT
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(0:0:2:0): Sync: period 9, offset 14, Wide, DT
qla1280: QLA12160 found on PCI bus 0, dev 3
ACPI: PCI Interrupt 0011:00:03.0[A]: no GSI
scsi(1): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(1): Enabling SN2 PCI DMA workaround
scsi(1:0): Resetting SCSI BUS
scsi(1:1): Resetting SCSI BUS
scsi1 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.42, Driver version 3.26
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(1:0:1:0): Sync: period 9, offset 14, Wide, DT
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(1:0:2:0): Sync: period 9, offset 14, Wide, DT
QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0002:01:04.0[A]: no GSI
qla2300 0002:01:04.0: Found an ISP2312, irq 74, iobase 0xc00000080fd00000
qla2300 0002:01:04.0: Configuring PCI space...
PCI: slot 0002:01:04.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.0: Configure NVRAM parameters...
qla2300 0002:01:04.0: Verifying loaded RISC code...
qla2300 0002:01:04.0: LIP reset occured (f7f7).
qla2300 0002:01:04.0: Waiting for LIP to complete...
qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
scsi2 : qla2xxx
qla2300 0002:01:04.0:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.0 hdma+, host#=2, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0002:01:04.1[B]: no GSI
qla2300 0002:01:04.1: Found an ISP2312, irq 75, iobase 0xc00000080fd20000
qla2300 0002:01:04.1: Configuring PCI space...
PCI: slot 0002:01:04.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.1: Configure NVRAM parameters...
Universal Xport   Rev: 0614
  Type:   Direct-Access     <6>qla2300 0002:01:04.1: Verifying loaded RISC code...
                 ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport<6>qla2300 0002:01:04.1: LIP reset occured (f800).
qla2300 0002:01:04.1: Waiting for LIP to complete...
   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0002:01:04.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.1: Topology - (F_Port), Host Loop address 0xffff
scsi3 : qla2xxx
qla2300 0002:01:04.1:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.1 hdma+, host#=3, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0002:01:06.0[A]: no GSI
qla2300 0002:01:06.0: Found an ISP2312, irq 74, iobase 0xc00000080fd40000
qla2300 0002:01:06.0: Configuring PCI space...
PCI: slot 0002:01:06.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.0: Configure NVRAM parameters...
Universal Xport   Rev: 0614
qla2300 0002:01:06.0: Verifying loaded RISC code...
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SG<6>qla2300 0002:01:06.0: LIP reset occured (f800).
qla2300 0002:01:06.0: Waiting for LIP to complete...
I       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0002:01:06.0: LOOP UP detected (2 Gbps).

  Vendor: SGI       Model: <6>qla2300 0002:01:06.0: Topology - (F_Port), Host Loop address 0xffff
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0002:01:04.0: scsi(2:9:0): Abort command issued -- 1c 2002.
scsi4 : qla2xxx
qla2300 0002:01:06.0:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.0 hdma+, host#=4, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0002:01:06.1[B]: no GSI
qla2300 0002:01:06.1: Found an ISP2312, irq 75, iobase 0xc00000080fd60000
qla2300 0002:01:06.1: Configuring PCI space...
PCI: slot 0002:01:06.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.1: Configure NVRAM parameters...
Universal Xport   Rev: 0614
qla2300 0002:01:06.1: Verifying loaded RISC code...
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: <6>qla2300 0002:01:06.1: LIP reset occured (f7f7).
qla2300 0002:01:06.1: Waiting for LIP to complete...
0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0002:01:06.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.1: Topology - (F_Port), Host Loop address 0xffff
qla2300 0002:01:04.1: scsi(3:9:0): Abort command issued -- 1c 2002.
scsi5 : qla2xxx
qla2300 0002:01:06.1:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.1 hdma+, host#=5, fw=3.03.18 IPX
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
ACPI: PCI Interrupt 0012:00:01.0[A]: no GSI<5>  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03

qla2300 0012:00:01.0: Found an ISP2312, irq 60, iobase 0xc00000880fe00000
qla2300 0012:00:01.0: Configuring PCI space...
qla2300 0012:00:01.0: Configure NVRAM parameters...
qla2300 0012:00:01.0: Verifying loaded RISC code...
qla2300 0012:00:01.0: Waiting for LIP to complete...
qla2300 0012:00:01.0: LIP reset occured (f800).
qla2300 0012:00:01.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0002:01:06.0: scsi(4:9:0): Abort command issued -- 1c 2002.
qla2300 0002:01:04.0: scsi(2:9:0): Abort command issued -- 1c 2002.
 2:0:9:0: scsi: Device offlined - not ready after error recovery
scsi6 : qla2xxx
qla2300 0012:00:01.0:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.0 hdma+, host#=6, fw=3.03.18 IPX
ACPI: PCI Interrupt 0012:00:01.1[B]: no GSI
qla2300 0012:00:01.1: Found an ISP2312, irq 61, iobase 0xc00000880fe01000
qla2300 0012:00:01.1: Configuring PCI space...
qla2300 0012:00:01.1: Configure NVRAM parameters...
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI<6>qla2300 0012:00:01.1: Verifying loaded RISC code...
       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI<6>qla2300 0012:00:01.1: Waiting for LIP to complete...
qla2300 0002:01:06.1: scsi(5:9:0): Abort command issued -- 1c 2002.
       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0012:00:01.1: LIP reset occured (f7f7).
qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).

qla2300 0012:00:01.1: Topology - (F_Port), Host Loop address 0xffff
qla2300 0002:01:04.1: scsi(3:9:0): Abort command issued -- 1c 2002.
 3:0:9:0: scsi: Device offlined - not ready after error recovery
qla2300 0002:01:04.0: scsi(2:10:0): Abort command issued -- 1d 2002.
scsi7 : qla2xxx
qla2300 0012:00:01.1:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.1 hdma+, host#=7, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0012:00:02.0[A]: no GSI
qla2300 0012:00:02.0: Found an ISP2312, irq 62, iobase 0xc00000880fe02000
qla2300 0012:00:02.0: Configuring PCI space...
qla2300 0012:00:02.0: Configure NVRAM parameters...
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <6>qla2300 0012:00:02.0: Verifying loaded RISC code...
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0012:00:02.0: Waiting for LIP to complete...

  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0002:01:06.0: scsi(4:9:0): Abort command issued -- 1c 2002.
 4:0:9:0: scsi: Device offlined - not ready after error recovery
qla2300 0012:00:01.0: scsi(6:9:0): Abort command issued -- 1c 2002.
qla2300 0012:00:02.0: LIP reset occured (f7f7).
qla2300 0012:00:02.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:02.0: Topology - (F_Port), Host Loop address 0xffff
qla2300 0002:01:04.1: scsi(3:10:0): Abort command issued -- 1d 2002.
  Vendor: SGI     <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Model: ST336753FC      <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi8 : qla2xxx
qla2300 0012:00:02.0:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:02.0 hdma+, host#=8, fw=3.03.18 IPX
  Vendor: SGI       Model: U<4>ACPI: PCI Interrupt 0012:00:02.1[B]: no GSI
niv<6>qla2300 0012:00:02.1: Found an ISP2312, irq 63, iobase 0xc00000880fe03000
qla2300 0012:00:02.1: Configuring PCI space...
qla2300 0012:00:02.1: Configure NVRAM parameters...
ersal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <6>qla2300 0012:00:02.1: Verifying loaded RISC code...
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xpo<6>qla2300 0012:00:02.1: Waiting for LIP to complete...
rt   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0002:01:06.0: scsi(4:10:0): Abort command issued -- 1d 2002.

  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0012:00:02.1: LIP reset occured (f7f7).
qla2300 0012:00:02.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: scsi(2:10:0): Abort command issued -- 1d 2002.
 2:0:10:0: scsi: Device offlined - not ready after error recovery
qla2300 0012:00:02.1: Topology - (F_Port), Host Loop address 0xffff
qla2300 0012:00:01.0: scsi(6:10:0): Abort command issued -- 20 2002.
  Vendor: SGI     <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701  3 out of 4 cpus in kdb, waiting for the rest, timeout in 59 second(s)

  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0002:01:06.1: scsi(5:10:0): Abort command issued -- 20 2003.
 5:0:10:0: scsi: Device offlined - not ready after error recovery
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi9 : qla2xxx
qla2300 0012:00:02.1:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:02.1 hdma+, host#=9, fw=3.03.18 IPX
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 143374744 512-byte hdwr sectors (73408 MB)
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: drive cache: write through w/ FUA
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
.All cpus are now in kdb

Entering kdb (current=0xe0000034f6000000, pid 1123) on processor 1 Oops: <NULL>
due to oops @ 0xa00000010053cbb0
 psr: 0x0000101008022018   ifs: 0x8000000000000286    ip: 0xa00000010053cbb0
unat: 0x0000000000000000   pfs: 0x000000000000040a   rsc: 0x0000000000000003
rnat: 0xe0000034f6001398  bsps: 0x0000000000009641    pr: 0x0000000000005541
ldrs: 0x0000000000000000   ccv: 0x0000000000000000  fpsr: 0x0009804c8a70433f
  b0: 0xa00000010053cf50    b6: 0xa0000001003d9b00    b7: 0xa00000010000c2d0
  r1: 0xa000000100cfb9b0    r2: 0x0000000000100100    r3: 0x00000000001005e8
  r8: 0x0000001008026018    r9: 0xe0000034f6001020   r10: 0x0000000000004000
 r11: 0x0000000000000000   r12: 0xe0000034f6007d10   r13: 0xe0000034f6000000
 r14: 0x0000000000000000   r15: 0x0000000000000001   r16: 0xe0000034f6001020
 r17: 0xe00000b003bcc054   r18: 0xffffffffffffff7f   r19: 0xe00000b003bcc128
 r20: 0xe0000034f6007e30   r21: 0xa000000100009120   r22: 0xe0000034f6001070
 r23: 0x0000000000000000   r24: 0x0000000000000000   r25: 0x000000000000000f
 r26: 0x0000000000000001   r27: 0xe00000b003bcc040   r28: 0xa000000100b79ee0
 r29: 0x0000000000000000   r30: 0xa000000100b79ee0   r31: 0xe00000b003bcc058
&regs = e0000034f6007b50
[1]kdb> btp 1123
Stack traceback for pid 1123
0xe0000034f6000000     1123       19  1    1   R  0xe0000034f6000380 *scsi_eh_7
0xa00000010053cbb0 scsi_device_get+0x10
        args (0x1000f0, 0x1, 0xa00000010053cf50, 0x40a, 0xe00000b0781cf340)
0xa00000010053cf50 __scsi_iterate_devices+0x50
        args (0xe00000b003bcc000, 0xe0000034f665c800, 0xe0000034f665c810, 0x1000f0, 0x1008026018)
0xa0000001005497f0 scsi_run_host_queues+0x50
        args (0xe00000b003bcc000, 0xe0000034f665c800, 0xa000000100546b10, 0x614, 0x1008026018)
0xa000000100546b10 scsi_error_handler+0x13b0
        args (0xe00000b003bcc000, 0x1008026018, 0xe0000034f6007d50, 0x0, 0xe0000034f6007d40)
0xa0000001000d3700 kthread+0x220
        args (0xe0000034f7ab7a00, 0xe0000034f6007dc0, 0xe0000034f6000000, 0xe00000b003bcc000, 0xa000000100815b90)
0xa000000100011070 kernel_thread_helper+0xd0
        args (0xa00000010081f5e0, 0xe0000034f7ab7a00, 0xa000000100009120, 0x2, 0xa000000100cfb9b0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010081f5e0, 0xe0000034f7ab7a00)
[1]kdb>

[1]kdb> btp 1158
Stack traceback for pid 1158
0xe0000034f6580000     1158       19  1    3   R  0xe0000034f6580380  scsi_wq_7
0xa0000001006fe220 _spin_lock_irqsave+0x100
        args (0xe00000b003bcc050, 0x1, 0xa00000010054e430, 0x713, 0xb)
0xa00000010054e430 scsi_alloc_target+0x250
        args (0xe00000b0782c38d0, 0x0, 0xb, 0xe00000b0782c38d0, 0xe00000b003bcc000)
0xa00000010054e970 __scsi_scan_target+0xb0
        args (0xe00000b0782c38d0, 0x0, 0xb, 0xffffffffffffffff, 0x1)
0xa00000010054f9f0 scsi_scan_target+0xd0
        args (0xe00000b0782c38d0, 0x0, 0xb, 0xffffffffffffffff, 0x1)
0xa00000010055c6b0 fc_scsi_scan_rport+0x50
        args (0xe00000b0782c38ac, 0xe00000b0782c38d0, 0xa0000001000ca840, 0x40c, 0x1008022018)
0xa0000001000ca840 run_workqueue+0x1c0
        args (0xe0000034f67f5480, 0xe00000b0782c3b60, 0xe00000b0782c3b58, 0xe00000b0782c3880, 0xa000000100820c10)
0xa0000001000cb930 worker_thread+0x1d0
        args (0xe0000034f67f5480, 0xe0000034f67f5498, 0xe0000034f67f54a8, 0xa0000001000d3700, 0x491)
0xa0000001000d3700 kthread+0x220
        args (0xe0000034f7ab7a00, 0xe0000034f6587dc0, 0xe0000034f6580000, 0xe0000034f67f5480, 0xa00000010081d820)
0xa000000100011070 kernel_thread_helper+0xd0
        args (0xa00000010081f5e0, 0xe0000034f7ab7a00, 0xa000000100009120, 0x2, 0xa000000100cfb9b0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010081f5e0, 0xe0000034f7ab7a00)
