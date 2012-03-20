From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 06/12] [SCSI] mpt2sas : Fix security scan issues reported
 by source code analysis tool
Date: Tue, 20 Mar 2012 12:07:17 +0530
Message-ID: <201203200636.q2K6ajwl032387@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46708 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964787Ab2CTGgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:36:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Modified the source code as per the findings reported by the source
code analysis tool. Source code for the following functionalities
has been touched. None of the driver functionalities has changed. 

- SMP Passthrough IOCTL 
- Debug messages for MPT Replies (i.e. bit 9 of Logging Level) 
- Task Management using sysfs 
- Device removal, i.e. when a target device (including any PD within a volume) is removed, and Volume Deletion. 
- Trace Buffer

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d5f72f7..2567688 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -713,6 +713,11 @@ _base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u16 ioc_status;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
+	if (unlikely(!mpi_reply)) {
+		printk(MPT2SAS_ERR_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+			ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
@@ -944,16 +949,18 @@ _base_interrupt(int irq, void *bus_id)
 		else if (request_desript_type ==
 		    MPI2_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS)
 			goto next;
-		if (smid)
+		if (smid) {
 			cb_idx = _base_get_cb_idx(ioc, smid);
-		if (smid && cb_idx != 0xFF) {
-			rc = mpt_callbacks[cb_idx](ioc, smid, msix_index,
-			    reply);
+		if ((likely(cb_idx < MPT_MAX_CALLBACKS))
+			    && (likely(mpt_callbacks[cb_idx] != NULL))) {
+				rc = mpt_callbacks[cb_idx](ioc, smid,
+				    msix_index, reply);
 			if (reply)
-				_base_display_reply_info(ioc, smid, msix_index,
-				    reply);
+				_base_display_reply_info(ioc, smid,
+				    msix_index, reply);
 			if (rc)
 				mpt2sas_base_free_smid(ioc, smid);
+			}
 		}
 		if (!smid)
 			_base_async_event(ioc, msix_index, reply);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 42f8d71..5aa1345 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -866,8 +866,16 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 		if (smp_request->PassthroughFlags &
 		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE)
 			data = (u8 *)&smp_request->SGL;
-		else
+		else {
+			if (unlikely(data_out == NULL)) {
+				printk(KERN_ERR "failure at %s:%d/%s()!\n",
+				    __FILE__, __LINE__, __func__);
+				mpt2sas_base_free_smid(ioc, smid);
+				ret = -EINVAL;
+				goto out;
+			}
 			data = data_out;
+		}
 
 		if (data[1] == 0x91 && (data[10] == 1 || data[10] == 2)) {
 			ioc->ioc_link_reset_in_progress = 1;
@@ -2835,7 +2843,7 @@ _ctl_host_trace_buffer_enable_store(struct device *cdev,
 	struct mpt2_diag_register diag_register;
 	u8 issue_reset = 0;
 
-	if (sscanf(buf, "%s", str) != 1)
+	if (sscanf(buf, "%9s", str) != 1)
 		return -EINVAL;
 
 	if (!strcmp(str, "post")) {
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 711c03c..7148fb5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3193,16 +3193,19 @@ static u8
 _scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
     u8 msix_index, u32 reply)
 {
-#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	Mpi2SasIoUnitControlReply_t *mpi_reply =
 	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
-#endif
-	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
-	    "sc_complete:handle(0x%04x), (open) "
-	    "smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
-	    ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
-	    le16_to_cpu(mpi_reply->IOCStatus),
-	    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	if (likely(mpi_reply)) {
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
+		"sc_complete:handle(0x%04x), (open) "
+		"smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
+		ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
+		le16_to_cpu(mpi_reply->IOCStatus),
+		le32_to_cpu(mpi_reply->IOCLogInfo)));
+	} else {
+		printk(MPT2SAS_ERR_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+	}
 	return 1;
 }
 
@@ -3281,7 +3284,11 @@ _scsih_tm_volume_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 		   "progress!\n", __func__, ioc->name));
 		return 1;
 	}
-
+	if (unlikely(!mpi_reply)) {
+		printk(MPT2SAS_ERR_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
 	mpi_request_tm = mpt2sas_base_get_msg_frame(ioc, smid);
 	handle = le16_to_cpu(mpi_request_tm->DevHandle);
 	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
@@ -3344,7 +3351,11 @@ _scsih_tm_tr_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 		    "operational\n", __func__, ioc->name));
 		return 1;
 	}
-
+	if (unlikely(!mpi_reply)) {
+		printk(MPT2SAS_ERR_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
 	mpi_request_tm = mpt2sas_base_get_msg_frame(ioc, smid);
 	handle = le16_to_cpu(mpi_request_tm->DevHandle);
 	if (handle != le16_to_cpu(mpi_reply->DevHandle)) {
@@ -7376,6 +7387,13 @@ mpt2sas_scsih_event_callback(struct MPT2SAS_ADAPTER *ioc, u8 msix_index,
 		return 1;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
+
+	if (unlikely(!mpi_reply)) {
+		printk(MPT2SAS_ERR_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return 1;
+	}
+
 	event = le16_to_cpu(mpi_reply->Event);
 
 	switch (event) {
