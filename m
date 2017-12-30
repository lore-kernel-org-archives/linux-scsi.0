From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 6/9] scsi: dpt_i2o: Use zeroing allocator rather than allocator/memset
Date: Sat, 30 Dec 2017 20:58:29 +0530
Message-ID: <1514647712-6332-7-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/dpt_i2o.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index fd172b0..67cd777 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1371,13 +1371,12 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		schedule_timeout_uninterruptible(1);
 	} while (m == EMPTY_QUEUE);
 
-	status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
+	status = dma_zalloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
 	if(status == NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2827,14 +2826,13 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
-	status = dma_alloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
+	status = dma_zalloc_coherent(&pHba->pDev->dev, 4, &addr, GFP_KERNEL);
 	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2881,14 +2879,14 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 			pHba->reply_pool, pHba->reply_pool_pa);
 	}
 
-	pHba->reply_pool = dma_alloc_coherent(&pHba->pDev->dev,
-				pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
-				&pHba->reply_pool_pa, GFP_KERNEL);
+	pHba->reply_pool = dma_zalloc_coherent(&pHba->pDev->dev,
+				pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4,
+				&pHba->reply_pool_pa, GFP_KERNEL);
 	if (!pHba->reply_pool) {
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
 		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
@@ -3117,13 +3115,12 @@ static int adpt_i2o_build_sys_table(void)
 	sys_tbl_len = sizeof(struct i2o_sys_tbl) +	// Header + IOPs
 				(hba_count) * sizeof(struct i2o_sys_tbl_entry);
 
-	sys_tbl = dma_alloc_coherent(&pHba->pDev->dev,
-				sys_tbl_len, &sys_tbl_pa, GFP_KERNEL);
+	sys_tbl = dma_zalloc_coherent(&pHba->pDev->dev, sys_tbl_len,
+				      &sys_tbl_pa, GFP_KERNEL);
 	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
-- 
2.7.4
