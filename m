Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16BA23D7E9
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 19:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759953152; cv=none; b=X296KmOcihviZtweMj6mG7xMNweH1FC8M8Uc+z88KAXn9Dd2HfSH/myIbNfrZR0Z/B2LFZvCwjOsCeMEOUnXIlfkM/I6WJXpx1rv4pt5AR2bHJUQ5ZBHqYEWsQM/hZFfNYeE6GZs6xnTo0VvBjK4X3SEco4rVkMGdb6DiO/XrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759953152; c=relaxed/simple;
	bh=m0mXtfquwpn/pEAXm5hMmK81nOqk8zME+wKLQt2LOLw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=B0T4KjRpIgD5b3iFN0PJjwEjyfxOec658LU2BmHSiKPGF7IiI1JzYFWhFSVAPo3I1t6ZFfErWKqU7rTw3ZgYRSFbjC11swBVf+YfyWLtOofUevZgpVkcBT5d2WXA1eycqRGlqlTjEhvc4rhDJebICVpK7fB7xYCZCQB3MZuH7IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-93bc56ebb0aso88720739f.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Oct 2025 12:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759953150; x=1760557950;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RF6ld1yoxd2iac/gXPbsZ8hOKk5638W+Efo0S99r2KA=;
        b=XrmXHnIFU/jKTG3gm/s1ItPAw691PiQ1OFdIrnEB6SeyfQ7YEv8+iRdWcCsXnrdO4w
         z4xmip83oB4vvAc98k8tNZ3Tf8j9scCqiEkER3pdj1MfpnRQbdC2ItIj2+KIIlrwWVWx
         HBvSQsl1YTSMw0/xUjsXbI/PMOcyX/5f9v1TC/8kpMnzex2eJDWGywEClxW0mhxWmleN
         rE/GAoiEgjKLA3LDP62XovWrH9gAhGaGTODywDmXXpxXvrKt8cbF5O9OUO25wqi/Wsgz
         8Gi7zVOpv8wW5r4AUzv7c9mMVXatEuerK2YDoEzTQ4rUP8CPGEBwX1oO/DDDCaTcUQD3
         /CSA==
X-Forwarded-Encrypted: i=1; AJvYcCWFVxqOaKha7m0kU94VKF82Rnk7R5cyANgSWuvH8L2JAFFIQn8Q7rbpVXR3HJwRKoCuBJYlh5aBQiZl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4zNeyXLtX/srkIYHbdXZMP1sLSmph5m5K0wC7OVKfHgcRTqDz
	6geLFVUX+hYlJf+y9q7Om5ZzE+LPf8nfGBOOKNKT1Y9Jb9C9D0up3Cb5MDcl6fVSgDF3qQtmR8t
	6qYIFDqcWAT8Ek545QcDG4RiT5/CFB0mE1UiFh3v4SmzA4NJWrx2dgMJzaAM=
X-Google-Smtp-Source: AGHT+IGqBHBHmzcQpVTB65cO6A7xkJQCfYtTXlLNYqtrBqApqQ52UnKrXEuB8fhi94o6kqQVgJGnU1Tehmck2xqdb6/k6/RipGBN
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6cc4:b0:920:87f9:5da8 with SMTP id
 ca18e2360f4ac-93bd196672amr490520339f.13.1759953150078; Wed, 08 Oct 2025
 12:52:30 -0700 (PDT)
Date: Wed, 08 Oct 2025 12:52:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e6c0fe.050a0220.256323.00fd.GAE@google.com>
Subject: [syzbot] [scsi?] upstream test error: KMSAN: uninit-value in scsi_get_vpd_buf
From: syzbot <syzbot+a7b56f5926d90eaf5071@syzkaller.appspotmail.com>
To: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    971199ad2a0f Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1415792f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed013bd3465f2abf
dashboard link: https://syzkaller.appspot.com/bug?extid=a7b56f5926d90eaf5071
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/32974b5d3b23/disk-971199ad.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3850d8c7dc24/vmlinux-971199ad.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ab0a4c5a862/bzImage-971199ad.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7b56f5926d90eaf5071@syzkaller.appspotmail.com

scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
=====================================================
BUG: KMSAN: uninit-value in scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
BUG: KMSAN: uninit-value in scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
 scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
 scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
 scsi_update_vpd_page drivers/scsi/scsi.c:479 [inline]
 scsi_attach_vpd+0x380/0xe70 drivers/scsi/scsi.c:520
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
 ret_from_fork+0x233/0x380 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5206
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof+0xf7/0x200 mm/mempolicy.c:2487
 alloc_slab_page mm/slub.c:3030 [inline]
 allocate_slab+0x26c/0x14e0 mm/slub.c:3203
 new_slab mm/slub.c:3257 [inline]
 ___slab_alloc+0x131b/0x3d90 mm/slub.c:4627
 __slab_alloc+0xa3/0x180 mm/slub.c:4746
 __slab_alloc_node mm/slub.c:4822 [inline]
 slab_alloc_node mm/slub.c:5233 [inline]
 __do_kmalloc_node mm/slub.c:5602 [inline]
 __kmalloc_noprof+0xba3/0x1b40 mm/slub.c:5615
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 lsm_blob_alloc security/security.c:690 [inline]
 lsm_task_alloc security/security.c:777 [inline]
 security_task_alloc+0xa1/0x6b0 security/security.c:3229
 copy_process+0x235a/0x5eb0 kernel/fork.c:2163
 kernel_clone+0x416/0x1080 kernel/fork.c:2609
 user_mode_thread+0xde/0x110 kernel/fork.c:2685
 call_usermodehelper_exec_work+0x8a/0x300 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x233/0x380 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

CPU: 1 UID: 0 PID: 58 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(none) 
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
