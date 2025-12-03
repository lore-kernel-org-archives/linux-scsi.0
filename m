Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6C329C7E
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803294; cv=none; b=uJOjwW7GEkJLNPNvAn7wK4bX1AI2+meZdV/zS1vwTE4KKhcxOBxD2cEg285NH3g0/nxNn9J6P1mOkz/pzVO3Po7BkiWtQ1XxvghOGqnjiOlq2DjYAp3wDfUflO7Q4V8kQu4RML14uYlaAr60J6ZVbURyIgK9KZXshM2k/OCQOW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803294; c=relaxed/simple;
	bh=mJKAm8M9p0GWE9hhIEfJBwFPkc3jhYYYYEtVCEWTXFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKgoubHYtJXnhRAlMFtI6qqs4ZO077y5T7fvDMSbyHTtEjjbN78vXFKM/HZeba4wMmQu7s00u8g7F4gEV/LubJxC7LEnUI0BDmFT8ukMHW6ODUl+JDuI9bEeaLnWnmTD2WrZd6IC73YufBOr6vfTrDXUBpJfQs4YJQ8nTFwVXzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=joE4DYVg; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="joE4DYVg"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so304400b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 15:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764803292; x=1765408092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEVPAlc5svJuUSmKl0RqG7MP0hET++VtFf6fF+uMCAw=;
        b=joE4DYVgR6MX0EmVe9Bco355xXmdBtnH5SIAX8AD3ubH4DT81/e45wFw0N9QxsUuMw
         oZCJjiSjEqBxdFWmNCXGj4cMHmpv2K0EvaNxvLFYJWM4zYXWDqzEa0YE8RkzCDKXhgTh
         ywPL0nWKWPdCGUXS7DeMmwmXR1A108FcP7NIi5XZLvSGr+2WtgNJ+PLKSycYZw5SsvPL
         fY94niFw5IyRwAevNI53UYRUZ239ia5jP4QPlKvlmZdQ6FKphav7HUh4j0D1xDqfqeqL
         DWeocUHEh+7wU6NQHksrxTqiZA0UZUL1dlI0B8alI/p0TNQgfrvhjoecPuisozH1RiCf
         uoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764803292; x=1765408092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FEVPAlc5svJuUSmKl0RqG7MP0hET++VtFf6fF+uMCAw=;
        b=iK8RfraKinclzoN16uMaODWB8GM/RoIgdMxnakp7kHLnf09Mt6cV+G2ksX5Xn40Cul
         3hKzR0UTrMPvqaeIEUHgh75vseiA4/0OwuZwI7+QoOpKIj8b+4WohBJdGNd0UtCCz1CX
         T55pc9012VGm3IDm8uNDBkn2nbUHytnhWFkcQyUPUa/kyUwYlc+ero/cDVWDzoDI+o+b
         hgB9n0EQVGxNrcBV0vLx4fOsztoZnPyVIz+KavW3TI+C0dEbebQ2jVwW3WLT+O8QF4MI
         7i92xitrPbBESdkp2NPup231IEGSCuYv4iWmz8S+TupED+SOPRO4IixcWxymVYahGAcj
         sXJw==
X-Forwarded-Encrypted: i=1; AJvYcCU7LZSzykq7d8u3JlMCMHpFvmgO1GvsKcxEO1SmJqHXxvdWnoo+eeI2A+zUpuB/WydUTSG2ayMkINFq@vger.kernel.org
X-Gm-Message-State: AOJu0YwiqTPCbOBbENh8NHlqVJ08fW0RALQxKyvFmGM4HTrd7+35v91M
	4d2sNzIeEyfnaA6ICFWlNIko7C57oR/Z/JQFMPWoN33f3kpCgoM8SK37
X-Gm-Gg: ASbGnctF7nfbhNOI71Nj+9dr9DRD7ASlNka3PMCYobQ+fVIXPdtP3ADBRSQ9vfaupE4
	RJEawbbn2VxrnRNGCikH2RkIoS2L84AQeInBjF80dIFEa+DPyeKQKb6YHAGhXGzRPrDcMsnRb+L
	rAu2urNbMHZIdkmo8m8jrodU+rl2Aq8Y360/9RqOhtqb3G5gM5+R3sIAmfpbrJuMTvrNjSrgcla
	PqhiAG/HHXtSV1uHyasU9vHC9zn7O80dWEfxMh07vIzKzDQ/1WqJsGxWx/cJyyzP1WwLapORGps
	6Tg+v8tN05BurwQhz2Fc0YKX7VcGvsC6xhZF6NuF4x0Xzk3cb2KZ+tan5KDLDRU9SGggtZiefsH
	Or8zIG+ppoHV7QyT+ptUQMANvXqp5A0NDfx5CEDR0GM0Pd/WwUfwpF4Bxs6xhqGOX6v3dGje2bS
	2Vlgo2Zsl6s9Q+1lVct5Wqy231H9fPono=
X-Google-Smtp-Source: AGHT+IF/KjPtW0QhOpY/Y+ZIh0GhdahqnUzws++tNEX3tQQLOVtZ6KA0TUVPAjq32YWtmRXo8qA3FQ==
X-Received: by 2002:a05:7022:ea46:10b0:119:e56b:9590 with SMTP id a92af1059eb24-11df0c740b1mr2585921c88.21.1764803291677;
        Wed, 03 Dec 2025 15:08:11 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcb049cdesm91535333c88.8.2025.12.03.15.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 15:08:11 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [RFC v2 2/2] scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
Date: Wed,  3 Dec 2025 23:05:47 +0000
Message-ID: <20251203230546.1275683-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Now that block layer can support block size > PAGE_SIZE
and the issue with WRITE SAME(16) and WRITE SAME(10) are
fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
> PAGE_SIZE in scsi_debug.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 drivers/scsi/scsi_debug.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..b5839e62d3bb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8459,13 +8459,8 @@ static int __init scsi_debug_init(void)
 	} else if (sdebug_ndelay > 0)
 		sdebug_jdelay = JDELAY_OVERRIDDEN;
 
-	switch (sdebug_sector_size) {
-	case  512:
-	case 1024:
-	case 2048:
-	case 4096:
-		break;
-	default:
+	if (sdebug_sector_size < 512 || sdebug_sector_size > BLK_MAX_BLOCK_SIZE ||
+	    !is_power_of_2(sdebug_sector_size)) {
 		pr_err("invalid sector_size %d\n", sdebug_sector_size);
 		return -EINVAL;
 	}
-- 
2.51.0

