From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Errors are logged when application issues illegal request
Date: Wed, 24 Sep 2014 16:25:47 -0500
Message-ID: <20140924212614.316232779@linux.vnet.ibm.com>
References: <20140924212546.034058593@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58078 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752425AbaIXVje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 17:39:34 -0400
Content-Disposition: inline; filename=fff4_fix
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

Failing Device information are logged when IOA firmware detected these
illegal request such as IOA firmware doesn't support inquiry with page
code 2. The patch fixes the issue.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   10 ++++++++++
 drivers/scsi/ipr.h |    1 +
 2 files changed, 11 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-09-23 19:32:26.000000000 -0500
+++ b/drivers/scsi/ipr.c	2014-09-23 19:48:26.179667000 -0500
@@ -2440,6 +2440,7 @@ static void ipr_handle_log_data(struct i
 {
 	u32 ioasc;
 	int error_index;
+	struct ipr_hostrcb_type_21_error *error;
 
 	if (hostrcb->hcam.notify_type != IPR_HOST_RCB_NOTIF_TYPE_ERROR_LOG_ENTRY)
 		return;
@@ -2464,6 +2465,15 @@ static void ipr_handle_log_data(struct i
 	if (!ipr_error_table[error_index].log_hcam)
 		return;
 
+	if (ioasc == IPR_IOASC_HW_CMD_FAILED &&
+	    hostrcb->hcam.overlay_id == IPR_HOST_RCB_OVERLAY_ID_21) {
+		error = &hostrcb->hcam.u.error64.u.type_21_error;
+
+		if (((be32_to_cpu(error->sense_data[0]) & 0x0000ff00) >> 8) == ILLEGAL_REQUEST &&
+			ioa_cfg->log_level <= IPR_DEFAULT_LOG_LEVEL)
+				return;
+	}
+
 	ipr_hcam_err(hostrcb, "%s\n", ipr_error_table[error_index].error);
 
 	/* Set indication we have logged an error */
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2014-09-23 19:32:26.000000000 -0500
+++ b/drivers/scsi/ipr.h	2014-09-23 19:43:01.729667012 -0500
@@ -130,6 +130,7 @@
 #define IPR_IOASC_HW_DEV_BUS_STATUS			0x04448500
 #define	IPR_IOASC_IOASC_MASK			0xFFFFFF00
 #define	IPR_IOASC_SCSI_STATUS_MASK		0x000000FF
+#define IPR_IOASC_HW_CMD_FAILEd			0x046E0000
 #define IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT	0x05240000
 #define IPR_IOASC_IR_RESOURCE_HANDLE		0x05250000
 #define IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA		0x05258100

-- 
