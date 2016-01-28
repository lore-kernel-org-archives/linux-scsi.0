From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 14/15] megaraid_sas: SPERC OCR changes
Date: Thu, 28 Jan 2016 21:04:35 +0530
Message-ID: <1453995276-24955-15-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35212 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966489AbcA1PgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:36:06 -0500
Received: by mail-pf0-f174.google.com with SMTP id 65so25279552pfd.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:36:05 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

This patch will do some fixes in OCR path of SRIOV enabled series of Avago controllers.

1)Removing late detection HB. 
2)Change in the behavior if the FW found in READY/OPERAETIONAL state.

There are no changes in this patch from last time sent patch.

Signed-off-by: Uday Lingala <uday.lingala@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 73 +++++++----------------------
 1 file changed, 16 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e740e26..be9c3f1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3462,52 +3462,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		/* Let SR-IOV VF & PF sync up if there was a HB failure */
 		if (instance->requestorId && !reason) {
 			msleep(MEGASAS_OCR_SETTLE_TIME_VF);
-			/* Look for a late HB update after VF settle time */
-			if (abs_state == MFI_STATE_OPERATIONAL &&
-			    (instance->hb_host_mem->HB.fwCounter !=
-			     instance->hb_host_mem->HB.driverCounter)) {
-					instance->hb_host_mem->HB.driverCounter =
-						instance->hb_host_mem->HB.fwCounter;
-					dev_warn(&instance->pdev->dev, "SR-IOV:"
-					       "Late FW heartbeat update for "
-					       "scsi%d.\n",
-					       instance->host->host_no);
-			} else {
-				/* In VF mode, first poll for FW ready */
-				for (i = 0;
-				     i < (MEGASAS_RESET_WAIT_TIME * 1000);
-				     i += 20) {
-					status_reg =
-						instance->instancet->
-						read_fw_status_reg(
-							instance->reg_set);
-					abs_state = status_reg &
-						MFI_STATE_MASK;
-					if (abs_state == MFI_STATE_READY) {
-						dev_warn(&instance->pdev->dev,
-						       "SR-IOV: FW was found"
-						       "to be in ready state "
-						       "for scsi%d.\n",
-						       instance->host->host_no);
-						break;
-					}
-					msleep(20);
-				}
-				if (abs_state != MFI_STATE_READY) {
-					dev_warn(&instance->pdev->dev, "SR-IOV: "
-					       "FW not in ready state after %d"
-					       " seconds for scsi%d, status_reg = "
-					       "0x%x.\n",
-					       MEGASAS_RESET_WAIT_TIME,
-					       instance->host->host_no,
-					       status_reg);
-					megaraid_sas_kill_hba(instance);
-					instance->skip_heartbeat_timer_del = 1;
-					atomic_set(&instance->adprecovery, MEGASAS_HW_CRITICAL_ERROR);
-					retval = FAILED;
-					goto out;
-				}
-			}
+			goto transition_to_ready;
 		}
 
 		/* Now try to reset the chip */
@@ -3516,25 +3471,28 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			if (instance->instancet->adp_reset
 				(instance, instance->reg_set))
 				continue;
-
+transition_to_ready:
 			/* Wait for FW to become ready */
 			if (megasas_transition_to_ready(instance, 1)) {
-				dev_warn(&instance->pdev->dev, "Failed to "
-				       "transition controller to ready "
-				       "for scsi%d.\n",
-				       instance->host->host_no);
-				continue;
+				dev_warn(&instance->pdev->dev,
+					"Failed to transition controller to ready for "
+					"scsi%d.\n", instance->host->host_no);
+				if (instance->requestorId && !reason)
+					goto fail_kill_adapter;
+				else
+					continue;
 			}
-
 			megasas_reset_reply_desc(instance);
 			megasas_fusion_update_can_queue(instance, OCR_CONTEXT);
 
 			if (megasas_ioc_init_fusion(instance)) {
 				dev_warn(&instance->pdev->dev,
-				       "megasas_ioc_init_fusion() failed!"
-				       " for scsi%d\n",
-				       instance->host->host_no);
-				continue;
+				       "megasas_ioc_init_fusion() failed! for "
+				       "scsi%d\n", instance->host->host_no);
+				if (instance->requestorId && !reason)
+					goto fail_kill_adapter;
+				else
+					continue;
 			}
 
 			megasas_refire_mgmt_cmd(instance);
@@ -3591,6 +3549,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			retval = SUCCESS;
 			goto out;
 		}
+fail_kill_adapter:
 		/* Reset failed, kill the adapter */
 		dev_warn(&instance->pdev->dev, "Reset failed, killing "
 		       "adapter scsi%d.\n", instance->host->host_no);
-- 
1.8.3.1

