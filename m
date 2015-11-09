From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 03/11] scsi: ufs: add quirk to contain unconformable utrd
 field
Date: Mon, 09 Nov 2015 10:56:19 +0530
Message-ID: <1447046787-480-4-git-send-email-alim.akhtar@samsung.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, kishon@ti.com
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

UTRD(UTP Transfer Request Descriptor)'s field such as offset/length,
especially response's has DWORD expression. This quirk can be specified
for host controller not to conform standard.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   28 +++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |    7 +++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 131c72038bf8..587a9c8fbfe9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1009,7 +1009,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  *
  * Returns 0 in case of success, non-zero value in case of failure
  */
-static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
+static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	struct ufshcd_sg_entry *prd_table;
 	struct scatterlist *sg;
@@ -1023,8 +1023,13 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
 		return sg_segments;
 
 	if (sg_segments) {
-		lrbp->utr_descriptor_ptr->prd_table_length =
-					cpu_to_le16((u16) (sg_segments));
+		if (hba->quirks & UFSHCI_QUIRK_BYTE_ALIGN_UTRD)
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((u16)(sg_segments *
+					sizeof(struct ufshcd_sg_entry)));
+		else
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((u16) (sg_segments));
 
 		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
 
@@ -1347,7 +1352,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* form UPIU before issuing the command */
 	ufshcd_compose_upiu(hba, lrbp);
-	err = ufshcd_map_sg(lrbp);
+	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
 		clear_bit_unlock(tag, &hba->lrb_in_use);
@@ -2034,13 +2039,22 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].command_desc_base_addr_hi =
 				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
 
+		if (hba->quirks & UFSHCI_QUIRK_BYTE_ALIGN_UTRD) {
+			utrdlp[i].response_upiu_offset =
+				cpu_to_le16(response_offset);
+			utrdlp[i].prd_table_offset =
+				cpu_to_le16(prdt_offset);
+			utrdlp[i].response_upiu_length =
+				cpu_to_le16(ALIGNED_UPIU_SIZE);
+		} else {
 		/* Response upiu and prdt offset should be in double words */
-		utrdlp[i].response_upiu_offset =
+			utrdlp[i].response_upiu_offset =
 				cpu_to_le16((response_offset >> 2));
-		utrdlp[i].prd_table_offset =
+			utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
-		utrdlp[i].response_upiu_length =
+			utrdlp[i].response_upiu_length =
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+		}
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_req_ptr =
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2570d9477b37..6cd542a803d5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -467,6 +467,13 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
 
+	/*
+	 * This quirk needs to be enabled if host controller doesn't conform
+	 * with UTRD. Some fields such as offset/length might not be in double
+	 * word, but in byte.
+	 */
+	#define UFSHCI_QUIRK_BYTE_ALIGN_UTRD			UFS_BIT(6)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
-- 
1.7.10.4
