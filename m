From: Andrew Randrianasulu <randrianasulu@gmail.com>
Subject: Re: Fwd: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git 4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 14:31:35 +0300
Message-ID: <201806141431.36085.randrianasulu@gmail.com>
References: <201806130602.59441.randrianasulu@gmail.com> <201806140133.52354.randrianasulu@gmail.com> <20180614083417.GB18536@lst.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YIlIb1/2xAYIosJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180614083417.GB18536@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_YIlIb1/2xAYIosJ
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=C2 =F1=EE=EE=E1=F9=E5=ED=E8=E8 =EE=F2 Thursday 14 June 2018 11:34:17 hch@l=
st.de =ED=E0=EF=E8=F1=E0=EB(=E0):
> Andrew, can you test the patch below, please?

Patch seems to work as well as previous one - I can boot with no warnings a=
nd=20
suspend/resume.

 Linux version 4.17.0-x64-11928-g2837461dbe6f-dirty

(sorry for some "AMD-Vi: Event logged" spam - it just sound acting strange=
=20
sometimes, I filled additional bug about it in kernel bugzilla)

>
> ---
> From ccf385c63e30e8633b771604bed0e09c895e9175 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 14 Jun 2018 10:25:36 +0200
> Subject: blk-mq: don't time out requests again that are in the timeout
> handler
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c         | 5 +++++
>  include/linux/blkdev.h | 2 ++
>  2 files changed, 7 insertions(+)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e9da5e6a8526..54332db09e5d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -671,6 +671,7 @@ static void __blk_mq_requeue_request(struct request
> *rq)
>
>  	if (blk_mq_request_started(rq)) {
>  		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
> +		rq->rq_flags &=3D ~RQF_TIMED_OUT;
>  		if (q->dma_drain_size && blk_rq_bytes(rq))
>  			rq->nr_phys_segments--;
>  	}
> @@ -770,6 +771,7 @@ EXPORT_SYMBOL(blk_mq_tag_to_rq);
>
>  static void blk_mq_rq_timed_out(struct request *req, bool reserved)
>  {
> +	req->rq_flags |=3D RQF_TIMED_OUT;
>  	if (req->q->mq_ops->timeout) {
>  		enum blk_eh_timer_return ret;
>
> @@ -779,6 +781,7 @@ static void blk_mq_rq_timed_out(struct request *req,
> bool reserved) WARN_ON_ONCE(ret !=3D BLK_EH_RESET_TIMER);
>  	}
>
> +	req->rq_flags &=3D ~RQF_TIMED_OUT;
>  	blk_add_timer(req);
>  }
>
> @@ -788,6 +791,8 @@ static bool blk_mq_req_expired(struct request *rq,
> unsigned long *next)
>
>  	if (blk_mq_rq_state(rq) !=3D MQ_RQ_IN_FLIGHT)
>  		return false;
> +	if (rq->rq_flags & RQF_TIMED_OUT)
> +		return false;
>
>  	deadline =3D blk_rq_deadline(rq);
>  	if (time_after_eq(jiffies, deadline))
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index bca3a92eb55f..fa6f11751430 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -127,6 +127,8 @@ typedef __u32 __bitwise req_flags_t;
>  #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
>  /* already slept for hybrid poll */
>  #define RQF_MQ_POLL_SLEPT	((__force req_flags_t)(1 << 20))
> +/* ->timeout has been called, don't expire again */
> +#define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
>
>  /* flags that prevent us from merging requests: */
>  #define RQF_NOMERGE_FLAGS \



--Boundary-00=_YIlIb1/2xAYIosJ
Content-Type: text/x-log;
  charset="iso 8859-1";
  name="dmesg_4_17_git.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_4_17_git.log"

[    0.000000] Linux version 4.17.0-x64-11928-g2837461dbe6f-dirty (guest@slax) (gcc version 4.9.2 (GCC)) #18 SMP Thu Jun 14 13:37:11 MSK 2018
[    0.000000] Command line: BOOT_IMAGE=Lin-4.18-x64 ro root=802 nocd vt.default_utf8=0 scsi_mod.use_blk_mq=1 nouveau.debug=pci=debug log_buf_len=1M
[    0.000000] random: get_random_u32 called from bsp_init_amd+0xd0/0x1af with crng_init=0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cd9a8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd9a9000-0x00000000cdb33fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cdb34000-0x00000000cde7cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cde7d000-0x00000000cea42fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cea43000-0x00000000cea43fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cea44000-0x00000000cec49fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cec4a000-0x00000000cf06dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf06e000-0x00000000cf7eefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf7ef000-0x00000000cf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000032effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: MSI MS-7693/970A-G46 (MS-7693), BIOS V2.8 01/08/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] last_pfn = 0x32f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CCFFF write-protect
[    0.000000]   CD000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 0000CF800000 mask FFFFFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000032f000000 aka 13040M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: update [mem 0xcf800000-0xffffffff] usable ==> reserved
[    0.000000] last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd830-0x000fd83f] mapped at [(____ptrval____)]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [(____ptrval____)] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x02269000, 0x02269fff] PGTABLE
[    0.000000] BRK [0x0226a000, 0x0226afff] PGTABLE
[    0.000000] BRK [0x0226b000, 0x0226bfff] PGTABLE
[    0.000000] BRK [0x0226c000, 0x0226cfff] PGTABLE
[    0.000000] BRK [0x0226d000, 0x0226dfff] PGTABLE
[    0.000000] BRK [0x0226e000, 0x0226efff] PGTABLE
[    0.000000] log_buf_len: 1048576 bytes
[    0.000000] early log buf free: 126604(96%)
[    0.000000] RAMDISK: [mem 0x7fd8e000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CDE6D070 00005C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CDE73528 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has valid Length but zero Address: 0x0000000000000000/0x1 (20180531/tbfadt-624)
[    0.000000] ACPI: DSDT 0x00000000CDE6D160 0063C2 (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CDE76080 000040
[    0.000000] ACPI: APIC 0x00000000CDE73638 00007E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CDE736B8 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000CDE73700 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 0x00000000CDE73740 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: SSDT 0x00000000CDE73778 000B9C (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: IVRS 0x00000000CDE74318 0000C0 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000032effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000cd9a8fff]
[    0.000000]   node   0: [mem 0x00000000cea43000-0x00000000cea43fff]
[    0.000000]   node   0: [mem 0x00000000cec4a000-0x00000000cf06dfff]
[    0.000000]   node   0: [mem 0x00000000cf7ef000-0x00000000cf7fffff]
[    0.000000]   node   0: [mem 0x0000000100001000-0x000000032effffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000032effffff]
[    0.000000] On node 0 totalpages: 3132795
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13112 pages used for memmap
[    0.000000]   DMA32 zone: 839135 pages, LIFO batch:31
[    0.000000]   Normal zone: 35776 pages used for memmap
[    0.000000]   Normal zone: 2289663 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 99 pages
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 5, version 33, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 6, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd9a9000-0xcdb33fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcdb34000-0xcde7cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcde7d000-0xcea42fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcea44000-0xcec49fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf06e000-0xcf7eefff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf800000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfec1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec20000-0xfec20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec21000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed60fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed61000-0xfed70fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed71000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x100000000-0x100000fff]
[    0.000000] [mem 0xcf800000-0xfebfffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 43 pages/cpu @(____ptrval____) s135384 r8192 d32552 u524288
[    0.000000] pcpu-alloc: s135384 r8192 d32552 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 3083822
[    0.000000] Kernel command line: BOOT_IMAGE=Lin-4.18-x64 ro root=802 nocd vt.default_utf8=0 scsi_mod.use_blk_mq=1 nouveau.debug=pci=debug log_buf_len=1M
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0x00000000-0x01ffffff] (32MB)
[    0.000000] AGP: Your BIOS doesn't leave an aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0xc4000000-0xc7ffffff] (65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0xc4000000-0xc7ffffff]
[    0.000000] Memory: 12155252K/12531180K available (8204K kernel code, 980K rwdata, 2564K rodata, 1248K init, 388K bss, 375928K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 27784 entries in 109 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 4352, nr_irqs: 1000, preallocated irqs: 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180531
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.004000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.024000] tsc: Fast TSC calibration using PIT
[    0.028000] tsc: Detected 3800.072 MHz processor
[    0.028000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x6d8d37a9e57, max_idle_ns: 881590865103 ns
[    0.028000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7600.14 BogoMIPS (lpj=15200288)
[    0.028000] pid_max: default: 32768 minimum: 301
[    0.028000] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.028000] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.028000] CPU: Physical Processor ID: 0
[    0.028000] CPU: Processor Core ID: 0
[    0.028000] mce: CPU supports 7 MCE banks
[    0.028000] LVT offset 1 assigned for vector 0xf9
[    0.028000] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.028000] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.028000] Spectre V2 : Vulnerable: Minimal AMD ASM retpoline
[    0.028000] Spectre V2 : Spectre v2 mitigation: Filling RSB on context switch
[    0.028000] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
[    0.028000] Freeing SMP alternatives memory: 16K
[    0.036000] smpboot: CPU0: AMD FX(tm)-4300 Quad-Core Processor (family: 0x15, model: 0x2, stepping: 0x0)
[    0.036040] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.036098] ... version:                0
[    0.036150] ... bit width:              48
[    0.036201] ... generic registers:      6
[    0.036253] ... value mask:             0000ffffffffffff
[    0.036307] ... max period:             00007fffffffffff
[    0.036360] ... fixed-purpose events:   0
[    0.036412] ... event mask:             000000000000003f
[    0.036496] Hierarchical SRCU implementation.
[    0.036691] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.036760] smp: Bringing up secondary CPUs ...
[    0.036913] x86: Booting SMP configuration:
[    0.036966] .... node  #0, CPUs:      #1 #2 #3
[    0.044025] smp: Brought up 1 node, 4 CPUs
[    0.044109] smpboot: Max logical packages: 1
[    0.044161] smpboot: Total of 4 processors activated (30400.57 BogoMIPS)
[    0.048241] devtmpfs: initialized
[    0.048241] PM: Registering ACPI NVS region [mem 0xcdb34000-0xcde7cfff] (3444736 bytes)
[    0.048241] PM: Registering ACPI NVS region [mem 0xcea44000-0xcec49fff] (2121728 bytes)
[    0.048313] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.048387] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.048487] pinctrl core: initialized pinctrl subsystem
[    0.048708] NET: Registered protocol family 16
[    0.048852] audit: initializing netlink subsys (disabled)
[    0.048910] audit: type=2000 audit(1528986408.048:1): state=initialized audit_enabled=0 res=1
[    0.048910] cpuidle: using governor ladder
[    0.048910] cpuidle: using governor menu
[    0.048910] ACPI: bus type PCI registered
[    0.048910] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.048910] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.048910] PCI: not using MMCONFIG
[    0.048910] PCI: Using configuration type 1 for base access
[    0.048910] PCI: Using configuration type 1 for extended access
[    0.048910] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.048910] ACPI: Added _OSI(Module Device)
[    0.048910] ACPI: Added _OSI(Processor Device)
[    0.048910] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.048910] ACPI: Added _OSI(Processor Aggregator Device)
[    0.048910] ACPI: Added _OSI(Linux-Dell-Video)
[    0.054649] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.056091] ACPI: Interpreter enabled
[    0.056157] ACPI: (supports S0 S3 S4 S5)
[    0.056209] ACPI: Using IOAPIC for interrupt routing
[    0.056378] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.056505] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.056584] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.056800] ACPI: Enabled 11 GPEs in block 00 to 1F
[    0.062247] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.062306] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.062379] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.062652] PCI host bridge to bus 0000:00
[    0.062705] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.062762] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.062818] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.062875] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.062931] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.063000] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.063068] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff window]
[    0.063137] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.063198] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.063303] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    0.063398] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.063414] pci 0000:00:02.0: enabling Extended Tags
[    0.063487] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.063565] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.063580] pci 0000:00:04.0: enabling Extended Tags
[    0.063651] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.063744] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.063759] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    0.063766] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    0.063773] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    0.063779] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    0.063786] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    0.063792] pci 0000:00:11.0: reg 0x24: [mem 0xfd30b000-0xfd30b3ff]
[    0.063890] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.063902] pci 0000:00:12.0: reg 0x10: [mem 0xfd30a000-0xfd30afff]
[    0.064017] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.064032] pci 0000:00:12.2: reg 0x10: [mem 0xfd309000-0xfd3090ff]
[    0.064090] pci 0000:00:12.2: supports D1 D2
[    0.064091] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.064168] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.064180] pci 0000:00:13.0: reg 0x10: [mem 0xfd308000-0xfd308fff]
[    0.064291] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.064306] pci 0000:00:13.2: reg 0x10: [mem 0xfd307000-0xfd3070ff]
[    0.064363] pci 0000:00:13.2: supports D1 D2
[    0.064364] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.064440] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.064557] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.064574] pci 0000:00:14.2: reg 0x10: [mem 0xfd300000-0xfd303fff 64bit]
[    0.064622] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.064696] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.064811] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.064909] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.064950] pci 0000:00:14.5: reg 0x10: [mem 0xfd306000-0xfd306fff]
[    0.065063] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.065091] pci 0000:00:15.0: enabling Extended Tags
[    0.065174] pci 0000:00:15.0: supports D1 D2
[    0.065260] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.065273] pci 0000:00:16.0: reg 0x10: [mem 0xfd305000-0xfd305fff]
[    0.065383] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.065398] pci 0000:00:16.2: reg 0x10: [mem 0xfd304000-0xfd3040ff]
[    0.065455] pci 0000:00:16.2: supports D1 D2
[    0.065456] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.065531] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    0.065601] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    0.065667] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    0.065733] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    0.065802] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    0.065867] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    0.065968] pci 0000:01:00.0: [10de:0606] type 00 class 0x030000
[    0.065980] pci 0000:01:00.0: reg 0x10: [mem 0xfc000000-0xfcffffff]
[    0.065987] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.065994] pci 0000:01:00.0: reg 0x1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.065998] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.066003] pci 0000:01:00.0: reg 0x30: [mem 0xfd000000-0xfd01ffff pref]
[    0.066007] pci 0000:01:00.0: enabling Extended Tags
[    0.066133] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.066217] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.066218] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.066221] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.066256] pci 0000:02:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.066279] pci 0000:02:00.0: reg 0x10: [mem 0xfd200000-0xfd207fff 64bit]
[    0.066367] pci 0000:02:00.0: PME# supported from D3hot
[    0.066430] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.066486] pci 0000:00:04.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    0.066496] pci_bus 0000:03: extended config space not accessible
[    0.066599] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.066660] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    0.066662] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    0.066663] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df window] (subtractive decode)
[    0.066665] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.066666] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.066667] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff window] (subtractive decode)
[    0.066668] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xffffffff window] (subtractive decode)
[    0.066714] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.066740] pci 0000:04:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.066764] pci 0000:04:00.0: reg 0x18: [mem 0xfd104000-0xfd104fff 64bit pref]
[    0.066780] pci 0000:04:00.0: reg 0x20: [mem 0xfd100000-0xfd103fff 64bit pref]
[    0.066862] pci 0000:04:00.0: supports D1 D2
[    0.066863] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.066958] pci 0000:00:15.0: PCI bridge to [bus 04]
[    0.067015] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.067017] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    0.067034] pci_bus 0000:00: on NUMA node 0
[    0.067358] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.067496] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.067608] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.067718] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 10 11 14 15) *0
[    0.067818] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.067908] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.067998] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.068092] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.068278] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    0.068278] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.068278] pci 0000:01:00.0: vgaarb: bridge control possible
[    0.068278] vgaarb: loaded
[    0.068278] pps_core: LinuxPPS API ver. 1 registered
[    0.068360] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.068433] PTP clock support registered
[    0.068486] EDAC MC: Ver: 3.0.0
[    0.068598] PCI: Using ACPI for IRQ routing
[    0.073390] PCI: pci_cache_line_size set to 64 bytes
[    0.073432] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.073433] e820: reserve RAM buffer [mem 0xcd9a9000-0xcfffffff]
[    0.073434] e820: reserve RAM buffer [mem 0xcea44000-0xcfffffff]
[    0.073435] e820: reserve RAM buffer [mem 0xcf06e000-0xcfffffff]
[    0.073436] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    0.073437] e820: reserve RAM buffer [mem 0x32f000000-0x32fffffff]
[    0.073565] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.073620] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.076002] clocksource: Switched to clocksource tsc-early
[    0.086873] VFS: Disk quotas dquot_6.6.0
[    0.086940] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.087032] pnp: PnP ACPI init
[    0.087203] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.087262] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.087474] system 00:01: [io  0x040b] has been reserved
[    0.087529] system 00:01: [io  0x04d6] has been reserved
[    0.087584] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.087639] system 00:01: [io  0x0c14] has been reserved
[    0.087720] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.087775] system 00:01: [io  0x0c52] has been reserved
[    0.087829] system 00:01: [io  0x0c6c] has been reserved
[    0.087884] system 00:01: [io  0x0c6f] has been reserved
[    0.087938] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.087993] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.088048] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.088103] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.088158] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.088214] system 00:01: [io  0x0800-0x089f] has been reserved
[    0.088269] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.088327] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.088382] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.088437] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.088493] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.088550] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.088607] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.088663] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.088720] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.088776] system 00:01: [mem 0xfed00000-0xfed00fff] could not be reserved
[    0.088833] system 00:01: [mem 0xff800000-0xffffffff] has been reserved
[    0.088920] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089029] system 00:02: [io  0x0480-0x0481] has been reserved
[    0.089086] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089252] pnp 00:03: [dma 0 disabled]
[    0.089289] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.089311] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.089359] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.089417] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089453] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089577] system 00:07: [mem 0xfeb20000-0xfeb23fff] could not be reserved
[    0.089636] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089723] system 00:08: [mem 0xfec20000-0xfec200ff] could not be reserved
[    0.089782] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089880] pnp: PnP ACPI: found 9 devices
[    0.095980] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.096068] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.096123] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.096180] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.096266] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.096338] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.096392] pci 0000:00:04.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    0.096451] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.096512] pci 0000:00:15.0: PCI bridge to [bus 04]
[    0.096566] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.096623] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    0.096684] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.096685] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.096686] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.096687] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.096688] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.096689] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.096690] pci_bus 0000:00: resource 10 [mem 0xd0000000-0xffffffff window]
[    0.096691] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.096692] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfd0fffff]
[    0.096693] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.096694] pci_bus 0000:02: resource 1 [mem 0xfd200000-0xfd2fffff]
[    0.096696] pci_bus 0000:03: resource 4 [io  0x0000-0x03af window]
[    0.096697] pci_bus 0000:03: resource 5 [io  0x03e0-0x0cf7 window]
[    0.096698] pci_bus 0000:03: resource 6 [io  0x03b0-0x03df window]
[    0.096699] pci_bus 0000:03: resource 7 [io  0x0d00-0xffff window]
[    0.096699] pci_bus 0000:03: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.096700] pci_bus 0000:03: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.096701] pci_bus 0000:03: resource 10 [mem 0xd0000000-0xffffffff window]
[    0.096703] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.096703] pci_bus 0000:04: resource 1 [mem 0xfd100000-0xfd1fffff]
[    0.096752] NET: Registered protocol family 2
[    0.096916] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
[    0.097029] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.097388] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.097737] TCP: Hash tables configured (established 131072 bind 65536)
[    0.097839] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.097960] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.098108] NET: Registered protocol family 1
[    0.188361] pci 0000:00:12.0: quirk_usb_early_handoff+0x0/0x615 took 88066 usecs
[    0.276348] pci 0000:00:13.0: quirk_usb_early_handoff+0x0/0x615 took 85743 usecs
[    0.364345] pci 0000:00:14.5: quirk_usb_early_handoff+0x0/0x615 took 85747 usecs
[    0.452342] pci 0000:00:16.0: quirk_usb_early_handoff+0x0/0x615 took 85858 usecs
[    0.452536] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.452748] PCI: CLS 64 bytes, default 64
[    0.452781] Trying to unpack rootfs image as initramfs...
[    0.482536] Freeing initrd memory: 2504K
[    0.483013] iommu: Adding device 0000:00:00.0 to group 0
[    0.483136] iommu: Adding device 0000:00:02.0 to group 1
[    0.483250] iommu: Adding device 0000:00:04.0 to group 2
[    0.483370] iommu: Adding device 0000:00:11.0 to group 3
[    0.483491] iommu: Adding device 0000:00:12.0 to group 4
[    0.483557] iommu: Adding device 0000:00:12.2 to group 4
[    0.483687] iommu: Adding device 0000:00:13.0 to group 5
[    0.483753] iommu: Adding device 0000:00:13.2 to group 5
[    0.487755] iommu: Adding device 0000:00:14.0 to group 6
[    0.487879] iommu: Adding device 0000:00:14.2 to group 7
[    0.488009] iommu: Adding device 0000:00:14.3 to group 8
[    0.488134] iommu: Adding device 0000:00:14.4 to group 9
[    0.488256] iommu: Adding device 0000:00:14.5 to group 10
[    0.488392] iommu: Adding device 0000:00:15.0 to group 11
[    0.488515] iommu: Adding device 0000:00:16.0 to group 12
[    0.488582] iommu: Adding device 0000:00:16.2 to group 12
[    0.488699] iommu: Adding device 0000:01:00.0 to group 13
[    0.488812] iommu: Adding device 0000:02:00.0 to group 14
[    0.488877] iommu: Adding device 0000:04:00.0 to group 11
[    0.529425] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    0.529508] AMD-Vi: Interrupt remapping enabled
[    0.529656] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.531337] amd_uncore: AMD NB counters detected
[    0.531454] LVT offset 0 assigned for vector 0x400
[    0.531538] perf: AMD IBS detected (0x000000ff)
[    0.531908] Scanning for low memory corruption every 60 seconds
[    0.532346] Initialise system trusted keyrings
[    0.532427] workingset: timestamp_bits=46 max_order=22 bucket_order=0
[    0.533581] pstore: using deflate compression
[    0.534029] Key type asymmetric registered
[    0.534083] Asymmetric key parser 'x509' registered
[    0.534171] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.534273] io scheduler noop registered
[    0.534355] io scheduler cfq registered (default)
[    0.534437] io scheduler mq-deadline registered
[    0.534490] io scheduler kyber registered
[    0.534560] io scheduler bfq registered
[    0.537762] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.558190] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.559033] brd: module loaded
[    0.559267] i8042: PNP: No PS/2 controller found.
[    0.559399] NET: Registered protocol family 17
[    0.559782] microcode: CPU0: patch_level=0x06000822
[    0.559840] microcode: CPU1: patch_level=0x06000822
[    0.559899] microcode: CPU2: patch_level=0x06000822
[    0.559958] microcode: CPU3: patch_level=0x06000822
[    0.560063] microcode: Microcode Update Driver: v2.2.
[    0.560074] sched_clock: Marking stable (560059710, 0)->(641350831, -81291121)
[    0.560315] registered taskstats version 1
[    0.560371] Loading compiled-in X.509 certificates
[    0.561349] zswap: default zpool zbud not available
[    0.561403] zswap: pool creation failed
[    0.561639] hctosys: unable to open rtc device (rtc0)
[    0.563312] Freeing unused kernel memory: 1248K
[    0.576353] Write protecting the kernel read-only data: 14336k
[    0.577196] Freeing unused kernel memory: 2020K
[    0.581074] Freeing unused kernel memory: 1532K
[    0.600923] SCSI subsystem initialized
[    0.613952] libata version 3.00 loaded.
[    0.617965] ahci 0000:00:11.0: version 3.0
[    0.618131] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.618202] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.618894] scsi host0: ahci
[    0.619084] scsi host1: ahci
[    0.619252] scsi host2: ahci
[    0.619426] scsi host3: ahci
[    0.619612] scsi host4: ahci
[    0.619778] scsi host5: ahci
[    0.619919] ata1: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b100 irq 19
[    0.619989] ata2: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b180 irq 19
[    0.620058] ata3: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b200 irq 19
[    0.620127] ata4: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b280 irq 19
[    0.620196] ata5: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b300 irq 19
[    0.620265] ata6: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b380 irq 19
[    0.930297] ata3: SATA link down (SStatus 0 SControl 300)
[    0.930859] ata6: SATA link down (SStatus 0 SControl 300)
[    0.932339] ata5: SATA link down (SStatus 0 SControl 300)
[    0.934294] ata4: SATA link down (SStatus 0 SControl 300)
[    1.093768] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.094934] ata2.00: ATAPI: DRW-24D5MT, 1.00, max UDMA/133
[    1.096029] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.096331] ata2.00: configured for UDMA/133
[    1.100250] ata1.00: ATA-7: SAMSUNG HD300LJ, ZT100-12, max UDMA7
[    1.100321] ata1.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.104577] ata1.00: configured for UDMA/133
[    1.104764] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD300LJ  0-12 PQ: 0 ANSI: 5
[    1.105706] scsi 1:0:0:0: CD-ROM            ASUS     DRW-24D5MT       1.00 PQ: 0 ANSI: 5
[    1.142207] sd 0:0:0:0: [sda] 586072368 512-byte logical blocks: (300 GB/279 GiB)
[    1.142281] sd 0:0:0:0: [sda] Write Protect is off
[    1.142335] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.142342] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.154670]  sda: sda1 sda2 sda3
[    1.155177] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.504088] tsc: Refined TSC clocksource calibration: 3800.108 MHz
[    1.504170] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6d8d7b0e4ce, max_idle_ns: 881590614467 ns
[    1.504286] clocksource: Switched to clocksource tsc
[    2.188351] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    2.492456] random: fast init done
[    3.964579] udev[154]: starting version 165
[    4.312105] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.312191] ACPI: Power Button [PWRB]
[    4.312288] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.312362] ACPI: Power Button [PWRF]
[    4.428898] rtc_cmos 00:04: RTC can wake from S4
[    4.429104] rtc_cmos 00:04: registered as rtc0
[    4.429185] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.481281] MCE: In-kernel MCE decoding enabled.
[    4.485898] acpi_cpufreq: overriding BIOS provided _PSD data
[    4.509549] EDAC amd64: Node 0: DRAM ECC disabled.
[    4.509604] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    4.509604]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    4.509604]  (Note that use of the override may cause unknown side effects.)
[    4.607946] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.608051] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.615698] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.615773] piix4_smbus 0000:00:14.0: Using register 0x2c for SMBus port selection
[    4.615923] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    4.638955] sr 1:0:0:0: [sr0] scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.639027] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.639260] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.689873] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.689939] r8169 0000:04:00.0: can't disable ASPM; OS doesn't have ASPM control
[    4.690605] r8169 0000:04:00.0 eth0: RTL8168evl/8111evl, d8:cb:8a:56:80:48, XID 2c900800, IRQ 27
[    4.690676] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    4.759610] ACPI: bus type USB registered
[    4.759707] usbcore: registered new interface driver usbfs
[    4.759779] usbcore: registered new interface driver hub
[    4.759875] usbcore: registered new device driver usb
[    4.818432] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.892161] ehci-pci: EHCI PCI platform driver
[    4.892327] QUIRK: Enable AMD PLL fix
[    4.892348] ehci-pci 0000:00:12.2: EHCI Host Controller
[    4.892408] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    4.892479] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.892556] ehci-pci 0000:00:12.2: debug port 1
[    4.892642] ehci-pci 0000:00:12.2: irq 17, io mem 0xfd309000
[    4.908026] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    4.908291] hub 1-0:1.0: USB hub found
[    4.908358] hub 1-0:1.0: 5 ports detected
[    4.908677] ehci-pci 0000:00:13.2: EHCI Host Controller
[    4.912613] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    4.912684] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.912760] ehci-pci 0000:00:13.2: debug port 1
[    4.912835] ehci-pci 0000:00:13.2: irq 17, io mem 0xfd307000
[    4.928027] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    4.928208] hub 2-0:1.0: USB hub found
[    4.928265] hub 2-0:1.0: 5 ports detected
[    4.928453] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    4.928512] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    4.938176] xhci_hcd 0000:02:00.0: hcc params 0x0200f180 hci version 0x96 quirks 0x0000000000080000
[    4.938550] hub 3-0:1.0: USB hub found
[    4.938609] hub 3-0:1.0: 2 ports detected
[    4.938759] ehci-pci 0000:00:16.2: EHCI Host Controller
[    4.938773] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    4.938852] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 4
[    4.938886] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 5
[    4.938953] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.939019] xhci_hcd 0000:02:00.0: Host supports USB 3.0  SuperSpeed
[    4.939142] ehci-pci 0000:00:16.2: debug port 1
[    4.939233] usb usb5: We don't know the algorithms for LPM for this host, disabling LPM.
[    4.939306] ehci-pci 0000:00:16.2: irq 17, io mem 0xfd304000
[    4.939470] hub 5-0:1.0: USB hub found
[    4.939528] hub 5-0:1.0: 2 ports detected
[    4.952034] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    4.952217] hub 4-0:1.0: USB hub found
[    4.952274] hub 4-0:1.0: 4 ports detected
[    5.191718] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.283034] ohci-pci: OHCI PCI platform driver
[    5.283210] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    5.283301] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 6
[    5.283400] ohci-pci 0000:00:12.0: irq 18, io mem 0xfd30a000
[    5.304034] pktcdvd: pktcdvd0: writer mapped to sr0
[    5.344732] hub 6-0:1.0: USB hub found
[    5.344797] hub 6-0:1.0: 5 ports detected
[    5.345152] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    5.345213] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 7
[    5.345305] ohci-pci 0000:00:13.0: irq 18, io mem 0xfd308000
[    5.356950] r8169 0000:04:00.0 eth6: renamed from eth0
[    5.376103] udev[160]: renamed network interface eth0 to eth6
[    5.399445] kvm: Nested Virtualization enabled
[    5.399502] kvm: Nested Paging enabled
[    5.410994] cryptd: max_cpu_qlen set to 1000
[    5.412190] hub 7-0:1.0: USB hub found
[    5.412252] hub 7-0:1.0: 5 ports detected
[    5.412547] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    5.412605] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 8
[    5.412720] ohci-pci 0000:00:14.5: irq 18, io mem 0xfd306000
[    5.480178] hub 8-0:1.0: USB hub found
[    5.480242] hub 8-0:1.0: 2 ports detected
[    5.480501] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    5.480560] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 9
[    5.480650] ohci-pci 0000:00:16.0: irq 18, io mem 0xfd305000
[    5.499046] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC892: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[    5.499123] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    5.499193] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    5.499262] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    5.499345] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x11/0x1e
[    5.499401] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    5.499455] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[    5.499511] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[    5.499566] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[    5.514644] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input2
[    5.514849] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    5.515173] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input4
[    5.515323] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    5.515879] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    5.516020] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    5.516172] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    5.516302] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    5.530972] Linux agpgart interface v0.103
[    5.544344] hub 9-0:1.0: USB hub found
[    5.544405] hub 9-0:1.0: 4 ports detected
[    5.656441] AVX version of gcm_enc/dec engaged.
[    5.656498] AES CTR mode by8 optimization enabled
[    5.972028] usb 6-2: new full-speed USB device number 2 using ohci-pci
[    6.407587] MXM: GUID detected in BIOS
[    6.407829] nouveau 0000:01:00.0: NVIDIA G92 (092300a2)
[    6.407915] nouveau 0000:01:00.0: pci: MSI enabled
[    6.459919] Bluetooth: Core ver 2.22
[    6.460197] NET: Registered protocol family 31
[    6.460490] Bluetooth: HCI device and connection manager initialized
[    6.460790] Bluetooth: HCI socket layer initialized
[    6.461111] Bluetooth: L2CAP socket layer initialized
[    6.461410] Bluetooth: SCO socket layer initialized
[    6.517367] nouveau 0000:01:00.0: bios: version 62.92.1f.00.09
[    6.537801] nouveau 0000:01:00.0: pci: pcie max speed: 5.0GT/s
[    6.537878] nouveau 0000:01:00.0: fb: 384 MiB GDDR3
[    6.589743] usbcore: registered new interface driver btusb
[    6.599190] [TTM] Zone  kernel: Available graphics memory: 6114262 kiB
[    6.599247] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    6.599303] [TTM] Initializing pool allocator
[    6.599358] [TTM] Initializing DMA pool allocator
[    6.599425] nouveau 0000:01:00.0: DRM: VRAM: 384 MiB
[    6.599479] nouveau 0000:01:00.0: DRM: GART: 1048576 MiB
[    6.599534] nouveau 0000:01:00.0: DRM: TMDS table version 2.0
[    6.599590] nouveau 0000:01:00.0: DRM: DCB version 4.0
[    6.599644] nouveau 0000:01:00.0: DRM: DCB outp 00: 02000300 00000028
[    6.599700] nouveau 0000:01:00.0: DRM: DCB outp 01: 01000302 00000030
[    6.599756] nouveau 0000:01:00.0: DRM: DCB outp 02: 02011312 00020010
[    6.599812] nouveau 0000:01:00.0: DRM: DCB outp 03: 010223f1 00c0c083
[    6.599868] nouveau 0000:01:00.0: DRM: DCB conn 00: 00001030
[    6.599922] nouveau 0000:01:00.0: DRM: DCB conn 01: 00002130
[    6.599977] nouveau 0000:01:00.0: DRM: DCB conn 02: 00000210
[    6.600036] nouveau 0000:01:00.0: DRM: DCB conn 03: 00000211
[    6.600091] nouveau 0000:01:00.0: DRM: DCB conn 04: 00000213
[    6.600146] nouveau 0000:01:00.0: DRM: DCB conn 05: 00000362
[    6.606502] nouveau 0000:01:00.0: DRM: failed to create encoder 0/1/0: -19
[    6.606559] nouveau 0000:01:00.0: DRM: TV-1 has no encoders, removing
[    6.606643] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.606699] [drm] Driver supports precise vblank timestamp query.
[    6.608356] nouveau 0000:01:00.0: DRM: MM: using CRYPT for buffer copies
[    6.638980] nouveau 0000:01:00.0: DRM: allocated 1440x900 fb: 0x50000, bo (____ptrval____)
[    6.640067] fbcon: nouveaufb (fb0) is primary device
[    6.739513] Console: switching to colour frame buffer device 180x56
[    6.742789] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    6.752122] [drm] Initialized nouveau 1.3.1 20120801 for 0000:01:00.0 on minor 0
[    6.824021] usb 6-3: new low-speed USB device number 3 using ohci-pci
[    7.070183] hidraw: raw HID events driver (C) Jiri Kosina
[    7.103151] usbcore: registered new interface driver usbhid
[    7.103160] usbhid: USB HID core driver
[    7.134565] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb6/6-3/6-3:1.0/0003:046D:C077.0001/input/input10
[    7.134657] hid-generic 0003:046D:C077.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:12.0-3/input0
[    7.154770] mousedev: PS/2 mouse device common for all mice
[    7.576088] usb 6-4: new low-speed USB device number 4 using ohci-pci
[    7.779482] input: SONiX USB Keyboard as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.0/0003:0C45:760B.0002/input/input11
[    7.836293] hid-generic 0003:0C45:760B.0002: input,hidraw1: USB HID v1.11 Keyboard [SONiX USB Keyboard] on usb-0000:00:12.0-4/input0
[    7.840558] input: SONiX USB Keyboard Consumer Control as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.1/0003:0C45:760B.0003/input/input12
[    7.900351] input: SONiX USB Keyboard System Control as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.1/0003:0C45:760B.0003/input/input13
[    7.900495] hid-generic 0003:0C45:760B.0003: input,hidraw2: USB HID v1.11 Device [SONiX USB Keyboard] on usb-0000:00:12.0-4/input1
[    8.538241] Adding 1172476k swap on /dev/sda1.  Priority:-2 extents:1 across:1172476k FS
[    8.540290] EXT4-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
[    8.553712] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.616865] f71882fg: Found f71889a chip at 0x480, revision 49
[    9.617202] f71882fg f71882fg.1152: Fan: 1 is in duty-cycle mode
[    9.617908] f71882fg f71882fg.1152: Fan: 2 is in duty-cycle mode
[    9.618990] f71882fg f71882fg.1152: Fan: 3 is in duty-cycle mode
[    9.620077] f71882fg f71882fg.1152: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    9.696411] lp: driver loaded but no devices found
[    9.844389] SGI XFS with ACLs, security attributes, no debug enabled
[    9.879255] XFS (sda3): Mounting V4 Filesystem
[   10.064342] XFS (sda3): Ending clean mount
[   10.314630] random: dd: uninitialized urandom read (4096 bytes read)
[   12.121432] r8169 0000:04:00.0 eth6: link down
[   13.949261] r8169 0000:04:00.0 eth6: link up
[   13.996249] random: dhcpcd: uninitialized urandom read (120 bytes read)
[   20.598508] NET: Registered protocol family 10
[   20.599023] Segment Routing with IPv6
[   20.599503] random: cupsd: uninitialized urandom read (4096 bytes read)
[   21.438039] random: dbus-daemon: uninitialized urandom read (12 bytes read)
[   21.564198] random: dbus-daemon: uninitialized urandom read (12 bytes read)
[   22.151884] random: hald: uninitialized urandom read (10 bytes read)
[   22.151969] random: hald: uninitialized urandom read (12 bytes read)
[   22.152791] random: hald: uninitialized urandom read (10 bytes read)
[   25.841267] microcode: CPU2: new patch_level=0x06000852
[   25.855970] microcode: CPU0: new patch_level=0x06000852
[   25.856029] x86/CPU: CPU features have changed after loading microcode, but might not take effect.
[   25.856031] x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.
[   26.084379] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   26.084385] Bluetooth: HIDP socket layer initialized
[   26.242372] Bluetooth: RFCOMM TTY layer initialized
[   26.242376] Bluetooth: RFCOMM socket layer initialized
[   26.242380] Bluetooth: RFCOMM ver 1.11
[   26.249025] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   26.249027] Bluetooth: BNEP filters: protocol multicast
[   26.249030] Bluetooth: BNEP socket layer initialized
[   26.327542] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   27.960129] random: crng init done
[   27.960134] random: 1 urandom warning(s) missed due to ratelimiting
[   44.982232] start_kdeinit (1049): /proc/1049/oom_adj is deprecated, please use /proc/1049/oom_score_adj instead.
[  203.412241] PM: suspend entry (deep)
[  203.412246] PM: Syncing filesystems ... done.
[  203.601266] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  203.602978] OOM killer disabled.
[  203.602979] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  203.604105] Suspending console(s) (use no_console_suspend to debug)
[  203.605534] serial 00:03: disabled
[  203.624227] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  203.624308] sd 0:0:0:0: [sda] Stopping disk
[  204.944974] ACPI: Preparing to enter system sleep state S3
[  204.946218] PM: Saving platform NVS memory
[  204.946247] Disabling non-boot CPUs ...
[  204.962941] smpboot: CPU 1 is now offline
[  204.985695] smpboot: CPU 2 is now offline
[  205.013615] smpboot: CPU 3 is now offline
[  205.015728] ACPI: Low-level resume complete
[  205.015754] PM: Restoring platform NVS memory
[  205.096958] LVT offset 0 assigned for vector 0x400
[  205.102425] microcode: CPU0: new patch_level=0x06000852
[  205.102463] Enabling non-boot CPUs ...
[  205.102488] x86: Booting SMP configuration:
[  205.102488] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  205.104909] TSC synchronization [CPU#0 -> CPU#1]:
[  205.104910] Measured 2407086594 cycles TSC warp between CPUs, turning off TSC clock.
[  205.104915] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[  205.104927] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
[  205.104928] sched_clock: Marking unstable (205021879202, -28940)<-(205186217900, -81291121)
[  205.738575]  cache: parent cpu1 should not be sleeping
[  205.738653] microcode: CPU1: patch_level=0x06000852
[  205.105310] CPU1 is up
[  205.655674] clocksource: Switched to clocksource hpet
[  205.655674] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  205.655686]  cache: parent cpu2 should not be sleeping
[  205.655686] microcode: CPU2: patch_level=0x06000822
[  205.655686] microcode: CPU2: new patch_level=0x06000852
[  205.655686] CPU2 is up
[  205.655686] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  205.655686]  cache: parent cpu3 should not be sleeping
[  205.655686] microcode: CPU3: patch_level=0x06000852
[  205.655686] CPU3 is up
[  205.655686] ACPI: Waking up from system sleep state S3
[  205.655686] usb usb3: root hub lost power or was reset
[  205.655686] usb usb5: root hub lost power or was reset
[  205.655686] serial 00:03: activated
[  205.655686] sd 0:0:0:0: [sda] Starting disk
[  205.655686] r8169 0000:04:00.0 eth6: link down
[  205.655686] ata3: SATA link down (SStatus 0 SControl 300)
[  205.655686] ata6: SATA link down (SStatus 0 SControl 300)
[  205.655686] ata4: SATA link down (SStatus 0 SControl 300)
[  205.655686] ata5: SATA link down (SStatus 0 SControl 300)
[  205.655686] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  205.655686] ata2.00: configured for UDMA/133
[  205.655686] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  206.248085] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  206.728068] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  206.917108] usb 6-2: device descriptor read/all, error -62
[  207.108071] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  207.195875] r8169 0000:04:00.0 eth6: link up
[  207.299840] OOM killer enabled.
[  207.299840] Restarting tasks ... done.
[  207.304737] PM: suspend exit
[  211.284083] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  211.292409] ata1.00: configured for UDMA/133
[  291.865609] PM: suspend entry (deep)
[  291.865612] PM: Syncing filesystems ... done.
[  291.986719] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  291.988084] OOM killer disabled.
[  291.988085] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  291.989301] Suspending console(s) (use no_console_suspend to debug)
[  291.990548] serial 00:03: disabled
[  292.009148] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  292.009238] sd 0:0:0:0: [sda] Stopping disk
[  293.092550] ACPI: Preparing to enter system sleep state S3
[  293.093357] PM: Saving platform NVS memory
[  293.093374] Disabling non-boot CPUs ...
[  293.110514] smpboot: CPU 1 is now offline
[  293.133752] smpboot: CPU 2 is now offline
[  293.165318] smpboot: CPU 3 is now offline
[  293.165357] ACPI: Low-level resume complete
[  293.165357] PM: Restoring platform NVS memory
[  293.165357] LVT offset 0 assigned for vector 0x400
[  293.165357] microcode: CPU0: new patch_level=0x06000852
[  293.170916] Enabling non-boot CPUs ...
[  293.170940] x86: Booting SMP configuration:
[  293.170941] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  293.171609]  cache: parent cpu1 should not be sleeping
[  293.171687] microcode: CPU1: patch_level=0x06000852
[  293.171771] CPU1 is up
[  293.171787] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  293.172396]  cache: parent cpu2 should not be sleeping
[  293.172477] microcode: CPU2: patch_level=0x06000822
[  293.176334] microcode: CPU2: new patch_level=0x06000852
[  293.177938] CPU2 is up
[  293.177953] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  293.178658]  cache: parent cpu3 should not be sleeping
[  293.178740] microcode: CPU3: patch_level=0x06000852
[  293.178854] CPU3 is up
[  293.181728] ACPI: Waking up from system sleep state S3
[  293.228206] usb usb3: root hub lost power or was reset
[  293.228208] usb usb5: root hub lost power or was reset
[  293.228819] serial 00:03: activated
[  293.233222] sd 0:0:0:0: [sda] Starting disk
[  293.369969] r8169 0000:04:00.0 eth6: link down
[  293.535367] ata3: SATA link down (SStatus 0 SControl 300)
[  293.535427] ata6: SATA link down (SStatus 0 SControl 300)
[  293.535458] ata4: SATA link down (SStatus 0 SControl 300)
[  293.547216] ata5: SATA link down (SStatus 0 SControl 300)
[  293.696071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  293.713006] ata2.00: configured for UDMA/133
[  293.732090] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  294.212074] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  294.401193] usb 6-2: device descriptor read/all, error -62
[  294.696087] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  295.176065] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  295.367753] OOM killer enabled.
[  295.367754] Restarting tasks ... done.
[  295.370579] PM: suspend exit
[  295.452211] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000000 flags=0x0000]
[  295.452217] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0xffffffffffffffc0 flags=0x0010]
[  295.452221] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000000 flags=0x0000]
[  295.452225] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000000 flags=0x0000]
[  295.452228] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000040 flags=0x0000]
[  295.452268] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000040 flags=0x0000]
[  295.452272] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000080 flags=0x0000]
[  295.452618] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000080 flags=0x0000]
[  295.452902] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000000c0 flags=0x0000]
[  295.453235] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000000100 flags=0x0000]
[  295.453568] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000140 flags=0x0000]
[  295.453901] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000180 flags=0x0000]
[  295.454234] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000001c0 flags=0x0000]
[  295.454567] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000200 flags=0x0000]
[  295.454900] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000240 flags=0x0000]
[  295.455234] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000280 flags=0x0000]
[  295.455567] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000002c0 flags=0x0000]
[  295.455899] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000300 flags=0x0000]
[  295.456235] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000340 flags=0x0000]
[  295.456567] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000000380 flags=0x0000]
[  295.490219] r8169 0000:04:00.0 eth6: link up
[  299.464017] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  299.472362] ata1.00: configured for UDMA/133
[  300.456245] amd_iommu_report_page_fault: 15008 callbacks suppressed
[  300.456255] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000ea940 flags=0x0000]
[  300.456597] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000ea980 flags=0x0000]
[  300.456917] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000ea9c0 flags=0x0000]
[  300.457248] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eaa00 flags=0x0000]
[  300.457579] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eaa40 flags=0x0000]
[  300.457912] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eaa80 flags=0x0000]
[  300.458246] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eaac0 flags=0x0000]
[  300.458577] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eab00 flags=0x0000]
[  300.458911] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eab40 flags=0x0000]
[  300.459244] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000000eab80 flags=0x0000]
[  300.459577] amd_iommu_report_page_fault: 14998 callbacks suppressed
[  300.459581] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eabc0 flags=0x0000]
[  300.459914] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eac00 flags=0x0000]
[  300.460250] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eac40 flags=0x0000]
[  300.460579] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eac80 flags=0x0000]
[  300.460911] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eacc0 flags=0x0000]
[  300.461247] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000ead00 flags=0x0000]
[  300.461579] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000ead40 flags=0x0000]
[  300.461910] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000ead80 flags=0x0000]
[  300.462243] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eadc0 flags=0x0000]
[  300.462578] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000000eae00 flags=0x0000]
[  305.460248] amd_iommu_report_page_fault: 15002 callbacks suppressed
[  305.460255] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5240 flags=0x0000]
[  305.460581] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5280 flags=0x0000]
[  305.460914] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d52c0 flags=0x0000]
[  305.461247] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5300 flags=0x0000]
[  305.461581] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5340 flags=0x0000]
[  305.461914] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5380 flags=0x0000]
[  305.462247] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d53c0 flags=0x0000]
[  305.462579] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5400 flags=0x0000]
[  305.462912] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5440 flags=0x0000]
[  305.463248] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000001d5480 flags=0x0000]
[  305.463575] amd_iommu_report_page_fault: 14992 callbacks suppressed
[  305.463578] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d54c0 flags=0x0000]
[  305.463913] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5500 flags=0x0000]
[  305.464245] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5540 flags=0x0000]
[  305.464579] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5580 flags=0x0000]
[  305.464913] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d55c0 flags=0x0000]
[  305.465247] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5600 flags=0x0000]
[  305.465577] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5640 flags=0x0000]
[  305.465912] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5680 flags=0x0000]
[  305.466248] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d56c0 flags=0x0000]
[  305.466577] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000001d5700 flags=0x0000]
[  310.464250] amd_iommu_report_page_fault: 15002 callbacks suppressed
[  310.464257] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfb40 flags=0x0000]
[  310.464582] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfb80 flags=0x0000]
[  310.464918] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfbc0 flags=0x0000]
[  310.465252] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfc00 flags=0x0000]
[  310.465584] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfc40 flags=0x0000]
[  310.465916] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfc80 flags=0x0000]
[  310.466249] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfcc0 flags=0x0000]
[  310.466580] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfd00 flags=0x0000]
[  310.466914] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfd40 flags=0x0000]
[  310.467247] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000002bfd80 flags=0x0000]
[  310.467580] amd_iommu_report_page_fault: 14992 callbacks suppressed
[  310.467584] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bfdc0 flags=0x0000]
[  310.467913] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bfe00 flags=0x0000]
[  310.468251] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bfe40 flags=0x0000]
[  310.468584] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bfe80 flags=0x0000]
[  310.468915] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bfec0 flags=0x0000]
[  310.469248] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bff00 flags=0x0000]
[  310.469580] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bff40 flags=0x0000]
[  310.469918] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bff80 flags=0x0000]
[  310.470249] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002bffc0 flags=0x0000]
[  310.470580] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000002c0000 flags=0x0000]
[  315.468251] amd_iommu_report_page_fault: 15002 callbacks suppressed
[  315.468257] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa440 flags=0x0000]
[  315.468584] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa480 flags=0x0000]
[  315.468917] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa4c0 flags=0x0000]
[  315.469250] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa500 flags=0x0000]
[  315.469584] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa540 flags=0x0000]
[  315.469917] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa580 flags=0x0000]
[  315.470249] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa5c0 flags=0x0000]
[  315.470582] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa600 flags=0x0000]
[  315.470916] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa640 flags=0x0000]
[  315.471250] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x00000000003aa680 flags=0x0000]
[  315.471582] amd_iommu_report_page_fault: 14992 callbacks suppressed
[  315.471586] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa6c0 flags=0x0000]
[  315.471921] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa700 flags=0x0000]
[  315.472252] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa740 flags=0x0000]
[  315.472584] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa780 flags=0x0000]
[  315.472918] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa7c0 flags=0x0000]
[  315.473251] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa800 flags=0x0000]
[  315.473589] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa840 flags=0x0000]
[  315.473916] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa880 flags=0x0000]
[  315.474248] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa8c0 flags=0x0000]
[  315.474582] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000003aa900 flags=0x0000]
[  320.472254] amd_iommu_report_page_fault: 15002 callbacks suppressed
[  320.472260] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494d40 flags=0x0000]
[  320.472586] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494d80 flags=0x0000]
[  320.472919] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494dc0 flags=0x0000]
[  320.473252] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494e00 flags=0x0000]
[  320.473585] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494e40 flags=0x0000]
[  320.473918] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494e80 flags=0x0000]
[  320.474252] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494ec0 flags=0x0000]
[  320.474583] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494f00 flags=0x0000]
[  320.474917] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494f40 flags=0x0000]
[  320.475250] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x0000000000494f80 flags=0x0000]
[  320.475583] amd_iommu_report_page_fault: 14992 callbacks suppressed
[  320.475587] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000494fc0 flags=0x0000]
[  320.475917] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495000 flags=0x0000]
[  320.476258] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495040 flags=0x0000]
[  320.476596] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495080 flags=0x0000]
[  320.476920] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000004950c0 flags=0x0000]
[  320.477252] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495100 flags=0x0000]
[  320.477588] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495140 flags=0x0000]
[  320.477917] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495180 flags=0x0000]
[  320.478252] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x00000000004951c0 flags=0x0000]
[  320.478582] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x0000000000495200 flags=0x0000]
[  325.476255] amd_iommu_report_page_fault: 15002 callbacks suppressed
[  325.476262] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f640 flags=0x0000]
[  325.476588] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f680 flags=0x0000]
[  325.476920] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f6c0 flags=0x0000]
[  325.477254] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f700 flags=0x0000]
[  325.477587] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f740 flags=0x0000]
[  325.477920] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f780 flags=0x0000]
[  325.478259] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f7c0 flags=0x0000]
[  325.478588] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f800 flags=0x0000]
[  325.478919] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f840 flags=0x0000]
[  325.479252] snd_hda_intel 0000:00:14.2: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0x000000000057f880 flags=0x0000]
[  325.479585] amd_iommu_report_page_fault: 14992 callbacks suppressed
[  325.479589] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057f8c0 flags=0x0000]
[  325.479918] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057f900 flags=0x0000]
[  325.480254] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057f940 flags=0x0000]
[  325.480590] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057f980 flags=0x0000]
[  325.480920] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057f9c0 flags=0x0000]
[  325.481253] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057fa00 flags=0x0000]
[  325.481586] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057fa40 flags=0x0000]
[  325.481920] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057fa80 flags=0x0000]
[  325.482253] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057fac0 flags=0x0000]
[  325.482585] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.2 domain=0x0000 address=0x000000000057fb00 flags=0x0000]
[  325.611201] PM: suspend entry (deep)
[  325.611204] PM: Syncing filesystems ... done.
[  325.806140] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  325.807692] OOM killer disabled.
[  325.807693] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  325.809017] Suspending console(s) (use no_console_suspend to debug)
[  325.810501] serial 00:03: disabled
[  325.829090] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  325.868128] sd 0:0:0:0: [sda] Stopping disk
[  326.904560] ACPI: Preparing to enter system sleep state S3
[  326.905593] PM: Saving platform NVS memory
[  326.905622] Disabling non-boot CPUs ...
[  326.922930] smpboot: CPU 1 is now offline
[  326.945372] smpboot: CPU 2 is now offline
[  326.969328] smpboot: CPU 3 is now offline
[  326.969427] ACPI: Low-level resume complete
[  326.969427] PM: Restoring platform NVS memory
[  326.969427] LVT offset 0 assigned for vector 0x400
[  326.969427] microcode: CPU0: new patch_level=0x06000852
[  326.974965] Enabling non-boot CPUs ...
[  326.974990] x86: Booting SMP configuration:
[  326.974990] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  326.975669]  cache: parent cpu1 should not be sleeping
[  326.975748] microcode: CPU1: patch_level=0x06000852
[  326.975831] CPU1 is up
[  326.975847] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  326.976463]  cache: parent cpu2 should not be sleeping
[  326.976546] microcode: CPU2: patch_level=0x06000822
[  326.980216] microcode: CPU2: new patch_level=0x06000852
[  326.982016] CPU2 is up
[  326.982030] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  326.982735]  cache: parent cpu3 should not be sleeping
[  326.982817] microcode: CPU3: patch_level=0x06000852
[  326.982930] CPU3 is up
[  326.985795] ACPI: Waking up from system sleep state S3
[  327.025170] usb usb3: root hub lost power or was reset
[  327.025172] usb usb5: root hub lost power or was reset
[  327.025786] serial 00:03: activated
[  327.032009] sd 0:0:0:0: [sda] Starting disk
[  327.169570] r8169 0000:04:00.0 eth6: link down
[  327.339263] ata6: SATA link down (SStatus 0 SControl 300)
[  327.343327] ata5: SATA link down (SStatus 0 SControl 300)
[  327.343377] ata3: SATA link down (SStatus 0 SControl 300)
[  327.343406] ata4: SATA link down (SStatus 0 SControl 300)
[  327.504135] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  327.520957] ata2.00: configured for UDMA/133
[  327.536098] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  328.156094] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  328.636073] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  328.825232] usb 6-2: device descriptor read/all, error -62
[  328.988004] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  329.179805] OOM killer enabled.
[  329.179805] Restarting tasks ... done.
[  329.188000] PM: suspend exit
[  329.230320] r8169 0000:04:00.0 eth6: link up
[  332.428084] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  332.436552] ata1.00: configured for UDMA/133

--Boundary-00=_YIlIb1/2xAYIosJ--
