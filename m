From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/13] qla2xxx: Propagate block-layer tags on submitted I/Os.
Date: Wed, 23 Feb 2011 15:27:15 -0800
Message-ID: <1298503638-22396-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52636 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755189Ab1BWXab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:31 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   52 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_nx.c   |   32 ++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 4c1ba62..d78d589 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -328,6 +328,7 @@ qla2x00_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha;
 	struct req_que *req;
 	struct rsp_que *rsp;
+	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -406,7 +407,22 @@ qla2x00_start_scsi(srb_t *sp)
 	cmd_pkt->lun = cpu_to_le16(sp->cmd->device->lun);
 
 	/* Update tagged queuing modifier */
-	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case HEAD_OF_QUEUE_TAG:
+			cmd_pkt->control_flags =
+			    __constant_cpu_to_le16(CF_HEAD_TAG);
+			break;
+		case ORDERED_QUEUE_TAG:
+			cmd_pkt->control_flags =
+			    __constant_cpu_to_le16(CF_ORDERED_TAG);
+			break;
+		default:
+			cmd_pkt->control_flags =
+			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
+			break;
+		}
+	}
 
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->scsi_cdb, cmd->cmnd, cmd->cmd_len);
@@ -971,6 +987,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	uint16_t		fcp_cmnd_len;
 	struct fcp_cmnd		*fcp_cmnd;
 	dma_addr_t		crc_ctx_dma;
+	char			tag[2];
 
 	cmd = sp->cmd;
 
@@ -1068,9 +1085,27 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	    LSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
 	cmd_pkt->fcp_cmnd_dseg_address[1] = cpu_to_le32(
 	    MSD(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF));
-	fcp_cmnd->task_attribute = 0;
 	fcp_cmnd->task_management = 0;
 
+	/*
+	 * Update tagged queuing modifier if using command tag queuing
+	 */
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case HEAD_OF_QUEUE_TAG:
+		    fcp_cmnd->task_attribute = TSK_HEAD_OF_QUEUE;
+		    break;
+		case ORDERED_QUEUE_TAG:
+		    fcp_cmnd->task_attribute = TSK_ORDERED;
+		    break;
+		default:
+		    fcp_cmnd->task_attribute = 0;
+		    break;
+		}
+	} else {
+		fcp_cmnd->task_attribute = 0;
+	}
+
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
 
 	DEBUG18(printk(KERN_INFO "%s(%ld): Total SG(s) Entries %d, Data"
@@ -1177,6 +1212,7 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
+	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -1260,6 +1296,18 @@ qla24xx_start_scsi(srb_t *sp)
 	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
+	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case HEAD_OF_QUEUE_TAG:
+			cmd_pkt->task = TSK_HEAD_OF_QUEUE;
+			break;
+		case ORDERED_QUEUE_TAG:
+			cmd_pkt->task = TSK_ORDERED;
+			break;
+		}
+	}
+
 	/* Load SCSI command packet. */
 	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
 	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f1ffee4..76ec876 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -7,6 +7,7 @@
 #include "qla_def.h"
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <scsi/scsi_tcq.h>
 
 #define MASK(n)			((1ULL<<(n))-1)
 #define MN_WIN(addr) (((addr & 0x1fc0000) >> 1) | \
@@ -2620,6 +2621,7 @@ qla82xx_start_scsi(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -2770,6 +2772,22 @@ sufficient_dsds:
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
+		/*
+		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
+		 */
+		if (scsi_populate_tag_msg(cmd, tag)) {
+			switch (tag[0]) {
+			case HEAD_OF_QUEUE_TAG:
+				ctx->fcp_cmnd->task_attribute =
+				    TSK_HEAD_OF_QUEUE;
+				break;
+			case ORDERED_QUEUE_TAG:
+				ctx->fcp_cmnd->task_attribute =
+				    TSK_ORDERED;
+				break;
+			}
+		}
+
 		/* build FCP_CMND IU */
 		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
@@ -2835,6 +2853,20 @@ sufficient_dsds:
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
 			sizeof(cmd_pkt->lun));
 
+		/*
+		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
+		 */
+		if (scsi_populate_tag_msg(cmd, tag)) {
+			switch (tag[0]) {
+			case HEAD_OF_QUEUE_TAG:
+				cmd_pkt->task = TSK_HEAD_OF_QUEUE;
+				break;
+			case ORDERED_QUEUE_TAG:
+				cmd_pkt->task = TSK_ORDERED;
+				break;
+			}
+		}
+
 		/* Load SCSI command packet. */
 		memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
 		host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
-- 
1.6.0.2

