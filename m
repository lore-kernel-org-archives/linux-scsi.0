From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: fix sparse warning introduced by previous target mode t10-dif patch
Date: Mon, 2 Jun 2014 07:02:16 -0400
Message-ID: <1401706936-9855-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:52501 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbaFBLcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 07:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Fix sparse warning introduce by

commit f83adb617f55be13046191d83fa9110ff0689406
Author: Quinn Tran <quinn.tran@qlogic.com>
Date:   Fri Apr 11 16:54:43 2014 -0400

    qla2xxx: T10-Dif: add T10-PI support

    Add support for T10-Dif for Target Mode to qla driver.
    The driver will look for firmware attribute that support
    this feature.  When the feature is present, the capabilities
    will be report to TCM layer.

    Add CTIO CRC2 iocb to build T10-Dif commands.
    Add support routines to process good & error cases.

    Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
    Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |   16 ++++++++--------
 drivers/scsi/qla2xxx/qla_target.c |   15 ++++++++++-----
 drivers/scsi/qla2xxx/qla_target.h |   16 ++++++++--------
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1fa0104..de5d0ae 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1648,16 +1648,16 @@ typedef struct {
  */
 struct crc_context {
 	uint32_t handle;		/* System handle. */
-	uint32_t ref_tag;
-	uint16_t app_tag;
+	__le32 ref_tag;
+	__le16 app_tag;
 	uint8_t ref_tag_mask[4];	/* Validation/Replacement Mask*/
 	uint8_t app_tag_mask[2];	/* Validation/Replacement Mask*/
-	uint16_t guard_seed;		/* Initial Guard Seed */
-	uint16_t prot_opts;		/* Requested Data Protection Mode */
-	uint16_t blk_size;		/* Data size in bytes */
+	__le16 guard_seed;		/* Initial Guard Seed */
+	__le16 prot_opts;		/* Requested Data Protection Mode */
+	__le16 blk_size;		/* Data size in bytes */
 	uint16_t runt_blk_guard;	/* Guard value for runt block (tape
 					 * only) */
-	uint32_t byte_count;		/* Total byte count/ total data
+	__le32 byte_count;		/* Total byte count/ total data
 					 * transfer count */
 	union {
 		struct {
@@ -1671,10 +1671,10 @@ struct crc_context {
 			uint32_t	reserved_6;
 		} nobundling;
 		struct {
-			uint32_t	dif_byte_count;	/* Total DIF byte
+			__le32	dif_byte_count;	/* Total DIF byte
 							 * count */
 			uint16_t	reserved_1;
-			uint16_t	dseg_count;	/* Data segment count */
+			__le16	dseg_count;	/* Data segment count */
 			uint32_t	reserved_2;
 			uint32_t	data_address[2];
 			uint32_t	data_length;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b1d10f9..2619ed4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1997,7 +1997,7 @@ qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
 	 * have been immplemented by TCM, before AppTag is avail.
 	 * Look for modesense_handlers[]
 	 */
-	ctx->app_tag = __constant_cpu_to_le16(0);
+	ctx->app_tag = 0;
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
@@ -2079,6 +2079,7 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 	struct se_cmd		*se_cmd = &cmd->se_cmd;
 	uint32_t h;
 	struct atio_from_isp *atio = &prm->cmd->atio;
+	uint16_t t16;
 
 	sgc = 0;
 	ha = vha->hw;
@@ -2175,8 +2176,13 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	pkt->exchange_addr   = atio->u.isp24.exchange_addr;
-	pkt->ox_id  = swab16(atio->u.isp24.fcp_hdr.ox_id);
-	pkt->flags |= (atio->u.isp24.attr << 9);
+
+	/* silence compile warning */
+	t16 = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	pkt->ox_id  = cpu_to_le16(t16);
+
+	t16 = (atio->u.isp24.attr << 9);
+	pkt->flags |= cpu_to_le16(t16);
 	pkt->relative_offset = cpu_to_le32(prm->cmd->offset);
 
 	/* Set transfer direction */
@@ -2251,8 +2257,7 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 
 	if (bundling && prm->prot_seg_cnt) {
 		/* Walks dif segments */
-		pkt->add_flags |=
-			__constant_cpu_to_le16(CTIO_CRC2_AF_DIF_DSD_ENA);
+		pkt->add_flags |= CTIO_CRC2_AF_DIF_DSD_ENA;
 
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
 		if (qla24xx_walk_and_build_prot_sglist(ha, NULL, cur_dsd,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f873e10..fa5630b 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -316,7 +316,7 @@ struct fcp_hdr {
 	uint8_t  seq_id;
 	uint8_t  df_ctl;
 	uint16_t seq_cnt;
-	uint16_t ox_id;
+	__be16   ox_id;
 	uint16_t rx_id;
 	uint32_t parameter;
 } __packed;
@@ -441,7 +441,7 @@ struct ctio7_to_24xx {
 	union {
 		struct {
 			uint16_t reserved1;
-			uint16_t flags;
+			__le16 flags;
 			uint32_t residual;
 			uint16_t ox_id;
 			uint16_t scsi_status;
@@ -527,7 +527,7 @@ struct ctio_crc2_to_fw {
 
 	uint32_t handle;		/* System handle. */
 	uint16_t nport_handle;		/* N_PORT handle. */
-	uint16_t timeout;		/* Command timeout. */
+	__le16 timeout;		/* Command timeout. */
 
 	uint16_t dseg_count;		/* Data segment count. */
 	uint8_t  vp_index;
@@ -538,15 +538,15 @@ struct ctio_crc2_to_fw {
 	uint8_t  reserved1;
 	uint32_t exchange_addr;		/* rcv exchange address */
 	uint16_t reserved2;
-	uint16_t flags;			/* refer to CTIO7 flags values */
+	__le16 flags;			/* refer to CTIO7 flags values */
 	uint32_t residual;
-	uint16_t ox_id;
+	__le16 ox_id;
 	uint16_t scsi_status;
-	uint32_t relative_offset;
+	__le32 relative_offset;
 	uint32_t reserved5;
-	uint32_t transfer_length;		/* total fc transfer length */
+	__le32 transfer_length;		/* total fc transfer length */
 	uint32_t reserved6;
-	uint32_t crc_context_address[2];/* Data segment address. */
+	__le32 crc_context_address[2];/* Data segment address. */
 	uint16_t crc_context_len;	/* Data segment length. */
 	uint16_t reserved_1;		/* MUST be set to 0. */
 } __packed;
-- 
1.7.7

