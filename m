Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666982C11CD
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770774707; cv=none; b=G9DaMngvk1Ut4rUguD6ryu5gMgYcMEoC7gHoaI8jS12VQGggcQUYVyt2sH8OSYJ8oL9vUCRNh9Bc/2WKpKFCBKvxAPkYlIXVCHKotoshPnIPhEP8Yf8i7TVBrGEPRq6WCy4t0ENVYTgzmPyYtzkTzLuhsNQAH7XdfhC7Lfw4Tvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770774707; c=relaxed/simple;
	bh=20+9y7YQsMaYpLIF1xi4kLOE4zsZSv0FqYAUVC9dCIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EAmFcGo2zCslI01JJwaztxRFRb7A5OgJKn0Xe+8Oe/z17TDWT6MYCjj8rWTN6FQXsa324PGxqEVif5MnVVBrxcUX4ctmJ0pi1xbOGPlQFeHy0Rgl/se/spGnzsOa15hMpysTn4vojRJiVCMn+mKDr33C6J6SlTw2aDRi5aACZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6YMjUZj; arc=none smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6YMjUZj"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64aefa98fe6so1650326d50.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 17:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770774704; x=1771379504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwRohyCczQP5APpYBp0ujf2bOM2ndalqngFoPQX4NTc=;
        b=O6YMjUZjBulL2QD9hcq1wZ2RPyQrCTjIhHQoumE9VwTDjbKisEwP2U6hhqevnavVRW
         qR3M+ZtwLMH6KoWxyWI3hdvCYViW8pzQ62qEkpEuxTDJ4tDczcb2YwiBOEvQm1BiG8pl
         0jpQlJEXeYfOO336ewW0TXJGzv/ejZMYAxKhqsR3/ireIdyUDE0Ae7Mm4untvjwN57Wv
         vt9+arXyGWSt35zAaERDcckLhN6OSij3QwNoi/kDoCJuJ+XoCunyjCCIuNekobz11S5N
         g2uZYcGmtWrac/S77fB4tKKwC32v/Sv2ooowEKVP3jEdgqbAW3mLep+jyokVRFGZA8zG
         lfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770774704; x=1771379504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EwRohyCczQP5APpYBp0ujf2bOM2ndalqngFoPQX4NTc=;
        b=w0Tm9s30PNEe9Kjm4bYaCdtPVDwquynvSPk+83gyeNxDHNbogOkmr8AV8YhRJtsRHg
         fe7e0l4Gm8foyjFY0KkZeDUNOUQsKkJ1kkwu3q9MyZAbTsvaRMcUGlbQIhCc2sSbV7C7
         fjhfENq4yIPDfzCVeRKNs3hggmdeKefGtpKN1KvhNmhcT7Nc5C9lx1+caIkRM7jz4qN+
         BxuSMqW6GCiZqxIJbcH2frOUgNTwrW+mm/F9gYF5D8mzysjyBuUlAI5Z0kFOCzX9nRy1
         ZEo5nxFy3DOBBYPH0ZL5tox9oAhRE1PPdiiM/VDilUVSjt0/70WWa9WHEdGBbDjTNj9c
         ljHw==
X-Forwarded-Encrypted: i=1; AJvYcCXB/bkFMQomrSpdsLoRrA5cn7hiYVk1vO/ZC3pQ60KbysMfYJA7iZFAabP7uOHkAYL9cCLBdaln8h/M@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5h+99ZX03K/3TZTe0PR5NLMD/ZbTC449R9mO/0fyU0Og+QWso
	L8W6gX0IydlYuvUESoTg5CoptjbfF6b+RlkalOVq0JFXwhCEftbHcR0X
X-Gm-Gg: AZuq6aLx8ejnBMn4x24U9YhU2ZFBWzW52iCxh/OG7UGouHoDwS7M2YwnftBAvz41J8e
	4PXM3mYtDiEexWe0eMowXZMZyrIvVZujoW9r1zzGZO5dJHVG+Hg8fg26rytgJDfNpYyxI+aaX/x
	Tc3Z7chM8yhiiU8SSn4q4+pOp/WAnEYOd+H/71soKrK3kgLIWeTt0o5i01wH9If2kjVnneGG46h
	9uHJ2rGHA9h2ejw8Ce0tO5lU6u2AKwz+lPhkLFvYv12DIMpllZhdmML7/zYZOaZh1b8cGDvXuxD
	ZW8Ejs0Pyz/KqJus0//YgXzaHe4MVTwp4BUR3yJWp0QMZM91qY6u+SFqc6g3lZUewscb5bnwTUx
	L76Wes2xUjhg91u79y8klCQoYmQ7l7uRowbxbxdYMb0ew+uujZl3kv/nTfmocEQH0kNn7fkJr+F
	z9a2TfeojuP1wnaRH/fSE65U5/nXlL2UhhMjBWzTGTtr1Smac=
X-Received: by 2002:a05:690c:46c7:b0:796:4ab9:f29b with SMTP id 00721157ae682-7964ab9f356mr151505747b3.39.1770774704462;
        Tue, 10 Feb 2026 17:51:44 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c16e7c6sm3751557b3.1.2026.02.10.17.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 17:51:44 -0800 (PST)
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
Date: Tue, 10 Feb 2026 17:50:43 -0800
Message-Id: <20260211015043.2608866-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260211015043.2608866-1-sw.prabhu6@gmail.com>
References: <20260211015043.2608866-1-sw.prabhu6@gmail.com>
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

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 drivers/scsi/scsi_debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c5085e6d2e75..91f42b7e68aa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8508,13 +8508,7 @@ static int __init scsi_debug_init(void)
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

