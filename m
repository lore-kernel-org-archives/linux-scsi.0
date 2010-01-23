From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 8/8] be2iscsi: correction in the claculation for num_cxn_wrb
Date: Sat, 23 Jan 2010 05:39:37 +0530
Message-ID: <20100123000927.GA12701@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:40070 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753073Ab0AWAJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:09:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch correct the math done for num_cxn_wrb

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 932cb8a..687d535 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2042,10 +2042,9 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 	}
 	idx = 0;
 	pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
-	num_cxn_wrb =
-	    ((mem_descr_wrb->mem_array[idx].size) / (sizeof(struct iscsi_wrb)) *
-	     phba->params.wrbs_per_cxn);
-
+	num_cxn_wrb = (mem_descr_wrb->mem_array[idx].size) /
+		      ((sizeof(struct iscsi_wrb) *
+			phba->params.wrbs_per_cxn));
 	for (index = 0; index < phba->params.cxns_per_ctrl; index += 2) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
 		if (num_cxn_wrb) {
@@ -2058,9 +2057,9 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 		} else {
 			idx++;
 			pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
-			num_cxn_wrb = ((mem_descr_wrb->mem_array[idx].size) /
-					(sizeof(struct iscsi_wrb)) *
-					phba->params.wrbs_per_cxn);
+			num_cxn_wrb = (mem_descr_wrb->mem_array[idx].size) /
+				      ((sizeof(struct iscsi_wrb) *
+					phba->params.wrbs_per_cxn));
 			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
 				pwrb_handle = pwrb_context->pwrb_handle_base[j];
 				pwrb_handle->pwrb = pwrb;
-- 
1.6.4

