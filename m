Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EE738E5CC
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 06:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780900619; cv=none; b=MRmJFOp6CbsXRr0HIfVaVwtSpkoB6QA0ndaHEeDl/ohUUIE5CwYYHQJkWwPq+WwTL69x1uySOnfqutNItkqnW/1V9qGVMyI2QVVPsKyPUwwDJZNqEWkV/U3hGfA2fol3dzWDHhsozHaVD7KfpzTNKVtqMtKiINgbm+ShX+8MLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780900619; c=relaxed/simple;
	bh=KMrV5pPr+i5O8xxCSE4GsNvdoC2291zJwjpszQOG2BY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nFz9JlG5oFFe368VfxdhbwV8OCtko3HtZiZmQDvHnsZeBJnByiuohyA8PjW7vm3ks/XzvmZAGZRyN7IAdp93j9C06Kq5LYmxu/t9JAtT49epl1uK1+3VPTtmtllbyH7bI0D0VY8kZkv3B+EWh8huD6AHVsjTRt55vkEzFX+COm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kYzDf7H6; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYzDf7H6"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c132ac5ec2so38577495ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2026 23:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780900615; x=1781505415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QyOrzsXzZonT6xdVUXrU9TKr4z89jWxC1bOyHjr9z4Y=;
        b=kYzDf7H6l5nZEZcevEg45ZDi7bVbftHCvSGpI4lzl4GV2fMqPg5wYXMD9td8VHRYTh
         VtFs0ZsrFD60PO/GaHLdIavF5DdluqsR8LHQwSODf50Lp3gVQhdkchBEOEfsxZiYGWJ0
         atfoNeOb27RQP8v4Dq9jO0TFcok432cvyGYdr5N3UigPXn/cXCQe/jjMl5Rru3EW/ANQ
         GXdEw43LjOqwCR7BngeCcTyaXH/kyL47BtXZbrnalJs/J6wpY4xHc9MPfFjxiGbn0aiD
         8NTRtx185dX00dsMwlq/3Opf/9xRX4Ik28duMt6BFP4dzgHh9/WajPMqzbbBDIiEgZwz
         rANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780900615; x=1781505415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyOrzsXzZonT6xdVUXrU9TKr4z89jWxC1bOyHjr9z4Y=;
        b=HUvIPkOFEz7GgZBYboXpnKOe7lgxmU4FfXwoQLG+i203WQomWn2sSQE4anJ/uOw5KL
         kN3fqki6wzmt54WLoFhS3fzXn549VJxGrRn1isBl2gYdbAXxY3akNRoRbiMyiQr1EelO
         QDqa1pi2Pnhzw2PmVvcJhvChrnb18Flte4oSoRSjC8VPgQ4IqySHIN5M7I+WZV09NxDX
         eEfNsndQNL75n0+RCPLkt+6NDHkn6PG3RihsNRDZ95zuh5OLijY2Pkc5LkB/cqiOuEQm
         uIJfAdbmm6uIdntJmszAQ4/iITE0BdqO9yfVBjaer+ZYC6+kS4Mfnh7sQUMAFUuyWhqz
         V8RA==
X-Gm-Message-State: AOJu0YwmfSacHbvl0samD4omJtnkohmSHAJU/eC3Pi+uxxYM3E0Zbf2F
	r/PWR8iNjNk/cQzaqAp6u9PlmWdoXleEtDysvweMXvlFXaQ+dK5pBWig
X-Gm-Gg: Acq92OHRVF/2TIc0ji3CEJerEkbTEjHOEhBa7RZFTaqmc3a4PeiClvgvdeyWn48vlEo
	tt6rYZbaFGTDZ5AjlPxgVSl1rIe9bzuCQ0NMa5EPCLF9b5h7SJ+McEENipaByvinQuxeomwvzpZ
	dXQblqQewaK3wlUyDsTXUNi1aXuEZatynxPor2u16fYJKTccOS4DQQ/fsr5aRIrFx591qwD7Zu4
	l6/UpDD5zOE0NibEEMKzpzRMZ+4/oyib3rsUzdFs0cwmhHsq4aK97SZoi+rh0A7SEgjjki5Gj4v
	JSqZcV3jEVELsream8mkZxfaCdPGX8QMSIOIQi3y8mSC0VAsA+Zn700U1ach0OiTmk+eXbtNeeC
	C8fJhapU0M24GigyKRHIMuBrYh2s/YbfUeRq7nxA0LhH7Qppfueg7F7gKp7L1Y68/zP7KHcZYLn
	zWvkmZWi4avYILgV3KpT+KsbFp8MCEevKGgCY9DZGpVIaTfaaweLh4
X-Received: by 2002:a17:902:da86:b0:2c0:f807:56b6 with SMTP id d9443c01a7336-2c1e7b3578cmr149366865ad.4.1780900615167;
        Sun, 07 Jun 2026 23:36:55 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:9a2:954d:67fe:d9c2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629cf89sm171820725ad.56.2026.06.07.23.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 23:36:54 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] scsi: arcmsr: check XOR DMA allocations
Date: Mon,  8 Jun 2026 14:36:50 +0800
Message-ID: <20260608063650.54-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arcmsr_alloc_xor_buffer() allocates the XOR metadata area with
dma_alloc_coherent() and then derives the XOR scatter-gather metadata from
the returned pointer. If the coherent allocation fails, the metadata setup
would dereference NULL.

Check the metadata allocation before using it. If a later XOR segment
allocation fails, release the partially allocated XOR buffers immediately
and clear the XOR state so the common CCB pool cleanup can safely release
only the CCB pool.

If XOR buffer setup fails after the CCB pool has been allocated, release
the CCB pool before returning the allocation error so the caller does not
leak the partially initialized resources.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 70 +++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8aa948f06cacf..c2ef752fd34c0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -753,9 +753,39 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 	return rtn;
 }
 
+static void arcmsr_free_xor_buffer(struct AdapterControlBlock *acb, int entries)
+{
+	struct Xor_sg *xor_phys;
+	void **xor_virt;
+	int i;
+
+	if (!acb->xorVirt)
+		return;
+	xor_phys = (struct Xor_sg *)(acb->xorVirt +
+		sizeof(struct HostRamBuf));
+	xor_virt = (void **)((unsigned long)acb->xorVirt +
+		(unsigned long)acb->xorVirtOffset);
+	for (i = 0; i < entries; i++) {
+		if (xor_phys->xorPhys) {
+			dma_free_coherent(&acb->pdev->dev,
+					  ARCMSR_XOR_SEG_SIZE,
+					  *xor_virt, xor_phys->xorPhys);
+			xor_phys->xorPhys = 0;
+			*xor_virt = NULL;
+		}
+		xor_phys++;
+		xor_virt++;
+	}
+	dma_free_coherent(&acb->pdev->dev, acb->init2cfg_size,
+			  acb->xorVirt, acb->xorPhys);
+	acb->xorVirt = NULL;
+	acb->xorPhys = 0;
+	acb->xorVirtOffset = 0;
+	acb->xor_mega = 0;
+}
+
 static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 {
-	int rc = 0;
 	struct pci_dev *pdev = acb->pdev;
 	void *dma_coherent;
 	dma_addr_t dma_coherent_handle;
@@ -771,6 +801,10 @@ static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 		(sizeof(struct XorHandle) * acb->xor_mega);
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->init2cfg_size,
 		&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		acb->xor_mega = 0;
+		return -ENOMEM;
+	}
 	acb->xorVirt = dma_coherent;
 	acb->xorPhys = dma_coherent_handle;
 	pXorPhys = (struct Xor_sg *)((unsigned long)dma_coherent +
@@ -792,8 +826,8 @@ static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 		} else {
 			pr_info("arcmsr%d: alloc max XOR buffer = 0x%x MB\n",
 				acb->host->host_no, i);
-			rc = -ENOMEM;
-			break;
+			arcmsr_free_xor_buffer(acb, i);
+			return -ENOMEM;
 		}
 	}
 	pRamBuf = (struct HostRamBuf *)acb->xorVirt;
@@ -801,7 +835,7 @@ static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 	pRamBuf->hrbSize = i * ARCMSR_XOR_SEG_SIZE;
 	pRamBuf->hrbRes[0] = 0;
 	pRamBuf->hrbRes[1] = 0;
-	return rc;
+	return 0;
 }
 
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
@@ -895,8 +929,10 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		break;
 	}
 	if ((acb->firm_PicStatus >> 24) & 0x0f) {
-		if (arcmsr_alloc_xor_buffer(acb))
+		if (arcmsr_alloc_xor_buffer(acb)) {
+			arcmsr_free_ccb_pool(acb);
 			return -ENOMEM;
+		}
 	}
 	return 0;
 }
@@ -2083,29 +2119,7 @@ static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
-	if (acb->xor_mega) {
-		struct Xor_sg *pXorPhys;
-		void **pXorVirt;
-		int i;
-
-		pXorPhys = (struct Xor_sg *)(acb->xorVirt +
-			sizeof(struct HostRamBuf));
-		pXorVirt = (void **)((unsigned long)acb->xorVirt +
-			(unsigned long)acb->xorVirtOffset);
-		for (i = 0; i < acb->xor_mega; i++) {
-			if (pXorPhys->xorPhys) {
-				dma_free_coherent(&acb->pdev->dev,
-					ARCMSR_XOR_SEG_SIZE,
-					*pXorVirt, pXorPhys->xorPhys);
-				pXorPhys->xorPhys = 0;
-				*pXorVirt = NULL;
-			}
-			pXorPhys++;
-			pXorVirt++;
-		}
-		dma_free_coherent(&acb->pdev->dev, acb->init2cfg_size,
-			acb->xorVirt, acb->xorPhys);
-	}
+	arcmsr_free_xor_buffer(acb, acb->xor_mega);
 	dma_free_coherent(&acb->pdev->dev, acb->uncache_size, acb->dma_coherent, acb->dma_coherent_handle);
 }
 
-- 
2.51.0

