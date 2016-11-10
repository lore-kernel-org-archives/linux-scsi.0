From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: introduce setup_task_mgmt
Date: Thu, 10 Nov 2016 21:16:15 +0900
Message-ID: <002301d23b4c$3ba55550$b2effff0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48279 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbcKJMQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 07:16:17 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGF024ALE33GY60@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 10 Nov 2016 21:16:15 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vinholikatti@gmail.com
Cc: cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

Some UFS host controller may need to configure some things
before any task management request is issued

v2: move a comment to another place

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |  2 ++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bf78321..301b592 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4357,6 +4357,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param1 = cpu_to_be32(lun_id);
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
+	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
+
 	/* send command to the controller */
 	__set_bit(free_slot, &hba->outstanding_tasks);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e935fd1..05d8384 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -263,6 +263,8 @@ struct ufs_pwr_mode_info {
  *			to be set.
  * @setup_xfer_req: called before any transfer request is issued
  *                  to set some things
+ * @setup_task_mgmt: called before any task management request is issued
+ *                  to set some things
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -287,6 +289,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -811,6 +814,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
+					int tag, u8 tm_function)
+{
+	if (hba->vops && hba->vops->setup_task_mgmt)
+		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
2.1.4


