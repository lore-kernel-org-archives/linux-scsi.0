From: Dmitry Vyukov <dvyukov@google.com>
Subject: sg: random memory corruptions
Date: Thu, 23 Mar 2017 16:50:22 +0100
Message-ID: <CACT4Y+aAADYiHYF8TjB-BxqC4t=Baio3ig8gAU0HzwVyrt9bLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

The following program causes random assorted memory corruptions:

https://gist.githubusercontent.com/dvyukov/da3463af2d1ff8c7d3624891b5d7427f/raw/09cf0f4af529f4506f9e0a9fa6bdb066a8777b9d/gistfile1.txt

It does some ioctl's on /dev/sg0.

general protection fault: 0000 [#1] SMP KASAN
Modules linked in:
CPU: 1 PID: 2843 Comm: rsyslogd Not tainted 4.11.0-rc3+ #365
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff880062754300 task.stack: ffff880062fc8000
RIP: 0010:__read_once_size include/linux/compiler.h:254 [inline]
RIP: 0010:radix_tree_load_root lib/radix-tree.c:602 [inline]
RIP: 0010:__radix_tree_lookup+0x12c/0x5e0 lib/radix-tree.c:1040
RSP: 0000:ffff880062fced90 EFLAGS: 00010202
RAX: 000000f37b916d5e RBX: 0000079bdc8b6ae8 RCX: ffff880062fcefa8
RDX: 0000000000000000 RSI: 0001622819596228 RDI: 0000079bdc8b6ae8
RBP: ffff880062fcef78 R08: ffffed000da135c2 R09: ffffed000da135c2
R10: 0000000000000001 R11: ffffed000da135c1 R12: ffff880062fcefa8
R13: dffffc0000000000 R14: 0000079bdc8b6ae8 R15: 0001622819596228
FS:  00007f773eae2700(0000) GS:ffff88006d080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f773eae1e30 CR3: 0000000064ac0000 CR4: 00000000001406e0
Call Trace:
 radix_tree_lookup_slot+0x78/0xe0 lib/radix-tree.c:1079
 find_get_entry+0x186/0x990 mm/filemap.c:1190
 pagecache_get_page+0x116/0xb60 mm/filemap.c:1298
 find_get_page include/linux/pagemap.h:258 [inline]
 lookup_swap_cache+0x8d/0x110 mm/swap_state.c:296
 do_swap_page+0x278/0x2110 mm/memory.c:2702
 handle_pte_fault mm/memory.c:3727 [inline]
 __handle_mm_fault+0x1747/0x3e70 mm/memory.c:3841
 handle_mm_fault+0x141/0x4f0 mm/memory.c:3878
 __do_page_fault+0x503/0xb50 arch/x86/mm/fault.c:1397
 trace_do_page_fault+0x145/0x720 arch/x86/mm/fault.c:1490
 do_async_page_fault+0x72/0xc0 arch/x86/kernel/kvm.c:264
 async_page_fault+0x28/0x30 arch/x86/entry/entry_64.S:1014
RIP: 0033:0x7f77411261fd
RSP: 002b:00007f773eae1e30 EFLAGS: 00010293
RAX: 0000000000000024 RBX: 00000000020944d0 RCX: 00007f77411261fd
RDX: 0000000000000fff RSI: 00007f77405225a0 RDI: 0000000000000004
RBP: 0000000000000000 R08: 000000000207f160 R09: 0000000004000001
R10: 0000000000000001 R11: 0000000000000293 R12: 000000000065e420
R13: 00007f773eae29c0 R14: 00007f774176b040 R15: 0000000000000003
Code: ff 42 c6 04 28 00 48 8d 85 d8 fe ff ff 48 c1 e8 03 42 c6 04 28
00 48 8b 85 48 fe ff ff c6 00 00 48 8b 85 40 fe ff ff 48 c1 e8 03 <42>
80 3c 28 00 0f 85 07 04 00 00 48 8b 85 38 fe ff ff 4c 8b 60
RIP: __read_once_size include/linux/compiler.h:254 [inline] RSP:
ffff880062fced90
RIP: radix_tree_load_root lib/radix-tree.c:602 [inline] RSP: ffff880062fced90
RIP: __radix_tree_lookup+0x12c/0x5e0 lib/radix-tree.c:1040 RSP: ffff880062fced90
---[ end trace 53d928cd2f7a08d4 ]---

BUG: unable to handle kernel paging request at 00000152000081a4
IP: qlist_move_cache+0x74/0x100 mm/kasan/quarantine.c:274
PGD 0
Oops: 0000 [#1] SMP KASAN
Modules linked in:
CPU: 0 PID: 29 Comm: kworker/u8:1 Not tainted 4.11.0-rc3+ #365
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: netns cleanup_net
task: ffff88006c096800 task.stack: ffff88006c098000
RIP: 0010:qlist_move_cache+0x74/0x100 mm/kasan/quarantine.c:274
RSP: 0018:ffff88006c09f368 EFLAGS: 00010002
RAX: 00000152000081a4 RBX: 000077ff80000000 RCX: 00000152000081a4
RDX: ffff8800696dd200 RSI: ffff88006c09f388 RDI: ffffffff865cce58
RBP: ffff88006c09f378 R08: ffff88006c019340 R09: 0000000080000000
R10: 00000152000081a4 R11: ffffea0000000000 R12: ffffea00016892ef
R13: ffffffff84fa9740 R14: ffffffff865d1760 R15: ffff8800696dd200
FS:  0000000000000000(0000) GS:ffff88006d000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000152000081a4 CR3: 0000000069898000 CR4: 00000000001406f0
Call Trace:
 quarantine_remove_cache+0x79/0xf0 mm/kasan/quarantine.c:317
 kasan_cache_shutdown+0x9/0x10 mm/kasan/kasan.c:451
 shutdown_cache mm/slab_common.c:532 [inline]
 kmem_cache_destroy+0x52/0x120 mm/slab_common.c:830
 tipc_server_stop+0x13f/0x190 net/tipc/server.c:636
 tipc_topsrv_stop+0x200/0x360 net/tipc/subscr.c:397
 tipc_exit_net+0x15/0x40 net/tipc/core.c:96
 ops_exit_list.isra.4+0xae/0x150 net/core/net_namespace.c:141
 cleanup_net+0x5c7/0xb60 net/core/net_namespace.c:463
 process_one_work+0xb20/0x1b40 kernel/workqueue.c:2097
 worker_thread+0x1b4/0x1340 kernel/workqueue.c:2231
 kthread+0x359/0x420 kernel/kthread.c:229
 ret_from_fork+0x31/0x40 arch/x86/entry/entry_64.S:430
Code: 00 8b 49 14 0f 84 87 00 00 00 4c 8b 47 08 49 89 00 48 89 47 08
48 c7 00 00 00 00 00 4c 89 d0 48 01 4f 10 4d 85 d2 74 64 48 89 c1 <4c>
8b 10 4c 01 c9 72 6d 49 89 d8 4c 01 c1 48 c1 e9 0c 4c 8d 04
RIP: qlist_move_cache+0x74/0x100 mm/kasan/quarantine.c:274 RSP: ffff88006c09f368
CR2: 00000152000081a4
---[ end trace 9db83f7c295b4f05 ]---

BUG: unable to handle kernel paging request at ffffeba5308001e0
IP: virt_to_head_page include/linux/mm.h:570 [inline]
IP: qlink_to_cache mm/kasan/quarantine.c:127 [inline]
IP: qlist_free_all+0x133/0x160 mm/kasan/quarantine.c:163
PGD 0
Oops: 0000 [#1] SMP KASAN
Modules linked in:
CPU: 3 PID: 3281 Comm: syz-executor Not tainted 4.11.0-rc3+ #365
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff880068f2e180 task.stack: ffff88005aaa0000
RIP: 0010:virt_to_head_page include/linux/mm.h:570 [inline]
RIP: 0010:qlink_to_cache mm/kasan/quarantine.c:127 [inline]
RIP: 0010:qlist_free_all+0x133/0x160 mm/kasan/quarantine.c:163
RSP: 0018:ffff88005aaa7838 EFLAGS: 00010212
RAX: 00000057000081a4 RBX: ffffea0000000000 RCX: 00000034a6100038
RDX: ffffeba5308001c0 RSI: ffff880068f2e990 RDI: 0000000000000286
RBP: ffff88005aaa7870 R08: ffffed000ffff125 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 00000057000081a4 R15: ffffffff84ec7680
FS:  00007f38772ec700(0000) GS:ffff88006d180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffeba5308001e0 CR3: 0000000061a10000 CR4: 00000000001426e0
Call Trace:
 quarantine_reduce+0x151/0x180 mm/kasan/quarantine.c:259
 kasan_kmalloc+0xd9/0xf0 mm/kasan/kasan.c:605
 kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:559
 slab_post_alloc_hook mm/slab.h:456 [inline]
 slab_alloc mm/slab.c:3408 [inline]
 kmem_cache_alloc+0x102/0x720 mm/slab.c:3570
 __split_vma+0x1b7/0x8d0 mm/mmap.c:2515
 do_munmap+0x2a0/0xfc0 mm/mmap.c:2636
 mmap_region+0x4ef/0x1670 mm/mmap.c:1616
 do_mmap+0x69b/0xd50 mm/mmap.c:1453
 do_mmap_pgoff include/linux/mm.h:2121 [inline]
 vm_mmap_pgoff+0x1ec/0x280 mm/util.c:309
 SYSC_mmap_pgoff mm/mmap.c:1503 [inline]
 SyS_mmap_pgoff+0x23b/0x5f0 mm/mmap.c:1461
 SYSC_mmap arch/x86/kernel/sys_x86_64.c:96 [inline]
 SyS_mmap+0x16/0x20 arch/x86/kernel/sys_x86_64.c:87
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x445b79
RSP: 002b:00007f38772eb858 EFLAGS: 00000282 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00000000007081f8 RCX: 0000000000445b79
RDX: 0000000000000003 RSI: 0000000000001000 RDI: 0000000020011000
RBP: 0000000000000086 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000032 R11: 0000000000000282 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f38772ec9c0 R15: 00007f38772ec700
Code: 4c 48 b9 00 00 00 80 ff 77 00 00 48 01 ca 48 bb 00 00 00 00 00
ea ff ff 48 c1 ea 0c 48 8d 0c d5 00 00 00 00 48 29 d1 48 8d 14 cb <48>
8b 4a 20 48 8d 71 ff 83 e1 01 48 0f 45 d6 4c 8b 6a 30 e9 ec
RIP: virt_to_head_page include/linux/mm.h:570 [inline] RSP: ffff88005aaa7838
RIP: qlink_to_cache mm/kasan/quarantine.c:127 [inline] RSP: ffff88005aaa7838
RIP: qlist_free_all+0x133/0x160 mm/kasan/quarantine.c:163 RSP: ffff88005aaa7838
CR2: ffffeba5308001e0
---[ end trace 39ffdc493242bddb ]---

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:
CPU: 3 PID: 6433 Comm: udevd Not tainted 4.11.0-rc2+ #340
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff880011b80880 task.stack: ffff88000ffe0000
RIP: 0010:ep_item_poll fs/eventpoll.c:805 [inline]
RIP: 0010:ep_send_events_proc+0x363/0xe80 fs/eventpoll.c:1535
RSP: 0018:ffff88000ffe7520 EFLAGS: 00010206
RAX: ffff880069b82600 RBX: ffff880069163918 RCX: 000000040001f30a
RDX: ffff880069163970 RSI: 0000000080003e69 RDI: 000000040001f34a
RBP: ffff88000ffe7820 R08: ffffed000d6604f9 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff880069163920 R14: ffff88000ffe77f8 R15: ffff88000ffe7af0
FS:  00007f2e361ac7a0(0000) GS:ffff88006e300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000104ccb8 CR3: 000000003df31000 CR4: 00000000000006e0
DR0: 0000000020000000 DR1: 0000000020000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 ep_scan_ready_list+0x3a9/0xea0 fs/eventpoll.c:631
 ep_send_events fs/eventpoll.c:1583 [inline]
 ep_poll+0x543/0xf00 fs/eventpoll.c:1686
 SYSC_epoll_wait fs/eventpoll.c:2040 [inline]
 SyS_epoll_wait+0x167/0x1f0 fs/eventpoll.c:2005
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x7f2e358bf943
RSP: 002b:00007ffd6620afc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
RAX: ffffffffffffffda RBX: 00000000020221d0 RCX: 00007f2e358bf943
RDX: 0000000000000004 RSI: 00007ffd6620b020 RDI: 0000000000000004
RBP: 0000000000000086 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f2e35b69e40
R13: 0000000002033a00 R14: 0000000000000d10 R15: 00007f2e35b6a498
Code: 00 00 48 8b 43 18 48 8d 78 28 48 89 f9 48 c1 e9 03 42 80 3c 21
00 0f 85 f1 08 00 00 48 8b 48 28 48 8d 79 40 48 89 fe 48 c1 ee 03 <42>
80 3c 26 00 0f 85 a3 08 00 00 48 89 95 50 fd ff ff 48 8b b5
RIP: ep_item_poll fs/eventpoll.c:805 [inline] RSP: ffff88000ffe7520
RIP: ep_send_events_proc+0x363/0xe80 fs/eventpoll.c:1535 RSP: ffff88000ffe7520
---[ end trace f9bae0064f40d8b7 ]---

On commit 093b995e3b55a0ae0670226ddfcb05bfbf0099ae
