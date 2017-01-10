From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V7 09/11] megaraid_sas: ldio_outstanding variable is not decremented in completion path
Date: Tue, 10 Jan 2017 18:20:51 -0500
Message-ID: <1484090453-7091-10-git-send-email-sasikumar.pc@broadcom.com>
References: <1484090453-7091-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484090453-7091-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

ldio outstanding variable needs to be decremented in io completion path for
iMR dual queue depth

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
Changes v6 -> v7:
-None

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 4d655e4..705102f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2580,7 +2580,6 @@ void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
 
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
