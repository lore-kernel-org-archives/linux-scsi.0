From: giridhar.malavali@qlogic.com
Subject: [PATCH 17/17] qla2xxx: T10 DIF Type 2 support
Date: Fri, 23 Jul 2010 15:28:38 +0500
Message-ID: <1279880918-62876-18-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47974 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWKAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 06:00:04 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 ++
 drivers/scsi/qla2xxx/qla_iocb.c |   35 +++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mid.c  |    5 ++++-
 drivers/scsi/qla2xxx/qla_os.c   |    7 ++++++-
 4 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d9b431d..420238c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1758,8 +1758,10 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			    " protection.\n"));
 			scsi_host_set_prot(vha->host,
 			    SHOST_DIF_TYPE1_PROTECTION
+			    | SHOST_DIF_TYPE2_PROTECTION
 			    | SHOST_DIF_TYPE3_PROTECTION
 			    | SHOST_DIX_TYPE1_PROTECTION
+			    | SHOST_DIX_TYPE2_PROTECTION
 			    | SHOST_DIX_TYPE3_PROTECTION);
 			scsi_host_set_guard(vha->host, SHOST_DIX_GUARD_CRC);
 		} else
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d2b299f..4e4c21f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -712,6 +712,25 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 	 * match LBA in CDB + N
 	 */
 	case SCSI_PROT_DIF_TYPE2:
+		if (!ql2xenablehba_err_chk)
+			break;
+
+		if (scsi_prot_sg_count(cmd)) {
+			spt = page_address(sg_page(scsi_prot_sglist(cmd))) +
+			    scsi_prot_sglist(cmd)[0].offset;
+			pkt->app_tag = swab32(spt->app_tag);
+			pkt->app_tag_mask[0] =  0xff;
+			pkt->app_tag_mask[1] =  0xff;
+		}
+
+		pkt->ref_tag = cpu_to_le32((uint32_t)
+		    (0xffffffff & scsi_get_lba(cmd)));
+
+		/* enable ALL bytes of the ref tag */
+		pkt->ref_tag_mask[0] = 0xff;
+		pkt->ref_tag_mask[1] = 0xff;
+		pkt->ref_tag_mask[2] = 0xff;
+		pkt->ref_tag_mask[3] = 0xff;
 		break;
 
 	/* For Type 3 protection: 16 bit GUARD only */
@@ -1062,7 +1081,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	total_bytes = data_bytes;
 	dif_bytes = 0;
 	blk_size = cmd->device->sector_size;
-	if (scsi_get_prot_type(cmd) == SCSI_PROT_DIF_TYPE1) {
+	if (scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
 		dif_bytes = (data_bytes / blk_size) * 8;
 		total_bytes += dif_bytes;
 	}
@@ -1100,6 +1119,12 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	    vha->host_no, dif_bytes, dif_bytes, total_bytes, total_bytes,
 	    crc_ctx_pkt->blk_size, crc_ctx_pkt->blk_size));
 
+	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
+		DEBUG18(printk(KERN_INFO "%s: Zero data bytes or DMA-NONE %d\n",
+		    __func__, data_bytes));
+		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		return QLA_SUCCESS;
+	}
 	/* Walks data segments */
 
 	cmd_pkt->control_flags |=
@@ -1310,9 +1335,11 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 #define QDSS_GOT_Q_SPACE	BIT_0
 
-	/* Only process protection in this routine */
-	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL)
-		return qla24xx_start_scsi(sp);
+	/* Only process protection or >16 cdb in this routine */
+	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
+		if (cmd->cmd_len <= 16)
+			return qla24xx_start_scsi(sp);
+	}
 
 	/* Setup device pointers. */
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 9a82c34..987c5b0 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -399,7 +399,10 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	host->can_queue = base_vha->req->length + 128;
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
-	host->max_cmd_len = MAX_CMDSZ;
+	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif)
+		host->max_cmd_len = 32;
+	else
+		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
 	host->unique_id = host->host_no;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index aeb2f1b..ff2172d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2147,7 +2147,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
 	host->unique_id = host->host_no;
-	host->max_cmd_len = MAX_CMDSZ;
+	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif)
+		host->max_cmd_len = 32;
+	else
+		host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
 	host->transportt = qla2xxx_transport_template;
@@ -2255,8 +2258,10 @@ skip_dpc:
 			    " protection.\n"));
 			scsi_host_set_prot(host,
 			    SHOST_DIF_TYPE1_PROTECTION
+			    | SHOST_DIF_TYPE2_PROTECTION
 			    | SHOST_DIF_TYPE3_PROTECTION
 			    | SHOST_DIX_TYPE1_PROTECTION
+			    | SHOST_DIX_TYPE2_PROTECTION
 			    | SHOST_DIX_TYPE3_PROTECTION);
 			scsi_host_set_guard(host, SHOST_DIX_GUARD_CRC);
 		} else
-- 
1.6.0.2

