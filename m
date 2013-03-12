From: jayamohank@gmail.com
Subject: [PATCH 02/15] be2iscsi: Fix returning Failure when MBX fails with Insufficient buffer error
Date: Mon, 11 Mar 2013 21:39:32 -0700
Message-ID: <1363063186-4902-2-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:59779 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3CLEkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:00 -0400
Received: by mail-da0-f52.google.com with SMTP id f10so1106917dak.11
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:39:59 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

 When MBX command fails with insufficent buffer, check for the
 response lenght returned. Return success if response length
 is non-zero value which indicates valid data.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   13 +++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h |    4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 0b44cc9..3ad95c7 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -155,6 +155,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 	uint16_t status = 0, addl_status = 0, wrb_num = 0;
 	struct be_mcc_wrb *temp_wrb;
 	struct be_cmd_req_hdr *ioctl_hdr;
+	struct be_cmd_resp_hdr *ioctl_resp_hdr;
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 
 	if (beiscsi_error(phba))
@@ -204,6 +205,12 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 			    ioctl_hdr->subsystem,
 			    ioctl_hdr->opcode,
 			    status, addl_status);
+
+		if (status == MCC_STATUS_INSUFFICIENT_BUFFER) {
+			ioctl_resp_hdr = (struct be_cmd_resp_hdr *) ioctl_hdr;
+			if (ioctl_resp_hdr->response_length)
+				goto release_mcc_tag;
+		}
 		rc = -EAGAIN;
 	}
 
@@ -267,6 +274,7 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	struct be_cmd_req_hdr *hdr = embedded_payload(wrb);
+	struct be_cmd_resp_hdr *resp_hdr;
 
 	be_dws_le_to_cpu(compl, 4);
 
@@ -284,6 +292,11 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 			    hdr->subsystem, hdr->opcode,
 			    compl_status, extd_status);
 
+		if (compl_status == MCC_STATUS_INSUFFICIENT_BUFFER) {
+			resp_hdr = (struct be_cmd_resp_hdr *) hdr;
+			if (resp_hdr->response_length)
+				return 0;
+		}
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 0f8c920..a338625 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -52,6 +52,10 @@ struct be_mcc_wrb {
 
 /* Completion Status */
 #define MCC_STATUS_SUCCESS 0x0
+#define MCC_STATUS_FAILED 0x1
+#define MCC_STATUS_ILLEGAL_REQUEST 0x2
+#define MCC_STATUS_ILLEGAL_FIELD 0x3
+#define MCC_STATUS_INSUFFICIENT_BUFFER 0x4
 
 #define CQE_STATUS_COMPL_MASK 0xFFFF
 #define CQE_STATUS_COMPL_SHIFT 0	/* bits 0 - 15 */
-- 
1.7.10.4

