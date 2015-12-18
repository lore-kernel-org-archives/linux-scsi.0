From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 08/15] megaraid_sas: Code optimization build_and_issue_cmd return-type
Date: Fri, 18 Dec 2015 18:57:01 +0530
Message-ID: <1450445228-26571-9-git-send-email-Sumit.Saxena@avagotech.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36399 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLRN2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:28:22 -0500
Received: by mail-pa0-f50.google.com with SMTP id q3so40570666pav.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:28:21 -0800 (PST)
In-Reply-To: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

build_and_issue_cmd should return SCSI_MLQUEUE_HOST_BUSY for few error case instead of returning 1.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    9 ++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a3b63fa..3454c5e 100644
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
index aca0cd3..9ad779d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2123,7 +2123,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	req_desc = megasas_get_request_descriptor(instance, index-1);
 	if (!req_desc)
-		return 1;
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	req_desc->Words = 0;
 	cmd->request_desc = req_desc;
@@ -2132,7 +2132,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		megasas_return_cmd_fusion(instance, cmd);
 		dev_err(&instance->pdev->dev, "Error building command\n");
 		cmd->request_desc = NULL;
-		return 1;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	req_desc = cmd->request_desc;
-- 
1.7.1

