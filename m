Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CB938B12D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791324683; cv=none; b=ZE4OXucYlO1ywNwi8GSWeuEfIv9jGBiFzpeRPNQfQEXYcCclPfyfPllgJR421GuylmWtCNq6e26H1Bdk2YlIFtlrRQtGGL0UJnzh0BQQNhHj4y/ijS4nbEuT/v1srFjV1QxLECxCY1WFXT0XQPuqaUPeccDMCv5xUZusL9DFaP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791324683; c=relaxed/simple;
	bh=12DSvA6Ez73SHL+5o+msk9/BwkZqgDWpNy84eAjxQPs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=D4yP04PLlNhWPcTx2gSF0LTF+XugnSsy7zgHxObVrJBmduc30Tt5b8m5xysT+nPJmZAQnpK3aCf8H48b/iaXouGQ0yiGihdeQ+gFrwb8w2wfmMJ5tpaDRWayy6p/Tx90cw9tPkAOahk7o5UvJEmm+Fb4JjdNsPetL7qEIxqIqgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8233f34d21eso4534216a34.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 15:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791324681; x=1791929481;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fjGNOAp+OvnHzpHgyNhacn17hvNikZq61kddzziGLXg=;
        b=BweAFDadhKH1/vpLGk7HaFrS1JzJNVqZMOwp2fFrGJfUIgQVvJSyhdJKqS4Rtc02Zl
         aka0KsIcyiiCEf+1yMQUWZv+mIHrvDSgZGMNbqo8Dy/4c1unq/BegWMFAvjYcy639Z64
         T+W0obHyCMZpzCxb7Pdbpua8whZd0n8kowv4CFBCK4g6/HFi5xPxUzKU8xhRMcRwTm3S
         WwVZENTEvEqV9/VzKv8+GSp4yDidbwI6D2RwtwgpONfipoKXrBDOqmIGgIcm3pXsZu6+
         EAG1B3XcEnxOqw17ySUIartj6tA145WgThcyLFF7DStagstBTmdqeQGIZa8qN4ekRHEl
         7gvg==
X-Forwarded-Encrypted: i=1; AKwUvByoN87z1SB6uuj7bDAsgT25EPVFNJgPY4kpBuBTkW6zshzEjWJ72osYW9Cd1c5G8DcdHMnyshZoydR6@vger.kernel.org
X-Gm-Message-State: AFuF++nQRy8XBEz/aFCh84xbsfrvhnTRqG7B00o62YBHwbQ6t5W4bR4l
	O/P1rtXIQtCsZrOiXpJtqObSKboRpvn9PZVnE8Wi16BWa4CTGusAKiRbY9rHmBnAl18vARElb4K
	/Qy/2dV+Kso65AmHxjTNDm1MJc8jFtotapqBcmxDyplIs0OaIusxXb4GKAwc=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c40c:b0:4b9:a88b:888e with SMTP id
 5614622812f47-4fc45d579d0mr790989b6e.36.1791324681143; Tue, 06 Oct 2026
 15:11:21 -0700 (PDT)
Date: Tue, 06 Oct 2026 15:11:21 -0700
In-Reply-To: <6ab0943c.514bccd6.255447.000a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac57209.353c8d8e.177895.000a.GAE@google.com>
Subject: Re: [syzbot] [target?] WARNING in rd_configure_device
From: syzbot <syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mkp@kernel.org, 
	syzkaller-bugs@googlegroups.com, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    eea3fef32a9c Add linux-next specific files for 20261006
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1717fff5580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36aaffb2bd6a0a93
dashboard link: https://syzkaller.appspot.com/bug?extid=fa495e1497c48a6ed885
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1097fff5580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: mm/slub.c:5459 at ___kmalloc_large_node+0x10c/0x170 mm/slub.c:5459, CPU#0: syz-executor320/5981
Modules linked in:
CPU: 0 UID: 0 PID: 5981 Comm: syz-executor320 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
RIP: 0010:___kmalloc_large_node+0x10c/0x170 mm/slub.c:5459
Code: 41 c7 46 30 00 00 00 f8 eb 03 45 31 ff 4c 89 ff 48 89 de 89 ea 5b 41 5c 41 5e 41 5f 5d e9 5c ca 0b 00 c6 05 b8 ae 76 0e 01 90 <0f> 0b 90 31 c0 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc 89 ef 89
RSP: 0018:ffffc90003287a88 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000004000000 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: 0000000000000dc0 RDI: 0000000004000000
RBP: 0000000000000dc0 R08: ffffc90003287b47 R09: 1ffff92000650f68
R10: dffffc0000000000 R11: ffffffff86a6d4d0 R12: dffffc0000000000
R13: ffffffff86a6d5d9 R14: 0000000004000000 R15: 1ffff11006d1a2c3
FS:  000055558e991400(0000) GS:ffff888124633000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005560dd7ca000 CR3: 000000002755e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5502
 __do_kmalloc_node mm/slub.c:5519 [inline]
 __kmalloc_noprof+0x3f6/0x710 mm/slub.c:5556
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
RIP: 0033:0x7f3f2d0cd537
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffe88432110 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055558e991400 RCX: 00007f3f2d0cd537
RDX: 0000000000000002 RSI: 00007f3f2d1060c3 RDI: 0000000000000003
RBP: 00007f3f2d108320 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007f3f2d1060c3
R13: 0000000000000002 R14: 00007f3f2d130cc0 R15: 0000000000000002
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
