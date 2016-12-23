From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V6 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Thu, 22 Dec 2016 20:19:52 -0500
Message-ID: <1482455994-8047-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:34924 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942229AbcLWBVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2016 20:21:06 -0500
Received: by mail-qt0-f176.google.com with SMTP id c47so250115464qtc.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2016 17:21:06 -0800 (PST)
In-Reply-To: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

ldio outstanding variable needs to be decremented in io completion path for
iMR dual queue depth

This patch is depending on patch 8 and same as V5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index aa508b3..a3382cf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2579,7 +2579,6 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 
 	if (atomic_inc_return(&instance->fw_outstanding) >
 			instance->host->can_queue) {
-		dev_err(&instance->pdev->dev, "Throttle IOs beyond Controller queue depth\n");
 		atomic_dec(&instance->fw_outstanding);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -2811,6 +2810,9 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 					extStatus, data_length, sense);
 				scsi_io_req->RaidContext.raid_context.status = 0;
 				scsi_io_req->RaidContext.raid_context.ex_status = 0;
+				if (instance->ldio_threshold
+					&& megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				scmd_local->scsi_done(scmd_local);
@@ -3959,7 +3961,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
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

