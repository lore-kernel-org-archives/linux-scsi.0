Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612F62594B9
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 01:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773969018; cv=none; b=LQLPMCQWKhTw880aYgPFI6vFpRsG/ORXQAaG8EDP2WFn8AV7M3fvv4u7GvmiDitLD5ajpCA5l2nRwKeva1HxdKGTVxqjsOYV4+WUJJ7FDKKdzmza/WZ8Vy1w5nW2USZURlck+dch6KpvbQLFT89TpqcyrK3J5D+Y7da0a87xf04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773969018; c=relaxed/simple;
	bh=27JPzjJMDDgjf2qMis3eedxFTyNiAGX6kPcAnzP2/20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OlIcH6cWKezBQEt3zIOm7C1+LfgifL6WEGjjO8DYx5+mxAIGXjzN/lp/puQqvAB3k5NqBm36vzlZ0E1kGFoiQAJChjkE/6PudkeJFPuOGnVjBxedjGTDZcCG1L8Be2gQ3zSBDpEw0o673p6AiEo9nWlhM24RmS7WxPbVerXoMfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmZlfiPd; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmZlfiPd"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64ea5b45673so1098500d50.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 18:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773969016; x=1774573816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qdP8K3+cAzx0ganXl8vq/PIp0ujTWW+NWr7suf1Oel0=;
        b=kmZlfiPdODOCvSU3eIci9NvNQzSPXDG0VOJinngreh/sycfaobk1/gN6c24bKbGk59
         GUuCkxe3zL7On+7dEWrf/kgfgxgbVJOvh1PLekF8opDHCRhWvsw6V7PRMrC9w8t01cbl
         q2lgoNCY9ajBXG3WXser4o4KH59xPbwJA9wG5bbKnXfA0XFbJ+5zEe07frfc8jFm2D6z
         p4i5XPyruwbw2Td57o4542JOnEmIDemPdV+/IVrenwmFl3q9JqZ8eCYdjicmEJLKHN97
         51p6oHqHs9sTno4SypOBM1ozb6vw70B6Ns8+bT1rJIQuNvH+dfZYDAkVO/NsdvqVHiyn
         bf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773969016; x=1774573816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdP8K3+cAzx0ganXl8vq/PIp0ujTWW+NWr7suf1Oel0=;
        b=GIlT6TU7aVftbW76kIn8IcSFNtDkpHdYttoKm7bIOxE0gKqHtCH+5m7yb+l5Wj117Y
         0qJU57Q+k8uonJeB1HXlA5Tke9c8Ae935zpWTHRDPrA7FnisKD2tF+OUDCFvoaRmNIAP
         /dWAUlsibWdkbbt/1s2stXehhMd7WOd7LMoBwgUKgBK9nMtbgYyoNupt59DRpyQ4CFHL
         /wlkCZ9474d5EpeMBd1rVTFLo6AL1LnSKYaGaSEAyK9pkrSgGZJY1OiRS24o4ETMZMmp
         8y/qbxwGhIU7Pp/WEF/9iTsQMKML6V/MmB9K6OdYA2BdMKRET5/7rTQpBQZ5AIl8kmSW
         3CWw==
X-Gm-Message-State: AOJu0YxGRrjzjmcoGSTG71tHaf7bqo/c+/gWzVMfD8kmH10uKKLE33I3
	7snPCZWf88pz/HgBtq2zHHLHyaWweMq+Amv0+X3h6v4ColWpabMMjQBn24lmRkU7
X-Gm-Gg: ATEYQzzFbVqmjjzr5Fm8LDD/EUsNXcAE9UFUHwkNNRBnX39QhBQizCKKnTgT5mKmvoz
	YuTkNO9L90FQ7MxJYmYF4ssD2JOtP2n7dSAl/YqxUxBQxCgTGKBsUX9X2Vhtku1KJ5MnVXBixFM
	14DDoKkowrkeYtUZwEZqFIcA4Rgxp3M+Z619xtp9Knu2IPA/b06h69zGaqHi5uJksk+hBARrJCJ
	RpQoV6ms4iQBMQR6a99OpgJw20PHdOtWJWlZZxvC9A1YLH0JwwK7XKdsP/iDaVdI4tcjHbQV8hq
	SBIKbI+szNj26GGGiUNd6VokcWj3ObpJ8VuLrBrOmnkBaQ29CJq2v1pE72aRM7pfEuAP0AOjaIX
	JSAiUoSv1EY68n3Cg+GoWnVP1jNqDe2galKKpZhU3k6S9AD5dYlEAXXonC70cAEcwiuiRKC+Z56
	j0+8f5xW2sbw6/ChM+Pnt7jc9Jq5JgqAfV9FJEsOIdjyLj3W1HBLfpSi0=
X-Received: by 2002:a05:690e:e11:b0:64a:db29:5e61 with SMTP id 956f58d0204a3-64eaacd241fmr1049059d50.32.1773969016093;
        Thu, 19 Mar 2026 18:10:16 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabd44121sm515493d50.1.2026.03.19.18.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 18:10:15 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH] scsi: be2iscsi: kzalloc + kcalloc to kzalloc_flex
Date: Thu, 19 Mar 2026 18:09:57 -0700
Message-ID: <20260320010957.32355-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplifies allocation by using a flexible array member

Added __counted_by for extra runtime analysis.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 27 ++-------------------------
 drivers/scsi/be2iscsi/be_main.h |  4 ++--
 2 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..782a21af01a3 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2470,22 +2470,15 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	struct mem_array *mem_arr, *mem_arr_orig;
 	unsigned int i, j, alloc_size, curr_alloc_size;
 
-	phba->phwi_ctrlr = kzalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
+	phba->phwi_ctrlr = kzalloc_flex(*phba->phwi_ctrlr, wrb_context, phba->params.cxns_per_ctrl);
 	if (!phba->phwi_ctrlr)
 		return -ENOMEM;
 
 	/* Allocate memory for wrb_context */
 	phwi_ctrlr = phba->phwi_ctrlr;
-	phwi_ctrlr->wrb_context = kzalloc_objs(struct hwi_wrb_context,
-					       phba->params.cxns_per_ctrl);
-	if (!phwi_ctrlr->wrb_context) {
-		kfree(phba->phwi_ctrlr);
-		return -ENOMEM;
-	}
 
 	phba->init_mem = kzalloc_objs(*mem_descr, SE_MEM_MAX);
 	if (!phba->init_mem) {
-		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -2493,7 +2486,6 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	mem_arr_orig = kmalloc_objs(*mem_arr_orig, BEISCSI_MAX_FRAGS_INIT);
 	if (!mem_arr_orig) {
 		kfree(phba->init_mem);
-		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -3992,25 +3984,12 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
-			ptr_cid_info = kzalloc_obj(struct ulp_cid_info);
-
+			ptr_cid_info = kzalloc_flex(*ptr_cid_info, cid_array, BEISCSI_GET_CID_COUNT(phba, ulp_num));
 			if (!ptr_cid_info) {
 				ret = -ENOMEM;
 				goto free_memory;
 			}
 
-			/* Allocate memory for CID array */
-			ptr_cid_info->cid_array =
-				kcalloc(BEISCSI_GET_CID_COUNT(phba, ulp_num),
-					sizeof(*ptr_cid_info->cid_array),
-					GFP_KERNEL);
-			if (!ptr_cid_info->cid_array) {
-				kfree(ptr_cid_info);
-				ptr_cid_info = NULL;
-				ret = -ENOMEM;
-
-				goto free_memory;
-			}
 			ptr_cid_info->avlbl_cids = BEISCSI_GET_CID_COUNT(
 						   phba, ulp_num);
 
@@ -4061,7 +4040,6 @@ static int hba_setup_cid_tbls(struct beiscsi_hba *phba)
 			ptr_cid_info = phba->cid_array_info[ulp_num];
 
 			if (ptr_cid_info) {
-				kfree(ptr_cid_info->cid_array);
 				kfree(ptr_cid_info);
 				phba->cid_array_info[ulp_num] = NULL;
 			}
@@ -4175,7 +4153,6 @@ static void beiscsi_cleanup_port(struct beiscsi_hba *phba)
 			ptr_cid_info = phba->cid_array_info[ulp_num];
 
 			if (ptr_cid_info) {
-				kfree(ptr_cid_info->cid_array);
 				kfree(ptr_cid_info);
 				phba->cid_array_info[ulp_num] = NULL;
 			}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 71c95d144560..77c9b1a1a488 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -241,10 +241,10 @@ struct hwi_wrb_context {
 };
 
 struct ulp_cid_info {
-	unsigned short *cid_array;
 	unsigned short avlbl_cids;
 	unsigned short cid_alloc;
 	unsigned short cid_free;
+	unsigned short cid_array[] __counted_by(avlbl_cids);
 };
 
 #include "be.h"
@@ -968,10 +968,10 @@ struct be_ring {
 };
 
 struct hwi_controller {
-	struct hwi_wrb_context *wrb_context;
 	struct be_ring default_pdu_hdr[BEISCSI_ULP_COUNT];
 	struct be_ring default_pdu_data[BEISCSI_ULP_COUNT];
 	struct hwi_context_memory *phwi_ctxt;
+	struct hwi_wrb_context wrb_context[];
 };
 
 enum hwh_type_enum {
-- 
2.53.0

