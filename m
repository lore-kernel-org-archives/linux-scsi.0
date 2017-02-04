From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 4/8] scsi: ufs: add host state prints in failure cases
Date: Fri,  3 Feb 2017 16:57:28 -0800
Message-ID: <1486169848-22814-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

Whenever some UFS failure occurs the driver prints the UFS
registers in order to help with analysis of the failure.
However this may not be sufficient in some cases, so having
the host controller state as it is represented and managed in
the driver will contribute to analysis efforts.
Added prints of various fields in the hba struct which may be
of interest.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e75e50d..056e912 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -453,6 +453,28 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 	}
 }
 
+static void ufshcd_print_host_state(struct ufs_hba *hba)
+{
+	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
+	dev_err(hba->dev, "lrb in use=0x%lx, outstanding reqs=0x%lx tasks=0x%lx\n",
+		hba->lrb_in_use, hba->outstanding_tasks, hba->outstanding_reqs);
+	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
+		hba->saved_err, hba->saved_uic_err);
+	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
+	dev_err(hba->dev, "PM in progress=%d, sys. suspended=%d\n",
+		hba->pm_op_in_progress, hba->is_sys_suspended);
+	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
+		hba->auto_bkops_enabled, hba->host->host_self_blocked);
+	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
+	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
+		hba->eh_flags, hba->req_abort_count);
+	dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
+		hba->capabilities, hba->caps);
+	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
+		hba->dev_quirks);
+}
+
 /**
  * ufshcd_print_pwr_info - print power params as saved in hba
  * power info
@@ -4426,6 +4448,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index, u8 *resp)
 				"OCS error from controller = %x for tag %d\n",
 				ocs, lrbp->task_tag);
 		ufshcd_print_host_regs(hba);
+		ufshcd_print_host_state(hba);
 		break;
 	} /* end of switch */
 
@@ -5477,6 +5500,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	scsi_print_command(hba->lrb[tag].cmd);
 	if (!hba->req_abort_count) {
 		ufshcd_print_host_regs(hba);
+		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
 		ufshcd_print_trs(hba, 1 << tag, true);
 	} else {
@@ -7738,6 +7762,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (err) {
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
+		ufshcd_print_host_state(hba);
 		goto out_remove_scsi_host;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
