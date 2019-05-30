From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] scsi: dpt_i2o: Remove call memset after dma_alloc_coherent
Date: Thu, 30 May 2019 23:51:02 +0530
Message-ID: <20190530182102.GA8140@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes below warning reported by coccicheck

/drivers/scsi/dpt_i2o.c:3092:11-29: WARNING: dma_alloc_coherent use in
sys_tbl already zeroes out memory,  so memset is not needed
./drivers/scsi/dpt_i2o.c:2802:10-28: WARNING: dma_alloc_coherent use in
status already zeroes out memory,  so memset is not needed
./drivers/scsi/dpt_i2o.c:2856:20-38: WARNING: dma_alloc_coherent use in
pHba -> reply_pool already zeroes out memory,  so memset is not needed
./drivers/scsi/dpt_i2o.c:1331:10-28: WARNING: dma_alloc_coherent use in
status already zeroes out memory,  so memset is not needed

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/scsi/dpt_i2o.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index a3afd14..128d4f9 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1334,7 +1334,6 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);
 
 	msg[0]=EIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=I2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -2806,7 +2805,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2860,7 +2858,6 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba)
 		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
 		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
 		writel(pHba->reply_pool_pa + (i * REPLY_FRAME_SIZE * 4),
@@ -3095,7 +3092,6 @@ static int adpt_i2o_build_sys_table(void)
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
-- 
2.7.4
