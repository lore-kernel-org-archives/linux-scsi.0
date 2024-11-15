Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C37718C332
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731714365; cv=none; b=iyAAws0dv/fm8hLk6MwqAv1IhNyFF4EFvsyBfT/jCz/izEJMVrCR1GhIppI6aVOJjeYIJ7ay0J6Imdevth9DpQdFO6xyZ9yYi8dybP2cotkKP7qzMAQSqGD+V7iFZdYHQYjzsPUql+kNOkLHje+zAEvGMbIU3p4AX+9EA7Z/4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731714365; c=relaxed/simple;
	bh=3eqBJVyYZ2Kb2iHnBcg75gOY8sbJyIiVX26U8DDV48E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=q65qGZsJTbKblMCjqTEnOhwZ/ni8ABGm/4npFLBRqiNHfUUVE3Pr286n0uWFpZ0p0+g//YiwsuE+l1QVNW+h/I3LTaijOb53v2eQj7qGm5EadVgJVsr9EXnLhCELJTjzzROiTzMNnibFNs7eLPX6/jmh+Gs6giZhSi03C+Flwg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83ab1b39ab1so253015739f.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 15:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731714363; x=1732319163;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sq3UU+mp4RqV38/CZRj5iNeL+vFTuienKSLV0FxqqEA=;
        b=cSmk3U0SNODWclkMt7bBLI8C3x2Vyw1rgvDwsERONmtfas4GV86WjUijubbhYOf6nj
         hmE775xIcV9tTXeWS9kctbz9YtDxqlzLWgW5IUUADd8mHlJOma2J+UWLaDT36R/MLNvR
         yaFIRcCca1sxfc1EtpnUlJXR/NbO9Owl7hJAjtV22ytJURWmqF2gKI8HBcJq8hL3JRqC
         KjT0hpZfFNDX3x/+UtBKX/hQi+wW1hwTOTWUymnQpG/ftkTZHbixNkNa2rcBt5c/So1C
         S6gfqItApYoYWihU/p9TshyHBc25FgsFhhpcyIUwHLdPNNDRrKb4XNLsn4q/ifTBVM68
         7MfQ==
X-Forwarded-Encrypted: i=1; AJvYcCURcz4t9hb3qhoGw+El6jFPaoLjPQaSZVng297k90KTF8q2KC/Lhv7bSC1rcldcUPKufWupIpj8wRBI@vger.kernel.org
X-Gm-Message-State: AOJu0YyjKrEe0xNRR7hjDwDXWwkZRDcxkMtj5MgOXchLqezFssy9ywmW
	Jd8v7Wwpn4OM0K8UPeG3r/gr3CWK76GOhqUD3fQXeUuNSRLZclcbexOgubOBbdVHyzkZUjdcUt6
	hcDjPGdoIi0Br0vnH1ojZLB+kyzu9COkP4yKwjbTCZyqYrASZyKPij4Q=
X-Google-Smtp-Source: AGHT+IHsiY9fnuy5KSfmtF/LBOzOFYVfzxHySm2jvYenNzv3aaQSpCWs8YhfHflm8uuilyg+rnI/B+Kozot5XhHouigq/QDdpCA7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3301:b0:3a0:a80a:997c with SMTP id
 e9e14a558f8ab-3a74807f1abmr46585425ab.19.1731714363379; Fri, 15 Nov 2024
 15:46:03 -0800 (PST)
Date: Fri, 15 Nov 2024 15:46:03 -0800
In-Reply-To: <1e56d9f8-6e16-4f17-9fdb-5296bb308bdd@acm.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6737dd3b.050a0220.85a0.0005.GAE@google.com>
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in sg_release
From: syzbot <syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com>
To: bvanassche@acm.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-use-after-free Read in sg_release

==================================================================
BUG: KASAN: slab-use-after-free in sg_device_destroy+0x57/0x180 drivers/scsi/sg.c:1572
Read of size 8 at addr ffff888034a06008 by task syz.3.47/7437

CPU: 1 UID: 0 PID: 7437 Comm: syz.3.47 Not tainted 6.12.0-rc1-syzkaller-00116-g9024d215a5d3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 sg_device_destroy+0x57/0x180 drivers/scsi/sg.c:1572
 kref_put include/linux/kref.h:65 [inline]
 sg_release+0x274/0x3c0 drivers/scsi/sg.c:404
 __fput+0x23f/0x880 fs/file_table.c:431
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f301d17e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe38eabda8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f301d337a80 RCX: 00007f301d17e719
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f301d337a80 R08: 0000000000000000 R09: 00007ffe38eac09f
R10: 000000000003fdc8 R11: 0000000000000246 R12: 000000000002126f
R13: 00007ffe38eabeb0 R14: 0000000000000032 R15: ffffffffffffffff
 </TASK>

Allocated by task 1128:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __do_kmalloc_node mm/slub.c:4265 [inline]
 __kmalloc_noprof+0x1fc/0x400 mm/slub.c:4277
 kmalloc_noprof include/linux/slab.h:882 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 scsi_alloc_sdev+0x180/0xb90 drivers/scsi/scsi_scan.c:288
 scsi_probe_and_add_lun+0x1db/0x4be0 drivers/scsi/scsi_scan.c:1210
 __scsi_scan_target+0x205/0x1080 drivers/scsi/scsi_scan.c:1757
 scsi_scan_channel drivers/scsi/scsi_scan.c:1845 [inline]
 scsi_scan_host_selected+0x37e/0x690 drivers/scsi/scsi_scan.c:1874
 do_scsi_scan_host drivers/scsi/scsi_scan.c:2013 [inline]
 do_scan_async+0x138/0x7a0 drivers/scsi/scsi_scan.c:2023
 async_run_entry_fn+0xa8/0x420 kernel/async.c:129
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Freed by task 6911:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2343 [inline]
 slab_free mm/slub.c:4580 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4728
 scsi_device_dev_release+0xbfb/0xf40 drivers/scsi/scsi_sysfs.c:519
 device_release+0x99/0x1c0
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 scsi_device_put+0x7e/0x90 drivers/scsi/scsi.c:792
 sg_remove_sfp_usercontext+0x354/0x4d0 drivers/scsi/sg.c:2237
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff888034a06000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 8 bytes inside of
 freed 4096-byte region [ffff888034a06000, ffff888034a07000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x34a00
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 00fff00000000003 ffffea0000d28001 ffffffffffffffff 0000000000000000
head: ffff888000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6939, tgid 6939 (kworker/1:8), ts 132642795076, free_ts 132531180778
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2413
 allocate_slab+0x5a/0x2f0 mm/slub.c:2579
 new_slab mm/slub.c:2632 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3819
 __slab_alloc+0x58/0xa0 mm/slub.c:3909
 __slab_alloc_node mm/slub.c:3962 [inline]
 slab_alloc_node mm/slub.c:4123 [inline]
 __do_kmalloc_node mm/slub.c:4264 [inline]
 __kmalloc_node_track_caller_noprof+0x281/0x440 mm/slub.c:4284
 kmalloc_reserve+0x111/0x2a0 net/core/skbuff.c:609
 __alloc_skb+0x1f3/0x440 net/core/skbuff.c:678
 alloc_skb include/linux/skbuff.h:1322 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:748 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:805 [inline]
 nsim_dev_trap_report_work+0x254/0xaa0 drivers/net/netdevsim/dev.c:850
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
page last free pid 7491 tgid 7491 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 discard_slab mm/slub.c:2678 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3146
 put_cpu_partial+0x17c/0x250 mm/slub.c:3221
 __slab_free+0x2ea/0x3d0 mm/slub.c:4450
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4086 [inline]
 slab_alloc_node mm/slub.c:4135 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4142
 alloc_empty_file+0x9e/0x1d0 fs/file_table.c:209
 path_openat+0x107/0x3590 fs/namei.c:3919
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_open_execat fs/exec.c:901 [inline]
 alloc_bprm+0x178/0xe20 fs/exec.c:1509
 do_execveat_common+0x18c/0x6f0 fs/exec.c:1903
 do_execve fs/exec.c:2026 [inline]
 __do_sys_execve fs/exec.c:2102 [inline]
 __se_sys_execve fs/exec.c:2097 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2097
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888034a05f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034a05f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888034a06000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888034a06080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888034a06100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         9024d215 sg: Fix a use-after-free in sg_release()
git tree:       https://github.com/bvanassche/linux.git scsi-for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16a8d130580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4f1b8d0c0075849
dashboard link: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
