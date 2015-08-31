From: sumit.saxena@avagotech.com
Subject: [PATCH v3 9/10] megaraid_sas : Code refactor for use of
 requestorId
Date: Mon, 31 Aug 2015 17:24:11 +0530
Message-ID: <201508311159.t7VBxe85031450@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp2.avagotech.com ([199.3.246.86]:52733 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbHaLym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Some of the code changes was proposed by David Binderman

Removed redudant check of requestorId. Redundant condition: instance.requestorId. 
Check for plasma firmware 1.11 or new restructured to support only for specific device id

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   35 +++++++++++++++--------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3a824cb..d2ebcdd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4842,18 +4842,22 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	}
 	if (ctrl_info->host_interface.SRIOV) {
-		if (!ctrl_info->adapterOperations2.activePassive)
-			instance->PlasmaFW111 = 1;
-
-		if (!instance->PlasmaFW111)
-			instance->requestorId =
-				ctrl_info->iov.requestorId;
-		else {
-			iovPtr = (struct IOV_111 *)((unsigned char *)ctrl_info + IOV_111_OFFSET);
-			instance->requestorId = iovPtr->requestorId;
+		instance->requestorId = ctrl_info->iov.requestorId;
+		if (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) {
+			if (!ctrl_info->adapterOperations2.activePassive)
+			    instance->PlasmaFW111 = 1;
+
+			dev_info(&instance->pdev->dev, "SR-IOV: firmware type: %s\n",
+			    instance->PlasmaFW111 ? "1.11" : "new");
+
+			if (instance->PlasmaFW111) {
+			    iovPtr = (struct IOV_111 *)
+				((unsigned char *)ctrl_info + IOV_111_OFFSET);
+			    instance->requestorId = iovPtr->requestorId;
+			}
 		}
-		dev_warn(&instance->pdev->dev, "I am VF "
-		       "requestorId %d\n", instance->requestorId);
+		dev_info(&instance->pdev->dev, "SRIOV: VF requestorId %d\n",
+			instance->requestorId);
 	}
 
 	instance->crash_dump_fw_support =
@@ -6723,8 +6727,7 @@ megasas_aen_polling(struct work_struct *work)
 		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
 			if (!instance->requestorId ||
-			    (instance->requestorId &&
-			     megasas_get_ld_vf_affiliation(instance, 0))) {
+			    megasas_get_ld_vf_affiliation(instance, 0)) {
 				if (megasas_ld_list_query(instance,
 							  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
 					megasas_get_ld_list(instance);
@@ -6755,8 +6758,7 @@ megasas_aen_polling(struct work_struct *work)
 			break;
 		case MR_EVT_LD_CREATED:
 			if (!instance->requestorId ||
-			    (instance->requestorId &&
-			     megasas_get_ld_vf_affiliation(instance, 0))) {
+			    megasas_get_ld_vf_affiliation(instance, 0)) {
 				if (megasas_ld_list_query(instance,
 							  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
 					megasas_get_ld_list(instance);
@@ -6822,8 +6824,7 @@ megasas_aen_polling(struct work_struct *work)
 		}
 
 		if (!instance->requestorId ||
-		    (instance->requestorId &&
-		     megasas_get_ld_vf_affiliation(instance, 0))) {
+		    megasas_get_ld_vf_affiliation(instance, 0)) {
 			if (megasas_ld_list_query(instance,
 						  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
 				megasas_get_ld_list(instance);
-- 
1.7.1

