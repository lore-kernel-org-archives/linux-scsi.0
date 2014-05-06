From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 6/8] be2iscsi: Fix destroy MCC-CQ before MCC-EQ is destroyed
Date: Mon,  5 May 2014 21:41:29 -0400
Message-ID: <1399340492-2136-6-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44552 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:41:54 -0400
Received: by mail-pd0-f173.google.com with SMTP id y10so5043281pdj.4
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:41:54 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 EQ teardown should happen only after all CQ are destroyed.
 In some FW config, adapter goes into a freeze state. This
 fix moves teardown of MCC-Q before the EQ teardown happens.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e8bba90..dccda6c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3685,7 +3685,7 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct hwi_async_pdu_context *pasync_ctx;
-	int i, eq_num, ulp_num;
+	int i, eq_for_mcc, ulp_num;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -3722,16 +3722,17 @@ static void hwi_cleanup(struct beiscsi_hba *phba)
 		if (q->created)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_CQ);
 	}
+
+	be_mcc_queues_destroy(phba);
 	if (phba->msix_enabled)
-		eq_num = 1;
+		eq_for_mcc = 1;
 	else
-		eq_num = 0;
-	for (i = 0; i < (phba->num_cpus + eq_num); i++) {
+		eq_for_mcc = 0;
+	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
 		q = &phwi_context->be_eq[i].q;
 		if (q->created)
 			beiscsi_cmd_q_destroy(ctrl, q, QTYPE_EQ);
 	}
-	be_mcc_queues_destroy(phba);
 	be_cmd_fw_uninit(ctrl);
 }
 
-- 
1.8.5.3

