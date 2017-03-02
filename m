From: =?UTF-8?Q?Lo=c3=afc_Yhuel?= <loic.yhuel@gmail.com>
Subject: [regression] vmw_pvscsi probe fails on 4.11
Date: Thu, 2 Mar 2017 09:51:46 +0100
Message-ID: <cd383513-7fc2-5cec-9471-808e97bef27a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35745 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932144AbdCBJTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 04:19:17 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so11338676wmu.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2017 01:19:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jim Gill <jgill@vmware.com>
Cc: linux-scsi@vger.kernel.org

Hi,

On Fedora Rawhide (reproduced on git master), vmw_pvscsi probe fails.
It also calls free_irq during cleanup, which produces a warning since it 
didn't
call request_irq in this case.

Reverting commit 2e48e34 (scsi: vmw_pvscsi: switch to pci_alloc_irq_vectors)
fixes the issue (I get "vmw_pvscsi: using MSI-X", and it uses the IRQ 78).

[    2.671383] vmw_pvscsi: using 64bit dma
[    2.671750] vmw_pvscsi: max_id: 16
[    2.671752] vmw_pvscsi: setting ring_pages to 8
[    2.673209] ------------[ cut here ]------------
[    2.673219] WARNING: CPU: 2 PID: 402 at kernel/irq/manage.c:1478 
__free_irq+0xa4/0x2e0
[    2.673220] Trying to free already-free IRQ 78
[    2.673221] Modules linked in: serio_raw vmw_pvscsi(+) vmxnet3 
ata_generic pata_acpi fjes vmwgfx drm_kms_helper ttm drm
[    2.673236] CPU: 2 PID: 402 Comm: systemd-udevd Not tainted 
4.11.0r0-test1+ #2
[    2.673238] Hardware name: VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform, BIOS 6.00 07/02/2015
[    2.673239] Call Trace:
[    2.673244]  dump_stack+0x8e/0xd1
[    2.673248]  __warn+0xcb/0xf0
[    2.673252]  warn_slowpath_fmt+0x5f/0x80
[    2.673257]  ? _raw_spin_lock_irqsave+0x82/0x90
[    2.673259]  ? __free_irq+0x5f/0x2e0
[    2.673262]  __free_irq+0xa4/0x2e0
[    2.673265]  ? __pci_enable_msix+0x234/0x520
[    2.673269]  free_irq+0x39/0x90
[    2.673274]  pvscsi_shutdown_intr+0x25/0x40 [vmw_pvscsi]
[    2.673277]  pvscsi_release_resources+0x1e/0x370 [vmw_pvscsi]
[    2.673281]  pvscsi_probe+0xd2e/0x10a4 [vmw_pvscsi]
[    2.673306]  local_pci_probe+0x42/0xa0
[    2.673308]  ? pci_match_device+0xe0/0x110
[    2.673311]  pci_device_probe+0xbe/0x150
[    2.673313]  ? _raw_spin_unlock+0x27/0x40
[    2.673318]  driver_probe_device+0x106/0x450
[    2.673322]  __driver_attach+0xa8/0xf0
[    2.673325]  ? driver_probe_device+0x450/0x450
[    2.673327]  bus_for_each_dev+0x75/0xc0
[    2.673331]  driver_attach+0x1e/0x20
[    2.673333]  bus_add_driver+0x1d3/0x270
[    2.673335]  ? 0xffffffffc032d000
[    2.673338]  driver_register+0x60/0xe0
[    2.673340]  ? 0xffffffffc032d000
[    2.673342]  __pci_register_driver+0x60/0x70
[    2.673345]  pvscsi_init+0x38/0x1000 [vmw_pvscsi]
[    2.673348]  do_one_initcall+0x50/0x1a0
[    2.673351]  ? rcu_read_lock_sched_held+0x79/0x80
[    2.673354]  ? kmem_cache_alloc_trace+0x273/0x2e0
[    2.673356]  ? do_init_module+0x27/0x1e8
[    2.673361]  do_init_module+0x5f/0x1e8
[    2.673365]  load_module+0x2386/0x29d0
[    2.673367]  ? __symbol_put+0x70/0x70
[    2.673371]  ? show_coresize+0x30/0x30
[    2.673375]  ? vfs_read+0x131/0x180
[    2.673386]  SYSC_finit_module+0xf6/0x110
[    2.673395]  SyS_finit_module+0xe/0x10
[    2.673397]  do_syscall_64+0x6c/0x1f0
[    2.673400]  entry_SYSCALL64_slow_path+0x25/0x25
[    2.673402] RIP: 0033:0x7f770375e5d9
[    2.673403] RSP: 002b:00007fff59d224b8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000139
[    2.673406] RAX: ffffffffffffffda RBX: 000056462cb91f20 RCX: 
00007f770375e5d9
[    2.673407] RDX: 0000000000000000 RSI: 00007f77042999c5 RDI: 
0000000000000006
[    2.673408] RBP: 00007f77042999c5 R08: 0000000000000000 R09: 
00007fff59d225d0
[    2.673409] R10: 0000000000000006 R11: 0000000000000246 R12: 
0000000000000000
[    2.673410] R13: 000056462cb8fcd0 R14: 0000000000020000 R15: 
000056462ae4cd81
[    2.673419] ---[ end trace 19fc54ed551e946e ]---
[    2.677816] vmw_pvscsi 0000:13:00.0: Driver probe function 
unexpectedly returned 1
