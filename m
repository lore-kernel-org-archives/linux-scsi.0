From: brking@us.ibm.com
Subject: [PATCH 1/6] ipr: Allow Query Resource State adapter command to scsi devices
Date: Tue, 14 Dec 2004 17:09:41 -0600
Message-ID: <200412142309.iBEN9gdQ003063@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54503 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261747AbULNXJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:09:46 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBEN9h8F032089
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:09:43 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBEN9hYQ261906
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:09:43 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBEN9gK4003068
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:09:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The ipr adapters support an adapter command directed at the device
resource called "Query Resource State". It can be used to retrieve
state information about the resource it is sent to, including the
currently negotiated scsi speed. The adapter interface requires the
IPR_RQTYPE_IOACMD to be set on this command, so we set it if the
command code matches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c |    3 ++-
 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_gscsi_allow_vendor_ioa_cmds drivers/scsi/ipr.c
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.c~ipr_gscsi_allow_vendor_ioa_cmds	2004-12-14 17:06:25.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c	2004-12-14 17:06:25.000000000 -0600
@@ -3904,7 +3904,8 @@ static int ipr_queuecommand(struct scsi_
 		ioarcb->cmd_pkt.flags_lo |= ipr_get_task_attributes(scsi_cmd);
 	}
 
-	if (!ipr_is_gscsi(res) && scsi_cmd->cmnd[0] >= 0xC0)
+	if (scsi_cmd->cmnd[0] >= 0xC0 &&
+	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE))
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 
 	if (ipr_is_ioa_resource(res) && scsi_cmd->cmnd[0] == MODE_SELECT)
diff -puN drivers/scsi/ipr.h~ipr_gscsi_allow_vendor_ioa_cmds drivers/scsi/ipr.h
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.h~ipr_gscsi_allow_vendor_ioa_cmds	2004-12-14 17:06:25.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h	2004-12-14 17:06:25.000000000 -0600
@@ -146,6 +146,7 @@
 /*
  * Adapter Commands
  */
+#define IPR_QUERY_RSRC_STATE				0xC2
 #define IPR_RESET_DEVICE				0xC3
 #define	IPR_RESET_TYPE_SELECT				0x80
 #define	IPR_LUN_RESET					0x40
_
