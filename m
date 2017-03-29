From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [REGRESSION] v4.11-rc3: lpfc: panic during module removal / shutdown
Date: Wed, 29 Mar 2017 02:29:45 +0000
Message-ID: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tyo162.gate.nec.co.jp ([114.179.232.162]:43740 "EHLO
        tyo162.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbdC2Csr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 22:48:47 -0400
Content-Language: ja-JP
Content-ID: <AF23B76456DCE34E89E88B4A9D69EE58@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
Cc: "anton@samba.org" <anton@samba.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications"),
"rmmod lpfc" starting to cause panic or corruption due to double free.

The double-free occurs as followings:
  - During initialization, lpfc_create_wq_cq() binds cq and wq to
    the same ring in the way that both cq->pring and wq->pring point
    to the same object.
  - Upon removal, lpfc_sli4_queue_destroy() ends up calling
    lpfc_sli4_queue_free() for both wqs and cqs
    and kfree(queue->pring) is done twice.

The problem became more visible in v4.11-rc3 because commit 85e8a23936ab
("scsi: lpfc: Add shutdown method for kexec") made lpfc_pci_remove_one()
called during driver shutdown.

A sample of slub_debug output is attached below.

=============================================================================
BUG kmalloc-512 (Not tainted): Object already free
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Allocated in lpfc_wq_create+0x31c/0x4f0 [lpfc] age=259902 cpu=0 pid=314
	___slab_alloc+0x47f/0x4b0
	__slab_alloc+0x40/0x5c
	kmem_cache_alloc_trace+0x16c/0x1b0
	lpfc_wq_create+0x31c/0x4f0 [lpfc]
	lpfc_create_wq_cq+0xb6/0x370 [lpfc]
	lpfc_sli4_queue_setup+0x331/0xd70 [lpfc]
	lpfc_sli4_hba_setup+0x12ce/0x1e90 [lpfc]
	lpfc_pci_probe_one_s4.isra.43+0x7c2/0x8f0 [lpfc]
	lpfc_pci_probe_one+0xbd/0xc30 [lpfc]
	local_pci_probe+0x45/0xa0
	work_for_cpu_fn+0x14/0x20
	process_one_work+0x165/0x410
	worker_thread+0x27f/0x4c0
	kthread+0x101/0x140
	ret_from_fork+0x2c/0x40
INFO: Freed in lpfc_sli4_queue_free+0x11b/0x160 [lpfc] age=100 cpu=3 pid=11802
	__slab_free+0x1ba/0x2c0
	kfree+0x122/0x170
	lpfc_sli4_queue_free+0x11b/0x160 [lpfc]
	lpfc_sli4_queue_destroy+0xba/0x470 [lpfc]
	lpfc_pci_remove_one+0x6b4/0x880 [lpfc]
	pci_device_remove+0x39/0xc0
	device_release_driver_internal+0x141/0x1f0
	driver_detach+0x3f/0x80
	bus_remove_driver+0x55/0xd0
	driver_unregister+0x2c/0x50
	pci_unregister_driver+0x2a/0xa0
	lpfc_exit+0x1c/0xe84 [lpfc]
	SyS_delete_module+0x1ba/0x220
	do_syscall_64+0x67/0x180
	return_from_SYSCALL_64+0x0/0x6a
INFO: Slab 0xffffea0040c9ce00 objects=38 used=34 fp=0xffff881032739a88 flags=0x17ffffc0008101
INFO: Object 0xffff881032739098 @offset=4248 fp=0x          (null)

Redzone ffff881032739090: bb bb bb bb bb bb bb bb                          ........
Object ffff881032739098: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327390f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739108: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739118: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739128: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739138: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739148: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739158: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739168: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739178: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739188: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739198: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8810327391f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739208: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739218: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739228: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739238: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739248: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739258: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739268: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739278: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff881032739288: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
Redzone ffff881032739298: bb bb bb bb bb bb bb bb                          ........
Padding ffff8810327393d8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
CPU: 3 PID: 11802 Comm: rmmod Tainted: G    B           4.11.0-rc3 #1
Call Trace:
 dump_stack+0x63/0x87
 print_trailer+0x165/0x260
 free_debug_processing+0x20c/0x278
 ? lpfc_sli4_queue_free+0x11b/0x160 [lpfc]
 __slab_free+0x1ba/0x2c0
 ? lpfc_sli4_queue_destroy+0xda/0x470 [lpfc]
 ? free_hot_cold_page+0x21f/0x280
 ? __free_pages+0x25/0x30
 ? free_pages.part.88+0x40/0x50
 ? lpfc_sli4_queue_free+0x11b/0x160 [lpfc]
 kfree+0x122/0x170
 lpfc_sli4_queue_free+0x11b/0x160 [lpfc]
 lpfc_sli4_queue_destroy+0x11b/0x470 [lpfc]
 lpfc_pci_remove_one+0x6b4/0x880 [lpfc]
 pci_device_remove+0x39/0xc0
 device_release_driver_internal+0x141/0x1f0
 driver_detach+0x3f/0x80
 bus_remove_driver+0x55/0xd0
 driver_unregister+0x2c/0x50
 pci_unregister_driver+0x2a/0xa0
 lpfc_exit+0x1c/0xe84 [lpfc]
 SyS_delete_module+0x1ba/0x220
 do_syscall_64+0x67/0x180
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7fa3e194ac27
RSP: 002b:00007ffdcd1607b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000000000789210 RCX: 00007fa3e194ac27
RDX: 00007fa3e19bb000 RSI: 0000000000000800 RDI: 0000000000789278
RBP: 0000000000000000 R08: 00007fa3e1c0e060 R09: 00007fa3e19bb000
R10: 00007ffdcd160540 R11: 0000000000000206 R12: 00007ffdcd1625ca
R13: 0000000000000000 R14: 0000000000789210 R15: 0000000000789010
FIX kmalloc-512: Object at 0xffff881032739098 not freed

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
