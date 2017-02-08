From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 08/39] megaraid_sas: megasas_get_request_descriptor always return valid desc
Date: Wed,  8 Feb 2017 01:29:02 -0800
Message-ID: <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33880 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754098AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pf0-f180.google.com with SMTP id e4so40970005pfg.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:19 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

fix in v2 - split patches into two. 
discussed below 
http://marc.info/?l=linux-scsi&m=148638999110404&w=2

No functional change. Code clean up. Removing error code which is not
valid scenario.
In megasas_get_request_descriptor we can remove the error handling
which is not required.
With fusion controllers, if there is a valid message frame available,
we are guaranteed to get a corresponding request descriptor.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6ec7a18..b6c5dc5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2438,18 +2438,12 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	return 0;
 }
 
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 {
 	u8 *p;
 	struct fusion_context *fusion;
 
-	if (index >= instance->max_mpt_cmds) {
-		dev_err(&instance->pdev->dev, "Invalid SMID (0x%x)request for "
-		       "descriptor for scsi%d\n", index,
-			instance->host->host_no);
-		return NULL;
-	}
 	fusion = instance->ctrl_context;
 	p = fusion->req_frames_desc +
 		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) * index;
@@ -2960,7 +2954,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
-	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc = NULL;
 	u16 index;
 
 	if (build_mpt_mfi_pass_thru(instance, cmd)) {
@@ -2972,9 +2966,6 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 
 	req_desc = megasas_get_request_descriptor(instance, index - 1);
 
-	if (!req_desc)
-		return NULL;
-
 	req_desc->Words = 0;
 	req_desc->SCSIIO.RequestFlags = (MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
 					 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
@@ -2997,11 +2988,6 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 
 	req_desc = build_mpt_cmd(instance, cmd);
-	if (!req_desc) {
-		dev_info(&instance->pdev->dev, "Failed from %s %d\n",
-					__func__, __LINE__);
-		return DCMD_NOT_FIRED;
-	}
 
 	megasas_fire_cmd_fusion(instance, req_desc);
 	return DCMD_SUCCESS;
@@ -3438,12 +3424,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 
 	req_desc = megasas_get_request_descriptor(instance,
 			(cmd_fusion->index - 1));
-	if (!req_desc) {
-		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
-			__func__, __LINE__);
-		megasas_return_cmd(instance, cmd_mfi);
-		return -ENOMEM;
-	}
 
 	cmd_fusion->request_desc = req_desc;
 	req_desc->Words = 0;
-- 
2.8.3
