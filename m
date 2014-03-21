From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [SCSI] WARNING: CPU: 7 PID: 1484 at mm/page_alloc.c:2513
 __alloc_pages_nodemask+0x1df/0x986()
Date: Fri, 21 Mar 2014 09:35:25 +0800
Message-ID: <20140321013525.GA11229@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760401AbaCUBfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 21:35:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hannes,

We noticed the below warnings on

commit beba1fc005a56a0597d01d3f381e533427856f5d ("[SCSI] Add EVPD page 0x83 to sysfs")

[   13.210464] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.229569]  sdb: sdb1 sdb2
[   13.230918] sd 1:0:0:0: [sdb] Attached SCSI disk
[   13.272657] igb 0000:01:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[   13.276044] ------------[ cut here ]------------
[   13.276051] WARNING: CPU: 7 PID: 1484 at mm/page_alloc.c:2513 __alloc_pages_nodemask+0x1df/0x986()
[   13.276053] Modules linked in:
[   13.276056] CPU: 7 PID: 1484 Comm: kworker/u50:5 Not tainted 3.14.0-rc7-wl-ath-03670-g3c3af80 #1
[   13.276057] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010                        
[   13.276062] Workqueue: events_unbound async_run_entry_fn                
[   13.276065]  0000000000000000 ffff880417b2ba18 ffffffff81a48792 0000000000000000
[   13.276067]  ffff880417b2ba50 ffffffff810de155 ffffffff8118c3ab 00000000001040d0
[   13.276069]  0000000000000000 0000000000000002 0000000000000000 ffff880417b2ba60
[   13.276070] Call Trace:
[   13.276076]  [<ffffffff81a48792>] dump_stack+0x4d/0x66
[   13.276079]  [<ffffffff810de155>] warn_slowpath_common+0x7f/0x98
[   13.276082]  [<ffffffff8118c3ab>] ? __alloc_pages_nodemask+0x1df/0x986
[   13.276085]  [<ffffffff810de21c>] warn_slowpath_null+0x1a/0x1c
[   13.276087]  [<ffffffff8118c3ab>] __alloc_pages_nodemask+0x1df/0x986
[   13.276091]  [<ffffffff814eb871>] ? __freed_request+0x42/0x96
[   13.276093]  [<ffffffff814eb90f>] ? freed_request+0x4a/0x69
[   13.276095]  [<ffffffff814ec163>] ? __blk_put_request+0xfe/0x15e
[   13.276099]  [<ffffffff811c217d>] alloc_pages_current+0xc7/0xe2 
[   13.276102]  [<ffffffff811889cd>] __get_free_pages+0xe/0x3b    
[   13.276104]  [<ffffffff811a1c48>] kmalloc_order_trace+0x2b/0x98
[   13.276108]  [<ffffffff811cb530>] __kmalloc+0x38/0x1f2
[   13.276112]  [<ffffffff815d0362>] scsi_attach_vpd+0x36/0x29a
[   13.276114]  [<ffffffff815d90ea>] scsi_probe_and_add_lun+0x8f6/0xa2b
[   13.276117]  [<ffffffff815d947b>] __scsi_add_device+0xd3/0x10f
[   13.276121]  [<ffffffff816c1ee0>] ata_scsi_scan_host+0x82/0x16e  
[   13.276124]  [<ffffffff816be336>] async_port_probe+0x4a/0x4f   
[   13.276127]  [<ffffffff810ffeae>] async_run_entry_fn+0x5f/0x115
[   13.276130]  [<ffffffff810f5c72>] process_one_work+0x1f7/0x396 
[   13.276131]  [<ffffffff810f62fc>] worker_thread+0x1e8/0x2e2
[   13.276133]  [<ffffffff810f6114>] ? rescuer_thread+0x2d4/0x2d4
[   13.276136]  [<ffffffff810fb273>] kthread+0xdb/0xe3
[   13.276139]  [<ffffffff810fb198>] ? kthread_create_on_node+0x16f/0x16f
[   13.276142]  [<ffffffff81a5743c>] ret_from_fork+0x7c/0xb0
[   13.276144]  [<ffffffff810fb198>] ? kthread_create_on_node+0x16f/0x16f
[   13.276150] ---[ end trace 3c57e8c3743333ed ]---
[   13.277434] scsi 5:0:0:0: Attached scsi generic sg2 type 5

Full dmesg is attached.

Thanks,
Fengguang

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-wl-ath-03670-g3c3af80 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Thu Mar 20 11:13:21 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/vmlinuz-3.14.0-rc7-wl-ath-03670-g3c3af80 kconfig=x86_64-lkp commit=3c3af80e2af6f37845464e6879a792496d9485e4 modules_initrd=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/modules.cgz RESULT_ROOT=/lkp/result/lkp-ws02/fake/boot/1/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ram
 disk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 base 0400000000 mask FFC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02668000, 0x02668fff] PGTABLE
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x73007000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140214/tbfadt-271)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/vmlinuz-3.14.0-rc7-wl-ath-03670-g3c3af80 kconfig=x86_64-lkp commit=3c3af80e2af6f37845464e6879a792496d9485e4 modules_initrd=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/modules.cgz RESULT_ROOT=/lkp/result/lkp-ws02/fake/boot/1/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 pro
 mpt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16198092K/16765248K available (10610K kernel code, 1255K rwdata, 4280K rodata, 1440K init, 1760K bss, 567156K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-wl-ath-03670-g3c3af80 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Thu Mar 20 11:13:21 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/vmlinuz-3.14.0-rc7-wl-ath-03670-g3c3af80 kconfig=x86_64-lkp commit=3c3af80e2af6f37845464e6879a792496d9485e4 modules_initrd=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/modules.cgz RESULT_ROOT=/lkp/result/lkp-ws02/fake/boot/1/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ram
 disk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 base 0400000000 mask FFC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02668000, 0x02668fff] PGTABLE
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x73007000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140214/tbfadt-271)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/vmlinuz-3.14.0-rc7-wl-ath-03670-g3c3af80 kconfig=x86_64-lkp commit=3c3af80e2af6f37845464e6879a792496d9485e4 modules_initrd=/kernel/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/modules.cgz RESULT_ROOT=/lkp/result/lkp-ws02/fake/boot/1/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 pro
 mpt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16198092K/16765248K available (10610K kernel code, 1255K rwdata, 4280K rodata, 1440K init, 1760K bss, 567156K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2800.025 MHz processor
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.05 BogoMIPS (lpj=11200100)
[    0.010826] pid_max: default: 32768 minimum: 301
[    0.015501] ACPI: Core revision 20140214
[    0.022573] ACPI: All ACPI Tables successfully acquired
[    0.028973] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.039636] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.048221] Mount-cache hash table entries: 256
[    0.053230] Initializing cgroup subsys memory
[    0.057855] Initializing cgroup subsys devices
[    0.062554] Initializing cgroup subsys freezer
[    0.067256] Initializing cgroup subsys blkio
[    0.071784] Initializing cgroup subsys perf_event
[    0.076749] Initializing cgroup subsys hugetlb
[    0.081482] CPU: Physical Processor ID: 0
[    0.085749] CPU: Processor Core ID: 0
[    0.089678] mce: CPU supports 9 MCE banks
[    0.093950] CPU0: Thermal LVT vector (0xfa) already installed
[    0.099961] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.099961] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.099961] tlb_flushall_shift: 6
[    0.115765] Freeing SMP alternatives memory: 44K (ffffffff824a3000 - ffffffff824ae000)
[    0.125247] ftrace: allocating 40578 entries in 159 pages
[    0.145674] Getting VERSION: 1060015
[    0.149509] Getting VERSION: 1060015
[    0.153344] Getting ID: 0
[    0.156222] Getting ID: 0
[    0.159104] Switched APIC routing to physical flat.
[    0.164239] masked ExtINT on CPU#0
[    0.168420] ENABLING IO-APIC IRQs
[    0.171992] init IO_APIC IRQs
[    0.175218]  apic 0 pin 0 not connected
[    0.179315] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.187704] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.196099] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.204494] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.212883] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.221272] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.229667] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.238056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.246451] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.254839] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.263409] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.271970] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.280538] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.289100] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.297669] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.306230]  apic 0 pin 16 not connected
[    0.310407]  apic 0 pin 17 not connected
[    0.314590]  apic 0 pin 18 not connected
[    0.318770]  apic 0 pin 19 not connected
[    0.322951]  apic 0 pin 20 not connected
[    0.327133]  apic 0 pin 21 not connected
[    0.331313]  apic 0 pin 22 not connected
[    0.335492]  apic 0 pin 23 not connected
[    0.339673]  apic 2 pin 0 not connected
[    0.343767]  apic 2 pin 1 not connected
[    0.347861]  apic 2 pin 2 not connected
[    0.351956]  apic 2 pin 3 not connected
[    0.356050]  apic 2 pin 4 not connected
[    0.360144]  apic 2 pin 5 not connected
[    0.364237]  apic 2 pin 6 not connected
[    0.368332]  apic 2 pin 7 not connected
[    0.372426]  apic 2 pin 8 not connected
[    0.376520]  apic 2 pin 9 not connected
[    0.380614]  apic 2 pin 10 not connected
[    0.384795]  apic 2 pin 11 not connected
[    0.388974]  apic 2 pin 12 not connected
[    0.393156]  apic 2 pin 13 not connected
[    0.397336]  apic 2 pin 14 not connected
[    0.401517]  apic 2 pin 15 not connected
[    0.405698]  apic 2 pin 16 not connected
[    0.409879]  apic 2 pin 17 not connected
[    0.414060]  apic 2 pin 18 not connected
[    0.418241]  apic 2 pin 19 not connected
[    0.422421]  apic 2 pin 20 not connected
[    0.426601]  apic 2 pin 21 not connected
[    0.430782]  apic 2 pin 22 not connected
[    0.434965]  apic 2 pin 23 not connected
[    0.439143]  apic 3 pin 0 not connected
[    0.443238]  apic 3 pin 1 not connected
[    0.447332]  apic 3 pin 2 not connected
[    0.451425]  apic 3 pin 3 not connected
[    0.455521]  apic 3 pin 4 not connected
[    0.459614]  apic 3 pin 5 not connected
[    0.463707]  apic 3 pin 6 not connected
[    0.467803]  apic 3 pin 7 not connected
[    0.471896]  apic 3 pin 8 not connected
[    0.475991]  apic 3 pin 9 not connected
[    0.480085]  apic 3 pin 10 not connected
[    0.484266]  apic 3 pin 11 not connected
[    0.488445]  apic 3 pin 12 not connected
[    0.492626]  apic 3 pin 13 not connected
[    0.496807]  apic 3 pin 14 not connected
[    0.500987]  apic 3 pin 15 not connected
[    0.505170]  apic 3 pin 16 not connected
[    0.509350]  apic 3 pin 17 not connected
[    0.513530]  apic 3 pin 18 not connected
[    0.517711]  apic 3 pin 19 not connected
[    0.521892]  apic 3 pin 20 not connected
[    0.526073]  apic 3 pin 21 not connected
[    0.530252]  apic 3 pin 22 not connected
[    0.534435]  apic 3 pin 23 not connected
[    0.538614]  apic 4 pin 0 not connected
[    0.542709]  apic 4 pin 1 not connected
[    0.546802]  apic 4 pin 2 not connected
[    0.550896]  apic 4 pin 3 not connected
[    0.554991]  apic 4 pin 4 not connected
[    0.559084]  apic 4 pin 5 not connected
[    0.563178]  apic 4 pin 6 not connected
[    0.567273]  apic 4 pin 7 not connected
[    0.571368]  apic 4 pin 8 not connected
[    0.575462]  apic 4 pin 9 not connected
[    0.579555]  apic 4 pin 10 not connected
[    0.583736]  apic 4 pin 11 not connected
[    0.587916]  apic 4 pin 12 not connected
[    0.592097]  apic 4 pin 13 not connected
[    0.596277]  apic 4 pin 14 not connected
[    0.600458]  apic 4 pin 15 not connected
[    0.604639]  apic 4 pin 16 not connected
[    0.608821]  apic 4 pin 17 not connected
[    0.613001]  apic 4 pin 18 not connected
[    0.617182]  apic 4 pin 19 not connected
[    0.621363]  apic 4 pin 20 not connected
[    0.625544]  apic 4 pin 21 not connected
[    0.629722]  apic 4 pin 22 not connected
[    0.633904]  apic 4 pin 23 not connected
[    0.638216] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.684200] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (fam: 06, model: 2c, stepping: 01)
[    0.694768] Using local APIC timer interrupts.
[    0.694768] calibrating APIC timer ...
[    0.810560] ... lapic delta = 833353
[    0.814395] ... PM-Timer delta = 357949
[    0.818490] ... PM-Timer result ok
[    0.822150] ..... delta 833353
[    0.825463] ..... mult: 35792238
[    0.828951] ..... calibration result: 533345
[    0.833477] ..... CPU clock speed is 2800.0239 MHz.
[    0.838611] ..... host bus clock speed is 133.1345 MHz.
[    0.844105] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.853169] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.860308] ... version:                3
[    0.864574] ... bit width:              48
[    0.868929] ... generic registers:      4
[    0.873196] ... value mask:             0000ffffffffffff
[    0.878763] ... max period:             000000007fffffff
[    0.884333] ... fixed-purpose events:   3
[    0.888600] ... event mask:             000000070000000f
[    0.895693] x86: Booting SMP configuration:
[    0.900138] .... node  #0, CPUs:        #1
[    0.915259] masked ExtINT on CPU#1
[    0.918874] CPU1: Thermal LVT vector (0xfa) already installed
[    0.926809]   #2
[    0.939554] masked ExtINT on CPU#2
[    0.943166] CPU2: Thermal LVT vector (0xfa) already installed
[    0.951104]   #3
[    0.964059] masked ExtINT on CPU#3
[    0.967671] CPU3: Thermal LVT vector (0xfa) already installed
[    0.975603]   #4
[    0.988343] masked ExtINT on CPU#4
[    0.991961] CPU4: Thermal LVT vector (0xfa) already installed
[    0.999883]   #5
[    1.012631] masked ExtINT on CPU#5
[    1.016246] CPU5: Thermal LVT vector (0xfa) already installed
[    1.024193] 
[    1.025951] .... node  #1, CPUs:    #6
[    1.040664] masked ExtINT on CPU#6
[    1.044288] CPU6: Thermal LVT vector (0xfa) already installed
[    1.148469]   #7
[    1.161213] masked ExtINT on CPU#7
[    1.164840] CPU7: Thermal LVT vector (0xfa) already installed
[    1.172732]   #8
[    1.185474] masked ExtINT on CPU#8
[    1.189102] CPU8: Thermal LVT vector (0xfa) already installed
[    1.196985]   #9
[    1.209942] masked ExtINT on CPU#9
[    1.213569] CPU9: Thermal LVT vector (0xfa) already installed
[    1.221456]  #10
[    1.234203] masked ExtINT on CPU#10
[    1.237915] CPU10: Thermal LVT vector (0xfa) already installed
[    1.245914]  #11
[    1.258663] masked ExtINT on CPU#11
[    1.262374] CPU11: Thermal LVT vector (0xfa) already installed
[    1.270375] 
[    1.272125] .... node  #0, CPUs:   #12
[    1.286840] masked ExtINT on CPU#12
[    1.290543] CPU12: Thermal LVT vector (0xfa) already installed
[    1.298597]  #13
[    1.311343] masked ExtINT on CPU#13
[    1.315044] CPU13: Thermal LVT vector (0xfa) already installed
[    1.322989]  #14
[    1.335738] masked ExtINT on CPU#14
[    1.339440] CPU14: Thermal LVT vector (0xfa) already installed
[    1.347485]  #15
[    1.360439] masked ExtINT on CPU#15
[    1.364138] CPU15: Thermal LVT vector (0xfa) already installed
[    1.372088]  #16
[    1.384831] masked ExtINT on CPU#16
[    1.388531] CPU16: Thermal LVT vector (0xfa) already installed
[    1.396578]  #17
[    1.409322] masked ExtINT on CPU#17
[    1.413025] CPU17: Thermal LVT vector (0xfa) already installed
[    1.420984] 
[    1.422737] .... node  #1, CPUs:   #18
[    1.437452] masked ExtINT on CPU#18
[    1.441163] CPU18: Thermal LVT vector (0xfa) already installed
[    1.449181]  #19
[    1.461922] masked ExtINT on CPU#19
[    1.465631] CPU19: Thermal LVT vector (0xfa) already installed
[    1.473637]  #20
[    1.486383] masked ExtINT on CPU#20
[    1.490095] CPU20: Thermal LVT vector (0xfa) already installed
[    1.498101]  #21
[    1.511061] masked ExtINT on CPU#21
[    1.514769] CPU21: Thermal LVT vector (0xfa) already installed
[    1.522783]  #22
[    1.535528] masked ExtINT on CPU#22
[    1.539241] CPU22: Thermal LVT vector (0xfa) already installed
[    1.547241]  #23
[    1.559992] masked ExtINT on CPU#23
[    1.563707] CPU23: Thermal LVT vector (0xfa) already installed
[    1.571661] x86: Booted up 2 nodes, 24 CPUs
[    1.576318] smpboot: Total of 24 processors activated (134403.32 BogoMIPS)
[    1.615691] devtmpfs: initialized
[    1.624967] PM: Registering ACPI NVS region [mem 0xbf30b000-0xbf38afff] (524288 bytes)
[    1.633372] PM: Registering ACPI NVS region [mem 0xbf3a1000-0xbf3a1fff] (4096 bytes)
[    1.641588] PM: Registering ACPI NVS region [mem 0xbf3b3000-0xbf3b5fff] (12288 bytes)
[    1.649888] PM: Registering ACPI NVS region [mem 0xbf3de000-0xbf3defff] (4096 bytes)
[    1.658102] PM: Registering ACPI NVS region [mem 0xbf416000-0xbf417fff] (8192 bytes)
[    1.672698] PM: Registering ACPI NVS region [mem 0xbf420000-0xbf420fff] (4096 bytes)
[    1.680913] PM: Registering ACPI NVS region [mem 0xbf423000-0xbf42afff] (32768 bytes)
[    1.689213] PM: Registering ACPI NVS region [mem 0xbf454000-0xbf656fff] (2109440 bytes)
[    1.699022] xor: measuring software checksum speed
[    1.740818]    prefetch64-sse: 12691.000 MB/sec
[    1.784853]    generic_sse: 11159.000 MB/sec
[    1.789387] xor: using function: prefetch64-sse (12691.000 MB/sec)
[    1.795837] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.803047] NET: Registered protocol family 16
[    1.808382] cpuidle: using governor ladder
[    1.812738] cpuidle: using governor menu
[    1.817336] ACPI: bus type PCI registered
[    1.821610] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.828399] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.838179] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.861778] PCI: Using configuration type 1 for base access
[    1.877894] bio: create slab <bio-0> at 0
[    1.948986] raid6: sse2x1    7317 MB/s
[    2.021044] raid6: sse2x2    8656 MB/s
[    2.093103] raid6: sse2x4    9503 MB/s
[    2.097113] raid6: using algorithm sse2x4 (9503 MB/s)
[    2.102421] raid6: using ssse3x2 recovery algorithm
[    2.107629] ACPI: Added _OSI(Module Device)
[    2.112079] ACPI: Added _OSI(Processor Device)
[    2.116786] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.121748] ACPI: Added _OSI(Processor Aggregator Device)
[    2.129166] ACPI: Executed 1 blocks of module-level executable AML code
[    2.138172] \_SB_:_OSC evaluation returned wrong type
[    2.143485] _OSC request data:1 1f 
[    2.157184] ACPI: SSDT 0x00000000BF416018 001494 (v01 AMI    IST      00000001 MSFT 03000001)
[    2.166879] ACPI: Dynamic OEM Table Load:
[    2.171282] ACPI: SSDT 0x0000000000000000 001494 (v01 AMI    IST      00000001 MSFT 03000001)
[    2.182684] ACPI: Interpreter enabled
[    2.186618] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    2.196442] ACPI: (supports S0 S1 S3 S4 S5)
[    2.200888] ACPI: Using IOAPIC for interrupt routing
[    2.206225] HEST: Table parsing has been initialized.
[    2.211541] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.222228] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.234982] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.241434] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.250268] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    2.259002] PCI host bridge to bus 0000:00
[    2.263357] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.269106] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.275551] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.281996] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.289133] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    2.296281] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    2.302599] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.309055] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    2.315379] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.321838] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    2.328152] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.334605] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    2.340919] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    2.347376] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    2.353696] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.360152] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    2.366475] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.372938] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    2.379221] pci 0000:00:13.0: reg 0x10: [mem 0xfbe24000-0xfbe24fff]
[    2.385789] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    2.392237] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    2.398629] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    2.405021] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    2.411411] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    2.417790] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    2.424072] pci 0000:00:16.0: reg 0x10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    2.431252] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    2.437534] pci 0000:00:16.1: reg 0x10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    2.444713] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    2.450995] pci 0000:00:16.2: reg 0x10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    2.458176] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    2.464458] pci 0000:00:16.3: reg 0x10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    2.471636] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    2.477920] pci 0000:00:16.4: reg 0x10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    2.485097] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    2.491381] pci 0000:00:16.5: reg 0x10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    2.498558] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    2.504834] pci 0000:00:16.6: reg 0x10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    2.512014] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    2.518296] pci 0000:00:16.7: reg 0x10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    2.525479] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    2.531784] pci 0000:00:1a.0: reg 0x20: [io  0xf0c0-0xf0df]
[    2.537703] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.543681] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    2.549989] pci 0000:00:1a.2: reg 0x20: [io  0xf0a0-0xf0bf]
[    2.555910] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    2.561894] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    2.568178] pci 0000:00:1a.7: reg 0x10: [mem 0xfbe23000-0xfbe233ff]
[    2.574786] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.581189] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    2.587172] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    2.593510] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.599915] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.605899] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    2.612235] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.618636] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    2.624618] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    2.630925] pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
[    2.636843] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.642822] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    2.649132] pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
[    2.655048] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    2.661029] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    2.667338] pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
[    2.673254] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    2.679244] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    2.685534] pci 0000:00:1d.7: reg 0x10: [mem 0xfbe22000-0xfbe223ff]
[    2.692142] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.698545] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    2.704524] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    2.710875] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    2.716862] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    2.723204] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0400-0x047f]: address conflict with ACPI CPU throttle [io  0x0410-0x0415]
[    2.735332] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    2.742729] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    2.750769] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    2.758810] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    2.766858] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    2.775017] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    2.781306] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    2.787143] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    2.792979] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    2.798819] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    2.804664] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    2.810501] pci 0000:00:1f.2: reg 0x24: [mem 0xfbe21000-0xfbe217ff]
[    2.817066] pci 0000:00:1f.2: PME# supported from D3hot
[    2.822650] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    2.828931] pci 0000:00:1f.3: reg 0x10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    2.835995] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    2.841997] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[    2.848281] pci 0000:01:00.0: reg 0x10: [mem 0xfbaa0000-0xfbabffff]
[    2.854817] pci 0000:01:00.0: reg 0x14: [mem 0xfba80000-0xfba9ffff]
[    2.861358] pci 0000:01:00.0: reg 0x18: [io  0xe020-0xe03f]
[    2.867203] pci 0000:01:00.0: reg 0x1c: [mem 0xfbb44000-0xfbb47fff]
[    2.873754] pci 0000:01:00.0: reg 0x30: [mem 0xfba60000-0xfba7ffff pref]
[    2.880766] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.887152] pci 0000:01:00.0: reg 0x184: [mem 0xfbb20000-0xfbb23fff 64bit]
[    2.894308] pci 0000:01:00.0: reg 0x190: [mem 0xfbb00000-0xfbb03fff 64bit]
[    2.901526] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[    2.907808] pci 0000:01:00.1: reg 0x10: [mem 0xfba40000-0xfba5ffff]
[    2.914345] pci 0000:01:00.1: reg 0x14: [mem 0xfba20000-0xfba3ffff]
[    2.920885] pci 0000:01:00.1: reg 0x18: [io  0xe000-0xe01f]
[    2.926731] pci 0000:01:00.1: reg 0x1c: [mem 0xfbb40000-0xfbb43fff]
[    2.933283] pci 0000:01:00.1: reg 0x30: [mem 0xfba00000-0xfba1ffff pref]
[    2.940294] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    2.946676] pci 0000:01:00.1: reg 0x184: [mem 0xfbae0000-0xfbae3fff 64bit]
[    2.953826] pci 0000:01:00.1: reg 0x190: [mem 0xfbac0000-0xfbac3fff 64bit]
[    2.965808] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.971302] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.977659] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    2.984770] pci 0000:00:03.0: PCI bridge to [bus 03]
[    2.990072] pci 0000:00:05.0: PCI bridge to [bus 04]
[    2.995394] pci 0000:00:07.0: PCI bridge to [bus 05]
[    3.000705] pci 0000:06:00.0: [8086:0329] type 01 class 0x060400
[    3.006986] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    3.014175] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    3.020609] pci 0000:06:00.2: [8086:032a] type 01 class 0x060400
[    3.026892] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    3.034076] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    3.040500] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.057366] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    3.062851] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    3.069210] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.076344] pci 0000:06:00.0: PCI bridge to [bus 07]
[    3.081643] pci 0000:08:01.0: [8086:1229] type 00 class 0x020000
[    3.087932] pci 0000:08:01.0: reg 0x10: [mem 0xfb900000-0xfb900fff]
[    3.094473] pci 0000:08:01.0: reg 0x14: [io  0xd000-0xd03f]
[    3.100319] pci 0000:08:01.0: reg 0x18: [mem 0xfb800000-0xfb8fffff]
[    3.106878] pci 0000:08:01.0: reg 0x30: [mem 0xfb700000-0xfb7fffff pref]
[    3.113865] pci 0000:08:01.0: supports D1 D2
[    3.118397] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.125362] pci 0000:06:00.2: PCI bridge to [bus 08]
[    3.130593] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    3.136951] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.144089] pci 0000:09:00.0: [1000:0058] type 00 class 0x010000
[    3.150371] pci 0000:09:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    3.156218] pci 0000:09:00.0: reg 0x14: [mem 0xfb610000-0xfb613fff 64bit]
[    3.163278] pci 0000:09:00.0: reg 0x1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    3.170342] pci 0000:09:00.0: reg 0x30: [mem 0xfb400000-0xfb5fffff pref]
[    3.177359] pci 0000:09:00.0: supports D1 D2
[    3.181948] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.192433] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    3.197659] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    3.204016] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    3.211071] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    3.219371] pci 0000:0a:00.0: [197b:2368] type 00 class 0x010185
[    3.225666] pci 0000:0a:00.0: reg 0x10: [io  0xb040-0xb047]
[    3.231514] pci 0000:0a:00.0: reg 0x14: [io  0xb030-0xb033]
[    3.237358] pci 0000:0a:00.0: reg 0x18: [io  0xb020-0xb027]
[    3.243206] pci 0000:0a:00.0: reg 0x1c: [io  0xb010-0xb013]
[    3.249051] pci 0000:0a:00.0: reg 0x20: [io  0xb000-0xb00f]
[    3.254910] pci 0000:0a:00.0: reg 0x30: [mem 0xfbd00000-0xfbd0ffff pref]
[    3.262003] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.272484] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    3.277717] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    3.284074] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    3.291129] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.299408] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    3.305694] pci 0000:0b:01.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
[    3.312670] pci 0000:0b:01.0: reg 0x14: [io  0xa000-0xa0ff]
[    3.318514] pci 0000:0b:01.0: reg 0x18: [mem 0xfbc20000-0xfbc2ffff]
[    3.325076] pci 0000:0b:01.0: reg 0x30: [mem 0xfbc00000-0xfbc1ffff pref]
[    3.332064] pci 0000:0b:01.0: supports D1 D2
[    3.336677] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive decode)
[    3.343733] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    3.350092] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    3.357145] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    3.365364] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    3.373751] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    3.382140] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.391230] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    3.400787] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.409865] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.418953] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.428026] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    3.437109] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.446425] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.455721] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.465028] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.474122] ACPI: Enabled 2 GPEs in block 00 to 3F
[    3.479645] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    3.488225] vgaarb: loaded
[    3.491195] vgaarb: bridge control possible 0000:0b:01.0
[    3.496993] SCSI subsystem initialized
[    3.501192] libata version 3.00 loaded.
[    3.505498] ACPI: bus type USB registered
[    3.509868] usbcore: registered new interface driver usbfs
[    3.515668] usbcore: registered new interface driver hub
[    3.521322] usbcore: registered new device driver usb
[    3.526790] pps_core: LinuxPPS API ver. 1 registered
[    3.532023] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.541675] PTP clock support registered
[    3.546091] EDAC MC: Ver: 3.0.0
[    3.549752] PCI: Using ACPI for IRQ routing
[    3.560625] PCI: Discovered peer bus fe
[    3.564732] PCI: root bus fe: using default resources
[    3.570049] PCI: Probing PCI hardware (bus fe)
[    3.574840] PCI host bridge to bus 0000:fe
[    3.579211] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    3.585661] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    3.592983] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    3.601395] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[    3.607794] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[    3.614176] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[    3.620558] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[    3.626943] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[    3.633325] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[    3.639707] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[    3.646093] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[    3.652476] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[    3.658864] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[    3.665242] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[    3.671626] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[    3.678013] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[    3.684393] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[    3.690788] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[    3.697171] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[    3.703558] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[    3.709939] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[    3.716322] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[    3.722711] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[    3.729096] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[    3.735475] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[    3.741859] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[    3.748241] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[    3.754674] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    3.761562] PCI: Discovered peer bus ff
[    3.765666] PCI: root bus ff: using default resources
[    3.770983] PCI: Probing PCI hardware (bus ff)
[    3.775771] PCI host bridge to bus 0000:ff
[    3.780137] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    3.786588] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    3.793909] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    3.802312] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    3.808692] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    3.815087] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    3.821467] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    3.827855] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    3.834236] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    3.840621] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    3.847021] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    3.853443] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    3.859839] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    3.866239] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    3.872644] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    3.879041] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    3.885436] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    3.891844] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    3.898250] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    3.904646] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    3.911046] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    3.917450] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    3.923848] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    3.930252] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    3.936654] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    3.943053] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    3.949453] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    3.955874] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    3.962512] PCI: pci_cache_line_size set to 64 bytes
[    3.967911] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    3.974186] e820: reserve RAM buffer [mem 0xbf30b000-0xbfffffff]
[    3.980464] e820: reserve RAM buffer [mem 0xbf3de000-0xbfffffff]
[    3.986745] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    3.994102] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.999838] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    4.008001] Switched to clocksource hpet
[    4.027570] pnp: PnP ACPI init
[    4.030922] ACPI: bus type PNP registered
[    4.035382] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    4.042280] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    4.049173] system 00:00: [mem 0xfe000000-0xfe9fffff] has been reserved
[    4.056061] system 00:00: [mem 0xfea00000-0xfea0001f] has been reserved
[    4.062947] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
[    4.069836] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    4.077068] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
[    4.083956] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.091361] system 00:01: [io  0x0290-0x029f] has been reserved
[    4.097558] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.104669] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    4.119578] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    4.127345] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    4.136018] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    4.144183] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    4.152595] pnp 00:04: [dma 0 disabled]
[    4.156836] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.163933] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    4.172350] pnp 00:05: [dma 0 disabled]
[    4.176603] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.183564] pnp 00:06: [dma 4]
[    4.186980] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.193800] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    4.202295] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.209198] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.216183] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    4.222382] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.229455] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    4.238137] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.245315] system 00:0b: [io  0x0400-0x047f] could not be reserved
[    4.251862] system 00:0b: [io  0x1180-0x119f] has been reserved
[    4.258054] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    4.264596] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    4.271480] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
[    4.278715] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    4.285603] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.292898] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.299930] pnp: PnP ACPI: found 13 devices
[    4.304391] ACPI: bus type PNP unregistered
[    4.320706] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alignment
[    4.328124] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    4.333628] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    4.339998] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    4.347068] pci 0000:00:03.0: PCI bridge to [bus 03]
[    4.352310] pci 0000:00:05.0: PCI bridge to [bus 04]
[    4.357556] pci 0000:00:07.0: PCI bridge to [bus 05]
[    4.362795] pci 0000:06:00.0: PCI bridge to [bus 07]
[    4.368044] pci 0000:06:00.2: PCI bridge to [bus 08]
[    4.373287] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    4.379652] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.386716] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    4.392211] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    4.398578] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.405642] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    4.410877] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    4.417246] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    4.424305] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.432539] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    4.437774] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    4.444143] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    4.451212] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.459444] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    4.464679] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    4.471049] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    4.478107] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.486341] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.492183] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.498030] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.504573] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    4.511110] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.516957] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    4.523497] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.529342] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.535883] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    4.541729] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.548269] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    4.554115] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    4.560653] pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.568365] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    4.574210] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    4.580750] pci_bus 0000:0a: resource 2 [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.588454] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    4.594300] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    4.600839] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.608550] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    4.614398] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    4.620243] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    4.626783] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    4.633328] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    4.639179] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    4.645893] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    4.651738] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    4.658525] NET: Registered protocol family 2
[    4.663544] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    4.671873] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.679062] TCP: Hash tables configured (established 131072 bind 65536)
[    4.685994] TCP: reno registered
[    4.689538] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    4.696034] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    4.703102] NET: Registered protocol family 1
[    4.707928] RPC: Registered named UNIX socket transport module.
[    4.714120] RPC: Registered udp transport module.
[    4.719106] RPC: Registered tcp transport module.
[    4.724084] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.731067] IOAPIC[0]: Set routing entry (0-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    4.740011] IOAPIC[0]: Set routing entry (0-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.748944] IOAPIC[0]: Set routing entry (0-18 -> 0x61 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    4.757890] IOAPIC[0]: Set routing entry (0-23 -> 0x71 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    4.767695] pci 0000:06:00.0: rerouting interrupts for [8086:0329]
[    4.774155] pci 0000:06:00.2: rerouting interrupts for [8086:032a]
[    4.780639] pci 0000:0b:01.0: Boot video device
[    4.785524] PCI: CLS 64 bytes, default 64
[    4.789867] Trying to unpack rootfs image as initramfs...
[   11.650878] Freeing initrd memory: 212912K (ffff880073007000 - ffff88007fff3000)
[   11.658771] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   11.665482] software IO TLB [mem 0xbb30b000-0xbf30b000] (64MB) mapped at [ffff8800bb30b000-ffff8800bf30afff]
[   11.676786] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   11.686245] Scanning for low memory corruption every 60 seconds
[   11.693614] SSE version of gcm_enc/dec engaged.
[   11.699108] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[   11.705647] AVX or AES-NI instructions are not detected.
[   11.711228] AVX instructions are not detected.
[   11.715943] AVX instructions are not detected.
[   11.720652] AVX instructions are not detected.
[   11.725363] AVX instructions are not detected.
[   11.732419] futex hash table entries: 8192 (order: 7, 524288 bytes)
[   11.777705] bounce pool size: 64 pages
[   11.781734] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.795081] VFS: Disk quotas dquot_6.5.2
[   11.799421] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   11.808292] NFS: Registering the id_resolver key type
[   11.813631] Key type id_resolver registered
[   11.818087] Key type id_legacy registered
[   11.822366] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   11.829337] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.836546] ROMFS MTD (C) 2007 Red Hat, Inc.
[   11.841322] fuse init (API version 7.22)
[   11.845871] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   11.856972] msgmni has been set to 32052
[   11.863727] NET: Registered protocol family 38
[   11.868450] Key type asymmetric registered
[   11.872996] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   11.880961] io scheduler noop registered
[   11.885153] io scheduler deadline registered
[   11.889706] io scheduler cfq registered (default)
[   11.895191] IOAPIC[3]: Set routing entry (4-4 -> 0x81 -> IRQ 76 Mode:1 Active:1 Dest:0)
[   11.903721] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[   11.909654] IOAPIC[3]: Set routing entry (4-0 -> 0xa1 -> IRQ 72 Mode:1 Active:1 Dest:0)
[   11.918182] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[   11.924126] IOAPIC[3]: Set routing entry (4-2 -> 0xc1 -> IRQ 74 Mode:1 Active:1 Dest:0)
[   11.932648] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[   11.938584] IOAPIC[3]: Set routing entry (4-6 -> 0xe1 -> IRQ 78 Mode:1 Active:1 Dest:0)
[   11.947117] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[   11.953067] IOAPIC[3]: Set routing entry (4-8 -> 0x42 -> IRQ 80 Mode:1 Active:1 Dest:0)
[   11.961593] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[   11.967531] IOAPIC[0]: Set routing entry (0-17 -> 0x62 -> IRQ 17 Mode:1 Active:1 Dest:0)
[   11.976147] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[   11.982184] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[   11.988121] aer 0000:00:01.0:pcie02: service driver aer loaded
[   11.994256] aer 0000:00:03.0:pcie02: service driver aer loaded
[   12.000387] aer 0000:00:05.0:pcie02: service driver aer loaded
[   12.012919] aer 0000:00:07.0:pcie02: service driver aer loaded
[   12.019053] aer 0000:00:09.0:pcie02: service driver aer loaded
[   12.025221] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   12.032459] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   12.039258] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[   12.046059] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   12.053042] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   12.060277] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   12.067258] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[   12.074492] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[   12.081475] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[   12.088710] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[   12.095694] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[   12.102928] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[   12.109723] pci 0000:06:00.2: Signaling PME through PCIe PME interrupt
[   12.116525] pci 0000:08:01.0: Signaling PME through PCIe PME interrupt
[   12.123326] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[   12.130321] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   12.137559] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[   12.144360] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   12.151354] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[   12.158584] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[   12.165386] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[   12.172416] ioapic: probe of 0000:00:13.0 failed with error -22
[   12.178670] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.184650] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[   12.195867] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[   12.202505] pciehp 0000:00:1c.4:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[   12.213717] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[   12.220386] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   12.227275] intel_idle: MWAIT substates: 0x1120
[   12.232077] intel_idle: v0.4 model 0x2C
[   12.236180] intel_idle: lapic_timer_reliable_states 0xffffffff
[   12.243838] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[   12.252680] ACPI: Sleep Button [SLPB]
[   12.256727] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[   12.265566] ACPI: Power Button [PWRB]
[   12.269607] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   12.277494] ACPI: Power Button [PWRF]
[   12.281702] ERST: Can not request [mem 0xbf3b303f-0xbf3b503e] for ERST.
[   12.330931] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
[   12.340293] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
[   12.348954] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
[   12.357877] ghes_edac: If you find incorrect reports, please contact your hardware vendor
[   12.366535] ghes_edac: to correct its BIOS.
[   12.370984] ghes_edac: This system has 18 DIMM sockets.
[   12.377162] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[   12.387302] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[   12.397268] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
[   12.407105] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[   12.413680] EINJ: Error INJection is initialized.
[   12.418949] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.445924] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   12.474211] 00:05: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   12.483643] Non-volatile memory driver v1.3
[   12.507337] brd: module loaded
[   12.515633] loop: module loaded
[   12.519277] lkdtm: No crash points registered, enable through debugfs
[   12.528364] Loading iSCSI transport class v2.0-870.
[   12.535223] Adaptec aacraid driver 1.2-0[30300]-ms
[   12.540498] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   12.548005] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.02-k.
[   12.557091] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   12.565097] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   12.572528] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[   12.579588] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   12.586205] RocketRAID 3xxx/4xxx Controller driver v1.8
[   12.592565] ahci 0000:00:1f.2: version 3.0
[   12.597161] ahci 0000:00:1f.2: irq 119 for MSI/MSI-X
[   12.602469] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   12.611142] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs 
[   12.662847] scsi0 : ahci
[   12.666114] scsi1 : ahci
[   12.669360] scsi2 : ahci
[   12.672597] scsi3 : ahci
[   12.675842] scsi4 : ahci
[   12.679018] scsi5 : ahci
[   12.682056] ata1: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21100 irq 119
[   12.683098] tsc: Refined TSC clocksource calibration: 2800.096 MHz
[   12.696471] ata2: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21180 irq 119
[   12.704441] ata3: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21200 irq 119
[   12.712414] ata4: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21280 irq 119
[   12.720383] ata5: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21300 irq 119
[   12.728355] ata6: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21380 irq 119
[   12.737425] tun: Universal TUN/TAP device driver, 1.6
[   12.742753] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   12.749541] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   12.756811] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   12.762485] Copyright (c) 2007 Atheros Corporation.
[   12.767992] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   12.775034] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   12.775034]   http://www.scyld.com/network/drivers.html
[   12.788183] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   12.795682] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   12.802045] e100: Copyright(c) 1999-2006 Intel Corporation
[   12.807879] e100 0000:08:01.0: PCI IRQ 48 -> rerouted to legacy IRQ 16
[   12.839489] e100 0000:08:01.0 eth0: addr 0xfb900000, irq 16, MAC addr 00:0e:0c:7f:c7:3e
[   12.848122] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   12.855443] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   12.861608] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   12.867713] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   12.874048] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[   12.881279] igb: Copyright (c) 2007-2014 Intel Corporation.
[   12.887588] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[   12.892747] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[   12.897906] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[   12.903059] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[   12.908217] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[   12.913371] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[   12.918525] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[   12.923689] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[   12.928846] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[   12.934081] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[   12.939237] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[   12.944397] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[   12.949547] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[   12.954699] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[   12.959853] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[   12.965006] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[   12.970157] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[   12.975319] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[   13.055400] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.061866] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.068376] ata5: SATA link down (SStatus 0 SControl 300)
[   13.074060] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.080567] ata3: SATA link down (SStatus 0 SControl 300)
[   13.086253] ata6.00: ATAPI: Slimtype DVD A  DS8A2S, 6P5D, max UDMA/100
[   13.093065] ata4: SATA link down (SStatus 0 SControl 300)
[   13.098900] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
[   13.105960] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   13.113664] ata6.00: configured for UDMA/100
[   13.120227] ata1.00: configured for UDMA/133
[   13.125088] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
[   13.131455] ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[   13.131456] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   13.147239] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   13.147987] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.161028] sd 0:0:0:0: [sda] Write Protect is off
[   13.166093] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.171440] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.182872] igb 0000:01:00.0: added PHC on eth1
[   13.187686] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   13.189809] ata2.00: configured for UDMA/133
[   13.189988] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[   13.190877] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[   13.190932] sd 1:0:0:0: [sdb] Write Protect is off
[   13.190934] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   13.190956] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.191458] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   13.195074] scsi 5:0:0:0: CD-ROM            Slimtype DVD A  DS8A2S    6P5D PQ: 0 ANSI: 5
[   13.208643]  sda: sda1 sda2 sda3
[   13.210464] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.229569]  sdb: sdb1 sdb2
[   13.230918] sd 1:0:0:0: [sdb] Attached SCSI disk
[   13.272657] igb 0000:01:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[   13.276044] ------------[ cut here ]------------
[   13.276051] WARNING: CPU: 7 PID: 1484 at mm/page_alloc.c:2513 __alloc_pages_nodemask+0x1df/0x986()
[   13.276053] Modules linked in:
[   13.276056] CPU: 7 PID: 1484 Comm: kworker/u50:5 Not tainted 3.14.0-rc7-wl-ath-03670-g3c3af80 #1
[   13.276057] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[   13.276062] Workqueue: events_unbound async_run_entry_fn
[   13.276065]  0000000000000000 ffff880417b2ba18 ffffffff81a48792 0000000000000000
[   13.276067]  ffff880417b2ba50 ffffffff810de155 ffffffff8118c3ab 00000000001040d0
[   13.276069]  0000000000000000 0000000000000002 0000000000000000 ffff880417b2ba60
[   13.276070] Call Trace:
[   13.276076]  [<ffffffff81a48792>] dump_stack+0x4d/0x66
[   13.276079]  [<ffffffff810de155>] warn_slowpath_common+0x7f/0x98
[   13.276082]  [<ffffffff8118c3ab>] ? __alloc_pages_nodemask+0x1df/0x986
[   13.276085]  [<ffffffff810de21c>] warn_slowpath_null+0x1a/0x1c
[   13.276087]  [<ffffffff8118c3ab>] __alloc_pages_nodemask+0x1df/0x986
[   13.276091]  [<ffffffff814eb871>] ? __freed_request+0x42/0x96
[   13.276093]  [<ffffffff814eb90f>] ? freed_request+0x4a/0x69
[   13.276095]  [<ffffffff814ec163>] ? __blk_put_request+0xfe/0x15e
[   13.276099]  [<ffffffff811c217d>] alloc_pages_current+0xc7/0xe2
[   13.276102]  [<ffffffff811889cd>] __get_free_pages+0xe/0x3b
[   13.276104]  [<ffffffff811a1c48>] kmalloc_order_trace+0x2b/0x98
[   13.276108]  [<ffffffff811cb530>] __kmalloc+0x38/0x1f2
[   13.276112]  [<ffffffff815d0362>] scsi_attach_vpd+0x36/0x29a
[   13.276114]  [<ffffffff815d90ea>] scsi_probe_and_add_lun+0x8f6/0xa2b
[   13.276117]  [<ffffffff815d947b>] __scsi_add_device+0xd3/0x10f
[   13.276121]  [<ffffffff816c1ee0>] ata_scsi_scan_host+0x82/0x16e
[   13.276124]  [<ffffffff816be336>] async_port_probe+0x4a/0x4f
[   13.276127]  [<ffffffff810ffeae>] async_run_entry_fn+0x5f/0x115
[   13.276130]  [<ffffffff810f5c72>] process_one_work+0x1f7/0x396
[   13.276131]  [<ffffffff810f62fc>] worker_thread+0x1e8/0x2e2
[   13.276133]  [<ffffffff810f6114>] ? rescuer_thread+0x2d4/0x2d4
[   13.276136]  [<ffffffff810fb273>] kthread+0xdb/0xe3
[   13.276139]  [<ffffffff810fb198>] ? kthread_create_on_node+0x16f/0x16f
[   13.276142]  [<ffffffff81a5743c>] ret_from_fork+0x7c/0xb0
[   13.276144]  [<ffffffff810fb198>] ? kthread_create_on_node+0x16f/0x16f
[   13.276150] ---[ end trace 3c57e8c3743333ed ]---
[   13.277434] scsi 5:0:0:0: Attached scsi generic sg2 type 5
[   13.510845] igb 0000:01:00.0: eth1: PBA No: Unknown
[   13.515990] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.524258] IOAPIC[3]: Set routing entry (4-16 -> 0x44 -> IRQ 88 Mode:1 Active:1 Dest:0)
[   13.533095] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[   13.538257] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[   13.543415] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[   13.548577] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[   13.553735] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[   13.558888] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[   13.564041] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[   13.569193] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[   13.574345] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   13.579570] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[   13.584730] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[   13.589888] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[   13.595041] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[   13.600194] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[   13.605358] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[   13.610517] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[   13.615680] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[   13.620836] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   13.684275] Switched to clocksource tsc
[   13.819520] igb 0000:01:00.1: added PHC on eth2
[   13.824336] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   13.831515] igb 0000:01:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[   13.838925] igb 0000:01:00.1: eth2: PBA No: Unknown
[   13.844110] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.852305] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   13.860538] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   13.866653] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   13.874060] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   13.880189] sky2: driver version 1.30
[   13.884842] usbcore: registered new interface driver catc
[   13.890566] usbcore: registered new interface driver kaweth
[   13.896416] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   13.904350] usbcore: registered new interface driver pegasus
[   13.910345] usbcore: registered new interface driver rtl8150
[   13.916376] usbcore: registered new interface driver asix
[   13.922127] usbcore: registered new interface driver ax88179_178a
[   13.928587] usbcore: registered new interface driver cdc_ether
[   13.934789] usbcore: registered new interface driver cdc_eem
[   13.940811] usbcore: registered new interface driver dm9601
[   13.946764] usbcore: registered new interface driver smsc75xx
[   13.952880] usbcore: registered new interface driver smsc95xx
[   13.958983] usbcore: registered new interface driver gl620a
[   13.964916] usbcore: registered new interface driver net1080
[   13.970927] usbcore: registered new interface driver plusb
[   13.976765] usbcore: registered new interface driver rndis_host
[   13.983054] usbcore: registered new interface driver cdc_subset
[   13.989330] usbcore: registered new interface driver zaurus
[   13.995257] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   14.003234] usbcore: registered new interface driver int51x1
[   14.009247] usbcore: registered new interface driver ipheth
[   14.015178] usbcore: registered new interface driver sierra_net
[   14.021464] usbcore: registered new interface driver cdc_ncm
[   14.027404] Fusion MPT base driver 3.04.20
[   14.031773] Copyright (c) 1999-2008 LSI Corporation
[   14.036932] Fusion MPT SPI Host driver 3.04.20
[   14.041739] Fusion MPT FC Host driver 3.04.20
[   14.046470] Fusion MPT SAS Host driver 3.04.20
[   14.051690] mptbase: ioc0: Initiating bringup
[   14.760851] ioc0: LSISAS1068E B2: Capabilities={Initiator}
[   34.072659] scsi6 : ioc0: LSISAS1068E B2, FwRev=01120000h, Ports=1, MaxQ=511, IRQ=16
[   34.113126] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x5000155d25e3423f)
[   34.214677] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 36, phy 0, sas_addr 0x5000155d25e34200
[   34.228252] scsi 6:0:0:0: Direct-Access     ATA      ST31000528AS     CC35 PQ: 0 ANSI: 5
[   34.242554] sd 6:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   34.242750] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   34.256958] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 1, sas_addr 0x5000c500022c41a5
[   34.268822] scsi 6:0:1:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.281925] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   34.303485] sd 6:0:1:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.304086] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 2, sas_addr 0x5000c50013005f59
[   34.306107] scsi 6:0:2:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   34.309649] sd 6:0:0:0: [sdc] Write Protect is off
[   34.309652] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   34.310884] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   34.311109] sd 6:0:2:0: [sde] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.311967] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   34.313217] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 3, sas_addr 0x5000c500130fe681
[   34.314075] sd 6:0:2:0: [sde] Write Protect is off
[   34.314078] sd 6:0:2:0: [sde] Mode Sense: b3 00 10 08
[   34.315108] scsi 6:0:3:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   34.315584] sd 6:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.341000] sd 6:0:3:0: [sdf] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.341120] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   34.343341] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 15, phy 4, sas_addr 0x5000c500022d25dd
[   34.343382] sd 6:0:3:0: [sdf] Write Protect is off
[   34.343386] sd 6:0:3:0: [sdf] Mode Sense: b3 00 10 08
[   34.344885] sd 6:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.344953]  sde: sde1 sde2
[   34.366472] scsi 6:0:4:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.371119] sd 6:0:2:0: [sde] Attached SCSI disk
[   34.371316] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   34.393288] sd 6:0:4:0: [sdg] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.393944] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 14, phy 5, sas_addr 0x5000c500022d09b5
[   34.394261]  sdf: sdf1 sdf2
[   34.395791] sd 6:0:4:0: [sdg] Write Protect is off
[   34.395794] sd 6:0:4:0: [sdg] Mode Sense: b3 00 10 08
[   34.396264] scsi 6:0:5:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.397521] sd 6:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.419052]  sdc: sdc1 sdc2 sdc3
[   34.420619] sd 6:0:3:0: [sdf] Attached SCSI disk
[   34.421753] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   34.443256] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 6, sas_addr 0x5000c500022c3f65
[   34.464983] sd 6:0:5:0: [sdh] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.465075] scsi 6:0:6:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.466931] sd 6:0:5:0: [sdh] Write Protect is off
[   34.466935] sd 6:0:5:0: [sdh] Mode Sense: b3 00 10 08
[   34.469187]  sdg: sdg1 sdg2
[   34.469296] sd 6:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.470041] sd 6:0:6:0: Attached scsi generic sg9 type 0
[   34.510991] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 17, phy 7, sas_addr 0x5000c500022d2a0d
[   34.534491] sd 6:0:6:0: [sdi] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.555819] scsi 6:0:7:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.557453] sd 6:0:6:0: [sdi] Write Protect is off
[   34.557457] sd 6:0:6:0: [sdi] Mode Sense: b3 00 10 08
[   34.559880] sd 6:0:0:0: [sdc] Attached SCSI disk
[   34.560229] sd 6:0:6:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.560743] sd 6:0:7:0: Attached scsi generic sg10 type 0
[   34.579708] sd 6:0:4:0: [sdg] Attached SCSI disk
[   34.604176] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 16, phy 8, sas_addr 0x5000c500022d0f35
[   34.604217]  sdh: sdh1 sdh2
[   34.604264] sd 6:0:7:0: [sdj] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.647351] scsi 6:0:8:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   34.648312] sd 6:0:7:0: [sdj] Write Protect is off
[   34.648315] sd 6:0:7:0: [sdj] Mode Sense: b3 00 10 08
[   34.650192] sd 6:0:7:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.652432] sd 6:0:8:0: Attached scsi generic sg11 type 0
[   34.692471] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 33, phy 9, sas_addr 0x5000c500130e21cd
[   34.694606] sd 6:0:5:0: [sdh] Attached SCSI disk
[   34.694867]  sdi: sdi1 sdi2
[   34.694928] sd 6:0:8:0: [sdk] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.695317] scsi 6:0:9:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   34.738621] sd 6:0:8:0: [sdk] Write Protect is off
[   34.738624] sd 6:0:8:0: [sdk] Mode Sense: b3 00 10 08
[   34.740358] sd 6:0:8:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.742598] sd 6:0:9:0: Attached scsi generic sg12 type 0
[   34.763584] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 10, sas_addr 0x5000c500130f4f4d
[   34.763648] sd 6:0:9:0: [sdl] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.763965] sd 6:0:6:0: [sdi] Attached SCSI disk
[   34.785310]  sdj: sdj1 sdj2
[   34.785819] scsi 6:0:10:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   34.786313] sd 6:0:9:0: [sdl] Write Protect is off
[   34.786316] sd 6:0:9:0: [sdl] Mode Sense: b3 00 10 08
[   34.808648] sd 6:0:9:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.811633] sd 6:0:10:0: Attached scsi generic sg13 type 0
[   34.832336] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 35, phy 11, sas_addr 0x5000c50017cc2595
[   34.832376] sd 6:0:10:0: [sdm] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.851112]  sdk: sdk1 sdk2
[   34.851801] sd 6:0:1:0: [sdd] Write Protect is off
[   34.851805] sd 6:0:1:0: [sdd] Mode Sense: b3 00 10 08
[   34.852152] sd 6:0:10:0: [sdm] Write Protect is off
[   34.852155] sd 6:0:10:0: [sdm] Mode Sense: b3 00 10 08
[   34.852835] scsi 6:0:11:0: Direct-Access     SEAGATE  ST3300657SS      0006 PQ: 0 ANSI: 5
[   34.852882] sd 6:0:7:0: [sdj] Attached SCSI disk
[   34.853491] sd 6:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.853735] sd 6:0:10:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.896897] random: nonblocking pool is initialized
[   34.896983]  sdl: sdl1 sdl2
[   34.898794] sd 6:0:11:0: Attached scsi generic sg14 type 0
[   34.919544] sd 6:0:11:0: [sdn] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   34.920222] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 34, phy 24, sas_addr 0x5000155d25e3423e
[   34.921575] sd 6:0:11:0: [sdn] Write Protect is off
[   34.921578] sd 6:0:11:0: [sdn] Mode Sense: bb 00 10 08
[   34.922852] sd 6:0:11:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   34.924045] sd 6:0:9:0: [sdl] Attached SCSI disk
[   34.924096]  sdm: sdm1 sdm2
[   34.924330] scsi 6:0:12:0: Enclosure         PROMISE  2U-SAS-12-S BP   0301 PQ: 0 ANSI: 5
[   34.924781]  sdd: sdd1 sdd2
[   34.949770]  sdn: sdn1 sdn2
[   34.951306] sd 6:0:10:0: [sdm] Attached SCSI disk
[   34.952017] sd 6:0:1:0: [sdd] Attached SCSI disk
[   34.975568] scsi 6:0:12:0: Attached scsi generic sg15 type 13
[   34.976819] sd 6:0:11:0: [sdn] Attached SCSI disk
[   34.978800] Fusion MPT misc device (ioctl) driver 3.04.20
[   34.979033] mptctl: Registered with Fusion MPT base driver
[   34.979035] mptctl: /dev/mptctl @ (major,minor=10,220)
[   34.979566] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   34.979570] ehci-pci: EHCI PCI platform driver
[   34.979857] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   34.980101] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   34.980118] ehci-pci 0000:00:1a.7: debug port 1
[   34.984042] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   34.984068] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbe23000
[   34.993316] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   34.994128] hub 1-0:1.0: USB hub found
[   34.994141] hub 1-0:1.0: 6 ports detected
[   34.994631] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   34.995009] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   34.995026] ehci-pci 0000:00:1d.7: debug port 1
[   34.998945] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   34.998964] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   35.009285] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   35.010181] hub 2-0:1.0: USB hub found
[   35.010196] hub 2-0:1.0: 6 ports detected
[   35.010737] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   35.010743] ohci-pci: OHCI PCI platform driver
[   35.010980] uhci_hcd: USB Universal Host Controller Interface driver
[   35.011214] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   35.011597] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   35.011606] uhci_hcd 0000:00:1a.0: detected 2 ports
[   35.011632] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   35.012323] hub 3-0:1.0: USB hub found
[   35.012338] hub 3-0:1.0: 2 ports detected
[   35.012706] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   35.013023] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   35.013032] uhci_hcd 0000:00:1a.2: detected 2 ports
[   35.013070] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   35.013703] hub 4-0:1.0: USB hub found
[   35.013715] hub 4-0:1.0: 2 ports detected
[   35.014077] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   35.014361] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   35.014370] uhci_hcd 0000:00:1d.0: detected 2 ports
[   35.014396] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   35.015020] hub 5-0:1.0: USB hub found
[   35.015032] hub 5-0:1.0: 2 ports detected
[   35.015386] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   35.015649] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   35.015658] uhci_hcd 0000:00:1d.1: detected 2 ports
[   35.015682] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   35.016281] hub 6-0:1.0: USB hub found
[   35.016294] hub 6-0:1.0: 2 ports detected
[   35.016647] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   35.016867] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   35.016876] uhci_hcd 0000:00:1d.2: detected 2 ports
[   35.016900] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   35.017487] hub 7-0:1.0: USB hub found
[   35.017507] hub 7-0:1.0: 2 ports detected
[   35.018048] usbcore: registered new interface driver usb-storage
[   35.018228] usbcore: registered new interface driver ums-alauda
[   35.018386] usbcore: registered new interface driver ums-datafab
[   35.018488] usbcore: registered new interface driver ums-freecom
[   35.018592] usbcore: registered new interface driver ums-isd200
[   35.018686] usbcore: registered new interface driver ums-jumpshot
[   35.018790] usbcore: registered new interface driver ums-sddr09
[   35.018863] usbcore: registered new interface driver ums-sddr55
[   35.018940] usbcore: registered new interface driver ums-usbat
[   35.018992] usbcore: registered new interface driver usbtest
[   35.019092] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   35.021494] serio: i8042 KBD port at 0x60,0x64 irq 1
[   35.021498] serio: i8042 AUX port at 0x60,0x64 irq 12
[   35.021859] mousedev: PS/2 mouse device common for all mice
[   35.023481] rtc_cmos 00:07: RTC can wake from S4
[   35.023814] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   35.023849] rtc_cmos 00:07: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   35.024044] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   35.024078] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   35.024439] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   35.024492] iTCO_vendor_support: vendor-support=0
[   35.024643] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   35.024645] md: linear personality registered for level -1
[   35.024646] md: raid0 personality registered for level 0
[   35.024648] md: raid1 personality registered for level 1
[   35.024649] md: raid10 personality registered for level 10
[   35.024764] md: raid6 personality registered for level 6
[   35.024765] md: raid5 personality registered for level 5
[   35.024766] md: raid4 personality registered for level 4
[   35.024767] md: multipath personality registered for level -4
[   35.024768] md: faulty personality registered for level -5
[   35.026156] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   35.026953] device-mapper: multipath: version 1.6.0 loaded
[   35.026955] device-mapper: multipath round-robin: version 1.0.0 loaded
[   35.026979] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   35.026980] device-mapper: cache cleaner: version 1.0.0 loaded
[   35.027388] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   35.028432] usbcore: registered new interface driver usbhid
[   35.028432] usbhid: USB HID core driver
[   35.028572] TCP: bic registered
[   35.028573] Initializing XFRM netlink socket
[   35.028819] NET: Registered protocol family 10
[   35.029104] sit: IPv6 over IPv4 tunneling driver
[   35.029336] NET: Registered protocol family 17
[   35.029352] 8021q: 802.1Q VLAN Support v1.8
[   35.030446] DCCP: Activated CCID 2 (TCP-like)
[   35.030456] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   35.031345] sctp: Hash tables configured (established 65536 bind 65536)
[   35.031522] tipc: Activated (version 2.0.0)
[   35.031581] NET: Registered protocol family 30
[   35.031789] tipc: Started in single node mode
[   35.031796] Key type dns_resolver registered
[   35.033781] 
[   35.033781] printing PIC contents
[   35.033783] ... PIC  IMR: ffff
[   35.033786] ... PIC  IRR: 0c20
[   35.033795] ... PIC  ISR: 0000
[   35.033797] ... PIC ELCR: 0e20
[   35.033830] printing local APIC contents on CPU#0/0:
[   35.033831] ... APIC ID:      00000000 (0)
[   35.033831] ... APIC VERSION: 01060015
[   35.033832] ... APIC TASKPRI: 00000000 (00)
[   35.033832] ... APIC PROCPRI: 00000000
[   35.033833] ... APIC LDR: 01000000
[   35.033833] ... APIC DFR: ffffffff
[   35.033833] ... APIC SPIV: 000001ff
[   35.033834] ... APIC ISR field:
[   35.033836] 0000000000000000000000000000000000000000000000000000000000000000
[   35.033836] ... APIC TMR field:
[   35.033838] 0000000000000000000200020002000200000000000000000000000000000000
[   35.033839] ... APIC IRR field:
[   35.033840] 0000000000000000000000000000000000000000000000000000000000000000
[   35.033841] ... APIC ESR: 00000000
[   35.033841] ... APIC ICR: 000000fd
[   35.033841] ... APIC ICR2: 02000000
[   35.033842] ... APIC LVTT: 000000ef
[   35.033842] ... APIC LVTPC: 00000400
[   35.033843] ... APIC LVT0: 00010700
[   35.033843] ... APIC LVT1: 00000400
[   35.033843] ... APIC LVTERR: 000000fe
[   35.033844] ... APIC TMICT: 000359fa
[   35.033844] ... APIC TMCCT: 000278fb
[   35.033844] ... APIC TDCR: 00000003
[   35.033844] 
[   35.033845] number of MP IRQ sources: 15.
[   35.033846] number of IO-APIC #0 registers: 24.
[   35.033846] number of IO-APIC #2 registers: 24.
[   35.033847] number of IO-APIC #3 registers: 24.
[   35.033847] number of IO-APIC #4 registers: 24.
[   35.033847] testing the IO APIC.......................
[   35.033854] IO APIC #0......
[   35.033854] .... register #00: 00000000
[   35.033854] .......    : physical APIC id: 00
[   35.033855] .......    : Delivery Type: 0
[   35.033855] .......    : LTS          : 0
[   35.033856] .... register #01: 00170020
[   35.033856] .......     : max redirection entries: 17
[   35.033856] .......     : PRQ implemented: 0
[   35.033857] .......     : IO APIC version: 20
[   35.033857] .... IRQ redirection table:
[   35.033862] 1    0    0   0   0    0    0    00
[   35.033865] 0    0    0   0   0    0    0    31
[   35.033869] 0    0    0   0   0    0    0    30
[   35.033873] 0    0    0   0   0    0    0    33
[   35.033877] 0    0    0   0   0    0    0    34
[   35.033881] 0    0    0   0   0    0    0    35
[   35.033885] 0    0    0   0   0    0    0    36
[   35.033889] 0    0    0   0   0    0    0    37
[   35.033893] 0    0    0   0   0    0    0    38
[   35.033898] 0    1    0   0   0    0    0    39
[   35.033902] 0    0    0   0   0    0    0    3A
[   35.033906] 0    0    0   0   0    0    0    3B
[   35.033910] 0    0    0   0   0    0    0    3C
[   35.033914] 0    0    0   0   0    0    0    3D
[   35.033918] 0    0    0   0   0    0    0    3E
[   35.033921] 0    0    0   0   0    0    0    3F
[   35.033926] 0    1    0   1   0    0    0    41
[   35.033929] 1    1    0   1   0    0    0    62
[   35.033934] 0    1    0   1   0    0    0    61
[   35.033938] 0    1    0   1   0    0    0    51
[   35.033942] 1    0    0   0   0    0    0    00
[   35.033946] 1    0    0   0   0    0    2    7B
[   35.033950] 1    0    0   0   0    0    0    00
[   35.033954] 0    1    0   1   0    0    0    71
[   35.033956] IO APIC #2......
[   35.033957] .... register #00: 02000000
[   35.033957] .......    : physical APIC id: 02
[   35.033957] .......    : Delivery Type: 0
[   35.033958] .......    : LTS          : 0
[   35.033958] .... register #01: 00178020
[   35.033958] .......     : max redirection entries: 17
[   35.033959] .......     : PRQ implemented: 1
[   35.033959] .......     : IO APIC version: 20
[   35.033959] .... register #02: 02000000
[   35.033960] .......     : arbitration: 02
[   35.033960] .... register #03: 00000001
[   35.033961] .......     : Boot DT    : 1
[   35.033961] .... IRQ redirection table:
[   35.033963] 1    0    0   0   0    0    0    00
[   35.033965] 1    0    0   0   0    0    0    00
[   35.033967] 1    0    0   0   0    0    0    00
[   35.033969] 1    0    0   0   0    0    0    00
[   35.033971] 1    0    0   0   0    0    0    00
[   35.033973] 1    0    0   0   0    0    0    00
[   35.033975] 1    0    0   0   0    0    0    00
[   35.033977] 1    0    0   0   0    0    0    00
[   35.033979] 1    0    0   0   0    0    0    00
[   35.033981] 1    0    0   0   0    0    0    00
[   35.033983] 1    0    0   0   0    0    0    00
[   35.033985] 1    0    0   0   0    0    0    00
[   35.033987] 1    0    0   0   0    0    0    00
[   35.033989] 1    0    0   0   0    0    0    00
[   35.033991] 1    0    0   0   0    0    0    00
[   35.033993] 1    0    0   0   0    0    0    00
[   35.033995] 1    0    0   0   0    0    0    00
[   35.033997] 1    0    0   0   0    0    0    00
[   35.033999] 1    0    0   0   0    0    0    00
[   35.034001] 1    0    0   0   0    0    0    00
[   35.034003] 1    0    0   0   0    0    0    00
[   35.034005] 1    0    0   0   0    0    0    00
[   35.034006] 1    0    0   0   0    0    0    00
[   35.034008] 1    0    0   0   0    0    0    00
[   35.034011] IO APIC #3......
[   35.034011] .... register #00: 03000000
[   35.034012] .......    : physical APIC id: 03
[   35.034012] .......    : Delivery Type: 0
[   35.034012] .......    : LTS          : 0
[   35.034013] .... register #01: 00178020
[   35.034013] .......     : max redirection entries: 17
[   35.034014] .......     : PRQ implemented: 1
[   35.034014] .......     : IO APIC version: 20
[   35.034014] .... register #02: 03000000
[   35.034015] .......     : arbitration: 03
[   35.034015] .... register #03: 00000001
[   35.034015] .......     : Boot DT    : 1
[   35.034016] .... IRQ redirection table:
[   35.034018] 1    0    0   0   0    0    0    00
[   35.034020] 1    0    0   0   0    0    0    00
[   35.034022] 1    0    0   0   0    0    0    00
[   35.034024] 1    0    0   0   0    0    0    00
[   35.034026] 1    0    0   0   0    0    0    00
[   35.034027] 1    0    0   0   0    0    0    00
[   35.034029] 1    0    0   0   0    0    0    00
[   35.034031] 1    0    0   0   0    0    0    00
[   35.034033] 1    0    0   0   0    0    0    00
[   35.034035] 1    0    0   0   0    0    0    00
[   35.034037] 1    0    0   0   0    0    0    00
[   35.034039] 1    0    0   0   0    0    0    00
[   35.034041] 1    0    0   0   0    0    0    00
[   35.034043] 1    0    0   0   0    0    0    00
[   35.034045] 1    0    0   0   0    0    0    00
[   35.034047] 1    0    0   0   0    0    0    00
[   35.034049] 1    0    0   0   0    0    0    00
[   35.034051] 1    0    0   0   0    0    0    00
[   35.034053] 1    0    0   0   0    0    0    00
[   35.034055] 1    0    0   0   0    0    0    00
[   35.034057] 1    0    0   0   0    0    0    00
[   35.034059] 1    0    0   0   0    0    0    00
[   35.034061] 1    0    0   0   0    0    0    00
[   35.034063] 1    0    0   0   0    0    0    00
[   35.034066] IO APIC #4......
[   35.034067] .... register #00: 04000000
[   35.034067] .......    : physical APIC id: 04
[   35.034068] .......    : Delivery Type: 0
[   35.034068] .......    : LTS          : 0
[   35.034068] .... register #01: 00170020
[   35.034069] .......     : max redirection entries: 17
[   35.034069] .......     : PRQ implemented: 0
[   35.034069] .......     : IO APIC version: 20
[   35.034070] .... register #02: 00000000
[   35.034070] .......     : arbitration: 00
[   35.034070] .... register #03: 00000001
[   35.034071] .......     : Boot DT    : 1
[   35.034071] .... IRQ redirection table:
[   35.034074] 1    1    0   1   0    0    0    A1
[   35.034076] 1    0    0   0   0    0    0    00
[   35.034078] 1    1    0   1   0    0    0    C1
[   35.034081] 1    0    0   0   0    0    0    00
[   35.034083] 1    1    0   1   0    0    0    81
[   35.034086] 1    0    0   0   0    0    0    00
[   35.034088] 1    1    0   1   0    0    0    E1
[   35.034090] 1    0    0   0   0    0    0    00
[   35.034093] 1    1    0   1   0    0    0    42
[   35.034095] 1    0    0   0   0    0    0    00
[   35.034097] 1    0    0   0   0    0    0    00
[   35.034100] 1    0    0   0   0    0    0    00
[   35.034102] 1    0    0   0   0    0    0    00
[   35.034105] 1    0    0   0   0    0    0    00
[   35.034107] 1    0    0   0   0    0    0    00
[   35.034109] 1    0    0   0   0    0    0    00
[   35.034112] 1    1    0   1   0    0    0    44
[   35.034114] 1    0    0   0   0    0    0    00
[   35.034116] 1    0    0   0   0    0    0    00
[   35.034119] 1    0    0   0   0    0    0    00
[   35.034121] 1    0    0   0   0    0    0    00
[   35.034124] 1    0    0   0   0    0    0    00
[   35.034126] 1    0    0   0   0    0    0    00
[   35.034128] 1    0    0   0   0    0    0    00
[   35.034129] IRQ to pin mappings:
[   35.034130] IRQ0 -> 0:2
[   35.034131] IRQ1 -> 0:1
[   35.034132] IRQ3 -> 0:3
[   35.034133] IRQ4 -> 0:4
[   35.034134] IRQ5 -> 0:5
[   35.034134] IRQ6 -> 0:6
[   35.034135] IRQ7 -> 0:7
[   35.034136] IRQ8 -> 0:8
[   35.034137] IRQ9 -> 0:9
[   35.034138] IRQ10 -> 0:10
[   35.034138] IRQ11 -> 0:11
[   35.034139] IRQ12 -> 0:12
[   35.034140] IRQ13 -> 0:13
[   35.034141] IRQ14 -> 0:14
[   35.034142] IRQ15 -> 0:15
[   35.034143] IRQ16 -> 0:16
[   35.034143] IRQ17 -> 0:17
[   35.034144] IRQ18 -> 0:18
[   35.034145] IRQ19 -> 0:19
[   35.034146] IRQ23 -> 0:23
[   35.034147] IRQ72 -> 3:0
[   35.034148] IRQ74 -> 3:2
[   35.034149] IRQ76 -> 3:4
[   35.034150] IRQ78 -> 3:6
[   35.034151] IRQ80 -> 3:8
[   35.034152] IRQ88 -> 3:16
[   35.034154] .................................... done.
[   35.034569] registered taskstats version 1
[   35.035389] bio: create slab <bio-1> at 1
[   35.036416] Btrfs loaded
[   35.709993] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[   35.866523] hub 5-2:1.0: USB hub found
[   35.868190] hub 5-2:1.0: 4 ports detected
[   36.151423] usb 5-2.1: new low-speed USB device number 3 using uhci_hcd
[   36.423510] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.0/0003:0557:2261.0001/input/input6
[   36.423964] hid-generic 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input0
[   36.517088] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.1/0003:0557:2261.0002/input/input7
[   36.517531] hid-generic 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input1
[   36.541451] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.2/0003:0557:2261.0003/input/input8
[   36.542165] hid-generic 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input2
[   36.662796] rtc_cmos 00:07: setting system clock to 2014-03-20 11:27:50 UTC (1395314870)
[   36.671388] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   36.677680] EDD information not available.
[   36.690524] sd 6:0:8:0: [sdk] Attached SCSI disk
[   36.714778] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.831452] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   36.837561] 8021q: adding VLAN 0 to HW filter on device eth1
[   36.955527] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   36.961631] 8021q: adding VLAN 0 to HW filter on device eth2
[   45.130059] igb: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   45.137876] igb 0000:01:00.0 eth1: Link Speed was downgraded by SmartSpeed
[   45.150265] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   45.165627] Sending DHCP requests ., OK
[   45.798147] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.67
[   45.991079] IP-Config: Complete:
[   45.994590]      device=eth1, hwaddr=00:30:48:cf:17:26, ipaddr=192.168.1.67, mask=255.255.255.0, gw=192.168.1.1
[   46.005164]      host=lkp-ws02, domain=lkp.intel.com, nis-domain=(none)
[   46.012049]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   46.018805]      nameserver0=192.168.1.1
[   46.023505] PM: Hibernation image not present or could not be loaded.
[   46.034725] Freeing unused kernel memory: 1440K (ffffffff8233b000 - ffffffff824a3000)
[   46.043041] Write protecting the kernel read-only data: 18432k
[   46.059663] Freeing unused kernel memory: 1664K (ffff880001a60000 - ffff880001c00000)
[   46.076190] Freeing unused kernel memory: 1864K (ffff88000202e000 - ffff880002200000)
[   46.365863] ipmi message handler version 39.2
[   46.372360] IPMI System Interface driver.
[   46.376713] ipmi_si: probing via SMBIOS
[   46.380912] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   46.387395] ipmi_si: Adding SMBIOS-specified kcs state machine
[   46.393767] ipmi_si: probing via SPMI
[   46.397800] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   46.403979] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[   46.412133] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   46.422834] ipmi_si: Interface detection failed
[   46.429435] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[   46.435503] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[   46.441560] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[   46.447611] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[   46.453673] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[   46.459761] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[   46.465818] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[   46.471892] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[   46.477955] microcode: CPU8 sig=0x206c1, pf=0x1, revision=0x3
[   46.484081] microcode: CPU9 sig=0x206c1, pf=0x1, revision=0x3
[   46.490143] microcode: CPU10 sig=0x206c1, pf=0x1, revision=0x3
[   46.496284] microcode: CPU11 sig=0x206c1, pf=0x1, revision=0x3
[   46.502423] microcode: CPU12 sig=0x206c1, pf=0x1, revision=0x3
[   46.508595] microcode: CPU13 sig=0x206c1, pf=0x1, revision=0x3
[   46.514784] microcode: CPU14 sig=0x206c1, pf=0x1, revision=0x3
[   46.520946] microcode: CPU15 sig=0x206c1, pf=0x1, revision=0x3
[   46.527100] microcode: CPU16 sig=0x206c1, pf=0x1, revision=0x3
[   46.533295] microcode: CPU17 sig=0x206c1, pf=0x1, revision=0x3
[   46.539501] microcode: CPU18 sig=0x206c1, pf=0x1, revision=0x3
[   46.545625] microcode: CPU19 sig=0x206c1, pf=0x1, revision=0x3
[   46.551789] microcode: CPU20 sig=0x206c1, pf=0x1, revision=0x3
[   46.557953] microcode: CPU21 sig=0x206c1, pf=0x1, revision=0x3
[   46.564118] microcode: CPU22 sig=0x206c1, pf=0x1, revision=0x3
[   46.570285] microcode: CPU23 sig=0x206c1, pf=0x1, revision=0x3
[   46.573951] BTRFS: device fsid f3082e2d-7b16-4b16-8027-d9ef0ff805ff devid 1 transid 44 /dev/sdc1
[   46.585816] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

==> /lkp/lkp/src/tmp/run_log <==
Kernel tests: Boot OK!
PATH=/sbin:/usr/sbin:/bin:/usr/bin

==> /lkp/lkp/src/tmp/err_log <==

==> /lkp/lkp/src/tmp/run_log <==
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=/lkp/lkp/src
RESULT_ROOT=/lkp/result/lkp-ws02/fake/boot/1/x86_64-lkp/3c3af80e2af6f37845464e6879a792496d9485e4/0
job=/lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml
run-job /lkp/scheduled/lkp-ws02/vip_boot-1-x86_64-lkp-3c3af80e2af6f37845464e6879a792496d9485e4-0.yaml
run: pre-test
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/fake/sleep 1{}
[   61.216429] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
geting new job...
downloading kernel image ...
downloading initrds ...
kexecing...
kexec -l /opt/rootfs/tmp//kernel/x86_64-lkp/v3.14-rc7/vmlinuz-3.14.0-rc7 --initrd=/tmp/initrd-3978 --append="user=lkp job=/lkp/scheduled/lkp-ws02/cyclic_hackbench-1600%-process-socket-BASE-v3.14-rc7.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/v3.14-rc7/vmlinuz-3.14.0-rc7 kconfig=x86_64-lkp commit=v3.14-rc7 modules_initrd=/kernel/x86_64-lkp/dcb99fd9b08cfe1afe426af4d8d3cbc429190f15/modules.cgz max_uptime=1796 RESULT_ROOT=/lkp/result/lkp-ws02/micro/hackbench/1600%-process-socket/x86_64-lkp/dcb99fd9b08cfe1afe426af4d8d3cbc429190f15/6 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic 
 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal"
[   71.135649] kvm: exiting hardware virtualization
[   71.143167] sd 6:0:11:0: [sdn] Synchronizing SCSI cache
[   71.149200] sd 6:0:0:0: [sdc] Synchronizing SCSI cache
[   71.154752] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[   71.160054] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   71.227920] Starting new kernel

--PNTmBPCT7hxwcZjr--
