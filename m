From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 01/10] ufs: introduce setup_xfer_req callback
Date: Sat, 08 Oct 2016 12:21:11 +0900
Message-ID: <000201d22113$04f4e820$0edeb860$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48530 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbcJHDcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2016 23:32:14 -0400
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEP01MIULB7Q520@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Sat, 08 Oct 2016 12:21:12 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, =?utf-8?B?J+y2lO2XjOq0kSc=?= <hg.chu@samsung.com>

Some UFS host controller may need to configure some things
before any transfer request is issued.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    2 ++
 drivers/scsi/ufs/ufshcd.h |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05c7456..bb537db 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1474,6 +1474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1683,6 +1684,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 430bef1..f37e5a4 100644
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
@@ -283,6 +285,7 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
+	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -799,6 +802,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
+static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
+					bool is_cmd_not_null)
+{
+	if (hba->vops && hba->vops->setup_xfer_req)
+		return hba->vops->setup_xfer_req(hba, tag, is_cmd_not_null);
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
1.7.9.5

