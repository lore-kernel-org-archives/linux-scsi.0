From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 03/15] megaraid_sas: Use synchronize_irq in target reset case
Date: Wed,  5 Jul 2017 05:00:17 -0700
Message-ID: <1499256029-16319-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:36287 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdGEMBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:24 -0400
Received: by mail-pg0-f51.google.com with SMTP id u62so123304226pgb.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:19 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Similar to task abort case, use synchronize_irq API in target reset case.
Also, remove redundant call to megasas_complete_cmd_dpc_fusion
after calling megasas_sync_irqs in task abort case.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f717fbc..5018a3f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3826,8 +3826,6 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 		else {
 			instance->instancet->disable_intr(instance);
 			megasas_sync_irqs((unsigned long)instance);
-			megasas_complete_cmd_dpc_fusion
-					((unsigned long)instance);
 			instance->instancet->enable_intr(instance);
 			if (scsi_lookup->scmd == NULL)
 				break;
@@ -3839,9 +3837,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 		if ((channel == 0xFFFFFFFF) && (id == 0xFFFFFFFF))
 			break;
 		instance->instancet->disable_intr(instance);
-		msleep(1000);
-		megasas_complete_cmd_dpc_fusion
-				((unsigned long)instance);
+		megasas_sync_irqs((unsigned long)instance);
 		rc = megasas_track_scsiio(instance, id, channel);
 		instance->instancet->enable_intr(instance);
 
-- 
1.8.3.1
