Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BFB22B8AB
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789957182; cv=none; b=YohO/X7CdxxaSHGlfOZfIPfo6Xbp3FLfitZMqonGBY8d4Z7mf6XpRbkZECcz9W8h6yB2AHDe3a0SlduO5dI5QvsdMpnUXtxs12rBpvxataUzxrtt7iam/64tqrYoMVMFcIaWAKzuOEqyc+d1HIcv5BYItV5sZERhFPXb/fccrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789957182; c=relaxed/simple;
	bh=BAsIUQ1nVkUgpzwJBCmVe0ojZCDOZnN7HyCcAiuT6So=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BW6zjYi9lQKuJWvkNX1CsM24Mh+T9pyyE4ihVMH3Xs57kmSViNRmXaO0FIY9uu1oJibl4Kygo2iPWCbZ2NqzE1HeuqzcHMPlkSG7Q6FI/zD2JF3k5J9YAz6kb/RHLO2Ki6RFst1GpKTdh5Or2DhLIsIUfxf1vmJLs/+6xGkFn7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6c18e7d53b9so5687085eaf.1
        for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 19:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789957180; x=1790561980;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPYuXaERi/jrwZ0INi/v5/jDFp/Y0zqC2P4+v3xDKMA=;
        b=wYC9bqaSJmF72cC+ez5hzEB/GB96ag8LOrVsz/NQOkNv5cL4UH3k28RVBj9M7mDiCT
         3KSgjqwwFDEk5K6xv3XaGkTyg5ay3y/us5MzcaT2FzuInfJifaj1aGgV5w86xRLE5jdr
         rSfjrfcz5NeoZExbJrXSzWMGSe3QZpKhadM+yvaXpblqUY2Tz4nTSKTtEHeXxsUpgz7Z
         MMAjv6thng6jvkXDPLp9dS23DCLNWh718y2f8+6usM3hC87ZHw91R7CbnGkafFDU36hz
         XTK2D3lIVFfjqPfxYZqtKRea9YmGPho1dfjtWeae7RemixJuy2d99Ux5l43ozR7uTpTF
         Roqw==
X-Forwarded-Encrypted: i=1; AKwUvBzp1a0Cj/pdbkghA8XvmxeXI0eMwUg19v12gDe43DLptXxNnE8Oloojy+oznNu8McslvxiTrJzq/cxT@vger.kernel.org
X-Gm-Message-State: AFuF++kBU+cCbIW9NkDE6MZLZ0C+BLKIM8VjhSWjZ85IKMx8IwiaHFUk
	3iXJ9C9MQOSjZ2lGfhF7WOPahwX2LEt7UpeZWVFRy8SB1zE5MH829WQ6QgheptFtXorECUyR4J4
	xBJd6ZThn/5qBhX/B6+6GaPPjZIO+KI3i1KuqPx2oPLiodNpB/mW3p/XAzVs=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4cc9:b0:6ba:34ea:ab69 with SMTP id
 006d021491bc7-6c8ffa2ca25mr10838622eaf.40.1789957180033; Sun, 20 Sep 2026
 19:19:40 -0700 (PDT)
Date: Sun, 20 Sep 2026 19:19:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab0943c.514bccd6.255447.000a.GAE@google.com>
Subject: [syzbot] [target?] WARNING in rd_configure_device
From: syzbot <syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mkp@kernel.org, 
	syzkaller-bugs@googlegroups.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9d80aa4617b3 Add linux-next specific files for 20260903
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13c1dbf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b370c26fb58c72f0
dashboard link: https://syzkaller.appspot.com/bug?extid=fa495e1497c48a6ed885
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/84a12994f553/disk-9d80aa46.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2329deeb3b2b/vmlinux-9d80aa46.xz
kernel image: https://storage.googleapis.com/syzbot-assets/689910d8c695/bzImage-9d80aa46.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: mm/slub.c:5347 at ___kmalloc_large_node+0x10c/0x170 mm/slub.c:5347, CPU#1: syz.3.40/5899
Modules linked in:
CPU: 1 UID: 0 PID: 5899 Comm: syz.3.40 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:___kmalloc_large_node+0x10c/0x170 mm/slub.c:5347
Code: 41 c7 46 30 00 00 00 f8 eb 03 45 31 ff 4c 89 ff 48 89 de 89 ea 5b 41 5c 41 5e 41 5f 5d e9 8c a0 0b 00 c6 05 8e e4 58 0e 01 90 <0f> 0b 90 31 c0 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc 89 ef 89
RSP: 0018:ffffc90004b7fa88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000008000000 RCX: ffff8880237eddc0
RDX: 00000000ffffffff RSI: 0000000000000dc0 RDI: 0000000008000000
RBP: 0000000000000dc0 R08: ffffc90004b7fb47 R09: 1ffff9200096ff68
R10: dffffc0000000000 R11: ffffffff869fe6a0 R12: dffffc0000000000
R13: ffffffff869fe7a9 R14: 0000000008000000 R15: 1ffff1100eff52c3
FS:  00007f0d2de8e6c0(0000) GS:ffff88812495b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c470003 CR3: 0000000036170000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5390
 __do_kmalloc_node mm/slub.c:5407 [inline]
 __kmalloc_noprof+0x3f6/0x710 mm/slub.c:5444
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 rd_build_device_space drivers/target/target_core_rd.c:194 [inline]
 rd_configure_device+0x109/0x730 drivers/target/target_core_rd.c:294
 target_configure_device+0x13c/0xa70 drivers/target/target_core_device.c:988
 target_dev_enable_store+0x3e/0x80 drivers/target/target_core_configfs.c:2484
 flush_write_buffer fs/configfs/file.c:207 [inline]
 configfs_write_iter+0x337/0x430 fs/configfs/file.c:229
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0d2cf9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0d2de8e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f0d2d225fa0 RCX: 00007f0d2cf9e159
RDX: 0000000000000002 RSI: 0000200000000280 RDI: 0000000000000004
RBP: 00007f0d2d03506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0d2d226038 R14: 00007f0d2d225fa0 R15: 00007ffe861d7d28
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
