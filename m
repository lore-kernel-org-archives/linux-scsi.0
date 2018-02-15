From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: aic94xx: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 22:09:53 +0530
Message-ID: <20180215163953.GA9545@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34122 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423976AbeBOQig (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 11:38:36 -0500
Received: by mail-pl0-f65.google.com with SMTP id bd10so129158plb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 08:38:36 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([183.82.18.32])
        by smtp.gmail.com with ESMTPSA id i27sm15520965pfi.32.2018.02.15.08.38.34
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Feb 2018 08:38:34 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 2dbc833..1b13133 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1055,14 +1055,13 @@ static struct asd_ascb *asd_ascb_alloc(struct asd_ha_struct *asd_ha,

 	if (ascb) {
 		ascb->dma_scb.size = sizeof(struct scb);
-		ascb->dma_scb.vaddr = dma_pool_alloc(asd_ha->scb_pool,
+		ascb->dma_scb.vaddr = dma_pool_zalloc(asd_ha->scb_pool,
 						     gfp_flags,
 						    &ascb->dma_scb.dma_handle);
 		if (!ascb->dma_scb.vaddr) {
 			kmem_cache_free(asd_ascb_cache, ascb);
 			return NULL;
 		}
-		memset(ascb->dma_scb.vaddr, 0, sizeof(struct scb));
 		asd_init_ascb(asd_ha, ascb);

 		spin_lock_irqsave(&seq->tc_index_lock, flags);
--
1.9.1
