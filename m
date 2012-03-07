From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH v2] [SCSI] pm8001: fix endian issue.
Date: Wed,  7 Mar 2012 23:10:37 +0530
Message-ID: <1331142037-26296-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mark_salyzyn@xyratex.com
Cc: jack_wang@usish.com, lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Data type of the 'tag' field of 'fw_flash_Update_resp' should be
__le32.

Data type of  'pHeader' should be __le32.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    6 +++---
 drivers/scsi/pm8001/pm8001_hwi.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 597593b..3976fab 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3150,7 +3150,7 @@ mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct fw_control_ex	fw_control_context;
 	struct fw_flash_Update_resp *ppayload =
 		(struct fw_flash_Update_resp *)(piomb + 4);
-	u32 tag = ppayload->tag;
+	u32 tag = le32_to_cpu(ppayload->tag);
 	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
 	status = le32_to_cpu(ppayload->status);
 	memcpy(&fw_control_context,
@@ -3496,8 +3496,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
-	u32 pHeader = (u32)*(u32 *)piomb;
-	u8 opc = (u8)(pHeader & 0xFFF);
+	__le32 pHeader = (__le32)*(__le32 *)piomb;
+	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
 
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 1a4611e..d437309 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -599,7 +599,7 @@ struct fw_flash_Update_req {
  *
  */
 struct fw_flash_Update_resp {
-	dma_addr_t	tag;
+	__le32	tag;
 	__le32	status;
 	u32	reserved[13];
 } __attribute__((packed, aligned(4)));
-- 
1.7.4.4
