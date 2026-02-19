Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBA0238C16
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 04:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771475990; cv=none; b=LMxXkGsibwlSVMFfid4uJEMz6yqJwFhmUhig54GE2R1EMRxUB+JODkRk3gTFpuUzojkANCH52v1NEs624Mkcvc+53w6zPPX79UiANdkJNijguUfaMuQlumzF2RVvaxJ0N+YKauSJv9eKobC0XlDaZKt3RgS2qCKF8pYqU06lQ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771475990; c=relaxed/simple;
	bh=ObbPzKcMkLFZEOmtX0HBbcQLzdXfZGKOceMbh+nh1/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xo6nbLw9MElPxmkLGSeH5bu3eGBM323kBUHIia1X1EkTlvIepiM1hQKscpjxCNiPhtj3HJ+g0xyboJCBFkCveTTTOCyXZiNBf98EcsguSmyGF4n8rFL/xA/Ahz28HDEc8jtSeIgNAXNxLkdkQUl/5UWZRoEFq/XS2UpH8Cb9FTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAeSg0Qy; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAeSg0Qy"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c6dcdc955a1so190953a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 20:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771475989; x=1772080789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TK2FSfFpgWRmabgfvqWtVYcxZdfMtKtMSre/uFQr/xo=;
        b=UAeSg0QyrGANPr9XQMKl92PwbhUuuTjli5GzG0K9m+FZ1JNyINSf7I+tavnr5iSYAD
         FXhORsL2XX3uGGs7PtIFM3VFL9nZUxpe1nmkn39piEblidKe3KkI9ZKoMisAUQIrTsa2
         aRh3u3GDdm8LP3zq1aejQBZADPxDdJoPitSv0vSpFujC5MYkseamLE3VmdAF/5ogesEX
         JaHeOBGpDWTsW23+lya4f9c2ZCDw6yY4zzy1po80Ag2xU0fpVWCT7o9xHLm+7toduzrY
         yBp6X9h2oLn9A6ZbM8sMGo15qjYYGBNsqs0hAgAcLF9nILwuPVX0/540SoVJDr1d9RhX
         BC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771475989; x=1772080789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TK2FSfFpgWRmabgfvqWtVYcxZdfMtKtMSre/uFQr/xo=;
        b=GAqTmOIVJKPOly4P3SXXlSaQs5d1f7ZpLnJtTmpmQHddv5W3LRqA0GMaSgzo2cyNH7
         p5/HfL23nJkzNqc5H0GeBghY3NGVaxzrgUiLfAn2n9hV/Ce5LAJ7efvbt6wo/0QapD55
         35iksOB7AN20C491KC86U51e/qtI0BxANssNcmZg6YgF5o8et5tIQRlewfdVhQy5hNcz
         wSGpYuAgzjPS5/7wBbdoGljTQpD9tP4oRCqn6+26Q61p0rEH3fRA+lFA83pKS9c2MVAl
         xYv+A5y/HufQOhwjY952e+/+FXvV+SAA9wN3uMLL9UU1hR3PBoKRSe5mlIlHB+vQyuZl
         JTCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtcdAMbWU8m1HuHxK+xIapVOZsUGqmBmmTKl5peObD6d/TGepe300y36vMYQBLoagtAkhBAV6VfbHX@vger.kernel.org
X-Gm-Message-State: AOJu0YylgbwE1Ajww9QQcGkbDODjPJxSOvwPsZ2zlR6aZx7/7C3Zkr05
	gmBQCQ+fu8w9K9BDvMJ9ZjgKSBowyMsHExUNsxwwH0HhyUVJ+hMsBCj+
X-Gm-Gg: AZuq6aJb+3QIWQBXFX3BjpoNiL1oS7+gAnWpC8QjSDN1fnA8VbdQLuMVwA37S6nfLlp
	K6WJVSz7DvdqAJiuxq2KM9qar75LbrRSAmOwtdWZSEdnsXCZDPFxFOpjISO8IppWj6spG2dH/Hf
	KwxWv9nfCVuXjUQAbZlEGPWc56gP6fzihcDurStfphXT0P7sQAM36MqsAf3jPlmTiIB2yGChA90
	5LIZdRvmVQJr66zjqUomjeZFdGQVp7hNMGuHVu7HdQzE33Q27Cs8pvufbJEwpu0A3VJtx42GDyd
	1TPBVyrp4kgxaPuJRfWTsLYEOTu1i/hRGlIs14N0kFBdaSM2c9nL+O3HwWfBVyTsrF8i1p9Olt2
	DZbJ9kzrqWwmgTsamRVsCaUL7YRvqO1Jmp7LUGbZu3Ea7ui2FUoAgp6uR/W43qfQemk60DzxH1a
	dUYFTnIeoqydW7kgnFwrvZ05wGyzP6Q4c8Pr2weUoPAfvhVLY=
X-Received: by 2002:a17:903:2b0d:b0:2aa:d7a7:8091 with SMTP id d9443c01a7336-2ad5aed3fcemr13876565ad.12.1771475989047;
        Wed, 18 Feb 2026 20:39:49 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([103.50.21.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a713675sm203345025ad.27.2026.02.18.20.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:39:48 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	pankaj.raghav@linux.dev,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 2/2] scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
Date: Wed, 18 Feb 2026 20:37:43 -0800
Message-Id: <20260219043741.276729-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260219043741.276729-1-sw.prabhu6@gmail.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <s.prabhu@samsung.com>

Now that block layer can support block size > PAGE_SIZE
and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
> PAGE_SIZE in scsi_debug.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 drivers/scsi/scsi_debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c947655db518..4c6feee87f05 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8495,13 +8495,7 @@ static int __init scsi_debug_init(void)
 	} else if (sdebug_ndelay > 0)
 		sdebug_jdelay = JDELAY_OVERRIDDEN;
 
-	switch (sdebug_sector_size) {
-	case  512:
-	case 1024:
-	case 2048:
-	case 4096:
-		break;
-	default:
+	if (blk_validate_block_size(sdebug_sector_size)) {
 		pr_err("invalid sector_size %d\n", sdebug_sector_size);
 		return -EINVAL;
 	}
-- 
2.39.5

