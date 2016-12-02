From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Fri,  2 Dec 2016 09:07:26 -0500
Message-ID: <1480687648-36380-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35872 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761758AbcLBOIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2016 09:08:04 -0500
Received: by mail-qk0-f170.google.com with SMTP id n21so279570317qka.3
        for <linux-scsi@vger.kernel.org>; Fri, 02 Dec 2016 06:08:03 -0800 (PST)
In-Reply-To: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com, thenzl@redhat.com, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

ldio outstanding variable needs to be decremented in io completion path for
iMR dual queue depth

This patch is depending on patch 8

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 3aab189..e8016bc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2558,8 +2558,6 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 
 	if (atomic_inc_return(&instance->fw_outstanding) >
 			instance->host->can_queue) {
-		dev_err(&instance->pdev->dev, "Throttle IOs beyond"
-		"Controller queue depth\n");
 		atomic_dec(&instance->fw_outstanding);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -2786,6 +2784,8 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 					extStatus, data_length, sense);
 				scsi_io_req->RaidContext.raid_context.status = 0;
 				scsi_io_req->RaidContext.raid_context.exStatus = 0;
+				if (instance->ldio_threshold && megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				scmd_local->scsi_done(scmd_local);
@@ -3931,7 +3931,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				scmd_local->result =
 					megasas_check_mpio_paths(instance,
 							scmd_local);
-				if (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+				if (instance->ldio_threshold && megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
 					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
-- 
1.8.3.1

