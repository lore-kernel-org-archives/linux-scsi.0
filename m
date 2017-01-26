From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Thu, 26 Jan 2017 15:36:14 +0100
Message-ID: <20170126143614.GA19849@lst.de>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com> <20170123163446.9227-2-bart.vanassche@sandisk.com> <1485359225.3093.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485359225.3093.3.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2017 at 03:47:20PM +0000, Bart Van Assche wrote:
> =============================================================================
> BUG kmalloc-16 (Not tainted): Redzone overwritten
> -----------------------------------------------------------------------------
> 
> Disabling lock debugging due to kernel taint
> INFO: 0xffff880030bacc78-0xffff880030bacc7f. First byte 0xf instead of 0xcc
> INFO: Allocated in irq_create_affinity_masks+0x5f/0x260 age=0 cpu=3 pid=812
> 	___slab_alloc.constprop.79+0x482/0x4f0
> 	__slab_alloc.isra.75.constprop.78+0x55/0xa0
> 	__kmalloc+0x27c/0x310
> 	irq_create_affinity_masks+0x5f/0x260

This is the normal affinity mask allocation.

> 	__pci_enable_msix+0x314/0x4c0
> 	pci_alloc_irq_vectors_affinity+0xb7/0x140
> 	qla2x00_request_irqs+0xa6/0x6d0 [qla2xxx]
> 	qla2x00_probe_one+0xc2e/0x25f0 [qla2xxx]
> 	pci_device_probe+0x8a/0xf0
> 	driver_probe_device+0x1f5/0x450
> 	__driver_attach+0xe3/0xf0
> 	bus_for_each_dev+0x66/0xa0
> 	driver_attach+0x1e/0x20
> 	bus_add_driver+0x200/0x270
> 	driver_register+0x60/0xe0
> 	__pci_register_driver+0x5d/0x60
> INFO: Freed in acpi_ns_get_node_unlocked+0x90/0xa4 age=0 cpu=3 pid=812
> 	__slab_free+0x176/0x310
> 	kfree+0x25e/0x2d0
> 	acpi_ns_get_node_unlocked+0x90/0xa4
> 	acpi_ns_get_node+0x3d/0x52
> 	acpi_get_handle+0x82/0x96

This on the other hand I don't understand acpi_ns_get_node_unlocked
only frees the object it allocated in the ACPI code using
acpi_ns_internalize_name.  I can't really see any relation to the
affinity mask allocation.

> 	acpi_pci_irq_find_prt_entry+0x26e/0x2ae
> 	acpi_pci_irq_lookup+0x28/0x135
> 	acpi_pci_irq_enable+0x60/0x1f8
> 	pcibios_enable_device+0x2d/0x30
> 	do_pci_enable_device+0x64/0xf0
> 	pci_enable_device_flags+0xc5/0x110
> 	pci_enable_device_mem+0x13/0x20
> 	qla2x00_probe_one+0x14b/0x25f0 [qla2xxx]
> 	pci_device_probe+0x8a/0xf0
> 	driver_probe_device+0x1f5/0x450
> 	__driver_attach+0xe3/0xf0
> INFO: Slab 0xffffea0000c2eb00 objects=23 used=21 fp=0xffff880030bacdc8 flags=0x4000000000008101
> INFO: Object 0xffff880030bacc68 @offset=3176 fp=0xffff880030bacf28
> 
> Redzone ffff880030bacc60: cc cc cc cc cc cc cc cc                          ........
> Object ffff880030bacc68: ff 00 00 00 00 00 00 00 ff 00 00 00 00 00 00 00  ................
> Redzone ffff880030bacc78: 0f 00 00 00 00 00 00 00                          ........
> Padding ffff880030bacdb8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> CPU: 3 PID: 812 Comm: modprobe Tainted: G    B           4.10.0-rc5-dbg+ #9
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  dump_stack+0x85/0xc2
>  print_trailer+0x162/0x260
>  check_bytes_and_report+0xc5/0x110
>  check_object+0x1da/0x2a0
>  free_debug_processing+0x161/0x3d0
>  ? debug_lockdep_rcu_enabled+0x1d/0x20
>  ? __pci_enable_msix+0x41c/0x4c0
>  __slab_free+0x176/0x310
>  ? __pci_enable_msix+0x41c/0x4c0
>  ? call_rcu+0x17/0x20
>  ? kfree+0xe7/0x2d0
>  ? __pci_enable_msix+0x41c/0x4c0
>  ? __pci_enable_msix+0x41c/0x4c0
>  kfree+0x25e/0x2d0
>  __pci_enable_msix+0x41c/0x4c0
>  pci_alloc_irq_vectors_affinity+0xb7/0x140
>  qla2x00_request_irqs+0xa6/0x6d0 [qla2xxx]
>  qla2x00_probe_one+0xc2e/0x25f0 [qla2xxx]
>  ? __pm_runtime_resume+0x40/0x80
>  ? trace_hardirqs_on_caller+0x128/0x1b0
>  ? trace_hardirqs_on+0xd/0x10
>  ? _raw_spin_unlock_irqrestore+0x4a/0x80
>  pci_device_probe+0x8a/0xf0
>  driver_probe_device+0x1f5/0x450
>  __driver_attach+0xe3/0xf0
>  ? driver_probe_device+0x450/0x450
>  bus_for_each_dev+0x66/0xa0
>  driver_attach+0x1e/0x20
>  bus_add_driver+0x200/0x270
>  ? 0xffffffffa04eb000
>  driver_register+0x60/0xe0
>  ? 0xffffffffa04eb000
>  __pci_register_driver+0x5d/0x60
>  qla2x00_module_init+0x1c9/0x217 [qla2xxx]
>  do_one_initcall+0x44/0x180
>  ? rcu_read_lock_sched_held+0x72/0x80
>  ? kmem_cache_alloc_trace+0x25b/0x2c0
>  ? do_init_module+0x27/0x1f9
>  do_init_module+0x5f/0x1f9
>  load_module+0x2582/0x2a00
>  ? __symbol_put+0x70/0x70
>  ? kernel_read_file+0x10a/0x1a0
>  ? kernel_read_file_from_fd+0x49/0x80
>  SYSC_finit_module+0xbc/0xf0
>  SyS_finit_module+0xe/0x10
>  entry_SYSCALL_64_fastpath+0x23/0xc6
> RIP: 0033:0x7f05711388e9
> RSP: 002b:00007fff51d4a0f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f05711388e9
> RDX: 0000000000000000 RSI: 000055c17ab4f720 RDI: 0000000000000004
> RBP: 00007fff51d49100 R08: 0000000000000000 R09: 0000000000000019
> R10: 0000000000000004 R11: 0000000000000246 R12: 000055c17ab4f570
> R13: 00007fff51d490e0 R14: 0000000000000005 R15: 0000000000040000
> FIX kmalloc-16: Restoring 0xffff880030bacc78-0xffff880030bacc7f=0xcc
> 
> FIX kmalloc-16: Object at 0xffff880030bacc68 not freed
> scsi host2: qla2xxx
> qla2xxx [0000:00:09.0]-00fb:2: QLogic QLE2460 - QLogic 4GB FC Single-Port PCI-E HBA for IBM System x.
> qla2xxx [0000:00:09.0]-00fc:2: ISP2432: PCIe (2.5GT/s x4) @ 0000:00:09.0 hdma- host#=2 fw=8.03.00 (9496).
> qla2xxx [0000:00:0a.0]-001d: : Found an ISP2432 irq 10 iobase 0xffffc900000ad000.
> =============================================================================
> BUG kmalloc-16 (Tainted: G    B          ): Redzone overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff88006ff18dd8-0xffff88006ff18ddf. First byte 0xf instead of 0xcc
> INFO: Allocated in irq_create_affinity_masks+0x5f/0x260 age=0 cpu=2 pid=812
> 	___slab_alloc.constprop.79+0x482/0x4f0
> 	__slab_alloc.isra.75.constprop.78+0x55/0xa0
> 	__kmalloc+0x27c/0x310
> 	irq_create_affinity_masks+0x5f/0x260
> 	__pci_enable_msix+0x314/0x4c0
> 	pci_alloc_irq_vectors_affinity+0xb7/0x140
> 	qla2x00_request_irqs+0xa6/0x6d0 [qla2xxx]
> 	qla2x00_probe_one+0xc2e/0x25f0 [qla2xxx]
> 	pci_device_probe+0x8a/0xf0
> 	driver_probe_device+0x1f5/0x450
> 	__driver_attach+0xe3/0xf0
> 	bus_for_each_dev+0x66/0xa0
> 	driver_attach+0x1e/0x20
> 	bus_add_driver+0x200/0x270
> 	driver_register+0x60/0xe0
> 	__pci_register_driver+0x5d/0x60
> INFO: Freed in acpi_ns_get_node_unlocked+0x90/0xa4 age=1 cpu=2 pid=812
> 	__slab_free+0x176/0x310
> 	kfree+0x25e/0x2d0
> 	acpi_ns_get_node_unlocked+0x90/0xa4
> 	acpi_ns_get_node+0x3d/0x52
> 	acpi_get_handle+0x82/0x96
> 	acpi_pci_irq_find_prt_entry+0x26e/0x2ae
> 	acpi_pci_irq_lookup+0x28/0x135
> 	acpi_pci_irq_enable+0x60/0x1f8
> 	pcibios_enable_device+0x2d/0x30
> 	do_pci_enable_device+0x64/0xf0
> 	pci_enable_device_flags+0xc5/0x110
> 	pci_enable_device_mem+0x13/0x20
> 	qla2x00_probe_one+0x14b/0x25f0 [qla2xxx]
> 	pci_device_probe+0x8a/0xf0
> 	driver_probe_device+0x1f5/0x450
> 	__driver_attach+0xe3/0xf0
> INFO: Slab 0xffffea0001bfc600 objects=23 used=22 fp=0xffff88006ff18f28 flags=0x4000000000008101
> INFO: Object 0xffff88006ff18dc8 @offset=3528 fp=0xffff88006ff18f28
> 
> Redzone ffff88006ff18dc0: cc cc cc cc cc cc cc cc                          ........
> Object ffff88006ff18dc8: ff 00 00 00 00 00 00 00 ff 00 00 00 00 00 00 00  ................
> Redzone ffff88006ff18dd8: 0f 00 00 00 00 00 00 00                          ........
> Padding ffff88006ff18f18: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> CPU: 2 PID: 812 Comm: modprobe Tainted: G    B           4.10.0-rc5-dbg+ #9
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  dump_stack+0x85/0xc2
>  print_trailer+0x162/0x260
>  check_bytes_and_report+0xc5/0x110
>  check_object+0x1da/0x2a0
>  free_debug_processing+0x161/0x3d0
>  ? __pci_enable_msix+0x41c/0x4c0
>  __slab_free+0x176/0x310
>  ? __pci_enable_msix+0x41c/0x4c0
>  ? call_rcu+0x17/0x20
>  ? put_object+0x2d/0x50
>  ? __delete_object+0x3d/0x70
>  ? __pci_enable_msix+0x41c/0x4c0
>  kfree+0x25e/0x2d0
>  __pci_enable_msix+0x41c/0x4c0
>  pci_alloc_irq_vectors_affinity+0xb7/0x140
>  qla2x00_request_irqs+0xa6/0x6d0 [qla2xxx]
>  qla2x00_probe_one+0xc2e/0x25f0 [qla2xxx]
>  ? __pm_runtime_resume+0x40/0x80
>  ? trace_hardirqs_on+0xd/0x10
>  ? _raw_spin_unlock_irqrestore+0x4a/0x80
>  pci_device_probe+0x8a/0xf0
>  driver_probe_device+0x1f5/0x450
>  __driver_attach+0xe3/0xf0
>  ? driver_probe_device+0x450/0x450
>  bus_for_each_dev+0x66/0xa0
>  driver_attach+0x1e/0x20
>  bus_add_driver+0x200/0x270
>  ? 0xffffffffa04eb000
>  driver_register+0x60/0xe0
>  ? 0xffffffffa04eb000
>  __pci_register_driver+0x5d/0x60
>  qla2x00_module_init+0x1c9/0x217 [qla2xxx]
>  do_one_initcall+0x44/0x180
>  ? rcu_read_lock_sched_held+0x72/0x80
>  ? kmem_cache_alloc_trace+0x25b/0x2c0
>  ? do_init_module+0x27/0x1f9
>  do_init_module+0x5f/0x1f9
>  load_module+0x2582/0x2a00
>  ? __symbol_put+0x70/0x70
>  ? kernel_read_file+0x10a/0x1a0
>  ? kernel_read_file_from_fd+0x49/0x80
>  SYSC_finit_module+0xbc/0xf0
>  SyS_finit_module+0xe/0x10
>  entry_SYSCALL_64_fastpath+0x23/0xc6
> RIP: 0033:0x7f05711388e9
> RSP: 002b:00007fff51d4a0f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f05711388e9
> RDX: 0000000000000000 RSI: 000055c17ab4f720 RDI: 0000000000000004
> RBP: 00007fff51d49100 R08: 0000000000000000 R09: 0000000000000019
> R10: 0000000000000004 R11: 0000000000000246 R12: 000055c17ab4f570
> R13: 00007fff51d490e0 R14: 0000000000000005 R15: 0000000000040000
> FIX kmalloc-16: Restoring 0xffff88006ff18dd8-0xffff88006ff18ddf=0xcc
> 
> FIX kmalloc-16: Object at 0xffff88006ff18dc8 not freed
> scsi host3: qla2xxx
> qla2xxx [0000:00:09.0]-500a:2: LOOP UP detected (4 Gbps).
> qla2xxx [0000:00:0a.0]-500a:3: LOOP UP detected (4 Gbps).
> 
> 
> (gdb) list *(__pci_enable_msix+0x314)
> 0xffffffff8131aa74 is in __pci_enable_msix (drivers/pci/msi.c:702).
> 697             struct msi_desc *entry;
> 698             int ret, i;
> 699
> 700             if (affd) {
> 701                     masks = irq_create_affinity_masks(nvec, affd);
> 702                     if (!masks)
> 703                             pr_err("Unable to allocate affinity masks, ignoring\n");
> 704             }
> 705
> 706             for (i = 0, curmsk = masks; i < nvec; i++) {
> (gdb) list *(__pci_enable_msix+0x41c)
> 0xffffffff8131ab7c is in __pci_enable_msix (drivers/pci/msi.c:783).
> 778
> 779             ret = msix_setup_entries(dev, base, entries, nvec, affd);
> 780             if (ret)
> 781                     return ret;
> 782
> 783             ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
> 784             if (ret)
> 785                     goto out_avail;
> 786
> 787             /* Check if all MSI entries honor device restrictions */
> (gdb) quit---end quoted text---
