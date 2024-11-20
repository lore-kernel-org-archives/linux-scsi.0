Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23DE171650;
	Wed, 20 Nov 2024 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732090795; cv=none; b=INBTo2dqDcehoPx7I6+P7IMy6J4gKl+hnPy2rB5EnBHXXbxD2XK3aZXEAvQhLXOxtP0JnXbbHt6ZHlQrcp3PXZslTJnFCw7uDx7K/ogNp9Bmpeaz82ynqMkXX6vFK1EA4vUWB/kKQi4EhC3w7sU7vO91EVc+zskp+rGTTklIOFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732090795; c=relaxed/simple;
	bh=+8BuvYtZsOPr9kBdC8QbRED12MdqVdSlkBGMJuDCJjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bs+IwABZSBG5eCgxHeBUQGw5bB5PYLbkC8ymw5Du7up0Jsz0DtBmaTLaRbrSqxjld9gvx+y5JsIyMpgav07IMhI5J73Tczzpjnl1spKgCeim/vI/upBCXfXD0iS34CwUjj+Z4nDvKVmeDBsPMc1kit0ZWfRStwZ5OxzQsSCWbYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEsaozck; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEsaozck"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cfd2978f95so3637869a12.0;
        Wed, 20 Nov 2024 00:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732090791; x=1732695591; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4uuJ3a38WMIE6XMWpfpcC64PqdPOj8XHBZMF9yo+uQI=;
        b=YEsaozckoT4Y6hj4DZUe/CdMvs+0EXXvYz/nMRmClXs2SyTrEpKbGVXYEoY4ve2Meg
         uA1cFqPnVYbB2XWY9h8So0Qmj/nKbS7hloYbeYweADobByJOs4sCNPNz9EqOnT8KAH16
         wgBeVr/26zDriXMsY1occjQOsQqZklQBlNO1GNcj16YFPfwqzjVZMVJ27i44vl2TGc5M
         S5dMRVcIC6Z8VYLqpIWVGjYFVP/L8QTfVnqY0FAB0o6+NFcrQCrPQjcDuIDEHz/E8Hcy
         +7/nLMLmUgdmSXyucCMKArJwm8PBamdgMheR0+7K0vpJ/4vx9V7IEwJVC/Z+p4c83FUW
         J/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732090791; x=1732695591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4uuJ3a38WMIE6XMWpfpcC64PqdPOj8XHBZMF9yo+uQI=;
        b=Vw3iQAXDdMKY1xVq4FVsrV29uDf0tWftuTpTYbG5Rn8ggYOoOFmTmzF5I4pFFR//mk
         C2WgkYdhxkls3KYnkOPNiRxIF8vSIWv8XsKt5ahaEJkx9h3FkI+20qtr6qBHbqcrH72K
         fT5DqTujhRb7eivFoVIkmdOeI098h0t3daVFjFHX6/ucgDzasqe9OeWgkZOL7ZSSiQKw
         1CgvkgH2EMHDFw+rdvXkeyT8AJXzP+wTz9A5z2WS2zvjgdpfj4+99uFjQLdrN8+MacfB
         VXB6SwRcJIX2B7+wrwWmniwD7PI4R1EoyzvdZEc9S8eeX41ZRMFE+jzNe7InuZ7QCk+X
         Kj4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7ArOim1wRSTFeb3WimJYjWkcZRZBCRBX/IOtzNjB5QuZOZB1NsF8iMcQbYxOpRxVyF/VU1+ZzCImVqPY=@vger.kernel.org, AJvYcCWZ2EIhmBGkmj+5PyP4jQ1gn/ddRPiupxn97BxKdLHYFfHO0zjn+IT+AjcC/Woj4ERdrAE8vpiYkcfahQ==@vger.kernel.org, AJvYcCXM9qO1A9bo0tOSxLtbAbQK2lhurz5t+1VE7nuqr8L4Vw+PNL1zAbW+OmKBQjxfx/qEcRsgvtb7R6dp@vger.kernel.org
X-Gm-Message-State: AOJu0YyjPCYKgonR87ZHIL/EYaTdFJQ3DfFMfnKa4JsNQCioQul5W/My
	nhnJIyrBV4YjuO0XOTpAj2GVygiCU4DoQIDN1+7T8ovTxqC6KBlDMmjcSe2Pu0azaC2NPqNVoUV
	RB5GmlvTKDhI90KDfNYQUcHpZbbk=
X-Google-Smtp-Source: AGHT+IFd7vpMIhTI8ROSmsEuVS0Cj23n37mwKiKnDm/tBRLgQEqw8lV+KpB8xBULCWH55hcihKLoFXBFzCdEFJfJaTs=
X-Received: by 2002:a17:907:970f:b0:a99:f92a:7a66 with SMTP id
 a640c23a62f3a-aa4dd59f541mr168174866b.30.1732090790999; Wed, 20 Nov 2024
 00:19:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <672b574b.050a0220.2edce.1523.GAE@google.com>
In-Reply-To: <672b574b.050a0220.2edce.1523.GAE@google.com>
From: Suraj Sonawane <surajsonawane0215@gmail.com>
Date: Wed, 20 Nov 2024 13:49:14 +0530
Message-ID: <CAHiZj8hBjro1gqmVt7L8La2vBBNTa0VUY1kdb1i1kNJ-x_Dazg@mail.gmail.com>
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in sg_release
To: syzbot <syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com>
Cc: James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-usb@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="00000000000051b08c062753d053"

--00000000000051b08c062753d053
Content-Type: multipart/alternative; boundary="00000000000051b08b062753d051"

--00000000000051b08b062753d051
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz test

On Wed, Nov 6, 2024 at 5:17=E2=80=AFPM syzbot <
syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com> wrote:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    11066801dd4b Merge tag 'linux_kselftest-fixes-6.12-rc6'
> of..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16146aa798000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D672325e7ab17f=
df7
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=3D7efb5850a17ba6ce098b
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for
> Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14e8755f980=
000
>
> Downloadable assets:
> disk image:
> https://storage.googleapis.com/syzbot-assets/d5100fe708c2/disk-11066801.r=
aw.xz
> vmlinux:
> https://storage.googleapis.com/syzbot-assets/581317b0fef2/vmlinux-1106680=
1.xz
> kernel image:
> https://storage.googleapis.com/syzbot-assets/c7571fdba64f/bzImage-1106680=
1.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit:
> Reported-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
> kernel/locking/lockdep.c:5838
> Read of size 8 at addr ffff8880312a38c0 by task syz.2.335/8457
>
> CPU: 1 UID: 0 PID: 8457 Comm: syz.2.335 Not tainted
> 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:377 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:488
>  kasan_report+0x143/0x180 mm/kasan/report.c:601
>  lock_release+0x151/0xa30 kernel/locking/lockdep.c:5838
>  __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
>  sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407
>  __fput+0x23f/0x880 fs/file_table.c:431
>  task_work_run+0x24f/0x310 kernel/task_work.c:239
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
>  do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f312af7e719
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdb5d17628 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007f312b137a80 RCX: 00007f312af7e719
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007f312b137a80 R08: 0000000000000000 R09: 00007ffdb5d1791f
> R10: 000000000003fdc8 R11: 0000000000000246 R12: 000000000005f4a4
> R13: 00007ffdb5d17730 R14: 0000000000000032 R15: ffffffffffffffff
>  </TASK>
>
> Allocated by task 7133:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>  __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
>  kasan_kmalloc include/linux/kasan.h:257 [inline]
>  __kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4295
>  kmalloc_noprof include/linux/slab.h:878 [inline]
>  kzalloc_noprof include/linux/slab.h:1014 [inline]
>  sg_alloc drivers/scsi/sg.c:1444 [inline]
>  sg_add_device+0x139/0xb10 drivers/scsi/sg.c:1518
>  device_add+0xa1f/0xbf0 drivers/base/core.c:3698
>  scsi_sysfs_add_sdev+0x306/0x5a0 drivers/scsi/scsi_sysfs.c:1435
>  scsi_sysfs_add_devices drivers/scsi/scsi_scan.c:1896 [inline]
>  scsi_finish_async_scan drivers/scsi/scsi_scan.c:1981 [inline]
>  do_scan_async+0x42a/0x7a0 drivers/scsi/scsi_scan.c:2024
>  async_run_entry_fn+0xa8/0x420 kernel/async.c:129
>  process_one_work kernel/workqueue.c:3229 [inline]
>  process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
>  worker_thread+0x870/0xd30 kernel/workqueue.c:3391
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Freed by task 6000:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
>  poison_slab_object mm/kasan/common.c:247 [inline]
>  __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
>  kasan_slab_free include/linux/kasan.h:230 [inline]
>  slab_free_hook mm/slub.c:2342 [inline]
>  slab_free mm/slub.c:4579 [inline]
>  kfree+0x1a0/0x440 mm/slub.c:4727
>  kref_put include/linux/kref.h:65 [inline]
>  sg_remove_sfp_usercontext+0x331/0x4d0 drivers/scsi/sg.c:2238
>  process_one_work kernel/workqueue.c:3229 [inline]
>  process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
>  worker_thread+0x870/0xd30 kernel/workqueue.c:3391
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> The buggy address belongs to the object at ffff8880312a3800
>  which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 192 bytes inside of
>  freed 512-byte region [ffff8880312a3800, ffff8880312a3a00)
>
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000
> index:0xffff8880312a2000 pfn:0x312a0
> head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000000240(workingset|head|node=3D0|zone=3D1|lastcpupid=3D0x=
7ff)
> page_type: f5(slab)
> raw: 00fff00000000240 ffff88801ac41c80 ffffea00010c8910 ffffea0001fcb310
> raw: ffff8880312a2000 000000000010000d 00000001f5000000 0000000000000000
> head: 00fff00000000240 ffff88801ac41c80 ffffea00010c8910 ffffea0001fcb310
> head: ffff8880312a2000 000000000010000d 00000001f5000000 0000000000000000
> head: 00fff00000000002 ffffea0000c4a801 ffffffffffffffff 0000000000000000
> head: ffff888000000004 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask
> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOM=
EMALLOC),
> pid 5224, tgid 5224 (udevd), ts 31207973672, free_ts 31004401902
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
>  prep_new_page mm/page_alloc.c:1545 [inline]
>  get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
>  __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
>  alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
>  alloc_slab_page+0x6a/0x120 mm/slub.c:2412
>  allocate_slab+0x5a/0x2f0 mm/slub.c:2578
>  new_slab mm/slub.c:2631 [inline]
>  ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
>  __slab_alloc+0x58/0xa0 mm/slub.c:3908
>  __slab_alloc_node mm/slub.c:3961 [inline]
>  slab_alloc_node mm/slub.c:4122 [inline]
>  __kmalloc_cache_noprof+0x1d5/0x2c0 mm/slub.c:4290
>  kmalloc_noprof include/linux/slab.h:878 [inline]
>  kzalloc_noprof include/linux/slab.h:1014 [inline]
>  kernfs_fop_open+0x3e0/0xd10 fs/kernfs/file.c:623
>  do_dentry_open+0x978/0x1460 fs/open.c:958
>  vfs_open+0x3e/0x330 fs/open.c:1088
>  do_open fs/namei.c:3774 [inline]
>  path_openat+0x2c84/0x3590 fs/namei.c:3933
>  do_filp_open+0x235/0x490 fs/namei.c:3960
>  do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
>  do_sys_open fs/open.c:1430 [inline]
>  __do_sys_openat fs/open.c:1446 [inline]
>  __se_sys_openat fs/open.c:1441 [inline]
>  __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
> page last free pid 16 tgid 16 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1108 [inline]
>  free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
>  rcu_do_batch kernel/rcu/tree.c:2567 [inline]
>  rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
>  handle_softirqs+0x2c5/0x980 kernel/softirq.c:554
>  run_ksoftirqd+0xca/0x130 kernel/softirq.c:927
>  smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Memory state around the buggy address:
>  ffff8880312a3780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8880312a3800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8880312a3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff8880312a3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880312a3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit
> https://groups.google.com/d/msgid/syzkaller-bugs/672b574b.050a0220.2edce.=
1523.GAE%40google.com
> .
>

--00000000000051b08b062753d051
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">#syz test<br></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Wed, Nov 6, 2024 at 5:17=E2=80=AFPM syzbot=
 &lt;<a href=3D"mailto:syzbot%2B7efb5850a17ba6ce098b@syzkaller.appspotmail.=
com">syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com</a>&gt; wrote:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello,<br>
<br>
syzbot found the following issue on:<br>
<br>
HEAD commit:=C2=A0 =C2=A0 11066801dd4b Merge tag &#39;linux_kselftest-fixes=
-6.12-rc6&#39; of..<br>
git tree:=C2=A0 =C2=A0 =C2=A0 =C2=A0upstream<br>
console output: <a href=3D"https://syzkaller.appspot.com/x/log.txt?x=3D1614=
6aa7980000" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.appspot.=
com/x/log.txt?x=3D16146aa7980000</a><br>
kernel config:=C2=A0 <a href=3D"https://syzkaller.appspot.com/x/.config?x=
=3D672325e7ab17fdf7" rel=3D"noreferrer" target=3D"_blank">https://syzkaller=
.appspot.com/x/.config?x=3D672325e7ab17fdf7</a><br>
dashboard link: <a href=3D"https://syzkaller.appspot.com/bug?extid=3D7efb58=
50a17ba6ce098b" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.apps=
pot.com/bug?extid=3D7efb5850a17ba6ce098b</a><br>
compiler:=C2=A0 =C2=A0 =C2=A0 =C2=A0Debian clang version 15.0.6, GNU ld (GN=
U Binutils for Debian) 2.40<br>
syz repro:=C2=A0 =C2=A0 =C2=A0 <a href=3D"https://syzkaller.appspot.com/x/r=
epro.syz?x=3D14e8755f980000" rel=3D"noreferrer" target=3D"_blank">https://s=
yzkaller.appspot.com/x/repro.syz?x=3D14e8755f980000</a><br>
<br>
Downloadable assets:<br>
disk image: <a href=3D"https://storage.googleapis.com/syzbot-assets/d5100fe=
708c2/disk-11066801.raw.xz" rel=3D"noreferrer" target=3D"_blank">https://st=
orage.googleapis.com/syzbot-assets/d5100fe708c2/disk-11066801.raw.xz</a><br=
>
vmlinux: <a href=3D"https://storage.googleapis.com/syzbot-assets/581317b0fe=
f2/vmlinux-11066801.xz" rel=3D"noreferrer" target=3D"_blank">https://storag=
e.googleapis.com/syzbot-assets/581317b0fef2/vmlinux-11066801.xz</a><br>
kernel image: <a href=3D"https://storage.googleapis.com/syzbot-assets/c7571=
fdba64f/bzImage-11066801.xz" rel=3D"noreferrer" target=3D"_blank">https://s=
torage.googleapis.com/syzbot-assets/c7571fdba64f/bzImage-11066801.xz</a><br=
>
<br>
IMPORTANT: if you fix the issue, please add the following tag to the commit=
:<br>
Reported-by: <a href=3D"mailto:syzbot%2B7efb5850a17ba6ce098b@syzkaller.apps=
potmail.com" target=3D"_blank">syzbot+7efb5850a17ba6ce098b@syzkaller.appspo=
tmail.com</a><br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30 kernel/locking/=
lockdep.c:5838<br>
Read of size 8 at addr ffff8880312a38c0 by task syz.2.335/8457<br>
<br>
CPU: 1 UID: 0 PID: 8457 Comm: syz.2.335 Not tainted 6.12.0-rc5-syzkaller-00=
299-g11066801dd4b #0<br>
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 09/13/2024<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0__dump_stack lib/dump_stack.c:94 [inline]<br>
=C2=A0dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120<br>
=C2=A0print_address_description mm/kasan/report.c:377 [inline]<br>
=C2=A0print_report+0x169/0x550 mm/kasan/report.c:488<br>
=C2=A0kasan_report+0x143/0x180 mm/kasan/report.c:601<br>
=C2=A0lock_release+0x151/0xa30 kernel/locking/lockdep.c:5838<br>
=C2=A0__mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912<br>
=C2=A0sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407<br>
=C2=A0__fput+0x23f/0x880 fs/file_table.c:431<br>
=C2=A0task_work_run+0x24f/0x310 kernel/task_work.c:239<br>
=C2=A0resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]<br=
>
=C2=A0exit_to_user_mode_loop kernel/entry/common.c:114 [inline]<br>
=C2=A0exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]<b=
r>
=C2=A0__syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]<b=
r>
=C2=A0syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218<br>
=C2=A0do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89<br>
=C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f<br>
RIP: 0033:0x7f312af7e719<br>
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 &lt;48&gt; 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48<br>
RSP: 002b:00007ffdb5d17628 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4<br>
RAX: 0000000000000000 RBX: 00007f312b137a80 RCX: 00007f312af7e719<br>
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003<br>
RBP: 00007f312b137a80 R08: 0000000000000000 R09: 00007ffdb5d1791f<br>
R10: 000000000003fdc8 R11: 0000000000000246 R12: 000000000005f4a4<br>
R13: 00007ffdb5d17730 R14: 0000000000000032 R15: ffffffffffffffff<br>
=C2=A0&lt;/TASK&gt;<br>
<br>
Allocated by task 7133:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:47 [inline]<br>
=C2=A0kasan_save_track+0x3f/0x80 mm/kasan/common.c:68<br>
=C2=A0poison_kmalloc_redzone mm/kasan/common.c:377 [inline]<br>
=C2=A0__kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394<br>
=C2=A0kasan_kmalloc include/linux/kasan.h:257 [inline]<br>
=C2=A0__kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4295<br>
=C2=A0kmalloc_noprof include/linux/slab.h:878 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1014 [inline]<br>
=C2=A0sg_alloc drivers/scsi/sg.c:1444 [inline]<br>
=C2=A0sg_add_device+0x139/0xb10 drivers/scsi/sg.c:1518<br>
=C2=A0device_add+0xa1f/0xbf0 drivers/base/core.c:3698<br>
=C2=A0scsi_sysfs_add_sdev+0x306/0x5a0 drivers/scsi/scsi_sysfs.c:1435<br>
=C2=A0scsi_sysfs_add_devices drivers/scsi/scsi_scan.c:1896 [inline]<br>
=C2=A0scsi_finish_async_scan drivers/scsi/scsi_scan.c:1981 [inline]<br>
=C2=A0do_scan_async+0x42a/0x7a0 drivers/scsi/scsi_scan.c:2024<br>
=C2=A0async_run_entry_fn+0xa8/0x420 kernel/async.c:129<br>
=C2=A0process_one_work kernel/workqueue.c:3229 [inline]<br>
=C2=A0process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310<br>
=C2=A0worker_thread+0x870/0xd30 kernel/workqueue.c:3391<br>
=C2=A0kthread+0x2f0/0x390 kernel/kthread.c:389<br>
=C2=A0ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244<br>
<br>
Freed by task 6000:<br>
=C2=A0kasan_save_stack mm/kasan/common.c:47 [inline]<br>
=C2=A0kasan_save_track+0x3f/0x80 mm/kasan/common.c:68<br>
=C2=A0kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579<br>
=C2=A0poison_slab_object mm/kasan/common.c:247 [inline]<br>
=C2=A0__kasan_slab_free+0x59/0x70 mm/kasan/common.c:264<br>
=C2=A0kasan_slab_free include/linux/kasan.h:230 [inline]<br>
=C2=A0slab_free_hook mm/slub.c:2342 [inline]<br>
=C2=A0slab_free mm/slub.c:4579 [inline]<br>
=C2=A0kfree+0x1a0/0x440 mm/slub.c:4727<br>
=C2=A0kref_put include/linux/kref.h:65 [inline]<br>
=C2=A0sg_remove_sfp_usercontext+0x331/0x4d0 drivers/scsi/sg.c:2238<br>
=C2=A0process_one_work kernel/workqueue.c:3229 [inline]<br>
=C2=A0process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310<br>
=C2=A0worker_thread+0x870/0xd30 kernel/workqueue.c:3391<br>
=C2=A0kthread+0x2f0/0x390 kernel/kthread.c:389<br>
=C2=A0ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244<br>
<br>
The buggy address belongs to the object at ffff8880312a3800<br>
=C2=A0which belongs to the cache kmalloc-512 of size 512<br>
The buggy address is located 192 bytes inside of<br>
=C2=A0freed 512-byte region [ffff8880312a3800, ffff8880312a3a00)<br>
<br>
The buggy address belongs to the physical page:<br>
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880312a20=
00 pfn:0x312a0<br>
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0<br>
flags: 0xfff00000000240(workingset|head|node=3D0|zone=3D1|lastcpupid=3D0x7f=
f)<br>
page_type: f5(slab)<br>
raw: 00fff00000000240 ffff88801ac41c80 ffffea00010c8910 ffffea0001fcb310<br=
>
raw: ffff8880312a2000 000000000010000d 00000001f5000000 0000000000000000<br=
>
head: 00fff00000000240 ffff88801ac41c80 ffffea00010c8910 ffffea0001fcb310<b=
r>
head: ffff8880312a2000 000000000010000d 00000001f5000000 0000000000000000<b=
r>
head: 00fff00000000002 ffffea0000c4a801 ffffffffffffffff 0000000000000000<b=
r>
head: ffff888000000004 0000000000000000 00000000ffffffff 0000000000000000<b=
r>
page dumped because: kasan: bad access detected<br>
page_owner tracks the page as allocated<br>
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5224, tgid 5224 (udevd), ts 31207973672, free_ts 31004401902<br>
=C2=A0set_page_owner include/linux/page_owner.h:32 [inline]<br>
=C2=A0post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537<br>
=C2=A0prep_new_page mm/page_alloc.c:1545 [inline]<br>
=C2=A0get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457<br>
=C2=A0__alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733<br>
=C2=A0alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265<br>
=C2=A0alloc_slab_page+0x6a/0x120 mm/slub.c:2412<br>
=C2=A0allocate_slab+0x5a/0x2f0 mm/slub.c:2578<br>
=C2=A0new_slab mm/slub.c:2631 [inline]<br>
=C2=A0___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818<br>
=C2=A0__slab_alloc+0x58/0xa0 mm/slub.c:3908<br>
=C2=A0__slab_alloc_node mm/slub.c:3961 [inline]<br>
=C2=A0slab_alloc_node mm/slub.c:4122 [inline]<br>
=C2=A0__kmalloc_cache_noprof+0x1d5/0x2c0 mm/slub.c:4290<br>
=C2=A0kmalloc_noprof include/linux/slab.h:878 [inline]<br>
=C2=A0kzalloc_noprof include/linux/slab.h:1014 [inline]<br>
=C2=A0kernfs_fop_open+0x3e0/0xd10 fs/kernfs/file.c:623<br>
=C2=A0do_dentry_open+0x978/0x1460 fs/open.c:958<br>
=C2=A0vfs_open+0x3e/0x330 fs/open.c:1088<br>
=C2=A0do_open fs/namei.c:3774 [inline]<br>
=C2=A0path_openat+0x2c84/0x3590 fs/namei.c:3933<br>
=C2=A0do_filp_open+0x235/0x490 fs/namei.c:3960<br>
=C2=A0do_sys_openat2+0x13e/0x1d0 fs/open.c:1415<br>
=C2=A0do_sys_open fs/open.c:1430 [inline]<br>
=C2=A0__do_sys_openat fs/open.c:1446 [inline]<br>
=C2=A0__se_sys_openat fs/open.c:1441 [inline]<br>
=C2=A0__x64_sys_openat+0x247/0x2a0 fs/open.c:1441<br>
page last free pid 16 tgid 16 stack trace:<br>
=C2=A0reset_page_owner include/linux/page_owner.h:25 [inline]<br>
=C2=A0free_pages_prepare mm/page_alloc.c:1108 [inline]<br>
=C2=A0free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638<br>
=C2=A0rcu_do_batch kernel/rcu/tree.c:2567 [inline]<br>
=C2=A0rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823<br>
=C2=A0handle_softirqs+0x2c5/0x980 kernel/softirq.c:554<br>
=C2=A0run_ksoftirqd+0xca/0x130 kernel/softirq.c:927<br>
=C2=A0smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164<br>
=C2=A0kthread+0x2f0/0x390 kernel/kthread.c:389<br>
=C2=A0ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244<br>
<br>
Memory state around the buggy address:<br>
=C2=A0ffff8880312a3780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc<br>
=C2=A0ffff8880312a3800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
&gt;ffff8880312a3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0^<br>
=C2=A0ffff8880312a3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=C2=A0ffff8880312a3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
<br>
---<br>
This report is generated by a bot. It may contain errors.<br>
See <a href=3D"https://goo.gl/tpsmEJ" rel=3D"noreferrer" target=3D"_blank">=
https://goo.gl/tpsmEJ</a> for more information about syzbot.<br>
syzbot engineers can be reached at <a href=3D"mailto:syzkaller@googlegroups=
.com" target=3D"_blank">syzkaller@googlegroups.com</a>.<br>
<br>
syzbot will keep track of this issue. See:<br>
<a href=3D"https://goo.gl/tpsmEJ#status" rel=3D"noreferrer" target=3D"_blan=
k">https://goo.gl/tpsmEJ#status</a> for how to communicate with syzbot.<br>
<br>
If the report is already addressed, let syzbot know by replying with:<br>
#syz fix: exact-commit-title<br>
<br>
If you want syzbot to run the reproducer, reply with:<br>
#syz test: git://repo/address.git branch-or-commit-hash<br>
If you attach or paste a git patch, syzbot will apply it before testing.<br=
>
<br>
If you want to overwrite report&#39;s subsystems, reply with:<br>
#syz set subsystems: new-subsystem<br>
(See the list of subsystem names on the web dashboard)<br>
<br>
If the report is a duplicate of another one, reply with:<br>
#syz dup: exact-subject-of-another-report<br>
<br>
If you want to undo deduplication, reply with:<br>
#syz undup<br>
<br>
-- <br>
You received this message because you are subscribed to the Google Groups &=
quot;syzkaller-bugs&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:syzkaller-bugs%2Bunsubscribe@googlegroups.com" ta=
rget=3D"_blank">syzkaller-bugs+unsubscribe@googlegroups.com</a>.<br>
To view this discussion visit <a href=3D"https://groups.google.com/d/msgid/=
syzkaller-bugs/672b574b.050a0220.2edce.1523.GAE%40google.com" rel=3D"norefe=
rrer" target=3D"_blank">https://groups.google.com/d/msgid/syzkaller-bugs/67=
2b574b.050a0220.2edce.1523.GAE%40google.com</a>.<br>
</blockquote></div>

--00000000000051b08b062753d051--
--00000000000051b08c062753d053
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-fix-slab-use-after-free-Read-in-sg_release.patch"
Content-Disposition: attachment; 
	filename="0001-fix-slab-use-after-free-Read-in-sg_release.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3pm3yf60>
X-Attachment-Id: f_m3pm3yf60

RnJvbSBmNjlhZjE1MWEzYWEzZjcwMGNhYzQwMjQxYjVhM2VkMjNlZmU2NmZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdXJhaiBTb25hd2FuZSA8c3VyYWpzb25hd2FuZTAyMTVAZ21h
aWwuY29tPgpEYXRlOiBXZWQsIDIwIE5vdiAyMDI0IDEzOjQ3OjA1ICswNTMwClN1YmplY3Q6IFtQ
QVRDSF0gZml4IHNsYWItdXNlLWFmdGVyLWZyZWUgUmVhZCBpbiBzZ19yZWxlYXNlCgpzeXogdGVz
dAoKU2lnbmVkLW9mZi1ieTogU3VyYWogU29uYXdhbmUgPHN1cmFqc29uYXdhbmUwMjE1QGdtYWls
LmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvc2cuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZy5j
IGIvZHJpdmVycy9zY3NpL3NnLmMKaW5kZXggZjg2YmUxOTdmLi40NTdkNTQxNzEgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc2NzaS9zZy5jCisrKyBiL2RyaXZlcnMvc2NzaS9zZy5jCkBAIC0zOTMsNyAr
MzkzLDYgQEAgc2dfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmls
cCkKIAogCW11dGV4X2xvY2soJnNkcC0+b3Blbl9yZWxfbG9jayk7CiAJc2NzaV9hdXRvcG1fcHV0
X2RldmljZShzZHAtPmRldmljZSk7Ci0Ja3JlZl9wdXQoJnNmcC0+Zl9yZWYsIHNnX3JlbW92ZV9z
ZnApOwogCXNkcC0+b3Blbl9jbnQtLTsKIAogCS8qIHBvc3NpYmx5IG1hbnkgb3BlbigpcyB3YWl0
aW5nIG9uIGV4bHVkZSBjbGVhcmluZywgc3RhcnQgbWFueTsKQEAgLTQwNSw2ICs0MDQsNyBAQCBz
Z19yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxwKQogCQl3YWtl
X3VwX2ludGVycnVwdGlibGUoJnNkcC0+b3Blbl93YWl0KTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZz
ZHAtPm9wZW5fcmVsX2xvY2spOworCWtyZWZfcHV0KCZzZnAtPmZfcmVmLCBzZ19yZW1vdmVfc2Zw
KTsKIAlyZXR1cm4gMDsKIH0KIAotLSAKMi4zNC4xCgo=
--00000000000051b08c062753d053--
