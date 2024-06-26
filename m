Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF60175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396858; cv=none; b=URtTy8Q+Rz4VBVrp0GS1bH5Wjk8zKmMFk+zPqafAC/+4ZTYYA1H5X21pGjk9lz7wmeOZlMv3ts5y0meUyn0SmDSCI5p6BYOzKJzwZBhHhXhkHSjY1K3OQkzy/K8vaQYmVnI5Z+WHTaHKdDCbg2jACJUmdx8sdGON4i3k8YUvhE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396858; c=relaxed/simple;
	bh=ZrjVcOiRUymWYcoHb/W3z4xw/yyC5O8gzQcN9V7t2P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGZyBWITK7E9ATs2b5XmGgUHJ/dOjWt5lI3vmycUGXyPK6kMZHTgspxnzU+loGKcGiwGwB4M4f8jXmn+k0IUil92rt67lWaI/J6mAkv2Wm8qxHdSc/Tid1TYce3KBreePGvzByaSRIFVn/dOGrseDYicr6xRyNo1OGZIQfEyD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TKVbOCVj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKVbOCVj"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f47f07aceaso51013535ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396856; x=1720001656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieQWqCkI9xb4UB11URnziOvdRWXntJmAaeT8EBK/Fd4=;
        b=TKVbOCVjz/k5JEDWJycweK6TTG93aZ4trGFqNDtQzhRn3/nrJFREbTHPnJ1IjRznY1
         UxAkKs5ynaJK/3RLepuMdnvQJsIGKNtXOnDeVHDDjPCOHzAuVvnoQ0OMtb9QXWyCmYC+
         SUso4EJcrjeIKTaOPmaDcYPee0DRLUnRaqdeJuUKViYSxOVyEkaEUkZ25gFJyYlmq84r
         u0fhJ1uDNcdF6E0RugeY7Lg4u7YuqHiZGrbFJFsbB3KdQb6w3lnhSuuwmSD8jDSj1moW
         Rvwx9kdCeYaPbpuu9kAopP6hpRwg05RKaUK1gnxy6jsi7aSpi8R5ZdL1WfR5PS0lRRNI
         5y3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396856; x=1720001656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ieQWqCkI9xb4UB11URnziOvdRWXntJmAaeT8EBK/Fd4=;
        b=nyblqu2i5PB6MU7KNyC5kWc/DCgKMUzjY1oyGFhJ7y4m1CPMnKrefkIvLWvHF+GpNA
         mla+2ehuYx2ZPWW/0mWfTs67WVA6bOdjRGFp35yG1W99VuKpXKycCgVgfv9fYI9omwqd
         tnd1SSeF3rYLkDWgsYnOzNs8yEh57F4MnDFifYzz9Wyy90t8zHVLwFIYQ43O3TaATxr3
         5ErDSe0o/a39hIjdcRC/0GDbz7sStOh/kSFm4yyxJL5J3xfia4TZkTcuXZyTMgAkITSm
         Fad02xNriOxmsS7bXtxHchRKr72jhudjZiyuJkZmAQ5m+WkZ1a0p0MZwPkcaZf46sEa7
         CHGg==
X-Gm-Message-State: AOJu0Yw7f2O04l9HY4475WJWS0rxr38zZ0Ra/kjrZFHFU3BRxKXnZaH0
	+FHPeLw+7Z/GnES2PWMGTvRId0t1eUFkXxJ92HZ3zgTJRqEKOr2allGX1A==
X-Google-Smtp-Source: AGHT+IHk2+OqURY0h8ZnJWKuI9i6HeeDLRrVTJbFitwQHEFLJ1oaLh49Z43DqzaMxWeDPeMKPPGwxA==
X-Received: by 2002:a17:902:f604:b0:1f6:ff48:1cf7 with SMTP id d9443c01a7336-1fa1594e163mr131288085ad.69.1719396855844;
        Wed, 26 Jun 2024 03:14:15 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:15 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 04/14] scsi: cxlflash: Replaced ternary operation in write_same16 with min()
Date: Wed, 26 Jun 2024 06:13:32 -0400
Message-ID: <20240626101342.1440049-5-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/cxlflash/vlun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 35326e311991..e39ef6967d5d 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -445,7 +445,7 @@ static int write_same16(struct scsi_device *sdev,
 		scsi_cmd[0] = WRITE_SAME_16;
 		scsi_cmd[1] = cfg->ws_unmap ? 0x8 : 0;
 		put_unaligned_be64(offset, &scsi_cmd[2]);
-		put_unaligned_be32(ws_limit < left ? ws_limit : left,
+		put_unaligned_be32(min(ws_limit, left),
 				   &scsi_cmd[10]);
 
 		/* Drop the ioctl read semaphore across lengthy call */
-- 
2.45.1

