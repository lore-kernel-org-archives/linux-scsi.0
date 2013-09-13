From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 09/22] be2iscsi: Fix Template HDR support for Dual Chute mode
Date: Thu, 12 Sep 2013 22:09:59 -0700
Message-ID: <1379049014-32716-9-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46849 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3IMFgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:33 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so777342pbc.16
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:32 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Template HDR is created for each chute which has iSCSI Protocol loaded.

 For BE-X family iSCSI protocol is loaded only on Chute - 1.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   44 +++++++++++++++++++++++----------------
 drivers/scsi/be2iscsi/be_main.h |   13 ++++++------
 2 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a54fa4d..1d4fcda 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2549,8 +2549,6 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 		phba->params.icds_per_ctrl;
 	phba->mem_req[HWI_MEM_SGE] = sizeof(struct iscsi_sge) *
 		phba->params.num_sge_per_io * phba->params.icds_per_ctrl;
-	phba->mem_req[HWI_MEM_TEMPLATE_HDR] = phba->params.cxns_per_ctrl *
-					      BEISCSI_TEMPLATE_HDR_PER_CXN_SIZE;
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
 
@@ -2574,7 +2572,12 @@ static void beiscsi_find_mem_req(struct beiscsi_hba *phba)
 					       phba, ulp_num) *
 					       sizeof(struct phys_addr));
 
-
+			/* HWI_MEM_TEMPLATE_HDR */
+			mem_descr_index = (HWI_MEM_TEMPLATE_HDR_ULP0 +
+					  (ulp_num * MEM_DESCR_OFFSET));
+			phba->mem_req[mem_descr_index] =
+				BEISCSI_GET_CID_COUNT(phba, ulp_num) *
+				BEISCSI_TEMPLATE_HDR_PER_CXN_SIZE;
 			mem_descr_index = (HWI_MEM_ASYNC_HEADER_BUF_ULP0 +
 					  (ulp_num * MEM_DESCR_OFFSET));
 			phba->mem_req[mem_descr_index] =
@@ -3416,26 +3419,31 @@ beiscsi_post_template_hdr(struct beiscsi_hba *phba)
 	struct be_mem_descriptor *mem_descr;
 	struct mem_array *pm_arr;
 	struct be_dma_mem sgl;
-	int status, i;
+	int status, ulp_num;
 
-	mem_descr = phba->init_mem;
-	mem_descr += HWI_MEM_TEMPLATE_HDR;
-	pm_arr = mem_descr->mem_array;
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
+			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
+			mem_descr += HWI_MEM_TEMPLATE_HDR_ULP0 +
+				    (ulp_num * MEM_DESCR_OFFSET);
+			pm_arr = mem_descr->mem_array;
 
-	for (i = 0; i < mem_descr->num_elements; i++) {
-		hwi_build_be_sgl_arr(phba, pm_arr, &sgl);
-		status = be_cmd_iscsi_post_template_hdr(&phba->ctrl, &sgl);
+			hwi_build_be_sgl_arr(phba, pm_arr, &sgl);
+			status = be_cmd_iscsi_post_template_hdr(
+				 &phba->ctrl, &sgl);
 
-		if (status != 0) {
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Post Template HDR Failed\n");
-			return status;
+			if (status != 0) {
+				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+					    "BM_%d : Post Template HDR Failed for"
+					    "ULP_%d\n", ulp_num);
+				return status;
+			}
+
+			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+				    "BM_%d : Template HDR Pages Posted for"
+				    "ULP_%d\n", ulp_num);
 		}
 	}
-
-	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
-		    "BM_%d : Template HDR Pages Posted\n");
-
 	return 0;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index d0bbf37..bb96ba4 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -161,7 +161,7 @@
 
 #define BEISCSI_MSI_NAME 20 /* size of msi_name string */
 
-#define MEM_DESCR_OFFSET 7
+#define MEM_DESCR_OFFSET 8
 #define BEISCSI_DEFQ_HDR 1
 #define BEISCSI_DEFQ_DATA 0
 enum be_mem_enum {
@@ -170,20 +170,21 @@ enum be_mem_enum {
 	HWI_MEM_WRBH,
 	HWI_MEM_SGLH,
 	HWI_MEM_SGE,
-	HWI_MEM_TEMPLATE_HDR,
-	HWI_MEM_ASYNC_HEADER_BUF_ULP0,
+	HWI_MEM_TEMPLATE_HDR_ULP0,
+	HWI_MEM_ASYNC_HEADER_BUF_ULP0,	/* 6 */
 	HWI_MEM_ASYNC_DATA_BUF_ULP0,
 	HWI_MEM_ASYNC_HEADER_RING_ULP0,
 	HWI_MEM_ASYNC_DATA_RING_ULP0,
 	HWI_MEM_ASYNC_HEADER_HANDLE_ULP0,
-	HWI_MEM_ASYNC_DATA_HANDLE_ULP0,
+	HWI_MEM_ASYNC_DATA_HANDLE_ULP0,	/* 11 */
 	HWI_MEM_ASYNC_PDU_CONTEXT_ULP0,
-	HWI_MEM_ASYNC_HEADER_BUF_ULP1,
+	HWI_MEM_TEMPLATE_HDR_ULP1,
+	HWI_MEM_ASYNC_HEADER_BUF_ULP1,	/* 14 */
 	HWI_MEM_ASYNC_DATA_BUF_ULP1,
 	HWI_MEM_ASYNC_HEADER_RING_ULP1,
 	HWI_MEM_ASYNC_DATA_RING_ULP1,
 	HWI_MEM_ASYNC_HEADER_HANDLE_ULP1,
-	HWI_MEM_ASYNC_DATA_HANDLE_ULP1,
+	HWI_MEM_ASYNC_DATA_HANDLE_ULP1,	/* 19 */
 	HWI_MEM_ASYNC_PDU_CONTEXT_ULP1,
 	ISCSI_MEM_GLOBAL_HEADER,
 	SE_MEM_MAX
-- 
1.7.10.4

