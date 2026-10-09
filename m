Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219F233946
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506144; cv=none; b=IWccIg3szgnZWbO7cTJqesuGeREw/S9IezDuiEYOp6DMPIS4HDZ7ja0K6KhA/iiRflwbqV9+KGzkj72ESC0aBuKKxXzIzYWYs1UHSEQJSkCTnUDadwsoEKigmkYwusTNZmhHzdqQTwpn3RyfRV7phoCpWedt7o8voUhTapgGdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506144; c=relaxed/simple;
	bh=2UfdJs69sO/fEFk4xEcV6sqiZJ4cwTu93x1gV3HZJK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tyxsgZ2j5ydTSY0xKHd91Mt9GhWyVXR151rSzsmjKg9vyW3n9Q9wFx7sZAUVqHgmwx/0uFnkIMzNjPtZR+lrY0ClBox/Gu8+9D2TBOt0yEUZXYMK2vBN9DjuFaWn+M/Ch9ipcqrKT2erQR39OqXXCUHI8VwBKpMEivsEf2a9gCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/lRtbNc; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/lRtbNc"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7c8b520c640so92105137.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 17:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506140; x=1792110940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x11PvIESSkGOPE/y8CqSvSINYIoP3r5FMwi0SVUBQUc=;
        b=e/lRtbNc2hQeqtz+U1EUVBRwiRWgCoEBQKruPJR5Ov8L2Dzy0hlvlsh6Q+2tDD1qMb
         /EVnWuXBhJGRpEmpUGO23cuYIVmh0XUD4sO3XAB3XpthQ72y8erz+8SjxnZ2mm9hmMkR
         TC15wn2oz95R+liYzLerl1EKiNi+yBkEEvB0kqAIVzZ22aWx4PJR0/hsbXY99FOqQrS3
         Ru6f2FFzmvWpYZ5qorqhek/0Mp3EtJMmrH5zdq0x1Q5cgReNy4ZvWDIso/Hz2YJvanW1
         J7at/JN9OvVFI+RFud/XmqI+l7xzqszlA31zxLEoAh4J7TZ7NvGwc+BdbZM4zmIoIKRp
         JgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506140; x=1792110940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x11PvIESSkGOPE/y8CqSvSINYIoP3r5FMwi0SVUBQUc=;
        b=CQfD0LDIt/gRnunegDJE0ar7Kyoqy+nwbk4ZBsziqywZO9I/NcMCWgGGCH7L+V/YTb
         cGJOvTqXsuL9pgdxl4gFuZuxGXPxMP1YrEGxI6SYB6FJx3H51fbnBIcLDHDwnABcYkGl
         NoSaU19FbhTp89VrqWglKW3oUyjlKAnlSqpHPszO+1YDdRSOR1MJOBFATnfv5dJ6940r
         ivjJ6QZLVOh587DgnGULDvITRSmlfYj/sEiN/DyNUGEfVw3Kni6L4Jsm38WGV1TdPQxn
         Fmfmzrc2fxrIFp/GcGKdjbtka42QKwEM3V/VK9YHDkAtGFizOh15y2bCXWYTuIPPU5Bw
         rfkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxmEQZvPRQkfZg4IIxYxGzMZ0fKdikYpHzW2niHRGGnrU5uTk4KswMo/Tzy2ZnXaWN5B3Vtq+55BF9j@vger.kernel.org
X-Gm-Message-State: AFq9FYL0ZtcKMr9MpkDgUdBL0gFDhR6GPf8fQ4obLPQgAOOZ2bB1byp7
	xbAKb8Y7ofwWfTJafdrnlnxNjWTRcbPgixEQtmDKejanD/oFXc2FMzWt
X-Gm-Gg: AYBFou3JVEYBE7Nbbcst50g/WrhaCbnCXY1U2/GH9R8PwzKIciAmMQHm/aZzdOTNys+
	1AgpgW46ZoDVSzGFclo4051cXgZP+gL9IbjXUGuBstVLQR31p5sNIzICP2lvhJ9XiNTLFk32ZmR
	1otCvZMqOperBT0FI209RigRon/Z4aKtG+HOLRon2fM2q5YcRIRTL9fkwfalhbC53Lp09oDV/oa
	/Sg9jO7BkSFrOs0N+PGJiaEf8vJFCeOgiFSVBVEkkwsDXYN+Tf9KnJd5W1aA2wIgfkahxosYKIt
	3t/Qekj6XM/LL7dxlmQBEIAVCV24f6U+pbwFj+KntlE6uEnQWWtCZ3+23UVJ0Bd2GIeUHMFpHW6
	KdZKx6xcYm8yv81DD/DDtPjFV4Z4z7EubUfVvCNeA6kZjdYqGyHvGalVwWxPEqgiYHxNzFxDZki
	y9fRzKu+CwwLFzYXuqvgyVuNADvIXTplGWbqf/dIF46b4PTpAYBLrTX+toT86Qx8MWHC0OXSB2r
	5n+doG4tbYPz2pCpYOP+gIDv2Lmopve6JkoX3awtO9U3VhIe5uD1MsEyECqfNQHPZI2RCLjJZIv
	UD5fN+8SSJ8h0Ak0qSc99xw30ugFrA==
X-Received: by 2002:a05:6102:a4d:b0:7c3:83a9:edc9 with SMTP id ada2fe7eead31-7cb36485419mr123513137.1.1791506140555;
        Thu, 08 Oct 2026 17:35:40 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:40 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 0/4] scsi: target: rd: Fix oversized ramdisk allocations
Date: Thu,  8 Oct 2026 20:35:30 -0400
Message-ID: <20261009003537.62265-1-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

A ramdisk page count set through configfs (rd_pages=) has no upper bound.
syzbot found that a large value makes rd_build_device_space() attempt a
single sg table array allocation above the page allocator's maximum
order, which triggers a WARNING. Patch 1 rejects page counts that
exceed system RAM and allocates the array with kvzalloc so that valid
large ramdisks also work.

A page count close to system RAM still passes that check, and the
backing pages are allocated with GFP_KERNEL, which invokes the OOM
killer instead of failing. On a 1 GiB VM, rd_pages=250000 panics the
system with "System is deadlocked on memory". Patch 3 allocates the
backing pages with __GFP_RETRY_MAYFAIL so that enabling such a device
fails with -ENOMEM instead.

That makes the failure path in rd_build_prot_space() reachable, and it
leaks the partially allocated protection space when pi_prot_type is
written again. Patch 2 fixes that first, so that patch 3 does not
introduce a leak.

Patch 4 fixes an older bug in the same function: the protection space
size is computed in 32 bits and wraps for ramdisks of 2 TiB and larger,
which leaves the protection sg tables too small.

Tested on an arm64 QEMU VM with 1 GiB RAM, with the syzbot reproducer,
normal and NULLIO ramdisks, DIF protection space, device removal, and
rd_pages=250000. The leak was checked with kmemleak by making
pi_prot_type=1 fail under memory pressure and then writing it again:
two unreferenced objects from rd_init_prot() are reported without
patch 2, none with it. I could not test the 2 TiB case of patch 4.

pi_prot_type_store() does not serialize concurrent writes, so two
writers can still race in rd_build_prot_space() and
rd_release_prot_space(). That was already the case before this series
and is not addressed here.

Changes in v4:
- Patch 2: build the protection space in local variables and store it
  in rd_dev only on success, so that the error path cannot free an
  array installed by a concurrent pi_prot_type write (Sashiko AI
  review).
- New patch 4 to compute the protection space size in 64 bits
  (Sashiko AI review).

Changes in v3:
- New patch 2 to release the protection space when its allocation
  fails (Sashiko AI review).

Changes in v2:
- Allocate the sg table arrays with kvzalloc_objs() so that ramdisks
  larger than 512 GiB do not hit the same WARNING (Sashiko AI review).
- New patch to avoid the OOM killer when the backing pages cannot be
  allocated (Sashiko AI review).

v3: https://lore.kernel.org/all/20261008235411.56641-1-sanan.hasanou@gmail.com/
v2: https://lore.kernel.org/all/20261008223712.49827-1-sanan.hasanou@gmail.com/
v1: https://lore.kernel.org/all/20261008215709.46014-1-sanan.hasanou@gmail.com/

Sanan Hasanov (4):
  scsi: target: rd: Fix oversized sg table array allocation
  scsi: target: rd: Release protection space on allocation failure
  scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
  scsi: target: rd: Avoid 32-bit overflow in protection space size

 drivers/target/target_core_rd.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)


base-commit: 6c377d19d4a5116d9bec5203aa3c6c11523e7898
-- 
2.48.1

