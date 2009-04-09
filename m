From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/6] mpt fusion: RESEND: fix for previous patch taskmgmt in progess should be cleared before return
Date: Thu, 9 Apr 2009 16:34:30 +0530
Message-ID: <20090409110424.GB5255@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:59069 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZDILX3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 07:23:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Small fix for previous Patch applied on 26/02/2009: subject line : "mpt fusion: config, Taskmgmt cmd, Internal cmd, Ioctl cmd changes".

Before returning from function make sure that taskmgmt in progress bit is
cleared.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 842e4f8..f85d56b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -560,11 +560,14 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
 	if (mf == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
-			"%s, no msg frames @%d!!\n",
-			ioc->name, __func__, __LINE__));
-		return 0;
+			"%s, no msg frames @%d!!\n", ioc->name,
+			__func__, __LINE__));
+		goto out_fail;
 	}
 
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "TaskMgmt request (mf=%p)\n",
+		ioc->name, mf));
+
 	/* Format the Request
 	 */
 	pScsiTm = (SCSITaskMgmt_t *) mf;
@@ -577,9 +580,18 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
 	DBG_DUMP_TM_REQUEST_FRAME(ioc, (u32 *)mf);
 
+	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	   "TaskMgmt type=%d (sas device delete) fw_channel = %d fw_id = %d)\n",
+	   ioc->name, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET, channel, id));
+
 	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
 
 	return 1;
+
+ out_fail:
+
+	mpt_clear_taskmgmt_in_progress_flag(ioc);
+	return 0;
 }
 
 /**
