From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] megaraid_sas: add endianess conversions for all ones
Date: Sat, 10 Jan 2015 18:11:17 +0100
Message-ID: <1420909883-19479-5-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbbAJRMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:20 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Add noop conversions for all ones to make sparse happy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 7 ++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index cb7d0c4..a6556ea 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1232,7 +1232,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	*/
 	if (scp->device->type == TYPE_TAPE) {
 		if ((scp->request->timeout / HZ) > 0xFFFF)
-			pthru->timeout = 0xFFFF;
+			pthru->timeout = cpu_to_le16(0xFFFF);
 		else
 			pthru->timeout = cpu_to_le16(scp->request->timeout / HZ);
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index e9138a2..2001ffb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -769,7 +769,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	if (pd != MR_PD_INVALID)
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
 	else {
-		*pDevHandle = MR_PD_INVALID;
+		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
 			(!do_invader  || (do_invader &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
@@ -864,7 +864,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		/* Get dev handle from Pd. */
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
 	else {
-		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
+		/* set dev handle as invalid. */
+		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
 			(!do_invader  || (do_invader &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
@@ -1109,7 +1110,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 					ref_in_start_stripe, io_info,
 					pRAID_Context, map);
 		/* If IO on an invalid Pd, then FP is not possible.*/
-		if (io_info->devHandle == MR_PD_INVALID)
+		if (io_info->devHandle == cpu_to_le16(MR_PD_INVALID))
 			io_info->fpOkForIo = FALSE;
 		return retval;
 	} else if (isRead) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 983635f..82439f9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -464,7 +464,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 
 	io_frames_sz = fusion->io_frames_alloc_sz;
 
@@ -1995,7 +1995,8 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 	num_completed = 0;
 
-	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {
+	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
+	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
 		smid = le16_to_cpu(reply_desc->SMID);
 
 		cmd_fusion = fusion->cmd_list[smid - 1];
@@ -2063,7 +2064,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		    fusion->reply_q_depth)
 			fusion->last_reply_idx[MSIxIndex] = 0;
 
-		desc->Words = ULLONG_MAX;
+		desc->Words = cpu_to_le64(ULLONG_MAX);
 		num_completed++;
 		threshold_reply_count++;
 
@@ -2505,7 +2506,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0 ; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 }
 
 /* Check for a second path that is currently UP */
-- 
1.9.1

