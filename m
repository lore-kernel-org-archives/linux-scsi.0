Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DAB1B0435;
	Mon, 30 Jun 2025 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751282321; cv=none; b=hOeByh19ov1unuvfVez17n63AAO5as+0pDQlHO/VHLyTX0rKgdcQeIKh6ZSrPjBTz7IKU4LW9//+2nzioQNcs1qJvwoTN6R9cGwje799HQU3B2B3S2Yf9rTLeyXpXYdTckcXu8uaMZBNMeQm0S7Sesc3HGnlIA5ph8ZUAwKqs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751282321; c=relaxed/simple;
	bh=nKcIly6qaq1Nl910VPmWYltAsx8yIOGi9TwL2l47JKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rXHA99Snx4byqIkIrTYILBseeGYf+/pIrfKC/LW5Z6qPtvSt2KTaZx6LlcS2t2SHf9lDRp2t6hy5oV3VmbEF84kkFIXQWg34z1KnHyj9xUU2OdvuI0MRTIRX9A7o2obg27FZmef5WMMhKTuy1jJTJz7uAjppQIXXHvnApo9s9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDS+86l6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDS+86l6"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a528e301b0so134901f8f.1;
        Mon, 30 Jun 2025 04:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751282318; x=1751887118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4bHSrGkiQpDnv6V2m1S1L8Uez278g9vphJNWWJac9vY=;
        b=lDS+86l6vfroD9D2y2sVFTiIuxFSSTo0ojDmanHX4VJ6Xph8OHwS3ciflH4ia+QpiY
         LKx80Zf6yFRKfsTkkN+rm2/3EYCpRYhwFnWnm9aGyUZaAwP3yFej4zCJZ9vUWzjSjn4f
         E16/f/GEk8ae18QQKQ/mdnVRBzOzK/WL9/gdOYbkMf4UT/mwFqCCB7BwftHN2lZ5nUXC
         UtyusmtT/iB0QqirS+C69MWhMpJ3k1ILLOJtIlg3zKbyablF4Ijg37L1E1Q7TtfeJVpG
         JsOZ8AcavdzYXMW9B8UxUPO8WnDxKgEHNcKMLMe4WFBPUwHmtzWjM/sOAOciqY2rMXQm
         DcKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751282318; x=1751887118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4bHSrGkiQpDnv6V2m1S1L8Uez278g9vphJNWWJac9vY=;
        b=ZjefrvQqehLwDhj+C4ITZUEnNU8AGbN0/Nx3e9ZkJVHumdkXW3nKyAO5Zr0jNslyIb
         AMXA7sWM03opxnbiaErcuIXql77uAKFPJlGahdEACYfdFm+gTWXrZAY33y0VMC7LhhFN
         NCkmJ98b27pht18qRornCC2OQrzeOB/WrNeTqw01Ll322A8uNzIbwkA8E+LbQXf6P273
         D1GnZPPZn0FPVUKcHmDVsHWinMPTEJFEOUMi0oZXxCroZBZsR6T2eACCb9kSJ0XEOxd6
         ljLjSlND8fQKHMfX6eXB4YS0TSBrUu/7mPiwLIG7V0sS/iJJT7ljUQbPb2UxD9/COUjK
         +NKg==
X-Forwarded-Encrypted: i=1; AJvYcCUiZmBMbGrEil1BKH+Ik2O3/19dMGoj0Fz64S4pz8usP1nrfU/QcpeyBYZJIu2/19ad8RNtTFN6bWStBsqb@vger.kernel.org, AJvYcCVUKcApRQuWvWBuaBGv17pWPJJY54dVSj792AQxYvQn+MHtdc10Dbkm8Pm+Ym3PQtGdVNNk499sRPS3oA==@vger.kernel.org, AJvYcCW9ypGJiekyf7LCzqNOQxZRUmVNTS0VLCxdGL8VzJDPkv97cfaf32D/0DpBzqkoN9cLipRTbH7pGz1eBE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywugza07xj50pt6IhqZXiIK7sIvp6WWqe5rTY4O1rIBKp2sD+sB
	KEnC/NAGfz6PRiDCFY2ml7MuEQchjQ83QNwLO4cc3W9OsX++j1H5N0lM
X-Gm-Gg: ASbGncvOn4Omo4yXfGv5U5NuDJfD3WcR/vuN0Dt/N8tLvYG1FgiW8rU+TFc/QnCRG+l
	TEZkrna/BVMXDaAZay/mV15yxeF/Z/dwb7++4B0HU1+jY3mlAExPGMjhHDS2NFcvsMH3bTy45Qk
	HbZX7LPvOXexUVHFb2tvSBAG4D91JbO2lemtmwOBo5EcL3/1QCEPdxq61YOUrL/+MeU1BiJ8ZEV
	Voc/NVbnVK8K9KBBUquboAm6qPbYtJGDR5BmlN9/pVQ14SPrPWfrXsluBGJ5pSqp/Z0OUlXEQIN
	Kvz1UzwDnxE5iM9YVHm+QkMc8M+BU2gLtlb6X6LmNgxNSZNNZW97MrLysfTZf7FO/fDEQtmpAqX
	seKUI0rUdHev7ta9akjP8mL6X
X-Google-Smtp-Source: AGHT+IFdIa5i+fsO4DexCnu4Udg7U+ph+4pACdyaAuy7OOOpwvuoUSrPIyws5b5Rh7q2WXLZTCK1fQ==
X-Received: by 2002:a5d:5849:0:b0:3a4:e0e1:8dc8 with SMTP id ffacd0b85a97d-3aaf4a75781mr2515514f8f.9.1751282317752;
        Mon, 30 Jun 2025 04:18:37 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:43e:be8c:f80c:622a])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a88c7ec6aesm10112826f8f.5.2025.06.30.04.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 04:18:37 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Steven Royer <seroyer@linux.vnet.ibm.com>,
	"Bryant G. Ly" <bryantly@linux.vnet.ibm.com>,
	Michael Cyr <mikecyr@linux.vnet.ibm.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ibmvscsis: Fix dma_unmap_sg() nents value
Date: Mon, 30 Jun 2025 13:18:02 +0200
Message-ID: <20250630111803.94389-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 88a678bbc34c ("ibmvscsis: Initial commit of IBM VSCSI Tgt Driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/libsrp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/libsrp.c b/drivers/scsi/ibmvscsi_tgt/libsrp.c
index 8a0e28aec928..0ecad398ed3d 100644
--- a/drivers/scsi/ibmvscsi_tgt/libsrp.c
+++ b/drivers/scsi/ibmvscsi_tgt/libsrp.c
@@ -184,7 +184,8 @@ static int srp_direct_data(struct ibmvscsis_cmd *cmd, struct srp_direct_buf *md,
 	err = rdma_io(cmd, sg, nsg, md, 1, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+			     DMA_BIDIRECTIONAL);
 
 	return err;
 }
@@ -256,7 +257,8 @@ static int srp_indirect_data(struct ibmvscsis_cmd *cmd, struct srp_cmd *srp_cmd,
 	err = rdma_io(cmd, sg, nsg, md, nmd, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+			     DMA_BIDIRECTIONAL);
 
 free_mem:
 	if (token && dma_map) {
-- 
2.43.0

