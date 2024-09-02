Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3DC1A2627;
	Mon,  2 Sep 2024 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725288118; cv=none; b=mR168hCZRPA010ZlzYRDAUWF30vp2vae5h+0XR69seXJyTRxkonLQdDgk6LumTg2bDtWhuVSrQ6tQus9y+S8dHVoZ3HocvwIY8RqG4wNsmcmp8mRo7tTN5qdgmos67TzY7qH+/NOGgwuDWMJqfRuN4u5Ll2gx1c7J28mqf1d6OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725288118; c=relaxed/simple;
	bh=lzb1ZazmLEsALfcMax2ZZ+lPe0yXf6bsbyx2Poz/udQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qgt/Am5wpjwpn8mc8g/bDl9dSww+ibpfF4UWhoW0yEdUD6T3l/i6RGlLBhMKjpBfGgZIR8qZNwZHNd5GduEwdzqcseNBj0bZF0Cv652Vrb1qP4nz8a0v+7wfn+F3j8lH4/kAYqImQ5Erv0crzIfmP+ChjUjaU9szDj/zqVNVfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eN0CEyp7; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eN0CEyp7"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-374c0a8c7a9so1306537f8f.0;
        Mon, 02 Sep 2024 07:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725288115; x=1725892915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WWlZagbdo5OAaezYG6br8ZTTQPvSDcg07kSABaERzT4=;
        b=eN0CEyp7Cp4sHG3bN851WRxiSZYU/1NzmMeugc7ps3WGA49Xam53AMJwsYdtVdghXh
         8ngCAMF6GL1irLBjyOgOlR5Bx3u8L6AQzZI0ItI3kwCRb0V3VYoZFtpr+cmu5RFQn/Jq
         3medIrBjeoYUSCgszrgLEHbprWyC0q1IR38/OUtEkXFU136f+P+veOakMOW5aL9kWWPC
         LnDwXv3fa8VzKBGsfl0esw0eioEFjFQzXM/fs6ntxTRPLHOuH1dVOLhCtWbc7/iPifsl
         iOXoq5eIXGG6ccakfryzbvGdez2v09D/iD5Uvmd4fR/nUexgkU3QzG5iOxy8dQPJDyl7
         rlew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725288115; x=1725892915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWlZagbdo5OAaezYG6br8ZTTQPvSDcg07kSABaERzT4=;
        b=nCbPxvXh/mESFRI+mgHYGAl+b/XU4To0yVUpU9tOzhTeO0oVyH1WYhErDOo+4owu7X
         jzXNw3aLk1l1BSaT9BHWEsFPiPTJqlvrDu/hCl7dgEj9EX6HV7uDGyWNotvF8TacKRqu
         wxhg3NMKJupCfNvFMcATGlc0JKnPWIHUOhZ5L2p1hGJLI2zF7fGoX0BU2e5xh0CMrxaZ
         zU/MwhIe+f3lzl1KjS4jcNavH4MldkfUkP0tl5nwOMFl2fS1JIIiAgWHaoPzEwSsBY+E
         BMsDO8/sHit5vNgTZ4JbjJyciNoDUAkdhI3BJT65/WIhWEPQwuGWsp/ynsby1/+7DCUF
         DyRA==
X-Forwarded-Encrypted: i=1; AJvYcCUEA0YE8GX4vDZAoEziFkaNQ0350NBtMNzrOir6qnICGFLOn8XfpCen2J2iD8uoCb/0k8fwiGm882OOfEw=@vger.kernel.org, AJvYcCWNmlSkJlqvxubmEkS/c15pZnRQAULD4rTbYVBbKogMA2gTnuUwbV6BvGxAz6gF7+0GFf9A1kQYGM7FPA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHyu7dR7a+kGFDU9xXIAsOTh959sBUl5W3y84Iluw8C43lJHz/
	N5MD59d2NG/RsgqHN9Mnz4ajLMa+DjfBtHvEknY6noQ9gArxbJn8m+y0UbcG
X-Google-Smtp-Source: AGHT+IEaDbDBHJN8s4DMGUkMtDPHapHA++XA2ag5za8MkGXzzJPIbLYNDGzCw5gbPP1CanSxIWIUbg==
X-Received: by 2002:a5d:4685:0:b0:374:c3cd:73ea with SMTP id ffacd0b85a97d-374eccc2990mr173898f8f.35.1725288114581;
        Mon, 02 Sep 2024 07:41:54 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bba7f9f3esm82775615e9.0.2024.09.02.07.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:41:54 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Yihang Li <liyihang9@huawei.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: hisi_sas: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:41:53 +0100
Message-Id: <20240902144153.309920-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a dev_info message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index feda9b54b443..4cd3a3eab6f1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2421,7 +2421,7 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 		spin_lock_irqsave(&device->done_lock, flags);
 		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
 			spin_unlock_irqrestore(&device->done_lock, flags);
-			dev_info(dev, "slot complete: task(%pK) ignored\n ",
+			dev_info(dev, "slot complete: task(%pK) ignored\n",
 				 task);
 			return;
 		}
-- 
2.39.2

