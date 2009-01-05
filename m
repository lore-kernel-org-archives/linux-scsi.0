From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/8] qla2xxx: Correct MQ-chain information retrieval during a firmware dump.
Date: Mon,  5 Jan 2009 11:18:09 -0800
Message-ID: <1231183092-10471-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbZAETSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:21 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code would not read request/response queue pointers.
Also, collapse code into a helper qla25xx_copy_mq() function in
preparation for newer ISP parts.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   77 +++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 49040ed..4f47836 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -347,6 +347,39 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	return iter_reg;
 }
 
+static inline void *
+qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+{
+	uint32_t cnt, que_idx;
+	uint8_t req_cnt, rsp_cnt, que_cnt;
+	struct qla2xxx_mq_chain *mq = ptr;
+	struct device_reg_25xxmq __iomem *reg;
+
+	if (!ha->mqenable)
+		return ptr;
+
+	mq = ptr;
+	*last_chain = &mq->type;
+	mq->type = __constant_htonl(DUMP_CHAIN_MQ);
+	mq->chain_size = __constant_htonl(sizeof(struct qla2xxx_mq_chain));
+
+	req_cnt = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
+	rsp_cnt = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
+	que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
+	mq->count = htonl(que_cnt);
+	for (cnt = 0; cnt < que_cnt; cnt++) {
+		reg = (struct device_reg_25xxmq *) ((void *)
+			ha->mqiobase + cnt * QLA_QUE_PAGE);
+		que_idx = cnt * 4;
+		mq->qregs[que_idx] = htonl(RD_REG_DWORD(&reg->req_q_in));
+		mq->qregs[que_idx+1] = htonl(RD_REG_DWORD(&reg->req_q_out));
+		mq->qregs[que_idx+2] = htonl(RD_REG_DWORD(&reg->rsp_q_in));
+		mq->qregs[que_idx+3] = htonl(RD_REG_DWORD(&reg->rsp_q_out));
+	}
+
+	return ptr + sizeof(struct qla2xxx_mq_chain);
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -979,19 +1012,14 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t	risc_address;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	struct device_reg_25xxmq __iomem *reg25;
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla25xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
-	void		*nxt;
+	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
-	struct qla2xxx_mq_chain *mq = NULL;
-	uint32_t	qreg_size;
-	uint8_t		req_cnt, rsp_cnt, que_cnt;
-	uint32_t	que_idx;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = ext_mem_cnt = 0;
@@ -1038,29 +1066,6 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
 	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
 
-	/* Multi queue registers */
-	if (ha->mqenable) {
-		qreg_size = sizeof(struct qla2xxx_mq_chain);
-		mq = kzalloc(qreg_size, GFP_KERNEL);
-		if (!mq)
-			goto qla25xx_fw_dump_failed_0;
-		req_cnt = find_first_zero_bit(ha->req_qid_map, ha->max_queues);
-		rsp_cnt = find_first_zero_bit(ha->rsp_qid_map, ha->max_queues);
-		que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
-		mq->count = htonl(que_cnt);
-		mq->chain_size = htonl(qreg_size);
-		last_chain = &mq->type;
-		mq->type = __constant_htonl(DUMP_CHAIN_MQ);
-		for (cnt = 0; cnt < que_cnt; cnt++) {
-			reg25 = (struct device_reg_25xxmq *) ((void *)
-				ha->mqiobase + cnt * QLA_QUE_PAGE);
-			que_idx = cnt * 4;
-			mq->qregs[que_idx] = htonl(reg25->req_q_in);
-			mq->qregs[que_idx+1] = htonl(reg25->req_q_out);
-			mq->qregs[que_idx+2] = htonl(reg25->rsp_q_in);
-			mq->qregs[que_idx+3] = htonl(reg25->rsp_q_out);
-		}
-	}
 	WRT_REG_DWORD(&reg->iobase_window, 0x00);
 	RD_REG_DWORD(&reg->iobase_window);
 
@@ -1278,6 +1283,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	iter_reg = qla24xx_read_window(reg, 0x61B0, 16, iter_reg);
 	qla24xx_read_window(reg, 0x6F00, 16, iter_reg);
 
+	/* Multi queue registers */
+	nxt_chain = qla25xx_copy_mq(ha, (void *)ha->fw_dump + ha->chain_offset,
+	    &last_chain);
+
 	rval = qla24xx_soft_reset(ha);
 	if (rval != QLA_SUCCESS)
 		goto qla25xx_fw_dump_failed_0;
@@ -1291,14 +1300,8 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	nxt = qla24xx_copy_eft(ha, nxt);
 
-	/* Chain entries. */
-	if (ha->mqenable) {
-		memcpy(nxt, mq, qreg_size);
-		kfree(mq);
-		nxt += qreg_size;
-	}
-
-	qla25xx_copy_fce(ha, nxt, &last_chain);
+	/* Chain entries -- started with MQ. */
+	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
-- 
1.6.1.28.gc32f76

