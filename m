Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CE32FF147
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 04:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763008710; cv=none; b=jdil9VQLUozsYcTOPcNYVkwU/X2kU8wLK+/Mh2a5GcPP8BMJZzzLRUrvv3KsON16uR3610Y+iAd9oC3JnRI2+czAH9CF8sEKj7LLInXF7SVeI4YCEsodzm4shERmZgGzCGrjwuPdHZ4G+fUFlHXTeVH6BLjn3TbUk3YIaH+EHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763008710; c=relaxed/simple;
	bh=vpoWHB2EbDrHkBaDyi59ATxfX/gqEyKvXwH5hVENijY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fnlMhYwycgunCU9+z40cV6T15O64zmWxcgQIreGXwuzCtDC1VlyVzzbh94vFUAsu2R0a0Zd7B05iZe4yCnYNkE1ZJwiz0uY1xTjoT/ycupmcNekqyinkjCwXNI9S1etkLVj7vqBNiWj7GP+hNpWDiT5CJYpbb/Bb7lplxovOxVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so66843739f.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 20:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763008708; x=1763613508;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7RegrYaPlt4EWnsQri7yJZAetXrWEzuqFX45X+IZid4=;
        b=C5OsustXSo487WC5pSKvUB1g/m37vpV40GvmARKdFWPZkQOtzXKpumD13+qmc+w9YC
         VTB4kvd6L4qmT7Gi+4D1MKV/21BF255TEHDTgrEA45CCpJX9fTeiRcEnH2zkiq9maNIL
         EDN9N0RGl1549ZPOiivd9IZOKuEbWptq/0NPbdi97ShiVkkRS2jCJ6eOzT6zfhdMY+1Q
         VUgp/brm9DbQCuMyiQkhapWv237P5GjsvvJRl4sB0yLCCxYEcRkfHAKABBl6WfcZ10Gh
         g0i9DhPZ+FM9i0ZHqG8z4k1Y6SUu7hGzlVorZjObChmS2xHzJ0pprk6GbWeX9hAy6VMY
         /PUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXKFUz3fHEB6cg1zzcyg50FvM0vFj5vjcZm4p4S0Rr4QGb6TgzT/U5XAXWw/wFgfrcV/AxabEou+DM@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7dKzHdbAQNWM3RWUgsYBOpXiDoREyufahOx0XxVYnmAYWou8V
	DjFM8Hl2qas46aYdFRr7aTGS+fbVS+V0fCY3mXjj4GOR/8xOXRZW6hXrNkHU25OEkxdbf485DNp
	h34f9YoHUkjQ5qhlwQWRgWJxz/+vIbbQK3lLswajR7aqCYamhpL/kVcQHnKk=
X-Google-Smtp-Source: AGHT+IFTxoS5WM6tk5K3tdgj1LigFUXo6PSmvY6zX00kzXapo3MZ4C4cqZf3dVg6+X6w4fVgs2go/tWOsB0kPH6fUidlPDM5IPcl
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3784:b0:433:43fb:3803 with SMTP id
 e9e14a558f8ab-43473c4274fmr79081995ab.0.1763008708335; Wed, 12 Nov 2025
 20:38:28 -0800 (PST)
Date: Wed, 12 Nov 2025 20:38:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691560c4.a70a0220.3124cb.001a.GAE@google.com>
Subject: [syzbot] [scsi?] BUG: sleeping function called from invalid context
 in __bio_release_pages (2)
From: syzbot <syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e9a6fb0bcdd7 Linux 6.18-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11dd07cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19d831c6d0386a9c
dashboard link: https://syzkaller.appspot.com/bug?extid=c01f8e6e73f20459912e
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9c9e524eb3ff/disk-e9a6fb0b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/db8dffcaebcd/vmlinux-e9a6fb0b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e341232467cd/bzImage-e9a6fb0b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at ./include/linux/pagemap.h:1139
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 12867, name: kworker/0:6
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
3 locks held by kworker/0:6/12867:
 #0: ffff88813ff15948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc90003ddfd00 ((work_completion)(&sfp->ew.work)){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffff88802a618080 (&sfp->rq_list_lock){..-.}-{3:3}, at: sg_remove_sfp_usercontext+0x81/0x590 drivers/scsi/sg.c:2208
irq event stamp: 943738
hardirqs last  enabled at (943737): [<ffffffff8b601a33>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (943737): [<ffffffff8b601a33>] _raw_spin_unlock_irq+0x23/0x50 kernel/locking/spinlock.c:202
hardirqs last disabled at (943738): [<ffffffff8b601ed2>] __raw_write_lock_irqsave include/linux/rwlock_api_smp.h:184 [inline]
hardirqs last disabled at (943738): [<ffffffff8b601ed2>] _raw_write_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:318
softirqs last  enabled at (943720): [<ffffffff89b46670>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (943720): [<ffffffff89b46670>] update_defense_level+0x5d0/0xf70 net/netfilter/ipvs/ip_vs_ctl.c:210
softirqs last disabled at (943718): [<ffffffff89b46184>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (943718): [<ffffffff89b46184>] update_defense_level+0xe4/0xf70 net/netfilter/ipvs/ip_vs_ctl.c:112
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 12867 Comm: kworker/0:6 Tainted: G     U              syzkaller #0 PREEMPT(full) 
Tainted: [U]=USER
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Workqueue: events sg_remove_sfp_usercontext
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 __might_resched+0x3c0/0x5e0 kernel/sched/core.c:8927
 folio_lock include/linux/pagemap.h:1139 [inline]
 __bio_release_pages+0x312/0x3b0 block/bio.c:1147
 bio_release_pages include/linux/bio.h:472 [inline]
 blk_rq_unmap_user+0x3be/0x980 block/blk-map.c:639
 sg_finish_rem_req+0xde/0x590 drivers/scsi/sg.c:1835
 sg_remove_sfp_usercontext+0x103/0x590 drivers/scsi/sg.c:2211
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
 process_scheduled_works kernel/workqueue.c:3346 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
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
