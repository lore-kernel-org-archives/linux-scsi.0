From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: pmcraid: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 20:44:38 +0530
Message-ID: <20180215151438.GA8253@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46902 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033584AbeBOPNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 10:13:20 -0500
Received: by mail-pl0-f67.google.com with SMTP id x19so1877504plr.13
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 07:13:20 -0800 (PST)
Received: from jordon-HP-15-Notebook-PC ([183.82.18.32])
        by smtp.gmail.com with ESMTPSA id j3sm40363091pfj.180.2018.02.15.07.13.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Feb 2018 07:13:18 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/pmcraid.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 201c8de..7535161 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4716,7 +4716,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)

 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
 		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
+			dma_pool_zalloc(
 				pinstance->control_pool,
 				GFP_KERNEL,
 				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
@@ -4725,8 +4725,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }
--
1.9.1
