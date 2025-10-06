Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFB2221543
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 17:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770401; cv=none; b=iekUgnyDlH8OpzyOI0h4SZ7m55KBqQkCWKF7zZJBCr7KNDlHXu55ScqRPC5tM/yE2w8ElmA5x0Wiq/F0kYhxLUpl3nEy0AP0nMDBian9kVVnbXgJq2onQqq06XmlZuriTE18JxwQtp6P/W+7VJKmEIkGOWNWFHxr23vH0GcBCDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770401; c=relaxed/simple;
	bh=a38ZD1cGESrwnzHb5XiH2nwhUEIyTa8y31XE4bDogVc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=m0PibsbNU/9AmWD2b/S3LRAt9QtGD0cK8K32yUhyni5VIrLWcVzURMdIPl9OPIUkKyA6YDRlYqAHsgJa5puk4R6J1IHV3ifHVTkxRdgMqfRl4pYOYlFV+4IE1S696DNH7azUpQwmEH7kWQYJCuaFRdPJDGnNsxMKyVgrbBAYu0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4256ef4eea3so60149595ab.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 10:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759770399; x=1760375199;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4upw0LzDkCIV2/KoZH6/pMGhPVw8QDjxclh7G1MmS0=;
        b=Y4nMly+9tTfFImDQYoexsfnMFjnh28aOwFJtG8aQ4I6q64js2nEGYozES4bavFp6rF
         QGfG8Vq28hDgUpXPvy0UEO6UuJFfKslqYvaaRAZ0/6ZZvKS70mypJU2gGPRKDOzir9Ev
         7gHxLnGhA+ixsKB7/SI9OzDMbeTh5NkiDDEW4TkN94S4y9SGlQyPJuQ0Oj4V4VVwhwZO
         5qEtlajcyqq0MIE5D9TN/Q7M1WbD8v3J5zU6TcqWE3wiGiSMq7zO36PQ6nJTMO7T1oJg
         V2r6Yuo0UgQ5zml95TsIrCTTCrxUnVG42RLomM0WQ521w0AFyGwh0BenQcKWrcmYSgIK
         LcfA==
X-Forwarded-Encrypted: i=1; AJvYcCWNadRcO14YKC87vfpuFxT7FoQGHfws8mzbgfqygsyFIReBTioi9eLzQPXalDHK2tsf+6dv3ePW1+Yw@vger.kernel.org
X-Gm-Message-State: AOJu0YxfJM/gBhOLp15IrP2ls3Cm7aTp0HUQ6ihCVx6by2t1EXxTzUU6
	5ec+kBuUP4bIxCLiEJUEC1f/CL0mHnur4do8g3CFFjBqGlgIaRF1vQlmmXB21s5y+6KRWcHVvQx
	gnTKDISuGaBKAKX6kJGQM0gyl6ieU01yTa9gBNzrZWfGGWgaF6S5EBI6QZlY=
X-Google-Smtp-Source: AGHT+IFopE9GSbNTifmJfN9G/acxuY7cnCA9Z5JbBQ4z/AVUaWy1wTuw/OTvV8LLfnCPUQgprU1qgayYKgKmyU5f4K4Af37Vur3l
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b0f:b0:424:1774:6915 with SMTP id
 e9e14a558f8ab-42e7ad0a71fmr167886625ab.8.1759770398860; Mon, 06 Oct 2025
 10:06:38 -0700 (PDT)
Date: Mon, 06 Oct 2025 10:06:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e3f71e.a00a0220.2a5ca.000c.GAE@google.com>
Subject: [syzbot] [scsi?] upstream test error: KMSAN: use-after-free in scsi_get_vpd_buf
From: syzbot <syzbot+f627b4ca9d1c5894ae1d@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fd94619c4336 Merge tag 'zonefs-6.18-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169595cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ad506767107aacda
dashboard link: https://syzkaller.appspot.com/bug?extid=f627b4ca9d1c5894ae1d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f3f6ed23a50a/disk-fd94619c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e36679259d5c/vmlinux-fd94619c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c3e733ae21be/bzImage-fd94619c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f627b4ca9d1c5894ae1d@syzkaller.appspotmail.com

scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
=====================================================
BUG: KMSAN: use-after-free in scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
BUG: KMSAN: use-after-free in scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
 scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
 scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
 scsi_update_vpd_page drivers/scsi/scsi.c:479 [inline]
 scsi_attach_vpd+0x7a8/0xe70 drivers/scsi/scsi.c:532
 scsi_add_lun drivers/scsi/scsi_scan.c:1110 [inline]
 scsi_probe_and_add_lun+0x6933/0x7f20 drivers/scsi/scsi_scan.c:1288
 __scsi_scan_target+0x2fb/0x2050 drivers/scsi/scsi_scan.c:1776
 scsi_scan_channel drivers/scsi/scsi_scan.c:1864 [inline]
 scsi_scan_host_selected+0x68f/0x9a0 drivers/scsi/scsi_scan.c:1893
 do_scsi_scan_host drivers/scsi/scsi_scan.c:2032 [inline]
 do_scan_async+0x1ad/0xdc0 drivers/scsi/scsi_scan.c:2042
 async_run_entry_fn+0x90/0x570 kernel/async.c:129
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x230/0x380 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 slab_free_hook mm/slub.c:2440 [inline]
 slab_free mm/slub.c:6566 [inline]
 kfree+0x254/0x1460 mm/slub.c:6773
 call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
 umh_complete kernel/umh.c:57 [inline]
 call_usermodehelper_exec_async+0x666/0x6f0 kernel/umh.c:119
 ret_from_fork+0x230/0x380 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

CPU: 1 UID: 0 PID: 69 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: async async_run_entry_fn
=====================================================


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
