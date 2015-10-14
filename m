From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v4 07/11] scsi: ufs: add specific callback for nexus type
Date: Wed, 14 Oct 2015 18:25:47 +0530
Message-ID: <1444827351-24128-8-git-send-email-alim.akhtar@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55564 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbJNNKR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 09:10:17 -0400
In-reply-to: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, alim.akhtar@samsung.com, arnd@arndb.de

From: Seungwon Jeon <essuuj@gmail.com>

Some host controller needs nexus type information for handling
command. This change adds specific callback function to support
vendor's implementation.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    3 +++
 drivers/scsi/ufs/ufshcd.h |   19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e8b96ec65987..eeb7835c52ab 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1378,6 +1378,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_specify_nexus_t_xfer_req(hba, tag, lrbp);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1578,6 +1579,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_specify_nexus_t_xfer_req(hba, tag, lrbp);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -3842,6 +3844,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
+	ufshcd_vops_specify_nexus_t_tm_req(hba, free_slot, tm_function);
 	__set_bit(free_slot, &hba->outstanding_tasks);
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 500e137bf68a..b3dd08420100 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -259,6 +259,9 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
+ * @specify_nexus_t_xfer_req:
+ * @specify_nexus_t_tm_req: called before command is issued to allow vendor
+ *			specific handling to be set for nexus type.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -280,6 +283,9 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*specify_nexus_t_xfer_req)(struct ufs_hba *,
+					    int, struct scsi_cmnd *);
+	void	(*specify_nexus_t_tm_req)(struct ufs_hba *, int, u8);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -811,4 +817,17 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
+static inline void ufshcd_vops_specify_nexus_t_xfer_req(struct ufs_hba *hba,
+					int tag, struct ufshcd_lrb *lrbp)
+{
+	if (hba->vops && hba->vops->specify_nexus_t_xfer_req)
+		hba->vops->specify_nexus_t_xfer_req(hba, tag, lrbp->cmd);
+}
+
+static inline void ufshcd_vops_specify_nexus_t_tm_req(struct ufs_hba *hba,
+						int free_slot, u8 tm_function)
+{
+	if (hba->vops && hba->vops->specify_nexus_t_tm_req)
+		hba->vops->specify_nexus_t_tm_req(hba, free_slot, tm_function);
+}
 #endif /* End of Header */
-- 
1.7.10.4

