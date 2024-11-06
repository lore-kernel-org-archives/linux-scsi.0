Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA21D363D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 22:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730932116; cv=none; b=ehEHlkX4m8JKCalNPog3Zwf6l8FjNfF0yjnKHePzg7yThx9AGNNAbB47XldMzzsgXx0+zYGfQ5yp59KD8nLdMDF81nqtqT/maqILKqEKhVq0n8DIFgs3AAoQEsYgAzUeqxVDySvdxfnHI4DFHvYekLoDS8N0Z8jqzu/4RsvI7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730932116; c=relaxed/simple;
	bh=vmWCPMI1EnL8PwsbYAulKsByiZH52oyBgVnhBG+c1dk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IcjD+2moMvWKMKCKet1cdfH/kuRYVJm2wA1nsR0yL5QBqPccULdSik5ZA6w28cdHjfymZS8ywdtBQkcf6Ir/PoKQSvND+eXGytX/Wm9bZBoItQClaDRcCeEQwmR1qq5rzq+fpB3PdgyoJZw9Kb9bmEfJaVZjDNKySfyVovhexaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLaR+w1N; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLaR+w1N"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539fe76e802so274913e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 14:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730932113; x=1731536913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=04l6SfDALYSbSxmf8EiFPEukJSYkKlEWzNWQVKLpkSs=;
        b=MLaR+w1N94d5M16Xu4epHaZR9xPsi75+ZzwrHJE+gL549PoZKszlbSK2Lr13BX9BRm
         LyRdreDcUQCgrowCEfiM/UOHSYdqBmfFZu2q/ApLe/PaofnD5bwXz76NoYin78KA2koG
         jh0K26oaeYxi5UCtw2wEgtN8CyaFuI68+GOQ5CkQ0cWeoxXOji7IiaDQJWo1X2RltK08
         BH8PheAwNZ1zbZv/Pu5hi0rPQ7BLbT0YkOLfkZKBFPAAmguSgVwJFCwt6BrPZyBSQMy1
         XWBCJRbtm5XwcDs9WmQ1tK++C5pO+DUvipCj3wgYE7ltVdFg5wrxhX8j2rvnlb4nn8bZ
         8NVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730932113; x=1731536913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04l6SfDALYSbSxmf8EiFPEukJSYkKlEWzNWQVKLpkSs=;
        b=oQ1KjXMw3nZX0t8rUC1ydAnj3CKPpEoBkeCkN6OvkF8qFPwNThynfyAcugvit7qn8P
         JMkp/f/bOBipchtKWkbG4v/jazDL2/LdHRcpMtPSgeJmCmUWtRb2JRRzgLEhSnbCopuY
         AlqMyGSOWH0+2BNYvvsg+KD57u2e0xJkB/h1WaKAL/dxYky6+gML7ccQ3Qjhg2JRXvKC
         g3yoh9gwEDVsgp+2FSp64MTvZLYy0XSUZ1sjp2gIQsnrxfNCgu4ur3UjcWLVdp6596dj
         cUGrLdAtrOfj4bs3pwyzCy1emFv82JgL3GSks7+Gw2EZHhZBf3bhKrOvEb6808FSvq2Q
         k7NQ==
X-Gm-Message-State: AOJu0YyvridVooGl6FWigekVhwUPLvOR644U30xqtpRo0SDUlKrui+XK
	ibL4MY8KFxBDn8HuwaBxj7XI45GiuGTFRiueA22CPwyLiZnmwGpP4VxqeA==
X-Google-Smtp-Source: AGHT+IEb4OwNX0bWaPqailahpc2MXWEPg/M5ygYEqLVVbm9SWwxAynRtHNyuDkgZtyOq8X1ZKwq6DA==
X-Received: by 2002:a05:6512:31c3:b0:539:8a9a:4e63 with SMTP id 2adb3069b0e04-53d65e11a80mr9278877e87.42.1730932112476;
        Wed, 06 Nov 2024 14:28:32 -0800 (PST)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53d826a77d9sm8050e87.165.2024.11.06.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 14:28:31 -0800 (PST)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: linmag7@gmail.com
Subject: [PATCH] scsi: qla1280.c (bug/typo)
Date: Wed,  6 Nov 2024 23:24:28 +0100
Message-ID: <20241106222812.2496-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 A null dereference or Oops exception will eventually occur
 when qla1280.c driver is compiled with DEBUG_QLA1280 enabled and
 ql_debug_level >= 3. I think its clear from the code that the 
 intention is sg_dma_len(s) not length of sg_next(s) when printing
 the debug info here.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..fed07b146070 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2867,7 +2867,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-- 
2.47.0

