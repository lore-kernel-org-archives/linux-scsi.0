Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923093B2FF0
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777582988; cv=none; b=g8kkpIppycKSe9LNRggfN34NtFyOec9a9UxluV2lggJgpkdRxywZY+wvHLclTh6TbhM9isFT3fQqKMP+szejtTU7OYUiK6CZEwlaUMVoUtFFXJUHr9BomtZgSbT8Lpu6ERCagJ/rcVlqU08N10KEIKhHAlL9JcuS+8AQFNDfltA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777582988; c=relaxed/simple;
	bh=O9DERP0tk+0f7A1tMchJccbrA3qiv/19kFTs5r8KkB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkQI0qAiLQXZcPFYgODXrVIJNc3KInr4NHv7ccj5+3u8qIwfbUvoG1eaQ09kkpf12YaZjFQtSceQ1ULwEpwPZCcRfEPdSBmHX8pU+5Yg4yY5ZVEWCb7jSpOWc45nSZDQWF2cUja9awYsXBXbAfMbUUCGzETwRB02CM6kdJ7W+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWBdJzSo; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWBdJzSo"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f943870baso667294b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777582986; x=1778187786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnqOGqDPHVUackkq9ZkSS/lfsrgEZLctighrNH7cCSs=;
        b=OWBdJzSodSicsRM8SXi4L9Y/oLazstFNn/GUPd+3HIHXLRvoyQQiT1KIzvAIeQZHde
         GfjDRHfjZ6DhaDGIu1Z7xWJBfFO4aQqAg6DLhBZTkNy3WyfAwq1d3kkxJhCxX21guRGi
         e3vRBYTzH0kG9MlVQUJMUyAxKUztgpfZTP0sfbUEVa0QP7HnslePT4KgcPEJNQBPMKPd
         77fq1WViwi4dGwWPOdntdbhHL9XDmMjMOB0ikTG5SvMEygMWG0bT0SAmLCj8xH0hYOnW
         7+PAelq4bWEvlMQ1fbdNFRVPNd1ASQnbgFhsFgr7St9cye7mCNjk0YnmgY/bu/yoA00V
         +jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582986; x=1778187786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LnqOGqDPHVUackkq9ZkSS/lfsrgEZLctighrNH7cCSs=;
        b=P69eKaiSIf3SfIC7IIZdvp8ONYVrh1NuCwOp068sV4xexReSO39m50vOzeowzJuTaG
         r5dofBdtR8SEr7K3L2MgJdG0zdcMDiRF9yT5QkXX9WzvGctCW0nqmuH/1OxWuL+LXtPx
         f9BpE3RGWL0LKzrBUrCEbSBgLLyk//l522WPTNyL57UjmIVbkfuRe68CUkxSkDbYmVVL
         EgfVr9m4Hx4QGVK+rDfoM6C/Vx/TvJJvBOObn0QOwDHleFlFKbdXR96m5F+fI0XmMJqm
         qA/1RW50A196osjQ9ueHwYbyPvDr1bj3MPh5BP0P3MK+FogvpAovDirO/qtg4CL+aIx0
         m3WQ==
X-Gm-Message-State: AOJu0YzOZ5qtlvRSUJjdCwD1urBy3JuFm+/krKB8ekI/O2/Y2KhZOUSd
	Kd80W8zxsCbiDWlx5eSSqMUsOZLGnKEkhhqM/GeSUSqtyButdEBC2FHqZRqrrQ==
X-Gm-Gg: AeBDievVUJsmSK+YCb1XBRjoa/CTOgdq70T6GGdXlQCKeccsbjPvoeneCwErgdSHVIC
	YBLcUBSYAcwzFPrYwWKKnNaY7oB/dEFmRB/cLCT49V2pyrVFrQJzzTvwg6YHLShZ2URAUm5kscS
	hf18jN9HDKTjJ0svqcoaegJiUnDI1jDGzYyz8J5/j4ak9J8m+PloUv7i5tj1+TWPNfG4yL5cAyl
	aNmm8lWJKjNZ4jYrm879TNuWMoIyUrz3kJuhymQEnb1qaN+ZRsJVPzOL6oZ+u6ezOJgb4TVWDPU
	PWyUe7q8VaFNxKWA0Mkz8ZtB2V+hC4xvzLVrt1BM8jD39aY5u11td54P5OI6OISRcnXfxOwOPmH
	S/GH4IT5LbpeC3B+QdSU1Zf7bTf3M8bLtqpuzMHr6xWb0VdLAMj7o2zFids/PJmXxc8JTs83IMZ
	xib28ea1Pn2T+vJj4gdzk+AxDmMTSstFQFl2Id/lQT+47L17qrabA6ONpSLt0+GRrbzxQf5bb4w
	hhKNTSbGHReVn5j/xJbITij4U7yiKvGwaSA9o247j0OXcMatVJCSg6c
X-Received: by 2002:a05:6a00:228f:b0:82f:6640:7229 with SMTP id d2e1a72fcca58-8351a58db66mr192650b3a.23.1777582986450;
        Thu, 30 Apr 2026 14:03:06 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b4f7c1sm516809b3a.51.2026.04.30.14.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:03:05 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] scsi: bnx2fc: no double pointer for io_bdt_pool
Date: Thu, 30 Apr 2026 14:02:44 -0700
Message-ID: <20260430210245.29840-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430210245.29840-1-rosenp@gmail.com>
References: <20260430210245.29840-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of allocating a double pointer, allocate a single and avoid
extra malloc and free. It's not needed anyway.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h    |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c | 25 +++++--------------------
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 30d8b563db0c..9a5de1048542 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -280,7 +280,7 @@ struct bnx2fc_cmd_mgr {
 	u16 next_idx;
 	struct list_head *free_list;
 	spinlock_t *free_list_lock;
-	struct io_bdt **io_bdt_pool;
+	struct io_bdt *io_bdt_pool;
 	struct bnx2fc_cmd *cmds[];
 };
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4810999976b6..6773f8d5d84e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -242,7 +242,7 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	}
 
 	cmgr->hba = hba;
-	cmgr->io_bdt_pool = (struct io_bdt **)(cmgr->cmds + num_ios);
+	cmgr->io_bdt_pool = (struct io_bdt *)(cmgr->cmds + num_ios);
 	cmgr->free_list = (struct list_head *)(cmgr->io_bdt_pool + num_ios);
 	cmgr->free_list_lock = (spinlock_t *)(cmgr->free_list + arr_sz);
 
@@ -280,19 +280,10 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		io_req++;
 	}
 
-	for (i = 0; i < num_ios; i++) {
-		cmgr->io_bdt_pool[i] = kmalloc_obj(struct io_bdt);
-		if (!cmgr->io_bdt_pool[i]) {
-			printk(KERN_ERR PFX "failed to alloc "
-				"io_bdt_pool[%d]\n", i);
-			goto mem_err;
-		}
-	}
-
 	/* Allocate an map fcoe_bdt_ctx structures */
 	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
 	for (i = 0; i < num_ios; i++) {
-		bdt_info = cmgr->io_bdt_pool[i];
+		bdt_info = &cmgr->io_bdt_pool[i];
 		bdt_info->bd_tbl = dma_alloc_coherent(&hba->pcidev->dev,
 						      bd_tbl_sz,
 						      &bdt_info->bd_tbl_dma,
@@ -325,7 +316,7 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 
 	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
 	for (i = 0; i < num_ios; i++) {
-		bdt_info = cmgr->io_bdt_pool[i];
+		bdt_info = &cmgr->io_bdt_pool[i];
 		if (bdt_info->bd_tbl) {
 			dma_free_coherent(&hba->pcidev->dev, bd_tbl_sz,
 					    bdt_info->bd_tbl,
@@ -334,12 +325,6 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 		}
 	}
 
-	/* Destroy io_bdt pool */
-	for (i = 0; i < num_ios; i++) {
-		kfree(cmgr->io_bdt_pool[i]);
-		cmgr->io_bdt_pool[i] = NULL;
-	}
-
 	for (i = 0; i < num_possible_cpus() + 1; i++)  {
 		struct bnx2fc_cmd *tmp, *io_req;
 
@@ -415,7 +400,7 @@ struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type)
 
 	/* Bind io_bdt for this io_req */
 	/* Have a static link between io_req and io_bdt_pool */
-	bd_tbl = io_req->bd_tbl = cmd_mgr->io_bdt_pool[xid];
+	bd_tbl = io_req->bd_tbl = &cmd_mgr->io_bdt_pool[xid];
 	bd_tbl->io_req = io_req;
 
 	/* Hold the io_req  against deletion */
@@ -468,7 +453,7 @@ struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt)
 
 	/* Bind io_bdt for this io_req */
 	/* Have a static link between io_req and io_bdt_pool */
-	bd_tbl = io_req->bd_tbl = cmd_mgr->io_bdt_pool[xid];
+	bd_tbl = io_req->bd_tbl = &cmd_mgr->io_bdt_pool[xid];
 	bd_tbl->io_req = io_req;
 
 	/* Hold the io_req  against deletion */
-- 
2.54.0

