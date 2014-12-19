From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH v2 1/3] [SCSI] mpt2sas: Merge two similar functions
Date: Fri, 19 Dec 2014 13:38:58 +0100
Message-ID: <20141219123858.GA20271@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

mpt2sas_scsih_set_tm_flag and mpt2sas_scsih_clear_tm_flag
shared a lot of code. Therefore, they are merged into one
function whose behaviour is given by a new parameter
named action.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 43 +++++++-----------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6a1c036..a6f89fd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2253,14 +2253,15 @@ _scsih_tm_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 }
 
 /**
- * mpt2sas_scsih_set_tm_flag - set per target tm_busy
+ * mpt2sas_scsih_tm_flag - set/clear per target tm_busy
  * @ioc: per adapter object
  * @handle: device handle
+ * @action: 1 set per target tm_busy, 0 clear per target tm_busy
  *
  * During taskmangement request, we need to freeze the device queue.
  */
 void
-mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
+mpt2sas_scsih_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 action)
 {
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
@@ -2273,37 +2274,9 @@ mpt2sas_scsih_set_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		if (!sas_device_priv_data)
 			continue;
 		if (sas_device_priv_data->sas_target->handle == handle) {
-			sas_device_priv_data->sas_target->tm_busy = 1;
+			sas_device_priv_data->sas_target->tm_busy = action;
 			skip = 1;
-			ioc->ignore_loginfos = 1;
-		}
-	}
-}
-
-/**
- * mpt2sas_scsih_clear_tm_flag - clear per target tm_busy
- * @ioc: per adapter object
- * @handle: device handle
- *
- * During taskmangement request, we need to freeze the device queue.
- */
-void
-mpt2sas_scsih_clear_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle)
-{
-	struct MPT2SAS_DEVICE *sas_device_priv_data;
-	struct scsi_device *sdev;
-	u8 skip = 0;
-
-	shost_for_each_device(sdev, ioc->shost) {
-		if (skip)
-			continue;
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data)
-			continue;
-		if (sas_device_priv_data->sas_target->handle == handle) {
-			sas_device_priv_data->sas_target->tm_busy = 0;
-			skip = 1;
-			ioc->ignore_loginfos = 0;
+			ioc->ignore_loginfos = action;
 		}
 	}
 }
@@ -2401,7 +2374,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	mpi_request->TaskType = type;
 	mpi_request->TaskMID = cpu_to_le16(smid_task);
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
-	mpt2sas_scsih_set_tm_flag(ioc, handle);
+	mpt2sas_scsih_tm_flag(ioc, handle, 1);
 	init_completion(&ioc->tm_cmds.done);
 	mpt2sas_base_put_smid_hi_priority(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
@@ -2415,7 +2388,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 			    FORCE_BIG_HAMMER);
 			rc = (!rc) ? SUCCESS : FAILED;
 			ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
-			mpt2sas_scsih_clear_tm_flag(ioc, handle);
+			mpt2sas_scsih_tm_flag(ioc, handle, 0);
 			goto err_out;
 		}
 	}
@@ -2465,7 +2438,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 		break;
 	}
 
-	mpt2sas_scsih_clear_tm_flag(ioc, handle);
+	mpt2sas_scsih_tm_flag(ioc, handle, 0);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 	if (m_type == TM_MUTEX_ON)
 		mutex_unlock(&ioc->tm_cmds.mutex);
-- 
1.9.1
