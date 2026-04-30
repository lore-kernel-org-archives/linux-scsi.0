Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F583B19DB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777585079; cv=none; b=KLqdTfR1yunFraOFVti7D+m/YOlxhHo0UfA9lX3ELuxfBQCrtOGZi5Aq3qIq6p/SHLkf7KYs8g6z6672XfU23GX014KfRvxDtCYmAxXEU9ow0ArRajhOV8mCOwpQPGck4t86xy6i7rFBBf70S6BxiI+4hwP7pnfDqs2gM17cCiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777585079; c=relaxed/simple;
	bh=MVraVFniajBUQIRJ+6h8gR2yGaiW60oRblMGC6lLPtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSvQjQvMGq9IOxdh1FcFAoON+Xi959IPa7jSmio3f9ODzXbK8K5f1pGaXguYJpurRVt3LkUA4xBI07WXfoPkOBiP+dmVwhAuGjPM+HjrQujyoVtDYrmY7QPJ+F2twXwsiJ5bkMncndCby2cb85NMCYM7CQPa2/65ZyatILhC4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D/ebH9vM; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/ebH9vM"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8d67a483d3eso152217285a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777585076; x=1778189876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVqn3dyVg4K8iMG+rfFnoKiLza2CoHq6O7x1qQbXIr4=;
        b=D/ebH9vMSmF0C00NasWmxOjjLEpcc1mLlDmMPmo/0gAEcuAGmy6IJzjjgt0mACJyMy
         1pONbRzpv71y65SG0yWZOa1Rir03D19SJfdb6org0vGmmkiCpEGHSTPA24/0qbOQO/Cj
         7FCcYMWt4uyPkp2XBtpsEdENJRYLoPNR1Et5RST5nDxNvoAl0A1XFIP40KblXrAEkKYq
         tIp6PeTzFj3/VI2WQ3MOoM0yk4ZZTsm9gkHRKWtWAvyE9lq2v9HItbcLqGH8YDXB+Qmt
         IhhAG/rayqnhll0qA58ZLS9YpCpyvCUkdKz++H06mvSY06BDE/5XzviwOclHOKvmCFt+
         Wqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777585076; x=1778189876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RVqn3dyVg4K8iMG+rfFnoKiLza2CoHq6O7x1qQbXIr4=;
        b=GC3ChCsyP22IRXSaNr14Ip6lV7iKIMIMDt0zy0/un2iJ3ZbxbS884oAfDSBy/Mzj4z
         m8zeGqYf8UBFoWlk0x3iXruZ278wYlewusuBKMZJbyxpd8a5VvNzR3RcJTdgbffHkmfS
         VXB20T39GWt4K0upmsk94MKvYnW59n0OLcoUlLkrvwiTM/x8X6Sjt3Z58rikKEtPdJC2
         2t2K7cSACIiNIpWIYbhcjTIZ/ZsCm5xs3+c2urZGJ3dGWFx/EgMgRdh4AD3zgSH3OoI9
         oVGJf669FhsR69/RBAol6tYvWZ3Ys+Sv+Eb6mPKsnecohe8rmCvUGkelS80bduegyeCn
         Sl2Q==
X-Gm-Message-State: AOJu0YwoBXvdHjUn9Om1aHkEJDnfTOPwTra5E8BF0mcb7a5dTfyZ+mP3
	qOuON5CGF1sC/cRiKAfQXdB558UYmXWWbacr6fEMTU5/msl8/pFBpLHWPt42NA==
X-Gm-Gg: AeBDievGkj1Ilu8y570XLAnLDJeWhOcRqogCOINggLLW1rde4fKl+BWZmGom3noSYYh
	nQ213/l8wv19FBn7avvY8oUaj0Ckxk+AvbttJUB+IAxSeMi6x1y1u2xXlQbm1KUyIAlfO9jC+fv
	Ne8ZCF04xdnT4O7L4FgwmdXYcjbtDAi1Vmm8Jk6Tx8vNnnH9DykwNivuBayjKpwkh4Q+szfjtie
	+fknRrHOEHOYuC9hbc1HjAQ6PWNs/TQuUXTuYBfTf+43Arr0AdxZp40pOZDk2PDtvD0dGy/znUV
	oAcXdM36hzknGjdP/n8y40NRCdX8KIuUwND40FmD/B1bPP0GaInfF4w/mV0BdHIe/UYGS3OMt5e
	fjQ/RjXgUp34HIf7i6lZmzABfTUGfzNdwg8pSTHkV3digZ4tk5MP3tkcxBMoZ3xoV9nOdo5da1T
	u/sFIoYEzVVC166Kiq1SRzDv8XRFeHKoRm5cv9kI/ChE5m//LhWpMZOmrMApGu1ZDqaV5CgIKQC
	Hx9SmUGgQ+QtjN3+aglwqdLH7Nw8zuklcem6VgsK6ePhg==
X-Received: by 2002:a05:620a:46a6:b0:8ef:3312:a155 with SMTP id af79cd13be357-8faaf62dcfamr659147685a.11.1777585076072;
        Thu, 30 Apr 2026 14:37:56 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fbf078618csm28281485a.8.2026.04.30.14.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:37:55 -0700 (PDT)
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
Date: Thu, 30 Apr 2026 14:37:33 -0700
Message-ID: <20260430213733.54840-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430213733.54840-1-rosenp@gmail.com>
References: <20260430213733.54840-1-rosenp@gmail.com>
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
2.54.0

