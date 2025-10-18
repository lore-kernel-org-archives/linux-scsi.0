Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC923258EF5
	for <linux-scsi@vger.kernel.org>; Sat, 18 Oct 2025 05:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760766816; cv=none; b=ID7qsNPViwFzMJLk6JAHvOhCtZETC8bUp+3hdWIgAZ7KlPKKD70zColyeyME6oc0q+koyeD5BvJVbR5k0Aym1qKM+BNHOWwvetmwlj98uwPzXG6DoBaKrlyyTHm9moSqgwnPIOYsFAueOree6p2cL8TFdTmuDl9SpPcpPwUXTXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760766816; c=relaxed/simple;
	bh=xzFoZbgpgYfmGrOx265Ju2hE1aOLkx8E4Nv8qZPo2zE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gl96I5nyRjBd2obGLBvjbimM2Ummo0kVaNlaKQGyYXBqrI/mJb9VPtBn6Zo9A9yKaOtWZar5OL2C3KH+g6DkZ761gh+uuBCYPG5QW0FbL9HScJ8WN56Fl0ELA50DJ+yF55tpfFACdmYAEongENruBd/BsSpuN9ud6Yp2gp/Bark=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so263005639f.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 22:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760766814; x=1761371614;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/GRj617Cfvkfsc2fvmNusGhnDVIoFOb4MtIivd7Oy8=;
        b=nYAFr9Iu2lT4iezXGSBK90MRSx6/GsFVlKoTgF3It+GzQDIUdUiqguBVzDVdR2u8/e
         1nftY3rknu8v9PKX1N67j0w8qlSpZghDru+LP3Xlrd/vs892/AQoXCNA74iD0o2WH47I
         CaaDAVrWupG+5gXCRawtWPkQZ8JMwoLFVOXDP6m7GnbqFFLkfMAevoDW6LWkipoJvoVz
         uxH1S9ogwIGGHfUpA1QH7eSNRXthsHarNVfX+/wiGEb1320JOmq3aCGLIHxM4zbhuVKT
         hRAagc/ASFc/UDOoWxTqFfkyb5Cdn1AU9ATMigdoeAROoCqDszlcA1++y72szSmTMpOU
         BJVg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ4V645plNkU+y7ecCUne6AXEFM3sc/DhI5lT+bJ0p/0RaScfanLoeF5KqP5q1ReYAFymNSmk9Z7Gk@vger.kernel.org
X-Gm-Message-State: AOJu0YyhRZYS85HzExSxUsTQzL4kUZpboGNLGz080WjOqm4h8Z716DYG
	r4Jpk6/12Qlrv0Yn5gEaY3ycKUdd5lG1OEHqwFsvdWgB7/9JTqsh+nFWGlT6DVbCJCHybSyK5Q4
	ynFuEzmI9oHYzgLPm06VslXKQYXoWeIHo8C/c4iUd8hGC5ug+vUmKE/ZU0kI=
X-Google-Smtp-Source: AGHT+IElhltGiLsko8opmZStyEUHbYRepMEk8ZMccaPq7VeXFIuIUakGpUrNkGUrNbHb+mrWW4GUYQ6kYJkcvQEbYH1Ccp4mqfsl
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29b3:b0:915:f0:58a3 with SMTP id
 ca18e2360f4ac-93e76437f51mr751969839f.15.1760766813811; Fri, 17 Oct 2025
 22:53:33 -0700 (PDT)
Date: Fri, 17 Oct 2025 22:53:33 -0700
In-Reply-To: <6840fdc4.a00a0220.68b4a.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f32b5d.050a0220.1186a4.051d.GAE@google.com>
Subject: Re: [syzbot] [net?] BUG: soft lockup in sys_sendmsg (2)
From: syzbot <syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com>
To: axboe@kernel.dk, davem@davemloft.net, dvyukov@google.com, 
	edumazet@google.com, hdanton@sina.com, horms@kernel.org, jmaloy@redhat.com, 
	kuba@kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, paulmck@kernel.org, peterz@infradead.org, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    bf45a62baffc Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15941de2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd2356106f507975
dashboard link: https://syzkaller.appspot.com/bug?extid=4032319a6a907f69e985
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1494767c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126fdde2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f0d4874557e9/disk-bf45a62b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0bf44a13b5b2/vmlinux-bf45a62b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/18db8bc9907c/Image-bf45a62b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [syz.0.76:6894]
Modules linked in:
irq event stamp: 5181
hardirqs last  enabled at (5180): [<ffff80008b064a14>] irqentry_exit+0xd8/0x108 kernel/entry/common.c:214
hardirqs last disabled at (5181): [<ffff80008b062af0>] __enter_from_kernel_mode arch/arm64/kernel/entry-common.c:43 [inline]
hardirqs last disabled at (5181): [<ffff80008b062af0>] enter_from_kernel_mode+0x14/0x34 arch/arm64/kernel/entry-common.c:50
softirqs last  enabled at (522): [<ffff8000892e0188>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last  enabled at (522): [<ffff8000892e0188>] release_sock+0x14c/0x1ac net/core/sock.c:3735
softirqs last disabled at (528): [<ffff8000892f4c84>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (528): [<ffff8000892f4c84>] lock_sock_nested+0x70/0x118 net/core/sock.c:3714
CPU: 0 UID: 0 PID: 6894 Comm: syz.0.76 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x138/0xaec kernel/locking/qspinlock.c:197
lr : queued_spin_lock_slowpath+0x144/0xaec kernel/locking/qspinlock.c:197
sp : ffff8000a1a17600
x29: ffff8000a1a176a0 x28: 1fffe0001b9124c1 x27: 1fffe000196c6002
x26: ffff0000cb630000 x25: dfff800000000000 x24: ffff700014342ec4
x23: 0000000000000001 x22: ffff0000cb630010 x21: ffff0000dc892608
x20: ffff0000dc892610 x19: ffff0000dc892600 x18: 0000000000000000
x17: 0000000000000000 x16: ffff800080537d14 x15: 0000000000000001
x14: 1fffe0001b9124c0 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001b9124c1 x10: dfff800000000000 x9 : 0000000000000000
x8 : 0000000000000001 x7 : ffff8000892f4c84 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80008b0885f8
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000001
Call trace:
 __cmpwait_case_8 arch/arm64/include/asm/cmpxchg.h:229 [inline] (P)
 __cmpwait arch/arm64/include/asm/cmpxchg.h:257 [inline] (P)
 queued_spin_lock_slowpath+0x138/0xaec kernel/locking/qspinlock.c:197 (P)
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x2a8/0x2cc kernel/locking/spinlock_debug.c:116
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:127 [inline]
 _raw_spin_lock_bh+0x50/0x60 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:356 [inline]
 lock_sock_nested+0x70/0x118 net/core/sock.c:3714
 lock_sock include/net/sock.h:1669 [inline]
 tipc_sendstream+0x50/0x84 net/tipc/socket.c:1545
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg net/socket.c:729 [inline]
 ____sys_sendmsg+0x490/0x7b8 net/socket.c:2614
 ___sys_sendmsg+0x204/0x278 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __arm64_sys_sendmsg+0x184/0x238 net/socket.c:2703
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6895 Comm: syz.0.76 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : should_resched arch/arm64/include/asm/preempt.h:78 [inline]
pc : __local_bh_enable_ip+0x1f0/0x35c kernel/softirq.c:414
lr : __local_bh_enable_ip+0x1ec/0x35c kernel/softirq.c:412
sp : ffff8000a1806210
x29: ffff8000a1806220 x28: 0000000040613361 x27: ffff8000a18063e0
x26: ffff0000f25e3b60 x25: dfff800000000000 x24: 0000000000000001
x23: dfff800000000000 x22: 1fffe000196c63d1 x21: ffff80008ab3e7b8
x20: 0000000000000201 x19: ffff0000cb631e88 x18: 00000000ffffffff
x17: ffff800093605000 x16: ffff80008052bc24 x15: 0000000000000001
x14: 1fffe0001b9124c0 x13: 0000000000000000 x12: 0000000000000000
x11: ffff800093404c28 x10: 0000000000000003 x9 : 0000000000000000
x8 : 000000000382547a x7 : ffff80008ab4aee0 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000010
x2 : 0000000000000002 x1 : ffff80008ee54d8e x0 : ffff80010c40c000
Call trace:
 __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
 arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
 __local_bh_enable_ip+0x1f0/0x35c kernel/softirq.c:412 (P)
 __raw_spin_trylock_bh include/linux/spinlock_api_smp.h:177 [inline]
 _raw_spin_trylock_bh+0x68/0x80 kernel/locking/spinlock.c:146
 spin_trylock_bh include/linux/spinlock.h:411 [inline]
 tipc_sk_rcv+0x2f4/0x2294 net/tipc/socket.c:2494
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x248/0x33c net/tipc/node.c:1781
 tipc_sk_rcv+0x1df0/0x2294 net/tipc/socket.c:2499
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_sk_push_backlog+0x398/0x744 net/tipc/socket.c:1312
 tipc_sk_conn_proto_rcv net/tipc/socket.c:1366 [inline]
 tipc_sk_proto_rcv+0x704/0x12ec net/tipc/socket.c:2156
 tipc_sk_filter_rcv+0x2524/0x277c net/tipc/socket.c:2350
 tipc_sk_enqueue net/tipc/socket.c:2443 [inline]
 tipc_sk_rcv+0x628/0x2294 net/tipc/socket.c:2495
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x248/0x33c net/tipc/node.c:1781
 tipc_sk_backlog_rcv+0x164/0x214 net/tipc/socket.c:2410
 sk_backlog_rcv include/net/sock.h:1150 [inline]
 __release_sock+0x19c/0x39c net/core/sock.c:3172
 release_sock+0x60/0x1ac net/core/sock.c:3726
 sockopt_release_sock net/core/sock.c:1155 [inline]
 sk_setsockopt+0x2354/0x28ec net/core/sock.c:1668
 sock_setsockopt+0x68/0x80 net/core/sock.c:1675
 do_sock_setsockopt+0x19c/0x328 net/socket.c:2340
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __arm64_sys_setsockopt+0x170/0x1e0 net/socket.c:2372
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
