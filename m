From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 1/7] Removing the iscsi_data_pdu setting.
Date: Mon, 13 Aug 2012 15:59:35 +0530
Message-ID: <881ee591-57a1-4fc9-a509-fda0d864c850@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:11013 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2HMKaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 06:30:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The setting of iscsi_data_pdu is not required anymore,
 as this was required for BE1 adapters only.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0b1d99c..2cdae08 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3981,15 +3981,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
 
 	if (writedir) {
-		memset(&io_task->cmd_bhs->iscsi_data_pdu, 0, 48);
-		AMAP_SET_BITS(struct amap_pdu_data_out, itt,
-			      &io_task->cmd_bhs->iscsi_data_pdu,
-			      (unsigned int)io_task->cmd_bhs->iscsi_hdr.itt);
-		AMAP_SET_BITS(struct amap_pdu_data_out, opcode,
-			      &io_task->cmd_bhs->iscsi_data_pdu,
-			      ISCSI_OPCODE_SCSI_DATA_OUT);
-		AMAP_SET_BITS(struct amap_pdu_data_out, final_bit,
-			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 			      INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
@@ -3998,9 +3989,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			      INI_RD_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 0);
 	}
-	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
-	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
-	       &io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, lun, pwrb,
 		      cpu_to_be16(*(unsigned short *)
-- 
1.7.1

