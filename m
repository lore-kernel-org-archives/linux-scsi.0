Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1734848B4
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712296; cv=none; b=myrWZw+tw1tNxs6nEuOxxG4z4r5VG91rZKLkXTE4hybtykSvGalAwKL2EVIcMtHq5Lmh6tqtoBuT9vVe0QBGTQC2MhoL1d5YNPHJr36tRQpkf0vFOTJxm8CHOMJ5wexRGKQR9mVpA47sZydrDAf4ZtIpyEego6lqD18eoPR9qgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712296; c=relaxed/simple;
	bh=yfmN4VgJWiM2K0qD+/ELhW7GlVZmQtDwQsE1uxCYWOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CFW1BoHyqlOadWMtfjv+8euurS4JdNQ8/th/2BnVYDX8v5lL54U0aEAk3t/kwHwNCwkKyCtyN+ybOQry4kllyw3rGrFeU1R056Ze0UBvXMyiH5x7nspUDhTkfqpnCdcOGsPOjC3wcDscD1yrDoFCrnxOe02ZlkyH7W1yVuRApy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STRGQ+B9; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STRGQ+B9"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccda24afso277162a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 23:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789712294; x=1790317094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F9Fiem68UhKZxOAnlG3cQI4tsKfNk/QxfQ4iK/+ITaM=;
        b=STRGQ+B9nQu77R/g5add3+Eh/f4ekXW+gi+Sep32DFDEOASu/YtP4FOFGVuOmfDPzM
         UrSQWGI2ps6GaIpcTlHTEEJFizibbSo/Qxjchl6lysI27QXTLm5M4Kj7aUB4wNyHeDpZ
         NdNyb5Wet3XKCUzWTV/c0exVSyFO4LvU/ngRsjHwgQzsE9bXPBxItdfIr/dytiy+XPJ9
         NU4OkBMFjOTH1XlNuXeJ6AChPL5Nm1gxFlw6GYwmszc5Dt3X+NfDXkmTzS1yvTKIeuo0
         fce3BJskEaEpaE2+geSc5zb1/cJCAFYRvbb2Ssn9h5Mats21TQ8LAJoY8bJQ94QFUORA
         TKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789712294; x=1790317094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9Fiem68UhKZxOAnlG3cQI4tsKfNk/QxfQ4iK/+ITaM=;
        b=g4s+ltcb6Uoun8pCC0O1L0DfqMGYO5T5URjR2d/CLtW0mvtlpF/1rzdn+JkdlzrzYN
         +i1fqxcpxz9jmoCOJyHy8tlOFg8stcMp8MMLMCd8ci6fTMC74GxLVWTY0S9jMrgkdi29
         HWsZyGFF7z83lTyzmGzXQQwuKP2EQ/R0sEtUNcw2JxHwj4vBvY8Z8ZcApsT/ShR0Vj/Y
         OoJiti5+gYM5rUv3uJdvLFOJQaX4Gu78dHsthN109EL64R6I/qkLH0PzitPahniQ9/Zu
         u5jgcJqPdCSlH3QE/+0bnBBnJ2C/xdMPEmiGbgGWKhY5VI9QO9cI2fYvQKped1bZ5WJ/
         ijzg==
X-Forwarded-Encrypted: i=1; AKwUvBySQUc6cxIST1kgMD93jM7jBs2b0a+kft7KnExtjz/w8iu/Aquh/Ld+1DnukQ4hLg8mmrqvRxq1QfMf@vger.kernel.org
X-Gm-Message-State: AFuF++l+ffpfJWApwvZkt2FJX2D/o3Ps/4Al8Duz5nhLf3AT5sJMBhea
	PH948bKHro7doK8r7lyGjid8D6DF+neI/7+coOCTK3LgHmFA7bwCRfmla4Nubj9q
X-Gm-Gg: AYBFou3bg+y3/h72i1CoFkFfm8I3p/HednSojcJeqT7lvtAiqan0Lualu9am/FYyl7v
	2BSx9HnCxhNcvCW8dTAZDLKEYb9lzLjQOPqY2Xp2y0CCwsk2VBUUx/s01EPIU3/pcCjDrBRAog8
	YzfzxXsydLwn0qK8TD4p0Wref3g2C1NA31IeaNj45WqKYMTlbvAmGqUZFwiptDhtEZQ3NKItjK+
	9u2auyeRbBzH1dXMYaEENQ+9Pr7PnhLVZKCgARN+vM46bBR6bHJ2bPFf+vuFRDBOO3Mx5fbzxB2
	E2VZL4s2LvIjssDr0n9G3elidGuzBxzYJQm7sAiDr9l13/v+Orv8LtKDkPvU7sdZ2xEI9KrjI21
	9OSOCV/kOpBamOPKJGgqgrmqUKlxkVMyByyVRzUT2JUjlYauD/bHtYTTtrGm5zGR2WNU1PQc46n
	66uLMRvNjIzJEeC+pU8fN5tM/QEF6sf1aKAiVCgLot6g5VkQ79+wwDuAMbFLVsBq4t
X-Received: by 2002:a17:90b:3909:b0:39e:359f:8539 with SMTP id 98e67ed59e1d1-39e54f35cf7mr5196439a91.15.1789712293559;
        Thu, 17 Sep 2026 23:18:13 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a5993bbsm1441555a91.17.2026.09.17.23.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 23:18:13 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: initio: free SCB array on remove
Date: Fri, 18 Sep 2026 14:18:03 +0800
Message-ID: <20260918061803.3561680-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

initio_probe_one() allocates an SCB array and stores it in host->scb.
The probe failure paths free this array, but the normal remove path
does not perform the corresponding cleanup.

As a result, the SCB array remains allocated after the driver is
removed and becomes unreachable once the SCSI host is released.

Free the SCB array in initio_remove_one(), matching the probe error
path.

This issue was found by manual code inspection.

Fixes: 72d39fea9017 ("[SCSI] initio: Convert into a real Linux driver and update to modern style")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/initio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 06fbe85dccfa..b373828bddf1 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2934,6 +2934,7 @@ static void initio_remove_one(struct pci_dev *pdev)
 	struct initio_host *s = (struct initio_host *)host->hostdata;
 	scsi_remove_host(host);
 	free_irq(pdev->irq, host);
+	kfree(s->scb);
 	release_region(s->addr, 256);
 	scsi_host_put(host);
 	pci_disable_device(pdev);
-- 
2.43.0

