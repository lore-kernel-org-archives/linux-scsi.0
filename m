From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 28 Nov 2016 16:56:26 +0530
Message-ID: <20161128112626.GA31859@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33310 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754475AbcK1L0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2016 06:26:30 -0500
Received: by mail-pf0-f193.google.com with SMTP id 144so6368843pfv.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 03:26:30 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: sahu.rameshwar73@gmail.com, linux-scsi@vger.kernel.org

Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
replaced by pci_pool_zalloc()

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 86eb199..681e5f7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -790,10 +790,9 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->n_elem = n_elem;
 	slot->slot_tag = tag;
 
-	slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
+	slot->buf = pci_pool_zalloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
 	if (!slot->buf)
 		goto err_out_tag;
-	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 
 	tei.task = task;
 	tei.hdr = &mvi->slot[tag];
-- 
1.9.1

