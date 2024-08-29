Received: from mx6.ucr.edu (mx6.ucr.edu [138.23.62.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA6C12F399
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 06:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=138.23.62.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724913646; cv=none; b=JnqLlUx+/cPuQ/3BRoIPtiBjVaVdQnRqm1skA6oBjE2aSaT9TOrU5W9Ipsr65dPY49DHqeghxQEvG5mCYLv9h/DiZuZQLhA+w2jNVVs7PM3lo/AzWhA5Dxn/FmFlsxXZCoP3aTCFsQZ9+/fOMnqJHOaqG5U3tkO26DaHBZZF11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724913646; c=relaxed/simple;
	bh=7LT5c84MDOwdUGrqpXcjjjVR1M018VNxDt8pZP4zJR4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ufxkh21L+gMpLE+Al2+WWWehjEPnW6TTlJBD97FoJE8Zcc1sbb436s2v1GMtoak4jbbySTqSZszyZtwYxfO235THcWM27fPzZ7DG3tk52kGT3bU1x7miEUMtLxntW7yqkyzfP2qsPtmhhP0YxxQ7QuZKBihKy1vo+AJyCyIwcVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu; spf=pass smtp.mailfrom=ucr.edu; dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=tjwNcpXF; dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=XCKnESI5; arc=none smtp.client-ip=138.23.62.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucr.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="tjwNcpXF";
	dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="XCKnESI5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1724913644; x=1756449644;
  h=dkim-signature:x-google-dkim-signature:
   x-forwarded-encrypted:x-gm-message-state:
   x-google-smtp-source:mime-version:from:date:message-id:
   subject:to:content-type:x-cse-connectionguid:
   x-cse-msgguid;
  bh=7LT5c84MDOwdUGrqpXcjjjVR1M018VNxDt8pZP4zJR4=;
  b=tjwNcpXFzhkD6VXeHc3KnosPxaz/YF3qx7cTZOG9wcdufddn4yh3Cyeg
   +2MoqDwRwJFlYP3zYgSDiD9n5yO+cB+7M67SaikQVJDsjFe9J0HKOQ0YR
   NA1y4oTyxRPrWP9lEVDlfy7cRIFl/l9k6tnYfOi8/HVyqO3ESyV0hDV/g
   DSWNAPoegDGoBwXRjXxxAYub+8ezqQ1e+qi3mgBL8JWtWxBqiXtL/yj95
   qcSFhDT9Iv2l1t/YUnUnwogzeIYAJhFrjDLft1xcD0dfGIGnewbRino2Q
   X2/MZ4TXX0fmAtp11LhRuNX2Fhom+s43ufdaluKLC6E0EA+Afj1AAYyqH
   Q==;
X-CSE-ConnectionGUID: whRudyhxQMyHMO+Og4WV/g==
X-CSE-MsgGUID: J5hFNN1QT8yk59Hy3Mg2FA==
Received: from mail-il1-f198.google.com ([209.85.166.198])
  by smtpmx6.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 28 Aug 2024 23:40:43 -0700
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39d244820edso2827045ab.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 23:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1724913643; x=1725518443; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7Woi7JNzcaZdz+JzUvTxVrIsbGp6n0bVNCKiGYFoIsY=;
        b=XCKnESI5h1V0CtPasvZBHmHgTwvy32IkyuRA8v3lAzrcuJwu3CPKe9AwfP1g2Fa0Am
         YfKZfxO1DoymWmnlZmMMjmR//UFTTIhg7CCCaeQimHwZLIEGrLpP2t4fpTMc4AcVGLdU
         j1CViP53fj1rYstKTx3ufJqvYTJZn0IYN0Zz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724913643; x=1725518443;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Woi7JNzcaZdz+JzUvTxVrIsbGp6n0bVNCKiGYFoIsY=;
        b=myqzQIwBjmZVUZ9K2yfc1t5chx7HYkZ+aPuG+hZ22gWvOUIf6fgE7nYDJqzyTno2yt
         vc4+Xvsii/A6p0R4X8ThVMCCC+drMlpmz08zejJFJ3ud3HEMnxG3Hy7/oVVXEdno8e/x
         od/x9tkSS/cLEVqppHOPsnwn4Rgmowk1Jhd3kiBFUaYYMz+orbpu5hiv+3pAhoq9XCUY
         JrwreqPLc/5doAypj20ctBoH8fYY7raGITJSrMQQonmlO7+OR2GnVVl9M3QmrTYkqmBG
         PW+xdnJLnm9Fcl4C0xQsM4cBZrGrdhClrXedEBe9UunS6GGa4TizblmchE49CAPpUZIM
         I+Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWzNO8xraobfmBKJHiLdy4CiR0Z4oidOLI3/wNHiKXotV5pv8vtJsAYCtxAlmK9GXmz649Ga3M7Nhbg@vger.kernel.org
X-Gm-Message-State: AOJu0YyvA9QyYDGQSsXFn0DJMVLN3i6qYw13Op3aSTSkC7U78bqrBtkm
	8SaI0z475NkL/Dxz19eaE1fBJh8Ww/GTlE6NZDnHI5czu1RG8hTVX9cwD5Plrmpf+smvjhK0gzq
	DyprNh538aodsFYvSB4nJHHGxtb+tZZnU6HDtrAc1xhehBXQFFwzJVkYoMfo350p+ZfBQwVJ9pI
	8XgZov+gFqJxDdxEE7D4k6sXiqa/pvN0SNImM=
X-Received: by 2002:a05:6e02:180b:b0:39d:35f2:6ed7 with SMTP id e9e14a558f8ab-39f378904a0mr24740545ab.27.1724913642660;
        Wed, 28 Aug 2024 23:40:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+cH6Wvwdutp93MplkI8A+PzbIuWsYpTxwNgTtIrme3YIex0n9pl9NRAhHfixVDPiTHV9c1eRS8IGL8hk8H8w=
X-Received: by 2002:a05:6e02:180b:b0:39d:35f2:6ed7 with SMTP id
 e9e14a558f8ab-39f378904a0mr24740475ab.27.1724913642331; Wed, 28 Aug 2024
 23:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Juefei Pu <juefei.pu@email.ucr.edu>
Date: Wed, 28 Aug 2024 23:40:31 -0700
Message-ID: <CANikGpfU7oa_P3MzYjh2B4L=FnsDamhaiaNgQYB_BgUAE9JzRg@mail.gmail.com>
Subject: BUG: general protection fault in batadv_iv_send_outstanding_bat_ogm_packet
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yu Hao <yhao016@ucr.edu>
Content-Type: text/plain; charset="UTF-8"

Hello,
We found the following issue using syzkaller on Linux v6.10.
The PoC generated by Syzkaller can cause the kernel to report memory
corruption related errors.
The C reproducer:
https://gist.github.com/TomAPU/3079772ea493ad008f9a837e63be87bb
kernel config:
https://gist.github.com/TomAPU/64f5db0fe976a3e94a6dd2b621887cdd

It seems that the task corrupted is `kworker`, not `syz-executor`. It
seems that there exists a bug in `/dev/sg0`, allowing a program to
tamper the memory without being caught by KASAN.

The report is below:

Syzkaller hit 'general protection fault in
batadv_iv_send_outstanding_bat_ogm_packet' bug.

veth1_vlan: left promiscuous mode
veth0_vlan: left promiscuous mode
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
Oops: general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 40 Comm: kworker/u4:3 Not tainted 6.10.0 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_aggr_packet net/batman-adv/bat_iv_ogm.c:325 [inline]
RIP: 0010:batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:352 [inline]
RIP: 0010:batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
RIP: 0010:batadv_iv_send_outstanding_bat_ogm_packet+0x2bd/0x800
net/batman-adv/bat_iv_ogm.c:1700
Code: 3c 41 be 18 00 00 00 31 c0 48 89 44 24 50 31 ed 48 89 5c 24 58
49 8d 55 16 49 89 d4 49 c1 ec 03 48 b8 00 00 00 00 00 fc ff df <41> 0f
b6 04 04 84 c0 48 89 54 24 08 0f 85 b9 01 00 00 0f b7 02 66
RSP: 0018:ffffc900008bfb30 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff88801ec1083c RCX: dffffc0000000000
RDX: 0000000000000016 RSI: 0000000000000018 RDI: 0000000000000018
RBP: 0000000000000000 R08: ffffffff8abf0ffc R09: 1ffff11006e56994
R10: dffffc0000000000 R11: ffffed1006e56995 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000018 R15: 0000000000000018
FS:  0000000000000000(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563601fc9418 CR3: 000000000d932000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 process_one_work kernel/workqueue.c:3248 [inline]
 process_scheduled_works+0x977/0x1410 kernel/workqueue.c:3329
 worker_thread+0xaa0/0x1020 kernel/workqueue.c:3409
 kthread+0x2eb/0x380 kernel/kthread.c:389
 ret_from_fork+0x49/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:batadv_iv_ogm_aggr_packet net/batman-adv/bat_iv_ogm.c:325 [inline]
RIP: 0010:batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:352 [inline]
RIP: 0010:batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
RIP: 0010:batadv_iv_send_outstanding_bat_ogm_packet+0x2bd/0x800
net/batman-adv/bat_iv_ogm.c:1700
Code: 3c 41 be 18 00 00 00 31 c0 48 89 44 24 50 31 ed 48 89 5c 24 58
49 8d 55 16 49 89 d4 49 c1 ec 03 48 b8 00 00 00 00 00 fc ff df <41> 0f
b6 04 04 84 c0 48 89 54 24 08 0f 85 b9 01 00 00 0f b7 02 66
RSP: 0018:ffffc900008bfb30 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff88801ec1083c RCX: dffffc0000000000
RDX: 0000000000000016 RSI: 0000000000000018 RDI: 0000000000000018
RBP: 0000000000000000 R08: ffffffff8abf0ffc R09: 1ffff11006e56994
R10: dffffc0000000000 R11: ffffed1006e56995 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000018 R15: 0000000000000018
FS:  0000000000000000(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563601fc9418 CR3: 00000000203c0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 3c 41                 cmp    $0x41,%al
   2: be 18 00 00 00       mov    $0x18,%esi
   7: 31 c0                 xor    %eax,%eax
   9: 48 89 44 24 50       mov    %rax,0x50(%rsp)
   e: 31 ed                 xor    %ebp,%ebp
  10: 48 89 5c 24 58       mov    %rbx,0x58(%rsp)
  15: 49 8d 55 16           lea    0x16(%r13),%rdx
  19: 49 89 d4             mov    %rdx,%r12
  1c: 49 c1 ec 03           shr    $0x3,%r12
  20: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
  27: fc ff df
* 2a: 41 0f b6 04 04       movzbl (%r12,%rax,1),%eax <-- trapping instruction
  2f: 84 c0                 test   %al,%al
  31: 48 89 54 24 08       mov    %rdx,0x8(%rsp)
  36: 0f 85 b9 01 00 00     jne    0x1f5
  3c: 0f b7 02             movzwl (%rdx),%eax
  3f: 66                   data16
