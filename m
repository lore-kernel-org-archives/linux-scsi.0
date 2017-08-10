From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Thu, 10 Aug 2017 20:32:00 +1000
Message-ID: <8760dvn273.fsf@concordia.ellerman.id.au>
References: <20170803214014.20332-1-bart.vanassche@wdc.com>
 <yq14ltj9sjd.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <yq14ltj9sjd.fsf@oracle.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linuxppc-dev@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, Brian J King <bjking1@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:
>> One of the two scsi-mq functions that requeue a request unprepares a
>> request before requeueing (scsi_io_completion()) but the other
>> function not (__scsi_queue_insert()). Make sure that a request is
>> unprepared before requeuing it.
>
> Applied to 4.13/scsi-fixes. Thanks much!

This seems to be preventing my Power8 box, which uses IPR, from booting.

Bisect said so:

# first bad commit: [270065e92c317845d69095ec8e3d18616b5b39d5] scsi: scsi-mq: Always unprepare before requeuing a request

And if I revert that on top of next-20170809 my system boots again.

The symptom is that it just gets "stuck" during boot and never gets to
mounting root, full log below, the end is:

  .
  ready
  ready
  sd 0:2:4:0: [sde] 554287104 512-byte logical blocks: (284 GB/264 GiB)
  sd 0:2:4:0: [sde] 4096-byte physical blocks
  sd 0:2:5:0: [sdf] 272646144 512-byte logical blocks: (140 GB/130 GiB)
  sd 0:2:5:0: [sdf] 4096-byte physical blocks
  sd 0:2:4:0: [sde] Write Protect is off
  sd 0:2:4:0: [sde] Mode Sense: 0b 00 00 08
  sd 0:2:5:0: [sdf] Write Protect is off
  sd 0:2:5:0: [sdf] Mode Sense: 0b 00 00 08


And it just sits there for at least hours.

I compared a good and bad boot log and there appears to be essentially
no difference. Certainly nothing that looks suspicous.

Any ideas?

cheers



[   29.492780] kexec_core: Starting new kernel
Allocated 2621440 bytes for 2048 pacas at c00000000fd80000
Page sizes from device-tree:
base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
Huge page(16GB) memory: addr = 0x800000000 size = 0x400000000 pages = 1
Huge page(16GB) memory: addr = 0xC00000000 size = 0x400000000 pages = 1
Page orders: linear mapping = 24, virtual = 16, io = 16, vmemmap = 24
Using 1TB segments
Initializing hash mmu with SLB
Linux version 4.12.0-gcc-6.3.1-10811-g270065e92c31 (michael@ka3.ozlabs.ibm.com) (gcc version 6.3.1 20170214 (Custom e9096cb27f4bd642)) #384 SMP Thu Aug 10 19:43:35 AEST 2017
Using pSeries machine description
bootconsole [udbg0] enabled
Partition configured for 96 cpus.
CPU maps initialized for 8 threads per core
 (thread shift is 3)
Freed 2490368 bytes for unused pacas
 -> smp_release_cpus()
spinning_secondaries = 0
 <- smp_release_cpus()
-----------------------------------------------------
ppc64_pft_size    = 0x1c
phys_mem_size     = 0x1000000000
dcache_bsize      = 0x80
icache_bsize      = 0x80
cpu_features      = 0x07fc7aec18500249
  possible        = 0x5fffffff18500649
  always          = 0x0000000018100040
cpu_user_features = 0xdc0065c2 0xef000000
mmu_features      = 0x7c006001
firmware_features = 0x00000001c45ffc5f
htab_hash_mask    = 0x1fffff
-----------------------------------------------------
numa:   NODE_DATA [mem 0x3ffff6300-0x3ffffffff]
numa:   NODE_DATA [mem 0x7ffcc2300-0x7ffccbfff]
numa:   NODE_DATA [mem 0x7ffcb8600-0x7ffcc22ff]
numa:     NODE_DATA(2) on node 1
numa:   NODE_DATA [mem 0x7ffcae900-0x7ffcb85ff]
numa:     NODE_DATA(3) on node 1
node 2 must be removed before remove section 2045
PCI host bridge /pci@800000020000015  ranges:
 MEM 0x00003fc0c0000000..0x00003fc0cfffffff -> 0x00000000c0000000 
 MEM 0x0000301800000000..0x0000301bffffffff -> 0x0003d01800000000 
PCI host bridge /pci@80000002000001b  ranges:
 MEM 0x00003fc2f0000000..0x00003fc2f7ffffff -> 0x00000000f0000000 
PCI host bridge /pci@80000002000001e  ranges:
 MEM 0x00003fc2c0000000..0x00003fc2dfffffff -> 0x00000000c0000000 
 MEM 0x0000305800000000..0x0000305bffffffff -> 0x0003d05800000000 
PPC64 nvram contains 15360 bytes
Top of RAM: 0x1000000000, Total RAM: 0x1000000000
Memory hole size: 0MB
Zone ranges:
  DMA      [mem 0x0000000000000000-0x0000000fffffffff]
  DMA32    empty
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000000000000-0x00000003ffffffff]
  node   1: [mem 0x0000000400000000-0x00000007ffffffff]
  node   2: [mem 0x0000000800000000-0x0000000bffffffff]
  node   3: [mem 0x0000000c00000000-0x0000000fffffffff]
Initmem setup node 0 [mem 0x0000000000000000-0x00000003ffffffff]
On node 0 totalpages: 262144
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 262144 pages, LIFO batch:1
Initmem setup node 1 [mem 0x0000000400000000-0x00000007ffffffff]
On node 1 totalpages: 262144
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 262144 pages, LIFO batch:1
Initmem setup node 2 [mem 0x0000000800000000-0x0000000bffffffff]
On node 2 totalpages: 262144
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 262144 pages, LIFO batch:1
Initmem setup node 3 [mem 0x0000000c00000000-0x0000000fffffffff]
On node 3 totalpages: 262144
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 262144 pages, LIFO batch:1
percpu: Embedded 3 pages/cpu @c0000003ff100000 s158360 r0 d38248 u262144
pcpu-alloc: s158360 r0 d38248 u262144 alloc=1*1048576
pcpu-alloc: [0] 00 01 02 03 [0] 04 05 06 07 
pcpu-alloc: [0] 08 09 10 11 [0] 12 13 14 15 
pcpu-alloc: [0] 16 17 18 19 [0] 20 21 22 23 
pcpu-alloc: [0] 24 25 26 27 [0] 28 29 30 31 
pcpu-alloc: [0] 32 33 34 35 [0] 36 37 38 39 
pcpu-alloc: [0] 80 81 82 83 [0] 84 85 86 87 
pcpu-alloc: [0] 88 89 90 91 [0] 92 93 94 95 
pcpu-alloc: [1] 40 41 42 43 [1] 44 45 46 47 
pcpu-alloc: [1] 48 49 50 51 [1] 52 53 54 55 
pcpu-alloc: [1] 56 57 58 59 [1] 60 61 62 63 
pcpu-alloc: [1] 64 65 66 67 [1] 68 69 70 71 
pcpu-alloc: [1] 72 73 74 75 [1] 76 77 78 79 
Built 4 zonelists in Node order, mobility grouping on.  Total pages: 1047552
Policy zone: DMA
Kernel command line: loglevel=8 nosplash root=PARTUUID=d1b3a402-8900-4e17-aa90-c199d8d8f370
log_buf_len individual max cpu contribution: 8192 bytes
log_buf_len total cpu_extra contributions: 778240 bytes
log_buf_len min size: 262144 bytes
log_buf_len: 1048576 bytes
early log buf free: 255724(97%)
PID hash table entries: 4096 (order: -1, 32768 bytes)
Memory: 33423936K/67108864K available (9984K kernel code, 1536K rwdata, 2624K rodata, 832K init, 1425K bss, 33684928K reserved, 0K cma-reserved)
SLUB: Unable to allocate memory from node 2
SLUB: Allocating a useless per node structure in order to be able to continue
SLUB: Unable to allocate memory from node 3
SLUB: Allocating a useless per node structure in order to be able to continue
SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=96, Nodes=4
Hierarchical RCU implementation.
	RCU event tracing is enabled.
	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=96.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=96
NR_IRQS: 512, nr_irqs: 512, preallocated irqs: 16
pic: no ISA interrupt controller
time_init: decrementer frequency = 512.000000 MHz
time_init: processor frequency   = 3425.000000 MHz
clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
clocksource: timebase mult[1f40000] shift[24] registered
clockevent: decrementer mult[83126e98] shift[32] cpu[0]
Console: colour dummy device 80x25
console [hvc0] enabled
console [hvc0] enabled
bootconsole [udbg0] disabled
bootconsole [udbg0] disabled
mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
pid_max: default: 98304 minimum: 768
Dentry cache hash table entries: 8388608 (order: 10, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 9, 33554432 bytes)
Mount-cache hash table entries: 131072 (order: 4, 1048576 bytes)
Mountpoint-cache hash table entries: 131072 (order: 4, 1048576 bytes)
EEH: pSeries platform initialized
POWER8 performance monitor hardware support registered
Hierarchical SRCU implementation.
smp: Bringing up secondary CPUs ...
smp: Brought up 4 nodes, 80 CPUs
numa: Node 0 CPUs: 0-39
numa: Node 1 CPUs: 40-79
numa: Node 2 CPUs:
numa: Node 3 CPUs:
devtmpfs: initialized
kworker/u193:0 (413) used greatest stack depth: 12320 bytes left
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 32768 (order: 6, 4194304 bytes)
NET: Registered protocol family 16
EEH: PCI Enhanced I/O Error Handling Enabled
cpuidle: using governor menu
RTAS daemon started
pstore: using zlib compression
pstore: Registered nvram as persistent store backend
PCI: Probing PCI hardware
PCI host bridge to bus 0015:70
pci_bus 0015:70: root bus resource [mem 0x3fc0c0000000-0x3fc0cfffffff] (bus address [0xc0000000-0xcfffffff])
pci_bus 0015:70: root bus resource [mem 0x301800000000-0x301bffffffff] (bus address [0x3d01800000000-0x3d01bffffffff])
pci_bus 0015:70: root bus resource [bus 70-ff]
pci 0015:70:00.0: PME# supported from D0 D3hot D3cold
IOMMU table initialized, virtual merging enabled
iommu: Adding device 0015:70:00.0 to group 0
PCI host bridge to bus 001b:50
pci_bus 001b:50: root bus resource [mem 0x3fc2f0000000-0x3fc2f7ffffff] (bus address [0xf0000000-0xf7ffffff])
pci_bus 001b:50: root bus resource [bus 50-ff]
pci 001b:50:00.0: supports D1 D2
pci 001b:50:00.0: PME# supported from D0 D1 D2 D3hot
iommu: Adding device 001b:50:00.0 to group 1
pci 001b:50:00.0: of_irq_parse_pci: no interrupt-map found, INTx interrupts not available
of_irq_parse_pci: possibly some PCI slots don't have level triggered interrupts capability
PCI host bridge to bus 001e:80
pci_bus 001e:80: root bus resource [mem 0x3fc2c0000000-0x3fc2dfffffff] (bus address [0xc0000000-0xdfffffff])
pci_bus 001e:80: root bus resource [mem 0x305800000000-0x305bffffffff] (bus address [0x3d05800000000-0x3d05bffffffff])
pci_bus 001e:80: root bus resource [bus 80-ff]
pci 001e:80:00.0: PME# supported from D0 D3hot D3cold
pci 001e:80:00.1: PME# supported from D0 D3hot D3cold
pci 001e:80:00.2: PME# supported from D0 D3hot D3cold
pci 001e:80:00.3: PME# supported from D0 D3hot D3cold
iommu: Adding device 001e:80:00.0 to group 2
pci 001e:80:00.0: of_irq_parse_pci: no interrupt-map found, INTx interrupts not available
iommu: Adding device 001e:80:00.1 to group 2
pci 001e:80:00.1: of_irq_parse_pci: no interrupt-map found, INTx interrupts not available
iommu: Adding device 001e:80:00.2 to group 2
pci 001e:80:00.2: of_irq_parse_pci: no interrupt-map found, INTx interrupts not available
iommu: Adding device 001e:80:00.3 to group 2
pci 001e:80:00.3: of_irq_parse_pci: no interrupt-map found, INTx interrupts not available
PCI: Probing PCI hardware done
pseries-rng: Registering arch random hook.
random: fast init done
HugeTLB registered 16.0 MiB page size, pre-allocated 0 pages
HugeTLB registered 16.0 GiB page size, pre-allocated 0 pages
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
clocksource: Switched to clocksource timebase
NET: Registered protocol family 2
TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
UDP hash table entries: 32768 (order: 4, 1048576 bytes)
UDP-Lite hash table entries: 32768 (order: 4, 1048576 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
PCI: CLS 128 bytes, default 128
hv-24x7: read 1330 catalog entries, created 337 event attrs (0 failures), 169 descs
audit: initializing netlink subsys (disabled)
audit: type=2000 audit(1502358334.168:1): state=initialized audit_enabled=0 res=1
workingset: timestamp_bits=38 max_order=19 bucket_order=0
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
io scheduler mq-deadline registered
io scheduler kyber registered
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
brd: module loaded
loop: module loaded
ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March 14, 2017)
ipr 0015:70:00.0: Found IOA with IRQ: 0
ipr 0015:70:00.0: Using 64-bit direct DMA at offset 800000000000000
ipr 0015:70:00.0: Received IRQ : 32
ipr 0015:70:00.0: Request for 16 MSI-Xs succeeded.
ipr 0015:70:00.0: Initializing IOA.
scsi host0: IBM 0 Storage Adapter
ipr 0015:70:00.0: Starting IOA initialization sequence.
ipr 0015:70:00.0: Adapter firmware version: 13511E00
ipr 0015:70:00.0: IOA initialized.
scsi 0:3:0:0: No Device         IBM      57D7001SISIOA    0150 PQ: 0 ANSI: 0
scsi 0:3:0:0: Resource path: 0/FE
scsi 0:0:0:0: Direct-Access     IBM      MK3001GRRB       6209 PQ: 0 ANSI: 6
scsi 0:0:0:0: Resource path: 0/00-02
scsi 0:0:1:0: Direct-Access     IBM      MK3001GRRB       6209 PQ: 0 ANSI: 6
scsi 0:0:1:0: Resource path: 0/00-01
random: crng init done
scsi 0:0:2:0: Direct-Access     IBM      MK3001GRRB       6209 PQ: 0 ANSI: 6
scsi 0:0:2:0: Resource path: 0/00-04
scsi 0:0:3:0: Direct-Access     IBM      MK3001GRRB       6209 PQ: 0 ANSI: 6
scsi 0:0:3:0: Resource path: 0/00-05
scsi 0:0:4:0: Direct-Access     IBM      MK3001GRRB       6209 PQ: 0 ANSI: 6
scsi 0:0:4:0: Resource path: 0/00-06
scsi 0:0:5:0: Direct-Access     IBM      ST9146853SS      7414 PQ: 0 ANSI: 6
scsi 0:0:5:0: Resource path: 0/00-00
scsi 0:1:0:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:0:0: Resource path: 0/FD-00
scsi 0:1:1:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:1:0: Resource path: 0/FD-01
scsi 0:1:2:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:2:0: Resource path: 0/FD-02
scsi 0:1:3:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:3:0: Resource path: 0/FD-03
scsi 0:1:4:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:4:0: Resource path: 0/FD-04
scsi 0:1:5:0: No Device         IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:1:5:0: Resource path: 0/FD-05
scsi 0:2:0:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:0:0: Resource path: 0/FC-01-00
scsi 0:2:1:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:1:0: Resource path: 0/FC-02-00
scsi 0:2:2:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:2:0: Resource path: 0/FC-00-00
scsi 0:2:3:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:3:0: Resource path: 0/FC-05-00
scsi 0:2:4:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:4:0: Resource path: 0/FC-04-00
scsi 0:2:5:0: Direct-Access     IBM      IPR-0   6AB4DA00      PQ: 0 ANSI: 3
scsi 0:2:5:0: Resource path: 0/FC-03-00
scsi 0:0:6:0: Enclosure         IBM      VSBPD12M1 6GSAS    03 PQ: 0 ANSI: 2
scsi 0:0:6:0: Resource path: 0/00-16
scsi 0:0:7:0: Enclosure         IBM      VSBPD12M1 6GSAS    03 PQ: 0 ANSI: 2
scsi 0:0:7:0: Resource path: 0/00-15
ata1.00: ATAPI: IBM.    RMBO0140532, RA64, max UDMA/133
ata1.00: configured for UDMA/133
scsi 0:0:8:0: CD-ROM            IBM.     RMBO0140532      RA64 PQ: 0 ANSI: 2
scsi 0:0:8:0: Resource path: 0/00-0F
sd 0:2:0:0: [sda] Spinning up disk...
sd 0:2:1:0: [sdb] Spinning up disk...
sd 0:2:2:0: [sdc] Spinning up disk...
sd 0:2:3:0: [sdd] Spinning up disk...
sd 0:2:4:0: [sde] Spinning up disk...
sd 0:2:5:0: [sdf] Spinning up disk...
sr 0:0:8:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:8:0: Attached scsi CD-ROM sr0
scsi 0:3:0:0: Attached scsi generic sg0 type 31
scsi 0:0:0:0: Attached scsi generic sg1 type 12
scsi 0:0:1:0: Attached scsi generic sg2 type 12
scsi 0:0:2:0: Attached scsi generic sg3 type 12
scsi 0:0:3:0: Attached scsi generic sg4 type 12
scsi 0:0:4:0: Attached scsi generic sg5 type 12
scsi 0:0:5:0: Attached scsi generic sg6 type 12
scsi 0:1:0:0: Attached scsi generic sg7 type 31
scsi 0:1:1:0: Attached scsi generic sg8 type 31
scsi 0:1:2:0: Attached scsi generic sg9 type 31
scsi 0:1:3:0: Attached scsi generic sg10 type 31
scsi 0:1:4:0: Attached scsi generic sg11 type 31
scsi 0:1:5:0: Attached scsi generic sg12 type 31
sd 0:2:0:0: Attached scsi generic sg13 type 0
sd 0:2:1:0: Attached scsi generic sg14 type 0
sd 0:2:2:0: Attached scsi generic sg15 type 0
sd 0:2:3:0: Attached scsi generic sg16 type 0
sd 0:2:4:0: Attached scsi generic sg17 type 0
sd 0:2:5:0: Attached scsi generic sg18 type 0
scsi 0:0:6:0: Attached scsi generic sg19 type 13
scsi 0:0:7:0: Attached scsi generic sg20 type 13
sr 0:0:8:0: Attached scsi generic sg21 type 5
libphy: Fixed MDIO Bus: probed
tg3.c:v3.137 (May 11, 2014)
tg3 001e:80:00.0: Using 64-bit direct DMA at offset 800000000000000
tg3 001e:80:00.0 eth0: Tigon3 [partno(00RX892) rev 5719001] (PCI Express) MAC address 98:be:94:01:e6:e8
tg3 001e:80:00.0 eth0: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 001e:80:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 001e:80:00.0 eth0: dma_rwctrl[00000000] dma_mask[64-bit]
tg3 001e:80:00.1: Using 64-bit direct DMA at offset 800000000000000
tg3 001e:80:00.1 eth1: Tigon3 [partno(00RX892) rev 5719001] (PCI Express) MAC address 98:be:94:01:e6:e9
tg3 001e:80:00.1 eth1: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 001e:80:00.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 001e:80:00.1 eth1: dma_rwctrl[00000000] dma_mask[64-bit]
tg3 001e:80:00.2: Using 64-bit direct DMA at offset 800000000000000
tg3 001e:80:00.2 eth2: Tigon3 [partno(00RX892) rev 5719001] (PCI Express) MAC address 98:be:94:01:e6:ea
tg3 001e:80:00.2 eth2: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 001e:80:00.2 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 001e:80:00.2 eth2: dma_rwctrl[00000000] dma_mask[64-bit]
tg3 001e:80:00.3: Using 64-bit direct DMA at offset 800000000000000
tg3 001e:80:00.3 eth3: Tigon3 [partno(00RX892) rev 5719001] (PCI Express) MAC address 98:be:94:01:e6:eb
tg3 001e:80:00.3 eth3: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 001e:80:00.3 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 001e:80:00.3 eth3: dma_rwctrl[00000000] dma_mask[64-bit]
ibmveth: IBM Power Virtual Ethernet Driver 1.06
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.36.0-ioctl (2017-06-09) initialised: dm-devel@redhat.com
pseries_idle_driver registered
nx_compress_pseries ibm,compression-v1: nx842_OF_upd: device disabled
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ipip: IPv4 and MPLS over IPv4 tunneling driver
NET: Registered protocol family 17
Key type dns_resolver registered
Running code patching self-tests ...
Running feature fixup self-tests ...
Running MSI bitmap self-tests ...
registered taskstats version 1
console [netcon0] enabled
netconsole: network logging started
rtc-generic rtc-generic: setting system clock to 2017-08-10 09:45:59 UTC (1502358359)
.
ready
sd 0:2:0:0: [sda] 554287104 512-byte logical blocks: (284 GB/264 GiB)
sd 0:2:0:0: [sda] 4096-byte physical blocks
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:0:0: [sda] Mode Sense: 0b 00 00 08
.
.
.
ready
ready
ready
sd 0:2:3:0: [sdd] 554287104 512-byte logical blocks: (284 GB/264 GiB)
sd 0:2:2:0: [sdc] 554287104 512-byte logical blocks: (284 GB/264 GiB)
sd 0:2:3:0: [sdd] 4096-byte physical blocks
sd 0:2:1:0: [sdb] 554287104 512-byte logical blocks: (284 GB/264 GiB)
sd 0:2:2:0: [sdc] 4096-byte physical blocks
sd 0:2:1:0: [sdb] 4096-byte physical blocks
sd 0:2:3:0: [sdd] Write Protect is off
sd 0:2:3:0: [sdd] Mode Sense: 0b 00 00 08
sd 0:2:2:0: [sdc] Write Protect is off
sd 0:2:2:0: [sdc] Mode Sense: 0b 00 00 08
sd 0:2:1:0: [sdb] Write Protect is off
sd 0:2:1:0: [sdb] Mode Sense: 0b 00 00 08
.
.
ready
ready
sd 0:2:4:0: [sde] 554287104 512-byte logical blocks: (284 GB/264 GiB)
sd 0:2:4:0: [sde] 4096-byte physical blocks
sd 0:2:5:0: [sdf] 272646144 512-byte logical blocks: (140 GB/130 GiB)
sd 0:2:5:0: [sdf] 4096-byte physical blocks
sd 0:2:4:0: [sde] Write Protect is off
sd 0:2:4:0: [sde] Mode Sense: 0b 00 00 08
sd 0:2:5:0: [sdf] Write Protect is off
sd 0:2:5:0: [sdf] Mode Sense: 0b 00 00 08
