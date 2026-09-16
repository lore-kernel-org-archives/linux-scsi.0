Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8374A3F2A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560929; cv=none; b=Ia4V46NHMUIuhuo2R1336H0uTu05TiOnF9k4Zs1UTkMFVtg2Y2OvqvQ1rMQmaFWWbIuArw75vBnGITUVlVhrTn9FyclzgB2HUuMy6+Gr3lAE4/8PnkmlmJ+1LjxSOwig8UtnTWuBHiCH6llWSL44bWItvkFVQUhdw0aDQjwu9nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560929; c=relaxed/simple;
	bh=DqlshfivEwgnrB+qkDvakP7pvIL7ZOxMkNNV0cMvHsk=;
	h=From:To:Cc:Subject:Date:Message-Id; b=jRaVgb83Wvb9VP/WAfOLdApWVzOEdZXIyXlcvRFC0usq3dZrgG/uv+Ec4nTDmc9jhGRz8NK19mM+WFIiluuaJdkCYMdtNAHzqArGL/L6eEjC0vf3KCy83+cvwFLrT1qtliCPTB1Rkjaq4gnfH49QP63BnepE+ZX97ZiLjjAkfQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HUkD+v9L; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUkD+v9L"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso693195a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 05:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789560928; x=1790165728; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aayfnjV5p3GQV2kJBDU3d+V6F7p/7t4V6z/4sqcizKw=;
        b=HUkD+v9LvPy+cCczmd/P1suhuDlH2yanOK46C+XKmg4doVR/eI2Pwbx4IioenIP+rR
         QMegF6Cj65xc1fAcq2iAdJwhsgwA/cYRS4d1/gCtBix6v4xAAP4ik0aSJfnNUvXg5aXe
         l0TiRh048htCYnQBG4xJJjtwhL9qfCYy1XrA8OW53VaoZ/NvTZuoWzYox/Cg6s2qMaAF
         aPz5usg9kMCw4rmmS3KpWA3c+PT3dR7s2+t363LYrQPwLknsdAehM4QiTCQybJrtax8S
         vGZHinoqzh2VTA0pfEhbubi2bmR1pNeWpqLBHAAO1BehgESbJxz+jTFioWa7jyjD/gvq
         Zy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789560928; x=1790165728;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aayfnjV5p3GQV2kJBDU3d+V6F7p/7t4V6z/4sqcizKw=;
        b=PNsNbBQyETjtHV2HaWQkR2PIvB9KXgDVJMLueaozWoydt6XzwoE5PIaeD/MdXyaSjk
         JuiBiQN+hvduzqnGt5H5h+5XXbb3anZwwHVuWBL0MeZinW/bp/QpGsJ5mYiL4M+YJyFL
         bxG4fqty9cRIu4C8pPrIKxKjEJk+Lu5VxPfxhrg2KhMvuo3V8uu9edm9Np+lytexq9FC
         l8s9EyUxs2wlxITycY8VfpJX1/eUpAYadJVotwdEKbdK28oFqaaXiu31A81OhZnwG3Ss
         CBKJv428vADe5TDAgjxT6Goqbgf+7JYZXFNNL0AKN1Dn97uf7E2syACocgtZ6s9r/Kww
         LmiA==
X-Forwarded-Encrypted: i=1; AKwUvBzxJx1Ye9yPAMoLuxWVf5NirOh3D60755ivWcxoz2em+w5fV6cNif2KkBEMk0vfw5UB60xYZC83wv6g@vger.kernel.org
X-Gm-Message-State: AFuF++naqrb9qlVwtnvaDWhg+rEnbjJWbGw7Mxx4/O7hMI7858Rnx8P9
	K4DORCbFeXNTiHn8RfmgUCGnboczCY/MxJ9DR/og464d8ICHsr+2GjQ8
X-Gm-Gg: AYBFou1QEQPcHobxC3/FRZsGf10bjP6zcH7/wDT2Keu/DNEMtWejnzqKvDqcP6IbHHy
	OIHPDi33tFRbbpvIFdGx2wYa8QmOrD+zxi3KMKTd7wbSp7G+TaH/e6/FPiGVFRzSR4lToZCx/sQ
	AfwCqk2Hsg7zrUrE/wNMy7a3AnrfPaTSefLL/lDA5SAVH3AR6jlTdUpRGvEO5vtr81zVo4f98fI
	Iv7uK6pAl3enTaET103SKSjC9BvaidS7HeY+eELzbAUyCHvzWgKHQ1g2T32XE2iWvgkGWJsHfa7
	Ony79txvym5bAM0FNBuFj15MeLOoSk83B9/zCoISxClcqgWjHpIod4rgR4XHJTQRt537XcaaBQr
	bMpgB9QYH5kOQ0lE31a3kI71uw8ouWL8KtmHdPCRVs9COPKew9OMyH27gcgoK/0OJGbsgzbgXEP
	898x4cNiI6EJdaIr8foSfk7bcMBcilzjRnOhbwJCsARvW7IvD1IFZBnPabWeaKWqmKGsHrjA==
X-Received: by 2002:a05:6a20:e290:b0:3d3:aec2:4dcd with SMTP id adf61e73a8af0-3dd5f7a9ca3mr5599543637.25.1789560927153;
        Wed, 16 Sep 2026 05:15:27 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab8ae01sm1512489a12.18.2026.09.16.05.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 05:15:26 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH RFC v5 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Wed, 16 Sep 2026 12:15:22 -0000
Message-Id: <202609162015.RFCv5-0.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Hello,

v5, as its own thread, addressing the fourth sashiko round (one real
Medium, the same two Low false positives).

Changes since v4:

- led_mc_calc_color_components() now runs under the zone spinlock.
  It writes the shared subled_info array, and the LED core allows
  concurrent brightness_set callbacks for the same LED: sysfs stores
  are serialized with led_access, but trigger events call
  led_set_brightness() without it, so two concurrent setters could
  interleave their component writes and the thread winning the lock
  would cache a mix of their colours.

The two low-severity items are the same false positives as in the
previous three rounds:

- kzalloc_obj() exists in include/linux/slab.h since v7.0 (Kees
  Cook's overflow-refactor series); this driver builds against 7.2.

- blk_rq_map_kern() takes four arguments on current kernels
  (rq, buf, len, gfp); drivers/scsi/scsi_lib.c calls it exactly this
  way from scsi_execute_cmd(). The five-argument form with the
  request_queue first parameter is from older trees.

v5 was re-verified on hardware: per-LED colours, 100 sequential
updates, concurrent same-LED updates, concurrent four-writer updates,
and unplug under load (zero splats, zero leaked LED nodes, clean
rmmod).

Everything else is unchanged: the hardware description, the
scsi_device_handler that does not claim the sdev, the multicolor LED
interface, the protocol handling and the known caveats (manual attach
until a notifier lands; SAVE on every update writes the enclosure
flash, wear uncharacterized; NULL-parent LED registration to avoid
the sdev reference cycle).

The open question from v3 and v4 stands: the driver is deliberately
not wired into Kconfig/Makefile/MAINTAINERS yet, because the agreed
direction with the SCSI side is a split into a SCSI transport helper
and a shared ASUS Aura LED interface, and the wiring would follow
that shape. Is deferring the wiring to that split acceptable for an
RFC, or would you rather have the driver buildable in-tree from this
series already?

Comments on the interface shape and on folding this into the shared
Aura work with Denis remain very welcome.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>
