From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 14/23] be2iscsi: Fix chute cleanup during drivers unload.
Date: Sat, 28 Sep 2013 15:35:51 -0700
Message-ID: <1380407761-2949-14-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41725 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3I1Wgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:39 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so4271508pad.9
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:39 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 This patch cleans up both chutes on unload

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   14 ++++++++++----
 drivers/scsi/be2iscsi/be_mgmt.c |   17 +++++++++++++----
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d539b17..b323569 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4433,10 +4433,16 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 	int mgmt_status, ulp_num;
 	struct ulp_cid_info *ptr_cid_info = NULL;
 
-	mgmt_status = mgmt_epfw_cleanup(phba, CMD_CONNECTION_CHUTE_0);
-	if (mgmt_status)
-		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
-			    "BM_%d : mgmt_epfw_cleanup FAILED\n");
+	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
+		if (test_bit(ulp_num, (void *)&phba->fw_config.ulp_supported)) {
+			mgmt_status = mgmt_epfw_cleanup(phba, ulp_num);
+			if (mgmt_status)
+				beiscsi_log(phba, KERN_WARNING,
+					    BEISCSI_LOG_INIT,
+					    "BM_%d : mgmt_epfw_cleanup FAILED"
+					    " for ULP_%d\n", ulp_num);
+		}
+	}
 
 	hwi_purge_eq(phba);
 	hwi_cleanup(phba);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index bcddc9f..a542bbb 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -491,7 +491,16 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 	return tag;
 }
 
-int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
+/**
+ * mgmt_epfw_cleanup()- Inform FW to cleanup data structures.
+ * @phba: pointer to dev priv structure
+ * @ulp_num: ULP number.
+ *
+ * return
+ *	Success: 0
+ *	Failure: Non-Zero Value
+ **/
+int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short ulp_num)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
@@ -505,9 +514,9 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
 
-	req->chute = chute;
-	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, 0));
-	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba, 0));
+	req->chute = (1 << ulp_num);
+	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, ulp_num));
+	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba, ulp_num));
 
 	status =  be_mcc_notify_wait(phba);
 	if (status)
-- 
1.7.10.4

