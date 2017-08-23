From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 08/14] megaraid_sas: Use SMID for Task abort case only
Date: Wed, 23 Aug 2017 04:47:02 -0700
Message-ID: <1503488828-2242-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36558 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753919AbdHWLry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:54 -0400
Received: by mail-pf0-f179.google.com with SMTP id c28so5740804pfe.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:54 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix - In TM code, smid_task is valid only in case of task aborts.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6efa72a..6da1663 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3760,7 +3760,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct megasas_cmd *cmd_mfi;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	struct fusion_context *fusion;
+	struct fusion_context *fusion = NULL;
 	struct megasas_cmd_fusion *scsi_lookup;
 	int rc;
 	struct MPI2_SCSI_TASK_MANAGE_REPLY *mpi_reply;
@@ -3787,8 +3787,6 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 	cmd_fusion->request_desc = req_desc;
 	req_desc->Words = 0;
 
-	scsi_lookup = fusion->cmd_list[smid_task - 1];
-
 	mr_request = (struct MR_TASK_MANAGE_REQUEST *) cmd_fusion->io_request;
 	memset(mr_request, 0, sizeof(struct MR_TASK_MANAGE_REQUEST));
 	mpi_request = (struct MPI2_SCSI_TASK_MANAGE_REQUEST *) &mr_request->TmRequest;
@@ -3835,6 +3833,8 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 	rc = SUCCESS;
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
+		scsi_lookup = fusion->cmd_list[smid_task - 1];
+
 		if (scsi_lookup->scmd == NULL)
 			break;
 		else {
-- 
1.8.3.1
