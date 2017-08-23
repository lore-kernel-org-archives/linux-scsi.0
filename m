From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 12/14] megaraid_sas: modified few prints in OCR and IOC INIT path
Date: Wed, 23 Aug 2017 04:47:06 -0700
Message-ID: <1503488828-2242-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:38452 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753929AbdHWLsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:48:07 -0400
Received: by mail-pg0-f54.google.com with SMTP id m133so6210888pga.5
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:48:07 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bd89962..11bd2e6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -916,7 +916,6 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	dev_info(&instance->pdev->dev, "Init cmd success\n");
 
 	ret = 0;
 
@@ -927,6 +926,10 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 				  sizeof(struct MPI2_IOC_INIT_REQUEST),
 				  IOCInitMessage, ioc_init_handle);
 fail_get_cmd:
+	dev_err(&instance->pdev->dev,
+		"Init cmd return status %s for SCSI host %d\n",
+		ret ? "FAILED" : "SUCCESS", instance->host->host_no);
+
 	return ret;
 }
 
@@ -4314,9 +4317,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			megasas_fusion_update_can_queue(instance, OCR_CONTEXT);
 
 			if (megasas_ioc_init_fusion(instance)) {
-				dev_warn(&instance->pdev->dev,
-				       "megasas_ioc_init_fusion() failed! for "
-				       "scsi%d\n", instance->host->host_no);
 				if (instance->requestorId && !reason)
 					goto fail_kill_adapter;
 				else
@@ -4362,6 +4362,10 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			instance->instancet->enable_intr(instance);
 			atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 
+			dev_info(&instance->pdev->dev, "Interrupts are enabled and"
+				" controller is OPERATIONAL for scsi:%d\n",
+				instance->host->host_no);
+
 			/* Restart SR-IOV heartbeat */
 			if (instance->requestorId) {
 				if (!megasas_sriov_start_heartbeat(instance, 0))
@@ -4373,11 +4377,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					instance->skip_heartbeat_timer_del = 1;
 			}
 
-			/* Adapter reset completed successfully */
-			dev_warn(&instance->pdev->dev, "Reset "
-			       "successful for scsi%d.\n",
-				instance->host->host_no);
-
 			if (instance->crash_dump_drv_support &&
 				instance->crash_dump_app_support)
 				megasas_set_crash_dump_params(instance,
@@ -4387,6 +4386,12 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					MR_CRASH_BUF_TURN_OFF);
 
 			retval = SUCCESS;
+
+			/* Adapter reset completed successfully */
+			dev_warn(&instance->pdev->dev,
+				 "Reset successful for scsi%d.\n",
+				 instance->host->host_no);
+
 			goto out;
 		}
 fail_kill_adapter:
-- 
1.8.3.1
