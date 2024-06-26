Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113BA176AD5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396869; cv=none; b=qGgK0ibRjSg5/dLvlgCckji/pSbidHF5lJc1HnnaZmNl64eyKgQJ/ASSHfmOrm78sHjTvwm6iYvR65IimlGX/4VuyjjVEQKoUmQ8TLiWXGSTJgAhysEQKDLl4DoSazmJDfNMe6Zee4qHD8a39P3D72rhJKICcWTjV92aBCAROH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396869; c=relaxed/simple;
	bh=ZUu3pQzVsqGNAAF+6RBWn1Vcx/FxQ0DS3kuPtIAajrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1ARmfkl/civ2WKaRfRXEhF7OzuvsK00t+RgfoaiIunw337hF5QZoO7kf2Ez1liRLrsCQsl6LHNITw0A/O5Qb3xiMDzy9ITWzftR6poatYQO1wrabiksc611ih0JXFbh+mpeIB4ONQTtAkhfy7iDx5EMyiSdF5SBRngMLDDp32Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7h9oIyI; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7h9oIyI"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70671ecd334so2991922b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396867; x=1720001667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8sYvE7NIBRGPL3jKH06ljE0MlVAbByZlEmhsz0GRWU=;
        b=Y7h9oIyI4Y5klS3MoJN8HqqfoUSkRynFNzE9h2KHhsH6cCWmTmrtyo8/hq70BoXOdw
         2rRx5E/Uv0mMujsGJbrvy3Qile+jX8Y+zn+eAGCfwps4uwEwm76UtihMnnl3a9vL1a3Q
         hCMCVrIuy41Hr6wrxG/bex0rWC0y9OxUsTme+TyUFIw/N/CV1p8/wRO0Rzwxu1wXY6WN
         pi3ZGAbxPBEb6i34NrQ/mztPu6Z85O3EFsPtzC62Zz6Yr0Iq3HvOMZJKxzcFGrIZtICd
         ZJZeZsyzYPtXgPr0klPg0/MBy7ywtMlYdT7ILJmhw8TQXiW9wTMnTY29uMiRVNV5qqB6
         neZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396867; x=1720001667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8sYvE7NIBRGPL3jKH06ljE0MlVAbByZlEmhsz0GRWU=;
        b=vn39Fz6ZrIPBWpVvCO1w7LqJwAnUXqfd0u6j65wAXG4Q2DMwXt0LbKx7i+S+JiKxhO
         ECMFQasnjJ4Qsnk/rRz3us3E1kpHnJlSUxJ8iOlYhZ6d+r/dYEwDDrAY4fTt3V+DygVH
         iR6YaIn0Kw9Rvnsnv+GMX8THC4Qld64UZv2Mz1PESvyHyYcvispdy4/mq9BnqnMhwrdA
         +pvavhI44Y7pIwbHHpJ7V7FELs5yRM5jDrU+OaR6hn0RHFBCzQDUg6HiO3Mv4JyzWjnu
         Wv+TGEruM8D7IS7mOJsAb9/70kVfZKLHqNttf9DkfsW3RI3wOYawr0ktxSgNzXCiDiM/
         3IVw==
X-Gm-Message-State: AOJu0YzQCBBqy1hJb+r74/CWuyOdTFeAPTIo2QrvnkZOIcx80cvuq9aR
	JYycoAtz+Fx0UMP9cd9V1pseWItpxbDZ3vp5HtilzMpLFWR5jckUgVpq0Q==
X-Google-Smtp-Source: AGHT+IH7SiY9QD8pXdo62uO0X1Ovuy0u8nxi8+LJEdz+x0qVeTJSfOr+53Fe8OjYqqaZzBbwG+WBXg==
X-Received: by 2002:a05:6a20:50d1:b0:1be:cfb:cdd1 with SMTP id adf61e73a8af0-1be0cfbe724mr1216219637.39.1719396867168;
        Wed, 26 Jun 2024 03:14:27 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:26 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 09/14] scsi: ncr53c8xx: Simplified tag number calculation with max() in ncr_sir_to_redo
Date: Wed, 26 Jun 2024 06:13:37 -0400
Message-ID: <20240626101342.1440049-10-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/ncr53c8xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 35869b4f9329..863139c98cce 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -6410,7 +6410,7 @@ static void ncr_sir_to_redo(struct ncb *np, int num, struct ccb *cp)
 					"CCBs\n", busy_cnt, disc_cnt);
 		}
 		if (disc_cnt < lp->numtags) {
-			lp->numtags	= disc_cnt > 2 ? disc_cnt : 2;
+			lp->numtags	= max(disc_cnt, 2);
 			lp->num_good	= 0;
 			ncr_setup_tags (np, cmd->device);
 		}
-- 
2.45.1

