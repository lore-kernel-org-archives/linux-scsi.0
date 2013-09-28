From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 22/23] be2iscsi: Fix SGL posting for unaligned ICD values
Date: Sat, 28 Sep 2013 15:35:59 -0700
Message-ID: <1380407761-2949-22-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57070 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3I1Wgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:55 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so4000964pdj.7
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:54 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 If certain configuration it is possible that ICD range is not page-aligned.
 SGL posting failed in these configuration and driver load was not success.
 This fix aligns ICD range values and SGL posting for IO is done.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   53 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/be2iscsi/be_mgmt.c |   10 ++++++--
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d84ecc5..1f37505 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -729,13 +729,60 @@ static void beiscsi_get_params(struct beiscsi_hba *phba)
 	total_cid_count = BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP0) +
 			  BEISCSI_GET_CID_COUNT(phba, BEISCSI_ULP1);
 
-	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		uint32_t align_mask = 0;
+		uint32_t icd_post_per_page = 0;
+		uint32_t icd_count_unavailable = 0;
+		uint32_t icd_start = 0, icd_count = 0;
+		uint32_t icd_start_align = 0, icd_count_align = 0;
+
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
-			total_icd_count = phba->fw_config.
-					  iscsi_icd_count[ulp_num];
+			icd_start = phba->fw_config.iscsi_icd_start[ulp_num];
+			icd_count = phba->fw_config.iscsi_icd_count[ulp_num];
+
+			/* Get ICD count that can be posted on each page */
+			icd_post_per_page = (PAGE_SIZE / (BE2_SGE *
+					     sizeof(struct iscsi_sge)));
+			align_mask = (icd_post_per_page - 1);
+
+			/* Check if icd_start is aligned ICD per page posting */
+			if (icd_start % icd_post_per_page) {
+				icd_start_align = ((icd_start +
+						    icd_post_per_page) &
+						    ~(align_mask));
+				phba->fw_config.
+					iscsi_icd_start[ulp_num] =
+					icd_start_align;
+			}
+
+			icd_count_align = (icd_count & ~align_mask);
+
+			/* ICD discarded in the process of alignment */
+			if (icd_start_align)
+				icd_count_unavailable = ((icd_start_align -
+							  icd_start) +
+							 (icd_count -
+							  icd_count_align));
+
+			/* Updated ICD count available */
+			phba->fw_config.iscsi_icd_count[ulp_num] = (icd_count -
+					icd_count_unavailable);
+
+			beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
+					"BM_%d : Aligned ICD values\n"
+					"\t ICD Start : %d\n"
+					"\t ICD Count : %d\n"
+					"\t ICD Discarded : %d\n",
+					phba->fw_config.
+					iscsi_icd_start[ulp_num],
+					phba->fw_config.
+					iscsi_icd_count[ulp_num],
+					icd_count_unavailable);
 			break;
 		}
+	}
 
+	total_icd_count = phba->fw_config.iscsi_icd_count[ulp_num];
 	phba->params.ios_per_ctrl = (total_icd_count -
 				    (total_cid_count +
 				     BE2_TMFS + BE2_NOPOUT_REQ));
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 1f2b546..b2fcac7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -350,12 +350,18 @@ int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
 					    "BG_%d : Function loaded on ULP : %d\n"
 					    "\tiscsi_cid_count : %d\n"
-					    "\t iscsi_icd_count : %d\n",
+					    "\tiscsi_cid_start : %d\n"
+					    "\t iscsi_icd_count : %d\n"
+					    "\t iscsi_icd_start : %d\n",
 					    ulp_num,
 					    phba->fw_config.
 					    iscsi_cid_count[ulp_num],
 					    phba->fw_config.
-					    iscsi_icd_count[ulp_num]);
+					    iscsi_cid_start[ulp_num],
+					    phba->fw_config.
+					    iscsi_icd_count[ulp_num],
+					    phba->fw_config.
+					    iscsi_icd_start[ulp_num]);
 			}
 		}
 
-- 
1.7.10.4

