Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1450D3B2D0F
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915855; cv=none; b=NKO1rJUIlRd+0VS89JeQa0kU2NpocEtdth2DGq7mBWWIqb4q92UFgINTIfTg3VSa8LdWcnQ174LSAF8AXz37ve1qDO4b82o9ZaWrEb6BhKG1Byz7d5H7HCzo6LMvEtzZWK0DehdVTGYyQKdwr2I1ZBMZgHYBjRHdEvKpZrLQzYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915855; c=relaxed/simple;
	bh=vT3eRxvmSLl3HeEePEpxh71DGTz/iVqHCb+IcEjGC+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lRL4TGhDSW5S24RRWW0KDBtDbZBmHYfjldO2jTCt9VHVZd1RPCN90UU6OMTVGT5GXZNvHTgQZ04BE9sDf9YWm0jiSX8ogxWnBmUdNAoi7s2dVwIYIKShb4oTRgYhPj1XBMyLgfeCTlPPSbkp6Dk7W2cAKk2SxbZK44a2oe7MKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YvebEnLl; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvebEnLl"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d6f9e2f681so6219055ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 04:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787915853; x=1788520653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jzw6ENnP+I3LmrUwavAwIvJNPHWXPsoHj8fC33Agm1o=;
        b=YvebEnLlpxZZ2yJYxYuecQwbeuLP+gvHGn29tAu5rwPOGJwW5ge+GfBWdp1e4oM6SB
         bUBUTpA5YourEp0E9X3CClBQQF++JUFvDVz1OpQCt6QGoVT85OPmzIGqnmmWSb3a9H2l
         SYqnLST+T3FhdwKgwkrQUjKy4CaIG/HA9kk4hVvxAk2TvLFSv/PxhGFrSBZuFtOKXF8o
         qeco/VHqcNP6meA2cg+gsGEKqdaIKsKYLkF2U/+nT6bi1EDjA0zUiG73d4gxaX9u6pOu
         SynhTBSVjDSH+C+3beo8M5IXcS6zUWigrYy95j+irHKUDEtATUN02cjW2lAaXhMH5PoR
         A3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787915853; x=1788520653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jzw6ENnP+I3LmrUwavAwIvJNPHWXPsoHj8fC33Agm1o=;
        b=ieanEr3ihDpeXL5QpQI9nR58AkHUiaEMfbYGpxFaVmktaNU8+6e0mIeEr8Lj2cX+Zx
         920aaNE6T3QsylTVtlfkxn4USb4+BjJqnZoLMq2wO5+hwQY354yjE5YqWVHonafKrTCx
         EmcmOX6reltTogsIvOOxsvVvSCijjFRJc4/uV2BFu3hUgBfRGeg0+yTec7+3R/N/JKbS
         HOrEWbZwRJhuApvY7phB76aJz375mhsih6NB0IqC4RLO1+idT2eyMddynUL36QQgPbfx
         pdZt7M/aEy+r3rOvk+/KmarZZ2jUrYuMBcwCwG1RGE+DemYCMRmBOQVopRC+52nXh/Lu
         W0ow==
X-Gm-Message-State: AFuF++lcOWEShShZFhGPtkidCEY6QHCaGxkeCcObqdwzBdsvaNMSDamd
	MoOq/GmcLQ+5RQKP+r8Iqhb/if1vixXHBqTqIvor4+ppOAWin3JSxMczyjtrEmfa
X-Gm-Gg: AR+sD11Btvf2o5St0kYfz5nK/J7N0zpPUfBwvoZQj6TgEPkz2hZ7unZu6JnnhqMT/ML
	LGgtdok8E5YG88ZAZZb0F/cXRHTzcYZoc2RVGHTFyFK4WGaT8HZUMY+AXxYD/DPxTkvvQ4HteZW
	bYoyrJnGW6/EtsCWeDCvu1hjhCbeGgPS4obj28Pi6wGooR7ofgOyz94zsL7A1g6V6yKmKGYn5mZ
	gA6xQsOJE40ScMAppUe1LsYUBKBc/ffx/b8I9k3ERKO3JpKRgafMU3Rbr0zWi2tbP/mGWNyQ48M
	n8GLfkL6/7KB0X38UfYsgYvzld+J8Wi93zo2xIfUODAXKEnI+qGZTd/7QDcYy+Jul1U3c68CtkL
	rKHFbGCy6cOhQgY+ZT8iBUEpqyInC6LbYAqHrS6yp3EI9EbEmWuj6I8ACiZWFcQFbI2hzPoRXxz
	uJbdGii9dqimXoCSZxAyvtLcR7eYgUE1FaBM3mGWrOMmT2fPDZ1lcnzg83AbtWQb3bDlyly/8B+
	p5uzzu/1csCOxF8mMTmy5YvmWMj+2b7
X-Received: by 2002:a17:903:320d:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2d74df16112mr127512905ad.14.1787915853297;
        Fri, 28 Aug 2026 04:17:33 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598b8f5esm4400015ad.75.2026.08.28.04.17.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 04:17:32 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: pm8001: fix IRQ leak using wrong index in MSI-X error path
Date: Fri, 28 Aug 2026 19:17:29 +0800
Message-ID: <20260828111729.58945-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm8001_request_msix() requests each MSI-X IRQ with the loop index i. On a
request_irq() failure the cleanup loop "for (j = 0; j < i; j++)" calls
free_irq() with pci_irq_vector(pdev, i) and &irq_vector[i], i.e. the failed
index i instead of j. It therefore repeatedly tries to free the IRQ i that
was never successfully requested (triggering a free_irq() warning) while
the successfully requested IRQs 0..i-1 are never freed (leaked). Use j.

Fixes: 6cd60b37f72b ("[SCSI] pm80xx: Tasklets synchronization fix.")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..54b35893261a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 			&(pm8001_ha->irq_vector[i]));
 		if (rc) {
 			for (j = 0; j < i; j++) {
-				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
-					&(pm8001_ha->irq_vector[i]));
+				free_irq(pci_irq_vector(pm8001_ha->pdev, j),
+					 &pm8001_ha->irq_vector[j]);
 			}
 			pci_free_irq_vectors(pm8001_ha->pdev);
 			break;
-- 
2.43.7

