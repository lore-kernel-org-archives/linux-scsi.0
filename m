Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550F0324B1C
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774120665; cv=none; b=powWtPZS05YGnM9Jto8jdQaQVLm961oHmh7javP/Cy50ojZ4zy8/RYRLY4GLCBSJOvrkJ4qh0LhyU6w3pBQKuMjSK5rMTEJkRBDbfSLE5Rt2teqzbWsyyxljq432k/OKJV3y+m4TMWO4KLur2D9SvjV+U3vxsNYL6IZjE+btowM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774120665; c=relaxed/simple;
	bh=Tsse4Ly6NtzSSlkCNrQss5DdsY0MgmF7zlxq5rnNN2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTVrp0jX9sWP1nFXF2CEu/opvBM/Cu141cPgb3gya71ihNqb94csPRa8e+eV4GKZp07bFiV6KXIee3wrvPBlca4ZBJXQbmiWVBadH+UhRdf9FTYrAcwRyUFA3Wb7gST4t7sADxyVloqctlOgXVA6f5nyJfqMdiH5rzeuUcl3r8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBueko6P; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBueko6P"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c742723c863so1769687a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774120663; x=1774725463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UicmcSJjTDj6d4okbgLa8FdzILWgq4+BDig2MAnvOJo=;
        b=UBueko6P1cy2f+uu6nsD8Hict8QEqkxYZIbMk3BGpsfzSxiEGSc++IfyxRyZPnJpAl
         bvEJpBV3QCwzqeznbulR8liI60t6dY+ZgQH3c/wMe8LPZp0Yyarp9UXevxeJqWBt8li6
         /+7xitXg1MbCKycfkipM+mw/GU6lw+JwIP8RWzNP2ISA1IAUJp1h+Oly8dKM12zjcRhf
         goHRIRtJ1fTChsYr/6/kXkWW8T0tNkNtCziqR7uwQQhQRLyfnEOlys2XjirNMkL9L3j3
         xSZUlp/x79AX85QQz7M5U2VRme6xpVvITUnAHQXLksihMy+V0ZcePZlECwkKeM+0907S
         tZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774120663; x=1774725463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UicmcSJjTDj6d4okbgLa8FdzILWgq4+BDig2MAnvOJo=;
        b=p9mJ20jpx+CBbtLtMt1L5XXEf4ML31Q8cHS5SFzb10eO773HkK4adRqCgwsRo7ps90
         JSMb6yNV/InwXvxFeacPYp4Qpyg3Lg2oSGnGKjAkYyw5CjL1nHkKMEuCGaxIBP9u+sbU
         GGfbW88i144TCAsvztts1chIxHxc5PA9V1p7dCYPEeOj87m2pvvNhGyn+nxEnMsedWTh
         QPKmN55vCZL7ZceElkjiKO9bHIwKVfBNOhu+xZUX7bpwJowloQDBrHN1lkVclyf3gXug
         kDD5+f7oYmVwNux9jqSz8whBO1HXD+DUBi006nCn+am6BTCw4GDBv7IvpNvd0Tym3dGx
         z/Zg==
X-Gm-Message-State: AOJu0Yw0U7U80FyKerYhrpgu/5K5+tOhrybbGG1BF/cfG85HcRA70QeK
	VwzyWK38M4FTUyBZhclBcSlwT5jmDTQ8Md9c+COYCIAHSrDdNj7PTdEvwMNEleqA
X-Gm-Gg: ATEYQzzixo61Q87h41Bsq5ZDx3sAuYJ4k/EhB07+kP4w27mtA5zmqbvy74zdLzhp4/v
	qOPf6wi8kOrM2W5uoEqYRQBy18ouT1CTV5HK19imk7ri+Lp6rn10Bwbd3vM+PkE7jZckNOwTruD
	l1dBQMnlKKgP2SrZXfpGlAgz8KBGpZHzDbN0cPd6y7WFUc+ZV6YG+K0MDQZcAmFPLuHH1rsFSck
	FxincsyRaxp3lvMMpu8RnX/EB2SEoZXnc+mTZHea+qNwSM0zfVGcdaGu2ObIeQHNf4ccyBRl7cJ
	bI8QaqhB3uJTyNrYRH9nGJdNPw99mAivxC/0relYiIBOUHY7BQG7JRMTJIP57HzvLe0E7reZ5d2
	RN0PsLVHCV4j76wPVfS7+W34rvrIt3a+ioAu30QdWQujcLf5vkhGXxS3zV5YTy9938n3zXdOyn3
	Uk5DZ0yVIBhjB0dMkLHQxgF/ps2u9me2roajVP0/zUI1bVDcY1KqtnoNw=
X-Received: by 2002:a05:6a20:1586:b0:398:9466:2ee8 with SMTP id adf61e73a8af0-39bce97c801mr6500384637.7.1774120663259;
        Sat, 21 Mar 2026 12:17:43 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443cc9edsm4319968a12.23.2026.03.21.12.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 12:17:42 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH 2/2] scsi: be2iscsi: simplify hwi_controller allocation
Date: Sat, 21 Mar 2026 12:17:22 -0700
Message-ID: <20260321191722.19235-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321191722.19235-1-rosenp@gmail.com>
References: <20260321191722.19235-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a flexible array member to allocate and free hwi_controller once
using kzalloc_flex.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 16 +---------------
 drivers/scsi/be2iscsi/be_main.h |  2 +-
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index aa5320535c1f..799063000e77 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2465,27 +2465,16 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 {
 	dma_addr_t bus_add;
-	struct hwi_controller *phwi_ctrlr;
 	struct be_mem_descriptor *mem_descr;
 	struct mem_array *mem_arr, *mem_arr_orig;
 	unsigned int i, j, alloc_size, curr_alloc_size;
 
-	phba->phwi_ctrlr = kzalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
+	phba->phwi_ctrlr = kzalloc_flex(*phba->phwi_ctrlr, wrb_context, phba->params.cxns_per_ctrl);
 	if (!phba->phwi_ctrlr)
 		return -ENOMEM;
 
-	/* Allocate memory for wrb_context */
-	phwi_ctrlr = phba->phwi_ctrlr;
-	phwi_ctrlr->wrb_context = kzalloc_objs(struct hwi_wrb_context,
-					       phba->params.cxns_per_ctrl);
-	if (!phwi_ctrlr->wrb_context) {
-		kfree(phba->phwi_ctrlr);
-		return -ENOMEM;
-	}
-
 	phba->init_mem = kzalloc_objs(*mem_descr, SE_MEM_MAX);
 	if (!phba->init_mem) {
-		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -2493,7 +2482,6 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	mem_arr_orig = kmalloc_objs(*mem_arr_orig, BEISCSI_MAX_FRAGS_INIT);
 	if (!mem_arr_orig) {
 		kfree(phba->init_mem);
-		kfree(phwi_ctrlr->wrb_context);
 		kfree(phba->phwi_ctrlr);
 		return -ENOMEM;
 	}
@@ -2568,7 +2556,6 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	}
 	kfree(mem_arr_orig);
 	kfree(phba->init_mem);
-	kfree(phba->phwi_ctrlr->wrb_context);
 	kfree(phba->phwi_ctrlr);
 	return -ENOMEM;
 }
@@ -3874,7 +3861,6 @@ static void beiscsi_free_mem(struct beiscsi_hba *phba)
 		mem_descr++;
 	}
 	kfree(phba->init_mem);
-	kfree(phba->phwi_ctrlr->wrb_context);
 	kfree(phba->phwi_ctrlr);
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b5f8e746deab..77c9b1a1a488 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
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

