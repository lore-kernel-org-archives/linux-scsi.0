From: Brian King <brking@us.ibm.com>
Subject: [PATCH 14/16] ipr: printk macro cleanup/removal
Date: Fri, 17 Feb 2006 16:21:11 -0600
Message-ID: <200602172221.k1HMLCHU017455@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34985 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751849AbWBQWVN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 17:21:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove some unused printk macros, make some more robust, and
convert some to use standard printk macros when possible.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |   15 ++++++++-------
 libata-dev-bjking1/drivers/scsi/ipr.h |   25 ++++++-------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_printk_fixes drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_printk_fixes	2006-02-14 13:12:20.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-02-14 13:16:29.000000000 -0600
@@ -1192,30 +1192,17 @@ struct ipr_ucode_image_header {
  */
 #define ipr_err(...) printk(KERN_ERR IPR_NAME ": "__VA_ARGS__)
 #define ipr_info(...) printk(KERN_INFO IPR_NAME ": "__VA_ARGS__)
-#define ipr_crit(...) printk(KERN_CRIT IPR_NAME ": "__VA_ARGS__)
-#define ipr_warn(...) printk(KERN_WARNING IPR_NAME": "__VA_ARGS__)
 #define ipr_dbg(...) IPR_DBG_CMD(printk(KERN_INFO IPR_NAME ": "__VA_ARGS__))
 
-#define ipr_sdev_printk(level, sdev, fmt, args...) \
-	sdev_printk(level, sdev, fmt, ## args)
+#define ipr_ra_printk(level, ioa_cfg, ra, fmt, ...) \
+	printk(level IPR_NAME ": %d:%d:%d:%d: " fmt, (ioa_cfg)->host->host_no, \
+		(ra).bus, (ra).target, (ra).lun, ##__VA_ARGS__)
 
-#define ipr_sdev_err(sdev, fmt, ...) \
-	ipr_sdev_printk(KERN_ERR, sdev, fmt, ##__VA_ARGS__)
-
-#define ipr_sdev_info(sdev, fmt, ...) \
-	ipr_sdev_printk(KERN_INFO, sdev, fmt, ##__VA_ARGS__)
-
-#define ipr_sdev_dbg(sdev, fmt, ...) \
-	IPR_DBG_CMD(ipr_sdev_printk(KERN_INFO, sdev, fmt, ##__VA_ARGS__))
-
-#define ipr_res_printk(level, ioa_cfg, res, fmt, ...) \
-	printk(level IPR_NAME ": %d:%d:%d:%d: " fmt, ioa_cfg->host->host_no, \
-		res.bus, res.target, res.lun, ##__VA_ARGS__)
+#define ipr_ra_err(ioa_cfg, ra, fmt, ...) \
+	ipr_ra_printk(KERN_ERR, ioa_cfg, ra, fmt, ##__VA_ARGS__)
 
 #define ipr_res_err(ioa_cfg, res, fmt, ...) \
-	ipr_res_printk(KERN_ERR, ioa_cfg, res, fmt, ##__VA_ARGS__)
-#define ipr_res_dbg(ioa_cfg, res, fmt, ...) \
-	IPR_DBG_CMD(ipr_res_printk(KERN_INFO, ioa_cfg, res, fmt, ##__VA_ARGS__))
+	ipr_ra_err(ioa_cfg, (res)->cfgte.res_addr, fmt, ##__VA_ARGS__)
 
 #define ipr_phys_res_err(ioa_cfg, res, fmt, ...)			\
 {									\
diff -puN drivers/scsi/ipr.c~ipr_printk_fixes drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_printk_fixes	2006-02-14 13:12:20.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-02-14 13:17:10.000000000 -0600
@@ -1333,8 +1333,8 @@ static void ipr_handle_log_data(struct i
 		return;
 
 	if (ipr_is_device(&hostrcb->hcam.u.error.failing_dev_res_addr)) {
-		ipr_res_err(ioa_cfg, hostrcb->hcam.u.error.failing_dev_res_addr,
-			    "%s\n", ipr_error_table[error_index].error);
+		ipr_ra_err(ioa_cfg, hostrcb->hcam.u.error.failing_dev_res_addr,
+			   "%s\n", ipr_error_table[error_index].error);
 	} else {
 		dev_err(&ioa_cfg->pdev->dev, "%s\n",
 			ipr_error_table[error_index].error);
@@ -3332,7 +3332,7 @@ static int __ipr_eh_dev_reset(struct scs
 	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
 	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
 
-	ipr_sdev_err(scsi_cmd->device, "Resetting device\n");
+	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
 	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
 
 	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
@@ -3417,7 +3417,7 @@ static void ipr_abort_timeout(struct ipr
 		return;
 	}
 
-	ipr_sdev_err(ipr_cmd->u.sdev, "Abort timed out. Resetting bus\n");
+	sdev_printk(KERN_ERR, ipr_cmd->u.sdev, "Abort timed out. Resetting bus.n");
 	reset_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ipr_cmd->sibling = reset_cmd;
 	reset_cmd->sibling = ipr_cmd;
@@ -3481,7 +3481,8 @@ static int ipr_cancel_op(struct scsi_cmn
 	cmd_pkt->cdb[0] = IPR_CANCEL_ALL_REQUESTS;
 	ipr_cmd->u.sdev = scsi_cmd->device;
 
-	ipr_sdev_err(scsi_cmd->device, "Aborting command: %02X\n", scsi_cmd->cmnd[0]);
+	scmd_printk(KERN_ERR, scsi_cmd, "Aborting command: %02X\n",
+		    scsi_cmd->cmnd[0]);
 	ipr_send_blocking_cmd(ipr_cmd, ipr_abort_timeout, IPR_CANCEL_ALL_TIMEOUT);
 	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
 
@@ -3792,8 +3793,8 @@ static void ipr_erp_done(struct ipr_cmnd
 
 	if (IPR_IOASC_SENSE_KEY(ioasc) > 0) {
 		scsi_cmd->result |= (DID_ERROR << 16);
-		ipr_sdev_err(scsi_cmd->device,
-			     "Request Sense failed with IOASC: 0x%08X\n", ioasc);
+		scmd_printk(KERN_ERR, scsi_cmd,
+			    "Request Sense failed with IOASC: 0x%08X\n", ioasc);
 	} else {
 		memcpy(scsi_cmd->sense_buffer, ipr_cmd->sense_buffer,
 		       SCSI_SENSE_BUFFERSIZE);
_
