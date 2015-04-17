From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 3/7] be2iscsi : Fix memory leak in the unload path
Date: Fri, 17 Apr 2015 15:02:01 +0530
Message-ID: <6a9fdbb8-ad2b-4108-9f32-45d30db72c8b@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:54678 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbbDPRG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:06:29 -0400
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

