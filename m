From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 10/22] be2iscsi: Fix SGL Initilization and posting Pages for Dual Chute
Date: Thu, 12 Sep 2013 22:10:00 -0700
Message-ID: <1379049014-32716-10-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59447 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3IMFgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:35 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so2067177pab.11
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:34 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Initialization of SGL and related PAGE posting is to be done for the chute.
 Based on configuration value of each Chute,SGL initialization and page posting
 is done.

 For BE-X family iSCSI protocol is loaded only on Chute - 1.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1d4fcda..f061a2f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3460,6 +3460,10 @@ beiscsi_post_pages(struct beiscsi_hba *phba)
 	mem_descr += HWI_MEM_SGE;
 	pm_arr = mem_descr->mem_array;
 
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
+			break;
+
 	page_offset = (sizeof(struct iscsi_sge) * phba->params.num_sge_per_io *
 			phba->fw_config.iscsi_icd_start[ulp_num]) / PAGE_SIZE;
 	for (i = 0; i < mem_descr->num_elements; i++) {
@@ -3956,7 +3960,8 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 	struct be_mem_descriptor *mem_descr_sglh, *mem_descr_sg;
 	struct sgl_handle *psgl_handle;
 	struct iscsi_sge *pfrag;
-	unsigned int arr_index, i, idx, ulp_num = 0;
+	unsigned int arr_index, i, idx;
+	unsigned int ulp_icd_start, ulp_num = 0;
 
 	phba->io_sgl_hndl_avbl = 0;
 	phba->eh_sgl_hndl_avbl = 0;
@@ -4023,6 +4028,12 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 		    "\n BM_%d : mem_descr_sg->num_elements=%d\n",
 		    mem_descr_sg->num_elements);
 
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
+		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
+			break;
+
+	ulp_icd_start = phba->fw_config.iscsi_icd_start[ulp_num];
+
 	arr_index = 0;
 	idx = 0;
 	while (idx < mem_descr_sg->num_elements) {
@@ -4041,9 +4052,7 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 			AMAP_SET_BITS(struct amap_iscsi_sge, addr_hi, pfrag, 0);
 			AMAP_SET_BITS(struct amap_iscsi_sge, addr_lo, pfrag, 0);
 			pfrag += phba->params.num_sge_per_io;
-			psgl_handle->sgl_index =
-				phba->fw_config.iscsi_icd_start[ulp_num] +
-				arr_index++;
+			psgl_handle->sgl_index = ulp_icd_start + arr_index++;
 		}
 		idx++;
 	}
-- 
1.7.10.4

