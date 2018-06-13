From: Andrew Randrianasulu <randrianasulu@gmail.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git 4.17.0-x64-08428-g7d3bf613e99a
Date: Wed, 13 Jun 2018 10:38:02 +0300
Message-ID: <201806131038.02793.randrianasulu@gmail.com>
References: <201806091606.51078.randrianasulu@gmail.com> <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com> <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_anMIbKDgw16xVrv"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Boundary-00=_anMIbKDgw16xVrv
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=C2 =F1=EE=EE=E1=F9=E5=ED=E8=E8 =EE=F2 Wednesday 13 June 2018 07:03:47 jian=
chao.wang =ED=E0=EF=E8=F1=E0=EB(=E0):
> On 06/12/2018 11:28 PM, Bart Van Assche wrote:
> > On Sat, 2018-06-09 at 08:02 -0700, Randy Dunlap wrote:
> >> On 06/09/2018 06:06 AM, Andrew Randrianasulu wrote:
> >>> Hello, everyone!
> >>>
> >>> I was trying to test not-yet-completed 4.18-rc1, and run into this bu=
g,
> >>> probably due to HAL (yes, I still use this) trying to poll empty DVD-=
RW
> >>> drive:
> >>>
> >>> [   35.040167] ------------[ cut here ]------------
> >>> [   35.040171] kernel BUG at drivers/scsi/scsi_error.c:197!
> >>> [   35.040196] invalid opcode: 0000 [#1] SMP NOPTI
> >>> [   35.040210] CPU: 2 PID: 117 Comm: kworker/2:1H Not tainted
> >>> 4.17.0-x64-08428-g7d3bf613e99a-dirty #18
> >>> [   35.040225] Hardware name: MSI MS-7693/970A-G46 (MS-7693), BIOS V2=
=2E8
> >>> 01/08/2016
> >>> [   35.040244] Workqueue: kblockd blk_mq_timeout_work
> >>> [   35.040283] RIP: 0010:scsi_times_out+0xe9/0x1a6 [scsi_mod]
> >>> [   35.040287] Code: 03 76 18 48 c7 c2 f9 c2 01 a0 48 89 ee 48 c7 c7 =
14
> >>> be 01 a0 31 c0 e8 76 ad 00 00 48 8b 83 98 01 00 00 a8 01 0f 84 a5 00 =
00
> >>> 00 <0f> 0b 49 8b 7c 24 38 e8 8f ba 4b e1 41 83 bc 24 2c 01
> >>>  00 00 ff 74
> >>> [   35.040312] RSP: 0018:ffffc90000293d98 EFLAGS: 00010202
> >>> [   35.040318] RAX: ffff88031f240605 RBX: ffff88031eed8500 RCX:
> >>> 00000000fffefd40 [   35.040323] RDX: ffffc90000293e80 RSI:
> >>> 0000000000002007 RDI: ffff88031eed8638 [   35.040327] RBP:
> >>> ffff88031eed8638 R08: ffff88031eed85d8 R09: 0000000000000000 [ =20
> >>> 35.040332] R10: 0000000000000040 R11: fefefefefefefeff R12:
> >>> ffff88031f2a8800 [   35.040336] R13: ffff88031f2a8800 R14:
> >>> ffff88031f29e910 R15: 0000000000000001 [   35.040341] FS:=20
> >>> 0000000000000000(0000) GS:ffff88032ed00000(0000) knlGS:00000000000000=
00
> >>> [   35.040346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [   35.040350] CR2: 00000000f7ea83c0 CR3: 000000031e194000 CR4:
> >>> 00000000000406e0 [   35.040354] Call Trace:
> >>> [   35.040360]  blk_mq_check_expired+0xdc/0x10c
> >>> [   35.040365]  bt_iter+0x42/0x45
> >>> [   35.040369]  __sbitmap_for_each_set.constprop.12+0x83/0xac
> >>> [   35.040374]  ? blk_mq_update_nr_requests+0xad/0xad
> >>> [   35.040595]  ? blk_mq_exit_hctx+0xda/0xda
> >>> [   35.041595]  blk_mq_queue_tag_busy_iter+0xa3/0xb4
> >>> [   35.042578]  ? blk_mq_exit_hctx+0xda/0xda
> >>> [   35.043550]  blk_mq_timeout_work+0x6b/0xca
> >>> [   35.044505]  process_one_work+0x17c/0x2a6
> >>> [   35.045445]  worker_thread+0x19f/0x243
> >>> [   35.046393]  ? rescuer_thread+0x262/0x262
> >>> [   35.047346]  kthread+0x100/0x108
> >>> [   35.048290]  ? kthread_destroy_worker+0x3e/0x3e
> >>> [   35.049242]  ret_from_fork+0x27/0x50
> >>> [   35.050192] Modules linked in: bridge stp llc bnep rfcomm hidp
> >>> snd_aloop ipv6
>
> .....
>
> > Is this something that happens systematically or sporadically?
> > Additionally, have you verified whether or not this can be triggered wi=
th
> > kernel v4.17? I'm wondering whether or not this is a regression that was
> > introduced in the merge window.
>
> I suspect this is due to we could expire a same request twice or even mor=
e.
> For scsi mid-layer, it return BLK_EH_DONE from .timeout, in fact, the
> request is not completed there, but just queue a delayed abort_work
> (HZ/100). If the blk_mq_timeout_work runs again before the abort_work, the
> request will be timed out again, because there is not any mark on it to
> identify this request has been timed out.
>
> Would please try the patch attached on to see whether this issue could be
> fixed ? (this patch only works for scsi device currently)

with this patch on top of 4.17.0-x64-11730-gf5b7769eb040-dirty I can=20
suspend/resume my machine again, no errors in dmesg (attached)

Thanks!

>
> Thanks
> Jianchao



--Boundary-00=_anMIbKDgw16xVrv
Content-Type: text/x-log;
  charset="iso 8859-1";
  name="dmesg_4.17-git_patched.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_4.17-git_patched.log"

[    0.000000] Linux version 4.17.0-x64-11730-gf5b7769eb040-dirty (guest@slax) (gcc version 4.9.2 (GCC)) #18 SMP Wed Jun 13 07:50:06 MSK 2018
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
[    0.000000] RAMDISK: [mem 0x7fdc5000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CDE6D070 00005C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CDE73528 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has valid Length but zero Address: 0x0000000000000000/0x1 (20180508/tbfadt-624)
[    0.000000] ACPI: DSDT 0x00000000CDE6D160 0063C2 (v02 ALASKA A M I    00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CDE76080 000040
[    0.000000] ACPI: APIC 0x00000000CDE73638 00007E (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CDE736B8 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000CDE73700 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 0x00000000CDE73740 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: SSDT 0x00000000CDE73778 000B9C (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: IVRS 0x00000000CDE74318 0000C0 (v01 AMD    RD890S   00202031 AMD  00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: No reference (HPET/PMTIMER) available
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
[    0.000000] Memory: 12155472K/12531180K available (8204K kernel code, 980K rwdata, 2564K rodata, 1248K init, 388K bss, 375708K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 27778 entries in 109 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 4352, nr_irqs: 1000, preallocated irqs: 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180508
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.004000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.024000] tsc: Fast TSC calibration using PIT
[    0.028000] tsc: Detected 3800.054 MHz processor
[    0.028000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x6d8d176edc6, max_idle_ns: 881590945952 ns
[    0.028000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7600.10 BogoMIPS (lpj=15200216)
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
[    0.040000] smpboot: CPU0: AMD FX(tm)-4300 Quad-Core Processor (family: 0x15, model: 0x2, stepping: 0x0)
[    0.040000] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.040000] ... version:                0
[    0.040000] ... bit width:              48
[    0.040000] ... generic registers:      6
[    0.040000] ... value mask:             0000ffffffffffff
[    0.040000] ... max period:             00007fffffffffff
[    0.040000] ... fixed-purpose events:   0
[    0.040000] ... event mask:             000000000000003f
[    0.040000] Hierarchical SRCU implementation.
[    0.040000] smp: Bringing up secondary CPUs ...
[    0.040000] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.040000] x86: Booting SMP configuration:
[    0.040000] .... node  #0, CPUs:      #1 #2 #3
[    0.044025] smp: Brought up 1 node, 4 CPUs
[    0.044109] smpboot: Max logical packages: 1
[    0.044161] smpboot: Total of 4 processors activated (30400.43 BogoMIPS)
[    0.048381] devtmpfs: initialized
[    0.048381] PM: Registering ACPI NVS region [mem 0xcdb34000-0xcde7cfff] (3444736 bytes)
[    0.048381] PM: Registering ACPI NVS region [mem 0xcea44000-0xcec49fff] (2121728 bytes)
[    0.048381] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.048412] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.048512] pinctrl core: initialized pinctrl subsystem
[    0.048715] NET: Registered protocol family 16
[    0.048860] audit: initializing netlink subsys (disabled)
[    0.048919] audit: type=2000 audit(1528885998.048:1): state=initialized audit_enabled=0 res=1
[    0.048919] cpuidle: using governor ladder
[    0.048919] cpuidle: using governor menu
[    0.048919] ACPI: bus type PCI registered
[    0.048919] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.048919] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.048919] PCI: not using MMCONFIG
[    0.048919] PCI: Using configuration type 1 for base access
[    0.048919] PCI: Using configuration type 1 for extended access
[    0.048919] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.048919] ACPI: Added _OSI(Module Device)
[    0.048919] ACPI: Added _OSI(Processor Device)
[    0.048919] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.048919] ACPI: Added _OSI(Processor Aggregator Device)
[    0.048919] ACPI: Added _OSI(Linux-Dell-Video)
[    0.054771] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.056205] ACPI: Interpreter enabled
[    0.056299] ACPI: (supports S0 S3 S4 S5)
[    0.056351] ACPI: Using IOAPIC for interrupt routing
[    0.056522] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.056625] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.056705] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.056922] ACPI: Enabled 11 GPEs in block 00 to 1F
[    0.060305] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.060364] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.060437] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.060716] PCI host bridge to bus 0000:00
[    0.060769] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.060826] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.060882] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.060938] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.060995] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.061063] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.061132] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xffffffff window]
[    0.061200] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.061262] pci 0000:00:00.0: [1002:5a14] type 00 class 0x060000
[    0.061368] pci 0000:00:00.2: [1002:5a23] type 00 class 0x080600
[    0.061465] pci 0000:00:02.0: [1002:5a16] type 01 class 0x060400
[    0.061509] pci 0000:00:02.0: enabling Extended Tags
[    0.061581] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.061658] pci 0000:00:04.0: [1002:5a18] type 01 class 0x060400
[    0.061673] pci 0000:00:04.0: enabling Extended Tags
[    0.061744] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.061832] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.061848] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    0.061854] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    0.061861] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    0.061867] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    0.061874] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    0.061880] pci 0000:00:11.0: reg 0x24: [mem 0xfd30b000-0xfd30b3ff]
[    0.061978] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.061990] pci 0000:00:12.0: reg 0x10: [mem 0xfd30a000-0xfd30afff]
[    0.062102] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.062117] pci 0000:00:12.2: reg 0x10: [mem 0xfd309000-0xfd3090ff]
[    0.062175] pci 0000:00:12.2: supports D1 D2
[    0.062176] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.062254] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.062266] pci 0000:00:13.0: reg 0x10: [mem 0xfd308000-0xfd308fff]
[    0.062378] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.062393] pci 0000:00:13.2: reg 0x10: [mem 0xfd307000-0xfd3070ff]
[    0.062450] pci 0000:00:13.2: supports D1 D2
[    0.062451] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.062528] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.062650] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.062667] pci 0000:00:14.2: reg 0x10: [mem 0xfd300000-0xfd303fff 64bit]
[    0.062744] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.062816] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.062933] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.063030] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.063043] pci 0000:00:14.5: reg 0x10: [mem 0xfd306000-0xfd306fff]
[    0.063156] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.063184] pci 0000:00:15.0: enabling Extended Tags
[    0.063267] pci 0000:00:15.0: supports D1 D2
[    0.063354] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.063367] pci 0000:00:16.0: reg 0x10: [mem 0xfd305000-0xfd305fff]
[    0.063479] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.063494] pci 0000:00:16.2: reg 0x10: [mem 0xfd304000-0xfd3040ff]
[    0.063551] pci 0000:00:16.2: supports D1 D2
[    0.063552] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.063630] pci 0000:00:18.0: [1022:1600] type 00 class 0x060000
[    0.063700] pci 0000:00:18.1: [1022:1601] type 00 class 0x060000
[    0.063767] pci 0000:00:18.2: [1022:1602] type 00 class 0x060000
[    0.063834] pci 0000:00:18.3: [1022:1603] type 00 class 0x060000
[    0.063903] pci 0000:00:18.4: [1022:1604] type 00 class 0x060000
[    0.063970] pci 0000:00:18.5: [1022:1605] type 00 class 0x060000
[    0.064074] pci 0000:01:00.0: [10de:0606] type 00 class 0x030000
[    0.064086] pci 0000:01:00.0: reg 0x10: [mem 0xfc000000-0xfcffffff]
[    0.064093] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.064099] pci 0000:01:00.0: reg 0x1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.064104] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.064109] pci 0000:01:00.0: reg 0x30: [mem 0xfd000000-0xfd01ffff pref]
[    0.064112] pci 0000:01:00.0: enabling Extended Tags
[    0.064239] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.064294] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.064296] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.064298] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.064335] pci 0000:02:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.064358] pci 0000:02:00.0: reg 0x10: [mem 0xfd200000-0xfd207fff 64bit]
[    0.064446] pci 0000:02:00.0: PME# supported from D3hot
[    0.064507] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.064563] pci 0000:00:04.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    0.064573] pci_bus 0000:03: extended config space not accessible
[    0.064676] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.064737] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    0.064738] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    0.064740] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df window] (subtractive decode)
[    0.064741] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.064742] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.064743] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff window] (subtractive decode)
[    0.064744] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xffffffff window] (subtractive decode)
[    0.064791] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.064816] pci 0000:04:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.064841] pci 0000:04:00.0: reg 0x18: [mem 0xfd104000-0xfd104fff 64bit pref]
[    0.064856] pci 0000:04:00.0: reg 0x20: [mem 0xfd100000-0xfd103fff 64bit pref]
[    0.064938] pci 0000:04:00.0: supports D1 D2
[    0.064939] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.065033] pci 0000:00:15.0: PCI bridge to [bus 04]
[    0.065089] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.065092] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    0.065109] pci_bus 0000:00: on NUMA node 0
[    0.065440] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.065551] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.065663] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.065775] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 10 11 14 15) *0
[    0.065876] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.065967] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.066059] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.066150] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.068026] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    0.068082] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.068152] pci 0000:01:00.0: vgaarb: bridge control possible
[    0.068207] vgaarb: loaded
[    0.068300] pps_core: LinuxPPS API ver. 1 registered
[    0.068353] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.068427] PTP clock support registered
[    0.068481] EDAC MC: Ver: 3.0.0
[    0.068599] PCI: Using ACPI for IRQ routing
[    0.073412] PCI: pci_cache_line_size set to 64 bytes
[    0.073454] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.073455] e820: reserve RAM buffer [mem 0xcd9a9000-0xcfffffff]
[    0.073456] e820: reserve RAM buffer [mem 0xcea44000-0xcfffffff]
[    0.073457] e820: reserve RAM buffer [mem 0xcf06e000-0xcfffffff]
[    0.073458] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    0.073458] e820: reserve RAM buffer [mem 0x32f000000-0x32fffffff]
[    0.073582] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.073637] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.076002] clocksource: Switched to clocksource tsc-early
[    0.086762] VFS: Disk quotas dquot_6.6.0
[    0.086830] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.086923] pnp: PnP ACPI init
[    0.087082] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.087142] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.087356] system 00:01: [io  0x040b] has been reserved
[    0.087423] system 00:01: [io  0x04d6] has been reserved
[    0.087478] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.087533] system 00:01: [io  0x0c14] has been reserved
[    0.087587] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.087642] system 00:01: [io  0x0c52] has been reserved
[    0.087696] system 00:01: [io  0x0c6c] has been reserved
[    0.087751] system 00:01: [io  0x0c6f] has been reserved
[    0.087805] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.087860] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.087915] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.087970] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.088025] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.088080] system 00:01: [io  0x0800-0x089f] has been reserved
[    0.088135] system 00:01: [io  0x0b20-0x0b3f] has been reserved
[    0.088190] system 00:01: [io  0x0900-0x090f] has been reserved
[    0.088248] system 00:01: [io  0x0910-0x091f] has been reserved
[    0.088303] system 00:01: [io  0xfe00-0xfefe] has been reserved
[    0.088359] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.088416] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.088472] system 00:01: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.088528] system 00:01: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.088613] system 00:01: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.088670] system 00:01: [mem 0xfed00000-0xfed00fff] could not be reserved
[    0.088726] system 00:01: [mem 0xff800000-0xffffffff] has been reserved
[    0.088785] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.088895] system 00:02: [io  0x0480-0x0481] has been reserved
[    0.088952] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089117] pnp 00:03: [dma 0 disabled]
[    0.089153] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.089175] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.089223] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.089281] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089316] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089437] system 00:07: [mem 0xfeb20000-0xfeb23fff] could not be reserved
[    0.089495] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089581] system 00:08: [mem 0xfec20000-0xfec200ff] could not be reserved
[    0.089641] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089735] pnp: PnP ACPI: found 9 devices
[    0.095866] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.095968] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.096023] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.096079] pci 0000:00:02.0:   bridge window [mem 0xfa000000-0xfd0fffff]
[    0.096136] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.096206] pci 0000:00:04.0: PCI bridge to [bus 02]
[    0.096263] pci 0000:00:04.0:   bridge window [mem 0xfd200000-0xfd2fffff]
[    0.096321] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.096382] pci 0000:00:15.0: PCI bridge to [bus 04]
[    0.096436] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.096493] pci 0000:00:15.0:   bridge window [mem 0xfd100000-0xfd1fffff]
[    0.096553] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.096554] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.096556] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.096557] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.096558] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.096559] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.096560] pci_bus 0000:00: resource 10 [mem 0xd0000000-0xffffffff window]
[    0.096561] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.096562] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfd0fffff]
[    0.096563] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.096564] pci_bus 0000:02: resource 1 [mem 0xfd200000-0xfd2fffff]
[    0.096565] pci_bus 0000:03: resource 4 [io  0x0000-0x03af window]
[    0.096566] pci_bus 0000:03: resource 5 [io  0x03e0-0x0cf7 window]
[    0.096567] pci_bus 0000:03: resource 6 [io  0x03b0-0x03df window]
[    0.096568] pci_bus 0000:03: resource 7 [io  0x0d00-0xffff window]
[    0.096569] pci_bus 0000:03: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.096570] pci_bus 0000:03: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.096571] pci_bus 0000:03: resource 10 [mem 0xd0000000-0xffffffff window]
[    0.096572] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.096573] pci_bus 0000:04: resource 1 [mem 0xfd100000-0xfd1fffff]
[    0.096621] NET: Registered protocol family 2
[    0.096786] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
[    0.096897] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.097254] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.097579] TCP: Hash tables configured (established 131072 bind 65536)
[    0.097681] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.097804] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.097956] NET: Registered protocol family 1
[    0.188317] pci 0000:00:12.0: quirk_usb_early_handoff+0x0/0x615 took 88172 usecs
[    0.276307] pci 0000:00:13.0: quirk_usb_early_handoff+0x0/0x615 took 85745 usecs
[    0.364302] pci 0000:00:14.5: quirk_usb_early_handoff+0x0/0x615 took 85747 usecs
[    0.452308] pci 0000:00:16.0: quirk_usb_early_handoff+0x0/0x615 took 85867 usecs
[    0.452501] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.452689] PCI: CLS 64 bytes, default 64
[    0.452718] Trying to unpack rootfs image as initramfs...
[    0.481141] Freeing initrd memory: 2284K
[    0.481624] iommu: Adding device 0000:00:00.0 to group 0
[    0.481748] iommu: Adding device 0000:00:02.0 to group 1
[    0.481867] iommu: Adding device 0000:00:04.0 to group 2
[    0.481989] iommu: Adding device 0000:00:11.0 to group 3
[    0.482112] iommu: Adding device 0000:00:12.0 to group 4
[    0.482177] iommu: Adding device 0000:00:12.2 to group 4
[    0.482306] iommu: Adding device 0000:00:13.0 to group 5
[    0.486247] iommu: Adding device 0000:00:13.2 to group 5
[    0.486367] iommu: Adding device 0000:00:14.0 to group 6
[    0.486492] iommu: Adding device 0000:00:14.2 to group 7
[    0.486611] iommu: Adding device 0000:00:14.3 to group 8
[    0.486739] iommu: Adding device 0000:00:14.4 to group 9
[    0.486869] iommu: Adding device 0000:00:14.5 to group 10
[    0.487004] iommu: Adding device 0000:00:15.0 to group 11
[    0.487129] iommu: Adding device 0000:00:16.0 to group 12
[    0.487196] iommu: Adding device 0000:00:16.2 to group 12
[    0.487318] iommu: Adding device 0000:01:00.0 to group 13
[    0.487433] iommu: Adding device 0000:02:00.0 to group 14
[    0.487498] iommu: Adding device 0000:04:00.0 to group 11
[    0.528010] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    0.528064] AMD-Vi: Interrupt remapping enabled
[    0.528196] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.529962] amd_uncore: AMD NB counters detected
[    0.530073] LVT offset 0 assigned for vector 0x400
[    0.530158] perf: AMD IBS detected (0x000000ff)
[    0.530536] Scanning for low memory corruption every 60 seconds
[    0.530941] Initialise system trusted keyrings
[    0.531022] workingset: timestamp_bits=46 max_order=22 bucket_order=0
[    0.532174] pstore: using deflate compression
[    0.532612] Key type asymmetric registered
[    0.532664] Asymmetric key parser 'x509' registered
[    0.532736] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.532845] io scheduler noop registered
[    0.532931] io scheduler cfq registered (default)
[    0.532985] io scheduler mq-deadline registered
[    0.533037] io scheduler kyber registered
[    0.533105] io scheduler bfq registered
[    0.536291] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.556716] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.557572] brd: module loaded
[    0.557806] i8042: PNP: No PS/2 controller found.
[    0.557939] NET: Registered protocol family 17
[    0.558368] microcode: CPU0: patch_level=0x06000822
[    0.558427] microcode: CPU1: patch_level=0x06000822
[    0.558510] microcode: CPU2: patch_level=0x06000822
[    0.558569] microcode: CPU3: patch_level=0x06000822
[    0.558645] microcode: Microcode Update Driver: v2.2.
[    0.558653] sched_clock: Marking stable (558641946, 0)->(640089762, -81447816)
[    0.558898] registered taskstats version 1
[    0.558956] Loading compiled-in X.509 certificates
[    0.559938] zswap: default zpool zbud not available
[    0.559993] zswap: pool creation failed
[    0.560219] hctosys: unable to open rtc device (rtc0)
[    0.561891] Freeing unused kernel memory: 1248K
[    0.582937] Write protecting the kernel read-only data: 14336k
[    0.583731] Freeing unused kernel memory: 2020K
[    0.587530] Freeing unused kernel memory: 1532K
[    0.607103] SCSI subsystem initialized
[    0.620083] libata version 3.00 loaded.
[    0.624128] ahci 0000:00:11.0: version 3.0
[    0.624297] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.624368] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.625083] scsi host0: ahci
[    0.625279] scsi host1: ahci
[    0.625451] scsi host2: ahci
[    0.625626] scsi host3: ahci
[    0.625803] scsi host4: ahci
[    0.625968] scsi host5: ahci
[    0.626088] ata1: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b100 irq 19
[    0.626168] ata2: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b180 irq 19
[    0.626237] ata3: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b200 irq 19
[    0.626306] ata4: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b280 irq 19
[    0.626374] ata5: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b300 irq 19
[    0.626443] ata6: SATA max UDMA/133 abar m1024@0xfd30b000 port 0xfd30b380 irq 19
[    0.940299] ata3: SATA link down (SStatus 0 SControl 300)
[    0.942123] ata4: SATA link down (SStatus 0 SControl 300)
[    0.944299] ata6: SATA link down (SStatus 0 SControl 300)
[    0.946123] ata5: SATA link down (SStatus 0 SControl 300)
[    1.108033] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.109709] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.110866] ata2.00: ATAPI: DRW-24D5MT, 1.00, max UDMA/133
[    1.112177] ata1.00: ATA-7: SAMSUNG HD300LJ, ZT100-12, max UDMA7
[    1.112233] ata1.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.112307] ata2.00: configured for UDMA/133
[    1.116489] ata1.00: configured for UDMA/133
[    1.116676] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD300LJ  0-12 PQ: 0 ANSI: 5
[    1.117576] scsi 1:0:0:0: CD-ROM            ASUS     DRW-24D5MT       1.00 PQ: 0 ANSI: 5
[    1.154150] sd 0:0:0:0: [sda] 586072368 512-byte logical blocks: (300 GB/279 GiB)
[    1.154224] sd 0:0:0:0: [sda] Write Protect is off
[    1.154278] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.154285] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.168793]  sda: sda1 sda2 sda3
[    1.169288] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.504088] tsc: Refined TSC clocksource calibration: 3800.108 MHz
[    1.504170] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6d8d7b0e4ce, max_idle_ns: 881590614467 ns
[    1.504287] clocksource: Switched to clocksource tsc
[    2.202607] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    2.446114] random: fast init done
[    4.053675] udev[154]: starting version 165
[    4.423046] acpi_cpufreq: overriding BIOS provided _PSD data
[    4.448090] MCE: In-kernel MCE decoding enabled.
[    4.465082] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.465195] ACPI: Power Button [PWRB]
[    4.465326] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.465408] ACPI: Power Button [PWRF]
[    4.544404] EDAC amd64: Node 0: DRAM ECC disabled.
[    4.544463] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    4.544463]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    4.544463]  (Note that use of the override may cause unknown side effects.)
[    4.549551] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.549629] piix4_smbus 0000:00:14.0: Using register 0x2c for SMBus port selection
[    4.549798] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    4.663005] sr 1:0:0:0: [sr0] scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.663079] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.663319] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.688642] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.688946] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.690880] rtc_cmos 00:04: RTC can wake from S4
[    4.691086] rtc_cmos 00:04: registered as rtc0
[    4.691166] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.709968] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.710031] r8169 0000:04:00.0: can't disable ASPM; OS doesn't have ASPM control
[    4.710727] r8169 0000:04:00.0 eth0: RTL8168evl/8111evl, d8:cb:8a:56:80:48, XID 2c900800, IRQ 27
[    4.710798] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    4.737518] ACPI: bus type USB registered
[    4.737844] usbcore: registered new interface driver usbfs
[    4.738041] usbcore: registered new interface driver hub
[    4.738132] usbcore: registered new device driver usb
[    4.901397] QUIRK: Enable AMD PLL fix
[    4.901413] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    4.901475] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 1
[    4.911136] xhci_hcd 0000:02:00.0: hcc params 0x0200f180 hci version 0x96 quirks 0x0000000000080000
[    4.911529] hub 1-0:1.0: USB hub found
[    4.911588] hub 1-0:1.0: 2 ports detected
[    4.911745] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    4.911802] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    4.911872] xhci_hcd 0000:02:00.0: Host supports USB 3.0  SuperSpeed
[    4.911967] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    4.916024] hub 2-0:1.0: USB hub found
[    4.916086] hub 2-0:1.0: 2 ports detected
[    4.939385] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.953465] ehci-pci: EHCI PCI platform driver
[    4.953661] ehci-pci 0000:00:12.2: EHCI Host Controller
[    4.953723] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 3
[    4.953796] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.953875] ehci-pci 0000:00:12.2: debug port 1
[    4.953964] ehci-pci 0000:00:12.2: irq 17, io mem 0xfd309000
[    4.968031] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    4.968317] hub 3-0:1.0: USB hub found
[    4.968383] hub 3-0:1.0: 5 ports detected
[    4.968702] ehci-pci 0000:00:13.2: EHCI Host Controller
[    4.968760] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 4
[    4.968830] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.968907] ehci-pci 0000:00:13.2: debug port 1
[    4.968983] ehci-pci 0000:00:13.2: irq 17, io mem 0xfd307000
[    4.988027] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    4.988286] hub 4-0:1.0: USB hub found
[    4.988352] hub 4-0:1.0: 5 ports detected
[    4.988682] ehci-pci 0000:00:16.2: EHCI Host Controller
[    4.988740] ehci-pci 0000:00:16.2: new USB bus registered, assigned bus number 5
[    4.988810] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    4.988915] ehci-pci 0000:00:16.2: debug port 1
[    4.988990] ehci-pci 0000:00:16.2: irq 17, io mem 0xfd304000
[    5.008079] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    5.008346] hub 5-0:1.0: USB hub found
[    5.008435] hub 5-0:1.0: 4 ports detected
[    5.022723] r8169 0000:04:00.0 eth6: renamed from eth0
[    5.044103] udev[159]: renamed network interface eth0 to eth6
[    5.113405] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.139573] ohci-pci: OHCI PCI platform driver
[    5.139761] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    5.139821] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 6
[    5.139919] ohci-pci 0000:00:12.0: irq 18, io mem 0xfd30a000
[    5.204170] hub 6-0:1.0: USB hub found
[    5.204234] hub 6-0:1.0: 5 ports detected
[    5.204530] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    5.204589] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 7
[    5.204676] ohci-pci 0000:00:13.0: irq 18, io mem 0xfd308000
[    5.224014] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC892: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[    5.224094] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    5.224165] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    5.224235] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    5.224292] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x11/0x1e
[    5.224348] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    5.224432] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[    5.224489] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[    5.224546] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[    5.239380] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input2
[    5.240089] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    5.240217] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input4
[    5.240377] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    5.240780] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    5.240910] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    5.241063] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    5.241463] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    5.268246] hub 7-0:1.0: USB hub found
[    5.268309] hub 7-0:1.0: 5 ports detected
[    5.268661] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    5.268721] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus number 8
[    5.268814] ohci-pci 0000:00:14.5: irq 18, io mem 0xfd306000
[    5.332236] hub 8-0:1.0: USB hub found
[    5.332298] hub 8-0:1.0: 2 ports detected
[    5.332554] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    5.332613] ohci-pci 0000:00:16.0: new USB bus registered, assigned bus number 9
[    5.332700] ohci-pci 0000:00:16.0: irq 18, io mem 0xfd305000
[    5.336494] pktcdvd: pktcdvd0: writer mapped to sr0
[    5.396220] hub 9-0:1.0: USB hub found
[    5.396281] hub 9-0:1.0: 4 ports detected
[    5.530241] Linux agpgart interface v0.103
[    5.579958] kvm: Nested Virtualization enabled
[    5.580021] kvm: Nested Paging enabled
[    5.616096] usb 6-2: new full-speed USB device number 2 using ohci-pci
[    5.650412] cryptd: max_cpu_qlen set to 1000
[    5.958762] AVX version of gcm_enc/dec engaged.
[    5.958818] AES CTR mode by8 optimization enabled
[    6.077885] Bluetooth: Core ver 2.22
[    6.077956] NET: Registered protocol family 31
[    6.078011] Bluetooth: HCI device and connection manager initialized
[    6.078073] Bluetooth: HCI socket layer initialized
[    6.078138] Bluetooth: L2CAP socket layer initialized
[    6.078198] Bluetooth: SCO socket layer initialized
[    6.180280] usbcore: registered new interface driver btusb
[    6.367446] MXM: GUID detected in BIOS
[    6.367707] nouveau 0000:01:00.0: NVIDIA G92 (092300a2)
[    6.367794] nouveau 0000:01:00.0: pci: MSI enabled
[    6.412104] usb 6-3: new low-speed USB device number 3 using ohci-pci
[    6.477094] nouveau 0000:01:00.0: bios: version 62.92.1f.00.09
[    6.497412] nouveau 0000:01:00.0: pci: pcie max speed: 5.0GT/s
[    6.497514] nouveau 0000:01:00.0: fb: 384 MiB GDDR3
[    6.558848] [TTM] Zone  kernel: Available graphics memory: 6114262 kiB
[    6.558914] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    6.558970] [TTM] Initializing pool allocator
[    6.559025] [TTM] Initializing DMA pool allocator
[    6.559091] nouveau 0000:01:00.0: DRM: VRAM: 384 MiB
[    6.559145] nouveau 0000:01:00.0: DRM: GART: 1048576 MiB
[    6.559201] nouveau 0000:01:00.0: DRM: TMDS table version 2.0
[    6.559256] nouveau 0000:01:00.0: DRM: DCB version 4.0
[    6.559310] nouveau 0000:01:00.0: DRM: DCB outp 00: 02000300 00000028
[    6.559366] nouveau 0000:01:00.0: DRM: DCB outp 01: 01000302 00000030
[    6.559422] nouveau 0000:01:00.0: DRM: DCB outp 02: 02011312 00020010
[    6.559478] nouveau 0000:01:00.0: DRM: DCB outp 03: 010223f1 00c0c083
[    6.559534] nouveau 0000:01:00.0: DRM: DCB conn 00: 00001030
[    6.559588] nouveau 0000:01:00.0: DRM: DCB conn 01: 00002130
[    6.559642] nouveau 0000:01:00.0: DRM: DCB conn 02: 00000210
[    6.559725] nouveau 0000:01:00.0: DRM: DCB conn 03: 00000211
[    6.559779] nouveau 0000:01:00.0: DRM: DCB conn 04: 00000213
[    6.559834] nouveau 0000:01:00.0: DRM: DCB conn 05: 00000362
[    6.562741] nouveau 0000:01:00.0: DRM: failed to create encoder 0/1/0: -19
[    6.562799] nouveau 0000:01:00.0: DRM: TV-1 has no encoders, removing
[    6.562888] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.562944] [drm] Driver supports precise vblank timestamp query.
[    6.564627] nouveau 0000:01:00.0: DRM: MM: using CRYPT for buffer copies
[    6.595404] nouveau 0000:01:00.0: DRM: allocated 1440x900 fb: 0x50000, bo (____ptrval____)
[    6.596074] fbcon: nouveaufb (fb0) is primary device
[    6.695593] Console: switching to colour frame buffer device 180x56
[    6.698870] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    6.708117] [drm] Initialized nouveau 1.3.1 20120801 for 0000:01:00.0 on minor 0
[    6.716855] hidraw: raw HID events driver (C) Jiri Kosina
[    6.760156] usbcore: registered new interface driver usbhid
[    6.760171] usbhid: USB HID core driver
[    6.864648] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb6/6-3/6-3:1.0/0003:046D:C077.0001/input/input10
[    6.864728] hid-generic 0003:046D:C077.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:12.0-3/input0
[    6.891870] mousedev: PS/2 mouse device common for all mice
[    7.172089] usb 6-4: new low-speed USB device number 4 using ohci-pci
[    7.375481] input: SONiX USB Keyboard as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.0/0003:0C45:760B.0002/input/input11
[    7.432323] hid-generic 0003:0C45:760B.0002: input,hidraw1: USB HID v1.11 Keyboard [SONiX USB Keyboard] on usb-0000:00:12.0-4/input0
[    7.436494] input: SONiX USB Keyboard Consumer Control as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.1/0003:0C45:760B.0003/input/input12
[    7.496349] input: SONiX USB Keyboard System Control as /devices/pci0000:00/0000:00:12.0/usb6/6-4/6-4:1.1/0003:0C45:760B.0003/input/input13
[    7.496493] hid-generic 0003:0C45:760B.0003: input,hidraw2: USB HID v1.11 Device [SONiX USB Keyboard] on usb-0000:00:12.0-4/input1
[    8.120994] Adding 1172476k swap on /dev/sda1.  Priority:-2 extents:1 across:1172476k FS
[    8.123148] EXT4-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
[    8.136517] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.144897] f71882fg: Found f71889a chip at 0x480, revision 49
[    9.145249] f71882fg f71882fg.1152: Fan: 1 is in duty-cycle mode
[    9.145926] f71882fg f71882fg.1152: Fan: 2 is in duty-cycle mode
[    9.146995] f71882fg f71882fg.1152: Fan: 3 is in duty-cycle mode
[    9.148060] f71882fg f71882fg.1152: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    9.189733] lp: driver loaded but no devices found
[    9.336156] SGI XFS with ACLs, security attributes, no debug enabled
[    9.370915] XFS (sda3): Mounting V4 Filesystem
[    9.564304] XFS (sda3): Ending clean mount
[    9.806176] random: dd: uninitialized urandom read (4096 bytes read)
[   11.601436] r8169 0000:04:00.0 eth6: link down
[   13.438652] r8169 0000:04:00.0 eth6: link up
[   13.493506] random: dhcpcd: uninitialized urandom read (120 bytes read)
[   19.863725] NET: Registered protocol family 10
[   19.864365] Segment Routing with IPv6
[   19.864819] random: cupsd: uninitialized urandom read (4096 bytes read)
[   20.771995] random: dbus-daemon: uninitialized urandom read (12 bytes read)
[   20.898330] random: dbus-daemon: uninitialized urandom read (12 bytes read)
[   21.485879] random: hald: uninitialized urandom read (10 bytes read)
[   21.485966] random: hald: uninitialized urandom read (12 bytes read)
[   25.150426] microcode: CPU0: new patch_level=0x06000852
[   25.165154] microcode: CPU2: new patch_level=0x06000852
[   25.165204] x86/CPU: CPU features have changed after loading microcode, but might not take effect.
[   25.165211] x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.
[   25.389708] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   25.389713] Bluetooth: HIDP socket layer initialized
[   25.553501] Bluetooth: RFCOMM TTY layer initialized
[   25.553508] Bluetooth: RFCOMM socket layer initialized
[   25.553512] Bluetooth: RFCOMM ver 1.11
[   25.561739] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   25.561740] Bluetooth: BNEP filters: protocol multicast
[   25.561744] Bluetooth: BNEP socket layer initialized
[   25.633491] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   27.961118] random: crng init done
[   27.961123] random: 2 urandom warning(s) missed due to ratelimiting
[   41.761935] start_kdeinit (1026): /proc/1026/oom_adj is deprecated, please use /proc/1026/oom_score_adj instead.
[  155.413067] PM: suspend entry (deep)
[  155.413072] PM: Syncing filesystems ... done.
[  155.585639] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  155.587297] OOM killer disabled.
[  155.587298] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[  155.588140] Suspending console(s) (use no_console_suspend to debug)
[  155.589284] serial 00:03: disabled
[  155.604577] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  155.604654] sd 0:0:0:0: [sda] Stopping disk
[  156.880770] ACPI: Preparing to enter system sleep state S3
[  156.881768] PM: Saving platform NVS memory
[  156.881791] Disabling non-boot CPUs ...
[  156.898533] smpboot: CPU 1 is now offline
[  156.921557] smpboot: CPU 2 is now offline
[  156.945488] smpboot: CPU 3 is now offline
[  156.947120] ACPI: Low-level resume complete
[  156.947147] PM: Restoring platform NVS memory
[  157.028351] LVT offset 0 assigned for vector 0x400
[  157.033816] microcode: CPU0: new patch_level=0x06000852
[  157.033850] Enabling non-boot CPUs ...
[  157.033875] x86: Booting SMP configuration:
[  157.033875] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  157.036289] TSC synchronization [CPU#0 -> CPU#1]:
[  157.036290] Measured 2419788018 cycles TSC warp between CPUs, turning off TSC clock.
[  157.036295] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[  157.036308] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
[  157.036309] sched_clock: Marking unstable (156953585938, -21861)<-(157117755281, -81447816)
[  157.673332]  cache: parent cpu1 should not be sleeping
[  157.673410] microcode: CPU1: patch_level=0x06000852
[  157.036725] CPU1 is up
[  157.590766] clocksource: Switched to clocksource hpet
[  157.590766] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  157.590778]  cache: parent cpu2 should not be sleeping
[  157.590778] microcode: CPU2: patch_level=0x06000822
[  157.590778] microcode: CPU2: new patch_level=0x06000852
[  157.590778] CPU2 is up
[  157.590778] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  157.590778]  cache: parent cpu3 should not be sleeping
[  157.590778] microcode: CPU3: patch_level=0x06000852
[  157.590778] CPU3 is up
[  157.590778] ACPI: Waking up from system sleep state S3
[  157.590778] usb usb1: root hub lost power or was reset
[  157.590778] usb usb2: root hub lost power or was reset
[  157.590778] serial 00:03: activated
[  157.590778] sd 0:0:0:0: [sda] Starting disk
[  157.590778] r8169 0000:04:00.0 eth6: link down
[  157.590778] ata5: SATA link down (SStatus 0 SControl 300)
[  157.590778] ata6: SATA link down (SStatus 0 SControl 300)
[  157.590778] ata4: SATA link down (SStatus 0 SControl 300)
[  157.590778] ata3: SATA link down (SStatus 0 SControl 300)
[  157.590778] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  157.590778] ata2.00: configured for UDMA/133
[  157.590778] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  158.136092] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  158.616134] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  158.805151] usb 6-2: device descriptor read/all, error -62
[  158.933983] r8169 0000:04:00.0 eth6: link up
[  158.996080] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  159.187686] OOM killer enabled.
[  159.187687] Restarting tasks ... done.
[  159.189830] PM: suspend exit
[  163.680093] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  163.688373] ata1.00: configured for UDMA/133
[  195.388553] PM: suspend entry (deep)
[  195.388556] PM: Syncing filesystems ... done.
[  195.515383] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  195.517241] OOM killer disabled.
[  195.517242] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  195.518599] Suspending console(s) (use no_console_suspend to debug)
[  195.520222] serial 00:03: disabled
[  195.536194] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  195.536313] sd 0:0:0:0: [sda] Stopping disk
[  196.589006] ACPI: Preparing to enter system sleep state S3
[  196.589960] PM: Saving platform NVS memory
[  196.589984] Disabling non-boot CPUs ...
[  196.606513] smpboot: CPU 1 is now offline
[  196.629717] smpboot: CPU 2 is now offline
[  196.653640] smpboot: CPU 3 is now offline
[  196.653676] ACPI: Low-level resume complete
[  196.653676] PM: Restoring platform NVS memory
[  196.653676] LVT offset 0 assigned for vector 0x400
[  196.653676] microcode: CPU0: new patch_level=0x06000852
[  196.659239] Enabling non-boot CPUs ...
[  196.659263] x86: Booting SMP configuration:
[  196.659264] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  196.659924]  cache: parent cpu1 should not be sleeping
[  196.660017] microcode: CPU1: patch_level=0x06000852
[  196.660104] CPU1 is up
[  196.660119] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  196.660735]  cache: parent cpu2 should not be sleeping
[  196.660820] microcode: CPU2: patch_level=0x06000822
[  196.664673] microcode: CPU2: new patch_level=0x06000852
[  196.666284] CPU2 is up
[  196.666298] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  196.666969]  cache: parent cpu3 should not be sleeping
[  196.667047] microcode: CPU3: patch_level=0x06000852
[  196.667161] CPU3 is up
[  196.670044] ACPI: Waking up from system sleep state S3
[  196.709266] usb usb1: root hub lost power or was reset
[  196.709268] usb usb2: root hub lost power or was reset
[  196.709960] serial 00:03: activated
[  196.724795] sd 0:0:0:0: [sda] Starting disk
[  196.865682] r8169 0000:04:00.0 eth6: link down
[  197.023467] ata3: SATA link down (SStatus 0 SControl 300)
[  197.027490] ata6: SATA link down (SStatus 0 SControl 300)
[  197.031411] ata5: SATA link down (SStatus 0 SControl 300)
[  197.031540] ata4: SATA link down (SStatus 0 SControl 300)
[  197.052078] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  197.184093] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  197.201108] ata2.00: configured for UDMA/133
[  197.241194] usb 6-2: device descriptor read/all, error -62
[  197.536102] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  198.156092] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  198.636076] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  198.673536] r8169 0000:04:00.0 eth6: link up
[  198.827794] OOM killer enabled.
[  198.827794] Restarting tasks ... done.
[  198.828111] PM: suspend exit
[  202.964084] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  202.972470] ata1.00: configured for UDMA/133
[  215.841002] PM: suspend entry (deep)
[  215.841006] PM: Syncing filesystems ... done.
[  216.010885] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  216.012715] OOM killer disabled.
[  216.012717] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  216.014089] Suspending console(s) (use no_console_suspend to debug)
[  216.015472] serial 00:03: disabled
[  216.040176] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  216.040275] sd 0:0:0:0: [sda] Stopping disk
[  217.069053] ACPI: Preparing to enter system sleep state S3
[  217.070714] PM: Saving platform NVS memory
[  217.070748] Disabling non-boot CPUs ...
[  217.086999] smpboot: CPU 1 is now offline
[  217.114895] smpboot: CPU 2 is now offline
[  217.137668] smpboot: CPU 3 is now offline
[  217.137789] ACPI: Low-level resume complete
[  217.137789] PM: Restoring platform NVS memory
[  217.137789] LVT offset 0 assigned for vector 0x400
[  217.137789] microcode: CPU0: new patch_level=0x06000852
[  217.143338] Enabling non-boot CPUs ...
[  217.143362] x86: Booting SMP configuration:
[  217.143363] smpboot: Booting Node 0 Processor 1 APIC 0x11
[  217.144052]  cache: parent cpu1 should not be sleeping
[  217.144133] microcode: CPU1: patch_level=0x06000852
[  217.144216] CPU1 is up
[  217.144232] smpboot: Booting Node 0 Processor 2 APIC 0x12
[  217.144848]  cache: parent cpu2 should not be sleeping
[  217.144929] microcode: CPU2: patch_level=0x06000822
[  217.148787] microcode: CPU2: new patch_level=0x06000852
[  217.150399] CPU2 is up
[  217.150413] smpboot: Booting Node 0 Processor 3 APIC 0x13
[  217.151095]  cache: parent cpu3 should not be sleeping
[  217.151173] microcode: CPU3: patch_level=0x06000852
[  217.151289] CPU3 is up
[  217.154163] ACPI: Waking up from system sleep state S3
[  217.193349] serial 00:03: activated
[  217.196118] usb usb1: root hub lost power or was reset
[  217.196123] usb usb2: root hub lost power or was reset
[  217.198164] sd 0:0:0:0: [sda] Starting disk
[  217.329696] r8169 0000:04:00.0 eth6: link down
[  217.511413] ata6: SATA link down (SStatus 0 SControl 300)
[  217.511477] ata4: SATA link down (SStatus 0 SControl 300)
[  217.511523] ata3: SATA link down (SStatus 0 SControl 300)
[  217.511553] ata5: SATA link down (SStatus 0 SControl 300)
[  217.536077] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  217.672081] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  217.689119] ata2.00: configured for UDMA/133
[  217.725103] usb 6-2: device descriptor read/all, error -62
[  218.048098] usb 6-4: reset low-speed USB device number 4 using ohci-pci
[  218.668097] usb 6-3: reset low-speed USB device number 3 using ohci-pci
[  219.115488] r8169 0000:04:00.0 eth6: link up
[  219.148082] usb 6-2: reset full-speed USB device number 2 using ohci-pci
[  219.339703] OOM killer enabled.
[  219.339703] Restarting tasks ... done.
[  219.342072] PM: suspend exit
[  223.808087] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  223.816424] ata1.00: configured for UDMA/133

--Boundary-00=_anMIbKDgw16xVrv--
