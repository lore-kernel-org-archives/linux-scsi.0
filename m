From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: introduce setup_task_mgmt
Date: Tue, 08 Nov 2016 16:47:08 +0900
Message-ID: <001e01d23994$4eca9cd0$ec5fd670$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47379 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbcKHH6z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 02:58:55 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGB02ADHCAKRD20@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 08 Nov 2016 16:47:08 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

Some UFS host controller may need to configure some things
before any task management request is issued

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |  1 +
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bf78321..fdb0502 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4358,6 +4358,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
 	/* send command to the controller */
+	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
 	__set_bit(free_slot, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f2a69c0..b084d89 100644
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
 		return hba->vops->setup_xfer_req(hba, tag, is_cmd_not_null);
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

