From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 6/7] be2iscsi: Fixing memory allocation for connection
Date: Thu, 18 Feb 2010 07:21:10 +0530
Message-ID: <20100218015055.GA31224@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:35294 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752854Ab0BRBvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 20:51:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch fixes some situations where enough resources were not
avaialable  when targets exceeded a certain limit

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 drivers/scsi/be2iscsi/be_main.h |    4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b5dca45..5887d7a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -359,7 +359,7 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 				    + BE2_TMFS
 				    + BE2_NOPOUT_REQ));
 	phba->params.cxns_per_ctrl = phba->fw_config.iscsi_cid_count;
-	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count;;
+	phba->params.asyncpdus_per_ctrl = phba->fw_config.iscsi_cid_count * 2;
 	phba->params.icds_per_ctrl = phba->fw_config.iscsi_icd_count;;
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
@@ -2169,7 +2169,7 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 	num_cxn_wrb = (mem_descr_wrb->mem_array[idx].size) /
 		      ((sizeof(struct iscsi_wrb) *
 			phba->params.wrbs_per_cxn));
-	for (index = 0; index < phba->params.cxns_per_ctrl; index += 2) {
+	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
 		if (num_cxn_wrb) {
 			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index d4d31dc..87ec212 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -498,8 +498,6 @@ struct hwi_async_entry {
 	struct list_head data_busy_list;
 };
 
-#define BE_MIN_ASYNC_ENTRIES 128
-
 struct hwi_async_pdu_context {
 	struct {
 		struct be_bus_address pa_base;
@@ -540,7 +538,7 @@ struct hwi_async_pdu_context {
 	 * This is a varying size list! Do not add anything
 	 * after this entry!!
 	 */
-	struct hwi_async_entry async_entry[BE_MIN_ASYNC_ENTRIES];
+	struct hwi_async_entry async_entry[BE2_MAX_SESSIONS * 2];
 };
 
 #define PDUCQE_CODE_MASK	0x0000003F
-- 
1.6.4

