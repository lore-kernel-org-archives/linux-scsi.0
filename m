From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2] ufs: introduce setup_xfer_req callback
Date: Thu, 10 Nov 2016 21:14:36 +0900
Message-ID: <002201d23b4c$012486d0$036d9470$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58369 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755733AbcKJMOj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2016 07:14:39 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGF001EQE0DPY90@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 10 Nov 2016 21:14:37 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, vinholikatti@gmail.com
Cc: cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

Some UFS host controller may need to configure some things
before any transfer request is issued.

V2: change data type of 2nd argument

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |  2 ++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8cf5d8f..bf78321 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1516,6 +1516,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1727,6 +1728,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index afff7f4..e935fd1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -261,6 +261,8 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
+ * @setup_xfer_req: called before any transfer request is issued
+ *                  to set some things
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -284,6 +286,7 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -801,6 +804,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
+static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
+					bool is_scsi_cmd)
+{
+	if (hba->vops && hba->vops->setup_xfer_req)
+		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
2.1.4

