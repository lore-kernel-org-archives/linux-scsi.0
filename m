From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8] qla2xxx: Collapse EFT/FCE copy procedures during a firmware dump.
Date: Mon,  5 Jan 2009 11:18:08 -0800
Message-ID: <1231183092-10471-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbZAETSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:17 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

In preparation for new ISP types with varying dump procedures.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |   75 +++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    4 ++-
 3 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1cf7777..49040ed 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -310,6 +310,43 @@ qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
 		*buf++ = htons(RD_REG_WORD(dmp_reg++));
 }
 
+static inline void *
+qla24xx_copy_eft(struct qla_hw_data *ha, void *ptr)
+{
+	if (!ha->eft)
+		return ptr;
+
+	memcpy(ptr, ha->eft, ntohl(ha->fw_dump->eft_size));
+	return ptr + ntohl(ha->fw_dump->eft_size);
+}
+
+static inline void *
+qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+{
+	uint32_t cnt;
+	uint32_t *iter_reg;
+	struct qla2xxx_fce_chain *fcec = ptr;
+
+	if (!ha->fce)
+		return ptr;
+
+	*last_chain = &fcec->type;
+	fcec->type = __constant_htonl(DUMP_CHAIN_FCE);
+	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
+	    fce_calc_size(ha->fce_bufs));
+	fcec->size = htonl(fce_calc_size(ha->fce_bufs));
+	fcec->addr_l = htonl(LSD(ha->fce_dma));
+	fcec->addr_h = htonl(MSD(ha->fce_dma));
+
+	iter_reg = fcec->eregs;
+	for (cnt = 0; cnt < 8; cnt++)
+		*iter_reg++ = htonl(ha->fce_mb[cnt]);
+
+	memcpy(iter_reg, ha->fce, ntohl(fcec->size));
+
+	return iter_reg;
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -913,8 +950,8 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		goto qla24xx_fw_dump_failed_0;
 
 	nxt = qla2xxx_copy_queues(ha, nxt);
-	if (ha->eft)
-		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
+
+	qla24xx_copy_eft(ha, nxt);
 
 qla24xx_fw_dump_failed_0:
 	if (rval != QLA_SUCCESS) {
@@ -950,7 +987,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	struct qla25xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
 	void		*nxt;
-	struct qla2xxx_fce_chain *fcec;
+	uint32_t	*last_chain = NULL;
 	struct qla2xxx_mq_chain *mq = NULL;
 	uint32_t	qreg_size;
 	uint8_t		req_cnt, rsp_cnt, que_cnt;
@@ -1012,6 +1049,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
 		mq->count = htonl(que_cnt);
 		mq->chain_size = htonl(qreg_size);
+		last_chain = &mq->type;
 		mq->type = __constant_htonl(DUMP_CHAIN_MQ);
 		for (cnt = 0; cnt < que_cnt; cnt++) {
 			reg25 = (struct device_reg_25xxmq *) ((void *)
@@ -1249,37 +1287,22 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	if (rval != QLA_SUCCESS)
 		goto qla25xx_fw_dump_failed_0;
 
-	/* Fibre Channel Trace Buffer. */
 	nxt = qla2xxx_copy_queues(ha, nxt);
-	if (ha->eft)
-		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 
-	/* Fibre Channel Event Buffer. */
-	if (!ha->fce)
-		goto qla25xx_fw_dump_failed_0;
-
-	ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
+	nxt = qla24xx_copy_eft(ha, nxt);
 
+	/* Chain entries. */
 	if (ha->mqenable) {
-		nxt = nxt + ntohl(ha->fw_dump->eft_size);
 		memcpy(nxt, mq, qreg_size);
 		kfree(mq);
-		fcec = nxt + qreg_size;
-	} else {
-		fcec = nxt + ntohl(ha->fw_dump->eft_size);
+		nxt += qreg_size;
 	}
-	fcec->type = __constant_htonl(DUMP_CHAIN_FCE | DUMP_CHAIN_LAST);
-	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
-	    fce_calc_size(ha->fce_bufs));
-	fcec->size = htonl(fce_calc_size(ha->fce_bufs));
-	fcec->addr_l = htonl(LSD(ha->fce_dma));
-	fcec->addr_h = htonl(MSD(ha->fce_dma));
-
-	iter_reg = fcec->eregs;
-	for (cnt = 0; cnt < 8; cnt++)
-		*iter_reg++ = htonl(ha->fce_mb[cnt]);
 
-	memcpy(iter_reg, ha->fce, ntohl(fcec->size));
+	qla25xx_copy_fce(ha, nxt, &last_chain);
+	if (last_chain) {
+		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+	}
 
 qla25xx_fw_dump_failed_0:
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 191c95d..c8e5af5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2477,6 +2477,7 @@ struct qla_hw_data {
 	dma_addr_t	eft_dma;
 	void		*eft;
 
+	uint32_t	chain_offset;
 	struct dentry *dfs_dir;
 	struct dentry *dfs_fce;
 	dma_addr_t	fce_dma;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3ec6eac..6038aed 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -850,7 +850,9 @@ cont_alloc:
 
 	dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 	dump_size += fixed_size + mem_size + req_q_size + rsp_q_size +
-	    mq_size + eft_size + fce_size;
+	    eft_size;
+	ha->chain_offset = dump_size;
+	dump_size += mq_size + fce_size;
 
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
-- 
1.6.1.28.gc32f76

