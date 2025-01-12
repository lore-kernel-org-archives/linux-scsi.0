Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8122A1B6CF0
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2025 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736689050; cv=none; b=S5q+nQvcC2a6yaejhCo1VGh0zVGutYXAx6cFUq5AU0ht5h58nN3giHxrK89JRTubGmN4zRifnO+gtzHsr5TsiZVRs01uNyVhJNrxGI3Igy9KMfAOc3QXMqm5JqtBgg7U2rwb2L4/zMiyhgFbP6c5cCtl8Dd2jDZqW0rbxxyQ+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736689050; c=relaxed/simple;
	bh=8eYQCmabC/YDb8aA9LMNzPZ/5sppWTXW9GIFgc+lSx0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aoXWnEM9/9rL7M+HsT/Pxw28w3iuFpiF/yam/1ZsvTTYGyxj0bDkq0y6E6/zXAekUs1TnPeQOPqMSVVQnQ+4NgmvVYq1IaUFwS0oTH4tCLd1vWp4ot2V7Ra08eCdiqZT7BeaXJhOmzSUsMe70Gx7sb/7zpG3/OA2ExtUC5OfLas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce3a416d71so54390705ab.3
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2025 05:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736689047; x=1737293847;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KPujOmimSjI/Umw2Crd39emwoJgGX91snYrBYOSBK0o=;
        b=cTh1EkRa5dDphK9aRcfDmi14o6YmCuQYQbBsTiqe5C+ghrgPxsAqzWt/wL4+ItnuHf
         Ee434bM+oOep8E8BDcnN6xQj+cWMlCI7hTIxzKzltp0BZAoNAm5DqRzfc3A7ANgaPr/c
         f1R25Ymr1BwwChhOtcsZaq8jdCfkcxDJKNjfAtGEuqUchz2GL65r44KqjBz1CKpV/hQ2
         jsuHp0mUDY3t21zcwH0TmQaGc6neGZTMwTycMyGQtdoTRaagm62/WlKCvkNX0RSFZdRn
         XT5Bt6tmkKnMyEN5ST7ovtyE3G01dgHqrbJvlSvbPazwHRRU7Ma6EsikYukXvJ2GvS0E
         4hMA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Uy9iPh0wSColOLGo3N36pq4DhEOt/qUDEG0uZdxO1AG3Gka1LmnYxN2rx5oLure56oExbgpLk8wD@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy3MtzZF6EGIBHQ10pPeGRvwx6x7tz1K+Ggrhr/AmkvNmlprSI
	VDHzXf6yhFyD+czcDBqkBNrvTEf3EEPoX9ExlFHlO92V5/4S2KJTZyWUXGahmTux/DWh23qL0eF
	BXz6fPUGkGVjqTy6za0KG1fT5XxzQP2htmsuiokiWLK9wbzj0IZT4gcM=
X-Google-Smtp-Source: AGHT+IH+xBh4BCd9UWTGcLXSiZWP3w9Ae7gw0zAbetR8NAKCqL9FLF6O2NI/A9S6BwnSk1hd0tFd4ThXEMZZ2T1q2HLPvDkMWjyO
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1cab:b0:3a7:1f72:ad3c with SMTP id
 e9e14a558f8ab-3ce3aa71e6amr148677655ab.19.1736689047575; Sun, 12 Jan 2025
 05:37:27 -0800 (PST)
Date: Sun, 12 Jan 2025 05:37:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6783c597.050a0220.216c54.002f.GAE@google.com>
Subject: [syzbot] [scsi?] possible deadlock in sg_mmap
From: syzbot <syzbot+941903927d608a37e1f6@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    09a0fa92e5b4 Merge tag 'selinux-pr-20250107' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153894b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ef22c4fce5135b4
dashboard link: https://syzkaller.appspot.com/bug?extid=941903927d608a37e1f6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3037b7cdd44/disk-09a0fa92.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9173fec61376/vmlinux-09a0fa92.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bbf3901e4f77/bzImage-09a0fa92.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+941903927d608a37e1f6@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc6-syzkaller-00038-g09a0fa92e5b4 #0 Not tainted
------------------------------------------------------
syz.4.2070/14808 is trying to acquire lock:
ffff88804d7b9730 (&vma->vm_lock->lock){++++}-{4:4}, at: vma_start_write include/linux/mm.h:770 [inline]
ffff88804d7b9730 (&vma->vm_lock->lock){++++}-{4:4}, at: vm_flags_set include/linux/mm.h:900 [inline]
ffff88804d7b9730 (&vma->vm_lock->lock){++++}-{4:4}, at: sg_mmap+0x2ea/0x530 drivers/scsi/sg.c:1288

but task is already holding lock:
ffff888078718110 (&sfp->f_mutex){+.+.}-{4:4}, at: sg_mmap+0x13b/0x530 drivers/scsi/sg.c:1273

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&sfp->f_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       sg_mmap+0x13b/0x530 drivers/scsi/sg.c:1273
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2291 [inline]
       __mmap_new_vma mm/vma.c:2355 [inline]
       __mmap_region+0x2250/0x2d30 mm/vma.c:2456
       mmap_region+0x1d0/0x2c0 mm/mmap.c:1352
       do_mmap+0x97a/0x10d0 mm/mmap.c:500
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:575
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:546
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __might_fault+0xc6/0x120 mm/memory.c:6751
       _inline_copy_from_user include/linux/uaccess.h:162 [inline]
       _copy_from_user+0x2a/0xc0 lib/usercopy.c:18
       copy_from_user include/linux/uaccess.h:212 [inline]
       __blk_trace_setup kernel/trace/blktrace.c:626 [inline]
       blk_trace_ioctl+0x1ad/0x9a0 kernel/trace/blktrace.c:740
       blkdev_ioctl+0x40c/0x6a0 block/ioctl.c:682
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&q->debugfs_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       blk_mq_init_sched+0x3fa/0x830 block/blk-mq-sched.c:473
       elevator_init_mq+0x20e/0x320 block/elevator.c:610
       add_disk_fwnode+0x10d/0xf80 block/genhd.c:413
       sd_probe+0xba6/0x1100 drivers/scsi/sd.c:4024
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #4 (&q->q_usage_counter(queue)#50){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       blk_queue_enter+0xe1/0x600 block/blk-core.c:328
       blk_mq_alloc_request+0x4fa/0xaa0 block/blk-mq.c:652
       scsi_alloc_request drivers/scsi/scsi_lib.c:1222 [inline]
       scsi_execute_cmd+0x177/0x1090 drivers/scsi/scsi_lib.c:304
       read_capacity_16+0x2b4/0x1450 drivers/scsi/sd.c:2655
       sd_read_capacity drivers/scsi/sd.c:2824 [inline]
       sd_revalidate_disk+0x1013/0xbce0 drivers/scsi/sd.c:3734
       sd_probe+0x9fa/0x1100 drivers/scsi/sd.c:4010
       really_probe+0x2ba/0xad0 drivers/base/dd.c:658
       __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
       driver_probe_device+0x50/0x430 drivers/base/dd.c:830
       __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:958
       bus_for_each_drv+0x250/0x2e0 drivers/base/bus.c:459
       __device_attach_async_helper+0x22d/0x300 drivers/base/dd.c:987
       async_run_entry_fn+0xaa/0x420 kernel/async.c:129
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f2/0x390 kernel/kthread.c:389
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&q->limits_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       queue_limits_start_update include/linux/blkdev.h:947 [inline]
       loop_reconfigure_limits+0x43f/0x900 drivers/block/loop.c:998
       loop_set_block_size drivers/block/loop.c:1473 [inline]
       lo_simple_ioctl drivers/block/loop.c:1496 [inline]
       lo_ioctl+0x1351/0x1f50 drivers/block/loop.c:1559
       blkdev_ioctl+0x57f/0x6a0 block/ioctl.c:693
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#24){++++}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       bio_queue_enter block/blk.h:75 [inline]
       blk_mq_submit_bio+0x1536/0x2390 block/blk-mq.c:3090
       __submit_bio+0x2c6/0x560 block/blk-core.c:629
       __submit_bio_noacct_mq block/blk-core.c:710 [inline]
       submit_bio_noacct_nocheck+0x4d3/0xe30 block/blk-core.c:739
       mpage_bio_submit_read fs/mpage.c:75 [inline]
       mpage_readahead+0x630/0x780 fs/mpage.c:377
       read_pages+0x178/0x750 mm/readahead.c:160
       page_cache_ra_unbounded+0x606/0x720 mm/readahead.c:295
       do_page_cache_ra mm/readahead.c:325 [inline]
       force_page_cache_ra mm/readahead.c:354 [inline]
       page_cache_sync_ra+0x3c5/0xad0 mm/readahead.c:566
       page_cache_sync_readahead include/linux/pagemap.h:1397 [inline]
       filemap_get_pages+0x605/0x2080 mm/filemap.c:2537
       filemap_read+0x452/0xf50 mm/filemap.c:2637
       blkdev_read_iter+0x2d8/0x430 block/fops.c:770
       new_sync_read fs/read_write.c:484 [inline]
       vfs_read+0x993/0xb70 fs/read_write.c:565
       ksys_read+0x18f/0x2b0 fs/read_write.c:708
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (mapping.invalidate_lock#2){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
       filemap_fault+0x615/0x1490 mm/filemap.c:3323
       __do_fault+0x137/0x390 mm/memory.c:4907
       do_read_fault mm/memory.c:5322 [inline]
       do_fault mm/memory.c:5456 [inline]
       do_pte_missing mm/memory.c:3979 [inline]
       handle_pte_fault+0x39eb/0x5ed0 mm/memory.c:5801
       __handle_mm_fault mm/memory.c:5944 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
       do_user_addr_fault arch/x86/mm/fault.c:1338 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x459/0x8b0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (&vma->vm_lock->lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_write+0x99/0x220 kernel/locking/rwsem.c:1577
       vma_start_write include/linux/mm.h:770 [inline]
       vm_flags_set include/linux/mm.h:900 [inline]
       sg_mmap+0x2ea/0x530 drivers/scsi/sg.c:1288
       call_mmap include/linux/fs.h:2183 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2291 [inline]
       __mmap_new_vma mm/vma.c:2355 [inline]
       __mmap_region+0x2250/0x2d30 mm/vma.c:2456
       mmap_region+0x1d0/0x2c0 mm/mmap.c:1352
       do_mmap+0x97a/0x10d0 mm/mmap.c:500
       vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:575
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:546
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &vma->vm_lock->lock --> &mm->mmap_lock --> &sfp->f_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sfp->f_mutex);
                               lock(&mm->mmap_lock);
                               lock(&sfp->f_mutex);
  lock(&vma->vm_lock->lock);

 *** DEADLOCK ***

2 locks held by syz.4.2070/14808:
 #0: ffff88807c3b0ba0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:122 [inline]
 #0: ffff88807c3b0ba0 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x17c/0x3d0 mm/util.c:573
 #1: ffff888078718110 (&sfp->f_mutex){+.+.}-{4:4}, at: sg_mmap+0x13b/0x530 drivers/scsi/sg.c:1273

stack backtrace:
CPU: 0 UID: 0 PID: 14808 Comm: syz.4.2070 Not tainted 6.13.0-rc6-syzkaller-00038-g09a0fa92e5b4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 vma_start_write include/linux/mm.h:770 [inline]
 vm_flags_set include/linux/mm.h:900 [inline]
 sg_mmap+0x2ea/0x530 drivers/scsi/sg.c:1288
 call_mmap include/linux/fs.h:2183 [inline]
 mmap_file mm/internal.h:124 [inline]
 __mmap_new_file_vma mm/vma.c:2291 [inline]
 __mmap_new_vma mm/vma.c:2355 [inline]
 __mmap_region+0x2250/0x2d30 mm/vma.c:2456
 mmap_region+0x1d0/0x2c0 mm/mmap.c:1352
 do_mmap+0x97a/0x10d0 mm/mmap.c:500
 vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:575
 ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:546
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb7d3b85d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb7d4a0c038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fb7d3d76080 RCX: 00007fb7d3b85d29
RDX: 000000000100000e RSI: 0000000000003000 RDI: 0000000020000000
RBP: 00007fb7d3c01b08 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fb7d3d76080 R15: 00007ffe771b7b78
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
