Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEF58460
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jun 2025 02:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749089735; cv=none; b=gW03QgppGtm7jL7rDxwfSeJ24sxn1OBlR7AaFsUlafo7x3qGjesI4uxsBjvbbpzRymX+UxOoxCPKfZMPQo2Enh8N8QMByzO8+G6XNqjgjvaT2TcPVDahyA14lA2BZhjSBfSeyytkcVdsNDqDXdTY+gF8qn3mwiGwaSLdCw9GPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749089735; c=relaxed/simple;
	bh=OKqjIkAt1M0nGu1Bc1K1MhkqVY/36iPWBWVeGXyUdZ8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pAplvfzkLVxLZz/4ib2GkY09L29EVmBH4hqEMDcpm18Rf3HsKV272VGrGNwEdRJfked7w59YG6Sx5EfLh7Plfvuh2JQDWQ0ByuY8yrF86/oBmTZ8/jqLC7njND10B1wlRWIVsnbApIw9hEPaSvC238nGrMsUknBuZAFsnnVTwBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddb9d32cfeso10216575ab.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2025 19:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749089732; x=1749694532;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gaJMOVzCvZ54gdZ0QfQJJiCN1xUxY6OMN696yAOJECU=;
        b=M2ZHyltGKpg0PrNwskwwfT+/+5wE9fCqENUVoJEng2CilXWa+tBKROM8iaXr7rQH1Q
         ZwWCFFs2F23yGoB2FnmAEXkivjTyoQ3Z9JHVmfRc6JHaUuRhYuPGrj5DwzgWC1TQ3wI8
         9AhHR+LyK2OvAuUnZpAqsdPZWmePdp6Pu0XDIRMYLlJ5aAsHs/2AalFlAjbUWItXHxBy
         EaFeQbdcpwHbZ79AxYVfIsTIL5RcKeGKkuI3n+aeaC5Sv7vwIlHf1fIjwMWHMfak1cL9
         f0lklT0Ebvk+LkyCLPGimlHEbLGGW54ep1zoly/+8DV/+xt715cyZvs5KjlkmtxtJMgq
         u0zQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqt3TruHcna0L4+ZBKIrUcxKxsxj8lf2RRgCfo/mTtr05LtwUDR48y0aMbVLN1SE+CJVvvPcjLG+oG@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd96KPSI6z4ntZ7p0oAJowlAljeHFq99EzneEFTnGfzL6vOUmh
	ehQkq0GDCYaBgOFICzQcyKzf2H28Z5D3an1wKoDpuH0DNUPazjVL2TSw7zYD7mmQe/JO/SNKbcs
	9NeUNDxspm/6A+VBludPZW/aHEd0oiPCIitLdUoSXAAG6IzofJjuTzGB8ezg=
X-Google-Smtp-Source: AGHT+IEHYGZDHF1gzdg0Mx9f90PfT0gX9qo+luirUu1IAxY6W8C9sQzLXiw+fQf2fRa3p1hjEtqbailhoPhTMFN8odA6Kdflr65k
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c241:0:b0:3dc:7a9a:44d5 with SMTP id
 e9e14a558f8ab-3ddbedc8c8fmr68982925ab.22.1749089732423; Wed, 04 Jun 2025
 19:15:32 -0700 (PDT)
Date: Wed, 04 Jun 2025 19:15:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6840fdc4.a00a0220.68b4a.000d.GAE@google.com>
Subject: [syzbot] [scsi?] [mm?] [block?] BUG: soft lockup in sys_sendmsg (2)
From: syzbot <syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com>
To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b4432656b36e Linux 6.15-rc4
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=13d76f68580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9a25b7a36123454
dashboard link: https://syzkaller.appspot.com/bug?extid=4032319a6a907f69e985
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c9ea4f1822ea/disk-b4432656.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5effc66ca81/vmlinux-b4432656.xz
kernel image: https://storage.googleapis.com/syzbot-assets/49364ea611a8/bzImage-b4432656.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#1 stuck for 120s! [syz.0.1:5966]
Modules linked in:
irq event stamp: 19582471
hardirqs last  enabled at (19582470): [<ffffffff8b55e3c4>] irqentry_exit+0x74/0x90 kernel/entry/common.c:357
hardirqs last disabled at (19582471): [<ffffffff8b55cdbe>] sysvec_apic_timer_interrupt+0xe/0xc0 arch/x86/kernel/apic/apic.c:1049
softirqs last  enabled at (17326936): [<ffffffff8185c3fa>] __do_softirq kernel/softirq.c:613 [inline]
softirqs last  enabled at (17326936): [<ffffffff8185c3fa>] invoke_softirq kernel/softirq.c:453 [inline]
softirqs last  enabled at (17326936): [<ffffffff8185c3fa>] __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
softirqs last disabled at (17326939): [<ffffffff8185c3fa>] __do_softirq kernel/softirq.c:613 [inline]
softirqs last disabled at (17326939): [<ffffffff8185c3fa>] invoke_softirq kernel/softirq.c:453 [inline]
softirqs last disabled at (17326939): [<ffffffff8185c3fa>] __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
CPU: 1 UID: 0 PID: 5966 Comm: syz.0.1 Not tainted 6.15.0-rc4-syzkaller-gb4432656b36e #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:rcu_read_unlock_special+0x87/0x4c0 kernel/rcu/tree_plugin.h:694
Code: f1 f1 f1 00 f2 f2 f2 4a 89 04 2b 66 42 c7 44 2b 09 f3 f3 42 c6 44 2b 0b f3 65 44 8b 35 e2 a3 cd 10 41 f7 c6 00 00 f0 00 74 49 <48> c7 44 24 40 0e 36 e0 45 4a c7 04 2b 00 00 00 00 66 42 c7 44 2b
RSP: 0018:ffffc90000a08680 EFLAGS: 00000206
RAX: 1a3e8c94b0fc9100 RBX: 1ffff920001410d8 RCX: 1a3e8c94b0fc9100
RDX: 0000000000000003 RSI: ffffffff8d749f78 RDI: ffffffff8bc1cde0
RBP: ffffc90000a08778 R08: ffffffff8f7ed377 R09: 1ffffffff1efda6e
R10: dffffc0000000000 R11: fffffbfff1efda6f R12: ffffffff8df40c00
R13: dffffc0000000000 R14: 0000000000000246 R15: 0000000000000002
FS:  00007fc1f490f6c0(0000) GS:ffff8881261cc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555566fd55c8 CR3: 000000002fd82000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __rcu_read_unlock+0x84/0xe0 kernel/rcu/tree_plugin.h:438
 rcu_read_unlock include/linux/rcupdate.h:873 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1155 [inline]
 unwind_next_frame+0x19ae/0x2390 arch/x86/kernel/unwind_orc.c:680
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2398 [inline]
 slab_free mm/slub.c:4656 [inline]
 kmem_cache_free+0x192/0x3f0 mm/slub.c:4758
 bvec_free block/bio.c:167 [inline]
 bio_free+0x1b7/0x2a0 block/bio.c:236
 blk_update_request+0x5ee/0xe80 block/blk-mq.c:983
 scsi_end_request+0x7c/0x830 drivers/scsi/scsi_lib.c:638
 scsi_io_completion+0x131/0x390 drivers/scsi/scsi_lib.c:1079
 blk_complete_reqs block/blk-mq.c:1220 [inline]
 blk_done_softirq+0x107/0x160 block/blk-mq.c:1225
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_irq_work arch/x86/kernel/irq_work.c:17 [inline]
 sysvec_irq_work+0xa3/0xc0 arch/x86/kernel/irq_work.c:17
 </IRQ>
 <TASK>
 asm_sysvec_irq_work+0x1a/0x20 arch/x86/include/asm/idtentry.h:738
RIP: 0010:__schedule+0x0/0x4cd0 kernel/sched/core.c:6646
Code: cb f6 45 89 f8 89 d9 48 8b 5c 24 08 e9 ee fe ff ff cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 e4 e0 48
RSP: 0018:ffffc90004f66e98 EFLAGS: 00000246
RAX: 1ffff11005ed429c RBX: ffffffff8b56f5de RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffff8d749f78 RDI: 0000000000000001
RBP: ffffc90004f66f38 R08: ffffffff8f7ed377 R09: 1ffffffff1efda6e
R10: dffffc0000000000 R11: fffffbfff1efda6f R12: dffffc0000000000
R13: ffff888032138000 R14: ffff88802f6a14e0 R15: dffffc0000000000
 preempt_schedule_common+0x83/0xd0 kernel/sched/core.c:6947
 preempt_schedule+0xae/0xc0 kernel/sched/core.c:6971
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 _raw_spin_unlock_irqrestore+0xfd/0x110 kernel/locking/spinlock.c:194
 __debug_check_no_obj_freed lib/debugobjects.c:1108 [inline]
 debug_check_no_obj_freed+0x451/0x470 lib/debugobjects.c:1129
 free_pages_prepare mm/page_alloc.c:1269 [inline]
 __free_frozen_pages+0x403/0xcd0 mm/page_alloc.c:2725
 __slab_free+0x326/0x400 mm/slub.c:4567
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4161 [inline]
 slab_alloc_node mm/slub.c:4210 [inline]
 __do_kmalloc_node mm/slub.c:4340 [inline]
 __kmalloc_noprof+0x224/0x4f0 mm/slub.c:4353
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kmalloc_array_noprof include/linux/slab.h:948 [inline]
 genl_family_rcv_msg_attrs_parse+0xa3/0x2a0 net/netlink/genetlink.c:940
 genl_start+0x180/0x6c0 net/netlink/genetlink.c:980
 __netlink_dump_start+0x466/0x7e0 net/netlink/af_netlink.c:2415
 genl_family_rcv_msg_dumpit+0x1e7/0x2c0 net/netlink/genetlink.c:1076
 genl_family_rcv_msg net/netlink/genetlink.c:1192 [inline]
 genl_rcv_msg+0x5da/0x790 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x219/0x490 net/netlink/af_netlink.c:2534
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
 netlink_unicast+0x758/0x8d0 net/netlink/af_netlink.c:1339
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:727
 ____sys_sendmsg+0x505/0x830 net/socket.c:2566
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
 __sys_sendmsg net/socket.c:2652 [inline]
 __do_sys_sendmsg net/socket.c:2657 [inline]
 __se_sys_sendmsg net/socket.c:2655 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc1f3b8e969
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc1f490f038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc1f3db6160 RCX: 00007fc1f3b8e969
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007fc1f3c10ab1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fc1f3db6160 R15: 00007fff4aca2068
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.15.0-rc4-syzkaller-gb4432656b36e #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:rcu_rdp_cpu_online kernel/rcu/tree.c:3953 [inline]
RIP: 0010:rcu_lockdep_current_cpu_online+0x87/0x120 kernel/rcu/tree.c:3994
Code: 3c 30 00 74 08 48 89 df e8 96 87 7a 00 48 8b 03 48 8d 98 00 eb 76 92 48 8d b8 20 eb 76 92 48 89 f8 48 c1 e8 03 42 80 3c 30 00 <74> 05 e8 72 87 7a 00 4c 8b 7b 20 48 83 c3 18 48 89 d8 48 c1 e8 03
RSP: 0018:ffffc90000a87830 EFLAGS: 00000046
RAX: 1ffff11017107564 RBX: ffff8880b883ab00 RCX: af84634d00986b00
RDX: ffff88801dae3c00 RSI: ffffffff8bc1cdc0 RDI: ffff8880b883ab20
RBP: ffffc90000a87958 R08: 0000000000000000 R09: 0000000000080000
R10: 0000000000000000 R11: ffffffff81cad457 R12: 0000000000000001
R13: ffffc90000a878e0 R14: dffffc0000000000 R15: ffffffff8df9be88
FS:  0000000000000000(0000) GS:ffff8881260cc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f397e3da1d0 CR3: 000000002fd82000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rcu_read_lock_held_common kernel/rcu/update.c:113 [inline]
 rcu_read_lock_held+0x1e/0x50 kernel/rcu/update.c:349
 trace_call_bpf+0x1ad/0x850 kernel/trace/bpf_trace.c:146
 perf_trace_run_bpf_submit+0x78/0x170 kernel/events/core.c:10788
 do_perf_trace_preemptirq_template include/trace/events/preemptirq.h:14 [inline]
 perf_trace_preemptirq_template+0x280/0x340 include/trace/events/preemptirq.h:14
 __do_trace_irq_disable include/trace/events/preemptirq.h:36 [inline]
 trace_irq_disable+0xee/0x110 include/trace/events/preemptirq.h:36
 irqentry_enter+0x3d/0x60 kernel/entry/common.c:297
 sysvec_apic_timer_interrupt+0xe/0xc0 arch/x86/kernel/apic/apic.c:1049
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 [inline]
RIP: 0010:vprintk_emit+0x58f/0x7a0 kernel/printk/printk.c:2449
Code: 85 32 01 00 00 e8 41 f3 1e 00 41 89 df 4d 85 f6 48 8b 1c 24 75 07 e8 30 f3 1e 00 eb 06 e8 29 f3 1e 00 fb 48 c7 c7 80 fa f2 8d <31> f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 f9 3f
RSP: 0018:ffffc90000a87b80 EFLAGS: 00000293
RAX: ffffffff81a0cba7 RBX: ffffffff81a0ca64 RCX: ffff88801dae3c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8df2fa80
RBP: ffffc90000a87c90 R08: ffffffff8f7ed377 R09: 1ffffffff1efda6e
R10: dffffc0000000000 R11: fffffbfff1efda6f R12: dffffc0000000000
R13: 1ffff92000150f74 R14: 0000000000000200 R15: 000000000000003d
 _printk+0xcf/0x120 kernel/printk/printk.c:2475
 check_hung_task kernel/hung_task.c:181 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:265 [inline]
 watchdog+0xb4f/0x1030 kernel/hung_task.c:437
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
