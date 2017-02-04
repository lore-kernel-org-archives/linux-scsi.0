From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 2/8] scsi: ufs: reduce printout for aborted requests
Date: Fri,  3 Feb 2017 16:56:50 -0800
Message-ID: <1486169811-22736-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

Details printed for each request that is aborted can overload the
target as there can be several requests that are aborted at once.
This change will print full request details only for the first
aborted request since the last link reset, and minimal details
for other subsequent requests.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 46 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  3 +++
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 61fea17..64d619a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -396,6 +396,7 @@ static void ufshcd_print_host_regs(struct ufs_hba *hba)
 void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 {
 	struct ufshcd_lrb *lrbp;
+	int prdt_length;
 	int tag;
 
 	for_each_set_bit(tag, &bitmap, hba->nutrs) {
@@ -417,18 +418,17 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 			(u64)lrbp->ucd_rsp_dma_addr);
 		ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
 				sizeof(struct utp_upiu_rsp));
-		if (pr_prdt) {
-			int prdt_length = le16_to_cpu(
-				lrbp->utr_descriptor_ptr->prd_table_length);
 
-			dev_err(hba->dev,
-				"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
-				tag, prdt_length,
-				(u64)lrbp->ucd_prdt_dma_addr);
+		prdt_length = le16_to_cpu(
+			lrbp->utr_descriptor_ptr->prd_table_length);
+		dev_err(hba->dev,
+			"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
+			tag, prdt_length,
+			(u64)lrbp->ucd_prdt_dma_addr);
+
+		if (pr_prdt)
 			ufshcd_hex_dump("UPIU PRDT: ", lrbp->ucd_prdt_ptr,
-					sizeof(struct ufshcd_sg_entry) *
-					prdt_length);
-		}
+				sizeof(struct ufshcd_sg_entry) * prdt_length);
 	}
 }
 
@@ -1848,6 +1848,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	hba->req_abort_count = 0;
+
 	/* acquire the tag to make sure device cmds don't use it */
 	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) {
 		/*
@@ -4970,7 +4972,9 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(host->host_lock, flags);
 	ufshcd_transfer_req_compl(hba);
 	spin_unlock_irqrestore(host->host_lock, flags);
+
 out:
+	hba->req_abort_count = 0;
 	if (!err) {
 		err = SUCCESS;
 	} else {
@@ -5054,11 +5058,23 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	/* Print Transfer Request of aborted task */
 	dev_err(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
-	scsi_print_command(hba->lrb[tag].cmd);
-	ufshcd_print_host_regs(hba);
-	ufshcd_print_pwr_info(hba);
-	ufshcd_print_trs(hba, 1 << tag, true);
 
+	/*
+	 * Print detailed info about aborted request.
+	 * As more than one request might get aborted at the same time,
+	 * print full information only for the first aborted request in order
+	 * to reduce repeated printouts. For other aborted requests only print
+	 * basic details.
+	 */
+	scsi_print_command(hba->lrb[tag].cmd);
+	if (!hba->req_abort_count) {
+		ufshcd_print_host_regs(hba);
+		ufshcd_print_pwr_info(hba);
+		ufshcd_print_trs(hba, 1 << tag, true);
+	} else {
+		ufshcd_print_trs(hba, 1 << tag, false);
+	}
+	hba->req_abort_count++;
 
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
@@ -5707,6 +5723,8 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 	memset(&hba->ufs_stats.nl_err, 0, err_reg_hist_size);
 	memset(&hba->ufs_stats.tl_err, 0, err_reg_hist_size);
 	memset(&hba->ufs_stats.dme_err, 0, err_reg_hist_size);
+
+	hba->req_abort_count = 0;
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 292fc14..b7ce129 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -594,6 +594,9 @@ struct ufs_hba {
 
 	bool wlun_dev_clr_ua;
 
+	/* Number of requests aborts */
+	int req_abort_count;
+
 	/* Number of lanes available (1 or 2) for Rx/Tx */
 	u32 lanes_per_direction;
 	struct ufs_pa_layer_attr pwr_info;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
