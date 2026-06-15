Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914B140D576
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 02:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781490472; cv=none; b=jgIrbyorq7KTb3dLPqmwSzOfHlMByji4GBt1L9rDBcLTLF6CIfRfTXoAis5p/QifQVc2B2tN6l+CKIQnMsunCy2PIPzwdeFwSS8anQGEVTydJR9aR7M+mFcc2/P8A6oB2NTZLQbbF+Zv2z02bGv+i0Y3rHQEBzc2KTlJVP9GqQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781490472; c=relaxed/simple;
	bh=kKSaQO8gNVspzPmkbXnYyZtkl7T31dZR0VUBnwCP27M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hAVTDO2peKQPU52u1nkYDF7g9JjTJoMus5noH2tr9x7DRK4bpHcO0bRajLmRAIzV2HCW5/dk1K4ajkZIchUghnERoR7uJnSjDI99Svby6UbHCV5fyZ0kaj7L5T6PVBnXCt1NquyL+rgzNWExaISuk1MgRdCS1BitERCgj6hafHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmWzZAim; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmWzZAim"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9159da9bba5so203113185a.1
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2026 19:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781490470; x=1782095270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBmRQVmPIG21njKWSCKU8soziCiefwmEo3kQcto0EfE=;
        b=fmWzZAimHlBWIkcA8a1j36ncrVck2nHIY5eUvi3D7Fq3jHcMXPI3sp01evn1RMMg+H
         GrQZT3BcHB3xmsB2408FwcEeLHIaV3uIE7cB6S3jTyQqeOYv8gEpdw2/h6wlr+6SLcOh
         CV2ZLY6HCr8ciN8L4vwPskzIjJnOzlLplCEinbiBqx0IaIUMtRxEK99xDwjIYGNsibjZ
         VURW4Lpbpv4mrTHBmcGNtPKzPtasgNefEws9AwBaZsQbYzjrKPrO32IvlUcjqXV8Spuj
         d5d75+B1yGf0NZcHMISwos405amhiD94x1Lm2iNKtLD3fJnH92e3X7TaYlp/oXd6AYNX
         xVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781490470; x=1782095270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aBmRQVmPIG21njKWSCKU8soziCiefwmEo3kQcto0EfE=;
        b=Yg9qGsGkZWzfWsu0HjKm+MW1PCknpX9KY64NNGrF7I+uyPMP4KY7QkcaskJ2sY20Wg
         ci6qmoFCR458iw9f9sWMIM0kHk2YNweWbM9PeLeiPS+ShkOMj0SE4idvsuU/S0pQRqJP
         +dAb7q5aZhWPc/YgsWYzH8HO3ceqUplkjhSqWE3TG5J3IQ3StH9QRPdRpkmfiLpYeTE2
         0gOwMDqgtXcvNhOsyBtvPauW3Q+HadaTXsEguiW34/XObHgqT8Jk/UO9IS0uPNoqRW77
         l1PcokKMUXRSYEXWwtU2kvlFKX74wUWv/rix/SwhGYexFajPg5hcZ/3c1DqhjRneTi/Z
         YmrQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qbl3vp9yqgwhMZrOk9CP2+dg5q3V1xVJNSc+9K2xNrz8xRlsmzdn1Ifl6JhJi/XJt3UWkNjXqvEUL@vger.kernel.org
X-Gm-Message-State: AOJu0YwBLbTZwUhClcINWT4CM7SKg7GJCqtcNt3rMK3xBbodSbw9DlVq
	EUUdto5OtnF5g2Kjpbu+N7IY5w6p3QN3rf+nlgMzr7BKQbDhKKLwDxRG
X-Gm-Gg: Acq92OEIWOhvuTLEavcuUPGeJwPopGLhyKFBXzmG/86UmXtAv7PObTYwDVb/Aqf6HsA
	ERoSiWz/d6fPGP8TThHsTHNt9TFr5qsCaHf+XhURzg+NyXXh8wwqYvG9D9/XQXSej9y5IvGhNhM
	GEuKShjAF6B/qYnhAu1kRKzI62Ch9e8Bv4lqoSzN2P/1mjj8lOyWLiibfFWS67XL51ISr/HkJrz
	0WA2iytb9ZWYWQVXKeccPhkWNlxg/zlMwcCIoXpjgHjsq/evFU3Q3Xr14n2sKeWX6D2qnFsfIoM
	wyCTwGQKp4V8vHHwdFFXNGTjc6ndAHyTwdA7xZqyXEA3gAD5QXrZfboVdpRvBggCTzHal+J7sMB
	YEyNr6U2y2CXp66sV/ckDEYuUpEGxiLCzNAUy78E4g0pw/XjyAvuHvfG4ICwRhkvgd7OUJLKQFy
	1WXnjrUJgFHDeyf62VFDWESeWJEEzKWJ3rwfStO4LFA40znb1E+vUMOewlEyVcDvSfenn/GQ==
X-Received: by 2002:a05:620a:2913:b0:915:6437:bbb7 with SMTP id af79cd13be357-9161bbfb66fmr1964105685a.14.1781490470480;
        Sun, 14 Jun 2026 19:27:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:985:4601:5df0:2106:6ce9:6b1:8f70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619ed7540sm958696885a.9.2026.06.14.19.27.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Jun 2026 19:27:50 -0700 (PDT)
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
Subject: Re: [BUG] KASAN: slab-use-after-free in is_free_buddy_page from megaraid_sas
Date: Sun, 14 Jun 2026 22:27:48 -0400
Message-ID: <178144969601.60470.12499376837330329541@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <178144969601.60470.16745418177798279969@gmail.com>
References: <178144969601.60470.16745418177798279969@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I hit another KASAN report that may be related to this megaraid_sas
management ioctl lifetime issue. I have not confirmed that it has the same
root cause, but this report trips earlier in megasas_mgmt_ioctl_fw(), while
accessing instance->requestorId after megasas_lookup_instance().

The issue was reproduced by racing MEGASAS_IOC_FIRMWARE ioctls against
unbind/bind of the megaraid_sas PCI device.

KASAN: use-after-free in megasas_mgmt_ioctl_fw

I reproduced this on commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7 (May 25 2026)

To help trigger the bug more reliably, we applied a minimal diagnostic patch
that only adds a delay.

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/72dca59b156aed25639db779bafdf7e4

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ 1445.240069][ T8341] BUG: KASAN: use-after-free in megasas_mgmt_ioctl_fw (drivers/scsi/megaraid/megaraid_sas_base.c:8546)
[ 1445.242466][ T8341] Read of size 1 at addr ffff888115b7d909 by task repro_megasas_l/8341
[ 1445.244862][ T8341]
[ 1445.245578][ T8341] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1445.245586][ T8341] Call Trace:
[ 1445.245595][ T8341]  <TASK>
[ 1445.245601][ T8341]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[ 1445.245617][ T8341]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[ 1445.245670][ T8341]  kasan_report (mm/kasan/report.c:595)
[ 1445.245697][ T8341]  megasas_mgmt_ioctl_fw (drivers/scsi/megaraid/megaraid_sas_base.c:8546)
[ 1445.245721][ T8341]  megasas_mgmt_ioctl (drivers/scsi/megaraid/megaraid_sas_base.c:8630)
[ 1445.245731][ T8341]  __se_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:597 fs/ioctl.c:583)
[ 1445.245741][ T8341]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[ 1445.245772][ T8341]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[ 1445.245783][ T8341] RIP: 0033:0x7f11ae510237
[ 1445.245794][ T8341] Code: 00 00 00 48 8b 05 59 cc 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 29 cc 0d 00 f7 d8 64 89 01 48
[ 1445.245804][ T8341] RSP: 002b:00007f11ae41ad38 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 1445.245819][ T8341] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f11ae510237
[ 1445.245827][ T8341] RDX: 00007f11ae41ad40 RSI: 00000000c1944d01 RDI: 0000000000000003
[ 1445.245834][ T8341] RBP: 00007f11ae41ad40 R08: 0000000000000000 R09: 00007f11ae41b700
[ 1445.245840][ T8341] R10: fffffffffffff7ee R11: 0000000000000202 R12: 0000000000000003
[ 1445.245846][ T8341] R13: 00007ffe50e3399f R14: 00007f11ae41afc0 R15: 0000000000802000
[ 1445.245859][ T8341]  </TASK>
[ 1445.245863][ T8341]


Best,
Shuangpeng
