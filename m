From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 3/7] be2iscsi : Fix memory leak in the unload path
Date: Sat, 25 Apr 2015 08:17:31 +0530
Message-ID: <33e07b3d-90d3-4f8c-bda8-f6dfcf5e701b@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:6788 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbDXKVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 06:21:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Driver was not freeing the DMA memory allocated for EQ/CQ in the
 unload path. This patch frees the DMA memory during the driver unload.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 4d95596..dca3a55 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3695,14 +3695,16 @@ static void be_mcc_queues_destroy(struct beiscsi_hba *phba)
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 
 	q = &phba->ctrl.mcc_obj.q;
-	if (q->created)
+	if (q->created) {
 		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_MCCQ);
-	be_queue_free(phba, q);
+		be_queue_free(phba, q);
+	}
 
 	q = &phba->ctrl.mcc_obj.cq;
-	if (q->created)
+	if (q->created) {
 		beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
-	be_queue_free(phba, q);
+		be_queue_free(phba, q);
+	}
 }
 
 static void hwi_cleanup(struct beiscsi_hba *phba)
@@ -3746,8 +3748,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 
 	for (i = 0; i < (phba->num_cpus); i++) {
 		q = &phwi_context->be_cq[i];
-		if (q->created)
+		if (q->created) {
+			be_queue_free(phba, q);
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+		}
 	}
 
 	be_mcc_queues_destroy(phba);
@@ -3757,8 +3761,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 		eq_for_mcc = 0;
 	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
 		q = &phwi_context->be_eq[i].q;
-		if (q->created)
+		if (q->created) {
+			be_queue_free(phba, q);
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
+		}
 	}
 	be_cmd_fw_uninit(ctrl);
 }
-- 
1.7.1

