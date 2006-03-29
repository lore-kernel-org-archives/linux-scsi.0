From: Brian King <brking@us.ibm.com>
Subject: [PATCH 5/6] ipr: Reset device cleanup
Date: Wed, 29 Mar 2006 09:37:43 -0600
Message-ID: <200603291537.k2TFbig8017788@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:41432 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751183AbWC2Php
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:37:45 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2TFbjwO007470
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:45 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2TFYY6L271122
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 08:34:34 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2TFbiFR017820
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 08:37:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Encapsulate some more of the device reset processing in
preparation for SATA support.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |   58 ++++++++++++++++++++++++----------
 1 files changed, 41 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dev_reset_cleanup drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_dev_reset_cleanup	2006-03-22 11:28:42.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-03-22 12:52:30.000000000 -0600
@@ -3281,6 +3281,44 @@ static int ipr_eh_host_reset(struct scsi
 }
 
 /**
+ * ipr_device_reset - Reset the device
+ * @ioa_cfg:	ioa config struct
+ * @res:		resource entry struct
+ *
+ * This function issues a device reset to the affected device.
+ * If the device is a SCSI device, a LUN reset will be sent
+ * to the device first. If that does not work, a target reset
+ * will be sent.
+ *
+ * Return value:
+ *	0 on success / non-zero on failure
+ **/
+static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
+			    struct ipr_resource_entry *res)
+{
+	struct ipr_cmnd *ipr_cmd;
+	struct ipr_ioarcb *ioarcb;
+	struct ipr_cmd_pkt *cmd_pkt;
+	u32 ioasc;
+
+	ENTER;
+	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
+	ioarcb = &ipr_cmd->ioarcb;
+	cmd_pkt = &ioarcb->cmd_pkt;
+
+	ioarcb->res_handle = res->cfgte.res_handle;
+	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
+	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
+
+	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
+	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+
+	LEAVE;
+	return (IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0);
+}
+
+/**
  * ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
  *
@@ -3296,8 +3334,7 @@ static int __ipr_eh_dev_reset(struct scs
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ipr_cmd_pkt *cmd_pkt;
-	u32 ioasc;
+	int rc;
 
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
@@ -3324,25 +3361,12 @@ static int __ipr_eh_dev_reset(struct scs
 	}
 
 	res->resetting_device = 1;
-
-	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
-
-	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
-	cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
-	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
-	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
-
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
-	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
-
-	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
-
+	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
 
-	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
-
 	LEAVE;
-	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
+	return (rc ? FAILED : SUCCESS);
 }
 
 static int ipr_eh_dev_reset(struct scsi_cmnd * cmd)
_
