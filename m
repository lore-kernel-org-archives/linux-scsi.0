From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 06/10] scsi: ufs: add specific callback for nexus type
Date: Fri, 21 Aug 2015 14:57:57 +0530
Message-ID: <1440149281-26336-7-git-send-email-alim.akhtar@samsung.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, JBottomley@odin.com, Seungwon Jeon <tgih.jun@samsung.com>
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <tgih.jun@samsung.com>

Some host controller needs nexus type information for handling
command. This change adds specific callback function to support
vendor's implementation.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    6 ++++++
 drivers/scsi/ufs/ufshcd.h |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bb143ac..bc27f5e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1377,6 +1377,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->vops && hba->vops->specify_nexus_t_xfer_req)
+		hba->vops->specify_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1577,6 +1579,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->vops && hba->vops->specify_nexus_t_xfer_req)
+		hba->vops->specify_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -3848,6 +3852,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
+	if (hba->vops && hba->vops->specify_nexus_t_tm_req)
+		hba->vops->specify_nexus_t_tm_req(hba, free_slot, tm_function);
 	__set_bit(free_slot, &hba->outstanding_tasks);
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f4ad3df..0b7dde0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -257,6 +257,9 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
+ * @specify_nexus_t_xfer_req:
+ * @specify_nexus_t_tm_req: called before command is issued to allow vendor
+ *			specific handling to be set for nexus type.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  */
@@ -273,6 +276,9 @@ struct ufs_hba_variant_ops {
 	int	(*pwr_change_notify)(struct ufs_hba *,
 					bool, struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*specify_nexus_t_xfer_req)(struct ufs_hba *,
+					    int, struct scsi_cmnd *);
+	void	(*specify_nexus_t_tm_req)(struct ufs_hba *, int, u8);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 };
-- 
1.7.10.4
