Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56E1E5207
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136367; cv=none; b=fNIaIy4Ec8V5W9Tosz/q6xIqmNHr0J0Cy+FylDrhcmh8ZR7rEZg3w3ubvlqVLZvmHAnLskqUoHwUgQce51q7j79IpCQnjpbFVo/do3ng/qKVYfijFqDHQVekLtMg9qJgpV+EkAE3+Unwq+bg78FwxrY3b9JaFOXfWzTEh/mYcEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136367; c=relaxed/simple;
	bh=IAdbxss3dLrcOoQ0t9BI37AncWy3V4wOjCAq5w1hmNA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=guVGnXhwrsvyWFK84A3E+rxc3wxsYLB1JlFJbqk+D3Oum3fNP5sDxL8vpFpe2Cbi6shmm9JAFBz0oswou7AEr7qwcISAQBEg4CpT8Iw7qNbFHmwjWD6u3x55UjSgB64/NL3VIhT3AhowO2L3luhAG6mS+ZgUW+Kt04TTxuO61b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=ShoUn43Z; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="ShoUn43Z"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2d5e119fso677935f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136361; x=1766741161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mEQfLBNkig6KHxBO+ZBOPBSWtfNwl/mAz8zFq4Fdwak=;
        b=ShoUn43ZKwkK9z9DYnQrA2y0c8Ka4UuDXuYj/Pbeja4owZpPJD7q32l2IrbG9DucZc
         x71rVHhYOrzYE7EYI1EO5RXEtP/ykan+yUG5gqeiq9mURodAb1nN6W3BDI2mWFzdZyCi
         qVHpYOcZuPFC+/UU5SH1VBQ9kDpZV9nGVpEXcsWQt/IjQcuc7tfsJ7Vy+eTRTHMX7TOQ
         COx8KrDa940wyrNFchfSObtbJIqtQG5bPeSmMlz9naYIgvLTMnloXR51bMvLkUh6A26I
         C9JoF3YBQlp88fVOud4IEGRmq5zjQ1aOBnSLk5GDfudQikWJ57hPxwgDJejXEYLN5U0R
         vjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136361; x=1766741161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEQfLBNkig6KHxBO+ZBOPBSWtfNwl/mAz8zFq4Fdwak=;
        b=j9Pj4RaTJREWcdfyfzSZDxfL0xvpjhjgSWyelkEh+A3D6dvD4rWMPil/5t5JxyyLjA
         5hVsPQqAb+9uzJuivZlElAK6CgwLCnSaKpwn9yUJ4jYB1780x+3DYvGV+51ih3NGaBSq
         RSV1MB+vWlRssdjCbS1dzPZco6y/4zP5LAIe8QcWCMtub5xaCGxyMkHz8bfKDN+31E4v
         v7kO4TMNxYIp7J2nUr3z0u5/6Gruy71N52oBAn18UVqoN4txELyobX7yK3uxn+5C/r5H
         fTWUTvHpQ6htRadIfujw09btQDnAk/W9cGfutr8DIq5P/Ldx29mfgG3Au8sIoY1c8ihg
         qBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5szqQrMUT8tr1Bdnb66iWS9NrT/FFCbmvYKPX8cpRvOKexbRUk2e6CJek7AjGDC46Dd8M4MEuu6au@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6v3XcQkA6aAqL4Qe2otnPCHGOZdjRzGk3iAPVzBpvlInR7BWz
	XttPteBiAOAZaL9Yyb2c3TdoKJrlfKMmH8voxhnZF9A5caG221QdCAYrqyN9aGHOJFs=
X-Gm-Gg: AY/fxX6KmXiHNA6gHWyqIvoWwDfKlNBJ5Bmq3RpptBmrF29isD9vpfPWEf2nayLBERd
	yVk7h85OUhalp9IrkYjAimWDiHpAa+dbXpqQY4LMY/z0VMjP+hghVBlStc8VNooS3Az0AZoKLqF
	Yo3/5Tv1C+TlulsU2yt/Ozu2E4xR3t4GCCp09sEukZY4Bv/4mItOYg8owAcBkBsXZw7U4g3Ufug
	IKr8+EVjIi2OevwHXcVUwglNN25DuVpDo1XJlBFRqfGS3b+kWKDjsTTmPDkaD3KYjLoXn95yFBY
	LmO3VGGVFReH1fCtKJiWKyegPLi+RQZE4pDa4gS/USveUWQEgpen/XIxVHCQqy9tRBJew+Una0z
	UBqogTMP1/D1pG1ogfhseEgDe4qzDiItUa6/30vAsPnu+o5+geGLE0f2asVMzP2FOHsZStR3fXA
	sR0yI/AsdDkpgQhZhOFy0+ZetVtrvQS7RzTfB/CpK/yvw5Xbz1CQohyaZ+LQKCbFhBTYztIRD5O
	E8=
X-Google-Smtp-Source: AGHT+IE/hZW3FJZsWVHdzVUWg5J9RwD+/ADUpNftxPBYvak62/hf0PU8XHFORkZeSi00XISdKG3jGg==
X-Received: by 2002:a05:6000:24c7:b0:431:1d4:3a8f with SMTP id ffacd0b85a97d-4324e506840mr2543450f8f.47.1766136360735;
        Fri, 19 Dec 2025 01:26:00 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4324ea82fa1sm3710071f8f.23.2025.12.19.01.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:00 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	=?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v2 0/8] scsi: Make use of bus callbacks
Date: Fri, 19 Dec 2025 10:25:29 +0100
Message-ID: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2378; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=IAdbxss3dLrcOoQ0t9BI37AncWy3V4wOjCAq5w1hmNA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoN8BONrIecwy7V+dYl2JORlG8x/4WY3e7rT l5IkkNll9iJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaDQAKCRCPgPtYfRL+ Tls8B/sFjIScuB6gXphaL0wGuHgRBEXVJ3RLWVxVSsgBMOBPVODhIP3eFDGOtIXf3Iv3H15IKm2 PwNN2Idzd2SYtU2mzeB2iJHIhtBNLFmM7UZe6vx+sS0u3wOUNCg6FyRMf3mabtv16sLwI5LM1iF L682E+bV2DoaJbH7XyL1C8s3m1XQhO5nBodi/tiVcPjyWrR+88+Uc8wJG3LXdJMcxuERbyfu+uF aqn9mZeh5k/F3L/NFB0owfoemrjldR6sRk36bInjQcYm1wmDzkQ967pqh+xNj/2dwO0cKtTbUAE kWjHW9Uu6aMldNE86CYiEqUHXzT9DtSLwIY/6t/bep0YI71r
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

this is v2 of the series to make the scsi subsystem stop using the
callbacks .probe(), .remove() and .shutdown() of struct device_driver.
Instead use their designated alternatives in struct bus_type.

The eventual goal is to drop the callbacks from struct device_driver.

The 2nd patch introduces some legacy handling for drivers still using
the device_driver callbacks. This results in a runtime warning (in
driver_register()). The following patches convert all in-tree drivers
(and thus fix the warnings one after another).
Conceptually this legacy handling could be dropped at the end of the
series, but I think this is a bad idea because this silently breaks
out-of-tree drivers (which also covers drivers that are currently
prepared for mainline submission) and in-tree drivers I might have
missed (though I'm convinced I catched them all). That convinces me that
keeping the legacy handling for at least one development cycle is the
right choice. I'll care for that at the latest when I remove the
callbacks from struct device_driver.

Changes since (implicit) v1, available at
https://lore.kernel.org/linux-scsi/cover.1765312062.git.u.kleine-koenig@baylibre.com:

 - trivially rebase to v6.19-rc1
 - fix a kdoc warning uncovered by the intel kernel test robot
 - rename a few variables to align with the already existing naming in
   the individual drivers
 - slightly reword the commit logs
 - add the tags received in v1

Best regards
Uwe

Uwe Kleine-König (8):
  scsi: Pass a struct scsi_driver to scsi_{,un}register_driver()
  scsi: Make use of bus callbacks
  scsi: ch: Convert to scsi bus methods
  scsi: sd: Convert to scsi bus methods
  scsi: ses: Convert to scsi bus methods
  scsi: sr: Convert to scsi bus methods
  scsi: st: Convert to scsi bus methods
  scsi: ufs: Convert to scsi bus methods

 drivers/scsi/ch.c          | 18 ++++-----
 drivers/scsi/scsi_sysfs.c  | 77 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sd.c          | 29 +++++++-------
 drivers/scsi/ses.c         | 15 ++------
 drivers/scsi/sr.c          | 21 +++++------
 drivers/scsi/st.c          | 22 +++++------
 drivers/ufs/core/ufshcd.c  | 22 +++++------
 include/scsi/scsi_driver.h |  7 +++-
 8 files changed, 139 insertions(+), 72 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.47.3

