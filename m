From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 07/39] megaraid_sas: Use DID_REQUEUE
Date: Wed,  8 Feb 2017 01:29:01 -0800
Message-ID: <1486546173-20713-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33514 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pf0-f175.google.com with SMTP id y143so41082097pfb.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:16 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Moving to use DID_REQUEUE return type for reliable unconditional retries.
Driver wants unconditional re-queue, so replace DID_RESET with DID_REQUEUE
Discussed below -
https://www.spinics.net/lists/linux-scsi/msg102848.html

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 67a205a..80fcdf5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1668,7 +1668,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	/* Check for an mpio path and adjust behavior */
 	if (atomic_read(&instance->adprecovery) == MEGASAS_ADPRESET_SM_INFAULT) {
 		if (megasas_check_mpio_paths(instance, scmd) ==
-		    (DID_RESET << 16)) {
+		    (DID_REQUEUE << 16)) {
 			return SCSI_MLQUEUE_HOST_BUSY;
 		} else {
 			scmd->result = DID_NO_CONNECT << 16;
@@ -2492,7 +2492,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						struct megasas_cmd, list);
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
-				reset_cmd->scmd->result = DID_RESET << 16;
+				reset_cmd->scmd->result = DID_REQUEUE << 16;
 				dev_notice(&instance->pdev->dev, "%d:%p reset [%02x]\n",
 					reset_index, reset_cmd,
 					reset_cmd->scmd->cmnd[0]);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675afc9..6ec7a18 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3770,7 +3770,7 @@ int megasas_check_mpio_paths(struct megasas_instance *instance,
 	struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *peer_instance = NULL;
-	int retval = (DID_RESET << 16);
+	int retval = (DID_REQUEUE << 16);
 
 	if (instance->peerIsPresent) {
 		peer_instance = megasas_get_peer_instance(instance);
-- 
2.8.3
