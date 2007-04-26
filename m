From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/8] ipr: Handle IOA reset request
Date: Thu, 26 Apr 2007 16:00:12 -0500
Message-ID: <200704262101.l3QL1NZo004413@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40270 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbXDZVBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 17:01:25 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL1OIc026447
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:24 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1OQL528996
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:24 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1OVS004438
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


In ipr dual adapter configurations, the ipr adapter firmware
may require an adapter reset for various reasons. The reset
is requested by the adapter firmware logging an error with
an IOASC of 0x02048000. Add support to log this error, and
reset the adapter.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   14 ++++++++++++--
 drivers/scsi/ipr.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_reset_request drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_reset_request	2007-04-26 09:17:46.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-04-26 09:17:46.000000000 -0500
@@ -91,6 +91,7 @@
  * IOASCs
  */
 #define IPR_IOASC_NR_INIT_CMD_REQUIRED		0x02040200
+#define IPR_IOASC_NR_IOA_RESET_REQUIRED		0x02048000
 #define IPR_IOASC_SYNC_REQUIRED			0x023f0000
 #define IPR_IOASC_MED_DO_NOT_REALLOC		0x03110C00
 #define IPR_IOASC_HW_SEL_TIMEOUT			0x04050000
diff -puN drivers/scsi/ipr.c~ipr_reset_request drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_reset_request	2007-04-26 09:17:46.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:17:46.000000000 -0500
@@ -206,6 +206,8 @@ struct ipr_error_table_t ipr_error_table
 	"8009: Impending cache battery pack failure"},
 	{0x02040400, 0, 0,
 	"34FF: Disk device format in progress"},
+	{0x02048000, 0, IPR_DEFAULT_LOG_LEVEL,
+	"9070: IOA requested reset"},
 	{0x023F0000, 0, 0,
 	"Synchronization required"},
 	{0x024E0000, 0, 0,
@@ -1672,12 +1674,15 @@ static void ipr_process_error(struct ipr
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+	u32 fd_ioasc = be32_to_cpu(hostrcb->hcam.u.error.failing_dev_ioasc);
 
 	list_del(&hostrcb->queue);
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 
 	if (!ioasc) {
 		ipr_handle_log_data(ioa_cfg, hostrcb);
+		if (fd_ioasc == IPR_IOASC_NR_IOA_RESET_REQUIRED)
+			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
 	} else if (ioasc != IPR_IOASC_IOA_WAS_RESET) {
 		dev_err(&ioa_cfg->pdev->dev,
 			"Host RCB failed with IOASC: 0x%08X\n", ioasc);
@@ -6296,6 +6301,7 @@ static void ipr_get_unit_check_buffer(st
 	struct ipr_hostrcb *hostrcb;
 	struct ipr_uc_sdt sdt;
 	int rc, length;
+	u32 ioasc;
 
 	mailbox = readl(ioa_cfg->ioa_mailbox);
 
@@ -6328,9 +6334,13 @@ static void ipr_get_unit_check_buffer(st
 					(__be32 *)&hostrcb->hcam,
 					min(length, (int)sizeof(hostrcb->hcam)) / sizeof(__be32));
 
-	if (!rc)
+	if (!rc) {
 		ipr_handle_log_data(ioa_cfg, hostrcb);
-	else
+		ioasc = be32_to_cpu(hostrcb->hcam.u.error.failing_dev_ioasc);
+		if (ioasc == IPR_IOASC_NR_IOA_RESET_REQUIRED &&
+		    ioa_cfg->sdt_state == GET_DUMP)
+			ioa_cfg->sdt_state = WAIT_FOR_DUMP;
+	} else
 		ipr_unit_check_no_data(ioa_cfg);
 
 	list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_free_q);
_
