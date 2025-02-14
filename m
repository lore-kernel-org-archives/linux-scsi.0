Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F71C84D9
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739563107; cv=none; b=UqCfvwl3esKZduYZPncrNWQTBUD2wNPpg3RN/RjPI9C4eO/Zb7eXAr9Gj1fHioyB1y2oDEifrO1qe5ltTh8BYtPcGfdACytQXrq0udz64pli/10pXdG+U3T/CtTwJHB/hbjhRmo6SQSY7S0btfUaBXFAYIdfQd1pz9vK80dRTek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739563107; c=relaxed/simple;
	bh=An93+tleFgQMT+Nla8JNOYOWFmX9GqrpN51TLo+yq9A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DWjO9mmvSTBMY/RT0OF7yVukPalWXbD0B2O7nWPYIKohEdTEuSqQ968/CspDpehBJsS7MEiwq9KwKfG1yKwejtWM6m8tkHN7Ohe4yFw+JnN0H4j2eZsEynZHm5TQJ3wA4/dABbDe/DxKy3CttimUFXDa19Tg4WPcPh0izFQ84/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3cfba354f79so48080165ab.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 11:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739563104; x=1740167904;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gnX8N2DEEYYmILHFY2tHj2QH8gdUdw/2zdatoc/JaG8=;
        b=Qh87WKJsQMk1heWO8dT01wdome9+RnyhVu2sTD7rCiPgg/J7lxkN4XmVX8j0ldyVMX
         tpaD8arlm3dn+PBY/KzBiRw3m4dsgrKBVTByA6491p+1RyHUR1NeqiHQ+BPDDwsHB7Ws
         LjEtg04GNPCYWd2ezfwsobYdiILTkfgBfEdR1J2rzE1Ycl1cjFOZAsN+fa335Bueai3H
         RWE9CNLVUwWZbZqJATDBief6KLya2PcKkXpslOK2/NiNGjj4txWCUUEipWCs1V/kBJ3O
         EYPZlbb77o4uF7QsB4VB+LKoHb4vxXViZUR3xMg8NvFCMzcXQlYP4rSkzIEYDvja5kjp
         Rl5g==
X-Forwarded-Encrypted: i=1; AJvYcCXEYbXgYYLNDIuyodyvtkE6AJBhEfeGwOGca1UtVQp0wER6EC2k8yQnUDqgSK8fDfdp7oKTEgcjv/Qt@vger.kernel.org
X-Gm-Message-State: AOJu0YyEABRJ0ndmYMISIpodVPG4vZV4vOacCIynp+Y4NqdODFDi7f0q
	dB6baig5GQfDJRgsrcGn0oEHrVIAVrl42OXVNttjmyZFC4HNxZ8fyrACSoDctH4pY2o+jvpNNnV
	xRNs2Zko0nFDOEMufhmA3cFxHJvAYzwzryDYEJMElgHxhLc7d0ZgD/3A=
X-Google-Smtp-Source: AGHT+IFDoFH0lR33XpdUFRtuUBmJT/pGH49QkI9Rr8mJg0K4ANZWwdrVJ/pA3YINgwrIdf8UFM3h6Rbkz70rZ+ddvnvwgIYe8J7U
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c2:b0:3d1:99b1:153c with SMTP id
 e9e14a558f8ab-3d2807b0f46mr5893205ab.7.1739563104470; Fri, 14 Feb 2025
 11:58:24 -0800 (PST)
Date: Fri, 14 Feb 2025 11:58:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67afa060.050a0220.21dd3.0052.GAE@google.com>
Subject: [syzbot] [scsi?] UBSAN: shift-out-of-bounds in sg_build_indirect
From: syzbot <syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15908bf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=40c8b8384bc47ab0
dashboard link: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149a87df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167a8f18580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da4c858d8649/disk-128c8f96.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4bd8410dd596/vmlinux-128c8f96.xz
kernel image: https://storage.googleapis.com/syzbot-assets/038939e96f8b/bzImage-128c8f96.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1897:13
shift exponent 64 is too large for 32-bit type 'int'
CPU: 1 UID: 0 PID: 5832 Comm: syz-executor361 Not tainted 6.14.0-rc2-syzkaller-00185-g128c8f96eb86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x24f/0x3f0 lib/ubsan.c:468
 sg_build_indirect.cold+0x1b/0x20 drivers/scsi/sg.c:1897
 sg_build_reserve+0xc4/0x180 drivers/scsi/sg.c:2007
 sg_add_sfp drivers/scsi/sg.c:2189 [inline]
 sg_open+0xc37/0x1910 drivers/scsi/sg.c:348
 chrdev_open+0x237/0x6a0 fs/char_dev.c:414
 do_dentry_open+0x735/0x1c40 fs/open.c:956
 vfs_open+0x82/0x3f0 fs/open.c:1086
 do_open fs/namei.c:3830 [inline]
 path_openat+0x1e88/0x2d80 fs/namei.c:3989
 do_filp_open+0x20c/0x470 fs/namei.c:4016
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x175/0x210 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1dc41ca3e9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeaa93f3d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007ffeaa93f5a8 RCX: 00007f1dc41ca3e9
RDX: 000000000008a002 RSI: 00004000000000c0 RDI: ffffffffffffff9c
RBP: 00007f1dc423d610 R08: 00007ffeaa93f5a8 R09: 00007ffeaa93f5a8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffeaa93f598 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
---[ end trace ]---


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
