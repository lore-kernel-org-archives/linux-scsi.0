Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA4F1DA23
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731678965; cv=none; b=hRB3e9erE1/dyZIEJjJ7RddCIl+456sXfGvRQEz5zf0lNSiPMBA4i+z6EoPdIzMgx9CpC1WCJdmdnubLGkM8DwohmOO705GZM7nt1ZZnleJlaH+Lg/dua+MR34KtWlKqPOqBLE7mqeM+QqiZpw7UzsuWJ58YO/2pApPNvw8BH/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731678965; c=relaxed/simple;
	bh=O1PLYZ5NpsNaAdnMUOiwZU+B0X2ZXdySU8zA6/C8420=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tczAwmskdhTAPdTgQazqw0v6DcdyXtGsCCOiVwVrHopbUDCjqYF2O+L8aI5ROrNrxSyfIro+ysLgFBD7YefCv5k3K/aWzFqbnJUA+QLqt8BsDXxRDZEOT1p8NIagDqAhOTluoqNEae2p5SgTiqheDVxvAvxOUKMCw/sRnT9jqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83abd63a132so149568039f.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 05:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731678963; x=1732283763;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c75OfcVgum07Js2p2+nMWiw9wbfGMjjt39XIrZFD5wE=;
        b=bV6lcUH8m/YCh8m7GfALpcek7wsWOKQZn1QecCXO3rv/4I2jiYvAk3pDCH4Pnh/E6N
         qPmXuUA4KOz8nb+iIaRP9vzFJllBQ+1SSb6mvbjIBvLsmjjN7IxU+B8ivd1jBqWR7tbw
         7z9WWvvVPfvErkbw0zVEwaKIVnzYj0NJOm2ODcv2x/d/OPZ8tH9qAX/5eCeOd82pm1xJ
         Ao2o7EJth7mJSxnekPiEsh7YFCZ0Zc+B3NzjpJdf1xGI3ZrAB9kIrnPr03aI6Puxbbuc
         9Uo+JqKid/p03+F8/a2L2a/k7TDrpUfnLnTnVLkKfZEQp1cDJoaEnjEN9hhVky54l2k4
         GfOg==
X-Forwarded-Encrypted: i=1; AJvYcCUbiWH5C60atdXSgZUvhAwuMN2fiEXOaA3qcYc1aO+C+nK+4CuIUOtMabgfgjK5PP8ZgMcBpA9Bl0aZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzll9TwbSbhyMhuvE03AyOqLk5TU9EXG7Bd/49e/aweOQhkdoZG
	cAj7dadMHTzD8OCtGssiIibu0sHpPzdJ7TXYENbGRMY0w1sisDQifgv32XnOH3MxTrnOyWR9eV7
	oyKXfubuP8afJVmZdIAVmffTK5uF3k7RMsyissl68QXEhBh63FVGiZcg=
X-Google-Smtp-Source: AGHT+IGDeU3ob7qC/S+oSytH861Y+Zwa6oXIGsc4ziek7a4xEwyZKRJGIp4MXNVB7k2e8h8z8Pr5PQbTd5UabZSqTQUmeYs35MRl
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3890:b0:3a7:1f23:1a46 with SMTP id
 e9e14a558f8ab-3a746ae37e9mr31380255ab.0.1731678962770; Fri, 15 Nov 2024
 05:56:02 -0800 (PST)
Date: Fri, 15 Nov 2024 05:56:02 -0800
In-Reply-To: <CAHiZj8jTbEc3SWFu81wkyZniiab6DgXV9W-EEHKXNnuCndHGeQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673752f2.050a0220.2a2fcc.007c.GAE@google.com>
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in sg_release
From: syzbot <syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com>
To: dgilbert@interlog.com, james.bottomley@hansenpartnership.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-usb@vger.kernel.org, martin.petersen@oracle.com, 
	surajsonawane0215@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-use-after-free Read in sg_release

==================================================================
BUG: KASAN: slab-use-after-free in sg_release+0x2a4/0x2e0 drivers/scsi/sg.c:397
Read of size 4 at addr ffff88807eec5148 by task syz.0.33/7177

CPU: 1 UID: 0 PID: 7177 Comm: syz.0.33 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 sg_release+0x2a4/0x2e0 drivers/scsi/sg.c:397
 __fput+0x23f/0x880 fs/file_table.c:431
 task_work_run+0x24f/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8726b7e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd5cfff398 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f8726d37a80 RCX: 00007f8726b7e719
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f8726d37a80 R08: 0000000000000000 R09: 00007ffd5cfff68f
R10: 000000000003fdc8 R11: 0000000000000246 R12: 000000000001fb17
R13: 00007ffd5cfff4a0 R14: 0000000000000032 R15: ffffffffffffffff
 </TASK>

Allocated by task 12:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4295
 kmalloc_noprof include/linux/slab.h:878 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 sg_alloc drivers/scsi/sg.c:1444 [inline]
 sg_add_device+0x139/0xb10 drivers/scsi/sg.c:1518
 device_add+0xa1f/0xbf0 drivers/base/core.c:3695
 scsi_sysfs_add_sdev+0x306/0x5a0 drivers/scsi/scsi_sysfs.c:1435
 scsi_sysfs_add_devices drivers/scsi/scsi_scan.c:1896 [inline]
 scsi_finish_async_scan drivers/scsi/scsi_scan.c:1981 [inline]
 do_scan_async+0x42a/0x7a0 drivers/scsi/scsi_scan.c:2024
 async_run_entry_fn+0xa8/0x420 kernel/async.c:129
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Freed by task 3067:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4727
 kref_put include/linux/kref.h:65 [inline]
 sg_remove_sfp_usercontext+0x331/0x4d0 drivers/scsi/sg.c:2239
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff88807eec5000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 328 bytes inside of
 freed 512-byte region [ffff88807eec5000, ffff88807eec5200)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807eec7800 pfn:0x7eec4
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000240 ffff88801ac41c80 ffffea0000cae210 ffffea0000cb7810
raw: ffff88807eec7800 000000000010000a 00000001f5000000 0000000000000000
head: 00fff00000000240 ffff88801ac41c80 ffffea0000cae210 ffffea0000cb7810
head: ffff88807eec7800 000000000010000a 00000001f5000000 0000000000000000
head: 00fff00000000002 ffffea0001fbb101 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6550, tgid 6550 (syz-executor), ts 104531524508, free_ts 104299146915
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3649/0x3790 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4750
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x140 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4276
 kmalloc_noprof include/linux/slab.h:882 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 __alloc_workqueue+0x10a/0x1f20 kernel/workqueue.c:5655
 alloc_workqueue+0xd6/0x210 kernel/workqueue.c:5758
 wg_newlink+0x1a8/0x640 drivers/net/wireguard/device.c:333
 rtnl_newlink_create net/core/rtnetlink.c:3539 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3759 [inline]
 rtnl_newlink+0x1591/0x20a0 net/core/rtnetlink.c:3772
 rtnetlink_rcv_msg+0x73f/0xcf0 net/core/rtnetlink.c:6675
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2536
 netlink_unicast_kernel net/netlink/af_netlink.c:1316 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1342
page last free pid 12 tgid 12 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xdf9/0x1140 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2677 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3145
 put_cpu_partial+0x17c/0x250 mm/slub.c:3220
 __slab_free+0x2ea/0x3d0 mm/slub.c:4449
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 __kmalloc_cache_noprof+0x132/0x2c0 mm/slub.c:4290
 kmalloc_noprof include/linux/slab.h:878 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 ipv6_add_addr+0x580/0x1090 net/ipv6/addrconf.c:1114
 addrconf_add_linklocal+0x36c/0xa30 net/ipv6/addrconf.c:3317
 addrconf_addr_gen+0x510/0xbb0
 addrconf_dev_config net/ipv6/addrconf.c:3494 [inline]
 addrconf_init_auto_addrs+0x96a/0xeb0 net/ipv6/addrconf.c:3572
 addrconf_notify+0xaff/0x1020 net/ipv6/addrconf.c:3745
 notifier_call_chain+0x19f/0x3e0 kernel/notifier.c:93
 netdev_state_change+0x11f/0x1a0 net/core/dev.c:1378
 linkwatch_do_dev+0x112/0x170 net/core/link_watch.c:177

Memory state around the buggy address:
 ffff88807eec5000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807eec5080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807eec5100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88807eec5180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807eec5200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


Tested on:

commit:         cfaaa7d0 Merge tag 'net-6.12-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=118b82e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=155382e8580000

