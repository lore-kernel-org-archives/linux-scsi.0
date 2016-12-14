From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V5 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Wed, 14 Dec 2016 17:13:06 -0500
Message-ID: <1481753588-101811-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34211 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933805AbcLNWNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 17:13:46 -0500
Received: by mail-qt0-f172.google.com with SMTP id n6so39507678qtd.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 14:13:45 -0800 (PST)
In-Reply-To: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

ldio outstanding variable needs to be decremented in io completion path for
iMR dual queue depth

This patch is depending on patch 8
This patch is same as V4 and there is no specific update for V5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 9b08de7..d4c78b0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2571,7 +2571,6 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 
 	if (atomic_inc_return(&instance->fw_outstanding) >
 			instance->host->can_queue) {
-		dev_err(&instance->pdev->dev, "Throttle IOs beyond Controller queue depth\n");
 		atomic_dec(&instance->fw_outstanding);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -2803,6 +2802,9 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 					extStatus, data_length, sense);
 				scsi_io_req->RaidContext.raid_context.status = 0;
 				scsi_io_req->RaidContext.raid_context.ex_status = 0;
+				if (instance->ldio_threshold
+					&& megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				scmd_local->scsi_done(scmd_local);
@@ -3951,7 +3953,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				scmd_local->result =
 					megasas_check_mpio_paths(instance,
 							scmd_local);
-				if (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+				if (instance->ldio_threshold &&
+					megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
 					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
-- 
1.8.3.1

