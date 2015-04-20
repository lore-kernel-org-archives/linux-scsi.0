From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 13/18] megaraid_sas : add endianess conversions for all ones
Date: Mon, 20 Apr 2015 18:04:30 +0530
Message-ID: <201504201236.t3KCagKv016670@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:53600
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751843AbbDTNM1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 09:12:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Add noop conversions for all ones to make sparse happy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    7 ++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 +++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9467b05..cb34b48 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1225,7 +1225,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
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
index 42d9c2e..7d34fe8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -433,7 +433,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 
 	io_frames_sz = fusion->io_frames_alloc_sz;
 
@@ -2030,7 +2030,8 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 	num_completed = 0;
 
-	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {
+	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
+	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
 		smid = le16_to_cpu(reply_desc->SMID);
 
 		cmd_fusion = fusion->cmd_list[smid - 1];
@@ -2094,7 +2095,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		    fusion->reply_q_depth)
 			fusion->last_reply_idx[MSIxIndex] = 0;
 
-		desc->Words = ULLONG_MAX;
+		desc->Words = cpu_to_le64(ULLONG_MAX);
 		num_completed++;
 		threshold_reply_count++;
 
@@ -2531,7 +2532,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0 ; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 }
 
 /*
-- 
1.7.1

