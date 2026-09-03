Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1328F4CA29F
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448410; cv=none; b=VykQ9dj49M0EbQPRzgY9R6E02z7aiPVj46qBS9RKieHvp0N1XJdnmjdTDgBSTostrDPy6HUe/w0a4g0Hy95Sk2oXiSJPSzEV15383/wWXBjZaXYey+2VQ+YSX2Q/WEOEmq5rtYYCEuVQ90R73OCVBk+lXubl2MSBCnV4oOjs3SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448410; c=relaxed/simple;
	bh=8oDPwKyJq6D8iNtKGoCjRBDtydxKgNge9OBI1Z9R0JA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IcpCF0p+X8tTWOMtboZy4GYlQI0MsJNlc3ib4s3j9gFRI6TGnnO+BsXc7MZlkozB/hp6bG+Hg5JP0kahqDvX867xKmSXrWvJkP1PgXuM2rbGMAoBgzUyZ0Xz2CxcpqFodu8XwCMkFMKn+me93Ro9lq+hkysZndOv3kpRI7NBo04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6b1b32cc57bso116500eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 08:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788448407; x=1789053207;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n88pISbCSWfh8Nmha5aYNHR09vbvpIlX43fQfrQW0kg=;
        b=MJnARQP9hn9KoMc4W+0/RKC/5AamRzgNSssh0y5SDTVJ4xfLAmH8CtoIwUzlMd2sxI
         fCKNKBPTGWSagueD4WjCwYzB5Lo5wV4vFaSw+GXg8YCLeY1bzDlWbnhGOuR5k6JTkzfM
         Ent8fXMf77XWY2yx+y9UMRXs4nSDH8ygSXAUH6NdYsA/c3/TcV5EkwkYye72i2jaPok4
         tBxs64Ea4LJAY4ftPGM64REGW0y9Qj665trlni9toa0jjgnbEAmTv5U9XOYH+mEKBAmr
         cWKaU23UUuOOLMMGwAl0SgsskQfgZblX1LN+esrMk3P4hMJbjrv/sIScUcPICFtiBPET
         Ehcg==
X-Forwarded-Encrypted: i=1; AKwUvBx/RMhmywgd7R+HwJl8qrM+iq8dCgh8xa3aSvLYwde7ixu5GYWlq8A5o3w1MhGUUqR50IIHcVnkkoRp@vger.kernel.org
X-Gm-Message-State: AFuF++kmKYjkUvuyc7kXmAeDU8xGNwm4FrLe5AzsSNyAr9h6XKf/X+r8
	D3bFLgaadMjPlaYwFdgd254coq7d2KT28q909jCyDxmhdslqtLDG/PsTeQHPLGQwN45vDmEOsUm
	nfTi9Qy+qwCeIndQ83chisNsEWQuCLXNTO89P6om6DsZ1zmWAb1p6EL4VFqo=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:619:b0:6ae:9815:7c8e with SMTP id
 006d021491bc7-6b48102eaa1mr9727355eaf.21.1788448406931; Thu, 03 Sep 2026
 08:13:26 -0700 (PDT)
Date: Thu, 03 Sep 2026 08:13:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a998e96.9266084e.bf0d7.026d.GAE@google.com>
Subject: [syzbot] [scsi?] INFO: task hung in scsi_scan_host_selected
From: syzbot <syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, mkp@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    940de590b839 Merge tag 'hardening-v7.3-rc2' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14f950f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=1f678bd2872aefb11d8a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15114b49580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16769f79580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bd9a624b9ba1/disk-940de590.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d23d27ba1b3/vmlinux-940de590.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fbe1a9f530ca/bzImage-940de590.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com

INFO: task syz-executor247:5632 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor247 state:D stack:27912 pid:5632  tgid:5632  ppid:5629   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5520 [inline]
 __schedule+0x16d9/0x5700 kernel/sched/core.c:7270
 __schedule_loop kernel/sched/core.c:7347 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7643
 rt_mutex_slowlock_block+0x55e/0x690 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916
 scsi_scan drivers/scsi/scsi_sysfs.c:151 [inline]
 store_scan+0x4aa/0x540 drivers/scsi/scsi_sysfs.c:191
 kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f95515558b9
RSP: 002b:00007ffdb0003058 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f95515558b9
RDX: 0000000000000005 RSI: 0000200000001400 RDI: 0000000000000003
RBP: 00000000000f4240 R08: 0000000000000009 R09: 0000000000000009
R10: 0000000000000009 R11: 0000000000000246 R12: 00007ffdb00031d8
R13: 0000000000000002 R14: 00007ffdb0003080 R15: 00007ffdb0003070
 </TASK>

Showing all locks held in the system:
locks held by pr/ttyS0/17: 3, last CPU#1:
 #0: ffffffff8e09d578 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquire include/linux/rcupdate.h:314 [inline]
 #0: ffffffff8e09d578 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmisafe include/linux/srcu.h:439 [inline]
 #0: ffffffff8e09d578 (console_srcu){....}-{0:0}, at: console_srcu_read_lock+0x30/0x60 kernel/printk/printk.c:291
 #1: ffffffff99e981f8 (&port_lock_key){+.+.}-{3:3}, at: nbcon_emit_one kernel/printk/nbcon.c:1137 [inline]
 #1: ffffffff99e981f8 (&port_lock_key){+.+.}-{3:3}, at: nbcon_kthread_func+0x64c/0x880 kernel/printk/nbcon.c:1271
 #2: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #2: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #2: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: __rt_spin_lock kernel/locking/spinlock_rt.c:50 [inline]
 #2: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1e2/0x400 kernel/locking/spinlock_rt.c:57
locks held by khungtaskd/38: 1, last CPU#0:
 #0: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e1c3ac0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6837
locks held by getty/5344: 2, on CPU#0:
 #0: ffff8880290a90a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900044cb2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x460/0x1360 drivers/tty/n_tty.c:2211
locks held by syz-executor247/5632: 4, on CPU#0:
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff88802d053878 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d9/0x540 fs/kernfs/file.c:336
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22c/0x540 fs/kernfs/file.c:337
 #3: ffff8880227cc110 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916
locks held by syz-executor247/5633: 4, on CPU#0:
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff88803bd46878 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d9/0x540 fs/kernfs/file.c:336
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22c/0x540 fs/kernfs/file.c:337
 #3: ffff8880227cc110 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916
locks held by syz-executor247/5640: 4, on CPU#1:
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff88803bd47078 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d9/0x540 fs/kernfs/file.c:336
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22c/0x540 fs/kernfs/file.c:337
 #3: ffff8880227cc110 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916
locks held by syz-executor247/5641: 4, on CPU#1:
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff88803bd47478 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d9/0x540 fs/kernfs/file.c:336
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22c/0x540 fs/kernfs/file.c:337
 #3: ffff8880227cc110 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916
locks held by syz-executor247/5648: 4, on CPU#1:
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2753 [inline]
 #0: ffff888035fc8510 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff88803bd47878 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d9/0x540 fs/kernfs/file.c:336
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #2: ffff888027b9b0f8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22c/0x540 fs/kernfs/file.c:337
 #3: ffff8880227cc110 (&shost->scan_mutex){+.+.}-{4:4}, at: scsi_scan_host_selected+0x19f/0x6c0 drivers/scsi/scsi_scan.c:1916

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 38 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:123
 nmi_trigger_cpumask_backtrace+0x17d/0x390 lib/nmi_backtrace.c:66
 trigger_all_cpu_backtrace include/linux/nmi.h:164 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 17 Comm: pr/ttyS0 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:409
Code: e8 ce cc 65 fc 44 89 f9 d3 e3 49 83 ee 80 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 6f 7b d1 fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f c3 cc cc cc cc cc 44 89 f9 80 e1 07
RSP: 0018:ffffc900001678b8 EFLAGS: 00000202
RAX: 1ffffffff33d3000 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff8560aca0 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff99e98220 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125cd5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555889aa798 CR3: 000000003ff02000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:128 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:150 [inline]
 wait_for_lsr+0x190/0x300 drivers/tty/serial/8250/8250_port.c:2013
 serial8250_fifo_wait_for_lsr_thre drivers/tty/serial/8250/8250_port.c:3270 [inline]
 __serial8250_console_fifo_write+0xd0/0x3f0 drivers/tty/serial/8250/8250_port.c:3345
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3378 [inline]
 __serial8250_console_write drivers/tty/serial/8250/8250_port.c:3429 [inline]
 serial8250_console_write+0xac5/0x1230 drivers/tty/serial/8250/8250_port.c:3493
 nbcon_emit_next_record+0xef5/0x1a90 kernel/printk/nbcon.c:-1
 nbcon_emit_one kernel/printk/nbcon.c:1157 [inline]
 nbcon_kthread_func+0x679/0x880 kernel/printk/nbcon.c:1271
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
