Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE651149E0E
	for <linux-scsi@vger.kernel.org>; Sun, 18 Aug 2024 22:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724019936; cv=none; b=PXE7fKuVIksD6a3ZpbwgwQTZClzHwwpB1+VS+Zl5+guQrClRvtQjrrh+oW6BxYTVclLZQoyK4i+y0i3z0DlSmxcPX/tJ1ZYgL9g6ROWaVtkvHzEXST+MFh4APwuBCZKpUsnY5V7V2UVY6mmFEpBpQhEkMaCnMhwRo8qvNvs/8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724019936; c=relaxed/simple;
	bh=gnEH/iMMSngxOeWgb4/tt8YTWoBGQyrI7J5qoexFf+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kBNi6hgRHui/AiG1qV/jUipPWr+9t4u5zyCTyEBSd7rhagKIs29zhKYlppJWatKSaA2S/KgnrhoczWCfvDbzsHgD3kQpcVdpmoBS4OLbquri17vz40L7xFo3PH50P8VaddiX2OL1l1A4rECrUofH1vLtd8PvVxj+Ggqqn6Nwchw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone; spf=none smtp.mailfrom=mary.zone; dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b=B4S4SrZA; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mary.zone
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b="B4S4SrZA"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4281ca54fd3so28987475e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 18 Aug 2024 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mary-zone.20230601.gappssmtp.com; s=20230601; t=1724019930; x=1724624730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AmXbMFGvUj5uU6lE8/ehF7ygNXBrr76qPt34D+Rf3CQ=;
        b=B4S4SrZAq/gZ7yAhwQVWp3NqfY864K4uYvgn6eQK1vMceBvbBD7TnpOGocTdD9c9Xf
         cLqVEKRwuNZ1DDZok5bhgVZ/6pR9iq/k6fY0Dd+2HLrcfSicMcYYBXxMONJI1/WT3r+h
         bgoPjxTHzidZccMgjNkmzWi17dMgJkvt34F/AqvgLlPhmlWFmf/rRiQFDUYJjRMi7p00
         TLfIrLjMYDMd6ZUX3OR6HA2LWpQIulMUryLANOfHZ2FWXzHTqD9PSHFl07DcmwGt1c/X
         JZjm1yDNzIdfvopOjhi2cie7IuHC7ZIBDc/KvJlJZhZmdEAJR4sjQwayjiCgUE+mO0gE
         /IaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724019930; x=1724624730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmXbMFGvUj5uU6lE8/ehF7ygNXBrr76qPt34D+Rf3CQ=;
        b=OtrgWOkoiEKyE9l2GuLIJU3Q3SJlS4FMCYCNPtiB45ppCXxP48JosETEMVGJD3BvOn
         xCptLoYhB/Apw7aoJWT70ysqu77mw1LCUkiIZZ3VQ/CX7wT3lnlJ1I2TS1aU6BfGoLe3
         5i3RoFGVukG4D7WRngME0EQSO6PKlzKdVMd0xZGhkOFl0FMHnA9Wr0fZRAmveIA5LQJQ
         IR1j7d8SKTYpUdwJAGuZwTIGiIaVcWkobZU6ijFAeRlgXzVry2DR/wy4NheBRxdDT866
         Xax2rJaSPNljvSEeXZvqhq15GLXXCdNcWlgc0okN2+Jhh2Pn/Al2rYucJkR/iYuKy6KN
         Ll0A==
X-Gm-Message-State: AOJu0YxO/tvTGPUkNaaplAYJ5F+r1Hn1HONKcC5ReUmpt/zjqK5Lugwr
	Em618H7VpH9SKgihSQ3jdsAZE2Ey2JvcILbv/On1+VriYTvPf4ZPoXT3QLXbsy/BEFl3Wg/D0a+
	h5QZ+XQ==
X-Google-Smtp-Source: AGHT+IG+j1Q3fYSaUFDUt2lqMNM3JcP/kVgcWKHAbRqJjxk+j5RzGyXxJJtc1NrJZ23kICutDwYc/g==
X-Received: by 2002:adf:f70d:0:b0:371:8bc8:ad5b with SMTP id ffacd0b85a97d-37194696ce6mr5802867f8f.60.1724019929705;
        Sun, 18 Aug 2024 15:25:29 -0700 (PDT)
Received: from kiyama.home (2a01cb040b5eb100f7cb8228474da207.ipv6.abo.wanadoo.fr. [2a01:cb04:b5e:b100:f7cb:8228:474d:a207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37189896df5sm8918631f8f.69.2024.08.18.15.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 15:25:29 -0700 (PDT)
From: Mary Guillemard <mary@mary.zone>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	Mary Guillemard <mary@mary.zone>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 0/1] ufs: mediatek: Fix probe failure on MT8395 SoC
Date: Mon, 19 Aug 2024 00:24:41 +0200
Message-ID: <20240818222442.44990-2-mary@mary.zone>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This series fixes probe failure on MT8395 SoC caused by LSDBS field
in the CAP register being set while the controller only support
UFSHCI 2.1.

This is based on 6.11/scsi-fixes as it requires the LSDBS quirk from [1].

This was tested on a Radxa NIO 12L with [2] and appropriate dt changes.

[1]https://lore.kernel.org/linux-scsi/20240816-ufs-bug-fix-v3-1-e6fe0e18e2a3@linaro.org/
[2]https://lore.kernel.org/all/20240612074309.50278-1-angelogioacchino.delregno@collabora.com/

Mary Guillemard (1):
  scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP

 drivers/ufs/host/ufs-mediatek.c | 3 +++
 1 file changed, 3 insertions(+)


base-commit: cbaac68987b8699397df29413b33bd51f5255255
-- 
2.46.0

