From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 08/15] megaraid_sas: Code optimization build_and_issue_cmd return-type
Date: Thu, 28 Jan 2016 21:04:29 +0530
Message-ID: <1453995276-24955-9-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34410 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967035AbcA1Pfi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:35:38 -0500
Received: by mail-pa0-f44.google.com with SMTP id uo6so25317136pac.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:35:38 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

build_and_issue_cmd should return SCSI_MLQUEUE_HOST_BUSY for few error case instead of returning 1.

There are no changes in this patch from last time sent patch.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 9 ++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8df58c2..edf8911 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1636,7 +1636,7 @@ megasas_build_and_issue_cmd(struct megasas_instance *instance,
 	return 0;
 out_return_cmd:
 	megasas_return_cmd(instance, cmd);
-	return 1;
+	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 
@@ -1728,12 +1728,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		break;
 	}
 
-	if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
-		dev_err(&instance->pdev->dev, "Err returned from build_and_issue_cmd\n");
-		return SCSI_MLQUEUE_HOST_BUSY;
-	}
-
-	return 0;
+	return instance->instancet->build_and_issue_cmd(instance, scmd);
 
  out_done:
 	scmd->scsi_done(scmd);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 1351cae..f553830 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2125,7 +2125,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	req_desc = megasas_get_request_descriptor(instance, index-1);
 	if (!req_desc)
-		return 1;
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	req_desc->Words = 0;
 	cmd->request_desc = req_desc;
@@ -2134,7 +2134,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		megasas_return_cmd_fusion(instance, cmd);
 		dev_err(&instance->pdev->dev, "Error building command\n");
 		cmd->request_desc = NULL;
-		return 1;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	req_desc = cmd->request_desc;
-- 
1.8.3.1

