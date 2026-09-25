Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2627D49EC71
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343620; cv=none; b=VFw+X4hoVgC0B+nOI9S7bKETX+XZHS59a9VMVqWHBNW7NabODb/huBZ2B3oJqa9F/At5m3+5kIc75jRj2DwoTrkI7HQ4p8CfzmKyxeU0GH7NR0aGTY+C4zPeIGz5EYNU5C4ljiPJdYXFTV2YuBxq385NtaKhEaONYHhe5xuqDJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343620; c=relaxed/simple;
	bh=ykf8iMJpAcatbima4Jd11GNPsy9PpqpBQ9DAP19u9qc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ess0jX4OZHieMchAjNbGe5mmmqf1y5R4Dz69qNCIKmrTzB6vTEL4sL4aHJZbEpYafm8P696pQHHXB1N89+0wJLti8v6umtQ4B74ebNZGxVNzwfN005Djy1baZCoFyy8FwYzkuAzvgJE5c91KLQH4hTyzj7TolJ16NjcUom/QvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8gmGdSj; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8gmGdSj"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4adso262150a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790343618; x=1790948418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a47bZYCTvp0bK7riN+3+5iqiQ4xgjbaSVoQw1BXJcB8=;
        b=e8gmGdSjw9fDaZMOlVWjxG9jjzssUyKZ1AJcSmsQHqEM8s0BkkfkYcEua3NvEG/E+8
         up8xe4m3skuN7b8JYbLX3iROJMp6Tt4OjWX6OZTGeUzUcOpHYV6Q/kczms652QlXCz6A
         ZkeuCi6S+3tsgM2ipIm0KpaFy42DnWG/7csQD9EhmJSxHo6Q0vi2IXQy7BLuLHjjUmxC
         2KT1jEqKz1wjcJk50Se3bd+TaTc69t/DLuP7E/dwnxG5TUR/g1lWPEJDMbYnxE5kN46d
         jNrEgksxxTK5SZTKC0TVCfysl8Mk7b2bAlfOlqLh0Ui6gALWb2/3bm9PfxVdtZhnX6rw
         2maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790343618; x=1790948418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a47bZYCTvp0bK7riN+3+5iqiQ4xgjbaSVoQw1BXJcB8=;
        b=W83j2ptQYsNZ1DFitWnkTcI5pf63whcJurN/Fi7lb6wBeRyhORPb04dSUSqmDv9Jm5
         zXUEdXokG0OSFogcOFALXW/ZObdEBqf10Yx24h0xOW4qMFlYK2mF1CuFTRfpOQSXHnQc
         yA1J1Zd3n/PwMt3VO29GWV8qpPggPNm1LQrMwQYe3qwfQkF7OIAj32N/u9igv2rQULn3
         TDOyPxi6u1OD1pg/AswR6gAIRUKolgUhYFSjDfxBROodrc86bqQDhwcstxlnAIN0IApg
         8Fpw8gYqGxxYKMM2K5kPvGYBmX7qj5t+uGKe6qwzFDQLjDJKM70m73jerOX5b5xOmkWI
         DE7g==
X-Forwarded-Encrypted: i=1; AKwUvBxPoru2FJoBFMfxzIiT2mtZUawKOnqoIVKtqudd8sweGCTQl+hv+Eo/otC+T6Jh/OoIzdBEgY7+iHbm@vger.kernel.org
X-Gm-Message-State: AFuF++kPC5kgjET0zTQRRpdVed+A89Zw82fm+KBqp2T6lROVo3r2s2qh
	xruPpx8q/3XGF4wsGmVt2WwNFENWr4oqSkuqpz/P8JDWtkbNBotaDy7Z
X-Gm-Gg: AYBFou3Pa8niUOBvmnuO3yaHVKEqxFAA+dDWvKjoDYyV2Z8v491fquKgLAnagqR8PWf
	mU+/D1nux1UMRzm5Wl1gru4BOoyOCHk7MwEzBmbxOEFrnLE5FA5qbUztf8JITkMdeSaNP7MSK/K
	e0hcJ4eM5kTsA+1m7n6Dpcb2o/G2zz/VAEd+Q5Z7VeXw2GhhM+78t61Yj6JLK+HwunhycTfXi6/
	+neisPA/F2hrbeHX5w1MMjJJg4tcAi3wTlXaB2TQw5bK4bgt32VXAyNwqLErwKHreWGGWUuYxz/
	fa5dtzH6dFkb9Z+n1F4lSbKoX6iDKj8UwKrKpDYZlaJ4FaYZ/8+euN/34XVQiZD2q+dmeqqfmAS
	fHDA/8AvL740FwZqyf6o0l8EMTMD3iC3rJndUUkA/ANBsCEeTLwiLYRqvfceOHQ1pNbRU/KyQEc
	6/hdDGOgB1nH7pBEJ2wcT4L61NhDIoyYuCGKz7dsZprJFNAe4icAzNuCvBLYzOqUGQ4Pg9b+Hlb
	/TBuQ==
X-Received: by 2002:a05:6a21:2c01:b0:3dd:85a8:4c64 with SMTP id adf61e73a8af0-3de0e894361mr4873068637.43.1790343617712;
        Fri, 25 Sep 2026 06:40:17 -0700 (PDT)
Received: from ROGZephyrusG16Air ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc787943cc9sm1269673a12.21.2026.09.25.06.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 06:40:17 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Marco Scardovi <scardracs@disroot.org>
Subject: [RFC v9 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
Date: Fri, 25 Sep 2026 21:40:09 +0800
Message-ID: <20260925134010.2815025-1-nbg2974@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

v9, as its own thread, addressing Ilpo's line review of v8 and the
one real sashiko item. This time the full pass over the code was
done.

Changes since v8:

- The DMA staging buffer is cacheline-aligned now, so an
  invalidation on non-coherent architectures cannot clobber the
  rest of struct asus_aura (the sashiko High).

- One pass over the code for includes, per Ilpo's comment: the
  explicit set is array_size.h, blk-mq.h, blk_types.h, blkdev.h,
  build_bug.h, byteorder/generic.h, cache.h, compiler.h,
  compiler_attributes.h, container_of.h, dev_printk.h, err.h,
  jiffies.h, the led headers, module.h, slab.h, sprintf.h,
  spinlock.h, string.h, workqueue.h and the scsi ones; unused ones
  (bits.h, kernel.h) dropped.

- ENE_OPCODE and ENE_TIMEOUT are defines again, the timeout value
  stays 5 s (Ilpo).

- The container_of() declarations are single lines (Lee's v6
  comment, Ilpo's reminder), and every loop over the LED array
  uses ARRAY_SIZE() (Ilpo).

- The MODE/APPLY writes pass named locals with sizeof() instead of
  compound literals (Ilpo).

- The driver now applies without saving. The controller flash only
  changes on an explicit save command, which this driver never
  sends: the LED class interface is runtime state and does not
  promise persistence across power cycles, and a save on every
  update would wear the flash. This drops the flash-wear caveat
  from the previous versions.

Everything else is unchanged from v8: the multicolor LED
interface, the SCSI device handler attachment, the protocol
handling and the remaining caveats. On the interface direction:
the LED side will move onto Marco's Dynamic Lighting class
(OpenGamingCollective/linux-unstable#17) once that settles; he has
removed his draft SCSI driver from the series and says the SCSI
part will be added by its maintainer, so the two efforts are
aligned on the same split.

v9 was verified on hardware again, including a visual check of the
per-LED colours: the four LEDs, sequential updates, unplug under
load (zero splats, zero leaked nodes, clean rmmod).

Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe
    enclosures

-- 
2.55.0


Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe
    enclosures

-- 
2.55.0

