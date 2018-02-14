From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: myrs: ensure sge_count is set correctly
Date: Wed, 14 Feb 2018 16:02:52 +0000
Message-ID: <20180214160252.32230-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The DMA size is not being assigned to sge_count, instead sge_addr is
being assigned this value, which is incorrected.

Detected by CoverityScan, CID#1465233 ("Unused value")

Fixes: 8a8606895947 ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 16498e1b0dd4..eb67ed3a7cff 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -442,7 +442,7 @@ myrs_translate_pdev(myrs_hba *cs, unsigned char channel,
 		DAC960_V2_TranslatePhysicalToLogicalDevice;
 	sgl = &mbox->PhysicalDeviceInfo.dma_addr;
 	sgl->sge[0].sge_addr = devmap_addr;
-	sgl->sge[0].sge_addr = mbox->PhysicalDeviceInfo.dma_size;
+	sgl->sge[0].sge_count = mbox->PhysicalDeviceInfo.dma_size;
 
 	myrs_exec_cmd(cs, cmd_blk);
 	status = cmd_blk->status;
-- 
2.15.1

