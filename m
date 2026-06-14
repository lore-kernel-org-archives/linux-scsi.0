Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3121E1C11
	for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 22:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781474566; cv=none; b=mu6Xar4FgR/T0Y2/fu9+b3pGUwvOVCkyIU1fban7mos6NDT0hymKRhe1fL6YYAFLb40ENndapC8v8yU+BmSRI/7M8H+vql1jfOfJPxZ6wfYASjAQqp+5NI0QbmMzYjhi15R9bKHSgC0mu0Jh2RcbPCzq8U6CPNG/Cl+ik3T+6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781474566; c=relaxed/simple;
	bh=nLIX5X43/8FIrNBR9qYbjAZYRY1X8Bo8AYb4vUeLGpA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MB/SJ5Jq/E+nRrwHX3Er8YUw9E0OAju860jCK0xZi0He/7EXnLt68cl3yUoUs/6s87iuOp+p77VqcwkLQ7Ji1oP+dGulwit9DIWidZ7azYVCOSvCwqo2MJ3c36Lk8H8X5CijwQsl8F+OtMHuQy1t1ARj3CaE41Eqb8rAiQsC6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s+8jRsYU; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s+8jRsYU"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7dc67a5e102so25668547b3.1
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 15:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781474562; x=1782079362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hcAFFbPAP2Q2h6idwJ3ZC7xWIHvpapDwn0WSEWg/X2Y=;
        b=s+8jRsYUKFnJ7odxPkOTPyEk0AbuUecWuQmbhfY7BqMb6rJo/eEJ9u34d+ySjChdq4
         iWchC24+rpmJFFFz1cgdAAeoccAS20kV0enerkY/KKSda+QJ/2psF1MS3FbQzOBy7DgL
         Ok3FlyzQl5YJKQDYas865D+Cc3HMUt8N7eFgNpooSH2IjnJZmR0zLeF7Wk3j1Qv5OkJY
         R3r4ywbfejU/ULCX2+xxRRdTwXs6Ot36NFuN/peKiyV5evwCFRjFjn+BwpArWGUJGKc4
         SbcLctBeO5vogxz8842TG9eBx1mzpiVFtwvEm7HRbah2ZzRAmUvxGgba3iNekQlsHgQs
         HGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781474562; x=1782079362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcAFFbPAP2Q2h6idwJ3ZC7xWIHvpapDwn0WSEWg/X2Y=;
        b=NT7rhj5wl3By8DTKgJvzSTLD/wQswj/sLJz2Tgy/t5vtSdPSZkbnuQBMgnlZccjiIe
         UhhdlwHt0DtaVxngJLO0udsCnG9vObH51UFeva9Z+kwFVqgVSmD3bu+/QxnnuzhgzZ7E
         /BBgorRfxvR+JuXiqK9l7PXhb/t7QS23bV9AqME69/T4TTUY2EPv61B/hkM2Rk/9SmHU
         90S4bXVfCJnNkF9+tyryluYQGQa81ZmHZaHdeBqaFw9eEw24nNCLEurKSkK4y/Y86uRW
         w2M5Rl+AZX8dVfhQ+bX5T1On0wmJ/hmiCN271CHlWTbmfxLDVk3UaEy7whnK1XiXe2Gp
         2noA==
X-Forwarded-Encrypted: i=1; AFNElJ8JT9kaRAs74r15jqhsoJg0E1W5ahBkSbIzDNMGkXAR8Pk3OANc4jL7APd1Hfyr8FOUct0rqAvR+LSn@vger.kernel.org
X-Gm-Message-State: AOJu0YxZnRUjJ15gxDzPCm0bp3CYGkGc2OrwkQoHjDR9UP8cOT1Fl1WU
	xoS99Jp5OYsZkd5/bKGrRVTysqd2Mk8RYnDlZOxkaJBUQCxTaDyTWIm7
X-Gm-Gg: Acq92OFbABVNGvPI71AhZ1fQaDdPKUrUVWwGdTChKK18yuVxieDIeJqgS8SS0rj6tga
	DPR52wfkf+wSrtC861uwb8uzwzOUrLZFE+XKzhv8PPXjORdTvaHLd43yVtHtWeeHG4yjmZyMUs4
	AqPt/+EkkgHYCbDfHBDt1qjKwF+Zxlh8rEecgTdEGa1q8iYnyhzMyTeBBzDcJQSjCDcuB2DR4qe
	yaW8kXHG+43CRhm1Ewbtpe6G2DVKXJCwOsAkBgNZa2VfNgZmSxwlZcFXhXn0LQArXWo7n3M1sTF
	1U8Zb0OTS+o1iTaxNKrkclCvFXM3qeuTI/kbo/f4DN9kQ9AHpHIH36GX5EbhmroOtPjpjZKKjYZ
	4qHgQB1kFJqYPM5vGZrAsjr3Jb3zkjGQvNNBqg0KkN+orLDIGSbSqTZOEPB9SFUaXzvzSRhmR22
	ywq2AmeVbOlwff0HFG+9llAF2/l+cja5eZudvAlp1uNEParL6IZ6y1hU/ZwvQdKJ353o3413A1Q
	g==
X-Received: by 2002:a05:690c:998e:b0:7c0:56f:5b70 with SMTP id 00721157ae682-7f7bcf107c3mr112549197b3.29.1781474562359;
        Sun, 14 Jun 2026 15:02:42 -0700 (PDT)
Received: from localhost.localdomain ([2607:fb91:14e1:4204:4d87:aacf:f5f1:c2dd])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d304577accsm90901256d6.25.2026.06.14.15.02.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Jun 2026 15:02:42 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] KASAN: slab-use-after-free in is_free_buddy_page from megaraid_sas
Date: Sun, 14 Jun 2026 18:02:30 -0400
Message-ID: <178144969601.60470.16745418177798279969@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kernel Maintainers,

I hit the following report while testing current upstream kernel:

KASAN: slab-use-after-free in is_free_buddy_page from megaraid_sas

I reproduced this on commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7 (May 25 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/e04467b211a84fbdea66596b50fac4bc

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[  114.160510][ T8384] BUG: KASAN: slab-use-after-free in is_free_buddy_page (include/linux/page-flags.h:993 mm/page_alloc.c:7426)
[  114.161332][ T8384] Read of size 4 at addr ffff8881263a0030 by task repro_megasas/8384
[  114.162155][ T8384]
[  114.162413][ T8384] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  114.162417][ T8384] Call Trace:
[  114.162420][ T8384]  <TASK>
[  114.162422][ T8384]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[  114.162429][ T8384]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[  114.162446][ T8384]  kasan_report (mm/kasan/report.c:595)
[  114.162455][ T8384]  is_free_buddy_page (include/linux/page-flags.h:993 mm/page_alloc.c:7426)
[  114.162459][ T8384]  set_ps_flags (mm/util.c:1294)
[  114.162464][ T8384]  snapshot_page (mm/util.c:1333)
[  114.162469][ T8384]  dump_page (mm/debug.c:134 mm/debug.c:146)
[  114.162517][ T8384]  __get_pfnblock_flags_mask (mm/page_alloc.c:357 mm/page_alloc.c:384)
[  114.162521][ T8384]  get_pfnblock_migratetype (mm/page_alloc.c:432)
[  114.162529][ T8384]  dump_page (mm/debug.c:115 mm/debug.c:138 mm/debug.c:146)
[  114.162548][ T8384]  ___free_pages (include/linux/mm.h:1766 mm/page_alloc.c:5306)
[  114.162552][ T8384]  megasas_mgmt_fw_ioctl (drivers/scsi/megaraid/megaraid_sas_base.c:?)
[  114.162579][ T8384]  megasas_mgmt_ioctl_fw (drivers/scsi/megaraid/megaraid_sas_base.c:8570)
[  114.162583][ T8384]  megasas_mgmt_ioctl (drivers/scsi/megaraid/megaraid_sas_base.c:8628)
[  114.162586][ T8384]  __se_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:597 fs/ioctl.c:583)
[  114.162591][ T8384]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[  114.162596][ T8384]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[  114.162600][ T8384] RIP: 0033:0x7fd4bdfc4237
[  114.162604][ T8384] Code: 00 00 00 48 8b 05 59 cc 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 29 cc 0d 00 f7 d8 64 89 01 48
[  114.162607][ T8384] RSP: 002b:00007fd4ba6c6d28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  114.162612][ T8384] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd4bdfc4237
[  114.162615][ T8384] RDX: 00007fd4ba6c6d30 RSI: 00000000c1944d01 RDI: 000000000000000a
[  114.162618][ T8384] RBP: 00007fd4ba6c6d30 R08: 0000000000000000 R09: 00007fd4ba6c8700
[  114.162619][ T8384] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
[  114.162621][ T8384] R13: 0101000000001000 R14: 0000000100000028 R15: 0000000000802000
[  114.162626][ T8384]  </TASK>
[  114.162627][ T8384]
[  114.166559][ T8384] Freed by task 8342 on cpu 0 at 70.147016s:
[  114.167592][ T8384]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[  114.167598][ T8384]  kasan_save_free_info (mm/kasan/generic.c:584)
[  114.167602][ T8384]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[  114.167606][ T8384]  kfree (include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6251 mm/slub.c:6566)
[  114.167611][ T8384]  tomoyo_realpath_from_path (security/tomoyo/realpath.c:286)
[  114.167618][ T8384]  tomoyo_check_open_permission (security/tomoyo/file.c:151 security/tomoyo/file.c:776)
[  114.171898][ T8384]  security_file_open (security/security.c:2739)
[  114.172838][ T8384]  do_dentry_open (fs/open.c:924)
[  114.173900][ T8384]  vfs_open (fs/open.c:1079)
[  114.173905][ T8384]  path_openat (fs/namei.c:4699 fs/namei.c:4858)
[  114.173908][ T8384]  do_file_open (fs/namei.c:4887)
[  114.174796][ T8384]  do_sys_openat2 (fs/open.c:1364)
[  114.174801][ T8384]  __x64_sys_openat (fs/open.c:1370 fs/open.c:1386 fs/open.c:1381 fs/open.c:1381)
[  114.179693][ T8384]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[  114.180735][ T8384]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[  114.180739][ T8384]
[  114.180740][ T8384] The buggy address belongs to the object at ffff8881263a0000
[  114.180740][ T8384]  which belongs to the cache kmalloc-4k of size 4096
[  114.180743][ T8384] The buggy address is located 48 bytes inside of
[  114.180743][ T8384]  freed 4096-byte region [ffff8881263a0000, ffff8881263a1000)
[  114.188131][ T8384]


Best,
Shuangpeng
