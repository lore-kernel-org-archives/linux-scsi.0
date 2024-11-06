Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBF818A92C
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 02:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861482; cv=none; b=kzame+BIG3crWqtG3w+Gc/R4D4perWhjdge+WpTUGuThvSIx3upxH0dAsdidK1ZjThggRxL3/aYnY4E/Bmx0UWiun4a46R4m0froK4xRqgRybRRUKRCsrmzoG0BL1QDMuNMh/DYk8pg3Dqv2pFkMQgZ1c1onG8btXqR7zO3zFro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861482; c=relaxed/simple;
	bh=NfP7BlgLxSn2WKKVkdrepVfQTJK7R3TVBFB7/t9tjC8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fuOUX0cwGVcSEskx9ttLpvwdB/em+CZGfLytYzYjOxBwGlYH1CLfLTiRLB92K7A+vsZdgirsIAKPOmgmuJ+iSaxAqIN6Ek3UkxKJ1a73Y7DzAN05rwOkuzcCRiix0qgbBrj4XAgmOfiaruPLx2GL2hUcRf+14D/03BsTxgkH7OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a6b7974696so48876885ab.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2024 18:51:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730861480; x=1731466280;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47a/jn3+/iOcV/k21j0lppzSJhAAjbRAD5/il+fS9AY=;
        b=OwhsILsDLxZhfgVRVUOCPqPHVfqKyMl5PBoAZDnChZAe12dPXvYl37ITjZUj6KkdF+
         CPzmFlaVrGHTL+XvQf994pWUAnhKmIYA2gHoQGh9gU7bfUhl3ETJZAzGmjahzqFzMDIh
         urfJJO2TgrxXrke3I5SxGRQwJuEHexRUvOYp+umLbovTGbcHiMjD9pw2nlYJXgcsKsBF
         lyigKy/NtTYzViScgwNaTTEZLlfJs9kR6tgslHn8uZDYP1uapPiIC5fYmY842VxfkzC/
         huUOkZpj++GV8m3jKsc1lKCcyDIKAti5QR8ZGu0bzTnWJ/YB8h2Ogzg4sHhVzBAI7Iig
         YXcA==
X-Forwarded-Encrypted: i=1; AJvYcCXAAiHWr0f5uYR7+cKNz6rhCFnEw+D/NLW7vqbjDCfYpWmdG46ionLHBe2OOXkVct4yZ8C7ZxxtQGmt@vger.kernel.org
X-Gm-Message-State: AOJu0YxUAgj3YNSbvfyqtTamzoz4TWd73gD0Ck5XOC8WNFtYHbTWhmiL
	UgwD185AYpwvSN9bGy0kLcwGVaFumc11nwwwM1BTGRQuJ62DhoIp84V1vkSE9152K6fMKtJ/jX/
	tahZvS/FD/cwxvyFZwyrqHBQLhxjL0upsbThtwxJTf4WH13P0iwjIgkg=
X-Google-Smtp-Source: AGHT+IGFA7vO4U2x3q6uAPBDzuTKgONZPR+0I/WW2RDdNThGI7VcDHE7KiA+lQeHU0V2dPevX7he5TheTnl8dkXWYd5ZPtDh9PWA
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1487:b0:3a6:aee2:1693 with SMTP id
 e9e14a558f8ab-3a6b0250c4emr195392805ab.6.1730861480603; Tue, 05 Nov 2024
 18:51:20 -0800 (PST)
Date: Tue, 05 Nov 2024 18:51:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672ad9a8.050a0220.2a847.1aac.GAE@google.com>
Subject: [syzbot] [usb?] [scsi?] WARNING: bad unlock balance in sd_revalidate_disk
From: syzbot <syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c88416ba074a Add linux-next specific files for 20241101
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1051f55f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
dashboard link: https://syzkaller.appspot.com/bug?extid=331e232a5d7a69fa7c81
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16952b40580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/760a8c88d0c3/disk-c88416ba.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/46e4b0a851a2/vmlinux-c88416ba.xz
kernel image: https://storage.googleapis.com/syzbot-assets/428e2c784b75/bzImage-c88416ba.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com

sd 2:0:0:1: [sdc] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
=====================================
WARNING: bad unlock balance detected!
6.12.0-rc5-next-20241101-syzkaller #0 Not tainted
-------------------------------------
udevd/5897 is trying to release lock (&q->q_usage_counter(queue)) at:
[<ffffffff862f40d3>] sd_revalidate_disk+0x7933/0xbcf0 drivers/scsi/sd.c:3808
but there are no more locks to release!

other info that might help us debug this:
1 lock held by udevd/5897:
 #0: ffff8881433c14c8 (&disk->open_mutex){+.+.}-{4:4}, at: bdev_open+0xf0/0xc50 block/bdev.c:904

stack backtrace:
CPU: 1 UID: 0 PID: 5897 Comm: udevd Not tainted 6.12.0-rc5-next-20241101-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0x25b/0x2d0 kernel/locking/lockdep.c:5287
 __lock_release kernel/locking/lockdep.c:5526 [inline]
 lock_release+0x5cb/0xa30 kernel/locking/lockdep.c:5870
 blk_unfreeze_release_lock block/blk.h:745 [inline]
 blk_mq_unfreeze_queue+0xd2/0x140 block/blk-mq.c:213
 sd_revalidate_disk+0x7933/0xbcf0 drivers/scsi/sd.c:3808
 sd_open+0x21e/0x610 drivers/scsi/sd.c:1534
 blkdev_get_whole+0x8e/0x450 block/bdev.c:689
 bdev_open+0x2d4/0xc50 block/bdev.c:916
 blkdev_open+0x389/0x4f0 block/fops.c:627
 do_dentry_open+0xbe1/0x1b70 fs/open.c:962
 vfs_open+0x3e/0x330 fs/open.c:1092
 do_open fs/namei.c:3774 [inline]
 path_openat+0x2c84/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1419
 do_sys_open fs/open.c:1434 [inline]
 __do_sys_openat fs/open.c:1450 [inline]
 __se_sys_openat fs/open.c:1445 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1445
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f64b7d169a4
Code: 24 20 48 8d 44 24 30 48 89 44 24 28 64 8b 04 25 18 00 00 00 85 c0 75 2c 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 76 60 48 8b 15 55 a4 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffcdb024940 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00005623a7271270 RCX: 00007f64b7d169a4
RDX: 00000000000a0800 RSI: 00005623a725b4e0 RDI: 00000000ffffff9c
RBP: 00005623a725b4e0 R08: 0000000000000006 R09: 7fffffffffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000a0800
R13: 00005623a726ee60 R14: 0000000000000001 R15: 00005623a724f910
 </TASK>
udevd[5897]: inotify_add_watch(7, /dev/sdc, 10) failed: No such file or directory


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
