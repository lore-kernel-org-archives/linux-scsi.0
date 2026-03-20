Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEF231829
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 04:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773979926; cv=none; b=sbs726izU/j90++yu9DEoiJ4256ZVhMtOWJ+VfMDNvHnbU3NjDbujZ9PbfG9zroYVi0nHJT0gHxYm6y4M/80WGAksuOORngR7Jog5Umk8MLS4jJxsWGJl9eBGyR+U/ScrBCSFvERsVSnCMqb9k5j/JXr3oan8XLoeVDX4+hMPzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773979926; c=relaxed/simple;
	bh=cKZ9DA8d7AqMDYmuVI90xfeG8zhHCOGpAlGVK6XL3Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qg50ZGMSO67AKAfHDT/AIoSD8/yNOcPd/Lqc8bgzeGEuM9bRWvmc55uG4HNapl7jwxNmM9NJ91RxtITeUUJHXWoFXrMlR3dwb0mQ6Z+4j4Hqlj63ah8k5jid+YdmyFIQ4bQmaGABDbTcArZYXcEFQ+TiAH1B5/0s/3GZQdphxlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SJIazOiv; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJIazOiv"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-794719afcd4so12277337b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 21:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773979924; x=1774584724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QfUjsYd7dbRw2uqaXUlO8/PTLsP2ayWwRNJQy8iJQ8Y=;
        b=SJIazOivsFRTZtr9cJTGqVb5ZgVCT7nrlN+pKrR7XJQ1oBzUVKFlixGg14X36AJidC
         DLRhKpdtfddj6hcgPCA3aiJiqbawE+QhiyrigMH2bpA84FcUqUycy6pFSf9mQF22PDPY
         rxdCTVI1QJ99sxBQE1P6ZZ6crLhwLW62q8Igk2EtrLwJxVhGH7loy1TN59Tz64xXCREz
         niK5hVlBnryL+leKeC19AjjS/j4VRst1c2Xy9gz6PesFm1YxSJRI/h3uQGS15DUJfK9f
         n2lKP3FHIUu674DQhVIbq1SaxKJ44RtGXZpSVOHkRWfTxQQmacoK68fvBShqvZhoOVqY
         72pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773979924; x=1774584724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfUjsYd7dbRw2uqaXUlO8/PTLsP2ayWwRNJQy8iJQ8Y=;
        b=bCO1vQQbaGF1+OIG0bANtAmxW9FNnfaa7eMRlPyejHYpUJ4WrRimLWemje7gEZPHNK
         h5fImc9k4pKkDRnYJBCqgMN4akfbA6nYuv4m6EO26+2ByiRlyvsGr2CZXmKblWHGqKQ9
         SpR0xHubvBzGkqDqLGaNofoAqQfw/SPeOFALh33alPAvNgsJVq+iyaRAcTEwwZNwpyhD
         EO7AfvBboCVRjW7cfoz9fnxczIkEszWV+QeLe1VbL2QX8KRZe/s7aphBh2UtShjOU93x
         6ziOzyNNGjP3aYyD4PGATKXN5+AP7iOxvasybPh9/bHrgMS2OHR8JIauDyE2KgUWTz4M
         a1FA==
X-Gm-Message-State: AOJu0YxTY13nqTP7zSBcpZoxNVtYLkIZX1dTJnB71KebcKMay/w87X8B
	wLKFFGGxHOdg7zhH/iVXH9S/IzngxW21Wc/DW2wTxdK0PXaIgBaU36XB3ThCxSqK
X-Gm-Gg: ATEYQzy9d5dGAr0wcf4nO8/Ue78SSo7AVVlCG/Lz1m3Js9fH9MIaWVjbPvSUd1bppOT
	jmwPpSEL4Ceh/r8Qc/um1kEpfo6FsgELPhUZYDraVZsxr4DsyQj4/OIsssTcDFlwnOK/QoPpkGe
	NTwJIiqmVR332hZ4iGPhToUrCc2KfjH9wu5JwzCeWLAh9W6gYN7bk/xBTGyXmgPlSFHGdB/BOWZ
	9SvFeO8ziKD4ioMpeGjVVuMgc96ELVqS//0tLyYUHAAThD8VDTRV0VtRsmwII+C9jtsVYft1xmW
	j2zc4E9Z3Dso5y6lU2EsollDQJoIKB1P/PpNDXqVAzzq0CmdBRNNWNrrO1MbtOoG3OOMOgAz5Ok
	yp9PTAJzNItN96xGFvMKVraSu8GR+khgXLzH7OeOZaAMFoKvz53WfGZHtOb+i4mdes/Kcl9gnfI
	ILLJfrTydu0NVDQMq62ap2yRikzwNKssXzuPkKInW2GLakHSMkx4HUvYU=
X-Received: by 2002:a05:690c:1a:b0:79a:67a0:adeb with SMTP id 00721157ae682-79a90c26448mr17621307b3.50.1773979924411;
        Thu, 19 Mar 2026 21:12:04 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabe7e343sm719089d50.11.2026.03.19.21.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 21:12:03 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: bx2fc: use kzalloc_flex
Date: Thu, 19 Mar 2026 21:11:46 -0700
Message-ID: <20260320041146.46873-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid calculating sizes manually.

Switch to flexible array member so that it works properly.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h    |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c | 14 +++-----------
 2 files changed, 4 insertions(+), 12 deletions(-)

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
index 9c7a541a4523..dd1c4b3232e1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -213,8 +213,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	struct bnx2fc_cmd_mgr *cmgr;
 	struct io_bdt *bdt_info;
 	struct bnx2fc_cmd *io_req;
-	size_t len;
-	u32 mem_size;
 	u16 xid;
 	int i;
 	int num_ios, num_pri_ios;
@@ -231,10 +229,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	BNX2FC_MISC_DBG("min xid 0x%x, max xid 0x%x\n", min_xid, max_xid);
 
 	num_ios = max_xid - min_xid + 1;
-	len = (num_ios * (sizeof(struct bnx2fc_cmd *)));
-	len += sizeof(struct bnx2fc_cmd_mgr);
 
-	cmgr = kzalloc(len, GFP_KERNEL);
+	cmgr = kzalloc_flex(*cmgr, cmds, num_ios);
 	if (!cmgr) {
 		printk(KERN_ERR PFX "failed to alloc cmgr\n");
 		return NULL;
@@ -255,8 +251,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 		goto mem_err;
 	}
 
-	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
-
 	for (i = 0; i < arr_sz; i++)  {
 		INIT_LIST_HEAD(&cmgr->free_list[i]);
 		spin_lock_init(&cmgr->free_list_lock[i]);
@@ -292,16 +286,14 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 	}
 
 	/* Allocate pool of io_bdts - one for each bnx2fc_cmd */
-	mem_size = num_ios * sizeof(struct io_bdt *);
-	cmgr->io_bdt_pool = kzalloc(mem_size, GFP_KERNEL);
+	cmgr->io_bdt_pool = kzalloc_objs(struct io_bdt *, num_ios);
 	if (!cmgr->io_bdt_pool) {
 		printk(KERN_ERR PFX "failed to alloc io_bdt_pool\n");
 		goto mem_err;
 	}
 
-	mem_size = sizeof(struct io_bdt);
 	for (i = 0; i < num_ios; i++) {
-		cmgr->io_bdt_pool[i] = kmalloc(mem_size, GFP_KERNEL);
+		cmgr->io_bdt_pool[i] = kmalloc_obj(struct io_bdt);
 		if (!cmgr->io_bdt_pool[i]) {
 			printk(KERN_ERR PFX "failed to alloc "
 				"io_bdt_pool[%d]\n", i);
-- 
2.53.0

