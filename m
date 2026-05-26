Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072393FA5DD
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805083; cv=none; b=lqG0x22awpgZkH1YMfap2MOtbWNSQhHmaGzi9NeihNiL/VjVu03dJoRRM07O97sknAZZc9ZON8/TAMIV4w/yZqQHaREPuQe48I4hGndgtjjYG9TXQkVWp1MckRLWSQvy44SP/WW8z7ahyfORgj6lMH+FT7av60SDMn66kbr2d4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805083; c=relaxed/simple;
	bh=Kybdz7vMHfQVHVOh6L5fYiSlCH/4zeDGpuUchAH7Tmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FMyobFsFXHuVXYZ02VwXHYo5Pt7J3LA9ptHOQ7qtKY3iF3K3LaLgWuKMiX3A4mXWRNbgneud3PmPV5hMhsoeL6/DeFD/DYa1hZTNzB67D4ZIte1MYrKTULLltdyvai9gV4M8wKn9R4r0KrfpRs3xgeInLRNLs9//FDabOau3P6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=jUCdy8Gi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="jUCdy8Gi"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49042aeeb75so56377445e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779805077; x=1780409877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7+ZEzN34eEHBV2XeA10qliUnFt9aIEOrlvbEy+ooC0=;
        b=jUCdy8Gipkt5y1MdcWslWRDMUj8JgIufk+P9hRE/YWr9GaQcjwOmoEt5qBgAPYQJGm
         fhMyOvwnNEu2gT8q+Lvv/ezwTrgG/MzOvWku/AH/ansOg9CipsEdrlnMwU34y8l1KOBS
         yGCk8FHKq99skBMwZv+iY8FPTRruC2IxSIZkuxVmDp5uxYMpN4MARnAqHIs+sktvOObc
         1pxwsRdd+M+ZTolUYkhoBNwfPxVjPj78KRVjKsOlwraDzdYlRmft0W6ufYl0lF/ZAH12
         Csw9U/m2LL0Qt0h8RSMnL6ZGFWkI2K+NcSD0GZMMl1stByq7jSkFkJqHVHn5f1SOp/o/
         VBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805077; x=1780409877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7+ZEzN34eEHBV2XeA10qliUnFt9aIEOrlvbEy+ooC0=;
        b=ZjSPddyy7n4OQsAIiZ2cIIIYN0viWv4VNg342HmdqwKY1vbvfLsMIADHn1Rg7S0amE
         EOBZ2A78Et08mb3zBnI+qf1TnPR26xScnhtWeGzGk/Vj85kdf2/nCdEHe7iV8Vcgbd1V
         cVICMeaegHHIR4UecbbMNX/qSLVXZisqJgiyZ4k3BeiCva5eYtp3QuDtiPJfL+o7a9LX
         2kFoQ9evWwSQveRVj5YRzVYhuAtCLNoiLxOWQG/SGBaXsZ/g7VHQf61ex5yv/iq2czNv
         TX3G8jvSPzSeDTzHI3FOaTQyHblkts4YNyDKAvcERN1z9zdXlWQJCaHC4zdAO/GBdl4k
         hIHA==
X-Forwarded-Encrypted: i=1; AFNElJ+AvD0I7WFmmm82X1LfTix8dbXVamGvlvid5P6OVWRzq1kkF2zx1foPCf1ElFy6hr0cDjdJD7mE/Suu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8faFhsHVkBA681qSchYxsCYc/bcdL5px8G93fXKeSZhj25Onn
	l5gYTebZQVzB+2L0xqBL/ANeKkthJb7azhCGz05yIMhQTsAo1O82Fi6FpU0FDNwB4GM=
X-Gm-Gg: Acq92OG7qpwuLfPOdKz178W/CI/5RFZGCxncnP5Gp9x5YhrF7a3Y3ruaBD1hXNmwZoq
	73Un4x+DohPPyA9l0Bxd2nABaVx7SBLlS5mvfVRuME+u+Hs9Zpzwm9W8BmDXYcOgrmpIk+g1F4i
	/cozIs9qGxT72x+i5ANey6X1Mg+ZzcuzjXFuVojkz/Hu88cBjs6S3WIOGnKN9hOH2DX4eCZeVlH
	9DL3SmkYjNEqRbv1T3UvGtQz2TsFFiNqhh9QSDK116O3a8IDl1zQRiYHM3KC7XZRmZExMvZ7Zct
	54djVOyrrx19RAXMFAY496SvKcE08tybQMfGXSPiR7Vn7NSKaeiqHjRcMK9Pg1rGhwNmSOP/eEx
	V98GZtcoFOUXTDgkE9/h+Hz/azoxFy9YPvO8KtqUYUREhXDsmmtMAIo/o7aA+63fE8zqUWWo2tM
	7ENKkHWbb6Z/hRPtkfIcvg7NMGQIoClXalyLxHt3LnRFQP1PTCKr7GAVWgncHgKlCU1hroCMLrb
	MUmEFxWuxQCvfQ1bNMQPu96oQ==
X-Received: by 2002:a05:600c:8484:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-490426cd8c4mr332344195e9.20.1779805076904;
        Tue, 26 May 2026 07:17:56 -0700 (PDT)
Received: from localhost (p200300f65f47db04a716d2bdeddb4813.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a716:d2bd:eddb:4813])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904526ca21sm323690885e9.3.2026.05.26.07.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:17:56 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Max Staudt <max@enpas.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Helge Deller <deller@gmx.de>
Cc: linux-ide@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>
Subject: [PATCH v1 0/8] zorro: Improve handling of pointers in zorro_device_id::driver_data
Date: Tue, 26 May 2026 16:17:26 +0200
Message-ID: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2934; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=Kybdz7vMHfQVHVOh6L5fYiSlCH/4zeDGpuUchAH7Tmw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqFat2pwUr5NuB2EXH5DJBMYu0MFsCRZClzwm2T O9dYlR4RvKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCahWrdgAKCRCPgPtYfRL+ TkGXB/437E8f30EKdaE8q56oaJt5WlihQ7/3LiGG3zpapj74Iu08O8/GcyZKo9eVo8NUFaoQUo0 0hif3fK8HhAxSruKgus+1EQhLy4QeBS7zZsfKLyQOA2B83qRv2SA46ZptWCnVfQXneJtq5rnt/p z+XAhB5HNmZ0vPCrnsT8fL9BH8Yuh3zYqxT9eUnhr+pmthPLdEZiphMZPNHOU/10eCiEJb0TQUX jspmFLtmTRiWApFBZdcAJAZ22LyP1Ls51jKz1i9KFNk3U1cVVN3KNX/HmgRm8an2jPEYqs0Aq03 oaSi8UN/pRU/wOeZjcBFx1K5Dq0XXmkIHLJB0BQbJ8js9PWI
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

this series is about improving the handling of pointers in struct
zorro_device_id's driver_data.

While it's ok on all current Linux platforms to store a pointer in an
unsigned long variable, it involves casting that loses type information.
This can be nicely seen in patch #7 where after profiting from patch #6
the compiler notices a missing const.

Preparing for that change, all zorro_device_ids are converted to use
named initializers, which is also a nice cleanup that could stand for
itself, as it improves readability for humans. (That is necessary
because an anonymous union can be initialized by name, but not using a
list initializer.)

My motivation for this series is the CHERI hardware extension. With that
pointers are bigger than longs and thus you cannot store pointers in
zorro_device_id::driver_data. So this series is also about getting
support for CHERI into the mainline, but I hope the clean up effects
mentioned above are justification enough to accept this series.

The dependencies in this series are as follows:

 - Patch #5 depends on #1, #2
 - Patches #7 and #8 depend on patch #6.

So if the ata maintainers agreed to merge their patch #1 via scsi, and
Geert agrees to patch #5 and that it's also merged via scsi, patches #1,
#2, #6 and #7 can go in without further coordination.

Patches #3, #4 and #5 are only about using the same initialization style
for all zorro_device_id and can go in without coordination.

Best regards
Uwe

Uwe Kleine-König (The Capable Hub) (8):
  ata: pata_budda: Use named initializer for zorro_device_id
  scsi: Use named initializer for zorro_device_id
  net: Use named initializer for zorro_device_id arrays
  i2c: icy: Use named initializer for zorro_device_id arrays
  video: fm2fb: Use named initializer for zorro_device_id array
  zorro: Simplify storing pointers in device id struct
  scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr
  video: cirrusfb: Make use of struct zorro_device_id::driver_data_ptr

 drivers/ata/pata_buddha.c             |  8 ++++----
 drivers/i2c/busses/i2c-icy.c          |  4 ++--
 drivers/net/ethernet/8390/hydra.c     |  4 ++--
 drivers/net/ethernet/8390/xsurf100.c  |  4 ++--
 drivers/net/ethernet/8390/zorro8390.c |  6 +++---
 drivers/net/ethernet/amd/a2065.c      |  8 ++++----
 drivers/net/ethernet/amd/ariadne.c    |  4 ++--
 drivers/scsi/a2091.c                  |  6 +++---
 drivers/scsi/gvp11.c                  | 17 ++++++++--------
 drivers/scsi/zorro7xx.c               | 16 +++++++--------
 drivers/scsi/zorro_esp.c              |  2 +-
 drivers/video/fbdev/cirrusfb.c        | 28 +++++++++++++--------------
 drivers/video/fbdev/fm2fb.c           |  6 +++---
 include/linux/mod_devicetable.h       |  6 +++++-
 14 files changed, 62 insertions(+), 57 deletions(-)


base-commit: d387b06f7c15b4639244ad66b4b0900c6a02b430
-- 
2.47.3

