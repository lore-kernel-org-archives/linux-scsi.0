Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D09737F8AA
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786128633; cv=none; b=Grwwdk2vrH+hwhxdMdh7piKG8WbjSDeZaasNf2wAcq2dE9dnKPkyiP6JlagaUHlLohG/IXjqVHoX8s2N3lBG080bOUYsO4g/YMf3hlkgi3nJqS/TUPrq4JRk5GwTStPEuaV9yCJ0NFwYKnuj2TB7bhvqp8moymvyavCg5wO73EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786128633; c=relaxed/simple;
	bh=2RBye3ZPr8nSEI/v54Gbh6xG9QzAw0hy5AkeJNg3XM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nsDurX9qA3TA7ehmgnsOZhi37BiSx58FGUjzUWDUTb40sl89rUc3iBri9Xqa/f+Yl+nCtAmuGxgGZ17uy2vWLlYi9nD/XqCiAAQwDW1FJmsUxE2s+EMeOtwXLnzRCVMct48GfFqwN+KEBI7oIAEpOKiG2BxZ5L7Xbef6j14u7h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oTK/XhfY; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oTK/XhfY"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8485ef63b68so5651704b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2026 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786128632; x=1786733432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1YKYnkYiFPUfsXKn8ypCxMurlFacKXjrC3GxgCzJBQw=;
        b=oTK/XhfYXtG1CF243pyx9IU57/7pJseo2Z5zNNNOwzD4lp6dTV2IHVE+EpypqXNqGS
         yqbNX/PR6ewdMdP4NOvqiEOG8M+p75l9nJA6s8SCjlwACgWaBH9CvzmwCs5H80O24ajR
         w2GalAd69il9W/pDqkXAZCfh/QyM9D72CU6h0SQael0BpnqrLVDgc22LpgOJQ6pdjjKd
         O5RoMp5bOksp2o7fIlRTLWGWKX+/W4qEcsrSknwkx7ulLDlUU4BshYCtN65eWKveheCa
         4gCllmVMGDGWNSU8pf3qWRGfBuoBZnkzvvtldAwdPZ67k/vfmzunIdsVbBCbdnDlAbBq
         XxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786128632; x=1786733432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1YKYnkYiFPUfsXKn8ypCxMurlFacKXjrC3GxgCzJBQw=;
        b=RY89iqI+REZjGT/xK4bPqL5CW8oJETcORQIX4rDk3u5F+Vbrvk0D1EeBbiKS2l0enW
         +H/vISo/lxoCF8UP5VIbK6ZeKvuf0EYVofGwE22vF/qu7/u8EPKqKnaRuLBEFxKvibmY
         LAXrFFSfnJZuo1gjeMkevu2p4eNmhHuCq8Lda/i2DXhI58jOcr3RW0Vayia9Hd/8IC32
         E8Bgcr1rE/28L94Cqnyab7jkWnSxw1gmnevgdIrZjKSnltVVDM416g/TE9jDZPxF3Mr2
         eSHOydiCjYyYRQE7hNYj8RYMpld8duX1kMGebKBQPwd1AUlvuczp0jmpXH9Ha8NTzVqJ
         0twg==
X-Forwarded-Encrypted: i=1; AHgh+Rrxyes/fbWzIWC1k2dELcSg3gv7i++Brct1j+7kEiOAqnGIvRBmDCzwQtiXNRFuZiTIwsTxJt/lgrzy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+bB+GpLECWldxwYjusuiZYbAPN4UNIUVP6mR53/lBn2gwJr2l
	HU/dViPMhIxh3IfUrWLnAjehkqj1bZdrdsI8gc/tMMj9XzWkIUUyYqQa
X-Gm-Gg: AR+sD10BMrE+xvv/jsUtSYki/4zJLRJp25jgRnbN96AejqE5l5MRcmMW5ynlbmSGS14
	LIjNkNB1Uzebt7ByjuOteJ1Wmc4k9EC1BIwflivLT+jx7fnu5oH7nGyGnThX/Honltt7mZoeaL+
	Q3C2w321Y7U82b+hDr5dlWXSGerZIrSe9zLuGSudEreinuVVoGDvMUFz/UKEZ9yDQMPnKNaXraC
	TZ/JNcy/Ud9wBRua15fZOeAyaP+lMFcK/aR7SbDqj1a8fSenq0plCQOYl7ARGPwh6Urq286d5yl
	/Et5U1NfVsZwMiAPporRr/kOKxpqUTxTxIk2tdb0RdoSlZlB2ohgzWkNRbUU1tUXMCIeNnR2+UW
	4Y/UgRJaYSAsURIcvqLjiugazI+bO2vzGt+OIyMQ8ygZ08L8J9KHXF8q4L5CZGEvMVPb4pEthZ7
	Na9pwonfFUzSoBUIydJCsx/nIdlD1LzwKR5KkcNiTJ5GDcUyafmAlhnI3PfDok6uZ5VSL9rOY3Q
	AR0b5D8NYIsBOgEY2OaTTEk5R9Mf79QTWv/5h3qhTSSFnDxp/4GQ0mRhWDR+Henx+WC46U=
X-Received: by 2002:a05:6a00:2d8f:b0:84c:4d9a:ae42 with SMTP id d2e1a72fcca58-84f2e00ea99mr25144376b3a.27.1786128631692;
        Fri, 07 Aug 2026 11:50:31 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a52060dsm1500361b3a.38.2026.08.07.11.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 11:50:31 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: viro@zeniv.linux.org.uk,
	axboe@kernel.dk,
	bvanassche@acm.org,
	ching2048@areca.com.tw,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] scsi: arcmsr: fix DMA memory and IO queue leak on arcmsr_alloc_ccb_pool() failure
Date: Fri,  7 Aug 2026 12:50:18 -0600
Message-ID: <20260807185018.80661-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If arcmsr_alloc_ccb_pool() fails in arcmsr_probe(), the error path
jumps directly to unmap_pci_region, bypassing the free_ccb_pool
label entirely. This leaks the CCB pool DMA allocation
(acb->dma_coherent) whenever arcmsr_alloc_ccb_pool() fails after
successfully allocating it, e.g. when the later
arcmsr_alloc_xor_buffer() call fails.

For ACB_ADAPTER_TYPE_F adapters specifically, the IO queue allocated
earlier by arcmsr_alloc_io_queue() is also never freed on this path:
other adapter types free their IO queue before calling
arcmsr_alloc_ccb_pool() (since its space is folded into the CCB
pool's own allocation), but type F does not, so it remains allocated
and leaked if arcmsr_alloc_ccb_pool() subsequently fails.

Fix this by routing arcmsr_alloc_ccb_pool() failure through the
existing free_ccb_pool label, and explicitly freeing the IO queue
for type F adapters beforehand. arcmsr_free_ccb_pool() is safe to
call here regardless of how far arcmsr_alloc_ccb_pool() got:
dma_free_coherent() is a no-op on a NULL address, and acb is
zero-initialized via scsi_host_alloc()'s kzalloc(), so
acb->dma_coherent and acb->xor_mega are both safely zero if
arcmsr_alloc_ccb_pool() failed before setting them.

Found via review feedback on a related fix (commit afa04c2998e4,
"scsi: arcmsr: fix NULL deref on dma_alloc_coherent() failure in
arcmsr_alloc_xor_buffer()").

Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Cc: ching Huang <ching2048@areca.com.tw>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 40407b281839..d8e56d7b1906 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1150,7 +1150,9 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		arcmsr_free_io_queue(acb);
 	error = arcmsr_alloc_ccb_pool(acb);
 	if(error){
-		goto unmap_pci_region;
+		if (acb->adapter_type == ACB_ADAPTER_TYPE_F)
+			arcmsr_free_io_queue(acb);
+		goto free_ccb_pool;
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
-- 
2.55.0

