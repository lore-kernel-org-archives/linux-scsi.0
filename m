From: Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [PATCH v3 0/2] virtio-scsi driver
Date: Sat, 10 Mar 2012 15:34:19 +0800
Message-ID: <20120310073419.GA24958@localhost.localdomain>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324296188-3426-1-git-send-email-pbonzini@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Dec 19, 2011 at 01:03:06PM +0100, Paolo Bonzini wrote:
> This is the first implementation of the virtio-scsi driver, a virtual
> HBA that will be supported by KVM.  It implements a subset of the spec,
> in particular it does not implement asynchronous notifications for either
> LUN reset/removal/addition or CD-ROM media events, but it is already
> functional and usable.

Hi Paolo,

In my tests there are two BUG_ON triggered, one is at blk-core.c:2292,
in blk_finish_request: BUG_ON(blk_queued_rq(req)); the other is at
blk-softirq.c:110, in __blk_complete_request: BUG_ON(!q->softirq_done_fn).

env:

In guest there are 300 disks on one virtio-scsi controller, which are
for test, and one virtio-blk disk in which the guest OS lives.

how to reproduce:

launch 300 background dd processes, one dd for one virtio-scsi disk:

  # for d in `ls /dev/sd*[1-9]`; do dd if=/dev/zero of=/mnt/$d/delme bs=1M count=200 & done

The BUG_ON will show up after some scsi command aborts.

To reproduce the second one, the dd command is slightly different:

  dd if=/root/testfile ...

where /root/testfile is a file in the virtio-blk disk.

BUG_ON(!q->softirq_done_fn) seems impossible but I examined the vmcore
file with the crash tool and found that the request was sent to the
virtio-blk disk(but wrongly grabbed by virtio-scsi):


------------[ cut here ]------------
kernel BUG at /home/hutao/linux-2.6/block/blk-softirq.c:110!
invalid opcode: 0000 [#1] SMP 
CPU 0 
Modules linked in: tun bridge stp llc autofs4 pcspkr sg i2c_piix4 i2c_core sr_mod cdrom [last unloaded: speedstep_lib]

Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc3-ht-virtio-scsi-1+ #13 Bochs Bochs
RIP: 0010:[<ffffffff81267567>]  [<ffffffff81267567>] __blk_complete_request+0x177/0x180
RSP: 0018:ffff88003fc03bd0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880037c90d40 RCX: 0000000000000000
RDX: ffff88003acf57e0 RSI: ffff880037c90d40 RDI: ffff88003780f118
RBP: ffff88003fc03bf0 R08: 0000000000000000 R09: ffff88003fc03ed0
R10: 00000000000e147a R11: 00000000008e147a R12: ffff880013b1e8c0
R13: ffff88003780f118 R14: ffff88003ad1a6a0 R15: 0000000000000086
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f52da498000 CR3: 000000003506f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0d020)
Stack:
 ffff880037c90d40 ffff880013b1e8c0 ffffffff81349d00 ffff88003ad1a6a0
 ffff88003fc03c00 ffffffff81267595 ffff88003fc03c20 ffffffff81339c06
 ffff880037c90d40 ffff880013b1e8c0 ffff88003fc03c50 ffffffff81349e49
Call Trace:
 <IRQ> 
 [<ffffffff81349d00>] ? virtscsi_ctrl_done+0x20/0x20
 [<ffffffff81267595>] blk_complete_request+0x25/0x30
 [<ffffffff81339c06>] scsi_done+0x26/0x60
 [<ffffffff81349e49>] virtscsi_complete_cmd+0x149/0x2a0
 [<ffffffff812ed98b>] ? virtqueue_get_buf+0x6b/0x120
 [<ffffffff81349c66>] virtscsi_vq_done+0x56/0x90
 [<ffffffff81349cb5>] virtscsi_req_done+0x15/0x20
 [<ffffffff812ed8ac>] vring_interrupt+0x3c/0xb0
 [<ffffffff812ee7e3>] vp_vring_interrupt+0x63/0xa0
 [<ffffffff810b746d>] handle_irq_event_percpu+0x5d/0x210
 [<ffffffff810b7662>] handle_irq_event+0x42/0x70
 [<ffffffff810bace9>] handle_edge_irq+0x69/0x120
 [<ffffffff8100436c>] handle_irq+0x5c/0x150
 [<ffffffff81041532>] ? irq_enter+0x22/0x80
 [<ffffffff814a3cbd>] do_IRQ+0x5d/0xe0
 [<ffffffff8149a4ee>] common_interrupt+0x6e/0x6e
 [<ffffffff812ee804>] ? vp_vring_interrupt+0x84/0xa0
 [<ffffffff810415f0>] ? __do_softirq+0x60/0x200
 [<ffffffff810b766d>] ? handle_irq_event+0x4d/0x70
 [<ffffffff814a35dc>] call_softirq+0x1c/0x30
 [<ffffffff810042d5>] do_softirq+0x65/0xa0
 [<ffffffff8104144d>] irq_exit+0xbd/0xe0
 [<ffffffff814a3cc6>] do_IRQ+0x66/0xe0
 [<ffffffff8149a4ee>] common_interrupt+0x6e/0x6e
 <EOI> 
 [<ffffffff81029f76>] ? native_safe_halt+0x6/0x10
 [<ffffffff8100b37d>] default_idle+0x5d/0x190
 [<ffffffff81002099>] cpu_idle+0xd9/0x120
 [<ffffffff8148113d>] rest_init+0x6d/0x80
 [<ffffffff81ad3cc7>] start_kernel+0x3d6/0x3e1
 [<ffffffff81ad332a>] x86_64_start_reservations+0x131/0x136
 [<ffffffff81ad3432>] x86_64_start_kernel+0x103/0x112
Code: 4d 89 6d 28 66 41 c7 45 30 00 00 31 d2 89 df e8 60 b7 e2 ff e9 5b ff ff ff 0f 1f 00 bf 04 00 00 00 e8 9e a3 dd ff e9 49 ff ff ff <0f> 0b eb fe 0f 1f 44 00 00 55 48 89 e5 66 66 66 66 90 3e 0f ba 
RIP  [<ffffffff81267567>] __blk_complete_request+0x177/0x180
 RSP <ffff88003fc03bd0>
crash-6> p /d &(((struct request*)0)->q)
$8 = 56
crash-6> rd ffff88003780f118 8
ffff88003780f118:  ffff88003780f118 ffff88003780f118   ...7.......7....
ffff88003780f128:  0000000106386166 0000000000000000   fa8.............
ffff88003780f138:  0000000000000000 0000000000000000   ................
ffff88003780f148:  0000000000000000 ffff88003acf57e0   .........W.:....
crash-6> p /d &(((struct request_queue*)0)->softirq_done_fn)
$9 = 152
crash-6> rd ffff88003acf57e0 20
ffff88003acf57e0:  ffff88003acf57e0 ffff88003acf57e0   .W.:.....W.:....
ffff88003acf57f0:  ffff88003aea1438 ffff88003acc75c0   8..:.....u.:....
ffff88003acf5800:  0000001500000080 0000000000000000   ................
ffff88003acf5810:  0000000000000095 ffff88003acc7640   ........@v.:....
ffff88003acf5820:  00000000a19aa19a ffff8800308c9370   ........p..0....
ffff88003acf5830:  ffff880032297370 0000000049864986   ps)2.....I.I....
ffff88003acf5840:  ffff88003acf5840 ffff88003acf5840   @X.:....@X.:....
ffff88003acf5850:  ffffffff81335c00 ffffffff81261760   .\3.....`.&.....
ffff88003acf5860:  0000000000000000 0000000000000000   ................
ffff88003acf5870:  0000000000000000 0000000000000000   ................
crash-6> sym ffffffff81261760
ffffffff81261760 (T) blk_queue_bio /home/hutao/linux-2.6/block/blk-core.c: 1315
crash-6> sym ffffffff81335c00
ffffffff81335c00 (t) do_virtblk_request /home/hutao/linux-2.6/drivers/block/virtio_blk.c: 192

                     ^^^ this is request_queue->request_fn
                     
crash-6> 


-- 
Thanks,
Hu Tao

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg-1

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc3-ht-virtio-scsi-1+ (root@KERNEL-128) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #13 SMP Wed Feb 22 14:36:48 CST 2012
Command line: ro root=UUID=a93a2827-4db1-4818-876c-5992c9b27830 rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=64M@64M  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM printk.time=1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Bochs Bochs, BIOS Bochs 01/01/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x3fffd max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [ffff8800000fd610] fd610
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000098000] 98000 size 20480
init_memory_mapping: 0000000000000000-000000003fffd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fffd000 page 4k
kernel direct mapping tables up to 3fffd000 @ 1fffd000-20000000
RAMDISK: 374c8000 - 37ff0000
Reserving 64MB of memory at 64MB for crashkernel (System RAM: 1023MB)
ACPI: RSDP 00000000000fd4b0 00014 (v00 BOCHS )
ACPI: RSDT 000000003fffd7b0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 000000003fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 000000003fffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
ACPI: FACS 000000003fffff40 00040
ACPI: SSDT 000000003fffd910 0009E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 000000003fffd830 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 000000003fffd7f0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
ACPI: Local APIC address 0xfee00000
kvm-clock: Using msrs 4b564d01 and 4b564d00
kvm-clock: cpu 0, msr 0:1ad1f41, boot clock
 [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003e600000-ffff88003f3fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x0003fffd
On node 0 totalpages: 262026
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3920 pages, LIFO batch:0
  DMA32 zone: 3528 pages used for memmap
  DMA32 zone: 254517 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 40000000:beffc000)
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88003fc00000 s76864 r8192 d21440 u2097152
pcpu-alloc: s76864 r8192 d21440 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 
kvm-clock: cpu 0, msr 0:3fc11f41, primary cpu clock
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258437
Kernel command line: ro root=UUID=a93a2827-4db1-4818-876c-5992c9b27830 rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=64M@64M  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM printk.time=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 941512k/1048564k available (4760k kernel code, 460k absent, 106592k reserved, 6242k data, 704k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:262400 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Detected 2393.894 MHz processor.
[    0.001999] Calibrating delay loop (skipped) preset value.. 4787.78 BogoMIPS (lpj=2393894)
[    0.002008] pid_max: default: 32768 minimum: 301
[    0.003047] Mount-cache hash table entries: 256
[    0.004088] Initializing cgroup subsys cpuacct
[    0.004685] Initializing cgroup subsys memory
[    0.005014] Initializing cgroup subsys devices
[    0.006008] Initializing cgroup subsys freezer
[    0.006590] Initializing cgroup subsys net_cls
[    0.007007] Initializing cgroup subsys blkio
[    0.007676] mce: CPU supports 10 MCE banks
[    0.008178] SMP alternatives: switching to UP code
[    0.022998] Freeing SMP alternatives: 20k freed
[    0.023023] ACPI: Core revision 20120111
[    0.024840] ftrace: allocating 16881 entries in 66 pages
[    0.034913] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.035001] CPU0: Intel QEMU Virtual CPU version 1.0.50 stepping 03
[    0.036997] APIC calibration not consistent with PM-Timer: 108ms instead of 100ms
[    0.036997] APIC delta adjusted to PM-Timer: 6249996 (6811887)
[    0.037095] Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
[    0.038077] Brought up 1 CPUs
[    0.038634] Total of 1 processors activated (4787.78 BogoMIPS).
[    0.040251] devtmpfs: initialized
[    0.044322] NET: Registered protocol family 16
[    0.045030] ACPI: bus type pci registered
[    0.045713] PCI: Using configuration type 1 for base access
[    0.047071] bio: create slab <bio-0> at 0
[    0.047720] ACPI: Added _OSI(Module Device)
[    0.048001] ACPI: Added _OSI(Processor Device)
[    0.048615] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.049000] ACPI: Added _OSI(Processor Aggregator Device)
[    0.050556] ACPI: EC: Look up EC in DSDT
[    0.052295] ACPI: Interpreter enabled
[    0.052874] ACPI: (supports S0 S3 S4 S5)
[    0.053745] ACPI: Using IOAPIC for interrupt routing
[    0.057521] ACPI: No dock devices found.
[    0.058000] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.059016] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.060011] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.060013] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.060016] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.060018] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.060020] PCI: root bus 00: using default resources
[    0.060048] PCI host bridge to bus 0000:00
[    0.060637] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.060999] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.062034] pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
[    0.062327] pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
[    0.062779] pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
[    0.064994] pci 0000:00:01.1: reg 20: [io  0xc0c0-0xc0cf]
[    0.066043] pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
[    0.066509] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.067009] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.068134] pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
[    0.069867] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.071993] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.079998] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.080089] pci 0000:00:03.0: [8086:100e] type 0 class 0x000200
[    0.081392] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.081998] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.084754] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.085105] pci 0000:00:08.0: [1af4:1004] type 0 class 0x000100
[    0.086365] pci 0000:00:08.0: reg 10: [io  0xc040-0xc07f]
[    0.086997] pci 0000:00:08.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.091251] pci 0000:00:09.0: [1af4:1001] type 0 class 0x000100
[    0.092517] pci 0000:00:09.0: reg 10: [io  0xc080-0xc0bf]
[    0.093460] pci 0000:00:09.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.099342] pci_bus 0000:00: on NUMA node 0
[    0.099346] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.099715]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    0.103124] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.104075] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.106711] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.107858] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.109070] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.110095] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.110995] vgaarb: loaded
[    0.111993] vgaarb: bridge control possible 0000:00:02.0
[    0.112705] SCSI subsystem initialized
[    0.113026] libata version 3.00 loaded.
[    0.113049] usbcore: registered new interface driver usbfs
[    0.114003] usbcore: registered new interface driver hub
[    0.114655] usbcore: registered new device driver usb
[    0.115019] PCI: Using ACPI for IRQ routing
[    0.115993] PCI: pci_cache_line_size set to 64 bytes
[    0.116135] reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
[    0.116137] reserve RAM buffer: 000000003fffd000 - 000000003fffffff 
[    0.116236] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.117015] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.117993] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.123031] Switching to clocksource kvm-clock
[    0.128465] pnp: PnP ACPI init
[    0.129104] ACPI: bus type pnp registered
[    0.129716] pnp 00:00: [bus 00-ff]
[    0.129719] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.129721] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.129722] pnp 00:00: [io  0x0d00-0xffff window]
[    0.129724] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.129726] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.129767] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.129806] pnp 00:01: [io  0x0070-0x0071]
[    0.129850] pnp 00:01: [irq 8]
[    0.129852] pnp 00:01: [io  0x0072-0x0077]
[    0.129881] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.129912] pnp 00:02: [io  0x0060]
[    0.129913] pnp 00:02: [io  0x0064]
[    0.129952] pnp 00:02: [irq 1]
[    0.129974] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.130031] pnp 00:03: [irq 12]
[    0.130053] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.130075] pnp 00:04: [io  0x03f2-0x03f5]
[    0.130076] pnp 00:04: [io  0x03f7]
[    0.130178] pnp 00:04: [irq 6]
[    0.130181] pnp 00:04: [dma 2]
[    0.130204] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.130257] pnp 00:05: [io  0x0378-0x037f]
[    0.130295] pnp 00:05: [irq 7]
[    0.130318] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.130363] pnp 00:06: [io  0x03f8-0x03ff]
[    0.130400] pnp 00:06: [irq 4]
[    0.130422] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.130492] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.130518] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.130646] pnp: PnP ACPI: found 8 devices
[    0.131284] ACPI: ACPI bus type pnp unregistered
[    0.149725] PCI: max bus depth: 0 pci_try_num: 1
[    0.149732] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.149734] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.149759] NET: Registered protocol family 2
[    0.150463] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.151468] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.153579] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.154605] TCP: Hash tables configured (established 131072 bind 65536)
[    0.155363] TCP reno registered
[    0.155919] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.156896] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.157705] NET: Registered protocol family 1
[    0.158365] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.159040] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.159776] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.160532] pci 0000:00:02.0: Boot video device
[    0.160566] PCI: CLS 0 bytes, default 64
[    0.160599] Unpacking initramfs...
[    0.389734] Freeing initrd memory: 11424k freed
[    0.392795] microcode: CPU0 sig=0x623, pf=0x0, revision=0x0
[    0.393551] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.394886] audit: initializing netlink socket (disabled)
[    0.395584] type=2000 audit(1331195222.394:1): initialized
[    0.414391] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.415325] VFS: Disk quotas dquot_6.5.2
[    0.415928] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.416764] msgmni has been set to 1861
[    0.417549] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.418716] io scheduler noop registered
[    0.419355] io scheduler deadline registered
[    0.419982] io scheduler cfq registered (default)
[    0.420681] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.421440] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.422173] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.422919] acpiphp: Slot [1] registered
[    0.423588] acpiphp: Slot [2] registered
[    0.424247] acpiphp: Slot [3] registered
[    0.424848] acpiphp: Slot [4] registered
[    0.425540] acpiphp: Slot [5] registered
[    0.426184] acpiphp: Slot [6] registered
[    0.426811] acpiphp: Slot [7] registered
[    0.427500] acpiphp: Slot [8] registered
[    0.428178] acpiphp: Slot [9] registered
[    0.428776] acpiphp: Slot [10] registered
[    0.429459] acpiphp: Slot [11] registered
[    0.430418] acpiphp: Slot [12] registered
[    0.430418] acpiphp: Slot [13] registered
[    0.430418] acpiphp: Slot [14] registered
[    0.430418] acpiphp: Slot [15] registered
[    0.430418] acpiphp: Slot [16] registered
[    0.446429] acpiphp: Slot [17] registered
[    0.447043] acpiphp: Slot [18] registered
[    0.447730] acpiphp: Slot [19] registered
[    0.452495] acpiphp: Slot [20] registered
[    0.453175] acpiphp: Slot [21] registered
[    0.453800] acpiphp: Slot [22] registered
[    0.454452] acpiphp: Slot [23] registered
[    0.455090] acpiphp: Slot [24] registered
[    0.455792] acpiphp: Slot [25] registered
[    0.456476] acpiphp: Slot [26] registered
[    0.457153] acpiphp: Slot [27] registered
[    0.457782] acpiphp: Slot [28] registered
[    0.458466] acpiphp: Slot [29] registered
[    0.459074] acpiphp: Slot [30] registered
[    0.459753] acpiphp: Slot [31] registered
[    0.461275] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.462410] ACPI: Power Button [PWRF]
[    0.465175] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.465888] virtio-pci 0000:00:08.0: setting latency timer to 64
[    0.466098] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.466878] virtio-pci 0000:00:09.0: setting latency timer to 64
[    0.467489] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.741877] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.768686] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.769553] Non-volatile memory driver v1.3
[    0.770659] loop: module loaded
[    0.771448] virtio-pci 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.771473] virtio-pci 0000:00:09.0: irq 41 for MSI/MSI-X
[    0.791375]  vda: vda1 vda2
[    0.793246] virtio-pci 0000:00:08.0: irq 42 for MSI/MSI-X
[    0.793271] virtio-pci 0000:00:08.0: irq 43 for MSI/MSI-X
[    0.793597] scsi0 : Virtio SCSI HBA
[    0.794369] ata_piix 0000:00:01.1: version 2.13
[    0.794438] ata_piix 0000:00:01.1: setting latency timer to 64
[    0.794889] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.796305] scsi 0:0:0:1: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.797561] scsi 0:0:0:2: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.798771] scsi1 : ata_piix
[    0.799460] scsi2 : ata_piix
[    0.800107] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0c0 irq 14
[    0.800818] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0c8 irq 15
[    0.801832] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.802613] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.803373] uhci_hcd: USB Universal Host Controller Interface driver
[    0.804133] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.806366] scsi 0:0:0:3: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.807610] scsi 0:0:0:4: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.809133] scsi 0:0:0:5: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.810368] scsi 0:0:0:6: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.811634] scsi 0:0:0:7: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.812952] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.813622] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.814351] mousedev: PS/2 mouse device common for all mice
[    0.815383] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.819293] rtc_cmos 00:01: RTC can wake from S4
[    0.820066] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.821022] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.822502] scsi 0:0:0:8: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.823732] scsi 0:0:0:9: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.824987] scsi 0:0:0:10: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.826160] cpuidle: using governor ladder
[    0.826743] cpuidle: using governor menu
[    0.827394] EFI Variables Facility v0.08 2004-May-17
[    0.828166] usbcore: registered new interface driver usbhid
[    0.828821] usbhid: USB HID core driver
[    0.829508] TCP cubic registered
[    0.830136] Initializing XFRM netlink socket
[    0.830755] NET: Registered protocol family 17
[    0.831534] scsi 0:0:0:11: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.832795] scsi 0:0:0:12: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.846639] registered taskstats version 1
[    0.847502] scsi: waiting for bus probes to complete ...
[    0.848289] scsi 0:0:0:13: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.849540] scsi 0:0:0:14: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.850790] scsi 0:0:0:15: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.852052] scsi 0:0:0:16: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.853301] scsi 0:0:0:17: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.854569] scsi 0:0:0:18: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.855825] scsi 0:0:0:19: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.857073] scsi 0:0:0:20: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.858320] scsi 0:0:0:21: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.859574] scsi 0:0:0:22: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.860838] scsi 0:0:0:23: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.862088] scsi 0:0:0:24: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.863338] scsi 0:0:0:25: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.864622] scsi 0:0:0:26: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.865889] scsi 0:0:0:27: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.867130] scsi 0:0:0:28: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.868366] scsi 0:0:0:29: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.869636] scsi 0:0:0:30: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.870925] scsi 0:0:0:31: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.872156] scsi 0:0:0:32: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.873423] scsi 0:0:0:33: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.874649] scsi 0:0:0:34: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.875934] scsi 0:0:0:35: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.877186] scsi 0:0:0:36: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.878451] scsi 0:0:0:37: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.888489] scsi 0:0:0:38: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.889731] scsi 0:0:0:39: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.891018] scsi 0:0:0:40: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.892267] scsi 0:0:0:41: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.893541] scsi 0:0:0:42: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.894787] scsi 0:0:0:43: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.896034] scsi 0:0:0:44: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.897280] scsi 0:0:0:45: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.898579] scsi 0:0:0:46: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.899851] scsi 0:0:0:47: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.901108] scsi 0:0:0:48: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.902361] scsi 0:0:0:49: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.903662] scsi 0:0:0:50: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.904946] scsi 0:0:0:51: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.906180] scsi 0:0:0:52: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.907455] scsi 0:0:0:53: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.908683] scsi 0:0:0:54: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.909959] scsi 0:0:0:55: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.911216] scsi 0:0:0:56: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.912487] scsi 0:0:0:57: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.913734] scsi 0:0:0:58: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.915007] scsi 0:0:0:59: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.916269] scsi 0:0:0:60: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.920907] scsi 0:0:0:61: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.922158] scsi 0:0:0:62: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.923412] scsi 0:0:0:63: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.924713] scsi 0:0:0:64: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.930134] scsi 0:0:0:65: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.931366] scsi 0:0:0:66: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.932624] scsi 0:0:0:67: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.934208] scsi 0:0:0:68: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.935488] scsi 0:0:0:69: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.936730] scsi 0:0:0:70: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.938000] scsi 0:0:0:71: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.939263] scsi 0:0:0:72: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.940560] scsi 0:0:0:73: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.941836] scsi 0:0:0:74: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.943075] scsi 0:0:0:75: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.944330] scsi 0:0:0:76: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.945579] scsi 0:0:0:77: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.946848] scsi 0:0:0:78: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.948096] scsi 0:0:0:79: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.949518] scsi 0:0:0:80: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.954445] scsi 0:0:0:81: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.955703] scsi 0:0:0:82: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.957010] scsi 0:0:0:83: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.958284] scsi 0:0:0:84: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.959848] scsi 0:0:0:85: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.961090] scsi 0:0:0:86: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.962368] scsi 0:0:0:87: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.963628] ata2.01: NODEV after polling detection
[    0.963879] ata2.00: ATAPI: QEMU DVD-ROM, 1.0.50, max UDMA/100
[    0.964983] ata2.00: configured for MWDMA2
[    0.965819] scsi: waiting for bus probes to complete ...
[    0.966631] scsi 0:0:0:88: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.967929] scsi 0:0:0:89: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.969191] scsi 0:0:0:90: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.970424] scsi 0:0:0:91: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.971695] scsi 0:0:0:92: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.972977] scsi 0:0:0:93: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.974242] scsi 0:0:0:94: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.975519] scsi 0:0:0:95: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.976770] scsi 0:0:0:96: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.978050] scsi 0:0:0:97: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.979302] scsi 0:0:0:98: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.980561] scsi 0:0:0:99: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.981845] scsi 0:0:0:100: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.991100] scsi 0:0:0:101: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.992361] scsi 0:0:0:102: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.993613] scsi 0:0:0:103: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.994885] scsi 0:0:0:104: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.996140] scsi 0:0:0:105: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.997386] scsi 0:0:0:106: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.998681] scsi 0:0:0:107: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    0.999963] scsi 0:0:0:108: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.001229] scsi 0:0:0:109: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.002499] scsi 0:0:0:110: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.003766] scsi 0:0:0:111: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.005054] scsi 0:0:0:112: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.006322] scsi 0:0:0:113: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.007593] scsi 0:0:0:114: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.008878] scsi 0:0:0:115: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.010145] scsi 0:0:0:116: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.011400] scsi 0:0:0:117: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.012675] scsi 0:0:0:118: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.013985] scsi 0:0:0:119: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.015236] scsi 0:0:0:120: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.016488] scsi 0:0:0:121: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.017745] scsi 0:0:0:122: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.019016] scsi 0:0:0:123: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.026635] scsi 0:0:0:124: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.027927] scsi 0:0:0:125: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.029205] scsi 0:0:0:126: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.030495] scsi 0:0:0:127: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.031759] scsi 0:0:0:128: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.033087] scsi 0:0:0:129: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.034421] scsi 0:0:0:130: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.035698] scsi 0:0:0:131: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.036970] scsi 0:0:0:132: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.038254] scsi 0:0:0:133: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.039545] scsi 0:0:0:134: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.040817] scsi 0:0:0:135: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.042084] scsi 0:0:0:136: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.043355] scsi 0:0:0:137: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.044645] scsi 0:0:0:138: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.045959] scsi 0:0:0:139: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.047224] scsi 0:0:0:140: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.048504] scsi 0:0:0:141: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.049781] scsi 0:0:0:142: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.051068] scsi 0:0:0:143: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.052341] scsi 0:0:0:144: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.053623] scsi 0:0:0:145: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.054911] scsi 0:0:0:146: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.059936] scsi 0:0:0:147: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.061225] scsi 0:0:0:148: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.062487] scsi 0:0:0:149: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.063743] scsi 0:0:0:150: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.065055] scsi 0:0:0:151: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.066342] scsi 0:0:0:152: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.071725] scsi 0:0:0:153: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.073014] scsi 0:0:0:154: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.074293] scsi 0:0:0:155: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.075600] scsi 0:0:0:156: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.076889] scsi 0:0:0:157: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.078158] scsi 0:0:0:158: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.079420] scsi 0:0:0:159: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.080825] scsi 0:0:0:160: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.082187] scsi 0:0:0:161: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.083519] scsi 0:0:0:162: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.084852] scsi 0:0:0:163: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.086146] scsi 0:0:0:164: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.087439] scsi 0:0:0:165: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.088705] scsi 0:0:0:166: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.097577] scsi 0:0:0:167: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.098846] scsi 0:0:0:168: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.100139] scsi 0:0:0:169: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.101443] scsi 0:0:0:170: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.102728] scsi 0:0:0:171: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.104013] scsi 0:0:0:172: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.105291] scsi 0:0:0:173: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.106610] scsi 0:0:0:174: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.107915] scsi 0:0:0:175: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.109203] scsi 0:0:0:176: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.110476] scsi 0:0:0:177: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.111763] scsi 0:0:0:178: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.113050] scsi 0:0:0:179: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.114323] scsi 0:0:0:180: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.115628] scsi 0:0:0:181: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.116957] scsi 0:0:0:182: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.118237] scsi 0:0:0:183: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.119556] scsi 0:0:0:184: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.120847] scsi 0:0:0:185: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.122138] scsi 0:0:0:186: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.123419] scsi 0:0:0:187: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.124690] scsi 0:0:0:188: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.129420] scsi 0:0:0:189: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.130694] scsi 0:0:0:190: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.132015] scsi 0:0:0:191: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.133302] scsi 0:0:0:192: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.134600] scsi 0:0:0:193: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.135904] scsi 0:0:0:194: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.137345] scsi 0:0:0:195: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.138710] scsi 0:0:0:196: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.140022] scsi 0:0:0:197: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.141298] scsi 0:0:0:198: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.142601] scsi 0:0:0:199: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.143910] scsi 0:0:0:200: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.145200] scsi 0:0:0:201: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.146494] scsi 0:0:0:202: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.147772] scsi 0:0:0:203: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.149085] scsi 0:0:0:204: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.150365] scsi 0:0:0:205: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.151674] scsi 0:0:0:206: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.152989] scsi 0:0:0:207: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.154259] scsi 0:0:0:208: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.155569] scsi 0:0:0:209: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.156832] scsi 0:0:0:210: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.158122] scsi 0:0:0:211: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.166681] scsi 0:0:0:212: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.167992] scsi 0:0:0:213: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.169288] scsi 0:0:0:214: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.170591] scsi 0:0:0:215: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.171964] scsi 0:0:0:216: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.173277] scsi 0:0:0:217: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.174587] scsi 0:0:0:218: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.175875] scsi 0:0:0:219: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.177171] scsi 0:0:0:220: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.178446] scsi 0:0:0:221: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.179740] scsi 0:0:0:222: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.181041] scsi 0:0:0:223: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.182343] scsi 0:0:0:224: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.183650] scsi 0:0:0:225: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.184979] scsi 0:0:0:226: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.186277] scsi 0:0:0:227: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.187589] scsi 0:0:0:228: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.188892] scsi 0:0:0:229: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.190175] scsi 0:0:0:230: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.191492] scsi 0:0:0:231: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.192775] scsi 0:0:0:232: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.194081] scsi 0:0:0:233: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.195384] scsi 0:0:0:234: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.204320] scsi 0:0:0:235: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.205667] scsi 0:0:0:236: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.206986] scsi 0:0:0:237: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.208267] scsi 0:0:0:238: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.209577] scsi 0:0:0:239: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.210885] scsi 0:0:0:240: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.212171] scsi 0:0:0:241: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.213468] scsi 0:0:0:242: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.218850] scsi 0:0:0:243: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.220166] scsi 0:0:0:244: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.221453] scsi 0:0:0:245: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.222724] scsi 0:0:0:246: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.224038] scsi 0:0:0:247: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.225344] scsi 0:0:0:248: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.226661] scsi 0:0:0:249: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.227978] scsi 0:0:0:250: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.229281] scsi 0:0:0:251: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.230612] scsi 0:0:0:252: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.231920] scsi 0:0:0:253: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.240194] scsi 0:0:0:254: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.241530] scsi 0:0:0:255: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.242846] scsi 0:0:0:256: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.244132] scsi 0:0:0:257: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.245423] scsi 0:0:0:258: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.246706] scsi 0:0:0:259: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.248040] scsi 0:0:0:260: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.249345] scsi 0:0:0:261: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.250674] scsi 0:0:0:262: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.252005] scsi 0:0:0:263: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.253331] scsi 0:0:0:264: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.254636] scsi 0:0:0:265: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.255971] scsi 0:0:0:266: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.257268] scsi 0:0:0:267: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.258599] scsi 0:0:0:268: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.261158] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    1.262590] scsi 0:0:0:269: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.263881] scsi 0:0:0:270: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.265218] scsi 0:0:0:271: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.266544] scsi 0:0:0:272: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.267865] scsi 0:0:0:273: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.269174] scsi 0:0:0:274: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.274490] scsi 0:0:0:275: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.275778] scsi 0:0:0:276: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.277121] scsi 0:0:0:277: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.278657] scsi 0:0:0:278: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.280050] scsi 0:0:0:279: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.281357] scsi 0:0:0:280: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.282668] scsi 0:0:0:281: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.284002] scsi 0:0:0:282: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.285323] scsi 0:0:0:283: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.286661] scsi 0:0:0:284: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.288049] scsi 0:0:0:285: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.289366] scsi 0:0:0:286: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.290702] scsi 0:0:0:287: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.292040] scsi 0:0:0:288: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.293362] scsi 0:0:0:289: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.294671] scsi 0:0:0:290: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.295996] scsi 0:0:0:291: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.297326] scsi 0:0:0:292: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.298660] scsi 0:0:0:293: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.300000] scsi 0:0:0:294: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.301304] scsi 0:0:0:295: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.302631] scsi 0:0:0:296: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.311114] scsi 0:0:0:297: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.312389] scsi 0:0:0:298: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.313708] scsi 0:0:0:299: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
[    1.315021] scsi scan: INQUIRY result too short (5), using 36
[    1.357485] sd 0:0:0:0: [sda] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.371048] sd 0:0:0:1: [sdb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.373246] sd 0:0:0:1: [sdb] Write Protect is off
[    1.390170] sd 0:0:0:1: [sdb] Mode Sense: 63 00 00 08
[    1.391354] sd 0:0:0:2: [sdc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.404922] Refined TSC clocksource calibration: 2393.892 MHz.
[    1.406318] sd 0:0:0:3: [sdd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.413711] sd 0:0:0:4: [sde] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.417082] sd 0:0:0:4: [sde] Write Protect is off
[    1.430102] sd 0:0:0:4: [sde] Mode Sense: 63 00 00 08
[    1.430472] sd 0:0:0:5: [sdf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.432688] sd 0:0:0:5: [sdf] Write Protect is off
[    1.441183] sd 0:0:0:5: [sdf] Mode Sense: 63 00 00 08
[    1.441319] sd 0:0:0:6: [sdg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.445094] sd 0:0:0:6: [sdg] Write Protect is off
[    1.449628] sd 0:0:0:6: [sdg] Mode Sense: 63 00 00 08
[    1.449937] sd 0:0:0:7: [sdh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.452080] sd 0:0:0:7: [sdh] Write Protect is off
[    1.458834] sd 0:0:0:7: [sdh] Mode Sense: 63 00 00 08
[    1.467296] sd 0:0:0:9: [sdj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.476230] sd 0:0:0:10: [sdk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.477541] sd 0:0:0:0: [sda] Write Protect is off
[    1.478203] sd 0:0:0:0: [sda] Mode Sense: 63 00 00 08
[    1.478294] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.480747] sd 0:0:0:3: [sdd] Write Protect is off
[    1.481444] sd 0:0:0:3: [sdd] Mode Sense: 63 00 00 08
[    1.481535] sd 0:0:0:3: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.483252] sd 0:0:0:11: [sdl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.510693] sd 0:0:0:12: [sdm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.520366] sd 0:0:0:13: [sdn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.521957]  sda: sda1
[    1.529626]  sdd: sdd1
[    1.530731] sd 0:0:0:3: [sdd] Attached SCSI disk
[    1.531630] sd 0:0:0:14: [sdo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.534173] sd 0:0:0:6: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.536146] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.536938] sd 0:0:0:15: [sdp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.539076] sd 0:0:0:14: [sdo] Write Protect is off
[    1.551769] sd 0:0:0:14: [sdo] Mode Sense: 63 00 00 08
[    1.551913] sd 0:0:0:16: [sdq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.553243] sd 0:0:0:8: [sdi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.556070] sd 0:0:0:16: [sdq] Write Protect is off
[    1.567487] sd 0:0:0:16: [sdq] Mode Sense: 63 00 00 08
[    1.567806] sd 0:0:0:17: [sdr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.569092] sd 0:0:0:18: [sds] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.571245] sd 0:0:0:17: [sdr] Write Protect is off
[    1.579590] sd 0:0:0:17: [sdr] Mode Sense: 63 00 00 08
[    1.579598]  sdg: sdg1
[    1.580773] sd 0:0:0:6: [sdg] Attached SCSI disk
[    1.588144] sd 0:0:0:19: [sdt] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.614274] sd 0:0:0:7: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.615765] sd 0:0:0:20: [sdu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.622992] sd 0:0:0:2: [sdc] Write Protect is off
[    1.623957] sd 0:0:0:2: [sdc] Mode Sense: 63 00 00 08
[    1.623963] sd 0:0:0:10: [sdk] Write Protect is off
[    1.624659] sd 0:0:0:10: [sdk] Mode Sense: 63 00 00 08
[    1.624786] sd 0:0:0:10: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.626425] sd 0:0:0:5: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.627920] sd 0:0:0:21: [sdv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.630320] sd 0:0:0:2: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.632579] sd 0:0:0:21: [sdv] Write Protect is off
[    1.640768] sd 0:0:0:21: [sdv] Mode Sense: 63 00 00 08
[    1.641362] sd 0:0:0:9: [sdj] Write Protect is off
[    1.642020] sd 0:0:0:9: [sdj] Mode Sense: 63 00 00 08
[    1.642114] sd 0:0:0:9: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.643521] sd 0:0:0:22: [sdw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.645309]  sdf: sdf1
[    1.646432] sd 0:0:0:5: [sdf] Attached SCSI disk
[    1.647187]  sdh: sdh1
[    1.648264] sd 0:0:0:7: [sdh] Attached SCSI disk
[    1.649032] sd 0:0:0:24: [sdy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.651173] sd 0:0:0:22: [sdw] Write Protect is off
[    1.668508] sd 0:0:0:22: [sdw] Mode Sense: 63 00 00 08
[    1.668655] sd 0:0:0:25: [sdz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.671595] sd 0:0:0:12: [sdm] Write Protect is off
[    1.672415] sd 0:0:0:12: [sdm] Mode Sense: 63 00 00 08
[    1.672891]  sdc: sdc1
[    1.674004] sd 0:0:0:2: [sdc] Attached SCSI disk
[    1.687124]  sdk: sdk1
[    1.688243] sd 0:0:0:10: [sdk] Attached SCSI disk
[    1.688991] sd 0:0:0:26: [sdaa] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.690265] sd 0:0:0:27: [sdab] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.691579] sd 0:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.692866] sd 0:0:0:12: [sdm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.695756] sd 0:0:0:23: [sdx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.704253] sd 0:0:0:4: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.723905] sd 0:0:0:13: [sdn] Write Protect is off
[    1.724578] sd 0:0:0:13: [sdn] Mode Sense: 63 00 00 08
[    1.724672] sd 0:0:0:13: [sdn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.726192] sd 0:0:0:28: [sdac] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.727432]  sdj: sdj1
[    1.728487] sd 0:0:0:9: [sdj] Attached SCSI disk
[    1.751236] sd 0:0:0:28: [sdac] Write Protect is off
[    1.766699] sd 0:0:0:28: [sdac] Mode Sense: 63 00 00 08
[    1.766844] sd 0:0:0:30: [sdae] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.768788] sd 0:0:0:31: [sdaf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.770052] sd 0:0:0:8: [sdi] Write Protect is off
[    1.770671] sd 0:0:0:8: [sdi] Mode Sense: 63 00 00 08
[    1.770764] sd 0:0:0:8: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.772104]  sdb: sdb1
[    1.773160] sd 0:0:0:1: [sdb] Attached SCSI disk
[    1.773931] sd 0:0:0:32: [sdag] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.777116] sd 0:0:0:24: [sdy] Write Protect is off
[    1.796863] sd 0:0:0:24: [sdy] Mode Sense: 63 00 00 08
[    1.808475]  sdm: sdm1
[    1.809609] sd 0:0:0:12: [sdm] Attached SCSI disk
[    1.811049] sd 0:0:0:33: [sdah] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.812373] sd 0:0:0:29: [sdad] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.813525]  sde: sde1
[    1.814592] sd 0:0:0:4: [sde] Attached SCSI disk
[    1.816228] sd 0:0:0:33: [sdah] Write Protect is off
[    1.824631] sd 0:0:0:33: [sdah] Mode Sense: 63 00 00 08
[    1.825598] sd 0:0:0:26: [sdaa] Write Protect is off
[    1.839964] sd 0:0:0:26: [sdaa] Mode Sense: 63 00 00 08
[    1.840115] sd 0:0:0:34: [sdai] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.841347] sd 0:0:0:15: [sdp] Write Protect is off
[    1.841974] sd 0:0:0:15: [sdp] Mode Sense: 63 00 00 08
[    1.842198]  sdn: sdn1
[    1.843282] sd 0:0:0:13: [sdn] Attached SCSI disk
[    1.857001] sd 0:0:0:20: [sdu] Write Protect is off
[    1.885287] sd 0:0:0:20: [sdu] Mode Sense: 63 00 00 08
[    1.886269] sd 0:0:0:34: [sdai] Write Protect is off
[    1.906180] sd 0:0:0:34: [sdai] Mode Sense: 63 00 00 08
[    1.907162] sd 0:0:0:29: [sdad] Write Protect is off
[    1.911750] sd 0:0:0:29: [sdad] Mode Sense: 63 00 00 08
[    1.911900] sd 0:0:0:36: [sdak] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.913075] sd 0:0:0:15: [sdp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.920441] sd 0:0:0:37: [sdal] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.921597]  sdi: sdi1
[    1.922673] sd 0:0:0:8: [sdi] Attached SCSI disk
[    1.923535] sd 0:0:0:38: [sdam] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.925695] sd 0:0:0:36: [sdak] Write Protect is off
[    1.942020] sd 0:0:0:36: [sdak] Mode Sense: 63 00 00 08
[    1.942166] sd 0:0:0:39: [sdan] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.943545] sd 0:0:0:40: [sdao] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.944705] sd 0:0:0:18: [sds] Write Protect is off
[    1.945492] sd 0:0:0:18: [sds] Mode Sense: 63 00 00 08
[    1.946476] sd 0:0:0:32: [sdag] Write Protect is off
[    1.967414] sd 0:0:0:32: [sdag] Mode Sense: 63 00 00 08
[    1.988482] rtc_cmos 00:01: setting system clock to 2012-03-08 08:27:03 UTC (1331195223)
[    1.989958] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.0. PQ: 0 ANSI: 5
[    1.991359] sd 0:0:0:41: [sdap] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    1.993585] sd 0:0:0:41: [sdap] Write Protect is off
[    2.016647] sd 0:0:0:41: [sdap] Mode Sense: 63 00 00 08
[    2.016749] sd 0:0:0:17: [sdr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.017970] sd 0:0:0:35: [sdaj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.020135] sd 0:0:0:40: [sdao] Write Protect is off
[    2.028027] sd 0:0:0:40: [sdao] Mode Sense: 63 00 00 08
[    2.029010] sd 0:0:0:37: [sdal] Write Protect is off
[    2.038682] sd 0:0:0:37: [sdal] Mode Sense: 63 00 00 08
[    2.038835] sd 0:0:0:42: [sdaq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.040088] sd 0:0:0:18: [sds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.042280] sd 0:0:0:38: [sdam] Write Protect is off
[    2.045604] sd 0:0:0:38: [sdam] Mode Sense: 63 00 00 08
[    2.046584] sd 0:0:0:39: [sdan] Write Protect is off
[    2.060005] sd 0:0:0:39: [sdan] Mode Sense: 63 00 00 08
[    2.060186] sd 0:0:0:43: [sdar] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.062360] sd 0:0:0:42: [sdaq] Write Protect is off
[    2.067404] sd 0:0:0:42: [sdaq] Mode Sense: 63 00 00 08
[    2.067554] sd 0:0:0:44: [sdas] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.082130] sd 0:0:0:44: [sdas] Write Protect is off
[    2.096511] sd 0:0:0:44: [sdas] Mode Sense: 63 00 00 08
[    2.097345] sd 0:0:0:45: [sdat] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.098642]  sdr: sdr1
[    2.099796] sd 0:0:0:17: [sdr] Attached SCSI disk
[    2.100650]  sds: sds1
[    2.101696] sd 0:0:0:18: [sds] Attached SCSI disk
[    2.112048] sd 0:0:0:16: [sdq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.113404] sd 0:0:0:21: [sdv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.114743] sd 0:0:0:46: [sdau] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.116876] sd 0:0:0:45: [sdat] Write Protect is off
[    2.125256] sd 0:0:0:45: [sdat] Mode Sense: 63 00 00 08
[    2.126234] sd 0:0:0:46: [sdau] Write Protect is off
[    2.144585] sd 0:0:0:46: [sdau] Mode Sense: 63 00 00 08
[    2.144685] sd 0:0:0:14: [sdo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.146126] sd 0:0:0:47: [sdav] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.148568] sd 0:0:0:48: [sdaw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.149906] sd 0:0:0:49: [sdax] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.152061] sd 0:0:0:47: [sdav] Write Protect is off
[    2.155846] sd 0:0:0:47: [sdav] Mode Sense: 63 00 00 08
[    2.155956] sd 0:0:0:29: [sdad] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.157167]  sdv: sdv1
[    2.158274] sd 0:0:0:21: [sdv] Attached SCSI disk
[    2.159023] sd 0:0:0:50: [sday] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.161210] sd 0:0:0:23: [sdx] Write Protect is off
[    2.166807] sd 0:0:0:23: [sdx] Mode Sense: 63 00 00 08
[    2.166969] sd 0:0:0:51: [sdaz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.168170]  sdq: sdq1
[    2.169240] sd 0:0:0:16: [sdq] Attached SCSI disk
[    2.169994] sd 0:0:0:52: [sdba] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.172126] sd 0:0:0:51: [sdaz] Write Protect is off
[    2.187876] sd 0:0:0:51: [sdaz] Mode Sense: 63 00 00 08
[    2.187993] sd 0:0:0:38: [sdam] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.189388] sd 0:0:0:53: [sdbb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.191547] sd 0:0:0:49: [sdax] Write Protect is off
[    2.195048] sd 0:0:0:49: [sdax] Mode Sense: 63 00 00 08
[    2.195056]  sdo: sdo1
[    2.196031] sd 0:0:0:14: [sdo] Attached SCSI disk
[    2.197829] sd 0:0:0:48: [sdaw] Write Protect is off
[    2.201002] sd 0:0:0:48: [sdaw] Mode Sense: 63 00 00 08
[    2.205961] sd 0:0:0:54: [sdbc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.207173]  sdad: sdad1
[    2.208282] sd 0:0:0:29: [sdad] Attached SCSI disk
[    2.211226] sd 0:0:0:54: [sdbc] Write Protect is off
[    2.229157] sd 0:0:0:54: [sdbc] Mode Sense: 63 00 00 08
[    2.229321] sd 0:0:0:56: [sdbe] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.230604]  sdam: sdam1
[    2.231724] sd 0:0:0:38: [sdam] Attached SCSI disk
[    2.236668]  sdp: sdp1
[    2.237814] sd 0:0:0:15: [sdp] Attached SCSI disk
[    2.238659] sd 0:0:0:57: [sdbf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.239913] sd 0:0:0:42: [sdaq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.241225] sd 0:0:0:33: [sdah] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.243412] sd 0:0:0:50: [sday] Write Protect is off
[    2.249496] sd 0:0:0:50: [sday] Mode Sense: 63 00 00 08
[    2.257652] sd 0:0:0:52: [sdba] Write Protect is off
[    2.275053] sd 0:0:0:52: [sdba] Mode Sense: 63 00 00 08
[    2.275213] sd 0:0:0:58: [sdbg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.276353] sd 0:0:0:25: [sdz] Write Protect is off
[    2.276997] sd 0:0:0:25: [sdz] Mode Sense: 63 00 00 08
[    2.277096] sd 0:0:0:25: [sdz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.278406] sd 0:0:0:55: [sdbd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.285741] sd 0:0:0:59: [sdbh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.286939] sd 0:0:0:11: [sdl] Write Protect is off
[    2.287655] sd 0:0:0:11: [sdl] Mode Sense: 63 00 00 08
[    2.287748] sd 0:0:0:11: [sdl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.296801] sd 0:0:0:30: [sdae] Write Protect is off
[    2.297695] sd 0:0:0:30: [sdae] Mode Sense: 63 00 00 08
[    2.297850] sd 0:0:0:60: [sdbi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.315840] sd 0:0:0:61: [sdbj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.317109] sd 0:0:0:47: [sdav] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.318385]  sdaq: sdaq1
[    2.319605] sd 0:0:0:42: [sdaq] Attached SCSI disk
[    2.326861]  sdah: sdah1
[    2.328003] sd 0:0:0:33: [sdah] Attached SCSI disk
[    2.328694] sd 0:0:0:31: [sdaf] Write Protect is off
[    2.329379] sd 0:0:0:31: [sdaf] Mode Sense: 63 00 00 08
[    2.329583] sd 0:0:0:31: [sdaf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.330914] sd 0:0:0:40: [sdao] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.333108] sd 0:0:0:61: [sdbj] Write Protect is off
[    2.342753] sd 0:0:0:61: [sdbj] Mode Sense: 63 00 00 08
[    2.342855] sd 0:0:0:30: [sdae] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.344156] sd 0:0:0:48: [sdaw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.354183] sd 0:0:0:62: [sdbk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.355899] sd 0:0:0:49: [sdax] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.357389] sd 0:0:0:53: [sdbb] Write Protect is off
[    2.358035] sd 0:0:0:53: [sdbb] Mode Sense: 63 00 00 08
[    2.359151] sd 0:0:0:60: [sdbi] Write Protect is off
[    2.365108] sd 0:0:0:60: [sdbi] Mode Sense: 63 00 00 08
[    2.365116]  sdz: sdz1
[    2.366287] sd 0:0:0:25: [sdz] Attached SCSI disk
[    2.368065] sd 0:0:0:62: [sdbk] Write Protect is off
[    2.376067] sd 0:0:0:62: [sdbk] Mode Sense: 63 00 00 08
[    2.377320] sd 0:0:0:64: [sdbm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.378981]  sdl: sdl1
[    2.380241] sd 0:0:0:11: [sdl] Attached SCSI disk
[    2.380996] sd 0:0:0:65: [sdbn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.382226] sd 0:0:0:53: [sdbb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.391804] sd 0:0:0:23: [sdx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.393197] sd 0:0:0:66: [sdbo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.394825]  sdav: sdav1
[    2.396293] sd 0:0:0:47: [sdav] Attached SCSI disk
[    2.397070] sd 0:0:0:67: [sdbp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.398554] sd 0:0:0:68: [sdbq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.399740]  sdao: sdao1
[    2.400828] sd 0:0:0:40: [sdao] Attached SCSI disk
[    2.402497] sd 0:0:0:64: [sdbm] Write Protect is off
[    2.406882] sd 0:0:0:64: [sdbm] Mode Sense: 63 00 00 08
[    2.406996] sd 0:0:0:37: [sdal] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.408353] sd 0:0:0:69: [sdbr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.409515]  sdae: sdae1
[    2.410646] sd 0:0:0:30: [sdae] Attached SCSI disk
[    2.413058] sd 0:0:0:69: [sdbr] Write Protect is off
[    2.418187] sd 0:0:0:69: [sdbr] Mode Sense: 63 00 00 08
[    2.418195]  sdaf: sdaf1
[    2.419329] sd 0:0:0:31: [sdaf] Attached SCSI disk
[    2.420304] sd 0:0:0:71: [sdbt] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.428818] sd 0:0:0:43: [sdar] Write Protect is off
[    2.429542] sd 0:0:0:43: [sdar] Mode Sense: 63 00 00 08
[    2.429649] sd 0:0:0:43: [sdar] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.430927]  sdax: sdax1
[    2.432036] sd 0:0:0:49: [sdax] Attached SCSI disk
[    2.432901] sd 0:0:0:63: [sdbl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.435037] sd 0:0:0:66: [sdbo] Write Protect is off
[    2.446211] sd 0:0:0:66: [sdbo] Mode Sense: 63 00 00 08
[    2.447182] sd 0:0:0:68: [sdbq] Write Protect is off
[    2.452211] sd 0:0:0:68: [sdbq] Mode Sense: 63 00 00 08
[    2.452319] sd 0:0:0:45: [sdat] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.454345]  sdx: sdx1
[    2.455520] sd 0:0:0:23: [sdx] Attached SCSI disk
[    2.456315] sd 0:0:0:22: [sdw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.457675] sd 0:0:0:72: [sdbu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.466945] sd 0:0:0:73: [sdbv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.468253] sd 0:0:0:74: [sdbw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.469671] sd 0:0:0:75: [sdbx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.470943]  sdal: sdal1
[    2.472010] sd 0:0:0:37: [sdal] Attached SCSI disk
[    2.474025] sd 0:0:0:28: [sdac] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.475411] sd 0:0:0:76: [sdby] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.476671] sd 0:0:0:26: [sdaa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.477914] sd 0:0:0:35: [sdaj] Write Protect is off
[    2.478601] sd 0:0:0:35: [sdaj] Mode Sense: 63 00 00 08
[    2.478700] sd 0:0:0:35: [sdaj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.479926] sd 0:0:0:70: [sdbs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.481746] sd 0:0:0:77: [sdbz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.483912] sd 0:0:0:65: [sdbn] Write Protect is off
[    2.488915] sd 0:0:0:65: [sdbn] Mode Sense: 63 00 00 08
[    2.488922] sd 0:0:0:27: [sdab] Write Protect is off
[    2.489690] sd 0:0:0:27: [sdab] Mode Sense: 63 00 00 08
[    2.489696] sd 0:0:0:58: [sdbg] Write Protect is off
[    2.490367] sd 0:0:0:58: [sdbg] Mode Sense: 63 00 00 08
[    2.490599] sd 0:0:0:58: [sdbg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.493188] sd 0:0:0:76: [sdby] Write Protect is off
[    2.505919] sd 0:0:0:76: [sdby] Mode Sense: 63 00 00 08
[    2.506900] sd 0:0:0:73: [sdbv] Write Protect is off
[    2.515562] sd 0:0:0:73: [sdbv] Mode Sense: 63 00 00 08
[    2.516413] sd 0:0:0:78: [sdca] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.517611]  sdat: sdat1
[    2.518731] sd 0:0:0:45: [sdat] Attached SCSI disk
[    2.520381] sd 0:0:0:74: [sdbw] Write Protect is off
[    2.526152] sd 0:0:0:74: [sdbw] Mode Sense: 63 00 00 08
[    2.526262] sd 0:0:0:50: [sday] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.530954] sd 0:0:0:79: [sdcb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.532222]  sdw: sdw1
[    2.533301] sd 0:0:0:22: [sdw] Attached SCSI disk
[    2.535100] sd 0:0:0:75: [sdbx] Write Protect is off
[    2.553969] sd 0:0:0:75: [sdbx] Mode Sense: 63 00 00 08
[    2.553975] sd 0:0:0:56: [sdbe] Write Protect is off
[    2.554682] sd 0:0:0:56: [sdbe] Mode Sense: 63 00 00 08
[    2.554793] sd 0:0:0:56: [sdbe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.556131] sd 0:0:0:63: [sdbl] Write Protect is off
[    2.556741] sd 0:0:0:63: [sdbl] Mode Sense: 63 00 00 08
[    2.556849] sd 0:0:0:63: [sdbl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.558297]  sdar: sdar1
[    2.559402] sd 0:0:0:43: [sdar] Attached SCSI disk
[    2.560143] sd 0:0:0:81: [sdcd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.562290] sd 0:0:0:27: [sdab] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.574372] sd 0:0:0:82: [sdce] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.576276] sd 0:0:0:83: [sdcf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.577464] sd 0:0:0:57: [sdbf] Write Protect is off
[    2.578099] sd 0:0:0:57: [sdbf] Mode Sense: 63 00 00 08
[    2.578262] sd 0:0:0:57: [sdbf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.580474] sd 0:0:0:78: [sdca] Write Protect is off
[    2.594951] sd 0:0:0:78: [sdca] Mode Sense: 63 00 00 08
[    2.594959]  sdac: sdac1
[    2.596075] sd 0:0:0:28: [sdac] Attached SCSI disk
[    2.597775] sd 0:0:0:77: [sdbz] Write Protect is off
[    2.609204] sd 0:0:0:77: [sdbz] Mode Sense: 63 00 00 08
[    2.609212]  sdaa: sdaa1
[    2.610304] sd 0:0:0:26: [sdaa] Attached SCSI disk
[    2.611082] sd 0:0:0:84: [sdcg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.612345] sd 0:0:0:39: [sdan] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.613609] sd 0:0:0:55: [sdbd] Write Protect is off
[    2.614278] sd 0:0:0:55: [sdbd] Mode Sense: 63 00 00 08
[    2.614384] sd 0:0:0:55: [sdbd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.616616] sd 0:0:0:83: [sdcf] Write Protect is off
[    2.631435] sd 0:0:0:83: [sdcf] Mode Sense: 63 00 00 08
[    2.632246] sd 0:0:0:85: [sdch] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.642771] sd 0:0:0:86: [sdci] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.644538]  sdaj: sdaj1
[    2.645719] sd 0:0:0:35: [sdaj] Attached SCSI disk
[    2.667542]  sday: sday1
[    2.668709] sd 0:0:0:50: [sday] Attached SCSI disk
[    2.669384] sd 0:0:0:80: [sdcc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.672165] sd 0:0:0:85: [sdch] Write Protect is off
[    2.680400] sd 0:0:0:85: [sdch] Mode Sense: 63 00 00 08
[    2.680569] sd 0:0:0:87: [sdcj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.681840] sd 0:0:0:64: [sdbm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.683061] sd 0:0:0:19: [sdt] Write Protect is off
[    2.683678] sd 0:0:0:19: [sdt] Mode Sense: 63 00 00 08
[    2.683772] sd 0:0:0:19: [sdt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.685134]  sdbg: sdbg1
[    2.686261] sd 0:0:0:58: [sdbg] Attached SCSI disk
[    2.687038] sd 0:0:0:88: [sdck] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.689431]  sdab: sdab1
[    2.690644] sd 0:0:0:27: [sdab] Attached SCSI disk
[    2.692035] sd 0:0:0:89: [sdcl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.693295] sd 0:0:0:36: [sdak] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.694634] sd 0:0:0:44: [sdas] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.697231] sd 0:0:0:87: [sdcj] Write Protect is off
[    2.712279] sd 0:0:0:87: [sdcj] Mode Sense: 63 00 00 08
[    2.712398] sd 0:0:0:60: [sdbi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.713629]  sdbe: sdbe1
[    2.714750] sd 0:0:0:56: [sdbe] Attached SCSI disk
[    2.715645] sd 0:0:0:90: [sdcm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.716854]  sdan: sdan1
[    2.717969] sd 0:0:0:39: [sdan] Attached SCSI disk
[    2.718641]  sdbl: sdbl1
[    2.719797] sd 0:0:0:63: [sdbl] Attached SCSI disk
[    2.721483] sd 0:0:0:86: [sdci] Write Protect is off
[    2.728442] sd 0:0:0:86: [sdci] Mode Sense: 63 00 00 08
[    2.739364]  sdbf: sdbf1
[    2.740513] sd 0:0:0:57: [sdbf] Attached SCSI disk
[    2.749083] sd 0:0:0:67: [sdbp] Write Protect is off
[    2.749706] sd 0:0:0:67: [sdbp] Mode Sense: 63 00 00 08
[    2.749818] sd 0:0:0:67: [sdbp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.751145] sd 0:0:0:69: [sdbr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.754097] sd 0:0:0:81: [sdcd] Write Protect is off
[    2.762892] sd 0:0:0:81: [sdcd] Mode Sense: 63 00 00 08
[    2.763002] sd 0:0:0:24: [sdy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.764310] sd 0:0:0:68: [sdbq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.767093] sd 0:0:0:90: [sdcm] Write Protect is off
[    2.772310] sd 0:0:0:90: [sdcm] Mode Sense: 63 00 00 08
[    2.772481] sd 0:0:0:91: [sdcn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.773804] sd 0:0:0:92: [sdco] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.774994]  sdbd: sdbd1
[    2.776202] sd 0:0:0:55: [sdbd] Attached SCSI disk
[    2.777005] sd 0:0:0:93: [sdcp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.788089] sd 0:0:0:89: [sdcl] Write Protect is off
[    2.796525] sd 0:0:0:89: [sdcl] Mode Sense: 63 00 00 08
[    2.807983]  sdbm: sdbm1
[    2.809381] sd 0:0:0:64: [sdbm] Attached SCSI disk
[    2.826048] sd 0:0:0:95: [sdcr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.827856] sd 0:0:0:96: [sdcs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.829039]  sdas: sdas1
[    2.830227] sd 0:0:0:44: [sdas] Attached SCSI disk
[    2.830868]  sdak: sdak1
[    2.832025] sd 0:0:0:36: [sdak] Attached SCSI disk
[    2.832783]  sdbi: sdbi1
[    2.833922] sd 0:0:0:60: [sdbi] Attached SCSI disk
[    2.834760] sd 0:0:0:98: [sdcu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.836721] sd 0:0:0:99: [sdcv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.837891]  sdt: sdt1
[    2.838925] sd 0:0:0:19: [sdt] Attached SCSI disk
[    2.840297] sd 0:0:0:100: [sdcw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.841564] sd 0:0:0:62: [sdbk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.844194] sd 0:0:0:92: [sdco] Write Protect is off
[    2.850201] sd 0:0:0:92: [sdco] Mode Sense: 63 00 00 08
[    2.867646] sd 0:0:0:101: [sdcx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.868852]  sdbr: sdbr1
[    2.870031] sd 0:0:0:69: [sdbr] Attached SCSI disk
[    2.871325]  sdy: sdy1
[    2.872539] sd 0:0:0:24: [sdy] Attached SCSI disk
[    2.879634] sd 0:0:0:34: [sdai] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.881046] sd 0:0:0:65: [sdbn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.883234] sd 0:0:0:71: [sdbt] Write Protect is off
[    2.893481] sd 0:0:0:71: [sdbt] Mode Sense: 63 00 00 08
[    2.893490]  sdbq: sdbq1
[    2.894645] sd 0:0:0:68: [sdbq] Attached SCSI disk
[    2.909577]  sdaw: sdaw1
[    2.910692] sd 0:0:0:48: [sdaw] Attached SCSI disk
[    2.911482] sd 0:0:0:61: [sdbj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.913680] sd 0:0:0:101: [sdcx] Write Protect is off
[    2.924614] sd 0:0:0:101: [sdcx] Mode Sense: 63 00 00 08
[    2.924622]  sdbp: sdbp1
[    2.925957] sd 0:0:0:67: [sdbp] Attached SCSI disk
[    2.926798] sd 0:0:0:102: [sdcy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.928966] sd 0:0:0:98: [sdcu] Write Protect is off
[    2.935336] sd 0:0:0:98: [sdcu] Mode Sense: 63 00 00 08
[    2.937092] sd 0:0:0:99: [sdcv] Write Protect is off
[    2.951632] sd 0:0:0:99: [sdcv] Mode Sense: 63 00 00 08
[    2.951754] sd 0:0:0:94: [sdcq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.953146] sd 0:0:0:97: [sdct] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.955281] sd 0:0:0:100: [sdcw] Write Protect is off
[    2.966664] sd 0:0:0:100: [sdcw] Mode Sense: 63 00 00 08
[    2.966839] sd 0:0:0:103: [sdcz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.968153] sd 0:0:0:104: [sdda] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.969462] sd 0:0:0:105: [sddb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.970634]  sdbb: sdbb1
[    2.971763] sd 0:0:0:53: [sdbb] Attached SCSI disk
[    2.987365] sd 0:0:0:106: [sddc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    2.988988]  sdbk: sdbk1
[    2.990448] sd 0:0:0:62: [sdbk] Attached SCSI disk
[    2.991238] sd 0:0:0:74: [sdbw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    2.994081] sd 0:0:0:72: [sdbu] Write Protect is off
[    3.003914] sd 0:0:0:72: [sdbu] Mode Sense: 63 00 00 08
[    3.004031] sd 0:0:0:51: [sdaz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.005411] sd 0:0:0:108: [sdde] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.006748] sd 0:0:0:109: [sddf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.008582]  sdai: sdai1
[    3.009702] sd 0:0:0:34: [sdai] Attached SCSI disk
[    3.010566] sd 0:0:0:110: [sddg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.011710]  sdbn: sdbn1
[    3.012819] sd 0:0:0:65: [sdbn] Attached SCSI disk
[    3.013690] sd 0:0:0:111: [sddh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.015059] sd 0:0:0:112: [sddi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.036849] sd 0:0:0:94: [sdcq] Write Protect is off
[    3.037530] sd 0:0:0:94: [sdcq] Mode Sense: 63 00 00 08
[    3.037634] sd 0:0:0:32: [sdag] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.039846] sd 0:0:0:103: [sdcz] Write Protect is off
[    3.039846] sd 0:0:0:103: [sdcz] Mode Sense: 63 00 00 08
[    3.039846] sd 0:0:0:103: [sdcz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.039846] sd 0:0:0:113: [sddj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.058853]  sdbj: sdbj1
[    3.060068] sd 0:0:0:61: [sdbj] Attached SCSI disk
[    3.061854] sd 0:0:0:105: [sddb] Write Protect is off
[    3.077059] sd 0:0:0:105: [sddb] Mode Sense: 63 00 00 08
[    3.078030] sd 0:0:0:106: [sddc] Write Protect is off
[    3.081844] sd 0:0:0:106: [sddc] Mode Sense: 63 00 00 08
[    3.082037] sd 0:0:0:114: [sddk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.084252] sd 0:0:0:111: [sddh] Write Protect is off
[    3.090365] sd 0:0:0:111: [sddh] Mode Sense: 63 00 00 08
[    3.091245] sd 0:0:0:115: [sddl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.092621] sd 0:0:0:116: [sddm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.105983] sd 0:0:0:109: [sddf] Write Protect is off
[    3.120749] sd 0:0:0:109: [sddf] Mode Sense: 63 00 00 08
[    3.120858] sd 0:0:0:46: [sdau] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.122083]  sdcz: sdcz1
[    3.123298] sd 0:0:0:103: [sdcz] Attached SCSI disk
[    3.125316]  sdbw: sdbw1
[    3.126588] sd 0:0:0:74: [sdbw] Attached SCSI disk
[    3.127407] sd 0:0:0:107: [sddd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.129612] sd 0:0:0:112: [sddi] Write Protect is off
[    3.138175] sd 0:0:0:112: [sddi] Mode Sense: 63 00 00 08
[    3.138183]  sdaz: sdaz1
[    3.139432] sd 0:0:0:51: [sdaz] Attached SCSI disk
[    3.141142] sd 0:0:0:116: [sddm] Write Protect is off
[    3.147114] sd 0:0:0:116: [sddm] Mode Sense: 63 00 00 08
[    3.147298] sd 0:0:0:119: [sddp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.148774] sd 0:0:0:120: [sddq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.158375] sd 0:0:0:114: [sddk] Write Protect is off
[    3.169370] sd 0:0:0:114: [sddk] Mode Sense: 63 00 00 08
[    3.169553] sd 0:0:0:121: [sddr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.174884] sd 0:0:0:73: [sdbv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.176119]  sdag: sdag1
[    3.177263] sd 0:0:0:32: [sdag] Attached SCSI disk
[    3.178033] sd 0:0:0:90: [sdcm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.180388] sd 0:0:0:119: [sddp] Write Protect is off
[    3.198497] sd 0:0:0:119: [sddp] Mode Sense: 63 00 00 08
[    3.198684] sd 0:0:0:123: [sddt] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.200954] sd 0:0:0:115: [sddl] Write Protect is off
[    3.208687] sd 0:0:0:115: [sddl] Mode Sense: 63 00 00 08
[    3.208871] sd 0:0:0:124: [sddu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.210190] sd 0:0:0:41: [sdap] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.211979] sd 0:0:0:110: [sddg] Write Protect is off
[    3.212772] sd 0:0:0:110: [sddg] Mode Sense: 63 00 00 08
[    3.212885] sd 0:0:0:66: [sdbo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.225380] sd 0:0:0:79: [sdcb] Write Protect is off
[    3.226009] sd 0:0:0:79: [sdcb] Mode Sense: 63 00 00 08
[    3.226170] sd 0:0:0:79: [sdcb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.234208]  sdau: sdau1
[    3.235446] sd 0:0:0:46: [sdau] Attached SCSI disk
[    3.237303] sd 0:0:0:124: [sddu] Write Protect is off
[    3.249055] sd 0:0:0:124: [sddu] Mode Sense: 63 00 00 08
[    3.249234] sd 0:0:0:117: [sddn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.250644] sd 0:0:0:126: [sddw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.252013] sd 0:0:0:127: [sddx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.253347] sd 0:0:0:118: [sddo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.255634] sd 0:0:0:110: [sddg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.256981] sd 0:0:0:59: [sdbh] Write Protect is off
[    3.257762] sd 0:0:0:59: [sdbh] Mode Sense: 63 00 00 08
[    3.259125] sd 0:0:0:127: [sddx] Write Protect is off
[    3.277663] sd 0:0:0:127: [sddx] Mode Sense: 63 00 00 08
[    3.277785] sd 0:0:0:86: [sdci] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.279053] sd 0:0:0:70: [sdbs] Write Protect is off
[    3.279677] sd 0:0:0:70: [sdbs] Mode Sense: 63 00 00 08
[    3.279787] sd 0:0:0:70: [sdbs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.281279] sd 0:0:0:122: [sdds] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.284179] sd 0:0:0:123: [sddt] Write Protect is off
[    3.293461] sd 0:0:0:123: [sddt] Mode Sense: 63 00 00 08
[    3.293468] sd 0:0:0:88: [sdck] Write Protect is off
[    3.294167] sd 0:0:0:88: [sdck] Mode Sense: 63 00 00 08
[    3.294284] sd 0:0:0:88: [sdck] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.295819] sd 0:0:0:128: [sddy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.297421] sd 0:0:0:54: [sdbc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.299317] sd 0:0:0:52: [sdba] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.300629]  sdbv: sdbv1
[    3.301759] sd 0:0:0:73: [sdbv] Attached SCSI disk
[    3.302595] sd 0:0:0:85: [sdch] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.303833]  sdap: sdap1
[    3.304899] sd 0:0:0:41: [sdap] Attached SCSI disk
[    3.305592]  sdcm: sdcm1
[    3.315280] sd 0:0:0:117: [sddn] Write Protect is off
[    3.323054] sd 0:0:0:117: [sddn] Mode Sense: 63 00 00 08
[    3.323169] sd 0:0:0:59: [sdbh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.325349] sd 0:0:0:128: [sddy] Write Protect is off
[    3.336139] sd 0:0:0:128: [sddy] Mode Sense: 63 00 00 08
[    3.336285] sd 0:0:0:92: [sdco] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.353721]  sdbo: sdbo1
[    3.354859] sd 0:0:0:66: [sdbo] Attached SCSI disk
[    3.355755] sd 0:0:0:129: [sddz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.357125] sd 0:0:0:125: [sddv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.358441] sd 0:0:0:94: [sdcq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.361364] sd 0:0:0:118: [sddo] Write Protect is off
[    3.368544] sd 0:0:0:118: [sddo] Mode Sense: 63 00 00 08
[    3.369352] sd 0:0:0:106: [sddc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.375247] sd 0:0:0:104: [sdda] Write Protect is off
[    3.375866] sd 0:0:0:104: [sdda] Mode Sense: 63 00 00 08
[    3.375995] sd 0:0:0:104: [sdda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.378224] sd 0:0:0:129: [sddz] Write Protect is off
[    3.393013] sd 0:0:0:129: [sddz] Mode Sense: 63 00 00 08
[    3.393993] sd 0:0:0:130: [sdea] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.396648] sd 0:0:0:131: [sdeb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.397838]  sdci: sdci1
[    3.398970] sd 0:0:0:86: [sdci] Attached SCSI disk
[    3.400175]  sddg: sddg1
[    3.401644] sd 0:0:0:110: [sddg] Attached SCSI disk
[    3.403165] sd 0:0:0:132: [sdec] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.404433]  sdbc: sdbc1
[    3.405953] sd 0:0:0:76: [sdby] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.407239]  sdba: sdba1
[    3.408359] sd 0:0:0:52: [sdba] Attached SCSI disk
[    3.409180] sd 0:0:0:98: [sdcu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.410590] sd 0:0:0:134: [sdee] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.411841] sd 0:0:0:77: [sdbz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.413175] sd 0:0:0:89: [sdcl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.415002] sd 0:0:0:20: [sdu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.417227] sd 0:0:0:125: [sddv] Write Protect is off
[    3.430749] sd 0:0:0:125: [sddv] Mode Sense: 63 00 00 08
[    3.430869] sd 0:0:0:81: [sdcd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.432286] sd 0:0:0:135: [sdef] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.434465] sd 0:0:0:130: [sdea] Write Protect is off
[    3.441755] sd 0:0:0:130: [sdea] Mode Sense: 63 00 00 08
[    3.441763]  sdch: sdch1
[    3.443028] sd 0:0:0:85: [sdch] Attached SCSI disk
[    3.443840]  sdbh: sdbh1
[    3.444950] sd 0:0:0:59: [sdbh] Attached SCSI disk
[    3.445843] sd 0:0:0:136: [sdeg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.447620]  sdbs: sdbs1
[    3.448827] sd 0:0:0:70: [sdbs] Attached SCSI disk
[    3.449522]  sdco: sdco1
[    3.450714] sd 0:0:0:92: [sdco] Attached SCSI disk
[    3.451378]  sdck: sdck1
[    3.452544] sd 0:0:0:88: [sdck] Attached SCSI disk
[    3.454417] sd 0:0:0:54: [sdbc] Attached SCSI disk
[    3.455050] sd 0:0:0:80: [sdcc] Write Protect is off
[    3.455746] sd 0:0:0:80: [sdcc] Mode Sense: 63 00 00 08
[    3.455858] sd 0:0:0:80: [sdcc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.472299] sd 0:0:0:138: [sdei] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.485309]  sdcq: sdcq1
[    3.486526] sd 0:0:0:94: [sdcq] Attached SCSI disk
[    3.488206] sd 0:0:0:121: [sddr] Write Protect is off
[    3.499496] sd 0:0:0:121: [sddr] Mode Sense: 63 00 00 08
[    3.499505]  sddc: sddc1
[    3.500676] sd 0:0:0:106: [sddc] Attached SCSI disk
[    3.512029] sd 0:0:0:139: [sdej] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.514227] sd 0:0:0:132: [sdec] Write Protect is off
[    3.522781] sd 0:0:0:132: [sdec] Mode Sense: 63 00 00 08
[    3.523760] sd 0:0:0:93: [sdcp] Write Protect is off
[    3.530980] sd 0:0:0:93: [sdcp] Mode Sense: 63 00 00 08
[    3.530986] sd 0:0:0:84: [sdcg] Write Protect is off
[    3.531703] sd 0:0:0:84: [sdcg] Mode Sense: 63 00 00 08
[    3.531826] sd 0:0:0:84: [sdcg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.533205] sd 0:0:0:133: [sded] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.547460] sd 0:0:0:140: [sdek] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.549647] sd 0:0:0:136: [sdeg] Write Protect is off
[    3.559121] sd 0:0:0:136: [sdeg] Mode Sense: 63 00 00 08
[    3.559247] sd 0:0:0:111: [sddh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.560559]  sdu: sdu1
[    3.561823] sd 0:0:0:20: [sdu] Attached SCSI disk
[    3.562571]  sdda: sdda1
[    3.563864] sd 0:0:0:104: [sdda] Attached SCSI disk
[    3.564721] sd 0:0:0:141: [sdel] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.565910]  sdcd: sdcd1
[    3.567037] sd 0:0:0:81: [sdcd] Attached SCSI disk
[    3.567741]  sdby: sdby1
[    3.568861] sd 0:0:0:76: [sdby] Attached SCSI disk
[    3.569519]  sdcl: sdcl1
[    3.570677] sd 0:0:0:89: [sdcl] Attached SCSI disk
[    3.571529] sd 0:0:0:137: [sdeh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.572690]  sdcu: sdcu1
[    3.573835] sd 0:0:0:98: [sdcu] Attached SCSI disk
[    3.574535]  sdbz: sdbz1
[    3.575677] sd 0:0:0:77: [sdbz] Attached SCSI disk
[    3.576532] sd 0:0:0:142: [sdem] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.586142] sd 0:0:0:116: [sddm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.587556] sd 0:0:0:143: [sden] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.588906] sd 0:0:0:144: [sdeo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.590233] sd 0:0:0:145: [sdep] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.591558] sd 0:0:0:146: [sdeq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.593680] sd 0:0:0:140: [sdek] Write Protect is off
[    3.602291] sd 0:0:0:140: [sdek] Mode Sense: 63 00 00 08
[    3.602485] sd 0:0:0:147: [sder] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.608674] sd 0:0:0:78: [sdca] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.611072] sd 0:0:0:139: [sdej] Write Protect is off
[    3.629404] sd 0:0:0:139: [sdej] Mode Sense: 63 00 00 08
[    3.629600] sd 0:0:0:148: [sdes] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.631776] sd 0:0:0:133: [sded] Write Protect is off
[    3.641778] sd 0:0:0:133: [sded] Mode Sense: 63 00 00 08
[    3.641980] sd 0:0:0:149: [sdet] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.643309] sd 0:0:0:150: [sdeu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.645577] sd 0:0:0:141: [sdel] Write Protect is off
[    3.650440] sd 0:0:0:141: [sdel] Mode Sense: 63 00 00 08
[    3.652207] sd 0:0:0:137: [sdeh] Write Protect is off
[    3.669089] sd 0:0:0:137: [sdeh] Mode Sense: 63 00 00 08
[    3.669097]  sdcc: sdcc1
[    3.670308] sd 0:0:0:80: [sdcc] Attached SCSI disk
[    3.671033] sd 0:0:0:71: [sdbt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.674084] sd 0:0:0:143: [sden] Write Protect is off
[    3.679480] sd 0:0:0:143: [sden] Mode Sense: 63 00 00 08
[    3.680462] sd 0:0:0:145: [sdep] Write Protect is off
[    3.688246] sd 0:0:0:145: [sdep] Mode Sense: 63 00 00 08
[    3.689228] sd 0:0:0:146: [sdeq] Write Protect is off
[    3.706729] sd 0:0:0:146: [sdeq] Mode Sense: 63 00 00 08
[    3.707692] sd 0:0:0:144: [sdeo] Write Protect is off
[    3.717320] sd 0:0:0:144: [sdeo] Mode Sense: 63 00 00 08
[    3.717540] sd 0:0:0:152: [sdew] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.718904] sd 0:0:0:153: [sdex] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.720778] sd 0:0:0:154: [sdey] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.722180] sd 0:0:0:155: [sdez] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.723532] sd 0:0:0:156: [sdfa] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.724894] sd 0:0:0:157: [sdfb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.726242] sd 0:0:0:158: [sdfc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.727531] sd 0:0:0:83: [sdcf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.728774]  sddh: sddh1
[    3.729934] sd 0:0:0:111: [sddh] Attached SCSI disk
[    3.730609] sd 0:0:0:122: [sdds] Write Protect is off
[    3.731284] sd 0:0:0:122: [sdds] Mode Sense: 63 00 00 08
[    3.731425] sd 0:0:0:122: [sdds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.732728] sd 0:0:0:72: [sdbu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.735032] sd 0:0:0:150: [sdeu] Write Protect is off
[    3.735032] sd 0:0:0:150: [sdeu] Mode Sense: 63 00 00 08
[    3.735032] sd 0:0:0:150: [sdeu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.735032] sd 0:0:0:159: [sdfd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.753118]  sddm: sddm1
[    3.754359] sd 0:0:0:116: [sddm] Attached SCSI disk
[    3.754990]  sdcg: sdcg1
[    3.756243] sd 0:0:0:84: [sdcg] Attached SCSI disk
[    3.764080] sd 0:0:0:149: [sdet] Write Protect is off
[    3.770749] sd 0:0:0:149: [sdet] Mode Sense: 63 00 00 08
[    3.771459] sd 0:0:0:101: [sdcx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.793991] sd 0:0:0:162: [sdfg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.795888] sd 0:0:0:100: [sdcw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.797088]  sdeu: sdeu1
[    3.798377] sd 0:0:0:150: [sdeu] Attached SCSI disk
[    3.799003]  sdca: sdca1
[    3.800294] sd 0:0:0:78: [sdca] Attached SCSI disk
[    3.802138] sd 0:0:0:152: [sdew] Write Protect is off
[    3.807587] sd 0:0:0:152: [sdew] Mode Sense: 63 00 00 08
[    3.808560] sd 0:0:0:153: [sdex] Write Protect is off
[    3.813533] sd 0:0:0:153: [sdex] Mode Sense: 63 00 00 08
[    3.813659] sd 0:0:0:112: [sddi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.815889] sd 0:0:0:155: [sdez] Write Protect is off
[    3.821153] sd 0:0:0:155: [sdez] Mode Sense: 63 00 00 08
[    3.821279] sd 0:0:0:115: [sddl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.823480] sd 0:0:0:154: [sdey] Write Protect is off
[    3.840077] sd 0:0:0:154: [sdey] Mode Sense: 63 00 00 08
[    3.841060] sd 0:0:0:156: [sdfa] Write Protect is off
[    3.847688] sd 0:0:0:156: [sdfa] Mode Sense: 63 00 00 08
[    3.848671] sd 0:0:0:157: [sdfb] Write Protect is off
[    3.853762] sd 0:0:0:157: [sdfb] Mode Sense: 63 00 00 08
[    3.855156] sd 0:0:0:158: [sdfc] Write Protect is off
[    3.859758] sd 0:0:0:158: [sdfc] Mode Sense: 63 00 00 08
[    3.859956] sd 0:0:0:151: [sdev] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.861122]  sdbt: sdbt1
[    3.862280] sd 0:0:0:71: [sdbt] Attached SCSI disk
[    3.863025] sd 0:0:0:87: [sdcj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.865238] sd 0:0:0:162: [sdfg] Write Protect is off
[    3.884256] sd 0:0:0:162: [sdfg] Mode Sense: 63 00 00 08
[    3.884463] sd 0:0:0:166: [sdfk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.885621] sd 0:0:0:108: [sdde] Write Protect is off
[    3.886302] sd 0:0:0:108: [sdde] Mode Sense: 63 00 00 08
[    3.886438] sd 0:0:0:108: [sdde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.887631] sd 0:0:0:82: [sdce] Write Protect is off
[    3.888306] sd 0:0:0:82: [sdce] Mode Sense: 63 00 00 08
[    3.888440] sd 0:0:0:82: [sdce] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.889851] sd 0:0:0:167: [sdfl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.891597]  sdcf: sdcf1
[    3.892811] sd 0:0:0:83: [sdcf] Attached SCSI disk
[    3.893661] sd 0:0:0:160: [sdfe] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.894838]  sdbu: sdbu1
[    3.895953] sd 0:0:0:72: [sdbu] Attached SCSI disk
[    3.898103] sd 0:0:0:161: [sdff] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.900237] sd 0:0:0:166: [sdfk] Write Protect is off
[    3.911825] sd 0:0:0:166: [sdfk] Mode Sense: 63 00 00 08
[    3.912700] sd 0:0:0:168: [sdfm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.921449]  sdcb: sdcb1
[    3.922623] sd 0:0:0:79: [sdcb] Attached SCSI disk
[    3.924508]  sdds: sdds1
[    3.925812] sd 0:0:0:122: [sdds] Attached SCSI disk
[    3.926495]  sdcx: sdcx1
[    3.927646] sd 0:0:0:101: [sdcx] Attached SCSI disk
[    3.929314] sd 0:0:0:151: [sdev] Write Protect is off
[    3.937459] sd 0:0:0:151: [sdev] Mode Sense: 63 00 00 08
[    3.937465] sd 0:0:0:95: [sdcr] Write Protect is off
[    3.938182] sd 0:0:0:95: [sdcr] Mode Sense: 63 00 00 08
[    3.938300] sd 0:0:0:95: [sdcr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.939527] sd 0:0:0:91: [sdcn] Write Protect is off
[    3.940217] sd 0:0:0:91: [sdcn] Mode Sense: 63 00 00 08
[    3.940331] sd 0:0:0:91: [sdcn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.942279] sd 0:0:0:75: [sdbx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.943766] sd 0:0:0:163: [sdfh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.945047] sd 0:0:0:118: [sddo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.946442] sd 0:0:0:164: [sdfi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.947582]  sdcw: sdcw1
[    3.948744] sd 0:0:0:100: [sdcw] Attached SCSI disk
[    3.950396] sd 0:0:0:167: [sdfl] Write Protect is off
[    3.968257] sd 0:0:0:167: [sdfl] Mode Sense: 63 00 00 08
[    3.968456] sd 0:0:0:165: [sdfj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.969829] sd 0:0:0:169: [sdfn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    3.971006]  sddi: sddi1
[    3.972267] sd 0:0:0:112: [sddi] Attached SCSI disk
[    3.973516] sd 0:0:0:90: [sdcm] Attached SCSI disk
[    3.974196]  sddl: sddl1
[    3.975410] sd 0:0:0:115: [sddl] Attached SCSI disk
[    3.976087]  sdcj: sdcj1
[    3.977255] sd 0:0:0:87: [sdcj] Attached SCSI disk
[    3.978020] sd 0:0:0:117: [sddn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.980215] sd 0:0:0:160: [sdfe] Write Protect is off
[    3.990103] sd 0:0:0:160: [sdfe] Mode Sense: 63 00 00 08
[    3.991075] sd 0:0:0:147: [sder] Write Protect is off
[    4.009862] sd 0:0:0:147: [sder] Mode Sense: 63 00 00 08
[    4.010548] sd 0:0:0:161: [sdff] Write Protect is off
[    4.011392] sd 0:0:0:161: [sdff] Mode Sense: 63 00 00 08
[    4.012814] sd 0:0:0:172: [sdfq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.014149] sd 0:0:0:173: [sdfr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.016279] sd 0:0:0:169: [sdfn] Write Protect is off
[    4.034115] sd 0:0:0:169: [sdfn] Mode Sense: 63 00 00 08
[    4.034327] sd 0:0:0:174: [sdfs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.035099] sd 0:0:0:174: [sdfs] Write Protect is off
[    4.035099] sd 0:0:0:174: [sdfs] Mode Sense: 63 00 00 08
[    4.035099] sd 0:0:0:174: [sdfs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.053027] sd 0:0:0:102: [sdcy] Write Protect is off
[    4.053839] sd 0:0:0:102: [sdcy] Mode Sense: 63 00 00 08
[    4.053847]  sdfs: sdfs1
[    4.055231] sd 0:0:0:174: [sdfs] Attached SCSI disk
[    4.055890]  sdde: sdde1
[    4.057331] sd 0:0:0:108: [sdde] Attached SCSI disk
[    4.058288] sd 0:0:0:177: [sdfv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.066193] sd 0:0:0:107: [sddd] Write Protect is off
[    4.066844] sd 0:0:0:107: [sddd] Mode Sense: 63 00 00 08
[    4.066974] sd 0:0:0:107: [sddd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.069153] sd 0:0:0:134: [sdee] Write Protect is off
[    4.078530] sd 0:0:0:134: [sdee] Mode Sense: 63 00 00 08
[    4.078538]  sdce: sdce1
[    4.079794] sd 0:0:0:82: [sdce] Attached SCSI disk
[    4.081594] sd 0:0:0:164: [sdfi] Write Protect is off
[    4.095342] sd 0:0:0:164: [sdfi] Mode Sense: 63 00 00 08
[    4.097371] sd 0:0:0:178: [sdfw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.098946] sd 0:0:0:179: [sdfx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.101132] sd 0:0:0:165: [sdfj] Write Protect is off
[    4.112882] sd 0:0:0:165: [sdfj] Mode Sense: 63 00 00 08
[    4.113011] sd 0:0:0:123: [sddt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.114445] sd 0:0:0:180: [sdfy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.115716] sd 0:0:0:130: [sdea] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.117604] sd 0:0:0:113: [sddj] Write Protect is off
[    4.118384] sd 0:0:0:113: [sddj] Mode Sense: 63 00 00 08
[    4.118509] sd 0:0:0:113: [sddj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.130505] sd 0:0:0:99: [sdcv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.131953] sd 0:0:0:182: [sdga] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.134352]  sddo: sddo1
[    4.135615] sd 0:0:0:118: [sddo] Attached SCSI disk
[    4.136397] sd 0:0:0:102: [sdcy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.137890] sd 0:0:0:170: [sdfo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.139254] sd 0:0:0:171: [sdfp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.140613] sd 0:0:0:183: [sdgb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.142752] sd 0:0:0:173: [sdfr] Write Protect is off
[    4.147624] sd 0:0:0:173: [sdfr] Mode Sense: 63 00 00 08
[    4.148606] sd 0:0:0:172: [sdfq] Write Protect is off
[    4.153771] sd 0:0:0:172: [sdfq] Mode Sense: 63 00 00 08
[    4.153921] sd 0:0:0:161: [sdff] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.155127] sd 0:0:0:96: [sdcs] Write Protect is off
[    4.155747] sd 0:0:0:96: [sdcs] Mode Sense: 63 00 00 08
[    4.155867] sd 0:0:0:96: [sdcs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.157229] sd 0:0:0:141: [sdel] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.158526]  sddn: sddn1
[    4.159781] sd 0:0:0:117: [sddn] Attached SCSI disk
[    4.168560]  sdcn: sdcn1
[    4.169713] sd 0:0:0:91: [sdcn] Attached SCSI disk
[    4.170550]  sdbx: sdbx1
[    4.171562] sd 0:0:0:184: [sdgc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.172913]  sdcr: sdcr1
[    4.174072] sd 0:0:0:95: [sdcr] Attached SCSI disk
[    4.175729] sd 0:0:0:177: [sdfv] Write Protect is off
[    4.184213] sd 0:0:0:177: [sdfv] Mode Sense: 63 00 00 08
[    4.185183] sd 0:0:0:179: [sdfx] Write Protect is off
[    4.190372] sd 0:0:0:179: [sdfx] Mode Sense: 63 00 00 08
[    4.191347] sd 0:0:0:180: [sdfy] Write Protect is off
[    4.196747] sd 0:0:0:180: [sdfy] Mode Sense: 63 00 00 08
[    4.196876] sd 0:0:0:93: [sdcp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.207660] sd 0:0:0:175: [sdft] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.209807] sd 0:0:0:178: [sdfw] Write Protect is off
[    4.219836] sd 0:0:0:178: [sdfw] Mode Sense: 63 00 00 08
[    4.220817] sd 0:0:0:182: [sdga] Write Protect is off
[    4.220817] sd 0:0:0:182: [sdga] Mode Sense: 63 00 00 08
[    4.220817] sd 0:0:0:182: [sdga] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.233505] sd 0:0:0:185: [sdgd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.234789] sd 0:0:0:124: [sddu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.243386] sd 0:0:0:176: [sdfu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.245556] sd 0:0:0:184: [sdgc] Write Protect is off
[    4.251998] sd 0:0:0:184: [sdgc] Mode Sense: 63 00 00 08
[    4.253012] sd 0:0:0:186: [sdge] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.265453] sd 0:0:0:143: [sden] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.273686] sd 0:0:0:183: [sdgb] Write Protect is off
[    4.286167] sd 0:0:0:183: [sdgb] Mode Sense: 63 00 00 08
[    4.286300] sd 0:0:0:128: [sddy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.287569]  sddt: sddt1
[    4.288909] sd 0:0:0:123: [sddt] Attached SCSI disk
[    4.290472]  sdea: sdea1
[    4.292069] sd 0:0:0:130: [sdea] Attached SCSI disk
[    4.292867] sd 0:0:0:132: [sdec] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.294684]  sdcv: sdcv1
[    4.295989] sd 0:0:0:99: [sdcv] Attached SCSI disk
[    4.296667] sd 0:0:0:148: [sdes] Write Protect is off
[    4.297351] sd 0:0:0:148: [sdes] Mode Sense: 63 00 00 08
[    4.297492] sd 0:0:0:148: [sdes] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.298849] sd 0:0:0:158: [sdfc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.300273] sd 0:0:0:187: [sdgf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.301586] sd 0:0:0:105: [sddb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.303864] sd 0:0:0:185: [sdgd] Write Protect is off
[    4.321836] sd 0:0:0:185: [sdgd] Mode Sense: 63 00 00 08
[    4.321844]  sdcy: sdcy1
[    4.323021] sd 0:0:0:102: [sdcy] Attached SCSI disk
[    4.323903] sd 0:0:0:188: [sdgg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.325196] sd 0:0:0:109: [sddf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.326402]  sddd: sddd1
[    4.327662] sd 0:0:0:107: [sddd] Attached SCSI disk
[    4.328334] sd 0:0:0:97: [sdct] Write Protect is off
[    4.328948] sd 0:0:0:97: [sdct] Mode Sense: 63 00 00 08
[    4.329063] sd 0:0:0:97: [sdct] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.330378]  sdga: sdga1
[    4.331838] sd 0:0:0:182: [sdga] Attached SCSI disk
[    4.333301] sd 0:0:0:153: [sdex] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.334749] sd 0:0:0:189: [sdgh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.336146] sd 0:0:0:190: [sdgi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.337316]  sdel: sdel1
[    4.338561] sd 0:0:0:141: [sdel] Attached SCSI disk
[    4.339228]  sdff: sdff1
[    4.340496] sd 0:0:0:161: [sdff] Attached SCSI disk
[    4.341309] sd 0:0:0:157: [sdfb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.343524] sd 0:0:0:175: [sdft] Write Protect is off
[    4.343524] sd 0:0:0:175: [sdft] Mode Sense: 63 00 00 08
[    4.343524] sd 0:0:0:175: [sdft] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.362010] sd 0:0:0:155: [sdez] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.372444] sd 0:0:0:176: [sdfu] Write Protect is off
[    4.373072] sd 0:0:0:176: [sdfu] Mode Sense: 63 00 00 08
[    4.373248]  sdcs: sdcs1
[    4.374501] sd 0:0:0:96: [sdcs] Attached SCSI disk
[    4.375394] sd 0:0:0:191: [sdgj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.377509] sd 0:0:0:186: [sdge] Write Protect is off
[    4.400607] sd 0:0:0:186: [sdge] Mode Sense: 63 00 00 08
[    4.401590] sd 0:0:0:152: [sdew] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.404198] sd 0:0:0:142: [sdem] Write Protect is off
[    4.414350] sd 0:0:0:142: [sdem] Mode Sense: 63 00 00 08
[    4.415830] sd 0:0:0:140: [sdek] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.424910] sd 0:0:0:149: [sdet] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.428251] sd 0:0:0:191: [sdgj] Write Protect is off
[    4.435971] sd 0:0:0:191: [sdgj] Mode Sense: 63 00 00 08
[    4.436155] sd 0:0:0:136: [sdeg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.437624] sd 0:0:0:192: [sdgk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.438997] sd 0:0:0:193: [sdgl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.440288] sd 0:0:0:145: [sdep] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.441544]  sden: sden1
[    4.442771] sd 0:0:0:143: [sden] Attached SCSI disk
[    4.443507]  sddy: sddy1
[    4.444746] sd 0:0:0:128: [sddy] Attached SCSI disk
[    4.445662] sd 0:0:0:194: [sdgm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.451851]  sdec: sdec1
[    4.453170] sd 0:0:0:132: [sdec] Attached SCSI disk
[    4.454850] sd 0:0:0:189: [sdgh] Write Protect is off
[    4.462553] sd 0:0:0:189: [sdgh] Mode Sense: 63 00 00 08
[    4.463481] sd 0:0:0:195: [sdgn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.464641]  sddb: sddb1
[    4.473318]  sdfc: sdfc1
[    4.474691] sd 0:0:0:158: [sdfc] Attached SCSI disk
[    4.476324] sd 0:0:0:196: [sdgo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.477679] sd 0:0:0:197: [sdgp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.478980] sd 0:0:0:156: [sdfa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.480195] sd 0:0:0:131: [sdeb] Write Protect is off
[    4.480823] sd 0:0:0:131: [sdeb] Mode Sense: 63 00 00 08
[    4.480947] sd 0:0:0:131: [sdeb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.482249] sd 0:0:0:176: [sdfu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.483541]  sddf: sddf1
[    4.484730] sd 0:0:0:109: [sddf] Attached SCSI disk
[    4.486892] sd 0:0:0:198: [sdgq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.488493] sd 0:0:0:192: [sdgk] Write Protect is off
[    4.489184] sd 0:0:0:192: [sdgk] Mode Sense: 63 00 00 08
[    4.489417] sd 0:0:0:199: [sdgr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.490779] sd 0:0:0:200: [sdgs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.492156] sd 0:0:0:201: [sdgt] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.493348]  sdex: sdex1
[    4.494601] sd 0:0:0:153: [sdex] Attached SCSI disk
[    4.495902]  sdes: sdes1
[    4.497304] sd 0:0:0:148: [sdes] Attached SCSI disk
[    4.497979]  sdfb: sdfb1
[    4.499316] sd 0:0:0:157: [sdfb] Attached SCSI disk
[    4.500882] sd 0:0:0:204: [sdgw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.508499]  sdct: sdct1
[    4.509695] sd 0:0:0:97: [sdct] Attached SCSI disk
[    4.511185]  sdet: sdet1
[    4.512454] sd 0:0:0:149: [sdet] Attached SCSI disk
[    4.513246] sd 0:0:0:121: [sddr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.514487]  sdez: sdez1
[    4.515699] sd 0:0:0:155: [sdez] Attached SCSI disk
[    4.522217] sd 0:0:0:201: [sdgt] Write Protect is off
[    4.528006] sd 0:0:0:201: [sdgt] Mode Sense: 63 00 00 08
[    4.528988] sd 0:0:0:193: [sdgl] Write Protect is off
[    4.547157] sd 0:0:0:193: [sdgl] Mode Sense: 63 00 00 08
[    4.548031] sd 0:0:0:205: [sdgx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.550234] sd 0:0:0:194: [sdgm] Write Protect is off
[    4.556285] sd 0:0:0:194: [sdgm] Mode Sense: 63 00 00 08
[    4.556292]  sdew: sdew1
[    4.557545] sd 0:0:0:152: [sdew] Attached SCSI disk
[    4.559214] sd 0:0:0:195: [sdgn] Write Protect is off
[    4.563239] sd 0:0:0:195: [sdgn] Mode Sense: 63 00 00 08
[    4.563374] sd 0:0:0:133: [sded] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.564585]  sdek: sdek1
[    4.565881] sd 0:0:0:140: [sdek] Attached SCSI disk
[    4.567570] sd 0:0:0:197: [sdgp] Write Protect is off
[    4.567570] sd 0:0:0:197: [sdgp] Mode Sense: 63 00 00 08
[    4.567570] sd 0:0:0:197: [sdgp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.588240] sd 0:0:0:192: [sdgk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.590499]  sdfu: sdfu1
[    4.591879] sd 0:0:0:176: [sdfu] Attached SCSI disk
[    4.592620]  sdeg: sdeg1
[    4.593860] sd 0:0:0:136: [sdeg] Attached SCSI disk
[    4.594714] sd 0:0:0:144: [sdeo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.596240] sd 0:0:0:206: [sdgy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.597645] sd 0:0:0:207: [sdgz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.599911] sd 0:0:0:198: [sdgq] Write Protect is off
[    4.609811] sd 0:0:0:198: [sdgq] Mode Sense: 63 00 00 08
[    4.609963] sd 0:0:0:181: [sdfz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.611149]  sdep: sdep1
[    4.612427] sd 0:0:0:145: [sdep] Attached SCSI disk
[    4.614148] sd 0:0:0:199: [sdgr] Write Protect is off
[    4.624750] sd 0:0:0:199: [sdgr] Mode Sense: 63 00 00 08
[    4.624987] sd 0:0:0:209: [sdhb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.627268] sd 0:0:0:200: [sdgs] Write Protect is off
[    4.634588] sd 0:0:0:200: [sdgs] Mode Sense: 63 00 00 08
[    4.635571] sd 0:0:0:168: [sdfm] Write Protect is off
[    4.642720] sd 0:0:0:168: [sdfm] Mode Sense: 63 00 00 08
[    4.642948] sd 0:0:0:210: [sdhc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.661742] sd 0:0:0:211: [sdhd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.663034] sd 0:0:0:125: [sddv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.664730] sd 0:0:0:212: [sdhe] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.666162] sd 0:0:0:138: [sdei] Write Protect is off
[    4.666785] sd 0:0:0:138: [sdei] Mode Sense: 63 00 00 08
[    4.666925] sd 0:0:0:138: [sdei] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.668686]  sdfa: sdfa1
[    4.669976] sd 0:0:0:156: [sdfa] Attached SCSI disk
[    4.671524] sd 0:0:0:173: [sdfr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.672874] sd 0:0:0:126: [sddw] Write Protect is off
[    4.673633] sd 0:0:0:126: [sddw] Mode Sense: 63 00 00 08
[    4.673761] sd 0:0:0:126: [sddw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.675053] sd 0:0:0:163: [sdfh] Write Protect is off
[    4.675673] sd 0:0:0:163: [sdfh] Mode Sense: 63 00 00 08
[    4.675808] sd 0:0:0:163: [sdfh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.677971] sd 0:0:0:213: [sdhf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.679137]  sdgp: sdgp1
[    4.680457] sd 0:0:0:197: [sdgp] Attached SCSI disk
[    4.681300] sd 0:0:0:129: [sddz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.682645] sd 0:0:0:172: [sdfq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.684092] sd 0:0:0:203: [sdgv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.686230] sd 0:0:0:211: [sdhd] Write Protect is off
[    4.690226] sd 0:0:0:211: [sdhd] Mode Sense: 63 00 00 08
[    4.690235]  sddj: sddj1
[    4.697996] sd 0:0:0:113: [sddj] Attached SCSI disk
[    4.698912] sd 0:0:0:202: [sdgu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.700284] sd 0:0:0:215: [sdhh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.701815] sd 0:0:0:216: [sdhi] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.703655]  sddr: sddr1
[    4.704868] sd 0:0:0:121: [sddr] Attached SCSI disk
[    4.705706] sd 0:0:0:119: [sddp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.706981]  sdeb: sdeb1
[    4.708180] sd 0:0:0:131: [sdeb] Attached SCSI disk
[    4.709040] sd 0:0:0:218: [sdhk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.710337] sd 0:0:0:180: [sdfy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.712538] sd 0:0:0:206: [sdgy] Write Protect is off
[    4.717658] sd 0:0:0:206: [sdgy] Mode Sense: 63 00 00 08
[    4.719186] sd 0:0:0:181: [sdfz] Write Protect is off
[    4.726428] sd 0:0:0:181: [sdfz] Mode Sense: 63 00 00 08
[    4.726565] sd 0:0:0:151: [sdev] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.734955] sd 0:0:0:219: [sdhl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.737017] sd 0:0:0:135: [sdef] Write Protect is off
[    4.737825] sd 0:0:0:135: [sdef] Mode Sense: 63 00 00 08
[    4.739089] sd 0:0:0:207: [sdgz] Write Protect is off
[    4.739089] sd 0:0:0:207: [sdgz] Mode Sense: 63 00 00 08
[    4.739089] sd 0:0:0:207: [sdgz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.739089] sd 0:0:0:179: [sdfx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.748697]  sdfx: sdfx1
[    4.750258] sd 0:0:0:179: [sdfx] Attached SCSI disk
[    4.758699] sd 0:0:0:221: [sdhn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.760910] sd 0:0:0:216: [sdhi] Write Protect is off
[    4.775233] sd 0:0:0:216: [sdhi] Mode Sense: 63 00 00 08
[    4.775242]  sded: sded1
[    4.776475] sd 0:0:0:133: [sded] Attached SCSI disk
[    4.777495] sd 0:0:0:222: [sdho] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.778920] sd 0:0:0:223: [sdhp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.780529] sd 0:0:0:208: [sdha] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.782347] sd 0:0:0:171: [sdfp] Write Protect is off
[    4.783041] sd 0:0:0:171: [sdfp] Mode Sense: 63 00 00 08
[    4.783253] sd 0:0:0:171: [sdfp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.786113] sd 0:0:0:212: [sdhe] Write Protect is off
[    4.787168] sd 0:0:0:212: [sdhe] Mode Sense: 63 00 00 08
[    4.788149] sd 0:0:0:213: [sdhf] Write Protect is off
[    4.797225] sd 0:0:0:213: [sdhf] Mode Sense: 63 00 00 08
[    4.797233]  sdeo: sdeo1
[    4.798459] sd 0:0:0:144: [sdeo] Attached SCSI disk
[    4.814236] sd 0:0:0:224: [sdhq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.815428]  sdgk: sdgk1
[    4.816669] sd 0:0:0:192: [sdgk] Attached SCSI disk
[    4.817655] sd 0:0:0:135: [sdef] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.819152] sd 0:0:0:225: [sdhr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.822111] sd 0:0:0:202: [sdgu] Write Protect is off
[    4.831556] sd 0:0:0:202: [sdgu] Mode Sense: 63 00 00 08
[    4.832538] sd 0:0:0:222: [sdho] Write Protect is off
[    4.837716] sd 0:0:0:222: [sdho] Mode Sense: 63 00 00 08
[    4.838699] sd 0:0:0:215: [sdhh] Write Protect is off
[    4.855212] sd 0:0:0:215: [sdhh] Mode Sense: 63 00 00 08
[    4.855221]  sddv: sddv1
[    4.856412] sd 0:0:0:125: [sddv] Attached SCSI disk
[    4.857351] sd 0:0:0:227: [sdht] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.860129] sd 0:0:0:218: [sdhk] Write Protect is off
[    4.874673] sd 0:0:0:218: [sdhk] Mode Sense: 63 00 00 08
[    4.875600] sd 0:0:0:214: [sdhg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.877010]  sdfr: sdfr1
[    4.878493] sd 0:0:0:173: [sdfr] Attached SCSI disk
[    4.880881] sd 0:0:0:228: [sdhu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.882046]  sddz: sddz1
[    4.883267] sd 0:0:0:129: [sddz] Attached SCSI disk
[    4.889935] sd 0:0:0:127: [sddx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.898288]  sdei: sdei1
[    4.899239] sd 0:0:0:138: [sdei] Attached SCSI disk
[    4.900495] sd 0:0:0:217: [sdhj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.902640] sd 0:0:0:221: [sdhn] Write Protect is off
[    4.913230] sd 0:0:0:221: [sdhn] Mode Sense: 63 00 00 08
[    4.913238]  sdfq: sdfq1
[    4.914675] sd 0:0:0:172: [sdfq] Attached SCSI disk
[    4.915863] sd 0:0:0:229: [sdhv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.917413] sd 0:0:0:190: [sdgi] Write Protect is off
[    4.918047] sd 0:0:0:190: [sdgi] Mode Sense: 63 00 00 08
[    4.918202] sd 0:0:0:190: [sdgi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.925917] sd 0:0:0:184: [sdgc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.927157]  sddp: sddp1
[    4.928472] sd 0:0:0:119: [sddp] Attached SCSI disk
[    4.943750]  sdfh: sdfh1
[    4.944946] sd 0:0:0:163: [sdfh] Attached SCSI disk
[    4.945858] sd 0:0:0:230: [sdhw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.947012]  sdfy: sdfy1
[    4.948257] sd 0:0:0:180: [sdfy] Attached SCSI disk
[    4.948907]  sddw: sddw1
[    4.950223] sd 0:0:0:126: [sddw] Attached SCSI disk
[    4.951313] sd 0:0:0:223: [sdhp] Write Protect is off
[    4.951943] sd 0:0:0:223: [sdhp] Mode Sense: 63 00 00 08
[    4.952092] sd 0:0:0:223: [sdhp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.953331]  sdgz: sdgz1
[    4.954584] sd 0:0:0:207: [sdgz] Attached SCSI disk
[    4.963201] sd 0:0:0:224: [sdhq] Write Protect is off
[    4.969583] sd 0:0:0:224: [sdhq] Mode Sense: 63 00 00 08
[    4.970638] sd 0:0:0:220: [sdhm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.972902] sd 0:0:0:225: [sdhr] Write Protect is off
[    4.980428] sd 0:0:0:225: [sdhr] Mode Sense: 63 00 00 08
[    4.980658] sd 0:0:0:233: [sdhz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    4.986148] sd 0:0:0:160: [sdfe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.988330] sd 0:0:0:230: [sdhw] Write Protect is off
[    5.000473] sd 0:0:0:230: [sdhw] Mode Sense: 63 00 00 08
[    5.000629] sd 0:0:0:212: [sdhe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.002109] sd 0:0:0:234: [sdia] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.003631] sd 0:0:0:235: [sdib] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.007369] sd 0:0:0:228: [sdhu] Write Protect is off
[    5.013344] sd 0:0:0:228: [sdhu] Mode Sense: 63 00 00 08
[    5.013478] sd 0:0:0:134: [sdee] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.015666] sd 0:0:0:214: [sdhg] Write Protect is off
[    5.026124] sd 0:0:0:214: [sdhg] Mode Sense: 63 00 00 08
[    5.026969] sd 0:0:0:236: [sdic] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.028330] sd 0:0:0:166: [sdfk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.036522] sd 0:0:0:226: [sdhs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.038675] sd 0:0:0:217: [sdhj] Write Protect is off
[    5.041778] sd 0:0:0:217: [sdhj] Mode Sense: 63 00 00 08
[    5.041787]  sdef: sdef1
[    5.043630] sd 0:0:0:195: [sdgn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.045269] sd 0:0:0:237: [sdid] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.048189] sd 0:0:0:235: [sdib] Write Protect is off
[    5.054937] sd 0:0:0:235: [sdib] Mode Sense: 63 00 00 08
[    5.055082] sd 0:0:0:177: [sdfv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.056529] sd 0:0:0:238: [sdie] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.057722]  sddx: sddx1
[    5.058878] sd 0:0:0:127: [sddx] Attached SCSI disk
[    5.059822] sd 0:0:0:239: [sdif] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.060977]  sddu: sddu1
[    5.062186] sd 0:0:0:124: [sddu] Attached SCSI disk
[    5.062846]  sdfp: sdfp1
[    5.064364] sd 0:0:0:171: [sdfp] Attached SCSI disk
[    5.072426] sd 0:0:0:241: [sdih] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.076057] sd 0:0:0:229: [sdhv] Write Protect is off
[    5.083204] sd 0:0:0:229: [sdhv] Mode Sense: 63 00 00 08
[    5.083440] sd 0:0:0:242: [sdii] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.084808] sd 0:0:0:231: [sdhx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.086196] sd 0:0:0:243: [sdij] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.088322] sd 0:0:0:220: [sdhm] Write Protect is off
[    5.097306] sd 0:0:0:220: [sdhm] Mode Sense: 63 00 00 08
[    5.097538] sd 0:0:0:244: [sdik] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.098915] sd 0:0:0:245: [sdil] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.100285] sd 0:0:0:232: [sdhy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.108779] sd 0:0:0:187: [sdgf] Write Protect is off
[    5.109465] sd 0:0:0:187: [sdgf] Mode Sense: 63 00 00 08
[    5.109631] sd 0:0:0:187: [sdgf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.117740]  sdgc: sdgc1
[    5.118964] sd 0:0:0:184: [sdgc] Attached SCSI disk
[    5.119629]  sdcp: sdcp1
[    5.120742] sd 0:0:0:93: [sdcp] Attached SCSI disk
[    5.131532] sd 0:0:0:246: [sdim] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.132693] sd 0:0:0:188: [sdgg] Write Protect is off
[    5.133444] sd 0:0:0:188: [sdgg] Mode Sense: 63 00 00 08
[    5.133587] sd 0:0:0:188: [sdgg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.134849]  sdfe: sdfe1
[    5.136004] sd 0:0:0:160: [sdfe] Attached SCSI disk
[    5.137699] sd 0:0:0:226: [sdhs] Write Protect is off
[    5.156799] sd 0:0:0:226: [sdhs] Mode Sense: 63 00 00 08
[    5.158224] sd 0:0:0:236: [sdic] Write Protect is off
[    5.169430] sd 0:0:0:236: [sdic] Mode Sense: 63 00 00 08
[    5.169583] sd 0:0:0:211: [sdhd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.171631]  sdhe: sdhe1
[    5.172930] sd 0:0:0:212: [sdhe] Attached SCSI disk
[    5.173592]  sdee: sdee1
[    5.174746] sd 0:0:0:134: [sdee] Attached SCSI disk
[    5.177074] sd 0:0:0:239: [sdif] Write Protect is off
[    5.197182] sd 0:0:0:239: [sdif] Mode Sense: 63 00 00 08
[    5.198155] sd 0:0:0:246: [sdim] Write Protect is off
[    5.202520] sd 0:0:0:246: [sdim] Mode Sense: 63 00 00 08
[    5.203057] sd 0:0:0:105: [sddb] Attached SCSI disk
[    5.204792] sd 0:0:0:241: [sdih] Write Protect is off
[    5.211331] sd 0:0:0:241: [sdih] Mode Sense: 63 00 00 08
[    5.211483] sd 0:0:0:201: [sdgt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.212926] sd 0:0:0:247: [sdin] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.219111] sd 0:0:0:191: [sdgj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.220383] sd 0:0:0:170: [sdfo] Write Protect is off
[    5.221019] sd 0:0:0:170: [sdfo] Mode Sense: 63 00 00 08
[    5.221208] sd 0:0:0:170: [sdfo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.223417] sd 0:0:0:242: [sdii] Write Protect is off
[    5.240412] sd 0:0:0:242: [sdii] Mode Sense: 63 00 00 08
[    5.241392] sd 0:0:0:231: [sdhx] Write Protect is off
[    5.249737] sd 0:0:0:231: [sdhx] Mode Sense: 63 00 00 08
[    5.249888] sd 0:0:0:194: [sdgm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.263749] sd 0:0:0:245: [sdil] Write Protect is off
[    5.275942] sd 0:0:0:245: [sdil] Mode Sense: 63 00 00 08
[    5.275951]  sdhp: sdhp1
[    5.277215] sd 0:0:0:223: [sdhp] Attached SCSI disk
[    5.278261] sd 0:0:0:240: [sdig] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.279708] sd 0:0:0:248: [sdio] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.281064] sd 0:0:0:178: [sdfw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.288859] sd 0:0:0:165: [sdfj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.290217] sd 0:0:0:189: [sdgh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.291479]  sdgn: sdgn1
[    5.292700] sd 0:0:0:195: [sdgn] Attached SCSI disk
[    5.293489]  sdfv: sdfv1
[    5.294682] sd 0:0:0:177: [sdfv] Attached SCSI disk
[    5.296332] sd 0:0:0:204: [sdgw] Write Protect is off
[    5.303595] sd 0:0:0:204: [sdgw] Mode Sense: 63 00 00 08
[    5.334709] sd 0:0:0:249: [sdip] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.336011] sd 0:0:0:137: [sdeh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.338280] sd 0:0:0:250: [sdiq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.339690] sd 0:0:0:251: [sdir] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.341008] sd 0:0:0:206: [sdgy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.343175] sd 0:0:0:252: [sdis] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.344540] sd 0:0:0:253: [sdit] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.345728] sd 0:0:0:227: [sdht] Write Protect is off
[    5.346443] sd 0:0:0:227: [sdht] Mode Sense: 63 00 00 08
[    5.346595] sd 0:0:0:227: [sdht] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.363892] sd 0:0:0:146: [sdeq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.366334] sd 0:0:0:254: [sdiu] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.367809] sd 0:0:0:139: [sdej] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.369038]  sdhd: sdhd1
[    5.370348] sd 0:0:0:211: [sdhd] Attached SCSI disk
[    5.371983] sd 0:0:0:256: [sdiw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.373198]  sdgf: sdgf1
[    5.374489] sd 0:0:0:187: [sdgf] Attached SCSI disk
[    5.376076] sd 0:0:0:257: [sdix] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.378289] sd 0:0:0:240: [sdig] Write Protect is off
[    5.388082] sd 0:0:0:240: [sdig] Mode Sense: 63 00 00 08
[    5.389056] sd 0:0:0:248: [sdio] Write Protect is off
[    5.405876] sd 0:0:0:248: [sdio] Mode Sense: 63 00 00 08
[    5.407472] sd 0:0:0:75: [sdbx] Attached SCSI disk
[    5.409133] sd 0:0:0:142: [sdem] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.410724] sd 0:0:0:168: [sdfm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.412142] sd 0:0:0:200: [sdgs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.413535] sd 0:0:0:154: [sdey] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.415499]  sdeh: sdeh1
[    5.416729] sd 0:0:0:137: [sdeh] Attached SCSI disk
[    5.417413]  sdgj: sdgj1
[    5.418704] sd 0:0:0:191: [sdgj] Attached SCSI disk
[    5.419532] sd 0:0:0:217: [sdhj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.420781]  sdgt: sdgt1
[    5.422082] sd 0:0:0:201: [sdgt] Attached SCSI disk
[    5.422769]  sdgg: sdgg1
[    5.424026] sd 0:0:0:188: [sdgg] Attached SCSI disk
[    5.425656] sd 0:0:0:164: [sdfi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.427154] sd 0:0:0:258: [sdiy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.428483] sd 0:0:0:222: [sdho] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.429715]  sdgm: sdgm1
[    5.430980] sd 0:0:0:194: [sdgm] Attached SCSI disk
[    5.431890] sd 0:0:0:259: [sdiz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.433133]  sdfw: sdfw1
[    5.434106] sd 0:0:0:178: [sdfw] Attached SCSI disk
[    5.442775] sd 0:0:0:260: [sdja] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.444965] sd 0:0:0:251: [sdir] Write Protect is off
[    5.454952] sd 0:0:0:251: [sdir] Mode Sense: 63 00 00 08
[    5.456179] sd 0:0:0:261: [sdjb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.462130] sd 0:0:0:254: [sdiu] Write Protect is off
[    5.462934] sd 0:0:0:254: [sdiu] Mode Sense: 63 00 00 08
[    5.487836]  sdgh: sdgh1
[    5.489317] sd 0:0:0:189: [sdgh] Attached SCSI disk
[    5.490179] sd 0:0:0:252: [sdis] Write Protect is off
[    5.500149] sd 0:0:0:252: [sdis] Mode Sense: 63 00 00 08
[    5.501121] sd 0:0:0:253: [sdit] Write Protect is off
[    5.510109] sd 0:0:0:253: [sdit] Mode Sense: 63 00 00 08
[    5.510117]  sdfj: sdfj1
[    5.511409] sd 0:0:0:165: [sdfj] Attached SCSI disk
[    5.512755] sd 0:0:0:209: [sdhb] Write Protect is off
[    5.513636] sd 0:0:0:209: [sdhb] Mode Sense: 63 00 00 08
[    5.514593] sd 0:0:0:258: [sdiy] Write Protect is off
[    5.531869] sd 0:0:0:258: [sdiy] Mode Sense: 63 00 00 08
[    5.536848]  sdfo: sdfo1
[    5.538257] sd 0:0:0:170: [sdfo] Attached SCSI disk
[    5.539898] sd 0:0:0:265: [sdjf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.541216] sd 0:0:0:181: [sdfz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.542458] sd 0:0:0:219: [sdhl] Write Protect is off
[    5.543151] sd 0:0:0:219: [sdhl] Mode Sense: 63 00 00 08
[    5.543300] sd 0:0:0:219: [sdhl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.552294] sd 0:0:0:183: [sdgb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.554478] sd 0:0:0:257: [sdix] Write Protect is off
[    5.570690] sd 0:0:0:257: [sdix] Mode Sense: 63 00 00 08
[    5.571013] sd 0:0:0:266: [sdjg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.572248]  sdgy: sdgy1
[    5.573876] sd 0:0:0:206: [sdgy] Attached SCSI disk
[    5.577364] sd 0:0:0:255: [sdiv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.579407]  sdht: sdht1
[    5.581023]  sdej: sdej1
[    5.582354] sd 0:0:0:139: [sdej] Attached SCSI disk
[    5.583298] sd 0:0:0:268: [sdji] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.585866]  sdeq: sdeq1
[    5.587217] sd 0:0:0:146: [sdeq] Attached SCSI disk
[    5.589154] sd 0:0:0:265: [sdjf] Write Protect is off
[    5.596175] sd 0:0:0:265: [sdjf] Mode Sense: 63 00 00 08
[    5.596328] sd 0:0:0:209: [sdhb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.597810] sd 0:0:0:270: [sdjk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.607076] sd 0:0:0:259: [sdiz] Write Protect is off
[    5.611928] sd 0:0:0:259: [sdiz] Mode Sense: 63 00 00 08
[    5.612911] sd 0:0:0:260: [sdja] Write Protect is off
[    5.612911] sd 0:0:0:260: [sdja] Mode Sense: 63 00 00 08
[    5.612911] sd 0:0:0:260: [sdja] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.618417]  sdev: sdev1
[    5.619747] sd 0:0:0:151: [sdev] Attached SCSI disk
[    5.620707] sd 0:0:0:271: [sdjl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.622143] sd 0:0:0:272: [sdjm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.623582] sd 0:0:0:273: [sdjn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.624964] sd 0:0:0:274: [sdjo] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.626131]  sdfm: sdfm1
[    5.627384] sd 0:0:0:168: [sdfm] Attached SCSI disk
[    5.628146] sd 0:0:0:276: [sdjq] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.629680] sd 0:0:0:277: [sdjr] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.630847]  sdem: sdem1
[    5.632048] sd 0:0:0:142: [sdem] Attached SCSI disk
[    5.632900] sd 0:0:0:162: [sdfg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.634139]  sdgs: sdgs1
[    5.635447] sd 0:0:0:200: [sdgs] Attached SCSI disk
[    5.642755]  sdhj: sdhj1
[    5.644173] sd 0:0:0:217: [sdhj] Attached SCSI disk
[    5.645656] sd 0:0:0:227: [sdht] Attached SCSI disk
[    5.646464]  sdfi: sdfi1
[    5.647889] sd 0:0:0:164: [sdfi] Attached SCSI disk
[    5.650025]  sdho: sdho1
[    5.651504] sd 0:0:0:222: [sdho] Attached SCSI disk
[    5.652908] sd 0:0:0:279: [sdjt] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.654206] sd 0:0:0:198: [sdgq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.655599] sd 0:0:0:246: [sdim] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.657056] sd 0:0:0:263: [sdjd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.658452] sd 0:0:0:262: [sdjc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.659749] sd 0:0:0:224: [sdhq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.661000] sd 0:0:0:237: [sdid] Write Protect is off
[    5.661724] sd 0:0:0:237: [sdid] Mode Sense: 63 00 00 08
[    5.661882] sd 0:0:0:237: [sdid] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.664087] sd 0:0:0:266: [sdjg] Write Protect is off
[    5.667742] sd 0:0:0:266: [sdjg] Mode Sense: 63 00 00 08
[    5.667909] sd 0:0:0:228: [sdhu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.669154] sd 0:0:0:120: [sddq] Write Protect is off
[    5.669771] sd 0:0:0:120: [sddq] Mode Sense: 63 00 00 08
[    5.669901] sd 0:0:0:120: [sddq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.671178]  sdja: sdja1
[    5.679505] sd 0:0:0:260: [sdja] Attached SCSI disk
[    5.681153] sd 0:0:0:210: [sdhc] Write Protect is off
[    5.687955] sd 0:0:0:210: [sdhc] Mode Sense: 63 00 00 08
[    5.687963]  sdey: sdey1
[    5.689238] sd 0:0:0:154: [sdey] Attached SCSI disk
[    5.691142] sd 0:0:0:255: [sdiv] Write Protect is off
[    5.699511] sd 0:0:0:255: [sdiv] Mode Sense: 63 00 00 08
[    5.699750] sd 0:0:0:264: [sdje] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.700945]  sdfz: sdfz1
[    5.702287] sd 0:0:0:181: [sdfz] Attached SCSI disk
[    5.704109] sd 0:0:0:268: [sdji] Write Protect is off
[    5.720971] sd 0:0:0:268: [sdji] Mode Sense: 63 00 00 08
[    5.720980] sd 0:0:0:243: [sdij] Write Protect is off
[    5.721672] sd 0:0:0:243: [sdij] Mode Sense: 63 00 00 08
[    5.721834] sd 0:0:0:243: [sdij] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.723808] sd 0:0:0:114: [sddk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.726726] sd 0:0:0:167: [sdfl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.727962]  sdgb: sdgb1
[    5.729196] sd 0:0:0:183: [sdgb] Attached SCSI disk
[    5.730174] sd 0:0:0:279: [sdjt] Write Protect is off
[    5.736028] sd 0:0:0:279: [sdjt] Mode Sense: 63 00 00 08
[    5.736035] sd 0:0:0:238: [sdie] Write Protect is off
[    5.736664] sd 0:0:0:238: [sdie] Mode Sense: 63 00 00 08
[    5.736822] sd 0:0:0:238: [sdie] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.738371] sd 0:0:0:283: [sdjx] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.739742] sd 0:0:0:199: [sdgr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.741946] sd 0:0:0:273: [sdjn] Write Protect is off
[    5.757110] sd 0:0:0:273: [sdjn] Mode Sense: 63 00 00 08
[    5.758091] sd 0:0:0:271: [sdjl] Write Protect is off
[    5.766916] sd 0:0:0:271: [sdjl] Mode Sense: 63 00 00 08
[    5.767155] sd 0:0:0:267: [sdjh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.769360] sd 0:0:0:274: [sdjo] Write Protect is off
[    5.773820] sd 0:0:0:274: [sdjo] Mode Sense: 63 00 00 08
[    5.774803] sd 0:0:0:272: [sdjm] Write Protect is off
[    5.780803] sd 0:0:0:272: [sdjm] Mode Sense: 63 00 00 08
[    5.781061] sd 0:0:0:284: [sdjy] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.783207] sd 0:0:0:276: [sdjq] Write Protect is off
[    5.794911] sd 0:0:0:276: [sdjq] Mode Sense: 63 00 00 08
[    5.795153] sd 0:0:0:269: [sdjj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.803974] sd 0:0:0:235: [sdib] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.805192]  sdhl: sdhl1
[    5.806516] sd 0:0:0:219: [sdhl] Attached SCSI disk
[    5.807454] sd 0:0:0:213: [sdhf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.808821] sd 0:0:0:169: [sdfn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.810038]  sdhb: sdhb1
[    5.811263] sd 0:0:0:209: [sdhb] Attached SCSI disk
[    5.812060] sd 0:0:0:225: [sdhr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.813541] sd 0:0:0:286: [sdka] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.816552] sd 0:0:0:275: [sdjp] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.818685] sd 0:0:0:263: [sdjd] Write Protect is off
[    5.831798] sd 0:0:0:263: [sdjd] Mode Sense: 63 00 00 08
[    5.832068] sd 0:0:0:287: [sdkb] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.843742] sd 0:0:0:288: [sdkc] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.845909] sd 0:0:0:283: [sdjx] Write Protect is off
[    5.845909] sd 0:0:0:283: [sdjx] Mode Sense: 63 00 00 08
[    5.858106]  sdgi: sdgi1
[    5.859393] sd 0:0:0:190: [sdgi] Attached SCSI disk
[    5.860473] sd 0:0:0:290: [sdke] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.870686] sd 0:0:0:291: [sdkf] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.874186] sd 0:0:0:135: [sdef] Attached SCSI disk
[    5.875104] sd 0:0:0:278: [sdjs] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.876270]  sdfg: sdfg1
[    5.877479] sd 0:0:0:162: [sdfg] Attached SCSI disk
[    5.878403] sd 0:0:0:293: [sdkh] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.889841] sd 0:0:0:147: [sder] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.891406] sd 0:0:0:294: [sdki] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.893552] sd 0:0:0:202: [sdgu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.894810]  sdgq: sdgq1
[    5.896012] sd 0:0:0:198: [sdgq] Attached SCSI disk
[    5.896733]  sdim: sdim1
[    5.905445] sd 0:0:0:280: [sdju] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.906820] sd 0:0:0:295: [sdkj] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.913946] sd 0:0:0:296: [sdkk] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.915172] sd 0:0:0:232: [sdhy] Write Protect is off
[    5.915795] sd 0:0:0:232: [sdhy] Mode Sense: 63 00 00 08
[    5.915955] sd 0:0:0:232: [sdhy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.917174]  sdhq: sdhq1
[    5.918437] sd 0:0:0:224: [sdhq] Attached SCSI disk
[    5.920157] sd 0:0:0:267: [sdjh] Write Protect is off
[    5.924370] sd 0:0:0:267: [sdjh] Mode Sense: 63 00 00 08
[    5.925345] sd 0:0:0:284: [sdjy] Write Protect is off
[    5.941951] sd 0:0:0:284: [sdjy] Mode Sense: 63 00 00 08
[    5.941960]  sdfk: sdfk1
[    5.943138] sd 0:0:0:166: [sdfk] Attached SCSI disk
[    5.944955] sd 0:0:0:269: [sdjj] Write Protect is off
[    5.944955] sd 0:0:0:269: [sdjj] Mode Sense: 63 00 00 08
[    5.944955] sd 0:0:0:269: [sdjj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.955283] sd 0:0:0:244: [sdik] Write Protect is off
[    5.955924] sd 0:0:0:244: [sdik] Mode Sense: 63 00 00 08
[    5.956085] sd 0:0:0:244: [sdik] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.957606] sd 0:0:0:281: [sdjv] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.958803]  sddk: sddk1
[    5.959908] sd 0:0:0:114: [sddk] Attached SCSI disk
[    5.960623] sd 0:0:0:208: [sdha] Write Protect is off
[    5.961320] sd 0:0:0:208: [sdha] Mode Sense: 63 00 00 08
[    5.961476] sd 0:0:0:208: [sdha] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.963582] sd 0:0:0:229: [sdhv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    5.968028]  sdhu: sdhu1
[    5.969396] sd 0:0:0:228: [sdhu] Attached SCSI disk
[    5.970337] sd 0:0:0:299: [sdkn] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    5.979771]  sdfl: sdfl1
[    5.980974] sd 0:0:0:167: [sdfl] Attached SCSI disk
[    5.983185] sd 0:0:0:286: [sdka] Write Protect is off
[    5.994558] sd 0:0:0:286: [sdka] Mode Sense: 63 00 00 08
[    6.019864] sd 0:0:0:241: [sdih] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.021085]  sdgr: sdgr1
[    6.022374] sd 0:0:0:199: [sdgr] Attached SCSI disk
[    6.023144]  sddq: sddq1
[    6.024692] sd 0:0:0:120: [sddq] Attached SCSI disk
[    6.025553]  sdid: sdid1
[    6.026823] sd 0:0:0:237: [sdid] Attached SCSI disk
[    6.028547] sd 0:0:0:287: [sdkb] Write Protect is off
[    6.034398] sd 0:0:0:287: [sdkb] Mode Sense: 63 00 00 08
[    6.035370] sd 0:0:0:291: [sdkf] Write Protect is off
[    6.046347] sd 0:0:0:291: [sdkf] Mode Sense: 63 00 00 08
[    6.047322] sd 0:0:0:278: [sdjs] Write Protect is off
[    6.059293] sd 0:0:0:278: [sdjs] Mode Sense: 63 00 00 08
[    6.059540] sd 0:0:0:285: [sdjz] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.060683]  sdij: sdij1
[    6.061975] sd 0:0:0:243: [sdij] Attached SCSI disk
[    6.063762] sd 0:0:0:293: [sdkh] Write Protect is off
[    6.076157] sd 0:0:0:293: [sdkh] Mode Sense: 63 00 00 08
[    6.076165]  sdfn: sdfn1
[    6.077754] sd 0:0:0:169: [sdfn] Attached SCSI disk
[    6.095560] sd 0:0:0:233: [sdhz] Write Protect is off
[    6.096249] sd 0:0:0:233: [sdhz] Mode Sense: 63 00 00 08
[    6.096413] sd 0:0:0:233: [sdhz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.097758]  sdhf: sdhf1
[    6.099007] sd 0:0:0:213: [sdhf] Attached SCSI disk
[    6.099923] sd 0:0:0:289: [sdkd] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.101993]  sdjj: sdjj1
[    6.102995]  sdhr: sdhr1
[    6.113652]  sdie: sdie1
[    6.114980] sd 0:0:0:238: [sdie] Attached SCSI disk
[    6.115939] sd 0:0:0:292: [sdkg] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.119067] sd 0:0:0:280: [sdju] Write Protect is off
[    6.123575] sd 0:0:0:280: [sdju] Mode Sense: 63 00 00 08
[    6.123585]  sdib: sdib1
[    6.124888] sd 0:0:0:235: [sdib] Attached SCSI disk
[    6.134228] sd 0:0:0:296: [sdkk] Write Protect is off
[    6.140207] sd 0:0:0:296: [sdkk] Mode Sense: 63 00 00 08
[    6.140364] sd 0:0:0:221: [sdhn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.141730] sd 0:0:0:234: [sdia] Write Protect is off
[    6.142483] sd 0:0:0:234: [sdia] Mode Sense: 63 00 00 08
[    6.142641] sd 0:0:0:234: [sdia] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.144855] sd 0:0:0:281: [sdjv] Write Protect is off
[    6.152197] sd 0:0:0:281: [sdjv] Mode Sense: 63 00 00 08
[    6.153358] sd 0:0:0:297: [sdkl] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.154569]  sdgu: sdgu1
[    6.155882] sd 0:0:0:202: [sdgu] Attached SCSI disk
[    6.156713] sd 0:0:0:204: [sdgw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.159894]  sder: sder1
[    6.161109] sd 0:0:0:147: [sder] Attached SCSI disk
[    6.168632] sd 0:0:0:220: [sdhm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.170621] sd 0:0:0:225: [sdhr] Attached SCSI disk
[    6.172347] sd 0:0:0:185: [sdgd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.174628] sd 0:0:0:269: [sdjj] Attached SCSI disk
[    6.176476] sd 0:0:0:285: [sdjz] Write Protect is off
[    6.186884] sd 0:0:0:285: [sdjz] Mode Sense: 63 00 00 08
[    6.187781] sd 0:0:0:203: [sdgv] Write Protect is off
[    6.188601] sd 0:0:0:203: [sdgv] Mode Sense: 63 00 00 08
[    6.188851] sd 0:0:0:298: [sdkm] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.190690]  sdhv: sdhv1
[    6.191984] sd 0:0:0:229: [sdhv] Attached SCSI disk
[    6.192833] sd 0:0:0:214: [sdhg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.195042] sd 0:0:0:289: [sdkd] Write Protect is off
[    6.207472] sd 0:0:0:289: [sdkd] Mode Sense: 63 00 00 08
[    6.207644] sd 0:0:0:266: [sdjg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.208992] sd 0:0:0:254: [sdiu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.211181] sd 0:0:0:292: [sdkg] Write Protect is off
[    6.219403] sd 0:0:0:292: [sdkg] Mode Sense: 63 00 00 08
[    6.219561] sd 0:0:0:231: [sdhx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.220842]  sdhy: sdhy1
[    6.222163] sd 0:0:0:232: [sdhy] Attached SCSI disk
[    6.222816]  sdih: sdih1
[    6.224236] sd 0:0:0:241: [sdih] Attached SCSI disk
[    6.225018] sd 0:0:0:259: [sdiz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.226952]  sdha: sdha1
[    6.228327] sd 0:0:0:208: [sdha] Attached SCSI disk
[    6.228970]  sdik: sdik1
[    6.230441] sd 0:0:0:244: [sdik] Attached SCSI disk
[    6.233111] sd 0:0:0:203: [sdgv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.254524]  sdhn: sdhn1
[    6.255752] sd 0:0:0:221: [sdhn] Attached SCSI disk
[    6.257420] sd 0:0:0:216: [sdhi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.259635] sd 0:0:0:298: [sdkm] Write Protect is off
[    6.259635] sd 0:0:0:298: [sdkm] Mode Sense: 63 00 00 08
[    6.259635] sd 0:0:0:298: [sdkm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.259635] sd 0:0:0:256: [sdiw] Write Protect is off
[    6.259635] sd 0:0:0:256: [sdiw] Mode Sense: 63 00 00 08
[    6.259635] sd 0:0:0:256: [sdiw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.259635] sd 0:0:0:230: [sdhw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.270203]  sdiw: sdiw1
[    6.271583] sd 0:0:0:256: [sdiw] Attached SCSI disk
[    6.279081]  sdhg: sdhg1
[    6.280053] sd 0:0:0:214: [sdhg] Attached SCSI disk
[    6.280053]  sdft: sdft1
[    6.280053] sd 0:0:0:175: [sdft] Attached SCSI disk
[    6.280053]  sdhz: sdhz1
[    6.280053] sd 0:0:0:233: [sdhz] Attached SCSI disk
[    6.286076]  sdgd: sdgd1
[    6.287344] sd 0:0:0:185: [sdgd] Attached SCSI disk
[    6.287975]  sdiu: sdiu1
[    6.289444] sd 0:0:0:254: [sdiu] Attached SCSI disk
[    6.290450] sd 0:0:0:274: [sdjo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.292687]  sdgw: sdgw1
[    6.293986] sd 0:0:0:204: [sdgw] Attached SCSI disk
[    6.296098]  sdia: sdia1
[    6.297358] sd 0:0:0:234: [sdia] Attached SCSI disk
[    6.297986] sd 0:0:0:205: [sdgx] Write Protect is off
[    6.298660] sd 0:0:0:205: [sdgx] Mode Sense: 63 00 00 08
[    6.298803] sd 0:0:0:205: [sdgx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.300192] sd 0:0:0:265: [sdjf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.301587] sd 0:0:0:279: [sdjt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.315603] sd 0:0:0:270: [sdjk] Write Protect is off
[    6.316316] sd 0:0:0:270: [sdjk] Mode Sense: 63 00 00 08
[    6.316494] sd 0:0:0:236: [sdic] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.317717]  sdkm: sdkm1
[    6.319166] sd 0:0:0:298: [sdkm] Attached SCSI disk
[    6.319988] sd 0:0:0:218: [sdhk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.322200] sd 0:0:0:295: [sdkj] Write Protect is off
[    6.330146] sd 0:0:0:295: [sdkj] Mode Sense: 63 00 00 08
[    6.330154]  sdiz: sdiz1
[    6.331520] sd 0:0:0:259: [sdiz] Attached SCSI disk
[    6.332252]  sdhx: sdhx1
[    6.333577] sd 0:0:0:231: [sdhx] Attached SCSI disk
[    6.335096]  sdgv: sdgv1
[    6.336382] sd 0:0:0:203: [sdgv] Attached SCSI disk
[    6.337299] sd 0:0:0:193: [sdgl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.338695] sd 0:0:0:267: [sdjh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.339934] sd 0:0:0:277: [sdjr] Write Protect is off
[    6.340634] sd 0:0:0:277: [sdjr] Mode Sense: 63 00 00 08
[    6.340797] sd 0:0:0:277: [sdjr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.342937] sd 0:0:0:272: [sdjm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.344384] sd 0:0:0:240: [sdig] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.351998] sd 0:0:0:210: [sdhc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.357525] sd 0:0:0:253: [sdit] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.358806] sd 0:0:0:247: [sdin] Write Protect is off
[    6.359569] sd 0:0:0:247: [sdin] Mode Sense: 63 00 00 08
[    6.361569]  sdhi: sdhi1
[    6.362601] sd 0:0:0:252: [sdis] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.366130] sd 0:0:0:196: [sdgo] Write Protect is off
[    6.379021] sd 0:0:0:196: [sdgo] Mode Sense: 63 00 00 08
[    6.379029]  sdjo: sdjo1
[    6.380495] sd 0:0:0:274: [sdjo] Attached SCSI disk
[    6.389012] sd 0:0:0:251: [sdir] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.390640] sd 0:0:0:247: [sdin] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.392340] sd 0:0:0:245: [sdil] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.394600] sd 0:0:0:215: [sdhh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.396873]  sdjf: sdjf1
[    6.398390] sd 0:0:0:265: [sdjf] Attached SCSI disk
[    6.399806] sd 0:0:0:216: [sdhi] Attached SCSI disk
[    6.400497]  sdic: sdic1
[    6.401818] sd 0:0:0:236: [sdic] Attached SCSI disk
[    6.402525]  sdjt: sdjt1
[    6.403964] sd 0:0:0:279: [sdjt] Attached SCSI disk
[    6.404635]  sdhk: sdhk1
[    6.405953] sd 0:0:0:218: [sdhk] Attached SCSI disk
[    6.407693] sd 0:0:0:280: [sdju] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.408946]  sdgx: sdgx1
[    6.410298] sd 0:0:0:205: [sdgx] Attached SCSI disk
[    6.412567] sd 0:0:0:246: [sdim] Attached SCSI disk
[    6.413301]  sdgl: sdgl1
[    6.414613] sd 0:0:0:193: [sdgl] Attached SCSI disk
[    6.416067]  sdjh: sdjh1
[    6.423864] sd 0:0:0:287: [sdkb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.425352] sd 0:0:0:255: [sdiv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.440435]  sdjm: sdjm1
[    6.441940] sd 0:0:0:272: [sdjm] Attached SCSI disk
[    6.443420]  sdit: sdit1
[    6.444905] sd 0:0:0:253: [sdit] Attached SCSI disk
[    6.445723] sd 0:0:0:186: [sdge] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.447777]  sdis: sdis1
[    6.449266] sd 0:0:0:252: [sdis] Attached SCSI disk
[    6.450710]  sdjr: sdjr1
[    6.452230] sd 0:0:0:277: [sdjr] Attached SCSI disk
[    6.461493] sd 0:0:0:296: [sdkk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.463004]  sdil: sdil1
[    6.463785] sd 0:0:0:249: [sdip] Write Protect is off
[    6.464622] sd 0:0:0:249: [sdip] Mode Sense: 63 00 00 08
[    6.464636]  sdir: sdir1
[    6.465996] sd 0:0:0:251: [sdir] Attached SCSI disk
[    6.466704] sd 0:0:0:264: [sdje] Write Protect is off
[    6.467547] sd 0:0:0:264: [sdje] Mode Sense: 63 00 00 08
[    6.468416]  sdin: sdin1
[    6.469885] sd 0:0:0:247: [sdin] Attached SCSI disk
[    6.471419] sd 0:0:0:262: [sdjc] Write Protect is off
[    6.472189] sd 0:0:0:262: [sdjc] Mode Sense: 63 00 00 08
[    6.472353] sd 0:0:0:262: [sdjc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.473554]  sdhh: sdhh1
[    6.474903] sd 0:0:0:215: [sdhh] Attached SCSI disk
[    6.475576]  sdju: sdju1
[    6.476945] sd 0:0:0:280: [sdju] Attached SCSI disk
[    6.479073] sd 0:0:0:245: [sdil] Attached SCSI disk
[    6.479955] sd 0:0:0:249: [sdip] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.481910] sd 0:0:0:264: [sdje] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.483205]  sdiv: sdiv1
[    6.484606] sd 0:0:0:255: [sdiv] Attached SCSI disk
[    6.485268]  sdkb: sdkb1
[    6.486713] sd 0:0:0:287: [sdkb] Attached SCSI disk
[    6.487564] sd 0:0:0:281: [sdjv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.496481] sd 0:0:0:299: [sdkn] Write Protect is off
[    6.497188] sd 0:0:0:299: [sdkn] Mode Sense: 63 00 00 08
[    6.497195]  sdge: sdge1
[    6.498533] sd 0:0:0:186: [sdge] Attached SCSI disk
[    6.499335]  sdhm: sdhm1
[    6.500763] sd 0:0:0:220: [sdhm] Attached SCSI disk
[    6.502337] sd 0:0:0:282: [sdjw] 819200 512-byte logical blocks: (419 MB/400 MiB)
[    6.504438]  sdip: sdip1
[    6.505806] sd 0:0:0:249: [sdip] Attached SCSI disk
[    6.506524] sd 0:0:0:261: [sdjb] Write Protect is off
[    6.507194] sd 0:0:0:261: [sdjb] Mode Sense: 63 00 00 08
[    6.507356] sd 0:0:0:261: [sdjb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.508562]  sdkk: sdkk1
[    6.510035] sd 0:0:0:296: [sdkk] Attached SCSI disk
[    6.513629] sd 0:0:0:242: [sdii] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.515947] sd 0:0:0:276: [sdjq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.517162] sd 0:0:0:275: [sdjp] Write Protect is off
[    6.517785] sd 0:0:0:275: [sdjp] Mode Sense: 63 00 00 08
[    6.517954] sd 0:0:0:275: [sdjp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.519334] sd 0:0:0:299: [sdkn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.521537] sd 0:0:0:282: [sdjw] Write Protect is off
[    6.545633] sd 0:0:0:282: [sdjw] Mode Sense: 63 00 00 08
[    6.545817] sd 0:0:0:292: [sdkg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.547046]  sdhc: sdhc1
[    6.548410] sd 0:0:0:210: [sdhc] Attached SCSI disk
[    6.549062]  sdjc: sdjc1
[    6.550550] sd 0:0:0:262: [sdjc] Attached SCSI disk
[    6.551309]  sdjv: sdjv1
[    6.552863] sd 0:0:0:281: [sdjv] Attached SCSI disk
[    6.553552]  sdje: sdje1
[    6.554955] sd 0:0:0:264: [sdje] Attached SCSI disk
[    6.555639] sd 0:0:0:283: [sdjx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.557033] sd 0:0:0:286: [sdka] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.558401] sd 0:0:0:226: [sdhs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.559633] sd 0:0:0:159: [sdfd] Write Protect is off
[    6.560321] sd 0:0:0:159: [sdfd] Mode Sense: 63 00 00 08
[    6.560464] sd 0:0:0:159: [sdfd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.561847] sd 0:0:0:291: [sdkf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.563388] sd 0:0:0:248: [sdio] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.568349] sd 0:0:0:263: [sdjd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.572894]  sdii: sdii1
[    6.580487] sd 0:0:0:257: [sdix] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.581999] sd 0:0:0:285: [sdjz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.583266]  sdjq: sdjq1
[    6.584709] sd 0:0:0:276: [sdjq] Attached SCSI disk
[    6.585570] sd 0:0:0:295: [sdkj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.586823]  sdkn: sdkn1
[    6.588358] sd 0:0:0:299: [sdkn] Attached SCSI disk
[    6.589161] sd 0:0:0:278: [sdjs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.592400] sd 0:0:0:239: [sdif] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.593835]  sdjb: sdjb1
[    6.595460] sd 0:0:0:261: [sdjb] Attached SCSI disk
[    6.596131]  sdig: sdig1
[    6.597502] sd 0:0:0:240: [sdig] Attached SCSI disk
[    6.598201]  sdkg: sdkg1
[    6.599659] sd 0:0:0:292: [sdkg] Attached SCSI disk
[    6.602014]  sdjp: sdjp1
[    6.603523] sd 0:0:0:275: [sdjp] Attached SCSI disk
[    6.604360] sd 0:0:0:258: [sdiy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.605729] sd 0:0:0:293: [sdkh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.606960]  sdjx: sdjx1
[    6.608404] sd 0:0:0:283: [sdjx] Attached SCSI disk
[    6.610087]  sdhs: sdhs1
[    6.617369]  sdhw: sdhw1
[    6.618973] sd 0:0:0:230: [sdhw] Attached SCSI disk
[    6.620619] sd 0:0:0:273: [sdjn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.621956] sd 0:0:0:288: [sdkc] Write Protect is off
[    6.622675] sd 0:0:0:288: [sdkc] Mode Sense: 63 00 00 08
[    6.622845] sd 0:0:0:288: [sdkc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.624090]  sdio: sdio1
[    6.625487] sd 0:0:0:248: [sdio] Attached SCSI disk
[    6.626172]  sdka: sdka1
[    6.627588] sd 0:0:0:286: [sdka] Attached SCSI disk
[    6.629555] sd 0:0:0:267: [sdjh] Attached SCSI disk
[    6.631018]  sdkf: sdkf1
[    6.632543] sd 0:0:0:291: [sdkf] Attached SCSI disk
[    6.633294] sd 0:0:0:271: [sdjl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.636256]  sdfd: sdfd1
[    6.637596] sd 0:0:0:159: [sdfd] Attached SCSI disk
[    6.638275]  sdjd: sdjd1
[    6.639689] sd 0:0:0:263: [sdjd] Attached SCSI disk
[    6.642747]  sdix: sdix1
[    6.644264] sd 0:0:0:257: [sdix] Attached SCSI disk
[    6.644883] sd 0:0:0:297: [sdkl] Write Protect is off
[    6.645578] sd 0:0:0:297: [sdkl] Mode Sense: 63 00 00 08
[    6.645748] sd 0:0:0:297: [sdkl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.653518]  sdjz: sdjz1
[    6.658904] sd 0:0:0:289: [sdkd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.660181]  sdkj: sdkj1
[    6.661699] sd 0:0:0:295: [sdkj] Attached SCSI disk
[    6.662388]  sdjs: sdjs1
[    6.663988] sd 0:0:0:278: [sdjs] Attached SCSI disk
[    6.665694] sd 0:0:0:268: [sdji] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.667032]  sdiy: sdiy1
[    6.668502] sd 0:0:0:258: [sdiy] Attached SCSI disk
[    6.669989]  sdif: sdif1
[    6.671528] sd 0:0:0:239: [sdif] Attached SCSI disk
[    6.672238]  sdkh: sdkh1
[    6.673694] sd 0:0:0:293: [sdkh] Attached SCSI disk
[    6.675602]  sdjn: sdjn1
[    6.677078] sd 0:0:0:273: [sdjn] Attached SCSI disk
[    6.677796]  sdjl: sdjl1
[    6.679221] sd 0:0:0:271: [sdjl] Attached SCSI disk
[    6.680749]  sdjg: sdjg1
[    6.688660] sd 0:0:0:270: [sdjk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.690106] sd 0:0:0:284: [sdjy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.692250]  sdkc: sdkc1
[    6.693230] sd 0:0:0:288: [sdkc] Attached SCSI disk
[    6.694409] sd 0:0:0:294: [sdki] Write Protect is off
[    6.695040] sd 0:0:0:294: [sdki] Mode Sense: 63 00 00 08
[    6.695198]  sdkd: sdkd1
[    6.696618] sd 0:0:0:289: [sdkd] Attached SCSI disk
[    6.697294]  sdji: sdji1
[    6.698716] sd 0:0:0:268: [sdji] Attached SCSI disk
[    6.700397] sd 0:0:0:294: [sdki] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.702449]  sdjk: sdjk1
[    6.703914] sd 0:0:0:270: [sdjk] Attached SCSI disk
[    6.704715] sd 0:0:0:196: [sdgo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.705948]  sdjy: sdjy1
[    6.707427] sd 0:0:0:284: [sdjy] Attached SCSI disk
[    6.708912] sd 0:0:0:250: [sdiq] Write Protect is off
[    6.709629] sd 0:0:0:250: [sdiq] Mode Sense: 63 00 00 08
[    6.709789] sd 0:0:0:250: [sdiq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.711316] sd 0:0:0:242: [sdii] Attached SCSI disk
[    6.711932]  sdki: sdki1
[    6.713424] sd 0:0:0:294: [sdki] Attached SCSI disk
[    6.714902] sd 0:0:0:285: [sdjz] Attached SCSI disk
[    6.716319] sd 0:0:0:290: [sdke] Write Protect is off
[    6.716991] sd 0:0:0:290: [sdke] Mode Sense: 63 00 00 08
[    6.717236] sd 0:0:0:290: [sdke] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.725209]  sdgo: sdgo1
[    6.726525] sd 0:0:0:196: [sdgo] Attached SCSI disk
[    6.727905] sd 0:0:0:226: [sdhs] Attached SCSI disk
[    6.729862]  sdiq: sdiq1
[    6.731285] sd 0:0:0:250: [sdiq] Attached SCSI disk
[    6.732639]  sdkl: sdkl1
[    6.733283] sd 0:0:0:266: [sdjg] Attached SCSI disk
[    6.734765] sd 0:0:0:297: [sdkl] Attached SCSI disk
[    6.736478] sd 0:0:0:282: [sdjw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    6.737784]  sdke: sdke1
[    6.739188] sd 0:0:0:290: [sdke] Attached SCSI disk
[    6.740819]  sdjw: sdjw1
[    6.742258] sd 0:0:0:282: [sdjw] Attached SCSI disk
[    6.744194] Freeing unused kernel memory: 704k freed
[    6.744952] Write protecting the kernel read-only data: 10240k
[    6.750206] Freeing unused kernel memory: 1364k freed
[    6.754156] Freeing unused kernel memory: 1904k freed
[    6.771615] dracut: dracut-004-256.el6
[    6.776638] dracut: rd_NO_LUKS: removing cryptoluks activation
[    6.778189] dracut: rd_NO_LVM: removing LVM activation
[    6.787201] udev: starting version 147
[    6.787852] udevd (168): /proc/168/oom_adj is deprecated, please use /proc/168/oom_score_adj instead.
[    6.952675] dracut: Starting plymouth daemon
[    7.030936] dracut: rd_NO_DM: removing DM RAID activation
[    7.032732] dracut: rd_NO_MD: removing MD RAID activation
[    7.152085] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    7.152828] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.156995] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   42.212271] EXT4-fs (vda1): INFO: recovery required on readonly filesystem
[   42.213000] EXT4-fs (vda1): write access will be enabled during recovery
[   44.764385] EXT4-fs (vda1): orphan cleanup on readonly fs
[   44.765053] EXT4-fs (vda1): ext4_orphan_cleanup: deleting unreferenced inode 1064015
[   44.765137] EXT4-fs (vda1): 1 orphan inode deleted
[   44.765762] EXT4-fs (vda1): recovery complete
[   44.856124] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[   44.893788] dracut: Mounted root filesystem /dev/vda1
[   45.133355] dracut: /sbin/load_policy: Can't load policy: No such device
[   45.163059] dracut: Switching root
[   46.400627] udev: starting version 147
[   46.546441] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[   46.640201] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   46.640889] sd 0:0:0:1: Attached scsi generic sg1 type 0
[   46.641611] sd 0:0:0:2: Attached scsi generic sg2 type 0
[   46.642335] sd 0:0:0:3: Attached scsi generic sg3 type 0
[   46.643008] sd 0:0:0:4: Attached scsi generic sg4 type 0
[   46.643722] sd 0:0:0:5: Attached scsi generic sg5 type 0
[   46.647128] sd 0:0:0:6: Attached scsi generic sg6 type 0
[   46.647818] sd 0:0:0:7: Attached scsi generic sg7 type 0
[   46.651154] sd 0:0:0:8: Attached scsi generic sg8 type 0
[   46.652094] sd 0:0:0:9: Attached scsi generic sg9 type 0
[   46.653117] sd 0:0:0:10: Attached scsi generic sg10 type 0
[   46.655481] sd 0:0:0:11: Attached scsi generic sg11 type 0
[   46.660168] sd 0:0:0:12: Attached scsi generic sg12 type 0
[   46.662019] sd 0:0:0:13: Attached scsi generic sg13 type 0
[   46.663038] sd 0:0:0:14: Attached scsi generic sg14 type 0
[   46.667125] sd 0:0:0:15: Attached scsi generic sg15 type 0
[   46.667818] sd 0:0:0:16: Attached scsi generic sg16 type 0
[   46.670282] sd 0:0:0:17: Attached scsi generic sg17 type 0
[   46.671409] sd 0:0:0:18: Attached scsi generic sg18 type 0
[   46.675220] sd 0:0:0:19: Attached scsi generic sg19 type 0
[   46.676224] sd 0:0:0:20: Attached scsi generic sg20 type 0
[   46.678128] sd 0:0:0:21: Attached scsi generic sg21 type 0
[   46.680309] sd 0:0:0:22: Attached scsi generic sg22 type 0
[   46.682193] sd 0:0:0:23: Attached scsi generic sg23 type 0
[   46.684580] sd 0:0:0:24: Attached scsi generic sg24 type 0
[   46.704399] sd 0:0:0:25: Attached scsi generic sg25 type 0
[   46.705575] sd 0:0:0:26: Attached scsi generic sg26 type 0
[   46.707695] sd 0:0:0:27: Attached scsi generic sg27 type 0
[   46.713330] sd 0:0:0:28: Attached scsi generic sg28 type 0
[   46.715715] sd 0:0:0:29: Attached scsi generic sg29 type 0
[   46.717957] sd 0:0:0:30: Attached scsi generic sg30 type 0
[   46.720592] sd 0:0:0:31: Attached scsi generic sg31 type 0
[   46.724496] sd 0:0:0:32: Attached scsi generic sg32 type 0
[   46.728336] sd 0:0:0:33: Attached scsi generic sg33 type 0
[   46.730412] sd 0:0:0:34: Attached scsi generic sg34 type 0
[   46.733302] sd 0:0:0:35: Attached scsi generic sg35 type 0
[   46.736704] sd 0:0:0:36: Attached scsi generic sg36 type 0
[   46.738005] sd 0:0:0:37: Attached scsi generic sg37 type 0
[   46.740497] sd 0:0:0:38: Attached scsi generic sg38 type 0
[   46.749574] sd 0:0:0:39: Attached scsi generic sg39 type 0
[   46.752490] sd 0:0:0:40: Attached scsi generic sg40 type 0
[   46.789597] sd 0:0:0:41: Attached scsi generic sg41 type 0
[   46.796760] sd 0:0:0:42: Attached scsi generic sg42 type 0
[   46.803900] sd 0:0:0:43: Attached scsi generic sg43 type 0
[   46.817670] sd 0:0:0:44: Attached scsi generic sg44 type 0
[   46.825892] sd 0:0:0:45: Attached scsi generic sg45 type 0
[   46.833990] sd 0:0:0:46: Attached scsi generic sg46 type 0
[   46.845741] sd 0:0:0:47: Attached scsi generic sg47 type 0
[   46.855650] sd 0:0:0:48: Attached scsi generic sg48 type 0
[   46.864723] sd 0:0:0:49: Attached scsi generic sg49 type 0
[   46.876638] sd 0:0:0:50: Attached scsi generic sg50 type 0
[   46.890371] sd 0:0:0:51: Attached scsi generic sg51 type 0
[   46.901964] sd 0:0:0:52: Attached scsi generic sg52 type 0
[   46.912699] sd 0:0:0:53: Attached scsi generic sg53 type 0
[   46.928610] sd 0:0:0:54: Attached scsi generic sg54 type 0
[   46.937745] sd 0:0:0:55: Attached scsi generic sg55 type 0
[   46.954253] sd 0:0:0:56: Attached scsi generic sg56 type 0
[   46.966760] sd 0:0:0:57: Attached scsi generic sg57 type 0
[   46.978247] sd 0:0:0:58: Attached scsi generic sg58 type 0
[   46.992418] sd 0:0:0:59: Attached scsi generic sg59 type 0
[   47.002896] sd 0:0:0:60: Attached scsi generic sg60 type 0
[   47.022736] sd 0:0:0:61: Attached scsi generic sg61 type 0
[   47.035323] sd 0:0:0:62: Attached scsi generic sg62 type 0
[   47.052593] sd 0:0:0:63: Attached scsi generic sg63 type 0
[   47.063218] sd 0:0:0:64: Attached scsi generic sg64 type 0
[   47.075616] sd 0:0:0:65: Attached scsi generic sg65 type 0
[   47.086963] sd 0:0:0:66: Attached scsi generic sg66 type 0
[   47.095836] sd 0:0:0:67: Attached scsi generic sg67 type 0
[   47.100196] sd 0:0:0:68: Attached scsi generic sg68 type 0
[   47.100196] sd 0:0:0:69: Attached scsi generic sg69 type 0
[   47.100196] sd 0:0:0:70: Attached scsi generic sg70 type 0
[   47.100196] sd 0:0:0:71: Attached scsi generic sg71 type 0
[   47.100196] sd 0:0:0:72: Attached scsi generic sg72 type 0
[   47.100196] sd 0:0:0:73: Attached scsi generic sg73 type 0
[   47.100196] sd 0:0:0:74: Attached scsi generic sg74 type 0
[   47.100196] sd 0:0:0:75: Attached scsi generic sg75 type 0
[   47.100196] sd 0:0:0:76: Attached scsi generic sg76 type 0
[   47.100196] sd 0:0:0:77: Attached scsi generic sg77 type 0
[   47.100196] sd 0:0:0:78: Attached scsi generic sg78 type 0
[   47.201119] sd 0:0:0:79: Attached scsi generic sg79 type 0
[   47.209817] sd 0:0:0:80: Attached scsi generic sg80 type 0
[   47.219853] sd 0:0:0:81: Attached scsi generic sg81 type 0
[   47.227342] sd 0:0:0:82: Attached scsi generic sg82 type 0
[   47.288413] sd 0:0:0:83: Attached scsi generic sg83 type 0
[   47.294715] sd 0:0:0:84: Attached scsi generic sg84 type 0
[   47.303687] sd 0:0:0:85: Attached scsi generic sg85 type 0
[   47.313253] sd 0:0:0:86: Attached scsi generic sg86 type 0
[   47.318755] sd 0:0:0:87: Attached scsi generic sg87 type 0
[   47.326049] sd 0:0:0:88: Attached scsi generic sg88 type 0
[   47.380368] sd 0:0:0:89: Attached scsi generic sg89 type 0
[   47.388561] sd 0:0:0:90: Attached scsi generic sg90 type 0
[   47.396999] sd 0:0:0:91: Attached scsi generic sg91 type 0
[   47.406321] sd 0:0:0:92: Attached scsi generic sg92 type 0
[   47.412691] sd 0:0:0:93: Attached scsi generic sg93 type 0
[   47.423416] sd 0:0:0:94: Attached scsi generic sg94 type 0
[   47.429345] sd 0:0:0:95: Attached scsi generic sg95 type 0
[   47.439318] sd 0:0:0:96: Attached scsi generic sg96 type 0
[   47.447079] sd 0:0:0:97: Attached scsi generic sg97 type 0
[   47.460666] sd 0:0:0:98: Attached scsi generic sg98 type 0
[   47.465294] sd 0:0:0:99: Attached scsi generic sg99 type 0
[   47.471911] sd 0:0:0:100: Attached scsi generic sg100 type 0
[   47.477571] sd 0:0:0:101: Attached scsi generic sg101 type 0
[   47.485418] sd 0:0:0:102: Attached scsi generic sg102 type 0
[   47.493285] sd 0:0:0:103: Attached scsi generic sg103 type 0
[   47.504168] sd 0:0:0:104: Attached scsi generic sg104 type 0
[   47.512950] sd 0:0:0:105: Attached scsi generic sg105 type 0
[   47.519320] sd 0:0:0:106: Attached scsi generic sg106 type 0
[   47.524784] sd 0:0:0:107: Attached scsi generic sg107 type 0
[   47.538620] sd 0:0:0:108: Attached scsi generic sg108 type 0
[   47.546670] sd 0:0:0:109: Attached scsi generic sg109 type 0
[   47.551885] sd 0:0:0:110: Attached scsi generic sg110 type 0
[   47.561513] sd 0:0:0:111: Attached scsi generic sg111 type 0
[   47.571243] sd 0:0:0:112: Attached scsi generic sg112 type 0
[   47.580487] sd 0:0:0:113: Attached scsi generic sg113 type 0
[   47.587650] sd 0:0:0:114: Attached scsi generic sg114 type 0
[   47.595630] sd 0:0:0:115: Attached scsi generic sg115 type 0
[   47.608060] sd 0:0:0:116: Attached scsi generic sg116 type 0
[   47.618174] sd 0:0:0:117: Attached scsi generic sg117 type 0
[   47.624488] sd 0:0:0:118: Attached scsi generic sg118 type 0
[   47.640645] sd 0:0:0:119: Attached scsi generic sg119 type 0
[   47.648019] sd 0:0:0:120: Attached scsi generic sg120 type 0
[   47.658274] sd 0:0:0:121: Attached scsi generic sg121 type 0
[   47.663651] sd 0:0:0:122: Attached scsi generic sg122 type 0
[   47.671821] sd 0:0:0:123: Attached scsi generic sg123 type 0
[   47.681508] sd 0:0:0:124: Attached scsi generic sg124 type 0
[   47.691032] sd 0:0:0:125: Attached scsi generic sg125 type 0
[   47.696391] sd 0:0:0:126: Attached scsi generic sg126 type 0
[   47.709452] sd 0:0:0:127: Attached scsi generic sg127 type 0
[   47.715780] sd 0:0:0:128: Attached scsi generic sg128 type 0
[   47.725840] sd 0:0:0:129: Attached scsi generic sg129 type 0
[   47.733240] sd 0:0:0:130: Attached scsi generic sg130 type 0
[   47.744704] sd 0:0:0:131: Attached scsi generic sg131 type 0
[   47.753570] sd 0:0:0:132: Attached scsi generic sg132 type 0
[   47.763288] sd 0:0:0:133: Attached scsi generic sg133 type 0
[   47.774395] sd 0:0:0:134: Attached scsi generic sg134 type 0
[   47.781450] sd 0:0:0:135: Attached scsi generic sg135 type 0
[   47.794051] sd 0:0:0:136: Attached scsi generic sg136 type 0
[   47.802669] sd 0:0:0:137: Attached scsi generic sg137 type 0
[   47.861399] sd 0:0:0:138: Attached scsi generic sg138 type 0
[   47.868387] sd 0:0:0:139: Attached scsi generic sg139 type 0
[   47.883778] sd 0:0:0:140: Attached scsi generic sg140 type 0
[   47.890246] sd 0:0:0:141: Attached scsi generic sg141 type 0
[   47.899988] sd 0:0:0:142: Attached scsi generic sg142 type 0
[   47.909487] sd 0:0:0:143: Attached scsi generic sg143 type 0
[   47.920639] sd 0:0:0:144: Attached scsi generic sg144 type 0
[   47.928264] sd 0:0:0:145: Attached scsi generic sg145 type 0
[   47.935546] sd 0:0:0:146: Attached scsi generic sg146 type 0
[   47.948219] sd 0:0:0:147: Attached scsi generic sg147 type 0
[   47.955832] sd 0:0:0:148: Attached scsi generic sg148 type 0
[   47.965316] sd 0:0:0:149: Attached scsi generic sg149 type 0
[   47.976159] sd 0:0:0:150: Attached scsi generic sg150 type 0
[   47.981722] sd 0:0:0:151: Attached scsi generic sg151 type 0
[   47.993443] sd 0:0:0:152: Attached scsi generic sg152 type 0
[   48.002162] sd 0:0:0:153: Attached scsi generic sg153 type 0
[   48.012062] sd 0:0:0:154: Attached scsi generic sg154 type 0
[   48.025805] sd 0:0:0:155: Attached scsi generic sg155 type 0
[   48.032969] sd 0:0:0:156: Attached scsi generic sg156 type 0
[   48.045151] sd 0:0:0:157: Attached scsi generic sg157 type 0
[   48.049229] sd 0:0:0:158: Attached scsi generic sg158 type 0
[   48.059757] sd 0:0:0:159: Attached scsi generic sg159 type 0
[   48.066202] sd 0:0:0:160: Attached scsi generic sg160 type 0
[   48.079410] sd 0:0:0:161: Attached scsi generic sg161 type 0
[   48.086678] sd 0:0:0:162: Attached scsi generic sg162 type 0
[   48.096627] sd 0:0:0:163: Attached scsi generic sg163 type 0
[   48.104370] sd 0:0:0:164: Attached scsi generic sg164 type 0
[   48.115882] sd 0:0:0:165: Attached scsi generic sg165 type 0
[   48.126454] sd 0:0:0:166: Attached scsi generic sg166 type 0
[   48.134012] sd 0:0:0:167: Attached scsi generic sg167 type 0
[   48.149695] sd 0:0:0:168: Attached scsi generic sg168 type 0
[   48.157353] sd 0:0:0:169: Attached scsi generic sg169 type 0
[   48.168026] sd 0:0:0:170: Attached scsi generic sg170 type 0
[   48.174427] sd 0:0:0:171: Attached scsi generic sg171 type 0
[   48.234680] sd 0:0:0:172: Attached scsi generic sg172 type 0
[   48.249055] sd 0:0:0:173: Attached scsi generic sg173 type 0
[   48.258558] sd 0:0:0:174: Attached scsi generic sg174 type 0
[   48.267962] sd 0:0:0:175: Attached scsi generic sg175 type 0
[   48.270812] sd 0:0:0:176: Attached scsi generic sg176 type 0
[   48.282324] sd 0:0:0:177: Attached scsi generic sg177 type 0
[   48.288895] sd 0:0:0:178: Attached scsi generic sg178 type 0
[   48.297652] sd 0:0:0:179: Attached scsi generic sg179 type 0
[   48.303659] sd 0:0:0:180: Attached scsi generic sg180 type 0
[   48.317039] sd 0:0:0:181: Attached scsi generic sg181 type 0
[   48.324660] sd 0:0:0:182: Attached scsi generic sg182 type 0
[   48.334808] sd 0:0:0:183: Attached scsi generic sg183 type 0
[   48.343139] sd 0:0:0:184: Attached scsi generic sg184 type 0
[   48.354329] sd 0:0:0:185: Attached scsi generic sg185 type 0
[   48.360964] sd 0:0:0:186: Attached scsi generic sg186 type 0
[   48.370295] sd 0:0:0:187: Attached scsi generic sg187 type 0
[   48.384668] sd 0:0:0:188: Attached scsi generic sg188 type 0
[   48.392968] sd 0:0:0:189: Attached scsi generic sg189 type 0
[   48.401947] sd 0:0:0:190: Attached scsi generic sg190 type 0
[   48.408668] sd 0:0:0:191: Attached scsi generic sg191 type 0
[   48.421907] sd 0:0:0:192: Attached scsi generic sg192 type 0
[   48.431587] sd 0:0:0:193: Attached scsi generic sg193 type 0
[   48.437818] sd 0:0:0:194: Attached scsi generic sg194 type 0
[   48.455893] sd 0:0:0:195: Attached scsi generic sg195 type 0
[   48.461865] sd 0:0:0:196: Attached scsi generic sg196 type 0
[   48.470383] sd 0:0:0:197: Attached scsi generic sg197 type 0
[   48.476395] sd 0:0:0:198: Attached scsi generic sg198 type 0
[   48.490219] sd 0:0:0:199: Attached scsi generic sg199 type 0
[   48.496516] sd 0:0:0:200: Attached scsi generic sg200 type 0
[   48.506040] sd 0:0:0:201: Attached scsi generic sg201 type 0
[   48.518781] sd 0:0:0:202: Attached scsi generic sg202 type 0
[   48.524245] sd 0:0:0:203: Attached scsi generic sg203 type 0
[   48.531628] sd 0:0:0:204: Attached scsi generic sg204 type 0
[   48.542362] sd 0:0:0:205: Attached scsi generic sg205 type 0
[   48.555333] sd 0:0:0:206: Attached scsi generic sg206 type 0
[   48.563633] sd 0:0:0:207: Attached scsi generic sg207 type 0
[   48.570731] sd 0:0:0:208: Attached scsi generic sg208 type 0
[   48.580715] sd 0:0:0:209: Attached scsi generic sg209 type 0
[   48.592930] sd 0:0:0:210: Attached scsi generic sg210 type 0
[   48.598749] sd 0:0:0:211: Attached scsi generic sg211 type 0
[   48.609227] sd 0:0:0:212: Attached scsi generic sg212 type 0
[   48.616050] sd 0:0:0:213: Attached scsi generic sg213 type 0
[   48.673420] sd 0:0:0:214: Attached scsi generic sg214 type 0
[   48.682122] sd 0:0:0:215: Attached scsi generic sg215 type 0
[   48.696318] sd 0:0:0:216: Attached scsi generic sg216 type 0
[   48.702104] sd 0:0:0:217: Attached scsi generic sg217 type 0
[   48.710080] sd 0:0:0:218: Attached scsi generic sg218 type 0
[   48.724986] sd 0:0:0:219: Attached scsi generic sg219 type 0
[   48.733487] sd 0:0:0:220: Attached scsi generic sg220 type 0
[   48.742691] sd 0:0:0:221: Attached scsi generic sg221 type 0
[   48.751150] sd 0:0:0:222: Attached scsi generic sg222 type 0
[   48.764501] sd 0:0:0:223: Attached scsi generic sg223 type 0
[   48.771428] sd 0:0:0:224: Attached scsi generic sg224 type 0
[   48.781601] sd 0:0:0:225: Attached scsi generic sg225 type 0
[   48.792493] sd 0:0:0:226: Attached scsi generic sg226 type 0
[   48.801836] sd 0:0:0:227: Attached scsi generic sg227 type 0
[   48.808616] sd 0:0:0:228: Attached scsi generic sg228 type 0
[   48.817122] sd 0:0:0:229: Attached scsi generic sg229 type 0
[   48.833691] sd 0:0:0:230: Attached scsi generic sg230 type 0
[   48.840850] sd 0:0:0:231: Attached scsi generic sg231 type 0
[   48.850253] sd 0:0:0:232: Attached scsi generic sg232 type 0
[   48.860392] sd 0:0:0:233: Attached scsi generic sg233 type 0
[   48.871763] sd 0:0:0:234: Attached scsi generic sg234 type 0
[   48.877952] sd 0:0:0:235: Attached scsi generic sg235 type 0
[   48.887096] sd 0:0:0:236: Attached scsi generic sg236 type 0
[   48.942317] sd 0:0:0:237: Attached scsi generic sg237 type 0
[   48.948971] sd 0:0:0:238: Attached scsi generic sg238 type 0
[   48.964120] sd 0:0:0:239: Attached scsi generic sg239 type 0
[   48.968834] sd 0:0:0:240: Attached scsi generic sg240 type 0
[   48.978645] sd 0:0:0:241: Attached scsi generic sg241 type 0
[   48.985985] sd 0:0:0:242: Attached scsi generic sg242 type 0
[   48.999334] sd 0:0:0:243: Attached scsi generic sg243 type 0
[   49.004650] sd 0:0:0:244: Attached scsi generic sg244 type 0
[   49.015901] sd 0:0:0:245: Attached scsi generic sg245 type 0
[   49.017578] sd 0:0:0:246: Attached scsi generic sg246 type 0
[   49.030715] sd 0:0:0:247: Attached scsi generic sg247 type 0
[   49.040906] sd 0:0:0:248: Attached scsi generic sg248 type 0
[   49.048215] sd 0:0:0:249: Attached scsi generic sg249 type 0
[   49.061676] sd 0:0:0:250: Attached scsi generic sg250 type 0
[   49.067169] sd 0:0:0:251: Attached scsi generic sg251 type 0
[   49.073105] sd 0:0:0:252: Attached scsi generic sg252 type 0
[   49.082986] sd 0:0:0:253: Attached scsi generic sg253 type 0
[   49.090135] sd 0:0:0:254: Attached scsi generic sg254 type 0
[   49.101950] sd 0:0:0:255: Attached scsi generic sg255 type 0
[   49.108534] sd 0:0:0:256: Attached scsi generic sg256 type 0
[   49.118992] sd 0:0:0:257: Attached scsi generic sg257 type 0
[   49.130516] sd 0:0:0:258: Attached scsi generic sg258 type 0
[   49.137210] sd 0:0:0:259: Attached scsi generic sg259 type 0
[   49.146142] sd 0:0:0:260: Attached scsi generic sg260 type 0
[   49.153912] sd 0:0:0:261: Attached scsi generic sg261 type 0
[   49.168298] sd 0:0:0:262: Attached scsi generic sg262 type 0
[   49.174865] sd 0:0:0:263: Attached scsi generic sg263 type 0
[   49.184102] sd 0:0:0:264: Attached scsi generic sg264 type 0
[   49.187240] sd 0:0:0:265: Attached scsi generic sg265 type 0
[   49.202891] sd 0:0:0:266: Attached scsi generic sg266 type 0
[   49.209897] sd 0:0:0:267: Attached scsi generic sg267 type 0
[   49.218358] sd 0:0:0:268: Attached scsi generic sg268 type 0
[   49.280707] sd 0:0:0:269: Attached scsi generic sg269 type 0
[   49.289311] sd 0:0:0:270: Attached scsi generic sg270 type 0
[   49.299122] sd 0:0:0:271: Attached scsi generic sg271 type 0
[   49.308335] sd 0:0:0:272: Attached scsi generic sg272 type 0
[   49.316272] sd 0:0:0:273: Attached scsi generic sg273 type 0
[   49.326760] sd 0:0:0:274: Attached scsi generic sg274 type 0
[   49.337018] sd 0:0:0:275: Attached scsi generic sg275 type 0
[   49.351628] sd 0:0:0:276: Attached scsi generic sg276 type 0
[   49.358220] sd 0:0:0:277: Attached scsi generic sg277 type 0
[   49.367471] sd 0:0:0:278: Attached scsi generic sg278 type 0
[   49.375812] sd 0:0:0:279: Attached scsi generic sg279 type 0
[   49.391906] sd 0:0:0:280: Attached scsi generic sg280 type 0
[   49.401662] sd 0:0:0:281: Attached scsi generic sg281 type 0
[   49.411159] sd 0:0:0:282: Attached scsi generic sg282 type 0
[   49.426426] sd 0:0:0:283: Attached scsi generic sg283 type 0
[   49.433829] sd 0:0:0:284: Attached scsi generic sg284 type 0
[   49.444175] sd 0:0:0:285: Attached scsi generic sg285 type 0
[   49.457344] sd 0:0:0:286: Attached scsi generic sg286 type 0
[   49.468346] sd 0:0:0:287: Attached scsi generic sg287 type 0
[   49.478675] sd 0:0:0:288: Attached scsi generic sg288 type 0
[   49.490370] sd 0:0:0:289: Attached scsi generic sg289 type 0
[   49.497240] sd 0:0:0:290: Attached scsi generic sg290 type 0
[   49.506652] sd 0:0:0:291: Attached scsi generic sg291 type 0
[   49.513758] sd 0:0:0:292: Attached scsi generic sg292 type 0
[   49.528124] sd 0:0:0:293: Attached scsi generic sg293 type 0
[   49.535125] sd 0:0:0:294: Attached scsi generic sg294 type 0
[   49.542161] sd 0:0:0:295: Attached scsi generic sg295 type 0
[   49.551876] sd 0:0:0:296: Attached scsi generic sg296 type 0
[   49.612485] sd 0:0:0:297: Attached scsi generic sg297 type 0
[   49.624535] sd 0:0:0:298: Attached scsi generic sg298 type 0
[   49.635222] sd 0:0:0:299: Attached scsi generic sg299 type 0
[   49.640278] sr 2:0:0:0: Attached scsi generic sg300 type 5
[   56.065337] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   59.785431] EXT4-fs (vda1): re-mounted. Opts: (null)
[   60.138223] Adding 1048572k swap on /dev/vda2.  Priority:-1 extents:1 across:1048572k 
[  132.563878] tun: Universal TUN/TAP device driver, 1.6
[  132.564716] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  132.566221] device virbr0-nic entered promiscuous mode
[  132.657359] device virbr0-nic left promiscuous mode
[  132.658056] virbr0: port 1(virbr0-nic) entering disabled state
[ 7983.922482] hdparm: sending ioctl 330 to a partition!
[ 7983.926972] hdparm: sending ioctl 330 to a partition!
[ 7983.935956] hdparm: sending ioctl 330 to a partition!
[ 7983.936287] hdparm: sending ioctl 330 to a partition!
[ 7983.945779] hdparm: sending ioctl 330 to a partition!
[ 7983.946124] hdparm: sending ioctl 330 to a partition!
[ 7983.955962] hdparm: sending ioctl 330 to a partition!
[ 7983.956296] hdparm: sending ioctl 330 to a partition!
[ 7983.965992] hdparm: sending ioctl 330 to a partition!
[ 7983.966386] hdparm: sending ioctl 330 to a partition!
[ 7988.930310] scsi_verify_blk_ioctl: 590 callbacks suppressed
[ 7988.931184] hdparm: sending ioctl 330 to a partition!
[ 7988.931888] hdparm: sending ioctl 330 to a partition!
[ 8016.635846] sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm@kvack.org.
[ 8696.374497] EXT2-fs (sda1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.412210] EXT2-fs (sdaa1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.443233] EXT2-fs (sdab1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.478727] EXT2-fs (sdac1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.510901] EXT2-fs (sdad1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.549624] EXT2-fs (sdae1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.586131] EXT2-fs (sdaf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.633276] EXT2-fs (sdag1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.669730] EXT2-fs (sdah1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.701485] EXT2-fs (sdai1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.733532] EXT2-fs (sdaj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.768991] EXT2-fs (sdak1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.804885] EXT2-fs (sdal1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.834576] EXT2-fs (sdam1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.863630] EXT2-fs (sdan1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.897460] EXT2-fs (sdao1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.930987] EXT2-fs (sdap1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.962397] EXT2-fs (sdaq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8696.994720] EXT2-fs (sdar1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.022860] EXT2-fs (sdas1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.051649] EXT2-fs (sdat1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.085939] EXT2-fs (sdau1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.121734] EXT2-fs (sdav1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.159621] EXT2-fs (sdaw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.195778] EXT2-fs (sdax1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.229658] EXT2-fs (sday1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.266708] EXT2-fs (sdaz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.295840] EXT2-fs (sdb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.326217] EXT2-fs (sdba1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.358267] EXT2-fs (sdbb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.396901] EXT2-fs (sdbc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.428222] EXT2-fs (sdbd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.460106] EXT2-fs (sdbe1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.491793] EXT2-fs (sdbf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.539523] EXT2-fs (sdbg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.579171] EXT2-fs (sdbh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.606923] EXT2-fs (sdbi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.639598] EXT2-fs (sdbj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.681711] EXT2-fs (sdbk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.717279] EXT2-fs (sdbl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.755515] EXT2-fs (sdbm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.791588] EXT2-fs (sdbn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.823709] EXT2-fs (sdbo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.855658] EXT2-fs (sdbp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.891897] EXT2-fs (sdbq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.946419] EXT2-fs (sdbr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8697.977400] EXT2-fs (sdbs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.009663] EXT2-fs (sdbt1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.044689] EXT2-fs (sdbu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.083533] EXT2-fs (sdbv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.125401] EXT2-fs (sdbw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.160551] EXT2-fs (sdbx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.196757] EXT2-fs (sdby1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.245842] EXT2-fs (sdbz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.279901] EXT2-fs (sdc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.318900] EXT2-fs (sdca1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.354750] EXT2-fs (sdcb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.388994] EXT2-fs (sdcc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.424240] EXT2-fs (sdcd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.456627] EXT2-fs (sdce1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.495174] EXT2-fs (sdcf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.528161] EXT2-fs (sdcg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.567734] EXT2-fs (sdch1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.607799] EXT2-fs (sdci1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.645523] EXT2-fs (sdcj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.680631] EXT2-fs (sdck1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.713584] EXT2-fs (sdcl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.748881] EXT2-fs (sdcm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.796863] EXT2-fs (sdcn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.828724] EXT2-fs (sdco1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.859581] EXT2-fs (sdcp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.899384] EXT2-fs (sdcq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.933189] EXT2-fs (sdcr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8698.969257] EXT2-fs (sdcs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.005092] EXT2-fs (sdct1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.036213] EXT2-fs (sdcu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.072097] EXT2-fs (sdcv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.109837] EXT2-fs (sdcw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.142738] EXT2-fs (sdcx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.184787] EXT2-fs (sdcy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.231383] EXT2-fs (sdcz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.267657] EXT2-fs (sdd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.313487] EXT2-fs (sdda1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.348270] EXT2-fs (sddb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.392526] EXT2-fs (sddc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.427523] EXT2-fs (sddd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.463838] EXT2-fs (sdde1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.508858] EXT2-fs (sddf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.557294] EXT2-fs (sddg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.598138] EXT2-fs (sddh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.636954] EXT2-fs (sddi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.677171] EXT2-fs (sddj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.716421] EXT2-fs (sddk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.754472] EXT2-fs (sddl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.793714] EXT2-fs (sddm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.848822] EXT2-fs (sddn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.886600] EXT2-fs (sddo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.921703] EXT2-fs (sddp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.961084] EXT2-fs (sddq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8699.996388] EXT2-fs (sddr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.038704] EXT2-fs (sdds1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.079911] EXT2-fs (sddt1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.112722] EXT2-fs (sddu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.150561] EXT2-fs (sddv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.191704] EXT2-fs (sddw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.231729] EXT2-fs (sddx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.262841] EXT2-fs (sddy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.302887] EXT2-fs (sddz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.333575] EXT2-fs (sde1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.368130] EXT2-fs (sdea1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.401914] EXT2-fs (sdeb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.437471] EXT2-fs (sdec1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.476239] EXT2-fs (sded1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.506998] EXT2-fs (sdee1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.542666] EXT2-fs (sdef1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.579484] EXT2-fs (sdeg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.638078] EXT2-fs (sdeh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.679792] EXT2-fs (sdei1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.716914] EXT2-fs (sdej1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.752246] EXT2-fs (sdek1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.789890] EXT2-fs (sdel1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.826129] EXT2-fs (sdem1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.865154] EXT2-fs (sden1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.898322] EXT2-fs (sdeo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.936775] EXT2-fs (sdep1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8700.973859] EXT2-fs (sdeq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.007997] EXT2-fs (sder1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.046999] EXT2-fs (sdes1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.082566] EXT2-fs (sdet1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.125530] EXT2-fs (sdeu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.161681] EXT2-fs (sdev1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.197903] EXT2-fs (sdew1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.232555] EXT2-fs (sdex1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.267578] EXT2-fs (sdey1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.300347] EXT2-fs (sdez1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.327988] EXT2-fs (sdf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.369831] EXT2-fs (sdfa1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.416698] EXT2-fs (sdfb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.464851] EXT2-fs (sdfc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.500159] EXT2-fs (sdfd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.539116] EXT2-fs (sdfe1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.570117] EXT2-fs (sdff1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.610290] EXT2-fs (sdfg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.648461] EXT2-fs (sdfh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.681754] EXT2-fs (sdfi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.719188] EXT2-fs (sdfj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.748235] EXT2-fs (sdfk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.781591] EXT2-fs (sdfl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.813936] EXT2-fs (sdfm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.848819] EXT2-fs (sdfn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.886544] EXT2-fs (sdfo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.916918] EXT2-fs (sdfp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.952138] EXT2-fs (sdfq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8701.989538] EXT2-fs (sdfr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.026107] EXT2-fs (sdfs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.062119] EXT2-fs (sdft1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.097531] EXT2-fs (sdfu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.152444] EXT2-fs (sdfv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.175499] EXT2-fs (sdfw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.213076] EXT2-fs (sdfx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.252596] EXT2-fs (sdfy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.291460] EXT2-fs (sdfz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.327882] EXT2-fs (sdg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.360542] EXT2-fs (sdga1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.399486] EXT2-fs (sdgb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.440745] EXT2-fs (sdgc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.483138] EXT2-fs (sdgd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.517005] EXT2-fs (sdge1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.564971] EXT2-fs (sdgf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.604132] EXT2-fs (sdgg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.645777] EXT2-fs (sdgh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.685963] EXT2-fs (sdgi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.725299] EXT2-fs (sdgj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.764129] EXT2-fs (sdgk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.801115] EXT2-fs (sdgl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.836156] EXT2-fs (sdgm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.884648] EXT2-fs (sdgn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.949614] EXT2-fs (sdgo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8702.990847] EXT2-fs (sdgp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.030718] EXT2-fs (sdgq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.068806] EXT2-fs (sdgr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.124380] EXT2-fs (sdgs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.161999] EXT2-fs (sdgt1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.197252] EXT2-fs (sdgu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.235107] EXT2-fs (sdgv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.269000] EXT2-fs (sdgw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.306313] EXT2-fs (sdgx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.342239] EXT2-fs (sdgy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.379261] EXT2-fs (sdgz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.420756] EXT2-fs (sdh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.459843] EXT2-fs (sdha1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.498282] EXT2-fs (sdhb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.537144] EXT2-fs (sdhc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.574846] EXT2-fs (sdhd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.612152] EXT2-fs (sdhe1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.670511] EXT2-fs (sdhf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.711964] EXT2-fs (sdhg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.745870] EXT2-fs (sdhh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.788975] EXT2-fs (sdhi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.838813] EXT2-fs (sdhj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.882740] EXT2-fs (sdhk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.923742] EXT2-fs (sdhl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8703.964352] EXT2-fs (sdhm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.001832] EXT2-fs (sdhn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.040825] EXT2-fs (sdho1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.098666] EXT2-fs (sdhp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.138675] EXT2-fs (sdhq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.182343] EXT2-fs (sdhr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.235234] EXT2-fs (sdhs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.264644] EXT2-fs (sdht1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.310611] EXT2-fs (sdhu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.356111] EXT2-fs (sdhv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.395700] EXT2-fs (sdhw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.440870] EXT2-fs (sdhx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.478960] EXT2-fs (sdhy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.522407] EXT2-fs (sdhz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.567588] EXT2-fs (sdi1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.607343] EXT2-fs (sdia1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.662303] EXT2-fs (sdib1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.701359] EXT2-fs (sdic1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.742453] EXT2-fs (sdid1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.794769] EXT2-fs (sdie1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.826893] EXT2-fs (sdif1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.868902] EXT2-fs (sdig1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.908394] EXT2-fs (sdih1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.961541] EXT2-fs (sdii1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8704.991222] EXT2-fs (sdij1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.028845] EXT2-fs (sdik1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.082243] EXT2-fs (sdil1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.121144] EXT2-fs (sdim1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.165674] EXT2-fs (sdin1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.205876] EXT2-fs (sdio1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.248415] EXT2-fs (sdip1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.289920] EXT2-fs (sdiq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.331538] EXT2-fs (sdir1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.371728] EXT2-fs (sdis1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.413124] EXT2-fs (sdit1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.449066] EXT2-fs (sdiu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.485848] EXT2-fs (sdiv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.536175] EXT2-fs (sdiw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.578904] EXT2-fs (sdix1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.620409] EXT2-fs (sdiy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.674373] EXT2-fs (sdiz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.701695] EXT2-fs (sdj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.753014] EXT2-fs (sdja1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.797497] EXT2-fs (sdjb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.837947] EXT2-fs (sdjc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.873901] EXT2-fs (sdjd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.914108] EXT2-fs (sdje1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.952348] EXT2-fs (sdjf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8705.995698] EXT2-fs (sdjg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.031456] EXT2-fs (sdjh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.070848] EXT2-fs (sdji1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.111137] EXT2-fs (sdjj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.153248] EXT2-fs (sdjk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.200939] EXT2-fs (sdjl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.240008] EXT2-fs (sdjm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.286904] EXT2-fs (sdjn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.345205] EXT2-fs (sdjo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.388108] EXT2-fs (sdjp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.435475] EXT2-fs (sdjq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.469344] EXT2-fs (sdjr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.501305] EXT2-fs (sdjs1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.542073] EXT2-fs (sdjt1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.577157] EXT2-fs (sdju1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.612218] EXT2-fs (sdjv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.658110] EXT2-fs (sdjw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.701393] EXT2-fs (sdjx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.740418] EXT2-fs (sdjy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.792914] EXT2-fs (sdjz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.820698] EXT2-fs (sdk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.862248] EXT2-fs (sdka1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.908383] EXT2-fs (sdkb1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.947948] EXT2-fs (sdkc1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8706.990699] EXT2-fs (sdkd1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.034115] EXT2-fs (sdke1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.083105] EXT2-fs (sdkf1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.127311] EXT2-fs (sdkg1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.174193] EXT2-fs (sdkh1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.217644] EXT2-fs (sdki1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.255611] EXT2-fs (sdkj1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.294403] EXT2-fs (sdkk1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.340325] EXT2-fs (sdkl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.384434] EXT2-fs (sdkm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.451821] EXT2-fs (sdkn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.485685] EXT2-fs (sdl1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.531160] EXT2-fs (sdm1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.565375] EXT2-fs (sdn1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.600208] EXT2-fs (sdo1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.630112] EXT2-fs (sdp1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.664549] EXT2-fs (sdq1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.692919] EXT2-fs (sdr1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.738361] EXT2-fs (sds1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.776257] EXT2-fs (sdt1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.812099] EXT2-fs (sdu1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.847541] EXT2-fs (sdv1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.885381] EXT2-fs (sdw1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.921432] EXT2-fs (sdx1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.952951] EXT2-fs (sdy1): warning: mounting unchecked fs, running e2fsck is recommended
[ 8707.982368] EXT2-fs (sdz1): warning: mounting unchecked fs, running e2fsck is recommended
[ 9480.414236] INFO: task kswapd0:19 blocked for more than 120 seconds.
[ 9480.415316] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9480.416472] kswapd0         D 0000000000000000     0    19      2 0x00000000
[ 9480.417167]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[ 9480.418273]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[ 9480.419390]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[ 9480.420503] Call Trace:
[ 9480.420979]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9480.421590]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9480.422358]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9480.422955]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9480.423570]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9480.424185]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9480.424763]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9480.425414]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9480.425983]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[ 9480.426625]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[ 9480.427254]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[ 9480.427860]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[ 9480.428495]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9480.429131]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9480.429722]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[ 9480.434442]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[ 9480.435082]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[ 9480.435663]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[ 9480.436291]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[ 9480.436886]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9480.437527]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9480.438157]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9480.438716]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[ 9480.439352]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[ 9480.439900]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9480.440510]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[ 9480.441127]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9480.441681]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9480.442326]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9480.442943]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9600.443143] INFO: task kswapd0:19 blocked for more than 120 seconds.
[ 9600.443746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9600.444901] kswapd0         D 0000000000000000     0    19      2 0x00000000
[ 9600.445673]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[ 9600.446807]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[ 9600.447964]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[ 9600.449110] Call Trace:
[ 9600.449601]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9600.450202]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9600.450780]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9600.451434]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9600.452004]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9600.452633]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9600.453273]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9600.453857]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9600.454473]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[ 9600.455123]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[ 9600.455862]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[ 9600.456592]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[ 9600.457223]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9600.457812]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9600.458467]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[ 9600.459135]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[ 9600.459730]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[ 9600.460365]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[ 9600.460946]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[ 9600.461604]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9600.462254]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9600.462839]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9600.463461]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[ 9600.464087]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[ 9600.464651]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9600.465264]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[ 9600.465864]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9600.466468]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9600.467097]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9600.467713]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9720.468139] INFO: task kswapd0:19 blocked for more than 120 seconds.
[ 9720.468758] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9720.469912] kswapd0         D 0000000000000000     0    19      2 0x00000000
[ 9720.470663]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[ 9720.471788]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[ 9720.473151]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[ 9720.474257] Call Trace:
[ 9720.474732]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9720.475363]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9720.475924]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9720.476585]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9720.477206]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9720.477781]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9720.478421]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9720.479012]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9720.479646]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[ 9720.480278]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[ 9720.480836]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[ 9720.481497]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[ 9720.482118]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9720.482703]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9720.483471]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[ 9720.484131]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[ 9720.484718]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[ 9720.485345]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[ 9720.485928]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[ 9720.486576]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9720.487220]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9720.487797]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9720.488411]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[ 9720.488988]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[ 9720.489603]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9720.490213]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[ 9720.490785]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9720.491387]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9720.491972]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9720.492658]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9720.493267] INFO: task flush-65:176:10421 blocked for more than 120 seconds.
[ 9720.493887] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9720.494962] flush-65:176    D 0000000000000000     0 10421      2 0x00000080
[ 9720.495653]  ffff8800318d76f0 0000000000000046 ffff880038c03440 0000000000012000
[ 9720.496762]  ffff8800318d7fd8 ffff8800318d6010 0000000000012000 0000000000012000
[ 9720.497855]  ffff8800318d7fd8 0000000000012000 ffff880038c02aa0 ffff880038c03440
[ 9720.498966] Call Trace:
[ 9720.499486]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9720.500084]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9720.500651]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9720.501274]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9720.501858]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9720.502473]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9720.503091]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9720.503670]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9720.504271]  [<ffffffff810fa853>] ? account_page_writeback+0x13/0x20
[ 9720.505648]  [<ffffffff810fcae9>] ? test_set_page_writeback+0x109/0x190
[ 9720.506329]  [<ffffffff81180b65>] __mpage_writepage+0x585/0x680
[ 9720.506912]  [<ffffffff81280715>] ? radix_tree_gang_lookup_tag_slot+0x95/0xe0
[ 9720.507612]  [<ffffffff810f3110>] ? find_get_pages_tag+0x40/0x130
[ 9720.508263]  [<ffffffff810fba26>] write_cache_pages+0x246/0x510
[ 9720.508847]  [<ffffffff811805e0>] ? mpage_readpages+0x140/0x140
[ 9720.509497]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9720.510129]  [<ffffffff8117fda8>] mpage_writepages+0x68/0xc0
[ 9720.510711]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9720.511367]  [<ffffffff811d9e75>] ext2_writepages+0x15/0x20
[ 9720.511943]  [<ffffffff810fbd91>] do_writepages+0x21/0x40
[ 9720.512576]  [<ffffffff8116de97>] writeback_single_inode+0x177/0x3b0
[ 9720.513227]  [<ffffffff8116e48e>] writeback_sb_inodes+0x19e/0x250
[ 9720.513820]  [<ffffffff8116e5de>] __writeback_inodes_wb+0x9e/0xd0
[ 9720.514463]  [<ffffffff8116e88b>] wb_writeback+0x1eb/0x2c0
[ 9720.515086]  [<ffffffff8116ea04>] wb_do_writeback+0xa4/0x250
[ 9720.515668]  [<ffffffff8116ec5a>] bdi_writeback_thread+0xaa/0x240
[ 9720.516333]  [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
[ 9720.516919]  [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
[ 9720.517559]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9720.518162]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9720.518751]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9720.519434]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9840.520209] INFO: task kswapd0:19 blocked for more than 120 seconds.
[ 9840.520818] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9840.521950] kswapd0         D 0000000000000000     0    19      2 0x00000000
[ 9840.522731]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[ 9840.523844]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[ 9840.524968]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[ 9840.526117] Call Trace:
[ 9840.526589]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9840.527252]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9840.527820]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9840.528468]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9840.529087]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9840.529649]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9840.530271]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9840.532964]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9840.533721]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[ 9840.534409]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[ 9840.534987]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[ 9840.535661]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[ 9840.536355]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9840.536954]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9840.537613]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[ 9840.538280]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[ 9840.538875]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[ 9840.539500]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[ 9840.540183]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[ 9840.540785]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9840.541502]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9840.542134]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9840.542706]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[ 9840.543384]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[ 9840.543995]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9840.544631]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[ 9840.545330]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9840.545922]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9840.546571]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9840.551550]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9960.552165] INFO: task kswapd0:19 blocked for more than 120 seconds.
[ 9960.552775] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9960.553922] kswapd0         D 0000000000000000     0    19      2 0x00000000
[ 9960.554686]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[ 9960.555800]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[ 9960.556897]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[ 9960.558078] Call Trace:
[ 9960.558563]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9960.559160]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9960.559715]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[ 9960.560364]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9960.560940]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[ 9960.561558]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[ 9960.562178]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[ 9960.562755]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[ 9960.563380]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[ 9960.563966]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[ 9960.564593]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[ 9960.565275]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[ 9960.565860]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9960.566489]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[ 9960.567119]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[ 9960.567732]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[ 9960.568391]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[ 9960.568963]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[ 9960.569594]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[ 9960.570234]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9960.570833]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9960.571461]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9960.572070]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[ 9960.572644]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[ 9960.573240]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9960.573803]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[ 9960.574439]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9960.574999]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9960.575632]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9960.576325]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[ 9960.576880] INFO: task khugepaged:21 blocked for more than 120 seconds.
[ 9960.577532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9960.578622] khugepaged      D ffffffff8160ece0     0    21      2 0x00000000
[ 9960.579365]  ffff88003ac5d6b0 0000000000000046 ffff88003ac521c0 0000000000012000
[ 9960.580479]  ffff88003ac5dfd8 ffff88003ac5c010 0000000000012000 0000000000012000
[ 9960.581586]  ffff88003ac5dfd8 0000000000012000 ffffffff81a0d020 ffff88003ac521c0
[ 9960.582672] Call Trace:
[ 9960.583178]  [<ffffffff810f1960>] ? __lock_page+0x70/0x70
[ 9960.583742]  [<ffffffff8149962f>] schedule+0x3f/0x60
[ 9960.584363]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[ 9960.584933]  [<ffffffff810f196e>] sleep_on_page+0xe/0x20
[ 9960.585547]  [<ffffffff81497b8f>] __wait_on_bit+0x5f/0x90
[ 9960.586164]  [<ffffffff810f1bb3>] wait_on_page_bit+0x73/0x80
[ 9960.586739]  [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
[ 9960.587404]  [<ffffffff8128e201>] ? list_del+0x11/0x40
[ 9960.587970]  [<ffffffff81102b85>] shrink_page_list+0x425/0x900
[ 9960.588606]  [<ffffffff81102227>] ? update_isolated_counts+0x127/0x180
[ 9960.589259]  [<ffffffff81104480>] shrink_inactive_list+0x270/0x530
[ 9960.589846]  [<ffffffff81280fbd>] ? rb_insert_color+0x9d/0x160
[ 9960.590474]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[ 9960.591120]  [<ffffffff8106a705>] ? ttwu_do_wakeup+0x45/0x100
[ 9960.591700]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[ 9960.592331]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[ 9960.592890]  [<ffffffff81104eee>] do_try_to_free_pages+0xee/0x580
[ 9960.593521]  [<ffffffff811055fb>] try_to_free_pages+0x9b/0x120
[ 9960.594147]  [<ffffffff810f9c06>] __alloc_pages_nodemask+0x486/0x870
[ 9960.594746]  [<ffffffff8113af9c>] khugepaged+0xac/0x13a0
[ 9960.595367]  [<ffffffff81070d10>] ? __dequeue_entity+0x30/0x50
[ 9960.595947]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[ 9960.596584]  [<ffffffff8113aef0>] ? khugepaged_alloc_sleep+0x150/0x150
[ 9960.597239]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[ 9960.597790]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[ 9960.598437]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[ 9960.599100]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[10080.599145] INFO: task kswapd0:19 blocked for more than 120 seconds.
[10080.599765] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10080.600917] kswapd0         D 0000000000000000     0    19      2 0x00000000
[10080.601679]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[10080.602796]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[10080.603966]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[10080.605119] Call Trace:
[10080.605609]  [<ffffffff8149962f>] schedule+0x3f/0x60
[10080.606258]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[10080.606818]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[10080.607453]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[10080.608091]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[10080.609024]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[10080.609693]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[10080.610360]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[10080.610927]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[10080.611595]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[10080.612204]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[10080.612825]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[10080.613452]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[10080.614099]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[10080.614688]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[10080.615378]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[10080.615967]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[10080.616601]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[10080.617230]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[10080.617821]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[10080.618468]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[10080.619100]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[10080.619660]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[10080.620276]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[10080.620825]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[10080.621563]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[10080.622210]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[10080.622767]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[10080.623408]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[10080.624077]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[10080.624651] INFO: task khugepaged:21 blocked for more than 120 seconds.
[10080.625332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10080.626430] khugepaged      D ffffffff8160ece0     0    21      2 0x00000000
[10080.627115]  ffff88003ac5d6b0 0000000000000046 ffff88003ac521c0 0000000000012000
[10080.628213]  ffff88003ac5dfd8 ffff88003ac5c010 0000000000012000 0000000000012000
[10080.629329]  ffff88003ac5dfd8 0000000000012000 ffffffff81a0d020 ffff88003ac521c0
[10080.630440] Call Trace:
[10080.630909]  [<ffffffff810f1960>] ? __lock_page+0x70/0x70
[10080.631533]  [<ffffffff8149962f>] schedule+0x3f/0x60
[10080.632136]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[10080.632697]  [<ffffffff810f196e>] sleep_on_page+0xe/0x20
[10080.633319]  [<ffffffff81497b8f>] __wait_on_bit+0x5f/0x90
[10080.633894]  [<ffffffff810f1bb3>] wait_on_page_bit+0x73/0x80
[10080.634526]  [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
[10080.635181]  [<ffffffff8128e201>] ? list_del+0x11/0x40
[10080.635738]  [<ffffffff81102b85>] shrink_page_list+0x425/0x900
[10080.636381]  [<ffffffff81102227>] ? update_isolated_counts+0x127/0x180
[10080.636993]  [<ffffffff81104480>] shrink_inactive_list+0x270/0x530
[10080.637650]  [<ffffffff81280fbd>] ? rb_insert_color+0x9d/0x160
[10080.638284]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[10080.638891]  [<ffffffff8106a705>] ? ttwu_do_wakeup+0x45/0x100
[10080.639519]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[10080.640149]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[10080.640706]  [<ffffffff81104eee>] do_try_to_free_pages+0xee/0x580
[10080.641348]  [<ffffffff811055fb>] try_to_free_pages+0x9b/0x120
[10080.641932]  [<ffffffff810f9c06>] __alloc_pages_nodemask+0x486/0x870
[10080.642607]  [<ffffffff8113af9c>] khugepaged+0xac/0x13a0
[10080.643218]  [<ffffffff81070d10>] ? __dequeue_entity+0x30/0x50
[10080.643802]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[10080.644420]  [<ffffffff8113aef0>] ? khugepaged_alloc_sleep+0x150/0x150
[10080.645084]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[10080.645644]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[10080.646280]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[10080.646895]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[10200.647098] INFO: task kswapd0:19 blocked for more than 120 seconds.
[10200.647701] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[10200.648843] kswapd0         D 0000000000000000     0    19      2 0x00000000
[10200.649624]  ffff88003ac55680 0000000000000046 ffff88003ac53500 0000000000012000
[10200.650753]  ffff88003ac55fd8 ffff88003ac54010 0000000000012000 0000000000012000
[10200.651870]  ffff88003ac55fd8 0000000000012000 ffff88003a316140 ffff88003ac53500
[10200.653009] Call Trace:
[10200.653546]  [<ffffffff8149962f>] schedule+0x3f/0x60
[10200.654156]  [<ffffffff814996dc>] io_schedule+0x8c/0xd0
[10200.654721]  [<ffffffff81260995>] get_request_wait+0x125/0x250
[10200.655377]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[10200.655945]  [<ffffffff8125aceb>] ? elv_merge+0xeb/0xf0
[10200.656589]  [<ffffffff81261863>] blk_queue_bio+0x103/0x370
[10200.657216]  [<ffffffff8125fd5f>] generic_make_request+0xbf/0xf0
[10200.657800]  [<ffffffff8125fe17>] submit_bio+0x87/0x110
[10200.658436]  [<ffffffff8117a70b>] ? bio_alloc_bioset+0x5b/0xf0
[10200.659081]  [<ffffffff81174c5b>] submit_bh+0xeb/0x140
[10200.663791]  [<ffffffff811768e0>] __block_write_full_page+0x210/0x3a0
[10200.664457]  [<ffffffff81176240>] ? lock_buffer+0x30/0x30
[10200.665089]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[10200.665677]  [<ffffffff811dade0>] ? ext2_get_blocks+0x9d0/0x9d0
[10200.666328]  [<ffffffff811774d3>] block_write_full_page_endio+0xe3/0x120
[10200.666938]  [<ffffffff81177525>] block_write_full_page+0x15/0x20
[10200.667608]  [<ffffffff811d9eb8>] ext2_writepage+0x18/0x20
[10200.668226]  [<ffffffff81102cbc>] shrink_page_list+0x55c/0x900
[10200.668809]  [<ffffffff811043ef>] shrink_inactive_list+0x1df/0x530
[10200.669464]  [<ffffffff81104af1>] shrink_mem_cgroup_zone+0x3b1/0x610
[10200.670112]  [<ffffffff8113ed01>] ? mem_cgroup_iter+0xf1/0x270
[10200.670693]  [<ffffffff81104db3>] shrink_zone+0x63/0xb0
[10200.671332]  [<ffffffff81105ca5>] balance_pgdat+0x625/0x890
[10200.671902]  [<ffffffff811060ed>] kswapd+0x1dd/0x410
[10200.672505]  [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
[10200.673163]  [<ffffffff81105f10>] ? balance_pgdat+0x890/0x890
[10200.673739]  [<ffffffff8105ca7e>] kthread+0x9e/0xb0
[10200.674357]  [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
[10200.674940]  [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
[10200.675627]  [<ffffffff814a34e0>] ? gs_change+0x13/0x13
[20138.937422] Waking error handler thread
[20138.938032] Error handler scsi_eh_0 waking up
[20138.938880] sd 0:0:0:16: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
[20138.939578] Total of 1 commands on 1 devices require eh work
[20138.940216] scsi_eh_0: aborting cmd:0xffff880031514ec0
[20138.940770] sd 0:0:0:16: [sdq] abort
[20138.942361] scsi_eh_done scmd: ffff880031514ec0 result: 0
[20138.953038] scsi_send_eh_cmnd: scmd: ffff880031514ec0, timeleft: 10000
[20138.953708] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[20138.954340] scsi_eh_tur: scmd ffff880031514ec0 rtn 2002
[20138.954897] scsi_eh_0: flush retry cmd: ffff880031514ec0
[20138.955867] scsi_restart_operations: waking up host to restart
[20138.962856] Error handler scsi_eh_0 sleeping
[30616.147215] Waking error handler thread
[30616.148074] Error handler scsi_eh_0 waking up
[30616.148735] sd 0:0:0:79: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
[30616.149454] Total of 1 commands on 1 devices require eh work
[30616.150032] scsi_eh_0: aborting cmd:0xffff880034096ec0
[30616.150664] sd 0:0:0:79: [sdcb] abort
[30616.153056] scsi_eh_done scmd: ffff880034096ec0 result: 0
[30616.189769] scsi_send_eh_cmnd: scmd: ffff880034096ec0, timeleft: 10000
[30616.190617] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[30616.191255] scsi_eh_tur: scmd ffff880034096ec0 rtn 2002
[30616.191823] scsi_eh_0: flush retry cmd: ffff880034096ec0
[30616.192505] scsi_restart_operations: waking up host to restart
[30616.201696] Error handler scsi_eh_0 sleeping
[30771.521263] Waking error handler thread
[30771.521892] Error handler scsi_eh_0 waking up
[30771.522602] sd 0:0:0:276: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
[30771.523393] Total of 1 commands on 1 devices require eh work
[30771.524003] scsi_eh_0: aborting cmd:0xffff8800367a4dc0
[30771.524635] sd 0:0:0:276: [sdjq] abort
[30771.525937] scsi_eh_done scmd: ffff8800367a4dc0 result: 0
[30771.526556] scsi_send_eh_cmnd: scmd: ffff8800367a4dc0, timeleft: 10000
[30771.527215] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[30771.527796] scsi_eh_tur: scmd ffff8800367a4dc0 rtn 2002
[30771.528490] scsi_eh_0: flush retry cmd: ffff8800367a4dc0
[30771.529150] scsi_restart_operations: waking up host to restart
[30771.537222] Error handler scsi_eh_0 sleeping
[30872.845287] Waking error handler thread
[30872.845875] Error handler scsi_eh_0 waking up
[30872.846505] sd 0:0:0:168: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
[30872.847220] Total of 1 commands on 1 devices require eh work
[30872.847790] scsi_eh_0: aborting cmd:0xffff88003246d5c0
[30872.848410] sd 0:0:0:168: [sdfm] abort
[30872.849392] scsi_eh_done scmd: ffff88003246d5c0 result: 0
[30872.852259] scsi_send_eh_cmnd: scmd: ffff88003246d5c0, timeleft: 10000
[30872.852873] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[30872.853505] scsi_eh_tur: scmd ffff88003246d5c0 rtn 2002
[30872.854114] scsi_eh_0: flush retry cmd: ffff88003246d5c0
[30872.854726] scsi_restart_operations: waking up host to restart
[30872.862588] Error handler scsi_eh_0 sleeping
[30917.460765] Waking error handler thread
[30917.461727] Error handler scsi_eh_0 waking up
[30917.462366] sd 0:0:0:168: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
[30917.463004] Total of 2 commands on 1 devices require eh work
[30917.463652] scsi_eh_0: aborting cmd:0xffff88003410b1c0
[30917.464261] sd 0:0:0:168: [sdfm] abort
[30917.465240] scsi_eh_0: aborting cmd:0xffff8800326f13c0
[30917.465797] sd 0:0:0:168: [sdfm] abort
[30917.466488] scsi_eh_done scmd: ffff88003410b1c0 result: 0
[30917.467060] scsi_send_eh_cmnd: scmd: ffff88003410b1c0, timeleft: 10000
[30917.467752] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[30917.468408] scsi_eh_tur: scmd ffff88003410b1c0 rtn 2002
[30917.468973] scsi_eh_0: flush retry cmd: ffff88003410b1c0
[30917.469601] scsi_eh_0: flush retry cmd: ffff8800326f13c0
[30917.470294] scsi_restart_operations: waking up host to restart
[30917.477824] Error handler scsi_eh_0 sleeping
[30917.487847] ------------[ cut here ]------------
[30917.488491] kernel BUG at /home/hutao/linux-2.6/block/blk-core.c:2292!
[30917.488803] invalid opcode: 0000 [#1] SMP 
[30917.488803] CPU 0 
[30917.488803] Modules linked in: tun bridge stp llc autofs4 pcspkr sg i2c_piix4 i2c_core sr_mod cdrom [last unloaded: speedstep_lib]
[30917.488803] 
[30917.488803] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc3-ht-virtio-scsi-1+ #13 Bochs Bochs
[30917.488803] RIP: 0010:[<ffffffff81260e61>]  [<ffffffff81260e61>] blk_finish_request+0x231/0x280
[30917.488803] RSP: 0018:ffff88003fc03d40  EFLAGS: 00010087
[30917.488803] RAX: 0000000000000246 RBX: ffff88003594b6d8 RCX: 0000000000000c31
[30917.488803] RDX: 0000000000000246 RSI: 0000000000000000 RDI: ffff88003594b6d8
[30917.488803] RBP: ffff88003fc03d60 R08: ffff88003594b6d8 R09: ffff880013236000
[30917.488803] R10: ffff88001aa86000 R11: ffff880019c86000 R12: 0000000000000000
[30917.488803] R13: ffff88003aeed078 R14: 0000000000000000 R15: 0000000000000000
[30917.488803] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[30917.488803] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[30917.488803] CR2: 000000349231a2e0 CR3: 00000000370ad000 CR4: 00000000000006f0
[30917.488803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[30917.488803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[30917.488803] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0d020)
[30917.488803] Stack:
[30917.488803]  ffff88003594b6d8 0000000000000000 ffff88003aeed078 0000000000000246
[30917.488803]  ffff88003fc03d90 ffffffff81260f04 ffff8800326f13c0 ffff88003594b6d8
[30917.488803]  0000000000000000 0000000000000000 ffff88003fc03da0 ffffffff81260f80
[30917.488803] Call Trace:
[30917.488803]  <IRQ> 
[30917.488803]  [<ffffffff81260f04>] blk_end_bidi_request+0x54/0x80
[30917.488803]  [<ffffffff81260f80>] blk_end_request+0x10/0x20
[30917.488803]  [<ffffffff81341a4f>] scsi_io_completion+0xaf/0x610
[30917.488803]  [<ffffffff812ed98b>] ? virtqueue_get_buf+0x6b/0x120
[30917.488803]  [<ffffffff81338db9>] scsi_finish_command+0xc9/0x130
[30917.488803]  [<ffffffff81342117>] scsi_softirq_done+0x147/0x170
[30917.488803]  [<ffffffff81267352>] blk_done_softirq+0x82/0xa0
[30917.488803]  [<ffffffff810b74c4>] ? handle_irq_event_percpu+0xb4/0x210
[30917.488803]  [<ffffffff8104164f>] __do_softirq+0xbf/0x200
[30917.488803]  [<ffffffff814a35dc>] call_softirq+0x1c/0x30
[30917.488803]  [<ffffffff810042d5>] do_softirq+0x65/0xa0
[30917.488803]  [<ffffffff8104144d>] irq_exit+0xbd/0xe0
[30917.488803]  [<ffffffff814a3cc6>] do_IRQ+0x66/0xe0
[30917.488803]  [<ffffffff8149a4ee>] common_interrupt+0x6e/0x6e
[30917.488803]  <EOI> 
[30917.488803]  [<ffffffff81029f76>] ? native_safe_halt+0x6/0x10
[30917.488803]  [<ffffffff8100b37d>] default_idle+0x5d/0x190
[30917.488803]  [<ffffffff81002099>] cpu_idle+0xd9/0x120
[30917.488803]  [<ffffffff8148113d>] rest_init+0x6d/0x80
[30917.488803]  [<ffffffff81ad3cc7>] start_kernel+0x3d6/0x3e1
[30917.488803]  [<ffffffff81ad332a>] x86_64_start_reservations+0x131/0x136
[30917.488803]  [<ffffffff81ad3432>] x86_64_start_kernel+0x103/0x112
[30917.488803] Code: 66 2e 0f 1f 84 00 00 00 00 00 48 89 df e8 68 a7 ff ff e9 3e fe ff ff 0f 1f 00 48 8b 7f 38 48 89 de e8 24 1a 00 00 e9 ff fd ff ff <0f> 0b eb fe 83 7b 44 01 0f 1f 80 00 00 00 00 0f 85 03 fe ff ff 
[30917.488803] RIP  [<ffffffff81260e61>] blk_finish_request+0x231/0x280
[30917.488803]  RSP <ffff88003fc03d40>

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg-2

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc3-ht-virtio-scsi-1+ (root@KERNEL-128) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #13 SMP Wed Feb 22 14:36:48 CST 2012
Command line: ro root=UUID=a93a2827-4db1-4818-876c-5992c9b27830 rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=64M@64M  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Bochs Bochs, BIOS Bochs 01/01/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x3fffd max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [ffff8800000fd610] fd610
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000098000] 98000 size 20480
init_memory_mapping: 0000000000000000-000000003fffd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fffd000 page 4k
kernel direct mapping tables up to 3fffd000 @ 1fffd000-20000000
RAMDISK: 374c8000 - 37ff0000
Reserving 64MB of memory at 64MB for crashkernel (System RAM: 1023MB)
ACPI: RSDP 00000000000fd4b0 00014 (v00 BOCHS )
ACPI: RSDT 000000003fffd7b0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 000000003fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 000000003fffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
ACPI: FACS 000000003fffff40 00040
ACPI: SSDT 000000003fffd910 0009E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 000000003fffd830 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 000000003fffd7f0 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
ACPI: Local APIC address 0xfee00000
kvm-clock: Using msrs 4b564d01 and 4b564d00
kvm-clock: cpu 0, msr 0:1ad1f41, boot clock
 [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003e600000-ffff88003f3fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x0003fffd
On node 0 totalpages: 262026
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3920 pages, LIFO batch:0
  DMA32 zone: 3528 pages used for memmap
  DMA32 zone: 254517 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 40000000:beffc000)
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88003fc00000 s76864 r8192 d21440 u2097152
pcpu-alloc: s76864 r8192 d21440 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 
kvm-clock: cpu 0, msr 0:3fc11f41, primary cpu clock
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258437
Kernel command line: ro root=UUID=a93a2827-4db1-4818-876c-5992c9b27830 rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=64M@64M  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Memory: 941516k/1048564k available (4760k kernel code, 460k absent, 106588k reserved, 6242k data, 704k init)
Hierarchical RCU implementation.
NR_IRQS:262400 nr_irqs:256 16
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 4194304 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Detected 2393.894 MHz processor.
Calibrating delay loop (skipped) preset value.. 4787.78 BogoMIPS (lpj=2393894)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
mce: CPU supports 10 MCE banks
SMP alternatives: switching to UP code
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20120111
ftrace: allocating 16881 entries in 66 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 1.0.50 stepping 03
APIC calibration not consistent with PM-Timer: 108ms instead of 100ms
APIC delta adjusted to PM-Timer: 6249982 (6754393)
Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
Brought up 1 CPUs
Total of 1 processors activated (4787.78 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
PCI: root bus 00: using default resources
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
pci 0000:00:01.1: reg 20: [io  0xc0c0-0xc0cf]
pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
pci 0000:00:03.0: [8086:100e] type 0 class 0x000200
pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
pci 0000:00:08.0: [1af4:1004] type 0 class 0x000100
pci 0000:00:08.0: reg 10: [io  0xc040-0xc07f]
pci 0000:00:08.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
pci 0000:00:09.0: [1af4:1001] type 0 class 0x000100
pci 0000:00:09.0: reg 10: [io  0xc080-0xc0bf]
pci 0000:00:09.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009dc00 - 000000000009ffff 
reserve RAM buffer: 000000003fffd000 - 000000003fffffff 
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
Switching to clocksource kvm-clock
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0xe0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x0070-0x0071]
pnp 00:01: [irq 8]
pnp 00:01: [io  0x0072-0x0077]
pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:02: [io  0x0060]
pnp 00:02: [io  0x0064]
pnp 00:02: [irq 1]
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:03: [irq 12]
pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:04: [io  0x03f2-0x03f5]
pnp 00:04: [io  0x03f7]
pnp 00:04: [irq 6]
pnp 00:04: [dma 2]
pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:05: [io  0x0378-0x037f]
pnp 00:05: [irq 7]
pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
pnp 00:06: [io  0x03f8-0x03ff]
pnp 00:06: [irq 4]
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: [mem 0xfed00000-0xfed003ff]
pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 0 pci_try_num: 1
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 0 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 11424k freed
microcode: CPU0 sig=0x623, pf=0x0, revision=0x0
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
audit: initializing netlink socket (disabled)
type=2000 audit(1330583975.369:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1861
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
acpiphp: Slot [2] registered
acpiphp: Slot [3] registered
acpiphp: Slot [4] registered
acpiphp: Slot [5] registered
acpiphp: Slot [6] registered
acpiphp: Slot [7] registered
acpiphp: Slot [8] registered
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
acpiphp: Slot [11] registered
acpiphp: Slot [12] registered
acpiphp: Slot [13] registered
acpiphp: Slot [14] registered
acpiphp: Slot [15] registered
acpiphp: Slot [16] registered
acpiphp: Slot [17] registered
acpiphp: Slot [18] registered
acpiphp: Slot [19] registered
acpiphp: Slot [20] registered
acpiphp: Slot [21] registered
acpiphp: Slot [22] registered
acpiphp: Slot [23] registered
acpiphp: Slot [24] registered
acpiphp: Slot [25] registered
acpiphp: Slot [26] registered
acpiphp: Slot [27] registered
acpiphp: Slot [28] registered
acpiphp: Slot [29] registered
acpiphp: Slot [30] registered
acpiphp: Slot [31] registered
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
virtio-pci 0000:00:08.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
virtio-pci 0000:00:09.0: setting latency timer to 64
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Non-volatile memory driver v1.3
loop: module loaded
virtio-pci 0000:00:09.0: irq 40 for MSI/MSI-X
virtio-pci 0000:00:09.0: irq 41 for MSI/MSI-X
 vda: vda1 vda2
virtio-pci 0000:00:08.0: irq 42 for MSI/MSI-X
virtio-pci 0000:00:08.0: irq 43 for MSI/MSI-X
scsi0 : Virtio SCSI HBA
ata_piix 0000:00:01.1: version 2.13
ata_piix 0000:00:01.1: setting latency timer to 64
scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:1: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:2: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:3: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi1 : ata_piix
scsi2 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0c0 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0c8 irq 15
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
scsi 0:0:0:4: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:5: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:6: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
scsi 0:0:0:7: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:8: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:9: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:10: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:11: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
mousedev: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
rtc_cmos 00:01: RTC can wake from S4
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
scsi 0:0:0:12: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:13: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:14: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:15: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
scsi 0:0:0:16: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:17: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
registered taskstats version 1
scsi: waiting for bus probes to complete ...
scsi 0:0:0:18: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:19: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:20: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:21: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:22: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:23: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:24: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:25: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:26: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:27: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:28: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:29: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:30: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:31: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:32: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:33: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:34: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:35: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:36: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:37: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:38: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:39: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:40: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:41: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:42: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:43: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:44: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:45: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:46: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:47: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:48: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:49: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:50: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:51: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:52: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:53: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:54: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:55: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:56: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:57: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:58: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:59: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:60: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:61: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:62: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:63: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:64: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:65: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:66: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:67: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:68: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:69: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:70: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:71: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:72: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:73: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:74: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:75: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:76: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:77: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:78: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:79: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:80: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:81: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:82: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:83: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:84: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:85: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:86: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:87: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:88: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:89: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:90: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:91: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:92: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:93: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:94: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:95: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:96: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:97: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:98: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:99: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:100: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:101: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:102: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:103: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:104: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:105: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:106: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:107: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:108: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:109: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:110: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:111: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:112: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:113: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:114: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:115: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:116: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:117: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:118: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:119: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:120: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:121: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:122: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:123: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:124: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:125: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:126: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:127: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:128: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:129: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:130: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:131: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:132: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
ata2.01: NODEV after polling detection
ata2.00: ATAPI: QEMU DVD-ROM, 1.0.50, max UDMA/100
ata2.00: configured for MWDMA2
scsi: waiting for bus probes to complete ...
scsi 0:0:0:133: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:134: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:135: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:136: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:137: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:138: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:139: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:140: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:141: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:142: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:143: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:144: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:145: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:146: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:147: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:148: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:149: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:150: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:151: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:152: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:153: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:154: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:155: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:156: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:157: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:158: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:159: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:160: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:161: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:162: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:163: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:164: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:165: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:166: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:167: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:168: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:169: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:170: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:171: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:172: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:173: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:174: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:175: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:176: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:177: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:178: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:179: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:180: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:181: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:182: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:183: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:184: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:185: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:186: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:187: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:188: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:189: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:190: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:191: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:192: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:193: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:194: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:195: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:196: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:197: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:198: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:199: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:200: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:201: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:202: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:203: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:204: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:205: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:206: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:207: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:208: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:209: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:210: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:211: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:212: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:213: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:214: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:215: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:216: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:217: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:218: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:219: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:220: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:221: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:222: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:223: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:224: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:225: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:226: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:227: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:228: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:229: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:230: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:231: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:232: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:233: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:234: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:235: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:236: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:237: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:238: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:239: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:240: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:241: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:242: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:243: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:244: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:245: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:246: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:247: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:248: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:249: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:250: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:251: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:252: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:253: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:254: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:255: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:256: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:257: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:258: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:259: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:260: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:261: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:262: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:263: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:264: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:265: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:266: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:267: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:268: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:269: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:270: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:271: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:272: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:273: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:274: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:275: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:276: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:277: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:278: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:279: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:280: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:281: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:282: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:283: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:284: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:285: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:286: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:287: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:288: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:289: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:290: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:291: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:292: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:293: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:294: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:295: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:296: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:297: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:298: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi 0:0:0:299: Direct-Access     QEMU     QEMU HARDDISK    1.0. PQ: 0 ANSI: 5
scsi scan: INQUIRY result too short (5), using 36
sd 0:0:0:0: [sda] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 63 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:1: [sdb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:1: [sdb] Write Protect is off
sd 0:0:0:1: [sdb] Mode Sense: 63 00 00 08
sd 0:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:2: [sdc] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:2: [sdc] Write Protect is off
sd 0:0:0:2: [sdc] Mode Sense: 63 00 00 08
sd 0:0:0:2: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 0:0:0:3: [sdd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:3: [sdd] Write Protect is off
sd 0:0:0:3: [sdd] Mode Sense: 63 00 00 08
sd 0:0:0:3: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:4: [sde] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:4: [sde] Write Protect is off
sd 0:0:0:4: [sde] Mode Sense: 63 00 00 08
sd 0:0:0:4: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:5: [sdf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:5: [sdf] Write Protect is off
sd 0:0:0:5: [sdf] Mode Sense: 63 00 00 08
 sdb: sdb1
sd 0:0:0:1: [sdb] Attached SCSI disk
 sdd: sdd1
sd 0:0:0:3: [sdd] Attached SCSI disk
sd 0:0:0:6: [sdg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:5: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:6: [sdg] Write Protect is off
sd 0:0:0:6: [sdg] Mode Sense: 63 00 00 08
sd 0:0:0:6: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:7: [sdh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:8: [sdi] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:8: [sdi] Write Protect is off
sd 0:0:0:8: [sdi] Mode Sense: 63 00 00 08
 sde: sde1
sd 0:0:0:4: [sde] Attached SCSI disk
sd 0:0:0:9: [sdj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:7: [sdh] Write Protect is off
sd 0:0:0:7: [sdh] Mode Sense: 63 00 00 08
sd 0:0:0:10: [sdk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:10: [sdk] Write Protect is off
sd 0:0:0:10: [sdk] Mode Sense: 63 00 00 08
sd 0:0:0:8: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1
sd 0:0:0:5: [sdf] Attached SCSI disk
sd 0:0:0:11: [sdl] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:11: [sdl] Write Protect is off
sd 0:0:0:11: [sdl] Mode Sense: 63 00 00 08
sd 0:0:0:7: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:10: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:12: [sdm] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdg: sdg1
sd 0:0:0:6: [sdg] Attached SCSI disk
sd 0:0:0:13: [sdn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:14: [sdo] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:11: [sdl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:14: [sdo] Write Protect is off
sd 0:0:0:14: [sdo] Mode Sense: 63 00 00 08
sd 0:0:0:15: [sdp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:12: [sdm] Write Protect is off
sd 0:0:0:12: [sdm] Mode Sense: 63 00 00 08
sd 0:0:0:12: [sdm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdi: sdi1
sd 0:0:0:8: [sdi] Attached SCSI disk
sd 0:0:0:16: [sdq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:16: [sdq] Write Protect is off
sd 0:0:0:16: [sdq] Mode Sense: 63 00 00 08
sd 0:0:0:14: [sdo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1
sd 0:0:0:7: [sdh] Attached SCSI disk
 sdk: sdk1
sd 0:0:0:10: [sdk] Attached SCSI disk
sd 0:0:0:15: [sdp] Write Protect is off
sd 0:0:0:15: [sdp] Mode Sense: 63 00 00 08
sd 0:0:0:18: [sds] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:18: [sds] Write Protect is off
sd 0:0:0:18: [sds] Mode Sense: 63 00 00 08
sd 0:0:0:16: [sdq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdl: sdl1
sd 0:0:0:11: [sdl] Attached SCSI disk
sd 0:0:0:13: [sdn] Write Protect is off
sd 0:0:0:13: [sdn] Mode Sense: 63 00 00 08
sd 0:0:0:13: [sdn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:19: [sdt] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:15: [sdp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:20: [sdu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:20: [sdu] Write Protect is off
sd 0:0:0:20: [sdu] Mode Sense: 63 00 00 08
sd 0:0:0:18: [sds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:21: [sdv] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:17: [sdr] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdo: sdo1
sd 0:0:0:14: [sdo] Attached SCSI disk
sd 0:0:0:22: [sdw] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdm: sdm1
sd 0:0:0:12: [sdm] Attached SCSI disk
sd 0:0:0:19: [sdt] Write Protect is off
sd 0:0:0:19: [sdt] Mode Sense: 63 00 00 08
sd 0:0:0:19: [sdt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:23: [sdx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:23: [sdx] Write Protect is off
sd 0:0:0:23: [sdx] Mode Sense: 63 00 00 08
sd 0:0:0:20: [sdu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdq: sdq1
sd 0:0:0:16: [sdq] Attached SCSI disk
sd 0:0:0:17: [sdr] Write Protect is off
sd 0:0:0:17: [sdr] Mode Sense: 63 00 00 08
sd 0:0:0:24: [sdy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:21: [sdv] Write Protect is off
sd 0:0:0:21: [sdv] Mode Sense: 63 00 00 08
sd 0:0:0:21: [sdv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:25: [sdz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:25: [sdz] Write Protect is off
sd 0:0:0:25: [sdz] Mode Sense: 63 00 00 08
 sdp: sdp1
sd 0:0:0:15: [sdp] Attached SCSI disk
sd 0:0:0:26: [sdaa] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sds: sds1
sd 0:0:0:18: [sds] Attached SCSI disk
sd 0:0:0:17: [sdr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:24: [sdy] Write Protect is off
sd 0:0:0:24: [sdy] Mode Sense: 63 00 00 08
sd 0:0:0:24: [sdy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdn: sdn1
sd 0:0:0:13: [sdn] Attached SCSI disk
sd 0:0:0:29: [sdad] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:30: [sdae] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:25: [sdz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:30: [sdae] Write Protect is off
sd 0:0:0:30: [sdae] Mode Sense: 63 00 00 08
 sdu: sdu1
sd 0:0:0:20: [sdu] Attached SCSI disk
sd 0:0:0:31: [sdaf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:31: [sdaf] Write Protect is off
sd 0:0:0:31: [sdaf] Mode Sense: 63 00 00 08
sd 0:0:0:2: [sdc] Attached SCSI disk
sd 0:0:0:22: [sdw] Write Protect is off
sd 0:0:0:22: [sdw] Mode Sense: 63 00 00 08
sd 0:0:0:22: [sdw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:33: [sdah] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdt: sdt1
sd 0:0:0:19: [sdt] Attached SCSI disk
sd 0:0:0:29: [sdad] Write Protect is off
sd 0:0:0:29: [sdad] Mode Sense: 63 00 00 08
sd 0:0:0:29: [sdad] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:30: [sdae] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:33: [sdah] Write Protect is off
sd 0:0:0:33: [sdah] Mode Sense: 63 00 00 08
 sdr: sdr1
sd 0:0:0:17: [sdr] Attached SCSI disk
sd 0:0:0:27: [sdab] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:27: [sdab] Write Protect is off
sd 0:0:0:27: [sdab] Mode Sense: 63 00 00 08
sd 0:0:0:35: [sdaj] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdv: sdv1
sd 0:0:0:21: [sdv] Attached SCSI disk
sd 0:0:0:28: [sdac] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:32: [sdag] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:35: [sdaj] Write Protect is off
sd 0:0:0:35: [sdaj] Mode Sense: 63 00 00 08
sd 0:0:0:35: [sdaj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:26: [sdaa] Write Protect is off
sd 0:0:0:26: [sdaa] Mode Sense: 63 00 00 08
sd 0:0:0:26: [sdaa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdz: sdz1
sd 0:0:0:25: [sdz] Attached SCSI disk
sd 0:0:0:33: [sdah] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:36: [sdak] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdy: sdy1
sd 0:0:0:24: [sdy] Attached SCSI disk
sd 0:0:0:28: [sdac] Write Protect is off
sd 0:0:0:28: [sdac] Mode Sense: 63 00 00 08
sd 0:0:0:32: [sdag] Write Protect is off
sd 0:0:0:32: [sdag] Mode Sense: 63 00 00 08
sd 0:0:0:34: [sdai] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:34: [sdai] Write Protect is off
sd 0:0:0:34: [sdai] Mode Sense: 63 00 00 08
sd 0:0:0:36: [sdak] Write Protect is off
sd 0:0:0:36: [sdak] Mode Sense: 63 00 00 08
 sdae: sdae1
sd 0:0:0:30: [sdae] Attached SCSI disk
sd 0:0:0:38: [sdam] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:9: [sdj] Write Protect is off
sd 0:0:0:9: [sdj] Mode Sense: 63 00 00 08
sd 0:0:0:9: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:39: [sdan] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:39: [sdan] Write Protect is off
sd 0:0:0:39: [sdan] Mode Sense: 63 00 00 08
sd 0:0:0:40: [sdao] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:27: [sdab] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdw: sdw1
sd 0:0:0:22: [sdw] Attached SCSI disk
sd 0:0:0:38: [sdam] Write Protect is off
sd 0:0:0:38: [sdam] Mode Sense: 63 00 00 08
sd 0:0:0:38: [sdam] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdad: sdad1
sd 0:0:0:29: [sdad] Attached SCSI disk
sd 0:0:0:28: [sdac] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
sd 0:0:0:32: [sdag] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdah: sdah1
sd 0:0:0:33: [sdah] Attached SCSI disk
sd 0:0:0:36: [sdak] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:42: [sdaq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:42: [sdaq] Write Protect is off
sd 0:0:0:42: [sdaq] Mode Sense: 63 00 00 08
sd 0:0:0:42: [sdaq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:40: [sdao] Write Protect is off
sd 0:0:0:40: [sdao] Mode Sense: 63 00 00 08
sd 0:0:0:40: [sdao] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdaj: sdaj1
sd 0:0:0:35: [sdaj] Attached SCSI disk
sd 0:0:0:43: [sdar] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:44: [sdas] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdaa: sdaa1
sd 0:0:0:26: [sdaa] Attached SCSI disk
sd 0:0:0:34: [sdai] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:45: [sdat] 819200 512-byte logical blocks: (419 MB/400 MiB)
Refined TSC clocksource calibration: 2393.890 MHz.
sd 0:0:0:46: [sdau] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:39: [sdan] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:45: [sdat] Write Protect is off
sd 0:0:0:45: [sdat] Mode Sense: 63 00 00 08
sd 0:0:0:45: [sdat] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:47: [sdav] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdab: sdab1
sd 0:0:0:27: [sdab] Attached SCSI disk
 sdac: sdac1
sd 0:0:0:44: [sdas] Write Protect is off
sd 0:0:0:44: [sdas] Mode Sense: 63 00 00 08
sd 0:0:0:44: [sdas] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdag: sdag1
sd 0:0:0:32: [sdag] Attached SCSI disk
sd 0:0:0:49: [sdax] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:49: [sdax] Write Protect is off
sd 0:0:0:49: [sdax] Mode Sense: 63 00 00 08
sd 0:0:0:50: [sday] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdj: sdj1
sd 0:0:0:9: [sdj] Attached SCSI disk
sd 0:0:0:46: [sdau] Write Protect is off
sd 0:0:0:46: [sdau] Mode Sense: 63 00 00 08
 sdak: sdak1
sd 0:0:0:36: [sdak] Attached SCSI disk
sd 0:0:0:47: [sdav] Write Protect is off
sd 0:0:0:47: [sdav] Mode Sense: 63 00 00 08
sd 0:0:0:47: [sdav] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdam: sdam1
sd 0:0:0:38: [sdam] Attached SCSI disk
sd 0:0:0:53: [sdbb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:54: [sdbc] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdai: sdai1
sd 0:0:0:34: [sdai] Attached SCSI disk
sd 0:0:0:54: [sdbc] Write Protect is off
sd 0:0:0:54: [sdbc] Mode Sense: 63 00 00 08
sd 0:0:0:54: [sdbc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:50: [sday] Write Protect is off
sd 0:0:0:50: [sday] Mode Sense: 63 00 00 08
sd 0:0:0:50: [sday] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:49: [sdax] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:56: [sdbe] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdao: sdao1
sd 0:0:0:40: [sdao] Attached SCSI disk
 sdan: sdan1
sd 0:0:0:39: [sdan] Attached SCSI disk
sd 0:0:0:46: [sdau] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdaq: sdaq1
sd 0:0:0:42: [sdaq] Attached SCSI disk
sd 0:0:0:23: [sdx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:53: [sdbb] Write Protect is off
sd 0:0:0:53: [sdbb] Mode Sense: 63 00 00 08
sd 0:0:0:53: [sdbb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:43: [sdar] Write Protect is off
sd 0:0:0:43: [sdar] Mode Sense: 63 00 00 08
sd 0:0:0:57: [sdbf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:48: [sdaw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:48: [sdaw] Write Protect is off
sd 0:0:0:48: [sdaw] Mode Sense: 63 00 00 08
sd 0:0:0:57: [sdbf] Write Protect is off
sd 0:0:0:57: [sdbf] Mode Sense: 63 00 00 08
sd 0:0:0:51: [sdaz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:51: [sdaz] Write Protect is off
sd 0:0:0:51: [sdaz] Mode Sense: 63 00 00 08
 sdat: sdat1
sd 0:0:0:45: [sdat] Attached SCSI disk
sd 0:0:0:58: [sdbg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:56: [sdbe] Write Protect is off
sd 0:0:0:56: [sdbe] Mode Sense: 63 00 00 08
sd 0:0:0:59: [sdbh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:60: [sdbi] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:52: [sdba] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:52: [sdba] Write Protect is off
sd 0:0:0:52: [sdba] Mode Sense: 63 00 00 08
sd 0:0:0:52: [sdba] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:43: [sdar] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:60: [sdbi] Write Protect is off
sd 0:0:0:60: [sdbi] Mode Sense: 63 00 00 08
 sdas: sdas1
sd 0:0:0:44: [sdas] Attached SCSI disk
sd 0:0:0:61: [sdbj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:55: [sdbd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:57: [sdbf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:56: [sdbe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:62: [sdbk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:63: [sdbl] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:64: [sdbm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:64: [sdbm] Write Protect is off
sd 0:0:0:64: [sdbm] Mode Sense: 63 00 00 08
sd 0:0:0:59: [sdbh] Write Protect is off
sd 0:0:0:59: [sdbh] Mode Sense: 63 00 00 08
sd 0:0:0:65: [sdbn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:65: [sdbn] Write Protect is off
sd 0:0:0:65: [sdbn] Mode Sense: 63 00 00 08
sd 0:0:0:65: [sdbn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdav: sdav1
sd 0:0:0:47: [sdav] Attached SCSI disk
sd 0:0:0:60: [sdbi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:48: [sdaw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdau: sdau1
sd 0:0:0:46: [sdau] Attached SCSI disk
sd 0:0:0:37: [sdal] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:51: [sdaz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdx: sdx1
sd 0:0:0:23: [sdx] Attached SCSI disk
sd 0:0:0:55: [sdbd] Write Protect is off
sd 0:0:0:55: [sdbd] Mode Sense: 63 00 00 08
sd 0:0:0:66: [sdbo] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sday: sday1
sd 0:0:0:50: [sday] Attached SCSI disk
 sdbc: sdbc1
sd 0:0:0:54: [sdbc] Attached SCSI disk
sd 0:0:0:68: [sdbq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:69: [sdbr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:62: [sdbk] Write Protect is off
sd 0:0:0:62: [sdbk] Mode Sense: 63 00 00 08
sd 0:0:0:59: [sdbh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:63: [sdbl] Write Protect is off
sd 0:0:0:63: [sdbl] Mode Sense: 63 00 00 08
sd 0:0:0:69: [sdbr] Write Protect is off
sd 0:0:0:69: [sdbr] Mode Sense: 63 00 00 08
sd 0:0:0:37: [sdal] Write Protect is off
sd 0:0:0:37: [sdal] Mode Sense: 63 00 00 08
sd 0:0:0:37: [sdal] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:55: [sdbd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:31: [sdaf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbf: sdbf1
sd 0:0:0:57: [sdbf] Attached SCSI disk
sd 0:0:0:70: [sdbs] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:58: [sdbg] Write Protect is off
sd 0:0:0:58: [sdbg] Mode Sense: 63 00 00 08
sd 0:0:0:71: [sdbt] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:66: [sdbo] Write Protect is off
sd 0:0:0:66: [sdbo] Mode Sense: 63 00 00 08
sd 0:0:0:66: [sdbo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
rtc_cmos 00:01: setting system clock to 2012-03-01 06:39:35 UTC (1330583975)
scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.0. PQ: 0 ANSI: 5
sd 0:0:0:72: [sdbu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:72: [sdbu] Write Protect is off
sd 0:0:0:72: [sdbu] Mode Sense: 63 00 00 08
sd 0:0:0:72: [sdbu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:64: [sdbm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:71: [sdbt] Write Protect is off
sd 0:0:0:71: [sdbt] Mode Sense: 63 00 00 08
sd 0:0:0:62: [sdbk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:63: [sdbl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbe: sdbe1
sd 0:0:0:56: [sdbe] Attached SCSI disk
sd 0:0:0:69: [sdbr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:73: [sdbv] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:74: [sdbw] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdbi: sdbi1
sd 0:0:0:60: [sdbi] Attached SCSI disk
sd 0:0:0:61: [sdbj] Write Protect is off
sd 0:0:0:61: [sdbj] Mode Sense: 63 00 00 08
sd 0:0:0:75: [sdbx] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdaw: sdaw1
sd 0:0:0:48: [sdaw] Attached SCSI disk
 sdaz: sdaz1
sd 0:0:0:51: [sdaz] Attached SCSI disk
sd 0:0:0:77: [sdbz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:77: [sdbz] Write Protect is off
sd 0:0:0:77: [sdbz] Mode Sense: 63 00 00 08
sd 0:0:0:58: [sdbg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:71: [sdbt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:67: [sdbp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:67: [sdbp] Write Protect is off
sd 0:0:0:67: [sdbp] Mode Sense: 63 00 00 08
 sdba: sdba1
 sdbh: sdbh1
sd 0:0:0:73: [sdbv] Write Protect is off
sd 0:0:0:73: [sdbv] Mode Sense: 63 00 00 08
sd 0:0:0:75: [sdbx] Write Protect is off
sd 0:0:0:75: [sdbx] Mode Sense: 63 00 00 08
sd 0:0:0:75: [sdbx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbn: sdbn1
sd 0:0:0:65: [sdbn] Attached SCSI disk
sd 0:0:0:61: [sdbj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:74: [sdbw] Write Protect is off
sd 0:0:0:74: [sdbw] Mode Sense: 63 00 00 08
sd 0:0:0:74: [sdbw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:79: [sdcb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:68: [sdbq] Write Protect is off
sd 0:0:0:68: [sdbq] Mode Sense: 63 00 00 08
 sdbd: sdbd1
sd 0:0:0:55: [sdbd] Attached SCSI disk
 sdaf: sdaf1
sd 0:0:0:31: [sdaf] Attached SCSI disk
sd 0:0:0:77: [sdbz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:79: [sdcb] Write Protect is off
sd 0:0:0:79: [sdcb] Mode Sense: 63 00 00 08
 sdbu: sdbu1
sd 0:0:0:72: [sdbu] Attached SCSI disk
sd 0:0:0:81: [sdcd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:81: [sdcd] Write Protect is off
sd 0:0:0:81: [sdcd] Mode Sense: 63 00 00 08
 sdbk: sdbk1
sd 0:0:0:62: [sdbk] Attached SCSI disk
sd 0:0:0:59: [sdbh] Attached SCSI disk
sd 0:0:0:73: [sdbv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbr: sdbr1
sd 0:0:0:69: [sdbr] Attached SCSI disk
 sdbl: sdbl1
sd 0:0:0:63: [sdbl] Attached SCSI disk
sd 0:0:0:41: [sdap] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:76: [sdby] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:76: [sdby] Write Protect is off
sd 0:0:0:76: [sdby] Mode Sense: 63 00 00 08
sd 0:0:0:83: [sdcf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:84: [sdcg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:83: [sdcf] Write Protect is off
sd 0:0:0:83: [sdcf] Mode Sense: 63 00 00 08
sd 0:0:0:68: [sdbq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdal: sdal1
sd 0:0:0:37: [sdal] Attached SCSI disk
 sdbo: sdbo1
sd 0:0:0:66: [sdbo] Attached SCSI disk
sd 0:0:0:70: [sdbs] Write Protect is off
sd 0:0:0:70: [sdbs] Mode Sense: 63 00 00 08
sd 0:0:0:70: [sdbs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:67: [sdbp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:79: [sdcb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbg: sdbg1
sd 0:0:0:58: [sdbg] Attached SCSI disk
sd 0:0:0:28: [sdac] Attached SCSI disk
 sdbt: sdbt1
sd 0:0:0:71: [sdbt] Attached SCSI disk
sd 0:0:0:78: [sdca] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:88: [sdck] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:89: [sdcl] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdbj: sdbj1
sd 0:0:0:61: [sdbj] Attached SCSI disk
sd 0:0:0:84: [sdcg] Write Protect is off
sd 0:0:0:84: [sdcg] Mode Sense: 63 00 00 08
sd 0:0:0:80: [sdcc] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:41: [sdap] Write Protect is off
sd 0:0:0:41: [sdap] Mode Sense: 63 00 00 08
sd 0:0:0:91: [sdcn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:88: [sdck] Write Protect is off
sd 0:0:0:88: [sdck] Mode Sense: 63 00 00 08
sd 0:0:0:83: [sdcf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:81: [sdcd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:92: [sdco] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdbz: sdbz1
sd 0:0:0:77: [sdbz] Attached SCSI disk
sd 0:0:0:93: [sdcp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:82: [sdce] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:94: [sdcq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:87: [sdcj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:78: [sdca] Write Protect is off
sd 0:0:0:78: [sdca] Mode Sense: 63 00 00 08
sd 0:0:0:78: [sdca] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbv: sdbv1
sd 0:0:0:73: [sdbv] Attached SCSI disk
sd 0:0:0:94: [sdcq] Write Protect is off
sd 0:0:0:94: [sdcq] Mode Sense: 63 00 00 08
 sdbw: sdbw1
sd 0:0:0:74: [sdbw] Attached SCSI disk
sd 0:0:0:89: [sdcl] Write Protect is off
sd 0:0:0:89: [sdcl] Mode Sense: 63 00 00 08
sd 0:0:0:89: [sdcl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:84: [sdcg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:41: [sdap] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:95: [sdcr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:76: [sdby] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbx: sdbx1
sd 0:0:0:75: [sdbx] Attached SCSI disk
sd 0:0:0:85: [sdch] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:91: [sdcn] Write Protect is off
sd 0:0:0:91: [sdcn] Mode Sense: 63 00 00 08
sd 0:0:0:88: [sdck] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdbq: sdbq1
sd 0:0:0:68: [sdbq] Attached SCSI disk
 sdbp: sdbp1
sd 0:0:0:67: [sdbp] Attached SCSI disk
sd 0:0:0:86: [sdci] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdcb: sdcb1
sd 0:0:0:79: [sdcb] Attached SCSI disk
sd 0:0:0:96: [sdcs] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:92: [sdco] Write Protect is off
sd 0:0:0:92: [sdco] Mode Sense: 63 00 00 08
sd 0:0:0:93: [sdcp] Write Protect is off
sd 0:0:0:93: [sdcp] Mode Sense: 63 00 00 08
sd 0:0:0:93: [sdcp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:97: [sdct] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:97: [sdct] Write Protect is off
sd 0:0:0:97: [sdct] Mode Sense: 63 00 00 08
sd 0:0:0:87: [sdcj] Write Protect is off
sd 0:0:0:87: [sdcj] Mode Sense: 63 00 00 08
sd 0:0:0:87: [sdcj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:90: [sdcm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:82: [sdce] Write Protect is off
sd 0:0:0:82: [sdce] Mode Sense: 63 00 00 08
sd 0:0:0:94: [sdcq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:95: [sdcr] Write Protect is off
sd 0:0:0:95: [sdcr] Mode Sense: 63 00 00 08
 sdcf: sdcf1
sd 0:0:0:83: [sdcf] Attached SCSI disk
 sdbs: sdbs1
sd 0:0:0:70: [sdbs] Attached SCSI disk
sd 0:0:0:91: [sdcn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:85: [sdch] Write Protect is off
sd 0:0:0:85: [sdch] Mode Sense: 63 00 00 08
sd 0:0:0:86: [sdci] Write Protect is off
sd 0:0:0:86: [sdci] Mode Sense: 63 00 00 08
sd 0:0:0:86: [sdci] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:98: [sdcu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:99: [sdcv] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:99: [sdcv] Write Protect is off
sd 0:0:0:99: [sdcv] Mode Sense: 63 00 00 08
sd 0:0:0:92: [sdco] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:96: [sdcs] Write Protect is off
sd 0:0:0:96: [sdcs] Mode Sense: 63 00 00 08
sd 0:0:0:96: [sdcs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcd: sdcd1
sd 0:0:0:81: [sdcd] Attached SCSI disk
sd 0:0:0:100: [sdcw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:97: [sdct] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:101: [sdcx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:90: [sdcm] Write Protect is off
sd 0:0:0:90: [sdcm] Mode Sense: 63 00 00 08
sd 0:0:0:82: [sdce] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcg: sdcg1
sd 0:0:0:84: [sdcg] Attached SCSI disk
 sdax: sdax1
sd 0:0:0:49: [sdax] Attached SCSI disk
sd 0:0:0:95: [sdcr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:103: [sdcz] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdap: sdap1
sd 0:0:0:41: [sdap] Attached SCSI disk
sd 0:0:0:104: [sdda] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:105: [sddb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:106: [sddc] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdbb: sdbb1
 sdby: sdby1
sd 0:0:0:76: [sdby] Attached SCSI disk
 sdck: sdck1
sd 0:0:0:88: [sdck] Attached SCSI disk
sd 0:0:0:98: [sdcu] Write Protect is off
sd 0:0:0:98: [sdcu] Mode Sense: 63 00 00 08
 sdar: sdar1
sd 0:0:0:43: [sdar] Attached SCSI disk
sd 0:0:0:100: [sdcw] Write Protect is off
sd 0:0:0:100: [sdcw] Mode Sense: 63 00 00 08
sd 0:0:0:100: [sdcw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:99: [sdcv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:90: [sdcm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:101: [sdcx] Write Protect is off
sd 0:0:0:101: [sdcx] Mode Sense: 63 00 00 08
 sdca: sdca1
sd 0:0:0:78: [sdca] Attached SCSI disk
 sdcl: sdcl1
sd 0:0:0:89: [sdcl] Attached SCSI disk
sd 0:0:0:110: [sddg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:111: [sddh] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdcq: sdcq1
sd 0:0:0:94: [sdcq] Attached SCSI disk
sd 0:0:0:103: [sdcz] Write Protect is off
sd 0:0:0:103: [sdcz] Mode Sense: 63 00 00 08
sd 0:0:0:112: [sddi] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:113: [sddj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:104: [sdda] Write Protect is off
sd 0:0:0:104: [sdda] Mode Sense: 63 00 00 08
 sdcn: sdcn1
sd 0:0:0:91: [sdcn] Attached SCSI disk
 sdcp: sdcp1
sd 0:0:0:93: [sdcp] Attached SCSI disk
sd 0:0:0:98: [sdcu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:112: [sddi] Write Protect is off
sd 0:0:0:112: [sddi] Mode Sense: 63 00 00 08
sd 0:0:0:105: [sddb] Write Protect is off
sd 0:0:0:105: [sddb] Mode Sense: 63 00 00 08
sd 0:0:0:105: [sddb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:115: [sddl] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:102: [sdcy] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdcj: sdcj1
sd 0:0:0:87: [sdcj] Attached SCSI disk
sd 0:0:0:101: [sdcx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdct: sdct1
sd 0:0:0:97: [sdct] Attached SCSI disk
 sdce: sdce1
sd 0:0:0:82: [sdce] Attached SCSI disk
sd 0:0:0:118: [sddo] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:119: [sddp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:120: [sddq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:120: [sddq] Write Protect is off
sd 0:0:0:120: [sddq] Mode Sense: 63 00 00 08
sd 0:0:0:110: [sddg] Write Protect is off
sd 0:0:0:110: [sddg] Mode Sense: 63 00 00 08
sd 0:0:0:111: [sddh] Write Protect is off
sd 0:0:0:111: [sddh] Mode Sense: 63 00 00 08
sd 0:0:0:103: [sdcz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcr: sdcr1
sd 0:0:0:95: [sdcr] Attached SCSI disk
sd 0:0:0:104: [sdda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:107: [sddd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:121: [sddr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:113: [sddj] Write Protect is off
sd 0:0:0:113: [sddj] Mode Sense: 63 00 00 08
sd 0:0:0:113: [sddj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:112: [sddi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:122: [sdds] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdci: sdci1
sd 0:0:0:86: [sdci] Attached SCSI disk
 sdcs: sdcs1
sd 0:0:0:96: [sdcs] Attached SCSI disk
sd 0:0:0:115: [sddl] Write Protect is off
sd 0:0:0:115: [sddl] Mode Sense: 63 00 00 08
sd 0:0:0:115: [sddl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:102: [sdcy] Write Protect is off
sd 0:0:0:102: [sdcy] Mode Sense: 63 00 00 08
sd 0:0:0:124: [sddu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:109: [sddf] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdcm: sdcm1
sd 0:0:0:90: [sdcm] Attached SCSI disk
sd 0:0:0:118: [sddo] Write Protect is off
sd 0:0:0:118: [sddo] Mode Sense: 63 00 00 08
sd 0:0:0:108: [sdde] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:108: [sdde] Write Protect is off
sd 0:0:0:108: [sdde] Mode Sense: 63 00 00 08
sd 0:0:0:125: [sddv] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdcv: sdcv1
sd 0:0:0:99: [sdcv] Attached SCSI disk
sd 0:0:0:119: [sddp] Write Protect is off
sd 0:0:0:119: [sddp] Mode Sense: 63 00 00 08
sd 0:0:0:124: [sddu] Write Protect is off
sd 0:0:0:124: [sddu] Mode Sense: 63 00 00 08
sd 0:0:0:124: [sddu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:110: [sddg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:120: [sddq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:114: [sddk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:126: [sddw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:107: [sddd] Write Protect is off
sd 0:0:0:107: [sddd] Mode Sense: 63 00 00 08
sd 0:0:0:107: [sddd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:121: [sddr] Write Protect is off
sd 0:0:0:121: [sddr] Mode Sense: 63 00 00 08
sd 0:0:0:121: [sddr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcu: sdcu1
sd 0:0:0:98: [sdcu] Attached SCSI disk
 sdbm: sdbm1
sd 0:0:0:64: [sdbm] Attached SCSI disk
sd 0:0:0:122: [sdds] Write Protect is off
sd 0:0:0:122: [sdds] Mode Sense: 63 00 00 08
sd 0:0:0:116: [sddm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:102: [sdcy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:117: [sddn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:127: [sddx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:52: [sdba] Attached SCSI disk
sd 0:0:0:128: [sddy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:127: [sddx] Write Protect is off
sd 0:0:0:127: [sddx] Mode Sense: 63 00 00 08
sd 0:0:0:127: [sddx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:129: [sddz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:109: [sddf] Write Protect is off
sd 0:0:0:109: [sddf] Mode Sense: 63 00 00 08
sd 0:0:0:109: [sddf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcx: sdcx1
sd 0:0:0:101: [sdcx] Attached SCSI disk
sd 0:0:0:119: [sddp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:118: [sddo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcw: sdcw1
sd 0:0:0:100: [sdcw] Attached SCSI disk
sd 0:0:0:125: [sddv] Write Protect is off
sd 0:0:0:125: [sddv] Mode Sense: 63 00 00 08
 sdcz: sdcz1
sd 0:0:0:103: [sdcz] Attached SCSI disk
 sdda: sdda1
sd 0:0:0:104: [sdda] Attached SCSI disk
 sddb: sddb1
sd 0:0:0:105: [sddb] Attached SCSI disk
sd 0:0:0:133: [sded] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:134: [sdee] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:123: [sddt] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:126: [sddw] Write Protect is off
sd 0:0:0:126: [sddw] Mode Sense: 63 00 00 08
sd 0:0:0:126: [sddw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:135: [sdef] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sddi: sddi1
sd 0:0:0:112: [sddi] Attached SCSI disk
sd 0:0:0:122: [sdds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddq: sddq1
sd 0:0:0:120: [sddq] Attached SCSI disk
sd 0:0:0:116: [sddm] Write Protect is off
sd 0:0:0:116: [sddm] Mode Sense: 63 00 00 08
sd 0:0:0:117: [sddn] Write Protect is off
sd 0:0:0:117: [sddn] Mode Sense: 63 00 00 08
sd 0:0:0:114: [sddk] Write Protect is off
sd 0:0:0:114: [sddk] Mode Sense: 63 00 00 08
sd 0:0:0:114: [sddk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:135: [sdef] Write Protect is off
sd 0:0:0:135: [sdef] Mode Sense: 63 00 00 08
sd 0:0:0:137: [sdeh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:138: [sdei] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:108: [sdde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:129: [sddz] Write Protect is off
sd 0:0:0:129: [sddz] Mode Sense: 63 00 00 08
sd 0:0:0:129: [sddz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:80: [sdcc] Write Protect is off
sd 0:0:0:80: [sdcc] Mode Sense: 63 00 00 08
 sddg: sddg1
sd 0:0:0:110: [sddg] Attached SCSI disk
 sddj: sddj1
sd 0:0:0:113: [sddj] Attached SCSI disk
sd 0:0:0:125: [sddv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:134: [sdee] Write Protect is off
sd 0:0:0:134: [sdee] Mode Sense: 63 00 00 08
sd 0:0:0:139: [sdej] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:139: [sdej] Write Protect is off
sd 0:0:0:139: [sdej] Mode Sense: 63 00 00 08
sd 0:0:0:140: [sdek] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:133: [sded] Write Protect is off
sd 0:0:0:133: [sded] Mode Sense: 63 00 00 08
sd 0:0:0:133: [sded] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:53: [sdbb] Attached SCSI disk
sd 0:0:0:128: [sddy] Write Protect is off
sd 0:0:0:128: [sddy] Mode Sense: 63 00 00 08
sd 0:0:0:141: [sdel] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:116: [sddm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:123: [sddt] Write Protect is off
sd 0:0:0:123: [sddt] Mode Sense: 63 00 00 08
sd 0:0:0:123: [sddt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddl: sddl1
sd 0:0:0:115: [sddl] Attached SCSI disk
sd 0:0:0:117: [sddn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:135: [sdef] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:137: [sdeh] Write Protect is off
sd 0:0:0:137: [sdeh] Mode Sense: 63 00 00 08
 sdcy: sdcy1
sd 0:0:0:102: [sdcy] Attached SCSI disk
sd 0:0:0:130: [sdea] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:131: [sdeb] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sddu: sddu1
sd 0:0:0:124: [sddu] Attached SCSI disk
sd 0:0:0:80: [sdcc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddo: sddo1
sd 0:0:0:118: [sddo] Attached SCSI disk
sd 0:0:0:132: [sdec] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:143: [sden] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:144: [sdeo] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:145: [sdep] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:146: [sdeq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:134: [sdee] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:143: [sden] Write Protect is off
sd 0:0:0:143: [sden] Mode Sense: 63 00 00 08
 sddd: sddd1
sd 0:0:0:107: [sddd] Attached SCSI disk
sd 0:0:0:128: [sddy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:141: [sdel] Write Protect is off
sd 0:0:0:141: [sdel] Mode Sense: 63 00 00 08
sd 0:0:0:140: [sdek] Write Protect is off
sd 0:0:0:140: [sdek] Mode Sense: 63 00 00 08
sd 0:0:0:140: [sdek] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:139: [sdej] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdds: sdds1
sd 0:0:0:122: [sdds] Attached SCSI disk
sd 0:0:0:148: [sdes] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:136: [sdeg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:137: [sdeh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddf: sddf1
sd 0:0:0:109: [sddf] Attached SCSI disk
sd 0:0:0:149: [sdet] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:130: [sdea] Write Protect is off
sd 0:0:0:130: [sdea] Mode Sense: 63 00 00 08
sd 0:0:0:131: [sdeb] Write Protect is off
sd 0:0:0:131: [sdeb] Mode Sense: 63 00 00 08
sd 0:0:0:85: [sdch] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddx: sddx1
sd 0:0:0:127: [sddx] Attached SCSI disk
sd 0:0:0:150: [sdeu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:151: [sdev] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdde: sdde1
sd 0:0:0:108: [sdde] Attached SCSI disk
sd 0:0:0:132: [sdec] Write Protect is off
sd 0:0:0:132: [sdec] Mode Sense: 63 00 00 08
sd 0:0:0:145: [sdep] Write Protect is off
sd 0:0:0:145: [sdep] Mode Sense: 63 00 00 08
sd 0:0:0:145: [sdep] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:150: [sdeu] Write Protect is off
sd 0:0:0:150: [sdeu] Mode Sense: 63 00 00 08
sd 0:0:0:144: [sdeo] Write Protect is off
sd 0:0:0:144: [sdeo] Mode Sense: 63 00 00 08
 sddv: sddv1
sd 0:0:0:125: [sddv] Attached SCSI disk
 sddw: sddw1
sd 0:0:0:126: [sddw] Attached SCSI disk
sd 0:0:0:146: [sdeq] Write Protect is off
sd 0:0:0:146: [sdeq] Mode Sense: 63 00 00 08
 sddk: sddk1
sd 0:0:0:114: [sddk] Attached SCSI disk
sd 0:0:0:143: [sden] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:141: [sdel] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:153: [sdex] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:154: [sdey] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:136: [sdeg] Write Protect is off
sd 0:0:0:136: [sdeg] Mode Sense: 63 00 00 08
sd 0:0:0:155: [sdez] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:148: [sdes] Write Protect is off
sd 0:0:0:148: [sdes] Mode Sense: 63 00 00 08
sd 0:0:0:148: [sdes] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddn: sddn1
sd 0:0:0:117: [sddn] Attached SCSI disk
sd 0:0:0:142: [sdem] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:142: [sdem] Write Protect is off
sd 0:0:0:142: [sdem] Mode Sense: 63 00 00 08
sd 0:0:0:157: [sdfb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:130: [sdea] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:131: [sdeb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:158: [sdfc] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:149: [sdet] Write Protect is off
sd 0:0:0:149: [sdet] Mode Sense: 63 00 00 08
 sddz: sddz1
sd 0:0:0:129: [sddz] Attached SCSI disk
 sdef: sdef1
sd 0:0:0:135: [sdef] Attached SCSI disk
sd 0:0:0:151: [sdev] Write Protect is off
sd 0:0:0:151: [sdev] Mode Sense: 63 00 00 08
sd 0:0:0:151: [sdev] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdcc: sdcc1
sd 0:0:0:157: [sdfb] Write Protect is off
sd 0:0:0:157: [sdfb] Mode Sense: 63 00 00 08
 sdco: sdco1
sd 0:0:0:92: [sdco] Attached SCSI disk
sd 0:0:0:132: [sdec] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:161: [sdff] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:144: [sdeo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:150: [sdeu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddt: sddt1
sd 0:0:0:123: [sddt] Attached SCSI disk
 sded: sded1
sd 0:0:0:133: [sded] Attached SCSI disk
 sdee: sdee1
sd 0:0:0:134: [sdee] Attached SCSI disk
sd 0:0:0:153: [sdex] Write Protect is off
sd 0:0:0:153: [sdex] Mode Sense: 63 00 00 08
sd 0:0:0:154: [sdey] Write Protect is off
sd 0:0:0:154: [sdey] Mode Sense: 63 00 00 08
 sddy: sddy1
sd 0:0:0:128: [sddy] Attached SCSI disk
sd 0:0:0:136: [sdeg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:163: [sdfh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:147: [sder] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:147: [sder] Write Protect is off
sd 0:0:0:147: [sder] Mode Sense: 63 00 00 08
sd 0:0:0:164: [sdfi] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:106: [sddc] Write Protect is off
sd 0:0:0:106: [sddc] Mode Sense: 63 00 00 08
sd 0:0:0:106: [sddc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:155: [sdez] Write Protect is off
sd 0:0:0:155: [sdez] Mode Sense: 63 00 00 08
sd 0:0:0:165: [sdfj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:163: [sdfh] Write Protect is off
sd 0:0:0:163: [sdfh] Mode Sense: 63 00 00 08
sd 0:0:0:149: [sdet] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:166: [sdfk] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdch: sdch1
sd 0:0:0:85: [sdch] Attached SCSI disk
sd 0:0:0:158: [sdfc] Write Protect is off
sd 0:0:0:158: [sdfc] Mode Sense: 63 00 00 08
 sdeh: sdeh1
sd 0:0:0:137: [sdeh] Attached SCSI disk
sd 0:0:0:157: [sdfb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:168: [sdfm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:152: [sdew] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdek: sdek1
sd 0:0:0:140: [sdek] Attached SCSI disk
sd 0:0:0:161: [sdff] Write Protect is off
sd 0:0:0:161: [sdff] Mode Sense: 63 00 00 08
sd 0:0:0:161: [sdff] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:169: [sdfn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:153: [sdex] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:170: [sdfo] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:154: [sdey] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:156: [sdfa] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sden: sden1
sd 0:0:0:143: [sden] Attached SCSI disk
sd 0:0:0:170: [sdfo] Write Protect is off
sd 0:0:0:170: [sdfo] Mode Sense: 63 00 00 08
sd 0:0:0:164: [sdfi] Write Protect is off
sd 0:0:0:164: [sdfi] Mode Sense: 63 00 00 08
 sdel: sdel1
sd 0:0:0:141: [sdel] Attached SCSI disk
sd 0:0:0:155: [sdez] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:172: [sdfq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:160: [sdfe] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:159: [sdfd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:163: [sdfh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:142: [sdem] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:165: [sdfj] Write Protect is off
sd 0:0:0:165: [sdfj] Mode Sense: 63 00 00 08
 sdea: sdea1
sd 0:0:0:130: [sdea] Attached SCSI disk
sd 0:0:0:111: [sddh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdeb: sdeb1
sd 0:0:0:131: [sdeb] Attached SCSI disk
 sdec: sdec1
sd 0:0:0:132: [sdec] Attached SCSI disk
sd 0:0:0:158: [sdfc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:173: [sdfr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:166: [sdfk] Write Protect is off
sd 0:0:0:166: [sdfk] Mode Sense: 63 00 00 08
sd 0:0:0:166: [sdfk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdeo: sdeo1
sd 0:0:0:144: [sdeo] Attached SCSI disk
 sdep: sdep1
sd 0:0:0:145: [sdep] Attached SCSI disk
sd 0:0:0:176: [sdfu] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdeu: sdeu1
sd 0:0:0:150: [sdeu] Attached SCSI disk
sd 0:0:0:177: [sdfv] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:169: [sdfn] Write Protect is off
sd 0:0:0:169: [sdfn] Mode Sense: 63 00 00 08
sd 0:0:0:178: [sdfw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:162: [sdfg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:168: [sdfm] Write Protect is off
sd 0:0:0:168: [sdfm] Mode Sense: 63 00 00 08
sd 0:0:0:152: [sdew] Write Protect is off
sd 0:0:0:152: [sdew] Mode Sense: 63 00 00 08
sd 0:0:0:152: [sdew] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:176: [sdfu] Write Protect is off
sd 0:0:0:176: [sdfu] Mode Sense: 63 00 00 08
sd 0:0:0:156: [sdfa] Write Protect is off
sd 0:0:0:156: [sdfa] Mode Sense: 63 00 00 08
sd 0:0:0:170: [sdfo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:147: [sder] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:164: [sdfi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:179: [sdfx] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdeg: sdeg1
sd 0:0:0:136: [sdeg] Attached SCSI disk
sd 0:0:0:159: [sdfd] Write Protect is off
sd 0:0:0:159: [sdfd] Mode Sense: 63 00 00 08
sd 0:0:0:172: [sdfq] Write Protect is off
sd 0:0:0:172: [sdfq] Mode Sense: 63 00 00 08
sd 0:0:0:160: [sdfe] Write Protect is off
sd 0:0:0:160: [sdfe] Mode Sense: 63 00 00 08
sd 0:0:0:165: [sdfj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:167: [sdfl] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdes: sdes1
sd 0:0:0:148: [sdes] Attached SCSI disk
sd 0:0:0:173: [sdfr] Write Protect is off
sd 0:0:0:173: [sdfr] Mode Sense: 63 00 00 08
sd 0:0:0:181: [sdfz] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfb: sdfb1
sd 0:0:0:157: [sdfb] Attached SCSI disk
 sdev: sdev1
sd 0:0:0:183: [sdgb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:181: [sdfz] Write Protect is off
sd 0:0:0:181: [sdfz] Mode Sense: 63 00 00 08
sd 0:0:0:168: [sdfm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:178: [sdfw] Write Protect is off
sd 0:0:0:178: [sdfw] Mode Sense: 63 00 00 08
sd 0:0:0:162: [sdfg] Write Protect is off
sd 0:0:0:162: [sdfg] Mode Sense: 63 00 00 08
sd 0:0:0:169: [sdfn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:177: [sdfv] Write Protect is off
sd 0:0:0:177: [sdfv] Mode Sense: 63 00 00 08
sd 0:0:0:171: [sdfp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:156: [sdfa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:184: [sdgc] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdex: sdex1
sd 0:0:0:153: [sdex] Attached SCSI disk
sd 0:0:0:176: [sdfu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddc: sddc1
sd 0:0:0:106: [sddc] Attached SCSI disk
sd 0:0:0:179: [sdfx] Write Protect is off
sd 0:0:0:179: [sdfx] Mode Sense: 63 00 00 08
sd 0:0:0:179: [sdfx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdey: sdey1
sd 0:0:0:154: [sdey] Attached SCSI disk
sd 0:0:0:188: [sdgg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:189: [sdgh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:172: [sdfq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:167: [sdfl] Write Protect is off
sd 0:0:0:167: [sdfl] Mode Sense: 63 00 00 08
sd 0:0:0:190: [sdgi] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sddm: sddm1
sd 0:0:0:160: [sdfe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdem: sdem1
sd 0:0:0:142: [sdem] Attached SCSI disk
sd 0:0:0:192: [sdgk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:159: [sdfd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddh: sddh1
sd 0:0:0:111: [sddh] Attached SCSI disk
 sdfh: sdfh1
sd 0:0:0:163: [sdfh] Attached SCSI disk
sd 0:0:0:174: [sdfs] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfc: sdfc1
sd 0:0:0:158: [sdfc] Attached SCSI disk
sd 0:0:0:192: [sdgk] Write Protect is off
sd 0:0:0:192: [sdgk] Mode Sense: 63 00 00 08
sd 0:0:0:192: [sdgk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:173: [sdfr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:175: [sdft] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdff: sdff1
sd 0:0:0:161: [sdff] Attached SCSI disk
sd 0:0:0:183: [sdgb] Write Protect is off
sd 0:0:0:183: [sdgb] Mode Sense: 63 00 00 08
sd 0:0:0:178: [sdfw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:162: [sdfg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:177: [sdfv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:181: [sdfz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sddr: sddr1
sd 0:0:0:121: [sddr] Attached SCSI disk
sd 0:0:0:180: [sdfy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:171: [sdfp] Write Protect is off
sd 0:0:0:171: [sdfp] Mode Sense: 63 00 00 08
sd 0:0:0:171: [sdfp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:184: [sdgc] Write Protect is off
sd 0:0:0:184: [sdgc] Mode Sense: 63 00 00 08
sd 0:0:0:184: [sdgc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:138: [sdei] Write Protect is off
sd 0:0:0:138: [sdei] Mode Sense: 63 00 00 08
sd 0:0:0:195: [sdgn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:196: [sdgo] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sder: sder1
sd 0:0:0:147: [sder] Attached SCSI disk
sd 0:0:0:189: [sdgh] Write Protect is off
sd 0:0:0:189: [sdgh] Mode Sense: 63 00 00 08
sd 0:0:0:189: [sdgh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfi: sdfi1
sd 0:0:0:164: [sdfi] Attached SCSI disk
 sdfo: sdfo1
sd 0:0:0:170: [sdfo] Attached SCSI disk
sd 0:0:0:167: [sdfl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:190: [sdgi] Write Protect is off
sd 0:0:0:190: [sdgi] Mode Sense: 63 00 00 08
 sdfj: sdfj1
sd 0:0:0:165: [sdfj] Attached SCSI disk
sd 0:0:0:182: [sdga] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:196: [sdgo] Write Protect is off
sd 0:0:0:196: [sdgo] Mode Sense: 63 00 00 08
sd 0:0:0:174: [sdfs] Write Protect is off
sd 0:0:0:174: [sdfs] Mode Sense: 63 00 00 08
sd 0:0:0:174: [sdfs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:188: [sdgg] Write Protect is off
sd 0:0:0:188: [sdgg] Mode Sense: 63 00 00 08
sd 0:0:0:188: [sdgg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:175: [sdft] Write Protect is off
sd 0:0:0:175: [sdft] Mode Sense: 63 00 00 08
 sdfk: sdfk1
sd 0:0:0:166: [sdfk] Attached SCSI disk
sd 0:0:0:185: [sdgd] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sddp: sddp1
sd 0:0:0:119: [sddp] Attached SCSI disk
sd 0:0:0:186: [sdge] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfm: sdfm1
sd 0:0:0:168: [sdfm] Attached SCSI disk
sd 0:0:0:183: [sdgb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:203: [sdgv] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfn: sdfn1
sd 0:0:0:169: [sdfn] Attached SCSI disk
sd 0:0:0:187: [sdgf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:180: [sdfy] Write Protect is off
sd 0:0:0:180: [sdfy] Mode Sense: 63 00 00 08
 sdfa: sdfa1
sd 0:0:0:156: [sdfa] Attached SCSI disk
 sdfu: sdfu1
sd 0:0:0:176: [sdfu] Attached SCSI disk
sd 0:0:0:138: [sdei] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:195: [sdgn] Write Protect is off
sd 0:0:0:195: [sdgn] Mode Sense: 63 00 00 08
sd 0:0:0:195: [sdgn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:191: [sdgj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:203: [sdgv] Write Protect is off
sd 0:0:0:203: [sdgv] Mode Sense: 63 00 00 08
 sdfe: sdfe1
sd 0:0:0:160: [sdfe] Attached SCSI disk
sd 0:0:0:207: [sdgz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:190: [sdgi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:208: [sdha] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:182: [sdga] Write Protect is off
sd 0:0:0:182: [sdga] Mode Sense: 63 00 00 08
sd 0:0:0:193: [sdgl] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:196: [sdgo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfq: sdfq1
sd 0:0:0:172: [sdfq] Attached SCSI disk
 sdfd: sdfd1
sd 0:0:0:159: [sdfd] Attached SCSI disk
sd 0:0:0:209: [sdhb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:175: [sdft] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfr: sdfr1
sd 0:0:0:173: [sdfr] Attached SCSI disk
sd 0:0:0:194: [sdgm] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfz: sdfz1
sd 0:0:0:181: [sdfz] Attached SCSI disk
sd 0:0:0:212: [sdhe] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdfw: sdfw1
sd 0:0:0:178: [sdfw] Attached SCSI disk
sd 0:0:0:146: [sdeq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:185: [sdgd] Write Protect is off
sd 0:0:0:185: [sdgd] Mode Sense: 63 00 00 08
 sdfv: sdfv1
sd 0:0:0:177: [sdfv] Attached SCSI disk
sd 0:0:0:180: [sdfy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:198: [sdgq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:186: [sdge] Write Protect is off
sd 0:0:0:186: [sdge] Mode Sense: 63 00 00 08
sd 0:0:0:187: [sdgf] Write Protect is off
sd 0:0:0:187: [sdgf] Mode Sense: 63 00 00 08
sd 0:0:0:197: [sdgp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:199: [sdgr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:212: [sdhe] Write Protect is off
sd 0:0:0:212: [sdhe] Mode Sense: 63 00 00 08
sd 0:0:0:212: [sdhe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:203: [sdgv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfx: sdfx1
sd 0:0:0:179: [sdfx] Attached SCSI disk
 sdfl: sdfl1
sd 0:0:0:167: [sdfl] Attached SCSI disk
sd 0:0:0:200: [sdgs] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:193: [sdgl] Write Protect is off
sd 0:0:0:193: [sdgl] Mode Sense: 63 00 00 08
sd 0:0:0:191: [sdgj] Write Protect is off
sd 0:0:0:191: [sdgj] Mode Sense: 63 00 00 08
sd 0:0:0:191: [sdgj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:207: [sdgz] Write Protect is off
sd 0:0:0:207: [sdgz] Mode Sense: 63 00 00 08
sd 0:0:0:182: [sdga] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdej: sdej1
sd 0:0:0:139: [sdej] Attached SCSI disk
sd 0:0:0:209: [sdhb] Write Protect is off
sd 0:0:0:209: [sdhb] Mode Sense: 63 00 00 08
sd 0:0:0:215: [sdhh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:201: [sdgt] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:208: [sdha] Write Protect is off
sd 0:0:0:208: [sdha] Mode Sense: 63 00 00 08
 sdgk: sdgk1
sd 0:0:0:192: [sdgk] Attached SCSI disk
sd 0:0:0:202: [sdgu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:216: [sdhi] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:185: [sdgd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:217: [sdhj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:194: [sdgm] Write Protect is off
sd 0:0:0:194: [sdgm] Mode Sense: 63 00 00 08
sd 0:0:0:194: [sdgm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfp: sdfp1
sd 0:0:0:171: [sdfp] Attached SCSI disk
 sdgb: sdgb1
sd 0:0:0:183: [sdgb] Attached SCSI disk
 sdgc: sdgc1
sd 0:0:0:184: [sdgc] Attached SCSI disk
sd 0:0:0:187: [sdgf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:204: [sdgw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:186: [sdge] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:198: [sdgq] Write Protect is off
sd 0:0:0:198: [sdgq] Mode Sense: 63 00 00 08
sd 0:0:0:80: [sdcc] Attached SCSI disk
sd 0:0:0:205: [sdgx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:197: [sdgp] Write Protect is off
sd 0:0:0:197: [sdgp] Mode Sense: 63 00 00 08
sd 0:0:0:206: [sdgy] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdei: sdei1
sd 0:0:0:219: [sdhl] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:207: [sdgz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgh: sdgh1
sd 0:0:0:189: [sdgh] Attached SCSI disk
sd 0:0:0:200: [sdgs] Write Protect is off
sd 0:0:0:200: [sdgs] Mode Sense: 63 00 00 08
sd 0:0:0:199: [sdgr] Write Protect is off
sd 0:0:0:199: [sdgr] Mode Sense: 63 00 00 08
sd 0:0:0:199: [sdgr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:193: [sdgl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:220: [sdhm] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdgi: sdgi1
sd 0:0:0:190: [sdgi] Attached SCSI disk
sd 0:0:0:210: [sdhc] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdgo: sdgo1
sd 0:0:0:196: [sdgo] Attached SCSI disk
sd 0:0:0:211: [sdhd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:220: [sdhm] Write Protect is off
sd 0:0:0:220: [sdhm] Mode Sense: 63 00 00 08
 sdfs: sdfs1
sd 0:0:0:174: [sdfs] Attached SCSI disk
sd 0:0:0:209: [sdhb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:221: [sdhn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:202: [sdgu] Write Protect is off
sd 0:0:0:202: [sdgu] Mode Sense: 63 00 00 08
sd 0:0:0:213: [sdhf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:201: [sdgt] Write Protect is off
sd 0:0:0:201: [sdgt] Mode Sense: 63 00 00 08
sd 0:0:0:208: [sdha] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:216: [sdhi] Write Protect is off
sd 0:0:0:216: [sdhi] Mode Sense: 63 00 00 08
 sdft: sdft1
sd 0:0:0:175: [sdft] Attached SCSI disk
sd 0:0:0:222: [sdho] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:217: [sdhj] Write Protect is off
sd 0:0:0:217: [sdhj] Mode Sense: 63 00 00 08
sd 0:0:0:204: [sdgw] Write Protect is off
sd 0:0:0:204: [sdgw] Mode Sense: 63 00 00 08
sd 0:0:0:197: [sdgp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:205: [sdgx] Write Protect is off
sd 0:0:0:205: [sdgx] Mode Sense: 63 00 00 08
sd 0:0:0:198: [sdgq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdfy: sdfy1
sd 0:0:0:180: [sdfy] Attached SCSI disk
sd 0:0:0:206: [sdgy] Write Protect is off
sd 0:0:0:206: [sdgy] Mode Sense: 63 00 00 08
sd 0:0:0:214: [sdhg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:223: [sdhp] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:224: [sdhq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:225: [sdhr] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:219: [sdhl] Write Protect is off
sd 0:0:0:219: [sdhl] Mode Sense: 63 00 00 08
 sdgn: sdgn1
sd 0:0:0:195: [sdgn] Attached SCSI disk
sd 0:0:0:223: [sdhp] Write Protect is off
sd 0:0:0:223: [sdhp] Mode Sense: 63 00 00 08
 sdgv: sdgv1
sd 0:0:0:203: [sdgv] Attached SCSI disk
sd 0:0:0:227: [sdht] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:200: [sdgs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:211: [sdhd] Write Protect is off
sd 0:0:0:211: [sdhd] Mode Sense: 63 00 00 08
sd 0:0:0:201: [sdgt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdga: sdga1
sd 0:0:0:182: [sdga] Attached SCSI disk
sd 0:0:0:220: [sdhm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:221: [sdhn] Write Protect is off
sd 0:0:0:221: [sdhn] Mode Sense: 63 00 00 08
sd 0:0:0:202: [sdgu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:228: [sdhu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:213: [sdhf] Write Protect is off
sd 0:0:0:213: [sdhf] Mode Sense: 63 00 00 08
sd 0:0:0:210: [sdhc] Write Protect is off
sd 0:0:0:210: [sdhc] Mode Sense: 63 00 00 08
sd 0:0:0:216: [sdhi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:229: [sdhv] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdet: sdet1
sd 0:0:0:149: [sdet] Attached SCSI disk
sd 0:0:0:230: [sdhw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:218: [sdhk] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdgd: sdgd1
sd 0:0:0:185: [sdgd] Attached SCSI disk
sd 0:0:0:217: [sdhj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:232: [sdhy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:222: [sdho] Write Protect is off
sd 0:0:0:222: [sdho] Mode Sense: 63 00 00 08
sd 0:0:0:204: [sdgw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:205: [sdgx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdhe: sdhe1
sd 0:0:0:212: [sdhe] Attached SCSI disk
sd 0:0:0:214: [sdhg] Write Protect is off
sd 0:0:0:214: [sdhg] Mode Sense: 63 00 00 08
sd 0:0:0:206: [sdgy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:232: [sdhy] Write Protect is off
sd 0:0:0:232: [sdhy] Mode Sense: 63 00 00 08
 sdge: sdge1
sd 0:0:0:186: [sdge] Attached SCSI disk
sd 0:0:0:225: [sdhr] Write Protect is off
sd 0:0:0:225: [sdhr] Mode Sense: 63 00 00 08
sd 0:0:0:233: [sdhz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:224: [sdhq] Write Protect is off
sd 0:0:0:224: [sdhq] Mode Sense: 63 00 00 08
sd 0:0:0:234: [sdia] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:219: [sdhl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgf: sdgf1
sd 0:0:0:187: [sdgf] Attached SCSI disk
sd 0:0:0:236: [sdic] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:223: [sdhp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgj: sdgj1
sd 0:0:0:191: [sdgj] Attached SCSI disk
sd 0:0:0:237: [sdid] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdgz: sdgz1
sd 0:0:0:207: [sdgz] Attached SCSI disk
 sdgl: sdgl1
sd 0:0:0:193: [sdgl] Attached SCSI disk
sd 0:0:0:238: [sdie] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:221: [sdhn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:227: [sdht] Write Protect is off
sd 0:0:0:227: [sdht] Mode Sense: 63 00 00 08
sd 0:0:0:227: [sdht] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:211: [sdhd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:210: [sdhc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:228: [sdhu] Write Protect is off
sd 0:0:0:228: [sdhu] Mode Sense: 63 00 00 08
sd 0:0:0:213: [sdhf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:229: [sdhv] Write Protect is off
sd 0:0:0:229: [sdhv] Mode Sense: 63 00 00 08
sd 0:0:0:239: [sdif] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhb: sdhb1
sd 0:0:0:209: [sdhb] Attached SCSI disk
 sdha: sdha1
sd 0:0:0:208: [sdha] Attached SCSI disk
sd 0:0:0:230: [sdhw] Write Protect is off
sd 0:0:0:230: [sdhw] Mode Sense: 63 00 00 08
sd 0:0:0:218: [sdhk] Write Protect is off
sd 0:0:0:218: [sdhk] Mode Sense: 63 00 00 08
sd 0:0:0:239: [sdif] Write Protect is off
sd 0:0:0:239: [sdif] Mode Sense: 63 00 00 08
sd 0:0:0:222: [sdho] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:240: [sdig] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:116: [sddm] Attached SCSI disk
sd 0:0:0:241: [sdih] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdez: sdez1
sd 0:0:0:155: [sdez] Attached SCSI disk
 sdgm: sdgm1
sd 0:0:0:194: [sdgm] Attached SCSI disk
sd 0:0:0:232: [sdhy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgq: sdgq1
sd 0:0:0:198: [sdgq] Attached SCSI disk
sd 0:0:0:214: [sdhg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgr: sdgr1
sd 0:0:0:199: [sdgr] Attached SCSI disk
sd 0:0:0:224: [sdhq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:226: [sdhs] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:233: [sdhz] Write Protect is off
sd 0:0:0:233: [sdhz] Mode Sense: 63 00 00 08
sd 0:0:0:234: [sdia] Write Protect is off
sd 0:0:0:234: [sdia] Mode Sense: 63 00 00 08
 sdgp: sdgp1
sd 0:0:0:197: [sdgp] Attached SCSI disk
sd 0:0:0:243: [sdij] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:236: [sdic] Write Protect is off
sd 0:0:0:236: [sdic] Mode Sense: 63 00 00 08
sd 0:0:0:237: [sdid] Write Protect is off
sd 0:0:0:237: [sdid] Mode Sense: 63 00 00 08
sd 0:0:0:237: [sdid] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:225: [sdhr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:238: [sdie] Write Protect is off
sd 0:0:0:238: [sdie] Mode Sense: 63 00 00 08
sd 0:0:0:238: [sdie] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:244: [sdik] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:228: [sdhu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgs: sdgs1
sd 0:0:0:200: [sdgs] Attached SCSI disk
 sdhm: sdhm1
sd 0:0:0:220: [sdhm] Attached SCSI disk
 sdgt: sdgt1
sd 0:0:0:201: [sdgt] Attached SCSI disk
sd 0:0:0:229: [sdhv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdgu: sdgu1
sd 0:0:0:202: [sdgu] Attached SCSI disk
sd 0:0:0:231: [sdhx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:246: [sdim] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:218: [sdhk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:230: [sdhw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:247: [sdin] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:244: [sdik] Write Protect is off
sd 0:0:0:244: [sdik] Mode Sense: 63 00 00 08
 sdhi: sdhi1
sd 0:0:0:216: [sdhi] Attached SCSI disk
sd 0:0:0:239: [sdif] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:240: [sdig] Write Protect is off
sd 0:0:0:240: [sdig] Mode Sense: 63 00 00 08
 sdgw: sdgw1
sd 0:0:0:204: [sdgw] Attached SCSI disk
sd 0:0:0:235: [sdib] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdgx: sdgx1
sd 0:0:0:205: [sdgx] Attached SCSI disk
 sdhj: sdhj1
sd 0:0:0:217: [sdhj] Attached SCSI disk
 sdew: sdew1
sd 0:0:0:152: [sdew] Attached SCSI disk
sd 0:0:0:226: [sdhs] Write Protect is off
sd 0:0:0:226: [sdhs] Mode Sense: 63 00 00 08
sd 0:0:0:233: [sdhz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:234: [sdia] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:249: [sdip] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:243: [sdij] Write Protect is off
sd 0:0:0:243: [sdij] Mode Sense: 63 00 00 08
 sdgy: sdgy1
sd 0:0:0:206: [sdgy] Attached SCSI disk
sd 0:0:0:236: [sdic] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:251: [sdir] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhl: sdhl1
sd 0:0:0:219: [sdhl] Attached SCSI disk
sd 0:0:0:253: [sdit] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:254: [sdiu] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:255: [sdiv] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhn: sdhn1
sd 0:0:0:221: [sdhn] Attached SCSI disk
 sdhc: sdhc1
sd 0:0:0:210: [sdhc] Attached SCSI disk
sd 0:0:0:251: [sdir] Write Protect is off
sd 0:0:0:251: [sdir] Mode Sense: 63 00 00 08
sd 0:0:0:251: [sdir] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:231: [sdhx] Write Protect is off
sd 0:0:0:231: [sdhx] Mode Sense: 63 00 00 08
sd 0:0:0:241: [sdih] Write Protect is off
sd 0:0:0:241: [sdih] Mode Sense: 63 00 00 08
sd 0:0:0:258: [sdiy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:246: [sdim] Write Protect is off
sd 0:0:0:246: [sdim] Mode Sense: 63 00 00 08
sd 0:0:0:259: [sdiz] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhd: sdhd1
sd 0:0:0:211: [sdhd] Attached SCSI disk
sd 0:0:0:244: [sdik] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:260: [sdja] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:261: [sdjb] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:240: [sdig] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:247: [sdin] Write Protect is off
sd 0:0:0:247: [sdin] Mode Sense: 63 00 00 08
 sdhf: sdhf1
sd 0:0:0:213: [sdhf] Attached SCSI disk
 sdho: sdho1
sd 0:0:0:222: [sdho] Attached SCSI disk
sd 0:0:0:242: [sdii] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:242: [sdii] Write Protect is off
sd 0:0:0:242: [sdii] Mode Sense: 63 00 00 08
sd 0:0:0:264: [sdje] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:265: [sdjf] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:266: [sdjg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:235: [sdib] Write Protect is off
sd 0:0:0:235: [sdib] Mode Sense: 63 00 00 08
 sdfg: sdfg1
sd 0:0:0:162: [sdfg] Attached SCSI disk
sd 0:0:0:226: [sdhs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:249: [sdip] Write Protect is off
sd 0:0:0:249: [sdip] Mode Sense: 63 00 00 08
 sdhy: sdhy1
sd 0:0:0:232: [sdhy] Attached SCSI disk
sd 0:0:0:265: [sdjf] Write Protect is off
sd 0:0:0:265: [sdjf] Mode Sense: 63 00 00 08
sd 0:0:0:265: [sdjf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:255: [sdiv] Write Protect is off
sd 0:0:0:255: [sdiv] Mode Sense: 63 00 00 08
 sdhr: sdhr1
sd 0:0:0:225: [sdhr] Attached SCSI disk
sd 0:0:0:254: [sdiu] Write Protect is off
sd 0:0:0:254: [sdiu] Mode Sense: 63 00 00 08
sd 0:0:0:245: [sdil] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:267: [sdjh] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhq: sdhq1
sd 0:0:0:224: [sdhq] Attached SCSI disk
sd 0:0:0:269: [sdjj] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:253: [sdit] Write Protect is off
sd 0:0:0:253: [sdit] Mode Sense: 63 00 00 08
 sdht: sdht1
sd 0:0:0:227: [sdht] Attached SCSI disk
sd 0:0:0:231: [sdhx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:246: [sdim] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:241: [sdih] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:259: [sdiz] Write Protect is off
sd 0:0:0:259: [sdiz] Mode Sense: 63 00 00 08
sd 0:0:0:259: [sdiz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdhu: sdhu1
sd 0:0:0:228: [sdhu] Attached SCSI disk
sd 0:0:0:260: [sdja] Write Protect is off
sd 0:0:0:260: [sdja] Mode Sense: 63 00 00 08
sd 0:0:0:258: [sdiy] Write Protect is off
sd 0:0:0:258: [sdiy] Mode Sense: 63 00 00 08
sd 0:0:0:270: [sdjk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:248: [sdio] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:271: [sdjl] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhk: sdhk1
sd 0:0:0:218: [sdhk] Attached SCSI disk
sd 0:0:0:272: [sdjm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:273: [sdjn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:215: [sdhh] Write Protect is off
sd 0:0:0:215: [sdhh] Mode Sense: 63 00 00 08
sd 0:0:0:274: [sdjo] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhw: sdhw1
sd 0:0:0:230: [sdhw] Attached SCSI disk
sd 0:0:0:264: [sdje] Write Protect is off
sd 0:0:0:264: [sdje] Mode Sense: 63 00 00 08
sd 0:0:0:266: [sdjg] Write Protect is off
sd 0:0:0:266: [sdjg] Mode Sense: 63 00 00 08
sd 0:0:0:266: [sdjg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:270: [sdjk] Write Protect is off
sd 0:0:0:270: [sdjk] Mode Sense: 63 00 00 08
sd 0:0:0:247: [sdin] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:250: [sdiq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:235: [sdib] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdif: sdif1
sd 0:0:0:239: [sdif] Attached SCSI disk
sd 0:0:0:249: [sdip] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:252: [sdis] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:254: [sdiu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:255: [sdiv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdia: sdia1
sd 0:0:0:234: [sdia] Attached SCSI disk
sd 0:0:0:253: [sdit] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdhz: sdhz1
sd 0:0:0:233: [sdhz] Attached SCSI disk
 sdic: sdic1
sd 0:0:0:236: [sdic] Attached SCSI disk
 sdid: sdid1
sd 0:0:0:237: [sdid] Attached SCSI disk
sd 0:0:0:245: [sdil] Write Protect is off
sd 0:0:0:245: [sdil] Mode Sense: 63 00 00 08
sd 0:0:0:267: [sdjh] Write Protect is off
sd 0:0:0:267: [sdjh] Mode Sense: 63 00 00 08
sd 0:0:0:269: [sdjj] Write Protect is off
sd 0:0:0:269: [sdjj] Mode Sense: 63 00 00 08
sd 0:0:0:269: [sdjj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:277: [sdjr] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdie: sdie1
sd 0:0:0:238: [sdie] Attached SCSI disk
sd 0:0:0:256: [sdiw] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdeq: sdeq1
sd 0:0:0:146: [sdeq] Attached SCSI disk
 sdgg: sdgg1
sd 0:0:0:188: [sdgg] Attached SCSI disk
sd 0:0:0:278: [sdjs] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:257: [sdix] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:262: [sdjc] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:258: [sdiy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdik: sdik1
sd 0:0:0:244: [sdik] Attached SCSI disk
sd 0:0:0:263: [sdjd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:248: [sdio] Write Protect is off
sd 0:0:0:248: [sdio] Mode Sense: 63 00 00 08
sd 0:0:0:271: [sdjl] Write Protect is off
sd 0:0:0:271: [sdjl] Mode Sense: 63 00 00 08
sd 0:0:0:215: [sdhh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:277: [sdjr] Write Protect is off
sd 0:0:0:277: [sdjr] Mode Sense: 63 00 00 08
sd 0:0:0:277: [sdjr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdig: sdig1
sd 0:0:0:242: [sdii] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:264: [sdje] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:279: [sdjt] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:279: [sdjt] Write Protect is off
sd 0:0:0:279: [sdjt] Mode Sense: 63 00 00 08
sd 0:0:0:273: [sdjn] Write Protect is off
sd 0:0:0:273: [sdjn] Mode Sense: 63 00 00 08
sd 0:0:0:250: [sdiq] Write Protect is off
sd 0:0:0:250: [sdiq] Mode Sense: 63 00 00 08
sd 0:0:0:280: [sdju] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:270: [sdjk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:274: [sdjo] Write Protect is off
sd 0:0:0:274: [sdjo] Mode Sense: 63 00 00 08
sd 0:0:0:138: [sdei] Attached SCSI disk
sd 0:0:0:281: [sdjv] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhs: sdhs1
sd 0:0:0:226: [sdhs] Attached SCSI disk
sd 0:0:0:282: [sdjw] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:282: [sdjw] Write Protect is off
sd 0:0:0:282: [sdjw] Mode Sense: 63 00 00 08
sd 0:0:0:283: [sdjx] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:245: [sdil] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:252: [sdis] Write Protect is off
sd 0:0:0:252: [sdis] Mode Sense: 63 00 00 08
sd 0:0:0:252: [sdis] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:267: [sdjh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:284: [sdjy] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:256: [sdiw] Write Protect is off
sd 0:0:0:256: [sdiw] Mode Sense: 63 00 00 08
sd 0:0:0:256: [sdiw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:285: [sdjz] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:257: [sdix] Write Protect is off
sd 0:0:0:257: [sdix] Mode Sense: 63 00 00 08
 sdhx: sdhx1
sd 0:0:0:231: [sdhx] Attached SCSI disk
sd 0:0:0:286: [sdka] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdih: sdih1
sd 0:0:0:241: [sdih] Attached SCSI disk
sd 0:0:0:248: [sdio] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:287: [sdkb] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdir: sdir1
sd 0:0:0:251: [sdir] Attached SCSI disk
sd 0:0:0:263: [sdjd] Write Protect is off
sd 0:0:0:263: [sdjd] Mode Sense: 63 00 00 08
sd 0:0:0:278: [sdjs] Write Protect is off
sd 0:0:0:278: [sdjs] Mode Sense: 63 00 00 08
sd 0:0:0:278: [sdjs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:288: [sdkc] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdim: sdim1
sd 0:0:0:246: [sdim] Attached SCSI disk
sd 0:0:0:271: [sdjl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:289: [sdkd] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:262: [sdjc] Write Protect is off
sd 0:0:0:262: [sdjc] Mode Sense: 63 00 00 08
sd 0:0:0:275: [sdjp] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdin: sdin1
sd 0:0:0:247: [sdin] Attached SCSI disk
sd 0:0:0:273: [sdjn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:250: [sdiq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:280: [sdju] Write Protect is off
sd 0:0:0:280: [sdju] Mode Sense: 63 00 00 08
sd 0:0:0:274: [sdjo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:290: [sdke] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:291: [sdkf] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdib: sdib1
sd 0:0:0:235: [sdib] Attached SCSI disk
 sdip: sdip1
sd 0:0:0:249: [sdip] Attached SCSI disk
sd 0:0:0:276: [sdjq] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:292: [sdkg] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:290: [sdke] Write Protect is off
sd 0:0:0:290: [sdke] Mode Sense: 63 00 00 08
sd 0:0:0:290: [sdke] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:293: [sdkh] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:294: [sdki] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdhp: sdhp1
sd 0:0:0:223: [sdhp] Attached SCSI disk
sd 0:0:0:284: [sdjy] Write Protect is off
sd 0:0:0:284: [sdjy] Mode Sense: 63 00 00 08
 sdiv: sdiv1
sd 0:0:0:255: [sdiv] Attached SCSI disk
 sdit: sdit1
sd 0:0:0:253: [sdit] Attached SCSI disk
 sdiu: sdiu1
sd 0:0:0:254: [sdiu] Attached SCSI disk
sd 0:0:0:297: [sdkl] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdjf: sdjf1
sd 0:0:0:265: [sdjf] Attached SCSI disk
sd 0:0:0:257: [sdix] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:299: [sdkn] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:262: [sdjc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:285: [sdjz] Write Protect is off
sd 0:0:0:285: [sdjz] Mode Sense: 63 00 00 08
sd 0:0:0:285: [sdjz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:287: [sdkb] Write Protect is off
sd 0:0:0:287: [sdkb] Mode Sense: 63 00 00 08
sd 0:0:0:288: [sdkc] Write Protect is off
sd 0:0:0:288: [sdkc] Mode Sense: 63 00 00 08
sd 0:0:0:288: [sdkc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:263: [sdjd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:281: [sdjv] Write Protect is off
sd 0:0:0:281: [sdjv] Mode Sense: 63 00 00 08
sd 0:0:0:281: [sdjv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:275: [sdjp] Write Protect is off
sd 0:0:0:275: [sdjp] Mode Sense: 63 00 00 08
sd 0:0:0:289: [sdkd] Write Protect is off
sd 0:0:0:289: [sdkd] Mode Sense: 63 00 00 08
sd 0:0:0:286: [sdka] Write Protect is off
sd 0:0:0:286: [sdka] Mode Sense: 63 00 00 08
 sdiy: sdiy1
sd 0:0:0:258: [sdiy] Attached SCSI disk
 sdhh: sdhh1
sd 0:0:0:215: [sdhh] Attached SCSI disk
sd 0:0:0:280: [sdju] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:279: [sdjt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdii: sdii1
sd 0:0:0:242: [sdii] Attached SCSI disk
sd 0:0:0:291: [sdkf] Write Protect is off
sd 0:0:0:291: [sdkf] Mode Sense: 63 00 00 08
 sdje: sdje1
sd 0:0:0:264: [sdje] Attached SCSI disk
sd 0:0:0:151: [sdev] Attached SCSI disk
sd 0:0:0:276: [sdjq] Write Protect is off
sd 0:0:0:276: [sdjq] Mode Sense: 63 00 00 08
 sdjk: sdjk1
sd 0:0:0:270: [sdjk] Attached SCSI disk
 sdjg: sdjg1
sd 0:0:0:266: [sdjg] Attached SCSI disk
sd 0:0:0:282: [sdjw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:292: [sdkg] Write Protect is off
sd 0:0:0:292: [sdkg] Mode Sense: 63 00 00 08
sd 0:0:0:292: [sdkg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:284: [sdjy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdil: sdil1
sd 0:0:0:245: [sdil] Attached SCSI disk
 sdjh: sdjh1
sd 0:0:0:267: [sdjh] Attached SCSI disk
 sdjj: sdjj1
sd 0:0:0:269: [sdjj] Attached SCSI disk
sd 0:0:0:293: [sdkh] Write Protect is off
sd 0:0:0:293: [sdkh] Mode Sense: 63 00 00 08
sd 0:0:0:293: [sdkh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:294: [sdki] Write Protect is off
sd 0:0:0:294: [sdki] Mode Sense: 63 00 00 08
sd 0:0:0:287: [sdkb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:275: [sdjp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:299: [sdkn] Write Protect is off
sd 0:0:0:299: [sdkn] Mode Sense: 63 00 00 08
sd 0:0:0:286: [sdka] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:289: [sdkd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdhg: sdhg1
sd 0:0:0:214: [sdhg] Attached SCSI disk
 sdjl: sdjl1
sd 0:0:0:271: [sdjl] Attached SCSI disk
 sdio: sdio1
sd 0:0:0:248: [sdio] Attached SCSI disk
 sdjr: sdjr1
sd 0:0:0:277: [sdjr] Attached SCSI disk
 sdjn: sdjn1
sd 0:0:0:273: [sdjn] Attached SCSI disk
 sdis: sdis1
sd 0:0:0:252: [sdis] Attached SCSI disk
 sdiq: sdiq1
sd 0:0:0:250: [sdiq] Attached SCSI disk
sd 0:0:0:295: [sdkj] 819200 512-byte logical blocks: (419 MB/400 MiB)
 sdjo: sdjo1
sd 0:0:0:274: [sdjo] Attached SCSI disk
sd 0:0:0:291: [sdkf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:296: [sdkk] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:298: [sdkm] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:294: [sdki] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdiw: sdiw1
sd 0:0:0:256: [sdiw] Attached SCSI disk
 sdjs: sdjs1
sd 0:0:0:278: [sdjs] Attached SCSI disk
sd 0:0:0:260: [sdja] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:299: [sdkn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdjc: sdjc1
sd 0:0:0:262: [sdjc] Attached SCSI disk
 sdix: sdix1
sd 0:0:0:257: [sdix] Attached SCSI disk
 sdjd: sdjd1
sd 0:0:0:263: [sdjd] Attached SCSI disk
sd 0:0:0:268: [sdji] 819200 512-byte logical blocks: (419 MB/400 MiB)
sd 0:0:0:268: [sdji] Write Protect is off
sd 0:0:0:268: [sdji] Mode Sense: 63 00 00 08
 sdjt: sdjt1
sd 0:0:0:279: [sdjt] Attached SCSI disk
sd 0:0:0:295: [sdkj] Write Protect is off
sd 0:0:0:295: [sdkj] Mode Sense: 63 00 00 08
sd 0:0:0:296: [sdkk] Write Protect is off
sd 0:0:0:296: [sdkk] Mode Sense: 63 00 00 08
 sdjw: sdjw1
sd 0:0:0:282: [sdjw] Attached SCSI disk
 sdke: sdke1
sd 0:0:0:290: [sdke] Attached SCSI disk
sd 0:0:0:298: [sdkm] Write Protect is off
sd 0:0:0:298: [sdkm] Mode Sense: 63 00 00 08
sd 0:0:0:243: [sdij] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdjy: sdjy1
sd 0:0:0:284: [sdjy] Attached SCSI disk
 sdhv: sdhv1
sd 0:0:0:229: [sdhv] Attached SCSI disk
 sdjz: sdjz1
sd 0:0:0:285: [sdjz] Attached SCSI disk
sd 0:0:0:261: [sdjb] Write Protect is off
sd 0:0:0:261: [sdjb] Mode Sense: 63 00 00 08
 sdjv: sdjv1
sd 0:0:0:281: [sdjv] Attached SCSI disk
 sdkc: sdkc1
sd 0:0:0:288: [sdkc] Attached SCSI disk
 sdjp: sdjp1
sd 0:0:0:275: [sdjp] Attached SCSI disk
 sdkd: sdkd1
 sdka: sdka1
sd 0:0:0:286: [sdka] Attached SCSI disk
sd 0:0:0:295: [sdkj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:296: [sdkk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdkg: sdkg1
sd 0:0:0:292: [sdkg] Attached SCSI disk
sd 0:0:0:298: [sdkm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdkf: sdkf1
sd 0:0:0:291: [sdkf] Attached SCSI disk
 sdkh: sdkh1
sd 0:0:0:293: [sdkh] Attached SCSI disk
 sdki: sdki1
sd 0:0:0:294: [sdki] Attached SCSI disk
sd 0:0:0:268: [sdji] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:261: [sdjb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdkn: sdkn1
sd 0:0:0:299: [sdkn] Attached SCSI disk
 sdja: sdja1
sd 0:0:0:260: [sdja] Attached SCSI disk
sd 0:0:0:240: [sdig] Attached SCSI disk
sd 0:0:0:272: [sdjm] Write Protect is off
sd 0:0:0:272: [sdjm] Mode Sense: 63 00 00 08
sd 0:0:0:272: [sdjm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdij: sdij1
sd 0:0:0:243: [sdij] Attached SCSI disk
sd 0:0:0:283: [sdjx] Write Protect is off
sd 0:0:0:283: [sdjx] Mode Sense: 63 00 00 08
sd 0:0:0:283: [sdjx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdkk: sdkk1
sd 0:0:0:296: [sdkk] Attached SCSI disk
 sdkm: sdkm1
sd 0:0:0:298: [sdkm] Attached SCSI disk
 sdji: sdji1
sd 0:0:0:268: [sdji] Attached SCSI disk
 sdjb: sdjb1
sd 0:0:0:261: [sdjb] Attached SCSI disk
 sdiz: sdiz1
sd 0:0:0:259: [sdiz] Attached SCSI disk
sd 0:0:0:297: [sdkl] Write Protect is off
sd 0:0:0:297: [sdkl] Mode Sense: 63 00 00 08
sd 0:0:0:297: [sdkl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:276: [sdjq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdjm: sdjm1
sd 0:0:0:272: [sdjm] Attached SCSI disk
 sdjx: sdjx1
sd 0:0:0:283: [sdjx] Attached SCSI disk
 sdju: sdju1
sd 0:0:0:280: [sdju] Attached SCSI disk
 sdkb: sdkb1
sd 0:0:0:289: [sdkd] Attached SCSI disk
 sdkl: sdkl1
sd 0:0:0:297: [sdkl] Attached SCSI disk
 sdjq: sdjq1
sd 0:0:0:276: [sdjq] Attached SCSI disk
 sdkj: sdkj1
sd 0:0:0:295: [sdkj] Attached SCSI disk
sd 0:0:0:287: [sdkb] Attached SCSI disk
Freeing unused kernel memory: 704k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1364k freed
Freeing unused kernel memory: 1904k freed
dracut: dracut-004-256.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
dracut: rd_NO_LVM: removing LVM activation
udev: starting version 147
udevd (132): /proc/132/oom_adj is deprecated, please use /proc/132/oom_score_adj instead.
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/vda1
dracut: /sbin/load_policy: Can't load policy: No such device
dracut: Switching root
readahead: starting
udev: starting version 147
piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:1: Attached scsi generic sg1 type 0
sd 0:0:0:2: Attached scsi generic sg2 type 0
sd 0:0:0:3: Attached scsi generic sg3 type 0
sd 0:0:0:4: Attached scsi generic sg4 type 0
sd 0:0:0:5: Attached scsi generic sg5 type 0
sd 0:0:0:6: Attached scsi generic sg6 type 0
sd 0:0:0:7: Attached scsi generic sg7 type 0
sd 0:0:0:8: Attached scsi generic sg8 type 0
sd 0:0:0:9: Attached scsi generic sg9 type 0
sd 0:0:0:10: Attached scsi generic sg10 type 0
sd 0:0:0:11: Attached scsi generic sg11 type 0
sd 0:0:0:12: Attached scsi generic sg12 type 0
sd 0:0:0:13: Attached scsi generic sg13 type 0
sd 0:0:0:14: Attached scsi generic sg14 type 0
sd 0:0:0:15: Attached scsi generic sg15 type 0
sd 0:0:0:16: Attached scsi generic sg16 type 0
sd 0:0:0:17: Attached scsi generic sg17 type 0
sd 0:0:0:18: Attached scsi generic sg18 type 0
sd 0:0:0:19: Attached scsi generic sg19 type 0
sd 0:0:0:20: Attached scsi generic sg20 type 0
sd 0:0:0:21: Attached scsi generic sg21 type 0
sd 0:0:0:22: Attached scsi generic sg22 type 0
sd 0:0:0:23: Attached scsi generic sg23 type 0
sd 0:0:0:24: Attached scsi generic sg24 type 0
sd 0:0:0:25: Attached scsi generic sg25 type 0
sd 0:0:0:26: Attached scsi generic sg26 type 0
sd 0:0:0:27: Attached scsi generic sg27 type 0
sd 0:0:0:28: Attached scsi generic sg28 type 0
sd 0:0:0:29: Attached scsi generic sg29 type 0
sd 0:0:0:30: Attached scsi generic sg30 type 0
sd 0:0:0:31: Attached scsi generic sg31 type 0
sd 0:0:0:32: Attached scsi generic sg32 type 0
sd 0:0:0:33: Attached scsi generic sg33 type 0
sd 0:0:0:34: Attached scsi generic sg34 type 0
sd 0:0:0:35: Attached scsi generic sg35 type 0
sd 0:0:0:36: Attached scsi generic sg36 type 0
sd 0:0:0:37: Attached scsi generic sg37 type 0
sd 0:0:0:38: Attached scsi generic sg38 type 0
sd 0:0:0:39: Attached scsi generic sg39 type 0
sd 0:0:0:40: Attached scsi generic sg40 type 0
sd 0:0:0:41: Attached scsi generic sg41 type 0
sd 0:0:0:42: Attached scsi generic sg42 type 0
sd 0:0:0:43: Attached scsi generic sg43 type 0
sd 0:0:0:44: Attached scsi generic sg44 type 0
sd 0:0:0:45: Attached scsi generic sg45 type 0
sd 0:0:0:46: Attached scsi generic sg46 type 0
sd 0:0:0:47: Attached scsi generic sg47 type 0
sd 0:0:0:48: Attached scsi generic sg48 type 0
sd 0:0:0:49: Attached scsi generic sg49 type 0
sd 0:0:0:50: Attached scsi generic sg50 type 0
sd 0:0:0:51: Attached scsi generic sg51 type 0
sd 0:0:0:52: Attached scsi generic sg52 type 0
sd 0:0:0:53: Attached scsi generic sg53 type 0
sd 0:0:0:54: Attached scsi generic sg54 type 0
sd 0:0:0:55: Attached scsi generic sg55 type 0
sd 0:0:0:56: Attached scsi generic sg56 type 0
sd 0:0:0:57: Attached scsi generic sg57 type 0
sd 0:0:0:58: Attached scsi generic sg58 type 0
sd 0:0:0:59: Attached scsi generic sg59 type 0
sd 0:0:0:60: Attached scsi generic sg60 type 0
sd 0:0:0:61: Attached scsi generic sg61 type 0
sd 0:0:0:62: Attached scsi generic sg62 type 0
sd 0:0:0:63: Attached scsi generic sg63 type 0
sd 0:0:0:64: Attached scsi generic sg64 type 0
sd 0:0:0:65: Attached scsi generic sg65 type 0
sd 0:0:0:66: Attached scsi generic sg66 type 0
sd 0:0:0:67: Attached scsi generic sg67 type 0
sd 0:0:0:68: Attached scsi generic sg68 type 0
sd 0:0:0:69: Attached scsi generic sg69 type 0
sd 0:0:0:70: Attached scsi generic sg70 type 0
sd 0:0:0:71: Attached scsi generic sg71 type 0
sd 0:0:0:72: Attached scsi generic sg72 type 0
sd 0:0:0:73: Attached scsi generic sg73 type 0
sd 0:0:0:74: Attached scsi generic sg74 type 0
sd 0:0:0:75: Attached scsi generic sg75 type 0
sd 0:0:0:76: Attached scsi generic sg76 type 0
sd 0:0:0:77: Attached scsi generic sg77 type 0
sd 0:0:0:78: Attached scsi generic sg78 type 0
sd 0:0:0:79: Attached scsi generic sg79 type 0
sd 0:0:0:80: Attached scsi generic sg80 type 0
sd 0:0:0:81: Attached scsi generic sg81 type 0
sd 0:0:0:82: Attached scsi generic sg82 type 0
sd 0:0:0:83: Attached scsi generic sg83 type 0
sd 0:0:0:84: Attached scsi generic sg84 type 0
sd 0:0:0:85: Attached scsi generic sg85 type 0
sd 0:0:0:86: Attached scsi generic sg86 type 0
sd 0:0:0:87: Attached scsi generic sg87 type 0
sd 0:0:0:88: Attached scsi generic sg88 type 0
sd 0:0:0:89: Attached scsi generic sg89 type 0
sd 0:0:0:90: Attached scsi generic sg90 type 0
sd 0:0:0:91: Attached scsi generic sg91 type 0
sd 0:0:0:92: Attached scsi generic sg92 type 0
sd 0:0:0:93: Attached scsi generic sg93 type 0
sd 0:0:0:94: Attached scsi generic sg94 type 0
sd 0:0:0:95: Attached scsi generic sg95 type 0
sd 0:0:0:96: Attached scsi generic sg96 type 0
sd 0:0:0:97: Attached scsi generic sg97 type 0
sd 0:0:0:98: Attached scsi generic sg98 type 0
sd 0:0:0:99: Attached scsi generic sg99 type 0
sd 0:0:0:100: Attached scsi generic sg100 type 0
sd 0:0:0:101: Attached scsi generic sg101 type 0
sd 0:0:0:102: Attached scsi generic sg102 type 0
sd 0:0:0:103: Attached scsi generic sg103 type 0
sd 0:0:0:104: Attached scsi generic sg104 type 0
sd 0:0:0:105: Attached scsi generic sg105 type 0
sd 0:0:0:106: Attached scsi generic sg106 type 0
sd 0:0:0:107: Attached scsi generic sg107 type 0
sd 0:0:0:108: Attached scsi generic sg108 type 0
sd 0:0:0:109: Attached scsi generic sg109 type 0
sd 0:0:0:110: Attached scsi generic sg110 type 0
sd 0:0:0:111: Attached scsi generic sg111 type 0
sd 0:0:0:112: Attached scsi generic sg112 type 0
sd 0:0:0:113: Attached scsi generic sg113 type 0
sd 0:0:0:114: Attached scsi generic sg114 type 0
sd 0:0:0:115: Attached scsi generic sg115 type 0
sd 0:0:0:116: Attached scsi generic sg116 type 0
sd 0:0:0:117: Attached scsi generic sg117 type 0
sd 0:0:0:118: Attached scsi generic sg118 type 0
sd 0:0:0:119: Attached scsi generic sg119 type 0
sd 0:0:0:120: Attached scsi generic sg120 type 0
sd 0:0:0:121: Attached scsi generic sg121 type 0
sd 0:0:0:122: Attached scsi generic sg122 type 0
sd 0:0:0:123: Attached scsi generic sg123 type 0
sd 0:0:0:124: Attached scsi generic sg124 type 0
sd 0:0:0:125: Attached scsi generic sg125 type 0
sd 0:0:0:126: Attached scsi generic sg126 type 0
sd 0:0:0:127: Attached scsi generic sg127 type 0
sd 0:0:0:128: Attached scsi generic sg128 type 0
sd 0:0:0:129: Attached scsi generic sg129 type 0
sd 0:0:0:130: Attached scsi generic sg130 type 0
sd 0:0:0:131: Attached scsi generic sg131 type 0
sd 0:0:0:132: Attached scsi generic sg132 type 0
sd 0:0:0:133: Attached scsi generic sg133 type 0
sd 0:0:0:134: Attached scsi generic sg134 type 0
sd 0:0:0:135: Attached scsi generic sg135 type 0
sd 0:0:0:136: Attached scsi generic sg136 type 0
sd 0:0:0:137: Attached scsi generic sg137 type 0
sd 0:0:0:138: Attached scsi generic sg138 type 0
sd 0:0:0:139: Attached scsi generic sg139 type 0
sd 0:0:0:140: Attached scsi generic sg140 type 0
sd 0:0:0:141: Attached scsi generic sg141 type 0
sd 0:0:0:142: Attached scsi generic sg142 type 0
sd 0:0:0:143: Attached scsi generic sg143 type 0
sd 0:0:0:144: Attached scsi generic sg144 type 0
sd 0:0:0:145: Attached scsi generic sg145 type 0
sd 0:0:0:146: Attached scsi generic sg146 type 0
sd 0:0:0:147: Attached scsi generic sg147 type 0
sd 0:0:0:148: Attached scsi generic sg148 type 0
sd 0:0:0:149: Attached scsi generic sg149 type 0
sd 0:0:0:150: Attached scsi generic sg150 type 0
sd 0:0:0:151: Attached scsi generic sg151 type 0
sd 0:0:0:152: Attached scsi generic sg152 type 0
sd 0:0:0:153: Attached scsi generic sg153 type 0
sd 0:0:0:154: Attached scsi generic sg154 type 0
sd 0:0:0:155: Attached scsi generic sg155 type 0
sd 0:0:0:156: Attached scsi generic sg156 type 0
sd 0:0:0:157: Attached scsi generic sg157 type 0
sd 0:0:0:158: Attached scsi generic sg158 type 0
sd 0:0:0:159: Attached scsi generic sg159 type 0
sd 0:0:0:160: Attached scsi generic sg160 type 0
sd 0:0:0:161: Attached scsi generic sg161 type 0
sd 0:0:0:162: Attached scsi generic sg162 type 0
sd 0:0:0:163: Attached scsi generic sg163 type 0
sd 0:0:0:164: Attached scsi generic sg164 type 0
sd 0:0:0:165: Attached scsi generic sg165 type 0
sd 0:0:0:166: Attached scsi generic sg166 type 0
sd 0:0:0:167: Attached scsi generic sg167 type 0
sd 0:0:0:168: Attached scsi generic sg168 type 0
sd 0:0:0:169: Attached scsi generic sg169 type 0
sd 0:0:0:170: Attached scsi generic sg170 type 0
sd 0:0:0:171: Attached scsi generic sg171 type 0
sd 0:0:0:172: Attached scsi generic sg172 type 0
sd 0:0:0:173: Attached scsi generic sg173 type 0
sd 0:0:0:174: Attached scsi generic sg174 type 0
sd 0:0:0:175: Attached scsi generic sg175 type 0
sd 0:0:0:176: Attached scsi generic sg176 type 0
sd 0:0:0:177: Attached scsi generic sg177 type 0
sd 0:0:0:178: Attached scsi generic sg178 type 0
sd 0:0:0:179: Attached scsi generic sg179 type 0
sd 0:0:0:180: Attached scsi generic sg180 type 0
sd 0:0:0:181: Attached scsi generic sg181 type 0
sd 0:0:0:182: Attached scsi generic sg182 type 0
sd 0:0:0:183: Attached scsi generic sg183 type 0
sd 0:0:0:184: Attached scsi generic sg184 type 0
sd 0:0:0:185: Attached scsi generic sg185 type 0
sd 0:0:0:186: Attached scsi generic sg186 type 0
sd 0:0:0:187: Attached scsi generic sg187 type 0
sd 0:0:0:188: Attached scsi generic sg188 type 0
sd 0:0:0:189: Attached scsi generic sg189 type 0
sd 0:0:0:190: Attached scsi generic sg190 type 0
sd 0:0:0:191: Attached scsi generic sg191 type 0
sd 0:0:0:192: Attached scsi generic sg192 type 0
sd 0:0:0:193: Attached scsi generic sg193 type 0
sd 0:0:0:194: Attached scsi generic sg194 type 0
sd 0:0:0:195: Attached scsi generic sg195 type 0
sd 0:0:0:196: Attached scsi generic sg196 type 0
sd 0:0:0:197: Attached scsi generic sg197 type 0
sd 0:0:0:198: Attached scsi generic sg198 type 0
sd 0:0:0:199: Attached scsi generic sg199 type 0
sd 0:0:0:200: Attached scsi generic sg200 type 0
sd 0:0:0:201: Attached scsi generic sg201 type 0
sd 0:0:0:202: Attached scsi generic sg202 type 0
sd 0:0:0:203: Attached scsi generic sg203 type 0
sd 0:0:0:204: Attached scsi generic sg204 type 0
sd 0:0:0:205: Attached scsi generic sg205 type 0
sd 0:0:0:206: Attached scsi generic sg206 type 0
sd 0:0:0:207: Attached scsi generic sg207 type 0
sd 0:0:0:208: Attached scsi generic sg208 type 0
sd 0:0:0:209: Attached scsi generic sg209 type 0
sd 0:0:0:210: Attached scsi generic sg210 type 0
sd 0:0:0:211: Attached scsi generic sg211 type 0
sd 0:0:0:212: Attached scsi generic sg212 type 0
sd 0:0:0:213: Attached scsi generic sg213 type 0
sd 0:0:0:214: Attached scsi generic sg214 type 0
sd 0:0:0:215: Attached scsi generic sg215 type 0
sd 0:0:0:216: Attached scsi generic sg216 type 0
sd 0:0:0:217: Attached scsi generic sg217 type 0
sd 0:0:0:218: Attached scsi generic sg218 type 0
sd 0:0:0:219: Attached scsi generic sg219 type 0
sd 0:0:0:220: Attached scsi generic sg220 type 0
sd 0:0:0:221: Attached scsi generic sg221 type 0
sd 0:0:0:222: Attached scsi generic sg222 type 0
sd 0:0:0:223: Attached scsi generic sg223 type 0
sd 0:0:0:224: Attached scsi generic sg224 type 0
sd 0:0:0:225: Attached scsi generic sg225 type 0
sd 0:0:0:226: Attached scsi generic sg226 type 0
sd 0:0:0:227: Attached scsi generic sg227 type 0
sd 0:0:0:228: Attached scsi generic sg228 type 0
sd 0:0:0:229: Attached scsi generic sg229 type 0
sd 0:0:0:230: Attached scsi generic sg230 type 0
sd 0:0:0:231: Attached scsi generic sg231 type 0
sd 0:0:0:232: Attached scsi generic sg232 type 0
sd 0:0:0:233: Attached scsi generic sg233 type 0
sd 0:0:0:234: Attached scsi generic sg234 type 0
sd 0:0:0:235: Attached scsi generic sg235 type 0
sd 0:0:0:236: Attached scsi generic sg236 type 0
sd 0:0:0:237: Attached scsi generic sg237 type 0
sd 0:0:0:238: Attached scsi generic sg238 type 0
sd 0:0:0:239: Attached scsi generic sg239 type 0
sd 0:0:0:240: Attached scsi generic sg240 type 0
sd 0:0:0:241: Attached scsi generic sg241 type 0
sd 0:0:0:242: Attached scsi generic sg242 type 0
sd 0:0:0:243: Attached scsi generic sg243 type 0
sd 0:0:0:244: Attached scsi generic sg244 type 0
sd 0:0:0:245: Attached scsi generic sg245 type 0
sd 0:0:0:246: Attached scsi generic sg246 type 0
sd 0:0:0:247: Attached scsi generic sg247 type 0
sd 0:0:0:248: Attached scsi generic sg248 type 0
sd 0:0:0:249: Attached scsi generic sg249 type 0
sd 0:0:0:250: Attached scsi generic sg250 type 0
sd 0:0:0:251: Attached scsi generic sg251 type 0
sd 0:0:0:252: Attached scsi generic sg252 type 0
sd 0:0:0:253: Attached scsi generic sg253 type 0
sd 0:0:0:254: Attached scsi generic sg254 type 0
sd 0:0:0:255: Attached scsi generic sg255 type 0
sd 0:0:0:256: Attached scsi generic sg256 type 0
sd 0:0:0:257: Attached scsi generic sg257 type 0
sd 0:0:0:258: Attached scsi generic sg258 type 0
sd 0:0:0:259: Attached scsi generic sg259 type 0
sd 0:0:0:260: Attached scsi generic sg260 type 0
sd 0:0:0:261: Attached scsi generic sg261 type 0
sd 0:0:0:262: Attached scsi generic sg262 type 0
sd 0:0:0:263: Attached scsi generic sg263 type 0
sd 0:0:0:264: Attached scsi generic sg264 type 0
sd 0:0:0:265: Attached scsi generic sg265 type 0
sd 0:0:0:266: Attached scsi generic sg266 type 0
sd 0:0:0:267: Attached scsi generic sg267 type 0
sd 0:0:0:268: Attached scsi generic sg268 type 0
sd 0:0:0:269: Attached scsi generic sg269 type 0
sd 0:0:0:270: Attached scsi generic sg270 type 0
sd 0:0:0:271: Attached scsi generic sg271 type 0
sd 0:0:0:272: Attached scsi generic sg272 type 0
sd 0:0:0:273: Attached scsi generic sg273 type 0
sd 0:0:0:274: Attached scsi generic sg274 type 0
sd 0:0:0:275: Attached scsi generic sg275 type 0
sd 0:0:0:276: Attached scsi generic sg276 type 0
sd 0:0:0:277: Attached scsi generic sg277 type 0
sd 0:0:0:278: Attached scsi generic sg278 type 0
sd 0:0:0:279: Attached scsi generic sg279 type 0
sd 0:0:0:280: Attached scsi generic sg280 type 0
sd 0:0:0:281: Attached scsi generic sg281 type 0
sd 0:0:0:282: Attached scsi generic sg282 type 0
sd 0:0:0:283: Attached scsi generic sg283 type 0
sd 0:0:0:284: Attached scsi generic sg284 type 0
sd 0:0:0:285: Attached scsi generic sg285 type 0
sd 0:0:0:286: Attached scsi generic sg286 type 0
sd 0:0:0:287: Attached scsi generic sg287 type 0
sd 0:0:0:288: Attached scsi generic sg288 type 0
sd 0:0:0:289: Attached scsi generic sg289 type 0
sd 0:0:0:290: Attached scsi generic sg290 type 0
sd 0:0:0:291: Attached scsi generic sg291 type 0
sd 0:0:0:292: Attached scsi generic sg292 type 0
sd 0:0:0:293: Attached scsi generic sg293 type 0
sd 0:0:0:294: Attached scsi generic sg294 type 0
sd 0:0:0:295: Attached scsi generic sg295 type 0
sd 0:0:0:296: Attached scsi generic sg296 type 0
sd 0:0:0:297: Attached scsi generic sg297 type 0
sd 0:0:0:298: Attached scsi generic sg298 type 0
sd 0:0:0:299: Attached scsi generic sg299 type 0
sr 2:0:0:0: Attached scsi generic sg300 type 5
input: PC Speaker as /devices/platform/pcspkr/input/input3
EXT4-fs (vda1): re-mounted. Opts: (null)
Adding 1048572k swap on /dev/vda2.  Priority:-1 extents:1 across:1048572k 
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
device virbr0-nic entered promiscuous mode
device virbr0-nic left promiscuous mode
virbr0: port 1(virbr0-nic) entering disabled state
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm@kvack.org.
INFO: task master:6528 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
master          D 0000000000000000     0  6528      1 0x00000080
 ffff880030a1d968 0000000000000086 ffff880033461600 0000000000012000
 ffff880030a1dfd8 ffff880030a1c010 0000000000012000 0000000000012000
 ffff880030a1dfd8 0000000000012000 ffff880032d4f600 ffff880033461600
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497a3a>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497b18>] out_of_line_wait_on_bit_lock+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175f66>] __lock_buffer+0x36/0x40
 [<ffffffff81233986>] do_get_write_access+0x4b6/0x510
 [<ffffffff81233b31>] jbd2_journal_get_write_access+0x31/0x50
 [<ffffffff81215d8e>] __ext4_journal_get_write_access+0x3e/0x80
 [<ffffffff811eb178>] ext4_reserve_inode_write+0x78/0xa0
 [<ffffffff811eb1fb>] ext4_mark_inode_dirty+0x5b/0x230
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811eb40d>] ext4_dirty_inode+0x3d/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115efb2>] file_update_time+0xd2/0x140
 [<ffffffff811504a7>] pipe_write+0x337/0x690
 [<ffffffff81146ae2>] do_sync_write+0xe2/0x120
 [<ffffffff81029f19>] ? kvm_clock_read+0x19/0x20
 [<ffffffff81029f29>] ? kvm_clock_get_cycles+0x9/0x10
 [<ffffffff810860dd>] ? ktime_get_ts+0xad/0xe0
 [<ffffffff81147038>] vfs_write+0xc8/0x190
 [<ffffffff81147201>] sys_write+0x51/0x90
 [<ffffffff8115a33c>] ? sys_poll+0x7c/0x110
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task pickup:11361 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pickup          D 0000000000000000     0 11361   6528 0x00000080
 ffff88000055f978 0000000000000082 ffff880035e2c140 0000000000012000
 ffff88000055ffd8 ffff88000055e010 0000000000012000 0000000000012000
 ffff88000055ffd8 0000000000012000 ffff880033461600 ffff880035e2c140
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497a3a>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497b18>] out_of_line_wait_on_bit_lock+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175f66>] __lock_buffer+0x36/0x40
 [<ffffffff81233986>] do_get_write_access+0x4b6/0x510
 [<ffffffff81233b31>] jbd2_journal_get_write_access+0x31/0x50
 [<ffffffff81215d8e>] __ext4_journal_get_write_access+0x3e/0x80
 [<ffffffff811eb178>] ext4_reserve_inode_write+0x78/0xa0
 [<ffffffff811eb1fb>] ext4_mark_inode_dirty+0x5b/0x230
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff81477324>] ? scm_destroy+0x14/0x60
 [<ffffffff811eb40d>] ext4_dirty_inode+0x3d/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115f135>] touch_atime+0x115/0x150
 [<ffffffff81150b14>] pipe_read+0x2b4/0x4c0
 [<ffffffff81060df8>] ? hrtimer_try_to_cancel+0x48/0xe0
 [<ffffffff81146c02>] do_sync_read+0xe2/0x120
 [<ffffffff81147305>] vfs_read+0xc5/0x190
 [<ffffffff811474d1>] sys_read+0x51/0x90
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task jbd2/vda1-8:2354 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/vda1-8     D 0000000000000000     0  2354      2 0x00000000
 ffff88003a1cdcb0 0000000000000046 ffff880038544ae0 0000000000012000
 ffff88003a1cdfd8 ffff88003a1cc010 0000000000012000 0000000000012000
 ffff88003a1cdfd8 0000000000012000 ffff880032d4f600 ffff880038544ae0
Call Trace:
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff81233eae>] jbd2_journal_commit_transaction+0x1ce/0x15e0
 [<ffffffff81029f19>] ? kvm_clock_read+0x19/0x20
 [<ffffffff81070c2a>] ? account_entity_dequeue+0x8a/0xb0
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff8104961c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff8104a106>] ? try_to_del_timer_sync+0x86/0xe0
 [<ffffffff81239c68>] kjournald2+0xc8/0x240
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81239ba0>] ? commit_timeout+0x10/0x10
 [<ffffffff8105ca7e>] kthread+0x9e/0xb0
 [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814a34e0>] ? gs_change+0x13/0x13
INFO: task auditd:5852 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
auditd          D 0000000000000000     0  5852      1 0x00000000
 ffff880032cf99c8 0000000000000086 ffff88003498abe0 0000000000012000
 ffff880032cf9fd8 ffff880032cf8010 0000000000012000 0000000000012000
 ffff880032cf9fd8 0000000000012000 ffff880035e762c0 ffff88003498abe0
Call Trace:
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff8123267d>] start_this_handle+0x2cd/0x4e0
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81232a9b>] jbd2__journal_start+0xbb/0x100
 [<ffffffff811eb3f7>] ? ext4_dirty_inode+0x27/0x60
 [<ffffffff81232af3>] jbd2_journal_start+0x13/0x20
 [<ffffffff81204583>] ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811eb3f7>] ext4_dirty_inode+0x27/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115efb2>] file_update_time+0xd2/0x140
 [<ffffffff810f3e68>] __generic_file_aio_write+0x208/0x460
 [<ffffffff810f4136>] generic_file_aio_write+0x76/0xf0
 [<ffffffff811e38f9>] ext4_file_write+0x69/0x280
 [<ffffffff81146ae2>] do_sync_write+0xe2/0x120
 [<ffffffff81294e58>] ? __percpu_counter_sum+0x58/0x80
 [<ffffffff81147038>] vfs_write+0xc8/0x190
 [<ffffffff81147201>] sys_write+0x51/0x90
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task rs:main Q:Reg:11824 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rs:main Q:Reg   D 0000000000000000     0 11824      1 0x00000080
 ffff88000cacb9c8 0000000000000082 ffff880038624080 0000000000012000
 ffff88000cacbfd8 ffff88000caca010 0000000000012000 0000000000012000
 ffff88000cacbfd8 0000000000012000 ffff880032d4f600 ffff880038624080
Call Trace:
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff8123267d>] start_this_handle+0x2cd/0x4e0
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81232a9b>] jbd2__journal_start+0xbb/0x100
 [<ffffffff811eb3f7>] ? ext4_dirty_inode+0x27/0x60
 [<ffffffff81232af3>] jbd2_journal_start+0x13/0x20
 [<ffffffff81204583>] ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811eb3f7>] ext4_dirty_inode+0x27/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115efb2>] file_update_time+0xd2/0x140
 [<ffffffff810f3e68>] __generic_file_aio_write+0x208/0x460
 [<ffffffff810f4136>] generic_file_aio_write+0x76/0xf0
 [<ffffffff811e38f9>] ext4_file_write+0x69/0x280
 [<ffffffff81040921>] ? sys_time+0x21/0x60
 [<ffffffff810076a9>] ? emulate_vsyscall+0x249/0x340
 [<ffffffff81146ae2>] do_sync_write+0xe2/0x120
 [<ffffffff81147038>] vfs_write+0xc8/0x190
 [<ffffffff81147201>] sys_write+0x51/0x90
 [<ffffffff8149abae>] ? do_device_not_available+0xe/0x10
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task master:6528 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
master          D 0000000000000000     0  6528      1 0x00000080
 ffff880030a1d968 0000000000000086 ffff880033461600 0000000000012000
 ffff880030a1dfd8 ffff880030a1c010 0000000000012000 0000000000012000
 ffff880030a1dfd8 0000000000012000 ffff880032d4f600 ffff880033461600
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497a3a>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497b18>] out_of_line_wait_on_bit_lock+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175f66>] __lock_buffer+0x36/0x40
 [<ffffffff81233986>] do_get_write_access+0x4b6/0x510
 [<ffffffff81233b31>] jbd2_journal_get_write_access+0x31/0x50
 [<ffffffff81215d8e>] __ext4_journal_get_write_access+0x3e/0x80
 [<ffffffff811eb178>] ext4_reserve_inode_write+0x78/0xa0
 [<ffffffff811eb1fb>] ext4_mark_inode_dirty+0x5b/0x230
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811eb40d>] ext4_dirty_inode+0x3d/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115efb2>] file_update_time+0xd2/0x140
 [<ffffffff811504a7>] pipe_write+0x337/0x690
 [<ffffffff81146ae2>] do_sync_write+0xe2/0x120
 [<ffffffff81029f19>] ? kvm_clock_read+0x19/0x20
 [<ffffffff81029f29>] ? kvm_clock_get_cycles+0x9/0x10
 [<ffffffff810860dd>] ? ktime_get_ts+0xad/0xe0
 [<ffffffff81147038>] vfs_write+0xc8/0x190
 [<ffffffff81147201>] sys_write+0x51/0x90
 [<ffffffff8115a33c>] ? sys_poll+0x7c/0x110
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task pickup:11361 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pickup          D 0000000000000000     0 11361   6528 0x00000080
 ffff88000055f978 0000000000000082 ffff880035e2c140 0000000000012000
 ffff88000055ffd8 ffff88000055e010 0000000000012000 0000000000012000
 ffff88000055ffd8 0000000000012000 ffff880033461600 ffff880035e2c140
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497a3a>] __wait_on_bit_lock+0x5a/0xc0
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497b18>] out_of_line_wait_on_bit_lock+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175f66>] __lock_buffer+0x36/0x40
 [<ffffffff81233986>] do_get_write_access+0x4b6/0x510
 [<ffffffff81233b31>] jbd2_journal_get_write_access+0x31/0x50
 [<ffffffff81215d8e>] __ext4_journal_get_write_access+0x3e/0x80
 [<ffffffff811eb178>] ext4_reserve_inode_write+0x78/0xa0
 [<ffffffff811eb1fb>] ext4_mark_inode_dirty+0x5b/0x230
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff81477324>] ? scm_destroy+0x14/0x60
 [<ffffffff811eb40d>] ext4_dirty_inode+0x3d/0x60
 [<ffffffff8116cf5f>] __mark_inode_dirty+0x3f/0x200
 [<ffffffff8115f135>] touch_atime+0x115/0x150
 [<ffffffff81150b14>] pipe_read+0x2b4/0x4c0
 [<ffffffff81060df8>] ? hrtimer_try_to_cancel+0x48/0xe0
 [<ffffffff81146c02>] do_sync_read+0xe2/0x120
 [<ffffffff81147305>] vfs_read+0xc5/0x190
 [<ffffffff811474d1>] sys_read+0x51/0x90
 [<ffffffff814a2129>] system_call_fastpath+0x16/0x1b
INFO: task flush-254:0:6200 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-254:0     D ffffffff8160ece0     0  6200      2 0x00000080
 ffff880031379430 0000000000000046 ffff88003354d380 0000000000012000
 ffff880031379fd8 ffff880031378010 0000000000012000 0000000000012000
 ffff880031379fd8 0000000000012000 ffffffff81a0d020 ffff88003354d380
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497b8f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497c38>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175dbe>] __wait_on_buffer+0x2e/0x30
 [<ffffffff8121ad5a>] ext4_mb_init_cache+0x26a/0xac0
 [<ffffffff8110e3d4>] ? __inc_zone_page_state+0x24/0x30
 [<ffffffff8121bb72>] ext4_mb_load_buddy+0x2a2/0x370
 [<ffffffff8121cd5b>] ext4_mb_find_by_goal+0x6b/0x2b0
 [<ffffffff81497bae>] ? __wait_on_bit+0x7e/0x90
 [<ffffffff8121d1ae>] ext4_mb_regular_allocator+0x5e/0x410
 [<ffffffff8121787b>] ? ext4_mb_normalize_request+0x2fb/0x520
 [<ffffffff8121f093>] ext4_mb_new_blocks+0x383/0x530
 [<ffffffff81214d44>] ext4_ext_map_blocks+0x1884/0x1c70
 [<ffffffff811e83df>] ext4_map_blocks+0xff/0x260
 [<ffffffff811ec592>] mpage_da_map_and_submit+0xc2/0x480
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811ed168>] ext4_da_writepages+0x2e8/0x620
 [<ffffffff8125b84b>] ? __blk_run_queue+0x1b/0x20
 [<ffffffff81261558>] ? blk_finish_plug+0x18/0x50
 [<ffffffff810fbd91>] do_writepages+0x21/0x40
 [<ffffffff8116de97>] writeback_single_inode+0x177/0x3b0
 [<ffffffff8116e48e>] writeback_sb_inodes+0x19e/0x250
 [<ffffffff8116e5de>] __writeback_inodes_wb+0x9e/0xd0
 [<ffffffff8116e88b>] wb_writeback+0x1eb/0x2c0
 [<ffffffff8104a106>] ? try_to_del_timer_sync+0x86/0xe0
 [<ffffffff8116eb59>] wb_do_writeback+0x1f9/0x250
 [<ffffffff8116ec5a>] bdi_writeback_thread+0xaa/0x240
 [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
 [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
 [<ffffffff8105ca7e>] kthread+0x9e/0xb0
 [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814a34e0>] ? gs_change+0x13/0x13
INFO: task jbd2/vda1-8:2354 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/vda1-8     D 0000000000000000     0  2354      2 0x00000000
 ffff88003a1cdcb0 0000000000000046 ffff880038544ae0 0000000000012000
 ffff88003a1cdfd8 ffff88003a1cc010 0000000000012000 0000000000012000
 ffff88003a1cdfd8 0000000000012000 ffff880034b50180 ffff880038544ae0
Call Trace:
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff81233eae>] jbd2_journal_commit_transaction+0x1ce/0x15e0
 [<ffffffff81072ce2>] ? update_shares+0xc2/0xf0
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff8104961c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff8104a106>] ? try_to_del_timer_sync+0x86/0xe0
 [<ffffffff81239c68>] kjournald2+0xc8/0x240
 [<ffffffff8105cfc0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81239ba0>] ? commit_timeout+0x10/0x10
 [<ffffffff8105ca7e>] kthread+0x9e/0xb0
 [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814a34e0>] ? gs_change+0x13/0x13
INFO: task flush-254:0:6200 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-254:0     D ffffffff8160ece0     0  6200      2 0x00000080
 ffff880031379430 0000000000000046 ffff88003354d380 0000000000012000
 ffff880031379fd8 ffff880031378010 0000000000012000 0000000000012000
 ffff880031379fd8 0000000000012000 ffffffff81a0d020 ffff88003354d380
Call Trace:
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff8149962f>] schedule+0x3f/0x60
 [<ffffffff814996dc>] io_schedule+0x8c/0xd0
 [<ffffffff81175dce>] sleep_on_buffer+0xe/0x20
 [<ffffffff81497b8f>] __wait_on_bit+0x5f/0x90
 [<ffffffff81175dc0>] ? __wait_on_buffer+0x30/0x30
 [<ffffffff81497c38>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff8105d010>] ? autoremove_wake_function+0x50/0x50
 [<ffffffff81175dbe>] __wait_on_buffer+0x2e/0x30
 [<ffffffff8121ad5a>] ext4_mb_init_cache+0x26a/0xac0
 [<ffffffff8110e3d4>] ? __inc_zone_page_state+0x24/0x30
 [<ffffffff8121bb72>] ext4_mb_load_buddy+0x2a2/0x370
 [<ffffffff8121cd5b>] ext4_mb_find_by_goal+0x6b/0x2b0
 [<ffffffff81497bae>] ? __wait_on_bit+0x7e/0x90
 [<ffffffff8121d1ae>] ext4_mb_regular_allocator+0x5e/0x410
 [<ffffffff8121787b>] ? ext4_mb_normalize_request+0x2fb/0x520
 [<ffffffff8121f093>] ext4_mb_new_blocks+0x383/0x530
 [<ffffffff81214d44>] ext4_ext_map_blocks+0x1884/0x1c70
 [<ffffffff811e83df>] ext4_map_blocks+0xff/0x260
 [<ffffffff811ec592>] mpage_da_map_and_submit+0xc2/0x480
 [<ffffffff81204583>] ? ext4_journal_start_sb+0x83/0x1b0
 [<ffffffff811ed168>] ext4_da_writepages+0x2e8/0x620
 [<ffffffff8125b84b>] ? __blk_run_queue+0x1b/0x20
 [<ffffffff81261558>] ? blk_finish_plug+0x18/0x50
 [<ffffffff810fbd91>] do_writepages+0x21/0x40
 [<ffffffff8116de97>] writeback_single_inode+0x177/0x3b0
 [<ffffffff8116e48e>] writeback_sb_inodes+0x19e/0x250
 [<ffffffff8116e5de>] __writeback_inodes_wb+0x9e/0xd0
 [<ffffffff8116e88b>] wb_writeback+0x1eb/0x2c0
 [<ffffffff8104a106>] ? try_to_del_timer_sync+0x86/0xe0
 [<ffffffff8116eb59>] wb_do_writeback+0x1f9/0x250
 [<ffffffff8116ec5a>] bdi_writeback_thread+0xaa/0x240
 [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
 [<ffffffff8116ebb0>] ? wb_do_writeback+0x250/0x250
 [<ffffffff8105ca7e>] kthread+0x9e/0xb0
 [<ffffffff814a34e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105c9e0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814a34e0>] ? gs_change+0x13/0x13
scsi_verify_blk_ioctl: 592 callbacks suppressed
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
scsi_verify_blk_ioctl: 272 callbacks suppressed
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
scsi_verify_blk_ioctl: 226 callbacks suppressed
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
sd 0:0:0:0: [sda] abort
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff88003ad11780
sd 0:0:0:0: [sda] abort
scsi_eh_done scmd: ffff88003ad11780 result: 0
scsi_send_eh_cmnd: scmd: ffff88003ad11780, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff88003ad11780 rtn 2002
scsi_eh_0: flush retry cmd: ffff88003ad11780
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:269: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 3
Total of 3 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff88003dfef6c0
sd 0:0:0:269: [sdjj] abort
scsi_eh_0: aborting cmd:0xffff88002dc9ecc0
sd 0:0:0:269: [sdjj] abort
scsi_eh_0: aborting cmd:0xffff8800178f4680
sd 0:0:0:269: [sdjj] abort
scsi_eh_done scmd: ffff88003dfef6c0 result: 0
scsi_send_eh_cmnd: scmd: ffff88003dfef6c0, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff88003dfef6c0 rtn 2002
scsi_eh_0: flush retry cmd: ffff88003dfef6c0
scsi_eh_0: flush retry cmd: ffff88002dc9ecc0
scsi_eh_0: flush retry cmd: ffff8800178f4680
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:136: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff8800179bbd80
sd 0:0:0:136: [sdeg] abort
scsi_eh_done scmd: ffff8800179bbd80 result: 0
scsi_send_eh_cmnd: scmd: ffff8800179bbd80, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff8800179bbd80 rtn 2002
scsi_eh_0: flush retry cmd: ffff8800179bbd80
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:283: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff88000859d0c0
sd 0:0:0:283: [sdjx] abort
scsi_eh_done scmd: ffff88000859d0c0 result: 0
scsi_send_eh_cmnd: scmd: ffff88000859d0c0, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff88000859d0c0 rtn 2002
scsi_eh_0: flush retry cmd: ffff88000859d0c0
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:153: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
Total of 2 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff8800275d49c0
sd 0:0:0:153: [sdex] abort
scsi_eh_0: aborting cmd:0xffff880020142b80
sd 0:0:0:153: [sdex] abort
scsi_eh_done scmd: ffff8800275d49c0 result: 0
scsi_send_eh_cmnd: scmd: ffff8800275d49c0, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff8800275d49c0 rtn 2002
scsi_eh_0: flush retry cmd: ffff8800275d49c0
scsi_eh_0: flush retry cmd: ffff880020142b80
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
Waking error handler thread
Error handler scsi_eh_0 waking up
sd 0:0:0:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 9
Total of 9 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xffff880037dd9b80
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff8800151107c0
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff880020142080
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff8800151105c0
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff8800151100c0
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff8800151106c0
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff88002e54c6c0
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff88003c79fa80
sd 0:0:0:31: [sdaf] abort
scsi_eh_0: aborting cmd:0xffff880037dd9880
sd 0:0:0:31: [sdaf] abort
scsi_eh_done scmd: ffff880037dd9b80 result: 0
scsi_send_eh_cmnd: scmd: ffff880037dd9b80, timeleft: 10000
scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
scsi_eh_tur: scmd ffff880037dd9b80 rtn 2002
scsi_eh_0: flush retry cmd: ffff880037dd9b80
scsi_eh_0: flush retry cmd: ffff8800151107c0
scsi_eh_0: flush retry cmd: ffff880020142080
scsi_eh_0: flush retry cmd: ffff8800151105c0
scsi_eh_0: flush retry cmd: ffff8800151100c0
scsi_eh_0: flush retry cmd: ffff8800151106c0
scsi_eh_0: flush retry cmd: ffff88002e54c6c0
scsi_eh_0: flush retry cmd: ffff88003c79fa80
scsi_eh_0: flush retry cmd: ffff880037dd9880
scsi_restart_operations: waking up host to restart
Error handler scsi_eh_0 sleeping
------------[ cut here ]------------
kernel BUG at /home/hutao/linux-2.6/block/blk-softirq.c:110!
invalid opcode: 0000 [#1] SMP 
CPU 0 
Modules linked in: tun bridge stp llc autofs4 pcspkr sg i2c_piix4 i2c_core sr_mod cdrom [last unloaded: speedstep_lib]

Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc3-ht-virtio-scsi-1+ #13 Bochs Bochs
RIP: 0010:[<ffffffff81267567>]  [<ffffffff81267567>] __blk_complete_request+0x177/0x180
RSP: 0018:ffff88003fc03bd0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880037c90d40 RCX: 0000000000000000
RDX: ffff88003acf57e0 RSI: ffff880037c90d40 RDI: ffff88003780f118
RBP: ffff88003fc03bf0 R08: 0000000000000000 R09: ffff88003fc03ed0
R10: 00000000000e147a R11: 00000000008e147a R12: ffff880013b1e8c0
R13: ffff88003780f118 R14: ffff88003ad1a6a0 R15: 0000000000000086
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f52da498000 CR3: 000000003506f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0d020)
Stack:
 ffff880037c90d40 ffff880013b1e8c0 ffffffff81349d00 ffff88003ad1a6a0
 ffff88003fc03c00 ffffffff81267595 ffff88003fc03c20 ffffffff81339c06
 ffff880037c90d40 ffff880013b1e8c0 ffff88003fc03c50 ffffffff81349e49
Call Trace:
 <IRQ> 
 [<ffffffff81349d00>] ? virtscsi_ctrl_done+0x20/0x20
 [<ffffffff81267595>] blk_complete_request+0x25/0x30
 [<ffffffff81339c06>] scsi_done+0x26/0x60
 [<ffffffff81349e49>] virtscsi_complete_cmd+0x149/0x2a0
 [<ffffffff812ed98b>] ? virtqueue_get_buf+0x6b/0x120
 [<ffffffff81349c66>] virtscsi_vq_done+0x56/0x90
 [<ffffffff81349cb5>] virtscsi_req_done+0x15/0x20
 [<ffffffff812ed8ac>] vring_interrupt+0x3c/0xb0
 [<ffffffff812ee7e3>] vp_vring_interrupt+0x63/0xa0
 [<ffffffff810b746d>] handle_irq_event_percpu+0x5d/0x210
 [<ffffffff810b7662>] handle_irq_event+0x42/0x70
 [<ffffffff810bace9>] handle_edge_irq+0x69/0x120
 [<ffffffff8100436c>] handle_irq+0x5c/0x150
 [<ffffffff81041532>] ? irq_enter+0x22/0x80
 [<ffffffff814a3cbd>] do_IRQ+0x5d/0xe0
 [<ffffffff8149a4ee>] common_interrupt+0x6e/0x6e
 [<ffffffff812ee804>] ? vp_vring_interrupt+0x84/0xa0
 [<ffffffff810415f0>] ? __do_softirq+0x60/0x200
 [<ffffffff810b766d>] ? handle_irq_event+0x4d/0x70
 [<ffffffff814a35dc>] call_softirq+0x1c/0x30
 [<ffffffff810042d5>] do_softirq+0x65/0xa0
 [<ffffffff8104144d>] irq_exit+0xbd/0xe0
 [<ffffffff814a3cc6>] do_IRQ+0x66/0xe0
 [<ffffffff8149a4ee>] common_interrupt+0x6e/0x6e
 <EOI> 
 [<ffffffff81029f76>] ? native_safe_halt+0x6/0x10
 [<ffffffff8100b37d>] default_idle+0x5d/0x190
 [<ffffffff81002099>] cpu_idle+0xd9/0x120
 [<ffffffff8148113d>] rest_init+0x6d/0x80
 [<ffffffff81ad3cc7>] start_kernel+0x3d6/0x3e1
 [<ffffffff81ad332a>] x86_64_start_reservations+0x131/0x136
 [<ffffffff81ad3432>] x86_64_start_kernel+0x103/0x112
Code: 4d 89 6d 28 66 41 c7 45 30 00 00 31 d2 89 df e8 60 b7 e2 ff e9 5b ff ff ff 0f 1f 00 bf 04 00 00 00 e8 9e a3 dd ff e9 49 ff ff ff <0f> 0b eb fe 0f 1f 44 00 00 55 48 89 e5 66 66 66 66 90 3e 0f ba 
RIP  [<ffffffff81267567>] __blk_complete_request+0x177/0x180
 RSP <ffff88003fc03bd0>

--45Z9DzgjV8m4Oswq--
