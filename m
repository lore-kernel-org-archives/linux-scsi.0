Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D8C36EAAB
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jun 2026 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830227; cv=none; b=aJ3vzM7u4eW9EWCb9G101EetKMLTdz/PpeHZJ8uU1NDZvH1OdmA5XDKCN9wvxY8AxRNTej/1oeA7VXxEEXBpxMFJAHfmdAfPGjviYYQ53b9wgIY5cH9tPfVx2WrLQFXdFgJwJf/5fPStv914vCNBtQ43qTTR4rqyUkXNGLj99W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830227; c=relaxed/simple;
	bh=7TL9mox3kFnWg7MAxp78VEQJzb2DwRyijYkLdDkS2AY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tReUO3cJOfcpFSGU2Ga2fqxu7kA+kP2G19z+yoVQvbw6zI4BRzDa+og3Y2qKMwsk4HJIjjtAqPXpm7TDpss4Ej7C+wz9poaFb+179HODMUD6MuUP1Jd3U6cqV9S8Q7rWUHdcM1VpKAAIpMxVX27GxD25zeigY7QSronzfnKAxgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xk0Zxb/E; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xk0Zxb/E"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36b9033d230so1702768a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2026 04:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780830225; x=1781435025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MRYeS+3lgp5NTYUoJEOQjWZ0O0A5oiI8iTFU5nQK1KU=;
        b=Xk0Zxb/E5mNA//4EqGaC/1rS13aMVzxMuKxXRwhZziGyprYeDS0wlQEac/9ZJJI97T
         ST3x8Ox2i0sc+rqZWQFtR/2G7PQDyhKTxCdawSJTd6dA7aGS0E+aJ2x5G2e9+UHTlHDX
         fnkku1b+6CU6r5CSzW0RPtK9v4TP3QamtWDqE1b5sL81Ur21xj7fOFhSDd8120wK9q2/
         PRsvMIclerBtFikWI+/e3Mg2uxTeEPPvBlmgP184MRZT9vaJOuW7I68NmsJIAC0kRQ3J
         uMlt4Airf7RNdrfWVYa/+Ky82tH/9/zPy8XXksCuHgxhpRGFKuDSTlByISzYfcq7u8ge
         ecJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780830225; x=1781435025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRYeS+3lgp5NTYUoJEOQjWZ0O0A5oiI8iTFU5nQK1KU=;
        b=nEtmM4xnsM9QGcJm0JewfdPGdNfYQlm3NHDK/ZavjsANj+F/1gI03qO966FWcMP9Z9
         MqDmIlStAd3gBMGNavbm14E5oNGE3HKPMKCk4LTqBso5LEC2hCNJZX+u75WfZ9EpyGvv
         9XkkRR4PwVY7QCc3ksNJ7HnEn3Hp4eeVPYY2N8cnKBqZpRn52u0a/e/MwDhki4txefRh
         WrcPMh8Mfd+MTfRri01Dql4Hkt4V2fTYWZ5VExnTRwiPrQGiLy0vNUxBQveYjxGzQqV4
         m6+A7p9s3w0hi1GP5eb/NvzsgGjwcHgCyOSBkiabKcew1t8u8D3bmKGC4ZBJqc1WXeub
         Q6og==
X-Gm-Message-State: AOJu0YwXJE6PLeBTgfbHMlEyf+GkRSptvXZLtJX6jk6ooeUBADkzZO1x
	xVXU8K1gOx6s3Ak3iUp36IUlizo7SrnYgcLk2anpeRCUR8dAr8zvXxVM
X-Gm-Gg: Acq92OHVW8xGL6s94GKouVREtFLe+DzxQvplINsBC0wSpwnBLqzD26C2XoxL87u+sw0
	B602r7sExgsWhJSdiTktQrvFaBfrtc4AcDnOTunpePvB+Vas5P7A7pOcZKgoEvBm8AhFbWC4Qxu
	4Xl3gAT0QNDd0iPNhBTmyDnUCU8cv3qjcSyAGhpPtlJiSuPKpD0s3tUYHfZ4Z7exH0+h+8zYeoB
	CGh1vD70kiQWK7+UIpspAsSeJN5nBe5u8MYIzjcpzie7NaTi5927bp1VSRhmhH5XqXBJVjkomzB
	72cZJNPrhhI97j+fmatkGSNxSM5o5GLjkafK7CODQZU9IR5EBZexKHBl4IOPHbJ7vW7xdIUcjIj
	vEUJphgJz+hE5adDDmEkMAGEN/Ymg+tOKltw0QxwKVa2GWi04Dab3Dgmj6Qn9OVuFGitqUwHazi
	f6Nxd2kYA1z+s8jdDspZjy6r2A3k+USdXS4eMr+iSUE8x8sBt3sf0j/6ml/l8yU/Y=
X-Received: by 2002:a17:90b:4a83:b0:368:864:62ad with SMTP id 98e67ed59e1d1-3713029c115mr8369162a91.3.1780830224771;
        Sun, 07 Jun 2026 04:03:44 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:5d57:2cec:64ac:50a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8521sm12124123a91.15.2026.06.07.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 04:03:44 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] scsi: be2iscsi: fix cleanup on memory allocation failure
Date: Sun,  7 Jun 2026 19:03:39 +0800
Message-ID: <20260607110339.3-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

beiscsi_alloc_mem() builds each memory descriptor from DMA chunks
recorded in the temporary mem_arr_orig array. After all chunks for the
current descriptor have been allocated, the code allocates
mem_descr->mem_array and copies the temporary descriptors into it.

If mem_descr->mem_array allocation fails, or if DMA allocation fails
after some chunks have been allocated for the current descriptor, the
error path records the current chunk count in mem_descr->num_elements and
then dereferences mem_descr->mem_array. That pointer has not been
allocated for the current descriptor, so the cleanup path can dereference
NULL and also fail to release the current DMA chunks.

Release the current descriptor chunks from mem_arr_orig first, then walk
backward over the descriptors that were fully initialized earlier.

Fixes: 6733b39a1301 ("[SCSI] be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d..31c617bb6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2549,8 +2549,18 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	kfree(mem_arr_orig);
 	return 0;
 free_mem:
-	mem_descr->num_elements = j;
-	while ((i) || (j)) {
+	while (j) {
+		j--;
+		bus_add = mem_arr_orig[j].bus_address.u.a64.address;
+		dma_free_coherent(&phba->pcidev->dev,
+				  mem_arr_orig[j].size,
+				  mem_arr_orig[j].virtual_address,
+				  bus_add);
+	}
+
+	while (i) {
+		i--;
+		mem_descr--;
 		for (j = mem_descr->num_elements; j > 0; j--) {
 			dma_free_coherent(&phba->pcidev->dev,
 					    mem_descr->mem_array[j - 1].size,
@@ -2560,11 +2570,7 @@ free_mem:
 					    mem_array[j - 1].
 					    bus_address.u.a64.address);
 		}
-		if (i) {
-			i--;
-			kfree(mem_descr->mem_array);
-			mem_descr--;
-		}
+		kfree(mem_descr->mem_array);
 	}
 	kfree(mem_arr_orig);
 	kfree(phba->init_mem);
-- 
2.51.0

