From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V4 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Tue,  6 Dec 2016 18:00:18 -0500
Message-ID: <1481065220-18431-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

ldio outstanding variable needs to be decremented in io completion path for
iMR dual queue depth

This patch is depending on patch 8

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5992153..3598590 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2584,7 +2584,6 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 
 	if (atomic_inc_return(&instance->fw_outstanding) >
 			instance->host->can_queue) {
-		dev_err(&instance->pdev->dev, "Throttle IOs beyond Controller queue depth\n");
 		atomic_dec(&instance->fw_outstanding);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -2818,6 +2817,10 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 				= 0;
 				scsi_io_req->RaidContext.raid_context.ex_status
 				= 0;
+				if (instance->ldio_threshold
+					&& megasas_cmd_type(scmd_local)
+					== READ_WRITE_LDIO)
+					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				scmd_local->scsi_done(scmd_local);
@@ -3966,7 +3969,9 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				scmd_local->result =
 					megasas_check_mpio_paths(instance,
 							scmd_local);
-				if (megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
+				if (instance->ldio_threshold &&
+					megasas_cmd_type(scmd_local)
+					== READ_WRITE_LDIO)
 					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
-- 
1.8.3.1
