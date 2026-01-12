Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447DE35B14C
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768225605; cv=none; b=jeDGqZBC1zC1uLpM+qI40mFO2y8LC3JpZckBgnO7g3vZCW1MPjsu4tbt3TN10EI0yLpI5HtxZNJbMxJiZ91lCPBbQylIWBC32zWX9YwSzlsn5Wy2pW2/d9TWYSY2ZYXnD24apNf2qN6Ab+nKwbQRTzYhsEy+tOme/N7vE7iYp9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768225605; c=relaxed/simple;
	bh=Bv3qBy4+6Y3vuNcEVDB+hKAOGNXG4Ls7bTshKwoyfE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eOtVDxDNtpZq2U022g0Haz6SufE+plm2+qFF/ckMR/3HWv1PmjjzXD3AG94qzClT28J5S6hrmsAB4A9BLtbXeZcO8yOuntqDvH4yI6gET+RJx3CUnAzB8pZUV5Aa4DWaYKBnsvKIJYIb8HkXVvQyWZTJ5pv5Gz9nKMrLxKxO6Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJOwyigC; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJOwyigC"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47928022b93so13575015e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 05:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768225601; x=1768830401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=es+qBMxJPTkLDqGMs0DKU7nfnSOFsDewoZYlUkiYIcI=;
        b=nJOwyigC1wbWFfWbHKNbKQzVCHcII6oHKsKdVscm6Oy227Zg4nUVUWvutpV6xl3eSO
         P9sTVz/c628fhEjDG8VUtM26WQsAYSyv7Pn5jaTBIFxHjZUlvKbOwc/dUaPSjlV4QEPy
         Cm+wvmRCMDzATnC0aRQZQgWJ2ET+9RM9vmsIN8S59xi7uP8ZykudHR9nBBb9UQ7olgTb
         g1zmAMOh11STflau+l3d8ysquXZPXn+Q2BS44OwwaJljlRwucrb0tdNwo5ocNcVYuo0o
         3DMjWTmL7HYuN5fodDbeY+2cazkWrX157Q+aQ+fzB5uZphIZ23YPq42I7oC08Cg7RGYU
         B1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225601; x=1768830401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=es+qBMxJPTkLDqGMs0DKU7nfnSOFsDewoZYlUkiYIcI=;
        b=djNwJLUN+cAxkNae+hmwSpWQGXHwx5mZjziYKFdSvVKseG2UorPOjOhl22W2AXaNi4
         Q9hyryqvXusNQ6q2xzxACByxFrSqzAqEzHddZkNIEco4xKFSDjuyYOgJAfyFMaBmjSGP
         ZSmUZIbcloC52E5WVdX6eiSIMwKDDzGO3DicG+/rVTmk3GBOtqgDJLKLKdLzQ7ceAayA
         rm8OQL9BQWqIgL1Nc5OvATHbSimcdZ6tMGuuwZUVa5NWabS86MZtPKwAh9bxlAVnPZrN
         F05jubp7o1aS/7IzLXdGd6VGS8zj3ZYQlWpzv8Svy3e7EBz+Tt214xa941zM/rtPDRbz
         b/6w==
X-Forwarded-Encrypted: i=1; AJvYcCX1x7IUh3z/mhO0928i3WMHOKZoRQfRSpJuIFo3AGYc0yug1Bf0DM0FEqd44bMT6EKM1TFzslv6Rm53@vger.kernel.org
X-Gm-Message-State: AOJu0YySxB0+MdBVObHsN/LrFXJSkjccT0lTVaILrw3/x7q8GfFK3Jxk
	kpj1HL4W4tNvvn0xqPOMBLB1XpnqtKXx3PcHYdpRzzJq2+VKPyY6E5Yy
X-Gm-Gg: AY/fxX6mul1THRHt90kM6pri/KeHC4qdvalXg3uoLAbfiihg8un+0JogfBwuuZrAopa
	xvFenmmsTEY3fv7eFiKOn94isQKewWRSHF/TqUVNnU/i6xJ5Wd7+9ZVLObsoKA9TU0Td1VdADyh
	FjzYX1L5L8XGZxPPPlcOKqCSsNq8udImq7Qt69ZeqPS0iHXiYXKwku6Gsc35vN/bxuRQbBulR6B
	Z42A0DdTfNOL16UmimDBzeF83gULm/s8NfdOnv7e+YPGHyKfwsi47cEkyoWHXegO0Ps8qsc9O0g
	g3rP455CybQLrZH07bGed2olRydjrO4Ka3DdMyvvzlUROddXE95lSDzPXZ6NNEMGXJ/7RE2xgVw
	PVA30iFzifP3RqV+iz7Ex5GKOIOrKdfLXj2j7ssEXkCj+oE9TjQ448DVeedlP9g1p7RQLtF2TRO
	KYWj7fChQMzFNHfdvHur95o4H2sFGu2giLU2s0okFfjKrJ1X+J3zCORlW27jeDqXryj0y++iG4i
	KrtCqQ=
X-Google-Smtp-Source: AGHT+IF9z6VjQIMgTfD2brfQRa4uGZOlR6wwUJHpWLiS5CGfO5mfqE6ysQh84IO1RlX2FlItb65i2Q==
X-Received: by 2002:a05:600c:3e0d:b0:47b:d992:601e with SMTP id 5b1f17b1804b1-47d84b0a0c8mr134457105e9.2.1768225600494;
        Mon, 12 Jan 2026 05:46:40 -0800 (PST)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-215.paris.inria.fr. [128.93.83.215])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-432bd0dacd1sm38122724f8f.4.2026.01.12.05.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:46:39 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Duane Grigsby <duane.grigsby@marvell.com>,
	Hannes Reinecke <hare@suse.de>,
	Quinn Tran <qutran@marvell.com>,
	Larry Wisneski <Larry.Wisneski@marvell.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Mon, 12 Jan 2026 14:43:24 +0100
Message-ID: <20260112134326.55466-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Earlier in the function, the ha->flt buffer is allocated with size
sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
path with size SFP_DEV_SIZE.

Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 16a44c0917e1..e939bc88e151 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4489,7 +4489,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_elsrej:
 	dma_pool_destroy(ha->purex_dma_pool);
 fail_flt:
-	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE,
 	    ha->flt, ha->flt_dma);
 
 fail_flt_buffer:
-- 
2.43.0

