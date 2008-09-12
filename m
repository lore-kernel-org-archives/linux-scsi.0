From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/8] qla2xxx: Add input/output byte-count statistics.
Date: Thu, 11 Sep 2008 21:22:47 -0700
Message-ID: <1221193374-77635-2-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYILEW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:22:58 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Currently Firmware does not have counters for input megabytes and
output megabytes, therefore driver counts these values depending
on the status of the scsi command and direction of the command.
The values are exported in the FC_HOST path.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 ++
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_iocb.c |   24 +++++++++++++++++-------
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 45e7dcb..866b0a8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1065,6 +1065,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 		pfc_host_stat->dumped_frames = stats->dumped_frames;
 		pfc_host_stat->nos_count = stats->nos_rcvd;
 	}
+	pfc_host_stat->fcp_input_megabytes = ha->qla_stats.input_bytes >> 20;
+	pfc_host_stat->fcp_output_megabytes = ha->qla_stats.output_bytes >> 20;
 
 done_free:
         dma_pool_free(ha->s_dma_pool, stats, stats_dma);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 431c19e..d1160d2 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2156,6 +2156,8 @@ struct qla_chip_state_84xx {
 
 struct qla_statistics {
 	uint32_t total_isp_aborts;
+	uint64_t input_bytes;
+	uint64_t output_bytes;
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d57669a..9778f0b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -21,17 +21,22 @@ static void qla2x00_isp_cmd(scsi_qla_host_t *ha);
  * Returns the proper CF_* direction based on CDB.
  */
 static inline uint16_t
-qla2x00_get_cmd_direction(struct scsi_cmnd *cmd)
+qla2x00_get_cmd_direction(srb_t *sp)
 {
 	uint16_t cflags;
 
 	cflags = 0;
 
 	/* Set transfer direction */
-	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+	if (sp->cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cflags = CF_WRITE;
-	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		sp->fcport->ha->qla_stats.output_bytes +=
+		    scsi_bufflen(sp->cmd);
+	} else if (sp->cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cflags = CF_READ;
+		sp->fcport->ha->qla_stats.input_bytes +=
+		    scsi_bufflen(sp->cmd);
+	}
 	return (cflags);
 }
 
@@ -169,7 +174,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 
 	ha = sp->ha;
 
-	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(cmd));
+	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Three DSDs are available in the Command Type 2 IOCB */
 	avail_dsds = 3;
@@ -228,7 +233,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 
 	ha = sp->ha;
 
-	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(cmd));
+	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Two DSDs are available in the Command Type 3 IOCB */
 	avail_dsds = 2;
@@ -625,12 +630,17 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	ha = sp->ha;
 
 	/* Set transfer direction */
-	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
 		    __constant_cpu_to_le16(TMF_WRITE_DATA);
-	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		sp->fcport->ha->qla_stats.output_bytes +=
+		    scsi_bufflen(sp->cmd);
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->task_mgmt_flags =
 		    __constant_cpu_to_le16(TMF_READ_DATA);
+		sp->fcport->ha->qla_stats.input_bytes +=
+		    scsi_bufflen(sp->cmd);
+	}
 
 	/* One DSD is available in the Command Type 3 IOCB */
 	avail_dsds = 1;
-- 
1.6.0.1.294.gda06a

