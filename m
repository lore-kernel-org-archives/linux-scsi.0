Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF42F1779B1
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396877; cv=none; b=FG0DfQPxvU3/5XO5IMnOTjRSh3DcRVFk5o8BI+MFS/Ojt407KWJL2Bn6Xcr2gboJteP/pRNgHyGs4xt/iImlD1iK0bukkiK03cyJ0vu8JFYPJT1XUROFJYi4p0/GkVC+qISw2oHX18yMegyskNMKN3MO1wS+Vi9E6rMK1Zl2pBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396877; c=relaxed/simple;
	bh=6KOTeQA08u7PIa6fqyJIO8S2pm+zFpyukKbzTb8OlqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h91B3fiZ5vbdmSy8LBaWTYMlwXywb9XoEHAg6iQ5b9YI6KZ1WdZoI31xqH8ml3TsfwVwQY6j4LoTxU8cE7mJPTQEWcEpiOun64ICOtq57SWzi/fGcoUeBhoX2k0YMTyxsZhpXiQphYQcml9beEXbpiuzolGAgtoAlzWTOtr0mqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8Af7dc8; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8Af7dc8"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-70df2135426so4203362a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396876; x=1720001676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlWBI7UdHor2P77JXIMXQDCL5Fy7mR8wocYDlTCkBII=;
        b=H8Af7dc8mnPqw+31lNb0NkvGwjbiF3EeE3CPRafpqs7JF4BZU+a2skBFzST9WMf0Cc
         RPRQApR6nfvPrOxLv+ejdKRgKMWX9sT/8TXKLxFjfFSXyXHCGSRSHU2pT1nEqCZxvNhF
         PJAQ+UMWnLLiTfpOjSIHBwWcHFdZfPAOhvHsZrXxHym/8G+dd1085HxJTT0kBnyk8K3n
         P20AlG7V15PlylZFdKvgEoxkfusouPu4WKAjY1YXT4pU4EGTZFubK0xn2G190oCvcorY
         yVn8DdA6OCkdQQ48US31vT4K8SX1HGNXrT7fSIGgSBaIyxABIDe7uVj4J0+Ost98IEeD
         P0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396876; x=1720001676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZlWBI7UdHor2P77JXIMXQDCL5Fy7mR8wocYDlTCkBII=;
        b=qi+UEsByohoHy+0rwF2G08kV5+CFeBwKHJSSTqga+fpvp9sWvcOsDqONBfhnZLTKDp
         0wvgVb0EMrJzyu7Lm6r7VFpgZrRFm7MFIbmL+qepWjNn2JciIxqcuHm4cQBItCqumz4t
         r4qgkqs/BEvl76eRBDDmeTPOYuMcjzP6gegs9ESihB1wdnGgYYTL4ze7s+hicraNHCfJ
         g69G6afmhJFIfbtBq8GIjneJGWUYfqKXHrhl4iK6j7EvDFow6+k/Ts6+g0f1LfE6jwVw
         0oMj2AdbIj6CAfoHLB8pOQNecAjaR/XPKXEU3LS4E/ixXFV0Z98YfkEfM3Sl0RCJiyyy
         lvLg==
X-Gm-Message-State: AOJu0Yy7PBrt6ClYIw3gDP3ywiYGNCZdRuyRDy8X4zLuol+UsGpmbFnf
	0iYb3t+EcSaS7r7edYFp268qfb7CzMGE/XUVAJBazk9mn3kLEAumYg0rxQ==
X-Google-Smtp-Source: AGHT+IGyGV1BFkNkIom8Lj0SMYeud/JAJfbxy+01YC0+M7AKGXSZxyuzx+frcdaPxDCqUbw1lpvIFw==
X-Received: by 2002:a05:6a20:b829:b0:1bd:1d6b:a917 with SMTP id adf61e73a8af0-1bd1d6ba94emr4109741637.50.1719396875777;
        Wed, 26 Jun 2024 03:14:35 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:35 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 12/14] scsi: scsi_debug: Replaced ternary operation with min() in resp_get_lba_status
Date: Wed, 26 Jun 2024 06:13:40 -0400
Message-ID: <20240626101342.1440049-13-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/scsi_debug.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index acf0592d63da..ae64c0df95f7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4579,10 +4579,7 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 		mapped = 1;
 		/* following just in case virtual_gb changed */
 		sdebug_capacity = get_sdebug_capacity();
-		if (sdebug_capacity - lba <= 0xffffffff)
-			num = sdebug_capacity - lba;
-		else
-			num = 0xffffffff;
+		num = min(sdebug_capacity - lba, 0xffffffff);
 	}
 
 	memset(arr, 0, SDEBUG_GET_LBA_STATUS_LEN);
-- 
2.45.1

