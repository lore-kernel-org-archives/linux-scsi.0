From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Oops in kmem_cache_free() via bioset_exit() (was Re: [next-20180601][nvme][ppc] Kernel Oops is triggered when creating lvm snapshots on nvme disks)
Date: Fri, 29 Jun 2018 00:42:57 +1000
Message-ID: <87a7rf55vy.fsf@concordia.ellerman.id.au>
References: <1530003645.24245.7.camel@abdul.in.ibm.com> <87d0wd7jph.fsf@concordia.ellerman.id.au> <1530176707.24245.12.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530176707.24245.12.camel@abdul.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, sachinp <sachinp@linux.vnet.ibm.com>, sim <sim@linux.vnet.ibm.com>, manvanth <manvanth@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Kent, Jens,

This looks like it might be related to the recent bioset changes?

cheers

Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
> On Tue, 2018-06-26 at 23:36 +1000, Michael Ellerman wrote:
>> Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:
...
> I was able to reproduce again with slub_debug=FZP and DEBUG_INFO enabled
> on 4.17.0-rc7-next-20180601, but not much traces other than the Oops stack trace

Are you still testing on that revision? It's nearly a month old.

Please try to reproduce on mainline or today's linux-next.


> the faulty instruction points to below code path :
>
> gdb -batch vmlinux -ex 'list *(0xc000000000304fe0)'
> 0xc000000000304fe0 is in kmem_cache_free (mm/slab.h:231).
> 226	}
> 227	
> 228	static inline bool slab_equal_or_root(struct kmem_cache *s,
> 229					      struct kmem_cache *p)
> 230	{
> 231		return p == s || p == s->memcg_params.root_cache;
> 232	}

And s is NULL.

Called via:
  kmem_cache_free+0x210/0x2a0
  mempool_free_slab+0x24/0x40
  mempool_exit+0x50/0x90
  bioset_exit+0x40/0x1d0
  dm_io_client_destroy+0x2c/0x50
  dm_bufio_client_destroy+0x1fc/0x2d0 [dm_bufio]
  persistent_read_metadata+0x430/0x660 [dm_snapshot]
  snapshot_ctr+0x5c8/0x7a0 [dm_snapshot]
  dm_table_add_target+0x19c/0x3c0
  table_load+0x104/0x450
  ctl_ioctl+0x1f8/0x570
  dm_ctl_ioctl+0x18/0x30
  do_vfs_ioctl+0xcc/0x9e0
  ksys_ioctl+0x5c/0xe0
  sys_ioctl+0x20/0x80
  system_call+0x58/0x6c

So looks like we did:

  kmem_cache_free(NULL, x)


Probably a bad error path that frees before the cache has been allocated.

mempool_init_node() calls mempool_exit() on a partially initialised
mempool, which looks fishy, though you're not hitting that patch AFAICS.


This patch should hopefully catch it earlier:

diff --git a/mm/mempool.c b/mm/mempool.c
index b54f2c20e5e0..6e23d7a119d4 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -508,6 +508,10 @@ EXPORT_SYMBOL(mempool_alloc_slab);
 void mempool_free_slab(void *element, void *pool_data)
 {
 	struct kmem_cache *mem = pool_data;
+
+	if (WARN_ON_ONCE(!mem))
+		return;
+
 	kmem_cache_free(mem, element);
 }
 EXPORT_SYMBOL(mempool_free_slab);


cheers



> [    0.000000] dt-cpu-ftrs: setup for ISA 3000
> [    0.000000] dt-cpu-ftrs: not enabling: system-call-vectored (disabled or unsupported by kernel)
> [    0.000000] dt-cpu-ftrs: final cpu/mmu features = 0x0000786f8f5fb1a7 0x3c006041
> [    0.000000] radix-mmu: Page sizes from device-tree:
> [    0.000000] radix-mmu: Page size shift = 12 AP=0x0
> [    0.000000] radix-mmu: Page size shift = 16 AP=0x5
> [    0.000000] radix-mmu: Page size shift = 21 AP=0x1
> [    0.000000] radix-mmu: Page size shift = 30 AP=0x2
> [    0.000000] radix-mmu: Initializing Radix MMU
> [    0.000000] radix-mmu: Partition table (____ptrval____)
> [    0.000000] radix-mmu: Mapped 0x0000000000000000-0x0000001000000000 with 1.00 GiB pages
> [    0.000000] radix-mmu: Mapped 0x0000200000000000-0x0000201000000000 with 1.00 GiB pages
> [    0.000000] radix-mmu: Process table (____ptrval____) and radix root for kernel: (____ptrval____)
> [    0.000000] Linux version 4.17.0-rc7-next-20180601-autotest (root@ltc-boston21) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #3 SMP Thu Jun 28 03:01:06 CDT 2018
> [    0.000000] Found initrd at 0xc000000002d50000:0xc000000009265921
> [    0.000000] OPAL: Found memory mapped LPC bus on chip 0
> [    0.000000] ISA: Non-PCI bridge is /lpcm-opb@6030000000000/lpc@0
> [    0.000000] Using PowerNV machine description
> [    0.000000] bootconsole [udbg0] enabled
> [    0.000000] CPU maps initialized for 4 threads per core
> [    0.000000]  (thread shift is 2)
> [    0.000000] Allocated 4352 bytes for 128 pacas
> [    0.000000] -----------------------------------------------------
> [    0.000000] ppc64_pft_size    = 0x0
> [    0.000000] phys_mem_size     = 0x2000000000
> [    0.000000] dcache_bsize      = 0x80
> [    0.000000] icache_bsize      = 0x80
> [    0.000000] cpu_features      = 0x0000786f8f5fb1a7
> [    0.000000]   possible        = 0x00007fffcf5fb1a7
> [    0.000000]   always          = 0x00000003800081a1
> [    0.000000] cpu_user_features = 0xdc0065c2 0xaee00000
> [    0.000000] mmu_features      = 0x3c006041
> [    0.000000] firmware_features = 0x0000000110000000
> [    0.000000] -----------------------------------------------------
> [    0.000000] cma: Reserved 6560 MiB at 0x0000200e62000000
> [    0.000000] numa:   NODE_DATA [mem 0xfffabe300-0xfffac7fff]
> [    0.000000] numa:   NODE_DATA [mem 0x200fff1a0300-0x200fff1a9fff]
> [    0.000000] rfi-flush: mttrig type flush available
> [    0.000000] rfi-flush: patched 9 locations (mttrig type flush)
> [    0.000000] stf-barrier: eieio barrier available
> [    0.000000] stf-barrier: patched 61 entry locations (eieio barrier)
> [    0.000000] stf-barrier: patched 9 exit locations (eieio barrier)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0000000)
> [    0.000000] PCI host bridge /pciex@600c3c0000000 (primary) ranges:
> [    0.000000]  MEM 0x000600c000000000..0x000600c07ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006000000000000..0x0006003fffffffff -> 0x0006000000000000 (M64 #1..31)
> [    0.000000]  Using M64 #31 as default window
> [    0.000000]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x20000000]
> [    0.000000]   Allocated bitmap for 4088 MSIs (base IRQ 0xfe000)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0100000)
> [    0.000000] PCI host bridge /pciex@600c3c0100000  ranges:
> [    0.000000]  MEM 0x000600c080000000..0x000600c0fffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006004000000000..0x0006007fffffffff -> 0x0006004000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0xfd800)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0200000)
> [    0.000000] PCI host bridge /pciex@600c3c0200000  ranges:
> [    0.000000]  MEM 0x000600c100000000..0x000600c17ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006008000000000..0x000600bfffffffff -> 0x0006008000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0xfd000)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0300000)
> [    0.000000] PCI host bridge /pciex@600c3c0300000  ranges:
> [    0.000000]  MEM 0x000600c180000000..0x000600c1fffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006020000000000..0x0006023fffffffff -> 0x0006020000000000 (M64 #1..31)
> [    0.000000]  Using M64 #31 as default window
> [    0.000000]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x20000000]
> [    0.000000]   Allocated bitmap for 4088 MSIs (base IRQ 0xfc000)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0400000)
> [    0.000000] PCI host bridge /pciex@600c3c0400000  ranges:
> [    0.000000]  MEM 0x000600c200000000..0x000600c27ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006024000000000..0x0006027fffffffff -> 0x0006024000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0xfb800)
> [    0.000000] Initializing IODA2 PHB (/pciex@600c3c0500000)
> [    0.000000] PCI host bridge /pciex@600c3c0500000  ranges:
> [    0.000000]  MEM 0x000600c280000000..0x000600c2fffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006028000000000..0x000602bfffffffff -> 0x0006028000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0xfb000)
> [    0.000000] Initializing IODA2 PHB (/pciex@620c3c0000000)
> [    0.000000] PCI host bridge /pciex@620c3c0000000  ranges:
> [    0.000000]  MEM 0x000620c000000000..0x000620c07ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006200000000000..0x0006203fffffffff -> 0x0006200000000000 (M64 #1..31)
> [    0.000000]  Using M64 #31 as default window
> [    0.000000]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x20000000]
> [    0.000000]   Allocated bitmap for 4088 MSIs (base IRQ 0x1fe000)
> [    0.000000] Initializing IODA2 PHB (/pciex@620c3c0100000)
> [    0.000000] PCI host bridge /pciex@620c3c0100000  ranges:
> [    0.000000]  MEM 0x000620c080000000..0x000620c0fffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006204000000000..0x0006207fffffffff -> 0x0006204000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x1fd800)
> [    0.000000] Initializing IODA2 PHB (/pciex@620c3c0200000)
> [    0.000000] PCI host bridge /pciex@620c3c0200000  ranges:
> [    0.000000]  MEM 0x000620c100000000..0x000620c17ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006208000000000..0x000620bfffffffff -> 0x0006208000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x1fd000)
> [    0.000000] Initializing IODA2 PHB (/pciex@620c3c0300000)
> [    0.000000] PCI host bridge /pciex@620c3c0300000  ranges:
> [    0.000000]  MEM 0x000620c180000000..0x000620c1fffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006220000000000..0x0006223fffffffff -> 0x0006220000000000 (M64 #1..31)
> [    0.000000]  Using M64 #31 as default window
> [    0.000000]   512 (511) PE's M32: 0x80000000 [segment=0x400000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x20000000]
> [    0.000000]   Allocated bitmap for 4088 MSIs (base IRQ 0x1fc000)
> [    0.000000] Initializing IODA2 PHB (/pciex@620c3c0400000)
> [    0.000000] PCI host bridge /pciex@620c3c0400000  ranges:
> [    0.000000]  MEM 0x000620c200000000..0x000620c27ffeffff -> 0x0000000080000000 
> [    0.000000]  MEM 0x0006224000000000..0x0006227fffffffff -> 0x0006224000000000 (M64 #1..15)
> [    0.000000]  Using M64 #15 as default window
> [    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
> [    0.000000]                  M64: 0x4000000000 [segment=0x40000000]
> [    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x1fb800)
> [    0.000000] OPAL nvram setup, 589824 bytes
> [    0.000000] Top of RAM: 0x201000000000, Total RAM: 0x2000000000
> [    0.000000] Memory hole size: 33488896MB
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000000000-0x0000200fffffffff]
> [    0.000000]   DMA32    empty
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000000000-0x0000000fffffffff]
> [    0.000000]   node   8: [mem 0x0000200000000000-0x0000200fffffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000fffffffff]
> [    0.000000] On node 0 totalpages: 1048576
> [    0.000000]   DMA zone: 1024 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 1048576 pages, LIFO batch:1
> [    0.000000] Initmem setup node 8 [mem 0x0000200000000000-0x0000200fffffffff]
> [    0.000000] On node 8 totalpages: 1048576
> [    0.000000]   DMA zone: 1024 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 1048576 pages, LIFO batch:1
> [    0.000000] percpu: Embedded 4 pages/cpu @(____ptrval____) s166808 r0 d95336 u262144
> [    0.000000] pcpu-alloc: s166808 r0 d95336 u262144 alloc=4*65536
> [    0.000000] pcpu-alloc: [0] 000 [0] 001 [0] 002 [0] 003 
> [    0.000000] pcpu-alloc: [0] 004 [0] 005 [0] 006 [0] 007 
> [    0.000000] pcpu-alloc: [0] 008 [0] 009 [0] 010 [0] 011 
> [    0.000000] pcpu-alloc: [0] 012 [0] 013 [0] 014 [0] 015 
> [    0.000000] pcpu-alloc: [0] 016 [0] 017 [0] 018 [0] 019 
> [    0.000000] pcpu-alloc: [0] 020 [0] 021 [0] 022 [0] 023 
> [    0.000000] pcpu-alloc: [0] 024 [0] 025 [0] 026 [0] 027 
> [    0.000000] pcpu-alloc: [0] 028 [0] 029 [0] 030 [0] 031 
> [    0.000000] pcpu-alloc: [0] 032 [0] 033 [0] 034 [0] 035 
> [    0.000000] pcpu-alloc: [0] 036 [0] 037 [0] 038 [0] 039 
> [    0.000000] pcpu-alloc: [0] 040 [0] 041 [0] 042 [0] 043 
> [    0.000000] pcpu-alloc: [0] 044 [0] 045 [0] 046 [0] 047 
> [    0.000000] pcpu-alloc: [0] 048 [0] 049 [0] 050 [0] 051 
> [    0.000000] pcpu-alloc: [0] 052 [0] 053 [0] 054 [0] 055 
> [    0.000000] pcpu-alloc: [0] 056 [0] 057 [0] 058 [0] 059 
> [    0.000000] pcpu-alloc: [0] 060 [0] 061 [0] 062 [0] 063 
> [    0.000000] pcpu-alloc: [1] 064 [1] 065 [1] 066 [1] 067 
> [    0.000000] pcpu-alloc: [1] 068 [1] 069 [1] 070 [1] 071 
> [    0.000000] pcpu-alloc: [1] 072 [1] 073 [1] 074 [1] 075 
> [    0.000000] pcpu-alloc: [1] 076 [1] 077 [1] 078 [1] 079 
> [    0.000000] pcpu-alloc: [1] 080 [1] 081 [1] 082 [1] 083 
> [    0.000000] pcpu-alloc: [1] 084 [1] 085 [1] 086 [1] 087 
> [    0.000000] pcpu-alloc: [1] 088 [1] 089 [1] 090 [1] 091 
> [    0.000000] pcpu-alloc: [1] 092 [1] 093 [1] 094 [1] 095 
> [    0.000000] pcpu-alloc: [1] 096 [1] 097 [1] 098 [1] 099 
> [    0.000000] pcpu-alloc: [1] 100 [1] 101 [1] 102 [1] 103 
> [    0.000000] pcpu-alloc: [1] 104 [1] 105 [1] 106 [1] 107 
> [    0.000000] pcpu-alloc: [1] 108 [1] 109 [1] 110 [1] 111 
> [    0.000000] pcpu-alloc: [1] 112 [1] 113 [1] 114 [1] 115 
> [    0.000000] pcpu-alloc: [1] 116 [1] 117 [1] 118 [1] 119 
> [    0.000000] pcpu-alloc: [1] 120 [1] 121 [1] 122 [1] 123 
> [    0.000000] pcpu-alloc: [1] 124 [1] 125 [1] 126 [1] 127 
> [    0.000000] Built 2 zonelists, mobility grouping on.  Total pages: 2095104
> [    0.000000] Policy zone: DMA
> [    0.000000] Kernel command line: rw,slub_debug=FZP root=UUID=e62c58bb-2824-4075-a31d-455f1bb62504 
> [    0.000000] log_buf_len individual max cpu contribution: 8192 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 1040384 bytes
> [    0.000000] log_buf_len min size: 262144 bytes
> [    0.000000] log_buf_len: 2097152 bytes
> [    0.000000] early log buf free: 249640(95%)
> [    0.000000] Memory: 126937280K/134217728K available (10624K kernel code, 1600K rwdata, 2816K rodata, 2752K init, 1391K bss, 563008K reserved, 6717440K cma-reserved)
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=128, Nodes=9
> [    0.000000] rcu: Hierarchical RCU implementation.
> [    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=128.
> [    0.000000] 	Tasks RCU enabled.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=128
> [    0.000000] NR_IRQS: 512, nr_irqs: 512, preallocated irqs: 16
> [    0.000000] xive: Interrupt handling initialized with native backend
> [    0.000000] xive: Using priority 7 for all interrupts
> [    0.000000] xive: Using 64kB queues
> [    0.000000] time_init: decrementer frequency = 512.000000 MHz
> [    0.000000] time_init: processor frequency   = 2250.000000 MHz
> [    0.000003] time_init: 56 bit decrementer (max: 7fffffffffffff)
> [    0.004131] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
> [    0.015127] clocksource: timebase mult[1f40000] shift[24] registered
> [    0.020765] clockevent: decrementer mult[83126e98] shift[32] cpu[0]
> [    0.020996] Console: colour dummy device 80x25
> [    0.026183] console [hvc0] enabled
> [    0.031888] bootconsole [udbg0] disabled
> [    0.040355] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
> [    0.051161] pid_max: default: 131072 minimum: 1024
> [    0.064324] Dentry cache hash table entries: 8388608 (order: 10, 67108864 bytes)
> [    0.072553] Inode-cache hash table entries: 4194304 (order: 9, 33554432 bytes)
> [    0.078288] Mount-cache hash table entries: 131072 (order: 4, 1048576 bytes)
> [    0.085039] Mountpoint-cache hash table entries: 131072 (order: 4, 1048576 bytes)
> [    0.094088] EEH: PowerNV platform initialized
> [    0.098132] POWER9 performance monitor hardware support registered
> [    0.103745] rcu: Hierarchical SRCU implementation.
> [    0.109204] smp: Bringing up secondary CPUs ...
> [    0.497962] smp: Brought up 2 nodes, 128 CPUs
> [    0.500638] numa: Node 0 CPUs: 0-63
> [    0.503403] numa: Node 8 CPUs: 64-127
> [    0.507553] Using shared cache scheduler topology
> [    0.527795] devtmpfs: initialized
> [    0.579056] random: get_random_u32 called from bucket_table_alloc+0xa4/0x220 with crng_init=0
> [    0.586622] kworker/u257:0 (654) used greatest stack depth: 12432 bytes left
> [    0.586944] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
> [    0.602577] futex hash table entries: 32768 (order: 6, 4194304 bytes)
> [    0.614833] NET: Registered protocol family 16
> [    0.617639] EEH: No capable adapters found
> [    0.621858] audit: initializing netlink subsys (disabled)
> [    0.627301] audit: type=2000 audit(1530175670.570:1): state=initialized audit_enabled=0 res=1
> [    0.627458] kworker/u257:0 (663) used greatest stack depth: 12384 bytes left
> [    0.642475] cpuidle: using governor menu
> [    0.646772] pstore: Registered nvram as persistent store backend
> [    0.696312] PCI: Probing PCI hardware
> [    0.696410] PCI host bridge to bus 0000:00
> [    0.696454] pci_bus 0000:00: root bus resource [mem 0x600c000000000-0x600c07ffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.696564] pci_bus 0000:00: root bus resource [mem 0x6000000000000-0x6003fbfffffff 64bit pref]
> [    0.696648] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.696700] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.696738] pci 0000:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.696940] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.702791] pci 0000:01:00.0: [10b5:9733] type 01 class 0x060400
> [    0.702863] pci 0000:01:00.0: reg 0x10: [mem 0x600c001800000-0x600c00183ffff]
> [    0.703113] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    0.708739] pci 0000:00:00.0: PCI bridge to [bus 01-13]
> [    0.708797] pci 0000:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.709172] pci 0000:02:01.0: [10b5:9733] type 01 class 0x060400
> [    0.709479] pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
> [    0.710138] pci 0000:02:04.0: [10b5:9733] type 01 class 0x060400
> [    0.710447] pci 0000:02:04.0: PME# supported from D0 D3hot D3cold
> [    0.710762] pci 0000:02:05.0: [10b5:9733] type 01 class 0x060400
> [    0.711071] pci 0000:02:05.0: PME# supported from D0 D3hot D3cold
> [    0.711386] pci 0000:02:06.0: [10b5:9733] type 01 class 0x060400
> [    0.711697] pci 0000:02:06.0: PME# supported from D0 D3hot D3cold
> [    0.712025] pci 0000:02:07.0: [10b5:9733] type 01 class 0x060400
> [    0.712338] pci 0000:02:07.0: PME# supported from D0 D3hot D3cold
> [    0.716738] pci 0000:01:00.0: PCI bridge to [bus 02-13]
> [    0.722562] pci 0000:02:01.0: PCI bridge to [bus 03-07]
> [    0.728220] pci 0000:02:04.0: PCI bridge to [bus 08-0c]
> [    0.733861] pci 0000:02:05.0: PCI bridge to [bus 0d-11]
> [    0.734078] pci 0000:12:00.0: [144d:a804] type 00 class 0x010802
> [    0.734152] pci 0000:12:00.0: reg 0x10: [mem 0x600c000820000-0x600c000823fff 64bit]
> [    0.734242] pci 0000:12:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
> [    0.734273] pci 0000:12:00.0: BAR0 [mem size 0x00004000 64bit]: requesting alignment to 0x10000
> [    0.740076] pci 0000:02:06.0: PCI bridge to [bus 12]
> [    0.740299] pci 0000:13:00.0: [144d:a804] type 00 class 0x010802
> [    0.740374] pci 0000:13:00.0: reg 0x10: [mem 0x600c000c20000-0x600c000c23fff 64bit]
> [    0.740464] pci 0000:13:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
> [    0.740493] pci 0000:13:00.0: BAR0 [mem size 0x00004000 64bit]: requesting alignment to 0x10000
> [    0.746296] pci 0000:02:07.0: PCI bridge to [bus 13]
> [    0.746463] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 13
> [    0.746525] PCI host bridge to bus 0001:00
> [    0.746567] pci_bus 0001:00: root bus resource [mem 0x600c080000000-0x600c0fffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.753399] pci_bus 0001:00: root bus resource [mem 0x6004000000000-0x6007f7fffffff 64bit pref]
> [    0.761727] pci_bus 0001:00: root bus resource [bus 00-ff]
> [    0.767269] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.767299] pci 0001:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.767481] pci 0001:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.778662] pci 0001:00:00.0: PCI bridge to [bus 01-ff]
> [    0.778720] pci 0001:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.778752] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.778806] PCI host bridge to bus 0002:00
> [    0.778848] pci_bus 0002:00: root bus resource [mem 0x600c100000000-0x600c17ffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.788071] pci_bus 0002:00: root bus resource [mem 0x6008000000000-0x600bf7fffffff 64bit pref]
> [    0.796394] pci_bus 0002:00: root bus resource [bus 00-ff]
> [    0.801936] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.801966] pci 0002:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.802157] pci 0002:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.807857] pci 0002:01:00.0: [8086:1589] type 00 class 0x020000
> [    0.807935] pci 0002:01:00.0: reg 0x10: [mem 0x6008008000000-0x60080087fffff 64bit pref]
> [    0.807985] pci 0002:01:00.0: reg 0x1c: [mem 0x600800a000000-0x600800a007fff 64bit pref]
> [    0.808023] pci 0002:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    0.808055] pci 0002:01:00.0: BAR3 [mem size 0x00008000 64bit pref]: requesting alignment to 0x10000
> [    0.810427] pci 0002:01:00.0: PME# supported from D0 D3hot
> [    0.810582] pci 0002:01:00.1: [8086:1589] type 00 class 0x020000
> [    0.810658] pci 0002:01:00.1: reg 0x10: [mem 0x6008008800000-0x6008008ffffff 64bit pref]
> [    0.810708] pci 0002:01:00.1: reg 0x1c: [mem 0x600800a010000-0x600800a017fff 64bit pref]
> [    0.810746] pci 0002:01:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    0.810779] pci 0002:01:00.1: BAR3 [mem size 0x00008000 64bit pref]: requesting alignment to 0x10000
> [    0.820113] pci 0002:01:00.1: PME# supported from D0 D3hot
> [    0.820254] pci 0002:01:00.2: [8086:1589] type 00 class 0x020000
> [    0.820330] pci 0002:01:00.2: reg 0x10: [mem 0x6008009000000-0x60080097fffff 64bit pref]
> [    0.820380] pci 0002:01:00.2: reg 0x1c: [mem 0x600800a020000-0x600800a027fff 64bit pref]
> [    0.820420] pci 0002:01:00.2: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    0.820452] pci 0002:01:00.2: BAR3 [mem size 0x00008000 64bit pref]: requesting alignment to 0x10000
> [    0.829818] pci 0002:01:00.2: PME# supported from D0 D3hot
> [    0.829967] pci 0002:01:00.3: [8086:1589] type 00 class 0x020000
> [    0.830044] pci 0002:01:00.3: reg 0x10: [mem 0x6008009800000-0x6008009ffffff 64bit pref]
> [    0.830095] pci 0002:01:00.3: reg 0x1c: [mem 0x600800a030000-0x600800a037fff 64bit pref]
> [    0.830135] pci 0002:01:00.3: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    0.830168] pci 0002:01:00.3: BAR3 [mem size 0x00008000 64bit pref]: requesting alignment to 0x10000
> [    0.838152] pci 0002:01:00.3: PME# supported from D0 D3hot
> [    0.843758] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    0.843815] pci 0002:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.843903] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to 01
> [    0.843960] PCI host bridge to bus 0003:00
> [    0.847698] pci_bus 0003:00: root bus resource [mem 0x600c180000000-0x600c1fffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.858793] pci_bus 0003:00: root bus resource [mem 0x6020000000000-0x6023fbfffffff 64bit pref]
> [    0.867110] pci_bus 0003:00: root bus resource [bus 00-ff]
> [    0.872660] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.872689] pci 0003:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.872880] pci 0003:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.878583] pci 0003:01:00.0: [9005:028d] type 00 class 0x010700
> [    0.878645] pci 0003:01:00.0: reg 0x10: [mem 0x600c180000000-0x600c1800fffff 64bit]
> [    0.878676] pci 0003:01:00.0: reg 0x18: [mem 0x600c180180000-0x600c1801803ff 64bit]
> [    0.878696] pci 0003:01:00.0: reg 0x20: [io  0x0000-0x00ff]
> [    0.878733] pci 0003:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    0.878764] pci 0003:01:00.0: BAR2 [mem size 0x00000400 64bit]: requesting alignment to 0x10000
> [    0.881098] pci 0003:01:00.0: PME# supported from D0 D1 D3hot
> [    0.886729] pci 0003:00:00.0: PCI bridge to [bus 01]
> [    0.886787] pci 0003:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.886855] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to 01
> [    0.886908] PCI host bridge to bus 0004:00
> [    0.889311] pci_bus 0004:00: root bus resource [mem 0x600c200000000-0x600c27ffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.900398] pci_bus 0004:00: root bus resource [mem 0x6024000000000-0x6027f7fffffff 64bit pref]
> [    0.910089] pci_bus 0004:00: root bus resource [bus 00-ff]
> [    0.915642] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.915672] pci 0004:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.915865] pci 0004:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.921568] pci 0004:01:00.0: [1a03:1150] type 01 class 0x060400
> [    0.921830] pci 0004:01:00.0: supports D1 D2
> [    0.921834] pci 0004:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.927451] pci 0004:00:00.0: PCI bridge to [bus 01-02]
> [    0.927509] pci 0004:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.927649] pci_bus 0004:02: extended config space not accessible
> [    0.927776] pci 0004:02:00.0: [1a03:2000] type 00 class 0x030000
> [    0.927817] pci 0004:02:00.0: reg 0x10: [mem 0x600c200000000-0x600c200ffffff]
> [    0.927839] pci 0004:02:00.0: reg 0x14: [mem 0x600c201000000-0x600c20101ffff]
> [    0.927861] pci 0004:02:00.0: reg 0x18: [io  0x0000-0x007f]
> [    0.928030] pci 0004:02:00.0: supports D1 D2
> [    0.928033] pci 0004:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.933609] pci 0004:01:00.0: PCI bridge to [bus 02]
> [    0.933744] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to 02
> [    0.933799] PCI host bridge to bus 0005:00
> [    0.935061] pci_bus 0005:00: root bus resource [mem 0x600c280000000-0x600c2fffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.946162] pci_bus 0005:00: root bus resource [mem 0x6028000000000-0x602bf7fffffff 64bit pref]
> [    0.954481] pci_bus 0005:00: root bus resource [bus 00-ff]
> [    0.960027] pci_bus 0005:00: busn_res: [bus 00-ff] end is updated to ff
> [    0.960056] pci 0005:00:00.0: [1014:04c1] type 01 class 0x060400
> [    0.960248] pci 0005:00:00.0: PME# supported from D0 D3hot D3cold
> [    0.965956] pci 0005:01:00.0: [104c:8241] type 00 class 0x0c0330
> [    0.966021] pci 0005:01:00.0: reg 0x10: [mem 0x600c280000000-0x600c28000ffff 64bit]
> [    0.966052] pci 0005:01:00.0: reg 0x18: [mem 0x600c280010000-0x600c280011fff 64bit]
> [    0.966135] pci 0005:01:00.0: BAR2 [mem size 0x00002000 64bit]: requesting alignment to 0x10000
> [    0.969850] pci 0005:01:00.0: supports D1 D2
> [    0.969853] pci 0005:01:00.0: PME# supported from D0 D1 D2 D3hot
> [    0.975472] pci 0005:00:00.0: PCI bridge to [bus 01]
> [    0.975530] pci 0005:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    0.975598] pci_bus 0005:00: busn_res: [bus 00-ff] end is updated to 01
> [    0.975652] PCI host bridge to bus 0030:00
> [    0.978049] pci_bus 0030:00: root bus resource [mem 0x620c000000000-0x620c07ffeffff] (bus address [0x80000000-0xfffeffff])
> [    0.989146] pci_bus 0030:00: root bus resource [mem 0x6200000000000-0x6203fbfffffff 64bit pref]
> [    0.997464] pci_bus 0030:00: root bus resource [bus 00-ff]
> [    1.003014] pci_bus 0030:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.003048] pci 0030:00:00.0: [1014:04c1] type 01 class 0x060400
> [    1.003280] pci 0030:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.007158] random: fast init done
> [    1.008995] pci 0030:01:00.0: [1000:0097] type 00 class 0x010700
> [    1.009065] pci 0030:01:00.0: reg 0x10: [io  0x0000-0x00ff]
> [    1.009101] pci 0030:01:00.0: reg 0x14: [mem 0x620c000140000-0x620c00014ffff 64bit]
> [    1.009137] pci 0030:01:00.0: reg 0x1c: [mem 0x620c000100000-0x620c00013ffff 64bit]
> [    1.009181] pci 0030:01:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
> [    1.009203] pci 0030:01:00.0: enabling Extended Tags
> [    1.011548] pci 0030:01:00.0: supports D1 D2
> [    1.017179] pci 0030:00:00.0: PCI bridge to [bus 01]
> [    1.017237] pci 0030:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    1.017310] pci_bus 0030:00: busn_res: [bus 00-ff] end is updated to 01
> [    1.017365] PCI host bridge to bus 0031:00
> [    1.021030] pci_bus 0031:00: root bus resource [mem 0x620c080000000-0x620c0fffeffff] (bus address [0x80000000-0xfffeffff])
> [    1.032133] pci_bus 0031:00: root bus resource [mem 0x6204000000000-0x6207f7fffffff 64bit pref]
> [    1.040454] pci_bus 0031:00: root bus resource [bus 00-ff]
> [    1.045996] pci_bus 0031:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.046030] pci 0031:00:00.0: [1014:04c1] type 01 class 0x060400
> [    1.046263] pci 0031:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.051986] pci 0031:01:00.0: [14e4:16a1] type 00 class 0x020000
> [    1.052085] pci 0031:01:00.0: reg 0x10: [mem 0x620400c000000-0x620400c7fffff 64bit pref]
> [    1.052123] pci 0031:01:00.0: reg 0x18: [mem 0x620400c800000-0x620400cffffff 64bit pref]
> [    1.052161] pci 0031:01:00.0: reg 0x20: [mem 0x6204010000000-0x620401000ffff 64bit pref]
> [    1.052186] pci 0031:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.052436] pci 0031:01:00.0: PME# supported from D0 D3hot
> [    1.052614] pci 0031:01:00.1: [14e4:16a1] type 00 class 0x020000
> [    1.052710] pci 0031:01:00.1: reg 0x10: [mem 0x620400d000000-0x620400d7fffff 64bit pref]
> [    1.052747] pci 0031:01:00.1: reg 0x18: [mem 0x620400d800000-0x620400dffffff 64bit pref]
> [    1.052785] pci 0031:01:00.1: reg 0x20: [mem 0x6204010010000-0x620401001ffff 64bit pref]
> [    1.052810] pci 0031:01:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.053055] pci 0031:01:00.1: PME# supported from D0 D3hot
> [    1.053207] pci 0031:01:00.2: [14e4:16a1] type 00 class 0x020000
> [    1.053303] pci 0031:01:00.2: reg 0x10: [mem 0x620400e000000-0x620400e7fffff 64bit pref]
> [    1.053341] pci 0031:01:00.2: reg 0x18: [mem 0x620400e800000-0x620400effffff 64bit pref]
> [    1.053379] pci 0031:01:00.2: reg 0x20: [mem 0x6204010020000-0x620401002ffff 64bit pref]
> [    1.053405] pci 0031:01:00.2: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.053652] pci 0031:01:00.2: PME# supported from D0 D3hot
> [    1.053804] pci 0031:01:00.3: [14e4:16a1] type 00 class 0x020000
> [    1.053901] pci 0031:01:00.3: reg 0x10: [mem 0x620400f000000-0x620400f7fffff 64bit pref]
> [    1.053940] pci 0031:01:00.3: reg 0x18: [mem 0x620400f800000-0x620400fffffff 64bit pref]
> [    1.053978] pci 0031:01:00.3: reg 0x20: [mem 0x6204010030000-0x620401003ffff 64bit pref]
> [    1.054003] pci 0031:01:00.3: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.054252] pci 0031:01:00.3: PME# supported from D0 D3hot
> [    1.059857] pci 0031:00:00.0: PCI bridge to [bus 01]
> [    1.059916] pci 0031:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    1.060060] pci_bus 0031:00: busn_res: [bus 00-ff] end is updated to 01
> [    1.060117] PCI host bridge to bus 0032:00
> [    1.060158] pci_bus 0032:00: root bus resource [mem 0x620c100000000-0x620c17ffeffff] (bus address [0x80000000-0xfffeffff])
> [    1.065411] pci_bus 0032:00: root bus resource [mem 0x6208000000000-0x620bf7fffffff 64bit pref]
> [    1.075121] pci_bus 0032:00: root bus resource [bus 00-ff]
> [    1.079282] pci_bus 0032:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.079316] pci 0032:00:00.0: [1014:04c1] type 01 class 0x060400
> [    1.079535] pci 0032:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.090700] pci 0032:00:00.0: PCI bridge to [bus 01-ff]
> [    1.090758] pci 0032:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    1.090795] pci_bus 0032:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.090849] PCI host bridge to bus 0033:00
> [    1.090891] pci_bus 0033:00: root bus resource [mem 0x620c180000000-0x620c1fffeffff] (bus address [0x80000000-0xfffeffff])
> [    1.100083] pci_bus 0033:00: root bus resource [mem 0x6220000000000-0x6223fbfffffff 64bit pref]
> [    1.108409] pci_bus 0033:00: root bus resource [bus 00-ff]
> [    1.113951] pci_bus 0033:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.113985] pci 0033:00:00.0: [1014:04c1] type 01 class 0x060400
> [    1.114219] pci 0033:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.119946] pci 0033:01:00.0: [8086:10fb] type 00 class 0x020000
> [    1.120028] pci 0033:01:00.0: reg 0x10: [mem 0x6220008000000-0x622000807ffff 64bit pref]
> [    1.120053] pci 0033:01:00.0: reg 0x18: [io  0x0000-0x001f]
> [    1.120110] pci 0033:01:00.0: reg 0x20: [mem 0x6220008100000-0x6220008103fff 64bit pref]
> [    1.120135] pci 0033:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.120168] pci 0033:01:00.0: BAR4 [mem size 0x00004000 64bit pref]: requesting alignment to 0x10000
> [    1.123815] pci 0033:01:00.0: PME# supported from D0 D3hot D3cold
> [    1.123995] pci 0033:01:00.1: [8086:10fb] type 00 class 0x020000
> [    1.124077] pci 0033:01:00.1: reg 0x10: [mem 0x6220008080000-0x62200080fffff 64bit pref]
> [    1.124101] pci 0033:01:00.1: reg 0x18: [io  0x0000-0x001f]
> [    1.124160] pci 0033:01:00.1: reg 0x20: [mem 0x6220008110000-0x6220008113fff 64bit pref]
> [    1.124185] pci 0033:01:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
> [    1.124218] pci 0033:01:00.1: BAR4 [mem size 0x00004000 64bit pref]: requesting alignment to 0x10000
> [    1.132150] pci 0033:01:00.1: PME# supported from D0 D3hot D3cold
> [    1.137756] pci 0033:00:00.0: PCI bridge to [bus 01]
> [    1.137814] pci 0033:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    1.137920] pci_bus 0033:00: busn_res: [bus 00-ff] end is updated to 01
> [    1.137976] PCI host bridge to bus 0034:00
> [    1.141684] pci_bus 0034:00: root bus resource [mem 0x620c200000000-0x620c27ffeffff] (bus address [0x80000000-0xfffeffff])
> [    1.152777] pci_bus 0034:00: root bus resource [mem 0x6224000000000-0x6227f7fffffff 64bit pref]
> [    1.161104] pci_bus 0034:00: root bus resource [bus 00-ff]
> [    1.166649] pci_bus 0034:00: busn_res: [bus 00-ff] end is updated to ff
> [    1.166683] pci 0034:00:00.0: [1014:04c1] type 01 class 0x060400
> [    1.166919] pci 0034:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.172639] pci 0034:01:00.0: [1000:005d] type 00 class 0x010400
> [    1.172706] pci 0034:01:00.0: reg 0x10: [io  0x0000-0x00ff]
> [    1.172742] pci 0034:01:00.0: reg 0x14: [mem 0x620c200200000-0x620c20020ffff 64bit]
> [    1.172778] pci 0034:01:00.0: reg 0x1c: [mem 0x620c200000000-0x620c2000fffff 64bit]
> [    1.172822] pci 0034:01:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
> [    1.173163] pci 0034:01:00.0: supports D1 D2
> [    1.178815] pci 0034:00:00.0: PCI bridge to [bus 01]
> [    1.178873] pci 0034:00:00.0:   bridge window [io  0x0000-0x0fff]
> [    1.178947] pci_bus 0034:00: busn_res: [bus 00-ff] end is updated to 01
> [    1.178998] pci 0000:02:04.0: bridge window [io  0x1000-0x0fff] to [bus 08-0c] add_size 1000
> [    1.179003] pci 0000:02:04.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 08-0c] add_size 20000000 add_align 20000000
> [    1.179008] pci 0000:02:04.0: bridge window [mem 0x00400000-0x003fffff] to [bus 08-0c] add_size 400000 add_align 400000
> [    1.179027] pci 0000:02:05.0: bridge window [io  0x1000-0x0fff] to [bus 0d-11] add_size 1000
> [    1.179032] pci 0000:02:05.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 0d-11] add_size 20000000 add_align 20000000
> [    1.179037] pci 0000:02:05.0: bridge window [mem 0x00400000-0x003fffff] to [bus 0d-11] add_size 400000 add_align 400000
> [    1.179056] pci 0000:02:06.0: bridge window [io  0x1000-0x0fff] to [bus 12] add_size 1000
> [    1.179061] pci 0000:02:06.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 12] add_size 20000000 add_align 20000000
> [    1.179081] pci 0000:02:07.0: bridge window [io  0x1000-0x0fff] to [bus 13] add_size 1000
> [    1.179086] pci 0000:02:07.0: bridge window [mem 0x20000000-0x1fffffff 64bit pref] to [bus 13] add_size 20000000 add_align 20000000
> [    1.179108] pci 0000:01:00.0: bridge window [io  0x1000-0x0fff] to [bus 02-13] add_size 4000
> [    1.179113] pci 0000:01:00.0: bridge window [mem 0x20000000-0x9fffffff 64bit pref] to [bus 02-13] add_size 80000000 add_align 20000000
> [    1.179119] pci 0000:01:00.0: bridge window [mem 0x00400000-0x013fffff] to [bus 02-13] add_size 800000 add_align 400000
> [    1.179143] pci 0000:00:00.0: bridge window [mem 0x20000000-0x9fffffff 64bit pref] to [bus 01-13] add_size 80000000 add_align 20000000
> [    1.179148] pci 0000:00:00.0: bridge window [mem 0x00400000-0x017fffff] to [bus 01-13] add_size 800000 add_align 400000
> [    1.179157] pci 0000:00:00.0: BAR 9: assigned [mem 0x6000000000000-0x60000ffffffff 64bit pref]
> [    1.180520] pci 0000:00:00.0: BAR 8: assigned [mem 0x600c000000000-0x600c001bfffff]
> [    1.187468] pci 0000:01:00.0: BAR 9: assigned [mem 0x6000000000000-0x60000ffffffff 64bit pref]
> [    1.195767] pci 0000:01:00.0: BAR 8: assigned [mem 0x600c000000000-0x600c0017fffff]
> [    1.204088] pci 0000:01:00.0: BAR 0: assigned [mem 0x600c001800000-0x600c00183ffff]
> [    1.211037] pci 0000:01:00.0: BAR 7: no space for [io  size 0x4000]
> [    1.217956] pci 0000:01:00.0: BAR 7: failed to assign [io  size 0x4000]
> [    1.224886] pci 0000:01:00.0: BAR 7: no space for [io  size 0x4000]
> [    1.230441] pci 0000:01:00.0: BAR 7: failed to assign [io  size 0x4000]
> [    1.237366] pci 0000:02:04.0: BAR 9: assigned [mem 0x6000000000000-0x600001fffffff 64bit pref]
> [    1.245705] pci 0000:02:05.0: BAR 9: assigned [mem 0x6000020000000-0x600003fffffff 64bit pref]
> [    1.254010] pci 0000:02:06.0: BAR 9: assigned [mem 0x6000040000000-0x600005fffffff 64bit pref]
> [    1.263714] pci 0000:02:07.0: BAR 9: assigned [mem 0x6000060000000-0x600007fffffff 64bit pref]
> [    1.272041] pci 0000:02:04.0: BAR 8: assigned [mem 0x600c000000000-0x600c0003fffff]
> [    1.278978] pci 0000:02:05.0: BAR 8: assigned [mem 0x600c000400000-0x600c0007fffff]
> [    1.287287] pci 0000:02:06.0: BAR 8: assigned [mem 0x600c000800000-0x600c000bfffff]
> [    1.294236] pci 0000:02:07.0: BAR 8: assigned [mem 0x600c000c00000-0x600c000ffffff]
> [    1.302545] pci 0000:02:04.0: BAR 7: no space for [io  size 0x1000]
> [    1.308098] pci 0000:02:04.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.315024] pci 0000:02:05.0: BAR 7: no space for [io  size 0x1000]
> [    1.320586] pci 0000:02:05.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.327501] pci 0000:02:06.0: BAR 7: no space for [io  size 0x1000]
> [    1.334437] pci 0000:02:06.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.339995] pci 0000:02:07.0: BAR 7: no space for [io  size 0x1000]
> [    1.346922] pci 0000:02:07.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.353851] pci 0000:02:07.0: BAR 7: no space for [io  size 0x1000]
> [    1.359414] pci 0000:02:07.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.366326] pci 0000:02:06.0: BAR 7: no space for [io  size 0x1000]
> [    1.371888] pci 0000:02:06.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.378814] pci 0000:02:05.0: BAR 7: no space for [io  size 0x1000]
> [    1.385753] pci 0000:02:05.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.391301] pci 0000:02:04.0: BAR 7: no space for [io  size 0x1000]
> [    1.398232] pci 0000:02:04.0: BAR 7: failed to assign [io  size 0x1000]
> [    1.405163] pci 0000:00     : [PE# 1fe] Secondary bus 0 associated with PE#1fe
> [    1.412384] pci 0000:02:01.0: PCI bridge to [bus 03-07]
> [    1.417654] pci 0000:02:04.0: PCI bridge to [bus 08-0c]
> [    1.421819] pci 0000:02:04.0:   bridge window [mem 0x600c000000000-0x600c0003fffff]
> [    1.430122] pci 0000:02:04.0:   bridge window [mem 0x6000000000000-0x600001fffffff 64bit pref]
> [    1.438460] pci 0000:02:05.0: PCI bridge to [bus 0d-11]
> [    1.443999] pci 0000:02:05.0:   bridge window [mem 0x600c000400000-0x600c0007fffff]
> [    1.450937] pci 0000:02:05.0:   bridge window [mem 0x6000020000000-0x600003fffffff 64bit pref]
> [    1.460642] pci 0000:12:00.0: BAR 6: assigned [mem 0x600c000800000-0x600c00081ffff pref]
> [    1.467573] pci 0000:12:00.0: BAR 0: assigned [mem 0x600c000820000-0x600c000823fff 64bit]
> [    1.475913] pci 0000:12     : [PE# 1fd] Secondary bus 18 associated with PE#1fd
> [    1.483113] pci 0000:12     : [PE# 1fd] Setting up 32-bit TCE table at 0..80000000
> [    1.498061] IOMMU table initialized, virtual merging enabled
> [    1.498125] pci 0000:12     : [PE# 1fd] Setting up window#0 0..7fffffff pg=1000
> [    1.503635] pci 0000:12     : [PE# 1fd] Enabling 64-bit DMA bypass
> [    1.510560] iommu: Adding device 0000:12:00.0 to group 0
> [    1.514728] pci 0000:02:06.0: PCI bridge to [bus 12]
> [    1.520266] pci 0000:02:06.0:   bridge window [mem 0x600c000800000-0x600c000bfffff]
> [    1.528579] pci 0000:02:06.0:   bridge window [mem 0x6000040000000-0x600005fffffff 64bit pref]
> [    1.536914] pci 0000:13:00.0: BAR 6: assigned [mem 0x600c000c00000-0x600c000c1ffff pref]
> [    1.545225] pci 0000:13:00.0: BAR 0: assigned [mem 0x600c000c20000-0x600c000c23fff 64bit]
> [    1.552179] pci 0000:13     : [PE# 1fc] Secondary bus 19 associated with PE#1fc
> [    1.560762] pci 0000:13     : [PE# 1fc] Setting up 32-bit TCE table at 0..80000000
> [    1.574326] pci 0000:13     : [PE# 1fc] Setting up window#0 0..7fffffff pg=1000
> [    1.574404] pci 0000:13     : [PE# 1fc] Enabling 64-bit DMA bypass
> [    1.581277] iommu: Adding device 0000:13:00.0 to group 1
> [    1.586822] pci 0000:02:07.0: PCI bridge to [bus 13]
> [    1.590998] pci 0000:02:07.0:   bridge window [mem 0x600c000c00000-0x600c000ffffff]
> [    1.599309] pci 0000:02:07.0:   bridge window [mem 0x6000060000000-0x600007fffffff 64bit pref]
> [    1.607648] pci 0000:02     : [PE# 1fb] Secondary bus 2 associated with PE#1fb
> [    1.614855] pci 0000:01:00.0: PCI bridge to [bus 02-13]
> [    1.620112] pci 0000:01:00.0:   bridge window [mem 0x600c000000000-0x600c07fefffff]
> [    1.627060] pci 0000:01:00.0:   bridge window [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
> [    1.635375] pci 0000:01     : [PE# 1fa] Secondary bus 1 associated with PE#1fa
> [    1.643957] pci 0000:00:00.0: PCI bridge to [bus 01-13]
> [    1.647856] pci 0000:00:00.0:   bridge window [mem 0x600c000000000-0x600c07fefffff]
> [    1.656165] pci 0000:00:00.0:   bridge window [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
> [    1.664492] pci_bus 0000:00: resource 4 [mem 0x600c000000000-0x600c07ffeffff]
> [    1.664496] pci_bus 0000:00: resource 5 [mem 0x6000000000000-0x6003fbfffffff 64bit pref]
> [    1.664500] pci_bus 0000:01: resource 1 [mem 0x600c000000000-0x600c07fefffff]
> [    1.664504] pci_bus 0000:01: resource 2 [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
> [    1.664507] pci_bus 0000:02: resource 1 [mem 0x600c000000000-0x600c07fefffff]
> [    1.664511] pci_bus 0000:02: resource 2 [mem 0x6000000000000-0x6003fbff0ffff 64bit pref]
> [    1.664514] pci_bus 0000:08: resource 1 [mem 0x600c000000000-0x600c0003fffff]
> [    1.664518] pci_bus 0000:08: resource 2 [mem 0x6000000000000-0x600001fffffff 64bit pref]
> [    1.664521] pci_bus 0000:0d: resource 1 [mem 0x600c000400000-0x600c0007fffff]
> [    1.664525] pci_bus 0000:0d: resource 2 [mem 0x6000020000000-0x600003fffffff 64bit pref]
> [    1.664528] pci_bus 0000:12: resource 1 [mem 0x600c000800000-0x600c000bfffff]
> [    1.664532] pci_bus 0000:12: resource 2 [mem 0x6000040000000-0x600005fffffff 64bit pref]
> [    1.664535] pci_bus 0000:13: resource 1 [mem 0x600c000c00000-0x600c000ffffff]
> [    1.664538] pci_bus 0000:13: resource 2 [mem 0x6000060000000-0x600007fffffff 64bit pref]
> [    1.664566] pci 0001:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    1.671703] pci 0001:00:00.0: PCI bridge to [bus 01-ff]
> [    1.676978] pci_bus 0001:00: resource 4 [mem 0x600c080000000-0x600c0fffeffff]
> [    1.676982] pci_bus 0001:00: resource 5 [mem 0x6004000000000-0x6007f7fffffff 64bit pref]
> [    1.677011] pci 0002:00:00.0: BAR 9: assigned [mem 0x6008000000000-0x600803fffffff 64bit pref]
> [    1.685293] pci 0002:00:00.0: BAR 8: assigned [mem 0x600c100000000-0x600c1007fffff]
> [    1.693601] pci 0002:01:00.0: BAR 0: assigned [mem 0x6008000000000-0x60080007fffff 64bit pref]
> [    1.701946] pci 0002:01:00.1: BAR 0: assigned [mem 0x6008000800000-0x6008000ffffff 64bit pref]
> [    1.710270] pci 0002:01:00.2: BAR 0: assigned [mem 0x6008001000000-0x60080017fffff 64bit pref]
> [    1.718590] pci 0002:01:00.3: BAR 0: assigned [mem 0x6008001800000-0x6008001ffffff 64bit pref]
> [    1.726905] pci 0002:01:00.0: BAR 6: assigned [mem 0x600c100000000-0x600c10007ffff pref]
> [    1.735202] pci 0002:01:00.1: BAR 6: assigned [mem 0x600c100080000-0x600c1000fffff pref]
> [    1.743516] pci 0002:01:00.2: BAR 6: assigned [mem 0x600c100100000-0x600c10017ffff pref]
> [    1.751842] pci 0002:01:00.3: BAR 6: assigned [mem 0x600c100180000-0x600c1001fffff pref]
> [    1.760166] pci 0002:01:00.0: BAR 3: assigned [mem 0x6008002000000-0x6008002007fff 64bit pref]
> [    1.768517] pci 0002:01:00.1: BAR 3: assigned [mem 0x6008002010000-0x6008002017fff 64bit pref]
> [    1.776833] pci 0002:01:00.2: BAR 3: assigned [mem 0x6008002020000-0x6008002027fff 64bit pref]
> [    1.785154] pci 0002:01:00.3: BAR 3: assigned [mem 0x6008002030000-0x6008002037fff 64bit pref]
> [    1.793475] pci 0002:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    1.800684] pci 0002:01     : [PE# 00] Secondary bus 1 associated with PE#0
> [    1.807601] pci 0002:01     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
> [    1.822536] pci 0002:01     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
> [    1.822621] pci 0002:01     : [PE# 00] Enabling 64-bit DMA bypass
> [    1.828133] iommu: Adding device 0002:01:00.0 to group 2
> [    1.833663] iommu: Adding device 0002:01:00.1 to group 2
> [    1.839212] iommu: Adding device 0002:01:00.2 to group 2
> [    1.844755] iommu: Adding device 0002:01:00.3 to group 2
> [    1.850297] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    1.854483] pci 0002:00:00.0:   bridge window [mem 0x600c100000000-0x600c17fefffff]
> [    1.862784] pci 0002:00:00.0:   bridge window [mem 0x6008000000000-0x600bf7ff0ffff 64bit pref]
> [    1.871117] pci_bus 0002:00: resource 4 [mem 0x600c100000000-0x600c17ffeffff]
> [    1.871120] pci_bus 0002:00: resource 5 [mem 0x6008000000000-0x600bf7fffffff 64bit pref]
> [    1.871124] pci_bus 0002:01: resource 1 [mem 0x600c100000000-0x600c17fefffff]
> [    1.871128] pci_bus 0002:01: resource 2 [mem 0x6008000000000-0x600bf7ff0ffff 64bit pref]
> [    1.871157] pci 0003:00:00.0: BAR 8: assigned [mem 0x600c180000000-0x600c1803fffff]
> [    1.878055] pci 0003:01:00.0: BAR 0: assigned [mem 0x600c180000000-0x600c1800fffff 64bit]
> [    1.886371] pci 0003:01:00.0: BAR 6: assigned [mem 0x600c180100000-0x600c18017ffff pref]
> [    1.894675] pci 0003:01:00.0: BAR 2: assigned [mem 0x600c180180000-0x600c1801803ff 64bit]
> [    1.903015] pci 0003:01:00.0: BAR 4: no space for [io  size 0x0100]
> [    1.908557] pci 0003:01:00.0: BAR 4: failed to assign [io  size 0x0100]
> [    1.915473] pci 0003:00     : [PE# 1fe] Secondary bus 0 associated with PE#1fe
> [    1.922710] pci 0003:01     : [PE# 1fd] Secondary bus 1 associated with PE#1fd
> [    1.931025] pci 0003:01     : [PE# 1fd] Setting up 32-bit TCE table at 0..80000000
> [    1.944583] pci 0003:01     : [PE# 1fd] Setting up window#0 0..7fffffff pg=1000
> [    1.944660] pci 0003:01     : [PE# 1fd] Enabling 64-bit DMA bypass
> [    1.951541] iommu: Adding device 0003:01:00.0 to group 3
> [    1.955697] pci 0003:00:00.0: PCI bridge to [bus 01]
> [    1.961249] pci 0003:00:00.0:   bridge window [mem 0x600c180000000-0x600c1ffefffff]
> [    1.969576] pci_bus 0003:00: Some PCI device resources are unassigned, try booting with pci=realloc
> [    1.977889] pci_bus 0003:00: resource 4 [mem 0x600c180000000-0x600c1fffeffff]
> [    1.977892] pci_bus 0003:00: resource 5 [mem 0x6020000000000-0x6023fbfffffff 64bit pref]
> [    1.977896] pci_bus 0003:01: resource 1 [mem 0x600c180000000-0x600c1ffefffff]
> [    1.977943] pci 0004:00:00.0: BAR 8: assigned [mem 0x600c200000000-0x600c2017fffff]
> [    1.986206] pci 0004:01:00.0: BAR 8: assigned [mem 0x600c200000000-0x600c2017fffff]
> [    1.993146] pci 0004:01:00.0: BAR 7: no space for [io  size 0x1000]
> [    2.000066] pci 0004:01:00.0: BAR 7: failed to assign [io  size 0x1000]
> [    2.005619] pci 0004:02:00.0: BAR 0: assigned [mem 0x600c200000000-0x600c200ffffff]
> [    2.013939] pci 0004:02:00.0: BAR 1: assigned [mem 0x600c201000000-0x600c20101ffff]
> [    2.020885] pci 0004:02:00.0: BAR 2: no space for [io  size 0x0080]
> [    2.027801] pci 0004:02:00.0: BAR 2: failed to assign [io  size 0x0080]
> [    2.034737] pci 0004:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    2.041967] pci 0004:02     : [PE# fd] Secondary bus 2..2 associated with PE#fd
> [    2.048904] pci 0004:02     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
> [    2.062465] pci 0004:02     : [PE# fd] Setting up window#0 0..7fffffff pg=1000
> [    2.062541] pci 0004:02     : [PE# fd] Enabling 64-bit DMA bypass
> [    2.069415] iommu: Adding device 0004:02:00.0 to group 4
> [    2.074954] pci 0004:01:00.0: PCI bridge to [bus 02]
> [    2.079128] pci 0004:01:00.0:   bridge window [mem 0x600c200000000-0x600c27fefffff]
> [    2.087457] pci 0004:01     : [PE# fc] Secondary bus 1 associated with PE#fc
> [    2.094647] pci 0004:00:00.0: PCI bridge to [bus 01-02]
> [    2.098541] pci 0004:00:00.0:   bridge window [mem 0x600c200000000-0x600c27fefffff]
> [    2.106849] pci_bus 0004:00: Some PCI device resources are unassigned, try booting with pci=realloc
> [    2.115179] pci_bus 0004:00: resource 4 [mem 0x600c200000000-0x600c27ffeffff]
> [    2.115183] pci_bus 0004:00: resource 5 [mem 0x6024000000000-0x6027f7fffffff 64bit pref]
> [    2.115186] pci_bus 0004:01: resource 1 [mem 0x600c200000000-0x600c27fefffff]
> [    2.115190] pci_bus 0004:02: resource 1 [mem 0x600c200000000-0x600c27fefffff]
> [    2.115219] pci 0005:00:00.0: BAR 8: assigned [mem 0x600c280000000-0x600c2807fffff]
> [    2.123490] pci 0005:01:00.0: BAR 0: assigned [mem 0x600c280000000-0x600c28000ffff 64bit]
> [    2.131828] pci 0005:01:00.0: BAR 2: assigned [mem 0x600c280010000-0x600c280011fff 64bit]
> [    2.140145] pci 0005:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    2.147353] pci 0005:01     : [PE# fd] Secondary bus 1 associated with PE#fd
> [    2.154290] pci 0005:01     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
> [    2.167852] pci 0005:01     : [PE# fd] Setting up window#0 0..7fffffff pg=1000
> [    2.167928] pci 0005:01     : [PE# fd] Enabling 64-bit DMA bypass
> [    2.174805] iommu: Adding device 0005:01:00.0 to group 5
> [    2.180335] pci 0005:00:00.0: PCI bridge to [bus 01]
> [    2.184521] pci 0005:00:00.0:   bridge window [mem 0x600c280000000-0x600c2ffefffff]
> [    2.192839] pci_bus 0005:00: resource 4 [mem 0x600c280000000-0x600c2fffeffff]
> [    2.192843] pci_bus 0005:00: resource 5 [mem 0x6028000000000-0x602bf7fffffff 64bit pref]
> [    2.192846] pci_bus 0005:01: resource 1 [mem 0x600c280000000-0x600c2ffefffff]
> [    2.192879] pci 0030:00:00.0: BAR 8: assigned [mem 0x620c000000000-0x620c0003fffff]
> [    2.199769] pci 0030:01:00.0: BAR 6: assigned [mem 0x620c000000000-0x620c0000fffff pref]
> [    2.208086] pci 0030:01:00.0: BAR 3: assigned [mem 0x620c000100000-0x620c00013ffff 64bit]
> [    2.216413] pci 0030:01:00.0: BAR 1: assigned [mem 0x620c000140000-0x620c00014ffff 64bit]
> [    2.224741] pci 0030:01:00.0: BAR 0: no space for [io  size 0x0100]
> [    2.230273] pci 0030:01:00.0: BAR 0: failed to assign [io  size 0x0100]
> [    2.237199] pci 0030:00     : [PE# 1fe] Secondary bus 0 associated with PE#1fe
> [    2.244425] pci 0030:01     : [PE# 1fd] Secondary bus 1 associated with PE#1fd
> [    2.251375] pci 0030:01     : [PE# 1fd] Setting up 32-bit TCE table at 0..80000000
> [    2.266304] pci 0030:01     : [PE# 1fd] Setting up window#0 0..7fffffff pg=1000
> [    2.266438] pci 0030:01     : [PE# 1fd] Enabling 64-bit DMA bypass
> [    2.271883] iommu: Adding device 0030:01:00.0 to group 6
> [    2.277416] pci 0030:00:00.0: PCI bridge to [bus 01]
> [    2.282977] pci 0030:00:00.0:   bridge window [mem 0x620c000000000-0x620c07fefffff]
> [    2.289917] pci_bus 0030:00: Some PCI device resources are unassigned, try booting with pci=realloc
> [    2.299602] pci_bus 0030:00: resource 4 [mem 0x620c000000000-0x620c07ffeffff]
> [    2.299606] pci_bus 0030:00: resource 5 [mem 0x6200000000000-0x6203fbfffffff 64bit pref]
> [    2.299609] pci_bus 0030:01: resource 1 [mem 0x620c000000000-0x620c07fefffff]
> [    2.299646] pci 0031:00:00.0: BAR 9: assigned [mem 0x6204000000000-0x620403fffffff 64bit pref]
> [    2.307936] pci 0031:00:00.0: BAR 8: assigned [mem 0x620c080000000-0x620c0807fffff]
> [    2.316253] pci 0031:01:00.0: BAR 0: assigned [mem 0x6204000000000-0x62040007fffff 64bit pref]
> [    2.324597] pci 0031:01:00.0: BAR 2: assigned [mem 0x6204000800000-0x6204000ffffff 64bit pref]
> [    2.332919] pci 0031:01:00.1: BAR 0: assigned [mem 0x6204001000000-0x62040017fffff 64bit pref]
> [    2.341240] pci 0031:01:00.1: BAR 2: assigned [mem 0x6204001800000-0x6204001ffffff 64bit pref]
> [    2.349563] pci 0031:01:00.2: BAR 0: assigned [mem 0x6204002000000-0x62040027fffff 64bit pref]
> [    2.357877] pci 0031:01:00.2: BAR 2: assigned [mem 0x6204002800000-0x6204002ffffff 64bit pref]
> [    2.367570] pci 0031:01:00.3: BAR 0: assigned [mem 0x6204003000000-0x62040037fffff 64bit pref]
> [    2.375903] pci 0031:01:00.3: BAR 2: assigned [mem 0x6204003800000-0x6204003ffffff 64bit pref]
> [    2.384232] pci 0031:01:00.0: BAR 6: assigned [mem 0x620c080000000-0x620c08007ffff pref]
> [    2.392506] pci 0031:01:00.1: BAR 6: assigned [mem 0x620c080080000-0x620c0800fffff pref]
> [    2.400831] pci 0031:01:00.2: BAR 6: assigned [mem 0x620c080100000-0x620c08017ffff pref]
> [    2.407778] pci 0031:01:00.3: BAR 6: assigned [mem 0x620c080180000-0x620c0801fffff pref]
> [    2.416097] pci 0031:01:00.0: BAR 4: assigned [mem 0x6204004000000-0x620400400ffff 64bit pref]
> [    2.424432] pci 0031:01:00.1: BAR 4: assigned [mem 0x6204004010000-0x620400401ffff 64bit pref]
> [    2.434139] pci 0031:01:00.2: BAR 4: assigned [mem 0x6204004020000-0x620400402ffff 64bit pref]
> [    2.442464] pci 0031:01:00.3: BAR 4: assigned [mem 0x6204004030000-0x620400403ffff 64bit pref]
> [    2.450787] pci 0031:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    2.458012] pci 0031:01     : [PE# 00] Secondary bus 1 associated with PE#0
> [    2.464921] pci 0031:01     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
> [    2.478491] pci 0031:01     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
> [    2.479883] pci 0031:01     : [PE# 00] Enabling 64-bit DMA bypass
> [    2.485447] iommu: Adding device 0031:01:00.0 to group 7
> [    2.490967] iommu: Adding device 0031:01:00.1 to group 7
> [    2.496528] iommu: Adding device 0031:01:00.2 to group 7
> [    2.500694] iommu: Adding device 0031:01:00.3 to group 7
> [    2.506223] pci 0031:00:00.0: PCI bridge to [bus 01]
> [    2.511786] pci 0031:00:00.0:   bridge window [mem 0x620c080000000-0x620c0ffefffff]
> [    2.518720] pci 0031:00:00.0:   bridge window [mem 0x6204000000000-0x6207f7ff0ffff 64bit pref]
> [    2.528432] pci_bus 0031:00: resource 4 [mem 0x620c080000000-0x620c0fffeffff]
> [    2.528435] pci_bus 0031:00: resource 5 [mem 0x6204000000000-0x6207f7fffffff 64bit pref]
> [    2.528439] pci_bus 0031:01: resource 1 [mem 0x620c080000000-0x620c0ffefffff]
> [    2.528443] pci_bus 0031:01: resource 2 [mem 0x6204000000000-0x6207f7ff0ffff 64bit pref]
> [    2.528475] pci 0032:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    2.535633] pci 0032:00:00.0: PCI bridge to [bus 01-ff]
> [    2.539535] pci_bus 0032:00: resource 4 [mem 0x620c100000000-0x620c17ffeffff]
> [    2.539539] pci_bus 0032:00: resource 5 [mem 0x6208000000000-0x620bf7fffffff 64bit pref]
> [    2.539574] pci 0033:00:00.0: BAR 9: assigned [mem 0x6220000000000-0x622001fffffff 64bit pref]
> [    2.549214] pci 0033:00:00.0: BAR 8: assigned [mem 0x620c180000000-0x620c1803fffff]
> [    2.556161] pci 0033:01:00.0: BAR 0: assigned [mem 0x6220000000000-0x622000007ffff 64bit pref]
> [    2.564501] pci 0033:01:00.0: BAR 6: assigned [mem 0x620c180000000-0x620c18007ffff pref]
> [    2.572794] pci 0033:01:00.1: BAR 0: assigned [mem 0x6220000080000-0x62200000fffff 64bit pref]
> [    2.581142] pci 0033:01:00.1: BAR 6: assigned [mem 0x620c180080000-0x620c1800fffff pref]
> [    2.589428] pci 0033:01:00.0: BAR 4: assigned [mem 0x6220000100000-0x6220000103fff 64bit pref]
> [    2.597775] pci 0033:01:00.1: BAR 4: assigned [mem 0x6220000110000-0x6220000113fff 64bit pref]
> [    2.606109] pci 0033:01:00.0: BAR 2: no space for [io  size 0x0020]
> [    2.612994] pci 0033:01:00.0: BAR 2: failed to assign [io  size 0x0020]
> [    2.619942] pci 0033:01:00.1: BAR 2: no space for [io  size 0x0020]
> [    2.625495] pci 0033:01:00.1: BAR 2: failed to assign [io  size 0x0020]
> [    2.632416] pci 0033:00     : [PE# 1fe] Secondary bus 0 associated with PE#1fe
> [    2.639655] pci 0033:01     : [PE# 00] Secondary bus 1 associated with PE#0
> [    2.646582] pci 0033:01     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
> [    2.660136] pci 0033:01     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
> [    2.661536] pci 0033:01     : [PE# 00] Enabling 64-bit DMA bypass
> [    2.667101] iommu: Adding device 0033:01:00.0 to group 8
> [    2.672638] iommu: Adding device 0033:01:00.1 to group 8
> [    2.678179] pci 0033:00:00.0: PCI bridge to [bus 01]
> [    2.682361] pci 0033:00:00.0:   bridge window [mem 0x620c180000000-0x620c1ffefffff]
> [    2.690669] pci 0033:00:00.0:   bridge window [mem 0x6220000000000-0x6223fbff0ffff 64bit pref]
> [    2.698995] pci_bus 0033:00: Some PCI device resources are unassigned, try booting with pci=realloc
> [    2.707311] pci_bus 0033:00: resource 4 [mem 0x620c180000000-0x620c1fffeffff]
> [    2.707314] pci_bus 0033:00: resource 5 [mem 0x6220000000000-0x6223fbfffffff 64bit pref]
> [    2.707318] pci_bus 0033:01: resource 1 [mem 0x620c180000000-0x620c1ffefffff]
> [    2.707321] pci_bus 0033:01: resource 2 [mem 0x6220000000000-0x6223fbff0ffff 64bit pref]
> [    2.707354] pci 0034:00:00.0: BAR 8: assigned [mem 0x620c200000000-0x620c2007fffff]
> [    2.715615] pci 0034:01:00.0: BAR 3: assigned [mem 0x620c200000000-0x620c2000fffff 64bit]
> [    2.723969] pci 0034:01:00.0: BAR 6: assigned [mem 0x620c200100000-0x620c2001fffff pref]
> [    2.732266] pci 0034:01:00.0: BAR 1: assigned [mem 0x620c200200000-0x620c20020ffff 64bit]
> [    2.739229] pci 0034:01:00.0: BAR 0: no space for [io  size 0x0100]
> [    2.746131] pci 0034:01:00.0: BAR 0: failed to assign [io  size 0x0100]
> [    2.753063] pci 0034:00     : [PE# fe] Secondary bus 0 associated with PE#fe
> [    2.760285] pci 0034:01     : [PE# fd] Secondary bus 1 associated with PE#fd
> [    2.767230] pci 0034:01     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
> [    2.780798] pci 0034:01     : [PE# fd] Setting up window#0 0..7fffffff pg=1000
> [    2.780876] pci 0034:01     : [PE# fd] Enabling 64-bit DMA bypass
> [    2.787740] iommu: Adding device 0034:01:00.0 to group 9
> [    2.793272] pci 0034:00:00.0: PCI bridge to [bus 01]
> [    2.797460] pci 0034:00:00.0:   bridge window [mem 0x620c200000000-0x620c27fefffff]
> [    2.805780] pci_bus 0034:00: Some PCI device resources are unassigned, try booting with pci=realloc
> [    2.814087] pci_bus 0034:00: resource 4 [mem 0x620c200000000-0x620c27ffeffff]
> [    2.814090] pci_bus 0034:00: resource 5 [mem 0x6224000000000-0x6227f7fffffff 64bit pref]
> [    2.814094] pci_bus 0034:01: resource 1 [mem 0x620c200000000-0x620c27fefffff]
> [    2.816741] PCI: Probing PCI hardware done
> [    2.819487] cpuidle-powernv: Default stop: psscr = 0x0000000000000330,mask=0x00000000003003ff
> [    2.822400] cpuidle-powernv: Deepest stop: psscr = 0x0000000000300375,mask=0x00000000003003ff
> [    2.830725] cpuidle-powernv: Requested Level (RL) value of first deep stop = 0x4
> [    2.846774] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    2.846835] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
> [    2.854067] pci 0004:02:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
> [    2.859842] pci 0004:02:00.0: vgaarb: bridge control possible
> [    2.865399] pci 0004:02:00.0: vgaarb: setting as boot device (VGA legacy resources not available)
> [    2.875089] vgaarb: loaded
> [    2.878169] SCSI subsystem initialized
> [    2.880663] libata version 3.00 loaded.
> [    2.880744] usbcore: registered new interface driver usbfs
> [    2.886202] usbcore: registered new interface driver hub
> [    2.892209] usbcore: registered new device driver usb
> [    2.897345] pps_core: LinuxPPS API ver. 1 registered
> [    2.901451] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    2.911156] PTP clock support registered
> [    2.916569] clocksource: Switched to clocksource timebase
> [    2.941126] NET: Registered protocol family 2
> [    2.941760] tcp_listen_portaddr_hash hash table entries: 65536 (order: 4, 1048576 bytes)
> [    2.942163] TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
> [    2.943790] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
> [    2.947497] TCP: Hash tables configured (established 524288 bind 65536)
> [    2.952962] UDP hash table entries: 65536 (order: 5, 2097152 bytes)
> [    2.960350] UDP-Lite hash table entries: 65536 (order: 5, 2097152 bytes)
> [    2.967614] NET: Registered protocol family 1
> [    2.971339] RPC: Registered named UNIX socket transport module.
> [    2.976328] RPC: Registered udp transport module.
> [    2.981880] RPC: Registered tcp transport module.
> [    2.986032] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    2.993072] pci 0005:00:00.0: enabling device (0101 -> 0103)
> [    2.998526] pci 0005:01:00.0: enabling device (0140 -> 0142)
> [    3.020212] pci 0005:01:00.0: xHCI HW did not halt within 16000 usec status = 0x0
> [    3.020290] pci 0005:01:00.0: quirk_usb_early_handoff+0x0/0xd90 took 26582 usecs
> [    3.020417] pci 0034:01:00.0: [Firmware Bug]: disabling VPD access (can't determine size of non-standard VPD format)
> [    3.029020] PCI: CLS 64 bytes, default 128
> [    3.029090] Trying to unpack rootfs image as initramfs...
> [    5.595479] Freeing initrd memory: 103488K
> [    5.598429] nest_capp0_imc performance monitor hardware support registered
> [    5.598555] nest_capp1_imc performance monitor hardware support registered
> [    5.601683] core_imc performance monitor hardware support registered
> [    5.601786] nest_mba0_imc performance monitor hardware support registered
> [    5.601881] nest_mba1_imc performance monitor hardware support registered
> [    5.601991] nest_mba2_imc performance monitor hardware support registered
> [    5.602086] nest_mba3_imc performance monitor hardware support registered
> [    5.602181] nest_mba4_imc performance monitor hardware support registered
> [    5.602275] nest_mba5_imc performance monitor hardware support registered
> [    5.602369] nest_mba6_imc performance monitor hardware support registered
> [    5.602463] nest_mba7_imc performance monitor hardware support registered
> [    5.602571] nest_mcs01_imc performance monitor hardware support registered
> [    5.602678] nest_mcs23_imc performance monitor hardware support registered
> [    5.602827] nest_nvlink0_imc performance monitor hardware support registered
> [    5.602971] nest_nvlink1_imc performance monitor hardware support registered
> [    5.603114] nest_nvlink2_imc performance monitor hardware support registered
> [    5.603255] nest_nvlink3_imc performance monitor hardware support registered
> [    5.603416] nest_nvlink4_imc performance monitor hardware support registered
> [    5.603557] nest_nvlink5_imc performance monitor hardware support registered
> [    5.603677] nest_nx_imc performance monitor hardware support registered
> [    5.603774] nest_phb0_imc performance monitor hardware support registered
> [    5.603872] nest_phb1_imc performance monitor hardware support registered
> [    5.603968] nest_phb2_imc performance monitor hardware support registered
> [    5.604066] nest_phb3_imc performance monitor hardware support registered
> [    5.604162] nest_phb4_imc performance monitor hardware support registered
> [    5.604259] nest_phb5_imc performance monitor hardware support registered
> [    5.604399] nest_powerbus0_imc performance monitor hardware support registered
> [    5.607620] thread_imc performance monitor hardware support registered
> [    5.607735] nest_xlink0_imc performance monitor hardware support registered
> [    5.607846] nest_xlink1_imc performance monitor hardware support registered
> [    5.607956] nest_xlink2_imc performance monitor hardware support registered
> [    5.621574] workingset: timestamp_bits=38 max_order=21 bucket_order=0
> [    5.628670] NFS: Registering the id_resolver key type
> [    5.628726] Key type id_resolver registered
> [    5.628761] Key type id_legacy registered
> [    5.628808] pstore: using deflate compression
> [    5.629724] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
> [    5.629795] io scheduler noop registered
> [    5.629830] io scheduler deadline registered
> [    5.630244] io scheduler cfq registered (default)
> [    5.630291] io scheduler mq-deadline registered
> [    5.630336] io scheduler kyber registered
> [    5.632492] pci 0004:00:00.0: enabling device (0101 -> 0103)
> [    5.632562] pci 0004:01:00.0: enabling device (0141 -> 0143)
> [    5.632628] pci 0004:02:00.0: enabling device (0141 -> 0143)
> [    5.632692] Using unsupported 1024x768 vga at 600c200010000, depth=32, pitch=4096
> [    5.715647] Console: switching to colour frame buffer device 128x48
> [    5.797006] fb0: Open Firmware frame buffer device on /pciex@600c3c0400000/pci@0/pci@0/vga@0
> [    5.814705] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
> [    5.814787] hvc0: No interrupts property, using OPAL event
> [    5.815227] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    5.819996] brd: module loaded
> [    5.833910] loop: module loaded
> [    5.833948] Uniform Multi-Platform E-IDE driver
> [    5.834109] ide-gd driver 1.18
> [    5.834156] ide-cd driver 5.00
> [    5.834257] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March 14, 2017)
> [    5.834704] libphy: Fixed MDIO Bus: probed
> [    5.834804] ibmveth: IBM Power Virtual Ethernet Driver 1.06
> [    5.834822] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    5.834882] e100: Copyright(c) 1999-2006 Intel Corporation
> [    5.834976] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> [    5.835045] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    5.835132] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    5.835189] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    5.835289] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.835347] ehci-pci: EHCI PCI platform driver
> [    5.835415] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.835477] ohci-pci: OHCI PCI platform driver
> [    5.836146] mousedev: PS/2 mouse device common for all mice
> [    5.856571] rtc-opal opal-rtc: rtc core: registered rtc-opal as rtc0
> [    5.859287] device-mapper: uevent: version 1.0.3
> [    5.859586] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
> [    5.859676] powernv-cpufreq: cpufreq pstate min 0x62 nominal 0x5d max 0x0
> [    5.859732] powernv-cpufreq: Workload Optimized Frequency is enabled in the platform
> [    5.872773] powernv_idle_driver registered
> [    5.880389] usbcore: registered new interface driver usbhid
> [    5.880428] usbhid: USB HID core driver
> [    5.880457] oprofile: using timer interrupt.
> [    5.880744] ipip: IPv4 and MPLS over IPv4 tunneling driver
> [    5.880960] NET: Registered protocol family 17
> [    5.881023] Key type dns_resolver registered
> [    5.881100] drmem: No dynamic reconfiguration memory found
> [    5.881136] Running code patching self-tests ...
> [    5.881487] Running feature fixup self-tests ...
> [    5.881492] Running MSI bitmap self-tests ...
> [    5.881702] registered taskstats version 1
> [    5.882018] console [netcon0] enabled
> [    5.882062] netconsole: network logging started
> [    5.916590] rtc-opal opal-rtc: setting system clock to 2018-06-28 08:47:56 UTC (1530175676)
> [    5.917441] Freeing unused kernel memory: 2752K
> [    5.917478] This architecture does not have kernel memory protection.
> [    5.921631] exe (2390) used greatest stack depth: 12368 bytes left
> [    5.926988] exe (2396) used greatest stack depth: 12032 bytes left
> [    6.097730] synth uevent: /devices/vio: failed to send uevent
> [    6.097733] vio vio: uevent: failed to send synthetic uevent
> [    6.103991] udevadm (2412) used greatest stack depth: 11120 bytes left
> [    6.114419] nvme nvme0: pci function 0000:12:00.0
> [    6.114499] pci 0000:00:00.0: enabling device (0101 -> 0103)
> [    6.114567] pci 0000:01:00.0: enabling device (0141 -> 0143)
> [    6.114588] nvme nvme1: pci function 0000:13:00.0
> [    6.114636] pci 0000:02:06.0: enabling device (0141 -> 0143)
> [    6.114691] pci 0000:02:07.0: enabling device (0141 -> 0143)
> [    6.114730] nvme 0000:12:00.0: enabling device (0140 -> 0142)
> [    6.114778] nvme 0000:13:00.0: enabling device (0140 -> 0142)
> [    6.114827] nvme 0000:12:00.0: Using 64-bit DMA iommu bypass
> [    6.114870] nvme 0000:13:00.0: Using 64-bit DMA iommu bypass
> [    6.154159] mpt3sas version 25.100.00.00 loaded
> [    6.155139] pci 0030:00:00.0: enabling device (0101 -> 0103)
> [    6.155215] mpt3sas 0030:01:00.0: enabling device (0140 -> 0142)
> [    6.155308] mpt3sas 0030:01:00.0: Using 64-bit DMA iommu bypass
> [    6.155368] mpt3sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (133760960 kB)
> [    6.183349] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
> [    6.183616] bnx2x 0031:01:00.0: msix capability found
> [    6.183699] pci 0031:00:00.0: enabling device (0101 -> 0103)
> [    6.183755] bnx2x 0031:01:00.0: enabling device (0140 -> 0142)
> [    6.183895] bnx2x 0031:01:00.0: Using 64-bit DMA iommu bypass
> [    6.184003] bnx2x 0031:01:00.0: part number 394D4342-34383735-30345430-473030
> [    6.185339] i40e: Intel(R) Ethernet Connection XL710 Network Driver - version 2.3.2-k
> [    6.185391] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
> [    6.185711] pci 0002:00:00.0: enabling device (0101 -> 0103)
> [    6.185789] i40e 0002:01:00.0: enabling device (0140 -> 0142)
> [    6.185845] i40e 0002:01:00.0: Using 64-bit DMA iommu bypass
> [    6.196410] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 5.1.0-k
> [    6.196460] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
> [    6.196693] pci 0033:00:00.0: enabling device (0101 -> 0103)
> [    6.196750] ixgbe 0033:01:00.0: enabling device (0140 -> 0142)
> [    6.196804] ixgbe 0033:01:00.0: Using 64-bit DMA iommu bypass
> [    6.199342] i40e 0002:01:00.0: fw 5.1.40981 api 1.5 nvm 5.05 0x800029e1 1.1313.0
> [    6.230662] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 4k
> [    6.230731] mpt3sas_cm0: MSI-X vectors supported: 96, no of cores: 128, max_msix_vectors: -1
> [    6.232963] mpt3sas0-msix0: PCI-MSI-X enabled: IRQ 64
> [    6.232998] mpt3sas0-msix1: PCI-MSI-X enabled: IRQ 65
> [    6.233030] mpt3sas0-msix2: PCI-MSI-X enabled: IRQ 66
> [    6.233063] mpt3sas0-msix3: PCI-MSI-X enabled: IRQ 67
> [    6.233095] mpt3sas0-msix4: PCI-MSI-X enabled: IRQ 68
> [    6.233128] mpt3sas0-msix5: PCI-MSI-X enabled: IRQ 69
> [    6.233160] mpt3sas0-msix6: PCI-MSI-X enabled: IRQ 70
> [    6.233192] mpt3sas0-msix7: PCI-MSI-X enabled: IRQ 71
> [    6.233225] mpt3sas0-msix8: PCI-MSI-X enabled: IRQ 75
> [    6.233257] mpt3sas0-msix9: PCI-MSI-X enabled: IRQ 76
> [    6.233289] mpt3sas0-msix10: PCI-MSI-X enabled: IRQ 77
> [    6.233321] mpt3sas0-msix11: PCI-MSI-X enabled: IRQ 78
> [    6.233354] mpt3sas0-msix12: PCI-MSI-X enabled: IRQ 79
> [    6.233386] mpt3sas0-msix13: PCI-MSI-X enabled: IRQ 81
> [    6.233418] mpt3sas0-msix14: PCI-MSI-X enabled: IRQ 82
> [    6.233450] mpt3sas0-msix15: PCI-MSI-X enabled: IRQ 83
> [    6.233483] mpt3sas0-msix16: PCI-MSI-X enabled: IRQ 84
> [    6.233515] mpt3sas0-msix17: PCI-MSI-X enabled: IRQ 85
> [    6.233548] mpt3sas0-msix18: PCI-MSI-X enabled: IRQ 86
> [    6.233580] mpt3sas0-msix19: PCI-MSI-X enabled: IRQ 87
> [    6.233612] mpt3sas0-msix20: PCI-MSI-X enabled: IRQ 89
> [    6.233644] mpt3sas0-msix21: PCI-MSI-X enabled: IRQ 90
> [    6.233677] mpt3sas0-msix22: PCI-MSI-X enabled: IRQ 91
> [    6.233709] mpt3sas0-msix23: PCI-MSI-X enabled: IRQ 92
> [    6.233741] mpt3sas0-msix24: PCI-MSI-X enabled: IRQ 93
> [    6.233773] mpt3sas0-msix25: PCI-MSI-X enabled: IRQ 94
> [    6.233805] mpt3sas0-msix26: PCI-MSI-X enabled: IRQ 95
> [    6.233838] mpt3sas0-msix27: PCI-MSI-X enabled: IRQ 96
> [    6.233870] mpt3sas0-msix28: PCI-MSI-X enabled: IRQ 97
> [    6.233902] mpt3sas0-msix29: PCI-MSI-X enabled: IRQ 98
> [    6.233934] mpt3sas0-msix30: PCI-MSI-X enabled: IRQ 99
> [    6.233967] mpt3sas0-msix31: PCI-MSI-X enabled: IRQ 100
> [    6.233999] mpt3sas0-msix32: PCI-MSI-X enabled: IRQ 101
> [    6.234032] mpt3sas0-msix33: PCI-MSI-X enabled: IRQ 102
> [    6.234064] mpt3sas0-msix34: PCI-MSI-X enabled: IRQ 103
> [    6.234097] mpt3sas0-msix35: PCI-MSI-X enabled: IRQ 104
> [    6.234129] mpt3sas0-msix36: PCI-MSI-X enabled: IRQ 105
> [    6.234161] mpt3sas0-msix37: PCI-MSI-X enabled: IRQ 106
> [    6.234193] mpt3sas0-msix38: PCI-MSI-X enabled: IRQ 107
> [    6.234226] mpt3sas0-msix39: PCI-MSI-X enabled: IRQ 108
> [    6.234258] mpt3sas0-msix40: PCI-MSI-X enabled: IRQ 109
> [    6.234309] mpt3sas0-msix41: PCI-MSI-X enabled: IRQ 110
> [    6.234341] mpt3sas0-msix42: PCI-MSI-X enabled: IRQ 111
> [    6.234374] mpt3sas0-msix43: PCI-MSI-X enabled: IRQ 112
> [    6.234406] mpt3sas0-msix44: PCI-MSI-X enabled: IRQ 113
> [    6.234439] mpt3sas0-msix45: PCI-MSI-X enabled: IRQ 114
> [    6.234471] mpt3sas0-msix46: PCI-MSI-X enabled: IRQ 115
> [    6.238459] mpt3sas0-msix47: PCI-MSI-X enabled: IRQ 116
> [    6.244003] mpt3sas0-msix48: PCI-MSI-X enabled: IRQ 117
> [    6.249554] mpt3sas0-msix49: PCI-MSI-X enabled: IRQ 118
> [    6.253715] mpt3sas0-msix50: PCI-MSI-X enabled: IRQ 119
> [    6.259260] mpt3sas0-msix51: PCI-MSI-X enabled: IRQ 120
> [    6.264799] mpt3sas0-msix52: PCI-MSI-X enabled: IRQ 121
> [    6.270353] mpt3sas0-msix53: PCI-MSI-X enabled: IRQ 122
> [    6.274514] mpt3sas0-msix54: PCI-MSI-X enabled: IRQ 123
> [    6.280057] mpt3sas0-msix55: PCI-MSI-X enabled: IRQ 124
> [    6.285604] mpt3sas0-msix56: PCI-MSI-X enabled: IRQ 125
> [    6.291154] mpt3sas0-msix57: PCI-MSI-X enabled: IRQ 126
> [    6.295315] mpt3sas0-msix58: PCI-MSI-X enabled: IRQ 127
> [    6.300857] mpt3sas0-msix59: PCI-MSI-X enabled: IRQ 128
> [    6.306405] mpt3sas0-msix60: PCI-MSI-X enabled: IRQ 129
> [    6.311956] mpt3sas0-msix61: PCI-MSI-X enabled: IRQ 130
> [    6.316119] mpt3sas0-msix62: PCI-MSI-X enabled: IRQ 131
> [    6.321659] mpt3sas0-msix63: PCI-MSI-X enabled: IRQ 132
> [    6.327209] mpt3sas0-msix64: PCI-MSI-X enabled: IRQ 133
> [    6.332752] mpt3sas0-msix65: PCI-MSI-X enabled: IRQ 134
> [    6.336923] mpt3sas0-msix66: PCI-MSI-X enabled: IRQ 135
> [    6.342460] mpt3sas0-msix67: PCI-MSI-X enabled: IRQ 136
> [    6.348011] mpt3sas0-msix68: PCI-MSI-X enabled: IRQ 137
> [    6.349732] nvme nvme0: Shutdown timeout set to 8 seconds
> [    6.349757] nvme nvme1: Shutdown timeout set to 8 seconds
> [    6.353553] mpt3sas0-msix69: PCI-MSI-X enabled: IRQ 138
> [    6.358569]  nvme1n1: p1 p2
> [    6.363262] mpt3sas0-msix70: PCI-MSI-X enabled: IRQ 139
> [    6.363265] mpt3sas0-msix71: PCI-MSI-X enabled: IRQ 140
> [    6.382674] mpt3sas0-msix72: PCI-MSI-X enabled: IRQ 141
> [    6.386847] mpt3sas0-msix73: PCI-MSI-X enabled: IRQ 142
> [    6.392377] mpt3sas0-msix74: PCI-MSI-X enabled: IRQ 143
> [    6.397930] mpt3sas0-msix75: PCI-MSI-X enabled: IRQ 144
> [    6.403474] mpt3sas0-msix76: PCI-MSI-X enabled: IRQ 145
> [    6.407648] mpt3sas0-msix77: PCI-MSI-X enabled: IRQ 146
> [    6.413182] mpt3sas0-msix78: PCI-MSI-X enabled: IRQ 147
> [    6.418735] mpt3sas0-msix79: PCI-MSI-X enabled: IRQ 148
> [    6.424277] mpt3sas0-msix80: PCI-MSI-X enabled: IRQ 149
> [    6.428446] mpt3sas0-msix81: PCI-MSI-X enabled: IRQ 150
> [    6.433985] mpt3sas0-msix82: PCI-MSI-X enabled: IRQ 151
> [    6.439533] mpt3sas0-msix83: PCI-MSI-X enabled: IRQ 152
> [    6.443073] i40e 0002:01:00.0: MAC address: 0c:c4:7a:f2:d5:b6
> [    6.445077] mpt3sas0-msix84: PCI-MSI-X enabled: IRQ 153
> [    6.445080] mpt3sas0-msix85: PCI-MSI-X enabled: IRQ 154
> [    6.458393] i40e 0002:01:00.0 eth0: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
> [    6.460335] mpt3sas0-msix86: PCI-MSI-X enabled: IRQ 155
> [    6.470320] i40e 0002:01:00.0: PCI-Express: Speed 8.0GT/s Width x8
> [    6.474199] mpt3sas0-msix87: PCI-MSI-X enabled: IRQ 156
> [    6.480273] i40e 0002:01:00.0: Features: PF-id[0] VSIs: 34 QP: 119 RSS FD_ATR FD_SB NTUPLE VxLAN Geneve PTP VEPA
> [    6.485295] mpt3sas0-msix88: PCI-MSI-X enabled: IRQ 157
> [    6.496450] i40e 0002:01:00.1: enabling device (0140 -> 0142)
> [    6.500555] mpt3sas0-msix89: PCI-MSI-X enabled: IRQ 158
> [    6.500557] mpt3sas0-msix90: PCI-MSI-X enabled: IRQ 159
> [    6.506103] i40e 0002:01:00.1: Using 64-bit DMA iommu bypass
> [    6.511640] mpt3sas0-msix91: PCI-MSI-X enabled: IRQ 160
> [    6.511643] mpt3sas0-msix92: PCI-MSI-X enabled: IRQ 161
> [    6.530569] i40e 0002:01:00.1: fw 5.1.40981 api 1.5 nvm 5.05 0x800029e1 1.1313.0
> [    6.532447] mpt3sas0-msix93: PCI-MSI-X enabled: IRQ 162
> [    6.532449] mpt3sas0-msix94: PCI-MSI-X enabled: IRQ 163
> [    6.550480] mpt3sas0-msix95: PCI-MSI-X enabled: IRQ 164
> [    6.556017] mpt3sas_cm0: iomem(0x000620c000140000), mapped(0x(____ptrval____)), size(65536)
> [    6.564340] mpt3sas_cm0: ioport(0x0000000000000000), size(0)
> [    6.571410] bnx2x 0031:01:00.0: 63.008 Gb/s available PCIe bandwidth (8 GT/s x8 link)
> [    6.578387] bnx2x 0031:01:00.1: msix capability found
> [    6.582388] bnx2x 0031:01:00.1: enabling device (0140 -> 0142)
> [    6.589362] bnx2x 0031:01:00.1: Using 64-bit DMA iommu bypass
> [    6.594890] bnx2x 0031:01:00.1: part number 394D4342-34383735-30345430-473030
> [    6.654106] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 4k
> [    6.667832] bnx2x 0031:01:00.1: 63.008 Gb/s available PCIe bandwidth (8 GT/s x8 link)
> [    6.667997] bnx2x 0031:01:00.2: msix capability found
> [    6.668059] bnx2x 0031:01:00.2: enabling device (0140 -> 0142)
> [    6.668186] bnx2x 0031:01:00.2: Using 64-bit DMA iommu bypass
> [    6.668284] bnx2x 0031:01:00.2: part number 394D4342-34383735-30345430-473030
> [    6.686274] mpt3sas_cm0: Allocated physical memory: size(6324 kB)
> [    6.686325] mpt3sas_cm0: Current Controller Queue Depth(2936),Max Controller Queue Depth(3072)
> [    6.686408] mpt3sas_cm0: Scatter Gather Elements per IO(128)
> [    6.714317] ixgbe 0033:01:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
> [    6.714702] ixgbe 0033:01:00.0: 32.000 Gb/s available PCIe bandwidth, limited by 5 GT/s x8 link at 0033:00:00.0 (capable of 63.008 Gb/s with 8 GT/s x8 link)
> [    6.714891] ixgbe 0033:01:00.0: MAC: 2, PHY: 15, SFP+: 7, PBA No: 0210FF-0FF
> [    6.714949] ixgbe 0033:01:00.0: 0c:c4:7a:87:0d:6a
> [    6.717983] ixgbe 0033:01:00.0: Intel(R) 10 Gigabit Network Connection
> [    6.718193] ixgbe 0033:01:00.1: enabling device (0140 -> 0142)
> [    6.718261] ixgbe 0033:01:00.1: Using 64-bit DMA iommu bypass
> [    6.747341] bnx2x 0031:01:00.2: 63.008 Gb/s available PCIe bandwidth (8 GT/s x8 link)
> [    6.747509] bnx2x 0031:01:00.3: msix capability found
> [    6.747558] bnx2x 0031:01:00.3: enabling device (0140 -> 0142)
> [    6.747661] bnx2x 0031:01:00.3: Using 64-bit DMA iommu bypass
> [    6.747744] bnx2x 0031:01:00.3: part number 394D4342-34383735-30345430-473030
> [    6.781582] i40e 0002:01:00.1: MAC address: 0c:c4:7a:f2:d5:b7
> [    6.790039] i40e 0002:01:00.1: PCI-Express: Speed 8.0GT/s Width x8
> [    6.790594] i40e 0002:01:00.1: Features: PF-id[1] VSIs: 34 QP: 119 RSS FD_ATR FD_SB NTUPLE VxLAN Geneve PTP VEPA
> [    6.791297] i40e 0002:01:00.2: enabling device (0140 -> 0142)
> [    6.791339] i40e 0002:01:00.2: Using 64-bit DMA iommu bypass
> [    6.804672] i40e 0002:01:00.2: fw 5.1.40981 api 1.5 nvm 5.05 0x800029e1 1.1313.0
> [    6.818439] bnx2x 0031:01:00.3: 63.008 Gb/s available PCIe bandwidth (8 GT/s x8 link)
> [    6.819731] bnx2x 0031:01:00.2 enP49p1s0f2: renamed from eth4
> [    6.883258] ixgbe 0033:01:00.1: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
> [    6.883660] ixgbe 0033:01:00.1: 32.000 Gb/s available PCIe bandwidth, limited by 5 GT/s x8 link at 0033:00:00.0 (capable of 63.008 Gb/s with 8 GT/s x8 link)
> [    6.883849] ixgbe 0033:01:00.1: MAC: 2, PHY: 15, SFP+: 8, PBA No: 0210FF-0FF
> [    6.883906] ixgbe 0033:01:00.1: 0c:c4:7a:87:0d:6b
> [    6.934407] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [    6.948061] mpt3sas_cm0: LSISAS3008: FWVersion(15.00.03.00), ChipRevision(0x02), BiosVersion(08.25.00.00)
> [    6.948133] mpt3sas_cm0: Protocol=(
> [    6.948135] Initiator
> [    6.948165] ), 
> [    6.948186] Capabilities=(
> [    6.948206] Raid
> [    6.948227] ,TLR
> [    6.948248] ,EEDP
> [    6.948269] ,Snapshot Buffer
> [    6.948290] ,Diag Trace Buffer
> [    6.948320] ,Task Set Full
> [    6.948350] ,NCQ
> [    6.948370] )
> [    6.949068] scsi host0: Fusion MPT SAS Host
> [    6.949434] mpt3sas_cm0: sending port enable !!
> [    7.045381] i40e 0002:01:00.2: MAC address: 0c:c4:7a:f2:d5:b8
> [    7.076822] bnx2x 0031:01:00.1 enP49p1s0f1: renamed from eth2
> [    7.160608] ixgbe 0033:01:00.1: Intel(R) 10 Gigabit Network Connection
> [    7.160634] bnx2x 0031:01:00.3 enP49p1s0f3: renamed from eth6
> [    7.162885] i40e 0002:01:00.2 eth4: NIC Link is Up, 1000 Mbps Full Duplex, Flow Control: None
> [    7.164716] i40e 0002:01:00.2: PCI-Express: Speed 8.0GT/s Width x8
> [    7.165282] i40e 0002:01:00.2: Features: PF-id[2] VSIs: 34 QP: 119 RSS FD_ATR FD_SB NTUPLE VxLAN Geneve PTP VEPA
> [    7.165425] i40e 0002:01:00.3: enabling device (0140 -> 0142)
> [    7.165480] i40e 0002:01:00.3: Using 64-bit DMA iommu bypass
> [    7.179037] i40e 0002:01:00.3: fw 5.1.40981 api 1.5 nvm 5.05 0x800029e1 1.1313.0
> [    7.421957] i40e 0002:01:00.3: MAC address: 0c:c4:7a:f2:d5:b9
> [    7.539606] ixgbe 0033:01:00.1 enP51p1s0f1: renamed from eth2
> [    7.543966] i40e 0002:01:00.3: PCI-Express: Speed 8.0GT/s Width x8
> [    7.544533] i40e 0002:01:00.3: Features: PF-id[3] VSIs: 34 QP: 119 RSS FD_ATR FD_SB NTUPLE VxLAN Geneve PTP VEPA
> [    7.676583] bnx2x 0031:01:00.0 enP49p1s0f0: renamed from eth1
> [    7.746597] ixgbe 0033:01:00.0 enP51p1s0f0: renamed from eth3
> [    7.836758] i40e 0002:01:00.3 enP2p1s0f3: renamed from eth6
> [    7.907249] i40e 0002:01:00.1 enP2p1s0f1: renamed from eth5
> [    7.987051] i40e 0002:01:00.2 enP2p1s0f2: renamed from eth4
> [    8.056615] i40e 0002:01:00.0 enP2p1s0f0: renamed from eth0
> [    8.813855] mpt3sas_cm0: host_add: handle(0x0001), sas_addr(0x500304801bdb3a01), phys(8)
> [    9.312205] mpt3sas_cm0: expander_add: handle(0x0009), parent(0x0001), sas_addr(0x500304801f1006bf), phys(31)
> [   14.047021] mpt3sas_cm0: port enable: SUCCESS
> [   14.049371] scsi 0:1:0:0: Direct-Access     LSI      Logical Volume   3000 PQ: 0 ANSI: 6
> [   14.054263] scsi 0:1:0:0: RAID1E: handle(0x0143), wwid(0x0340f942695ee6fc), pd_count(3), type(SSP)
> [   14.054353] scsi 0:1:0:0: Set queue's max_sector to: 8192
> [   14.058431] sd 0:1:0:0: Attached scsi generic sg0 type 0
> [   14.063374] sd 0:1:0:0: [sda] 20480000 512-byte logical blocks: (10.5 GB/9.77 GiB)
> [   14.063439] sd 0:1:0:0: [sda] 4096-byte physical blocks
> [   14.064573] sd 0:1:0:0: [sda] Write Protect is off
> [   14.064633] sd 0:1:0:0: [sda] Mode Sense: 67 00 00 08
> [   14.066804] sd 0:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [   14.094960]  sda: sda1
> [   14.095053] scsi 0:0:0:0: Direct-Access     SEAGATE  ST2000NM0045     N003 PQ: 0 ANSI: 6
> [   14.096360] scsi 0:0:0:0: SSP: handle(0x000a), sas_addr(0x5000c50086a57ee5), phy(0), device_name(0x5000c50086a57ee4)
> [   14.096458] scsi 0:0:0:0: enclosure logical id (0x500304801f1006bf), slot(0) 
> [   14.096521] scsi 0:0:0:0: enclosure level(0x0000), connector name(     )
> [   14.097284] sd 0:1:0:0: [sda] Attached SCSI disk
> [   14.101326] scsi 0:0:0:0: Attached scsi generic sg1 type 0
> [   14.114064] scsi 0:0:1:0: Direct-Access     SEAGATE  ST2000NM0135     E002 PQ: 0 ANSI: 6
> [   14.114768] scsi 0:0:1:0: SSP: handle(0x000b), sas_addr(0x5000c50093a254fd), phy(1), device_name(0x5000c50093a254fc)
> [   14.114863] scsi 0:0:1:0: enclosure logical id (0x500304801f1006bf), slot(1) 
> [   14.114925] scsi 0:0:1:0: enclosure level(0x0000), connector name(     )
> [   14.120976] scsi 0:0:1:0: Attached scsi generic sg2 type 0
> [   14.134248] scsi 0:0:2:0: Direct-Access     SEAGATE  ST2000NM0135     E002 PQ: 0 ANSI: 6
> [   14.134952] scsi 0:0:2:0: SSP: handle(0x000c), sas_addr(0x5000c50085d5ceb5), phy(2), device_name(0x5000c50085d5ceb4)
> [   14.135047] scsi 0:0:2:0: enclosure logical id (0x500304801f1006bf), slot(2) 
> [   14.135106] scsi 0:0:2:0: enclosure level(0x0000), connector name(     )
> [   14.141689] scsi 0:0:2:0: Attached scsi generic sg3 type 0
> [   14.148503] scsi 0:0:3:0: Direct-Access     ATA      ST2000NM0125-1YZ SN02 PQ: 0 ANSI: 6
> [   14.148569] scsi 0:0:3:0: SATA: handle(0x000d), sas_addr(0x500304801f100683), phy(3), device_name(0x5000c50092b8dbb7)
> [   14.148648] scsi 0:0:3:0: enclosure logical id (0x500304801f1006bf), slot(3) 
> [   14.148707] scsi 0:0:3:0: enclosure level(0x0000), connector name(     )
> [   14.149309] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   14.155164] sd 0:0:3:0: Attached scsi generic sg4 type 0
> [   14.164875] sd 0:0:3:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
> [   14.164953] sd 0:0:3:0: [sdb] 4096-byte physical blocks
> [   14.168178] scsi 0:0:4:0: Direct-Access     SEAGATE  ST4000NM0075     KT02 PQ: 0 ANSI: 6
> [   14.168258] scsi 0:0:4:0: SSP: handle(0x000e), sas_addr(0x5000c500863b9e25), phy(8), device_name(0x5000c500863b9e24)
> [   14.168335] scsi 0:0:4:0: enclosure logical id (0x500304801f1006bf), slot(8) 
> [   14.168393] scsi 0:0:4:0: enclosure level(0x0000), connector name(     )
> [   14.174737] sd 0:0:4:0: Attached scsi generic sg5 type 0
> [   14.181347] scsi 0:0:5:0: Enclosure         LSI      SAS3x28          0601 PQ: 0 ANSI: 5
> [   14.181428] scsi 0:0:5:0: set ignore_delay_remove for handle(0x000f)
> [   14.181481] scsi 0:0:5:0: SES: handle(0x000f), sas_addr(0x500304801f1006bd), phy(28), device_name(0x500304801f1006bd)
> [   14.181558] scsi 0:0:5:0: enclosure logical id (0x500304801f1006bf), slot(12) 
> [   14.181618] scsi 0:0:5:0: enclosure level(0x0000), connector name(     )
> [   14.183325] sd 0:0:4:0: [sdc] 976754646 4096-byte logical blocks: (4.00 TB/3.64 TiB)
> [   14.184665] scsi 0:0:5:0: Attached scsi generic sg6 type 13
> [   14.185122] sd 0:0:4:0: [sdc] Write Protect is off
> [   14.185166] sd 0:0:4:0: [sdc] Mode Sense: db 00 10 08
> [   14.188399] sd 0:0:4:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
> [   14.213574] sd 0:0:4:0: [sdc] Attached SCSI disk
> [   14.413688] sd 0:0:3:0: [sdb] Write Protect is off
> [   14.413734] sd 0:0:3:0: [sdb] Mode Sense: 9b 00 10 08
> [   14.417045] sd 0:0:3:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   14.454663] random: crng init done
> [   14.454813]  sdb: sdb1 sdb2 sdb3
> [   14.485918] sd 0:0:3:0: [sdb] Attached SCSI disk
> [   15.494282] setfont (2758) used greatest stack depth: 10864 bytes left
> [   15.796480] raid6: altivecx1 gen()  7680 MB/s
> [   15.966480] raid6: altivecx2 gen() 12356 MB/s
> [   16.136483] raid6: altivecx4 gen() 15549 MB/s
> [   16.306484] raid6: altivecx8 gen() 13776 MB/s
> [   16.476484] raid6: vpermxor1 gen()  7682 MB/s
> [   16.646483] raid6: vpermxor2 gen() 12353 MB/s
> [   16.816479] raid6: vpermxor4 gen() 15535 MB/s
> [   16.986479] raid6: vpermxor8 gen() 17241 MB/s
> [   17.156480] raid6: int64x1  gen()  5098 MB/s
> [   17.326497] raid6: int64x1  xor()  1581 MB/s
> [   17.496485] raid6: int64x2  gen()  8888 MB/s
> [   17.666485] raid6: int64x2  xor()  3232 MB/s
> [   17.836479] raid6: int64x4  gen() 10741 MB/s
> [   18.006483] raid6: int64x4  xor()  4083 MB/s
> [   18.176488] raid6: int64x8  gen()  6282 MB/s
> [   18.346481] raid6: int64x8  xor()  2571 MB/s
> [   18.346526] raid6: using algorithm vpermxor8 gen() 17241 MB/s
> [   18.346563] raid6: using intx1 recovery algorithm
> [   18.348327] xor: measuring software checksum speed
> [   18.446478]    8regs     : 17683.200 MB/sec
> [   18.546477]    8regs_prefetch: 15008.000 MB/sec
> [   18.646481]    32regs    : 18534.400 MB/sec
> [   18.746477]    32regs_prefetch: 16371.200 MB/sec
> [   18.846482]    altivec   : 21139.200 MB/sec
> [   18.846513] xor: using function: altivec (21139.200 MB/sec)
> [   19.350206] Btrfs loaded, crc32c=crc32c-generic
> [   19.424799] BTRFS: device fsid 4eba18bc-a2a1-4032-8b44-521c87720061 devid 1 transid 14 /dev/sda1
> [   19.425013] btrfs (2849) used greatest stack depth: 9952 bytes left
> [   19.491388] EXT4-fs (nvme1n1p2): mounted filesystem with ordered data mode. Opts: (null)
> [   19.632803] systemd[1]: Configuration file /etc/systemd/system.conf.d/htxsystemdcustom.conf is marked executable. Please remove executable permission bits. Proceeding anyway.
> [   19.633556] systemd[1]: systemd 237 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
> [   19.644997] systemd[1]: Detected architecture ppc64-le.
> [   19.646311] systemd[1]: Set hostname to <ltc-boston21>.
> [   19.679595] systemd[1]: File /lib/systemd/system/systemd-journald.service:36 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
> [   19.679705] systemd[1]: Proceeding WITHOUT firewalling in effect! (This warning is only shown for the first loaded unit using IP firewalling.)
> [   19.725501] systemd[1]: Created slice System Slice.
> [   19.725830] systemd[1]: Listening on udev Kernel Socket.
> [   19.726085] systemd[1]: Listening on Journal Socket (/dev/log).
> [   19.726364] systemd[1]: Listening on Device-mapper event daemon FIFOs.
> [   19.726902] systemd[1]: Created slice User and Session Slice.
> [   19.734241] ufw-init (2924) used greatest stack depth: 9792 bytes left
> [   19.751794] Loading iSCSI transport class v2.0-870.
> [   19.755053] EXT4-fs (nvme1n1p2): re-mounted. Opts: errors=remount-ro
> [   19.927200] Adding 2097088k swap on /swapfile.  Priority:-2 extents:6 across:2260928k SS
> [   19.929834] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   19.987644] iscsi: registered transport (iser)
> [   20.016987] systemd-journald[2933]: Received request to flush runtime journal from PID 1
> [   20.018749] systemd-journald[2933]: File /var/log/journal/03421d269c0e44b28ec9bd3f7152d10b/system.journal corrupted or uncleanly shut down, renaming and replacing.
> [   20.021582] synth uevent: /devices/vio: failed to send uevent
> [   20.021586] vio vio: uevent: failed to send synthetic uevent
> [   20.107304] crypto_register_alg 'aes' = 0
> [   20.107558] crypto_register_alg 'cbc(aes)' = 0
> [   20.107833] crypto_register_alg 'ctr(aes)' = 0
> [   20.108078] crypto_register_alg 'xts(aes)' = 0
> [   20.525406] EXT4-fs (sda1): VFS: Can't find ext4 filesystem
> [   20.594897] Unable to handle kernel paging request for data at address 0x000000d0
> [   20.594976] Faulting instruction address: 0xc000000000304fe0
> [   20.595031] Oops: Kernel access of bad area, sig: 11 [#1]
> [   20.595073] LE SMP NR_CPUS=2048 NUMA PowerNV
> [   20.595119] Modules linked in: dm_snapshot dm_bufio bridge vmx_crypto stp llc ib_iser rdma_cm iw_cm ib_cm nfsd ib_core libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash lzo_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq multipath ixgbe i40e bnx2x mpt3sas nvme raid_class nvme_core scsi_transport_sas mdio libcrc32c
> [   20.595452] CPU: 92 PID: 5368 Comm: lvm Not tainted 4.17.0-rc7-next-20180601-autotest #3
> [   20.595514] NIP:  c000000000304fe0 LR: c0000000002641b4 CTR: c000000000264190
> [   20.595577] REGS: c000200e49587370 TRAP: 0300   Not tainted  (4.17.0-rc7-next-20180601-autotest)
> [   20.595648] MSR:  900000000280b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24022424  XER: 20040000
> [   20.595734] CFAR: c000000000304df4 DAR: 00000000000000d0 DSISR: 40000000 SOFTE: 0 
>                GPR00: c0000000002642b0 c000200e495875f0 c000000001109100 c000000ff901b000 
>                GPR04: 0000000000000000 c000200e4f960300 0000000000000000 0000200e60560000 
>                GPR08: 0000000000000000 0000000000000000 c00a000000000008 c0080000083f3950 
>                GPR12: c000000000264190 c000200fff6c8b00 00007fff96bd2910 00007fff96baf658 
>                GPR16: 00000001289a9960 00000001289774d0 00007fff96bafb88 00007fff96ba5f20 
>                GPR20: c000200e525c08c0 c000200e32350000 c000200e325c1000 0000000000000001 
>                GPR24: 0000000000000001 fffffffffffff000 c000200e43451800 c000200e52710820 
>                GPR28: c0000000002641b4 0000000000000000 5deadbeef0000200 c000000ff901b000 
> [   20.597990] NIP [c000000000304fe0] kmem_cache_free+0x210/0x2a0
> [   20.603563] LR [c0000000002641b4] mempool_free_slab+0x24/0x40
> [   20.609091] Call Trace:
> [   20.609096] [c000200e495875f0] [c000200e49587680] 0xc000200e49587680 (unreliable)
> [   20.609099] [c000200e49587680] [c000200e49031cf0] 0xc000200e49031cf0
> [   20.609107] [c000200e495876a0] [c0000000002642b0] mempool_exit+0x50/0x90
> [   20.632672] [c000200e495876d0] [c0000000005360d0] bioset_exit+0x40/0x1d0
> [   20.638210] [c000200e49587750] [c00000000087c84c] dm_io_client_destroy+0x2c/0x50
> [   20.646524] [c000200e49587780] [c0080000083f2f44] dm_bufio_client_destroy+0x1fc/0x2d0 [dm_bufio]
> [   20.654849] [c000200e49587810] [c0080000089667d8] persistent_read_metadata+0x430/0x660 [dm_snapshot]
> [   20.664547] [c000200e495878d0] [c0080000089643a0] snapshot_ctr+0x5c8/0x7a0 [dm_snapshot]
> [   20.671487] [c000200e495879b0] [c000000000874b0c] dm_table_add_target+0x19c/0x3c0
> [   20.679799] [c000200e49587a60] [c00000000087a344] table_load+0x104/0x450
> [   20.686726] [c000200e49587b10] [c00000000087b1b8] ctl_ioctl+0x1f8/0x570
> [   20.692286] [c000200e49587d00] [c00000000087b548] dm_ctl_ioctl+0x18/0x30
> [   20.699215] [c000200e49587d20] [c000000000354e2c] do_vfs_ioctl+0xcc/0x9e0
> [   20.706144] [c000200e49587dc0] [c00000000035579c] ksys_ioctl+0x5c/0xe0
> [   20.713080] [c000200e49587e10] [c000000000355840] sys_ioctl+0x20/0x80
> [   20.718637] [c000200e49587e30] [c00000000000b9e0] system_call+0x58/0x6c
> [   20.725560] Instruction dump:
> [   20.728341] 3d02000a 39089150 7ba98502 792a3664 e9280000 7d295214 e9490008 71480001 
> [   20.736652] 40820090 e9290018 7fbf4840 419efe28 <e94900d0> 7fbf5000 419e0068 7c0802a6 
> [   20.744976] ---[ end trace 076e4b6d277fc734 ]---
>
> [   22.347952] bnx2x 0031:01:00.3 enP49p1s0f3: using MSI-X  IRQs: sp 524  fp[0] 526 ... fp[7] 533
> [   22.566968] bnx2x 0031:01:00.3 enP49p1s0f3: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit
> [   22.767776] bnx2x 0031:01:00.1 enP49p1s0f1: using MSI-X  IRQs: sp 310  fp[0] 312 ... fp[7] 319
> [   23.508053] bnx2x 0031:01:00.0 enP49p1s0f0: using MSI-X  IRQs: sp 300  fp[0] 302 ... fp[7] 309
> [   33.797102] NFSD: starting 90-second grace period (net f000001f)
