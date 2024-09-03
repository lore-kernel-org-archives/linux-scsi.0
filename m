Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F341B1C14;
	Tue,  3 Sep 2024 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725383999; cv=none; b=byais/hTwqeORkShw1UQgGHr3QF51mSJHd9uPN5w9c1A1J8umTEklJH+ljQIJicbtFVtKtBBRjmSQgfKOAXCtV4MhvKEqtoFuvT1iK9oDQczaOSbHBHnu5RSQEVNaykbc0qoG7olOAogpMMh6LTuym7te3+VAl0jlWaK0jY+KMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725383999; c=relaxed/simple;
	bh=nRZ2V36ig2VtSBPxHVYItft25PT2WEBXHd3mI9pDF2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FeRN7SiHO30mCOwApwLj0C35pTUMLW8OdvnhadLe7LjamOIwg8v5ewEevJvPDDHsUeC3c3ejhbLEGgGARwgkskuT9yxIRtk0cg5yhdJjqHjp60xh6W/WKcMgwK8VQY0JTTgtuIhNbMEh9341XJHK12WYLhGpA5pon+v/v6sHrMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJSiaHTo; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJSiaHTo"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5e172cc6d66so1221090eaf.2;
        Tue, 03 Sep 2024 10:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725383997; x=1725988797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qtH9IPamoorP6Ga02exdlUhBBWCKetzwMLalE6WeBhU=;
        b=mJSiaHToB8MZFOo3RhlSdwEUBDcDR6K2J2+kSXsr7tcbSCQYoRkxUjOU9bgOgTs16u
         8CQ8LNwMuCjPx+bF6tQzNeBrauRQ1PO95S51q1gTfX+GiwRb/43qJwoRHXzFkj4UFmjX
         Aivos+dAhL+g/zf1t6R0iGM3U7818QqFYYWCRF7F0fFoWr2eVcBN0i4eJnyvpNTzIxxf
         oaaw7XLlnl8bHx+eH8bLE1eskBnwuTwnFeJwIIt9ckpWncrc6TXVgEx8uQcaM8KtGtN5
         WHRQpFl5DbYy4bApJAovFGHHvFifzIvBdTSXdQU4sKwp+ZuMuNJXdfsYka0hqMyR1MyG
         uU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725383997; x=1725988797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qtH9IPamoorP6Ga02exdlUhBBWCKetzwMLalE6WeBhU=;
        b=L6+XMRXuYnLLp/IfEBrkpuW5gd8NpGDpK5raJ538YZ8V41O/jsDjj2lsI49o6gus1U
         X3FefFHYiLTImrfi5MhjwaWqinFpLYSBWWReN6iLs8jOBqn2uFC/Cd1KbGJEiWlO2H+4
         Fw7r7dnVFL4MmpR/3o9b0sIAnvnc3WqjsvNymu9M/D76LKTFs/ba/fMy7YWG1E1uIciM
         UfsogJtFV/czmvfNH2dR6p2XVzVHLPVUnuca7jPfbHQTKghgV1uv5TdFwNhOXzYDTs/y
         wvBUIGnwsmIiK8AjH+eSuAMVxfsEklb07wwYZo4YQsIe1oRvIE60rBaJ/BWct+ErwW+I
         aCcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWVp0F0Yjuo/JUiAuh00EG+ZqFpqYyAPhAcWNjROUcYrFmlTXix2Khi8q7iyqeru/BAwBlFsOuX1tsBnc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdY9lBZncervDuIMDUwCsYg2J0OWBR5BRszfbqC/nQIvg3Dif/
	VQ2z/WW3D3aIN4suT6dBDTayEBxM6INIBebegeaHUVVgBa8KKgcq
X-Google-Smtp-Source: AGHT+IHfFv81FL9CWSvPRuQ1Ag7YXMFuM3Q4pEddxacXVQIp8ZecgE/XViB7Vu+JuEFaKiPp/R58XA==
X-Received: by 2002:a05:6358:783:b0:1b5:a34d:fea8 with SMTP id e5c5f4694b2df-1b7e35ecda7mr1904005155d.0.1725383996838;
        Tue, 03 Sep 2024 10:19:56 -0700 (PDT)
Received: from fedora.. ([106.219.162.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d4fbd8aab2sm120044a12.20.2024.09.03.10.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 10:19:56 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Riyan Dhiman <riyandhiman14@gmail.com>
Subject: [PATCH] scsi: aacraid: Prevent premature freeing and improve memory allocation checks for fsa_dev
Date: Tue,  3 Sep 2024 22:49:11 +0530
Message-ID: <20240903171911.9197-1-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the allocation and freeing sequence of `fsa_dev` to ensure
that memory is not prematurely freed, which could lead to use-after-free errors
or undefined behavior.

Changes:
- Modified the order of memory operations by allocating new memory for fsa_dev
  first and checking for success before freeing the old fsa_dev pointer.
- Updated the error handling to ensure -ENOMEM is returned if allocation fails,
  preserving the existing valid memory.

Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
---
 drivers/scsi/aacraid/aachba.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index b22857c6f3f4..f3fc9b622aee 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -490,18 +490,14 @@ int aac_get_containers(struct aac_dev *dev)
 	if (dev->fsa_dev == NULL ||
 		dev->maximum_num_containers != maximum_num_containers) {
 
-		fsa_dev_ptr = dev->fsa_dev;
-
-		dev->fsa_dev = kcalloc(maximum_num_containers,
+		fsa_dev_ptr = kcalloc(maximum_num_containers,
 					sizeof(*fsa_dev_ptr), GFP_KERNEL);
-
-		kfree(fsa_dev_ptr);
-		fsa_dev_ptr = NULL;
-
-
-		if (!dev->fsa_dev)
+		if(!fsa_dev_ptr)
 			return -ENOMEM;
 
+		kfree(dev->fsa_dev);
+		dev->fsa_dev = fsa_dev_ptr;
+
 		dev->maximum_num_containers = maximum_num_containers;
 	}
 	for (index = 0; index < dev->maximum_num_containers; index++) {
-- 
2.46.0

