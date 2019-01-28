From: Christopher Diaz Riveros <chrisadr@gentoo.org>
Subject: [patch-next] scsi: pmcraid: use dma_pool_zalloc
Date: Mon, 28 Jan 2019 18:10:44 -0500
Message-ID: <20190128231044.12200-1-chrisadr@gentoo.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes coccinelle warning: *_pool_zalloc should be used for pinstance -> cmd_list [ i ] -> ioa_cb, instead of *_pool_alloc/memset

Signed-off-by: Christopher Diaz Riveros <chrisadr@gentoo.org>
---
 drivers/scsi/pmcraid.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e338d7a4f571..525144a2c936 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4669,7 +4669,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 
 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
 		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
+			dma_pool_zalloc(
 				pinstance->control_pool,
 				GFP_KERNEL,
 				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
@@ -4678,8 +4678,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
 	return 0;
 }
-- 
2.20.1
