Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01A52F42;
	Sun, 22 Jun 2025 05:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750571868; cv=none; b=KFJalgjRs3ZXdQhmiUbwVtofKKBiLfnFgrPvgSbIgJ83rTAzb3s0FIYYwCwJsWbEDh+uvqnJE957cKcAYex2AElXx2lJsURvilhsaYHS3G4xbHl1R+B+uUHQGKhzzafc4BZT6MR2SCJ8p8LAcaWEDN8mEx5pFpe76h/gU8geXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750571868; c=relaxed/simple;
	bh=l9l87sZf62pg5/dTBE6/y8SuF5Z7ql7BaMW5Ex2MJLc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lgZmUmpRFJc9lHJlRlS5AsVVYpXdBwVU68iIfm77vPKl7BaLzM3GRjL6uGp0L+v9RMDbUFtQaB92v5suLAZz4bD2aT25sP//DdyYy1um8tkdjP3/fy9r1F+x3hPNQQ7cMtyrQ74iu5U1BRS3GV4kSZeJdhdjDy51AZxqQTYe4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cUl4CRuq; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cUl4CRuq"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-236470b2dceso32568735ad.0;
        Sat, 21 Jun 2025 22:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750571866; x=1751176666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m8TXebLUoEWcZMAmOu6HQ6oFbM2pQE/lBu07ZCSxO04=;
        b=cUl4CRuq2Mc5OUe2fHC4kiO3xVqbbH+jpMcYh6HelGX8GuSNeIUxmLRJpWxdLiSO29
         rfNwBGIDQFu9pqQSIuFzkowoJLkJ4fgi+Ink27Sg+t7/G2IbP0RrXrjVsr8I62q5lTQo
         aEVmcNpaoAzQ0GNvvaZRLhnRrnjBPRhggEDEPPAUx/3N5ZZyOcXySZWnbbWXTTVA10YE
         ipZDSc2z5T2Qrs2qyKXCW3Yjidi/gCXgwmMqERqtGXbCYrp+MuoZ68y5cy0TLkXqsCBk
         5PkkBvnU9U9e3JO+u+59+NJn6RQtQBRWUXX7L9MzjAnTQXFsZ7E34a5lorDJ+Adkvld+
         a9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750571866; x=1751176666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m8TXebLUoEWcZMAmOu6HQ6oFbM2pQE/lBu07ZCSxO04=;
        b=kMuQUEqilO1eEiscakwNCyVaILpqdYN98F02S0kmieAiWix1SSCg3AterZubpFhE9s
         P3l75pkw9LVX/498gCo4eUsNJ4qg7myDn7hgF8uUlBC3sAEkDeuXoacTpQLn4k420+3O
         xJ6ZmAvBTQ9qB5GgUXPPGV2KO7EnIPyWK6Zz55x8pxnkodk7ko1xA/+xTE4fk8IVIwKv
         VpbHdOUpqYYyUm+neogdaWgtXM1t3XMOj5kR53XpGNcmxlXJSHIAG3/+P+7KIDEU0rpn
         /DksDZdNoj905ej4RBeIYlk9P8YNye+sLVcFjnUzT393+45lPp0CIFdRP1EzA/PaBYVw
         cxlw==
X-Forwarded-Encrypted: i=1; AJvYcCW5N6g2cjZAZKhynoumH/DGY2rVhiAfgtA4uThTzjRUh9XpQJoyukRZZRXGywaZJnLBhHg/L2lzB2dxFQw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyolm82u1Czdx1wTVnnj8e+VIujFbnkBzKt6SdpyjdZtG1/lJTg
	kDtOF4KZKolOR4nVdl7vgBBDuQaD7DyT2MdTIq57L/5awYQfGABzZt+b
X-Gm-Gg: ASbGncurpUpy7tzMXAFoua45d6mzc06TOLzP/mrIHsBfR7U2v7eHCZaO5jlrBdWDKh3
	0IZ/vZpnCbBpLwSRPkcpHHwcBekLMF0NfbhQBTQTCxD/GTN07AoHRZVhMwGuMD7ZcF2g+67gZWj
	fR0yK4yd6PHpVzSMBZbIKpPT+gRgbanR7EqHNTRnbKm5ndL2ZCYnCL95hjYZ388RX1w4MM0hq3Z
	pdtKyhPnRbLRB09pHwMbCwClV6Y6ErhWOafci8GfN6bOM+EuZdoiSrAFWz0XhPT+BdesKz1bErl
	xSUOg7+PI33fPFAQS/zMooL0XbEvqLGMFEzNZ5VB2wFwUhng8BlODdI7PjRz0jEq
X-Google-Smtp-Source: AGHT+IF9vTLfiEh5f47Ro879/ivmDlzccHfFh57S+898X95YcqRleEO1lmO8SRBlY0GQYVrDLn9GCQ==
X-Received: by 2002:a17:902:d483:b0:235:7c6:ebdb with SMTP id d9443c01a7336-237d987aa64mr151858455ad.10.1750571865839;
        Sat, 21 Jun 2025 22:57:45 -0700 (PDT)
Received: from n.. ([2401:4900:1c0f:2858:1595:9335:9300:7c1c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d868f878sm54683605ad.184.2025.06.21.22.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jun 2025 22:57:45 -0700 (PDT)
From: mrigendrachaubey <mrigendra.chaubey@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>
Subject: [PATCH v2] scsi: scsi_devinfo: remove redundant 'found'
Date: Sun, 22 Jun 2025 11:27:09 +0530
Message-Id: <20250622055709.7893-1-mrigendra.chaubey@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the unnecessary 'found' flag in scsi_devinfo_lookup_by_key().
The loop can return the matching entry directly when found, and fall
through to return ERR_PTR(-EINVAL) otherwise.

Signed-off-by: mrigendrachaubey <mrigendra.chaubey@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a348df895dca..e364829b6079 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -269,17 +269,12 @@ static struct {
 static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
 {
 	struct scsi_dev_info_list_table *devinfo_table;
-	int found = 0;
 
 	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node)
-		if (devinfo_table->key == key) {
-			found = 1;
-			break;
-		}
-	if (!found)
-		return ERR_PTR(-EINVAL);
+		if (devinfo_table->key == key)
+			return devinfo_table;
 
-	return devinfo_table;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
-- 
2.34.1

