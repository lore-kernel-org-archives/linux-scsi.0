Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF512BEA0
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711636287; cv=none; b=QvyiPk7FvN0PU8Ag+cvth0JONDkcP6SUjYrW4IaRnBLg4n24tmb2IYyhrSm4yvkMkf5HNugm0zDws5C1ZzF15Z4IunayYRD257RC1094nY9T8Sm1NSQm6UCCqD+Y5g7jjQ97UaMnAO98B2QjV539/FGFFeyYXJvj496wpgPrchY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711636287; c=relaxed/simple;
	bh=ql0ShIXEVLTm4DaLyg9Gu3OwM9uQ9LAPxl/H3BUej5c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LEhXTR74DMlAt8zqBjDBpzh7YOfu86kSldgI/wZcbOuBmUO/Ry+zCjH1PXnt8//V8x1bYG9Ios13fxIxtvghzMNETlU0eww4diKNekCs1X24ty4RG50m2suZ8jkIyyCvVLdL6AHUQei6CBUS5y5lF3ii6WfCcgNA70us/y+tMeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7cbfd4781fcso95818439f.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 07:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711636283; x=1712241083;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKHhWn51ldZDqfWJ6q60eQUGHhOBY3BJue8OM3ps8qY=;
        b=SyaOcjeLIWrk82Sdr/4pdc3LAHcXa+LYPvN7rTHmDyscBkuzBhqoGW7qDvESxWVZfS
         PWSnbGXnwkePog4pJumlMEJ3SgwZZqrWwiAZ7myxpsf+Ex5//C1hXS6NomNCEW+BKOsx
         HBTN9WTE8A1n6rJesYEM/EKluQPM9SBu7YMbU0onIuE9gcczRW6RAy7wzZPBdCaMVWnF
         +S5p7EjaRZTN44MpBGx+Gk6kek1jYlnSTLo3lWDsC+qGZ3k2pN4oahoNqD2Cq0wnGY9c
         U/QAP61FEiAdrnPu1/h9o+2GnDAvz4tz/uoILrHMo2Snp+nHq4RD0u6pLUXuvPgLkAG9
         +hKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxGAkM1ud7SAokDRA9EqYgKR8MIYUKfMYP6UPFFJsVQAvsvwfB1WTkNKYt9xBxgXaxq6DtEM85XYIyWTrvHYfVQm/cWCHhrvsclw==
X-Gm-Message-State: AOJu0YyzI9LMNxKPKMUX14Zgvbz5KCilYsJJoRiQ0gFHPeCeeqsgYcs/
	BCTQsMGy0GP21m2Jan9YoUGBRjlyhjXKsbenwnvEdpvAcVHWsnkYMaohN3T5KoccnvrPRtED05s
	rj36aPGizoHIDkoOldAlAg3FuL3A4EYuf0xGbQZk0pQIUhjN1HD/P4IY=
X-Google-Smtp-Source: AGHT+IF2esD8gMeDLCuj3r/4WBmGLTuFwxUM3dV8BeC3Bhnp634ROWL9Mpp1q1684CUTBqa4XaEpZJxsudSuErOCU0lT0XFow66+
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3789:b0:47e:c0b0:5a08 with SMTP id
 w9-20020a056638378900b0047ec0b05a08mr102477jal.4.1711636283301; Thu, 28 Mar
 2024 07:31:23 -0700 (PDT)
Date: Thu, 28 Mar 2024 07:31:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a6e0450614b960ac@google.com>
Subject: [syzbot] [scsi?] WARNING in sg_remove_sfp_usercontext
From: syzbot <syzbot+93cdc797590ffc710918@syzkaller.appspotmail.com>
To: dgilbert@interlog.com, jejb@linux.ibm.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a6bd6c933339 Add linux-next specific files for 20240328
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=126f4231180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0058bda1436e073
dashboard link: https://syzkaller.appspot.com/bug?extid=93cdc797590ffc710918
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7c1618ff7d25/disk-a6bd6c93.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/875519f620fe/vmlinux-a6bd6c93.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ad92b057fb96/bzImage-a6bd6c93.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+93cdc797590ffc710918@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 46 at drivers/scsi/sg.c:2236 sg_remove_sfp_usercontext+0x3f3/0x530 drivers/scsi/sg.c:2236
Modules linked in:
CPU: 1 PID: 46 Comm: kworker/1:1 Not tainted 6.9.0-rc1-next-20240328-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: events sg_remove_sfp_usercontext
RIP: 0010:sg_remove_sfp_usercontext+0x3f3/0x530 drivers/scsi/sg.c:2236
Code: 8b 36 49 8d 96 4d 01 00 00 48 c7 c7 a0 fe 4b 8c 48 c7 c1 c0 07 4c 8c 4d 89 e0 e8 d8 a3 eb ff e9 f7 fe ff ff e8 8e 9d 74 fb 90 <0f> 0b 90 e9 3f ff ff ff e8 80 9d 74 fb 48 8b 44 24 08 48 b9 00 00
RSP: 0018:ffffc90000b67b48 EFLAGS: 00010293
RAX: ffffffff8620cd42 RBX: 0000000000000002 RCX: ffff888015171e00
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: 0000000000008000 R08: ffffffff8620cc7c R09: 1ffff1100412372f
R10: dffffc0000000000 R11: ffffed1004123730 R12: ffff88805fb20000
R13: ffff88805fb21688 R14: ffff88802091b978 R15: ffff88805fb20148
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32227000 CR3: 0000000068468000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 process_one_work kernel/workqueue.c:3218 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3299
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3380
 kthread+0x2f0/0x390 kernel/kthread.c:388
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
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
