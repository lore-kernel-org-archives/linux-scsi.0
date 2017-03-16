From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 05/10] be2iscsi: Increase HDQ default queue size
Date: Thu, 16 Mar 2017 08:54:40 +0530
Message-ID: <1489634685-4975-6-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34458 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wr0-f180.google.com with SMTP id l37so23186574wrc.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:28 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Currently, ASYNC PDU default queue size is set to max connections.
This leaves only one buffer per connection for any ASYNC PDUs from
targets.

Double the size of the default queue.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 29 ++++++++++++++---------------
 drivers/scsi/be2iscsi/be_main.h |  4 +++-
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ff48573..b76fd26 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -636,7 +636,6 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 				    (total_cid_count +
 				     BE2_TMFS + BE2_NOPOUT_REQ));
 	phba->params.cxns_per_ctrl = total_cid_count;
-	phba->params.asyncpdus_per_ctrl = total_cid_count;
 	phba->params.icds_per_ctrl = total_icd_count;
 	phba->params.num_sge_per_io = BE2_SGE;
 	phba->params.defpdu_hdr_sz = BE2_DEFPDU_HDR_SZ;
@@ -2407,22 +2406,22 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
 			num_async_pdu_buf_sgl_pages =
-				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+				PAGES_REQUIRED(BEISCSI_ASYNC_HDQ_SIZE(
 					       phba, ulp_num) *
 					       sizeof(struct phys_addr));
 
 			num_async_pdu_buf_pages =
-				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+				PAGES_REQUIRED(BEISCSI_ASYNC_HDQ_SIZE(
 					       phba, ulp_num) *
 					       phba->params.defpdu_hdr_sz);
 
 			num_async_pdu_data_pages =
-				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+				PAGES_REQUIRED(BEISCSI_ASYNC_HDQ_SIZE(
 					       phba, ulp_num) *
 					       phba->params.defpdu_data_sz);
 
 			num_async_pdu_data_sgl_pages =
-				PAGES_REQUIRED(BEISCSI_GET_CID_COUNT(
+				PAGES_REQUIRED(BEISCSI_ASYNC_HDQ_SIZE(
 					       phba, ulp_num) *
 					       sizeof(struct phys_addr));
 
@@ -2459,21 +2458,21 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 			mem_descr_index = (HWI_MEM_ASYNC_HEADER_HANDLE_ULP0 +
 					  (ulp_num * MEM_DESCR_OFFSET));
 			phba->mem_req[mem_descr_index] =
-					  BEISCSI_GET_CID_COUNT(phba, ulp_num) *
-					  sizeof(struct hd_async_handle);
+				BEISCSI_ASYNC_HDQ_SIZE(phba, ulp_num) *
+				sizeof(struct hd_async_handle);
 
 			mem_descr_index = (HWI_MEM_ASYNC_DATA_HANDLE_ULP0 +
 					  (ulp_num * MEM_DESCR_OFFSET));
 			phba->mem_req[mem_descr_index] =
-					  BEISCSI_GET_CID_COUNT(phba, ulp_num) *
-					  sizeof(struct hd_async_handle);
+				BEISCSI_ASYNC_HDQ_SIZE(phba, ulp_num) *
+				sizeof(struct hd_async_handle);
 
 			mem_descr_index = (HWI_MEM_ASYNC_PDU_CONTEXT_ULP0 +
 					  (ulp_num * MEM_DESCR_OFFSET));
 			phba->mem_req[mem_descr_index] =
-					  sizeof(struct hd_async_context) +
-					 (BEISCSI_GET_CID_COUNT(phba, ulp_num) *
-					  sizeof(struct hd_async_entry));
+				sizeof(struct hd_async_context) +
+				(BEISCSI_ASYNC_HDQ_SIZE(phba, ulp_num) *
+				 sizeof(struct hd_async_entry));
 		}
 	}
 }
@@ -2757,7 +2756,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 					((long unsigned int)pasync_ctx +
 					sizeof(struct hd_async_context));
 
-			pasync_ctx->num_entries = BEISCSI_GET_CID_COUNT(phba,
+			pasync_ctx->num_entries = BEISCSI_ASYNC_HDQ_SIZE(phba,
 						  ulp_num);
 			/* setup header buffers */
 			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
@@ -2895,7 +2894,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 					phba->params.defpdu_data_sz);
 			num_per_mem = 0;
 
-			for (index = 0;	index < BEISCSI_GET_CID_COUNT
+			for (index = 0;	index < BEISCSI_ASYNC_HDQ_SIZE
 					(phba, ulp_num); index++) {
 				pasync_header_h->cri = -1;
 				pasync_header_h->is_header = 1;
@@ -3772,7 +3771,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 			def_pdu_ring_sz =
-				BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+				BEISCSI_ASYNC_HDQ_SIZE(phba, ulp_num) *
 				sizeof(struct phys_addr);
 
 			status = beiscsi_create_def_hdr(phba, phwi_context,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 2188579..216f9b4 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -235,7 +235,6 @@ struct sgl_handle {
 struct hba_parameters {
 	unsigned int ios_per_ctrl;
 	unsigned int cxns_per_ctrl;
-	unsigned int asyncpdus_per_ctrl;
 	unsigned int icds_per_ctrl;
 	unsigned int num_sge_per_io;
 	unsigned int defpdu_hdr_sz;
@@ -599,6 +598,9 @@ struct hd_async_handle {
 	u8 is_final;
 };
 
+#define BEISCSI_ASYNC_HDQ_SIZE(phba, ulp) \
+	(BEISCSI_GET_CID_COUNT((phba), (ulp)) * 2)
+
 /**
  * This has list of async PDUs that are waiting to be processed.
  * Buffers live in this list for a brief duration before they get
-- 
2.7.4
