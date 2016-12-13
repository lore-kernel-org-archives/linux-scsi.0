From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 06/13] be2iscsi: Fix iSCSI cmd cleanup IOCTL
Date: Tue, 13 Dec 2016 15:55:59 +0530
Message-ID: <1481624766-13846-7-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36348 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753086AbcLMK04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:26:56 -0500
Received: by mail-qt0-f173.google.com with SMTP id w33so102118152qtc.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:26:56 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Prepare the IOCTL with appropriate sizes of buffers of V0 and V1.
Set missing chute number in V1 IOCTL.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 33 ++++++++++++++++++---------------
 drivers/scsi/be2iscsi/be_main.c |  3 +--
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index be65da2..94aae45 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1700,31 +1700,34 @@ int beiscsi_cmd_iscsi_cleanup(struct beiscsi_hba *phba, unsigned short ulp)
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct iscsi_cleanup_req_v1 *req_v1;
 	struct iscsi_cleanup_req *req;
+	u16 hdr_ring_id, data_ring_id;
 	struct be_mcc_wrb *wrb;
 	int status;
 
 	mutex_lock(&ctrl->mbox_lock);
 	wrb = wrb_from_mbox(&ctrl->mbox_mem);
-	req = embedded_payload(wrb);
-	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
-	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
-			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
 
-       /**
-	* TODO: Check with FW folks the chute value to be set.
-	* For now, use the ULP_MASK as the chute value.
-	*/
+	hdr_ring_id = HWI_GET_DEF_HDRQ_ID(phba, ulp);
+	data_ring_id = HWI_GET_DEF_BUFQ_ID(phba, ulp);
 	if (is_chip_be2_be3r(phba)) {
+		req = embedded_payload(wrb);
+		be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+		be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+				   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
 		req->chute = (1 << ulp);
-		req->hdr_ring_id = HWI_GET_DEF_HDRQ_ID(phba, ulp);
-		req->data_ring_id = HWI_GET_DEF_BUFQ_ID(phba, ulp);
+		/* BE2/BE3 FW creates 8-bit ring id */
+		req->hdr_ring_id = hdr_ring_id;
+		req->data_ring_id = data_ring_id;
 	} else {
-		req_v1 = (struct iscsi_cleanup_req_v1 *)req;
+		req_v1 = embedded_payload(wrb);
+		be_wrb_hdr_prepare(wrb, sizeof(*req_v1), true, 0);
+		be_cmd_hdr_prepare(&req_v1->hdr, CMD_SUBSYSTEM_ISCSI,
+				   OPCODE_COMMON_ISCSI_CLEANUP,
+				   sizeof(*req_v1));
 		req_v1->hdr.version = 1;
-		req_v1->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba,
-								      ulp));
-		req_v1->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba,
-								       ulp));
+		req_v1->chute = (1 << ulp);
+		req_v1->hdr_ring_id = cpu_to_le16(hdr_ring_id);
+		req_v1->data_ring_id = cpu_to_le16(data_ring_id);
 	}
 
 	status = be_mbox_notify(ctrl);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 832d4f0..1b5a07f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2747,7 +2747,7 @@ static int hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
 
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++) {
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported)) {
-			 /* get async_ctx for each ULP */
+			/* get async_ctx for each ULP */
 			mem_descr = (struct be_mem_descriptor *)phba->init_mem;
 			mem_descr += (HWI_MEM_ASYNC_PDU_CONTEXT_ULP0 +
 				     (ulp_num * MEM_DESCR_OFFSET));
@@ -3814,7 +3814,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 			/**
 			 * Now that the default PDU rings have been created,
 			 * let EP know about it.
-			 * Call beiscsi_cmd_iscsi_cleanup before posting?
 			 */
 			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_HDR,
 						 ulp_num);
-- 
2.7.4

