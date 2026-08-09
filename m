Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39A13C908
	for <linux-scsi@vger.kernel.org>; Sun,  9 Aug 2026 03:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786246518; cv=none; b=Krt83Hq3fNrsh7k+5YfzX914KdNZe4gpdITCbQ4uyTb9/i/85/WH0rXVpqhw5IJ8/upXymRhvb4bJFvTAuIWKfZfgr1WMPjMICqZVzK/QjScU1NOpmdZ6727cnATeZzwBZdrCGDeskqjiU05Ys3vM6fbNbAgsEyPED5Fq4liwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786246518; c=relaxed/simple;
	bh=qDd5025ltkx2plAraA4GXZjTXOJCqNrVwmJ/X9vWV6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YecjKqZE4PBawdFhkZglip/O1O1JVxw3E40keLchNQe4qgGY7R8LhtXJ1TOi6Jaie+Ef3mJDaipvLvwbSRmvnVFPKchQRgzFy7N6d2AuPRaZoczJgeX3MRLCfQ8odUwEfGfELNPyt/VWaTJwzgvpiyk2b35P1wDLjdcG/G1cQhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBCKBQq4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBCKBQq4"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cfff5f88dbso13055025ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 08 Aug 2026 20:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786246516; x=1786851316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=99aSv3oQy8bBTbpm4SMRqbPI3qurgIZlhYbHmHdiDcY=;
        b=XBCKBQq4/okku4y52NznRByuFaWWRGjRZUcrfu9QvplFYBpYnTPykO7FKOO0P3iF1g
         JDIjJ8YcGQfzq7EAsNMFrgvS3flNbuhpskIs8EEFONhezfV/9v3oOFTgKgcve6uLvrTL
         q6jYyNOFqHHrOl+ihvmPzk3eZ9P95K0UqaAJvK8FYT15XRq6JlVv9vrKOnOuao/+aLpd
         H6M54RberXl6ds4WUqfnMxSD9IRrjSYcCG+Fwu7sxzOCoHXfoSaMDTflP1Dvgo6igCNc
         +3MH1PeYUtcZ6UenkVUpKfwJiaDE8ktl/xZIccCbAbssF4bIcwaFDaGismJYlJnDzxa+
         oS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786246516; x=1786851316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=99aSv3oQy8bBTbpm4SMRqbPI3qurgIZlhYbHmHdiDcY=;
        b=fE4Jfr4Sdmk+cG8clsm5t+cDir2zT4xuNc5Ir0gtW8zbuqylq/wiljdki+T0DicrE4
         ReCBM/rZd6vxhomMOp+eWuUDXaWsyg4wWtNgMr1NJ63ewgIiWH8MHHJftT8nSPLP6GCP
         7UDHx87iaZf8ENlnaSDsd4nF7PtxofR9OGSAYqEeCR8JQpup9vC7NVIpcj5cSMzj44//
         Q7cDM6s8C7o/9YRHLaizG+xDG8pKQGpeTY228e/B4SZoBtx2w4rVR5TJSk7k6iwD6C4G
         QkeeqrpHIsM7BREykobBYKtJj65YF6/cFMG4/0LFVDhcqopzPlqgZglJtbei2CkiWP2S
         xagA==
X-Gm-Message-State: AOJu0YyvJ4hOaqbVEc7aURj893nQwp7gtnxJjtG7+6f8sUFk/S7HPNIs
	1zQFRx+LNmuIepyMGh+++00K+9Xjq4KQTVYI98dfVSzxVcVcAYRKmoAT
X-Gm-Gg: AR+sD10J9z/H5IGRB+iuJep0kan8IxcWLgk+wK1Fr9Ax/Q49o+G15NdkAWKV020whcW
	/W317hfBv6jliUjS0YinhM6LQBQ9gEOeSlg6+2zQ7yN+S9FNIrmQyq472PATfxqbNTy/EBEyh/z
	HLOUMkC6PE4bqIFBaA9S17i/4msr0Hna/PUKAtiXzRPVeHxJKYcsrEtysuPYo0c5sgRKlNm8/Ou
	J7TzQ99WAx4TV6ymE3DF9oYVfKVJuSISIh8M54CEKjUMeHupb4aYaC/vM0Ba8AkteghLNwOSZ3M
	3bVQ/s3p5c2MdTXvlCpfFZJbWP48hJ3rnSY1qrq5l6liI7UnvJJ0Zuw8yQ5uicEGJ2+HDTHZkNL
	8mVE1kjFWbdSiOm+FfxuGnAO0Jkxe7Y1spiL27I39PBIXpRgtHOslQtdBk0NKLlnq/QPVlIq02L
	bXNnUTKfdPMHf+12MmVWf6kGqEWauU9mHjfsHsabWt+4lr9juAK9S6rBQQCO+orpX0YN5FRh8qj
	2NViy9nGbGky2qzTpHyvD3oVVp7eTxBDKiruikYikmU+Z98ciosisxoozl0
X-Received: by 2002:a05:6a20:a10a:b0:3c4:3ada:384d with SMTP id adf61e73a8af0-3cb85f42d97mr35710340637.30.1786246516041;
        Sat, 08 Aug 2026 20:35:16 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8f1aa50esm2531160a12.9.2026.08.08.20.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 20:35:15 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] scsi: aacraid: fix DMA mapping leak in aac_send_raw_srb()
Date: Sat,  8 Aug 2026 21:34:49 -0600
Message-ID: <20260809033449.286233-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aac_send_raw_srb() maps each scatter/gather entry for DMA via
dma_map_single() across five separate code paths, depending on the
adapter type and SG format (native HBA, 64-bit host SG, 32-bit host
SG, and two legacy formats). None of these mappings are ever undone:
there is no dma_unmap_single() call anywhere in the file, on the
success path or any of the error paths that funnel through the
single cleanup label.

Every FSACTL_SEND_RAW_SRB ioctl that submits at least one SG entry
therefore leaks that many DMA mappings permanently. Under an IOMMU
or SWIOTLB this is a genuinely exhaustible resource: sustained use
(e.g. periodic smartctl -d aacraid,... polling) eventually drives
new DMA mappings to fail, surfacing as intermittent I/O failures
(aac_fib_send failing with -ENOMEM) and, left long enough, adapter
resets and system instability.

Fix this by tracking the DMA address returned from each of the five
dma_map_single() calls in a new per-entry array (sg_addr[]), zero
initialized alongside the existing sg_list[] array. In cleanup,
unmap each entry before freeing its backing memory, using the
sg_addr[i] != 0 check as a guard: some cleanup paths are reached
after sg_indx has been advanced for entry i but before that entry's
dma_map_single() call runs (e.g. a copy_from_user() failure), so
not every index in the cleanup loop was actually mapped.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220504
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index bd82aeb679ae..d4dffd6f8af0 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -492,6 +492,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	u32 data_dir;
 	void __user *sg_user[HBA_MAX_SG_EMBEDDED];
 	void *sg_list[HBA_MAX_SG_EMBEDDED];
+	dma_addr_t sg_addr[HBA_MAX_SG_EMBEDDED];
 	u32 sg_count[HBA_MAX_SG_EMBEDDED];
 	u32 sg_indx = 0;
 	u32 byte_count = 0;
@@ -517,6 +518,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
+	memset(sg_addr, 0, sizeof(sg_addr)); /* mark all entries unmapped */
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
 		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
 		rcode = -EFAULT;
@@ -690,6 +692,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 			addr = dma_map_single(&dev->pdev->dev, p, sg_count[i],
 					      data_dir);
+			sg_addr[i] = addr;
 			hbacmd->sge[i].addr_hi = cpu_to_le32((u32)(addr>>32));
 			hbacmd->sge[i].addr_lo = cpu_to_le32(
 						(u32)(addr & 0xffffffff));
@@ -752,7 +755,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				sg_addr[i] = addr;
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 				byte_count += sg_count[i];
@@ -808,7 +811,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				sg_addr[i] = addr;
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 				byte_count += sg_count[i];
@@ -865,7 +868,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      usg->sg[i].count,
 						      data_dir);
-
+				sg_addr[i] = addr;
 				psg->sg[i].addr = cpu_to_le32(addr & 0xffffffff);
 				byte_count += usg->sg[i].count;
 				psg->sg[i].count = cpu_to_le32(sg_count[i]);
@@ -905,7 +908,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				sg_addr[i] = addr;
 				psg->sg[i].addr = cpu_to_le32(addr);
 				byte_count += sg_count[i];
 				psg->sg[i].count = cpu_to_le32(sg_count[i]);
@@ -986,8 +989,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 cleanup:
 	kfree(user_srbcmd);
 	if (rcode != -ERESTARTSYS) {
-		for (i = 0; i <= sg_indx; i++)
+		for (i = 0; i <= sg_indx; i++) {
+			if (sg_addr[i])
+				dma_unmap_single(&dev->pdev->dev, sg_addr[i],
+						 sg_count[i], data_dir);
 			kfree(sg_list[i]);
+		}
 		aac_fib_complete(srbfib);
 		aac_fib_free(srbfib);
 	}
-- 
2.55.0

