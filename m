From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 3/4] be2iscsi : Fix memory leak in the unload path
Date: Wed, 17 Dec 2014 08:04:23 +0530
Message-ID: <bbf55987-6abf-4ed9-a4de-9935f62f1e3e@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:25692 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPKIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2014 05:08:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Driver was not freeing the DMA memory allocated for EQ/CQ in the
 unload path. This patch frees the DMA memory during the driver unload.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2f2207a..409b13d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3748,8 +3748,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 
 	for (i = 0; i < (phba->num_cpus); i++) {
 		q = &phwi_context->be_cq[i];
-		if (q->created)
+		if (q->created) {
+			be_queue_free(phba, q);
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
+		}
 	}
 
 	be_mcc_queues_destroy(phba);
@@ -3759,8 +3761,10 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
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

