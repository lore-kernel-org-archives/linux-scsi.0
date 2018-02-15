From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: mvsas: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 21:28:39 +0530
Message-ID: <20180215155839.GA8967@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38713 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424925AbeBOP5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 10:57:23 -0500
Received: by mail-pg0-f68.google.com with SMTP id l24so74577pgc.5
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 07:57:23 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([183.82.18.32])
        by smtp.gmail.com with ESMTPSA id n25sm40952094pfk.152.2018.02.15.07.57.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Feb 2018 07:57:20 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index cff43bd..d00d37d 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -790,12 +790,11 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->n_elem = n_elem;
 	slot->slot_tag = tag;

-	slot->buf = dma_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
+	slot->buf = dma_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 	if (!slot->buf) {
 		rc = -ENOMEM;
 		goto err_out_tag;
 	}
-	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);

 	tei.task = task;
 	tei.hdr = &mvi->slot[tag];
--
1.9.1
