From: brking@us.ibm.com
Subject: [PATCH 14/16] ipr: Use cancel all instead of abort task
Date: Wed, 04 Aug 2004 17:33:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042234.i74MYCCu136894@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:22992 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267481AbUHDWdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:33:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Currently, ABORT_TASK does not work properly on ipr adapters. It results in
timeouts and eh ends up getting escalated to eh_host_reset to recover.
The adapters are supposed to be fixed to properly handle this at some
point in the future, but until that updated microcode is available,
we need to send a cancel all to the device instead.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |   12 +++---------
 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |    1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_eh_abort_cancel_all drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_eh_abort_cancel_all	2004-08-04 17:17:40.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:40.000000000 -0500
@@ -3077,7 +3077,7 @@ static int ipr_cancel_op(struct scsi_cmn
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	struct ipr_cmd_pkt *cmd_pkt;
-	u32 ioasc, ioarcb_addr;
+	u32 ioasc;
 	int op_found = 0;
 
 	ENTER;
@@ -3098,21 +3098,15 @@ static int ipr_cancel_op(struct scsi_cmn
 	if (!op_found)
 		return SUCCESS;
 
-	ioarcb_addr = be32_to_cpu(ipr_cmd->ioarcb.ioarcb_host_pci_addr);
-
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ipr_cmd->ioarcb.res_handle = res->cfgte.res_handle;
 	cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
 	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
-	cmd_pkt->cdb[0] = IPR_ABORT_TASK;
-	cmd_pkt->cdb[2] = (ioarcb_addr >> 24) & 0xff;
-	cmd_pkt->cdb[3] = (ioarcb_addr >> 16) & 0xff;
-	cmd_pkt->cdb[4] = (ioarcb_addr >> 8) & 0xff;
-	cmd_pkt->cdb[5] = ioarcb_addr & 0xff;
+	cmd_pkt->cdb[0] = IPR_CANCEL_ALL_REQUESTS;
 	ipr_cmd->u.sdev = scsi_cmd->device;
 
 	ipr_sdev_err(scsi_cmd->device, "Aborting command: %02X\n", scsi_cmd->cmnd[0]);
-	ipr_send_blocking_cmd(ipr_cmd, ipr_abort_timeout, IPR_ABORT_TASK_TIMEOUT);
+	ipr_send_blocking_cmd(ipr_cmd, ipr_abort_timeout, IPR_CANCEL_ALL_TIMEOUT);
 	ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
 
 	/*
diff -puN drivers/scsi/ipr.h~ipr_eh_abort_cancel_all drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_eh_abort_cancel_all	2004-08-04 17:17:40.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:40.000000000 -0500
@@ -153,7 +153,6 @@
 #define	IPR_BUS_RESET					0x10
 #define IPR_ID_HOST_RR_Q				0xC4
 #define IPR_QUERY_IOA_CONFIG				0xC5
-#define IPR_ABORT_TASK					0xC7
 #define IPR_CANCEL_ALL_REQUESTS			0xCE
 #define IPR_HOST_CONTROLLED_ASYNC			0xCF
 #define	IPR_HCAM_CDB_OP_CODE_CONFIG_CHANGE	0x01
_
