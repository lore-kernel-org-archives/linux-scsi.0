From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/21] qla2xxx: Assign mailbox command timeout values in a consistent manner.
Date: Thu,  3 Apr 2008 13:13:25 -0700
Message-ID: <1207253612-15538-14-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbYDCUNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:42 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   62 ++++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c1af56d..beff743 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -310,7 +310,7 @@ qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
 	}
 
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -367,7 +367,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 		}
 	}
 
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -417,7 +417,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *ha, uint16_t *major, uint16_t *minor,
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->flags = 0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
 	/* Return mailbox data. */
@@ -466,7 +466,7 @@ qla2x00_get_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 	mcp->mb[0] = MBC_GET_FIRMWARE_OPTION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -524,7 +524,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *ha, uint16_t *fwopts)
 		mcp->mb[12] = 0;	/* Undocumented, but used */
 		mcp->out_mb |= MBX_12|MBX_11|MBX_10;
 	}
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -576,7 +576,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha)
 	mcp->mb[7] = 0x2525;
 	mcp->out_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -648,7 +648,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
 		mcp->in_mb |= MBX_1;
 	}
 
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -697,7 +697,7 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, void*  buffer, dma_addr_t phys_addr,
 	mcp->mb[7] = LSW(MSD(phys_addr));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_2|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -768,7 +768,7 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	mcp->mb[6] = (uint16_t)sp->cmd->device->lun;
 	mcp->out_mb = MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -809,7 +809,7 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l)
 	mcp->mb[9] = ha->vp_idx;
 
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -851,7 +851,7 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l)
 	mcp->mb[9] = ha->vp_idx;
 
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -906,7 +906,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 	mcp->mb[9] = ha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (mcp->mb[0] == MBS_COMMAND_ERROR)
@@ -963,7 +963,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *ha, uint8_t *retry_cnt, uint8_t *tov,
 	mcp->mb[0] = MBC_GET_RETRY_COUNT;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1030,7 +1030,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	mcp->in_mb = MBX_5|MBX_4|MBX_0;
 	mcp->buf_size = size;
 	mcp->flags = MBX_DMA_OUT;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
 	if (rval != QLA_SUCCESS) {
@@ -1220,7 +1220,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *ha, uint16_t *dptr)
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1281,7 +1281,7 @@ qla2x00_get_port_name(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t *name,
 	}
 
 	mcp->in_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1353,7 +1353,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 		mcp->mb[3] = 0;
 	}
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1778,7 +1778,7 @@ qla2x00_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	}
 
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1826,7 +1826,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *ha)
 	mcp->mb[3] = 0;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1887,7 +1887,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
 		mcp->out_mb |= MBX_6|MBX_3|MBX_2|MBX_1;
 	}
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -1931,7 +1931,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2071,7 +2071,7 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 		mcp->mb[1] = loop_id << 8;
 		mcp->out_mb |= MBX_1;
 	}
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2117,7 +2117,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
 	mcp->mb[10] = 0;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = IOCTL_CMD;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2351,7 +2351,7 @@ qla2x00_set_serdes_params(scsi_qla_host_t *ha, uint16_t sw_em_1g,
 	mcp->mb[4] = sw_em_4g | BIT_15;
 	mcp->out_mb = MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2419,7 +2419,7 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *ha, dma_addr_t eft_dma,
 	mcp->mb[7] = TC_AEN_DISABLE;
 	mcp->out_mb = MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -2448,7 +2448,7 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *ha)
 	mcp->mb[1] = TC_EFT_DISABLE;
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -2488,7 +2488,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|
 	    MBX_1|MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -2524,7 +2524,7 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *ha, uint64_t *wr, uint64_t *rd)
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_9|MBX_8|MBX_7|MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|
 	    MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -2572,7 +2572,7 @@ qla2x00_read_sfp(scsi_qla_host_t *ha, dma_addr_t sfp_dma, uint16_t addr,
 	mcp->mb[10] = 0;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2606,7 +2606,7 @@ qla2x00_set_idma_speed(scsi_qla_host_t *ha, uint16_t loop_id,
 	mcp->mb[4] = mcp->mb[5] = 0;
 	mcp->out_mb = MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_5|MBX_4|MBX_3|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
@@ -2924,7 +2924,7 @@ qla2x00_dump_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t addr,
 	}
 
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
 
-- 
1.5.5.rc2

