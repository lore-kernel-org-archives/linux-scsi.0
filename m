Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC04B3B0AFA
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777582987; cv=none; b=Jm4UMOYFzCZVkxTVgSybCW+EQlHs07z0FNYZIfBNdyqVdAiEIQAaEXtz3AkbnZ/xrJDbyy2tvxyD1s8ihv2UZ5R+lYcvf7R0yXOAG6UWTETPEdnPX2G1gKXUBIpeG4EMyIeZYKJZOxuD5yKBOxLUkenLPcgCqcAwLOk++k3nAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777582987; c=relaxed/simple;
	bh=2+a8FjqR6Y8l6luOjOutV2eo5zpCnfifP9LtBYYSgm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbxqJHFsukenr5xmojIzm84P5o19Vrm3b4nwmc5ULoHQgNpKRX2/YZcQJJhdCKt36qfGXm4vJGPW12I4z8KDPqMBH8hD55+gvWA5/3mwERYEwYoPJuw4/Yfq6L+OGC/3WmF2OfwLwe5KhRHvklnfQ/Eu2L5Yie1nYYFU0UQNAhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=htB5ViNG; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="htB5ViNG"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82418b0178cso758866b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 14:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777582985; x=1778187785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Hm+SYroWp743tKYAFyC841yKgS6flDuKxy8fma+JfM=;
        b=htB5ViNGOMuPldvGHiDrR4/Zzv2gHVHeFoyLlZHrsbki92XHK1pyalj0H7eEfJ8852
         8u76WE/b7tOnOzguDNoNkVvNI2ieCybNlcwLDqs5wBtMBb9htrAdwFAgSvCaDzv01qhZ
         wFGwQVu4ovwm9YexutBcib0jsps7K8hjnvKhU9DZqWROn3A8qZn7QmOXeJB65PGv5BN5
         Bd7xP29Y8TbxDALHvfRBcpEOcIXdOE0toRSw7wQb4GGH+13JbnF10E2xRJhTT+UzBaSM
         ZA95bcP4MEejUc11L3SCAumAxoTpLTlG6ojnvDs7UBZDZrUVoiL6Dmw+7982k/8AatL/
         ObyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582985; x=1778187785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Hm+SYroWp743tKYAFyC841yKgS6flDuKxy8fma+JfM=;
        b=Dl4glxkbv/dDiczrLY1pYmA3HuH/jifN20f/ZncqVFaNLx/23Fm7VkPWW1X5/4TF1x
         wmdkh9vfR9Kx+G/eNkt9ml+coLZ63XGlTvaWp6q4owOCxO+trpOu68Y159DmI13ySrL8
         AxG0sYhfw7s40gxUtEYx/KLQCWSQ8OJQjPLYu4wYcQzqF3FGv0zVwVUy72momH0dVnuT
         7kXdpPwqrY2adfYEfqk+Y+NBm5IBzIZj4NC99X1SgnPcJCAR35bg9mXMUreaRsb44MSC
         tflB/YRWFcV1gW3nUpV9Q3T/qreGdwvhWpH/eUtdZLlPReyuHct7HmpcaV7KfTA8R29B
         zWqQ==
X-Gm-Message-State: AOJu0YxVbw60kmyHm7NwKPdo4+LxWhNXQ6bBCRgEylDUl8jwjBPDkAcu
	B/S0VCoPfKq0ljly9qDhTlxT7jpzgSSxMfSQkOEuQCENtji0toOJjOGj6CAdvA==
X-Gm-Gg: AeBDiet8Bk/myDv9da+O4TMneCjU7DEEpWMgmi3S3M7R1+GBhu/RmsS7xBHEO6YwFr0
	IIyZRaEYRJPl0Ig9dEubIjRj65of4Kp8hdoXfq26VDBLV3PwLkVRpr07g/CuWhH6y/1LqQzM8DH
	EYa4TNtYf1OevQNcYfZsDV9wNlu/X7vcz48XCQDvx9ByrHXXGXhbJ51jlRlsceb7R3qzVawo4+x
	WP6zFrwUr2olMkbrzl5r1itnF+xSKnhfmUpgsp/xSpWuaBvrlr56GlWIlIDr6TgzEKOFztvo/eR
	7i6nTRbiHbYPwUtxGp9JI1AGr9tRr2x19UvPt1BX7SeYaSrDKXfO18Tr8aTYbswFCS2MeORw3Bi
	NH1NXc3QHqW5Y1qlRvUbJQvYWiEmo5MM/06cp7YNjuqZYvWujr6DcHQh+oI5Ws2PIPKxRKyZrOl
	wKsR2gu1lt4E36x3+EZBc7e9tXB8XpBvIYjWIUdRB6om9cu4ugA1FMGnJhFdLrKRwfskeA9YWy7
	farGYNxGbIfEvZDA7Hy8PHwYBNoQqLzDroCQ8aAtfwAFw==
X-Received: by 2002:a05:6a00:4c9a:b0:82f:28da:ec7 with SMTP id d2e1a72fcca58-834fdc0ddd5mr5212627b3a.27.1777582984774;
        Thu, 30 Apr 2026 14:03:04 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b4f7c1sm516809b3a.51.2026.04.30.14.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:03:04 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] scsi: bnx2fc: simplify allocation of cmgr
Date: Thu, 30 Apr 2026 14:02:43 -0700
Message-ID: <20260430210245.29840-2-rosenp@gmail.com>
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

Switch to flexible array member for cmds so that all members can be
referenced properly instead of using + 1 hacks.

Allocate io_bdt_pool, free_list, and free_list_lock with the struct to
avoid separate kfrees.

Remove mem_size variable. It's just open coding kzalloc_objs.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h    |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c | 52 +++++----------------------------
 2 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 8c8968ec8cb4..30d8b563db0c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -281,7 +281,7 @@ struct bnx2fc_cmd_mgr {
 	struct list_head *free_list;
 	spinlock_t *free_list_lock;
 	struct io_bdt **io_bdt_pool;
-	struct bnx2fc_cmd **cmds;
+	struct bnx2fc_cmd *cmds[];
 };
 
 struct bnx2fc_rport {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9c7a541a4523..4810999976b6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -214,7 +214,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	struct io_bdt *bdt_info;
 	struct bnx2fc_cmd *io_req;
 	size_t len;
-	u32 mem_size;
 	u16 xid;
 	int i;
 	int num_ios, num_pri_ios;
@@ -231,8 +230,10 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	BNX2FC_MISC_DBG("min xid 0x%x, max xid 0x%x\n", min_xid, max_xid);
 
 	num_ios = max_xid - min_xid + 1;
-	len = (num_ios * (sizeof(struct bnx2fc_cmd *)));
-	len += sizeof(struct bnx2fc_cmd_mgr);
+	len = struct_size(cmgr, cmds, num_ios);
+	len += sizeof(*cmgr->io_bdt_pool) * num_ios;
+	len += sizeof(*cmgr->free_list) * arr_sz;
+	len += sizeof(*cmgr->free_list_lock) * arr_sz;
 
 	cmgr = kzalloc(len, GFP_KERNEL);
 	if (!cmgr) {
@@ -241,21 +242,9 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	}
 
 	cmgr->hba = hba;
-	cmgr->free_list = kzalloc_objs(*cmgr->free_list, arr_sz);
-	if (!cmgr->free_list) {
-		printk(KERN_ERR PFX "failed to alloc free_list\n");
-		goto mem_err;
-	}
-
-	cmgr->free_list_lock = kzalloc_objs(*cmgr->free_list_lock, arr_sz);
-	if (!cmgr->free_list_lock) {
-		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
-		kfree(cmgr->free_list);
-		cmgr->free_list = NULL;
-		goto mem_err;
-	}
-
-	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
+	cmgr->io_bdt_pool = (struct io_bdt **)(cmgr->cmds + num_ios);
+	cmgr->free_list = (struct list_head *)(cmgr->io_bdt_pool + num_ios);
+	cmgr->free_list_lock = (spinlock_t *)(cmgr->free_list + arr_sz);
 
 	for (i = 0; i < arr_sz; i++)  {
 		INIT_LIST_HEAD(&cmgr->free_list[i]);
@@ -291,17 +280,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		io_req++;
 	}
 
-	/* Allocate pool of io_bdts - one for each bnx2fc_cmd */
-	mem_size = num_ios * sizeof(struct io_bdt *);
-	cmgr->io_bdt_pool = kzalloc(mem_size, GFP_KERNEL);
-	if (!cmgr->io_bdt_pool) {
-		printk(KERN_ERR PFX "failed to alloc io_bdt_pool\n");
-		goto mem_err;
-	}
-
-	mem_size = sizeof(struct io_bdt);
 	for (i = 0; i < num_ios; i++) {
-		cmgr->io_bdt_pool[i] = kmalloc(mem_size, GFP_KERNEL);
+		cmgr->io_bdt_pool[i] = kmalloc_obj(struct io_bdt);
 		if (!cmgr->io_bdt_pool[i]) {
 			printk(KERN_ERR PFX "failed to alloc "
 				"io_bdt_pool[%d]\n", i);
@@ -343,10 +323,6 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 
 	num_ios = max_xid - min_xid + 1;
 
-	/* Free fcoe_bdt_ctx structures */
-	if (!cmgr->io_bdt_pool)
-		goto free_cmd_pool;
-
 	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
@@ -364,16 +340,6 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 		cmgr->io_bdt_pool[i] = NULL;
 	}
 
-	kfree(cmgr->io_bdt_pool);
-	cmgr->io_bdt_pool = NULL;
-
-free_cmd_pool:
-	kfree(cmgr->free_list_lock);
-
-	/* Destroy cmd pool */
-	if (!cmgr->free_list)
-		goto free_cmgr;
-
 	for (i = 0; i < num_possible_cpus() + 1; i++)  {
 		struct bnx2fc_cmd *tmp, *io_req;
 
@@ -383,8 +349,6 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 			kfree(io_req);
 		}
 	}
-	kfree(cmgr->free_list);
-free_cmgr:
 	/* Free command manager itself */
 	kfree(cmgr);
 }
-- 
2.54.0

