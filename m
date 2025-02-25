Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211F3264A93;
	Tue, 25 Feb 2025 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740478340; cv=none; b=LcxkLKKNIK5iO/3UAR5srdrDehsOEOeQfwXkrC1r/zDQQhV3y9TYaomB8F8RJpsGO0rLR9RqkwsympTv3lR5NzcTuZGRmq8lYiZ9p3l2v7d/1A4csMGVHX6/qPMvekBLjnPIkFmX6v6ZrzwN2ufn4Qd/HlHLTsDHLMwB/e4ap2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740478340; c=relaxed/simple;
	bh=hE+OYAFm57UzumtsPo2MCdm6/Z+qyVrO2i/t3SAQ7g4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bnFQ+RYtRK5Lf5lO4brOlw1h2sOddKM/RP2v6E5RHDuAojt7Zdi6ZTpN5VGD/oVuquHHqY3jY4/i+hy0NYsjYmaqJYV5fv4fi286CQU+OyQbBGvH92q3lvJMNL09r2glIbzEJws/Tj2LZb8Z4QfFIDqhC7vA+dJXH4JSJXIESaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QeOzjdX9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QeOzjdX9"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4398738217aso47041475e9.3;
        Tue, 25 Feb 2025 02:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740478337; x=1741083137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8f50ReeNO2ewLKOc+m/ce/otGU09DrlDIWdxnZUlcMA=;
        b=QeOzjdX9Nl0qR8npHnpjLxyoKy79GpJsb/DfC7m+empx1maOxQHC8znpRtFt1xVLJq
         gCCMcSP5lIesniyefDAhtI3S36yWg9foo/24skz/IcnugPtkJVqg87Cr0sTASJK0vb/7
         BQ35wf9Rk6McK40tfyEeTlyMZLOg0iomDpjpMy08ewlA5fGTRpWktQtPqTnW/dkFT4s8
         +/X1L8kL92T1BKwz6zVDqFYuqzeq3JDWPiCtVCIBs/DR0aGBqGNDOoxlxasCqppzSxWs
         4Y3/wNE41SA1k/PIC6SLJx95+A3EYEBkkUCKeT3Cih3aAMqKCvs2ipOY/CZwMOqExjE+
         yX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740478337; x=1741083137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8f50ReeNO2ewLKOc+m/ce/otGU09DrlDIWdxnZUlcMA=;
        b=gpNeYP+/8ztTFbAbYMtP668CDPSwdZ9T4BMy5SSBxmPlo5pZerIlMuc3lc/aWY3CHR
         OfqD+Ed2CA0tVec8fal4sUdv117snp0CQ1BR1mZoPcoeSLLXxMTU0WKZyG5+2Mt2/PAZ
         Bq2h+yaHXlGo5oUjx4N8KSLkvXkI+YQPK5MvSaxdlMXQ/tdqNSMerQRGv+W/BqNGCbzV
         uALHWX+cWt+rdvwA8z6hhLz5KaUSWuO2NyHDmH04EkuLSPzzGCklGU7JFV5vh4oHXMYH
         Et8k5LGBnZKeanLThGy+g/E6t0xXPNGbNixeWUYW6cQgOkuBGsbpVix9UBIVYrSOflqR
         roHw==
X-Forwarded-Encrypted: i=1; AJvYcCVDALv9x61xllZC+oESfwcsNDx/EhRVcbnUV5CuBlrPgnf2j8CsPlor5xQ91WB9Gc9M3REUkAN/ZZnU7Fk=@vger.kernel.org, AJvYcCXdbUk+mnU5ArzGyu63B3gRdtSuK0XuouerrKITyLWmU63S7DtvWhyHRWGXFZHyZ810TzPMHB/p5bLuzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMXqMb52sLXwJ4/J4zMfDNSHGE13wR0fvx2Wo7zBUeLOOj/FQP
	GdV5B3t3R7fC9of8xH6EbrX3TU4UBgr2jAmQyNIdTtpDRTu9PLIz
X-Gm-Gg: ASbGncvHV5Xe8Qvu1jUIKpSOAptiDQOhHOykQG2bYnUyLMaKRPaj50wMn6g+4Kx4P22
	HB+xfWLTn/D9QrBjVHf/nwl5s1aQ/6bMAAUDk8GxHQRhH8t12s5ig+Jtz4PnJNC7WftljGQD3Yz
	7RwBSSWx0Qv32dqZs3x80K8QZjkjIKo6qD7+UH/OUeFCT2l7/YyxveMW1XGSGtbQhtiBcdtkXWR
	mPG/RtD/HT06idZ4zM8alUJ41lhDvDT52Qt8Cx6g1l8S+zaRhcH+B/k5B0XOJzFKVCBiSPkOkSE
	nhyzoY2yLWwCvbN9IYKSqLhyYfg=
X-Google-Smtp-Source: AGHT+IH3M1TCXeGQjPYelk3PO2DOrAA7RTWE9FnFRNNtZ+SU4MlPMarj5Sh4XgmPSVxXCUY6AifVTA==
X-Received: by 2002:a05:600c:1390:b0:439:9274:81dd with SMTP id 5b1f17b1804b1-439ae1d7b20mr113737095e9.1.1740478336758;
        Tue, 25 Feb 2025 02:12:16 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-439b0367577sm134605925e9.25.2025.02.25.02.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 02:12:16 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: rockchip: Fix spelling mistake "susped" -> "suspend"
Date: Tue, 25 Feb 2025 10:11:42 +0000
Message-ID: <20250225101142.161474-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/ufs/host/ufs-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 5b0ea9820767..dddff5f538b9 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -307,7 +307,7 @@ static int ufs_rockchip_system_suspend(struct device *dev)
 
 	err = ufshcd_system_suspend(dev);
 	if (err) {
-		dev_err(hba->dev, "UFSHCD system susped failed %d\n", err);
+		dev_err(hba->dev, "UFSHCD system suspend failed %d\n", err);
 		return err;
 	}
 
-- 
2.47.2

