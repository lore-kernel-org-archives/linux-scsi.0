Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428EC1CB322
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594387; cv=none; b=cu9mbKmuK8OociB/YujRegpBwcONoOq9ww4+s8SSFmc0VJ0gJijh8v+x+fG7XrJHWKn2iO9hihK78pfFNW9JLYn4bR1LSycHqBzhmzw3NyWa6g1N7fNLGRzVzfpMQz9d2HOdlox9WJ580ljOR6F5/8XJs9cth3qBZ5mCXIRB7EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594387; c=relaxed/simple;
	bh=9So4BZMf5XjyQ1XyzPVmP6biJ5yXu5JY4/YOZnbmTio=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJ1D4cGexPKvfdWknyWvmv9wpA4wxyjYam4G01XyvUNEjFSYH3WLDYOQUwYHt+6AGU2Wgeb1kUIronlnCakd+ZWFUHtJnAD/sspu7DLcGCDvfrZzQnpxENN6PN9LYcN0yf1lc6loDem53zvL/30M0sFkScs5GEsVkjTFpSuK6CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPeaq1ac; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPeaq1ac"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70677fe5d87so41973b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594385; x=1720199185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKgOvlTc0UfjL+qcFfB925sH1IjQwSnOhFoOsm7UVZ8=;
        b=ZPeaq1ac90pOPR83DVHhWTylXjxQaaiWhQn958TN8IQ58e6Dz72tMUio+/fi2q+Vhi
         oFXI5lr2BIlhriLrnvuGew/YSxzoeERUrFzbNqsCycn1DLv0EtQW6F/kNtlFpmxGB0eu
         /dk7lfUHZFPXWc6Q7ITE99HGwIwngR13NwcAP04VRMT3C08ooXXaTD4olWObPPSCff/J
         L+bgji65Q9L91rtCp/Z0FigJkD45qQioDsYcHsWJRfV6NCUNO0zMeP0sre9EAU4riA0O
         JqFxhmmLB2rF4tFaQMIxLLTX9GEumpSU4wcx3eur7p6SM/zwt8tzIpMZi6IpkxT/5H0M
         iZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594385; x=1720199185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dKgOvlTc0UfjL+qcFfB925sH1IjQwSnOhFoOsm7UVZ8=;
        b=HV+dH2ORytyP7ZkXUazVT6PL11eKY8KIQi9gshfYxO7Tk31OP6aH1ZYAY5Hucc0F45
         C/waR3YBo07qYBSHzYVs9JC16Lcnl3uJcn5MbnCjz6kYn+k++yziLPLNtWAEq3Wk+WE0
         5ZEJMrN8ITrNnSssSbjNCpCvhnn92ZRRykGuqUDvzy3el2uBddSadFMdcMSUx6I7ZIq+
         mOdwhCZ9cBouG9smjI6UvS7U5YX0OC7Wg8CBniNA8d6YR3kGGXtEsoCOZwT9GFxGw+9n
         N5aBclDQfqjKs8iqejN0FNhTRvkI02iINRYm7Uhi9rqqXKqEr3Rs5sKrhSW+xMWaQaas
         fyuw==
X-Gm-Message-State: AOJu0YzqSLStI3+Wq3RJdHdcoj5slfVniMHoDSWvW7LexKU8vcADMZXP
	LPLP0suQ3me75VePcmgoP/AOPiY+MRXotHbovs3qfry1e5xA43DucSSXMw==
X-Google-Smtp-Source: AGHT+IEwpEgTM35JjFiIGMf+1wkBFbpGJyzr+raBp2kiM4YUFbMhgzuWQ1DEa4uuoOtcjKKqgc7WVg==
X-Received: by 2002:a05:6a00:8702:b0:705:daf0:9004 with SMTP id d2e1a72fcca58-706680c1610mr19162822b3a.3.1719594385254;
        Fri, 28 Jun 2024 10:06:25 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:24 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/8] lpfc: Revise lpfc_prep_embed_io routine with proper endian macro usages
Date: Fri, 28 Jun 2024 10:20:10 -0700
Message-Id: <20240628172011.25921-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On big endian architectures, it is possible to run into a memory out of
bounds pointer dereference when FCP targets are zoned.

In lpfc_prep_embed_io, the memcpy(ptr, fcp_cmnd, sgl->sge_len) is
referencing a little endian formatted sgl->sge_len value.  So, the memcpy
can cause big endian systems to crash.

Redefine the *sgl ptr as a struct sli4_sge_le to make it clear that we are
referring to a little endian formatted data structure.  And, update the
routine with proper le32_to_cpu macro usages.

Fixes: af20bb73ac25 ("scsi: lpfc: Add support for 32 byte CDBs")

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8bfac9143314..88debef2fb6d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10579,10 +10579,11 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 {
 	struct lpfc_iocbq *piocb = &lpfc_cmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &lpfc_cmd->cur_iocbq.wqe;
-	struct sli4_sge *sgl;
+	struct sli4_sge_le *sgl;
+	u32 type_size;
 
 	/* 128 byte wqe support here */
-	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
+	sgl = (struct sli4_sge_le *)lpfc_cmd->dma_sgl;
 
 	if (phba->fcp_embed_io) {
 		struct fcp_cmnd *fcp_cmnd;
@@ -10591,9 +10592,9 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		fcp_cmnd = lpfc_cmd->fcp_cmnd;
 
 		/* Word 0-2 - FCP_CMND */
-		wqe->generic.bde.tus.f.bdeFlags =
-			BUFF_TYPE_BDE_IMMED;
-		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
+		type_size = le32_to_cpu(sgl->sge_len);
+		type_size |= ULP_BDE64_TYPE_BDE_IMMED;
+		wqe->generic.bde.tus.w = type_size;
 		wqe->generic.bde.addrHigh = 0;
 		wqe->generic.bde.addrLow =  72;  /* Word 18 */
 
@@ -10602,13 +10603,13 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		/* Word 18-29  FCP CMND Payload */
 		ptr = &wqe->words[18];
-		memcpy(ptr, fcp_cmnd, sgl->sge_len);
+		lpfc_sli_pcimem_bcopy(fcp_cmnd, ptr, le32_to_cpu(sgl->sge_len));
 	} else {
 		/* Word 0-2 - Inline BDE */
 		wqe->generic.bde.tus.f.bdeFlags =  BUFF_TYPE_BDE_64;
-		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
-		wqe->generic.bde.addrHigh = sgl->addr_hi;
-		wqe->generic.bde.addrLow =  sgl->addr_lo;
+		wqe->generic.bde.tus.f.bdeSize = le32_to_cpu(sgl->sge_len);
+		wqe->generic.bde.addrHigh = le32_to_cpu(sgl->addr_hi);
+		wqe->generic.bde.addrLow = le32_to_cpu(sgl->addr_lo);
 
 		/* Word 10 */
 		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
-- 
2.38.0

