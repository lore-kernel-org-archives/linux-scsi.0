From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Fri, 10 Mar 2017 00:47:12 +0000
Message-ID: <bug-194837-11613-UZgRJ5X1u5@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60942 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750781AbdCJArS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 19:47:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A0232285EF
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 00:47:17 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F3F32285EF
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 00:47:16 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #2 from Adam Williamson (adamw@happyassassin.net) ---
I seem to get a different traceback every time this happens in local testing,
aside from the times it just hangs - but it always seems to hang or crash at
approximately the same point in the boot process, right after the "virtio-pci
0000:00:0a.0: virtio_pci: leaving for legacy driver" messages. The last one I
got was:

[    1.327442] Kernel panic - not syncing: CRED: put_cred_rcu() sees
ffff938bb584c000 with usage 1953655158
[    1.327442] 
[    1.328949] CPU: 1 PID: 21 Comm: rcuos/1 Not tainted
4.11.0-0.rc1.git0.1.fc26.x86_64 #1
[    1.328949] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Bochs 01/01/2011
[    1.331157] Call Trace:
[    1.331157]  dump_stack+0x63/0x84
[    1.331157]  panic+0xe4/0x22d
[    1.331157]  ? __prepare_to_swait+0x52/0x80
[    1.331157]  put_cred_rcu+0xb0/0xb0
[    1.331157]  rcu_nocb_kthread+0x15f/0x500
[    1.335141]  ? get_state_synchronize_sched+0x20/0x20
[    1.335141]  kthread+0x11e/0x140
[    1.335141]  ? kthread_park+0x90/0x90
[    1.335141]  ret_from_fork+0x2c/0x40
[    1.335141] Kernel Offset: 0x34000000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.335141] ---[ end Kernel panic - not syncing: CRED: put_cred_rcu() sees
ffff938bb584c000 with usage 1953655158

aside from that I've seen:

[    1.419027] Call Trace:
[    1.435026]  <IRQ>
[    1.435026]  mpage_end_io+0x39/0x60
[    1.435026]  bio_endio+0x54/0x60
[    1.435026]  blk_update_request+0x8d/0x340
[    1.435026]  blk_mq_end_request+0x1a/0x80
[    1.435026]  virtblk_request_done+0x45/0x80 [virtio_blk]
[    1.435026]  __blk_mq_complete_request+0xc9/0x120
[    1.435026]  blk_mq_complete_request+0x1e/0x20
[    1.435026]  virtblk_done+0x74/0x100 [virtio_blk]
[    1.435026]  vring_interrupt+0x34/0x80 [virtio_ring]
[    1.435026]  __handle_irq_event_percpu+0x3f/0x1a0
[    1.435026]  handle_irq_event_percpu+0x32/0x80
[    1.435026]  handle_irq_event+0x2c/0x50
[    1.435026]  handle_edge_irq+0x6f/0x120
[    1.435026]  handle_irq+0xad/0x130
[    1.435026]  do_IRQ+0x46/0xd0
[    1.435026]  common_interrupt+0x93/0x93
[    1.435026] RIP: 0010:native_safe_halt+0x6/0x10
[    1.435026] RSP: 0018:ffffffffaae03de0 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff7e
[    1.435026] RAX: 0000000000000000 RBX: ffffffffaae104c0 RCX:
0000000000000000
[    1.435026] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[    1.435026] RBP: ffffffffaae03de0 R08: 000000001c32e304 R09:
ffff883d767b1f00
[    1.435026] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[    1.435026] R13: ffffffffaae104c0 R14: 0000000000000000 R15:
0000000000000000
[    1.435026]  </IRQ>
[    1.435026]  default_idle+0x20/0xe0
[    1.435026]  arch_cpu_idle+0xf/0x20
[    1.435026]  default_idle_call+0x23/0x30
[    1.435026]  do_idle+0x170/0x200
[    1.435026]  cpu_startup_entry+0x71/0x80
[    1.435026]  rest_init+0x77/0x80
[    1.435026]  start_kernel+0x45a/0x47b
[    1.435026]  ? early_idt_handler_array+0x120/0x120
[    1.435026]  x86_64_start_reservations+0x24/0x26
[    1.435026]  x86_64_start_kernel+0x13c/0x15f
[    1.435026]  start_cpu+0x14/0x14
[    1.435026] Code: ff c3 b8 f8 ff ff ff c3 66 0f 1f 84 00 00 00 00 00 66 66
66 66 90 55 48 89 e5 53 48 89 fb 48 83 ec 08 40 84 f6 75 12 85 d2 75 21 <48> 8b
47 20 a8 01 75 66 f0 80 0f 08 eb 2a 85 d2 75 35 48 89 df 
[    1.435026] RIP: page_endio+0x1a/0xa0 RSP: ffff883dbfc03d68
[    1.435026] CR2: 0000000000000020
[    1.435026] ---[ end trace cf261be33b5d0d05 ]---
[    1.435026] Kernel panic - not syncing: Fatal exception in interrupt
[    1.435026] Kernel Offset: 0x29000000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.435026] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt

and:

[    1.530432] general protection fault: 0000 [#1] SMP
[    1.531004] Modules linked in: virtio_scsi(+) virtio_console qxl
drm_kms_helper ttm drm crc32c_intel sym53c8xx serio_raw scsi_transport_spi
virtio_pci virtio_ring virtio ata_generic pata_acpi qemu_fw_cfg
[    1.531004] CPU: 0 PID: 314 Comm: systemd-udevd Not tainted
4.11.0-0.rc1.git0.1.fc26.x86_64 #1
[    1.531004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Bochs 01/01/2011
[    1.531004] task: ffff9c49760c0000 task.stack: ffffbfbcc05d8000
[    1.531004] RIP: 0010:kmem_cache_alloc+0x84/0x1b0
[    1.531004] RSP: 0018:ffffbfbcc05dbe60 EFLAGS: 00010246
[    1.531004] RAX: 2d316f6974726976 RBX: 00000000014000c0 RCX:
00007fcf9e251b30
[    1.531004] RDX: 0000000000002192 RSI: 00000000014000c0 RDI:
000000000001d780
[    1.531004] RBP: ffffbfbcc05dbe90 R08: ffff9c49bfc1d780 R09:
0000000000000077
[    1.531004] R10: 0000000000000000 R11: 0000000000000000 R12:
00000000014000c0
[    1.531004] R13: ffff9c49bd098140 R14: 2d316f6974726976 R15:
ffff9c49bd098140
[    1.531004] FS:  00007fcf9f3398c0(0000) GS:ffff9c49bfc00000(0000)
knlGS:0000000000000000
[    1.531004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.531004] CR2: 00007ffe1682ffc8 CR3: 000000003617c000 CR4:
00000000000006f0
[    1.531004] Call Trace:
[    1.531004]  ? prepare_creds+0x26/0xf0
[    1.531004]  prepare_creds+0x26/0xf0
[    1.531004]  SyS_access+0x41/0x230
[    1.531004]  do_syscall_64+0x67/0x170
[    1.531004]  entry_SYSCALL64_slow_path+0x25/0x25
[    1.531004] RIP: 0033:0x7fcf9df8651a
[    1.531004] RSP: 002b:00007ffe16830f88 EFLAGS: 00000246 ORIG_RAX:
0000000000000015
[    1.531004] RAX: ffffffffffffffda RBX: 0000556016def330 RCX:
00007fcf9df8651a
[    1.531004] RDX: 00316f6974726976 RSI: 0000000000000000 RDI:
00007ffe16830f90
[    1.531004] RBP: 00007ffe16831030 R08: 0000000000001000 R09:
0000000000000077
[    1.531004] R10: 00007fcf9e251b30 R11: 0000000000000246 R12:
00007ffe16830f90
[    1.531004] R13: 0000556016dea880 R14: 00000000ffffffea R15:
0000556015e1baf8
[    1.531004] Code: 49 83 78 10 00 4d 8b 30 0f 84 fe 00 00 00 4d 85 f6 0f 84
f5 00 00 00 49 63 47 20 49 8b 3f 4c 01 f0 40 f6 c7 0f 0f 85 21 01 00 00 <48> 8b
18 48 8d 4a 01 4c 89 f0 65 48 0f c7 0f 0f 94 c0 84 c0 74 
[    1.531004] RIP: kmem_cache_alloc+0x84/0x1b0 RSP: ffffbfbcc05dbe60
[    1.561110] ---[ end trace b9396075a1c8bec4 ]---

that one actually shows *12* general protection faults, all with the same
traceback.

-- 
You are receiving this mail because:
You are the assignee for the bug.
