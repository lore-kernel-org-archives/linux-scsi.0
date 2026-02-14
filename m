Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250721A00F0
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2026 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031981; cv=none; b=rjv3jKr/0CKFjIo4Lc91rg6EwBWKRcJm4y0eMF/+MRbbyvZHdZHBN0nr9+f8aCrLHFsaeYMN3LbdxoMhrh5OPlroDSnpJyDCrJptFmSkbduHFk98g9YHU3yqf26OHtwGEFOl1W/OCoWKsXa3Iz6gSrtU9LqvjK85Tz1H9JeCn/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031981; c=relaxed/simple;
	bh=AdiN4kJ4lWQ/oIlSgUGfi5JSCMjnnHuNZPraS5k/xuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IJPRQXyvr4GX/IHF8X9MfErNKLWDKCxQCLuQNzL0SwWrLnKvOl3iz//oPVYkTVmtDzgbomuXdoEex9qrbUhq6DzafNXAz9bXu5EewAUW3Zd1ywkvbre9SdJQmpmgV6XD7ADClV0UTglJfLfNnkZO/0lndl0v0iU+pRS4wrCmJB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWBOqSNb; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWBOqSNb"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79495b1aaa7so15796637b3.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 17:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771031978; x=1771636778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxxDqb9sCehr4aY04ovS37dZDZh0n2wPFLedvk9CKcw=;
        b=XWBOqSNbTkNb0DA9RoZih0lMISTM8kaCs6XbbFuxlFopcWYl+D+FAVMwuFiSN0mI8x
         8qYHxjXRydKnIt13pn4JGIF6G4Op8Sb7umNL/DCMbd8XyLgCRQHkPU9sVbQR2nOfT234
         0680UWVaBjeD8LS+76vxWD8T8csuPFObUAErhVGyhrn0tcYkdP2ssvVtJVpFfrXsJm4A
         E5sb08xAUMQpsxzYVZcxVYhyHR4XFEi6mxvz49+yasvXUVbQnXrgewvtqeLy/KLdbEQj
         24TylSJ/IELcFn9oliDroYs7TEnOHGmAQP076IeppCsKMYZpxQVjREagtIQB17cOhvvo
         0poQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771031978; x=1771636778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rxxDqb9sCehr4aY04ovS37dZDZh0n2wPFLedvk9CKcw=;
        b=XPR/bWsGwEtvclz36o8k8M0pNsGvoGPsDs2wkOcqAzqMvf53zvzrccaiZbTEn5G2qV
         5BpOXOnYDHdFe4rM2SjbkdUUOwOv7tQqcl80GP1jmgoZWz+uQqO9ixsxdkt1S3dwhgV2
         RFLLWey4fN+o/m2h4S287dTMD12ta2Acr0TbGhpSwAISo5Cqg/4EJVPkGV9sF5DUnaZa
         wB2HagFBPJBnN7XpWt2g0roUwRIHvQoVzthBqr9v03uLMUmX40jjxdSoEbOqLyLYv1KT
         PLyVkG2U4WJsAAG4TYNg/UPqFDnYlKnYeDi4vHpIZq/D00j5OP4pgfbkzSIHSJxHJir7
         3MGg==
X-Forwarded-Encrypted: i=1; AJvYcCVsKSoiSLovt2y6a0lVkEVXvby5BNsNU/0fu2lTfk4itNWeCYMWOZW/s1wQN2Pb08tCGNuuU9rC0ESd@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrb8pQVw3i6Ti/TbIhwEzkuUL+CMxsGmuWoU/ybyXK8W9zwBOf
	wUm5LQLdTJZttZXyEC3AMGET+4Y6f6qHRMd5zeaG8LZJuEt8zIZhZo+W
X-Gm-Gg: AZuq6aLsgjCFC2naRAF3n62//VzPpXpWOC+6AfXa4n3wugwMzblLB2oJqkPuo46chW4
	Vubp/YviFkTxsgOo6veL7mFZPZW6mL7ZmYJFWr+WKils47/seNgjihxUFqahFwO/7vCBQAdbS7W
	fOFMOkHlShzk+5Okn7OiABgl0GexMyf+eagQQqTWGSKiFMvB8HOx8yyJV1o1bD6ah0awnPNlSHU
	Yj6Zfat6cDTt56Kc/JceXcMF1G8y9FhhtkrvYKyt+tJtKMc7JQoZvEWt0TPX2RuV5xXUv0ws7O7
	fs5pzMfxpmeXpV/qbyA2RpszJ0gEyeT/oD4vwOEfTY3g+2lqajAXu7lSBF7EH+P8PKz6KCzqoM6
	Nv70cvN4H/fa4x0SwyJVAf3eapzTisYsNXZpPcJxdHrsNk6GbC5f/cUuXb5aU5THTLOARlN6uA+
	G1AGxbF4YgXaTKwha1vItmxPPHbs5T58cbWD5A9SsN4uNi0YfVtFzJ2B27fA==
X-Received: by 2002:a05:690c:f81:b0:796:3a4f:68e4 with SMTP id 00721157ae682-7979e7f071bmr40554807b3.17.1771031978165;
        Fri, 13 Feb 2026 17:19:38 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c177773sm77655057b3.2.2026.02.13.17.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 17:19:37 -0800 (PST)
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
Subject: [PATCH v3 2/2] scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
Date: Fri, 13 Feb 2026 17:18:30 -0800
Message-Id: <20260214011829.508272-3-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260214011829.508272-1-sw.prabhu6@gmail.com>
References: <20260214011829.508272-1-sw.prabhu6@gmail.com>
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

