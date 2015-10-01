From: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 07/13] scsi: ufs: add specific callback for nexus type
Date: Thu, 01 Oct 2015 13:39:24 +0530
Message-ID: <1443686970-28104-8-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Some host controller needs nexus type information for handling
command. This change adds specific callback function to support
vendor's implementation.

Signed-off-by: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/ufs/ufshcd.c |    6 ++++++
 drivers/scsi/ufs/ufshcd.h |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 07659be..46f92fe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1378,6 +1378,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->vops && hba->vops->specify_nexus_t_xfer_req)
+		hba->vops->specify_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1578,6 +1580,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	hba->dev_cmd.complete = &wait;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->vops && hba->vops->specify_nexus_t_xfer_req)
+		hba->vops->specify_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -3849,6 +3853,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
+	if (hba->vops && hba->vops->specify_nexus_t_tm_req)
+		hba->vops->specify_nexus_t_tm_req(hba, free_slot, tm_function);
 	__set_bit(free_slot, &hba->outstanding_tasks);
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a4543c8..75af314 100644
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
