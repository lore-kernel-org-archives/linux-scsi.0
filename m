From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] megaraid_sas: do not crash on invalid completion
Date: Fri, 11 Nov 2016 10:44:50 +0100
Message-ID: <1478857492-4581-4-git-send-email-hare@suse.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60657 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754300AbcKKJpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 04:45:05 -0500
In-Reply-To: <1478857492-4581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Avoid a kernel oops when receiving an invalid command completion.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 38137de..eb3cb0f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2298,13 +2298,15 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 			break;
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
-			device_id = MEGASAS_DEV_INDEX(scmd_local);
-			lbinfo = &fusion->load_balance_info[device_id];
-			if (cmd_fusion->scmd->SCp.Status &
-			    MEGASAS_LOAD_BALANCE_FLAG) {
-				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
-				cmd_fusion->scmd->SCp.Status &=
-					~MEGASAS_LOAD_BALANCE_FLAG;
+			if (scmd_local) {
+				device_id = MEGASAS_DEV_INDEX(scmd_local);
+				lbinfo = &fusion->load_balance_info[device_id];
+				if (cmd_fusion->scmd->SCp.Status &
+				    MEGASAS_LOAD_BALANCE_FLAG) {
+					atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
+					cmd_fusion->scmd->SCp.Status &=
+						~MEGASAS_LOAD_BALANCE_FLAG;
+				}
 			}
 			if (reply_descript_type ==
 			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
@@ -2315,6 +2317,12 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 			/* Fall thru and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
 			/* Map the FW Cmd Status */
+			if (!scmd_local) {
+				dev_err(&instance->pdev->dev,
+					"cmd[%d:%d] already completed\n",
+					MSIxIndex, smid);
+				break;
+			}
 			map_cmd_status(cmd_fusion, status, extStatus);
 			scsi_io_req->RaidContext.status = 0;
 			scsi_io_req->RaidContext.exStatus = 0;
-- 
1.8.5.6

