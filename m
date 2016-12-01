From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Thu,  1 Dec 2016 14:10:43 -0500
Message-ID: <1480619445-45073-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

From: root <sasikumar.pc@broadcom.com>

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
