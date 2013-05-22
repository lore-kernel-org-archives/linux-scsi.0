From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 01/12] megaraid_sas : Return DID_ERROR for SCSI IO, when
 controller is in critical h/w error
Date: Wed, 22 May 2013 12:29:28 +0530
Message-ID: <201305221229.r4MCTiqw011816@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:5120 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906Ab3EVM3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:29:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Do not return SCSI_MLQUEUE_HOST_BUSY, but send DID_ERROR to SCSI mid-layer, if adapter is in critical error state.
"SCSI_MLQUEUE_HOST_BUSY" will keep same SCSI command in loop and it is not a right return value,
if controller is hardware critical error.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9d53540..758ea2e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1471,6 +1471,14 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
+
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		scmd->result = DID_ERROR << 16;
+		done(scmd);
+		return 0;
+	}
+
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		return SCSI_MLQUEUE_HOST_BUSY;

