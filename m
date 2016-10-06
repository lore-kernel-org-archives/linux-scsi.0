From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 1/8] ufs: add some vendor specific operations
Date: Thu, 06 Oct 2016 17:17:50 +0900
Message-ID: <006401d21faa$210df570$6329e050$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:50583 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbcJFIRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 04:17:54 -0400
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEM02BGJ9PFRG30@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 06 Oct 2016 17:17:50 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

Some UFS host controller may need to require some sequences
before used clocks are turned on or off.
e.g) control internal gates in UFS host

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   15 +++++++++++++--
 drivers/scsi/ufs/ufshcd.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05c7456..82c9a40 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1474,6 +1474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_set_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1683,6 +1684,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_set_nexus_t_xfer_req(hba, tag, lrbp->cmd);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -2651,6 +2653,8 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	int ret;
 	struct uic_command uic_cmd = {0};
 
+	ufshcd_vops_hibern8_notify(hba, true, PRE_CHANGE);
+
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 
@@ -2664,7 +2668,8 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 		 */
 		if (ufshcd_link_recovery(hba))
 			ret = -ENOLINK;
-	}
+	} else
+		ufshcd_vops_hibern8_notify(hba, true, POST_CHANGE);
 
 	return ret;
 }
@@ -2687,13 +2692,16 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	struct uic_command uic_cmd = {0};
 	int ret;
 
+	ufshcd_vops_hibern8_notify(hba, false, PRE_CHANGE);
+
 	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
 		ret = ufshcd_link_recovery(hba);
-	}
+	} else
+		ufshcd_vops_hibern8_notify(hba, false, POST_CHANGE);
 
 	return ret;
 }
@@ -4312,6 +4320,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
+	ufshcd_vops_set_nexus_t_task_mgmt(hba, free_slot, tm_function);
 	__set_bit(free_slot, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
@@ -5389,6 +5398,8 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	if (!head || list_empty(head))
 		goto out;
 
+	ufshcd_vops_pre_setup_clocks(hba, on);
+
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
 			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 430bef1..b97f7c2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -252,6 +252,7 @@ struct ufs_pwr_mode_info {
  * @exit: called to cleanup everything done in init
  * @get_ufs_hci_version: called to get UFS HCI version
  * @clk_scale_notify: notifies that clks are scaled up/down
+ * @pre_setup_clocks: called before controlling used clocks
  * @setup_clocks: called before touching any of the controller registers
  * @setup_regulators: called before accessing the host controller
  * @hce_enable_notify: called before and after HCE enable bit is set to allow
@@ -261,6 +262,9 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
+ * @set_nexus_t_xfer_req:
+ * @set_nexus_t_task_mgmt:
+ * @hibern8_notify:
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -273,6 +277,7 @@ struct ufs_hba_variant_ops {
 	u32	(*get_ufs_hci_version)(struct ufs_hba *);
 	int	(*clk_scale_notify)(struct ufs_hba *, bool,
 				    enum ufs_notify_change_status);
+	int	(*pre_setup_clocks)(struct ufs_hba *, bool);
 	int	(*setup_clocks)(struct ufs_hba *, bool);
 	int     (*setup_regulators)(struct ufs_hba *, bool);
 	int	(*hce_enable_notify)(struct ufs_hba *,
@@ -283,6 +288,10 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*set_nexus_t_xfer_req)(struct ufs_hba *,
+					int, struct scsi_cmnd *);
+	void	(*set_nexus_t_task_mgmt)(struct ufs_hba *, int, u8);
+	void    (*hibern8_notify)(struct ufs_hba *, u8, bool);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -755,6 +764,13 @@ static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
 	return 0;
 }
 
+static inline int ufshcd_vops_pre_setup_clocks(struct ufs_hba *hba, bool on)
+{
+	if (hba->vops && hba->vops->pre_setup_clocks)
+		return hba->vops->pre_setup_clocks(hba, on);
+	return 0;
+}
+
 static inline int ufshcd_vops_setup_clocks(struct ufs_hba *hba, bool on)
 {
 	if (hba->vops && hba->vops->setup_clocks)
@@ -799,6 +815,27 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
+static inline void ufshcd_vops_set_nexus_t_xfer_req(struct ufs_hba *hba,
+					int tag, struct scsi_cmnd *cmd)
+{
+	if (hba->vops && hba->vops->set_nexus_t_xfer_req)
+		return hba->vops->set_nexus_t_xfer_req(hba, tag, cmd);
+}
+
+static inline void ufshcd_vops_set_nexus_t_task_mgmt(struct ufs_hba *hba,
+					int tag, u8 tm_function)
+{
+	if (hba->vops && hba->vops->set_nexus_t_task_mgmt)
+		return hba->vops->set_nexus_t_task_mgmt(hba, tag, tm_function);
+}
+
+static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
+					u8 enter, bool notify)
+{
+	if (hba->vops && hba->vops->hibern8_notify)
+		return hba->vops->hibern8_notify(hba, enter, notify);
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
1.7.9.5

