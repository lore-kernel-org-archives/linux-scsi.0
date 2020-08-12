Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C06C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15C182076C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHLUyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:54:05 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:54951 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgHLUyF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 16:54:05 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 12 Aug 2020 13:54:01 -0700
Received: from petr-dev3.eng.vmware.com (petr-dev2.eng.vmware.com [10.20.78.5])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 98D62B24B6;
        Wed, 12 Aug 2020 16:54:04 -0400 (EDT)
Received: by petr-dev3.eng.vmware.com (Postfix, from userid 1078)
        id 9184DA00680; Wed, 12 Aug 2020 13:54:04 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:54:04 -0700
From:   Jim Gill <jgill@vmware.com>
To:     <pv-drivers@vmware.com>
CC:     <jgill@vmware.com>, <jejb@linux.ibj.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/3 for-next] pvscsi: Use coherent memory instead of dma
 mapping sg lists
Message-ID: <20200812205404.GA17846@petr-dev3.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Received-SPF: None (EX13-EDG-OU-001.vmware.com: jgill@vmware.com does not
 designate permitted sender hosts)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use coherent memory instead of dma mapping sg lists each
time they are used. This becomes important with SEV/swiotlb where
dma mapping otherwise implies bouncing of the data. It also gets rid
of a point of potential failure.

Tested using a "bonnie++" run on an 8GB pvscsi disk on a swiotlb=force
booted kernel.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
[jgill@vmware.com: forwarding patch on behalf of thellstrom]
Acked-by: jgill@vmware.com
---
 drivers/scsi/vmw_pvscsi.c | 48 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8dbb4db..0573e94 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/pci.h>
+#include <linux/dmapool.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -98,6 +99,8 @@ struct pvscsi_adapter {
 
 	struct list_head		cmd_pool;
 	struct pvscsi_ctx		*cmd_map;
+
+	struct dma_pool                 *sg_pool;
 };
 
 
@@ -372,15 +375,6 @@ static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 			pvscsi_create_sg(ctx, sg, segs);
 
 			e->flags |= PVSCSI_FLAG_CMD_WITH_SG_LIST;
-			ctx->sglPA = dma_map_single(&adapter->dev->dev,
-					ctx->sgl, SGL_SIZE, DMA_TO_DEVICE);
-			if (dma_mapping_error(&adapter->dev->dev, ctx->sglPA)) {
-				scmd_printk(KERN_ERR, cmd,
-					    "vmw_pvscsi: Failed to map ctx sglist for DMA.\n");
-				scsi_dma_unmap(cmd);
-				ctx->sglPA = 0;
-				return -ENOMEM;
-			}
 			e->dataAddr = ctx->sglPA;
 		} else
 			e->dataAddr = sg_dma_address(sg);
@@ -425,14 +419,9 @@ static void pvscsi_unmap_buffers(const struct pvscsi_adapter *adapter,
 	if (bufflen != 0) {
 		unsigned count = scsi_sg_count(cmd);
 
-		if (count != 0) {
+		if (count != 0)
 			scsi_dma_unmap(cmd);
-			if (ctx->sglPA) {
-				dma_unmap_single(&adapter->dev->dev, ctx->sglPA,
-						 SGL_SIZE, DMA_TO_DEVICE);
-				ctx->sglPA = 0;
-			}
-		} else
+		else
 			dma_unmap_single(&adapter->dev->dev, ctx->dataPA,
 					 bufflen, cmd->sc_data_direction);
 	}
@@ -1206,7 +1195,9 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 	unsigned i;
 
 	for (i = 0; i < adapter->req_depth; ++i, ++ctx)
-		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
+		dma_pool_free(adapter->sg_pool, ctx->sgl, ctx->sglPA);
+
+	dma_pool_destroy(adapter->sg_pool);
 }
 
 static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
@@ -1225,10 +1216,11 @@ static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
 
 	pci_release_regions(adapter->dev);
 
-	if (adapter->cmd_map) {
+	if (adapter->sg_pool)
 		pvscsi_free_sgls(adapter);
+
+	if (adapter->cmd_map)
 		kfree(adapter->cmd_map);
-	}
 
 	if (adapter->rings_state)
 		dma_free_coherent(&adapter->dev->dev, PAGE_SIZE,
@@ -1268,20 +1260,26 @@ static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 	struct pvscsi_ctx *ctx;
 	int i;
 
+	/* Use a dma pool so that we can impose alignment constraints. */
+	adapter->sg_pool = dma_pool_create("pvscsi_sg", pvscsi_dev(adapter),
+					   SGL_SIZE, PAGE_SIZE, 0);
+	if (!adapter->sg_pool)
+		return -ENOMEM;
+
 	ctx = adapter->cmd_map;
 	BUILD_BUG_ON(sizeof(struct pvscsi_sg_list) > SGL_SIZE);
 
 	for (i = 0; i < adapter->req_depth; ++i, ++ctx) {
-		ctx->sgl = (void *)__get_free_pages(GFP_KERNEL,
-						    get_order(SGL_SIZE));
-		ctx->sglPA = 0;
-		BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
+		ctx->sgl = dma_pool_alloc(adapter->sg_pool, GFP_KERNEL,
+					  &ctx->sglPA);
 		if (!ctx->sgl) {
 			for (; i >= 0; --i, --ctx) {
-				free_pages((unsigned long)ctx->sgl,
-					   get_order(SGL_SIZE));
+				dma_pool_free(adapter->sg_pool, ctx->sgl,
+					      ctx->sglPA);
 				ctx->sgl = NULL;
 			}
+			dma_pool_destroy(adapter->sg_pool);
+			adapter->sg_pool = NULL;
 			return -ENOMEM;
 		}
 	}
-- 
2.7.4

