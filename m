Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFCE2F90C5
	for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781458315; cv=none; b=fSFk2gkQRExr64vMf+4T2wlKxkDxlkGTn1QGSY5lCQ3Bvqb8UXabd8h35x8u9L6FaAbAiFNMrN68ZdQP7x9qkDaKH9uDc7TzeIMXsaDP2A5zyUMzSw5ZjjzeLSQCbg3kOlCZNgI5QHN+U1L/JtGESgUkUXwz3lbLOb8MjdB7DJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781458315; c=relaxed/simple;
	bh=Rf47W4MrbK3B7Rb/H6FzPGQSOhTwfxvwu3rNm+WbZ9Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tlzakHSvEsXltB8P0MxL2fApPamTItXBzvNYIh0koRmIliYJS7N8H35qG6Qf370kN1N3y5JpZqEOGq5HRWLegpi4oMPxTT/xroGR7dbQ9r/4vpwernSI7qc4tC0MHBNLT9pE2e8HHbBpy1mGaGq6JAVoEHtRsLAD6/SlahKWZio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnFXv/kO; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnFXv/kO"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51788280e71so30608041cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 10:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781458311; x=1782063111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=M6rV5OO0hDV4rs1k1n6A/5dI2OOx9MdpsSLPmgeV6P4=;
        b=nnFXv/kOBm2Ymrcgtmhi30PWfR342ll1ufxW6YfQ50Nh7yZyuI6RSgKot0EEbI/r0/
         BDJiGqxojbFKUOpj4O2ecwMHxgzYDbAiAFFdXFv/VZBPONmYWNjJnkBvBz/l5WsUipZR
         zvCkFqO/kzW1M1xw1dojugLnL2Y7FiKWzLt/2cAgG7t8vRFR2keDou2hlW6BiazusRNB
         SS17KIuxCaeH2YY8PXVQnvbz4tJlgAclY8lBB1rQiTFw+pDTtV8QZzzMtk63YxO7NuWr
         6HFLT0zv8O+qWGwg8dUr8QOOhKVtiZZGXCofgOm4POBgSIMjgyglrpw92tKMma5LMzdz
         86Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781458311; x=1782063111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6rV5OO0hDV4rs1k1n6A/5dI2OOx9MdpsSLPmgeV6P4=;
        b=YsfdXN73HJ63wfAKWHHXR2GOB6HEb0kRBzLnbXbh3pKNgjD8ZteX7FHlGP2VGQ7hYu
         bJTLMrIJFCVUMOGboYaCm+bDnlLyMhLU3ObuOehSQlmTS/uXJmjxhs4opMWi9Lg/xHmO
         HIoL/JD0B/bFWQ0g5FJ7n+lvTjCBwOkE3Fka5UhNTBRiQ8IV9ymUjcRNz7ivFx2Iicej
         x3bT9CxlL5cvEKZH8t7RHhf3uRgApErdkxY+f0bXGOvf45cZCjTjIHgPZm9mSAlVrpga
         +YrWYuZmwTwVcB2VwSwoZ1U52Vmb5CzqHW2RYUBHU7a1kfTeBlziRetoh+6jHVpOe2SF
         sIpA==
X-Forwarded-Encrypted: i=1; AFNElJ9FHQcHZ3Bre/cPlcdHwIU8TG++mqoEGXPcYgkIdQkFn2vShGD+lAIVmtUkuvUPPsdixFpMzlP6KeGa@vger.kernel.org
X-Gm-Message-State: AOJu0YyCmAnMdwVcMgOneqQnzaxGhdfKYt20XJu2wQsMpcpCWmRkHTLn
	S+5gvvkinvzCUhNQWAzLobTn8/R7PYmOKmm2SyuedsMGXHyzk84iXRwp
X-Gm-Gg: Acq92OHqGbjPDK+9u1mLKFBuYl5k2+Lzy9bfb+U1g5kNBNN/NApNTxho3EDg/XAbvNB
	MpDmwJsi/TAv9WBId8ki/OyKXaVrc11kolgnc3rb8/yvS+JlqDcikPQefmnkvLWc3gR6M22JjnY
	vPgGxOfog4IBHZ5Atqk7KkU21fTWdIVjCt36sjTH8m5ASCmayIC7x0XXSgvIHEraAyJ1+XGymIX
	67HrBwa9GmnhzisX/T3pv6H8W/u42tDN9Opj+sFxK4MrtFYNXgCjqpWdtvLz2ZaAHBPjvhLgLKR
	eBfv/uS3Gj7KQiZG6G3/kjhCvOSwg2qi7r4nIiJ6uCQehtYgvlUIsEqMiAx06Js8svSIB6TrE1k
	7XStpQOClY3cVeY7+eOxwABfZsPZIUtiJ5AKtyGqYTtatDuXbaO4pOhfHk7siQJb1NUYYfo5QVS
	teMYyeZmpVwAoudasdVt2zIQRUCIno4se2VEZhtPHFLbv7AFw0Za6plg6V/+VrKuBnF1auMCue
X-Received: by 2002:ac8:59c2:0:b0:517:7a6b:52ca with SMTP id d75a77b69052e-517fe4d7c8emr175783781cf.33.1781458311453;
        Sun, 14 Jun 2026 10:31:51 -0700 (PDT)
Received: from localhost.localdomain ([2607:fb90:a8e7:8c2b:20e1:3889:792:e164])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb63e594sm79780501cf.8.2026.06.14.10.31.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Jun 2026 10:31:51 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] KASAN: slab-use-after-free in __mptctl_ioctl
Date: Sun, 14 Jun 2026 13:31:49 -0400
Message-ID: <178144969600.60470.16720377825136893393@gmail.com>
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

KASAN: slab-use-after-free in __mptctl_ioctl

on commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7 (May 25 2026)

To help trigger the bug more reliably, we applied a minimal diagnostic patch
that only adds delays and print statements.

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/f6aa77a9c6e552b7ff7e79b39286ed45

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   63.990467][ T8321] BUG: KASAN: slab-use-after-free in __mptctl_ioctl (drivers/message/fusion/mptctl.c:1274 drivers/message/fusion/mptctl.c:656)
[   63.992791][ T8321] Read of size 1 at addr ffff888119b82080 by task mptctl_iocinfo_/8321
[   63.994574][ T8321]
[   63.994953][ T8321] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   63.994958][ T8321] Call Trace:
[   63.994963][ T8321]  <TASK>
[   63.994966][ T8321]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   63.994977][ T8321]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   63.995002][ T8321]  kasan_report (mm/kasan/report.c:595)
[   63.995034][ T8321]  __mptctl_ioctl (drivers/message/fusion/mptctl.c:1274 drivers/message/fusion/mptctl.c:656)
[   63.995102][ T8321]  mptctl_ioctl (drivers/message/fusion/mptctl.c:700)
[   63.995108][ T8321]  __se_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:597 fs/ioctl.c:583)
[   63.995112][ T8321]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   63.995122][ T8321]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   63.995128][ T8321] RIP: 0033:0x7ff74f883237
[   63.995135][ T8321] Code: 00 00 00 48 8b 05 59 cc 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 29 cc 0d 00 f7 d8 64 89 01 48
[   63.995141][ T8321] RSP: 002b:00007ff74f78dd68 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[   63.995150][ T8321] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff74f883237
[   63.995154][ T8321] RDX: 00007ff74f78de60 RSI: 00000000c05c6d11 RDI: 0000000000000003
[   63.995158][ T8321] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007ff74f78e700
[   63.995161][ T8321] R10: fffffffffffff5ea R11: 0000000000000202 R12: 00007ff74f78de60
[   63.995164][ T8321] R13: 0000000000000020 R14: 000000006a2b030a R15: 0000000000000000
[   63.995171][ T8321]  </TASK>
[   63.995173][ T8321]
[   64.015739][ T8321] Freed by task 8303 on cpu 0 at 62.780944s:
[   64.016310][ T8321]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[   64.016757][ T8321]  kasan_save_free_info (mm/kasan/generic.c:584)
[   64.017239][ T8321]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[   64.017692][ T8321]  kfree (include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6251 mm/slub.c:6566)
[   64.018075][ T8321]  mpt_detach (drivers/message/fusion/mptbase.c:2849 drivers/message/fusion/mptbase.c:2125)
[   64.018507][ T8321]  pci_device_remove (drivers/pci/pci-driver.c:512)
[   64.018969][ T8321]  device_release_driver_internal (drivers/base/dd.c:619 drivers/base/dd.c:1352 drivers/base/dd.c:1375)
[   64.019552][ T8321]  unbind_store (drivers/base/bus.c:244)
[   64.019982][ T8321]  kernfs_fop_write_iter (fs/kernfs/file.c:352)
[   64.020487][ T8321]  vfs_write (fs/read_write.c:595 fs/read_write.c:688)
[   64.020888][ T8321]  ksys_write (fs/read_write.c:740)
[   64.021307][ T8321]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   64.021745][ T8321]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   64.022305][ T8321]
[   64.022533][ T8321] The buggy address belongs to the object at ffff888119b82000
[   64.022533][ T8321]  which belongs to the cache kmalloc-4k of size 4096
[   64.023834][ T8321] The buggy address is located 128 bytes inside of
[   64.023834][ T8321]  freed 4096-byte region [ffff888119b82000, ffff888119b83000)
[   64.025137][ T8321]


Best,
Shuangpeng
