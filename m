From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/5] ipr add error logs to abort and reset paths
Date: Sat, 22 May 2004 19:49:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40AFF532.1040306@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090601060209060203040403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:54722 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262008AbUEWAt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 20:49:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090601060209060203040403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------090601060209060203040403
Content-Type: text/plain;
 name="ipr_eh_elog_fixes-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_eh_elog_fixes-2.patch"


This patch adds additional error logging to abort, device reset,
and bus reset paths to help in diagnosing scsi problems on ipr.


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.c |    4 ++++
 linux-2.6.6-bjking1/drivers/scsi/ipr.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_eh_elog_fixes drivers/scsi/ipr.c
--- linux-2.6.6/drivers/scsi/ipr.c~ipr_eh_elog_fixes	2004-05-22 14:43:51.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.c	2004-05-22 14:49:38.000000000 -0500
@@ -2972,6 +2972,7 @@ static int ipr_eh_dev_reset(struct scsi_
 	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
 	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
 
+	ipr_sdev_err(scsi_cmd->device, "Resetting device\n");
 	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
 
 	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
@@ -3045,6 +3046,7 @@ static void ipr_abort_timeout(struct ipr
 		return;
 	}
 
+	ipr_sdev_err(ipr_cmd->sdev, "Abort timed out. Resetting bus\n");
 	reset_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ipr_cmd->sibling = reset_cmd;
 	reset_cmd->sibling = ipr_cmd;
@@ -3106,7 +3108,9 @@ static int ipr_cancel_op(struct scsi_cmn
 	cmd_pkt->cdb[3] = (ioarcb_addr >> 16) & 0xff;
 	cmd_pkt->cdb[4] = (ioarcb_addr >> 8) & 0xff;
 	cmd_pkt->cdb[5] = ioarcb_addr & 0xff;
+	ipr_cmd->sdev = scsi_cmd->device;
 
+	ipr_sdev_err(scsi_cmd->device, "Aborting command: %02X\n", scsi_cmd->cmnd[0]);
 	ipr_send_blocking_cmd(ipr_cmd, ipr_abort_timeout, IPR_ABORT_TASK_TIMEOUT);
 	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
 
diff -puN drivers/scsi/ipr.h~ipr_eh_elog_fixes drivers/scsi/ipr.h
--- linux-2.6.6/drivers/scsi/ipr.h~ipr_eh_elog_fixes	2004-05-22 14:43:51.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.h	2004-05-22 14:49:07.000000000 -0500
@@ -939,6 +939,7 @@ struct ipr_cmnd {
 		unsigned long scratch;
 		struct ipr_resource_entry *res;
 		struct ipr_cmnd *sibling;
+		struct scsi_device *sdev;
 	};
 
 	struct ipr_ioa_cfg *ioa_cfg;

_

--------------090601060209060203040403--

