Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932313B42CB
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 12:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476544; cv=none; b=oqsM2g/UBKYBZm0E+CQgl6nbS7Enk1uky/G9Bfo86xU3yzhbtD9zNTD/wqmeLjo7FRer9wzkVA+AswNnMZMihHkDts9P/7p/gnJfr/OyTXJL0foASihzBfSk5qRIUse0PMQ5yGrlJLGPjU4k+Bre6ECruaBXAQi1/g4xmbOPd1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476544; c=relaxed/simple;
	bh=YFHzDuiSQXSIMebzDRCSKEz0SUhCBqu8HZ+JLzlNMtI=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ki0PLqrY95G5rcXvlfwjRqdVN5dfG11eYG3QBr1U+fjOSI3HsKoOneH6E921FUpPb1I2E6n9H/rx7y/94PH2QXhs46dH8McnrdSyEsulaPteMKKgc9FLXoNcF+z7IFX+6vp86DptwOTn48x5WhhTVWDOiNVGZhHFSg2bT/R4/tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DFb7u2Tr; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFb7u2Tr"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd58e1e2c7so23152045ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476542; x=1790081342; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K4NEyPUzdcskfuL6SgD4LKloEIz4xPCUOIfMYZX8ltY=;
        b=DFb7u2TrVWtDC6Qq5VonQ5y2Eno7vf7CBQVoAV63ywLB9WT0T+27nkyA6yjSyunuX9
         ZUMSh76lb9z3WI87LNmWa5FIO1PoORJpclzrDvxLY+EpECdFtRyw2RF0/zdsI2Bgr45+
         JdEJV4nb78TfntkjcgwYUZOrRI1qzSoW+D8J9yDZtY82hh/ABfe0NDCiBvdoerTYcd2F
         urRnaPBZnfrq74XuRUX97vWmpv6dYpqTvwgoE5/GC3r309s3WZwSqS/JyNIh/jxIP5SU
         3DOs13v36CcG5FSs9EnzSxfdBkqRNNoHpLRt6fWeG0YNwClKyvfAon1GjPllksjonoEe
         qYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476542; x=1790081342;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K4NEyPUzdcskfuL6SgD4LKloEIz4xPCUOIfMYZX8ltY=;
        b=Kmx5ASNxqUUNt5g2w6v4wXoq025C/ahYEUFf5Bi0Eu3nV+YSIMbdAoIxu8hrAKOTYh
         CiyOvC3YV/QI6UX1C9dbkx5ZLvrhNduQU+c78WBgMigIXUfYHhyFY1bBxzWuAhtvppWP
         39h9RGZHCR3IriiAV/ZP67gFfMf2k95fCItP6TrBsZ7SM09C4mpPeR39Pdv7mY9Alszd
         jDgwtI3LW+SGuwaPMh3LZWa8fjMLUlOvHt7i9y9MiJweCRCRRe8b9CYyrhggClZBlrQ7
         Kk3+/Ff5QsqtGA+yz3eV1xQAKzZQZIb4sUY7dRjG3oJZcCzP0BI4L7n5j1NwWz2x5XTW
         etZw==
X-Forwarded-Encrypted: i=1; AKwUvBxKKOfSYetygUOoe+0c8DFV2+b2exTEHIncYdFum8VOz0t/zD4+UNk8giDDEkP8KfCPNTeW+rySogfa@vger.kernel.org
X-Gm-Message-State: AFuF++m+VRBS9Vij7X9V8TP/vhmDjo2aXGPYOh2GdNxiA3dl5ECxeenx
	FysdAs6F9KZHhUi4pM+1UWzoguNX4hmh16aZds1vSr6lMCx9RElg9yVZ
X-Gm-Gg: AYBFou17UCcnDiecoJTpZEfhzivdcj6BvL7o7aSDlssywTtgx3MGINXmm3juKkANAx2
	W4BT0VpgOBY44AhmM5isMUZEnrm8hlUupiP0uNQiAwlfo3sV7TgQB0jBbwDWXUzNXLX92kvgwNW
	faw+f2xnCa2+BEdWYzCcQwbQqAwDS4TpllYJIPOp09dPKwTvEvfDm0i+tOZsAXlgH85PEk/c9W9
	wjRpFDEpBJhiQspne0PwdQ4DL+qJBi7TKgwixKynzv+wZ5L+6hfsNdTdczPYFlHw2LjZ01ryu6j
	YPboGKJtzG6s53lgWelJvbCdQFpwwcpzZcqJ1wfMi64NxwipWQXJhtlmZrqomekqxxWxaXprNPC
	efaRuS+jAIbn8USlt8dM9tbT9H8av5ie3u7GMjEfdT1dUlfLzuDxuu/0ojXBRX5Zr27+xcJn8Bx
	YZcEm/1baI1c9CHJTKK4VPjWu3HNQa7QyCJAElEkxVmOcpHD87h14QziiUCBGRjbZUB+evOw==
X-Received: by 2002:a17:903:11cf:b0:2db:733c:fd1f with SMTP id d9443c01a7336-2dd6c5ee698mr129931065ad.8.1789476541491;
        Tue, 15 Sep 2026 05:49:01 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd48ae3cacsm52866095ad.26.2026.09.15.05.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 05:49:00 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH RFC v4 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Tue, 15 Sep 2026 12:48:57 -0000
Message-Id: <202609152112.RFCv4-0.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Hello,

v4, sent as its own thread this time, addressing the third sashiko
review round (the Medium naming item is a real bug, the two Low ones
are false positives again).

Changes since v3:

- LED class device names follow the devicename:color:function scheme
  again. v3 embedded the sdev's H:C:T:L verbatim
  (asus-arion-0:0:0:0:led0); the extra colons break the single
  separator userspace parses LED names with. The colons are now
  flattened to dashes (asus-arion-0-0-0-0:led0), keeping the
  per-attachment uniqueness while leaving exactly one separator.

The two low-severity items are the same false positives as before:

- kzalloc_obj() exists in include/linux/slab.h since v7.0 (Kees
  Cook's overflow-refactor series); this driver builds against 7.2.

- blk_rq_map_kern() takes four arguments on current kernels
  (rq, buf, len, gfp); drivers/scsi/scsi_lib.c calls it exactly this
  way from scsi_execute_cmd().

v4 was re-verified on hardware: per-LED colours, 100 sequential
updates, concurrent updates from four writers, and unplug under load
(zero splats, zero leaked LED nodes, clean rmmod).

Everything else is unchanged: the hardware description, the
scsi_device_handler that does not claim the sdev, the multicolor LED
interface, the protocol handling and the known caveats (manual attach
until a notifier lands; SAVE on every update writes the enclosure
flash, wear uncharacterized; NULL-parent LED registration to avoid
the sdev reference cycle).

The open question from v3 stands: the driver is deliberately not
wired into Kconfig/Makefile/MAINTAINERS yet, because the agreed
direction with the SCSI side is a split into a SCSI transport helper
and a shared ASUS Aura LED interface, and the wiring would follow
that shape. Is deferring the wiring to that split acceptable for an
RFC, or would you rather have the driver buildable in-tree from this
series already?

Comments on the interface shape and on folding this into the shared
Aura work with Denis remain very welcome.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
