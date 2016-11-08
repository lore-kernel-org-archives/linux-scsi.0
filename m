From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: introduce setup_hibern8 callback
Date: Tue, 08 Nov 2016 16:48:07 +0900
Message-ID: <001f01d23994$719997c0$54ccc740$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60955 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752881AbcKHH7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 02:59:09 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGB007APCC3T230@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 08 Nov 2016 16:48:07 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

Some UFS host controller may need to configure some things
around hibern8 enter/exit

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fdb0502..d4a5a9c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2697,6 +2697,8 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	int ret;
 	struct uic_command uic_cmd = {0};
 
+	ufshcd_vops_setup_hibern8(hba, true, PRE_CHANGE);
+
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 
@@ -2710,7 +2712,8 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 		 */
 		if (ufshcd_link_recovery(hba))
 			ret = -ENOLINK;
-	}
+	} else
+		ufshcd_vops_setup_hibern8(hba, true, POST_CHANGE);
 
 	return ret;
 }
@@ -2733,13 +2736,16 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	struct uic_command uic_cmd = {0};
 	int ret;
 
+	ufshcd_vops_setup_hibern8(hba, false, PRE_CHANGE);
+
 	uic_cmd.command = UIC_CMD_DME_HIBER_EXIT;
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	if (ret) {
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
 		ret = ufshcd_link_recovery(hba);
-	}
+	} else
+		ufshcd_vops_setup_hibern8(hba, false, POST_CHANGE);
 
 	return ret;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b084d89..13504b4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -265,6 +265,8 @@ struct ufs_pwr_mode_info {
  *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
  *                  to set some things
+ * @setup_hibern8: called around hibern8 enter/exit
+ *		    to configure some things
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -290,6 +292,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
+	void    (*setup_hibern8)(struct ufs_hba *, bool, bool);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -821,6 +824,13 @@ static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 		return hba->vops->setup_task_mgmt(hba, tag, tm_function);
 }
 
+static inline void ufshcd_vops_setup_hibern8(struct ufs_hba *hba,
+					bool enter, bool notify)
+{
+	if (hba->vops && hba->vops->setup_hibern8)
+		return hba->vops->setup_hibern8(hba, enter, notify);
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
2.1.4

