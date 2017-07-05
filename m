From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 04/15] megaraid_sas: Call megasas_complete_cmd_dpc_fusion every 1 second while there are pending commands
Date: Wed,  5 Jul 2017 05:00:18 -0700
Message-ID: <1499256029-16319-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33192 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbdGEMBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:25 -0400
Received: by mail-pf0-f171.google.com with SMTP id e7so128780651pfk.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:25 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix - megasas_wait_for_outstanding_fusion checks for pending commands every
1second. But megasas_complete_cmd_dpc_fusion is only called every 5seconds.
If the commands are already completed by firmware, there is an additional
delay of 5seconds before driver will process completion for these commands.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5018a3f..0f13c58 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3552,6 +3552,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			}
 		}
 
+		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
 		outstanding = atomic_read(&instance->fw_outstanding);
 		if (!outstanding)
 			goto out;
@@ -3560,8 +3561,6 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
 			       "commands to complete for scsi%d\n", i,
 			       outstanding, instance->host->host_no);
-			megasas_complete_cmd_dpc_fusion(
-				(unsigned long)instance);
 		}
 		msleep(1000);
 	}
-- 
1.8.3.1
