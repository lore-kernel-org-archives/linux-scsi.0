From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 1/7] be2iscsi: Removing the iscsi_data_pdu setting.
Date: Mon, 20 Aug 2012 22:59:58 +0530
Message-ID: <61826075-2f29-42b3-b080-35e21690bdd6@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21645 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2HTRa6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 13:30:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The setting of iscsi_data_pdu is not required anymore,
 as this was required for BE1 adapters only. The BE1 adapter
 were not supported in any previous versions of the kernel.

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

