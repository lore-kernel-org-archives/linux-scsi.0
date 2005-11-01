From: brking@us.ibm.com
Subject: [PATCH 25/26] ipr: Better handle failure of adapter bringup commands
Date: Tue, 01 Nov 2005 17:02:55 -0600
Message-ID: <200511012302.jA1N2uwf002943@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:3034 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751421AbVKAXC5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2v5O019528
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:57 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2vbn098370
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:57 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2uuu002959
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Some new ipr adapters do not support some of the initialization
commands currently sent to it from the driver. Handle these
commands failing and continue on with the adapter initialization.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   59 +++++++++++++++++++++++++++++------
 linux-2.6-bjking1/drivers/scsi/ipr.h |    2 +
 2 files changed, 52 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_reset_cmd_failure drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_reset_cmd_failure	2005-11-01 16:08:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:22.000000000 -0600
@@ -84,6 +84,7 @@
 #define IPR_IOASC_HW_DEV_BUS_STATUS			0x04448500
 #define	IPR_IOASC_IOASC_MASK			0xFFFFFF00
 #define	IPR_IOASC_SCSI_STATUS_MASK		0x000000FF
+#define IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT	0x05240000
 #define IPR_IOASC_IR_RESOURCE_HANDLE		0x05250000
 #define IPR_IOASC_IR_NO_CMDS_TO_2ND_IOA		0x05258100
 #define IPR_IOASA_IR_DUAL_IOA_DISABLED		0x052C8000
@@ -1031,6 +1032,7 @@ struct ipr_cmnd {
 	struct timer_list timer;
 	void (*done) (struct ipr_cmnd *);
 	int (*job_step) (struct ipr_cmnd *);
+	int (*job_step_failed) (struct ipr_cmnd *);
 	u16 cmd_index;
 	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
 	dma_addr_t sense_buffer_dma;
diff -puN drivers/scsi/ipr.c~ipr_reset_cmd_failure drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_reset_cmd_failure	2005-11-01 16:08:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-11-01 16:08:22.000000000 -0600
@@ -4884,6 +4884,51 @@ static void ipr_build_mode_sense(struct 
 }
 
 /**
+ * ipr_reset_cmd_failed - Handle failure of IOA reset command
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function handles the failure of an IOA bringup command.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_cmd_failed(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+
+	dev_err(&ioa_cfg->pdev->dev,
+		"0x%02X failed with IOASC: 0x%08X\n",
+		ipr_cmd->ioarcb.cmd_pkt.cdb[0], ioasc);
+
+	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
+ * ipr_reset_mode_sense_failed - Handle failure of IOAFP mode sense
+ * @ipr_cmd:	ipr command struct
+ *
+ * This function handles the failure of a Mode Sense to the IOAFP.
+ * Some adapters do not handle all mode pages.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_mode_sense_failed(struct ipr_cmnd *ipr_cmd)
+{
+	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+
+	if (ioasc == IPR_IOASC_IR_INVALID_REQ_TYPE_OR_PKT) {
+		ipr_cmd->job_step = ipr_setup_write_cache;
+		return IPR_RC_JOB_CONTINUE;
+	}
+
+	return ipr_reset_cmd_failed(ipr_cmd);
+}
+
+/**
  * ipr_ioafp_mode_sense_page28 - Issue Mode Sense Page 28 to IOA
  * @ipr_cmd:	ipr command struct
  *
@@ -4904,6 +4949,7 @@ static int ipr_ioafp_mode_sense_page28(s
 			     sizeof(struct ipr_mode_pages));
 
 	ipr_cmd->job_step = ipr_ioafp_mode_select_page28;
+	ipr_cmd->job_step_failed = ipr_reset_mode_sense_failed;
 
 	ipr_do_req(ipr_cmd, ipr_reset_ioa_job, ipr_timeout, IPR_INTERNAL_TIMEOUT);
 
@@ -5716,7 +5762,6 @@ static int ipr_reset_shutdown_ioa(struct
 static void ipr_reset_ioa_job(struct ipr_cmnd *ipr_cmd)
 {
 	u32 rc, ioasc;
-	unsigned long scratch = ipr_cmd->u.scratch;
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	do {
@@ -5732,17 +5777,13 @@ static void ipr_reset_ioa_job(struct ipr
 		}
 
 		if (IPR_IOASC_SENSE_KEY(ioasc)) {
-			dev_err(&ioa_cfg->pdev->dev,
-				"0x%02X failed with IOASC: 0x%08X\n",
-				ipr_cmd->ioarcb.cmd_pkt.cdb[0], ioasc);
-
-			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
-			list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-			return;
+			rc = ipr_cmd->job_step_failed(ipr_cmd);
+			if (rc == IPR_RC_JOB_RETURN)
+				return;
 		}
 
 		ipr_reinit_ipr_cmnd(ipr_cmd);
-		ipr_cmd->u.scratch = scratch;
+		ipr_cmd->job_step_failed = ipr_reset_cmd_failed;
 		rc = ipr_cmd->job_step(ipr_cmd);
 	} while(rc == IPR_RC_JOB_CONTINUE);
 }
_
