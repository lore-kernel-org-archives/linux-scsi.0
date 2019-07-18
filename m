From: Vasyl Gomonovych <gomonovych@gmail.com>
Subject: [PATCH] scsi: pmcraid: Use dma_pool_zalloc rather than dma_pool_alloc
Date: Thu, 18 Jul 2019 20:11:46 +0200
Message-ID: <20190718181146.23019-1-gomonovych@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Vasyl Gomonovych <gomonovych@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0
The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci.

Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
---
 drivers/scsi/pmcraid.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 71ff3936da4f945f3d8a798a8b2129ca3c07ec22..f79d7750934e629c6d6edc1a075205247889531d 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4653,9 +4653,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 		return -ENOMEM;
 
 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
-		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
-				pinstance->control_pool,
+		pinstance->cmd_list[i]->ioa_cb = dma_pool_zalloc(pinstance->control_pool,
 				GFP_KERNEL,
 				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
 
@@ -4663,8 +4661,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }
-- 
2.17.1
