Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CC12D46CE
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988594; cv=none; b=pLt4ggaSrv+58HHcwcKPYdTzYnCyLW5OqNQx/Prs4f9mmMNygQrWYqECakGVfndy6L52iya7pQUajnR2MBsUx3XMdolVvMrzbB3zOnBW9s/2XVrta7tVomy3uW2b937hZbbHas6SF0rjCNnHOwjdxoru+624BLhw+/DDBj8Nl0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988594; c=relaxed/simple;
	bh=mXoJk1WXOUnq9MS8Ng0qOAfeNZ0+rPxUJo/Da60hhNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PKoGL85AQAuKoyKG9WcsfgQJiLXkxzVqZGMQ/fh8Lt+6vcYPM3PCP2kzuv0XxqlvkQJGFnXMVQas9Qkxaw5vP9pjVLIb4TRgE9xgbBbgwxBGppoQuXeiKK1DDz0josTM1aWUrJ2oYMSdXuiwZanyhPrq0kFTCvR2QdG//wKdBWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qcge2m5Y; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qcge2m5Y"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a032383008so46393006d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988591; x=1775593391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4z0tHKJEn7SCBCALxiXeKOsOGMmNWaaIlP6NvxQq5s=;
        b=Qcge2m5YQfwZO6DWN/7A4AYeZTvJHi8sETuUblPTQvgfJFzEqwDhEfftCooQcGETm6
         2NdFgs8RC7IvzmeVjrzT6Y36uADC9St58kezwSkMDXKNMpwEX+HoHqQxFVSRWX4TEyKs
         jlGjoAwQRjdwAx4Tlm6ONG4ghzgPFQGUjdGYWc/ge84zioy8mJXoqx0dKWgvINd4yJVG
         qzKR+LYD0Go8kFSsIepVBVaSRAEXDAYy1p88wh2DOn8oMysvOIWCUxo5+DWuE9tH4lVT
         up7drra/ku5nczQI1dWQF20AFXTXAodqIirD9wpjtv1ZQiy1PH52f9QoGHAAbKDmiDNw
         qYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988591; x=1775593391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q4z0tHKJEn7SCBCALxiXeKOsOGMmNWaaIlP6NvxQq5s=;
        b=X0l1UUHJCabiNIj5AoqEMeGZKwn7spKcdHwCaiP36E5JYSLSX923dlqYUp3pW02Zrr
         tPI1cPr8mlJesWs1SXKZAWr3kM5DragYAPf5kSPKK+uyZ6si7miNX0R6L+PI2NwPqZ4u
         SW+ur8FcTi7j9AMANJXX8kW6TYSgrlckRRcZ/aPRco8cv5ZloYo8Nhje3y2gOHxuPcTK
         qhEBXisll+lMM+7J/DLpXa+V2bpUDti/wVMCXGSN9ebYL7YYqaJvW9bmvSUvuJ6CLMOM
         6xp38M34VBXiL9j4WZOtslLb/2oocKciEAMWxuxudTIdtS3DL70ZgunS25qMks0tuVgz
         RvnQ==
X-Gm-Message-State: AOJu0YyZUybrGGLiOpCoMeeI5+VRQLzDAEfG1m8D62vD8sAVMFAB+jeu
	9c0LoFpGLvHcEgZVAEHCQOWOqC04ou9fGn/nmu1mbRSdU2xI0oW3bvVMzNeC1g==
X-Gm-Gg: ATEYQzztAVxz62IwjUcFHDEfP37TZJChcp07E+UR3lVih/PiEJsW7Cv8IKlJuWBmelF
	mA82s1bfVLRPSXOaaZeHcADcMee89rBAgI5CpC2bd2kMu59cwptKnciTROwNgQ2fMHs9MjdCvLw
	RyXNmkoazWHSmb2Kn6R0KMSolSnnBJW49qhNVrT5HNCRARUqvqkydc0xttWRVbtYdq1XBZjzqQ9
	ezDPXNVTg4i0QShFTCR0SjUxPvRPFL1kr60O4OnPCNSa/RiJ+XjNWtHwiZOiSJcMRJzu9xhkSNy
	98YpxQ26/C7zRpHVGTPIv/Jt+EOakJHAR1f3O2VZg+l302fXmydooXwVVHpkW33GELSgOkR2Geq
	ffDtuuHTllQZ844yoyoLEHZoO2MNrsEQrlaCaJX23bpFeaEHCSDSbQhd0glOa0ALCQwEiFnM2e9
	UhoKNijueuTsOCDPS1rxDKiUrWvw9xrmRLbFNAB8luhiNf6+5kuEsbJeL17H/KpGd12qyiIstyH
	KKLj9Xm23NIZWOZLeuE9tRGLihtAE4BcggekoyKKT8=
X-Received: by 2002:a05:6214:601b:b0:8a1:f18d:1b with SMTP id 6a1803df08f44-8a439e8aa0amr14268706d6.49.1774988591114;
        Tue, 31 Mar 2026 13:23:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:10 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/10] lpfc: Update construction of SGL when XPSGL is enabled
Date: Tue, 31 Mar 2026 13:59:24 -0700
Message-Id: <20260331205928.119833-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The construction of SGLs is updated to safeguard ASIC boundary
requirements when using XPSGL.

The LSP type SGE is used to notify where a continuing SGL resides.
Typically, this means that the LSP is the last SGE in an SGL because the
current SGL has reached its maximum size and the LSP is used to refer to
the next follow up SGL.  Due to ASIC boundary requirements, there is a need
to ensure a 4 KB boundary is not crossed.  Thus, for a maximum size of 256
byte SGLs or 16 SGEs, this means restricting the LSP to being the 12th SGE
for the very first SGL that is used for pre-registration.  If additional
SGEs are needed, the LSP will be the last SGE position within that follow
up SGL as was previously implemented.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c |  30 ++++++----
 drivers/scsi/lpfc/lpfc_scsi.c | 103 ++++++++++++++++++++++------------
 2 files changed, 87 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 81b8fe69f2bc..71714ea390d9 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1339,7 +1339,7 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 	dma_addr_t physaddr = 0;
 	uint32_t dma_len = 0;
 	uint32_t dma_offset = 0;
-	int nseg, i, j;
+	int nseg, i, j, k;
 	bool lsp_just_set = false;
 
 	/* Fix up the command and response DMA stuff. */
@@ -1379,6 +1379,9 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 
 		/* for tracking the segment boundaries */
 		j = 2;
+		k = 5;
+		if (unlikely(!phba->cfg_xpsgl))
+			k = 1;
 		for (i = 0; i < nseg; i++) {
 			if (data_sg == NULL) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -1397,9 +1400,8 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 				bf_set(lpfc_sli4_sge_last, sgl, 0);
 
 				/* expand the segment */
-				if (!lsp_just_set &&
-				    !((j + 1) % phba->border_sge_num) &&
-				    ((nseg - 1) != i)) {
+				if (!lsp_just_set && (nseg != (i + k)) &&
+				    !((j + k) % phba->border_sge_num)) {
 					/* set LSP type */
 					bf_set(lpfc_sli4_sge_type, sgl,
 					       LPFC_SGE_TYPE_LSP);
@@ -1422,8 +1424,8 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 				}
 			}
 
-			if (!(bf_get(lpfc_sli4_sge_type, sgl) &
-				     LPFC_SGE_TYPE_LSP)) {
+			if (bf_get(lpfc_sli4_sge_type, sgl) !=
+			    LPFC_SGE_TYPE_LSP) {
 				if ((nseg - 1) == i)
 					bf_set(lpfc_sli4_sge_last, sgl, 1);
 
@@ -1444,19 +1446,25 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 				sgl++;
 
 				lsp_just_set = false;
+				j++;
 			} else {
 				sgl->word2 = cpu_to_le32(sgl->word2);
-
-				sgl->sge_len = cpu_to_le32(
-						     phba->cfg_sg_dma_buf_size);
+				/* will remaining SGEs fill the next SGL? */
+				if ((nseg - i) < phba->border_sge_num)
+					sgl->sge_len =
+						cpu_to_le32((nseg - i) *
+								sizeof(*sgl));
+				else
+					sgl->sge_len =
+						cpu_to_le32(phba->cfg_sg_dma_buf_size);
 
 				sgl = (struct sli4_sge *)sgl_xtra->dma_sgl;
 				i = i - 1;
 
 				lsp_just_set = true;
+				j += k;
+				k = 1;
 			}
-
-			j++;
 		}
 	} else {
 		lpfc_ncmd->seg_cnt = 0;
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f11f2c29db89..1dce33b79beb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1938,7 +1938,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
-	int j;
+	int j, k;
 	bool lsp_just_set = false;
 
 	status  = lpfc_sc_to_bg_opcodes(phba, sc, &txop, &rxop);
@@ -2001,13 +2001,16 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	/* assumption: caller has already run dma_map_sg on command data */
 	sgde = scsi_sglist(sc);
 	j = 3;
+	k = 5;
+	if (unlikely(!phba->cfg_xpsgl))
+		k = 1;
 	for (i = 0; i < datasegcnt; i++) {
 		/* clear it */
 		sgl->word2 = 0;
 
-		/* do we need to expand the segment */
-		if (!lsp_just_set && !((j + 1) % phba->border_sge_num) &&
-		    ((datasegcnt - 1) != i)) {
+		/* do we need to expand the segment? */
+		if (!lsp_just_set && (datasegcnt != (i + k)) &&
+		    !((j + k) % phba->border_sge_num)) {
 			/* set LSP type */
 			bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_LSP);
 
@@ -2026,7 +2029,7 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 			bf_set(lpfc_sli4_sge_type, sgl, LPFC_SGE_TYPE_DATA);
 		}
 
-		if (!(bf_get(lpfc_sli4_sge_type, sgl) & LPFC_SGE_TYPE_LSP)) {
+		if (bf_get(lpfc_sli4_sge_type, sgl) != LPFC_SGE_TYPE_LSP) {
 			if ((datasegcnt - 1) == i)
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 			physaddr = sg_dma_address(sgde);
@@ -2043,20 +2046,23 @@ lpfc_bg_setup_sgl(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 			sgl++;
 			num_sge++;
+			j++;
 			lsp_just_set = false;
-
 		} else {
 			sgl->word2 = cpu_to_le32(sgl->word2);
-			sgl->sge_len = cpu_to_le32(phba->cfg_sg_dma_buf_size);
-
+			/* will remaining SGEs fill the next SGL? */
+			if ((datasegcnt - i) < phba->border_sge_num)
+				sgl->sge_len = cpu_to_le32((datasegcnt - i) *
+								sizeof(*sgl));
+			else
+				sgl->sge_len =
+					cpu_to_le32(phba->cfg_sg_dma_buf_size);
 			sgl = (struct sli4_sge *)sgl_xtra->dma_sgl;
 			i = i - 1;
-
+			j += k;
 			lsp_just_set = true;
+			k = 1;
 		}
-
-		j++;
-
 	}
 
 out:
@@ -2109,6 +2115,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	struct scatterlist *sgde = NULL; /* s/g data entry */
 	struct scatterlist *sgpe = NULL; /* s/g prot entry */
 	struct sli4_sge_diseed *diseed = NULL;
+	struct sli4_sge_le *lsp_sgl = NULL;
 	dma_addr_t dataphysaddr, protphysaddr;
 	unsigned short curr_prot = 0;
 	unsigned int split_offset;
@@ -2125,8 +2132,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	uint32_t rc;
 #endif
 	uint32_t checking = 1;
-	uint32_t dma_offset = 0, num_sge = 0;
-	int j = 2;
+	uint32_t dma_offset = 0, num_sge = 0, lsp_len;
+	int j = 2, k = 4;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
 
 	sgpe = scsi_prot_sglist(sc);
@@ -2157,6 +2164,8 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 	}
 #endif
 
+	if (unlikely(!phba->cfg_xpsgl))
+		k = 0;
 	split_offset = 0;
 	do {
 		/* Check to see if we ran out of space */
@@ -2164,10 +2173,10 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		    !(phba->cfg_xpsgl))
 			return num_sge + 3;
 
-		/* DISEED and DIF have to be together */
-		if (!((j + 1) % phba->border_sge_num) ||
-		    !((j + 2) % phba->border_sge_num) ||
-		    !((j + 3) % phba->border_sge_num)) {
+		/* DISEED and DIF have to be together  */
+		if (!((j + k + 1) % phba->border_sge_num) ||
+		    !((j + k + 2) % phba->border_sge_num) ||
+		    !((j + k + 3) % phba->border_sge_num)) {
 			sgl->word2 = 0;
 
 			/* set LSP type */
@@ -2186,9 +2195,18 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 			sgl->word2 = cpu_to_le32(sgl->word2);
 			sgl->sge_len = cpu_to_le32(phba->cfg_sg_dma_buf_size);
+			if (lsp_sgl) {
+				j++;
+				if (j % phba->border_sge_num) {
+					lsp_len = j * (sizeof(*sgl));
+					lsp_sgl->sge_len = cpu_to_le32(lsp_len);
+				}
+			}
+			lsp_sgl = (struct sli4_sge_le *)sgl;
 
 			sgl = (struct sli4_sge *)sgl_xtra->dma_sgl;
 			j = 0;
+			k = 0;
 		}
 
 		/* setup DISEED with what we have */
@@ -2291,7 +2309,7 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 				return 0;
 			}
 
-			if (!((j + 1) % phba->border_sge_num)) {
+			if (!((j + k + 1) % phba->border_sge_num)) {
 				sgl->word2 = 0;
 
 				/* set LSP type */
@@ -2313,8 +2331,11 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 				sgl->word2 = cpu_to_le32(sgl->word2);
 				sgl->sge_len = cpu_to_le32(
 						     phba->cfg_sg_dma_buf_size);
+				lsp_sgl = (struct sli4_sge_le *)sgl;
 
 				sgl = (struct sli4_sge *)sgl_xtra->dma_sgl;
+				j = 0;
+				k = 0;
 			} else {
 				dataphysaddr = sg_dma_address(sgde) +
 								   split_offset;
@@ -2362,11 +2383,9 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 
 				/* Move to the next s/g segment if possible */
 				sgde = sg_next(sgde);
-
 				sgl++;
+				j++;
 			}
-
-			j++;
 		}
 
 		if (protgroup_offset) {
@@ -2381,6 +2400,14 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 			sgl--;
 			bf_set(lpfc_sli4_sge_last, sgl, 1);
 			alldone = 1;
+
+			/* Reset length in previous LSP where necessary */
+			if (lsp_sgl) {
+				if (j % phba->border_sge_num) {
+					lsp_len = j * (sizeof(*sgl));
+					lsp_sgl->sge_len = cpu_to_le32(lsp_len);
+				}
+			}
 		} else if (curr_prot < protcnt) {
 			/* advance to next prot buffer */
 			sgpe = sg_next(sgpe);
@@ -2392,7 +2419,6 @@ lpfc_bg_setup_sgl_prot(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"9085 BLKGRD: bug in %s\n", __func__);
 		}
-
 	} while (!alldone);
 
 out:
@@ -3056,7 +3082,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	dma_addr_t physaddr;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
-	int nseg, i, j;
+	int nseg, i, j, k;
 	bool lsp_just_set = false;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
 
@@ -3111,6 +3137,9 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		/* for tracking segment boundaries */
 		sgel = scsi_sglist(scsi_cmnd);
 		j = 2;
+		k = 5;
+		if (unlikely(!phba->cfg_xpsgl))
+			k = 1;
 		for (i = 0; i < nseg; i++) {
 			sgl->word2 = 0;
 			if (nseg == 1) {
@@ -3121,9 +3150,8 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				bf_set(lpfc_sli4_sge_last, sgl, 0);
 
 				/* do we need to expand the segment */
-				if (!lsp_just_set &&
-				    !((j + 1) % phba->border_sge_num) &&
-				    ((nseg - 1) != i)) {
+				if (!lsp_just_set && (nseg != (i + k)) &&
+				    !((j + k) % phba->border_sge_num)) {
 					/* set LSP type */
 					bf_set(lpfc_sli4_sge_type, sgl,
 					       LPFC_SGE_TYPE_LSP);
@@ -3147,8 +3175,8 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				}
 			}
 
-			if (!(bf_get(lpfc_sli4_sge_type, sgl) &
-				     LPFC_SGE_TYPE_LSP)) {
+			if (bf_get(lpfc_sli4_sge_type, sgl) !=
+			    LPFC_SGE_TYPE_LSP) {
 				if ((nseg - 1) == i)
 					bf_set(lpfc_sli4_sge_last, sgl, 1);
 
@@ -3168,19 +3196,24 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 				sgl++;
 				lsp_just_set = false;
-
+				j++;
 			} else {
 				sgl->word2 = cpu_to_le32(sgl->word2);
-				sgl->sge_len = cpu_to_le32(
-						     phba->cfg_sg_dma_buf_size);
-
+				/* will remaining SGEs fill the next SGL? */
+				if ((nseg - i) < phba->border_sge_num)
+					sgl->sge_len =
+						cpu_to_le32((nseg - i) *
+								sizeof(*sgl));
+				else
+					sgl->sge_len =
+						cpu_to_le32(phba->cfg_sg_dma_buf_size);
 				sgl = (struct sli4_sge *)sgl_xtra->dma_sgl;
 				i = i - 1;
 
 				lsp_just_set = true;
+				j += k;
+				k = 1;
 			}
-
-			j++;
 		}
 	} else {
 		sgl += 1;
-- 
2.38.0

