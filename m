Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1418158843
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 20:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712695202; cv=none; b=ZZF85soFw6HgBYMgh0/yKEDCusNfVTxPKBvWSa7X/b8AAhr4FuA6i9nhedcL9S43V3kwVeIb1IgGmNKHxO7sAyDdg5SxOIukYLkRWiParS79buctw6rjWejaTNGeyrRmYIVHgnSSkJd+KVwjkA/DIbZKJH8I0aNHHOWewxr13XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712695202; c=relaxed/simple;
	bh=yk2BDxM+7Y4i2zDVZmBIPZBAOJ1qHub6vL1uG2mZ+jk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A8CgM1x3F+G5YeCGF2jjxM/BFVBVaOBpgzJ9WttvaNUnJ3C0Lsinn8WQVlbXsVlgTphvUzuk6XQo0S1so6LcNPLlY1KnT3UG8Pb5Ck3uCAeWAYBqzDKjcwcUQLBkAAnEVHXWak6PtqSCMOlGMWSJUiP7H5VeXVaZsIJbjZGqLNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UHzE1cSQ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UHzE1cSQ"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41551500a7eso48764885e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 13:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712695199; x=1713299999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v4I8phARquuRtcJ9dGFSKVepYNDlwt0kz9QDOiZ7JmM=;
        b=UHzE1cSQKqEBp/pxy40KjElSwJJVlkuiCz15tbrinBYCAGS5lKxZriYqNqh1Ibnguy
         0GYZiPWSCmxu0niNsW0AthVlkCMDqhAFI5YM4+U1YGGMLuJl9ejSVYGGhsFBM/pjraaH
         vZ2rEbQx/5dhfqc7RQ4EFZea6HrNlkQM0W64v7anZvEn7dU0k7rExodTrQ9+dxkSU3tw
         8TkR6Yqpv1LLljzdNZOh2VomNb/vcR1JaUD/cUeSQpYMFDiqRSIBdMSlNhtmNokwrRBd
         i7dOCHJNwY0XoPnHuhowoNmtjnjk8EmOXcdaIoP8SfGA3ACehkw/GVtkO6itXZpP0Jyp
         tydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712695199; x=1713299999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4I8phARquuRtcJ9dGFSKVepYNDlwt0kz9QDOiZ7JmM=;
        b=HAxgINqM9sZzb6pWbmrtiIA6cuma22lbWXft9oLrHV4GxnHpmZ9XGPFUArXT9nEdck
         9sy+phuaVyFZ796ibvCrESdeLOtAJYsu3YMP09tWByQACFnw0mOPmMhVlNxF0NYCk4Hv
         /aJZ26Z+/FeCURHmViFfGtHAWarTuRW9eB8suYBVOcCUeiDPvJZBhjrnD7kNSkO8ufhw
         utQL87fahWBsIzATiBMEDRtM2rhY+lMDnR6dJEGcuouBErSEP7rWZKU2r77dv91vOaeW
         KoNyMphWxFq7wL+ofrWTQ1+JqTKYX7v7Zis0uBHBMrA6THq+N6anyHWKgPX7NvUkO9Hl
         8mbg==
X-Forwarded-Encrypted: i=1; AJvYcCWbGvvuHbNNu1ZQ7R3UCDcySzSFmZr34hLXR/Cqwc5YubR0/UZLgus7Jf+SvyBk1Fc8y9AVbmbaKmhXT1RtgcZVNoM3Ija6LQ21jg==
X-Gm-Message-State: AOJu0YwzGb/9BVbOVROUhvbKl7LrkUvWp3/iNMJdu0E3cKAilyXC+eBt
	wuTQuzrdtye9/Na68n94ZOTyGPbzRNtTwtpFs3W9BE0WSueMhmPhyO2YZxTcHBKpV3T4LjBhl+F
	J
X-Google-Smtp-Source: AGHT+IGeDCGRn+eN+K867Alrf3EerOJpky7viAd5Dpu+DzEMbQjNs30y2mzbObgPmejllvI8RirF0g==
X-Received: by 2002:a05:600c:310c:b0:414:102f:27b8 with SMTP id g12-20020a05600c310c00b00414102f27b8mr515611wmo.32.1712695199233;
        Tue, 09 Apr 2024 13:39:59 -0700 (PDT)
Received: from krzk-bin.. ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d56c5000000b00341ce80ea66sm12267111wrw.82.2024.04.09.13.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 13:39:58 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Will McVicker <willmcvicker@google.com>
Subject: [PATCH] scsi: ufs: mediatek: fix module autoloading
Date: Tue,  9 Apr 2024 22:39:54 +0200
Message-Id: <20240409203954.80484-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Cc: Will McVicker <willmcvicker@google.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/host/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0b0c923b1d7b..c4f997196c57 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -52,6 +52,7 @@ static const struct of_device_id ufs_mtk_of_match[] = {
 	{ .compatible = "mediatek,mt8183-ufshci" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
 
 /*
  * Details of UIC Errors
-- 
2.34.1

